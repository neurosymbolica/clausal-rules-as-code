:- module(m__eu_procurement_utilities_negotiated_without_prior_call_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [get/3]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_utilities_negotiated_without_prior_call, [decide_utilities_negotiated_without_prior_call/2, utilities_negotiated_without_prior_call_status/2, utilities_negotiated_without_prior_call_checklist/2]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_fixtures, [utilities_negotiated_without_prior_call_subject/1, utilities_negotiated_without_prior_call_profile_for/2, utilities_negotiated_without_prior_call_assess/2]).

test('a_lawful: no suitable tenders, conditions not altered -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("a_lawful", utilities_negotiated_verdict(use_lawful, art_50_a_no_suitable_tenders, _Citations)).
test('b_lawful: research contract, all three conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("b_lawful", utilities_negotiated_verdict(use_lawful, art_50_b_research_contract, _Citations)).
test('c_art_lawful: sole operator unique art -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("c_art_lawful", utilities_negotiated_verdict(use_lawful, art_50_c_sole_operator, _Citations)).
test('c_tech_lawful: sole operator technical reasons with proviso -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("c_tech_lawful", utilities_negotiated_verdict(use_lawful, art_50_c_sole_operator, _Citations)).
test('c_rights_lawful: sole operator exclusive rights with proviso -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("c_rights_lawful", utilities_negotiated_verdict(use_lawful, art_50_c_sole_operator, _Citations)).
test('d_lawful: extreme urgency, all three conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("d_lawful", utilities_negotiated_verdict(use_lawful, art_50_d_extreme_urgency, _Citations)).
test('e_lawful: additional deliveries, supplies type, both conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("e_lawful", utilities_negotiated_verdict(use_lawful, art_50_e_additional_deliveries, _Citations)).
test('f_lawful: repetition, services type, all four conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("f_lawful", utilities_negotiated_verdict(use_lawful, art_50_f_repetition, _Citations)).
test('g_lawful: commodity market, supplies type -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("g_lawful", utilities_negotiated_verdict(use_lawful, art_50_g_commodity_market, _Citations)).
test('h_lawful: bargain purchase, supplies type, both conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("h_lawful", utilities_negotiated_verdict(use_lawful, art_50_h_bargain_purchase, _Citations)).
test('i_lawful: advantageous winding up, services type, both conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("i_lawful", utilities_negotiated_verdict(use_lawful, art_50_i_advantageous_winding_up, _Citations)).
test('j_lawful: design contest, services type, both conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_assess("j_lawful", utilities_negotiated_verdict(use_lawful, art_50_j_design_contest, _Citations)).
test('a_near_miss: initial conditions substantially altered -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("a_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('b_near_miss: award prejudices subsequent competitive award -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("b_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('c_art_near_miss: only_particular_operator false -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("c_art_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('c_tech_near_miss: absence_of_competition artificially narrowed -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("c_tech_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('c_rights_near_miss: no_reasonable_alternative false -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("c_rights_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('d_near_miss: urgency attributable to entity -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("d_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('e_near_miss: works type, type gate fails -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("e_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('f_near_miss: supplies type, type gate fails -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("f_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('g_near_miss: services type, type gate fails -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("g_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('h_near_miss: price not considerably lower -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("h_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('i_near_miss: works type, type gate fails -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("i_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('j_near_miss: supplies type, type gate fails -> use_unlawful') :-
    utilities_negotiated_without_prior_call_assess("j_near_miss", utilities_negotiated_verdict(use_unlawful, n_a, _Citations)).
test('checklist non-empty: a_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty: b_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("b_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty: c_tech_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("c_tech_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty: d_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("d_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty: e_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("e_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty: f_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("f_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty: g_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("g_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty: h_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("h_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty: i_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("i_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('checklist non-empty: j_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("j_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    dif(Checklist, []).
test('status projection: a_lawful -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('status projection: e_near_miss -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("e_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('pleaded_ground_key, contract_type_key, sole_operator_reason_key are distinct profile key atoms') :-
    dif(pleaded_ground_key, contract_type_key),
    dif(contract_type_key, sole_operator_reason_key),
    dif(pleaded_ground_key, sole_operator_reason_key).
test('pleaded_ground_key appears in a lawful profile') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    get(Profile, pleaded_ground_key, art_50_a_no_suitable_tenders).
test('contract_type_key appears in a lawful profile') :-
    utilities_negotiated_without_prior_call_profile_for("e_lawful", Profile),
    get(Profile, contract_type_key, supplies).
test('sole_operator_reason_key appears in a sole-operator profile') :-
    utilities_negotiated_without_prior_call_profile_for("c_tech_lawful", Profile),
    get(Profile, sole_operator_reason_key, competition_absent_for_technical_reasons).

cp_test_names(['a_lawful: no suitable tenders, conditions not altered -> use_lawful', 'b_lawful: research contract, all three conditions met -> use_lawful', 'c_art_lawful: sole operator unique art -> use_lawful', 'c_tech_lawful: sole operator technical reasons with proviso -> use_lawful', 'c_rights_lawful: sole operator exclusive rights with proviso -> use_lawful', 'd_lawful: extreme urgency, all three conditions met -> use_lawful', 'e_lawful: additional deliveries, supplies type, both conditions met -> use_lawful', 'f_lawful: repetition, services type, all four conditions met -> use_lawful', 'g_lawful: commodity market, supplies type -> use_lawful', 'h_lawful: bargain purchase, supplies type, both conditions met -> use_lawful', 'i_lawful: advantageous winding up, services type, both conditions met -> use_lawful', 'j_lawful: design contest, services type, both conditions met -> use_lawful', 'a_near_miss: initial conditions substantially altered -> use_unlawful', 'b_near_miss: award prejudices subsequent competitive award -> use_unlawful', 'c_art_near_miss: only_particular_operator false -> use_unlawful', 'c_tech_near_miss: absence_of_competition artificially narrowed -> use_unlawful', 'c_rights_near_miss: no_reasonable_alternative false -> use_unlawful', 'd_near_miss: urgency attributable to entity -> use_unlawful', 'e_near_miss: works type, type gate fails -> use_unlawful', 'f_near_miss: supplies type, type gate fails -> use_unlawful', 'g_near_miss: services type, type gate fails -> use_unlawful', 'h_near_miss: price not considerably lower -> use_unlawful', 'i_near_miss: works type, type gate fails -> use_unlawful', 'j_near_miss: supplies type, type gate fails -> use_unlawful', 'checklist non-empty: a_lawful', 'checklist non-empty: b_lawful', 'checklist non-empty: c_tech_lawful', 'checklist non-empty: d_lawful', 'checklist non-empty: e_lawful', 'checklist non-empty: f_lawful', 'checklist non-empty: g_lawful', 'checklist non-empty: h_lawful', 'checklist non-empty: i_lawful', 'checklist non-empty: j_lawful', 'status projection: a_lawful -> use_lawful', 'status projection: e_near_miss -> use_unlawful', 'pleaded_ground_key, contract_type_key, sole_operator_reason_key are distinct profile key atoms', 'pleaded_ground_key appears in a lawful profile', 'contract_type_key appears in a lawful profile', 'sole_operator_reason_key appears in a sole-operator profile']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
