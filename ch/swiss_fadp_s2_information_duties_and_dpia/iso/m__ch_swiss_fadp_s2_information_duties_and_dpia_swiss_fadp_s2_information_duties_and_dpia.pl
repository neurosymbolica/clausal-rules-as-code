% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s2_information_duties_and_dpia_swiss_fadp_s2_information_duties_and_dpia, [decide_swiss_fadp_s2_information_duties_and_dpia/2, swiss_fadp_s2_information_duties_and_dpia_status/2, swiss_fadp_s2_information_duties_and_dpia_checklist/2, swiss_fadp_s2_information_duties_and_dpia_decision_resolvable/1, swiss_fadp_s2_information_duties_and_dpia_status_values/1, swiss_information_duty/3, swiss_minimum_information_item/4, swiss_automated_decision_information/3, swiss_automated_decision_review/3, swiss_automated_decision_marking/3, swiss_impact_assessment/3, eu_information_duty/3, eu_automated_decision_information/3, eu_impact_assessment/3, compare_swiss_eu_information_duty/5, compare_swiss_eu_automated_decision_information/5, compare_swiss_eu_impact_assessment/5]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_kernel, [swiss_fadp_s2_information_duties_and_dpia_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_citations, [implements/1]).

swiss_fadp_s2_information_duties_and_dpia_status_values([information_required, information_not_required, information_may_be_restricted_deferred_or_omitted]).

information_items([identity_and_contact_details_of_controller, processing_purpose, recipients_or_categories_of_recipients, categories_of_personal_data_processed, state_or_international_body, safeguards_or_exception_relied_on]).

query_keys(swiss_information_duty, [controller_is_federal_body, personal_data_collected_from_data_subject, data_subject_already_has_information, processing_provided_for_by_law, controller_bound_by_statutory_secrecy, article_27_conditions_met, information_impossible_or_requires_disproportionate_effort, overriding_third_party_interests_require_restriction, information_defeats_purpose_of_processing, overriding_controller_interests_require_restriction, controller_discloses_personal_data_to_third_parties, overriding_public_interests_require_restriction, information_may_endanger_investigation_or_proceedings]).
query_keys(minimum_item(identity_and_contact_details_of_controller), []).
query_keys(minimum_item(processing_purpose), []).
query_keys(minimum_item(recipients_or_categories_of_recipients), [personal_data_disclosed_to_recipients]).
query_keys(minimum_item(categories_of_personal_data_processed), [personal_data_collected_from_data_subject]).
query_keys(minimum_item(state_or_international_body), [personal_data_disclosed_abroad]).
query_keys(minimum_item(safeguards_or_exception_relied_on), [personal_data_disclosed_abroad, disclosure_abroad_relies_on_safeguards_or_exception]).
query_keys(swiss_automated_decision_information, [decision_based_solely_on_automated_processing, decision_has_legal_consequence_or_significantly_impairs_data_subject, decision_directly_related_to_contract_with_data_subject, data_subject_request_granted, data_subject_explicitly_consented_to_automated_decision]).
query_keys(swiss_automated_decision_review, [controller_is_federal_body, decision_based_solely_on_automated_processing, decision_has_legal_consequence_or_significantly_impairs_data_subject, decision_directly_related_to_contract_with_data_subject, data_subject_request_granted, data_subject_explicitly_consented_to_automated_decision, data_subject_need_not_be_heard_before_decision]).
query_keys(swiss_automated_decision_marking, [controller_is_federal_body, decision_based_solely_on_automated_processing, decision_has_legal_consequence_or_significantly_impairs_data_subject]).
query_keys(swiss_impact_assessment, [controller_is_federal_body, processing_may_entail_high_risk_to_personality_or_fundamental_rights, large_scale_processing_of_sensitive_personal_data, systematic_large_scale_monitoring_of_public_areas, controller_legally_obliged_to_process_data, system_product_or_service_certified_for_intended_use, controller_complies_with_code_of_conduct, code_of_conduct_based_on_impact_assessment, code_of_conduct_provides_protective_measures, code_of_conduct_submitted_to_commissioner]).
query_keys(eu_information_duty, [personal_data_collected_from_data_subject, eu_data_subject_already_has_information, eu_information_impossible_disproportionate_or_seriously_impairing, eu_obtaining_or_disclosure_expressly_laid_down_by_law, eu_personal_data_confidential_under_professional_secrecy]).
query_keys(eu_automated_decision_information, [personal_data_collected_from_data_subject, eu_data_subject_already_has_information, eu_information_impossible_disproportionate_or_seriously_impairing, eu_obtaining_or_disclosure_expressly_laid_down_by_law, eu_personal_data_confidential_under_professional_secrecy, eu_decision_based_solely_on_automated_processing, eu_decision_has_legal_or_similarly_significant_effects]).
query_keys(eu_impact_assessment, [eu_processing_likely_to_result_in_high_risk, eu_systematic_extensive_evaluation_with_significant_automated_decisions, eu_large_scale_processing_of_special_categories_or_criminal_data, eu_systematic_large_scale_monitoring_of_publicly_accessible_area, eu_article_35_10_exemption_applies]).
query_keys(compare_swiss_eu_information_duty, [controller_is_federal_body, personal_data_collected_from_data_subject, data_subject_already_has_information, processing_provided_for_by_law, controller_bound_by_statutory_secrecy, article_27_conditions_met, information_impossible_or_requires_disproportionate_effort, overriding_third_party_interests_require_restriction, information_defeats_purpose_of_processing, overriding_controller_interests_require_restriction, controller_discloses_personal_data_to_third_parties, overriding_public_interests_require_restriction, information_may_endanger_investigation_or_proceedings, eu_data_subject_already_has_information, eu_information_impossible_disproportionate_or_seriously_impairing, eu_obtaining_or_disclosure_expressly_laid_down_by_law, eu_personal_data_confidential_under_professional_secrecy]).
query_keys(compare_swiss_eu_automated_decision_information, [personal_data_collected_from_data_subject, decision_based_solely_on_automated_processing, decision_has_legal_consequence_or_significantly_impairs_data_subject, decision_directly_related_to_contract_with_data_subject, data_subject_request_granted, data_subject_explicitly_consented_to_automated_decision, eu_data_subject_already_has_information, eu_information_impossible_disproportionate_or_seriously_impairing, eu_obtaining_or_disclosure_expressly_laid_down_by_law, eu_personal_data_confidential_under_professional_secrecy, eu_decision_based_solely_on_automated_processing, eu_decision_has_legal_or_similarly_significant_effects]).
query_keys(compare_swiss_eu_impact_assessment, [controller_is_federal_body, processing_may_entail_high_risk_to_personality_or_fundamental_rights, large_scale_processing_of_sensitive_personal_data, systematic_large_scale_monitoring_of_public_areas, controller_legally_obliged_to_process_data, system_product_or_service_certified_for_intended_use, controller_complies_with_code_of_conduct, code_of_conduct_based_on_impact_assessment, code_of_conduct_provides_protective_measures, code_of_conduct_submitted_to_commissioner, eu_processing_likely_to_result_in_high_risk, eu_systematic_extensive_evaluation_with_significant_automated_decisions, eu_large_scale_processing_of_special_categories_or_criminal_data, eu_systematic_large_scale_monitoring_of_publicly_accessible_area, eu_article_35_10_exemption_applies]).

