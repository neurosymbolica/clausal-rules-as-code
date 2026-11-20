% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_csp_registration_csp_registration, [csp_assessment/2, csp_registration_status/2, csp_registration_checklist/2, csp_registration_decision_resolvable/1, csp_registration_status_values/1]).
:- use_module(m__sg_companies_csp_registration_fixtures, [csp_registration_subject/1, csp_registration_profile_for/2, csp_registration_assess/2]).

test(missing_activities_is_indeterminate) :-
    csp_registration_profile_for(missing_activities, Profile),
    csp_assessment(Profile, csp(indeterminate, [], [], n_a, [])).
test(missing_carries_is_indeterminate) :-
    csp_registration_profile_for(missing_carries, Profile),
    csp_assessment(Profile, csp(indeterminate, [], [], n_a, [])).
test(missing_activities_status_is_indeterminate) :-
    csp_registration_profile_for(missing_activities, Profile),
    csp_registration_status(Profile, indeterminate).
test(missing_carries_status_is_indeterminate) :-
    csp_registration_profile_for(missing_carries, Profile),
    csp_registration_status(Profile, indeterminate).
test(no_service_is_no_corporate_service) :-
    csp_registration_profile_for(no_service, Profile),
    csp_assessment(Profile, csp(no_corporate_service, [], [], not_applicable, [sg_cspa_2024_s2_1_corporate_service])).
test(no_service_status) :-
    csp_registration_profile_for(no_service, Profile),
    csp_registration_status(Profile, no_corporate_service).
test(listed_shareholder_is_no_corporate_service) :-
    csp_registration_profile_for(listed_shareholder, Profile),
    csp_assessment(Profile, csp(no_corporate_service, [], [], not_applicable, [sg_cspa_2024_s2_1_corporate_service])).
test(listed_shareholder_status) :-
    csp_registration_profile_for(listed_shareholder, Profile),
    csp_registration_status(Profile, no_corporate_service).
test(no_service_near_miss_is_registration_required) :-
    csp_registration_profile_for(no_service_near_miss, Profile),
    csp_assessment(Profile, csp(registration_required, [formation], [formation], not_applicable, [sg_cspa_2024_s7_1])).
test(no_service_near_miss_status) :-
    csp_registration_profile_for(no_service_near_miss, Profile),
    csp_registration_status(Profile, registration_required).
test(not_in_singapore_is_not_carrying) :-
    csp_registration_profile_for(not_in_singapore, Profile),
    csp_assessment(Profile, csp(not_carrying_on_business_in_singapore, [formation], [], not_applicable, [sg_cspa_2024_s7_1])).
test(not_in_singapore_status) :-
    csp_registration_profile_for(not_in_singapore, Profile),
    csp_registration_status(Profile, not_carrying_on_business_in_singapore).
test(not_in_singapore_near_miss_is_registration_required) :-
    csp_registration_profile_for(not_in_singapore_near_miss, Profile),
    csp_assessment(Profile, csp(registration_required, [formation], [formation], not_applicable, [sg_cspa_2024_s7_1])).
test(not_in_singapore_near_miss_status) :-
    csp_registration_profile_for(not_in_singapore_near_miss, Profile),
    csp_registration_status(Profile, registration_required).
test(fully_registered_is_registered) :-
    csp_registration_profile_for(fully_registered, Profile),
    csp_assessment(Profile, csp(registered, [formation, address], [], not_applicable, [sg_cspa_2024_s7_1])).
test(fully_registered_status) :-
    csp_registration_profile_for(fully_registered, Profile),
    csp_registration_status(Profile, registered).
test(fully_registered_near_miss_is_registration_required) :-
    csp_registration_profile_for(fully_registered_near_miss, Profile),
    csp_assessment(Profile, csp(registration_required, [formation, address], [address], not_applicable, [sg_cspa_2024_s7_1])).
test(fully_registered_near_miss_status) :-
    csp_registration_profile_for(fully_registered_near_miss, Profile),
    csp_registration_status(Profile, registration_required).
test(deemed_accounting_is_registered) :-
    csp_registration_profile_for(deemed_accounting, Profile),
    csp_assessment(Profile, csp(registered, [designated_accounting], [], not_applicable, [sg_cspa_2024_s7_1, sg_cspa_2024_s7_2])).
test(deemed_accounting_status) :-
    csp_registration_profile_for(deemed_accounting, Profile),
    csp_registration_status(Profile, registered).
test(deemed_accounting_near_miss_is_registration_required) :-
    csp_registration_profile_for(deemed_accounting_near_miss, Profile),
    csp_assessment(Profile, csp(registration_required, [designated_accounting], [designated_accounting], not_applicable, [sg_cspa_2024_s7_1])).
test(deemed_accounting_near_miss_status) :-
    csp_registration_profile_for(deemed_accounting_near_miss, Profile),
    csp_registration_status(Profile, registration_required).
test(nominee_complied_is_registered_complied) :-
    csp_registration_profile_for(nominee_complied, Profile),
    csp_assessment(Profile, csp(registered, [director_secretary], [], complied, [sg_cspa_2024_s7_1, sg_cspa_2024_s16_1, sg_cspa_2024_s16_2])).
test(nominee_complied_status) :-
    csp_registration_profile_for(nominee_complied, Profile),
    csp_registration_status(Profile, registered).
