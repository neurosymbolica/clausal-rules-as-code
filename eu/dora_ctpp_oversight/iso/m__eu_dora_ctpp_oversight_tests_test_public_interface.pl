% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_oversight_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ctpp_oversight_dora_ctpp_oversight, [decide_dora_ctpp_oversight/2, dora_ctpp_oversight_status/2, dora_ctpp_oversight_checklist/2, dora_ctpp_oversight_decision_resolvable/1, dora_ctpp_oversight_status_values/1, ctpp_oversight_duties_required/3, ctpp_lead_overseer_powers/3, ctpp_response_window_status/3, ctpp_periodic_penalty_payment_status/3, ctpp_periodic_penalty_payment_limits/3, ctpp_competent_authority_measure_condition/3]).
:- use_module(m__eu_dora_ctpp_oversight_fixtures, [dora_ctpp_oversight_subject/1, dora_ctpp_oversight_profile_for/2, dora_ctpp_oversight_assess/2]).
:- use_module(m__eu_dora_ctpp_oversight_queries, [dora_ctpp_oversight_what_if/4]).
:- use_module(m__eu_dora_ctpp_oversight_kernel, [dora_ctpp_oversight_input_problems/2]).

expected_status(designated_provider_full_profile, subject_to_lead_overseer_oversight).
expected_status(not_designated_provider, not_designated_as_critical).
expected_status(designation_unstated, oversight_indeterminate).
expected_status(profile_with_unknown_key, oversight_input_problems).
expected_status(profile_with_float_year_length, oversight_input_problems).
expected_status(profile_with_integer_year_length, subject_to_lead_overseer_oversight).
expected_status(statement_window_last_day, subject_to_lead_overseer_oversight).
expected_status(statement_window_day_after_last_day, subject_to_lead_overseer_oversight).
expected_status(statement_window_day_before_start, subject_to_lead_overseer_oversight).
expected_status(information_window_last_day, subject_to_lead_overseer_oversight).
expected_status(information_window_day_after_last_day, subject_to_lead_overseer_oversight).
expected_status(penalty_thirtieth_day_after_receipt, subject_to_lead_overseer_oversight).
expected_status(penalty_thirty_first_day_after_receipt, subject_to_lead_overseer_oversight).
expected_status(penalty_recommendation_measure, subject_to_lead_overseer_oversight).
expected_status(penalty_remediation_report_measure, subject_to_lead_overseer_oversight).
expected_status(penalty_full_compliance, subject_to_lead_overseer_oversight).
expected_status(penalty_partial_compliance, subject_to_lead_overseer_oversight).
expected_status(limits_notified_end_of_august, subject_to_lead_overseer_oversight).
expected_status(limits_notified_end_of_august_before_leap_year, subject_to_lead_overseer_oversight).
expected_status(limits_zero_turnover, subject_to_lead_overseer_oversight).
expected_status(limits_one_euro_turnover, subject_to_lead_overseer_oversight).
expected_status(powers_all_point_four_facts_hold, subject_to_lead_overseer_oversight).
expected_status(powers_risk_not_deemed, subject_to_lead_overseer_oversight).
expected_status(powers_oversight_activities_not_completed, subject_to_lead_overseer_oversight).
expected_status(duties_with_planned_subcontracting, subject_to_lead_overseer_oversight).
expected_status(duties_without_planned_subcontracting, subject_to_lead_overseer_oversight).
expected_status(measure_plan_adopted, subject_to_lead_overseer_oversight).
expected_status(measure_plan_not_adopted, subject_to_lead_overseer_oversight).

one_answer_per_query([]).
one_answer_per_query([Subject|Subjects]) :-
    dora_ctpp_oversight_profile_for(Subject, Profile),
    findall(Result, ctpp_oversight_duties_required(Profile, Result, _), DutiesAnswers),
    length(DutiesAnswers, 1),
    findall(Result, ctpp_lead_overseer_powers(Profile, Result, _), PowersAnswers),
    length(PowersAnswers, 1),
    findall(Result, ctpp_response_window_status(Profile, Result, _), WindowAnswers),
    length(WindowAnswers, 1),
    findall(Result, ctpp_periodic_penalty_payment_status(Profile, Result, _), PenaltyAnswers),
    length(PenaltyAnswers, 1),
    findall(Result, ctpp_periodic_penalty_payment_limits(Profile, Result, _), LimitsAnswers),
    length(LimitsAnswers, 1),
    findall(Result, ctpp_competent_authority_measure_condition(Profile, Result, _), MeasureAnswers),
    length(MeasureAnswers, 1),
    findall(Problems, dora_ctpp_oversight_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1),
    one_answer_per_query(Subjects).