comparison_pair(compare_swiss_eu_information_duty, swiss_information_duty, eu_information_duty).
comparison_pair(compare_swiss_eu_automated_decision_information, swiss_automated_decision_information, eu_automated_decision_information).
comparison_pair(compare_swiss_eu_impact_assessment, swiss_impact_assessment, eu_impact_assessment).

condition(already_has_information, true_key(data_subject_already_has_information)) :-
    implements(ch_fadp_art_20_1_a).
condition(provided_for_by_law, true_key(processing_provided_for_by_law)) :-
    implements(ch_fadp_art_20_1_b).
condition(private_controller_bound_to_secrecy, all_of([false_key(controller_is_federal_body), true_key(controller_bound_by_statutory_secrecy)])) :-
    implements(ch_fadp_art_20_1_c).
condition(article_27_conditions, true_key(article_27_conditions_met)) :-
    implements(ch_fadp_art_20_1_d).
condition(indirect_collection_impossible_or_disproportionate, all_of([false_key(personal_data_collected_from_data_subject), true_key(information_impossible_or_requires_disproportionate_effort)])) :-
    implements(ch_fadp_art_20_2).
condition(third_party_interests, true_key(overriding_third_party_interests_require_restriction)) :-
    implements(ch_fadp_art_20_3_a).
condition(defeats_purpose, true_key(information_defeats_purpose_of_processing)) :-
    implements(ch_fadp_art_20_3_b).
condition(private_controller_interests_without_disclosure, all_of([false_key(controller_is_federal_body), true_key(overriding_controller_interests_require_restriction), false_key(controller_discloses_personal_data_to_third_parties)])) :-
    implements(ch_fadp_art_20_3_c).
condition(federal_body_public_interest_or_investigation, all_of([true_key(controller_is_federal_body), any_of([true_key(overriding_public_interests_require_restriction), true_key(information_may_endanger_investigation_or_proceedings)])])) :-
    implements(ch_fadp_art_20_3_d).
condition(automated_individual_decision, all_of([true_key(decision_based_solely_on_automated_processing), true_key(decision_has_legal_consequence_or_significantly_impairs_data_subject)])) :-
    implements(ch_fadp_art_21_1).
condition(article_21_3_exception, any_of([all_of([true_key(decision_directly_related_to_contract_with_data_subject), true_key(data_subject_request_granted)]), true_key(data_subject_explicitly_consented_to_automated_decision)])) :-
    implements(ch_fadp_art_21_3).
condition(federal_decision_without_hearing, all_of([true_key(controller_is_federal_body), true_key(data_subject_need_not_be_heard_before_decision)])) :-
    implements(ch_fadp_art_21_4).
condition(federal_body_controller, true_key(controller_is_federal_body)) :-
    implements(ch_fadp_art_21_4).
condition(no_high_risk, all_of([false_key(processing_may_entail_high_risk_to_personality_or_fundamental_rights), false_key(large_scale_processing_of_sensitive_personal_data), false_key(systematic_large_scale_monitoring_of_public_areas)])) :-
    implements(ch_fadp_art_22_2).
condition(private_controller_obliged_by_law, all_of([false_key(controller_is_federal_body), true_key(controller_legally_obliged_to_process_data)])) :-
    implements(ch_fadp_art_22_4).
condition(code_of_conduct_route, all_of([true_key(controller_complies_with_code_of_conduct), true_key(code_of_conduct_based_on_impact_assessment), true_key(code_of_conduct_provides_protective_measures), true_key(code_of_conduct_submitted_to_commissioner)])) :-
    implements(ch_fadp_art_22_5_c).
condition(private_controller_may_dispense, all_of([false_key(controller_is_federal_body), any_of([true_key(system_product_or_service_certified_for_intended_use), CodeRoute])])) :-
    implements(ch_fadp_art_22_5),
    condition(code_of_conduct_route, CodeRoute).
condition(eu_direct_collection_exception, all_of([true_key(personal_data_collected_from_data_subject), true_key(eu_data_subject_already_has_information)])) :-
    implements(eu_reg_2016_679_art_13_4).
condition(eu_indirect_collection_exception, all_of([false_key(personal_data_collected_from_data_subject), any_of([true_key(eu_data_subject_already_has_information), true_key(eu_information_impossible_disproportionate_or_seriously_impairing), true_key(eu_obtaining_or_disclosure_expressly_laid_down_by_law), true_key(eu_personal_data_confidential_under_professional_secrecy)])])) :-
    implements(eu_reg_2016_679_art_14_5).
condition(eu_automated_decision, all_of([true_key(eu_decision_based_solely_on_automated_processing), true_key(eu_decision_has_legal_or_similarly_significant_effects)])) :-
    implements(eu_reg_2016_679_art_22_1).
condition(eu_no_high_risk_or_listed_case, all_of([false_key(eu_processing_likely_to_result_in_high_risk), false_key(eu_systematic_extensive_evaluation_with_significant_automated_decisions), false_key(eu_large_scale_processing_of_special_categories_or_criminal_data), false_key(eu_systematic_large_scale_monitoring_of_publicly_accessible_area)])) :-
    implements(eu_reg_2016_679_art_35_3).
condition(eu_article_35_10_exemption, true_key(eu_article_35_10_exemption_applies)) :-
    implements(eu_reg_2016_679_art_35_10).

query_rules(swiss_information_duty, [rule(any_of([AlreadyInformed, ProvidedByLaw, Secrecy, Article27, IndirectImpossible]), information_not_required), rule(any_of([ThirdParty, DefeatsPurpose, PrivateInterests, FederalInterests]), information_may_be_restricted_deferred_or_omitted), rule(always, information_required)]) :-
    implements(ch_fadp_art_19_1),
    condition(already_has_information, AlreadyInformed),
    condition(provided_for_by_law, ProvidedByLaw),
    condition(private_controller_bound_to_secrecy, Secrecy),
    condition(article_27_conditions, Article27),
    condition(indirect_collection_impossible_or_disproportionate, IndirectImpossible),
    condition(third_party_interests, ThirdParty),
    condition(defeats_purpose, DefeatsPurpose),
    condition(private_controller_interests_without_disclosure, PrivateInterests),
    condition(federal_body_public_interest_or_investigation, FederalInterests).
