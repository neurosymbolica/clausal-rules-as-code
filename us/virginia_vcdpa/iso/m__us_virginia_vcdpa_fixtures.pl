% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_virginia_vcdpa_fixtures, [virginia_vcdpa_subject/1, virginia_vcdpa_profile_for/2, virginia_vcdpa_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_virginia_vcdpa_virginia_vcdpa, [decide_virginia_vcdpa/2]).

virginia_vcdpa_subject(large_virginia_controller).
virginia_vcdpa_subject(exactly_general_threshold).
virginia_vcdpa_subject(just_below_general_threshold).
virginia_vcdpa_subject(exactly_sale_threshold).
virginia_vcdpa_subject(just_below_sale_threshold).
virginia_vcdpa_subject(data_broker_mid_size).
virginia_vcdpa_subject(mid_size_not_broker).
virginia_vcdpa_subject(no_business_link).
virginia_vcdpa_subject(hospital_hipaa).
virginia_vcdpa_subject(state_agency).
virginia_vcdpa_subject(charity_nonprofit).
virginia_vcdpa_subject(unsure_business_link).
virginia_vcdpa_subject(unsure_business_link_small_count).
virginia_vcdpa_subject(empty_profile).
virginia_vcdpa_subject(missing_consumer_count).
virginia_vcdpa_subject(missing_revenue_share).
virginia_vcdpa_subject(missing_business_link).
virginia_vcdpa_subject(malformed_profile).

virginia_vcdpa_profile_for(large_virginia_controller, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 150000)]).
virginia_vcdpa_profile_for(exactly_general_threshold, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 100000), attribute(over_half_of_gross_revenue_from_sale, false)]).
virginia_vcdpa_profile_for(just_below_general_threshold, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 99999), attribute(over_half_of_gross_revenue_from_sale, false)]).
virginia_vcdpa_profile_for(exactly_sale_threshold, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 25000), attribute(over_half_of_gross_revenue_from_sale, true)]).
virginia_vcdpa_profile_for(just_below_sale_threshold, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 24999), attribute(over_half_of_gross_revenue_from_sale, true)]).
virginia_vcdpa_profile_for(data_broker_mid_size, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 30000), attribute(over_half_of_gross_revenue_from_sale, true)]).
virginia_vcdpa_profile_for(mid_size_not_broker, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 30000), attribute(over_half_of_gross_revenue_from_sale, false)]).
virginia_vcdpa_profile_for(no_business_link, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, false), attribute(consumer_count, 150000)]).
virginia_vcdpa_profile_for(hospital_hipaa, [attribute(entity_category, hipaa_covered_entity_or_business_associate), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 150000)]).
virginia_vcdpa_profile_for(state_agency, [attribute(entity_category, public_body_of_the_commonwealth)]).
virginia_vcdpa_profile_for(charity_nonprofit, [attribute(entity_category, nonprofit_organization), attribute(conducts_business_in_or_targets_virginia, unsure), attribute(consumer_count, 500000)]).
virginia_vcdpa_profile_for(unsure_business_link, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, unsure), attribute(consumer_count, 150000)]).
virginia_vcdpa_profile_for(unsure_business_link_small_count, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, unsure), attribute(consumer_count, 24999)]).
virginia_vcdpa_profile_for(empty_profile, []).
virginia_vcdpa_profile_for(missing_consumer_count, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true)]).
virginia_vcdpa_profile_for(missing_revenue_share, [attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 30000)]).
virginia_vcdpa_profile_for(missing_business_link, [attribute(entity_category, none_of_the_exempt_categories), attribute(consumer_count, 150000)]).
virginia_vcdpa_profile_for(malformed_profile, [attribute(colour, red)]).

virginia_vcdpa_assess(Subject, Result) :-
    virginia_vcdpa_profile_for(Subject, Profile),
    decide_virginia_vcdpa(Profile, Result).
