% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_small_items, [bias_data_processing_status/4, sandbox_personal_data_processing_status/4, real_world_testing_status/4, informed_consent_status/4, sme_simplified_compliance_status/4, explanation_right_status/4, decide_small_items/2, small_items_status/2, small_items_checklist/2, small_items_decision_resolvable/1, small_items_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(reif), [tfilter/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_ai_act_small_items_kernel, [small_items_step_zero_problems/3, small_items_date_before_t/3]).
:- use_module(m__eu_ai_act_small_items_citations, [implements/1]).

application_date(bias_data_processing, date(2026, 7, 27), cite(eu_reg_2024_1689_art_113_a)).
application_date(sandbox_personal_data_processing, date(2026, 8, 2), cite(eu_reg_2024_1689_art_113)).
application_date(real_world_testing, date(2026, 8, 2), cite(eu_reg_2024_1689_art_113)).
application_date(informed_consent, date(2026, 8, 2), cite(eu_reg_2024_1689_art_113)).
application_date(sme_simplified_compliance, date(2026, 8, 2), cite(eu_reg_2024_1689_art_113)).
application_date(explanation_right, date(2026, 8, 2), cite(eu_reg_2024_1689_art_113)).

small_items_status_values([not_applicable_on_date, bias_processing_not_permitted, bias_processing_permitted, sandbox_processing_not_permitted, sandbox_processing_permitted, testing_not_provided_for_by_the_member_state, subject_to_the_member_state_framework, real_world_testing_not_permitted, real_world_testing_permitted, consent_does_not_meet_article_61, consent_meets_article_61, no_simplified_compliance, may_comply_in_a_simplified_manner, no_right_to_explanation_under_article_86, right_to_explanation_under_article_86]).

query_key_list(bias_data_processing, [bias_processing_capacity - enumeration([provider_of_a_high_risk_system, other_provider_or_deployer]), strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g - judgement, strictly_necessary_for_bias_detection_and_correction_of_biases_affecting_health_safety_or_fundamental_rights - judgement, appropriate_safeguards_for_fundamental_rights_and_freedoms - judgement, bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data - judgement, technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures - judgement, measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation - judgement, data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties - crisp, data_deleted_once_bias_corrected_or_retention_period_ended - crisp, records_of_processing_include_the_reasons_for_the_processing - crisp]).
query_key_list(sandbox_personal_data_processing, [sandbox_processing_of_data_collected_for_other_purposes_solely_for_developing_training_and_testing - crisp, developed_for_safeguarding_substantial_public_interest - judgement, public_interest_area - enumeration([public_safety_and_public_health, environment, energy_sustainability, transport_and_critical_infrastructure, public_administration_and_public_services, none_of_the_listed_areas]), data_necessary_for_chapter_iii_section_2_requirements_and_non_personal_data_not_effective - judgement, effective_monitoring_and_response_mechanisms - judgement, functionally_separate_isolated_and_protected_environment_under_provider_control - crisp, data_shared_only_as_article_59_allows - crisp, processing_leads_to_no_measures_or_decisions_affecting_data_subjects_or_their_rights - crisp, appropriate_technical_and_organisational_measures - judgement, data_deleted_at_end_of_participation_or_retention_period - crisp, processing_logs_kept_for_the_duration_of_participation - crisp, description_of_process_and_rationale_kept_in_technical_documentation - crisp, project_summary_published_on_competent_authority_website - crisp, for_law_enforcement_purposes_under_law_enforcement_authority_control - crisp, based_on_specific_union_or_national_law - crisp]).
query_key_list(real_world_testing, [testing_route - enumeration([annex_iii, annex_i_section_a, annex_i_section_b]), member_state_has_adopted_a_real_world_testing_framework - crisp, testing_plan_drawn_up_and_submitted_to_the_market_surveillance_authority - crisp, approval_status - enumeration([approved, no_answer_within_30_days, not_approved]), national_law_provides_for_tacit_approval - crisp, testing_registered_as_article_60_4_c_requires - crisp, established_in_the_union_or_legal_representative_established_in_the_union - crisp, third_country_transfers_only_with_appropriate_and_applicable_safeguards - judgement, testing_duration - enumeration([up_to_six_months, extended_up_to_twelve_months, longer]), extension_notified_in_advance_with_explanation - crisp, testing_no_longer_than_necessary_to_achieve_its_objectives - judgement, vulnerable_subjects_appropriately_protected - judgement, testing_in_cooperation_with_deployers - crisp, deployers_informed_instructed_and_agreement_concluded - crisp, informed_consent_given_in_accordance_with_article_61 - crisp, law_enforcement_testing_where_seeking_consent_would_prevent_the_test - crisp, no_negative_effect_on_subjects_and_data_deleted_after_the_test - crisp, effectively_overseen_by_suitably_qualified_persons - judgement, outputs_can_be_effectively_reversed_and_disregarded - judgement]).
query_key_list(informed_consent, [consent_freely_given - judgement, consent_obtained_before_participation - crisp, information_concise_clear_relevant_and_understandable - judgement, informed_of_nature_objectives_and_possible_inconvenience - crisp, informed_of_conditions_and_expected_duration - crisp, informed_of_rights_and_guarantees_including_refusal_and_withdrawal - crisp, informed_of_arrangements_for_reversal_or_disregarding - crisp, informed_of_identification_number_and_contact_details - crisp, consent_dated_and_documented - crisp, copy_given_to_the_subject_or_legal_representative - crisp]).
query_key_list(sme_simplified_compliance, [is_an_sme_including_a_start_up - crisp, has_partner_or_linked_enterprises - crisp]).
query_key_list(explanation_right, [affected_person_subject_to_a_deployer_decision_based_on_the_system_output - crisp, system_is_a_high_risk_ai_system_listed_in_annex_iii - crisp, system_listed_under_point_2_of_annex_iii - crisp, decision_produces_legal_effects_or_similarly_significantly_affects_the_person - judgement, person_considers_an_adverse_impact_on_health_safety_or_fundamental_rights - crisp, union_or_national_law_provides_an_exception_or_restriction - crisp, right_otherwise_provided_for_under_union_law - crisp]).

key_domain(judgement, [true, false]).
key_domain(crisp, [true, false]).
key_domain(enumeration(Atoms), Atoms).

requirement(bias_provider_of_a_high_risk_system, strict_necessity_under_article_10, literal(strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g, true), cite(eu_reg_2024_1689_art_4a_1)).
requirement(bias_provider_of_a_high_risk_system, appropriate_safeguards, literal(appropriate_safeguards_for_fundamental_rights_and_freedoms, true), cite(eu_reg_2024_1689_art_4a_1)).
requirement(bias_provider_of_a_high_risk_system, other_data_not_effective, literal(bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data, true), cite(eu_reg_2024_1689_art_4a_1_a)).
requirement(bias_provider_of_a_high_risk_system, reuse_limitations_and_security, literal(technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures, true), cite(eu_reg_2024_1689_art_4a_1_b)).
requirement(bias_provider_of_a_high_risk_system, access_controls, literal(measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation, true), cite(eu_reg_2024_1689_art_4a_1_c)).
requirement(bias_provider_of_a_high_risk_system, no_access_by_other_parties, literal(data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties, true), cite(eu_reg_2024_1689_art_4a_1_d)).
requirement(bias_provider_of_a_high_risk_system, deletion, literal(data_deleted_once_bias_corrected_or_retention_period_ended, true), cite(eu_reg_2024_1689_art_4a_1_e)).
requirement(bias_provider_of_a_high_risk_system, records_of_processing, literal(records_of_processing_include_the_reasons_for_the_processing, true), cite(eu_reg_2024_1689_art_4a_1_f)).
requirement(bias_other_provider_or_deployer, strict_necessity_for_harmful_biases, literal(strictly_necessary_for_bias_detection_and_correction_of_biases_affecting_health_safety_or_fundamental_rights, true), cite(eu_reg_2024_1689_art_4a_2_a)).
requirement(bias_other_provider_or_deployer, appropriate_safeguards, literal(appropriate_safeguards_for_fundamental_rights_and_freedoms, true), cite(eu_reg_2024_1689_art_4a_1)).
requirement(bias_other_provider_or_deployer, other_data_not_effective, literal(bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data, true), cite(eu_reg_2024_1689_art_4a_1_a)).
requirement(bias_other_provider_or_deployer, reuse_limitations_and_security, literal(technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures, true), cite(eu_reg_2024_1689_art_4a_1_b)).
requirement(bias_other_provider_or_deployer, access_controls, literal(measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation, true), cite(eu_reg_2024_1689_art_4a_1_c)).
requirement(bias_other_provider_or_deployer, no_access_by_other_parties, literal(data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties, true), cite(eu_reg_2024_1689_art_4a_1_d)).
requirement(bias_other_provider_or_deployer, deletion, literal(data_deleted_once_bias_corrected_or_retention_period_ended, true), cite(eu_reg_2024_1689_art_4a_1_e)).
requirement(bias_other_provider_or_deployer, records_of_processing, literal(records_of_processing_include_the_reasons_for_the_processing, true), cite(eu_reg_2024_1689_art_4a_1_f)).
requirement(sandbox_personal_data_processing, processing_solely_for_developing_training_and_testing, literal(sandbox_processing_of_data_collected_for_other_purposes_solely_for_developing_training_and_testing, true), cite(eu_reg_2024_1689_art_59_1)).
requirement(sandbox_personal_data_processing, substantial_public_interest, literal(developed_for_safeguarding_substantial_public_interest, true), cite(eu_reg_2024_1689_art_59_1_a)).
requirement(sandbox_personal_data_processing, listed_public_interest_area, negation(literal(public_interest_area, none_of_the_listed_areas)), cite(eu_reg_2024_1689_art_59_1_a)).
requirement(sandbox_personal_data_processing, personal_data_necessary, literal(data_necessary_for_chapter_iii_section_2_requirements_and_non_personal_data_not_effective, true), cite(eu_reg_2024_1689_art_59_1_b)).
requirement(sandbox_personal_data_processing, monitoring_and_response, literal(effective_monitoring_and_response_mechanisms, true), cite(eu_reg_2024_1689_art_59_1_c)).
requirement(sandbox_personal_data_processing, separate_environment, literal(functionally_separate_isolated_and_protected_environment_under_provider_control, true), cite(eu_reg_2024_1689_art_59_1_d)).
requirement(sandbox_personal_data_processing, sharing_limits, literal(data_shared_only_as_article_59_allows, true), cite(eu_reg_2024_1689_art_59_1_e)).
requirement(sandbox_personal_data_processing, no_measures_or_decisions, literal(processing_leads_to_no_measures_or_decisions_affecting_data_subjects_or_their_rights, true), cite(eu_reg_2024_1689_art_59_1_f)).
requirement(sandbox_personal_data_processing, technical_and_organisational_measures, literal(appropriate_technical_and_organisational_measures, true), cite(eu_reg_2024_1689_art_59_1_g)).
requirement(sandbox_personal_data_processing, deletion, literal(data_deleted_at_end_of_participation_or_retention_period, true), cite(eu_reg_2024_1689_art_59_1_g)).
requirement(sandbox_personal_data_processing, processing_logs, literal(processing_logs_kept_for_the_duration_of_participation, true), cite(eu_reg_2024_1689_art_59_1_h)).
requirement(sandbox_personal_data_processing, technical_documentation, literal(description_of_process_and_rationale_kept_in_technical_documentation, true), cite(eu_reg_2024_1689_art_59_1_i)).
requirement(sandbox_personal_data_processing, published_summary, literal(project_summary_published_on_competent_authority_website, true), cite(eu_reg_2024_1689_art_59_1_j)).
requirement(sandbox_personal_data_processing, law_enforcement_legal_basis, any([literal(for_law_enforcement_purposes_under_law_enforcement_authority_control, false), literal(based_on_specific_union_or_national_law, true)]), cite(eu_reg_2024_1689_art_59_2)).
requirement(real_world_testing, testing_plan, literal(testing_plan_drawn_up_and_submitted_to_the_market_surveillance_authority, true), cite(eu_reg_2024_1689_art_60_4_a)).
requirement(real_world_testing, approval, any([literal(approval_status, approved), all([literal(approval_status, no_answer_within_30_days), literal(national_law_provides_for_tacit_approval, true)])]), cite(eu_reg_2024_1689_art_60_4_b)).
requirement(real_world_testing, registration, literal(testing_registered_as_article_60_4_c_requires, true), cite(eu_reg_2024_1689_art_60_4_c)).
requirement(real_world_testing, establishment_in_the_union, literal(established_in_the_union_or_legal_representative_established_in_the_union, true), cite(eu_reg_2024_1689_art_60_4_d)).
requirement(real_world_testing, third_country_transfers, literal(third_country_transfers_only_with_appropriate_and_applicable_safeguards, true), cite(eu_reg_2024_1689_art_60_4_e)).
requirement(real_world_testing, duration_necessary, literal(testing_no_longer_than_necessary_to_achieve_its_objectives, true), cite(eu_reg_2024_1689_art_60_4_f)).
requirement(real_world_testing, duration_limit, any([literal(testing_duration, up_to_six_months), all([literal(testing_duration, extended_up_to_twelve_months), literal(extension_notified_in_advance_with_explanation, true)])]), cite(eu_reg_2024_1689_art_60_4_f)).
requirement(real_world_testing, vulnerable_subjects, literal(vulnerable_subjects_appropriately_protected, true), cite(eu_reg_2024_1689_art_60_4_g)).
requirement(real_world_testing, deployer_cooperation, any([literal(testing_in_cooperation_with_deployers, false), literal(deployers_informed_instructed_and_agreement_concluded, true)]), cite(eu_reg_2024_1689_art_60_4_h)).
requirement(real_world_testing, informed_consent, any([literal(informed_consent_given_in_accordance_with_article_61, true), all([literal(law_enforcement_testing_where_seeking_consent_would_prevent_the_test, true), literal(no_negative_effect_on_subjects_and_data_deleted_after_the_test, true)])]), cite(eu_reg_2024_1689_art_60_4_i)).
requirement(real_world_testing, oversight, literal(effectively_overseen_by_suitably_qualified_persons, true), cite(eu_reg_2024_1689_art_60_4_j)).
requirement(real_world_testing, reversal_of_outputs, literal(outputs_can_be_effectively_reversed_and_disregarded, true), cite(eu_reg_2024_1689_art_60_4_k)).
requirement(real_world_testing_framework, framework_adopted, literal(member_state_has_adopted_a_real_world_testing_framework, true), cite(eu_reg_2024_1689_art_60a_2)).
requirement(informed_consent, freely_given, literal(consent_freely_given, true), cite(eu_reg_2024_1689_art_61_1)).
requirement(informed_consent, before_participation, literal(consent_obtained_before_participation, true), cite(eu_reg_2024_1689_art_61_1)).
requirement(informed_consent, clear_information, literal(information_concise_clear_relevant_and_understandable, true), cite(eu_reg_2024_1689_art_61_1)).
requirement(informed_consent, nature_and_objectives, literal(informed_of_nature_objectives_and_possible_inconvenience, true), cite(eu_reg_2024_1689_art_61_1_a)).
requirement(informed_consent, conditions_and_duration, literal(informed_of_conditions_and_expected_duration, true), cite(eu_reg_2024_1689_art_61_1_b)).
requirement(informed_consent, rights_and_guarantees, literal(informed_of_rights_and_guarantees_including_refusal_and_withdrawal, true), cite(eu_reg_2024_1689_art_61_1_c)).
requirement(informed_consent, reversal_arrangements, literal(informed_of_arrangements_for_reversal_or_disregarding, true), cite(eu_reg_2024_1689_art_61_1_d)).
requirement(informed_consent, identification_and_contact, literal(informed_of_identification_number_and_contact_details, true), cite(eu_reg_2024_1689_art_61_1_e)).
requirement(informed_consent, dated_and_documented, literal(consent_dated_and_documented, true), cite(eu_reg_2024_1689_art_61_2)).
requirement(informed_consent, copy_given, literal(copy_given_to_the_subject_or_legal_representative, true), cite(eu_reg_2024_1689_art_61_2)).
requirement(sme_simplified_compliance, small_or_medium_enterprise, literal(is_an_sme_including_a_start_up, true), cite(eu_reg_2024_1689_art_63_1)).
requirement(sme_simplified_compliance, no_partner_or_linked_enterprises, literal(has_partner_or_linked_enterprises, false), cite(eu_reg_2024_1689_art_63_1)).
requirement(explanation_right, affected_person, literal(affected_person_subject_to_a_deployer_decision_based_on_the_system_output, true), cite(eu_reg_2024_1689_art_86_1)).
requirement(explanation_right, annex_iii_high_risk_system, literal(system_is_a_high_risk_ai_system_listed_in_annex_iii, true), cite(eu_reg_2024_1689_art_86_1)).
requirement(explanation_right, not_point_2_of_annex_iii, literal(system_listed_under_point_2_of_annex_iii, false), cite(eu_reg_2024_1689_art_86_1)).
requirement(explanation_right, significant_effects, literal(decision_produces_legal_effects_or_similarly_significantly_affects_the_person, true), cite(eu_reg_2024_1689_art_86_1)).
requirement(explanation_right, adverse_impact_considered, literal(person_considers_an_adverse_impact_on_health_safety_or_fundamental_rights, true), cite(eu_reg_2024_1689_art_86_1)).
requirement(explanation_right, no_exception_or_restriction, literal(union_or_national_law_provides_an_exception_or_restriction, false), cite(eu_reg_2024_1689_art_86_2)).
requirement(explanation_right, not_otherwise_provided, literal(right_otherwise_provided_for_under_union_law, false), cite(eu_reg_2024_1689_art_86_3)).

bias_capacity_citations(provider_of_a_high_risk_system, bias_provider_of_a_high_risk_system, [cite(eu_reg_2024_1689_art_4a_1), cite(eu_reg_2024_1689_art_4a_1_a), cite(eu_reg_2024_1689_art_4a_1_b), cite(eu_reg_2024_1689_art_4a_1_c), cite(eu_reg_2024_1689_art_4a_1_d), cite(eu_reg_2024_1689_art_4a_1_e), cite(eu_reg_2024_1689_art_4a_1_f)]).
bias_capacity_citations(other_provider_or_deployer, bias_other_provider_or_deployer, [cite(eu_reg_2024_1689_art_4a_2), cite(eu_reg_2024_1689_art_4a_2_a), cite(eu_reg_2024_1689_art_4a_2_b), cite(eu_reg_2024_1689_art_4a_1), cite(eu_reg_2024_1689_art_4a_1_a), cite(eu_reg_2024_1689_art_4a_1_b), cite(eu_reg_2024_1689_art_4a_1_c), cite(eu_reg_2024_1689_art_4a_1_d), cite(eu_reg_2024_1689_art_4a_1_e), cite(eu_reg_2024_1689_art_4a_1_f)]).

testing_route_article(annex_iii, article_60, cite(eu_reg_2024_1689_art_60_1)).
testing_route_article(annex_i_section_a, article_60, cite(eu_reg_2024_1689_art_60_1)).
testing_route_article(annex_i_section_b, article_60a, cite(eu_reg_2024_1689_art_60a_1)).

referral(strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g, cite(eu_reg_2024_1689_art_4a_1)).
referral(strictly_necessary_for_bias_detection_and_correction_of_biases_affecting_health_safety_or_fundamental_rights, cite(eu_reg_2024_1689_art_4a_2_a)).
referral(appropriate_safeguards_for_fundamental_rights_and_freedoms, cite(eu_reg_2024_1689_art_4a_1)).
referral(bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data, cite(eu_reg_2024_1689_art_4a_1_a)).
referral(technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures, cite(eu_reg_2024_1689_art_4a_1_b)).
referral(measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation, cite(eu_reg_2024_1689_art_4a_1_c)).
referral(developed_for_safeguarding_substantial_public_interest, cite(eu_reg_2024_1689_art_59_1_a)).
referral(data_necessary_for_chapter_iii_section_2_requirements_and_non_personal_data_not_effective, cite(eu_reg_2024_1689_art_59_1_b)).
referral(effective_monitoring_and_response_mechanisms, cite(eu_reg_2024_1689_art_59_1_c)).
referral(appropriate_technical_and_organisational_measures, cite(eu_reg_2024_1689_art_59_1_g)).
referral(third_country_transfers_only_with_appropriate_and_applicable_safeguards, cite(eu_reg_2024_1689_art_60_4_e)).
referral(testing_no_longer_than_necessary_to_achieve_its_objectives, cite(eu_reg_2024_1689_art_60_4_f)).
referral(vulnerable_subjects_appropriately_protected, cite(eu_reg_2024_1689_art_60_4_g)).
referral(effectively_overseen_by_suitably_qualified_persons, cite(eu_reg_2024_1689_art_60_4_j)).
referral(outputs_can_be_effectively_reversed_and_disregarded, cite(eu_reg_2024_1689_art_60_4_k)).
referral(consent_freely_given, cite(eu_reg_2024_1689_art_61_1)).
referral(information_concise_clear_relevant_and_understandable, cite(eu_reg_2024_1689_art_61_1)).
referral(decision_produces_legal_effects_or_similarly_significantly_affects_the_person, cite(eu_reg_2024_1689_art_86_1)).

bias_data_processing_status(Profile, AssessmentDate, Result, Citations) :-
    small_items_step_zero_problems(Profile, AssessmentDate, Problems),
    query_answer(Problems, bias_data_processing, Profile, AssessmentDate, Result, Citations).

sandbox_personal_data_processing_status(Profile, AssessmentDate, Result, Citations) :-
    small_items_step_zero_problems(Profile, AssessmentDate, Problems),
    query_answer(Problems, sandbox_personal_data_processing, Profile, AssessmentDate, Result, Citations).

real_world_testing_status(Profile, AssessmentDate, Result, Citations) :-
    small_items_step_zero_problems(Profile, AssessmentDate, Problems),
    query_answer(Problems, real_world_testing, Profile, AssessmentDate, Result, Citations).

informed_consent_status(Profile, AssessmentDate, Result, Citations) :-
    small_items_step_zero_problems(Profile, AssessmentDate, Problems),
    query_answer(Problems, informed_consent, Profile, AssessmentDate, Result, Citations).

sme_simplified_compliance_status(Profile, AssessmentDate, Result, Citations) :-
    small_items_step_zero_problems(Profile, AssessmentDate, Problems),
    query_answer(Problems, sme_simplified_compliance, Profile, AssessmentDate, Result, Citations).

explanation_right_status(Profile, AssessmentDate, Result, Citations) :-
    small_items_step_zero_problems(Profile, AssessmentDate, Problems),
    query_answer(Problems, explanation_right, Profile, AssessmentDate, Result, Citations).

query_answer([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).
query_answer([], Query, Profile, AssessmentDate, Result, Citations) :-
    application_date(Query, FirstDay, _),
    small_items_date_before_t(AssessmentDate, FirstDay, Before),
    dated_answer(Before, Query, Profile, Result, Citations).

dated_answer(true, Query, _, not_applicable_on_date, [Citation]) :-
    implements(eu_reg_2024_1689_art_113),
    application_date(Query, _, Citation).
dated_answer(false, Query, Profile, Result, Citations) :-
    ladder(Query, Profile, Result, Citations).

ladder(bias_data_processing, Profile, Result, Citations) :-
    bias_ladder(Profile, Result, Citations).
ladder(sandbox_personal_data_processing, Profile, Result, Citations) :-
    implements(eu_reg_2024_1689_art_59_1),
    conjunction_status(sandbox_personal_data_processing, sandbox_personal_data_processing, Profile, Outcome),
    sandbox_outcome(Outcome, Result, Citations).
ladder(real_world_testing, Profile, Result, Citations) :-
    real_world_ladder(Profile, Result, Citations).
ladder(informed_consent, Profile, Result, Citations) :-
    implements(eu_reg_2024_1689_art_61_1),
    conjunction_status(informed_consent, informed_consent, Profile, Outcome),
    consent_outcome(Outcome, Result, Citations).
ladder(sme_simplified_compliance, Profile, Result, Citations) :-
    implements(eu_reg_2024_1689_art_63_1),
    conjunction_status(sme_simplified_compliance, sme_simplified_compliance, Profile, Outcome),
    sme_outcome(Outcome, Result, Citations).
ladder(explanation_right, Profile, Result, Citations) :-
    implements(eu_reg_2024_1689_art_86_1),
    conjunction_status(explanation_right, explanation_right, Profile, Outcome),
    explanation_outcome(Outcome, Result, Citations).

bias_ladder(Profile, indeterminate([bias_processing_capacity]), []) :-
    profile_lacks(Profile, bias_processing_capacity).
bias_ladder(Profile, Result, Citations) :-
    implements(eu_reg_2024_1689_art_4a_1),
    profile_get(Profile, bias_processing_capacity, provider_of_a_high_risk_system),
    bias_capacity_citations(provider_of_a_high_risk_system, RequirementSet, CapacityCitations),
    conjunction_status(bias_data_processing, RequirementSet, Profile, Outcome),
    bias_outcome(Outcome, CapacityCitations, Result, Citations).
bias_ladder(Profile, Result, Citations) :-
    implements(eu_reg_2024_1689_art_4a_2),
    profile_get(Profile, bias_processing_capacity, other_provider_or_deployer),
    bias_capacity_citations(other_provider_or_deployer, RequirementSet, CapacityCitations),
    conjunction_status(bias_data_processing, RequirementSet, Profile, Outcome),
    bias_outcome(Outcome, CapacityCitations, Result, Citations).

bias_outcome(negative, Citations, bias_processing_not_permitted, Citations) :-
    implements(eu_reg_2024_1689_art_4a_1).
bias_outcome(positive, Citations, bias_processing_permitted, Citations) :-
    implements(eu_reg_2024_1689_art_4a_1).
bias_outcome(open(Status), _, Status, []).

sandbox_outcome(negative, sandbox_processing_not_permitted, [cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)]) :-
    implements(eu_reg_2024_1689_art_59_1).
sandbox_outcome(positive, sandbox_processing_permitted, [cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)]) :-
    implements(eu_reg_2024_1689_art_59_1).