query_rules(minimum_item(identity_and_contact_details_of_controller), [rule(always, information_item_required)]) :-
    implements(ch_fadp_art_19_2_a).
query_rules(minimum_item(processing_purpose), [rule(always, information_item_required)]) :-
    implements(ch_fadp_art_19_2_b).
query_rules(minimum_item(recipients_or_categories_of_recipients), [rule(true_key(personal_data_disclosed_to_recipients), information_item_required), rule(always, information_item_not_required)]) :-
    implements(ch_fadp_art_19_2_c).
query_rules(minimum_item(categories_of_personal_data_processed), [rule(false_key(personal_data_collected_from_data_subject), information_item_required), rule(always, information_item_not_required)]) :-
    implements(ch_fadp_art_19_3).
query_rules(minimum_item(state_or_international_body), [rule(true_key(personal_data_disclosed_abroad), information_item_required), rule(always, information_item_not_required)]) :-
    implements(ch_fadp_art_19_4).
query_rules(minimum_item(safeguards_or_exception_relied_on), [rule(all_of([true_key(personal_data_disclosed_abroad), true_key(disclosure_abroad_relies_on_safeguards_or_exception)]), information_item_required), rule(always, information_item_not_required)]) :-
    implements(ch_fadp_art_19_4).
query_rules(swiss_automated_decision_information, [rule(all_of([AutomatedDecision, negated(Exception)]), automated_decision_information_required), rule(always, automated_decision_information_not_required)]) :-
    implements(ch_fadp_art_21_1),
    condition(automated_individual_decision, AutomatedDecision),
    condition(article_21_3_exception, Exception).
query_rules(swiss_automated_decision_review, [rule(all_of([AutomatedDecision, negated(Exception), negated(NoHearing)]), view_and_review_rights_apply), rule(always, view_and_review_rights_do_not_apply)]) :-
    implements(ch_fadp_art_21_2),
    condition(automated_individual_decision, AutomatedDecision),
    condition(article_21_3_exception, Exception),
    condition(federal_decision_without_hearing, NoHearing).
query_rules(swiss_automated_decision_marking, [rule(all_of([FederalBody, AutomatedDecision]), decision_marking_required), rule(always, decision_marking_not_required)]) :-
    implements(ch_fadp_art_21_4),
    condition(federal_body_controller, FederalBody),
    condition(automated_individual_decision, AutomatedDecision).
query_rules(swiss_impact_assessment, [rule(NoHighRisk, impact_assessment_not_required), rule(ObligedByLaw, impact_assessment_not_required), rule(MayDispense, impact_assessment_may_be_omitted), rule(always, impact_assessment_required)]) :-
    implements(ch_fadp_art_22_1),
    condition(no_high_risk, NoHighRisk),
    condition(private_controller_obliged_by_law, ObligedByLaw),
    condition(private_controller_may_dispense, MayDispense).
query_rules(eu_information_duty, [rule(any_of([DirectException, IndirectException]), information_not_required), rule(always, information_required)]) :-
    implements(eu_reg_2016_679_art_13_1),
    condition(eu_direct_collection_exception, DirectException),
    condition(eu_indirect_collection_exception, IndirectException).
query_rules(eu_automated_decision_information, [rule(all_of([AutomatedDecision, negated(any_of([DirectException, IndirectException]))]), automated_decision_information_required), rule(always, automated_decision_information_not_required)]) :-
    implements(eu_reg_2016_679_art_13_2_f),
    condition(eu_automated_decision, AutomatedDecision),
    condition(eu_direct_collection_exception, DirectException),
    condition(eu_indirect_collection_exception, IndirectException).
query_rules(eu_impact_assessment, [rule(any_of([NoHighRisk, Exemption]), impact_assessment_not_required), rule(always, impact_assessment_required)]) :-
    implements(eu_reg_2016_679_art_35_1),
    condition(eu_no_high_risk_or_listed_case, NoHighRisk),
    condition(eu_article_35_10_exemption, Exemption).

result_citations(swiss_information_duty, information_not_required, [cite(ch_fadp_art_19_1), cite(ch_fadp_art_20_1), cite(ch_fadp_art_20_1_a), cite(ch_fadp_art_20_1_b), cite(ch_fadp_art_20_1_c), cite(ch_fadp_art_20_1_d), cite(ch_fadp_art_20_2), cite(ch_fadp_art_20_2_a), cite(ch_fadp_art_20_2_b)]).
result_citations(swiss_information_duty, information_may_be_restricted_deferred_or_omitted, [cite(ch_fadp_art_19_1), cite(ch_fadp_art_20_3), cite(ch_fadp_art_20_3_a), cite(ch_fadp_art_20_3_b), cite(ch_fadp_art_20_3_c), cite(ch_fadp_art_20_3_c_1), cite(ch_fadp_art_20_3_c_2), cite(ch_fadp_art_20_3_d), cite(ch_fadp_art_20_3_d_1), cite(ch_fadp_art_20_3_d_2), cite(ch_fadp_art_20_4)]).
result_citations(swiss_information_duty, information_required, [cite(ch_fadp_art_19_1), cite(ch_fadp_art_20_1), cite(ch_fadp_art_20_2), cite(ch_fadp_art_20_3)]).
result_citations(minimum_item(identity_and_contact_details_of_controller), _, [cite(ch_fadp_art_19_2), cite(ch_fadp_art_19_2_a)]).
result_citations(minimum_item(processing_purpose), _, [cite(ch_fadp_art_19_2), cite(ch_fadp_art_19_2_b)]).
result_citations(minimum_item(recipients_or_categories_of_recipients), _, [cite(ch_fadp_art_19_2), cite(ch_fadp_art_19_2_c)]).
result_citations(minimum_item(categories_of_personal_data_processed), _, [cite(ch_fadp_art_19_3)]).
result_citations(minimum_item(state_or_international_body), _, [cite(ch_fadp_art_19_4)]).
result_citations(minimum_item(safeguards_or_exception_relied_on), _, [cite(ch_fadp_art_19_4)]).
result_citations(swiss_automated_decision_information, _, [cite(ch_fadp_art_21_1), cite(ch_fadp_art_21_3), cite(ch_fadp_art_21_3_a), cite(ch_fadp_art_21_3_b)]).
result_citations(swiss_automated_decision_review, _, [cite(ch_fadp_art_21_1), cite(ch_fadp_art_21_2), cite(ch_fadp_art_21_3), cite(ch_fadp_art_21_3_a), cite(ch_fadp_art_21_3_b), cite(ch_fadp_art_21_4)]).
result_citations(swiss_automated_decision_marking, _, [cite(ch_fadp_art_21_1), cite(ch_fadp_art_21_4)]).
result_citations(swiss_impact_assessment, impact_assessment_not_required, [cite(ch_fadp_art_22_1), cite(ch_fadp_art_22_2), cite(ch_fadp_art_22_2_a), cite(ch_fadp_art_22_2_b), cite(ch_fadp_art_22_4)]).
result_citations(swiss_impact_assessment, impact_assessment_may_be_omitted, [cite(ch_fadp_art_22_1), cite(ch_fadp_art_22_5), cite(ch_fadp_art_22_5_a), cite(ch_fadp_art_22_5_b), cite(ch_fadp_art_22_5_c)]).
result_citations(swiss_impact_assessment, impact_assessment_required, [cite(ch_fadp_art_22_1), cite(ch_fadp_art_22_2), cite(ch_fadp_art_22_4), cite(ch_fadp_art_22_5)]).
result_citations(eu_information_duty, _, [cite(eu_reg_2016_679_art_13_1), cite(eu_reg_2016_679_art_13_4), cite(eu_reg_2016_679_art_14_1), cite(eu_reg_2016_679_art_14_5), cite(eu_reg_2016_679_art_14_5_a), cite(eu_reg_2016_679_art_14_5_b), cite(eu_reg_2016_679_art_14_5_c), cite(eu_reg_2016_679_art_14_5_d)]).
result_citations(eu_automated_decision_information, _, [cite(eu_reg_2016_679_art_13_2), cite(eu_reg_2016_679_art_13_2_f), cite(eu_reg_2016_679_art_13_4), cite(eu_reg_2016_679_art_14_2), cite(eu_reg_2016_679_art_14_2_g), cite(eu_reg_2016_679_art_14_5), cite(eu_reg_2016_679_art_14_5_a), cite(eu_reg_2016_679_art_14_5_b), cite(eu_reg_2016_679_art_14_5_c), cite(eu_reg_2016_679_art_14_5_d), cite(eu_reg_2016_679_art_22_1)]).
result_citations(eu_impact_assessment, _, [cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_35_3), cite(eu_reg_2016_679_art_35_3_a), cite(eu_reg_2016_679_art_35_3_b), cite(eu_reg_2016_679_art_35_3_c), cite(eu_reg_2016_679_art_35_10)]).

