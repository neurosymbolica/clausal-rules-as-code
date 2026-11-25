% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_dora_ict_risk_learning_and_evolving, [ict_risk_learning_and_evolving_duties_required/3, ict_risk_learning_and_evolving_duties_complete/3, ict_risk_learning_and_evolving_duties_outstanding/3, decide_dora_ict_risk_learning_and_evolving/2, dora_ict_risk_learning_and_evolving_status/2, dora_ict_risk_learning_and_evolving_checklist/2, dora_ict_risk_learning_and_evolving_decision_resolvable/1, dora_ict_risk_learning_and_evolving_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(clausal_hof, [include/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_kernel, [dora_ict_risk_learning_and_evolving_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_citations, [implements/1]).

dora_ict_risk_learning_and_evolving_status_values([complete, incomplete, simplified_framework_entity]).

contract_key_order([financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, major_ict_related_incident_disrupted_core_activities, competent_authority_requested_post_incident_review_changes, capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, post_ict_related_incident_reviews_put_in_place, post_incident_review_changes_communicated_to_competent_authorities, post_incident_reviews_determine_procedures_followed_and_actions_effective, post_incident_reviews_cover_promptness_of_response_and_impact_determination, post_incident_reviews_cover_quality_and_speed_of_forensic_analysis, post_incident_reviews_cover_effectiveness_of_incident_escalation, post_incident_reviews_cover_effectiveness_of_internal_and_external_communication, lessons_incorporated_into_ict_risk_assessment_process, findings_form_basis_for_reviews_of_ict_risk_management_framework, effectiveness_of_resilience_strategy_implementation_monitored, evolution_of_ict_risk_mapped_over_time, frequency_types_magnitude_and_evolution_of_incidents_analysed, cyber_maturity_and_preparedness_enhanced, senior_ict_staff_report_findings_and_recommendations_at_least_yearly, awareness_programmes_and_resilience_training_compulsory_in_staff_training, programmes_and_training_apply_to_all_staff_at_commensurate_complexity, ict_third_party_service_providers_included_in_training_where_appropriate, relevant_technological_developments_monitored_continuously, kept_up_to_date_with_latest_ict_risk_management_processes]).

answer_key_order(Keys) :-
    contract_key_order([_|Keys]).

trigger_key_order([financial_entity_is_microenterprise, major_ict_related_incident_disrupted_core_activities, competent_authority_requested_post_incident_review_changes]).

trigger_key(Key) :-
    trigger_key_order(Keys),
    member(Key, Keys).

fixed_citations([cite(eu_reg_2022_2554_art_13_1), cite(eu_reg_2022_2554_art_13_2), cite(eu_reg_2022_2554_art_13_3), cite(eu_reg_2022_2554_art_13_4), cite(eu_reg_2022_2554_art_13_5), cite(eu_reg_2022_2554_art_13_6), cite(eu_reg_2022_2554_art_13_7)]).

duty_row(threat_and_incident_information_capability, capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, [], cite(eu_reg_2022_2554_art_13_1), cite(eu_reg_2022_2554_art_13_1)).
duty_row(post_incident_reviews, post_ict_related_incident_reviews_put_in_place, [major_ict_related_incident_disrupted_core_activities - true], cite(eu_reg_2022_2554_art_13_2), cite(eu_reg_2022_2554_art_13_2)).
duty_row(communication_of_post_incident_changes, post_incident_review_changes_communicated_to_competent_authorities, [financial_entity_is_microenterprise - false, major_ict_related_incident_disrupted_core_activities - true, competent_authority_requested_post_incident_review_changes - true], cite(eu_reg_2022_2554_art_13_2), cite(eu_reg_2022_2554_art_13_2)).
duty_row(review_of_procedures_and_actions, post_incident_reviews_determine_procedures_followed_and_actions_effective, [major_ict_related_incident_disrupted_core_activities - true], cite(eu_reg_2022_2554_art_13_2), cite(eu_reg_2022_2554_art_13_2)).
duty_row(review_of_response_promptness, post_incident_reviews_cover_promptness_of_response_and_impact_determination, [major_ict_related_incident_disrupted_core_activities - true], cite(eu_reg_2022_2554_art_13_2_a), cite(eu_reg_2022_2554_art_13_2)).
duty_row(review_of_forensic_analysis, post_incident_reviews_cover_quality_and_speed_of_forensic_analysis, [major_ict_related_incident_disrupted_core_activities - true], cite(eu_reg_2022_2554_art_13_2_b), cite(eu_reg_2022_2554_art_13_2)).
duty_row(review_of_incident_escalation, post_incident_reviews_cover_effectiveness_of_incident_escalation, [major_ict_related_incident_disrupted_core_activities - true], cite(eu_reg_2022_2554_art_13_2_c), cite(eu_reg_2022_2554_art_13_2)).
duty_row(review_of_internal_and_external_communication, post_incident_reviews_cover_effectiveness_of_internal_and_external_communication, [major_ict_related_incident_disrupted_core_activities - true], cite(eu_reg_2022_2554_art_13_2_d), cite(eu_reg_2022_2554_art_13_2)).
duty_row(lessons_incorporated_into_ict_risk_assessment, lessons_incorporated_into_ict_risk_assessment_process, [], cite(eu_reg_2022_2554_art_13_3), cite(eu_reg_2022_2554_art_13_3)).
duty_row(findings_basis_for_framework_reviews, findings_form_basis_for_reviews_of_ict_risk_management_framework, [], cite(eu_reg_2022_2554_art_13_3), cite(eu_reg_2022_2554_art_13_3)).
duty_row(monitoring_of_resilience_strategy_effectiveness, effectiveness_of_resilience_strategy_implementation_monitored, [], cite(eu_reg_2022_2554_art_13_4), cite(eu_reg_2022_2554_art_13_4)).
duty_row(mapping_of_ict_risk_evolution, evolution_of_ict_risk_mapped_over_time, [], cite(eu_reg_2022_2554_art_13_4), cite(eu_reg_2022_2554_art_13_4)).
duty_row(analysis_of_ict_related_incidents, frequency_types_magnitude_and_evolution_of_incidents_analysed, [], cite(eu_reg_2022_2554_art_13_4), cite(eu_reg_2022_2554_art_13_4)).
duty_row(enhancement_of_cyber_maturity, cyber_maturity_and_preparedness_enhanced, [], cite(eu_reg_2022_2554_art_13_4), cite(eu_reg_2022_2554_art_13_4)).
duty_row(yearly_report_to_management_body, senior_ict_staff_report_findings_and_recommendations_at_least_yearly, [], cite(eu_reg_2022_2554_art_13_5), cite(eu_reg_2022_2554_art_13_5)).
duty_row(compulsory_awareness_and_training_modules, awareness_programmes_and_resilience_training_compulsory_in_staff_training, [], cite(eu_reg_2022_2554_art_13_6), cite(eu_reg_2022_2554_art_13_6)).
duty_row(training_for_all_staff_commensurate_to_remit, programmes_and_training_apply_to_all_staff_at_commensurate_complexity, [], cite(eu_reg_2022_2554_art_13_6), cite(eu_reg_2022_2554_art_13_6)).
duty_row(third_party_providers_in_training, ict_third_party_service_providers_included_in_training_where_appropriate, [], cite(eu_reg_2022_2554_art_13_6), cite(eu_reg_2022_2554_art_13_6)).
duty_row(monitoring_of_technological_developments, relevant_technological_developments_monitored_continuously, [financial_entity_is_microenterprise - false], cite(eu_reg_2022_2554_art_13_7), cite(eu_reg_2022_2554_art_13_7)).
duty_row(up_to_date_ict_risk_management_processes, kept_up_to_date_with_latest_ict_risk_management_processes, [financial_entity_is_microenterprise - false], cite(eu_reg_2022_2554_art_13_7), cite(eu_reg_2022_2554_art_13_7)).

ict_risk_learning_and_evolving_duties_required(Profile, Result, Citations) :-
    dora_ict_risk_learning_and_evolving_input_problems(Profile, Problems),
    answer_for_problems(Problems, required_query, Profile, Result, Citations).

ict_risk_learning_and_evolving_duties_complete(Profile, Result, Citations) :-
    dora_ict_risk_learning_and_evolving_input_problems(Profile, Problems),
    answer_for_problems(Problems, complete_query, Profile, Result, Citations).

ict_risk_learning_and_evolving_duties_outstanding(Profile, Result, Citations) :-
    dora_ict_risk_learning_and_evolving_input_problems(Profile, Problems),
    answer_for_problems(Problems, outstanding_query, Profile, Result, Citations).

answer_for_problems([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
answer_for_problems([], Query, Profile, Result, Citations) :-
    profile_snapshot(Profile, Snapshot),
    lookup_state(Snapshot, financial_entity_is_article_16_1_entity, GateState),
    gate_answer(GateState, Query, Snapshot, Result, Citations).

gate_answer(true, _, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
gate_answer(absent, _, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
gate_answer(false, Query, Snapshot, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    duty_records(Snapshot, Records),
    query_answer(Query, Snapshot, Records, Result, Citations).

query_answer(required_query, Snapshot, Records, Result, Citations) :-
    trigger_key_order(Triggers),
    include(required_open_trigger(Snapshot, Records), Triggers, Candidates),
    required_answer(Candidates, Records, Result, Citations).
query_answer(complete_query, Snapshot, Records, Result, Citations) :-
    findall(Duty, failing_duty(Records, Duty), Failing),
    complete_after_failures(Failing, Snapshot, Records, Result, Citations).
query_answer(outstanding_query, Snapshot, Records, Result, Citations) :-
    key_candidates(outstanding_query, Snapshot, Records, Candidates),
    outstanding_after_candidates(Candidates, Snapshot, Records, Result, Citations).

required_open_trigger(Snapshot, Records, TriggerKey) :-
    lookup_state(Snapshot, TriggerKey, absent),
    findall(Duty, open_duty_with_condition_key(Records, TriggerKey, Duty), Duties),
    non_empty_t(Duties, true).

open_duty_with_condition_key(Records, TriggerKey, Duty) :-
    member(duty(Duty, _, Conditions, _, _, Applicability, _), Records),
    open_t(Applicability, true),
    condition_key_t(TriggerKey, Conditions, true).

required_answer([TriggerKey|_], _, indeterminate([TriggerKey]), []).
required_answer([], Records, required(Duties), Citations) :-
    implements(eu_reg_2022_2554_art_13_1),
    findall(Duty, member(duty(Duty, _, _, _, _, applies, _), Records), Duties),
    findall(Citation, member(duty(_, _, _, _, Citation, applies, _), Records), CitationList),
    sort(CitationList, Citations).

failing_duty(Records, Duty) :-
    implements(eu_reg_2022_2554_art_13_1),
    member(duty(Duty, _, _, _, _, applies, false), Records).

complete_after_failures([_|_], _, _, incomplete, Citations) :-
    implements(eu_reg_2022_2554_art_13_1),
    fixed_citations(Citations).
complete_after_failures([], Snapshot, Records, Result, Citations) :-
    key_candidates(complete_query, Snapshot, Records, Candidates),
    complete_after_candidates(Candidates, Snapshot, Records, Result, Citations).

complete_after_candidates([Candidate|Candidates], _, _, indeterminate([Key]), []) :-
    named_candidate_key(complete_query, [Candidate|Candidates], Key).
complete_after_candidates([], Snapshot, Records, Result, Citations) :-
    findall(Record, complete_reviewable(Snapshot, Records, Record), Reviewable),
    complete_after_review(Reviewable, Snapshot, Result, Citations).

complete_reviewable(Snapshot, Records, Record) :-
    member(Record, Records),
    Record = duty(_, _, _, _, _, _, unsure),
    complete_duty_through(Snapshot, Records, Record, Through),
    non_empty_t(Through, true).

complete_after_review([Record|_], Snapshot, Result, []) :-
    referral(Record, Snapshot, Result).
complete_after_review([], _, complete, Citations) :-
    implements(eu_reg_2022_2554_art_13_1),
    fixed_citations(Citations).

outstanding_after_candidates([Candidate|Candidates], _, _, indeterminate([Key]), []) :-
    named_candidate_key(outstanding_query, [Candidate|Candidates], Key).
outstanding_after_candidates([], Snapshot, Records, Result, Citations) :-
    findall(Record, outstanding_reviewable(Records, Record), Reviewable),
    outstanding_after_review(Reviewable, Snapshot, Records, Result, Citations).

outstanding_reviewable(Records, Record) :-
    member(Record, Records),
    Record = duty(_, _, _, _, _, Applicability, unsure),
    open_t(Applicability, true).

outstanding_after_review([Record|_], Snapshot, _, Result, []) :-
    referral(Record, Snapshot, Result).
outstanding_after_review([], _, Records, Result, Citations) :-
    findall(Record, failing_record(Records, Record), Failing),
    outstanding_final(Failing, Result, Citations).

failing_record(Records, Record) :-
    implements(eu_reg_2022_2554_art_13_1),
    member(Record, Records),
    Record = duty(_, _, _, _, _, applies, false).

outstanding_final([], none_outstanding, Citations) :-
    implements(eu_reg_2022_2554_art_13_1),
    fixed_citations(Citations).
outstanding_final([Record|Records], outstanding(Duties), Citations) :-
    implements(eu_reg_2022_2554_art_13_1),
    findall(Duty, member(duty(Duty, _, _, _, _, _, _), [Record|Records]), Duties),
    findall(Citation, member(duty(_, _, _, Citation, _, _, _), [Record|Records]), CitationList),
    sort(CitationList, Citations).

referral(duty(_, Key, _, KeyCitation, _, _, _), Snapshot, needs_legal_review(open_textured(Key, KeyCitation), [inputs_relied_on(Pairs)])) :-
    findall(Pair, present_pair(Snapshot, Pair), Pairs).

present_pair(Snapshot, Key - Value) :-
    member(Key - Value, Snapshot),
    dif(Value, absent).

key_candidates(Query, Snapshot, Records, Candidates) :-
    answer_key_order(Keys),
    findall(Key, absent_key(Snapshot, Keys, Key), AbsentKeys),
    maplist(key_candidate(Query, Snapshot, Records), AbsentKeys, Entries),
    include(candidate_changes, Entries, Candidates).

absent_key(Snapshot, Keys, Key) :-
    member(Key, Keys),
    lookup_state(Snapshot, Key, absent).

key_candidate(Query, Snapshot, Records, Key, candidate(Key, Through, Alone)) :-
    key_kind(Key, Kind),
    key_through(Query, Kind, Snapshot, Records, Key, Through),
    key_alone(Query, Kind, Snapshot, Records, Key, Alone).

candidate_changes(candidate(_, [_|_], _)).

key_kind(Key, trigger) :-
    trigger_key(Key).
key_kind(Key, duty) :-
    duty_row(_, Key, _, _, _).

key_through(complete_query, duty, Snapshot, Records, Key, Through) :-
    member(Record, Records),
    Record = duty(_, Key, _, _, _, _, _),
    complete_duty_through(Snapshot, Records, Record, Through).
key_through(complete_query, trigger, Snapshot, Records, Key, Through) :-
    findall(Record, complete_trigger_through(Snapshot, Records, Key, Record), Through).
key_through(outstanding_query, duty, _, Records, Key, Through) :-
    member(Record, Records),
    Record = duty(_, Key, _, _, _, Applicability, _),
    open_t(Applicability, Open),
    open_through(Open, Record, Through).
key_through(outstanding_query, trigger, _, Records, Key, Through) :-
    findall(Record, outstanding_trigger_through(Records, Key, Record), Through).

open_through(true, Record, [Record]).
open_through(false, _, []).

key_alone(_, duty, _, Records, Key, Alone) :-
    member(Record, Records),
    Record = duty(_, Key, _, _, _, Applicability, _),
    applies_t(Applicability, Alone).
key_alone(complete_query, trigger, Snapshot, Records, Key, Alone) :-
    findall(Record, complete_trigger_decider(Snapshot, Records, Key, Record), Deciders),
    non_empty_t(Deciders, Alone).
key_alone(outstanding_query, trigger, Snapshot, Records, Key, Alone) :-
    findall(Record, outstanding_trigger_alone(Snapshot, Records, Key, Record), Changers),
    non_empty_t(Changers, Alone).

complete_duty_through(Snapshot, Records, Record, Through) :-
    Record = duty(_, _, _, _, _, Applicability, _),
    open_t(Applicability, Open),
    findall(Other, duty_blocker(Snapshot, Records, Record, Other), Blockers),
    non_empty_t(Blockers, Blocked),
    duty_through(Open, Blocked, Record, Through).

duty_through(true, false, Record, [Record]).
duty_through(true, true, _, []).
duty_through(false, _, _, []).

duty_blocker(Snapshot, Records, duty(Duty, _, Conditions, _, _, _, _), Other) :-
    member(Other, Records),
    Other = duty(OtherDuty, _, OtherConditions, _, _, _, false),
    dif(OtherDuty, Duty),
    maplist(holds_or_among(Snapshot, Conditions), OtherConditions).

complete_trigger_through(Snapshot, Records, TriggerKey, Record) :-
    member(Value, [true, false]),
    member(Record, Records),
    Record = duty(_, _, Conditions, _, _, Applicability, KeyState),
    open_t(Applicability, true),
    memberd_t(TriggerKey - Value, Conditions, true),
    not_true_state(KeyState),
    findall(Other, trigger_blocker(Snapshot, Records, TriggerKey - Value, Record, Other), Blockers),
    non_empty_t(Blockers, false).

trigger_blocker(Snapshot, Records, TriggerKey - Value, duty(_, _, Conditions, _, _, _, _), Other) :-
    member(Other, Records),
    Other = duty(_, _, OtherConditions, _, _, _, false),
    memberd_t(TriggerKey - Value, OtherConditions, false),
    maplist(holds_or_among_unless_on_key(Snapshot, Conditions, TriggerKey), OtherConditions).

complete_trigger_decider(Snapshot, Records, TriggerKey, Record) :-
    member(Value, [true, false]),
    member(Record, Records),
    Record = duty(_, _, Conditions, _, _, _, false),
    memberd_t(TriggerKey - Value, Conditions, true),
    maplist(holds_unless_on_key(Snapshot, TriggerKey), Conditions).

outstanding_trigger_through(Records, TriggerKey, Record) :-
    member(Record, Records),
    Record = duty(_, _, Conditions, _, _, Applicability, KeyState),
    open_t(Applicability, true),
    condition_key_t(TriggerKey, Conditions, true),
    not_true_state(KeyState).

outstanding_trigger_alone(Snapshot, Records, TriggerKey, Record) :-
    outstanding_trigger_through(Records, TriggerKey, Record),
    Record = duty(_, _, Conditions, _, _, _, _),
    maplist(holds_unless_on_key(Snapshot, TriggerKey), Conditions).

holds_or_among(Snapshot, Conditions, Condition) :-
    condition_state(Snapshot, Condition, State),
    memberd_t(Condition, Conditions, Among),
    holds_or_among_state(State, Among).

holds_or_among_state(holds, _).
holds_or_among_state(open, true).
holds_or_among_state(fails, true).

holds_or_among_unless_on_key(_, _, TriggerKey, TriggerKey - _).
holds_or_among_unless_on_key(Snapshot, Conditions, TriggerKey, ConditionKey - Value) :-
    dif(ConditionKey, TriggerKey),
    holds_or_among(Snapshot, Conditions, ConditionKey - Value).

holds_unless_on_key(_, TriggerKey, TriggerKey - _).
holds_unless_on_key(Snapshot, TriggerKey, ConditionKey - Value) :-
    dif(ConditionKey, TriggerKey),
    condition_state(Snapshot, ConditionKey - Value, holds).

named_candidate_key(Query, Candidates, Key) :-
    include(unbehind_candidate(Query, Candidates), Candidates, Unbehind),
    first_candidate_key(Unbehind, Candidates, Key).

first_candidate_key([candidate(Key, _, _)|_], _, Key).
first_candidate_key([], [candidate(Key, _, _)|_], Key).

unbehind_candidate(Query, Candidates, Candidate) :-
    findall(Rival, behind_rival(Query, Candidates, Candidate, Rival), Rivals),
    non_empty_t(Rivals, false).

behind_rival(Query, Candidates, Candidate, Rival) :-
    member(Rival, Candidates),
    behind(Query, Candidate, Rival).

behind(complete_query, candidate(_, _, false), candidate(_, _, true)).
behind(complete_query, candidate(Key, Through, false), candidate(RivalKey, RivalThrough, false)) :-
    dif(Key, RivalKey),
    maplist(duty_involves_key(RivalKey), Through),
    member(RivalRecord, RivalThrough),
    duty_involves_key_t(Key, RivalRecord, false).
behind(outstanding_query, candidate(_, Through, false), candidate(RivalKey, _, true)) :-
    maplist(duty_involves_key(RivalKey), Through).

duty_involves_key(Key, Record) :-
    duty_involves_key_t(Key, Record, true).

duty_involves_key_t(Key, duty(_, DutyKey, Conditions, _, _, _, _), Truth) :-
    pairs_keys(Conditions, ConditionKeys),
    memberd_t(Key, [DutyKey|ConditionKeys], Truth).

duty_records(Snapshot, Records) :-
    findall(row(Duty, Key, Conditions, KeyCitation, ParagraphCitation), duty_row(Duty, Key, Conditions, KeyCitation, ParagraphCitation), Rows),
    maplist(duty_record(Snapshot), Rows, Records).

duty_record(Snapshot, row(Duty, Key, Conditions, KeyCitation, ParagraphCitation), duty(Duty, Key, Conditions, KeyCitation, ParagraphCitation, Applicability, KeyState)) :-
    applicability(Snapshot, Conditions, Applicability),
    lookup_state(Snapshot, Key, KeyState).

applicability(Snapshot, Conditions, Applicability) :-
    implements(eu_reg_2022_2554_art_13_2),
    maplist(condition_state(Snapshot), Conditions, States),
    states_applicability(States, Applicability).

states_applicability(States, excluded) :-
    memberd_t(fails, States, true).
states_applicability(States, applies) :-
    memberd_t(fails, States, false),
    memberd_t(open, States, false).
states_applicability(States, pending) :-
    memberd_t(fails, States, false),
    memberd_t(open, States, true).

condition_state(Snapshot, TriggerKey - Value, State) :-
    lookup_state(Snapshot, TriggerKey, TriggerState),
    trigger_condition_state(TriggerState, Value, State).

trigger_condition_state(absent, _, open).
trigger_condition_state(true, true, holds).
trigger_condition_state(false, false, holds).
trigger_condition_state(true, false, fails).
trigger_condition_state(false, true, fails).

condition_key_t(Key, Conditions, Truth) :-
    pairs_keys(Conditions, ConditionKeys),
    memberd_t(Key, ConditionKeys, Truth).

open_t(applies, true).
open_t(pending, true).
open_t(excluded, false).

applies_t(applies, true).
applies_t(pending, false).
applies_t(excluded, false).

not_true_state(false).
not_true_state(unsure).
not_true_state(absent).

non_empty_t([], false).
non_empty_t([_|_], true).

profile_snapshot(Profile, Snapshot) :-
    contract_key_order(Keys),
    maplist(snapshot_entry(Profile), Keys, Snapshot).

snapshot_entry(Profile, Key, Key - Value) :-
    profile_get(Profile, Key, Value).
snapshot_entry(Profile, Key, Key - absent) :-
    profile_lacks(Profile, Key).

lookup_state(Snapshot, Key, State) :-
    member(Key - State, Snapshot).

decide_dora_ict_risk_learning_and_evolving(Profile, dora_ict_risk_learning_and_evolving_verdict(Status, Citations)) :-
    ict_risk_learning_and_evolving_duties_complete(Profile, Status, Citations).

dora_ict_risk_learning_and_evolving_status(Profile, Status) :-
    decide_dora_ict_risk_learning_and_evolving(Profile, dora_ict_risk_learning_and_evolving_verdict(Status, _Citations)).

dora_ict_risk_learning_and_evolving_decision_resolvable(Profile) :-
    decide_dora_ict_risk_learning_and_evolving(Profile, _Verdict).

dora_ict_risk_learning_and_evolving_checklist(Profile, Items) :-
    dora_ict_risk_learning_and_evolving_input_problems(Profile, Problems),
    checklist_for_problems(Problems, Profile, Items).

checklist_for_problems([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2022_2554_art_13_1))]).
checklist_for_problems([], Profile, Items) :-
    profile_snapshot(Profile, Snapshot),
    lookup_state(Snapshot, financial_entity_is_article_16_1_entity, GateState),
    gate_checklist(GateState, Snapshot, Items).

gate_checklist(true, _, [item(article_16_1_entity, inapplicable, cite(eu_reg_2022_2554_art_16_1))]) :-
    implements(eu_reg_2022_2554_art_16_1).
gate_checklist(absent, _, [item(article_16_1_entity, unknown([financial_entity_is_article_16_1_entity]), cite(eu_reg_2022_2554_art_16_1))]) :-
    implements(eu_reg_2022_2554_art_16_1).
gate_checklist(false, Snapshot, Items) :-
    implements(eu_reg_2022_2554_art_16_1),
    duty_records(Snapshot, Records),
    maplist(duty_item(Snapshot), Records, Items).

duty_item(Snapshot, duty(Duty, Key, Conditions, KeyCitation, _, Applicability, KeyState), item(Duty, Status, KeyCitation)) :-
    duty_item_status(Applicability, KeyState, Key, Conditions, Snapshot, Status).

duty_item_status(excluded, _, _, _, _, inapplicable).
duty_item_status(applies, true, _, _, _, met).
duty_item_status(applies, false, _, _, _, unmet(not_performed)).
duty_item_status(applies, unsure, Key, _, _, unknown([Key])).
duty_item_status(applies, absent, Key, _, _, unknown([Key])).
duty_item_status(pending, _, _, Conditions, Snapshot, unknown(OpenKeys)) :-
    findall(ConditionKey, open_condition_key(Snapshot, Conditions, ConditionKey), OpenKeys).

open_condition_key(Snapshot, Conditions, ConditionKey) :-
    member(ConditionKey - Value, Conditions),
    condition_state(Snapshot, ConditionKey - Value, open).

test_profile(Facts, Overrides, Profile) :-
    findall(Key, duty_row(_, Key, [], _, _), AlwaysKeys),
    maplist(always_pair(Overrides), AlwaysKeys, AlwaysPairs),
    append(Facts, AlwaysPairs, AllPairs),
    include(present_test_pair, AllPairs, Pairs),
    maplist(pair_attribute, Pairs, Profile).

always_pair(Overrides, Key, Key - Value) :-
    pairs_keys(Overrides, OverrideKeys),
    memberd_t(Key, OverrideKeys, Overridden),
    override_value(Overridden, Overrides, Key, Value).

override_value(true, Overrides, Key, Value) :-
    member(Key - Value, Overrides).
override_value(false, _, _, true).

present_test_pair(_ - Value) :-
    dif(Value, absent).

pair_attribute(Key - Value, attribute(Key, Value)).

test(gate_true_is_simplified_framework_entity) :-
    test_profile([financial_entity_is_article_16_1_entity - true], [], Profile),
    findall(Result - Citations, ict_risk_learning_and_evolving_duties_required(Profile, Result, Citations), Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(empty_profile_asks_for_the_gate) :-
    findall(Result - Citations, ict_risk_learning_and_evolving_duties_complete([], Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(required_asks_microenterprise_first) :-
    test_profile([financial_entity_is_article_16_1_entity - false], [], Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, Result, Citations),
    Result == indeterminate([financial_entity_is_microenterprise]),
    Citations == [].
test(required_for_a_microenterprise_without_incident) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [], Profile),
    findall(Result - Citations, ict_risk_learning_and_evolving_duties_required(Profile, Result, Citations), [required(Duties) - Citations]),
    length(Duties, 11),
    Duties = [threat_and_incident_information_capability|_],
    Citations == [cite(eu_reg_2022_2554_art_13_1), cite(eu_reg_2022_2554_art_13_3), cite(eu_reg_2022_2554_art_13_4), cite(eu_reg_2022_2554_art_13_5), cite(eu_reg_2022_2554_art_13_6)].
test(required_full_list_after_incident_and_request) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false, major_ict_related_incident_disrupted_core_activities - true, competent_authority_requested_post_incident_review_changes - true], [], Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, required(Duties), Citations),
    length(Duties, 20),
    fixed_citations(Citations).
test(complete_when_every_applying_duty_is_performed) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [], Profile),
    findall(Result, ict_risk_learning_and_evolving_duties_complete(Profile, Result, _), Results),
    Results == [complete].
test(incomplete_when_one_duty_is_false) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [senior_ict_staff_report_findings_and_recommendations_at_least_yearly - false], Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, Result, Citations),
    Result == incomplete,
    fixed_citations(Citations).
test(false_duty_decides_completeness_before_an_absent_key) :-
    test_profile([financial_entity_is_article_16_1_entity - false], [senior_ict_staff_report_findings_and_recommendations_at_least_yearly - false, capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information - absent], Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, incomplete, _).
test(outstanding_lists_the_false_duty) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [senior_ict_staff_report_findings_and_recommendations_at_least_yearly - false], Profile),
    findall(Result - Citations, ict_risk_learning_and_evolving_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([yearly_report_to_management_body]) - [cite(eu_reg_2022_2554_art_13_5)]].
test(outstanding_asks_an_absent_key_despite_a_false_one) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [senior_ict_staff_report_findings_and_recommendations_at_least_yearly - false, capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information - absent], Profile),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, Result, []),
    Result == indeterminate([capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information]).
test(none_outstanding_when_all_performed) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [], Profile),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, none_outstanding, Citations),
    fixed_citations(Citations).
