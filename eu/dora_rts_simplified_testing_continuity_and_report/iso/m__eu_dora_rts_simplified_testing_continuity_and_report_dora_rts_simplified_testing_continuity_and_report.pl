% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_dora_rts_simplified_testing_continuity_and_report, [simplified_testing_continuity_and_report_duties_required/3, simplified_testing_continuity_and_report_duties_complete/3, simplified_testing_continuity_and_report_duties_outstanding/3, decide_dora_rts_simplified_testing_continuity_and_report/2, dora_rts_simplified_testing_continuity_and_report_status/2, dora_rts_simplified_testing_continuity_and_report_checklist/2, dora_rts_simplified_testing_continuity_and_report_decision_resolvable/1, dora_rts_simplified_testing_continuity_and_report_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_kernel, [dora_rts_simplified_testing_continuity_and_report_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_citations, [implements/1]).

dora_rts_simplified_testing_continuity_and_report_status_values([complete, incomplete, not_article_16_1_entity, indeterminate, needs_legal_review, input_problems]).

fixed_citations([cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2024_1774_art_36_1), cite(eu_reg_2024_1774_art_36_2), cite(eu_reg_2024_1774_art_36_3), cite(eu_reg_2024_1774_art_37), cite(eu_reg_2024_1774_art_38_1), cite(eu_reg_2024_1774_art_38_2), cite(eu_reg_2024_1774_art_39_1), cite(eu_reg_2024_1774_art_39_2), cite(eu_reg_2024_1774_art_40_1), cite(eu_reg_2024_1774_art_40_2), cite(eu_reg_2024_1774_art_40_3), cite(eu_reg_2024_1774_art_41_1), cite(eu_reg_2024_1774_art_41_2)]).

trigger_key(authority_requested_framework_review_report, cite(eu_reg_2022_2554_art_16_2)).
trigger_key(framework_review_initiated_following_supervisory_instructions, cite(eu_reg_2024_1774_art_41_2)).
trigger_key(framework_review_initiated_following_ict_related_incidents, cite(eu_reg_2024_1774_art_41_2)).