sandbox_outcome(open(Status), Status, []).

real_world_ladder(Profile, indeterminate([testing_route]), []) :-
    profile_lacks(Profile, testing_route).
real_world_ladder(Profile, Result, Citations) :-
    implements(eu_reg_2024_1689_art_60a_1),
    profile_get(Profile, testing_route, Route),
    testing_route_article(Route, article_60a, _),
    framework_route(Profile, Result, Citations).
real_world_ladder(Profile, Result, Citations) :-
    implements(eu_reg_2024_1689_art_60_1),
    profile_get(Profile, testing_route, Route),
    testing_route_article(Route, article_60, _),
    conjunction_status(real_world_testing, real_world_testing, Profile, Outcome),
    real_world_outcome(Outcome, Result, Citations).

framework_route(Profile, indeterminate([member_state_has_adopted_a_real_world_testing_framework]), []) :-
    profile_lacks(Profile, member_state_has_adopted_a_real_world_testing_framework).
framework_route(Profile, testing_not_provided_for_by_the_member_state, [cite(eu_reg_2024_1689_art_60a_1), cite(eu_reg_2024_1689_art_60a_2)]) :-
    implements(eu_reg_2024_1689_art_60a_2),
    profile_get(Profile, member_state_has_adopted_a_real_world_testing_framework, false).
