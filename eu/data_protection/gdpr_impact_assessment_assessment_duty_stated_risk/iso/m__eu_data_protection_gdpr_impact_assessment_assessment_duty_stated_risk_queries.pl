% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_queries, [gdpr_impact_assessment_assessment_duty_stated_risk_profile_keys/1, gdpr_impact_assessment_assessment_duty_stated_risk_what_if/4, gdpr_impact_assessment_assessment_duty_stated_risk_compliance_check/3, gdpr_impact_assessment_assessment_duty_stated_risk_officer_status/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_kernel, [gdpr_impact_assessment_assessment_duty_stated_risk_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_gdpr_impact_assessment_assessment_duty_stated_risk, [gdpr_impact_assessment_assessment_duty_stated_risk_status/2, decide_impact_assessment_duty/2, impact_assessment_officer_advice/2]).

gdpr_impact_assessment_assessment_duty_stated_risk_profile_keys([assessment_indicates_high_risk_absent_mitigation, automated_evaluation_including_profiling, criminal_offence_data_processed, data_protection_officer_advice_sought, data_protection_officer_designated, datasets_matched_or_combined, decisions_based_on_evaluation, decisions_produce_legal_effects, decisions_similarly_significantly_affect, description_of_processing_and_purposes_present, envisaged_measures_described, highly_personal_data_processed, impact_assessment_carried_out, lawful_basis_is_legal_obligation_or_public_task, legal_basis_with_general_impact_assessment, legitimate_interest_described, legitimate_interest_pursued, likely_high_risk_to_rights_and_freedoms, measures_reduce_residual_risk_below_high, member_state_requires_assessment_despite_general_one, member_state_requires_prior_authorisation, mitigating_measures_taken, monitoring_is_systematic, national_list_exempts_assessment, national_list_exempts_item, national_list_requires_assessment, national_list_requires_item, necessity_and_proportionality_assessed, processing_for_public_interest_task, processing_on_large_scale, processing_prevents_exercise_of_right_or_service, publicly_accessible_area_monitored, risks_to_data_subjects_assessed, route_approvals, special_category_data_processed, systematic_and_extensive_evaluation, uses_new_technologies, vulnerable_data_subjects]).

gdpr_impact_assessment_assessment_duty_stated_risk_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    replaced_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_impact_assessment_assessment_duty_stated_risk_status(Hypothesis, NewStatus).

replaced_profile(Profile, OverriddenKey, NewValue, Hypothesis) :-
    without_key(Profile, OverriddenKey, RemainingItems),
    append(RemainingItems, [attribute(OverriddenKey, NewValue)], Hypothesis).

without_key([], _, []).
without_key([attribute(ItemKey, _)|Items], OverriddenKey, RemainingItems) :-
    ItemKey == OverriddenKey,
    without_key(Items, OverriddenKey, RemainingItems).
without_key([attribute(ItemKey, ItemValue)|Items], OverriddenKey, [attribute(ItemKey, ItemValue)|RemainingItems]) :-
    ItemKey \== OverriddenKey,
    without_key(Items, OverriddenKey, RemainingItems).

gdpr_impact_assessment_assessment_duty_stated_risk_compliance_check(Profile, Action, Result) :-
    processing_action(Action),
    decide_impact_assessment_duty(Profile, impact_assessment_verdict(Status, _Bases, MissingContents, _Context, _Citations, _RoutesReliedOn)),
    processing_permission(Status, MissingContents, Result).

processing_action(begin_processing).

processing_permission(not_required, _, permitted) :-
    implements(eu_reg_2016_679_art_35_1).
processing_permission(required, [], permitted) :-
    implements(eu_reg_2016_679_art_35_1),
    implements(eu_reg_2016_679_art_35_7_a),
    implements(eu_reg_2016_679_art_35_7_d).
processing_permission(required, [_|_], prohibited) :-
    implements(eu_reg_2016_679_art_35_1),
    implements(eu_reg_2016_679_art_35_7_a),
    implements(eu_reg_2016_679_art_35_7_d).
processing_permission(indeterminate(MissingKeys), _, indeterminate(MissingKeys)).
processing_permission(needs_legal_review(Reason, ReviewContext), _, needs_legal_review(Reason, ReviewContext)).
processing_permission(input_problems(Problems), _, input_problems(Problems)).

gdpr_impact_assessment_assessment_duty_stated_risk_officer_status(Profile, Status) :-
    impact_assessment_officer_advice(Profile, officer_advice_verdict(Status, _Citations)).
