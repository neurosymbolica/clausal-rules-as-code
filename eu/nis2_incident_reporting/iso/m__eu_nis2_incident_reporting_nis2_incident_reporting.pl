% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [incident_significance/3, incident_reporting_steps/2, reporting_step_timeliness/4, decide_nis2_incident_reporting/2, nis2_incident_reporting_status/2, nis2_incident_reporting_checklist/2, nis2_incident_reporting_decision_resolvable/1, nis2_incident_reporting_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_citations, [implements/1]).

early_warning_limit(24, cite(eu_dir_2022_2555_art_23_4_a)).

incident_notification_limit(false, 72, cite(eu_dir_2022_2555_art_23_4_b)).
incident_notification_limit(true, 24, cite(eu_dir_2022_2555_art_23_4)).

intermediate_report_limit(on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)).

final_report_limit(months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d)).

ongoing_incident_steps(true, [step_due(progress_report, at_final_report_due, cite(eu_dir_2022_2555_art_23_4_e)), step_due(final_report_after_handling, months_after_handling(1), cite(eu_dir_2022_2555_art_23_4_e))]).
ongoing_incident_steps(false, []).

significance_limb(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)).
significance_limb(considerable_damage_to_other_persons, cite(eu_dir_2022_2555_art_23_3_b)).

nis2_incident_reporting_status_values([significant, not_significant, indeterminate(_), needs_legal_review(_, _), input_problems(_)]).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, present(Value)) :-
    profile_get(Profile, Key, Value).

