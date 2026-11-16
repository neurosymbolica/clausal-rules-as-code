% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_recognised_legitimate_interests_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_recognised_legitimate_interests_uk_recognised_legitimate_interests, [decide_uk_recognised_legitimate_interests/2, uk_recognised_legitimate_interests_status/2, recognised_legitimate_interest/3, uk_legitimate_interests/3, uk_legitimate_interest_basis/3, eu_legitimate_interests/3, compare_uk_eu_legitimate_interest_basis/5, uk_right_to_object/3]).
:- use_module(m__uk_uk_recognised_legitimate_interests_kernel, [uk_recognised_legitimate_interests_input_problems/2]).
:- use_module(m__uk_uk_recognised_legitimate_interests_fixtures, [uk_recognised_legitimate_interests_profile_for/2]).

expect_answer(Query, Subject, Result, Expected) :-
    uk_recognised_legitimate_interests_profile_for(Subject, Profile),
    findall(Answer - AnswerCitations, call(Query, Profile, Answer, AnswerCitations), Answers),
    Answers = [Result - Citations],
    sort(Citations, CitationSet),
    sort(Expected, ExpectedSet),
    CitationSet == ExpectedSet.

expect_comparison(Subject, UkResult, EuResult, Difference, Expected) :-
    uk_recognised_legitimate_interests_profile_for(Subject, Profile),
    findall(answer(Uk, Eu, Found, Changed), compare_uk_eu_legitimate_interest_basis(Profile, Uk, Eu, Found, Changed), Answers),
    Answers = [answer(UkResult, EuResult, Difference, ChangedBy)],
    sort(ChangedBy, ChangedSet),
    sort(Expected, ExpectedSet),
    ChangedSet == ExpectedSet.

test(the_baseline_profile_yields_exactly_one_status) :-
    uk_recognised_legitimate_interests_profile_for(security_condition_met, Profile),
    findall(Status, uk_recognised_legitimate_interests_status(Profile, Status), Statuses),
    Statuses == [recognised_legitimate_interest_applies].
test(the_verdict_carries_a_citation) :-
    uk_recognised_legitimate_interests_profile_for(security_condition_met, Profile),
    decide_uk_recognised_legitimate_interests(Profile, uk_recognised_legitimate_interests_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(recognised_public_authority_bar) :-
    expect_answer(recognised_legitimate_interest, public_authority_bar, recognised_legitimate_interest_does_not_apply, [cite(uk_gdpr_art_6_1)]).
test(recognised_security_condition) :-
    expect_answer(recognised_legitimate_interest, security_condition_met, recognised_legitimate_interest_applies, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_2)]).
test(recognised_disclosure_condition) :-
    expect_answer(recognised_legitimate_interest, disclosure_condition_met, recognised_legitimate_interest_applies, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_1)]).
test(recognised_emergency_condition) :-
    expect_answer(recognised_legitimate_interest, emergency_condition_met, recognised_legitimate_interest_applies, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_3), cite(uk_gdpr_annex_1_para_4)]).
test(recognised_crime_condition) :-
    expect_answer(recognised_legitimate_interest, crime_condition_met, recognised_legitimate_interest_applies, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_5)]).
test(recognised_safeguarding_child) :-
    expect_answer(recognised_legitimate_interest, safeguarding_child, recognised_legitimate_interest_applies, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_6), cite(uk_gdpr_annex_1_para_7), cite(uk_gdpr_annex_1_para_8)]).
test(recognised_safeguarding_adult_at_risk) :-
    expect_answer(recognised_legitimate_interest, safeguarding_adult_at_risk, recognised_legitimate_interest_applies, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_6), cite(uk_gdpr_annex_1_para_7), cite(uk_gdpr_annex_1_para_8)]).
test(recognised_all_conditions_fail) :-
    expect_answer(recognised_legitimate_interest, all_conditions_fail, recognised_legitimate_interest_does_not_apply, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5)]).
test(recognised_disclosure_request_silent) :-
    expect_answer(recognised_legitimate_interest, disclosure_request_silent, recognised_legitimate_interest_does_not_apply, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5)]).
test(recognised_safeguarding_adult_not_at_risk) :-
    expect_answer(recognised_legitimate_interest, safeguarding_adult_not_at_risk, recognised_legitimate_interest_does_not_apply, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5)]).
test(recognised_authority_absent_names_the_bar) :-
    expect_answer(recognised_legitimate_interest, authority_absent_condition_met, indeterminate([processing_by_a_public_authority_in_the_performance_of_its_tasks]), []).
