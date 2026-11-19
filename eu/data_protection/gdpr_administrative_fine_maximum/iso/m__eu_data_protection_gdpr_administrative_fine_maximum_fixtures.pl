% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_subject/1, gdpr_administrative_fine_maximum_profile_for/2, gdpr_administrative_fine_maximum_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [decide_gdpr_administrative_fine_maximum/2]).

gdpr_administrative_fine_maximum_subject(lower_tier_turnover_at_tie).
gdpr_administrative_fine_maximum_subject(lower_tier_turnover_just_above_tie).
gdpr_administrative_fine_maximum_subject(higher_tier_turnover_at_tie).
gdpr_administrative_fine_maximum_subject(higher_tier_turnover_just_above_tie).
gdpr_administrative_fine_maximum_subject(non_undertaking_certification_body).
gdpr_administrative_fine_maximum_subject(undertaking_with_zero_turnover).
gdpr_administrative_fine_maximum_subject(supervisory_order_non_undertaking).
gdpr_administrative_fine_maximum_subject(combined_linked_and_intentional).
gdpr_administrative_fine_maximum_subject(separate_not_intentional_or_negligent).
gdpr_administrative_fine_maximum_subject(linked_operations_unsure).
gdpr_administrative_fine_maximum_subject(missing_turnover_unsure_undertaking).
gdpr_administrative_fine_maximum_subject(unsure_undertaking_with_turnover).
gdpr_administrative_fine_maximum_subject(unlisted_provision).
gdpr_administrative_fine_maximum_subject(listed_neighbour_provision).
gdpr_administrative_fine_maximum_subject(negative_turnover_rejected).
gdpr_administrative_fine_maximum_subject(zero_turnover_accepted).

gdpr_administrative_fine_maximum_profile_for(lower_tier_turnover_at_tie, [attribute(infringed_provisions, [article_30]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)]).
gdpr_administrative_fine_maximum_profile_for(lower_tier_turnover_just_above_tie, [attribute(infringed_provisions, [article_30]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000001)]).
gdpr_administrative_fine_maximum_profile_for(higher_tier_turnover_at_tie, [attribute(infringed_provisions, [article_17]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)]).
gdpr_administrative_fine_maximum_profile_for(higher_tier_turnover_just_above_tie, [attribute(infringed_provisions, [article_17]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000001)]).
gdpr_administrative_fine_maximum_profile_for(non_undertaking_certification_body, [attribute(infringed_provisions, [article_42]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(undertaking_with_zero_turnover, [attribute(infringed_provisions, [article_42]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 0)]).
gdpr_administrative_fine_maximum_profile_for(supervisory_order_non_undertaking, [attribute(infringed_provisions, [non_compliance_with_supervisory_authority_order]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(combined_linked_and_intentional, [attribute(infringed_provisions, [article_33, article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 400000000), attribute(infringements_concern_same_or_linked_processing_operations, true), attribute(infringements_intentional_or_negligent, true)]).
gdpr_administrative_fine_maximum_profile_for(separate_not_intentional_or_negligent, [attribute(infringed_provisions, [article_33, article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 400000000), attribute(infringements_concern_same_or_linked_processing_operations, true), attribute(infringements_intentional_or_negligent, false)]).
gdpr_administrative_fine_maximum_profile_for(linked_operations_unsure, [attribute(infringed_provisions, [article_33, article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 400000000), attribute(infringements_concern_same_or_linked_processing_operations, unsure), attribute(infringements_intentional_or_negligent, true)]).
gdpr_administrative_fine_maximum_profile_for(missing_turnover_unsure_undertaking, [attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, unsure)]).
gdpr_administrative_fine_maximum_profile_for(unsure_undertaking_with_turnover, [attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 100)]).
gdpr_administrative_fine_maximum_profile_for(unlisted_provision, [attribute(infringed_provisions, [article_24]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(listed_neighbour_provision, [attribute(infringed_provisions, [article_25]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(negative_turnover_rejected, [attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, -1)]).
gdpr_administrative_fine_maximum_profile_for(zero_turnover_accepted, [attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 0)]).

gdpr_administrative_fine_maximum_assess(Subject, Result) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    decide_gdpr_administrative_fine_maximum(Profile, Result).
