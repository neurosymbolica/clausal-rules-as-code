% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_working_time_weekly_limit, [decide_working_time_weekly_limit/2, working_time_weekly_limit_status/2, working_time_weekly_limit_checklist/2, working_time_weekly_limit_decision_resolvable/1, working_time_weekly_limit_status_values/1, weekly_limit_status/7, weekly_working_time_average/6, required_reduction_minutes/6]).
:- use_module(m__eu_labour_working_time_weekly_limit_fixtures, [working_time_weekly_limit_subject/1, working_time_weekly_limit_profile_for/2, working_time_weekly_limit_assess/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_kernel, [working_time_weekly_limit_input_problems/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_queries, [working_time_weekly_limit_what_if/4, working_time_weekly_limit_maximum_counted_minutes/6]).

expected_verdict(at_limit, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(one_minute_over, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(option_absent_over, indeterminate([member_state_uses_article_22_option]), []).
expected_verdict(opt_out_agreed, weekly_limit_not_applied_by_agreement, [cite(eu_dir_2003_88_art_22_1), cite(eu_dir_2003_88_art_22_1_a)]).
expected_verdict(opt_out_without_agreement, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_22_1_a)]).
expected_verdict(agreement_false_option_absent, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_22_1_a)]).
expected_verdict(leave_day_at_limit, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(leave_day_one_minute_over, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(member_state_period_at_four_months, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(member_state_period_one_day_over, reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(basis_absent_one_day_over, indeterminate([reference_period_basis]), []).
expected_verdict(derogation_period_at_six_months, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(derogation_period_one_day_over, reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_19_first_subpara)]).
expected_verdict(collective_agreement_period_at_twelve_months, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(offshore_period_at_twelve_months, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(period_one_day_over_twelve_months, reference_period_longer_than_allowed, [cite(eu_dir_2003_88_art_16_b), cite(eu_dir_2003_88_art_19_first_subpara), cite(eu_dir_2003_88_art_19_second_subpara), cite(eu_dir_2003_88_art_20_2)]).
expected_verdict(all_sick_leave, no_countable_period, [cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(sick_leave_one_minute_short, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(on_site_absent_matters, indeterminate([on_call_on_site_counts_as_working_time]), []).
expected_verdict(on_site_absent_does_not_matter, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(on_site_unsure_matters, needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]), []).
expected_verdict(on_site_counted, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(on_site_not_counted, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(standby_absent_matters, indeterminate([on_call_standby_counts_as_working_time]), []).
expected_verdict(edge_shift_at_limit, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(edge_shift_one_minute_over, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(other_worker_ignored, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(same_rota_own_worker, over_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).
expected_verdict(bad_profile, input_problems([wrong_type(reference_period_basis), unknown_key(foo)]), []).
expected_verdict(good_profile_control, within_weekly_limit, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]).

gets_expected(Subject) :-
    expected_verdict(Subject, Status, Citations),
    findall(Verdict, working_time_weekly_limit_assess(Subject, Verdict), Verdicts),
    Verdicts == [working_time_weekly_limit_verdict(Status, Citations)].

has_a_checklist(Subject) :-
    working_time_weekly_limit_profile_for(Subject, SubjectCase),
    working_time_weekly_limit_checklist(SubjectCase, [_FirstItem|_OtherItems]).

is_resolvable(Subject) :-
    working_time_weekly_limit_profile_for(Subject, SubjectCase),
    working_time_weekly_limit_decision_resolvable(SubjectCase).

average_for(Subject, Average) :-
    working_time_weekly_limit_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    weekly_working_time_average(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average).

reduction_for(Subject, Minutes) :-
    working_time_weekly_limit_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    required_reduction_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes).

maximum_for(Subject, Maximum) :-
    working_time_weekly_limit_profile_for(Subject, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    working_time_weekly_limit_maximum_counted_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Maximum).

test(every_subject_has_an_expectation) :-
    findall(Subject, working_time_weekly_limit_subject(Subject), Subjects),
    findall(Subject, expected_verdict(Subject, _, _), ExpectedSubjects),
    msort(Subjects, SortedSubjects),
    msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_gets_its_expected_verdict_once) :-
    findall(Subject, working_time_weekly_limit_subject(Subject), Subjects),
    maplist(gets_expected, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, working_time_weekly_limit_subject(Subject), Subjects),
    maplist(has_a_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, working_time_weekly_limit_subject(Subject), Subjects),
    maplist(is_resolvable, Subjects).
test(final_statuses_are_in_the_vocabulary) :-
    working_time_weekly_limit_status_values(StatusValues),
    working_time_weekly_limit_profile_for(at_limit, SubjectCase),
    working_time_weekly_limit_status(SubjectCase, Status),
    member(Status, StatusValues).
test(at_limit) :-
    gets_expected(at_limit).
test(one_minute_over) :-
    gets_expected(one_minute_over).
test(option_absent_over) :-
    gets_expected(option_absent_over).
test(opt_out_agreed) :-
    gets_expected(opt_out_agreed).
test(opt_out_without_agreement) :-
    gets_expected(opt_out_without_agreement).
test(agreement_false_option_absent) :-
    gets_expected(agreement_false_option_absent).
test(leave_day_at_limit) :-
    gets_expected(leave_day_at_limit).
test(leave_day_one_minute_over) :-
    gets_expected(leave_day_one_minute_over).
test(member_state_period_at_four_months) :-
    gets_expected(member_state_period_at_four_months).
test(member_state_period_one_day_over) :-
    gets_expected(member_state_period_one_day_over).
test(basis_absent_one_day_over) :-
    gets_expected(basis_absent_one_day_over).
test(derogation_period_at_six_months) :-
    gets_expected(derogation_period_at_six_months).
test(derogation_period_one_day_over) :-
    gets_expected(derogation_period_one_day_over).
test(collective_agreement_period_at_twelve_months) :-
    gets_expected(collective_agreement_period_at_twelve_months).
test(offshore_period_at_twelve_months) :-
    gets_expected(offshore_period_at_twelve_months).
test(period_one_day_over_twelve_months) :-
    gets_expected(period_one_day_over_twelve_months).
test(all_sick_leave) :-
    gets_expected(all_sick_leave).
test(sick_leave_one_minute_short) :-
    gets_expected(sick_leave_one_minute_short).
test(on_site_absent_matters) :-
    gets_expected(on_site_absent_matters).
test(on_site_absent_does_not_matter) :-
    gets_expected(on_site_absent_does_not_matter).
test(on_site_unsure_matters) :-
    gets_expected(on_site_unsure_matters).
test(on_site_counted) :-
    gets_expected(on_site_counted).
test(on_site_not_counted) :-
    gets_expected(on_site_not_counted).
test(standby_absent_matters) :-
    gets_expected(standby_absent_matters).
test(edge_shift_at_limit) :-
    gets_expected(edge_shift_at_limit).
test(edge_shift_one_minute_over) :-
    gets_expected(edge_shift_one_minute_over).
test(other_worker_ignored) :-
    gets_expected(other_worker_ignored).
test(same_rota_own_worker) :-
    gets_expected(same_rota_own_worker).
test(bad_profile) :-
    gets_expected(bad_profile).
test(good_profile_control) :-
    gets_expected(good_profile_control).
test(the_status_query_answers_once) :-
    working_time_weekly_limit_profile_for(at_limit, case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Result - Citations, weekly_limit_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations), Answers),
    Answers == [within_weekly_limit - [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_6_b), cite(eu_dir_2003_88_art_16_b)]].
test(the_average_at_the_limit_is_exactly_2880) :-
    findall(Average, average_for(at_limit, Average), Averages),
    Averages == [minutes_per_seven_days(2880, 1)].
test(the_average_one_minute_over) :-
    average_for(one_minute_over, minutes_per_seven_days(2881, 1)).
test(the_average_with_a_leave_day_is_exact) :-
    average_for(leave_day_at_limit, minutes_per_seven_days(8638, 3)).
test(the_average_of_a_sick_period) :-
    average_for(all_sick_leave, no_countable_period).
test(the_average_asks_for_an_absent_on_call_judgement) :-
    average_for(on_site_absent_does_not_matter, indeterminate([on_call_on_site_counts_as_working_time])).
test(the_average_refers_an_unsure_on_call_judgement) :-
    average_for(on_site_unsure_matters, needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])])).
test(a_referral_context_may_carry_a_trailing_provenance_element) :-
    average_for(on_site_unsure_matters, needs_legal_review(Reason, [inputs_relied_on(Pairs)])),
    Context = [inputs_relied_on(Pairs), provenance(weekly_working_time_average, [cite(eu_dir_2003_88_art_2_1)])],
    Referral = needs_legal_review(Reason, Context),
    Referral = needs_legal_review(open_textured(KeyName, cite(CitationKey)), [inputs_relied_on(ReadPairs), provenance(Clause, ProvenanceCitations)]),
    KeyName == on_call_on_site_counts_as_working_time,
    CitationKey == eu_dir_2003_88_art_2_1,
    ReadPairs == [on_call_on_site_counts_as_working_time - unsure],
    Clause == weekly_working_time_average,
    ProvenanceCitations == [cite(eu_dir_2003_88_art_2_1)].
test(no_reduction_at_the_limit) :-
    findall(Minutes, reduction_for(at_limit, Minutes), Reductions),
    Reductions == [0].
test(one_minute_of_reduction_one_minute_over) :-
    reduction_for(one_minute_over, 1).
test(one_minute_of_reduction_with_a_leave_day) :-
    reduction_for(leave_day_one_minute_over, 1).
test(no_reduction_when_the_unresolved_kind_cannot_tip) :-
    reduction_for(on_site_absent_does_not_matter, 0).
test(the_reduction_asks_for_an_on_call_judgement_that_tips) :-
    reduction_for(on_site_absent_matters, indeterminate([on_call_on_site_counts_as_working_time])).
test(the_reduction_of_another_workers_rota_is_zero) :-
    reduction_for(other_worker_ignored, 0).
test(the_reduction_refuses_a_bad_profile) :-
    reduction_for(bad_profile, input_problems([wrong_type(reference_period_basis), unknown_key(foo)])).
test(the_threshold_of_a_week) :-
    findall(Maximum, maximum_for(at_limit, Maximum), Maxima),
    Maxima == [2880].
test(the_threshold_with_a_leave_day_flips_between_2468_and_2469) :-
    maximum_for(leave_day_at_limit, 2468),
    maximum_for(leave_day_one_minute_over, 2468),
    gets_expected(leave_day_at_limit),
    gets_expected(leave_day_one_minute_over).
test(the_threshold_reads_no_on_call_key) :-
    maximum_for(on_site_absent_matters, 2880).
test(the_threshold_of_a_sick_period) :-
    maximum_for(all_sick_leave, no_countable_period).
test(the_threshold_refuses_a_bad_profile) :-
    maximum_for(bad_profile, input_problems([wrong_type(reference_period_basis), unknown_key(foo)])).
test(the_input_check_of_a_bad_profile) :-
    findall(Problems, working_time_weekly_limit_input_problems([attribute(reference_period_basis, x), attribute(foo, 1), attribute(foo, 2)], Problems), Answers),
    Answers == [[wrong_type(reference_period_basis), unknown_key(foo)]].
test(the_input_check_of_a_good_profile) :-
    working_time_weekly_limit_input_problems([attribute(reference_period_basis, member_state_reference_period)], []).
test(what_if_the_option_is_used_asks_for_the_agreement) :-
    working_time_weekly_limit_profile_for(one_minute_over, SubjectCase),
    working_time_weekly_limit_what_if(SubjectCase, member_state_uses_article_22_option, true, working_time_weekly_limit_verdict(indeterminate([worker_agreement_to_exceed_obtained_first]), [])).
test(what_if_on_site_time_is_not_working_time) :-
    working_time_weekly_limit_profile_for(on_site_unsure_matters, SubjectCase),
    working_time_weekly_limit_what_if(SubjectCase, on_call_on_site_counts_as_working_time, false, working_time_weekly_limit_verdict(within_weekly_limit, _)).
test(what_if_the_worker_agreed_first) :-
    working_time_weekly_limit_profile_for(opt_out_without_agreement, SubjectCase),
    working_time_weekly_limit_what_if(SubjectCase, worker_agreement_to_exceed_obtained_first, true, working_time_weekly_limit_verdict(weekly_limit_not_applied_by_agreement, _)).
test(the_checklist_of_a_breach_names_the_average) :-
    working_time_weekly_limit_profile_for(one_minute_over, SubjectCase),
    working_time_weekly_limit_checklist(SubjectCase, Items),
    member(item(weekly_average, unmet(over_weekly_limit), cite(eu_dir_2003_88_art_6_b)), Items).
test(the_checklist_at_the_limit_is_met) :-
    working_time_weekly_limit_profile_for(at_limit, SubjectCase),
    working_time_weekly_limit_checklist(SubjectCase, Items),
    member(item(weekly_average, met, cite(eu_dir_2003_88_art_6_b)), Items).
test(the_facade_verdict_matches_the_status) :-
    working_time_weekly_limit_profile_for(opt_out_agreed, SubjectCase),
    decide_working_time_weekly_limit(SubjectCase, working_time_weekly_limit_verdict(Status, _)),
    working_time_weekly_limit_status(SubjectCase, Status),
    Status == weekly_limit_not_applied_by_agreement.

test(at_limit_is_not_over, fail) :-
    working_time_weekly_limit_assess(at_limit, working_time_weekly_limit_verdict(over_weekly_limit, _)).
test(one_minute_over_is_not_within, fail) :-
    working_time_weekly_limit_assess(one_minute_over, working_time_weekly_limit_verdict(within_weekly_limit, _)).
test(leave_day_at_limit_is_not_over, fail) :-
    working_time_weekly_limit_assess(leave_day_at_limit, working_time_weekly_limit_verdict(over_weekly_limit, _)).
test(leave_day_one_minute_over_is_not_within, fail) :-
    working_time_weekly_limit_assess(leave_day_one_minute_over, working_time_weekly_limit_verdict(within_weekly_limit, _)).
test(opt_out_without_agreement_is_not_disapplied, fail) :-
    working_time_weekly_limit_assess(opt_out_without_agreement, working_time_weekly_limit_verdict(weekly_limit_not_applied_by_agreement, _)).
test(four_months_is_not_too_long, fail) :-
    working_time_weekly_limit_assess(member_state_period_at_four_months, working_time_weekly_limit_verdict(reference_period_longer_than_allowed, _)).
test(four_months_and_a_day_is_not_within, fail) :-
    working_time_weekly_limit_assess(member_state_period_one_day_over, working_time_weekly_limit_verdict(within_weekly_limit, _)).
test(six_months_derogation_is_not_too_long, fail) :-
    working_time_weekly_limit_assess(derogation_period_at_six_months, working_time_weekly_limit_verdict(reference_period_longer_than_allowed, _)).
test(six_months_and_a_day_derogation_is_not_within, fail) :-
    working_time_weekly_limit_assess(derogation_period_one_day_over, working_time_weekly_limit_verdict(within_weekly_limit, _)).
test(twelve_months_collective_agreement_is_not_too_long, fail) :-
    working_time_weekly_limit_assess(collective_agreement_period_at_twelve_months, working_time_weekly_limit_verdict(reference_period_longer_than_allowed, _)).
test(twelve_months_and_a_day_is_not_within, fail) :-
    working_time_weekly_limit_assess(period_one_day_over_twelve_months, working_time_weekly_limit_verdict(within_weekly_limit, _)).
test(one_minute_short_of_sick_leave_is_countable, fail) :-
    working_time_weekly_limit_assess(sick_leave_one_minute_short, working_time_weekly_limit_verdict(no_countable_period, _)).
test(on_site_that_does_not_matter_is_not_asked_for, fail) :-
    working_time_weekly_limit_assess(on_site_absent_does_not_matter, working_time_weekly_limit_verdict(indeterminate(_), _)).
test(edge_shift_at_limit_is_not_over, fail) :-
    working_time_weekly_limit_assess(edge_shift_at_limit, working_time_weekly_limit_verdict(over_weekly_limit, _)).
test(edge_shift_one_minute_over_is_not_within, fail) :-
    working_time_weekly_limit_assess(edge_shift_one_minute_over, working_time_weekly_limit_verdict(within_weekly_limit, _)).
test(another_workers_rota_is_not_over, fail) :-
    working_time_weekly_limit_assess(other_worker_ignored, working_time_weekly_limit_verdict(over_weekly_limit, _)).
test(a_good_profile_has_no_input_problem, fail) :-
    working_time_weekly_limit_assess(good_profile_control, working_time_weekly_limit_verdict(input_problems(_), _)).
test(a_provenance_term_is_not_a_pairs_item, fail) :-
    provenance(weekly_working_time_average, [cite(eu_dir_2003_88_art_2_1)]) = inputs_relied_on(_).

cp_test_names([every_subject_has_an_expectation, every_subject_gets_its_expected_verdict_once, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, final_statuses_are_in_the_vocabulary, at_limit, one_minute_over, option_absent_over, opt_out_agreed, opt_out_without_agreement, agreement_false_option_absent, leave_day_at_limit, leave_day_one_minute_over, member_state_period_at_four_months, member_state_period_one_day_over, basis_absent_one_day_over, derogation_period_at_six_months, derogation_period_one_day_over, collective_agreement_period_at_twelve_months, offshore_period_at_twelve_months, period_one_day_over_twelve_months, all_sick_leave, sick_leave_one_minute_short, on_site_absent_matters, on_site_absent_does_not_matter, on_site_unsure_matters, on_site_counted, on_site_not_counted, standby_absent_matters, edge_shift_at_limit, edge_shift_one_minute_over, other_worker_ignored, same_rota_own_worker, bad_profile, good_profile_control, the_status_query_answers_once, the_average_at_the_limit_is_exactly_2880, the_average_one_minute_over, the_average_with_a_leave_day_is_exact, the_average_of_a_sick_period, the_average_asks_for_an_absent_on_call_judgement, the_average_refers_an_unsure_on_call_judgement, a_referral_context_may_carry_a_trailing_provenance_element, no_reduction_at_the_limit, one_minute_of_reduction_one_minute_over, one_minute_of_reduction_with_a_leave_day, no_reduction_when_the_unresolved_kind_cannot_tip, the_reduction_asks_for_an_on_call_judgement_that_tips, the_reduction_of_another_workers_rota_is_zero, the_reduction_refuses_a_bad_profile, the_threshold_of_a_week, the_threshold_with_a_leave_day_flips_between_2468_and_2469, the_threshold_reads_no_on_call_key, the_threshold_of_a_sick_period, the_threshold_refuses_a_bad_profile, the_input_check_of_a_bad_profile, the_input_check_of_a_good_profile, what_if_the_option_is_used_asks_for_the_agreement, what_if_on_site_time_is_not_working_time, what_if_the_worker_agreed_first, the_checklist_of_a_breach_names_the_average, the_checklist_at_the_limit_is_met, the_facade_verdict_matches_the_status]).
cp_test_fail_names([at_limit_is_not_over, one_minute_over_is_not_within, leave_day_at_limit_is_not_over, leave_day_one_minute_over_is_not_within, opt_out_without_agreement_is_not_disapplied, four_months_is_not_too_long, four_months_and_a_day_is_not_within, six_months_derogation_is_not_too_long, six_months_and_a_day_derogation_is_not_within, twelve_months_collective_agreement_is_not_too_long, twelve_months_and_a_day_is_not_within, one_minute_short_of_sick_leave_is_countable, on_site_that_does_not_matter_is_not_asked_for, edge_shift_at_limit_is_not_over, edge_shift_one_minute_over_is_not_within, another_workers_rota_is_not_over, a_good_profile_has_no_input_problem, a_provenance_term_is_not_a_pairs_item]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
