% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_queries, [decide_prior_consultation/2, prior_consultation_duty/2, impact_assessment_outside_facts/2, gdpr_impact_assessment_prior_consultation_profile_keys/1, gdpr_impact_assessment_prior_consultation_what_if/4, gdpr_impact_assessment_prior_consultation_compliance_check/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_kernel, [gdpr_impact_assessment_prior_consultation_input_problems/2, gdpr_impact_assessment_prior_consultation_outside_fact_reading/3]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_prior_consultation_duty, [decide_prior_consultation_duty/2, prior_consultation_duty_status/2]).

gdpr_impact_assessment_prior_consultation_profile_keys([assessment_indicates_high_risk_absent_mitigation, automated_evaluation_including_profiling, criminal_offence_data_processed, datasets_matched_or_combined, decisions_based_on_evaluation, decisions_produce_legal_effects, decisions_similarly_significantly_affect, description_of_processing_and_purposes_present, envisaged_measures_described, highly_personal_data_processed, impact_assessment_carried_out, lawful_basis_is_legal_obligation_or_public_task, legal_basis_with_general_impact_assessment, legitimate_interest_described, legitimate_interest_pursued, likely_high_risk_to_rights_and_freedoms, measures_reduce_residual_risk_below_high, member_state_requires_assessment_despite_general_one, member_state_requires_prior_authorisation, mitigating_measures_taken, monitoring_is_systematic, national_list_exempts_assessment, national_list_exempts_item, national_list_requires_assessment, national_list_requires_item, necessity_and_proportionality_assessed, processing_for_public_interest_task, processing_on_large_scale, processing_prevents_exercise_of_right_or_service, publicly_accessible_area_monitored, risks_to_data_subjects_assessed, route_approvals, special_category_data_processed, systematic_and_extensive_evaluation, uses_new_technologies, vulnerable_data_subjects]).

decide_prior_consultation(Profile, Verdict) :-
    decide_prior_consultation_duty(Profile, Verdict).

prior_consultation_duty(Profile, Status) :-
    prior_consultation_duty_status(Profile, Status).

outside_fact_keys([legal_basis_with_general_impact_assessment, member_state_requires_assessment_despite_general_one, member_state_requires_prior_authorisation, national_list_exempts_assessment, national_list_requires_assessment]).

impact_assessment_outside_facts(Profile, OutsideFacts) :-
    gdpr_impact_assessment_prior_consultation_input_problems(Profile, Problems),
    outside_facts_for_problems(Problems, Profile, OutsideFacts).

outside_facts_for_problems([Problem|Problems], _, input_problems([Problem|Problems])).
outside_facts_for_problems([], Profile, OutsideFacts) :-
    outside_fact_keys(FactKeys),
    maplist(outside_fact_item(Profile), FactKeys, OutsideFacts).

outside_fact_item(Profile, FactKey, outside_fact(FactKey, Attested)) :-
    gdpr_impact_assessment_prior_consultation_outside_fact_reading(Profile, FactKey, Attested).

gdpr_impact_assessment_prior_consultation_what_if(Profile, OverriddenKey, NewValue, NewVerdict) :-
    edited_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_prior_consultation_duty(Hypothesis, NewVerdict).

edited_profile(Term, _, _, Term) :-
    var(Term).
edited_profile(Term, Key, Value, [attribute(Key, Value)]) :-
    Term == [].
edited_profile(Term, Key, Value, Edited) :-
    nonvar(Term),
    Term = [Element|Elements],
    kept_element(Element, Key, Kept),
    edited_profile(Elements, Key, Value, EditedRest),
    append(Kept, EditedRest, Edited).
edited_profile(Term, _, _, Term) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

kept_element(Element, _, [Element]) :-
    var(Element).
kept_element(Element, Key, []) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key.
kept_element(Element, Key, [Element]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== Key.
kept_element(Element, _, [Element]) :-
    nonvar(Element),
    Element \= attribute(_, _).

gdpr_impact_assessment_prior_consultation_compliance_check(Profile, Action, Verdict) :-
    compliance_action(Action),
    decide_prior_consultation_duty(Profile, prior_consultation_verdict(Status, Bases, _, _)),
    action_modality(Status, Bases, Action, Verdict).

compliance_action(begin_processing_without_prior_consultation).
compliance_action(begin_processing_after_prior_consultation).
compliance_action(begin_processing_after_prior_authorisation).

action_modality(required, [art36_1_residual_high_risk], begin_processing_without_prior_consultation, prohibited) :-
    implements(eu_reg_2016_679_art_36_1).
action_modality(required, [art36_1_residual_high_risk], begin_processing_after_prior_consultation, permitted) :-
    implements(eu_reg_2016_679_art_36_1).
action_modality(required, [art36_1_residual_high_risk], begin_processing_after_prior_authorisation, permitted) :-
    implements(eu_reg_2016_679_art_36_1).
action_modality(required, [art36_5_member_state_prior_authorisation], begin_processing_without_prior_consultation, prohibited) :-
    implements(eu_reg_2016_679_art_36_5).
action_modality(required, [art36_5_member_state_prior_authorisation], begin_processing_after_prior_consultation, prohibited) :-
    implements(eu_reg_2016_679_art_36_5).
action_modality(required, [art36_5_member_state_prior_authorisation], begin_processing_after_prior_authorisation, permitted) :-
    implements(eu_reg_2016_679_art_36_5).
action_modality(not_required, [art36_1_condition_not_met], _, permitted) :-
    implements(eu_reg_2016_679_art_36_1).
action_modality(indeterminate(MissingKeys), [], _, not_decided(indeterminate(MissingKeys))).
action_modality(needs_legal_review(Reason, ReviewContext), [], _, not_decided(needs_legal_review(Reason, ReviewContext))).
action_modality(input_problems(Problems), [], _, not_decided(input_problems(Problems))).

test(the_outside_facts_of_an_empty_profile_are_all_absent) :-
    findall(OutsideFacts, impact_assessment_outside_facts([], OutsideFacts), Answers),
    Answers == [[outside_fact(legal_basis_with_general_impact_assessment, absent), outside_fact(member_state_requires_assessment_despite_general_one, absent), outside_fact(member_state_requires_prior_authorisation, absent), outside_fact(national_list_exempts_assessment, absent), outside_fact(national_list_requires_assessment, absent)]].
test(the_outside_facts_of_a_problem_profile_are_its_problems) :-
    impact_assessment_outside_facts([attribute(stray_key, 1)], input_problems([unknown_key(stray_key)])).
test(required_consultation_prohibits_processing_without_it) :-
    gdpr_impact_assessment_prior_consultation_compliance_check([attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, false)], begin_processing_without_prior_consultation, prohibited).
test(an_open_answer_decides_no_action) :-
    gdpr_impact_assessment_prior_consultation_compliance_check([], begin_processing_without_prior_consultation, not_decided(indeterminate(_))).
test(the_edit_replaces_the_key_and_keeps_the_others) :-
    edited_profile([attribute(a_key, 1), attribute(b_key, 2)], b_key, 3, Edited),
    Edited == [attribute(a_key, 1), attribute(b_key, 3)].
test(the_whole_verdict_and_the_status_agree) :-
    decide_prior_consultation([attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, false)], prior_consultation_verdict(Status, _, _, _)),
    prior_consultation_duty([attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, false)], DutyStatus),
    Status == DutyStatus.

test(required_consultation_does_not_permit_processing_without_it, fail) :-
    gdpr_impact_assessment_prior_consultation_compliance_check([attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, false)], begin_processing_without_prior_consultation, permitted).
