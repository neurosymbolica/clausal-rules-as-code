% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s2_information_duties_and_dpia_queries, [swiss_fadp_s2_information_duties_and_dpia_profile_keys/1, swiss_fadp_s2_information_duties_and_dpia_what_if/4, swiss_fadp_s2_information_duties_and_dpia_obligations/2, information_required/0, information_not_required/0, information_may_be_restricted_deferred_or_omitted/0, information_item_required/0, information_item_not_required/0, automated_decision_information_required/0, automated_decision_information_not_required/0, view_and_review_rights_apply/0, view_and_review_rights_do_not_apply/0, decision_marking_required/0, decision_marking_not_required/0, impact_assessment_required/0, impact_assessment_not_required/0, impact_assessment_may_be_omitted/0, same/0, differs/0, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, wrong_type/1, duplicate_key/1, controller_is_federal_body/0, personal_data_collected_from_data_subject/0, data_subject_already_has_information/0, processing_provided_for_by_law/0, controller_bound_by_statutory_secrecy/0, article_27_conditions_met/0, information_impossible_or_requires_disproportionate_effort/0, overriding_third_party_interests_require_restriction/0, information_defeats_purpose_of_processing/0, overriding_controller_interests_require_restriction/0, controller_discloses_personal_data_to_third_parties/0, overriding_public_interests_require_restriction/0, information_may_endanger_investigation_or_proceedings/0, personal_data_disclosed_to_recipients/0, personal_data_disclosed_abroad/0, disclosure_abroad_relies_on_safeguards_or_exception/0, decision_based_solely_on_automated_processing/0, decision_has_legal_consequence_or_significantly_impairs_data_subject/0, decision_directly_related_to_contract_with_data_subject/0, data_subject_request_granted/0, data_subject_explicitly_consented_to_automated_decision/0, data_subject_need_not_be_heard_before_decision/0, processing_may_entail_high_risk_to_personality_or_fundamental_rights/0, large_scale_processing_of_sensitive_personal_data/0, systematic_large_scale_monitoring_of_public_areas/0, controller_legally_obliged_to_process_data/0, system_product_or_service_certified_for_intended_use/0, controller_complies_with_code_of_conduct/0, code_of_conduct_based_on_impact_assessment/0, code_of_conduct_provides_protective_measures/0, code_of_conduct_submitted_to_commissioner/0, eu_data_subject_already_has_information/0, eu_information_impossible_disproportionate_or_seriously_impairing/0, eu_obtaining_or_disclosure_expressly_laid_down_by_law/0, eu_personal_data_confidential_under_professional_secrecy/0, eu_decision_based_solely_on_automated_processing/0, eu_decision_has_legal_or_similarly_significant_effects/0, eu_processing_likely_to_result_in_high_risk/0, eu_systematic_extensive_evaluation_with_significant_automated_decisions/0, eu_large_scale_processing_of_special_categories_or_criminal_data/0, eu_systematic_large_scale_monitoring_of_publicly_accessible_area/0, eu_article_35_10_exemption_applies/0, identity_and_contact_details_of_controller/0, processing_purpose/0, recipients_or_categories_of_recipients/0, categories_of_personal_data_processed/0, state_or_international_body/0, safeguards_or_exception_relied_on/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_kernel, [swiss_fadp_s2_information_duties_and_dpia_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_swiss_fadp_s2_information_duties_and_dpia, [swiss_fadp_s2_information_duties_and_dpia_status/2, swiss_information_duty/3, swiss_minimum_information_item/4, swiss_automated_decision_information/3, swiss_automated_decision_review/3, swiss_automated_decision_marking/3, swiss_impact_assessment/3]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_citations, [implements/1]).

swiss_fadp_s2_information_duties_and_dpia_profile_keys([controller_is_federal_body, personal_data_collected_from_data_subject, data_subject_already_has_information, processing_provided_for_by_law, controller_bound_by_statutory_secrecy, article_27_conditions_met, information_impossible_or_requires_disproportionate_effort, overriding_third_party_interests_require_restriction, information_defeats_purpose_of_processing, overriding_controller_interests_require_restriction, controller_discloses_personal_data_to_third_parties, overriding_public_interests_require_restriction, information_may_endanger_investigation_or_proceedings, personal_data_disclosed_to_recipients, personal_data_disclosed_abroad, disclosure_abroad_relies_on_safeguards_or_exception, decision_based_solely_on_automated_processing, decision_has_legal_consequence_or_significantly_impairs_data_subject, decision_directly_related_to_contract_with_data_subject, data_subject_request_granted, data_subject_explicitly_consented_to_automated_decision, data_subject_need_not_be_heard_before_decision, processing_may_entail_high_risk_to_personality_or_fundamental_rights, large_scale_processing_of_sensitive_personal_data, systematic_large_scale_monitoring_of_public_areas, controller_legally_obliged_to_process_data, system_product_or_service_certified_for_intended_use, controller_complies_with_code_of_conduct, code_of_conduct_based_on_impact_assessment, code_of_conduct_provides_protective_measures, code_of_conduct_submitted_to_commissioner, eu_data_subject_already_has_information, eu_information_impossible_disproportionate_or_seriously_impairing, eu_obtaining_or_disclosure_expressly_laid_down_by_law, eu_personal_data_confidential_under_professional_secrecy, eu_decision_based_solely_on_automated_processing, eu_decision_has_legal_or_similarly_significant_effects, eu_processing_likely_to_result_in_high_risk, eu_systematic_extensive_evaluation_with_significant_automated_decisions, eu_large_scale_processing_of_special_categories_or_criminal_data, eu_systematic_large_scale_monitoring_of_publicly_accessible_area, eu_article_35_10_exemption_applies]).

swiss_fadp_s2_information_duties_and_dpia_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(Profile, Problems),
    hypothesis_profile(Problems, Profile, OverriddenKey, NewValue, Hypothesis),
    swiss_fadp_s2_information_duties_and_dpia_status(Hypothesis, NewStatus).

hypothesis_profile([wrong_type(profile)], Profile, _, _, Profile).
hypothesis_profile(Problems, Profile, OverriddenKey, NewValue, Hypothesis) :-
    dif(Problems, [wrong_type(profile)]),
    with_attribute(Profile, OverriddenKey, NewValue, Hypothesis).

with_attribute(Profile, OverriddenKey, NewValue, Hypothesis) :-
    replace_attribute(Profile, OverriddenKey, NewValue, Replaced, Found),
    add_missing_attribute(Found, Replaced, OverriddenKey, NewValue, Hypothesis).

replace_attribute([], _, _, [], false).
replace_attribute([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, NewValue)|Replaced], true) :-
    ElementKey == OverriddenKey,
    replace_attribute(Elements, OverriddenKey, NewValue, Replaced, _).