every_item_cited([]).
every_item_cited([item(_, _, [cite(_)|_])|Items]) :-
    every_item_cited(Items).

test(every_subject_resolves_to_its_expected_status_once) :-
    findall(Subject - Status, (dora_ctpp_oversight_subject(Subject), dora_ctpp_oversight_assess(Subject, dora_ctpp_oversight_verdict(Status, _))), Found),
    findall(Subject - Status, expected_status(Subject, Status), Expected),
    clausal_msort(Found, SortedFound),
    clausal_msort(Expected, SortedExpected),
    SortedFound == SortedExpected.
test(every_status_is_in_the_vocabulary) :-
    dora_ctpp_oversight_status_values(StatusValues),
    findall(Status, expected_status(_, Status), Statuses),
    sort(Statuses, Distinct),
    clausal_msort(StatusValues, SortedValues),
    Distinct == SortedValues.
test(every_query_answers_once_on_every_subject) :-
    findall(Subject, dora_ctpp_oversight_subject(Subject), Subjects),
    one_answer_per_query(Subjects).
test(designated_provider_verdict_cites_article_35_1_and_35_5) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    decide_dora_ctpp_oversight(Profile, dora_ctpp_oversight_verdict(Status, Citations)),
    Status == subject_to_lead_overseer_oversight,
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_1), cite(eu_reg_2022_2554_art_35_5)].
test(not_designated_verdict) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    dora_ctpp_oversight_status(Profile, not_designated_as_critical).
test(unstated_designation_has_empty_citations) :-
    dora_ctpp_oversight_assess(designation_unstated, Verdict),
    Verdict == dora_ctpp_oversight_verdict(oversight_indeterminate, []).
test(full_profile_checklist_has_six_cited_items) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    dora_ctpp_oversight_decision_resolvable(Profile),
    dora_ctpp_oversight_checklist(Profile, Items),
    length(Items, 6),
    every_item_cited(Items).
test(not_designated_checklist_is_cited) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    dora_ctpp_oversight_checklist(Profile, [FirstItem|OtherItems]),
    every_item_cited([FirstItem|OtherItems]).
test(unstated_checklist_items_are_uncited) :-
    dora_ctpp_oversight_profile_for(designation_unstated, Profile),
    dora_ctpp_oversight_checklist(Profile, Items),
    Items = [item(_, indeterminate([provider_designated_as_critical]), [])|_].
test(unknown_key_is_reported) :-
    dora_ctpp_oversight_profile_for(profile_with_unknown_key, Profile),
    dora_ctpp_oversight_input_problems(Profile, Problems),
    Problems == [unknown_key(colour)].
test(unknown_key_comes_before_every_query_answer) :-
    dora_ctpp_oversight_profile_for(profile_with_unknown_key, Profile),
    ctpp_oversight_duties_required(Profile, Result, Citations),
    Result == input_problems([unknown_key(colour)]),
    Citations == [].
test(float_year_length_is_wrong_type) :-
    dora_ctpp_oversight_profile_for(profile_with_float_year_length, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, Result, Citations),
    Result == input_problems([wrong_type(preceding_business_year_length_in_days)]),
    Citations == [].
test(integer_year_length_has_no_problem) :-
    dora_ctpp_oversight_profile_for(profile_with_integer_year_length, Profile),
    dora_ctpp_oversight_input_problems(Profile, Problems),
    Problems == [].
test(integer_year_length_asks_for_the_notification_date) :-
    dora_ctpp_oversight_profile_for(profile_with_integer_year_length, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, Result, Citations),
    Result == indeterminate([penalty_decision_notified_on]),
    Citations == [].
test(full_profile_duties) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    ctpp_oversight_duties_required(Profile, Result, Citations),
    Result == required([transmit_subcontracting_information_to_lead_overseer, cooperate_in_good_faith_with_lead_overseer]),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_1_d), cite(eu_reg_2022_2554_art_35_5)].
test(full_profile_powers) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    ctpp_lead_overseer_powers(Profile, Result, _),
    Result == powers([request_information_and_documentation, conduct_general_investigations_and_inspections, request_remediation_reports, issue_recommendations, recommend_refraining_from_further_subcontracting]).
test(full_profile_window_open) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    ctpp_response_window_status(Profile, Result, Citations),
    Result = window_open(date(2026, 3, 17)),
    Citations == [cite(eu_reg_2022_2554_art_33_4)].