framework_route(Profile, subject_to_the_member_state_framework, [cite(eu_reg_2024_1689_art_60a_1), cite(eu_reg_2024_1689_art_60a_5)]) :-
    implements(eu_reg_2024_1689_art_60a_5),
    profile_get(Profile, member_state_has_adopted_a_real_world_testing_framework, true).

real_world_outcome(negative, real_world_testing_not_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]) :-
    implements(eu_reg_2024_1689_art_60_4).
real_world_outcome(positive, real_world_testing_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]) :-
    implements(eu_reg_2024_1689_art_60_4).
real_world_outcome(open(Status), Status, []).

consent_outcome(negative, consent_does_not_meet_article_61, [cite(eu_reg_2024_1689_art_61_1), cite(eu_reg_2024_1689_art_61_1_a), cite(eu_reg_2024_1689_art_61_1_b), cite(eu_reg_2024_1689_art_61_1_c), cite(eu_reg_2024_1689_art_61_1_d), cite(eu_reg_2024_1689_art_61_1_e), cite(eu_reg_2024_1689_art_61_2)]) :-
    implements(eu_reg_2024_1689_art_61_2).
consent_outcome(positive, consent_meets_article_61, [cite(eu_reg_2024_1689_art_61_1), cite(eu_reg_2024_1689_art_61_1_a), cite(eu_reg_2024_1689_art_61_1_b), cite(eu_reg_2024_1689_art_61_1_c), cite(eu_reg_2024_1689_art_61_1_d), cite(eu_reg_2024_1689_art_61_1_e), cite(eu_reg_2024_1689_art_61_2)]) :-
    implements(eu_reg_2024_1689_art_61_2).