changed_by_row(compare_swiss_eu_information_duty, [cite(ch_fadp_art_19_1), cite(ch_fadp_art_20_1), cite(ch_fadp_art_20_2), cite(ch_fadp_art_20_3), cite(eu_reg_2016_679_art_13_4), cite(eu_reg_2016_679_art_14_5)]).
changed_by_row(compare_swiss_eu_automated_decision_information, [cite(ch_fadp_art_21_1), cite(ch_fadp_art_21_3), cite(eu_reg_2016_679_art_13_2_f), cite(eu_reg_2016_679_art_14_2_g), cite(eu_reg_2016_679_art_13_4), cite(eu_reg_2016_679_art_14_5), cite(eu_reg_2016_679_art_22_1)]).
changed_by_row(compare_swiss_eu_impact_assessment, [cite(ch_fadp_art_22_1), cite(ch_fadp_art_22_2), cite(ch_fadp_art_22_4), cite(ch_fadp_art_22_5), cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_35_3), cite(eu_reg_2016_679_art_35_10)]).

referral(swiss_information_duty, data_subject_already_has_information, cite(ch_fadp_art_20_1_a)).
referral(swiss_information_duty, processing_provided_for_by_law, cite(ch_fadp_art_20_1_b)).
referral(swiss_information_duty, controller_bound_by_statutory_secrecy, cite(ch_fadp_art_20_1_c)).
referral(swiss_information_duty, article_27_conditions_met, cite(ch_fadp_art_20_1_d)).
referral(swiss_information_duty, information_impossible_or_requires_disproportionate_effort, cite(ch_fadp_art_20_2)).
referral(swiss_information_duty, overriding_third_party_interests_require_restriction, cite(ch_fadp_art_20_3_a)).
referral(swiss_information_duty, information_defeats_purpose_of_processing, cite(ch_fadp_art_20_3_b)).
referral(swiss_information_duty, overriding_controller_interests_require_restriction, cite(ch_fadp_art_20_3_c_1)).
referral(swiss_information_duty, overriding_public_interests_require_restriction, cite(ch_fadp_art_20_3_d_1)).
referral(swiss_information_duty, information_may_endanger_investigation_or_proceedings, cite(ch_fadp_art_20_3_d_2)).
referral(swiss_automated_decision_information, decision_based_solely_on_automated_processing, cite(ch_fadp_art_21_1)).
referral(swiss_automated_decision_information, decision_has_legal_consequence_or_significantly_impairs_data_subject, cite(ch_fadp_art_21_1)).
referral(swiss_automated_decision_information, decision_directly_related_to_contract_with_data_subject, cite(ch_fadp_art_21_3_a)).
referral(swiss_automated_decision_information, data_subject_explicitly_consented_to_automated_decision, cite(ch_fadp_art_21_3_b)).
referral(swiss_automated_decision_review, decision_based_solely_on_automated_processing, cite(ch_fadp_art_21_1)).
referral(swiss_automated_decision_review, decision_has_legal_consequence_or_significantly_impairs_data_subject, cite(ch_fadp_art_21_1)).
referral(swiss_automated_decision_review, decision_directly_related_to_contract_with_data_subject, cite(ch_fadp_art_21_3_a)).
referral(swiss_automated_decision_review, data_subject_explicitly_consented_to_automated_decision, cite(ch_fadp_art_21_3_b)).
referral(swiss_automated_decision_review, data_subject_need_not_be_heard_before_decision, cite(ch_fadp_art_21_4)).
referral(swiss_automated_decision_marking, decision_based_solely_on_automated_processing, cite(ch_fadp_art_21_1)).
referral(swiss_automated_decision_marking, decision_has_legal_consequence_or_significantly_impairs_data_subject, cite(ch_fadp_art_21_1)).
referral(swiss_impact_assessment, processing_may_entail_high_risk_to_personality_or_fundamental_rights, cite(ch_fadp_art_22_1)).
referral(swiss_impact_assessment, large_scale_processing_of_sensitive_personal_data, cite(ch_fadp_art_22_2_a)).
referral(swiss_impact_assessment, systematic_large_scale_monitoring_of_public_areas, cite(ch_fadp_art_22_2_b)).
referral(swiss_impact_assessment, controller_legally_obliged_to_process_data, cite(ch_fadp_art_22_4)).
referral(swiss_impact_assessment, system_product_or_service_certified_for_intended_use, cite(ch_fadp_art_22_5)).
referral(swiss_impact_assessment, controller_complies_with_code_of_conduct, cite(ch_fadp_art_22_5)).
referral(swiss_impact_assessment, code_of_conduct_based_on_impact_assessment, cite(ch_fadp_art_22_5_a)).
referral(swiss_impact_assessment, code_of_conduct_provides_protective_measures, cite(ch_fadp_art_22_5_b)).
referral(eu_information_duty, eu_data_subject_already_has_information, cite(eu_reg_2016_679_art_13_4)).
referral(eu_information_duty, eu_information_impossible_disproportionate_or_seriously_impairing, cite(eu_reg_2016_679_art_14_5_b)).
referral(eu_information_duty, eu_obtaining_or_disclosure_expressly_laid_down_by_law, cite(eu_reg_2016_679_art_14_5_c)).
referral(eu_information_duty, eu_personal_data_confidential_under_professional_secrecy, cite(eu_reg_2016_679_art_14_5_d)).
referral(eu_automated_decision_information, eu_data_subject_already_has_information, cite(eu_reg_2016_679_art_13_4)).
referral(eu_automated_decision_information, eu_information_impossible_disproportionate_or_seriously_impairing, cite(eu_reg_2016_679_art_14_5_b)).
referral(eu_automated_decision_information, eu_obtaining_or_disclosure_expressly_laid_down_by_law, cite(eu_reg_2016_679_art_14_5_c)).
referral(eu_automated_decision_information, eu_personal_data_confidential_under_professional_secrecy, cite(eu_reg_2016_679_art_14_5_d)).
referral(eu_automated_decision_information, eu_decision_based_solely_on_automated_processing, cite(eu_reg_2016_679_art_22_1)).
referral(eu_automated_decision_information, eu_decision_has_legal_or_similarly_significant_effects, cite(eu_reg_2016_679_art_22_1)).
referral(eu_impact_assessment, eu_processing_likely_to_result_in_high_risk, cite(eu_reg_2016_679_art_35_1)).
referral(eu_impact_assessment, eu_systematic_extensive_evaluation_with_significant_automated_decisions, cite(eu_reg_2016_679_art_35_3_a)).
referral(eu_impact_assessment, eu_large_scale_processing_of_special_categories_or_criminal_data, cite(eu_reg_2016_679_art_35_3_b)).
referral(eu_impact_assessment, eu_systematic_large_scale_monitoring_of_publicly_accessible_area, cite(eu_reg_2016_679_art_35_3_c)).
referral(eu_impact_assessment, eu_article_35_10_exemption_applies, cite(eu_reg_2016_679_art_35_10)).
referral(Comparison, Key, Citation) :-
    comparison_pair(Comparison, SwissQuery, _),
    referral(SwissQuery, Key, Citation).
