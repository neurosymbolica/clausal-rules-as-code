:- module(m__eu_procurement_utilities_negotiated_without_prior_call_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_utilities_negotiated_without_prior_call, [decide_utilities_negotiated_without_prior_call/2, utilities_negotiated_without_prior_call_status/2]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_fixtures, [utilities_negotiated_without_prior_call_profile_for/2]).

test('output mode: a_lawful yields exactly one verdict with use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    findall(Verdict, decide_utilities_negotiated_without_prior_call(Profile, Verdict), VerdictList),
    length(VerdictList, 1),
    member(utilities_negotiated_verdict(use_lawful, _, _), VerdictList).
test('output mode: a_near_miss yields exactly one verdict with use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_near_miss", Profile),
    findall(Verdict, decide_utilities_negotiated_without_prior_call(Profile, Verdict), VerdictList),
    length(VerdictList, 1),
    member(utilities_negotiated_verdict(use_unlawful, n_a, _), VerdictList).
test('output mode: b_lawful yields use_lawful with ground art_50_b_research_contract') :-
    utilities_negotiated_without_prior_call_profile_for("b_lawful", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, art_50_b_research_contract, _)).
test('output mode: d_lawful yields use_lawful with ground art_50_d_extreme_urgency') :-
    utilities_negotiated_without_prior_call_profile_for("d_lawful", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, art_50_d_extreme_urgency, _)).
test('output mode: e_lawful yields use_lawful with ground art_50_e_additional_deliveries') :-
    utilities_negotiated_without_prior_call_profile_for("e_lawful", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, art_50_e_additional_deliveries, _)).
test('output mode: f_lawful yields use_lawful with ground art_50_f_repetition') :-
    utilities_negotiated_without_prior_call_profile_for("f_lawful", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, art_50_f_repetition, _)).
test('output mode: g_lawful yields use_lawful with ground art_50_g_commodity_market') :-
    utilities_negotiated_without_prior_call_profile_for("g_lawful", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, art_50_g_commodity_market, _)).
test('output mode: h_lawful yields use_lawful with ground art_50_h_bargain_purchase') :-
    utilities_negotiated_without_prior_call_profile_for("h_lawful", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, art_50_h_bargain_purchase, _)).
test('output mode: i_lawful yields use_lawful with ground art_50_i_advantageous_winding_up') :-
    utilities_negotiated_without_prior_call_profile_for("i_lawful", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, art_50_i_advantageous_winding_up, _)).
test('output mode: j_lawful yields use_lawful with ground art_50_j_design_contest') :-
    utilities_negotiated_without_prior_call_profile_for("j_lawful", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, art_50_j_design_contest, _)).
test('output mode: c_tech_lawful yields use_lawful with ground art_50_c_sole_operator') :-
    utilities_negotiated_without_prior_call_profile_for("c_tech_lawful", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, art_50_c_sole_operator, _)).
test('output mode: f_near_miss (supplies type-gate) yields use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("f_near_miss", Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_unlawful, n_a, _)).

cp_test_names(['output mode: a_lawful yields exactly one verdict with use_lawful', 'output mode: a_near_miss yields exactly one verdict with use_unlawful', 'output mode: b_lawful yields use_lawful with ground art_50_b_research_contract', 'output mode: d_lawful yields use_lawful with ground art_50_d_extreme_urgency', 'output mode: e_lawful yields use_lawful with ground art_50_e_additional_deliveries', 'output mode: f_lawful yields use_lawful with ground art_50_f_repetition', 'output mode: g_lawful yields use_lawful with ground art_50_g_commodity_market', 'output mode: h_lawful yields use_lawful with ground art_50_h_bargain_purchase', 'output mode: i_lawful yields use_lawful with ground art_50_i_advantageous_winding_up', 'output mode: j_lawful yields use_lawful with ground art_50_j_design_contest', 'output mode: c_tech_lawful yields use_lawful with ground art_50_c_sole_operator', 'output mode: f_near_miss (supplies type-gate) yields use_unlawful']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