test(recognised_emergency_response_missing) :-
    expect_answer(recognised_legitimate_interest, emergency_response_missing, indeterminate([processing_necessary_for_responding_to_the_emergency]), []).
test(recognised_first_absent_condition_key) :-
    expect_answer(recognised_legitimate_interest, interests_apply, indeterminate([processing_necessary_for_a_disclosure_in_response_to_a_request]), []).
test(recognised_authority_unsure_referral) :-
    expect_answer(recognised_legitimate_interest, authority_unsure_condition_met, needs_legal_review(open_textured(processing_by_a_public_authority_in_the_performance_of_its_tasks, cite(uk_gdpr_art_6_1)), [inputs_relied_on([processing_by_a_public_authority_in_the_performance_of_its_tasks - unsure, processing_necessary_for_national_security_public_security_or_defence - true])]), []).
test(recognised_at_risk_unsure_referral) :-
    expect_answer(recognised_legitimate_interest, safeguarding_adult_unsure_risk, needs_legal_review(open_textured(controller_has_reasonable_cause_to_suspect_the_individual_is_at_risk, cite(uk_gdpr_annex_1_para_8)), [inputs_relied_on([processing_by_a_public_authority_in_the_performance_of_its_tasks - false, processing_necessary_for_a_disclosure_in_response_to_a_request - false, processing_necessary_for_national_security_public_security_or_defence - false, event_is_an_emergency_within_part_2_of_the_civil_contingencies_act_2004 - false, processing_necessary_for_detecting_investigating_or_preventing_crime_or_apprehending_or_prosecuting_offenders - false, processing_necessary_for_safeguarding_an_individual - true, individual_aged_under_18 - false, controller_has_reasonable_cause_to_suspect_the_individual_is_at_risk - unsure])]), []).
test(uk_interests_apply) :-
    expect_answer(uk_legitimate_interests, interests_apply, legitimate_interests_applies, [cite(uk_gdpr_art_6_1_f)]).
test(uk_interests_overridden) :-
    expect_answer(uk_legitimate_interests, interests_overridden, legitimate_interests_does_not_apply, [cite(uk_gdpr_art_6_1_f)]).
test(uk_interests_public_authority_bar) :-
    expect_answer(uk_legitimate_interests, public_authority_bar, legitimate_interests_does_not_apply, [cite(uk_gdpr_art_6_1)]).
test(uk_interests_first_missing_key) :-
    expect_answer(uk_legitimate_interests, security_condition_met, indeterminate([legitimate_interest_pursued_by_the_controller_or_a_third_party]), []).
test(eu_interests_apply) :-
    expect_answer(eu_legitimate_interests, interests_apply, legitimate_interests_applies, [cite(eu_reg_2016_679_art_6_1_f)]).
test(eu_interests_overridden) :-
    expect_answer(eu_legitimate_interests, interests_overridden, legitimate_interests_does_not_apply, [cite(eu_reg_2016_679_art_6_1_f)]).
test(eu_interests_public_authority_bar) :-
    expect_answer(eu_legitimate_interests, public_authority_bar, legitimate_interests_does_not_apply, [cite(eu_reg_2016_679_art_6_1)]).
test(basis_available_through_ea) :-
    expect_answer(uk_legitimate_interest_basis, security_condition_met, legitimate_interest_basis_available, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_2)]).
test(basis_available_through_f) :-
    expect_answer(uk_legitimate_interest_basis, interests_apply, legitimate_interest_basis_available, [cite(uk_gdpr_art_6_1_f)]).
test(basis_not_available_on_both_sides) :-
    expect_answer(uk_legitimate_interest_basis, uk_same_as_eu, legitimate_interest_basis_not_available, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_art_6_1_f)]).
test(basis_not_available_for_a_public_authority) :-
    expect_answer(uk_legitimate_interest_basis, public_authority_bar, legitimate_interest_basis_not_available, [cite(uk_gdpr_art_6_1)]).
test(basis_turns_on_the_bar_alone_when_absent) :-
    expect_answer(uk_legitimate_interest_basis, authority_absent_condition_met, indeterminate([processing_by_a_public_authority_in_the_performance_of_its_tasks]), []).
test(basis_copies_the_recognised_bar_referral) :-
    expect_answer(uk_legitimate_interest_basis, authority_unsure_condition_met, needs_legal_review(open_textured(processing_by_a_public_authority_in_the_performance_of_its_tasks, cite(uk_gdpr_art_6_1)), [inputs_relied_on([processing_by_a_public_authority_in_the_performance_of_its_tasks - unsure, processing_necessary_for_national_security_public_security_or_defence - true])]), []).
