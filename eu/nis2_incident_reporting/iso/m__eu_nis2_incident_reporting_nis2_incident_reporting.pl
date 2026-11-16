% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [decide_nis2_incident_reporting/2, nis2_incident_reporting_status/2, nis2_incident_reporting_checklist/2, nis2_incident_reporting_decision_resolvable/1, nis2_incident_reporting_status_values/1, incident_significance/3, incident_reporting_steps/2, reporting_step_timeliness/4, significant/0, not_significant/0, on_time/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_citations, [implements/1]).

significant.

not_significant.

on_time.

nis2_incident_reporting_status_values([significant, not_significant]).

reporting_hour_limit(early_warning, standard, 24, cite(eu_dir_2022_2555_art_23_4_a)).
reporting_hour_limit(incident_notification, standard, 72, cite(eu_dir_2022_2555_art_23_4_b)).
reporting_hour_limit(incident_notification, trust_service_provider, 24, cite(eu_dir_2022_2555_art_23_4)).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, present(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

judgement_pairs(_, [], []).
judgement_pairs(Profile, [Key|Keys], Pairs) :-
    key_state(Profile, Key, State),
    judgement_pairs(Profile, Keys, LaterPairs),
    add_pair(State, Key, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(present(Value), Key, Pairs, [Key - Value|Pairs]).

incident_significance(Profile, input_problems([Problem|Problems]), []) :-
    nis2_incident_reporting_input_problems(Profile, [Problem|Problems]).
incident_significance(Profile, Status, Citations) :-
    nis2_incident_reporting_input_problems(Profile, []),
    significance_of(Profile, Status, Citations).

significance_of(Profile, Status, Citations) :-
    key_state(Profile, severe_operational_disruption_or_financial_loss, OperationalState),
    key_state(Profile, considerable_damage_to_other_persons, DamageState),
    judgement_pairs(Profile, [severe_operational_disruption_or_financial_loss, considerable_damage_to_other_persons], Pairs),
    significance_decision(OperationalState, DamageState, Pairs, Status, Citations).

significance_decision(present(true), _, _, significant, [cite(eu_dir_2022_2555_art_23_3_a)]) :-
    implements(eu_dir_2022_2555_art_23_3_a).
significance_decision(absent, present(true), _, significant, [cite(eu_dir_2022_2555_art_23_3_b)]) :-
    implements(eu_dir_2022_2555_art_23_3_b).
significance_decision(present(false), present(true), _, significant, [cite(eu_dir_2022_2555_art_23_3_b)]) :-
    implements(eu_dir_2022_2555_art_23_3_b).
significance_decision(present(unsure), present(true), _, significant, [cite(eu_dir_2022_2555_art_23_3_b)]) :-
    implements(eu_dir_2022_2555_art_23_3_b).
significance_decision(absent, absent, _, indeterminate([severe_operational_disruption_or_financial_loss, considerable_damage_to_other_persons]), []) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_decision(absent, present(false), _, indeterminate([severe_operational_disruption_or_financial_loss]), []) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_decision(absent, present(unsure), _, indeterminate([severe_operational_disruption_or_financial_loss]), []) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_decision(present(false), absent, _, indeterminate([considerable_damage_to_other_persons]), []) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_decision(present(unsure), absent, _, indeterminate([considerable_damage_to_other_persons]), []) :-
    implements(eu_dir_2022_2555_art_23_3).
significance_decision(present(unsure), present(false), Pairs, needs_legal_review(open_textured(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_23_3_a).
significance_decision(present(unsure), present(unsure), Pairs, needs_legal_review(open_textured(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_23_3_a).
significance_decision(present(false), present(unsure), Pairs, needs_legal_review(open_textured(considerable_damage_to_other_persons, cite(eu_dir_2022_2555_art_23_3_b)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_dir_2022_2555_art_23_3_b).
significance_decision(present(false), present(false), _, not_significant, [cite(eu_dir_2022_2555_art_23_3_a), cite(eu_dir_2022_2555_art_23_3_b)]) :-
    implements(eu_dir_2022_2555_art_23_3).

incident_reporting_steps(Profile, input_problems([Problem|Problems])) :-
    nis2_incident_reporting_input_problems(Profile, [Problem|Problems]).
incident_reporting_steps(Profile, Steps) :-
    nis2_incident_reporting_input_problems(Profile, []),
    significance_of(Profile, Status, _),
    steps_for(Status, Profile, Steps).

steps_for(significant, Profile, Steps) :-
    key_state(Profile, trust_service_provider_incident_affects_trust_services, ProviderState),
    key_state(Profile, incident_ongoing_at_final_report_due, OngoingState),
    steps_with(ProviderState, OngoingState, Steps).
steps_for(not_significant, _, []).
steps_for(indeterminate(MissingKeys), _, indeterminate(MissingKeys)).
steps_for(needs_legal_review(Reason, Context), _, needs_legal_review(Reason, Context)).

steps_with(absent, absent, indeterminate([trust_service_provider_incident_affects_trust_services, incident_ongoing_at_final_report_due])) :-
    implements(eu_dir_2022_2555_art_23_4).
steps_with(absent, present(_), indeterminate([trust_service_provider_incident_affects_trust_services])) :-
    implements(eu_dir_2022_2555_art_23_4).
steps_with(present(_), absent, indeterminate([incident_ongoing_at_final_report_due])) :-
    implements(eu_dir_2022_2555_art_23_4).
steps_with(present(Provider), present(Ongoing), [EarlyWarning, Notification|Rest]) :-
    implements(eu_dir_2022_2555_art_23_4),
    hour_step(early_warning, standard, EarlyWarning),
    notification_step(Provider, Notification),
    later_steps(Ongoing, Rest).

notification_step(true, Step) :-
    implements(eu_dir_2022_2555_art_23_4),
    hour_step(incident_notification, trust_service_provider, Step).
notification_step(false, Step) :-
    implements(eu_dir_2022_2555_art_23_4_b),
    hour_step(incident_notification, standard, Step).

hour_step(Step, Mode, step_due(Step, hours_after_awareness(Hours), Citation)) :-
    reporting_hour_limit(Step, Mode, Hours, Citation).

later_steps(false, [step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d))]) :-
    implements(eu_dir_2022_2555_art_23_4_d).
later_steps(true, [step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d)), step_due(progress_report, at_final_report_due, cite(eu_dir_2022_2555_art_23_4_e)), step_due(final_report_after_handling, months_after_handling(1), cite(eu_dir_2022_2555_art_23_4_e))]) :-
    implements(eu_dir_2022_2555_art_23_4_e).

reporting_step_timeliness(Profile, Step, HoursElapsed, input_problems([Problem|Problems])) :-
    timeliness_problems(Profile, Step, HoursElapsed, [Problem|Problems]).
reporting_step_timeliness(Profile, Step, HoursElapsed, Result) :-
    timeliness_problems(Profile, Step, HoursElapsed, []),
    timeliness_result(Profile, Step, HoursElapsed, Result).

timeliness_problems(Profile, Step, HoursElapsed, Problems) :-
    nis2_incident_reporting_input_problems(Profile, ProfileProblems),
    step_problems(Step, StepProblems),
    hours_problems(HoursElapsed, HoursProblems),
    append(ProfileProblems, StepProblems, FirstProblems),
    append(FirstProblems, HoursProblems, Problems).

step_problems(Step, [wrong_type(step)]) :-
    var(Step).
step_problems(Step, Problems) :-
    nonvar(Step),
    memberd_t(Step, [early_warning, incident_notification], InType),
    step_problem_list(InType, Problems).

step_problem_list(true, []).
step_problem_list(false, [wrong_type(step)]).

hours_problems(HoursElapsed, Problems) :-
    hours_in_type_t(HoursElapsed, InType),
    hours_problem_list(InType, Problems).

hours_problem_list(true, []).
hours_problem_list(false, [wrong_type(hours_elapsed)]).

hours_in_type_t(Hours, false) :-
    var(Hours).
hours_in_type_t(Hours, Truth) :-
    nonvar(Hours),
    integer(Hours),
    nonnegative_truth(Hours, Truth).
hours_in_type_t(Hours, false) :-
    nonvar(Hours),
    float(Hours).
hours_in_type_t(Hours, false) :-
    nonvar(Hours),
    Hours \== [],
    atom(Hours).
hours_in_type_t(Hours, false) :-
    nonvar(Hours),
    Hours == [].
hours_in_type_t(Hours, false) :-
    nonvar(Hours),
    compound(Hours).

nonnegative_truth(Hours, true) :-
    Hours #>= 0.
nonnegative_truth(Hours, false) :-
    Hours #< 0.

timeliness_result(_, early_warning, HoursElapsed, late(hour_limit)) :-
    implements(eu_dir_2022_2555_art_23_4_a),
    reporting_hour_limit(early_warning, standard, Limit, _),
    HoursElapsed #> Limit.
timeliness_result(Profile, early_warning, HoursElapsed, Result) :-
    implements(eu_dir_2022_2555_art_23_4_a),
    reporting_hour_limit(early_warning, standard, Limit, _),
    HoursElapsed #=< Limit,
    key_state(Profile, early_warning_without_undue_delay, State),
    undue_delay_result(State, early_warning_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_a), Result).
timeliness_result(_, incident_notification, HoursElapsed, late(hour_limit)) :-
    implements(eu_dir_2022_2555_art_23_4_b),
    reporting_hour_limit(incident_notification, standard, StandardLimit, _),
    HoursElapsed #> StandardLimit.
timeliness_result(Profile, incident_notification, HoursElapsed, Result) :-
    implements(eu_dir_2022_2555_art_23_4),
    reporting_hour_limit(incident_notification, standard, StandardLimit, _),
    reporting_hour_limit(incident_notification, trust_service_provider, ProviderLimit, _),
    HoursElapsed #=< StandardLimit,
    HoursElapsed #> ProviderLimit,
    key_state(Profile, trust_service_provider_incident_affects_trust_services, ProviderState),
    notification_between(ProviderState, Profile, Result).
timeliness_result(Profile, incident_notification, HoursElapsed, Result) :-
    implements(eu_dir_2022_2555_art_23_4_b),
    reporting_hour_limit(incident_notification, trust_service_provider, ProviderLimit, _),
    HoursElapsed #=< ProviderLimit,
    notification_delay(Profile, Result).

notification_between(absent, _, indeterminate([trust_service_provider_incident_affects_trust_services])) :-
    implements(eu_dir_2022_2555_art_23_4).
notification_between(present(true), _, late(hour_limit)) :-
    implements(eu_dir_2022_2555_art_23_4).
notification_between(present(false), Profile, Result) :-
    implements(eu_dir_2022_2555_art_23_4_b),
    notification_delay(Profile, Result).

notification_delay(Profile, Result) :-
    key_state(Profile, incident_notification_without_undue_delay, State),
    undue_delay_result(State, incident_notification_without_undue_delay, cite(eu_dir_2022_2555_art_23_4_b), Result).

undue_delay_result(absent, Key, _, indeterminate([Key])).
undue_delay_result(present(true), _, _, on_time).
undue_delay_result(present(false), _, _, late(without_undue_delay)).
undue_delay_result(present(unsure), Key, Citation, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on([Key - unsure])])).

decide_nis2_incident_reporting(Profile, nis2_incident_reporting_verdict(Status, Citations)) :-
    incident_significance(Profile, Status, Citations).

nis2_incident_reporting_status(Profile, Status) :-
    decide_nis2_incident_reporting(Profile, nis2_incident_reporting_verdict(Status, _Citations)).

nis2_incident_reporting_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_dir_2022_2555_art_23_1))]) :-
    nis2_incident_reporting_input_problems(Profile, [Problem|Problems]).
