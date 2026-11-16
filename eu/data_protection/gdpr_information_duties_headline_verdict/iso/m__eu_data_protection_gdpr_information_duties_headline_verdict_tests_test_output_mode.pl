% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3, decide_information_duty_verdict/2, information_duty_verdict_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [decide_information_duty_exemption/2, information_duty_exemption_status/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_profile_for/2]).

test(art13_on_time_yields_exactly_one_answer) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    findall(Verdict - Citations, information_duty_verdict(Profile, Verdict, Citations), Answers),
    Answers == [eligible - [cite(eu_reg_2016_679_art_13_1)]].
test(art13_one_day_late_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    findall(Verdict - Citations, information_duty_verdict(Profile, Verdict, Citations), Answers),
    Answers == [ineligible - [cite(eu_reg_2016_679_art_13_1)]].
test(art13_missing_statutory_item_names_its_point) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_missing_statutory_item, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_2_e)]).
test(art13_unsure_automated_decision_is_referred) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_unsure_automated_decision, Profile),
    information_duty_verdict(Profile, needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])]), []).
test(art13_further_processing_prior_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_further_processing_prior, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_13_1), cite(eu_reg_2016_679_art_13_3)]).
test(art13_further_processing_same_day_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_further_processing_same_day, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_3)]).
test(art14_boundary_day_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_on_time_at_boundary, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_one_day_over_is_ineligible_on_limb_a) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_one_day_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_communication_limb_on_time) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_communication_limb_on_time, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_communication_limb_late_cites_limb_b) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_communication_limb_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_b)]).
test(art14_month_end_saturday_moves_to_monday) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_month_end_on_time, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_month_end_one_day_over_is_late) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_month_end_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_attested_holiday_shifts_the_deadline) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_holiday_shift_on_time, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_absent_holiday_leaves_the_deadline) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_holiday_absent_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_effort_exemption_disapplies_the_duty) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_exemption, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_5_b)]).
test(art14_law_exemption_disapplies_the_duty) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_law_exemption, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_5_c)]).
test(art14_secrecy_exemption_disapplies_the_duty) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_secrecy_exemption, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_5_d)]).
test(art14_effort_unsure_is_referred) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_unsure, Profile),
    information_duty_verdict(Profile, needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])]), []).
test(art14_effort_without_measures_lists_the_missing_items) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_without_measures, Profile),
    information_duty_verdict(Profile, ineligible, Citations),
    member(cite(eu_reg_2016_679_art_14_1_a), Citations).
test(exemption_status_is_read_out) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_secrecy_exemption, Profile),
    findall(Status, information_duty_exemption_status(Profile, Status), Statuses),
    Statuses == [professional_secrecy_obligation].
test(exemption_verdict_carries_its_citation) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_law_exemption, Profile),
    decide_information_duty_exemption(Profile, information_duty_exemption_verdict(law_lays_down_obtaining_or_disclosure, [cite(eu_reg_2016_679_art_14_5_c)])).
test(decided_verdict_wraps_status_and_citations) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    decide_information_duty_verdict(Profile, information_duty_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_13_1)])).
test(checklist_has_three_rows) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_verdict_checklist(Profile, Rows),
    length(Rows, 3).

cp_test_names([art13_on_time_yields_exactly_one_answer, art13_one_day_late_is_ineligible, art13_missing_statutory_item_names_its_point, art13_unsure_automated_decision_is_referred, art13_further_processing_prior_is_eligible, art13_further_processing_same_day_is_ineligible, art14_boundary_day_is_eligible, art14_one_day_over_is_ineligible_on_limb_a, art14_communication_limb_on_time, art14_communication_limb_late_cites_limb_b, art14_month_end_saturday_moves_to_monday, art14_month_end_one_day_over_is_late, art14_attested_holiday_shifts_the_deadline, art14_absent_holiday_leaves_the_deadline, art14_effort_exemption_disapplies_the_duty, art14_law_exemption_disapplies_the_duty, art14_secrecy_exemption_disapplies_the_duty, art14_effort_unsure_is_referred, art14_effort_without_measures_lists_the_missing_items, exemption_status_is_read_out, exemption_verdict_carries_its_citation, decided_verdict_wraps_status_and_citations, checklist_has_three_rows]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