present_pairs(_, [], []).
present_pairs(Profile, [Key|Keys], Pairs) :-
    key_state(Profile, Key, State),
    present_pairs(Profile, Keys, LaterPairs),
    add_pair(State, Key, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(present(Value), Key, Pairs, [Key - Value|Pairs]).

significance_pairs(Profile, Pairs) :-
    present_pairs(Profile, [severe_operational_disruption_or_financial_loss, considerable_damage_to_other_persons], Pairs).

significance_class(present(true), _, limb(severe_operational_disruption_or_financial_loss)) :-
    implements(eu_dir_2022_2555_art_23_3_a).
significance_class(absent, present(true), limb(considerable_damage_to_other_persons)) :-
    implements(eu_dir_2022_2555_art_23_3_b).
significance_class(present(false), present(true), limb(considerable_damage_to_other_persons)) :-
    implements(eu_dir_2022_2555_art_23_3_b).
significance_class(present(unsure), present(true), limb(considerable_damage_to_other_persons)) :-
    implements(eu_dir_2022_2555_art_23_3_b).
significance_class(absent, absent, missing(severe_operational_disruption_or_financial_loss)) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_class(absent, present(false), missing(severe_operational_disruption_or_financial_loss)) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_class(absent, present(unsure), missing(severe_operational_disruption_or_financial_loss)) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_class(present(false), absent, missing(considerable_damage_to_other_persons)) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_class(present(unsure), absent, missing(considerable_damage_to_other_persons)) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_class(present(unsure), present(false), unsure(severe_operational_disruption_or_financial_loss)) :-
    implements(eu_dir_2022_2555_art_23_3_a).
significance_class(present(unsure), present(unsure), unsure(severe_operational_disruption_or_financial_loss)) :-
    implements(eu_dir_2022_2555_art_23_3_a).
significance_class(present(false), present(unsure), unsure(considerable_damage_to_other_persons)) :-
    implements(eu_dir_2022_2555_art_23_3_b).
significance_class(present(false), present(false), neither_limb) :-
    implements(eu_dir_2022_2555_art_23_3).

incident_class(Profile, Class) :-
    key_state(Profile, severe_operational_disruption_or_financial_loss, SevereState),
    key_state(Profile, considerable_damage_to_other_persons, DamageState),
    significance_class(SevereState, DamageState, Class).

incident_significance(Profile, input_problems([Problem|Problems]), []) :-
    nis2_incident_reporting_input_problems(Profile, [Problem|Problems]).
incident_significance(Profile, Status, Citations) :-
    nis2_incident_reporting_input_problems(Profile, []),
    incident_class(Profile, Class),
    significance_answer(Class, Profile, Status, Citations).

significance_answer(limb(Key), _, significant, [Citation]) :-
    implements(eu_dir_2022_2555_art_23_3),
    significance_limb(Key, Citation).
significance_answer(missing(Key), _, indeterminate([Key]), []).
significance_answer(unsure(Key), Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_23_3),
    significance_limb(Key, Citation),
    significance_pairs(Profile, Pairs).
significance_answer(neither_limb, _, not_significant, [cite(eu_dir_2022_2555_art_23_3_a), cite(eu_dir_2022_2555_art_23_3_b)]) :-
    implements(eu_dir_2022_2555_art_23_3).

incident_reporting_steps(Profile, input_problems([Problem|Problems])) :-
    nis2_incident_reporting_input_problems(Profile, [Problem|Problems]).
incident_reporting_steps(Profile, Steps) :-
    nis2_incident_reporting_input_problems(Profile, []),
    incident_class(Profile, Class),
    steps_answer(Class, Profile, Steps).

steps_answer(limb(_), Profile, Steps) :-
    implements(eu_dir_2022_2555_art_23_4),
    follow_up_gate(Profile, Gate),
    significant_steps(Gate, Steps).
steps_answer(missing(Key), _, indeterminate([Key])).
steps_answer(neither_limb, _, []) :-
    implements(eu_dir_2022_2555_art_23_3).
steps_answer(unsure(Key), Profile, Steps) :-
    implements(eu_dir_2022_2555_art_23_3),
    follow_up_gate(Profile, Gate),
    referral_steps(Gate, Key, Profile, Steps).

follow_up_gate(Profile, Gate) :-
    key_state(Profile, trust_service_provider_incident_affects_trust_services, TrustState),
    key_state(Profile, incident_ongoing_at_final_report_due, OngoingState),
    gate_from_states(TrustState, OngoingState, Gate).

gate_from_states(absent, _, missing(trust_service_provider_incident_affects_trust_services)).
gate_from_states(present(_), absent, missing(incident_ongoing_at_final_report_due)).
gate_from_states(present(Trust), present(Ongoing), present(Trust, Ongoing)).

significant_steps(missing(Key), indeterminate([Key])).
significant_steps(present(Trust, Ongoing), Steps) :-
    reporting_steps(Trust, Ongoing, Steps).

referral_steps(missing(Missing), _, _, indeterminate([Missing])).
referral_steps(present(_, _), Key, Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    implements(eu_dir_2022_2555_art_23_3),
    significance_limb(Key, Citation),
    significance_pairs(Profile, Pairs).

reporting_steps(Trust, Ongoing, [step_due(early_warning, hours_after_awareness(EarlyHours), EarlyCitation), step_due(incident_notification, hours_after_awareness(NotificationHours), NotificationCitation), step_due(intermediate_report, IntermediateLimit, IntermediateCitation), step_due(final_report, FinalLimit, FinalCitation)|OngoingSteps]) :-
    implements(eu_dir_2022_2555_art_23_4),
    early_warning_limit(EarlyHours, EarlyCitation),
    incident_notification_limit(Trust, NotificationHours, NotificationCitation),
    intermediate_report_limit(IntermediateLimit, IntermediateCitation),
    final_report_limit(FinalLimit, FinalCitation),
    ongoing_steps(Ongoing, OngoingSteps).

ongoing_steps(Ongoing, Steps) :-
    implements(eu_dir_2022_2555_art_23_4_e),
    ongoing_incident_steps(Ongoing, Steps).

reporting_step_timeliness(Profile, Step, Hours, input_problems([Problem|Problems])) :-
    timeliness_problems(Profile, Step, Hours, [Problem|Problems]).
reporting_step_timeliness(Profile, Step, Hours, Result) :-
    timeliness_problems(Profile, Step, Hours, []),
    step_timeliness(Step, Hours, Profile, Result).

timeliness_problems(Profile, Step, Hours, Problems) :-
    nis2_incident_reporting_input_problems(Profile, ProfileProblems),
    step_problems(Step, StepProblems),
    hours_problems(Hours, HourProblems),
    append(ProfileProblems, StepProblems, FrontProblems),
    append(FrontProblems, HourProblems, Problems).

step_problems(Step, [wrong_type(step)]) :-
    var(Step).
step_problems(Step, Problems) :-
    nonvar(Step),
    memberd_t(Step, [early_warning, incident_notification], Known),
    step_problem(Known, Problems).

step_problem(true, []).
step_problem(false, [wrong_type(step)]).

hours_problems(Hours, [wrong_type(hours_elapsed)]) :-
    var(Hours).
hours_problems(Hours, Problems) :-
    nonvar(Hours),
    integer_truth(Hours, IsInteger),
    integer_problems(IsInteger, Hours, Problems).

integer_truth(Hours, Truth) :-
    catch(integer_check(Hours, Truth), error(type_error(_, _), _), Truth = false).

integer_check(Hours, true) :-
    must_be(integer, Hours).

integer_problems(false, _, [wrong_type(hours_elapsed)]).
integer_problems(true, Hours, []) :-
    Hours #>= 0.
integer_problems(true, Hours, [wrong_type(hours_elapsed)]) :-
    Hours #< 0.

step_timeliness(early_warning, Hours, _, late(hour_limit)) :-
    implements(eu_dir_2022_2555_art_23_4_a),
    early_warning_limit(LimitHours, _),
    Hours #> LimitHours.
step_timeliness(early_warning, Hours, Profile, Result) :-
    implements(eu_dir_2022_2555_art_23_4_a),
    early_warning_limit(LimitHours, Citation),
    Hours #=< LimitHours,
    undue_delay_check(Profile, early_warning_without_undue_delay, Citation, Result).
step_timeliness(incident_notification, Hours, _, late(hour_limit)) :-
    implements(eu_dir_2022_2555_art_23_4_b),
    incident_notification_limit(false, StandardHours, _),
    Hours #> StandardHours.
step_timeliness(incident_notification, Hours, Profile, Result) :-
    implements(eu_dir_2022_2555_art_23_4),
    incident_notification_limit(false, StandardHours, StandardCitation),
    incident_notification_limit(true, TrustHours, _),
    Hours #> TrustHours,
    Hours #=< StandardHours,
    key_state(Profile, trust_service_provider_incident_affects_trust_services, TrustState),
    trust_service_window(TrustState, StandardCitation, Profile, Result).
step_timeliness(incident_notification, Hours, Profile, Result) :-
    implements(eu_dir_2022_2555_art_23_4_b),
    incident_notification_limit(true, TrustHours, _),
    Hours #=< TrustHours,
    incident_notification_limit(false, _, StandardCitation),
    undue_delay_check(Profile, incident_notification_without_undue_delay, StandardCitation, Result).

trust_service_window(absent, _, _, indeterminate([trust_service_provider_incident_affects_trust_services])).
trust_service_window(present(true), _, _, late(hour_limit)) :-
    implements(eu_dir_2022_2555_art_23_4).
trust_service_window(present(false), Citation, Profile, Result) :-
    implements(eu_dir_2022_2555_art_23_4_b),
    undue_delay_check(Profile, incident_notification_without_undue_delay, Citation, Result).

undue_delay_check(Profile, Key, Citation, Result) :-
    key_state(Profile, Key, State),
    undue_delay_result(State, Key, Citation, Result).

undue_delay_marker(early_warning_without_undue_delay) :-
    implements(eu_dir_2022_2555_art_23_4_a).
undue_delay_marker(incident_notification_without_undue_delay) :-
    implements(eu_dir_2022_2555_art_23_4_b).

undue_delay_result(absent, Key, _, indeterminate([Key])).
undue_delay_result(present(true), Key, _Citation, on_time) :-
    undue_delay_marker(Key).
undue_delay_result(present(false), Key, _Citation, late(without_undue_delay)) :-
    undue_delay_marker(Key).
undue_delay_result(present(unsure), Key, Citation, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on([Key - unsure])])) :-
    undue_delay_marker(Key).

