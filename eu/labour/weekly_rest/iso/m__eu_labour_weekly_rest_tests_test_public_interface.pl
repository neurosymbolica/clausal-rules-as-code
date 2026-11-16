% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_weekly_rest_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_weekly_rest_weekly_rest, [decide_weekly_rest/2, weekly_rest_status/2, weekly_rest_status/7, shortest_weekly_rest_minutes/6, first_period_without_weekly_rest/6, weekly_rest_checklist/2, weekly_rest_decision_resolvable/1, weekly_rest_status_values/1]).
:- use_module(m__eu_labour_weekly_rest_kernel, [weekly_rest_input_problems/2]).
:- use_module(m__eu_labour_weekly_rest_fixtures, [weekly_rest_subject/1, weekly_rest_profile_for/2, weekly_rest_assess/2]).

status_of(Subject, Status) :-
    weekly_rest_profile_for(Subject, Case),
    weekly_rest_status(Case, Status).

citations_of(Subject, Citations) :-
    weekly_rest_assess(Subject, weekly_rest_verdict(_, Citations)).

shortest_of(Subject, Minutes) :-
    weekly_rest_profile_for(Subject, weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    shortest_weekly_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Minutes).

first_day_of(Subject, Day) :-
    weekly_rest_profile_for(Subject, weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    first_period_without_weekly_rest(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Day).

rest_citations([cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_2), cite(eu_dir_2003_88_art_5_first_subpara), cite(eu_dir_2003_88_art_5_second_subpara), cite(eu_dir_2003_88_art_16_a)]).

test(every_subject_yields_exactly_one_verdict) :-
    findall(Subject, weekly_rest_subject(Subject), Subjects),
    length(Subjects, 22),
    findall(Subject - Status, (weekly_rest_subject(Subject), weekly_rest_assess(Subject, weekly_rest_verdict(Status, _))), Answers),
    length(Answers, 22).
test(the_status_query_yields_one_solution) :-
    weekly_rest_profile_for(rest_of_2100_minutes_given, weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    findall(Result - Citations, weekly_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations), Answers),
    length(Answers, 1).
test(rest_of_2100_minutes_is_given) :-
    status_of(rest_of_2100_minutes_given, weekly_rest_given),
    citations_of(rest_of_2100_minutes_given, Citations),
    rest_citations(Expected),
    Citations == Expected.
test(rest_of_2099_minutes_is_not_given) :-
    status_of(rest_of_2099_minutes_not_given, weekly_rest_not_given),
    citations_of(rest_of_2099_minutes_not_given, Citations),
    rest_citations(Expected),
    Citations == Expected.
test(shortest_measures_the_boundary_exactly) :-
    shortest_of(rest_of_2100_minutes_given, 2100),
    shortest_of(rest_of_2099_minutes_not_given, 2099).
test(first_period_at_the_boundary) :-
    first_day_of(rest_of_2100_minutes_given, no_period_without_weekly_rest),
    first_day_of(rest_of_2099_minutes_not_given, date(2026, 3, 2)).
test(reduced_rest_of_1440_minutes_is_given) :-
    status_of(reduced_rest_of_1440_minutes_given, weekly_rest_given),
    shortest_of(reduced_rest_of_1440_minutes_given, 1440).
test(reduced_rest_of_1439_minutes_is_not_given) :-
    status_of(reduced_rest_of_1439_minutes_not_given, weekly_rest_not_given),
    shortest_of(reduced_rest_of_1439_minutes_not_given, 1439).
test(fourteen_day_run_of_4200_minutes_is_given) :-
    status_of(fourteen_day_run_of_4200_minutes_given, weekly_rest_given),
    shortest_of(fourteen_day_run_of_4200_minutes_given, 2100).
test(fourteen_day_run_of_4199_minutes_is_not_given) :-
    status_of(fourteen_day_run_of_4199_minutes_not_given, weekly_rest_not_given),
    shortest_of(fourteen_day_run_of_4199_minutes_not_given, 2099).
test(mobile_worker_short_rest_is_not_applied) :-
    status_of(mobile_worker_short_rest_not_applied, weekly_rest_not_applied_to_worker),
    citations_of(mobile_worker_short_rest_not_applied, [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]).
test(mobile_worker_full_rest_is_given) :-
    status_of(mobile_worker_full_rest_given, weekly_rest_given).
test(fishing_vessel_worker_short_rest_is_not_applied) :-
    status_of(fishing_vessel_worker_short_rest_not_applied, weekly_rest_not_applied_to_worker),
    citations_of(fishing_vessel_worker_short_rest_not_applied, [cite(eu_dir_2003_88_art_21_1)]).
