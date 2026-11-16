% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_subject/1, gdpr_administrative_fine_maximum_profile_for/2, gdpr_administrative_fine_maximum_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [decide_gdpr_administrative_fine_maximum/2]).

gdpr_administrative_fine_maximum_subject(lower_percentage_basis).
gdpr_administrative_fine_maximum_subject(lower_tie_at_fixed).
gdpr_administrative_fine_maximum_subject(lower_one_euro_above_tie).
gdpr_administrative_fine_maximum_subject(lower_one_euro_below_tie).
gdpr_administrative_fine_maximum_subject(higher_fixed_basis).
gdpr_administrative_fine_maximum_subject(higher_tie_at_fixed).
gdpr_administrative_fine_maximum_subject(higher_one_euro_above_tie).
gdpr_administrative_fine_maximum_subject(lower_non_undertaking).
gdpr_administrative_fine_maximum_subject(higher_non_undertaking_ignores_turnover).
gdpr_administrative_fine_maximum_subject(certification_body_article_42).
gdpr_administrative_fine_maximum_subject(monitoring_body_article_41_paragraph_4).
gdpr_administrative_fine_maximum_subject(member_state_law_chapter_ix).
gdpr_administrative_fine_maximum_subject(order_non_compliance).
gdpr_administrative_fine_maximum_subject(access_failure).
gdpr_administrative_fine_maximum_subject(provision_named_twice).
gdpr_administrative_fine_maximum_subject(combined_gravest_is_higher).
gdpr_administrative_fine_maximum_subject(combined_all_lower).
gdpr_administrative_fine_maximum_subject(separate_not_linked).
gdpr_administrative_fine_maximum_subject(separate_not_negligent).
gdpr_administrative_fine_maximum_subject(separate_one_unsure_one_false).
gdpr_administrative_fine_maximum_subject(unsure_undertaking).
gdpr_administrative_fine_maximum_subject(unsure_first_art_83_3_key).
gdpr_administrative_fine_maximum_subject(unsure_second_art_83_3_key).
gdpr_administrative_fine_maximum_subject(unsure_undertaking_in_separate_mode).
gdpr_administrative_fine_maximum_subject(missing_turnover).
gdpr_administrative_fine_maximum_subject(missing_art_83_3_keys).
gdpr_administrative_fine_maximum_subject(missing_provisions).
gdpr_administrative_fine_maximum_subject(missing_everything).
gdpr_administrative_fine_maximum_subject(unlisted_provision).
gdpr_administrative_fine_maximum_subject(unlisted_with_duplicates).
gdpr_administrative_fine_maximum_subject(input_negative_turnover).
gdpr_administrative_fine_maximum_subject(input_unknown_key).
gdpr_administrative_fine_maximum_subject(input_duplicate_key).
gdpr_administrative_fine_maximum_subject(input_wrong_judgement_unread).

gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, [attribute(infringed_provisions, [article_32]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000)]).
gdpr_administrative_fine_maximum_profile_for(lower_tie_at_fixed, [attribute(infringed_provisions, [article_32]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)]).
gdpr_administrative_fine_maximum_profile_for(lower_one_euro_above_tie, [attribute(infringed_provisions, [article_32]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000001)]).
gdpr_administrative_fine_maximum_profile_for(lower_one_euro_below_tie, [attribute(infringed_provisions, [article_32]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 499999999)]).
gdpr_administrative_fine_maximum_profile_for(higher_fixed_basis, [attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 400000000)]).
gdpr_administrative_fine_maximum_profile_for(higher_tie_at_fixed, [attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)]).
gdpr_administrative_fine_maximum_profile_for(higher_one_euro_above_tie, [attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000001)]).
gdpr_administrative_fine_maximum_profile_for(lower_non_undertaking, [attribute(infringed_provisions, [article_25]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(higher_non_undertaking_ignores_turnover, [attribute(infringed_provisions, [article_9]), attribute(infringer_is_undertaking, false), attribute(total_worldwide_annual_turnover_in_euros, 999999999999)]).
gdpr_administrative_fine_maximum_profile_for(certification_body_article_42, [attribute(infringed_provisions, [article_42]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1)]).
gdpr_administrative_fine_maximum_profile_for(monitoring_body_article_41_paragraph_4, [attribute(infringed_provisions, [article_41_paragraph_4]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(member_state_law_chapter_ix, [attribute(infringed_provisions, [member_state_law_adopted_under_chapter_ix]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(order_non_compliance, [attribute(infringed_provisions, [non_compliance_with_supervisory_authority_order]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000)]).
gdpr_administrative_fine_maximum_profile_for(access_failure, [attribute(infringed_provisions, [failure_to_provide_access_to_supervisory_authority]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(provision_named_twice, [attribute(infringed_provisions, [article_5, article_5]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(combined_gravest_is_higher, [attribute(infringed_provisions, [article_32, article_5]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000), attribute(infringements_concern_same_or_linked_processing_operations, true), attribute(infringements_intentional_or_negligent, true)]).
gdpr_administrative_fine_maximum_profile_for(combined_all_lower, [attribute(infringed_provisions, [article_32, article_33]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000), attribute(infringements_concern_same_or_linked_processing_operations, true), attribute(infringements_intentional_or_negligent, true)]).
gdpr_administrative_fine_maximum_profile_for(separate_not_linked, [attribute(infringed_provisions, [article_5, article_32]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000), attribute(infringements_concern_same_or_linked_processing_operations, false), attribute(infringements_intentional_or_negligent, true)]).
gdpr_administrative_fine_maximum_profile_for(separate_not_negligent, [attribute(infringed_provisions, [article_5, article_32]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000), attribute(infringements_concern_same_or_linked_processing_operations, true), attribute(infringements_intentional_or_negligent, false)]).
gdpr_administrative_fine_maximum_profile_for(separate_one_unsure_one_false, [attribute(infringed_provisions, [article_5, article_32]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000), attribute(infringements_concern_same_or_linked_processing_operations, unsure), attribute(infringements_intentional_or_negligent, false)]).
gdpr_administrative_fine_maximum_profile_for(unsure_undertaking, [attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 100)]).
gdpr_administrative_fine_maximum_profile_for(unsure_first_art_83_3_key, [attribute(infringed_provisions, [article_5, article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000), attribute(infringements_concern_same_or_linked_processing_operations, unsure), attribute(infringements_intentional_or_negligent, true)]).
gdpr_administrative_fine_maximum_profile_for(unsure_second_art_83_3_key, [attribute(infringed_provisions, [article_5, article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000), attribute(infringements_concern_same_or_linked_processing_operations, true), attribute(infringements_intentional_or_negligent, unsure)]).
gdpr_administrative_fine_maximum_profile_for(unsure_undertaking_in_separate_mode, [attribute(infringed_provisions, [article_5, article_32]), attribute(infringer_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 1000), attribute(infringements_concern_same_or_linked_processing_operations, false), attribute(infringements_intentional_or_negligent, true)]).
gdpr_administrative_fine_maximum_profile_for(missing_turnover, [attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, true)]).
gdpr_administrative_fine_maximum_profile_for(missing_art_83_3_keys, [attribute(infringed_provisions, [article_5, article_6]), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(missing_provisions, [attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(missing_everything, []).
gdpr_administrative_fine_maximum_profile_for(unlisted_provision, [attribute(infringed_provisions, [article_24]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000)]).
gdpr_administrative_fine_maximum_profile_for(unlisted_with_duplicates, [attribute(infringed_provisions, [article_5, article_24, article_24]), attribute(infringer_is_undertaking, false), attribute(infringements_concern_same_or_linked_processing_operations, true), attribute(infringements_intentional_or_negligent, true)]).
gdpr_administrative_fine_maximum_profile_for(input_negative_turnover, [attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, -1)]).
gdpr_administrative_fine_maximum_profile_for(input_unknown_key, [attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, false), attribute(surprise_key, 1)]).
gdpr_administrative_fine_maximum_profile_for(input_duplicate_key, [attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, true), attribute(infringer_is_undertaking, false)]).
gdpr_administrative_fine_maximum_profile_for(input_wrong_judgement_unread, [attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, false), attribute(infringements_intentional_or_negligent, maybe)]).

gdpr_administrative_fine_maximum_assess(Subject, Result) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    decide_gdpr_administrative_fine_maximum(Profile, Result).
