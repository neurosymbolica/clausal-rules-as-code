% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_corrective_powers_named_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_kernel, [gdpr_corrective_powers_named_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_citations, [citation/2, implements/1]).

test(the_list_answer_carries_powers_and_authority_discretion) :-
    Result = powers_named([power(warning, [controller, processor]), power(administrative_fine, [])], authority_discretion),
    Result = powers_named(Powers, Discretion),
    Powers == [power(warning, [controller, processor]), power(administrative_fine, [])],
    Discretion == authority_discretion.
test(the_empty_list_answer_still_carries_authority_discretion) :-
    Result = powers_named([], authority_discretion),
    Result = powers_named(Powers, Discretion),
    Powers == [],
    Discretion == authority_discretion.
test(the_named_answer_carries_addressees_and_authority_discretion) :-
    Result = named([certification_body], authority_discretion),
    Result = named(Addressees, Discretion),
    Addressees == [certification_body],
    Discretion == authority_discretion.
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(processing_has_infringed, cite(eu_reg_2016_679_art_58_2_b)), [inputs_relied_on([processing_has_infringed - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == processing_has_infringed,
    CitationKey == eu_reg_2016_679_art_58_2_b,
    Pairs == [processing_has_infringed - unsure].
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([certification_issued_or_applied_for]),
    Result = indeterminate([Key]),
    Key == certification_issued_or_applied_for.
test(the_input_problems_status_destructures) :-
    Result = input_problems([wrong_type(profile), wrong_type(measure)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(profile), wrong_type(measure)].
test(the_result_atoms_are_distinct) :-
    dif(not_named, authority_discretion).
test(the_named_answer_is_not_the_bare_atom) :-
    dif(named([controller], authority_discretion), not_named).
test(the_addressee_atoms_are_distinct) :-
    dif(controller, processor),
    dif(processor, certification_body),
    dif(controller, certification_body).
test(the_measure_atoms_are_ten_and_distinct) :-
    Measures = [warning, reprimand, order_to_comply_with_data_subject_requests, order_to_bring_processing_into_compliance, order_to_communicate_personal_data_breach, limitation_or_ban_on_processing, order_of_rectification_erasure_or_restriction, withdrawal_or_refusal_of_certification, administrative_fine, suspension_of_data_flows],
    sort(Measures, Sorted),
    length(Sorted, Count),
    Count == 10.
test(the_chapeau_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_58_2, _Record).
test(the_point_citations_are_recorded) :-
    citation(eu_reg_2016_679_art_58_2_a, _RecordA),
    citation(eu_reg_2016_679_art_58_2_e, _RecordE),
    citation(eu_reg_2016_679_art_58_2_j, _RecordJ).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_58_2_h).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems([], Problems), Answers),
    Answers == [[]].
test(an_unsure_judgement_is_well_formed) :-
    gdpr_corrective_powers_named_input_problems([attribute(processing_has_infringed, unsure), attribute(personal_data_breach_occurred, true)], Problems),
    Problems == [].
test(an_unsure_crisp_key_is_wrong_type) :-
    gdpr_corrective_powers_named_input_problems([attribute(personal_data_breach_occurred, unsure)], Problems),
    Problems == [wrong_type(personal_data_breach_occurred)].
test(an_attested_value_is_wrong_type) :-
    gdpr_corrective_powers_named_input_problems([attribute(processing_has_infringed, attested(finding))], Problems),
    Problems == [wrong_type(processing_has_infringed)].
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_corrective_powers_named_input_problems([attribute(fine_amount, true)], Problems),
    Problems == [unknown_key(fine_amount)].
test(a_repeated_contract_key_is_a_duplicate) :-
    gdpr_corrective_powers_named_input_problems([attribute(personal_data_breach_occurred, true), attribute(personal_data_breach_occurred, true)], Problems),
    Problems == [duplicate_key(personal_data_breach_occurred)].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].

test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_58_2_z).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_list_answer_carries_powers_and_authority_discretion, the_empty_list_answer_still_carries_authority_discretion, the_named_answer_carries_addressees_and_authority_discretion, the_referral_term_destructures, the_indeterminate_status_names_one_key, the_input_problems_status_destructures, the_result_atoms_are_distinct, the_named_answer_is_not_the_bare_atom, the_addressee_atoms_are_distinct, the_measure_atoms_are_ten_and_distinct, the_chapeau_citation_is_recorded, the_point_citations_are_recorded, the_provenance_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, an_unsure_judgement_is_well_formed, an_unsure_crisp_key_is_wrong_type, an_attested_value_is_wrong_type, a_key_outside_the_contract_is_unknown, a_repeated_contract_key_is_a_duplicate, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile]).
cp_test_fail_names([the_provenance_marker_fails_for_an_unrecorded_key, the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
