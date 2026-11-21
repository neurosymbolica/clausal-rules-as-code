% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_colorado_cpa_fixtures, [colorado_cpa_subject/1, colorado_cpa_profile_for/2, colorado_cpa_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_colorado_cpa_colorado_cpa, [decide_colorado_cpa/2]).

colorado_cpa_subject(large_linked_controller).
colorado_cpa_subject(controller_just_below_general_threshold).
colorado_cpa_subject(sale_controller_at_threshold).
colorado_cpa_subject(sale_controller_just_below_threshold).
colorado_cpa_subject(small_controller_with_biometric_data).
colorado_cpa_subject(unlinked_controller_with_biometric_data).
colorado_cpa_subject(unlinked_controller_without_biometric_data).
colorado_cpa_subject(glba_financial_institution).
colorado_cpa_subject(regulated_air_carrier).
colorado_cpa_subject(registered_securities_association).
colorado_cpa_subject(controller_with_unsure_link).
colorado_cpa_subject(controller_with_unsure_link_and_biometric_data_unknown).
colorado_cpa_subject(controller_without_entity_category).
colorado_cpa_subject(middle_count_controller_without_revenue_fact).
colorado_cpa_subject(controller_with_unlisted_entity_category).
colorado_cpa_subject(controller_with_duplicated_count).
colorado_cpa_subject(minors_linked_controller).
colorado_cpa_subject(minors_unlinked_controller).
colorado_cpa_subject(minors_unsure_link_controller).
colorado_cpa_subject(response_extension_granted).
colorado_cpa_subject(response_extension_notice_late).
colorado_cpa_subject(response_extension_necessity_unsure).
colorado_cpa_subject(appeal_extension_granted).
colorado_cpa_subject(appeal_extension_not_necessary).
colorado_cpa_subject(appeal_extension_necessity_unsure).
colorado_cpa_subject(minors_enforcement_uncured).
colorado_cpa_subject(minors_enforcement_cured).
colorado_cpa_subject(minors_enforcement_cure_impossible).
colorado_cpa_subject(minors_enforcement_cure_unknown).
colorado_cpa_subject(targeted_advertising_controller).
colorado_cpa_subject(controller_without_targeted_advertising).

colorado_cpa_profile_for(large_linked_controller, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 100000), attribute(revenue_or_discount_from_sale, false), attribute(processes_biometric_data, false)]).
colorado_cpa_profile_for(controller_just_below_general_threshold, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 99999), attribute(revenue_or_discount_from_sale, false), attribute(processes_biometric_data, false)]).
colorado_cpa_profile_for(sale_controller_at_threshold, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 25000), attribute(revenue_or_discount_from_sale, true), attribute(processes_biometric_data, false)]).
colorado_cpa_profile_for(sale_controller_just_below_threshold, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 24999), attribute(revenue_or_discount_from_sale, true), attribute(processes_biometric_data, false)]).
colorado_cpa_profile_for(small_controller_with_biometric_data, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 24999), attribute(revenue_or_discount_from_sale, true), attribute(processes_biometric_data, true)]).
colorado_cpa_profile_for(unlinked_controller_with_biometric_data, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, false), attribute(consumer_count, 500000), attribute(processes_biometric_data, true)]).
colorado_cpa_profile_for(unlinked_controller_without_biometric_data, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, false), attribute(consumer_count, 500000), attribute(processes_biometric_data, false)]).
colorado_cpa_profile_for(glba_financial_institution, [attribute(entity_category, financial_institution_or_affiliate_subject_to_glba), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 500000), attribute(colorado_link_for_minors_duties, true)]).
colorado_cpa_profile_for(regulated_air_carrier, [attribute(entity_category, air_carrier), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 500000)]).
colorado_cpa_profile_for(registered_securities_association, [attribute(entity_category, national_securities_association)]).
colorado_cpa_profile_for(controller_with_unsure_link, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, unsure), attribute(consumer_count, 200000), attribute(processes_biometric_data, false)]).
colorado_cpa_profile_for(controller_with_unsure_link_and_biometric_data_unknown, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, unsure), attribute(consumer_count, 200000)]).
colorado_cpa_profile_for(controller_without_entity_category, [attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 200000)]).
colorado_cpa_profile_for(middle_count_controller_without_revenue_fact, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 50000)]).
colorado_cpa_profile_for(controller_with_unlisted_entity_category, [attribute(entity_category, nonprofit_organization)]).
colorado_cpa_profile_for(controller_with_duplicated_count, [attribute(entity_category, none_of_the_exempt_categories), attribute(consumer_count, 1), attribute(consumer_count, 2)]).
colorado_cpa_profile_for(minors_linked_controller, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_minors_duties, true)]).
colorado_cpa_profile_for(minors_unlinked_controller, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_minors_duties, false)]).
colorado_cpa_profile_for(minors_unsure_link_controller, [attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_minors_duties, unsure)]).
colorado_cpa_profile_for(response_extension_granted, [attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, true)]).
colorado_cpa_profile_for(response_extension_notice_late, [attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, false)]).
colorado_cpa_profile_for(response_extension_necessity_unsure, [attribute(extension_reasonably_necessary, unsure), attribute(extension_notice_given_within_initial_period, true)]).
colorado_cpa_profile_for(appeal_extension_granted, [attribute(appeal_extension_reasonably_necessary, true), attribute(appeal_extension_notice_given_within_initial_period, true)]).
colorado_cpa_profile_for(appeal_extension_not_necessary, [attribute(appeal_extension_reasonably_necessary, false), attribute(appeal_extension_notice_given_within_initial_period, true)]).
colorado_cpa_profile_for(appeal_extension_necessity_unsure, [attribute(appeal_extension_reasonably_necessary, unsure), attribute(appeal_extension_notice_given_within_initial_period, true)]).
colorado_cpa_profile_for(minors_enforcement_uncured, [attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, true), attribute(cured_within_cure_period, false)]).
colorado_cpa_profile_for(minors_enforcement_cured, [attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, true), attribute(cured_within_cure_period, true)]).
colorado_cpa_profile_for(minors_enforcement_cure_impossible, [attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, false)]).
colorado_cpa_profile_for(minors_enforcement_cure_unknown, [attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, true)]).
colorado_cpa_profile_for(targeted_advertising_controller, [attribute(processes_for_targeted_advertising_or_sale, true)]).
colorado_cpa_profile_for(controller_without_targeted_advertising, [attribute(processes_for_targeted_advertising_or_sale, false)]).

colorado_cpa_assess(Subject, Result) :-
    colorado_cpa_profile_for(Subject, Profile),
    decide_colorado_cpa(Profile, Result).
