% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_special_categories_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_special_categories_kernel, [gdpr_special_categories_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_four_fields) :-
    Verdict = special_category_verdict(eligible, [art9_2_a], [explicit_consent, specified_purposes, consent_definition, no_legal_bar], [cite(eu_reg_2016_679_art_9_1), cite(eu_reg_2016_679_art_9_2_a)]),
    Verdict = special_category_verdict(Status, Bases, Conditions, Citations),
    Status == eligible,
    Bases == [art9_2_a],
    Conditions == [explicit_consent, specified_purposes, consent_definition, no_legal_bar],
    Citations == [cite(eu_reg_2016_679_art_9_1), cite(eu_reg_2016_679_art_9_2_a)].
test(the_indeterminate_status_carries_its_missing_keys) :-
    Status = indeterminate([genetic_data_present]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [genetic_data_present].
test(the_referral_status_carries_reason_and_context) :-
    Status = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_9_2_g), cite(eu_reg_2016_679_art_9_2_g)), [resolution(cite(eu_reg_2016_679_art_9_2_g), not_attempted), inputs_relied_on([exception_claimed - art9_2_g])]),
    Status = needs_legal_review(Reason, Context),
    Reason = cross_reference_unresolved(cite(CitationKey), cite(TargetKey)),
    CitationKey == eu_reg_2016_679_art_9_2_g,
    TargetKey == eu_reg_2016_679_art_9_2_g,
    Context = [resolution(_, ResolutionStatus), inputs_relied_on(Pairs)],
    ResolutionStatus == not_attempted,
    Pairs == [exception_claimed - art9_2_g].
test(the_open_textured_reason_destructures) :-
    Reason = open_textured(concerns_health, cite(eu_reg_2016_679_art_4_15)),
    Reason = open_textured(Input, cite(CitationKey)),
    Input == concerns_health,
    CitationKey == eu_reg_2016_679_art_4_15.
test(the_outside_fact_item_destructures) :-
    Item = outside_fact(member_state_further_conditions_exist, attested(true, attestation(host, moment, reason, none))),
    Item = outside_fact(Key, attested(Value, attestation(_, _, _, Evidence))),
    Key == member_state_further_conditions_exist,
    Value == true,
    Evidence == none.
test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_resolution_statuses_are_distinct) :-
    dif(not_attempted, attested_not_modelled).
test(the_referral_reasons_are_distinct) :-
    dif(open_textured, cross_reference_unresolved).
test(the_prohibition_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_9_1, _Record).
test(the_criminal_offence_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_10, _Record).
test(the_health_definition_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_4_15, _Record).
test(a_citation_record_has_label_reference_and_verbatim) :-
    citation(eu_reg_2016_679_art_9_4, [label - _, ref - _, verbatim - _]).
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_9_2_h).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_special_categories_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(exception_claimed, art9_2_a), attribute(genetic_data_present, true), attribute(concerns_health, unsure), attribute(prohibition_lifting_barred_by_law, attested(false, attestation(host, moment, reason, none)))],
    findall(Problems, gdpr_special_categories_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    findall(Problems, gdpr_special_categories_input_problems([attribute(genetic_data_present, unsure)], Problems), Answers),
    Answers == [[wrong_type(genetic_data_present)]].
test(an_exception_outside_the_ten_is_wrong_type) :-
    gdpr_special_categories_input_problems([attribute(exception_claimed, art6_1_a)], [wrong_type(exception_claimed)]).
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_special_categories_input_problems([attribute(criminal_data_authorising_law_exists, true)], [wrong_type(criminal_data_authorising_law_exists)]).
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_special_categories_input_problems([attribute(mystery_key, true), attribute(genetic_data_present, false), attribute(mystery_key, false)], [unknown_key(mystery_key)]).
test(a_repeated_key_is_a_duplicate_and_never_wrong_type) :-
    gdpr_special_categories_input_problems([attribute(genetic_data_present, true), attribute(genetic_data_present, maybe)], [duplicate_key(genetic_data_present)]).
test(problems_follow_contract_order_then_unknown_keys) :-
    Profile = [attribute(stray_key, true), attribute(vital_interest_at_stake, maybe), attribute(appropriate_safeguards, maybe)],
    gdpr_special_categories_input_problems(Profile, [wrong_type(appropriate_safeguards), wrong_type(vital_interest_at_stake), unknown_key(stray_key)]).
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    findall(Problems, gdpr_special_categories_input_problems(not_a_list, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_of_non_attributes_is_wrong_type_profile) :-
    gdpr_special_categories_input_problems([colour], [wrong_type(profile)]).

test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_9_5).
test(a_crisp_key_given_unsure_has_a_problem, fail) :-
    gdpr_special_categories_input_problems([attribute(genetic_data_present, unsure)], []).

cp_test_names([the_verdict_term_carries_four_fields, the_indeterminate_status_carries_its_missing_keys, the_referral_status_carries_reason_and_context, the_open_textured_reason_destructures, the_outside_fact_item_destructures, the_verdict_atoms_are_distinct, the_resolution_statuses_are_distinct, the_referral_reasons_are_distinct, the_prohibition_citation_is_recorded, the_criminal_offence_citation_is_recorded, the_health_definition_citation_is_recorded, a_citation_record_has_label_reference_and_verbatim, the_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, an_exception_outside_the_ten_is_wrong_type, a_bare_outside_fact_is_wrong_type, a_key_outside_the_contract_is_unknown, a_repeated_key_is_a_duplicate_and_never_wrong_type, problems_follow_contract_order_then_unknown_keys, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, a_list_of_non_attributes_is_wrong_type_profile]).
cp_test_fail_names([the_marker_fails_for_an_unrecorded_key, a_crisp_key_given_unsure_has_a_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