test(full_profile_penalty_required) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    ctpp_periodic_penalty_payment_status(Profile, Result, Citations),
    Result == penalty_decision_required,
    Citations == [cite(eu_reg_2022_2554_art_35_6)].
test(full_profile_limits) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, Result, _),
    Result = penalty_limits(amount(1000, 1), date(2027, 2, 28)).
test(full_profile_measure_condition) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    ctpp_competent_authority_measure_condition(Profile, Result, Citations),
    Result == lead_overseer_agreement_required,
    Citations == [cite(eu_reg_2022_2554_art_33_5)].
test(not_designated_every_query) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    ctpp_oversight_duties_required(Profile, not_designated_as_critical, [cite(eu_reg_2022_2554_art_35_5)]),
    ctpp_lead_overseer_powers(Profile, not_designated_as_critical, [cite(eu_reg_2022_2554_art_35_1)]),
    ctpp_response_window_status(Profile, not_designated_as_critical, WindowCitations),
    clausal_msort(WindowCitations, SortedWindowCitations),
    SortedWindowCitations == [cite(eu_reg_2022_2554_art_33_4), cite(eu_reg_2022_2554_art_35_3)],
    ctpp_periodic_penalty_payment_status(Profile, not_designated_as_critical, [cite(eu_reg_2022_2554_art_35_6)]),
    ctpp_periodic_penalty_payment_limits(Profile, not_designated_as_critical, LimitsCitations),
    clausal_msort(LimitsCitations, SortedLimitsCitations),
    SortedLimitsCitations == [cite(eu_reg_2022_2554_art_35_7), cite(eu_reg_2022_2554_art_35_8)],
    ctpp_competent_authority_measure_condition(Profile, not_designated_as_critical, [cite(eu_reg_2022_2554_art_33_5)]).
test(unstated_designation_is_named_first) :-
    dora_ctpp_oversight_profile_for(designation_unstated, Profile),
    ctpp_lead_overseer_powers(Profile, Result, Citations),
    Result == indeterminate([provider_designated_as_critical]),
    Citations == [].
test(statement_window_open_on_last_day) :-
    dora_ctpp_oversight_profile_for(statement_window_last_day, Profile),
    ctpp_response_window_status(Profile, Result, Citations),
    Result = window_open(date(2026, 3, 17)),
    Citations == [cite(eu_reg_2022_2554_art_33_4)].
test(statement_window_closed_on_day_after_last_day) :-
    dora_ctpp_oversight_profile_for(statement_window_day_after_last_day, Profile),
    ctpp_response_window_status(Profile, Result, _),
    Result = window_closed(date(2026, 3, 17)).
test(statement_window_not_yet_open_before_start) :-
    dora_ctpp_oversight_profile_for(statement_window_day_before_start, Profile),
    ctpp_response_window_status(Profile, Result, _),
    Result = window_not_yet_open(date(2026, 3, 17)).
test(information_window_open_on_last_day) :-
    dora_ctpp_oversight_profile_for(information_window_last_day, Profile),
    ctpp_response_window_status(Profile, Result, Citations),
    Result = window_open(date(2026, 1, 31)),
    Citations == [cite(eu_reg_2022_2554_art_35_3)].
test(information_window_closed_on_day_after_last_day) :-
    dora_ctpp_oversight_profile_for(information_window_day_after_last_day, Profile),
    ctpp_response_window_status(Profile, Result, Citations),
    Result = window_closed(date(2026, 1, 31)),
    Citations == [cite(eu_reg_2022_2554_art_35_3)].
test(penalty_waiting_period_running_on_thirtieth_day) :-
    dora_ctpp_oversight_profile_for(penalty_thirtieth_day_after_receipt, Profile),
    ctpp_periodic_penalty_payment_status(Profile, Result, Citations),
    Result = penalty_waiting_period_running(date(2026, 2, 1)),
    Citations == [cite(eu_reg_2022_2554_art_35_6)].
test(penalty_decision_required_on_thirty_first_day) :-
    dora_ctpp_oversight_profile_for(penalty_thirty_first_day_after_receipt, Profile),
    ctpp_periodic_penalty_payment_status(Profile, Result, Citations),
    Result == penalty_decision_required,
    Citations == [cite(eu_reg_2022_2554_art_35_6)].
test(penalty_recommendation_is_no_ground) :-
    dora_ctpp_oversight_profile_for(penalty_recommendation_measure, Profile),
    ctpp_periodic_penalty_payment_status(Profile, Result, Citations),
    Result == no_penalty_ground_recommendation,
    Citations == [cite(eu_reg_2022_2554_art_35_6)].