consent_outcome(open(Status), Status, []).

sme_outcome(negative, no_simplified_compliance, [cite(eu_reg_2024_1689_art_63_1), cite(eu_reg_2024_1689_art_63_2)]) :-
    implements(eu_reg_2024_1689_art_63_2).
sme_outcome(positive, may_comply_in_a_simplified_manner, [cite(eu_reg_2024_1689_art_63_1), cite(eu_reg_2024_1689_art_63_2)]) :-
    implements(eu_reg_2024_1689_art_63_2).
sme_outcome(open(Status), Status, []).

explanation_outcome(negative, no_right_to_explanation_under_article_86, [cite(eu_reg_2024_1689_art_86_1), cite(eu_reg_2024_1689_art_86_2), cite(eu_reg_2024_1689_art_86_3)]) :-
    implements(eu_reg_2024_1689_art_86_3).
explanation_outcome(positive, right_to_explanation_under_article_86, [cite(eu_reg_2024_1689_art_86_1), cite(eu_reg_2024_1689_art_86_2), cite(eu_reg_2024_1689_art_86_3)]) :-
    implements(eu_reg_2024_1689_art_86_3).
explanation_outcome(open(Status), Status, []).

conjunction_status(Query, RequirementSet, Profile, Outcome) :-
    findall(RequirementName - Formula, requirement(RequirementSet, RequirementName, Formula, _), Requirements),
    maplist(requirement_table(Query, Profile), Requirements, Tables),
    tables_outcome(Query, Profile, Tables, Outcome).

