% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_citations, [citation/2, implements/1]).

test(the_definition_answer_carries_status_ground_and_citations) :-
    Answer = definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)]),
    Answer = definition_answer(Status, Ground, Citations),
    Status == met,
    Ground == none,
    Citations == [cite(eu_reg_2016_679_art_4_1)].
test(the_consent_ground_compound_destructures) :-
    Answer = definition_answer(not_met, unmet_elements([indication_freely_given, indication_informed]), [cite(eu_reg_2016_679_art_4_11)]),
    Answer = definition_answer(not_met, unmet_elements(Keys), [cite(CitationKey)]),
    Keys == [indication_freely_given, indication_informed],
    CitationKey == eu_reg_2016_679_art_4_11.
test(the_indeterminate_status_is_a_compound) :-
    Answer = definition_answer(indeterminate([natural_person_identified]), none, [cite(eu_reg_2016_679_art_4_1)]),
    Answer = definition_answer(indeterminate(MissingKeys), none, _),
    MissingKeys == [natural_person_identified].
test(the_open_textured_referral_destructures) :-
    Status = needs_legal_review(open_textured(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([information_relates_to_natural_person - true, natural_person_identifiable - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == natural_person_identifiable,
    CitationKey == eu_reg_2016_679_art_4_1,
    Pairs == [information_relates_to_natural_person - true, natural_person_identifiable - unsure].
test(the_cross_reference_referral_destructures) :-
    Status = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)), [resolution(cite(eu_dir_2015_1535_art_1_1_b), not_attempted), inputs_relied_on([])]),
    Status = needs_legal_review(cross_reference_unresolved(cite(CitationKey), cite(TargetKey)), [resolution(cite(TargetKey), Resolution), inputs_relied_on(Pairs)]),
    CitationKey == eu_reg_2016_679_art_4_25,
    TargetKey == eu_dir_2015_1535_art_1_1_b,
    Resolution == not_attempted,
    Pairs == [].
test(the_outside_fact_item_destructures) :-
    Item = outside_fact(service_is_information_society_service, attested(true, attestation(host, moment, reason, none))),
    Item = outside_fact(Key, attested(Value, attestation(_, _, _, Evidence))),
    Key == service_is_information_society_service,
    Value == true,
    Evidence == none.
test(the_status_atoms_are_distinct) :-
    dif(met, not_met).
test(the_international_organisation_grounds_are_distinct) :-
    dif(governed_by_public_international_law, set_up_by_agreement_between_countries),
    dif(governed_by_public_international_law, none),
    dif(set_up_by_agreement_between_countries, none).
test(the_problem_constructors_are_distinct) :-
    dif(unknown_key(processing_automated), wrong_type(processing_automated)),
    dif(wrong_type(processing_automated), duplicate_key(processing_automated)),
    dif(unknown_key(processing_automated), duplicate_key(processing_automated)).
test(the_personal_data_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_4_1, _Record).
test(the_consent_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_4_11, _Record).
test(an_outside_fact_target_is_recorded) :-
    citation(eu_dir_2015_1535_art_1_1_b, _Record).
test(the_provenance_marker_resolves_a_real_key) :-
    implements(eu_reg_2016_679_art_4_26).
test(an_empty_profile_has_no_input_problem) :-
    gdpr_common_definitions_data_and_processing_input_problems([], Problems),
    Problems == [].
test(an_unknown_key_is_an_input_problem) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(extra_key, true)], Problems),
    Problems == [unknown_key(extra_key)].

test(met_is_not_not_met, fail) :-
    met = not_met.
test(an_unrecorded_key_does_not_resolve, fail) :-
    citation(eu_reg_2016_679_art_4_7, _Record).
test(a_well_formed_profile_is_not_reported_as_a_problem, fail) :-
    gdpr_common_definitions_data_and_processing_input_problems([attribute(natural_person_identified, true)], [wrong_type(natural_person_identified)]).

cp_test_names([the_definition_answer_carries_status_ground_and_citations, the_consent_ground_compound_destructures, the_indeterminate_status_is_a_compound, the_open_textured_referral_destructures, the_cross_reference_referral_destructures, the_outside_fact_item_destructures, the_status_atoms_are_distinct, the_international_organisation_grounds_are_distinct, the_problem_constructors_are_distinct, the_personal_data_citation_is_recorded, the_consent_citation_is_recorded, an_outside_fact_target_is_recorded, the_provenance_marker_resolves_a_real_key, an_empty_profile_has_no_input_problem, an_unknown_key_is_an_input_problem]).
cp_test_fail_names([met_is_not_not_met, an_unrecorded_key_does_not_resolve, a_well_formed_profile_is_not_reported_as_a_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
