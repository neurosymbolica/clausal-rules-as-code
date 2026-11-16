% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_queries, [provider_side_duties_profile_keys/1, provider_side_duties_what_if/4, provider_side_duties_compliance_check/3, provider_side_duties_obligations/3, not_applicable_on_date/0, earlier_text_not_formalised/0, not_an_ai_system/0, not_a_high_risk_ai_system/0, not_the_addressee_of_the_duty/0, compliance_required_by_31_december_2030/0, compliance_required_by_2_august_2030/0, system_already_placed_without_significant_change/0, duty_not_triggered/0, duty_applies/0, indeterminate/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_ai_act_provider_side_duties_kernel, [provider_side_duties_input_problems/2]).
:- use_module(m__eu_ai_act_provider_side_duties_provider_side_duties, [provider_side_duties_status/2, provider_side_duties_status_values/1]).

not_applicable_on_date.

earlier_text_not_formalised.

not_an_ai_system.

not_a_high_risk_ai_system.

not_the_addressee_of_the_duty.

compliance_required_by_31_december_2030.

compliance_required_by_2_august_2030.

system_already_placed_without_significant_change.

duty_not_triggered.

duty_applies.

indeterminate([_MissingKey]).

provider_side_duties_profile_keys([ai_system, high_risk_ai_system, high_risk_route, actor_role, component_of_a_large_scale_it_system_listed_in_annex_x, placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, intended_to_be_used_by_public_authorities, provider_established_in_a_third_country, logs_under_the_providers_control, reasoned_request_from_a_competent_authority, request_from_a_market_surveillance_authority_for_a_copy_of_the_mandate, competent_authority_action_in_relation_to_the_system, system_under_the_operators_responsibility, provider_considers_or_has_reason_to_consider_the_system_not_in_conformity, presents_a_risk_within_the_meaning_of_article_79_1, provider_aware_of_the_risk, representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations, importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, distributor_has_made_the_system_available_on_the_market]).

duty_atoms([compliance_with_the_requirements_of_section_2, provider_name_and_contact_address, quality_management_system, documentation_keeping, log_keeping, conformity_assessment_before_placing_on_the_market, eu_declaration_of_conformity, ce_marking, registration, corrective_actions_and_information, investigation_and_information_on_a_risk, demonstration_of_conformity_on_request, access_to_logs_on_request, accessibility_requirements, appointment_of_an_authorised_representative, enabling_the_authorised_representative, performance_of_the_mandate_tasks, copy_of_the_mandate_on_request, verification_of_the_declaration_documentation_and_conformity_assessment, keeping_of_the_provider_contact_details_and_documents, representative_information_on_request, representative_cooperation_with_authorities, representative_registration, termination_of_the_mandate, importer_verification_before_placing_on_the_market, importer_withholding_of_a_non_conforming_system, importer_information_on_a_risk, importer_name_and_contact_address, importer_storage_and_transport_conditions, importer_keeping_of_copies, importer_information_on_request, importer_cooperation_with_authorities, distributor_verification_before_making_available, distributor_withholding_of_a_non_conforming_system, distributor_information_on_a_risk, distributor_storage_and_transport_conditions, distributor_corrective_actions, distributor_information_on_request, distributor_cooperation_with_authorities, ai_literacy_measures]).

provider_side_duties_what_if(duty_case(Profile, Duty, AssessmentDate), OverriddenKey, NewValue, NewStatus) :-
    provider_side_duties_input_problems(Profile, Problems),
    override_attribute(Problems, Profile, OverriddenKey, NewValue, Hypothesis),
    provider_side_duties_status(duty_case(Hypothesis, Duty, AssessmentDate), NewStatus).

override_attribute([wrong_type(profile)], Profile, _, _, Profile).
override_attribute(Problems, Profile, OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)|Kept]) :-
    dif(Problems, [wrong_type(profile)]),
    exclude(same_attribute_key(OverriddenKey), Profile, Kept).

same_attribute_key(OverriddenKey, Element) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey.

provider_side_duties_compliance_check(Case, Action, Verdict) :-
    provider_side_duties_status(Case, Status),
    provider_side_duties_status_values(FinalValues),
    memberd_t(Status, FinalValues, IsFinal),
    proposed_action_t(Action, IsAction),
    compliance_verdict(IsAction, IsFinal, Action, Status, Verdict).

proposed_action_t(Action, false) :-
    var(Action).
proposed_action_t(Action, IsAction) :-
    nonvar(Action),
    memberd_t(Action, [omit_duty, perform_duty], IsAction).

compliance_verdict(false, _, _, _, input_problems([wrong_type(action)])).
compliance_verdict(true, false, _, Status, Status).
compliance_verdict(true, true, perform_duty, _, compliant).
compliance_verdict(true, true, omit_duty, Status, Verdict) :-
    omission_verdict(Status, Verdict).