test(fishing_vessel_worker_full_rest_is_given) :-
    status_of(fishing_vessel_worker_full_rest_given, weekly_rest_given).
test(derogation_under_article_17_1_applies) :-
    status_of(derogation_under_article_17_1_short_rest, weekly_rest_derogation_applies),
    citations_of(derogation_under_article_17_1_short_rest, [cite(eu_dir_2003_88_art_5_first_subpara), cite(eu_dir_2003_88_art_17_1)]).
test(derogation_under_article_17_3_applies) :-
    status_of(derogation_under_article_17_3_short_rest, weekly_rest_derogation_applies),
    citations_of(derogation_under_article_17_3_short_rest, [cite(eu_dir_2003_88_art_5_first_subpara), cite(eu_dir_2003_88_art_17_3)]).
test(derogation_under_article_17_4_applies) :-
    status_of(derogation_under_article_17_4_short_rest, weekly_rest_derogation_applies),
    citations_of(derogation_under_article_17_4_short_rest, [cite(eu_dir_2003_88_art_5_first_subpara), cite(eu_dir_2003_88_art_17_4)]).
test(derogation_under_article_18_applies) :-
    status_of(derogation_under_article_18_short_rest, weekly_rest_derogation_applies),
    citations_of(derogation_under_article_18_short_rest, [cite(eu_dir_2003_88_art_5_first_subpara), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)]).
test(derogation_with_full_rest_is_given) :-
    status_of(derogation_under_article_17_4_full_rest_given, weekly_rest_given).
test(short_rest_without_worker_category_asks_for_it) :-
    status_of(short_rest_without_worker_category, indeterminate([worker_category])),
    citations_of(short_rest_without_worker_category, []).
test(short_rest_without_derogation_asks_for_it) :-
    status_of(short_rest_without_derogation, indeterminate([derogation_from_article_5])),
    citations_of(short_rest_without_derogation, []).
test(absent_standby_is_asked_for) :-
    status_of(absent_standby_indeterminate, indeterminate([on_call_standby_counts_as_working_time])).
test(absent_standby_also_leaves_the_figure_open) :-
    shortest_of(absent_standby_indeterminate, indeterminate([on_call_standby_counts_as_working_time])).
test(unsure_standby_needs_legal_review) :-
    status_of(unsure_standby_needs_legal_review, needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_standby_counts_as_working_time - unsure])])),
    citations_of(unsure_standby_needs_legal_review, []).
test(standby_not_working_time_is_given) :-
    status_of(standby_not_working_time_given, weekly_rest_given),
    shortest_of(standby_not_working_time_given, 2100).
test(standby_working_time_is_not_given) :-
    status_of(standby_working_time_not_given, weekly_rest_not_given),
    shortest_of(standby_working_time_not_given, 0),
    first_day_of(standby_working_time_not_given, date(2026, 3, 2)).
test(a_referral_context_may_carry_a_provenance_element) :-
    status_of(unsure_standby_needs_legal_review, needs_legal_review(Reason, [inputs_relied_on(Pairs)])),
    Extended = needs_legal_review(Reason, [inputs_relied_on(Pairs), provenance(weekly_rest_status_step_2c, [cite(eu_dir_2003_88_art_2_1)])]),
    Extended = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(ReadPairs), provenance(Clause, ProvenanceCitations)]),
    Key == on_call_standby_counts_as_working_time,
    CitationKey == eu_dir_2003_88_art_2_1,
    ReadPairs == [on_call_standby_counts_as_working_time - unsure],
    Clause == weekly_rest_status_step_2c,
    ProvenanceCitations == [cite(eu_dir_2003_88_art_2_1)].
test(unknown_key_gives_input_problems) :-
    weekly_rest_profile_for(unknown_key_input_problems, weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd)),
    weekly_rest_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, input_problems([unknown_key(audit_note)]), []),
    shortest_weekly_rest_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, input_problems([unknown_key(audit_note)])).
test(input_check_reports_a_duplicate_key) :-
    weekly_rest_input_problems([attribute(worker_category, other_worker), attribute(worker_category, mobile_worker)], [duplicate_key(worker_category)]).
test(input_check_accepts_a_well_formed_profile) :-
    weekly_rest_input_problems([attribute(worker_category, other_worker)], []).
test(input_check_rejects_a_non_list) :-
    weekly_rest_input_problems(not_a_profile, [wrong_type(profile)]).