nis2_incident_reporting_checklist(Profile, [OperationalItem, DamageItem]) :-
    nis2_incident_reporting_input_problems(Profile, []),
    key_state(Profile, severe_operational_disruption_or_financial_loss, OperationalState),
    key_state(Profile, considerable_damage_to_other_persons, DamageState),
    limb_item(significance_operational_or_financial, severe_operational_disruption_or_financial_loss, OperationalState, cite(eu_dir_2022_2555_art_23_3_a), OperationalItem),
    limb_item(significance_damage_to_others, considerable_damage_to_other_persons, DamageState, cite(eu_dir_2022_2555_art_23_3_b), DamageItem).

limb_item(Id, _, present(true), Citation, item(Id, met, Citation)).
limb_item(Id, _, present(false), Citation, item(Id, unmet(limb_not_met), Citation)).
limb_item(Id, Key, present(unsure), Citation, item(Id, unknown([Key]), Citation)).
limb_item(Id, Key, absent, Citation, item(Id, unknown([Key]), Citation)).

nis2_incident_reporting_decision_resolvable(Profile) :-
    decide_nis2_incident_reporting(Profile, _Verdict).

test(limb_a_true_is_significant) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, true)], significant, [cite(eu_dir_2022_2555_art_23_3_a)]).
test(limb_b_true_is_significant_with_b_citation) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, true)], significant, [cite(eu_dir_2022_2555_art_23_3_b)]).
test(both_false_is_not_significant) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], not_significant, [cite(eu_dir_2022_2555_art_23_3_a), cite(eu_dir_2022_2555_art_23_3_b)]).
test(absent_limbs_are_named) :-
    incident_significance([], indeterminate([severe_operational_disruption_or_financial_loss, considerable_damage_to_other_persons]), []).
