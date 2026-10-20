:- module(m__eu_procurement_framework_agreements_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_framework_agreements_queries, [framework_agreements_profile_keys/1, framework_agreements_what_if/4, framework_agreements_route_status/2, framework_agreements_enumerate_defects/2, framework_agreements_term_boundary/2, framework_agreements_threshold_status/3]).
:- use_module(m__eu_procurement_framework_agreements_fixtures, [framework_agreements_profile_for/2]).

test('profile keys: returns exactly 21 keys') :-
    framework_agreements_profile_keys(ProfileKeys),
    length(ProfileKeys, 21).
test('profile keys: framework_start_date is present') :-
    framework_agreements_profile_keys(ProfileKeys),
    member(framework_start_date, ProfileKeys).
test('profile keys: framework_operator_count is present') :-
    framework_agreements_profile_keys(ProfileKeys),
    member(framework_operator_count, ProfileKeys).
test('route status: single-operator profile yields single_operator_direct_award') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    framework_agreements_route_status(Profile, single_operator_direct_award).
test('route status: multi-direct-all profile yields multi_operator_direct_award_all_terms_set_out') :-
    framework_agreements_profile_for("multi_direct_all_lawful", Profile),
    framework_agreements_route_status(Profile, multi_operator_direct_award_all_terms_set_out).
test('route status: no-route profile yields no_lawful_route') :-
    framework_agreements_profile_for("no_route_single_reopen", Profile),
    framework_agreements_route_status(Profile, no_lawful_route).
test('enumerate defects: lawful profile has empty defect list') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    framework_agreements_enumerate_defects(Profile, Defects),
    Defects = [].
test('enumerate defects: outside-term profile has a non-empty defect list') :-
    framework_agreements_profile_for("single_op_outside_term", Profile),
    framework_agreements_enumerate_defects(Profile, Defects),
    Defects = [_|_].
test('term boundary: 2024-01-01 start yields 2028-01-01 limit') :-
    framework_agreements_term_boundary(date(2024, 1, 1), date(2028, 1, 1)).
test('term boundary: 2024-02-29 start yields 2028-02-29 limit (leap)') :-
    framework_agreements_term_boundary(date(2024, 2, 29), date(2028, 2, 29)).
test('term boundary: 2096-02-29 start CLAMPS to 2100-02-28 (century non-leap)') :-
    framework_agreements_term_boundary(date(2096, 2, 29), date(2100, 2, 28)).
test('threshold status: exactly 4 years is within limit') :-
    framework_agreements_threshold_status(date(2024, 1, 1), date(2028, 1, 1), within_four_year_limit).
test('threshold status: 4 years plus 1 day exceeds limit') :-
    framework_agreements_threshold_status(date(2024, 1, 1), date(2028, 1, 2), exceeds_four_year_limit).
test('what_if: flipping exceptional_case_duly_justified to True makes an over-long term lawful') :-
    framework_agreements_profile_for("term_exceeds", Profile),
    framework_agreements_what_if(Profile, exceptional_case_duly_justified, true, framework_agreements_verdict(_, _)).
test('what_if: flipping call_off_entails_substantial_modification to True makes a lawful call-off unlawful') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    framework_agreements_what_if(Profile, call_off_entails_substantial_modification, true, framework_agreements_verdict(_, _)).

cp_test_names(['profile keys: returns exactly 21 keys', 'profile keys: framework_start_date is present', 'profile keys: framework_operator_count is present', 'route status: single-operator profile yields single_operator_direct_award', 'route status: multi-direct-all profile yields multi_operator_direct_award_all_terms_set_out', 'route status: no-route profile yields no_lawful_route', 'enumerate defects: lawful profile has empty defect list', 'enumerate defects: outside-term profile has a non-empty defect list', 'term boundary: 2024-01-01 start yields 2028-01-01 limit', 'term boundary: 2024-02-29 start yields 2028-02-29 limit (leap)', 'term boundary: 2096-02-29 start CLAMPS to 2100-02-28 (century non-leap)', 'threshold status: exactly 4 years is within limit', 'threshold status: 4 years plus 1 day exceeds limit', 'what_if: flipping exceptional_case_duly_justified to True makes an over-long term lawful', 'what_if: flipping call_off_entails_substantial_modification to True makes a lawful call-off unlawful']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