referral(Comparison, Key, Citation) :-
    comparison_pair(Comparison, _, EuQuery),
    referral(EuQuery, Key, Citation).

checklist_ground(already_has_information, cite(ch_fadp_art_20_1_a)).
checklist_ground(provided_for_by_law, cite(ch_fadp_art_20_1_b)).
checklist_ground(private_controller_bound_to_secrecy, cite(ch_fadp_art_20_1_c)).
checklist_ground(article_27_conditions, cite(ch_fadp_art_20_1_d)).
checklist_ground(indirect_collection_impossible_or_disproportionate, cite(ch_fadp_art_20_2)).
checklist_ground(third_party_interests, cite(ch_fadp_art_20_3_a)).
checklist_ground(defeats_purpose, cite(ch_fadp_art_20_3_b)).
checklist_ground(private_controller_interests_without_disclosure, cite(ch_fadp_art_20_3_c)).
checklist_ground(federal_body_public_interest_or_investigation, cite(ch_fadp_art_20_3_d)).

query_specification(Query, Keys, decision(Rules)) :-
    query_keys(Query, Keys),
    query_rules(Query, Rules).
query_specification(Query, Keys, comparison(SwissRules, EuRules)) :-
    comparison_pair(Query, SwissQuery, EuQuery),
    query_keys(Query, Keys),
    query_rules(SwissQuery, SwissRules),
    query_rules(EuQuery, EuRules).

build_assignment(_, [], []).
build_assignment(Profile, [Key|Keys], [Key - State|Rest]) :-
    key_state(Profile, Key, State),
    build_assignment(Profile, Keys, Rest).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, State) :-
    profile_get(Profile, Key, State).

set_state([Current - _|Rest], Key, Value, [Current - Value|Rest]) :-
    Current == Key.
set_state([Current - State|Rest], Key, Value, [Current - State|Updated]) :-
    Current \== Key,
    set_state(Rest, Key, Value, Updated).

evaluate(always, _, true, []).
evaluate(true_key(Key), Assignment, Value, OpenKeys) :-
    member(Key - State, Assignment),
    positive_leaf(State, Key, Value, OpenKeys).
evaluate(false_key(Key), Assignment, Value, OpenKeys) :-
    member(Key - State, Assignment),
    negative_leaf(State, Key, Value, OpenKeys).
evaluate(negated(Formula), Assignment, Value, OpenKeys) :-
    evaluate(Formula, Assignment, InnerValue, OpenKeys),
    inverted_value(InnerValue, Value).
evaluate(all_of(Formulas), Assignment, Value, OpenKeys) :-
    conjunction_fold(Formulas, Assignment, true, [], Value, Collected),
    open_keys_when_open(Value, Collected, OpenKeys).
evaluate(any_of(Formulas), Assignment, Value, OpenKeys) :-
    disjunction_fold(Formulas, Assignment, false, [], Value, Collected),
    open_keys_when_open(Value, Collected, OpenKeys).

positive_leaf(true, _, true, []).
positive_leaf(false, _, false, []).
positive_leaf(absent, Key, open, [Key]).
positive_leaf(unsure, Key, open, [Key]).

negative_leaf(true, _, false, []).
negative_leaf(false, _, true, []).
negative_leaf(absent, Key, open, [Key]).
negative_leaf(unsure, Key, open, [Key]).

inverted_value(true, false).
inverted_value(false, true).
inverted_value(open, open).

conjunction_fold([], _, Value, Collected, Value, Collected).
conjunction_fold([Formula|Formulas], Assignment, ValueSoFar, CollectedSoFar, Value, Collected) :-
    evaluate(Formula, Assignment, FormulaValue, FormulaOpen),
    conjunction_value(ValueSoFar, FormulaValue, NextValue),
    append(CollectedSoFar, FormulaOpen, NextCollected),
    conjunction_fold(Formulas, Assignment, NextValue, NextCollected, Value, Collected).

disjunction_fold([], _, Value, Collected, Value, Collected).
disjunction_fold([Formula|Formulas], Assignment, ValueSoFar, CollectedSoFar, Value, Collected) :-
    evaluate(Formula, Assignment, FormulaValue, FormulaOpen),
    disjunction_value(ValueSoFar, FormulaValue, NextValue),
    append(CollectedSoFar, FormulaOpen, NextCollected),
    disjunction_fold(Formulas, Assignment, NextValue, NextCollected, Value, Collected).

