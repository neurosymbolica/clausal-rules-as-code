% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification_nis2_information_sharing_voluntary_notification, [voluntary_notification_possible/3, information_exchange_permitted/3, arrangement_notification_duty/3, decide_nis2_information_sharing_voluntary_notification/2, nis2_information_sharing_voluntary_notification_status/2, nis2_information_sharing_voluntary_notification_checklist/2, nis2_information_sharing_voluntary_notification_decision_resolvable/1, nis2_information_sharing_voluntary_notification_status_values/1, essential_entity/0, important_entity/0, out_of_scope/0, incident/0, significant_incident/0, cyber_threat/0, near_miss/0, entered/0, withdrew/0, no_arrangement_event/0, voluntary_notification_possible/0, voluntary_notification_not_possible/0, information_exchange_permitted/0, information_exchange_not_permitted/0, must_notify_on_entering/0, must_notify_on_withdrawal_taking_effect/0, no_notification_duty/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_kernel, [nis2_information_sharing_voluntary_notification_input_problems/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_citations, [implements/1]).

essential_entity.

important_entity.

out_of_scope.

incident.

significant_incident.

cyber_threat.

near_miss.

entered.

withdrew.

no_arrangement_event.

voluntary_notification_possible.

voluntary_notification_not_possible.

information_exchange_permitted.

information_exchange_not_permitted.

must_notify_on_entering.

must_notify_on_withdrawal_taking_effect.

no_notification_duty.

nis2_information_sharing_voluntary_notification_status_values([eligible, ineligible, eligibility_undetermined]).

entity_class_group(essential_entity, point_a_entity, cite(eu_dir_2022_2555_art_30_1_a)).
entity_class_group(important_entity, point_a_entity, cite(eu_dir_2022_2555_art_30_1_a)).
entity_class_group(out_of_scope, point_b_entity, cite(eu_dir_2022_2555_art_30_1_b)).

event_kind_reach(incident, point_a_entities_only, cite(eu_dir_2022_2555_art_30_1_a)).
event_kind_reach(significant_incident, every_entity, cite(eu_dir_2022_2555_art_30_1_b)).
event_kind_reach(cyber_threat, every_entity, cite(eu_dir_2022_2555_art_30_1_b)).
event_kind_reach(near_miss, every_entity, cite(eu_dir_2022_2555_art_30_1_b)).

arrangement_event_duty(entered, must_notify_on_entering, cite(eu_dir_2022_2555_art_29_4)).
arrangement_event_duty(withdrew, must_notify_on_withdrawal_taking_effect, cite(eu_dir_2022_2555_art_29_4)).

referral(exchange_information_relevant, open_textured, information_is_relevant_cybersecurity_information, cite(eu_dir_2022_2555_art_29_1), [information_is_relevant_cybersecurity_information, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity], information_exchange_permitted/3).
referral(exchange_aims_to_prevent_or_respond, open_textured, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, cite(eu_dir_2022_2555_art_29_1_a), [information_is_relevant_cybersecurity_information, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity], information_exchange_permitted/3).
referral(exchange_enhances_cybersecurity, open_textured, sharing_enhances_the_level_of_cybersecurity, cite(eu_dir_2022_2555_art_29_1_b), [information_is_relevant_cybersecurity_information, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity], information_exchange_permitted/3).
referral(arrangement_is_an_art_29_2_arrangement, open_textured, arrangement_is_a_cybersecurity_information_sharing_arrangement, cite(eu_dir_2022_2555_art_29_2), [arrangement_is_a_cybersecurity_information_sharing_arrangement], arrangement_notification_duty/3).

key_state(Profile, InputKey, absent) :-
    profile_lacks(Profile, InputKey).
key_state(Profile, InputKey, present(KeyValue)) :-
    profile_get(Profile, InputKey, KeyValue).

state_is_t(absent, _, false).
state_is_t(present(KeyValue), Wanted, Truth) :-
    memberd_t(KeyValue, [Wanted], Truth).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

absent_keys([], []).
absent_keys([InputKey - absent|KeyStates], [InputKey|Missing]) :-
    absent_keys(KeyStates, Missing).
absent_keys([_ - present(_)|KeyStates], Missing) :-
    absent_keys(KeyStates, Missing).

present_pairs([], _, []).
present_pairs([InputKey|InputKeys], Profile, Pairs) :-
    key_state(Profile, InputKey, State),
    present_pairs(InputKeys, Profile, LaterPairs),
    add_pair(State, InputKey, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(present(KeyValue), InputKey, Pairs, [InputKey - KeyValue|Pairs]).

referral_answer(Situation, Profile, needs_legal_review(open_textured(InputKey, Citation), [inputs_relied_on(Pairs)])) :-
    referral(Situation, open_textured, InputKey, Citation, Inputs, _Query),
    present_pairs(Inputs, Profile, Pairs).

voluntary_notification_possible(Profile, Result, Citations) :-
    nis2_information_sharing_voluntary_notification_input_problems(Profile, Problems),
    voluntary_notification_answer(Problems, Profile, Result, Citations).

voluntary_notification_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
voluntary_notification_answer([], Profile, Result, Citations) :-
    key_state(Profile, entity_class, EntityState),
    key_state(Profile, event_kind, EventState),
    entity_group(EntityState, EntityGroup),
    event_reach(EventState, EventReach),
    voluntary_route(EntityGroup, EventReach, Result, Citations).

entity_group(absent, unknown_entity_group).
entity_group(present(EntityClass), EntityGroup) :-
    implements(eu_dir_2022_2555_art_30_1),
    entity_class_group(EntityClass, EntityGroup, _Citation).

event_reach(absent, unknown_event_reach).
event_reach(present(EventKind), EventReach) :-
    implements(eu_dir_2022_2555_art_30_1),
    event_kind_reach(EventKind, EventReach, _Citation).

voluntary_route(point_a_entity, _, voluntary_notification_possible, [cite(eu_dir_2022_2555_art_30_1_a)]) :-
    implements(eu_dir_2022_2555_art_30_1_a).
voluntary_route(point_b_entity, every_entity, voluntary_notification_possible, [cite(eu_dir_2022_2555_art_30_1_b)]) :-
    implements(eu_dir_2022_2555_art_30_1_b).
voluntary_route(unknown_entity_group, every_entity, voluntary_notification_possible, [cite(eu_dir_2022_2555_art_30_1_a), cite(eu_dir_2022_2555_art_30_1_b)]) :-
    implements(eu_dir_2022_2555_art_30_1_a),
    implements(eu_dir_2022_2555_art_30_1_b).
voluntary_route(point_b_entity, point_a_entities_only, voluntary_notification_not_possible, [cite(eu_dir_2022_2555_art_30_1_b)]) :-
    implements(eu_dir_2022_2555_art_30_1_b).
voluntary_route(point_b_entity, unknown_event_reach, indeterminate([event_kind]), []) :-
    implements(eu_dir_2022_2555_art_30_1_b).
voluntary_route(unknown_entity_group, point_a_entities_only, indeterminate([entity_class]), []) :-
    implements(eu_dir_2022_2555_art_30_1_a).
voluntary_route(unknown_entity_group, unknown_event_reach, indeterminate([entity_class, event_kind]), []) :-
    implements(eu_dir_2022_2555_art_30_1).

information_exchange_permitted(Profile, Result, Citations) :-
    nis2_information_sharing_voluntary_notification_input_problems(Profile, Problems),
    information_exchange_answer(Problems, Profile, Result, Citations).

information_exchange_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
information_exchange_answer([], Profile, Result, Citations) :-
    key_state(Profile, information_is_relevant_cybersecurity_information, RelevantState),
    key_state(Profile, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, AimsState),
    key_state(Profile, sharing_enhances_the_level_of_cybersecurity, EnhancesState),
    exchange_refused_t(RelevantState, AimsState, EnhancesState, Refused),
    exchange_refusal_step(Refused, Profile, RelevantState, AimsState, EnhancesState, Result, Citations).

exchange_refused_t(RelevantState, AimsState, EnhancesState, Refused) :-
    implements(eu_dir_2022_2555_art_29_1),
    state_is_t(RelevantState, false, RelevantFalse),
    state_is_t(AimsState, false, AimsFalse),
    state_is_t(EnhancesState, false, EnhancesFalse),
    truth_and(AimsFalse, EnhancesFalse, NeitherPoint),
    truth_or(RelevantFalse, NeitherPoint, Refused).

exchange_refusal_step(true, _, _, _, _, information_exchange_not_permitted, [cite(eu_dir_2022_2555_art_29_1)]) :-
    implements(eu_dir_2022_2555_art_29_1).
exchange_refusal_step(false, Profile, RelevantState, AimsState, EnhancesState, Result, Citations) :-
    exchange_granted_t(RelevantState, AimsState, EnhancesState, Granted),
    exchange_grant_step(Granted, Profile, RelevantState, AimsState, EnhancesState, Result, Citations).

exchange_granted_t(RelevantState, AimsState, EnhancesState, Granted) :-
    implements(eu_dir_2022_2555_art_29_1),
    state_is_t(RelevantState, true, RelevantTrue),
    state_is_t(AimsState, true, AimsTrue),
    state_is_t(EnhancesState, true, EnhancesTrue),
    truth_or(AimsTrue, EnhancesTrue, EitherPoint),
    truth_and(RelevantTrue, EitherPoint, Granted).

exchange_grant_step(true, _, _, _, _, information_exchange_permitted, [cite(eu_dir_2022_2555_art_29_1)]) :-
    implements(eu_dir_2022_2555_art_29_1).
exchange_grant_step(false, Profile, RelevantState, AimsState, EnhancesState, Result, Citations) :-
    relevant_needed(RelevantState, RelevantNeeded),
    point_needed(AimsState, EnhancesState, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, AimsNeeded),
    point_needed(EnhancesState, AimsState, sharing_enhances_the_level_of_cybersecurity, EnhancesNeeded),
    append([RelevantNeeded, AimsNeeded, EnhancesNeeded], Needed),
    exchange_needed_step(Needed, Profile, RelevantState, AimsState, Result, Citations).

relevant_needed(absent, [information_is_relevant_cybersecurity_information]) :-
    implements(eu_dir_2022_2555_art_29_1).
relevant_needed(present(_), []).

point_needed(absent, OtherState, InputKey, Needed) :-
    implements(eu_dir_2022_2555_art_29_1),
    state_is_t(OtherState, true, OtherTrue),
    point_needed_when(OtherTrue, InputKey, Needed).
point_needed(present(_), _, _, []).

point_needed_when(true, _, []).
point_needed_when(false, InputKey, [InputKey]).

exchange_needed_step([FirstMissing|OtherMissing], _, _, _, indeterminate([FirstMissing|OtherMissing]), []).
exchange_needed_step([], Profile, RelevantState, AimsState, Result, []) :-
    exchange_review_situation(RelevantState, AimsState, Situation),
    referral_answer(Situation, Profile, Result).

exchange_review_situation(present(unsure), _, exchange_information_relevant) :-
    implements(eu_dir_2022_2555_art_29_1).
exchange_review_situation(present(true), present(unsure), exchange_aims_to_prevent_or_respond) :-
    implements(eu_dir_2022_2555_art_29_1_a).
exchange_review_situation(present(true), present(false), exchange_enhances_cybersecurity) :-
    implements(eu_dir_2022_2555_art_29_1_b).

arrangement_notification_duty(Profile, Result, Citations) :-
    nis2_information_sharing_voluntary_notification_input_problems(Profile, Problems),
    arrangement_notification_answer(Problems, Profile, Result, Citations).

arrangement_notification_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
arrangement_notification_answer([], Profile, Result, Citations) :-
    key_state(Profile, entity_class, EntityState),
    key_state(Profile, arrangement_event, EventState),
    key_state(Profile, arrangement_is_a_cybersecurity_information_sharing_arrangement, ArrangementState),
    no_duty_t(EntityState, EventState, ArrangementState, NoDuty),
    arrangement_no_duty_step(NoDuty, Profile, EntityState, EventState, ArrangementState, Result, Citations).

no_duty_t(EntityState, EventState, ArrangementState, NoDuty) :-
    implements(eu_dir_2022_2555_art_29_4),
    state_is_t(EntityState, out_of_scope, OtherEntity),
    state_is_t(EventState, no_arrangement_event, NoEvent),
    state_is_t(ArrangementState, false, NotAnArrangement),
    truth_or(NoEvent, NotAnArrangement, EventOrArrangement),
    truth_or(OtherEntity, EventOrArrangement, NoDuty).

arrangement_no_duty_step(true, _, _, _, _, no_notification_duty, [cite(eu_dir_2022_2555_art_29_4)]) :-
    implements(eu_dir_2022_2555_art_29_4).
arrangement_no_duty_step(false, Profile, EntityState, EventState, ArrangementState, Result, Citations) :-
    absent_keys([entity_class - EntityState, arrangement_event - EventState, arrangement_is_a_cybersecurity_information_sharing_arrangement - ArrangementState], Missing),
    arrangement_missing_step(Missing, Profile, EventState, ArrangementState, Result, Citations).

arrangement_missing_step([FirstMissing|OtherMissing], _, _, _, indeterminate([FirstMissing|OtherMissing]), []) :-
    implements(eu_dir_2022_2555_art_29_4).
arrangement_missing_step([], Profile, EventState, ArrangementState, Result, Citations) :-
    arrangement_judgement_step(ArrangementState, Profile, EventState, Result, Citations).

arrangement_judgement_step(present(unsure), Profile, _, Result, []) :-
    implements(eu_dir_2022_2555_art_29_2),
    referral_answer(arrangement_is_an_art_29_2_arrangement, Profile, Result).
arrangement_judgement_step(present(true), _, present(ArrangementEvent), Result, [Citation]) :-
    implements(eu_dir_2022_2555_art_29_4),
    arrangement_event_duty(ArrangementEvent, Result, Citation).

nis2_information_sharing_voluntary_notification_checklist(Profile, Items) :-
    nis2_information_sharing_voluntary_notification_input_problems(Profile, Problems),
    checklist_items(Problems, Profile, Items).

checklist_items([Problem|Problems], _, [item(input_check, unknown([Problem|Problems]), cite(eu_dir_2022_2555_art_30_1))]).
checklist_items([], Profile, [item(essential_or_important_entity, EntityStatus, cite(eu_dir_2022_2555_art_30_1_a)), item(event_open_to_every_entity, EventStatus, cite(eu_dir_2022_2555_art_30_1_b))]) :-
    key_state(Profile, entity_class, EntityState),
    key_state(Profile, event_kind, EventState),
    entity_group(EntityState, EntityGroup),
    event_reach(EventState, EventReach),
    entity_item_status(EntityGroup, EntityStatus),
    event_item_status(EventReach, EventStatus).

entity_item_status(point_a_entity, met) :-
    implements(eu_dir_2022_2555_art_30_1_a).
entity_item_status(point_b_entity, unmet(not_an_essential_or_important_entity)) :-
    implements(eu_dir_2022_2555_art_30_1_a).
entity_item_status(unknown_entity_group, unknown([entity_class])).

event_item_status(every_entity, met) :-
    implements(eu_dir_2022_2555_art_30_1_b).
event_item_status(point_a_entities_only, unmet(incident_not_significant)) :-
    implements(eu_dir_2022_2555_art_30_1_b).
event_item_status(unknown_event_reach, unknown([event_kind])).

checklist_flags([], false, false).
checklist_flags([item(_, Status, _)|Items], HasMet, HasUnknown) :-
    status_flags(Status, StatusMet, StatusUnknown),
    checklist_flags(Items, LaterMet, LaterUnknown),
    truth_or(StatusMet, LaterMet, HasMet),
    truth_or(StatusUnknown, LaterUnknown, HasUnknown).

status_flags(met, true, false).
status_flags(unmet(_), false, false).
status_flags(unknown(_), false, true).

decide_nis2_information_sharing_voluntary_notification(Profile, nis2_information_sharing_voluntary_notification_verdict(eligible, Citations)) :-
    nis2_information_sharing_voluntary_notification_checklist(Profile, Items),
    checklist_flags(Items, true, _),
    findall(Citation, member(item(_, met, Citation), Items), MetCitations),
    sort(MetCitations, Citations).
decide_nis2_information_sharing_voluntary_notification(Profile, nis2_information_sharing_voluntary_notification_verdict(ineligible, Citations)) :-
    nis2_information_sharing_voluntary_notification_checklist(Profile, Items),
    checklist_flags(Items, false, false),
    findall(Citation, member(item(_, _, Citation), Items), ItemCitations),
    sort(ItemCitations, Citations).
decide_nis2_information_sharing_voluntary_notification(Profile, nis2_information_sharing_voluntary_notification_verdict(eligibility_undetermined, [])) :-
    nis2_information_sharing_voluntary_notification_checklist(Profile, Items),
    checklist_flags(Items, false, true).

nis2_information_sharing_voluntary_notification_status(Profile, Status) :-
    decide_nis2_information_sharing_voluntary_notification(Profile, nis2_information_sharing_voluntary_notification_verdict(Status, _Citations)).

nis2_information_sharing_voluntary_notification_decision_resolvable(Profile) :-
    decide_nis2_information_sharing_voluntary_notification(Profile, _Verdict).

test(an_essential_entity_can_notify_whatever_the_event) :-
    findall(Result - Citations, voluntary_notification_possible([attribute(entity_class, essential_entity)], Result, Citations), Answers),
    Answers == [voluntary_notification_possible - [cite(eu_dir_2022_2555_art_30_1_a)]].
test(an_important_entity_can_notify_an_incident) :-
    findall(Result, voluntary_notification_possible([attribute(entity_class, important_entity), attribute(event_kind, incident)], Result, _), Results),
    Results == [voluntary_notification_possible].
test(an_other_entity_can_notify_a_near_miss) :-
    findall(Result - Citations, voluntary_notification_possible([attribute(entity_class, out_of_scope), attribute(event_kind, near_miss)], Result, Citations), Answers),
    Answers == [voluntary_notification_possible - [cite(eu_dir_2022_2555_art_30_1_b)]].
test(an_absent_class_with_a_cyber_threat_cites_both_points) :-
    findall(Result - Citations, voluntary_notification_possible([attribute(event_kind, cyber_threat)], Result, Citations), Answers),
    Answers == [voluntary_notification_possible - [cite(eu_dir_2022_2555_art_30_1_a), cite(eu_dir_2022_2555_art_30_1_b)]].
test(an_other_entity_cannot_notify_an_incident_not_significant) :-
    findall(Result - Citations, voluntary_notification_possible([attribute(entity_class, out_of_scope), attribute(event_kind, incident)], Result, Citations), Answers),
    Answers == [voluntary_notification_not_possible - [cite(eu_dir_2022_2555_art_30_1_b)]].
test(an_empty_profile_names_both_notification_keys) :-
    findall(Result - Citations, voluntary_notification_possible([], Result, Citations), Answers),
    Answers == [indeterminate([entity_class, event_kind]) - []].
test(an_absent_class_with_an_incident_names_the_class) :-
    voluntary_notification_possible([attribute(event_kind, incident)], indeterminate([entity_class]), []).
test(a_wrong_value_is_an_input_problem) :-
    findall(Result - Citations, voluntary_notification_possible([attribute(entity_class, operator)], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(entity_class)]) - []].
test(a_duplicate_key_is_an_input_problem_for_every_query) :-
    arrangement_notification_duty([attribute(event_kind, incident), attribute(event_kind, incident)], input_problems([duplicate_key(event_kind)]), []).
test(relevant_information_aiming_at_response_is_permitted) :-
    findall(Result - Citations, information_exchange_permitted([attribute(information_is_relevant_cybersecurity_information, true), attribute(sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, true)], Result, Citations), Answers),
    Answers == [information_exchange_permitted - [cite(eu_dir_2022_2555_art_29_1)]].
test(irrelevant_information_is_not_permitted) :-
    findall(Result, information_exchange_permitted([attribute(information_is_relevant_cybersecurity_information, false)], Result, _), Results),
    Results == [information_exchange_not_permitted].
test(neither_point_is_not_permitted) :-
    information_exchange_permitted([attribute(sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, false), attribute(sharing_enhances_the_level_of_cybersecurity, false)], information_exchange_not_permitted, [cite(eu_dir_2022_2555_art_29_1)]).
test(an_empty_profile_names_all_three_exchange_keys) :-
    information_exchange_permitted([], indeterminate([information_is_relevant_cybersecurity_information, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity]), []).
test(one_point_true_leaves_only_relevance_missing) :-
    information_exchange_permitted([attribute(sharing_enhances_the_level_of_cybersecurity, true)], indeterminate([information_is_relevant_cybersecurity_information]), []).
test(an_unsure_relevance_goes_to_review) :-
    findall(Result - Citations, information_exchange_permitted([attribute(sharing_enhances_the_level_of_cybersecurity, true), attribute(information_is_relevant_cybersecurity_information, unsure)], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(information_is_relevant_cybersecurity_information, cite(eu_dir_2022_2555_art_29_1)), [inputs_relied_on([information_is_relevant_cybersecurity_information - unsure, sharing_enhances_the_level_of_cybersecurity - true])]) - []].
test(an_unsure_point_b_goes_to_review) :-
    information_exchange_permitted([attribute(information_is_relevant_cybersecurity_information, true), attribute(sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, false), attribute(sharing_enhances_the_level_of_cybersecurity, unsure)], needs_legal_review(open_textured(sharing_enhances_the_level_of_cybersecurity, cite(eu_dir_2022_2555_art_29_1_b)), [inputs_relied_on([information_is_relevant_cybersecurity_information - true, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact - false, sharing_enhances_the_level_of_cybersecurity - unsure])]), []).
test(an_unsure_point_with_a_missing_point_is_indeterminate) :-
    information_exchange_permitted([attribute(information_is_relevant_cybersecurity_information, true), attribute(sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, unsure)], indeterminate([sharing_enhances_the_level_of_cybersecurity]), []).
test(an_important_entity_entering_must_notify) :-
    findall(Result - Citations, arrangement_notification_duty([attribute(entity_class, important_entity), attribute(arrangement_event, entered), attribute(arrangement_is_a_cybersecurity_information_sharing_arrangement, true)], Result, Citations), Answers),
    Answers == [must_notify_on_entering - [cite(eu_dir_2022_2555_art_29_4)]].
test(an_essential_entity_withdrawing_must_notify) :-
    arrangement_notification_duty([attribute(entity_class, essential_entity), attribute(arrangement_event, withdrew), attribute(arrangement_is_a_cybersecurity_information_sharing_arrangement, true)], must_notify_on_withdrawal_taking_effect, [cite(eu_dir_2022_2555_art_29_4)]).
test(an_other_entity_has_no_duty_whatever_is_missing) :-
    findall(Result - Citations, arrangement_notification_duty([attribute(entity_class, out_of_scope)], Result, Citations), Answers),
    Answers == [no_notification_duty - [cite(eu_dir_2022_2555_art_29_4)]].
test(an_empty_profile_names_all_three_arrangement_keys) :-
    arrangement_notification_duty([], indeterminate([entity_class, arrangement_event, arrangement_is_a_cybersecurity_information_sharing_arrangement]), []).
test(a_missing_event_comes_before_an_unsure_arrangement) :-
    arrangement_notification_duty([attribute(entity_class, essential_entity), attribute(arrangement_is_a_cybersecurity_information_sharing_arrangement, unsure)], indeterminate([arrangement_event]), []).
test(an_unsure_arrangement_goes_to_review) :-
    findall(Result - Citations, arrangement_notification_duty([attribute(entity_class, essential_entity), attribute(arrangement_event, entered), attribute(arrangement_is_a_cybersecurity_information_sharing_arrangement, unsure)], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(arrangement_is_a_cybersecurity_information_sharing_arrangement, cite(eu_dir_2022_2555_art_29_2)), [inputs_relied_on([arrangement_is_a_cybersecurity_information_sharing_arrangement - unsure])]) - []].
test(the_facade_finds_an_essential_entity_eligible) :-
    findall(Status, nis2_information_sharing_voluntary_notification_status([attribute(entity_class, essential_entity)], Status), Statuses),
    Statuses == [eligible].
test(the_facade_finds_an_other_entity_incident_ineligible) :-
    nis2_information_sharing_voluntary_notification_status([attribute(entity_class, out_of_scope), attribute(event_kind, incident)], ineligible).
test(the_facade_leaves_an_empty_profile_undetermined) :-
    nis2_information_sharing_voluntary_notification_status([], eligibility_undetermined).
test(the_facade_leaves_a_bad_profile_undetermined) :-
    nis2_information_sharing_voluntary_notification_status(not_a_profile, eligibility_undetermined).
test(every_checklist_item_carries_a_citation) :-
    nis2_information_sharing_voluntary_notification_checklist([attribute(entity_class, out_of_scope), attribute(event_kind, near_miss)], Items),
    Items == [item(essential_or_important_entity, unmet(not_an_essential_or_important_entity), cite(eu_dir_2022_2555_art_30_1_a)), item(event_open_to_every_entity, met, cite(eu_dir_2022_2555_art_30_1_b))].

test(an_other_entity_incident_is_not_possible, fail) :-
    voluntary_notification_possible([attribute(entity_class, out_of_scope), attribute(event_kind, incident)], voluntary_notification_possible, _).
test(irrelevant_information_is_not_permitted_answer, fail) :-
    information_exchange_permitted([attribute(information_is_relevant_cybersecurity_information, false)], information_exchange_permitted, _).
test(an_other_entity_has_no_entering_duty, fail) :-
    arrangement_notification_duty([attribute(entity_class, out_of_scope), attribute(arrangement_event, entered), attribute(arrangement_is_a_cybersecurity_information_sharing_arrangement, true)], must_notify_on_entering, _).
