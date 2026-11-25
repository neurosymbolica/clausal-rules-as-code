% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_oversight_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ctpp_oversight_dora_ctpp_oversight, [ctpp_oversight_duties_required/3, ctpp_lead_overseer_powers/3, ctpp_response_window_status/3, ctpp_periodic_penalty_payment_status/3, ctpp_periodic_penalty_payment_limits/3, ctpp_competent_authority_measure_condition/3, dora_ctpp_oversight_status/2, dora_ctpp_oversight_status_values/1]).
:- use_module(m__eu_dora_ctpp_oversight_fixtures, [dora_ctpp_oversight_profile_for/2]).

test(the_status_table_holds_every_facade_status) :-
    dora_ctpp_oversight_status_values(StatusValues),
    clausal_msort(StatusValues, Sorted),
    Sorted == [not_designated_as_critical, oversight_indeterminate, oversight_input_problems, subject_to_lead_overseer_oversight].
test(facade_designated_is_under_oversight) :-
    dora_ctpp_oversight_profile_for(profile_with_integer_year_length, Profile),
    dora_ctpp_oversight_status(Profile, subject_to_lead_overseer_oversight).
test(facade_not_designated_gets_its_own_status) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    dora_ctpp_oversight_status(Profile, not_designated_as_critical).
test(facade_unstated_is_indeterminate) :-
    dora_ctpp_oversight_profile_for(designation_unstated, Profile),
    dora_ctpp_oversight_status(Profile, oversight_indeterminate).
test(facade_float_year_length_is_an_input_problem) :-
    dora_ctpp_oversight_profile_for(profile_with_float_year_length, Profile),
    dora_ctpp_oversight_status(Profile, oversight_input_problems).
test(facade_unknown_key_is_an_input_problem) :-
    dora_ctpp_oversight_profile_for(profile_with_unknown_key, Profile),
    dora_ctpp_oversight_status(Profile, oversight_input_problems).
test(duties_planned_subcontracting_adds_transmission) :-
    dora_ctpp_oversight_profile_for(duties_with_planned_subcontracting, Profile),
    ctpp_oversight_duties_required(Profile, required(Duties), _),
    member(transmit_subcontracting_information_to_lead_overseer, Duties).
test(duties_without_planned_subcontracting_still_cooperates) :-
    dora_ctpp_oversight_profile_for(duties_without_planned_subcontracting, Profile),
    ctpp_oversight_duties_required(Profile, required([cooperate_in_good_faith_with_lead_overseer]), _).
test(duties_not_designated_is_not_designated) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    ctpp_oversight_duties_required(Profile, not_designated_as_critical, [cite(eu_reg_2022_2554_art_35_5)]).
test(powers_all_point_four_facts_list_the_refrain_recommendation) :-
    dora_ctpp_oversight_profile_for(powers_all_point_four_facts_hold, Profile),
    ctpp_lead_overseer_powers(Profile, powers(Powers), _),
    member(recommend_refraining_from_further_subcontracting, Powers).
test(powers_risk_not_deemed_still_lists_recommendations) :-
    dora_ctpp_oversight_profile_for(powers_risk_not_deemed, Profile),
    ctpp_lead_overseer_powers(Profile, powers(Powers), _),
    member(issue_recommendations, Powers).
test(powers_completed_oversight_lists_remediation_reports) :-
    dora_ctpp_oversight_profile_for(powers_risk_not_deemed, Profile),
    ctpp_lead_overseer_powers(Profile, powers(Powers), _),
    member(request_remediation_reports, Powers).
test(powers_uncompleted_oversight_still_lists_information_requests) :-
    dora_ctpp_oversight_profile_for(powers_oversight_activities_not_completed, Profile),
    ctpp_lead_overseer_powers(Profile, powers(Powers), _),
    member(request_information_and_documentation, Powers).
test(statement_window_open_on_last_day) :-
    dora_ctpp_oversight_profile_for(statement_window_last_day, Profile),
    ctpp_response_window_status(Profile, window_open(date(2026, 3, 17)), _).
test(statement_window_closed_day_after) :-
    dora_ctpp_oversight_profile_for(statement_window_day_after_last_day, Profile),
    ctpp_response_window_status(Profile, window_closed(date(2026, 3, 17)), _).
test(statement_window_not_yet_open_day_before_start) :-
    dora_ctpp_oversight_profile_for(statement_window_day_before_start, Profile),
    ctpp_response_window_status(Profile, window_not_yet_open(date(2026, 3, 17)), _).
test(information_window_open_on_last_day) :-
    dora_ctpp_oversight_profile_for(information_window_last_day, Profile),
    ctpp_response_window_status(Profile, window_open(date(2026, 1, 31)), _).
test(information_window_closed_day_after) :-
    dora_ctpp_oversight_profile_for(information_window_day_after_last_day, Profile),
    ctpp_response_window_status(Profile, window_closed(date(2026, 1, 31)), _).
test(information_window_cites_article_35_3) :-
    dora_ctpp_oversight_profile_for(information_window_last_day, Profile),
    ctpp_response_window_status(Profile, _, Citations),
    member(cite(eu_reg_2022_2554_art_35_3), Citations).
