% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_notice_consent_fixtures, [dpdp_notice_consent_subject/1, dpdp_notice_consent_profile_for/2, dpdp_notice_consent_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_notice_consent_dpdp_notice_consent, [decide_dpdp_notice_consent/2]).

dpdp_notice_consent_subject(consent_lawful).
dpdp_notice_consent_subject(consent_withdrawn).
dpdp_notice_consent_subject(consent_not_given).
dpdp_notice_consent_subject(consent_purpose_forbidden).
dpdp_notice_consent_subject(consent_fails_section_6_1).
dpdp_notice_consent_subject(consent_sections_not_in_force).
dpdp_notice_consent_subject(consent_in_force_absent).
dpdp_notice_consent_subject(consent_withdrawal_absent).
dpdp_notice_consent_subject(consent_purpose_unsure).
dpdp_notice_consent_subject(consent_section_6_1_unsure).
dpdp_notice_consent_subject(consent_wrong_type).
dpdp_notice_consent_subject(consent_duplicate_key).
dpdp_notice_consent_subject(consent_unknown_key).
dpdp_notice_consent_subject(legitimate_use_employment).
dpdp_notice_consent_subject(legitimate_use_conditions_unmet).
dpdp_notice_consent_subject(legitimate_use_no_listed_use).
dpdp_notice_consent_subject(legitimate_use_conditions_unsure).
dpdp_notice_consent_subject(notice_request_before_rule_3).
dpdp_notice_consent_subject(notice_request_on_rule_3_day).
dpdp_notice_consent_subject(notice_earlier_consent_before_rule_3).
dpdp_notice_consent_subject(notice_earlier_consent_on_rule_3_day).
dpdp_notice_consent_subject(notice_processor).
dpdp_notice_consent_subject(notice_no_occasion).
dpdp_notice_consent_subject(notice_fiduciary_unsure).
dpdp_notice_consent_subject(withdrawal_cease).
dpdp_notice_consent_subject(withdrawal_may_continue).
dpdp_notice_consent_subject(withdrawal_not_withdrawn).
dpdp_notice_consent_subject(withdrawal_law_unsure).
dpdp_notice_consent_subject(manager_registered).
dpdp_notice_consent_subject(manager_suspended).
dpdp_notice_consent_subject(manager_unregistered).
dpdp_notice_consent_subject(manager_section_not_in_force).

