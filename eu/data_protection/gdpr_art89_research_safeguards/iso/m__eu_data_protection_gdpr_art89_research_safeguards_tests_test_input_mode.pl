% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_safeguards_status, [safeguards_status_status/2, unmet_requirements/2, decide_safeguards/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_fixtures, [gdpr_art89_research_safeguards_profile_for/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_kernel, [gdpr_art89_research_safeguards_input_problems/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    safeguards_status_status(Profile, in_accordance).
test(bound_unmet_list_holds) :-
    gdpr_art89_research_safeguards_profile_for(no_measures, Profile),
    unmet_requirements(Profile, [measures]).
test(bound_indeterminate_purpose) :-
    gdpr_art89_research_safeguards_profile_for(purpose_absent, Profile),
    safeguards_status_status(Profile, indeterminate([purpose])).
test(unknown_key_is_an_input_problem) :-
    gdpr_art89_research_safeguards_profile_for(unknown_key_given, Profile),
    gdpr_art89_research_safeguards_input_problems(Profile, [unknown_key(extra_note)]).
test(input_problem_status_and_empty_unmet) :-
    gdpr_art89_research_safeguards_profile_for(unknown_key_given, Profile),
    safeguards_status_status(Profile, input_problems([unknown_key(extra_note)])),
    unmet_requirements(Profile, []).
test(wrong_type_is_named) :-
    gdpr_art89_research_safeguards_input_problems([attribute(purpose, bogus)], [wrong_type(purpose)]).
test(unsure_on_a_crisp_key_is_a_wrong_type) :-
    gdpr_art89_research_safeguards_input_problems([attribute(minimisation_measures_in_place, unsure)], [wrong_type(minimisation_measures_in_place)]).
test(unsure_on_a_judgement_key_is_well_formed) :-
    gdpr_art89_research_safeguards_input_problems([attribute(safeguards_appropriate, unsure)], []).
test(duplicate_key_is_named_once) :-
    gdpr_art89_research_safeguards_input_problems([attribute(purpose, statistical), attribute(purpose, other_purpose)], [duplicate_key(purpose)]).
test(duplicate_key_gives_the_input_problems_verdict) :-
    decide_safeguards([attribute(purpose, statistical), attribute(purpose, other_purpose)], gdpr_art89_verdict(input_problems([duplicate_key(purpose)]), [], [])).
test(contract_key_order_then_unknown_keys) :-
    gdpr_art89_research_safeguards_input_problems([attribute(zzz_extra, 1), attribute(purpose, bogus)], [wrong_type(purpose), unknown_key(zzz_extra)]).
test(not_an_attribute_list) :-
    gdpr_art89_research_safeguards_input_problems(foo, [wrong_type(profile)]),
    decide_safeguards(foo, gdpr_art89_verdict(input_problems([wrong_type(profile)]), [], [])).
test(absence_is_not_a_problem) :-
    gdpr_art89_research_safeguards_input_problems([], []).
test(a_clean_profile_has_no_problem) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    gdpr_art89_research_safeguards_input_problems(Profile, []).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    safeguards_status_status(Profile, not_in_accordance).
test(a_wrong_bound_unmet_list_is_rejected, fail) :-
    gdpr_art89_research_safeguards_profile_for(no_measures, Profile),
    unmet_requirements(Profile, [minimisation]).

cp_test_names([status_holds_with_the_verdict_bound, bound_unmet_list_holds, bound_indeterminate_purpose, unknown_key_is_an_input_problem, input_problem_status_and_empty_unmet, wrong_type_is_named, unsure_on_a_crisp_key_is_a_wrong_type, unsure_on_a_judgement_key_is_well_formed, duplicate_key_is_named_once, duplicate_key_gives_the_input_problems_verdict, contract_key_order_then_unknown_keys, not_an_attribute_list, absence_is_not_a_problem, a_clean_profile_has_no_problem]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, a_wrong_bound_unmet_list_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
