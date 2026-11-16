% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [management_body_duties/2, risk_management_measures/2, proportionality_factors/2, supply_chain_considerations/2, corrective_measures_duty/3, essential_entity/0, important_entity/0, out_of_scope/0, must_take_corrective_measures_without_undue_delay/0, no_corrective_measures_duty/0, decide_nis2_governance_risk_measures/2, nis2_governance_risk_measures_status/2, nis2_governance_risk_measures_checklist/2, nis2_governance_risk_measures_decision_resolvable/1, nis2_governance_risk_measures_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_nis2_governance_risk_measures_kernel, [nis2_governance_risk_measures_input_problems/2]).
:- use_module(m__eu_nis2_governance_risk_measures_citations, [implements/1]).

essential_entity.

important_entity.

out_of_scope.

must_take_corrective_measures_without_undue_delay.

no_corrective_measures_duty.

deferred_provision(implementing_acts_on_the_measures, cite(eu_dir_2022_2555_art_21_5)).

nis2_governance_risk_measures_status_values([duties_apply, no_duties_apply]).

duty_table([duty(approve_the_cybersecurity_risk_management_measures, cite(eu_dir_2022_2555_art_20_1)), duty(oversee_the_implementation_of_the_measures, cite(eu_dir_2022_2555_art_20_1)), duty(can_be_held_liable_for_infringements_of_article_21, cite(eu_dir_2022_2555_art_20_1)), duty(members_of_the_management_bodies_follow_training, cite(eu_dir_2022_2555_art_20_2))]).

measures_without_point_j([measure(take_appropriate_and_proportionate_measures, cite(eu_dir_2022_2555_art_21_1)), measure(based_on_an_all_hazards_approach, cite(eu_dir_2022_2555_art_21_2)), measure(policies_on_risk_analysis_and_information_system_security, cite(eu_dir_2022_2555_art_21_2_a)), measure(incident_handling, cite(eu_dir_2022_2555_art_21_2_b)), measure(business_continuity_and_crisis_management, cite(eu_dir_2022_2555_art_21_2_c)), measure(supply_chain_security, cite(eu_dir_2022_2555_art_21_2_d)), measure(security_in_network_and_information_systems_acquisition_development_and_maintenance, cite(eu_dir_2022_2555_art_21_2_e)), measure(policies_and_procedures_to_assess_the_effectiveness_of_the_measures, cite(eu_dir_2022_2555_art_21_2_f)), measure(basic_cyber_hygiene_practices_and_cybersecurity_training, cite(eu_dir_2022_2555_art_21_2_g)), measure(policies_and_procedures_on_the_use_of_cryptography_and_encryption, cite(eu_dir_2022_2555_art_21_2_h)), measure(human_resources_security_access_control_and_asset_management, cite(eu_dir_2022_2555_art_21_2_i))]).

measures_with_point_j([measure(take_appropriate_and_proportionate_measures, cite(eu_dir_2022_2555_art_21_1)), measure(based_on_an_all_hazards_approach, cite(eu_dir_2022_2555_art_21_2)), measure(policies_on_risk_analysis_and_information_system_security, cite(eu_dir_2022_2555_art_21_2_a)), measure(incident_handling, cite(eu_dir_2022_2555_art_21_2_b)), measure(business_continuity_and_crisis_management, cite(eu_dir_2022_2555_art_21_2_c)), measure(supply_chain_security, cite(eu_dir_2022_2555_art_21_2_d)), measure(security_in_network_and_information_systems_acquisition_development_and_maintenance, cite(eu_dir_2022_2555_art_21_2_e)), measure(policies_and_procedures_to_assess_the_effectiveness_of_the_measures, cite(eu_dir_2022_2555_art_21_2_f)), measure(basic_cyber_hygiene_practices_and_cybersecurity_training, cite(eu_dir_2022_2555_art_21_2_g)), measure(policies_and_procedures_on_the_use_of_cryptography_and_encryption, cite(eu_dir_2022_2555_art_21_2_h)), measure(human_resources_security_access_control_and_asset_management, cite(eu_dir_2022_2555_art_21_2_i)), measure(multi_factor_or_continuous_authentication_and_secured_communications, cite(eu_dir_2022_2555_art_21_2_j))]).

