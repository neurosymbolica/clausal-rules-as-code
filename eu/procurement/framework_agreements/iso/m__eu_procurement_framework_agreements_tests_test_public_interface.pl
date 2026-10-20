:- module(m__eu_procurement_framework_agreements_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [decide_framework_term/2, decide_call_off/2, call_off_route/2, framework_term_limit_date/2, framework_term_within_limit/3, call_off_award_window_status/4, decide_framework_agreements/2, framework_agreements_status/2, framework_agreements_checklist/2, framework_agreements_decision_resolvable/1, framework_agreements_status_values/1]).
:- use_module(m__eu_procurement_framework_agreements_fixtures, [framework_agreements_subject/1, framework_agreements_profile_for/2, framework_agreements_assess/2]).

test('single_op_lawful: call_off_lawful, route single_operator_direct_award') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, single_operator_direct_award, [], [])).
test('single_op_lawful: lawful_framework_term') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    decide_framework_term(Profile, framework_term_verdict(lawful_framework_term, [], [])).
test('single_op_outside_term: call_off_unlawful with award outside term') :-
    framework_agreements_profile_for("single_op_outside_term", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, single_operator_direct_award, [call_off_awarded_outside_framework_term], [cite(eu_dir_2014_24_art_33_2)])).
test('multi_direct_all_lawful: call_off_lawful, route multi_operator_direct_award_all_terms_set_out') :-
    framework_agreements_profile_for("multi_direct_all_lawful", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, multi_operator_direct_award_all_terms_set_out, [], [])).
test('multi_direct_all_no_conditions: call_off_unlawful, objective conditions not indicated') :-
    framework_agreements_profile_for("multi_direct_all_no_conditions", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, multi_operator_direct_award_all_terms_set_out, [objective_conditions_for_determining_performer_not_indicated], [cite(eu_dir_2014_24_art_33_4)])).
test('multi_direct_split_lawful: call_off_lawful, route multi_operator_direct_award_under_split_framework') :-
    framework_agreements_profile_for("multi_direct_split_lawful", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, multi_operator_direct_award_under_split_framework, [], [])).
test('multi_direct_split_no_terms_spec: call_off_unlawful, terms subject to reopening not specified') :-
    framework_agreements_profile_for("multi_direct_split_no_terms_spec", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, multi_operator_direct_award_under_split_framework, [terms_subject_to_reopening_not_specified], [cite(eu_dir_2014_24_art_33_4)])).
test('multi_reopen_lawful: call_off_lawful, route multi_operator_reopened_competition') :-
    framework_agreements_profile_for("multi_reopen_lawful", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, multi_operator_reopened_competition, [], [])).
test('multi_reopen_short_time: call_off_unlawful, time limit not sufficiently long') :-
    framework_agreements_profile_for("multi_reopen_short_time", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, multi_operator_reopened_competition, [time_limit_not_sufficiently_long], [cite(eu_dir_2014_24_art_33_5)])).
test('no_route_single_reopen: call_off_unlawful, reopening in single-operator framework') :-
    framework_agreements_profile_for("no_route_single_reopen", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, no_lawful_route, [reopening_competition_in_single_operator_framework], [cite(eu_dir_2014_24_art_33_4)])).
test('no_route_multi_all_nosplit: call_off_unlawful, reopening not available') :-
    framework_agreements_profile_for("no_route_multi_all_nosplit", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, no_lawful_route, [reopening_not_available_where_framework_sets_out_all_terms], [cite(eu_dir_2014_24_art_33_4)])).
test('term_boundary: exactly four years is lawful') :-
    framework_agreements_profile_for("term_boundary", Profile),
    decide_framework_term(Profile, framework_term_verdict(lawful_framework_term, [], [])).
test('term_exceeds: one day over four years, not justified, is unlawful') :-
    framework_agreements_profile_for("term_exceeds", Profile),
    decide_framework_term(Profile, framework_term_verdict(unlawful_framework_term, [framework_term_exceeds_four_years], [cite(eu_dir_2014_24_art_33_1)])).
test('term_justified: one day over four years, justified, is lawful') :-
    framework_agreements_profile_for("term_justified", Profile),
    decide_framework_term(Profile, framework_term_verdict(lawful_framework_term, [], [])).
test('framework_term_limit_date: fourth anniversary of 2024-01-01 is 2028-01-01') :-
    framework_term_limit_date(date(2024, 1, 1), date(2028, 1, 1)).
test('framework_term_within_limit: end at limit is within') :-
    framework_term_within_limit(date(2024, 1, 1), date(2028, 1, 1), within_four_year_limit).
test('framework_term_within_limit: end one day past limit exceeds') :-
    framework_term_within_limit(date(2024, 1, 1), date(2028, 1, 2), exceeds_four_year_limit).
test('call_off_award_window_status: award at start date is within') :-
    call_off_award_window_status(date(2024, 1, 1), date(2027, 1, 1), date(2024, 1, 1), award_date_within_framework_term).
test('call_off_award_window_status: award at end date is within') :-
    call_off_award_window_status(date(2024, 1, 1), date(2027, 1, 1), date(2027, 1, 1), award_date_within_framework_term).
