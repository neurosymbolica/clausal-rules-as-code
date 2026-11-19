% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_kernel, [dpdp_transfer_input_problems/2]).
:- use_module(m__ind_dpdp_transfer_citations, [citation/2, implements/1]).

test(the_final_result_atoms_are_distinct) :-
    Atoms = [restricted_see_notification, requirements_apply_see_order, not_restricted, not_in_force],
    sort(Atoms, Sorted),
    length(Sorted, 4).
test(the_restricted_result_differs_from_not_restricted) :-
    dif(restricted_see_notification, not_restricted).
test(the_requirements_result_differs_from_not_in_force) :-
    dif(requirements_apply_see_order, not_in_force).
test(the_restriction_atoms_are_distinct) :-
    dif(notified_destination, foreign_state_requirements).
test(the_verdict_term_carries_result_and_citations) :-
    Verdict = dpdp_transfer_verdict(not_restricted, [cite(in_dpdp_act_2023_s_16_1), cite(in_dpdp_act_2023_s_16_2)]),
    Verdict = dpdp_transfer_verdict(Result, Citations),
    Result == not_restricted,
    Citations == [cite(in_dpdp_act_2023_s_16_1), cite(in_dpdp_act_2023_s_16_2)].
test(the_indeterminate_status_names_one_key) :-
    Verdict = dpdp_transfer_verdict(indeterminate([section_16_in_force_on_reference_date]), []),
    Verdict = dpdp_transfer_verdict(indeterminate([MissingKey]), Citations),
    MissingKey == section_16_in_force_on_reference_date,
    Citations == [].
test(the_referral_status_destructures) :-
    Result = needs_legal_review(open_textured(recipient_is_foreign_state_or_its_entity, cite(in_dpdp_rules_2025_r_15)), [inputs_relied_on([recipient_is_foreign_state_or_its_entity - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == recipient_is_foreign_state_or_its_entity,
    CitationKey == in_dpdp_rules_2025_r_15,
    Pairs == [recipient_is_foreign_state_or_its_entity - unsure].
test(the_request_term_carries_both_inputs) :-
    Request = restriction_request(notified_destination, []),
    Request = restriction_request(Restriction, Profile),
    Restriction == notified_destination,
    Profile == [].
test(the_section_16_1_citation_is_recorded) :-
    citation(in_dpdp_act_2023_s_16_1, _Record).
test(the_section_16_2_citation_is_recorded) :-
    citation(in_dpdp_act_2023_s_16_2, _Record).
test(the_rule_15_citation_is_recorded) :-
    citation(in_dpdp_rules_2025_r_15, _Record).
test(the_rule_1_4_citation_is_recorded) :-
    citation(in_dpdp_rules_2025_r_1_4, _Record).
test(the_citation_record_has_label_ref_verbatim) :-
    citation(in_dpdp_rules_2025_r_1_4, [label - _Label, ref - _Reference, verbatim - Verbatim]),
    Verbatim == 'Rules 3, 5 to 16, 22 and 23 shall come into force eighteen months after the date of publication of this Gazette.'.
test(exactly_four_citations_are_recorded) :-
    findall(Key, citation(Key, _), Keys),
    sort(Keys, Sorted),
    Sorted == [in_dpdp_act_2023_s_16_1, in_dpdp_act_2023_s_16_2, in_dpdp_rules_2025_r_15, in_dpdp_rules_2025_r_1_4].
test(the_marker_holds_for_a_recorded_key) :-
    implements(in_dpdp_rules_2025_r_15).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dpdp_transfer_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, unsure), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, false), attribute(foreign_state_requirements_specified, false)], Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, dpdp_transfer_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, dpdp_transfer_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(section_16_in_force_on_reference_date, unsure)], Problems), Answers),
    Answers == [[wrong_type(section_16_in_force_on_reference_date)]].
test(a_date_that_is_not_a_real_day_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(2025, 2, 29))], Problems), Answers),
    Answers == [[wrong_type(reference_date)]].
test(a_leap_day_is_a_real_day) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(2028, 2, 29))], Problems), Answers),
    Answers == [[]].
test(a_repeated_key_is_duplicate_key) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(foreign_state_requirements_specified, true), attribute(foreign_state_requirements_specified, maybe)], Problems), Answers),
    Answers == [[duplicate_key(foreign_state_requirements_specified)]].
test(a_key_outside_the_contract_is_unknown_key_after_contract_problems) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(destination_country, usa), attribute(recipient_is_foreign_state_or_its_entity, yes)], Problems), Answers),
    Answers == [[wrong_type(recipient_is_foreign_state_or_its_entity), unknown_key(destination_country)]].

test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(in_dpdp_rules_2025_r_16).

cp_test_names([the_final_result_atoms_are_distinct, the_restricted_result_differs_from_not_restricted, the_requirements_result_differs_from_not_in_force, the_restriction_atoms_are_distinct, the_verdict_term_carries_result_and_citations, the_indeterminate_status_names_one_key, the_referral_status_destructures, the_request_term_carries_both_inputs, the_section_16_1_citation_is_recorded, the_section_16_2_citation_is_recorded, the_rule_15_citation_is_recorded, the_rule_1_4_citation_is_recorded, the_citation_record_has_label_ref_verbatim, exactly_four_citations_are_recorded, the_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, a_crisp_key_given_unsure_is_wrong_type, a_date_that_is_not_a_real_day_is_wrong_type, a_leap_day_is_a_real_day, a_repeated_key_is_duplicate_key, a_key_outside_the_contract_is_unknown_key_after_contract_problems]).
cp_test_fail_names([the_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