omission_verdict(duty_applies, non_compliant).
omission_verdict(Status, compliant) :-
    dif(Status, duty_applies).

provider_side_duties_obligations(Profile, AssessmentDate, Duties) :-
    duty_atoms(AllDuties),
    findall(Duty, owed_duty(AllDuties, Profile, AssessmentDate, Duty), Duties).

owed_duty(AllDuties, Profile, AssessmentDate, Duty) :-
    member(Duty, AllDuties),
    provider_side_duties_status(duty_case(Profile, Duty, AssessmentDate), duty_applies).

complete_provider_profile([attribute(ai_system, true), attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, provider), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, false), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, false), attribute(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, false), attribute(intended_to_be_used_by_public_authorities, false), attribute(provider_established_in_a_third_country, false), attribute(logs_under_the_providers_control, false), attribute(reasoned_request_from_a_competent_authority, false), attribute(request_from_a_market_surveillance_authority_for_a_copy_of_the_mandate, false), attribute(competent_authority_action_in_relation_to_the_system, false), attribute(system_under_the_operators_responsibility, false), attribute(provider_considers_or_has_reason_to_consider_the_system_not_in_conformity, false), attribute(presents_a_risk_within_the_meaning_of_article_79_1, false), attribute(provider_aware_of_the_risk, false), attribute(representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations, false), attribute(importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, false), attribute(distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, false), attribute(distributor_has_made_the_system_available_on_the_market, false)]).

importer_profile([attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, importer), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, false), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, false), attribute(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, false), attribute(importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, false), attribute(presents_a_risk_within_the_meaning_of_article_79_1, false), attribute(system_under_the_operators_responsibility, false), attribute(reasoned_request_from_a_competent_authority, false), attribute(competent_authority_action_in_relation_to_the_system, false)]).

test(omitting_an_applicable_duty_is_non_compliant) :-
    complete_provider_profile(Profile),
    findall(Verdict, provider_side_duties_compliance_check(duty_case(Profile, ce_marking, date(2029, 1, 1)), omit_duty, Verdict), Verdicts),
    Verdicts == [non_compliant].
test(performing_the_duty_is_compliant) :-
    complete_provider_profile(Profile),
    provider_side_duties_compliance_check(duty_case(Profile, ce_marking, date(2029, 1, 1)), perform_duty, compliant).
test(omitting_an_untriggered_duty_is_compliant) :-
    complete_provider_profile(Profile),
    provider_side_duties_compliance_check(duty_case(Profile, log_keeping, date(2029, 1, 1)), omit_duty, compliant).
test(a_not_final_status_passes_through) :-
    provider_side_duties_compliance_check(duty_case([], ce_marking, date(2029, 1, 1)), omit_duty, Verdict),
    Verdict == indeterminate([high_risk_ai_system]).
test(an_unknown_action_is_an_input_problem) :-
    complete_provider_profile(Profile),
    provider_side_duties_compliance_check(duty_case(Profile, ce_marking, date(2029, 1, 1)), ignore_duty, input_problems([wrong_type(action)])).
test(the_importer_owes_three_unconditional_duties) :-
    importer_profile(Profile),
    findall(Duties, provider_side_duties_obligations(Profile, date(2028, 1, 1), Duties), AllDuties),
    AllDuties == [[importer_verification_before_placing_on_the_market, importer_name_and_contact_address, importer_keeping_of_copies]].
test(before_chapter_three_no_importer_duty_is_owed) :-
    importer_profile(Profile),
    provider_side_duties_obligations(Profile, date(2027, 12, 1), []).
test(what_if_logs_come_under_control) :-
    complete_provider_profile(Profile),
    provider_side_duties_status(duty_case(Profile, log_keeping, date(2029, 1, 1)), duty_not_triggered),
    provider_side_duties_what_if(duty_case(Profile, log_keeping, date(2029, 1, 1)), logs_under_the_providers_control, true, NewStatus),
    NewStatus == duty_applies.
test(what_if_on_a_non_list_profile_keeps_the_input_problem) :-
    provider_side_duties_what_if(duty_case(profile, ce_marking, date(2029, 1, 1)), actor_role, provider, NewStatus),
    NewStatus == input_problems([wrong_type(profile)]).
test(the_key_schema_has_twenty_two_keys) :-
    provider_side_duties_profile_keys(Keys),
    length(Keys, 22).
test(there_are_forty_duty_atoms) :-
    duty_atoms(Duties),
    length(Duties, 40).

test(omitting_an_applicable_duty_is_not_compliant, fail) :-
    complete_provider_profile(Profile),
    provider_side_duties_compliance_check(duty_case(Profile, ce_marking, date(2029, 1, 1)), omit_duty, compliant).
