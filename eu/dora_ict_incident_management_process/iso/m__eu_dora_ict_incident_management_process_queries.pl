% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_queries, [dora_ict_incident_management_process_profile_keys/1, dora_ict_incident_management_process_what_if/4, dora_ict_incident_management_process_compliance/3, complete/0, incomplete/0, none_outstanding/0, unsure/0, ict_related_incident_management_process_defined_established_and_implemented/0, all_ict_related_incidents_and_significant_cyber_threats_recorded/0, procedures_for_monitoring_handling_follow_up_and_root_causes_established/0, early_warning_indicators_put_in_place/0, procedures_to_identify_track_log_categorise_and_classify_incidents_established/0, roles_and_responsibilities_for_incident_types_and_scenarios_assigned/0, communication_notification_escalation_and_counterpart_information_plans_set_out/0, major_incidents_reported_to_senior_management_and_management_body_informed/0, incident_response_procedures_established/0, cyber_threats_classified_as_significant_on_the_article_18_2_criteria/0, incident_management_process/0, recording_of_incidents_and_significant_cyber_threats/0, monitoring_handling_and_follow_up_procedures/0, early_warning_indicators/0, identification_and_classification_procedures/0, incident_roles_and_responsibilities/0, communication_and_escalation_plans/0, reporting_to_senior_management_and_management_body/0, incident_response_procedures/0, classification_of_significant_cyber_threats/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [not_member/2]).
:- use_module(m__eu_dora_ict_incident_management_process_kernel, [dora_ict_incident_management_process_input_problems/2]).
:- use_module(m__eu_dora_ict_incident_management_process_citations, [implements/1]).
:- use_module(m__eu_dora_ict_incident_management_process_dora_ict_incident_management_process, [dora_ict_incident_management_process_status/2, dora_ict_incident_management_process_checklist/2]).

dora_ict_incident_management_process_profile_keys([ict_related_incident_management_process_defined_established_and_implemented, all_ict_related_incidents_and_significant_cyber_threats_recorded, procedures_for_monitoring_handling_follow_up_and_root_causes_established, early_warning_indicators_put_in_place, procedures_to_identify_track_log_categorise_and_classify_incidents_established, roles_and_responsibilities_for_incident_types_and_scenarios_assigned, communication_notification_escalation_and_counterpart_information_plans_set_out, major_incidents_reported_to_senior_management_and_management_body_informed, incident_response_procedures_established, cyber_threats_classified_as_significant_on_the_article_18_2_criteria]).

complete.

incomplete.

none_outstanding.

unsure.

ict_related_incident_management_process_defined_established_and_implemented.

all_ict_related_incidents_and_significant_cyber_threats_recorded.

procedures_for_monitoring_handling_follow_up_and_root_causes_established.

early_warning_indicators_put_in_place.

procedures_to_identify_track_log_categorise_and_classify_incidents_established.

roles_and_responsibilities_for_incident_types_and_scenarios_assigned.

communication_notification_escalation_and_counterpart_information_plans_set_out.

major_incidents_reported_to_senior_management_and_management_body_informed.

incident_response_procedures_established.

cyber_threats_classified_as_significant_on_the_article_18_2_criteria.

incident_management_process.

recording_of_incidents_and_significant_cyber_threats.

monitoring_handling_and_follow_up_procedures.

early_warning_indicators.

identification_and_classification_procedures.

incident_roles_and_responsibilities.

communication_and_escalation_plans.

reporting_to_senior_management_and_management_body.

incident_response_procedures.

classification_of_significant_cyber_threats.

dora_ict_incident_management_process_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_ict_incident_management_process_status(Hypothesis, NewStatus).

override_attribute([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
override_attribute([attribute(EntryKey, _)|Entries], OverriddenKey, NewValue, [attribute(EntryKey, NewValue)|Entries]) :-
    EntryKey == OverriddenKey.
override_attribute([attribute(EntryKey, EntryValue)|Entries], OverriddenKey, NewValue, [attribute(EntryKey, EntryValue)|NewEntries]) :-
    EntryKey \== OverriddenKey,
    override_attribute(Entries, OverriddenKey, NewValue, NewEntries).

dora_ict_incident_management_process_compliance(Profile, _Action, input_problems([Problem|Problems])) :-
    dora_ict_incident_management_process_input_problems(Profile, [Problem|Problems]).
dora_ict_incident_management_process_compliance(Profile, omit(DutyName), permission(prohibited, [Citation])) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    dora_ict_incident_management_process_checklist(Profile, Items),
    member(item(DutyName, _, Citation), Items).
dora_ict_incident_management_process_compliance(Profile, perform(DutyName), permission(allowed, [Citation])) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    dora_ict_incident_management_process_checklist(Profile, Items),
    member(item(DutyName, _, Citation), Items).
dora_ict_incident_management_process_compliance(Profile, Action, permission(not_regulated, [])) :-
    dora_ict_incident_management_process_input_problems(Profile, []),
    dora_ict_incident_management_process_checklist(Profile, Items),
    findall(RegulatedAction, (member(item(DutyName, _, _), Items), regulated_action(DutyName, RegulatedAction)), RegulatedActions),
    not_member(Action, RegulatedActions).

regulated_action(DutyName, omit(DutyName)).
regulated_action(DutyName, perform(DutyName)).

test(omitting_a_duty_is_prohibited) :-
    dora_ict_incident_management_process_compliance([], omit(early_warning_indicators), permission(prohibited, [cite(eu_reg_2022_2554_art_17_3_a)])).
test(performing_a_duty_is_allowed) :-
    dora_ict_incident_management_process_compliance([], perform(classification_of_significant_cyber_threats), permission(allowed, [cite(eu_reg_2022_2554_art_18_2)])).
test(an_unrelated_action_is_not_regulated) :-
    dora_ict_incident_management_process_compliance([], omit(annual_party), permission(not_regulated, [])).
test(a_bad_profile_is_refused_first) :-
    dora_ict_incident_management_process_compliance(not_a_list, omit(early_warning_indicators), input_problems([wrong_type(profile)])).
test(the_override_replaces_a_present_key) :-
    override_attribute([attribute(early_warning_indicators_put_in_place, true)], early_warning_indicators_put_in_place, false, Hypothesis),
    Hypothesis == [attribute(early_warning_indicators_put_in_place, false)].
test(the_override_adds_an_absent_key) :-
    override_attribute([], early_warning_indicators_put_in_place, true, Hypothesis),
    Hypothesis == [attribute(early_warning_indicators_put_in_place, true)].
test(the_result_atoms_are_served) :-
    complete,
    incomplete,
    none_outstanding,
    unsure.

test(omitting_a_duty_is_not_allowed, fail) :-
    dora_ict_incident_management_process_compliance([], omit(early_warning_indicators), permission(allowed, _)).