requirement_table(Query, Profile, RequirementName - Formula, table(RequirementName, Choices, Rows, CanBeTrue, CanBeFalse)) :-
    formula_keys(Formula, Keys),
    maplist(key_choice(Query, Profile), Keys, Choices),
    findall(Assignment - Truth, (choice_assignment(Choices, Assignment), formula_truth(Formula, Assignment, Truth)), Rows),
    pairs_values(Rows, Truths),
    memberd_t(true, Truths, CanBeTrue),
    memberd_t(false, Truths, CanBeFalse).

tables_outcome(Query, Profile, Tables, Outcome) :-
    findall(CanBeTrue, member(table(_, _, _, CanBeTrue, _), Tables), TrueFlags),
    findall(CanBeFalse, member(table(_, _, _, _, CanBeFalse), Tables), FalseFlags),
    memberd_t(false, TrueFlags, SomeCannotHold),
    memberd_t(true, FalseFlags, SomeCanFail),
    flags_outcome(SomeCannotHold, SomeCanFail, Query, Profile, Tables, Outcome).

flags_outcome(true, _, _, _, _, negative).
flags_outcome(false, false, _, _, _, positive).
flags_outcome(false, true, Query, Profile, Tables, open(Status)) :-
    open_status(Query, Profile, Tables, Status).

