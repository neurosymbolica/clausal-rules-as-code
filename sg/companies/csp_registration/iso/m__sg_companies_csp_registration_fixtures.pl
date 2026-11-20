% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_fixtures, [csp_registration_subject/1, csp_registration_profile_for/2, csp_registration_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__sg_companies_csp_registration_csp_registration, [csp_assessment/2]).

csp_registration_subject(no_service).
csp_registration_subject(no_service_near_miss).
csp_registration_subject(not_in_singapore).
csp_registration_subject(not_in_singapore_near_miss).
csp_registration_subject(fully_registered).
csp_registration_subject(fully_registered_near_miss).
csp_registration_subject(deemed_accounting).
csp_registration_subject(deemed_accounting_near_miss).
csp_registration_subject(nominee_complied).
csp_registration_subject(nominee_breached).
csp_registration_subject(nominee_not_applicable).
csp_registration_subject(missing_activities).
csp_registration_subject(missing_carries).
csp_registration_subject(listed_shareholder).
csp_registration_subject(unlisted_shareholder).

csp_registration_profile_for(no_service, Profile) :-
    dict_pairs(Profile, [activities - [], carries_on_business_in_singapore - true, registered_service_types - []]).
csp_registration_profile_for(no_service_near_miss, Profile) :-
    dict_pairs(Profile, [activities - [forms_legal_person_for_another], carries_on_business_in_singapore - true, registered_service_types - []]).
csp_registration_profile_for(not_in_singapore, Profile) :-
    dict_pairs(Profile, [activities - [forms_legal_person_for_another], carries_on_business_in_singapore - false, registered_service_types - []]).
csp_registration_profile_for(not_in_singapore_near_miss, Profile) :-
    dict_pairs(Profile, [activities - [forms_legal_person_for_another], carries_on_business_in_singapore - true, registered_service_types - []]).
csp_registration_profile_for(fully_registered, Profile) :-
    dict_pairs(Profile, [activities - [forms_legal_person_for_another, provides_registered_office_or_address], carries_on_business_in_singapore - true, registered_service_types - [formation, address]]).
csp_registration_profile_for(fully_registered_near_miss, Profile) :-
    dict_pairs(Profile, [activities - [forms_legal_person_for_another, provides_registered_office_or_address], carries_on_business_in_singapore - true, registered_service_types - [formation]]).
csp_registration_profile_for(deemed_accounting, Profile) :-
    dict_pairs(Profile, [activities - [designated_activity_with_accounting_service], carries_on_business_in_singapore - true, registered_service_types - [], is_accounting_entity - true, accounting_service_is_own - true]).
csp_registration_profile_for(deemed_accounting_near_miss, Profile) :-
    dict_pairs(Profile, [activities - [designated_activity_with_accounting_service], carries_on_business_in_singapore - true, registered_service_types - [], is_accounting_entity - true, accounting_service_is_own - false]).
csp_registration_profile_for(nominee_complied, Profile) :-
    dict_pairs(Profile, [activities - [], carries_on_business_in_singapore - true, registered_service_types - [director_secretary], arranges_nominee_director - true, satisfied_nominee_fit_and_proper - true, took_reasonable_steps_on_disqualification - true, considered_prescribed_factors - true]).
csp_registration_profile_for(nominee_breached, Profile) :-
    dict_pairs(Profile, [activities - [], carries_on_business_in_singapore - true, registered_service_types - [director_secretary], arranges_nominee_director - true, satisfied_nominee_fit_and_proper - false, took_reasonable_steps_on_disqualification - true, considered_prescribed_factors - true]).
csp_registration_profile_for(nominee_not_applicable, Profile) :-
    dict_pairs(Profile, [activities - [], carries_on_business_in_singapore - true, registered_service_types - [], arranges_nominee_director - true]).
csp_registration_profile_for(missing_activities, Profile) :-
    dict_pairs(Profile, [carries_on_business_in_singapore - true, registered_service_types - []]).
csp_registration_profile_for(missing_carries, Profile) :-
    dict_pairs(Profile, [activities - [], registered_service_types - []]).
csp_registration_profile_for(listed_shareholder, Profile) :-
    dict_pairs(Profile, [activities - [nominee_shareholder_for_listed_corporation], carries_on_business_in_singapore - true, registered_service_types - []]).
csp_registration_profile_for(unlisted_shareholder, Profile) :-
    dict_pairs(Profile, [activities - [nominee_shareholder_for_unlisted_corporation], carries_on_business_in_singapore - true, registered_service_types - []]).

csp_registration_assess(Subject, Result) :-
    csp_registration_profile_for(Subject, Profile),
    csp_assessment(Profile, Result).