duty(ict_security_testing_plan, ict_security_testing_plan_established_and_implemented, [], cite(eu_reg_2024_1774_art_36_1)).
duty(review_and_testing_of_security_measures, ict_security_measures_reviewed_assessed_and_tested, [], cite(eu_reg_2024_1774_art_36_2)).
duty(evaluation_of_security_test_results, security_test_results_evaluated_and_measures_updated, [], cite(eu_reg_2024_1774_art_36_3)).
duty(acquisition_development_and_maintenance_procedure, ict_systems_acquisition_and_development_procedure_in_place, [], cite(eu_reg_2024_1774_art_37)).
duty(requirements_specified_before_acquisition, requirements_specified_and_approved_before_acquisition, [], cite(eu_reg_2024_1774_art_37)).
duty(testing_and_approval_before_use, ict_systems_tested_and_approved_before_use_and_changes, [], cite(eu_reg_2024_1774_art_37)).
duty(manipulation_risk_measures, alteration_and_manipulation_risk_measures_identified, [], cite(eu_reg_2024_1774_art_37)).
duty(ict_project_management_procedure, ict_project_management_procedure_in_place, [], cite(eu_reg_2024_1774_art_38_1)).
duty(ict_change_management_procedure, ict_change_management_procedure_in_place, [], cite(eu_reg_2024_1774_art_38_2)).
duty(continuity_plans_based_on_disruption_analysis, continuity_plans_developed_on_disruption_and_scenario_analysis, [], cite(eu_reg_2024_1774_art_39_1)).
duty(management_body_approval_of_continuity_plans, continuity_plans_approved_by_management_body, [], cite(eu_reg_2024_1774_art_39_2)).
duty(continuity_plans_documented_and_accessible, continuity_plans_documented_and_readily_accessible, [], cite(eu_reg_2024_1774_art_39_2)).
duty(continuity_plan_resources, continuity_plans_allocate_sufficient_resources, [], cite(eu_reg_2024_1774_art_39_2)).
duty(recovery_levels_and_timeframes, continuity_plans_establish_recovery_levels_and_timeframes, [], cite(eu_reg_2024_1774_art_39_2)).
duty(activation_conditions_and_actions, continuity_plans_identify_activation_conditions_and_actions, [], cite(eu_reg_2024_1774_art_39_2)).
duty(restoration_and_recovery_measures, continuity_plans_identify_restoration_and_recovery_measures, [], cite(eu_reg_2024_1774_art_39_2)).
duty(backup_procedures, continuity_plans_identify_backup_procedures_scope_and_frequency, [], cite(eu_reg_2024_1774_art_39_2)).
duty(alternative_options, continuity_plans_consider_alternative_options, [], cite(eu_reg_2024_1774_art_39_2)).
duty(communication_arrangements, continuity_plans_specify_communication_and_escalation, [], cite(eu_reg_2024_1774_art_39_2)).
duty(updating_of_continuity_plans, continuity_plans_updated_with_lessons_learned, [], cite(eu_reg_2024_1774_art_39_2)).
duty(testing_of_continuity_plans, continuity_plans_tested_yearly_and_on_major_change, [], cite(eu_reg_2024_1774_art_40_1)).
duty(continuity_testing_demonstrates_viability, continuity_plan_testing_demonstrates_viability_and_finds_deficiencies, [], cite(eu_reg_2024_1774_art_40_2)).
duty(continuity_test_results_and_deficiencies, continuity_test_results_documented_and_deficiencies_reported, [], cite(eu_reg_2024_1774_art_40_3)).
duty(review_report_in_searchable_electronic_format, review_report_submitted_in_searchable_electronic_format, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_1)).
duty(report_context_description, review_report_describes_context, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_executive_summary, review_report_has_executive_summary, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_reported_area, review_report_informs_on_reported_area, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_major_framework_changes, review_report_summarises_major_framework_changes, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_impact_of_major_changes, review_report_describes_impact_of_major_changes, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_approval_date, review_report_states_approval_date_where_applicable, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_reasons_for_review, review_report_describes_reasons_for_review, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_evidence_of_supervisory_instructions, review_report_gives_evidence_of_supervisory_instructions, [authority_requested_framework_review_report, framework_review_initiated_following_supervisory_instructions], cite(eu_reg_2024_1774_art_41_2)).
duty(report_incidents_and_root_cause_analysis, review_report_lists_incidents_with_root_cause_analysis, [authority_requested_framework_review_report, framework_review_initiated_following_ict_related_incidents], cite(eu_reg_2024_1774_art_41_2)).
duty(report_review_period, review_report_states_review_period, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_person_responsible, review_report_names_person_responsible, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_findings_and_self_assessment, review_report_summarises_findings_and_self_assessment, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_remedying_measures, review_report_states_remedying_measures, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).
duty(report_overall_conclusions, review_report_states_overall_conclusions, [authority_requested_framework_review_report], cite(eu_reg_2024_1774_art_41_2)).

root_keys(ProfileKeys) :-
    findall(TriggerAtom, trigger_key(TriggerAtom, _), TriggerKeys),
    findall(DutyKey, duty(_, DutyKey, _, _), DutyKeys),
    append([financial_entity_is_article_16_1_entity|TriggerKeys], DutyKeys, ProfileKeys).

profile_states(Profile, States) :-
    root_keys(ProfileKeys),
    maplist(key_state_pair(Profile), ProfileKeys, States).

key_state_pair(Profile, KeyAtom, KeyAtom - State) :-
    key_state(Profile, KeyAtom, State).

key_state(Profile, KeyAtom, absent) :-
    profile_lacks(Profile, KeyAtom).
key_state(Profile, KeyAtom, given(Value)) :-
    profile_get(Profile, KeyAtom, Value).

state_of(States, KeyAtom, State) :-
    member(KeyAtom - State, States).

relied_pairs(States, KeyPairs) :-
    findall(KeyAtom - Value, member(KeyAtom - given(Value), States), KeyPairs).

first_entry([Entry|_], first(Entry)).
first_entry([], none).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

negate(true, false).
negate(false, true).

truth_all([], true).
truth_all([Truth|Truths], Result) :-
    truth_all(Truths, RestResult),
    truth_and(Truth, RestResult, Result).

any_row_t(_, [], false).
any_row_t(Goal, [DutyRow|RestRows], Truth) :-
    call(Goal, DutyRow, RowTruth),
    any_row_t(Goal, RestRows, RestTruth),
    truth_or(RowTruth, RestTruth, Truth).

