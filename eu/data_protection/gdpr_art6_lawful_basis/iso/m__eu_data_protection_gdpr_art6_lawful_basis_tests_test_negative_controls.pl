% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, gdpr_art6_lawful_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_profile_for/2]).

lawful_result(Subject, Result) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    lawful_basis_status(Profile, Result, _, _).

lawful_basis_of(Subject, Basis) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    lawful_basis_status(Profile, _, Basis, _).

purpose_result(Subject, Result) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    purpose_compatibility(Profile, Result, _, _).

test(the_status_table_names_both_verdicts) :-
    gdpr_art6_lawful_basis_status_values(StatusValues),
    StatusValues == [eligible, ineligible].
test(consent_attested_true_is_eligible) :-
    lawful_result(claimed_consent_holds, eligible).
test(consent_attested_false_is_ineligible) :-
    lawful_result(claimed_consent_refused, ineligible).
test(consent_absent_is_referred) :-
    lawful_result(claimed_consent_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), _), _)).
test(contract_necessary_is_eligible) :-
    lawful_result(claimed_contract_holds, eligible).
test(contract_not_necessary_is_ineligible) :-
    lawful_result(claimed_contract_not_necessary, ineligible).
test(legal_obligation_with_law_is_eligible) :-
    lawful_result(claimed_legal_obligation_holds, eligible).
test(legal_obligation_law_refused_is_ineligible) :-
    lawful_result(claimed_legal_obligation_law_refused, ineligible).
test(legal_obligation_necessary_alone_refers_the_law) :-
    lawful_basis_status([attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true)], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), _), [], []).
test(vital_interests_necessary_is_eligible) :-
    lawful_result(claimed_vital_interests_holds, eligible).
test(vital_interests_not_necessary_is_ineligible) :-
    lawful_result(claimed_vital_interests_not_necessary, ineligible).
test(public_interest_task_with_law_is_eligible) :-
    lawful_result(claimed_public_interest_task_holds, eligible).
test(public_interest_task_without_law_is_referred) :-
    lawful_result(claimed_public_interest_task_law_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(public_interest_task_law_statement)), _)).
test(legitimate_interests_not_overridden_is_eligible) :-
    lawful_result(claimed_legitimate_interests_holds, eligible).
test(legitimate_interests_overridden_is_ineligible) :-
    lawful_result(claimed_legitimate_interests_overridden, ineligible).
test(public_authority_is_ineligible_on_legitimate_interests) :-
    lawful_result(claimed_legitimate_interests_public_authority, ineligible).
test(balance_absent_names_the_balance) :-
    lawful_result(claimed_legitimate_interests_balance_absent, indeterminate([interests_overridden])).
test(child_is_flagged_when_legitimate_interests_hold) :-
    lawful_basis_of(legitimate_interests_holds_child_flagged, [flagged(child_data_subject, _)]).
test(no_child_stated_gives_an_empty_basis) :-
    lawful_basis_of(claimed_legitimate_interests_holds, []).
test(special_category_is_flagged_on_an_eligible_answer) :-
    lawful_basis_of(consent_holds_special_category_flagged, [_, flagged(special_category, _)]).
test(empty_profile_names_the_one_step_key) :-
    lawful_result(empty_profile, indeterminate([contract_necessary])).
test(only_unsure_left_goes_to_a_lawyer) :-
    lawful_result(only_unsure_contract_left, needs_legal_review(open_textured(contract_necessary, _), _)).
test(absent_key_is_named_with_an_unsure_one) :-
    lawful_result(unsure_contract_vital_interests_absent, indeterminate([vital_interests_necessary])).
test(purpose_not_new_is_not_engaged) :-
    purpose_result(purpose_test_not_engaged, compatibility_test_not_engaged).
test(purpose_judged_compatible) :-
    purpose_result(purpose_compatible, purpose_compatible).
test(purpose_judged_not_compatible) :-
    purpose_result(purpose_not_compatible, purpose_not_compatible).
test(purpose_all_factors_taken_is_compatible) :-
    purpose_result(purpose_factors_all_taken, purpose_compatible).
test(purpose_factor_left_out_is_not_ascertained) :-
    purpose_result(purpose_factor_left_out, compatibility_not_ascertained).
test(purpose_judgement_absent_is_named) :-
    purpose_result(purpose_judgement_absent, indeterminate([compatible_purpose])).
test(single_key_has_no_problem) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, true)], []).
test(duplicated_key_gives_input_problems) :-
    lawful_result(input_duplicate_key, input_problems([duplicate_key(contract_necessary)])).

test(consent_attested_false_is_not_eligible, fail) :-
    lawful_result(claimed_consent_refused, eligible).
test(consent_absent_is_not_final, fail) :-
    lawful_result(claimed_consent_statement_absent, ineligible).
