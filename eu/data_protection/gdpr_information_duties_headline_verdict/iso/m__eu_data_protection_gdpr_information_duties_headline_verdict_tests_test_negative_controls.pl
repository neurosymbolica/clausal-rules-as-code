% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_profile_for/2]).

verdict_of(Subject, Verdict, Citations) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    information_duty_verdict(Profile, Verdict, Citations).

test(art13_on_obtaining_day_is_eligible) :-
    verdict_of(article_13_complete_on_obtaining_day, eligible, [cite(eu_reg_2016_679_art_13_1)]).
test(art13_one_day_after_is_ineligible) :-
    verdict_of(article_13_complete_one_day_after_obtaining, ineligible, [cite(eu_reg_2016_679_art_13_1)]).
test(art13_requirement_item_missing_is_ineligible) :-
    verdict_of(article_13_requirement_item_missing, ineligible, [cite(eu_reg_2016_679_art_13_2_e)]).
test(art13_adm_unsure_refers) :-
    verdict_of(article_13_automated_decision_unsure, needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])]), []).
test(art13_adm_true_item_missing_is_ineligible) :-
    verdict_of(article_13_automated_decision_item_missing, ineligible, [cite(eu_reg_2016_679_art_13_2_f)]).
test(art13_further_processing_day_before_is_eligible) :-
    verdict_of(article_13_further_processing_informed_day_before, eligible, [cite(eu_reg_2016_679_art_13_1), cite(eu_reg_2016_679_art_13_3)]).
test(art13_further_processing_same_day_is_ineligible) :-
    verdict_of(article_13_further_processing_informed_same_day, ineligible, [cite(eu_reg_2016_679_art_13_3)]).
test(art14_on_shifted_last_day_is_eligible) :-
    verdict_of(article_14_on_last_day_of_month, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_day_after_last_day_is_ineligible) :-
    verdict_of(article_14_day_after_last_day_of_month, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_capped_month_end_is_eligible) :-
    verdict_of(article_14_month_end_shifted_past_weekend, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_day_after_capped_month_end_is_ineligible) :-
    verdict_of(article_14_day_after_shifted_month_end, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_holiday_shifted_day_is_eligible) :-
    verdict_of(article_14_holiday_shifted_last_day, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_day_after_holiday_shift_is_ineligible) :-
    verdict_of(article_14_day_after_holiday_shifted_last_day, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_on_first_communication_is_eligible) :-
    verdict_of(article_14_first_communication_on_the_day, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_day_after_first_communication_is_ineligible) :-
    verdict_of(article_14_first_communication_day_after, ineligible, [cite(eu_reg_2016_679_art_14_3_b)]).
test(art14_law_attested_true_is_eligible) :-
    verdict_of(article_14_source_missing_law_attested_true, eligible, [cite(eu_reg_2016_679_art_14_5_c)]).
test(art14_law_attested_false_is_ineligible) :-
    verdict_of(article_14_source_missing_law_attested_false, ineligible, [cite(eu_reg_2016_679_art_14_2_f)]).
test(art14_effort_with_measures_is_eligible) :-
    verdict_of(article_14_effort_with_measures, eligible, [cite(eu_reg_2016_679_art_14_5_b)]).
test(art14_effort_unsure_refers) :-
    verdict_of(article_14_effort_unsure_with_measures, needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])]), []).
test(art14_effort_without_measures_is_none) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, false)], none).
test(route_absent_names_the_route_key) :-
    verdict_of(route_not_supplied, indeterminate(Keys), []),
    Keys = [personal_data_collected_from_data_subject|_].
test(input_problems_are_refused) :-
    verdict_of(not_a_profile, input_problems([wrong_type(profile)]), []).

test(art13_one_day_after_is_not_eligible, fail) :-
    verdict_of(article_13_complete_one_day_after_obtaining, eligible, _).
test(art13_requirement_item_missing_is_not_eligible, fail) :-
    verdict_of(article_13_requirement_item_missing, eligible, _).
test(art13_adm_true_does_not_refer, fail) :-
    verdict_of(article_13_automated_decision_item_missing, needs_legal_review(_, _), _).
test(art13_further_processing_same_day_is_not_eligible, fail) :-
    verdict_of(article_13_further_processing_informed_same_day, eligible, _).
test(art14_day_after_last_day_is_not_eligible, fail) :-
    verdict_of(article_14_day_after_last_day_of_month, eligible, _).
test(art14_day_after_capped_month_end_is_not_eligible, fail) :-
    verdict_of(article_14_day_after_shifted_month_end, eligible, _).
test(art14_day_after_holiday_shift_is_not_eligible, fail) :-
    verdict_of(article_14_day_after_holiday_shifted_last_day, eligible, _).
test(art14_day_after_first_communication_is_not_eligible, fail) :-
    verdict_of(article_14_first_communication_day_after, eligible, _).
test(art14_law_attested_false_is_not_eligible, fail) :-
    verdict_of(article_14_source_missing_law_attested_false, eligible, _).
test(art14_effort_unsure_is_not_eligible, fail) :-
    verdict_of(article_14_effort_unsure_with_measures, eligible, _).
test(art14_effort_without_measures_is_not_exempt, fail) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, false)], impossible_or_disproportionate_effort).
test(route_absent_never_names_exemption_keys, fail) :-
    verdict_of(route_not_supplied, indeterminate(Keys), []),
    member(protective_measures_taken, Keys).
test(route_present_does_not_name_the_route_key, fail) :-
    verdict_of(article_14_only_the_route, indeterminate(Keys), []),
    member(personal_data_collected_from_data_subject, Keys).
test(input_problems_get_no_final_verdict, fail) :-
    verdict_of(not_a_profile, eligible, _).

cp_test_names([art13_on_obtaining_day_is_eligible, art13_one_day_after_is_ineligible, art13_requirement_item_missing_is_ineligible, art13_adm_unsure_refers, art13_adm_true_item_missing_is_ineligible, art13_further_processing_day_before_is_eligible, art13_further_processing_same_day_is_ineligible, art14_on_shifted_last_day_is_eligible, art14_day_after_last_day_is_ineligible, art14_capped_month_end_is_eligible, art14_day_after_capped_month_end_is_ineligible, art14_holiday_shifted_day_is_eligible, art14_day_after_holiday_shift_is_ineligible, art14_on_first_communication_is_eligible, art14_day_after_first_communication_is_ineligible, art14_law_attested_true_is_eligible, art14_law_attested_false_is_ineligible, art14_effort_with_measures_is_eligible, art14_effort_unsure_refers, art14_effort_without_measures_is_none, route_absent_names_the_route_key, input_problems_are_refused]).
cp_test_fail_names([art13_one_day_after_is_not_eligible, art13_requirement_item_missing_is_not_eligible, art13_adm_true_does_not_refer, art13_further_processing_same_day_is_not_eligible, art14_day_after_last_day_is_not_eligible, art14_day_after_capped_month_end_is_not_eligible, art14_day_after_holiday_shift_is_not_eligible, art14_day_after_first_communication_is_not_eligible, art14_law_attested_false_is_not_eligible, art14_effort_unsure_is_not_eligible, art14_effort_without_measures_is_not_exempt, route_absent_never_names_exemption_keys, route_present_does_not_name_the_route_key, input_problems_get_no_final_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