open_status(Query, Profile, Tables, Status) :-
    query_key_list(Query, QueryKeys),
    findall(matter(Key, State, TableName), (member(Key - _, QueryKeys), mattering_key(Profile, Tables, Key, State, TableName)), Mattering),
    findall(Key - TableName, member(matter(Key, absent, TableName), Mattering), AbsentKeys),
    findall(Key, member(matter(Key, unsure, _), Mattering), UnsureKeys),
    open_status_from(AbsentKeys, UnsureKeys, Query, Profile, Tables, Status).

mattering_key(Profile, Tables, Key, State, TableName) :-
    member(table(TableName, Choices, Rows, _, _), Tables),
    member(Key - _, Choices),
    key_state(Profile, Key, State),
    findall(Assignment, local_flip(Rows, Key, Assignment), Flips),
    Flips = [_|_].

open_status_from(AbsentKeys, _, Query, _, Tables, indeterminate([Key])) :-
    AbsentKeys = [_|_],
    tfilter(not_behind_t(AbsentKeys, Query, Tables), AbsentKeys, Unblocked),
    choose_unblocked(Unblocked, AbsentKeys, Key).
open_status_from([], [Judgement|_], Query, Profile, _, needs_legal_review(open_textured(Judgement, Citation), [inputs_relied_on(Pairs)])) :-
    referral(Judgement, Citation),
    relied_pairs(Query, Profile, Pairs).

choose_unblocked([Key - _|_], _, Key).
choose_unblocked([], [Key - _|_], Key).

not_behind_t(AbsentKeys, Query, Tables, Candidate, Truth) :-
    behind_some_t(Candidate, AbsentKeys, Query, Tables, IsBehind),
    truth_not(IsBehind, Truth).

behind_some_t(_, [], _, _, false).
behind_some_t(Candidate, [Other|Others], Query, Tables, Truth) :-
    pair_behind_t(Candidate, Other, Query, Tables, PairTruth),
    behind_some_t(Candidate, Others, Query, Tables, RestTruth),
    truth_or(PairTruth, RestTruth, Truth).

pair_behind_t(Key - KeyTable, Other - OtherTable, Query, Tables, Truth) :-
    memberd_t(Other, [Key], Same),
    pair_behind_by(Same, Key - KeyTable, Other - OtherTable, Query, Tables, Truth).

pair_behind_by(true, _, _, _, _, false).
pair_behind_by(false, Key - KeyTable, Other - OtherTable, Query, Tables, Truth) :-
    witness_values(Tables, Key, KeyTable, Other, OtherTable, OtherValuesSeen),
    witness_values(Tables, Other, OtherTable, Key, KeyTable, KeyValuesSeen),
    sorted_domain(Query, Other, OtherDomain),
    sorted_domain(Query, Key, KeyDomain),
    memberd_t(OtherValuesSeen, [OtherDomain], OtherFullyRanged),
    truth_not(OtherFullyRanged, OtherRestricted),
    memberd_t(KeyValuesSeen, [KeyDomain], KeyFullyRanged),
    truth_and(OtherRestricted, KeyFullyRanged, Truth).

witness_values(Tables, Key, KeyTable, Other, OtherTable, Values) :-
    memberd_t(OtherTable, [KeyTable], SameTable),
    witness_values_by(SameTable, Tables, Key, KeyTable, Other, OtherTable, Values).

witness_values_by(true, Tables, Key, KeyTable, Other, _, Values) :-
    member(table(KeyTable, _, Rows, _, _), Tables),
    findall(Value, (local_flip(Rows, Key, Assignment), member(Other - Value, Assignment)), Found),
    sort(Found, Values).
witness_values_by(false, Tables, _, _, Other, OtherTable, Values) :-
    member(table(OtherTable, _, Rows, _, _), Tables),
    findall(Value, (member(Assignment - true, Rows), member(Other - Value, Assignment)), Found),
    sort(Found, Values).

local_flip(Rows, Key, Assignment) :-
    member(Assignment - Truth, Rows),
    select(Key - Value, Assignment, Rest),
    member(OtherAssignment - OtherTruth, Rows),
    select(Key - OtherValue, OtherAssignment, OtherRest),
    OtherRest == Rest,
    dif(Value, OtherValue),
    dif(Truth, OtherTruth).

sorted_domain(Query, Key, Domain) :-
    key_kind(Query, Key, Kind),
    key_domain(Kind, Values),
    sort(Values, Domain).

relied_pairs(Query, Profile, Pairs) :-
    query_key_list(Query, QueryKeys),
    findall(Key - Value, (member(Key - judgement, QueryKeys), profile_get(Profile, Key, Value)), Pairs).

key_kind(Query, Key, Kind) :-
    query_key_list(Query, QueryKeys),
    member(Key - Kind, QueryKeys).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, State) :-
    profile_get(Profile, Key, Value),
    memberd_t(Value, [unsure], IsUnsure),
    given_state(IsUnsure, Value, State).

given_state(true, _, unsure).
given_state(false, Value, given(Value)).

possible_values(absent, Kind, Values) :-
    key_domain(Kind, Values).
possible_values(unsure, _, [true, false]).
possible_values(given(Value), _, [Value]).

key_choice(Query, Profile, Key, Key - Values) :-
    key_kind(Query, Key, Kind),
    key_state(Profile, Key, State),
    possible_values(State, Kind, Values).