factors_with_standards([factor(state_of_the_art, cite(eu_dir_2022_2555_art_21_1)), factor(relevant_european_and_international_standards, cite(eu_dir_2022_2555_art_21_1)), factor(cost_of_implementation, cite(eu_dir_2022_2555_art_21_1)), factor(degree_of_exposure_to_risks, cite(eu_dir_2022_2555_art_21_1)), factor(entity_size, cite(eu_dir_2022_2555_art_21_1)), factor(likelihood_of_incidents, cite(eu_dir_2022_2555_art_21_1)), factor(severity_of_incidents_including_societal_and_economic_impact, cite(eu_dir_2022_2555_art_21_1))]).

factors_without_standards([factor(state_of_the_art, cite(eu_dir_2022_2555_art_21_1)), factor(cost_of_implementation, cite(eu_dir_2022_2555_art_21_1)), factor(degree_of_exposure_to_risks, cite(eu_dir_2022_2555_art_21_1)), factor(entity_size, cite(eu_dir_2022_2555_art_21_1)), factor(likelihood_of_incidents, cite(eu_dir_2022_2555_art_21_1)), factor(severity_of_incidents_including_societal_and_economic_impact, cite(eu_dir_2022_2555_art_21_1))]).

considerations_with_assessments([consideration(vulnerabilities_specific_to_each_direct_supplier_and_service_provider, cite(eu_dir_2022_2555_art_21_3)), consideration(overall_quality_of_products_and_cybersecurity_practices_of_suppliers_and_service_providers, cite(eu_dir_2022_2555_art_21_3)), consideration(results_of_the_coordinated_security_risk_assessments_of_critical_supply_chains, cite(eu_dir_2022_2555_art_21_3))]).

considerations_without_assessments([consideration(vulnerabilities_specific_to_each_direct_supplier_and_service_provider, cite(eu_dir_2022_2555_art_21_3)), consideration(overall_quality_of_products_and_cybersecurity_practices_of_suppliers_and_service_providers, cite(eu_dir_2022_2555_art_21_3))]).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).

management_body_duties(Profile, Answer) :-
    nis2_governance_risk_measures_input_problems(Profile, Problems),
    duties_answer(Problems, Profile, Answer).

duties_answer([Problem|Problems], _, input_problems([Problem|Problems])).
duties_answer([], Profile, Answer) :-
    key_state(Profile, entity_class, State),
    duties_for(State, Answer).

duties_for(absent, indeterminate([entity_class])).
duties_for(out_of_scope, []).
duties_for(essential_entity, Duties) :-
    implements(eu_dir_2022_2555_art_20_1),
    duty_table(Duties).
duties_for(important_entity, Duties) :-
    implements(eu_dir_2022_2555_art_20_1),
    duty_table(Duties).

risk_management_measures(Profile, Answer) :-
    nis2_governance_risk_measures_input_problems(Profile, Problems),
    measures_answer(Problems, Profile, Answer).

measures_answer([Problem|Problems], _, input_problems([Problem|Problems])).
measures_answer([], Profile, Answer) :-
    key_state(Profile, entity_class, State),
    measures_for(State, Profile, Answer).

measures_for(absent, _, indeterminate([entity_class])).
measures_for(out_of_scope, _, []).
measures_for(essential_entity, Profile, Answer) :-
    measures_in_scope(Profile, Answer).
measures_for(important_entity, Profile, Answer) :-
    measures_in_scope(Profile, Answer).

measures_in_scope(Profile, Answer) :-
    key_state(Profile, multi_factor_authentication_and_secured_communications_appropriate, State),
    measures_by(State, Answer).

measures_by(absent, indeterminate([multi_factor_authentication_and_secured_communications_appropriate])).
measures_by(unsure, needs_legal_review(open_textured(multi_factor_authentication_and_secured_communications_appropriate, cite(eu_dir_2022_2555_art_21_2_j)), [inputs_relied_on([multi_factor_authentication_and_secured_communications_appropriate - unsure])])) :-
    implements(eu_dir_2022_2555_art_21_2_j).
measures_by(true, Measures) :-
    implements(eu_dir_2022_2555_art_21_2_j),
    measures_with_point_j(Measures).
