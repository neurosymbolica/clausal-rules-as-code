% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_fixtures, [uk_complaints_to_the_commissioner_subject/1, uk_complaints_to_the_commissioner_profile_for/2, uk_complaints_to_the_commissioner_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_complaints_to_the_commissioner_uk_complaints_to_the_commissioner, [decide_uk_complaints_to_the_commissioner/2]).

uk_complaints_to_the_commissioner_subject(gdpr_complaint_to_controller).
uk_complaints_to_the_commissioner_subject(part_3_complaint_to_controller).
uk_complaints_to_the_commissioner_subject(part_4_complaint_to_controller).
uk_complaints_to_the_commissioner_subject(complaint_to_processor).
uk_complaints_to_the_commissioner_subject(third_party_complaint).
uk_complaints_to_the_commissioner_subject(no_infringement_considered).
uk_complaints_to_the_commissioner_subject(recipient_not_stated).
uk_complaints_to_the_commissioner_subject(empty_profile).
uk_complaints_to_the_commissioner_subject(badly_typed_profile).
uk_complaints_to_the_commissioner_subject(duplicated_key_profile).

uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, [attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, uk_gdpr), attribute(complaint_made_to_the_controller, true)]).
uk_complaints_to_the_commissioner_profile_for(part_3_complaint_to_controller, [attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_3), attribute(complaint_made_to_the_controller, true)]).
uk_complaints_to_the_commissioner_profile_for(part_4_complaint_to_controller, [attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_4), attribute(complaint_made_to_the_controller, true)]).
uk_complaints_to_the_commissioner_profile_for(complaint_to_processor, [attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, uk_gdpr), attribute(complaint_made_to_the_controller, false)]).
uk_complaints_to_the_commissioner_profile_for(third_party_complaint, [attribute(complaint_by_data_subject_about_own_personal_data, false), attribute(infringement_considered, uk_gdpr), attribute(complaint_made_to_the_controller, true)]).
uk_complaints_to_the_commissioner_profile_for(no_infringement_considered, [attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, none_of_the_three), attribute(complaint_made_to_the_controller, true)]).
uk_complaints_to_the_commissioner_profile_for(recipient_not_stated, [attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, uk_gdpr)]).
uk_complaints_to_the_commissioner_profile_for(empty_profile, []).
uk_complaints_to_the_commissioner_profile_for(badly_typed_profile, [attribute(infringement_considered, gdpr), attribute(colour, red)]).
uk_complaints_to_the_commissioner_profile_for(duplicated_key_profile, [attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, uk_gdpr), attribute(infringement_considered, dpa_2018_part_3), attribute(complaint_made_to_the_controller, true)]).

uk_complaints_to_the_commissioner_assess(Subject, Result) :-
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile),
    decide_uk_complaints_to_the_commissioner(Profile, Result).