choice_assignment([], []).
choice_assignment([Key - Values|Choices], [Key - Value|Assignment]) :-
    member(Value, Values),
    choice_assignment(Choices, Assignment).

formula_keys(Formula, Keys) :-
    formula_key_occurrences(Formula, Occurrences),
    sort(Occurrences, Keys).

formula_key_occurrences(literal(Key, _), [Key]).
formula_key_occurrences(all(Formulas), Keys) :-
    maplist(formula_key_occurrences, Formulas, KeyLists),
    append(KeyLists, Keys).
formula_key_occurrences(any(Formulas), Keys) :-
    maplist(formula_key_occurrences, Formulas, KeyLists),
    append(KeyLists, Keys).
formula_key_occurrences(negation(Formula), Keys) :-
    formula_key_occurrences(Formula, Keys).

formula_truth(literal(Key, Wanted), Assignment, Truth) :-
    member(Key - Value, Assignment),
    memberd_t(Value, [Wanted], Truth).
formula_truth(all(Formulas), Assignment, Truth) :-
    all_truth(Formulas, Assignment, Truth).
formula_truth(any(Formulas), Assignment, Truth) :-
    any_truth(Formulas, Assignment, Truth).
formula_truth(negation(Formula), Assignment, Truth) :-
    formula_truth(Formula, Assignment, Inner),
    truth_not(Inner, Truth).

all_truth([], _, true).
all_truth([Formula|Formulas], Assignment, Truth) :-
    formula_truth(Formula, Assignment, First),
    all_truth(Formulas, Assignment, Rest),
    truth_and(First, Rest, Truth).

any_truth([], _, false).
any_truth([Formula|Formulas], Assignment, Truth) :-
    formula_truth(Formula, Assignment, First),
    any_truth(Formulas, Assignment, Rest),
    truth_or(First, Rest, Truth).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

truth_not(true, false).
truth_not(false, true).

query_status(bias_data_processing, Profile, AssessmentDate, Result, Citations) :-
    bias_data_processing_status(Profile, AssessmentDate, Result, Citations).
query_status(sandbox_personal_data_processing, Profile, AssessmentDate, Result, Citations) :-
    sandbox_personal_data_processing_status(Profile, AssessmentDate, Result, Citations).
query_status(real_world_testing, Profile, AssessmentDate, Result, Citations) :-
    real_world_testing_status(Profile, AssessmentDate, Result, Citations).
query_status(informed_consent, Profile, AssessmentDate, Result, Citations) :-
    informed_consent_status(Profile, AssessmentDate, Result, Citations).
query_status(sme_simplified_compliance, Profile, AssessmentDate, Result, Citations) :-
    sme_simplified_compliance_status(Profile, AssessmentDate, Result, Citations).
query_status(explanation_right, Profile, AssessmentDate, Result, Citations) :-
    explanation_right_status(Profile, AssessmentDate, Result, Citations).

decide_small_items(small_items_request(Query, Profile, AssessmentDate), small_items_verdict(Result, Citations)) :-
    query_status(Query, Profile, AssessmentDate, Result, Citations).

small_items_status(Request, Status) :-
    decide_small_items(Request, small_items_verdict(Status, _Citations)).

small_items_decision_resolvable(Request) :-
    decide_small_items(Request, _Verdict).

small_items_checklist(small_items_request(Query, Profile, _), Items) :-
    query_requirement_set(Query, Profile, RequirementSet),
    findall(RequirementName - Formula - Citation, requirement(RequirementSet, RequirementName, Formula, Citation), Requirements),
    maplist(checklist_item(Query, Profile), Requirements, Items).

query_requirement_set(bias_data_processing, Profile, RequirementSet) :-
    profile_get(Profile, bias_processing_capacity, Capacity),
    bias_capacity_citations(Capacity, RequirementSet, _).
query_requirement_set(sandbox_personal_data_processing, _, sandbox_personal_data_processing).
query_requirement_set(real_world_testing, Profile, RequirementSet) :-
    profile_get(Profile, testing_route, Route),
    testing_route_article(Route, Article, _),
    article_requirement_set(Article, RequirementSet).
query_requirement_set(informed_consent, _, informed_consent).
query_requirement_set(sme_simplified_compliance, _, sme_simplified_compliance).
query_requirement_set(explanation_right, _, explanation_right).

article_requirement_set(article_60, real_world_testing).
article_requirement_set(article_60a, real_world_testing_framework).

checklist_item(Query, Profile, RequirementName - Formula - Citation, item(RequirementName, Status, Citation)) :-
    requirement_table(Query, Profile, RequirementName - Formula, table(_, Choices, _, CanBeTrue, CanBeFalse)),
    item_status(CanBeTrue, CanBeFalse, RequirementName, Choices, Status).

item_status(false, _, RequirementName, _, unmet(RequirementName)).
item_status(true, false, _, _, met).
item_status(true, true, _, Choices, unknown(Keys)) :-
    findall(Key, member(Key - [_, _|_], Choices), Keys).

explanation_profile(Decision, Exception, [attribute(affected_person_subject_to_a_deployer_decision_based_on_the_system_output, true), attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, true), attribute(system_listed_under_point_2_of_annex_iii, false), attribute(decision_produces_legal_effects_or_similarly_significantly_affects_the_person, Decision), attribute(person_considers_an_adverse_impact_on_health_safety_or_fundamental_rights, true), attribute(union_or_national_law_provides_an_exception_or_restriction, Exception), attribute(right_otherwise_provided_for_under_union_law, false)]).

real_world_profile(Extra, Profile) :-
    append([attribute(testing_route, annex_iii), attribute(testing_plan_drawn_up_and_submitted_to_the_market_surveillance_authority, true), attribute(approval_status, approved), attribute(testing_registered_as_article_60_4_c_requires, true), attribute(established_in_the_union_or_legal_representative_established_in_the_union, true), attribute(third_country_transfers_only_with_appropriate_and_applicable_safeguards, true), attribute(testing_duration, up_to_six_months), attribute(testing_no_longer_than_necessary_to_achieve_its_objectives, true), attribute(vulnerable_subjects_appropriately_protected, true), attribute(law_enforcement_testing_where_seeking_consent_would_prevent_the_test, false), attribute(no_negative_effect_on_subjects_and_data_deleted_after_the_test, true), attribute(effectively_overseen_by_suitably_qualified_persons, true), attribute(outputs_can_be_effectively_reversed_and_disregarded, true)], Extra, Profile).