test(basis_names_the_recognised_missing_key_first) :-
    expect_answer(uk_legitimate_interest_basis, interests_overridden, indeterminate([processing_necessary_for_a_disclosure_in_response_to_a_request]), []).
test(comparison_differs) :-
    expect_comparison(uk_differs_from_eu, legitimate_interest_basis_available, legitimate_interest_basis_not_available, differs, [cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_5)]).
test(comparison_same_not_available) :-
    expect_comparison(uk_same_as_eu, legitimate_interest_basis_not_available, legitimate_interest_basis_not_available, same, []).
test(comparison_same_available) :-
    expect_comparison(interests_apply, legitimate_interest_basis_available, legitimate_interest_basis_available, same, []).
test(comparison_not_comparable_when_eu_open) :-
    expect_comparison(security_condition_met, legitimate_interest_basis_available, indeterminate([legitimate_interest_pursued_by_the_controller_or_a_third_party]), not_comparable, []).
test(comparison_with_input_problems) :-
    expect_comparison(crisp_key_wrong_type, input_problems([wrong_type(individual_aged_under_18)]), input_problems([wrong_type(individual_aged_under_18)]), not_comparable, []).
test(objection_not_engaged) :-
    expect_answer(uk_right_to_object, objection_not_engaged, objection_right_not_engaged, [cite(uk_gdpr_art_21_1)]).
test(objection_must_stop) :-
    expect_answer(uk_right_to_object, objection_must_stop, controller_must_no_longer_process, [cite(uk_gdpr_art_21_1)]).
test(objection_legal_claims) :-
    expect_answer(uk_right_to_object, objection_legal_claims, controller_may_continue_processing, [cite(uk_gdpr_art_21_1)]).
test(objection_exceptions_missing) :-
    expect_answer(uk_right_to_object, objection_exceptions_missing, indeterminate([controller_demonstrates_compelling_legitimate_grounds_that_override]), []).
test(objection_unsure_referral) :-
    expect_answer(uk_right_to_object, objection_unsure, needs_legal_review(open_textured(objection_on_grounds_relating_to_particular_situation, cite(uk_gdpr_art_21_1)), [inputs_relied_on([basis_relied_on - recognised_legitimate_interest, objection_on_grounds_relating_to_particular_situation - unsure, controller_demonstrates_compelling_legitimate_grounds_that_override - false, processing_for_establishment_exercise_or_defence_of_legal_claims - false])]), []).
test(objection_empty_profile_names_the_basis) :-
    findall(Result - Citations, uk_right_to_object([], Result, Citations), Answers),
    Answers == [indeterminate([basis_relied_on]) - []].
test(duplicate_and_unknown_keys_listed_in_order) :-
    uk_recognised_legitimate_interests_profile_for(duplicate_and_unknown_keys, Profile),
    findall(Problems, uk_recognised_legitimate_interests_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(individual_aged_under_18), unknown_key(foo)]].
test(not_an_attribute_list_listed_alone) :-
    uk_recognised_legitimate_interests_profile_for(not_an_attribute_list, Profile),
    findall(Problems, uk_recognised_legitimate_interests_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, recognised_public_authority_bar, recognised_security_condition, recognised_disclosure_condition, recognised_emergency_condition, recognised_crime_condition, recognised_safeguarding_child, recognised_safeguarding_adult_at_risk, recognised_all_conditions_fail, recognised_disclosure_request_silent, recognised_safeguarding_adult_not_at_risk, recognised_authority_absent_names_the_bar, recognised_emergency_response_missing, recognised_first_absent_condition_key, recognised_authority_unsure_referral, recognised_at_risk_unsure_referral, uk_interests_apply, uk_interests_overridden, uk_interests_public_authority_bar, uk_interests_first_missing_key, eu_interests_apply, eu_interests_overridden, eu_interests_public_authority_bar, basis_available_through_ea, basis_available_through_f, basis_not_available_on_both_sides, basis_not_available_for_a_public_authority, basis_turns_on_the_bar_alone_when_absent, basis_copies_the_recognised_bar_referral, basis_names_the_recognised_missing_key_first, comparison_differs, comparison_same_not_available, comparison_same_available, comparison_not_comparable_when_eu_open, comparison_with_input_problems, objection_not_engaged, objection_must_stop, objection_legal_claims, objection_exceptions_missing, objection_unsure_referral, objection_empty_profile_names_the_basis, duplicate_and_unknown_keys_listed_in_order, not_an_attribute_list_listed_alone]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