condition_state(States, authority_requested_framework_review_report, Standing) :-
    implements(eu_reg_2022_2554_art_16_2),
    state_of(States, authority_requested_framework_review_report, State),
    condition_value(State, Standing).
condition_state(States, framework_review_initiated_following_supervisory_instructions, Standing) :-
    implements(eu_reg_2024_1774_art_41_2),
    state_of(States, framework_review_initiated_following_supervisory_instructions, State),
    condition_value(State, Standing).
condition_state(States, framework_review_initiated_following_ict_related_incidents, Standing) :-
    implements(eu_reg_2024_1774_art_41_2),
    state_of(States, framework_review_initiated_following_ict_related_incidents, State),
    condition_value(State, Standing).

condition_value(absent, open).
condition_value(given(true), holds).
condition_value(given(false), fails).

conditions_summary(_, [], all_hold).
conditions_summary(States, [Condition|Conditions], Summary) :-
    condition_state(States, Condition, Standing),
    conditions_summary(States, Conditions, RestSummary),
    combine_summary(Standing, RestSummary, Summary).

combine_summary(fails, _, some_fail).
combine_summary(holds, RestSummary, RestSummary).
combine_summary(open, all_hold, some_open).
combine_summary(open, some_open, some_open).
combine_summary(open, some_fail, some_fail).

summary_standing(all_hold, applies).
summary_standing(some_open, open_pending).
summary_standing(some_fail, inapplicable).

duty_row(States, row(DutyAtom, DutyKey, Conditions, cite(CitationKey), Standing, KeyState)) :-
    duty(DutyAtom, DutyKey, Conditions, cite(CitationKey)),
    conditions_summary(States, Conditions, Summary),
    summary_standing(Summary, Standing),
    state_of(States, DutyKey, KeyState).

duty_rows(States, DutyRows) :-
    findall(DutyRow, duty_row(States, DutyRow), DutyRows).

open_standing(applies).
open_standing(open_pending).

open_t(applies, true).
open_t(open_pending, true).
open_t(inapplicable, false).

applies_t(applies, true).
applies_t(open_pending, false).
applies_t(inapplicable, false).

key_false_t(absent, false).
key_false_t(given(true), false).
key_false_t(given(false), true).
key_false_t(given(unsure), false).

not_true_t(absent, true).
not_true_t(given(true), false).
not_true_t(given(false), true).
not_true_t(given(unsure), true).

not_true_state(absent).
not_true_state(given(false)).
not_true_state(given(unsure)).

all_covered_t(_, _, [], true).
all_covered_t(States, Covering, [Condition|Conditions], Truth) :-
    condition_state(States, Condition, Standing),
    covered_by_standing_t(Standing, Condition, Covering, ConditionTruth),
    all_covered_t(States, Covering, Conditions, RestTruth),
    truth_and(ConditionTruth, RestTruth, Truth).

covered_by_standing_t(holds, _, _, true).
covered_by_standing_t(fails, Condition, Covering, Truth) :-
    memberd_t(Condition, Covering, Truth).
covered_by_standing_t(open, Condition, Covering, Truth) :-
    memberd_t(Condition, Covering, Truth).

guard_t(no_guard, _, true).
guard_t(not_on(TriggerAtom), Conditions, Truth) :-
    memberd_t(TriggerAtom, Conditions, IsOn),
    negate(IsOn, Truth).

row_blocks_t(States, Guard, Covering, row(_, _, Conditions, _, _, KeyState), Truth) :-
    key_false_t(KeyState, IsFalse),
    guard_t(Guard, Conditions, GuardHolds),
    all_covered_t(States, Covering, Conditions, IsCovered),
    truth_all([IsFalse, GuardHolds, IsCovered], Truth).

duty_key_changes_t(States, DutyRows, row(_, _, Conditions, _, Standing, _), Truth) :-
    implements(eu_reg_2024_1774_art_41_2),
    open_t(Standing, IsOpen),
    any_row_t(row_blocks_t(States, no_guard, Conditions), DutyRows, Blocked),
    negate(Blocked, Unblocked),
    truth_and(IsOpen, Unblocked, Truth).

trigger_changes_t(States, DutyRows, TriggerAtom, Truth) :-
    implements(eu_reg_2024_1774_art_41_2),
    any_row_t(trigger_row_change_t(States, DutyRows, TriggerAtom), DutyRows, Truth).