test(unsure_judgement_goes_to_review) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information - unsure], Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, Result, Citations),
    Result = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information,
    Citation == cite(eu_reg_2022_2554_art_13_1),
    length(Pairs, 14),
    Pairs = [financial_entity_is_article_16_1_entity - false|_],
    Citations == [].
test(always_duty_key_is_asked_before_a_trigger) :-
    test_profile([financial_entity_is_article_16_1_entity - false], [capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information - absent], Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, Result, _),
    Result == indeterminate([capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information]).
test(microenterprise_asked_once_always_duties_are_answered) :-
    test_profile([financial_entity_is_article_16_1_entity - false], [], Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, Result, _),
    Result == indeterminate([financial_entity_is_microenterprise]).
test(incident_asked_before_the_review_duties_and_the_request) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false, relevant_technological_developments_monitored_continuously - true, kept_up_to_date_with_latest_ict_risk_management_processes - true], [], Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, Result, _),
    Result == indeterminate([major_ict_related_incident_disrupted_core_activities]).
test(unknown_key_is_an_input_problem) :-
    test_profile([financial_entity_is_article_16_1_entity - false, colour - red], [], Profile),
    findall(Result - Citations, ict_risk_learning_and_evolving_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(checklist_carries_a_citation_per_duty) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [], Profile),
    dora_ict_risk_learning_and_evolving_checklist(Profile, Items),
    length(Items, 20),
    member(item(threat_and_incident_information_capability, met, cite(eu_reg_2022_2554_art_13_1)), Items),
    member(item(post_incident_reviews, inapplicable, cite(eu_reg_2022_2554_art_13_2)), Items).

test(complete_profile_is_not_incomplete, fail) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false], [], Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, incomplete, _).