test(penalty_ground_met_on_thirty_first_day) :-
    dora_ctpp_oversight_profile_for(penalty_thirty_first_day_after_receipt, Profile),
    ctpp_periodic_penalty_payment_status(Profile, penalty_decision_required, _).
test(penalty_waiting_period_runs_on_thirtieth_day) :-
    dora_ctpp_oversight_profile_for(penalty_thirtieth_day_after_receipt, Profile),
    ctpp_periodic_penalty_payment_status(Profile, penalty_waiting_period_running(date(2026, 2, 1)), _).
test(penalty_remediation_report_measure_is_a_ground) :-
    dora_ctpp_oversight_profile_for(penalty_remediation_report_measure, Profile),
    ctpp_periodic_penalty_payment_status(Profile, penalty_decision_required, _).
test(penalty_recommendation_gets_its_own_answer) :-
    dora_ctpp_oversight_profile_for(penalty_recommendation_measure, Profile),
    ctpp_periodic_penalty_payment_status(Profile, no_penalty_ground_recommendation, [cite(eu_reg_2022_2554_art_35_6)]).
test(penalty_partial_compliance_is_a_ground) :-
    dora_ctpp_oversight_profile_for(penalty_partial_compliance, Profile),
    ctpp_periodic_penalty_payment_status(Profile, penalty_decision_required, _).
test(penalty_full_compliance_gets_its_own_answer) :-
    dora_ctpp_oversight_profile_for(penalty_full_compliance, Profile),
    ctpp_periodic_penalty_payment_status(Profile, no_penalty_ground_full_compliance, _).
test(limits_zero_turnover_gives_nothing_without_year_length) :-
    dora_ctpp_oversight_profile_for(limits_zero_turnover, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, penalty_limits(amount(0, 1), date(2026, 7, 10)), _).
test(limits_one_euro_turnover_names_the_year_length) :-
    dora_ctpp_oversight_profile_for(limits_one_euro_turnover, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, indeterminate([preceding_business_year_length_in_days]), []).
test(limits_leap_year_ends_on_twenty_ninth_february) :-
    dora_ctpp_oversight_profile_for(limits_notified_end_of_august_before_leap_year, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, penalty_limits(_, date(2028, 2, 29)), _).
test(limits_ordinary_year_ends_on_twenty_eighth_february) :-
    dora_ctpp_oversight_profile_for(limits_notified_end_of_august, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, penalty_limits(amount(1000, 1), date(2027, 2, 28)), _).
test(measure_plan_adopted_needs_agreement) :-
    dora_ctpp_oversight_profile_for(measure_plan_adopted, Profile),
    ctpp_competent_authority_measure_condition(Profile, lead_overseer_agreement_required, [cite(eu_reg_2022_2554_art_33_5)]).
test(measure_plan_not_adopted_has_no_article_33_5_condition) :-
    dora_ctpp_oversight_profile_for(measure_plan_not_adopted, Profile),
    ctpp_competent_authority_measure_condition(Profile, no_article_33_5_condition, _).
test(measure_not_designated_is_not_designated) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    ctpp_competent_authority_measure_condition(Profile, not_designated_as_critical, [cite(eu_reg_2022_2554_art_33_5)]).

test(facade_not_designated_is_not_under_oversight, fail) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    dora_ctpp_oversight_status(Profile, subject_to_lead_overseer_oversight).
test(facade_unstated_is_not_under_oversight, fail) :-
    dora_ctpp_oversight_profile_for(designation_unstated, Profile),
    dora_ctpp_oversight_status(Profile, subject_to_lead_overseer_oversight).
test(facade_float_year_length_is_not_under_oversight, fail) :-
    dora_ctpp_oversight_profile_for(profile_with_float_year_length, Profile),
    dora_ctpp_oversight_status(Profile, subject_to_lead_overseer_oversight).
test(facade_integer_year_length_is_not_an_input_problem, fail) :-
    dora_ctpp_oversight_profile_for(profile_with_integer_year_length, Profile),
    dora_ctpp_oversight_status(Profile, oversight_input_problems).
test(duties_without_planned_subcontracting_has_no_transmission, fail) :-
    dora_ctpp_oversight_profile_for(duties_without_planned_subcontracting, Profile),
    ctpp_oversight_duties_required(Profile, required(Duties), _),
    member(transmit_subcontracting_information_to_lead_overseer, Duties).
test(duties_not_designated_requires_nothing, fail) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    ctpp_oversight_duties_required(Profile, required(_), _).
test(powers_risk_not_deemed_drops_the_refrain_recommendation, fail) :-
    dora_ctpp_oversight_profile_for(powers_risk_not_deemed, Profile),
    ctpp_lead_overseer_powers(Profile, powers(Powers), _),
    member(recommend_refraining_from_further_subcontracting, Powers).