conjunction_value(false, _, false).
conjunction_value(true, Value, Value).
conjunction_value(open, false, false).
conjunction_value(open, true, open).
conjunction_value(open, open, open).

disjunction_value(true, _, true).
disjunction_value(false, Value, Value).
disjunction_value(open, true, true).
disjunction_value(open, false, open).
disjunction_value(open, open, open).

open_keys_when_open(open, Collected, Collected).
open_keys_when_open(true, _, []).
open_keys_when_open(false, _, []).

possible_results(decision(Rules), Assignment, Results, OpenKeys) :-
    decision_results(Rules, Assignment, Results, OpenKeys).
possible_results(comparison(SwissRules, EuRules), Assignment, Results, OpenKeys) :-
    decision_results(SwissRules, Assignment, SwissResults, SwissOpen),
    decision_results(EuRules, Assignment, EuResults, EuOpen),
    shared_results(SwissResults, EuResults, Shared),
    same_part(Shared, SamePart),
    differs_part(SwissResults, EuResults, DiffersPart),
    append(DiffersPart, SamePart, Joined),
    sort(Joined, Results),
    append(SwissOpen, EuOpen, Collected),
    open_unless_settled(Results, Collected, OpenKeys).

decision_results(Rules, Assignment, Results, OpenKeys) :-
    rule_walk(Rules, Assignment, Found, Collected),
    sort(Found, Results),
    open_unless_settled(Results, Collected, OpenKeys).

rule_walk([], _, [], []).
rule_walk([rule(Guard, Result)|Rules], Assignment, Found, Collected) :-
    evaluate(Guard, Assignment, Value, GuardOpen),
    rule_step(Value, Result, GuardOpen, Rules, Assignment, Found, Collected).

rule_step(true, Result, _, _, _, [Result], []).
rule_step(false, _, _, Rules, Assignment, Found, Collected) :-
    rule_walk(Rules, Assignment, Found, Collected).
rule_step(open, Result, GuardOpen, Rules, Assignment, [Result|Found], Collected) :-
    rule_walk(Rules, Assignment, Found, LaterOpen),
    append(GuardOpen, LaterOpen, Collected).

open_unless_settled([_], _, []).
open_unless_settled([_, _|_], Collected, Collected).

shared_results(First, Second, Shared) :-
    findall(Result, (member(Result, First), member(Result, Second)), Shared).

same_part([], []).
same_part([_|_], [same]).

differs_part([Swiss], [Eu], []) :-
    Swiss == Eu.
differs_part([Swiss], [Eu], [differs]) :-
    Swiss \== Eu.
differs_part([_], [_, _|_], [differs]).
differs_part([_, _|_], _, [differs]).

exact_results(Specification, Assignment, Results) :-
    possible_results(Specification, Assignment, Candidates, OpenKeys),
    refine_results(Candidates, OpenKeys, Specification, Assignment, Results).

refine_results([Result], _, _, _, [Result]).
refine_results([_, _|_], [Split|_], Specification, Assignment, Results) :-
    set_state(Assignment, Split, true, AssignmentTrue),
    set_state(Assignment, Split, false, AssignmentFalse),
    exact_results(Specification, AssignmentTrue, ResultsTrue),
    exact_results(Specification, AssignmentFalse, ResultsFalse),
    append(ResultsTrue, ResultsFalse, Joined),
    sort(Joined, Results).

changes_t(Specification, Assignment, Key, Truth) :-
    set_state(Assignment, Key, true, AssignmentTrue),
    set_state(Assignment, Key, false, AssignmentFalse),
    possible_results(Specification, AssignmentTrue, ResultsTrue, OpenTrue),
    possible_results(Specification, AssignmentFalse, ResultsFalse, OpenFalse),
    append(OpenTrue, OpenFalse, OpenKeys),
    changes_decide(ResultsTrue, ResultsFalse, OpenKeys, Specification, Assignment, Key, Truth).

changes_decide([First], [Second], _, _, _, _, true) :-
    First \== Second.
changes_decide([First], [Second], _, _, _, _, false) :-
    First == Second.
changes_decide(ResultsTrue, ResultsFalse, OpenKeys, Specification, Assignment, Key, Truth) :-
    wide_pair(ResultsTrue, ResultsFalse),
    shared_results(ResultsTrue, ResultsFalse, Shared),
    changes_overlap(Shared, OpenKeys, Specification, Assignment, Key, Truth).

wide_pair([_, _|_], _).
wide_pair([_], [_, _|_]).

changes_overlap([], _, _, _, _, true).
changes_overlap([_|_], [Split|_], Specification, Assignment, Key, Truth) :-
    set_state(Assignment, Split, true, AssignmentTrue),
    changes_t(Specification, AssignmentTrue, Key, TruthOnTrue),
    changes_more(TruthOnTrue, Split, Specification, Assignment, Key, Truth).

changes_more(true, _, _, _, _, true).
changes_more(false, Split, Specification, Assignment, Key, Truth) :-
    set_state(Assignment, Split, false, AssignmentFalse),
    changes_t(Specification, AssignmentFalse, Key, Truth).

behind_t(Specification, Assignment, Key, Other, Truth) :-
    set_state(Assignment, Other, true, OtherTrue),
    set_state(Assignment, Other, false, OtherFalse),
    changes_t(Specification, OtherTrue, Key, KeyOnTrue),
    changes_t(Specification, OtherFalse, Key, KeyOnFalse),
    behind_step(KeyOnTrue, KeyOnFalse, Specification, Assignment, Key, Other, Truth).

behind_step(KeyOnTrue, KeyOnFalse, _, _, _, _, false) :-
    KeyOnTrue == KeyOnFalse.
behind_step(KeyOnTrue, KeyOnFalse, Specification, Assignment, Key, Other, Truth) :-
    KeyOnTrue \== KeyOnFalse,
    set_state(Assignment, Key, true, KeyTrue),
    changes_t(Specification, KeyTrue, Other, OtherOnTrue),
    behind_finish(OtherOnTrue, Specification, Assignment, Key, Other, Truth).

behind_finish(false, _, _, _, _, false).
behind_finish(true, Specification, Assignment, Key, Other, Truth) :-
    set_state(Assignment, Key, false, KeyFalse),
    changes_t(Specification, KeyFalse, Other, Truth).

behind_any_t(_, _, _, [], false).
behind_any_t(Specification, Assignment, Key, [Other - State|Rest], Truth) :-
    behind_entry(State, Other, Specification, Assignment, Key, Rest, Truth).

behind_entry(State, _, Specification, Assignment, Key, Rest, Truth) :-
    State \== absent,
    behind_any_t(Specification, Assignment, Key, Rest, Truth).
behind_entry(absent, Other, Specification, Assignment, Key, Rest, Truth) :-
    Other == Key,
    behind_any_t(Specification, Assignment, Key, Rest, Truth).