trigger_row_change_t(States, DutyRows, TriggerAtom, row(_, _, Conditions, _, Standing, KeyState), Truth) :-
    open_t(Standing, IsOpen),
    memberd_t(TriggerAtom, Conditions, IsUnder),
    not_true_t(KeyState, NotTrue),
    exclude(==(TriggerAtom), Conditions, OtherConditions),
    any_row_t(row_blocks_t(States, not_on(TriggerAtom), OtherConditions), DutyRows, Blocked),
    negate(Blocked, Unblocked),
    truth_all([IsOpen, IsUnder, NotTrue, Unblocked], Truth).

trigger_decides_alone_t(States, DutyRows, TriggerAtom, Truth) :-
    implements(eu_reg_2024_1774_art_41_2),
    any_row_t(alone_row_t(States, TriggerAtom), DutyRows, Truth).

alone_row_t(States, TriggerAtom, row(_, _, Conditions, _, _, KeyState), Truth) :-
    memberd_t(TriggerAtom, Conditions, IsUnder),
    key_false_t(KeyState, IsFalse),
    exclude(==(TriggerAtom), Conditions, OtherConditions),
    all_covered_t(States, [], OtherConditions, OthersHold),
    truth_all([IsUnder, IsFalse, OthersHold], Truth).

complete_candidates(States, DutyRows, Entries) :-
    findall(TriggerAtom, trigger_key(TriggerAtom, _), TriggerKeys),
    maplist(trigger_entry(States, DutyRows), TriggerKeys, TriggerEntries),
    maplist(duty_key_entry(States, DutyRows), DutyRows, DutyEntries),
    append(TriggerEntries, DutyEntries, Entries).

trigger_entry(States, DutyRows, TriggerAtom, Entry) :-
    state_of(States, TriggerAtom, State),
    absent_trigger_entry(State, States, DutyRows, TriggerAtom, Entry).

absent_trigger_entry(given(_), _, _, _, skip).
absent_trigger_entry(absent, States, DutyRows, TriggerAtom, Entry) :-
    trigger_changes_t(States, DutyRows, TriggerAtom, Changes),
    trigger_decides_alone_t(States, DutyRows, TriggerAtom, Alone),
    candidate_entry(Changes, TriggerAtom, Alone, Entry).

duty_key_entry(States, DutyRows, DutyRow, Entry) :-
    DutyRow = row(_, DutyKey, _, _, Standing, KeyState),
    absent_duty_entry(KeyState, States, DutyRows, DutyRow, DutyKey, Standing, Entry).

absent_duty_entry(given(_), _, _, _, _, _, skip).
absent_duty_entry(absent, States, DutyRows, DutyRow, DutyKey, Standing, Entry) :-
    duty_key_changes_t(States, DutyRows, DutyRow, Changes),
    applies_t(Standing, Alone),
    candidate_entry(Changes, DutyKey, Alone, Entry).

candidate_entry(true, KeyAtom, Alone, candidate(KeyAtom, Alone)).
candidate_entry(false, _, _, skip).

choose_named([KeyAtom|_], _, first(KeyAtom)).
choose_named([], [KeyAtom|_], first(KeyAtom)).
choose_named([], [], none).

simplified_testing_continuity_and_report_duties_required(Profile, Result, Citations) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems(Profile, Problems),
    required_after_check(Problems, Profile, Result, Citations).

required_after_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
required_after_check([], Profile, Result, Citations) :-
    profile_states(Profile, States),
    state_of(States, financial_entity_is_article_16_1_entity, GateState),
    required_by_gate(GateState, States, Result, Citations).