test(unsure_first_limb_refers) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, unsure), attribute(considerable_damage_to_other_persons, false)], needs_legal_review(open_textured(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - unsure, considerable_damage_to_other_persons - false])]), []).
test(one_solution_only) :-
    findall(Status, incident_significance([attribute(severe_operational_disruption_or_financial_loss, true), attribute(considerable_damage_to_other_persons, true)], Status, _), Statuses),
    Statuses == [significant].
test(unknown_key_is_an_input_problem) :-
    incident_significance([attribute(bogus, true)], input_problems([unknown_key(bogus)]), []).
test(steps_for_provider_ongoing) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, true), attribute(trust_service_provider_incident_affects_trust_services, true), attribute(incident_ongoing_at_final_report_due, true)], [step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)), step_due(incident_notification, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4)), step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d)), step_due(progress_report, at_final_report_due, cite(eu_dir_2022_2555_art_23_4_e)), step_due(final_report_after_handling, months_after_handling(1), cite(eu_dir_2022_2555_art_23_4_e))]).
test(steps_empty_when_not_significant) :-
    incident_reporting_steps([attribute(severe_operational_disruption_or_financial_loss, false), attribute(considerable_damage_to_other_persons, false)], []).
test(early_warning_24_is_on_time) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], early_warning, 24, on_time).
test(early_warning_25_is_late) :-
    reporting_step_timeliness([], early_warning, 25, late(hour_limit)).
test(notification_73_is_late) :-
    reporting_step_timeliness([], incident_notification, 73, late(hour_limit)).
test(notification_72_standard_on_time) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, false), attribute(incident_notification_without_undue_delay, true)], incident_notification, 72, on_time).
test(notification_30_provider_is_late) :-
    reporting_step_timeliness([attribute(trust_service_provider_incident_affects_trust_services, true)], incident_notification, 30, late(hour_limit)).
test(notification_30_needs_provider_key) :-
    reporting_step_timeliness([], incident_notification, 30, indeterminate([trust_service_provider_incident_affects_trust_services])).
test(bad_step_and_hours) :-
    reporting_step_timeliness([], final_report, -1, input_problems([wrong_type(step), wrong_type(hours_elapsed)])).
test(unbound_step_is_one_input_problem) :-
    findall(Result, reporting_step_timeliness([], _Step, 5, Result), Results),
    Results == [input_problems([wrong_type(step)])].
test(undue_delay_false_is_late) :-
    reporting_step_timeliness([attribute(early_warning_without_undue_delay, false)], early_warning, 5, late(without_undue_delay)).