behind_entry(absent, Other, Specification, Assignment, Key, Rest, Truth) :-
    Other \== Key,
    behind_t(Specification, Assignment, Key, Other, Behind),
    behind_more(Behind, Specification, Assignment, Key, Rest, Truth).

behind_more(true, _, _, _, _, true).
behind_more(false, Specification, Assignment, Key, Rest, Truth) :-
    behind_any_t(Specification, Assignment, Key, Rest, Truth).

first_needed(_, _, [], none).
first_needed(Specification, Assignment, [Key - State|Rest], Needed) :-
    needed_entry(State, Key, Specification, Assignment, Rest, Needed).

needed_entry(State, _, Specification, Assignment, Rest, Needed) :-
    State \== absent,
    first_needed(Specification, Assignment, Rest, Needed).
needed_entry(absent, Key, Specification, Assignment, Rest, Needed) :-
    changes_t(Specification, Assignment, Key, Changes),
    needed_changes(Changes, Key, Specification, Assignment, Rest, Needed).

needed_changes(false, _, Specification, Assignment, Rest, Needed) :-
    first_needed(Specification, Assignment, Rest, Needed).
needed_changes(true, Key, Specification, Assignment, Rest, Needed) :-
    behind_any_t(Specification, Assignment, Key, Assignment, Behind),
    needed_behind(Behind, Key, Specification, Assignment, Rest, Needed).

needed_behind(false, Key, _, _, _, key(Key)).
needed_behind(true, _, Specification, Assignment, Rest, Needed) :-
    first_needed(Specification, Assignment, Rest, Needed).

first_unsure(_, _, [], none).
first_unsure(Specification, Assignment, [Key - State|Rest], Found) :-
    unsure_entry(State, Key, Specification, Assignment, Rest, Found).

unsure_entry(State, _, Specification, Assignment, Rest, Found) :-
    State \== unsure,
    first_unsure(Specification, Assignment, Rest, Found).
unsure_entry(unsure, Key, Specification, Assignment, Rest, Found) :-
    changes_t(Specification, Assignment, Key, Changes),
    unsure_changes(Changes, Key, Specification, Assignment, Rest, Found).

unsure_changes(true, Key, _, _, _, key(Key)).
unsure_changes(false, _, Specification, Assignment, Rest, Found) :-
    first_unsure(Specification, Assignment, Rest, Found).

relied_pairs([], []).
relied_pairs([_ - absent|Rest], Pairs) :-
    relied_pairs(Rest, Pairs).
relied_pairs([Key - State|Rest], [Key - State|Pairs]) :-
    State \== absent,
    relied_pairs(Rest, Pairs).

query_outcome(Query, Profile, Outcome) :-
    query_specification(Query, Keys, Specification),
    build_assignment(Profile, Keys, Assignment),
    exact_results(Specification, Assignment, Results),
    settle(Results, Query, Specification, Assignment, Outcome).

settle([Result], _, _, _, final(Result)).
settle([_, _|_], Query, Specification, Assignment, Outcome) :-
    first_needed(Specification, Assignment, Assignment, Needed),
    needed_outcome(Needed, Query, Specification, Assignment, Outcome).

needed_outcome(key(Key), _, _, _, status(indeterminate([Key]))).
needed_outcome(none, Query, Specification, Assignment, status(needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]))) :-
    first_unsure(Specification, Assignment, Assignment, key(Key)),
    referral(Query, Key, Citation),
    relied_pairs(Assignment, Pairs).

query_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
query_answer([], Query, Profile, Result, Citations) :-
    query_outcome(Query, Profile, Outcome),
    outcome_answer(Outcome, Query, Result, Citations).

outcome_answer(final(Result), Query, Result, Citations) :-
    result_citations(Query, Result, Citations).
outcome_answer(status(Status), _, Status, []).

swiss_information_duty(Profile, Result, Citations) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    query_answer(Problems, swiss_information_duty, Profile, Result, Citations).

swiss_minimum_information_item(Profile, Item, Result, Citations) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, ProfileProblems),
    item_problems(Item, ItemProblems),
    append(ProfileProblems, ItemProblems, Problems),
    query_answer(Problems, minimum_item(Item), Profile, Result, Citations).

item_problems(Item, [wrong_type(information_item)]) :-
    var(Item).
item_problems(Item, Problems) :-
    nonvar(Item),
    information_items(Items),
    memberd_t(Item, Items, Known),
    item_known_problems(Known, Problems).

item_known_problems(true, []).
item_known_problems(false, [wrong_type(information_item)]).

swiss_automated_decision_information(Profile, Result, Citations) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    query_answer(Problems, swiss_automated_decision_information, Profile, Result, Citations).

swiss_automated_decision_review(Profile, Result, Citations) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    query_answer(Problems, swiss_automated_decision_review, Profile, Result, Citations).

swiss_automated_decision_marking(Profile, Result, Citations) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    query_answer(Problems, swiss_automated_decision_marking, Profile, Result, Citations).

swiss_impact_assessment(Profile, Result, Citations) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    query_answer(Problems, swiss_impact_assessment, Profile, Result, Citations).

eu_information_duty(Profile, Result, Citations) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    query_answer(Problems, eu_information_duty, Profile, Result, Citations).

eu_automated_decision_information(Profile, Result, Citations) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    query_answer(Problems, eu_automated_decision_information, Profile, Result, Citations).

eu_impact_assessment(Profile, Result, Citations) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    query_answer(Problems, eu_impact_assessment, Profile, Result, Citations).

compare_swiss_eu_information_duty(Profile, SwissResult, EuResult, Difference, ChangedBy) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    comparison_answer(Problems, compare_swiss_eu_information_duty, Profile, SwissResult, EuResult, Difference, ChangedBy).

compare_swiss_eu_automated_decision_information(Profile, SwissResult, EuResult, Difference, ChangedBy) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    comparison_answer(Problems, compare_swiss_eu_automated_decision_information, Profile, SwissResult, EuResult, Difference, ChangedBy).

compare_swiss_eu_impact_assessment(Profile, SwissResult, EuResult, Difference, ChangedBy) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    comparison_answer(Problems, compare_swiss_eu_impact_assessment, Profile, SwissResult, EuResult, Difference, ChangedBy).

comparison_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), input_problems([Problem|Problems]), input_problems([Problem|Problems]), []).
comparison_answer([], Comparison, Profile, SwissResult, EuResult, Difference, ChangedBy) :-
    comparison_pair(Comparison, SwissQuery, EuQuery),
    query_outcome(SwissQuery, Profile, SwissOutcome),
    outcome_answer(SwissOutcome, SwissQuery, SwissResult, _),
    query_outcome(EuQuery, Profile, EuOutcome),
    outcome_answer(EuOutcome, EuQuery, EuResult, _),
    query_outcome(Comparison, Profile, DifferenceOutcome),
    difference_answer(DifferenceOutcome, Comparison, Difference, ChangedBy).

