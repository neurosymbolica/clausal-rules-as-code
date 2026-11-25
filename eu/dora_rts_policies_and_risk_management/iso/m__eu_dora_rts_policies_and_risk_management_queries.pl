% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_queries, [dora_rts_policies_and_risk_management_profile_keys/1, dora_rts_policies_and_risk_management_what_if/4, dora_rts_policies_and_risk_management_compliance_check/4, complete/0, incomplete/0, none_outstanding/0, simplified_framework_entity/0, unsure/0, risk_profile_and_complexity_consideration/0, embedding_of_security_policies/0, network_security/0, intrusion_and_data_misuse_safeguards/0, data_availability_authenticity_integrity_and_confidentiality/0, accurate_and_prompt_data_transmission/0, alignment_to_information_security_objectives/0, indication_of_approval_date/0, implementation_and_exception_indicators/0, staff_security_responsibilities/0, consequences_of_non_compliance/0, documentation_list/0, segregation_of_duties/0, leading_practices_and_standards/0, roles_for_security_policies/0, review_of_security_policies/0, material_changes/0, ict_risk_management_policies_and_procedures/0, risk_tolerance_approval/0, risk_assessment_procedure_and_methodology/0, risk_treatment_procedure/0, residual_risk_provisions/0, risk_monitoring_provisions/0, strategy_change_process/0, monitoring_of_treatment_effectiveness/0, assessment_of_risk_tolerance_attainment/0, assessment_of_corrective_actions/0, financial_entity_is_article_16_1_entity/0, size_risk_profile_and_complexity_taken_into_account/0, ict_security_policies_embedded_in_ict_risk_management_framework/0, security_policies_ensure_security_of_networks/0, security_policies_contain_safeguards_against_intrusions_and_data_misuse/0, security_policies_preserve_availability_authenticity_integrity_and_confidentiality_of_data/0, security_policies_guarantee_accurate_and_prompt_data_transmission/0, security_policies_aligned_to_information_security_objectives/0, security_policies_indicate_date_of_management_body_approval/0, security_policies_contain_indicators_and_measures_for_implementation_and_exceptions/0, security_policies_specify_staff_responsibilities_for_ict_security/0, security_policies_specify_consequences_of_staff_non_compliance/0, security_policies_list_documentation_to_be_maintained/0, security_policies_specify_segregation_of_duties_arrangements/0, security_policies_consider_leading_practices_and_standards/0, security_policies_identify_roles_for_development_implementation_and_maintenance/0, security_policies_reviewed_in_accordance_with_article_6_5/0, security_policies_take_material_changes_into_account/0, ict_risk_management_policies_and_procedures_developed_documented_and_implemented/0, risk_management_policies_indicate_approval_of_risk_tolerance_level/0, risk_management_policies_contain_risk_assessment_procedure_and_methodology/0, risk_management_policies_contain_risk_treatment_procedure/0, risk_management_policies_contain_residual_risk_provisions/0, risk_management_policies_contain_risk_monitoring_provisions/0, risk_management_policies_contain_process_for_strategy_changes/0, risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness/0, risk_treatment_procedure_ensures_assessment_of_risk_tolerance_attainment/0, risk_treatment_procedure_ensures_assessment_of_corrective_actions/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [(=)/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(library(reif), [if_/3]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_kernel, [dora_rts_policies_and_risk_management_input_problems/2]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_dora_rts_policies_and_risk_management, [dora_rts_policies_and_risk_management_status/2, dora_rts_policies_and_risk_management_checklist/2, rts_policies_and_risk_management_duties_required/3, rts_policies_and_risk_management_duties_complete/3]).

complete.

incomplete.

none_outstanding.

simplified_framework_entity.

unsure.

risk_profile_and_complexity_consideration.

embedding_of_security_policies.

network_security.

intrusion_and_data_misuse_safeguards.

data_availability_authenticity_integrity_and_confidentiality.

accurate_and_prompt_data_transmission.

alignment_to_information_security_objectives.

indication_of_approval_date.

implementation_and_exception_indicators.

staff_security_responsibilities.

consequences_of_non_compliance.

documentation_list.

segregation_of_duties.

leading_practices_and_standards.

roles_for_security_policies.

review_of_security_policies.

material_changes.

ict_risk_management_policies_and_procedures.

risk_tolerance_approval.

risk_assessment_procedure_and_methodology.

risk_treatment_procedure.

residual_risk_provisions.

risk_monitoring_provisions.

strategy_change_process.

monitoring_of_treatment_effectiveness.

assessment_of_risk_tolerance_attainment.

assessment_of_corrective_actions.

financial_entity_is_article_16_1_entity.

size_risk_profile_and_complexity_taken_into_account.

ict_security_policies_embedded_in_ict_risk_management_framework.

security_policies_ensure_security_of_networks.

security_policies_contain_safeguards_against_intrusions_and_data_misuse.

security_policies_preserve_availability_authenticity_integrity_and_confidentiality_of_data.

security_policies_guarantee_accurate_and_prompt_data_transmission.

security_policies_aligned_to_information_security_objectives.

security_policies_indicate_date_of_management_body_approval.

security_policies_contain_indicators_and_measures_for_implementation_and_exceptions.

security_policies_specify_staff_responsibilities_for_ict_security.

security_policies_specify_consequences_of_staff_non_compliance.

security_policies_list_documentation_to_be_maintained.

security_policies_specify_segregation_of_duties_arrangements.

security_policies_consider_leading_practices_and_standards.

security_policies_identify_roles_for_development_implementation_and_maintenance.

security_policies_reviewed_in_accordance_with_article_6_5.

security_policies_take_material_changes_into_account.

ict_risk_management_policies_and_procedures_developed_documented_and_implemented.

risk_management_policies_indicate_approval_of_risk_tolerance_level.

risk_management_policies_contain_risk_assessment_procedure_and_methodology.

risk_management_policies_contain_risk_treatment_procedure.

risk_management_policies_contain_residual_risk_provisions.

risk_management_policies_contain_risk_monitoring_provisions.

risk_management_policies_contain_process_for_strategy_changes.

risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness.

risk_treatment_procedure_ensures_assessment_of_risk_tolerance_attainment.

risk_treatment_procedure_ensures_assessment_of_corrective_actions.

dora_rts_policies_and_risk_management_profile_keys([financial_entity_is_article_16_1_entity, size_risk_profile_and_complexity_taken_into_account, ict_security_policies_embedded_in_ict_risk_management_framework, security_policies_ensure_security_of_networks, security_policies_contain_safeguards_against_intrusions_and_data_misuse, security_policies_preserve_availability_authenticity_integrity_and_confidentiality_of_data, security_policies_guarantee_accurate_and_prompt_data_transmission, security_policies_aligned_to_information_security_objectives, security_policies_indicate_date_of_management_body_approval, security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, security_policies_specify_staff_responsibilities_for_ict_security, security_policies_specify_consequences_of_staff_non_compliance, security_policies_list_documentation_to_be_maintained, security_policies_specify_segregation_of_duties_arrangements, security_policies_consider_leading_practices_and_standards, security_policies_identify_roles_for_development_implementation_and_maintenance, security_policies_reviewed_in_accordance_with_article_6_5, security_policies_take_material_changes_into_account, ict_risk_management_policies_and_procedures_developed_documented_and_implemented, risk_management_policies_indicate_approval_of_risk_tolerance_level, risk_management_policies_contain_risk_assessment_procedure_and_methodology, risk_management_policies_contain_risk_treatment_procedure, risk_management_policies_contain_residual_risk_provisions, risk_management_policies_contain_risk_monitoring_provisions, risk_management_policies_contain_process_for_strategy_changes, risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness, risk_treatment_procedure_ensures_assessment_of_risk_tolerance_attainment, risk_treatment_procedure_ensures_assessment_of_corrective_actions]).

dora_rts_policies_and_risk_management_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    overridden_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_rts_policies_and_risk_management_status(Hypothesis, NewStatus).

overridden_profile(Profile, OverriddenKey, NewValue, Hypothesis) :-
    profile_lacks(Profile, OverriddenKey),
    append(Profile, [attribute(OverriddenKey, NewValue)], Hypothesis).
overridden_profile(Profile, OverriddenKey, NewValue, Hypothesis) :-
    profile_get(Profile, OverriddenKey, _OldValue),
    maplist(replaced_attribute(OverriddenKey, NewValue), Profile, Hypothesis).

replaced_attribute(ProfileKey, Value, attribute(OtherKey, OldValue), attribute(OtherKey, NewValue)) :-
    if_(OtherKey = ProfileKey, NewValue = Value, NewValue = OldValue).

dora_rts_policies_and_risk_management_compliance_check(Profile, certify_all_duties, Verdict, Citations) :-
    rts_policies_and_risk_management_duties_complete(Profile, Result, ResultCitations),
    all_duties_verdict(Result, ResultCitations, Verdict, Citations).
dora_rts_policies_and_risk_management_compliance_check(Profile, certify_duty(DutyAtom), Verdict, Citations) :-
    rts_policies_and_risk_management_duties_required(Profile, Result, ResultCitations),
    duty_verdict(Result, ResultCitations, Profile, DutyAtom, Verdict, Citations).

all_duties_verdict(complete, Citations, permitted, Citations).
all_duties_verdict(incomplete, Citations, prohibited, Citations).
all_duties_verdict(simplified_framework_entity, Citations, prohibited, Citations).
all_duties_verdict(indeterminate(MissingKeys), Citations, indeterminate(MissingKeys), Citations).
all_duties_verdict(needs_legal_review(Reason, Context), Citations, needs_legal_review(Reason, Context), Citations).
all_duties_verdict(input_problems(Problems), Citations, input_problems(Problems), Citations).

duty_verdict(required(_), _, Profile, DutyAtom, Verdict, Citations) :-
    dora_rts_policies_and_risk_management_checklist(Profile, Items),
    member(item(DutyAtom, Status, Citation), Items),
    duty_item_verdict(Status, Citation, Profile, Verdict, Citations).
duty_verdict(simplified_framework_entity, Citations, _, _, prohibited, Citations).
duty_verdict(indeterminate(MissingKeys), Citations, _, _, indeterminate(MissingKeys), Citations).
duty_verdict(input_problems(Problems), Citations, _, _, input_problems(Problems), Citations).

duty_item_verdict(met, Citation, _, permitted, [Citation]).
duty_item_verdict(unmet(_), Citation, _, prohibited, [Citation]).
duty_item_verdict(unknown([ProfileKey]), _, Profile, indeterminate([ProfileKey]), []) :-
    profile_lacks(Profile, ProfileKey).
duty_item_verdict(unknown([ProfileKey]), Citation, Profile, needs_legal_review(open_textured(ProfileKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    profile_get(Profile, ProfileKey, unsure),
    dora_rts_policies_and_risk_management_profile_keys(ContractKeys),
    present_pairs(ContractKeys, Profile, Pairs).

present_pairs([], _, []).
present_pairs([ProfileKey|ContractKeys], Profile, Pairs) :-
    profile_lacks(Profile, ProfileKey),
    present_pairs(ContractKeys, Profile, Pairs).
present_pairs([ProfileKey|ContractKeys], Profile, [ProfileKey - Value|LaterPairs]) :-
    profile_get(Profile, ProfileKey, Value),
    present_pairs(ContractKeys, Profile, LaterPairs).

performed_profile([attribute(financial_entity_is_article_16_1_entity, false)|DutyAttributes]) :-
    dora_rts_policies_and_risk_management_profile_keys([_|DutyKeys]),
    maplist(true_attribute, DutyKeys, DutyAttributes).

true_attribute(ProfileKey, attribute(ProfileKey, true)).

test(every_duty_performed_permits_certifying_all) :-
    performed_profile(Profile),
    findall(Verdict - Citations, dora_rts_policies_and_risk_management_compliance_check(Profile, certify_all_duties, Verdict, Citations), Answers),
    Answers == [permitted - [cite(eu_reg_2024_1774_art_1), cite(eu_reg_2024_1774_art_2_1), cite(eu_reg_2024_1774_art_2_2), cite(eu_reg_2024_1774_art_3)]].
test(a_performed_duty_may_be_certified) :-
    performed_profile(Profile),
    findall(Verdict - Citations, dora_rts_policies_and_risk_management_compliance_check(Profile, certify_duty(network_security), Verdict, Citations), Answers),
    Answers == [permitted - [cite(eu_reg_2024_1774_art_2_1_a)]].
test(a_duty_not_performed_may_not_be_certified) :-
    findall(Verdict - Citations, dora_rts_policies_and_risk_management_compliance_check([attribute(financial_entity_is_article_16_1_entity, false), attribute(security_policies_ensure_security_of_networks, false)], certify_duty(network_security), Verdict, Citations), Answers),
    Answers == [prohibited - [cite(eu_reg_2024_1774_art_2_1_a)]].
test(an_unanswered_duty_is_asked) :-
    dora_rts_policies_and_risk_management_compliance_check([attribute(financial_entity_is_article_16_1_entity, false)], certify_duty(network_security), indeterminate([security_policies_ensure_security_of_networks]), []).
test(an_article_16_1_entity_may_not_certify_title_ii_duties) :-
    dora_rts_policies_and_risk_management_compliance_check([attribute(financial_entity_is_article_16_1_entity, true)], certify_all_duties, prohibited, [cite(eu_reg_2022_2554_art_16_1)]).
test(what_if_adds_an_absent_key_once) :-
    findall(Hypothesis, overridden_profile([attribute(financial_entity_is_article_16_1_entity, false)], security_policies_ensure_security_of_networks, true, Hypothesis), Answers),
    Answers == [[attribute(financial_entity_is_article_16_1_entity, false), attribute(security_policies_ensure_security_of_networks, true)]].
test(what_if_replaces_a_present_key_once) :-
    findall(Hypothesis, overridden_profile([attribute(financial_entity_is_article_16_1_entity, false)], financial_entity_is_article_16_1_entity, true, Hypothesis), Answers),
    Answers == [[attribute(financial_entity_is_article_16_1_entity, true)]].

test(an_article_16_1_entity_is_not_permitted, fail) :-
    dora_rts_policies_and_risk_management_compliance_check([attribute(financial_entity_is_article_16_1_entity, true)], certify_all_duties, permitted, _).