test(contract_not_necessary_is_not_eligible, fail) :-
    lawful_result(claimed_contract_not_necessary, eligible).
test(legal_obligation_law_refused_is_not_eligible, fail) :-
    lawful_result(claimed_legal_obligation_law_refused, eligible).
test(legal_obligation_necessary_alone_is_not_eligible, fail) :-
    lawful_basis_status([attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true)], eligible, _, _).
test(vital_interests_not_necessary_is_not_eligible, fail) :-
    lawful_result(claimed_vital_interests_not_necessary, eligible).
test(public_interest_task_without_law_is_not_eligible, fail) :-
    lawful_result(claimed_public_interest_task_law_absent, eligible).
test(legitimate_interests_overridden_is_not_eligible, fail) :-
    lawful_result(claimed_legitimate_interests_overridden, eligible).
test(public_authority_is_not_eligible_on_legitimate_interests, fail) :-
    lawful_result(claimed_legitimate_interests_public_authority, eligible).
test(balance_absent_is_not_eligible, fail) :-
    lawful_result(claimed_legitimate_interests_balance_absent, eligible).
test(no_child_flag_without_a_stated_child, fail) :-
    lawful_basis_of(claimed_legitimate_interests_holds, [flagged(child_data_subject, _)]).
test(special_category_does_not_change_the_result, fail) :-
    lawful_result(consent_holds_special_category_flagged, ineligible).
test(empty_profile_is_not_referred, fail) :-
    lawful_result(empty_profile, needs_legal_review(_, _)).
test(absent_key_is_named_before_the_unsure_one, fail) :-
    lawful_result(unsure_contract_vital_interests_absent, needs_legal_review(_, _)).
test(purpose_not_new_is_not_compatible_answer, fail) :-
    purpose_result(purpose_test_not_engaged, purpose_compatible).
test(purpose_judged_not_compatible_is_not_compatible_answer, fail) :-
    purpose_result(purpose_not_compatible, purpose_compatible).
test(purpose_factor_left_out_is_not_compatible_answer, fail) :-
    purpose_result(purpose_factor_left_out, purpose_compatible).
test(purpose_judgement_absent_names_no_factor, fail) :-
    purpose_result(purpose_judgement_absent, indeterminate([link_between_purposes_taken_into_account])).
test(duplicated_key_has_a_problem, fail) :-
    gdpr_art6_lawful_basis_profile_for(input_duplicate_key, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, []).
test(duplicated_key_gives_no_verdict, fail) :-
    lawful_result(input_duplicate_key, eligible).

cp_test_names([the_status_table_names_both_verdicts, consent_attested_true_is_eligible, consent_attested_false_is_ineligible, consent_absent_is_referred, contract_necessary_is_eligible, contract_not_necessary_is_ineligible, legal_obligation_with_law_is_eligible, legal_obligation_law_refused_is_ineligible, legal_obligation_necessary_alone_refers_the_law, vital_interests_necessary_is_eligible, vital_interests_not_necessary_is_ineligible, public_interest_task_with_law_is_eligible, public_interest_task_without_law_is_referred, legitimate_interests_not_overridden_is_eligible, legitimate_interests_overridden_is_ineligible, public_authority_is_ineligible_on_legitimate_interests, balance_absent_names_the_balance, child_is_flagged_when_legitimate_interests_hold, no_child_stated_gives_an_empty_basis, special_category_is_flagged_on_an_eligible_answer, empty_profile_names_the_one_step_key, only_unsure_left_goes_to_a_lawyer, absent_key_is_named_with_an_unsure_one, purpose_not_new_is_not_engaged, purpose_judged_compatible, purpose_judged_not_compatible, purpose_all_factors_taken_is_compatible, purpose_factor_left_out_is_not_ascertained, purpose_judgement_absent_is_named, single_key_has_no_problem, duplicated_key_gives_input_problems]).
cp_test_fail_names([consent_attested_false_is_not_eligible, consent_absent_is_not_final, contract_not_necessary_is_not_eligible, legal_obligation_law_refused_is_not_eligible, legal_obligation_necessary_alone_is_not_eligible, vital_interests_not_necessary_is_not_eligible, public_interest_task_without_law_is_not_eligible, legitimate_interests_overridden_is_not_eligible, public_authority_is_not_eligible_on_legitimate_interests, balance_absent_is_not_eligible, no_child_flag_without_a_stated_child, special_category_does_not_change_the_result, empty_profile_is_not_referred, absent_key_is_named_before_the_unsure_one, purpose_not_new_is_not_compatible_answer, purpose_judged_not_compatible_is_not_compatible_answer, purpose_factor_left_out_is_not_compatible_answer, purpose_judgement_absent_names_no_factor, duplicated_key_has_a_problem, duplicated_key_gives_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