test(penalty_remediation_report_request_is_a_ground) :-
    dora_ctpp_oversight_profile_for(penalty_remediation_report_measure, Profile),
    ctpp_periodic_penalty_payment_status(Profile, Result, _),
    Result == penalty_decision_required.
test(penalty_full_compliance_is_no_ground) :-
    dora_ctpp_oversight_profile_for(penalty_full_compliance, Profile),
    ctpp_periodic_penalty_payment_status(Profile, Result, Citations),
    Result == no_penalty_ground_full_compliance,
    Citations == [cite(eu_reg_2022_2554_art_35_6)].
test(penalty_partial_compliance_is_a_ground) :-
    dora_ctpp_oversight_profile_for(penalty_partial_compliance, Profile),
    ctpp_periodic_penalty_payment_status(Profile, Result, _),
    Result == penalty_decision_required.
test(limits_end_of_february) :-
    dora_ctpp_oversight_profile_for(limits_notified_end_of_august, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, Result, Citations),
    Result = penalty_limits(amount(1000, 1), date(2027, 2, 28)),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_7), cite(eu_reg_2022_2554_art_35_8)].
test(limits_end_of_february_in_a_leap_year) :-
    dora_ctpp_oversight_profile_for(limits_notified_end_of_august_before_leap_year, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, Result, _),
    Result = penalty_limits(amount(1, 36600), date(2028, 2, 29)).
test(limits_zero_turnover_needs_no_year_length) :-
    dora_ctpp_oversight_profile_for(limits_zero_turnover, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, Result, Citations),
    Result = penalty_limits(amount(0, 1), date(2026, 7, 10)),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_7), cite(eu_reg_2022_2554_art_35_8)].
test(limits_one_euro_turnover_asks_for_the_year_length) :-
    dora_ctpp_oversight_profile_for(limits_one_euro_turnover, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, Result, Citations),
    Result == indeterminate([preceding_business_year_length_in_days]),
    Citations == [].
test(powers_all_point_four_facts_hold) :-
    dora_ctpp_oversight_profile_for(powers_all_point_four_facts_hold, Profile),
    ctpp_lead_overseer_powers(Profile, Result, Citations),
    Result == powers([request_information_and_documentation, conduct_general_investigations_and_inspections, request_remediation_reports, issue_recommendations, recommend_refraining_from_further_subcontracting]),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_1), cite(eu_reg_2022_2554_art_35_1_a), cite(eu_reg_2022_2554_art_35_1_b), cite(eu_reg_2022_2554_art_35_1_c), cite(eu_reg_2022_2554_art_35_1_d), cite(eu_reg_2022_2554_art_35_1_d_iv)].
test(powers_risk_not_deemed_drops_the_refrain_recommendation) :-
    dora_ctpp_oversight_profile_for(powers_risk_not_deemed, Profile),
    ctpp_lead_overseer_powers(Profile, Result, Citations),
    Result == powers([request_information_and_documentation, conduct_general_investigations_and_inspections, request_remediation_reports, issue_recommendations]),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_1), cite(eu_reg_2022_2554_art_35_1_a), cite(eu_reg_2022_2554_art_35_1_b), cite(eu_reg_2022_2554_art_35_1_c), cite(eu_reg_2022_2554_art_35_1_d)].
test(powers_oversight_activities_not_completed) :-
    dora_ctpp_oversight_profile_for(powers_oversight_activities_not_completed, Profile),
    ctpp_lead_overseer_powers(Profile, Result, _),
    Result == powers([request_information_and_documentation, conduct_general_investigations_and_inspections, issue_recommendations]).
test(duties_with_planned_subcontracting) :-
    dora_ctpp_oversight_profile_for(duties_with_planned_subcontracting, Profile),
    ctpp_oversight_duties_required(Profile, Result, Citations),
    Result == required([transmit_subcontracting_information_to_lead_overseer, cooperate_in_good_faith_with_lead_overseer]),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_1_d), cite(eu_reg_2022_2554_art_35_5)].
test(duties_without_planned_subcontracting) :-
    dora_ctpp_oversight_profile_for(duties_without_planned_subcontracting, Profile),
    ctpp_oversight_duties_required(Profile, Result, Citations),
    Result == required([cooperate_in_good_faith_with_lead_overseer]),
    Citations == [cite(eu_reg_2022_2554_art_35_5)].
test(measure_plan_adopted_needs_agreement) :-
    dora_ctpp_oversight_profile_for(measure_plan_adopted, Profile),
    ctpp_competent_authority_measure_condition(Profile, Result, Citations),
    Result == lead_overseer_agreement_required,
    Citations == [cite(eu_reg_2022_2554_art_33_5)].