required_by_gate(given(false), _, not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
required_by_gate(absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
required_by_gate(given(true), States, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    duty_rows(States, DutyRows),
    findall(TriggerAtom, required_open_trigger(States, DutyRows, TriggerAtom), TriggerKeys),
    first_entry(TriggerKeys, Outcome),
    required_named(Outcome, DutyRows, Result, Citations).

required_open_trigger(States, DutyRows, TriggerAtom) :-
    implements(eu_reg_2022_2554_art_16_2),
    trigger_key(TriggerAtom, _),
    state_of(States, TriggerAtom, absent),
    member(row(_, _, Conditions, _, Standing, _), DutyRows),
    open_standing(Standing),
    member(TriggerAtom, Conditions).

required_named(first(TriggerAtom), _, indeterminate([TriggerAtom]), []).
required_named(none, DutyRows, required(Duties), Citations) :-
    findall(DutyAtom, member(row(DutyAtom, _, _, _, applies, _), DutyRows), Duties),
    findall(Citation, member(row(_, _, _, Citation, applies, _), DutyRows), DutyCitations),
    sort([cite(eu_reg_2022_2554_art_16_1)|DutyCitations], Citations).

simplified_testing_continuity_and_report_duties_complete(Profile, Result, Citations) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems(Profile, Problems),
    complete_after_check(Problems, Profile, Result, Citations).

complete_after_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
complete_after_check([], Profile, Result, Citations) :-
    profile_states(Profile, States),
    state_of(States, financial_entity_is_article_16_1_entity, GateState),
    complete_by_gate(GateState, States, Result, Citations).

complete_by_gate(given(false), _, not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
complete_by_gate(absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
complete_by_gate(given(true), States, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    duty_rows(States, DutyRows),
    findall(DutyAtom, member(row(DutyAtom, _, _, _, applies, given(false)), DutyRows), Failing),
    complete_by_failures(Failing, States, DutyRows, Result, Citations).

complete_by_failures([_|_], _, _, incomplete, Citations) :-
    implements(eu_reg_2024_1774_art_36_1),
    fixed_citations(Citations).
complete_by_failures([], States, DutyRows, Result, Citations) :-
    complete_candidates(States, DutyRows, Entries),
    findall(KeyAtom, member(candidate(KeyAtom, true), Entries), AloneKeys),
    findall(KeyAtom, member(candidate(KeyAtom, _), Entries), CandidateKeys),
    choose_named(AloneKeys, CandidateKeys, Outcome),
    complete_named(Outcome, States, DutyRows, Result, Citations).

complete_named(first(KeyAtom), _, _, indeterminate([KeyAtom]), []).
complete_named(none, States, DutyRows, Result, Citations) :-
    findall(DutyKey - Citation, unsure_changing(States, DutyRows, DutyKey, Citation), Referrals),
    first_entry(Referrals, Outcome),
    complete_referral(Outcome, States, Result, Citations).

unsure_changing(States, DutyRows, DutyKey, Citation) :-
    member(row(DutyAtom, DutyKey, Conditions, Citation, Standing, given(unsure)), DutyRows),
    duty_key_changes_t(States, DutyRows, row(DutyAtom, DutyKey, Conditions, Citation, Standing, given(unsure)), true).

complete_referral(first(DutyKey - Citation), States, needs_legal_review(open_textured(DutyKey, Citation), [inputs_relied_on(KeyPairs)]), []) :-
    relied_pairs(States, KeyPairs).
complete_referral(none, _, complete, Citations) :-
    implements(eu_reg_2024_1774_art_41_2),
    fixed_citations(Citations).

simplified_testing_continuity_and_report_duties_outstanding(Profile, Result, Citations) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems(Profile, Problems),
    outstanding_after_check(Problems, Profile, Result, Citations).

outstanding_after_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
outstanding_after_check([], Profile, Result, Citations) :-
    profile_states(Profile, States),
    state_of(States, financial_entity_is_article_16_1_entity, GateState),
    outstanding_by_gate(GateState, States, Result, Citations).

outstanding_by_gate(given(false), _, not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
outstanding_by_gate(absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
outstanding_by_gate(given(true), States, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    duty_rows(States, DutyRows),
    findall(KeyAtom, outstanding_changing_key(States, DutyRows, KeyAtom), ChangingKeys),
    first_entry(ChangingKeys, Outcome),
    outstanding_named(Outcome, States, DutyRows, Result, Citations).

outstanding_changing_key(States, DutyRows, TriggerAtom) :-
    implements(eu_reg_2022_2554_art_16_2),
    trigger_key(TriggerAtom, _),
    state_of(States, TriggerAtom, absent),
    member(row(_, _, Conditions, _, Standing, KeyState), DutyRows),
    open_standing(Standing),
    member(TriggerAtom, Conditions),
    not_true_state(KeyState).
outstanding_changing_key(_, DutyRows, DutyKey) :-
    implements(eu_reg_2024_1774_art_41_2),
    member(row(_, DutyKey, _, _, Standing, absent), DutyRows),
    open_standing(Standing).

outstanding_named(first(KeyAtom), _, _, indeterminate([KeyAtom]), []).
outstanding_named(none, States, DutyRows, Result, Citations) :-
    findall(DutyKey - Citation, outstanding_unsure(DutyRows, DutyKey, Citation), Referrals),
    first_entry(Referrals, Outcome),
    outstanding_referral(Outcome, States, DutyRows, Result, Citations).

outstanding_unsure(DutyRows, DutyKey, Citation) :-
    member(row(_, DutyKey, _, Citation, Standing, given(unsure)), DutyRows),
    open_standing(Standing).

outstanding_referral(first(DutyKey - Citation), States, _, needs_legal_review(open_textured(DutyKey, Citation), [inputs_relied_on(KeyPairs)]), []) :-
    relied_pairs(States, KeyPairs).
outstanding_referral(none, _, DutyRows, Result, Citations) :-
    findall(DutyAtom, member(row(DutyAtom, _, _, _, applies, given(false)), DutyRows), Failing),
    findall(Citation, member(row(_, _, _, Citation, applies, given(false)), DutyRows), FailingCitations),
    outstanding_final(Failing, FailingCitations, Result, Citations).

outstanding_final([], _, none_outstanding, Citations) :-
    implements(eu_reg_2024_1774_art_41_2),
    fixed_citations(Citations).
outstanding_final([FirstDuty|OtherDuties], FailingCitations, outstanding([FirstDuty|OtherDuties]), Citations) :-
    implements(eu_reg_2024_1774_art_41_2),
    sort(FailingCitations, Citations).

decide_dora_rts_simplified_testing_continuity_and_report(Profile, dora_rts_simplified_testing_continuity_and_report_verdict(Result, Citations)) :-
    simplified_testing_continuity_and_report_duties_complete(Profile, Result, Citations).

dora_rts_simplified_testing_continuity_and_report_status(Profile, Status) :-
    decide_dora_rts_simplified_testing_continuity_and_report(Profile, dora_rts_simplified_testing_continuity_and_report_verdict(Result, _)),
    functor(Result, Status, _).

dora_rts_simplified_testing_continuity_and_report_checklist(Profile, Items) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems(Profile, Problems),
    checklist_after_check(Problems, Profile, Items).

checklist_after_check([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), [])]).
checklist_after_check([], Profile, Items) :-
    profile_states(Profile, States),
    state_of(States, financial_entity_is_article_16_1_entity, GateState),
    checklist_by_gate(GateState, States, Items).

checklist_by_gate(given(false), _, [item(article_16_1_entity, unmet(not_article_16_1_entity), [cite(eu_reg_2022_2554_art_16_1)])]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_by_gate(absent, _, [item(article_16_1_entity, unknown([financial_entity_is_article_16_1_entity]), [cite(eu_reg_2022_2554_art_16_1)])]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_by_gate(given(true), States, [item(article_16_1_entity, met, [cite(eu_reg_2022_2554_art_16_1)])|DutyItems]) :-
    implements(eu_reg_2022_2554_art_16_1),
    duty_rows(States, DutyRows),
    maplist(duty_item, DutyRows, DutyItems).

duty_item(row(DutyAtom, DutyKey, Conditions, Citation, Standing, KeyState), item(DutyAtom, Status, [Citation])) :-
    item_status(Standing, KeyState, DutyKey, Conditions, Status).

item_status(inapplicable, _, _, _, inapplicable).
item_status(open_pending, _, _, Conditions, unknown(Conditions)).
item_status(applies, given(true), _, _, met).
item_status(applies, given(false), DutyKey, _, unmet(DutyKey)).
item_status(applies, given(unsure), DutyKey, _, unknown([DutyKey])).
item_status(applies, absent, DutyKey, _, unknown([DutyKey])).

dora_rts_simplified_testing_continuity_and_report_decision_resolvable(Profile) :-
    decide_dora_rts_simplified_testing_continuity_and_report(Profile, _).

articles_36_to_40_true(Attributes) :-
    findall(attribute(DutyKey, true), duty(_, DutyKey, [], _), Attributes).

articles_36_to_40_true_except(Excluded, Attributes) :-
    findall(attribute(DutyKey, true), excluded_duty_key(Excluded, DutyKey), Attributes).

excluded_duty_key(Excluded, DutyKey) :-
    duty(DutyAtom, DutyKey, [], _),
    dif(DutyAtom, Excluded).

test(a_false_gate_is_not_an_article_16_1_entity) :-
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, false)], not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(an_empty_profile_names_the_gate) :-
    simplified_testing_continuity_and_report_duties_required([], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(required_asks_for_the_request_first) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_article_16_1_entity, true)], indeterminate([authority_requested_framework_review_report]), []).
test(required_without_a_request_lists_twenty_three) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, false)], required(Duties), Citations),
    length(Duties, 23),
    length(Citations, 12).
test(required_with_a_request_asks_for_supervisory_instructions) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, true)], indeterminate([framework_review_initiated_following_supervisory_instructions]), []).
test(required_with_a_request_and_supervisory_instructions) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, true), attribute(framework_review_initiated_following_supervisory_instructions, true), attribute(framework_review_initiated_following_ict_related_incidents, false)], required(Duties), Citations),
    length(Duties, 37),
    length(Citations, 14).