test(nominee_breached_is_registered_breached) :-
    csp_registration_profile_for(nominee_breached, Profile),
    csp_assessment(Profile, csp(registered, [director_secretary], [], breached, [sg_cspa_2024_s7_1, sg_cspa_2024_s16_1, sg_cspa_2024_s16_2])).
test(nominee_breached_status) :-
    csp_registration_profile_for(nominee_breached, Profile),
    csp_registration_status(Profile, registered).
test(nominee_not_applicable_is_registration_required) :-
    csp_registration_profile_for(nominee_not_applicable, Profile),
    csp_assessment(Profile, csp(registration_required, [director_secretary], [director_secretary], not_applicable, [sg_cspa_2024_s7_1])).
test(nominee_not_applicable_status) :-
    csp_registration_profile_for(nominee_not_applicable, Profile),
    csp_registration_status(Profile, registration_required).
test(unlisted_shareholder_is_registration_required) :-
    csp_registration_profile_for(unlisted_shareholder, Profile),
    csp_assessment(Profile, csp(registration_required, [nominee_shareholder], [nominee_shareholder], not_applicable, [sg_cspa_2024_s7_1])).
test(unlisted_shareholder_status) :-
    csp_registration_profile_for(unlisted_shareholder, Profile),
    csp_registration_status(Profile, registration_required).
test(checklist_is_non_empty_on_registered) :-
    csp_registration_profile_for(fully_registered, Profile),
    csp_registration_checklist(Profile, Checklist),
    Checklist \= [].
test(checklist_is_non_empty_on_indeterminate) :-
    csp_registration_profile_for(missing_activities, Profile),
    csp_registration_checklist(Profile, Checklist),
    Checklist \= [].
test(checklist_is_non_empty_on_nominee_complied) :-
    csp_registration_profile_for(nominee_complied, Profile),
    csp_registration_checklist(Profile, Checklist),
    Checklist \= [].
test(decision_resolvable_on_registered) :-
    csp_registration_profile_for(fully_registered, Profile),
    csp_registration_decision_resolvable(Profile).
test(decision_resolvable_on_indeterminate) :-
    csp_registration_profile_for(missing_activities, Profile),
    csp_registration_decision_resolvable(Profile).
test(decision_resolvable_on_nominee_breached) :-
    csp_registration_profile_for(nominee_breached, Profile),
    csp_registration_decision_resolvable(Profile).
test(status_values_are_complete) :-
    csp_registration_status_values(StatusValues),
    member(no_corporate_service, StatusValues),
    member(not_carrying_on_business_in_singapore, StatusValues),
    member(registered, StatusValues),
    member(registration_required, StatusValues),
    member(indeterminate, StatusValues).

test(no_service_is_not_registered, fail) :-
    csp_registration_profile_for(no_service, Profile),
    csp_registration_status(Profile, registered).
test(fully_registered_is_not_registration_required, fail) :-
    csp_registration_profile_for(fully_registered, Profile),
    csp_registration_status(Profile, registration_required).
test(nominee_complied_is_not_breached, fail) :-
    csp_registration_profile_for(nominee_complied, Profile),
    csp_assessment(Profile, csp(registered, [director_secretary], [], breached, _Citations)).
test(nominee_breached_is_not_complied, fail) :-
    csp_registration_profile_for(nominee_breached, Profile),
    csp_assessment(Profile, csp(registered, [director_secretary], [], complied, _Citations)).
test(missing_activities_is_not_no_corporate_service, fail) :-
    csp_registration_profile_for(missing_activities, Profile),
    csp_registration_status(Profile, no_corporate_service).
test(deemed_accounting_is_not_registration_required, fail) :-
    csp_registration_profile_for(deemed_accounting, Profile),
    csp_registration_status(Profile, registration_required).

cp_test_names([missing_activities_is_indeterminate, missing_carries_is_indeterminate, missing_activities_status_is_indeterminate, missing_carries_status_is_indeterminate, no_service_is_no_corporate_service, no_service_status, listed_shareholder_is_no_corporate_service, listed_shareholder_status, no_service_near_miss_is_registration_required, no_service_near_miss_status, not_in_singapore_is_not_carrying, not_in_singapore_status, not_in_singapore_near_miss_is_registration_required, not_in_singapore_near_miss_status, fully_registered_is_registered, fully_registered_status, fully_registered_near_miss_is_registration_required, fully_registered_near_miss_status, deemed_accounting_is_registered, deemed_accounting_status, deemed_accounting_near_miss_is_registration_required, deemed_accounting_near_miss_status, nominee_complied_is_registered_complied, nominee_complied_status, nominee_breached_is_registered_breached, nominee_breached_status, nominee_not_applicable_is_registration_required, nominee_not_applicable_status, unlisted_shareholder_is_registration_required, unlisted_shareholder_status, checklist_is_non_empty_on_registered, checklist_is_non_empty_on_indeterminate, checklist_is_non_empty_on_nominee_complied, decision_resolvable_on_registered, decision_resolvable_on_indeterminate, decision_resolvable_on_nominee_breached, status_values_are_complete]).
cp_test_fail_names([no_service_is_not_registered, fully_registered_is_not_registration_required, nominee_complied_is_not_breached, nominee_breached_is_not_complied, missing_activities_is_not_no_corporate_service, deemed_accounting_is_not_registration_required]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