measures_by(false, Measures) :-
    implements(eu_dir_2022_2555_art_21_2),
    measures_without_point_j(Measures).

proportionality_factors(Profile, Answer) :-
    nis2_governance_risk_measures_input_problems(Profile, Problems),
    factors_answer(Problems, Profile, Answer).

factors_answer([Problem|Problems], _, input_problems([Problem|Problems])).
factors_answer([], Profile, Answer) :-
    key_state(Profile, entity_class, State),
    factors_for(State, Profile, Answer).

factors_for(absent, _, indeterminate([entity_class])).
factors_for(out_of_scope, _, []).
factors_for(essential_entity, Profile, Answer) :-
    factors_in_scope(Profile, Answer).
factors_for(important_entity, Profile, Answer) :-
    factors_in_scope(Profile, Answer).

factors_in_scope(Profile, Answer) :-
    key_state(Profile, relevant_european_or_international_standards_apply, State),
    factors_by(State, Answer).

factors_by(absent, indeterminate([relevant_european_or_international_standards_apply])).
factors_by(true, Factors) :-
    implements(eu_dir_2022_2555_art_21_1),
    factors_with_standards(Factors).
factors_by(false, Factors) :-
    implements(eu_dir_2022_2555_art_21_1),
    factors_without_standards(Factors).

supply_chain_considerations(Profile, Answer) :-
    nis2_governance_risk_measures_input_problems(Profile, Problems),
    considerations_answer(Problems, Profile, Answer).

considerations_answer([Problem|Problems], _, input_problems([Problem|Problems])).
considerations_answer([], Profile, Answer) :-
    key_state(Profile, entity_class, State),
    considerations_for(State, Profile, Answer).

considerations_for(absent, _, indeterminate([entity_class])).
considerations_for(out_of_scope, _, []).
considerations_for(essential_entity, Profile, Answer) :-
    considerations_in_scope(Profile, Answer).
considerations_for(important_entity, Profile, Answer) :-
    considerations_in_scope(Profile, Answer).

considerations_in_scope(Profile, Answer) :-
    key_state(Profile, coordinated_supply_chain_risk_assessment_carried_out, State),
    considerations_by(State, Answer).

considerations_by(absent, indeterminate([coordinated_supply_chain_risk_assessment_carried_out])).
considerations_by(true, Considerations) :-
    implements(eu_dir_2022_2555_art_21_3),
    considerations_with_assessments(Considerations).
considerations_by(false, Considerations) :-
    implements(eu_dir_2022_2555_art_21_3),
    considerations_without_assessments(Considerations).

corrective_measures_duty(Profile, Result, Citations) :-
    nis2_governance_risk_measures_input_problems(Profile, Problems),
    corrective_answer(Problems, Profile, Result, Citations).

corrective_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
corrective_answer([], Profile, Result, Citations) :-
    key_state(Profile, entity_class, State),
    corrective_for(State, Profile, Result, Citations).

corrective_for(absent, _, indeterminate([entity_class]), []).
corrective_for(out_of_scope, _, no_corrective_measures_duty, [cite(eu_dir_2022_2555_art_21_4)]) :-
    implements(eu_dir_2022_2555_art_21_4).
corrective_for(essential_entity, Profile, Result, Citations) :-
    corrective_in_scope(Profile, Result, Citations).
corrective_for(important_entity, Profile, Result, Citations) :-
    corrective_in_scope(Profile, Result, Citations).

corrective_in_scope(Profile, Result, Citations) :-
    key_state(Profile, non_compliance_with_the_art_21_2_measures_found, State),
    corrective_by(State, Result, Citations).

corrective_by(absent, indeterminate([non_compliance_with_the_art_21_2_measures_found]), []).
corrective_by(true, must_take_corrective_measures_without_undue_delay, [cite(eu_dir_2022_2555_art_21_4)]) :-
    implements(eu_dir_2022_2555_art_21_4).
corrective_by(false, no_corrective_measures_duty, [cite(eu_dir_2022_2555_art_21_4)]) :-
    implements(eu_dir_2022_2555_art_21_4).

decide_nis2_governance_risk_measures(Profile, nis2_governance_risk_measures_verdict(Status, Citations)) :-
    management_body_duties(Profile, Answer),
    rollup(Answer, Status, Citations).