test(complete_names_the_first_duty_key) :-
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, true)], indeterminate([ict_security_testing_plan_established_and_implemented]), []).
test(a_false_duty_is_incomplete_whatever_is_absent) :-
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, true), attribute(ict_security_testing_plan_established_and_implemented, false)], incomplete, Citations),
    length(Citations, 14).
test(all_duties_performed_without_a_request_is_complete) :-
    articles_36_to_40_true(Attributes),
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, false)|Attributes], complete, Citations),
    length(Citations, 14).
test(all_duties_performed_asks_for_the_request) :-
    articles_36_to_40_true(Attributes),
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, true)|Attributes], indeterminate([authority_requested_framework_review_report]), []).
test(a_false_incident_list_puts_the_request_first) :-
    articles_36_to_40_true(Attributes),
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, true), attribute(framework_review_initiated_following_ict_related_incidents, true), attribute(review_report_lists_incidents_with_root_cause_analysis, false)|Attributes], indeterminate([authority_requested_framework_review_report]), []).
test(an_unsure_duty_is_referred) :-
    articles_36_to_40_true_except(ict_security_testing_plan, Attributes),
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, false), attribute(ict_security_testing_plan_established_and_implemented, unsure)|Attributes], needs_legal_review(open_textured(ict_security_testing_plan_established_and_implemented, cite(eu_reg_2024_1774_art_36_1)), [inputs_relied_on(KeyPairs)]), []),
    length(KeyPairs, 25).