decide_nis2_incident_reporting(Profile, nis2_incident_reporting_verdict(Status, Citations)) :-
    incident_significance(Profile, Status, Citations).

nis2_incident_reporting_status(Profile, Status) :-
    decide_nis2_incident_reporting(Profile, nis2_incident_reporting_verdict(Status, _Citations)).

nis2_incident_reporting_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_dir_2022_2555_art_23_1))]) :-
    nis2_incident_reporting_input_problems(Profile, [Problem|Problems]).
nis2_incident_reporting_checklist(Profile, [SevereItem, DamageItem]) :-
    nis2_incident_reporting_input_problems(Profile, []),
    limb_item(Profile, severe_operational_disruption_or_financial_loss, SevereItem),
    limb_item(Profile, considerable_damage_to_other_persons, DamageItem).

limb_item(Profile, Key, item(Key, Status, Citation)) :-
    implements(eu_dir_2022_2555_art_23_3),
    significance_limb(Key, Citation),
    key_state(Profile, Key, State),
    limb_status(State, Key, Status).

limb_status(absent, Key, unknown([Key])).
limb_status(present(true), _, met).
limb_status(present(false), _, unmet(limb_not_met)).
limb_status(present(unsure), Key, unknown([Key])).

nis2_incident_reporting_decision_resolvable(Profile) :-
    decide_nis2_incident_reporting(Profile, _Verdict).