rollup([], no_duties_apply, []).
rollup([_|_], duties_apply, [cite(eu_dir_2022_2555_art_20_1), cite(eu_dir_2022_2555_art_20_2)]).
rollup(indeterminate(Keys), indeterminate(Keys), []).
rollup(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context), []).
rollup(input_problems(Problems), input_problems(Problems), []).

nis2_governance_risk_measures_status(Profile, Status) :-
    decide_nis2_governance_risk_measures(Profile, nis2_governance_risk_measures_verdict(Status, _Citations)).

nis2_governance_risk_measures_checklist(Profile, Items) :-
    management_body_duties(Profile, Answer),
    checklist_rows(Answer, Items).

checklist_rows([], []).
checklist_rows([Duty|Duties], Items) :-
    maplist(duty_item, [Duty|Duties], Items).
checklist_rows(indeterminate(Keys), [item(overall, indeterminate(Keys), cite(eu_dir_2022_2555_art_20_1))]).
checklist_rows(needs_legal_review(Reason, Context), [item(overall, needs_legal_review(Reason, Context), cite(eu_dir_2022_2555_art_20_1))]).
checklist_rows(input_problems(Problems), [item(overall, input_problems(Problems), cite(eu_dir_2022_2555_art_20_1))]).

duty_item(duty(Name, Citation), item(Name, met, Citation)).

nis2_governance_risk_measures_decision_resolvable(Profile) :-
    decide_nis2_governance_risk_measures(Profile, _Verdict).

test(essential_entity_has_four_duties) :-
    management_body_duties([attribute(entity_class, essential_entity)], Duties),
    length(Duties, 4).
test(out_of_scope_has_no_duties) :-
    management_body_duties([attribute(entity_class, out_of_scope)], []).
test(missing_entity_class_is_indeterminate) :-
    management_body_duties([], indeterminate([entity_class])).
test(unsure_point_j_is_referred) :-
    risk_management_measures([attribute(entity_class, important_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, unsure)], needs_legal_review(open_textured(multi_factor_authentication_and_secured_communications_appropriate, cite(eu_dir_2022_2555_art_21_2_j)), _)).
test(point_j_true_gives_twelve_measures) :-
    risk_management_measures([attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, true)], Measures),
    length(Measures, 12).
test(point_j_false_gives_eleven_measures) :-
    risk_management_measures([attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, false)], Measures),
    length(Measures, 11).
test(standards_true_gives_seven_factors) :-
    proportionality_factors([attribute(entity_class, essential_entity), attribute(relevant_european_or_international_standards_apply, true)], Factors),
    length(Factors, 7).
test(coordinated_assessment_false_gives_two_considerations) :-
    supply_chain_considerations([attribute(entity_class, important_entity), attribute(coordinated_supply_chain_risk_assessment_carried_out, false)], Considerations),
    length(Considerations, 2).
test(non_compliance_found_requires_corrective_measures) :-
    corrective_measures_duty([attribute(entity_class, essential_entity), attribute(non_compliance_with_the_art_21_2_measures_found, true)], must_take_corrective_measures_without_undue_delay, [cite(eu_dir_2022_2555_art_21_4)]).
test(no_non_compliance_gives_no_duty) :-
    corrective_measures_duty([attribute(entity_class, essential_entity), attribute(non_compliance_with_the_art_21_2_measures_found, false)], no_corrective_measures_duty, [cite(eu_dir_2022_2555_art_21_4)]).
test(unknown_key_is_an_input_problem) :-
    management_body_duties([attribute(entity_class, essential_entity), attribute(surprise, true)], input_problems([unknown_key(surprise)])).
test(rollup_duties_apply) :-
    nis2_governance_risk_measures_status([attribute(entity_class, important_entity)], duties_apply).
test(rollup_out_of_scope_is_no_duties_apply) :-
    nis2_governance_risk_measures_status([attribute(entity_class, out_of_scope)], no_duties_apply).
test(checklist_has_a_cited_row_per_duty) :-
    nis2_governance_risk_measures_checklist([attribute(entity_class, essential_entity)], Items),
    length(Items, 4).

test(out_of_scope_is_not_a_duty_list, fail) :-
    management_body_duties([attribute(entity_class, out_of_scope)], [_|_]).
