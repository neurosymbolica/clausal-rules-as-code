% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject/1, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [decide_request_exception/2]).

base_profile(empty, []).
base_profile(portability_engaged, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)]).
base_profile(automated_decision_engaged, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true)]).

fixture_case(portability_engaged_must_comply, portability_engaged, []).
fixture_case(portability_not_automated_not_engaged, empty, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, false)]).
fixture_case(portability_public_task_relieves, portability_engaged, [attribute(processing_necessary_for_public_task_or_official_authority, true)]).
fixture_case(portability_public_task_false_must_comply, portability_engaged, [attribute(processing_necessary_for_public_task_or_official_authority, false)]).
fixture_case(portability_rights_of_others_relieves, portability_engaged, [attribute(transmission_would_adversely_affect_rights_and_freedoms_of_others, true)]).
fixture_case(portability_rights_of_others_unsure_refers, portability_engaged, [attribute(transmission_would_adversely_affect_rights_and_freedoms_of_others, unsure)]).
fixture_case(portability_missing_keys, empty, [attribute(request_type, portability)]).
fixture_case(objection_direct_marketing_absolute, empty, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true), attribute(controller_demonstrates_compelling_legitimate_grounds, true)]).
fixture_case(objection_direct_marketing_not_engaged, empty, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, false), attribute(controller_demonstrates_compelling_legitimate_grounds, true)]).
fixture_case(objection_article_21_1_compelling_grounds, empty, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(controller_demonstrates_compelling_legitimate_grounds, true)]).
fixture_case(objection_article_21_1_compelling_grounds_false, empty, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(controller_demonstrates_compelling_legitimate_grounds, false)]).
fixture_case(objection_article_21_1_legal_claims, empty, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(processing_necessary_for_legal_claims, true)]).
fixture_case(objection_article_21_1_legal_claims_false, empty, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(processing_necessary_for_legal_claims, false)]).
fixture_case(objection_article_21_6_public_interest_task, empty, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_6), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(processing_necessary_for_public_task_or_official_authority, true)]).
fixture_case(objection_article_21_6_public_interest_task_false, empty, [attribute(request_type, objection), attribute(objection_ground_claimed, art21_6), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(processing_necessary_for_public_task_or_official_authority, false)]).
fixture_case(objection_ground_absent_grounds_disagree, empty, [attribute(request_type, objection), attribute(processing_based_on_art6_1_e_or_f, false), attribute(processing_for_direct_marketing, true), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, false)]).
fixture_case(objection_ground_absent_grounds_agree, empty, [attribute(request_type, objection), attribute(processing_based_on_art6_1_e_or_f, false), attribute(processing_for_direct_marketing, false), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, false)]).
fixture_case(automated_decision_engaged_must_comply, automated_decision_engaged, []).
fixture_case(automated_decision_not_solely_automated, empty, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, false), attribute(decision_produces_legal_or_similarly_significant_effects, true)]).
fixture_case(automated_decision_contract_with_safeguards, automated_decision_engaged, [attribute(decision_necessary_for_contract_with_data_subject, true)]).
fixture_case(automated_decision_contract_unsure_refers, automated_decision_engaged, [attribute(decision_necessary_for_contract_with_data_subject, unsure)]).
fixture_case(automated_decision_explicit_consent_barred_special_categories, automated_decision_engaged, [attribute(data_subject_gave_explicit_consent, true), attribute(decision_based_on_special_categories, true), attribute(special_category_condition_and_safeguards_met_for_decision, false)]).
fixture_case(automated_decision_explicit_consent_safeguards_met, automated_decision_engaged, [attribute(data_subject_gave_explicit_consent, true), attribute(decision_based_on_special_categories, true), attribute(special_category_condition_and_safeguards_met_for_decision, true)]).
fixture_case(automated_decision_special_category_safeguards_missing, automated_decision_engaged, [attribute(data_subject_gave_explicit_consent, true), attribute(decision_based_on_special_categories, true)]).
fixture_case(automated_decision_authorised_by_law_attested, automated_decision_engaged, [attribute(decision_authorised_by_union_or_member_state_law, attested(true, attestation(by, at, reason, none)))]).
fixture_case(automated_decision_authorised_by_law_attested_false, automated_decision_engaged, [attribute(decision_authorised_by_union_or_member_state_law, attested(false, attestation(by, at, reason, none)))]).
fixture_case(manifestly_excessive_fee_open, portability_engaged, [attribute(request_manifestly_unfounded_or_excessive, true)]).
fixture_case(manifestly_excessive_unsure_refers, portability_engaged, [attribute(request_manifestly_unfounded_or_excessive, unsure)]).
fixture_case(unable_to_identify_relieves, portability_engaged, [attribute(controller_demonstrates_unable_to_identify_data_subject, true)]).
fixture_case(unable_to_identify_false_must_comply, portability_engaged, [attribute(controller_demonstrates_unable_to_identify_data_subject, false)]).
fixture_case(legislative_restriction_attested_true, portability_engaged, [attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(by, at, reason, none)))]).
fixture_case(legislative_restriction_attested_false, portability_engaged, [attribute(legislative_restriction_applies_to_the_right, attested(false, attestation(by, at, reason, none)))]).
fixture_case(identity_doubts_suspend, portability_engaged, [attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)]).
fixture_case(identity_doubts_identity_confirmed, portability_engaged, [attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, true)]).
fixture_case(identity_doubts_unsure_refers, portability_engaged, [attribute(reasonable_doubts_about_identity, unsure), attribute(identity_confirmed, false)]).
fixture_case(request_type_absent_all_types_not_engaged, empty, [attribute(personal_data_provided_by_data_subject, false), attribute(processing_based_on_art6_1_e_or_f, false), attribute(processing_for_direct_marketing, false), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, false), attribute(decision_based_solely_on_automated_processing, false)]).
fixture_case(request_type_absent_types_disagree, empty, [attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)]).
fixture_case(duplicate_and_unknown_keys, empty, [attribute(request_type, portability), attribute(request_type, objection), attribute(colour, red)]).
fixture_case(crisp_flag_given_unsure_wrong_type, empty, [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, unsure)]).

gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject(Subject) :-
    fixture_case(Subject, _, _).

gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile) :-
    fixture_case(Subject, Base, ExtraAttributes),
    base_profile(Base, BaseAttributes),
    append(BaseAttributes, ExtraAttributes, Profile).

gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_assess(Subject, Result) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile),
    decide_request_exception(Profile, Result).