test(final_subjects_are_resolvable) :-
    weekly_rest_profile_for(rest_of_2100_minutes_given, GivenCase),
    weekly_rest_decision_resolvable(GivenCase),
    weekly_rest_profile_for(rest_of_2099_minutes_not_given, ShortCase),
    weekly_rest_decision_resolvable(ShortCase).
test(checklists_are_non_empty) :-
    weekly_rest_profile_for(rest_of_2100_minutes_given, GivenCase),
    weekly_rest_checklist(GivenCase, [_|_]),
    weekly_rest_profile_for(rest_of_2099_minutes_not_given, ShortCase),
    weekly_rest_checklist(ShortCase, ShortItems),
    member(item(weekly_rest_in_every_block, unmet(block_rest_below_required), _), ShortItems).
test(final_statuses_are_in_the_vocabulary) :-
    weekly_rest_status_values(Values),
    weekly_rest_profile_for(mobile_worker_short_rest_not_applied, Case),
    decide_weekly_rest(Case, weekly_rest_verdict(Status, _)),
    member(Status, Values).

test(rest_of_2099_minutes_is_not_given_as_given, fail) :-
    status_of(rest_of_2099_minutes_not_given, weekly_rest_given).
test(rest_of_2100_minutes_is_not_short, fail) :-
    status_of(rest_of_2100_minutes_given, weekly_rest_not_given).
test(reduced_rest_of_1439_minutes_is_not_given_as_given, fail) :-
    status_of(reduced_rest_of_1439_minutes_not_given, weekly_rest_given).
test(fourteen_day_run_of_4199_minutes_is_not_given_as_given, fail) :-
    status_of(fourteen_day_run_of_4199_minutes_not_given, weekly_rest_given).
test(mobile_worker_full_rest_is_not_not_applied, fail) :-
    status_of(mobile_worker_full_rest_given, weekly_rest_not_applied_to_worker).
test(derogation_with_full_rest_is_not_a_derogation_answer, fail) :-
    status_of(derogation_under_article_17_4_full_rest_given, weekly_rest_derogation_applies).
test(standby_working_time_is_not_given_as_given, fail) :-
    status_of(standby_working_time_not_given, weekly_rest_given).
test(a_provenance_element_has_two_arguments, fail) :-
    provenance(weekly_rest_status_step_2c, [cite(eu_dir_2003_88_art_2_1)]) = provenance(_).
test(unknown_key_is_not_given, fail) :-
    status_of(unknown_key_input_problems, weekly_rest_given).
test(an_indeterminate_subject_is_not_resolvable, fail) :-
    weekly_rest_profile_for(short_rest_without_worker_category, Case),
    weekly_rest_decision_resolvable(Case).

cp_test_names([every_subject_yields_exactly_one_verdict, the_status_query_yields_one_solution, rest_of_2100_minutes_is_given, rest_of_2099_minutes_is_not_given, shortest_measures_the_boundary_exactly, first_period_at_the_boundary, reduced_rest_of_1440_minutes_is_given, reduced_rest_of_1439_minutes_is_not_given, fourteen_day_run_of_4200_minutes_is_given, fourteen_day_run_of_4199_minutes_is_not_given, mobile_worker_short_rest_is_not_applied, mobile_worker_full_rest_is_given, fishing_vessel_worker_short_rest_is_not_applied, fishing_vessel_worker_full_rest_is_given, derogation_under_article_17_1_applies, derogation_under_article_17_3_applies, derogation_under_article_17_4_applies, derogation_under_article_18_applies, derogation_with_full_rest_is_given, short_rest_without_worker_category_asks_for_it, short_rest_without_derogation_asks_for_it, absent_standby_is_asked_for, absent_standby_also_leaves_the_figure_open, unsure_standby_needs_legal_review, standby_not_working_time_is_given, standby_working_time_is_not_given, a_referral_context_may_carry_a_provenance_element, unknown_key_gives_input_problems, input_check_reports_a_duplicate_key, input_check_accepts_a_well_formed_profile, input_check_rejects_a_non_list, final_subjects_are_resolvable, checklists_are_non_empty, final_statuses_are_in_the_vocabulary]).
cp_test_fail_names([rest_of_2099_minutes_is_not_given_as_given, rest_of_2100_minutes_is_not_short, reduced_rest_of_1439_minutes_is_not_given_as_given, fourteen_day_run_of_4199_minutes_is_not_given_as_given, mobile_worker_full_rest_is_not_not_applied, derogation_with_full_rest_is_not_a_derogation_answer, standby_working_time_is_not_given_as_given, a_provenance_element_has_two_arguments, unknown_key_is_not_given, an_indeterminate_subject_is_not_resolvable]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