test(outstanding_asks_for_the_request_in_root_order) :-
    simplified_testing_continuity_and_report_duties_outstanding([attribute(financial_entity_is_article_16_1_entity, true)], indeterminate([authority_requested_framework_review_report]), []).
test(outstanding_lists_the_failing_duty) :-
    articles_36_to_40_true_except(review_and_testing_of_security_measures, Attributes),
    simplified_testing_continuity_and_report_duties_outstanding([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, false), attribute(ict_security_measures_reviewed_assessed_and_tested, false)|Attributes], outstanding([review_and_testing_of_security_measures]), [cite(eu_reg_2024_1774_art_36_2)]).
test(outstanding_none_when_all_performed) :-
    articles_36_to_40_true(Attributes),
    simplified_testing_continuity_and_report_duties_outstanding([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, false)|Attributes], none_outstanding, _).
test(an_unknown_key_is_an_input_problem) :-
    simplified_testing_continuity_and_report_duties_complete([attribute(dora_entity_type, credit_institution)], input_problems([unknown_key(dora_entity_type)]), []).
test(each_query_answers_once) :-
    findall(Result - Citations, simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, true)], Result, Citations), Answers),
    length(Answers, 1).
test(the_checklist_has_a_row_per_duty) :-
    dora_rts_simplified_testing_continuity_and_report_checklist([attribute(financial_entity_is_article_16_1_entity, true)], Items),
    length(Items, 39).
test(the_status_projects_the_result_name) :-
    dora_rts_simplified_testing_continuity_and_report_status([attribute(financial_entity_is_article_16_1_entity, false)], not_article_16_1_entity).

test(an_unsure_duty_is_not_complete, fail) :-
    articles_36_to_40_true_except(ict_security_testing_plan, Attributes),
    simplified_testing_continuity_and_report_duties_complete([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, false), attribute(ict_security_testing_plan_established_and_implemented, unsure)|Attributes], complete, _).