replace_attribute([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Replaced], Found) :-
    ElementKey \== OverriddenKey,
    replace_attribute(Elements, OverriddenKey, NewValue, Replaced, Found).

add_missing_attribute(true, Replaced, _, _, Replaced).
add_missing_attribute(false, Replaced, OverriddenKey, NewValue, Hypothesis) :-
    append(Replaced, [attribute(OverriddenKey, NewValue)], Hypothesis).

swiss_fadp_s2_information_duties_and_dpia_obligations(Profile, Obligations) :-
    findall(Entry, obligation_entry(Profile, Entry), Obligations).

obligation_determination(swiss_information_duty).
obligation_determination(swiss_automated_decision_information).
obligation_determination(swiss_automated_decision_review).
obligation_determination(swiss_automated_decision_marking).
obligation_determination(swiss_impact_assessment).

determination_answer(swiss_information_duty, Profile, Result, Citations) :-
    swiss_information_duty(Profile, Result, Citations).
determination_answer(swiss_automated_decision_information, Profile, Result, Citations) :-
    swiss_automated_decision_information(Profile, Result, Citations).
determination_answer(swiss_automated_decision_review, Profile, Result, Citations) :-
    swiss_automated_decision_review(Profile, Result, Citations).
determination_answer(swiss_automated_decision_marking, Profile, Result, Citations) :-
    swiss_automated_decision_marking(Profile, Result, Citations).
determination_answer(swiss_impact_assessment, Profile, Result, Citations) :-
    swiss_impact_assessment(Profile, Result, Citations).

duty_result(information_required).
duty_result(automated_decision_information_required).
duty_result(view_and_review_rights_apply).
duty_result(decision_marking_required).
duty_result(impact_assessment_required).