test(powers_uncompleted_oversight_drops_remediation_reports, fail) :-
    dora_ctpp_oversight_profile_for(powers_oversight_activities_not_completed, Profile),
    ctpp_lead_overseer_powers(Profile, powers(Powers), _),
    member(request_remediation_reports, Powers).
test(statement_window_not_open_day_after, fail) :-
    dora_ctpp_oversight_profile_for(statement_window_day_after_last_day, Profile),
    ctpp_response_window_status(Profile, window_open(_), _).
test(statement_window_not_open_day_before_start, fail) :-
    dora_ctpp_oversight_profile_for(statement_window_day_before_start, Profile),
    ctpp_response_window_status(Profile, window_open(_), _).
test(information_window_not_open_day_after, fail) :-
    dora_ctpp_oversight_profile_for(information_window_day_after_last_day, Profile),
    ctpp_response_window_status(Profile, window_open(_), _).
test(information_window_does_not_cite_article_33_4, fail) :-
    dora_ctpp_oversight_profile_for(information_window_last_day, Profile),
    ctpp_response_window_status(Profile, _, Citations),
    member(cite(eu_reg_2022_2554_art_33_4), Citations).
test(penalty_ground_not_met_on_thirtieth_day, fail) :-
    dora_ctpp_oversight_profile_for(penalty_thirtieth_day_after_receipt, Profile),
    ctpp_periodic_penalty_payment_status(Profile, penalty_decision_required, _).
test(penalty_recommendation_is_not_a_ground, fail) :-
    dora_ctpp_oversight_profile_for(penalty_recommendation_measure, Profile),
    ctpp_periodic_penalty_payment_status(Profile, penalty_decision_required, _).
test(penalty_full_compliance_is_not_a_ground, fail) :-
    dora_ctpp_oversight_profile_for(penalty_full_compliance, Profile),
    ctpp_periodic_penalty_payment_status(Profile, penalty_decision_required, _).
test(limits_one_euro_turnover_needs_the_year_length, fail) :-
    dora_ctpp_oversight_profile_for(limits_one_euro_turnover, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, penalty_limits(_, _), _).
test(limits_ordinary_year_ends_on_no_other_day, fail) :-
    dora_ctpp_oversight_profile_for(limits_notified_end_of_august, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, penalty_limits(_, LastDay), _),
    dif(LastDay, date(2027, 2, 28)).
test(measure_plan_not_adopted_needs_no_agreement, fail) :-
    dora_ctpp_oversight_profile_for(measure_plan_not_adopted, Profile),
    ctpp_competent_authority_measure_condition(Profile, lead_overseer_agreement_required, _).
test(measure_not_designated_needs_no_agreement, fail) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    ctpp_competent_authority_measure_condition(Profile, lead_overseer_agreement_required, _).

cp_test_names([the_status_table_holds_every_facade_status, facade_designated_is_under_oversight, facade_not_designated_gets_its_own_status, facade_unstated_is_indeterminate, facade_float_year_length_is_an_input_problem, facade_unknown_key_is_an_input_problem, duties_planned_subcontracting_adds_transmission, duties_without_planned_subcontracting_still_cooperates, duties_not_designated_is_not_designated, powers_all_point_four_facts_list_the_refrain_recommendation, powers_risk_not_deemed_still_lists_recommendations, powers_completed_oversight_lists_remediation_reports, powers_uncompleted_oversight_still_lists_information_requests, statement_window_open_on_last_day, statement_window_closed_day_after, statement_window_not_yet_open_day_before_start, information_window_open_on_last_day, information_window_closed_day_after, information_window_cites_article_35_3, penalty_ground_met_on_thirty_first_day, penalty_waiting_period_runs_on_thirtieth_day, penalty_remediation_report_measure_is_a_ground, penalty_recommendation_gets_its_own_answer, penalty_partial_compliance_is_a_ground, penalty_full_compliance_gets_its_own_answer, limits_zero_turnover_gives_nothing_without_year_length, limits_one_euro_turnover_names_the_year_length, limits_leap_year_ends_on_twenty_ninth_february, limits_ordinary_year_ends_on_twenty_eighth_february, measure_plan_adopted_needs_agreement, measure_plan_not_adopted_has_no_article_33_5_condition, measure_not_designated_is_not_designated]).
cp_test_fail_names([facade_not_designated_is_not_under_oversight, facade_unstated_is_not_under_oversight, facade_float_year_length_is_not_under_oversight, facade_integer_year_length_is_not_an_input_problem, duties_without_planned_subcontracting_has_no_transmission, duties_not_designated_requires_nothing, powers_risk_not_deemed_drops_the_refrain_recommendation, powers_uncompleted_oversight_drops_remediation_reports, statement_window_not_open_day_after, statement_window_not_open_day_before_start, information_window_not_open_day_after, information_window_does_not_cite_article_33_4, penalty_ground_not_met_on_thirtieth_day, penalty_recommendation_is_not_a_ground, penalty_full_compliance_is_not_a_ground, limits_one_euro_turnover_needs_the_year_length, limits_ordinary_year_ends_on_no_other_day, measure_plan_not_adopted_needs_no_agreement, measure_not_designated_needs_no_agreement]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
