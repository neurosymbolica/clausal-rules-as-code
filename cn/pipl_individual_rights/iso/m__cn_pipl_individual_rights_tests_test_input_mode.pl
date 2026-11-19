% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_individual_rights_pipl_individual_rights, [restriction_or_refusal_right/3, access_and_copy_duty/3, portability_duty/3, correction_duty/3, deletion_duty/3, explanation_duty/3, deceased_person_rights/3, request_mechanism/3, refusal_status/3, pipl_individual_rights_status/2]).
:- use_module(m__cn_pipl_individual_rights_kernel, [pipl_individual_rights_input_problems/2]).
:- use_module(m__cn_pipl_individual_rights_fixtures, [pipl_individual_rights_profile_for/2]).

baseline(Profile) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile).

test(baseline_status_bound_eligible) :-
    baseline(Profile),
    pipl_individual_rights_status(Profile, eligible).
test(restriction_bound) :-
    baseline(Profile),
    restriction_or_refusal_right(Profile, right_available, [cite(cn_pipl_art_44_p1)]).
test(access_bound) :-
    baseline(Profile),
    access_and_copy_duty(Profile, provide_in_time, [cite(cn_pipl_art_45_p1), cite(cn_pipl_art_45_p2)]).
test(portability_bound) :-
    baseline(Profile),
    portability_duty(Profile, provide_transfer_route, [cite(cn_pipl_art_45_p3)]).
test(correction_bound) :-
    baseline(Profile),
    correction_duty(Profile, correct_or_supplement_in_time, [cite(cn_pipl_art_46_p1), cite(cn_pipl_art_46_p2)]).
test(deletion_bound) :-
    baseline(Profile),
    deletion_duty(Profile, delete_personal_information, [cite(cn_pipl_art_47_p1), cite(cn_pipl_art_47_p1_i1), cite(cn_pipl_art_47_p1_i2), cite(cn_pipl_art_47_p1_i3), cite(cn_pipl_art_47_p1_i4), cite(cn_pipl_art_47_p1_i5), cite(cn_pipl_art_47_p2)]).
test(explanation_bound) :-
    baseline(Profile),
    explanation_duty(Profile, explain_processing_rules, [cite(cn_pipl_art_48_p1)]).
test(deceased_bound) :-
    baseline(Profile),
    deceased_person_rights(Profile, near_relative_may_exercise, [cite(cn_pipl_art_49_p1)]).
test(mechanism_bound) :-
    baseline(Profile),
    request_mechanism(Profile, requirement_met, [cite(cn_pipl_art_50_p1)]).
test(refusal_bound) :-
    baseline(Profile),
    refusal_status(Profile, refused_with_reasons, [cite(cn_pipl_art_50_p1), cite(cn_pipl_art_50_p2)]).
test(a_pair_element_is_not_an_attribute) :-
    explanation_duty([consent_withdrawn - true], input_problems([wrong_type(profile)]), []).
test(an_atom_profile_gives_wrong_type_profile) :-
    portability_duty(not_a_profile, input_problems([wrong_type(profile)]), []).
test(a_number_key_is_an_unknown_key) :-
    request_mechanism([attribute(7, true)], input_problems([unknown_key(7)]), []).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    access_and_copy_duty([attribute(pinned_text_in_force_on_reference_day, true), attribute(article_35_case, unsure)], input_problems([wrong_type(article_35_case)]), []).
test(a_judgement_given_a_number_is_wrong_type) :-
    request_mechanism([attribute(convenient_mechanism_established, 1)], input_problems([wrong_type(convenient_mechanism_established)]), []).
test(a_duplicate_key_is_named_once_and_not_wrong_type) :-
    deceased_person_rights([attribute(person_deceased, true), attribute(person_deceased, maybe)], input_problems([duplicate_key(person_deceased)]), []).
test(problems_come_in_contract_order_then_unknown_keys) :-
    pipl_individual_rights_input_problems([attribute(zeta, 1), attribute(refusal_reasons_given, maybe), attribute(alpha, 2), attribute(article_18_1_case, unsure), attribute(zeta, 3)], [wrong_type(article_18_1_case), wrong_type(refusal_reasons_given), unknown_key(zeta), unknown_key(alpha)]).
test(an_unread_present_key_changes_nothing) :-
    explanation_duty([attribute(pinned_text_in_force_on_reference_day, true), attribute(consent_withdrawn, true)], explain_processing_rules, [cite(cn_pipl_art_48_p1)]).
test(an_absent_key_is_not_a_problem) :-
    pipl_individual_rights_input_problems([attribute(pinned_text_in_force_on_reference_day, true)], []).

test(baseline_status_bound_ineligible_fails, fail) :-
    baseline(Profile),
    pipl_individual_rights_status(Profile, ineligible).
test(baseline_status_bound_undetermined_fails, fail) :-
    baseline(Profile),
    pipl_individual_rights_status(Profile, undetermined).
test(baseline_status_bound_referred_fails, fail) :-
    baseline(Profile),
    pipl_individual_rights_status(Profile, referred_for_legal_review).
test(baseline_status_bound_text_not_in_force_fails, fail) :-
    baseline(Profile),
    pipl_individual_rights_status(Profile, text_not_in_force).
test(baseline_status_bound_input_rejected_fails, fail) :-
    baseline(Profile),
    pipl_individual_rights_status(Profile, input_rejected).
test(deletion_bound_wrong_answer_fails, fail) :-
    baseline(Profile),
    deletion_duty(Profile, not_owed, _).
test(refusal_bound_wrong_answer_fails, fail) :-
    baseline(Profile),
    refusal_status(Profile, refused_without_reasons, _).
test(restriction_bound_wrong_citations_fail, fail) :-
    baseline(Profile),
    restriction_or_refusal_right(Profile, right_available, []).

cp_test_names([baseline_status_bound_eligible, restriction_bound, access_bound, portability_bound, correction_bound, deletion_bound, explanation_bound, deceased_bound, mechanism_bound, refusal_bound, a_pair_element_is_not_an_attribute, an_atom_profile_gives_wrong_type_profile, a_number_key_is_an_unknown_key, a_crisp_key_given_unsure_is_wrong_type, a_judgement_given_a_number_is_wrong_type, a_duplicate_key_is_named_once_and_not_wrong_type, problems_come_in_contract_order_then_unknown_keys, an_unread_present_key_changes_nothing, an_absent_key_is_not_a_problem]).
cp_test_fail_names([baseline_status_bound_ineligible_fails, baseline_status_bound_undetermined_fails, baseline_status_bound_referred_fails, baseline_status_bound_text_not_in_force_fails, baseline_status_bound_input_rejected_fails, deletion_bound_wrong_answer_fails, refusal_bound_wrong_answer_fails, restriction_bound_wrong_citations_fail]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