information_given_result(information_required).
information_given_result(information_may_be_restricted_deferred_or_omitted).

minimum_item(identity_and_contact_details_of_controller).
minimum_item(processing_purpose).
minimum_item(recipients_or_categories_of_recipients).
minimum_item(categories_of_personal_data_processed).
minimum_item(state_or_international_body).
minimum_item(safeguards_or_exception_relied_on).

obligation_entry(Profile, Entry) :-
    obligation_determination(DeterminationId),
    determination_answer(DeterminationId, Profile, Result, Citations),
    determination_entry(DeterminationId, Result, Citations, Entry).
obligation_entry(Profile, obligation(information_item(Item), Citations)) :-
    implements(ch_fadp_art_19_2),
    swiss_information_duty(Profile, DutyResult, _),
    information_given_result(DutyResult),
    minimum_item(Item),
    swiss_minimum_information_item(Profile, Item, information_item_required, Citations).

determination_entry(_, Result, Citations, obligation(Result, Citations)) :-
    duty_result(Result).
determination_entry(DeterminationId, Result, _, open(DeterminationId, Result)) :-
    compound(Result).

information_required.

information_not_required.

information_may_be_restricted_deferred_or_omitted.

information_item_required.

information_item_not_required.

automated_decision_information_required.

automated_decision_information_not_required.

view_and_review_rights_apply.

view_and_review_rights_do_not_apply.

decision_marking_required.

decision_marking_not_required.

impact_assessment_required.

impact_assessment_not_required.

impact_assessment_may_be_omitted.

same.

differs.

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(InputKey, Citation) :-
    atom(InputKey),
    compound(Citation).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Source, Detail) :-
    nonvar(Source),
    nonvar(Detail).

input_problems(Problems) :-
    clausal_is_list(Problems).

wrong_type(ProblemKey) :-
    atom(ProblemKey).

duplicate_key(ProblemKey) :-
    atom(ProblemKey).

controller_is_federal_body.

personal_data_collected_from_data_subject.

data_subject_already_has_information.

processing_provided_for_by_law.

controller_bound_by_statutory_secrecy.

article_27_conditions_met.

information_impossible_or_requires_disproportionate_effort.

overriding_third_party_interests_require_restriction.

information_defeats_purpose_of_processing.

overriding_controller_interests_require_restriction.

controller_discloses_personal_data_to_third_parties.

overriding_public_interests_require_restriction.

information_may_endanger_investigation_or_proceedings.

personal_data_disclosed_to_recipients.

personal_data_disclosed_abroad.

disclosure_abroad_relies_on_safeguards_or_exception.

decision_based_solely_on_automated_processing.

decision_has_legal_consequence_or_significantly_impairs_data_subject.

decision_directly_related_to_contract_with_data_subject.

data_subject_request_granted.

data_subject_explicitly_consented_to_automated_decision.

data_subject_need_not_be_heard_before_decision.

processing_may_entail_high_risk_to_personality_or_fundamental_rights.

large_scale_processing_of_sensitive_personal_data.

systematic_large_scale_monitoring_of_public_areas.

controller_legally_obliged_to_process_data.

system_product_or_service_certified_for_intended_use.

controller_complies_with_code_of_conduct.

code_of_conduct_based_on_impact_assessment.

code_of_conduct_provides_protective_measures.

code_of_conduct_submitted_to_commissioner.

eu_data_subject_already_has_information.

eu_information_impossible_disproportionate_or_seriously_impairing.

eu_obtaining_or_disclosure_expressly_laid_down_by_law.

eu_personal_data_confidential_under_professional_secrecy.

eu_decision_based_solely_on_automated_processing.

eu_decision_has_legal_or_similarly_significant_effects.

eu_processing_likely_to_result_in_high_risk.

eu_systematic_extensive_evaluation_with_significant_automated_decisions.

eu_large_scale_processing_of_special_categories_or_criminal_data.

eu_systematic_large_scale_monitoring_of_publicly_accessible_area.

eu_article_35_10_exemption_applies.

identity_and_contact_details_of_controller.

processing_purpose.

recipients_or_categories_of_recipients.

categories_of_personal_data_processed.

state_or_international_body.

safeguards_or_exception_relied_on.

unsure.
