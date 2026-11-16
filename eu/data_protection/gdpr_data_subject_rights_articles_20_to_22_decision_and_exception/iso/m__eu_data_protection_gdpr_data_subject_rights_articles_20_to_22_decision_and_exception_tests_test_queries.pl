% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_queries, [request_decision/2, request_exception/2, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_keys/1, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if/4, suspended/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_exception_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_keys(ProfileKeys),
    length(ProfileKeys, 54),
    ProfileKeys = [request_type, objection_ground_claimed, request_received_on|_].
test(compliance_check_complies) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    request_decision(Profile, must_comply).
test(compliance_check_is_single) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    findall(Comply, request_decision(Profile, Comply), Answers),
    Answers == [must_comply].
test(exception_query) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_rights_of_others, Profile),
    request_exception(Profile, art20_4_rights_of_others).
test(input_check_clean) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, []).
test(input_check_unknown_key) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(unknown_key_problem, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, [unknown_key(not_a_contract_key)]).
test(input_check_not_an_attribute_list) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(not_a_list, [wrong_type(profile)]).
test(suspended_constructor) :-
    suspended(art12_6_identity_not_confirmed).
test(what_if_flips_engagement) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, processing_carried_out_by_automated_means, false, need_not_comply).
test(what_if_unchanged_baseline) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, processing_carried_out_by_automated_means, true, must_comply).
test(what_if_adds_an_exception) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, processing_necessary_for_public_task_or_official_authority, true, need_not_comply).
test(what_if_unsure_refers) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_art21_1_engaged, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, objection_grounds_relate_to_particular_situation, unsure, needs_legal_review(_, _)).
test(what_if_is_single) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    findall(Comply, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, processing_carried_out_by_automated_means, false, Comply), Answers),
    Answers == [need_not_comply].
test(what_if_does_not_mutate_the_original) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, processing_carried_out_by_automated_means, false, _),
    request_decision(Profile, must_comply).
test(justification_checklist_carries_cite_items) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    request_exception_checklist(Profile, [item(engagement, met, cite(eu_reg_2016_679_art_20_1)), item(suspension, unmet(not_satisfied), cite(eu_reg_2016_679_art_12_6))|Rest]),
    length(Rest, 5).
test(justification_checklist_marks_the_met_exception) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_public_task, Profile),
    request_exception_checklist(Profile, Items),
    member(item(art20_3_public_task, met, cite(eu_reg_2016_679_art_20_3)), Items).
test(justification_checklist_is_single) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    findall(Items, request_exception_checklist(Profile, Items), Answers),
    length(Answers, 1).
test(justification_checklist_empty_on_input_problems) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(unknown_key_problem, Profile),
    request_exception_checklist(Profile, []).

cp_test_names([profile_keys_are_the_contract_keys, compliance_check_complies, compliance_check_is_single, exception_query, input_check_clean, input_check_unknown_key, input_check_not_an_attribute_list, suspended_constructor, what_if_flips_engagement, what_if_unchanged_baseline, what_if_adds_an_exception, what_if_unsure_refers, what_if_is_single, what_if_does_not_mutate_the_original, justification_checklist_carries_cite_items, justification_checklist_marks_the_met_exception, justification_checklist_is_single, justification_checklist_empty_on_input_problems]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