test(limb_a_true_is_significant_citing_a) :-
    findall(Status - Citations, incident_significance([attribute(severe_operational_disruption_or_financial_loss, true)], Status, Citations), Answers),
    Answers == [significant - [cite(eu_dir_2022_2555_art_23_3_a)]].
test(limb_b_true_beside_unsure_a_cites_b) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, unsure), attribute(considerable_damage_to_other_persons, true)], significant, [cite(eu_dir_2022_2555_art_23_3_b)]).
test(absent_a_is_named) :-
    incident_significance([attribute(considerable_damage_to_other_persons, false)], indeterminate([severe_operational_disruption_or_financial_loss]), []).
test(absent_b_is_named_before_unsure_a) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, unsure)], indeterminate([considerable_damage_to_other_persons]), []).
test(unsure_a_refers) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, unsure), attribute(considerable_damage_to_other_persons, false)], needs_legal_review(open_textured(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - unsure, considerable_damage_to_other_persons - false])]), []).
test(both_false_not_significant) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], not_significant, [cite(eu_dir_2022_2555_art_23_3_a), cite(eu_dir_2022_2555_art_23_3_b)]).
test(wrong_value_is_input_problem) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, maybe)], input_problems([wrong_type(severe_operational_disruption_or_financial_loss)]), []).
test(steps_for_trust_service_provider) :-
    findall(Steps, incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, true), attribute(trust_service_provider_incident_affects_trust_services, true), attribute(incident_ongoing_at_final_report_due, false)], Steps), Answers),
    Answers == [[step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)), step_due(incident_notification, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4)), step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d))]].
test(steps_for_ongoing_incident_add_two) :-
    incident_reporting_steps([attribute(considerable_damage_to_other_persons, true), attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_ongoing_at_final_report_due, true)], Steps),
    length(Steps, 6),
    Steps = [_, step_due(incident_notification, hours_after_awareness(72), cite(eu_dir_2022_2555_art_23_4_b))|_].
test(steps_not_significant_empty) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], []).
test(steps_unsure_names_trust_first) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, unsure), attribute(considerable_damage_to_other_persons, false)], indeterminate([trust_service_provider_incident_affects_trust_services])).
test(steps_unsure_refers_when_complete) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, unsure), attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_ongoing_at_final_report_due, false)], needs_legal_review(open_textured(considerable_damage_to_other_persons, cite(eu_dir_2022_2555_art_23_3_b)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - false, considerable_damage_to_other_persons - unsure])])).
test(early_warning_at_25_hours_late) :-
    findall(Result, reporting_step_timeliness([], early_warning, 25, Result), Results),
    Results == [late(hour_limit)].
test(early_warning_at_24_hours_on_time) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 24, on_time).
test(notification_at_30_hours_needs_trust_key) :-
    reporting_step_timeliness([], incident_notification, 30, indeterminate([trust_service_provider_incident_affects_trust_services])).
test(notification_at_30_hours_trust_provider_late) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, true)], incident_notification, 30, late(hour_limit)).
test(notification_at_72_hours_on_time) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 72, on_time).
test(notification_at_73_hours_late) :-
    reporting_step_timeliness([], incident_notification, 73, late(hour_limit)).
test(notification_unsure_delay_refers) :-
    reporting_step_timeliness([attribute(incident_notification_without_undue_delay, unsure)], incident_notification, 10, needs_legal_review(open_textured(incident_notification_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_b)), [inputs_relied_on([incident_notification_without_undue_delay - unsure])])).
test(bad_step_and_hours_are_input_problems) :-
    reporting_step_timeliness([], final_report, minus_one, input_problems([wrong_type(step), wrong_type(hours_elapsed)])).
test(negative_hours_are_input_problem) :-
    reporting_step_timeliness([], early_warning, -1, input_problems([wrong_type(hours_elapsed)])).
test(facade_verdict) :-
    decide_nis2_incident_reporting([attribute(severe_operational_disruption_or_financial_loss, true)], nis2_incident_reporting_verdict(significant, [cite(eu_dir_2022_2555_art_23_3_a)])).
test(checklist_rows) :-
    nis2_incident_reporting_checklist([attribute(severe_operational_disruption_or_financial_loss, true)], [item(severe_operational_disruption_or_financial_loss, met, cite(eu_dir_2022_2555_art_23_3_a)), item(considerable_damage_to_other_persons, unknown([considerable_damage_to_other_persons]), cite(eu_dir_2022_2555_art_23_3_b))]).

test(both_false_is_not_significant_status, fail) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], significant, _).
test(early_warning_at_24_hours_not_late, fail) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 24, late(_)).