difference_answer(final(differs), Comparison, differs, ChangedBy) :-
    changed_by_row(Comparison, ChangedBy).
difference_answer(final(same), _, same, []).
difference_answer(status(Status), _, Status, []).

decide_swiss_fadp_s2_information_duties_and_dpia(Profile, swiss_fadp_s2_information_duties_and_dpia_verdict(Status, Citations)) :-
    swiss_information_duty(Profile, Status, Citations).

swiss_fadp_s2_information_duties_and_dpia_status(Profile, Status) :-
    decide_swiss_fadp_s2_information_duties_and_dpia(Profile, swiss_fadp_s2_information_duties_and_dpia_verdict(Status, _Citations)).

swiss_fadp_s2_information_duties_and_dpia_checklist(Profile, Items) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    checklist_items(Problems, Profile, Items).

checklist_items([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(ch_fadp_art_19_1))]).
checklist_items([], Profile, [item(swiss_information_duty, Result, Citations)|Rows]) :-
    swiss_information_duty(Profile, Result, Citations),
    query_keys(swiss_information_duty, Keys),
    build_assignment(Profile, Keys, Assignment),
    findall(Row, ground_row(Assignment, Row), Rows).

ground_row(Assignment, item(Name, Status, Citation)) :-
    checklist_ground(Name, Citation),
    condition(Name, Formula),
    evaluate(Formula, Assignment, Value, OpenKeys),
    ground_status(Value, Name, OpenKeys, Status).

ground_status(true, _, _, met).
ground_status(false, Name, _, unmet(Name)).
ground_status(open, _, OpenKeys, unknown(Keys)) :-
    sort(OpenKeys, Keys).

swiss_fadp_s2_information_duties_and_dpia_decision_resolvable(Profile) :-
    swiss_information_duty(Profile, Result, _),
    swiss_fadp_s2_information_duties_and_dpia_status_values(Values),
    member(Result, Values).

test(empty_profile_names_the_first_key_not_behind_another) :-
    swiss_information_duty([], indeterminate([data_subject_already_has_information]), []).
test(empty_profile_gives_exactly_one_solution) :-
    findall(Result - Citations, swiss_information_duty([], Result, Citations), Answers),
    length(Answers, 1).
test(already_informed_settles_not_required) :-
    swiss_information_duty([attribute(data_subject_already_has_information, true)], information_not_required, Citations),
    member(cite(ch_fadp_art_20_1_a), Citations).
test(third_party_interests_permit_restriction) :-
    swiss_information_duty([attribute(controller_is_federal_body, false), attribute(personal_data_collected_from_data_subject, true), attribute(data_subject_already_has_information, false), attribute(processing_provided_for_by_law, false), attribute(controller_bound_by_statutory_secrecy, false), attribute(article_27_conditions_met, false), attribute(overriding_third_party_interests_require_restriction, true)], information_may_be_restricted_deferred_or_omitted, Citations),
    member(cite(ch_fadp_art_20_4), Citations).
test(swiss_permission_differs_from_any_eu_answer) :-
    compare_swiss_eu_information_duty([attribute(controller_is_federal_body, false), attribute(personal_data_collected_from_data_subject, true), attribute(data_subject_already_has_information, false), attribute(processing_provided_for_by_law, false), attribute(controller_bound_by_statutory_secrecy, false), attribute(article_27_conditions_met, false), attribute(overriding_third_party_interests_require_restriction, true)], information_may_be_restricted_deferred_or_omitted, indeterminate([eu_data_subject_already_has_information]), differs, ChangedBy),
    member(cite(eu_reg_2016_679_art_13_4), ChangedBy).
test(unknown_key_is_an_input_problem) :-
    swiss_information_duty([attribute(foreign_key_name, true)], input_problems([unknown_key(foreign_key_name)]), []).
test(identity_item_is_always_required) :-
    swiss_minimum_information_item([], identity_and_contact_details_of_controller, information_item_required, [cite(ch_fadp_art_19_2), cite(ch_fadp_art_19_2_a)]).
test(unknown_item_is_wrong_type) :-
    swiss_minimum_information_item([], unlisted_item, input_problems([wrong_type(information_item)]), []).
test(safeguards_item_not_required_without_reliance) :-
    swiss_minimum_information_item([attribute(disclosure_abroad_relies_on_safeguards_or_exception, false)], safeguards_or_exception_relied_on, information_item_not_required, [cite(ch_fadp_art_19_4)]).
test(safeguards_item_names_abroad_first) :-
    swiss_minimum_information_item([], safeguards_or_exception_relied_on, indeterminate([personal_data_disclosed_abroad]), []).
test(federal_body_marks_automated_decision) :-
    swiss_automated_decision_marking([attribute(controller_is_federal_body, true), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_has_legal_consequence_or_significantly_impairs_data_subject, true)], decision_marking_required, [cite(ch_fadp_art_21_1), cite(ch_fadp_art_21_4)]).
test(unsure_high_risk_goes_to_a_lawyer) :-
    swiss_impact_assessment([attribute(controller_is_federal_body, true), attribute(processing_may_entail_high_risk_to_personality_or_fundamental_rights, unsure), attribute(large_scale_processing_of_sensitive_personal_data, false), attribute(systematic_large_scale_monitoring_of_public_areas, false)], needs_legal_review(open_textured(processing_may_entail_high_risk_to_personality_or_fundamental_rights, cite(ch_fadp_art_22_1)), [inputs_relied_on([controller_is_federal_body - true, processing_may_entail_high_risk_to_personality_or_fundamental_rights - unsure, large_scale_processing_of_sensitive_personal_data - false, systematic_large_scale_monitoring_of_public_areas - false])]), []).
test(eu_article_35_10_exemption_settles_not_required) :-
    eu_impact_assessment([attribute(eu_article_35_10_exemption_applies, true)], impact_assessment_not_required, Citations),
    member(cite(eu_reg_2016_679_art_35_10), Citations).
test(checklist_carries_the_headline_row) :-
    swiss_fadp_s2_information_duties_and_dpia_checklist([attribute(data_subject_already_has_information, true)], [item(swiss_information_duty, information_not_required, _)|_]).

test(third_party_interests_profile_is_not_required, fail) :-
    swiss_information_duty([attribute(controller_is_federal_body, false), attribute(personal_data_collected_from_data_subject, true), attribute(data_subject_already_has_information, false), attribute(processing_provided_for_by_law, false), attribute(controller_bound_by_statutory_secrecy, false), attribute(article_27_conditions_met, false), attribute(overriding_third_party_interests_require_restriction, true)], information_required, _).