test(measure_plan_not_adopted_sets_no_condition) :-
    dora_ctpp_oversight_profile_for(measure_plan_not_adopted, Profile),
    ctpp_competent_authority_measure_condition(Profile, Result, Citations),
    Result == no_article_33_5_condition,
    Citations == [cite(eu_reg_2022_2554_art_33_5)].
test(what_if_designation_true_flips_not_designated) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    dora_ctpp_oversight_what_if(Profile, provider_designated_as_critical, true, Status),
    Status == subject_to_lead_overseer_oversight.
test(what_if_designation_false_flips_designated) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    dora_ctpp_oversight_what_if(Profile, provider_designated_as_critical, false, Status),
    Status == not_designated_as_critical.

test(not_designated_is_not_under_oversight, fail) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    dora_ctpp_oversight_status(Profile, subject_to_lead_overseer_oversight).
test(statement_window_day_after_is_not_open, fail) :-
    dora_ctpp_oversight_profile_for(statement_window_day_after_last_day, Profile),
    ctpp_response_window_status(Profile, window_open(_), _).
test(information_window_day_after_is_not_open, fail) :-
    dora_ctpp_oversight_profile_for(information_window_day_after_last_day, Profile),
    ctpp_response_window_status(Profile, window_open(_), _).
test(penalty_thirtieth_day_is_no_decision, fail) :-
    dora_ctpp_oversight_profile_for(penalty_thirtieth_day_after_receipt, Profile),
    ctpp_periodic_penalty_payment_status(Profile, penalty_decision_required, _).
test(penalty_partial_compliance_is_not_full, fail) :-
    dora_ctpp_oversight_profile_for(penalty_partial_compliance, Profile),
    ctpp_periodic_penalty_payment_status(Profile, no_penalty_ground_full_compliance, _).
test(limits_one_euro_turnover_gives_no_limits, fail) :-
    dora_ctpp_oversight_profile_for(limits_one_euro_turnover, Profile),
    ctpp_periodic_penalty_payment_limits(Profile, penalty_limits(_, _), _).
test(measure_plan_not_adopted_needs_no_agreement, fail) :-
    dora_ctpp_oversight_profile_for(measure_plan_not_adopted, Profile),
    ctpp_competent_authority_measure_condition(Profile, lead_overseer_agreement_required, _).

cp_test_names([every_subject_resolves_to_its_expected_status_once, every_status_is_in_the_vocabulary, every_query_answers_once_on_every_subject, designated_provider_verdict_cites_article_35_1_and_35_5, not_designated_verdict, unstated_designation_has_empty_citations, full_profile_checklist_has_six_cited_items, not_designated_checklist_is_cited, unstated_checklist_items_are_uncited, unknown_key_is_reported, unknown_key_comes_before_every_query_answer, float_year_length_is_wrong_type, integer_year_length_has_no_problem, integer_year_length_asks_for_the_notification_date, full_profile_duties, full_profile_powers, full_profile_window_open, full_profile_penalty_required, full_profile_limits, full_profile_measure_condition, not_designated_every_query, unstated_designation_is_named_first, statement_window_open_on_last_day, statement_window_closed_on_day_after_last_day, statement_window_not_yet_open_before_start, information_window_open_on_last_day, information_window_closed_on_day_after_last_day, penalty_waiting_period_running_on_thirtieth_day, penalty_decision_required_on_thirty_first_day, penalty_recommendation_is_no_ground, penalty_remediation_report_request_is_a_ground, penalty_full_compliance_is_no_ground, penalty_partial_compliance_is_a_ground, limits_end_of_february, limits_end_of_february_in_a_leap_year, limits_zero_turnover_needs_no_year_length, limits_one_euro_turnover_asks_for_the_year_length, powers_all_point_four_facts_hold, powers_risk_not_deemed_drops_the_refrain_recommendation, powers_oversight_activities_not_completed, duties_with_planned_subcontracting, duties_without_planned_subcontracting, measure_plan_adopted_needs_agreement, measure_plan_not_adopted_sets_no_condition, what_if_designation_true_flips_not_designated, what_if_designation_false_flips_designated]).
cp_test_fail_names([not_designated_is_not_under_oversight, statement_window_day_after_is_not_open, information_window_day_after_is_not_open, penalty_thirtieth_day_is_no_decision, penalty_partial_compliance_is_not_full, limits_one_euro_turnover_gives_no_limits, measure_plan_not_adopted_needs_no_agreement]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