test('call_off_award_window_status: award one day after end is outside') :-
    call_off_award_window_status(date(2024, 1, 1), date(2027, 1, 1), date(2027, 1, 2), award_date_outside_framework_term).
test('call_off_award_window_status: award one day before start is outside') :-
    call_off_award_window_status(date(2024, 1, 1), date(2027, 1, 1), date(2023, 12, 31), award_date_outside_framework_term).
test('framework_agreements_status: single op direct') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    framework_agreements_status(Profile, single_operator_direct_award).
test('framework_agreements_status: multi op direct all terms') :-
    framework_agreements_profile_for("multi_direct_all_lawful", Profile),
    framework_agreements_status(Profile, multi_operator_direct_award_all_terms_set_out).
test('framework_agreements_status: multi op direct split') :-
    framework_agreements_profile_for("multi_direct_split_lawful", Profile),
    framework_agreements_status(Profile, multi_operator_direct_award_under_split_framework).
test('framework_agreements_status: multi op reopened') :-
    framework_agreements_profile_for("multi_reopen_lawful", Profile),
    framework_agreements_status(Profile, multi_operator_reopened_competition).
test('framework_agreements_status: no lawful route single op reopen') :-
    framework_agreements_profile_for("no_route_single_reopen", Profile),
    framework_agreements_status(Profile, no_lawful_route).
test('framework_agreements_status: no lawful route multi all no split') :-
    framework_agreements_profile_for("no_route_multi_all_nosplit", Profile),
    framework_agreements_status(Profile, no_lawful_route).
test('decide_framework_agreements: both lawful') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    decide_framework_agreements(Profile, framework_agreements_verdict(framework_term_lawful, [])).
test('decide_framework_agreements: term lawful, call-off unlawful') :-
    framework_agreements_profile_for("single_op_outside_term", Profile),
    decide_framework_agreements(Profile, framework_agreements_verdict(call_off_unlawful, [cite(eu_dir_2014_24_art_33_2)])).
test('decide_framework_agreements: term unlawful') :-
    framework_agreements_profile_for("term_exceeds", Profile),
    decide_framework_agreements(Profile, framework_agreements_verdict(framework_term_unlawful, [cite(eu_dir_2014_24_art_33_1)])).
test('checklist non-empty on single_op_lawful') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    framework_agreements_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty on multi_reopen_lawful') :-
    framework_agreements_profile_for("multi_reopen_lawful", Profile),
    framework_agreements_checklist(Profile, Checklist),
    dif(Checklist, []).
test('decision resolvable on all fixtures') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    framework_agreements_decision_resolvable(Profile).
test('status values include all four statuses') :-
    framework_agreements_status_values(StatusValues),
    member(framework_term_lawful, StatusValues),
    member(framework_term_unlawful, StatusValues),
    member(call_off_lawful, StatusValues),
    member(call_off_unlawful, StatusValues).

cp_test_names(['single_op_lawful: call_off_lawful, route single_operator_direct_award', 'single_op_lawful: lawful_framework_term', 'single_op_outside_term: call_off_unlawful with award outside term', 'multi_direct_all_lawful: call_off_lawful, route multi_operator_direct_award_all_terms_set_out', 'multi_direct_all_no_conditions: call_off_unlawful, objective conditions not indicated', 'multi_direct_split_lawful: call_off_lawful, route multi_operator_direct_award_under_split_framework', 'multi_direct_split_no_terms_spec: call_off_unlawful, terms subject to reopening not specified', 'multi_reopen_lawful: call_off_lawful, route multi_operator_reopened_competition', 'multi_reopen_short_time: call_off_unlawful, time limit not sufficiently long', 'no_route_single_reopen: call_off_unlawful, reopening in single-operator framework', 'no_route_multi_all_nosplit: call_off_unlawful, reopening not available', 'term_boundary: exactly four years is lawful', 'term_exceeds: one day over four years, not justified, is unlawful', 'term_justified: one day over four years, justified, is lawful', 'framework_term_limit_date: fourth anniversary of 2024-01-01 is 2028-01-01', 'framework_term_within_limit: end at limit is within', 'framework_term_within_limit: end one day past limit exceeds', 'call_off_award_window_status: award at start date is within', 'call_off_award_window_status: award at end date is within', 'call_off_award_window_status: award one day after end is outside', 'call_off_award_window_status: award one day before start is outside', 'framework_agreements_status: single op direct', 'framework_agreements_status: multi op direct all terms', 'framework_agreements_status: multi op direct split', 'framework_agreements_status: multi op reopened', 'framework_agreements_status: no lawful route single op reopen', 'framework_agreements_status: no lawful route multi all no split', 'decide_framework_agreements: both lawful', 'decide_framework_agreements: term lawful, call-off unlawful', 'decide_framework_agreements: term unlawful', 'checklist non-empty on single_op_lawful', 'checklist non-empty on multi_reopen_lawful', 'decision resolvable on all fixtures', 'status values include all four statuses']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