test(explanation_right_on_the_first_day) :-
    explanation_profile(true, false, Profile),
    explanation_right_status(Profile, date(2026, 8, 2), Result, Citations),
    Result == right_to_explanation_under_article_86,
    Citations == [cite(eu_reg_2024_1689_art_86_1), cite(eu_reg_2024_1689_art_86_2), cite(eu_reg_2024_1689_art_86_3)].
test(explanation_answers_exactly_once) :-
    explanation_profile(true, false, Profile),
    findall(Result - Citations, explanation_right_status(Profile, date(2026, 8, 2), Result, Citations), Answers),
    length(Answers, 1).
test(explanation_not_applicable_the_day_before) :-
    explanation_profile(true, false, Profile),
    explanation_right_status(Profile, date(2026, 8, 1), Result, Citations),
    Result == not_applicable_on_date,
    Citations == [cite(eu_reg_2024_1689_art_113)].
test(explanation_exception_removes_the_right) :-
    explanation_profile(true, true, Profile),
    explanation_right_status(Profile, date(2026, 8, 2), no_right_to_explanation_under_article_86, _).
test(explanation_unsure_judgement_is_referred) :-
    explanation_profile(unsure, false, Profile),
    explanation_right_status(Profile, date(2026, 8, 2), Result, Citations),
    Result == needs_legal_review(open_textured(decision_produces_legal_effects_or_similarly_significantly_affects_the_person, cite(eu_reg_2024_1689_art_86_1)), [inputs_relied_on([decision_produces_legal_effects_or_similarly_significantly_affects_the_person - unsure])]),
    Citations == [].
test(explanation_unsure_judgement_that_cannot_matter_is_settled) :-
    explanation_profile(unsure, true, Profile),
    explanation_right_status(Profile, date(2026, 8, 2), no_right_to_explanation_under_article_86, _).
test(sme_missing_partner_key_is_named) :-
    sme_simplified_compliance_status([attribute(is_an_sme_including_a_start_up, true)], date(2026, 9, 1), Result, Citations),
    Result == indeterminate([has_partner_or_linked_enterprises]),
    Citations == [].
test(sme_not_an_sme_is_settled_without_the_partner_key) :-
    sme_simplified_compliance_status([attribute(is_an_sme_including_a_start_up, false)], date(2026, 9, 1), Result, Citations),
    Result == no_simplified_compliance,
    Citations == [cite(eu_reg_2024_1689_art_63_1), cite(eu_reg_2024_1689_art_63_2)].
test(sme_may_simplify) :-
    sme_simplified_compliance_status([attribute(is_an_sme_including_a_start_up, true), attribute(has_partner_or_linked_enterprises, false)], date(2026, 9, 1), may_comply_in_a_simplified_manner, _).
test(bias_not_applicable_before_twenty_seventh_july) :-
    bias_data_processing_status([], date(2026, 7, 26), Result, Citations),
    Result == not_applicable_on_date,
    Citations == [cite(eu_reg_2024_1689_art_113_a)].
test(bias_capacity_is_asked_from_twenty_seventh_july) :-
    bias_data_processing_status([], date(2026, 7, 27), Result, Citations),
    Result == indeterminate([bias_processing_capacity]),
    Citations == [].
test(bias_failed_crisp_condition_is_not_permitted) :-
    bias_data_processing_status([attribute(bias_processing_capacity, other_provider_or_deployer), attribute(data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties, false)], date(2026, 8, 1), Result, _),
    Result == bias_processing_not_permitted.
test(real_world_section_b_without_framework) :-
    real_world_testing_status([attribute(testing_route, annex_i_section_b), attribute(member_state_has_adopted_a_real_world_testing_framework, false)], date(2026, 8, 2), Result, Citations),
    Result == testing_not_provided_for_by_the_member_state,
    Citations == [cite(eu_reg_2024_1689_art_60a_1), cite(eu_reg_2024_1689_art_60a_2)].
test(real_world_route_is_asked_first) :-
    real_world_testing_status([], date(2026, 8, 2), indeterminate([testing_route]), []).
test(real_world_permitted) :-
    real_world_profile([attribute(testing_in_cooperation_with_deployers, false), attribute(informed_consent_given_in_accordance_with_article_61, true)], Profile),
    real_world_testing_status(Profile, date(2026, 8, 2), Result, Citations),
    Result == real_world_testing_permitted,
    Citations == [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)].
test(real_world_without_consent_not_permitted) :-
    real_world_profile([attribute(testing_in_cooperation_with_deployers, false), attribute(informed_consent_given_in_accordance_with_article_61, false)], Profile),
    real_world_testing_status(Profile, date(2026, 8, 2), real_world_testing_not_permitted, _).
test(real_world_key_behind_another_is_not_named) :-
    real_world_profile([], Profile),
    real_world_testing_status(Profile, date(2026, 8, 2), Result, Citations),
    Result == indeterminate([informed_consent_given_in_accordance_with_article_61]),
    Citations == [].
test(unknown_key_is_an_input_problem) :-
    informed_consent_status([attribute(unheard_of, true)], date(2026, 8, 2), Result, Citations),
    Result == input_problems([unknown_key(unheard_of)]),
    Citations == [].
test(impossible_date_is_an_input_problem) :-
    sandbox_personal_data_processing_status([], date(2026, 2, 30), Result, Citations),
    Result == input_problems([wrong_type(assessment_date)]),
    Citations == [].
test(sandbox_unlisted_area_is_not_permitted) :-
    sandbox_personal_data_processing_status([attribute(public_interest_area, none_of_the_listed_areas)], date(2026, 8, 2), Result, Citations),
    Result == sandbox_processing_not_permitted,
    Citations == [cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)].
test(sandbox_first_missing_key_is_named) :-
    sandbox_personal_data_processing_status([], date(2026, 8, 2), indeterminate([sandbox_processing_of_data_collected_for_other_purposes_solely_for_developing_training_and_testing]), []).

test(explanation_exception_is_not_a_right, fail) :-
    explanation_profile(true, true, Profile),
    explanation_right_status(Profile, date(2026, 8, 2), right_to_explanation_under_article_86, _).