dpdp_notice_consent_profile_for(consent_lawful, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(consent_given, true), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_withdrawn, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(consent_given, true), attribute(consent_withdrawn, true), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_not_given, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(consent_given, false), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_purpose_forbidden, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, false), attribute(consent_given, true), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_fails_section_6_1, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(consent_given, true), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, false)]).
dpdp_notice_consent_profile_for(consent_sections_not_in_force, [attribute(sections_4_to_7_in_force, false), attribute(lawful_purpose, true), attribute(consent_given, true), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_in_force_absent, [attribute(lawful_purpose, true), attribute(consent_given, true), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_withdrawal_absent, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(consent_given, true), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_purpose_unsure, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, unsure), attribute(consent_given, true), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_section_6_1_unsure, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(consent_given, true), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, unsure)]).
dpdp_notice_consent_profile_for(consent_wrong_type, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(consent_given, unsure), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_duplicate_key, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(consent_given, true), attribute(consent_given, false), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, true)]).
dpdp_notice_consent_profile_for(consent_unknown_key, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(consent_given, true), attribute(consent_withdrawn, false), attribute(consent_meets_section_6_1, true), attribute(colour, red)]).
dpdp_notice_consent_profile_for(legitimate_use_employment, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(legitimate_use_clause, employment_purposes), attribute(legitimate_use_conditions_met, true)]).
dpdp_notice_consent_profile_for(legitimate_use_conditions_unmet, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(legitimate_use_clause, employment_purposes), attribute(legitimate_use_conditions_met, false)]).
dpdp_notice_consent_profile_for(legitimate_use_no_listed_use, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(legitimate_use_clause, no_listed_use), attribute(legitimate_use_conditions_met, true)]).
dpdp_notice_consent_profile_for(legitimate_use_conditions_unsure, [attribute(sections_4_to_7_in_force, true), attribute(lawful_purpose, true), attribute(legitimate_use_clause, employment_purposes), attribute(legitimate_use_conditions_met, unsure)]).
dpdp_notice_consent_profile_for(notice_request_before_rule_3, [attribute(sections_4_to_7_in_force, true), attribute(question_date, date(2027, 5, 12)), attribute(acts_as_data_fiduciary, true), attribute(notice_occasion, request_for_consent)]).
dpdp_notice_consent_profile_for(notice_request_on_rule_3_day, [attribute(sections_4_to_7_in_force, true), attribute(question_date, date(2027, 5, 13)), attribute(acts_as_data_fiduciary, true), attribute(notice_occasion, request_for_consent)]).
dpdp_notice_consent_profile_for(notice_earlier_consent_before_rule_3, [attribute(sections_4_to_7_in_force, true), attribute(question_date, date(2027, 5, 12)), attribute(acts_as_data_fiduciary, true), attribute(notice_occasion, consent_given_before_commencement)]).
dpdp_notice_consent_profile_for(notice_earlier_consent_on_rule_3_day, [attribute(sections_4_to_7_in_force, true), attribute(question_date, date(2027, 5, 13)), attribute(acts_as_data_fiduciary, true), attribute(notice_occasion, consent_given_before_commencement)]).
dpdp_notice_consent_profile_for(notice_processor, [attribute(sections_4_to_7_in_force, true), attribute(question_date, date(2027, 5, 13)), attribute(acts_as_data_fiduciary, false), attribute(notice_occasion, request_for_consent)]).
dpdp_notice_consent_profile_for(notice_no_occasion, [attribute(sections_4_to_7_in_force, true), attribute(question_date, date(2027, 5, 13)), attribute(acts_as_data_fiduciary, true), attribute(notice_occasion, no_notice_occasion)]).
dpdp_notice_consent_profile_for(notice_fiduciary_unsure, [attribute(sections_4_to_7_in_force, true), attribute(question_date, date(2027, 6, 1)), attribute(acts_as_data_fiduciary, unsure), attribute(notice_occasion, request_for_consent)]).
dpdp_notice_consent_profile_for(withdrawal_cease, [attribute(sections_4_to_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(consent_withdrawn, true), attribute(processing_required_or_authorised_by_law, false)]).
dpdp_notice_consent_profile_for(withdrawal_may_continue, [attribute(sections_4_to_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(consent_withdrawn, true), attribute(processing_required_or_authorised_by_law, true)]).
dpdp_notice_consent_profile_for(withdrawal_not_withdrawn, [attribute(sections_4_to_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(consent_withdrawn, false), attribute(processing_required_or_authorised_by_law, false)]).
dpdp_notice_consent_profile_for(withdrawal_law_unsure, [attribute(sections_4_to_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(consent_withdrawn, true), attribute(processing_required_or_authorised_by_law, unsure)]).
dpdp_notice_consent_profile_for(manager_registered, [attribute(section_6_9_in_force, true), attribute(registered_with_board_as_consent_manager, true), attribute(consent_manager_registration_suspended_or_cancelled, false)]).
dpdp_notice_consent_profile_for(manager_suspended, [attribute(section_6_9_in_force, true), attribute(registered_with_board_as_consent_manager, true), attribute(consent_manager_registration_suspended_or_cancelled, true)]).
dpdp_notice_consent_profile_for(manager_unregistered, [attribute(section_6_9_in_force, true), attribute(registered_with_board_as_consent_manager, false), attribute(consent_manager_registration_suspended_or_cancelled, false)]).
dpdp_notice_consent_profile_for(manager_section_not_in_force, [attribute(section_6_9_in_force, false), attribute(registered_with_board_as_consent_manager, true), attribute(consent_manager_registration_suspended_or_cancelled, false)]).

dpdp_notice_consent_assess(Subject, Result) :-
    dpdp_notice_consent_profile_for(Subject, Profile),
    decide_dpdp_notice_consent(Profile, Result).
