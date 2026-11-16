% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_queries, [gdpr_data_subject_rights_automated_decision_profile_keys/1, gdpr_data_subject_rights_automated_decision_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_kernel, [gdpr_data_subject_rights_automated_decision_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_request_basis, [request_basis_checklist/2, decide_data_subject_request/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_fixtures, [gdpr_data_subject_rights_automated_decision_profile_for/2]).

item_cited(item(_, _, cite(_))).

all_cited([]).
all_cited([Item|Items]) :-
    item_cited(Item),
    all_cited(Items).

test(profile_keys_are_the_contract_keys) :-
    gdpr_data_subject_rights_automated_decision_profile_keys(ProfileKeys),
    length(ProfileKeys, 54),
    ProfileKeys = [request_type|_].
test(input_problems_empty_for_a_good_profile) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    gdpr_data_subject_rights_automated_decision_input_problems(Profile, []).
test(input_problems_names_the_unknown_key) :-
    gdpr_data_subject_rights_automated_decision_profile_for(unknown_key_input_problem, Profile),
    gdpr_data_subject_rights_automated_decision_input_problems(Profile, [unknown_key(bogus_key)]).
test(input_problems_for_a_non_list) :-
    gdpr_data_subject_rights_automated_decision_input_problems(not_a_profile, [wrong_type(profile)]).
test(compliance_check_gives_one_verdict) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    findall(Verdict, decide_data_subject_request(Profile, Verdict), Verdicts),
    length(Verdicts, 1).
test(justification_every_checklist_item_is_cited) :-
    gdpr_data_subject_rights_automated_decision_profile_for(contract_exception, Profile),
    request_basis_checklist(Profile, Items),
    Items = [_|_],
    all_cited(Items).
test(justification_checklist_marks_the_met_exception) :-
    gdpr_data_subject_rights_automated_decision_profile_for(contract_exception, Profile),
    request_basis_checklist(Profile, Items),
    member(item(art22_2_a, met, cite(eu_reg_2016_679_art_22_2_a)), Items).
test(justification_checklist_for_input_problems) :-
    gdpr_data_subject_rights_automated_decision_profile_for(unknown_key_input_problem, Profile),
    request_basis_checklist(Profile, [item(input_check, unmet, cite(_))]).
test(what_if_not_engaged_gives_none) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    gdpr_data_subject_rights_automated_decision_what_if(Profile, decision_produces_legal_or_similarly_significant_effects, false, none).
test(what_if_engaged_gives_art22_1) :-
    gdpr_data_subject_rights_automated_decision_profile_for(not_solely_automated, Profile),
    gdpr_data_subject_rights_automated_decision_what_if(Profile, decision_based_solely_on_automated_processing, true, art22_1).
test(what_if_leaves_the_original_unchanged) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    gdpr_data_subject_rights_automated_decision_what_if(Profile, decision_produces_legal_or_similarly_significant_effects, false, _),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(must_comply, _, _, _, _)).

test(what_if_wrong_status_is_rejected, fail) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    gdpr_data_subject_rights_automated_decision_what_if(Profile, decision_produces_legal_or_similarly_significant_effects, false, art22_1).

cp_test_names([profile_keys_are_the_contract_keys, input_problems_empty_for_a_good_profile, input_problems_names_the_unknown_key, input_problems_for_a_non_list, compliance_check_gives_one_verdict, justification_every_checklist_item_is_cited, justification_checklist_marks_the_met_exception, justification_checklist_for_input_problems, what_if_not_engaged_gives_none, what_if_engaged_gives_art22_1, what_if_leaves_the_original_unchanged]).
cp_test_fail_names([what_if_wrong_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
