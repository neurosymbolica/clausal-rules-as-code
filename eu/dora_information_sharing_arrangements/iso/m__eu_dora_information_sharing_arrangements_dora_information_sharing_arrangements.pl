% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_information_sharing_arrangements_dora_information_sharing_arrangements, [decide_dora_information_sharing_arrangements/2, dora_information_sharing_arrangements_status/2, dora_information_sharing_arrangements_checklist/2, dora_information_sharing_arrangements_decision_resolvable/1, dora_information_sharing_arrangements_status_values/1, information_sharing_within_article_45/3, membership_notification_duty/3, sharing_within_article_45/0, sharing_outside_article_45/0, notify_participation_upon_validation/0, notify_cessation_once_effective/0, no_notification_duty/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_information_sharing_arrangements_kernel, [dora_information_sharing_arrangements_input_problems/2]).
:- use_module(m__eu_dora_information_sharing_arrangements_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(library(reif), [memberd_t/3]).

sharing_within_article_45.

sharing_outside_article_45.

notify_participation_upon_validation.

notify_cessation_once_effective.

no_notification_duty.

dora_information_sharing_arrangements_status_values([sharing_within_article_45, sharing_outside_article_45]).

condition_identifiers([information_is_cyber_threat_information_and_intelligence, sharing_aims_to_enhance_digital_operational_resilience, sharing_takes_place_within_trusted_community_of_financial_entities, arrangement_protects_sensitive_information_and_has_rules_of_conduct, arrangement_defines_participation_conditions_and_appropriate_details]).

referral(information_is_cyber_threat_information_unclear, information_sharing_within_article_45/3, information_is_cyber_threat_information_and_intelligence, cite(eu_reg_2022_2554_art_45_1), [information_is_cyber_threat_information_and_intelligence, sharing_aims_to_enhance_digital_operational_resilience, sharing_takes_place_within_trusted_community_of_financial_entities, arrangement_protects_sensitive_information_and_has_rules_of_conduct, arrangement_defines_participation_conditions_and_appropriate_details]).
referral(aim_of_resilience_unclear, information_sharing_within_article_45/3, sharing_aims_to_enhance_digital_operational_resilience, cite(eu_reg_2022_2554_art_45_1_a), [information_is_cyber_threat_information_and_intelligence, sharing_aims_to_enhance_digital_operational_resilience, sharing_takes_place_within_trusted_community_of_financial_entities, arrangement_protects_sensitive_information_and_has_rules_of_conduct, arrangement_defines_participation_conditions_and_appropriate_details]).
referral(trusted_community_unclear, information_sharing_within_article_45/3, sharing_takes_place_within_trusted_community_of_financial_entities, cite(eu_reg_2022_2554_art_45_1_b), [information_is_cyber_threat_information_and_intelligence, sharing_aims_to_enhance_digital_operational_resilience, sharing_takes_place_within_trusted_community_of_financial_entities, arrangement_protects_sensitive_information_and_has_rules_of_conduct, arrangement_defines_participation_conditions_and_appropriate_details]).
referral(arrangement_protection_and_rules_of_conduct_unclear, information_sharing_within_article_45/3, arrangement_protects_sensitive_information_and_has_rules_of_conduct, cite(eu_reg_2022_2554_art_45_1_c), [information_is_cyber_threat_information_and_intelligence, sharing_aims_to_enhance_digital_operational_resilience, sharing_takes_place_within_trusted_community_of_financial_entities, arrangement_protects_sensitive_information_and_has_rules_of_conduct, arrangement_defines_participation_conditions_and_appropriate_details]).
referral(arrangement_participation_conditions_and_details_unclear, information_sharing_within_article_45/3, arrangement_defines_participation_conditions_and_appropriate_details, cite(eu_reg_2022_2554_art_45_2), [information_is_cyber_threat_information_and_intelligence, sharing_aims_to_enhance_digital_operational_resilience, sharing_takes_place_within_trusted_community_of_financial_entities, arrangement_protects_sensitive_information_and_has_rules_of_conduct, arrangement_defines_participation_conditions_and_appropriate_details]).
referral(arrangement_referred_to_in_paragraph_1_unclear, membership_notification_duty/3, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, cite(eu_reg_2022_2554_art_45_3), [membership_event, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1]).

key_state(Profile, ProfileKey, Value) :-
    profile_get(Profile, ProfileKey, Value).
key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).

relied_pairs(_Profile, [], []).
relied_pairs(Profile, [InputKey|InputKeys], Pairs) :-
    key_state(Profile, InputKey, State),
    relied_pairs(Profile, InputKeys, LaterPairs),
    add_relied_pair(State, InputKey, LaterPairs, Pairs).

add_relied_pair(absent, _InputKey, Pairs, Pairs).
add_relied_pair(State, InputKey, LaterPairs, [InputKey - State|LaterPairs]) :-
    dif(State, absent).

judgement_status(true, _ConditionKey, met).
judgement_status(false, _ConditionKey, unmet(judged_false)).
judgement_status(unsure, ConditionKey, open_textured(ConditionKey)).
judgement_status(absent, ConditionKey, unknown([ConditionKey])).

condition_requirement(information_is_cyber_threat_information_and_intelligence, Profile, Status, cite(eu_reg_2022_2554_art_45_1)) :-
    implements(eu_reg_2022_2554_art_45_1),
    key_state(Profile, information_is_cyber_threat_information_and_intelligence, State),
    judgement_status(State, information_is_cyber_threat_information_and_intelligence, Status).
condition_requirement(sharing_aims_to_enhance_digital_operational_resilience, Profile, Status, cite(eu_reg_2022_2554_art_45_1_a)) :-
    implements(eu_reg_2022_2554_art_45_1_a),
    key_state(Profile, sharing_aims_to_enhance_digital_operational_resilience, State),
    judgement_status(State, sharing_aims_to_enhance_digital_operational_resilience, Status).
condition_requirement(sharing_takes_place_within_trusted_community_of_financial_entities, Profile, Status, cite(eu_reg_2022_2554_art_45_1_b)) :-
    implements(eu_reg_2022_2554_art_45_1_b),
    key_state(Profile, sharing_takes_place_within_trusted_community_of_financial_entities, State),
    judgement_status(State, sharing_takes_place_within_trusted_community_of_financial_entities, Status).
condition_requirement(arrangement_protects_sensitive_information_and_has_rules_of_conduct, Profile, Status, cite(eu_reg_2022_2554_art_45_1_c)) :-
    implements(eu_reg_2022_2554_art_45_1_c),
    key_state(Profile, arrangement_protects_sensitive_information_and_has_rules_of_conduct, State),
    judgement_status(State, arrangement_protects_sensitive_information_and_has_rules_of_conduct, Status).
condition_requirement(arrangement_defines_participation_conditions_and_appropriate_details, Profile, Status, cite(eu_reg_2022_2554_art_45_2)) :-
    implements(eu_reg_2022_2554_art_45_2),
    key_state(Profile, arrangement_defines_participation_conditions_and_appropriate_details, State),
    judgement_status(State, arrangement_defines_participation_conditions_and_appropriate_details, Status).

condition_item(Profile, Identifier, item(Identifier, Status, Citation)) :-
    condition_requirement(Identifier, Profile, Status, Citation).

sharing_items(Profile, Items) :-
    condition_identifiers(Identifiers),
    maplist(condition_item(Profile), Identifiers, Items).

status_kind(met, met).
status_kind(unmet(_Reason), unmet).
status_kind(unknown(_MissingKeys), absent).
status_kind(open_textured(_Judgement), unsure).

item_kind(item(_Identifier, Status, _Citation), Kind) :-
    status_kind(Status, Kind).

item_kinds(Items, Kinds) :-
    maplist(item_kind, Items, Kinds).

first_item_of_kind([item(Identifier, Status, _Citation)|_Items], Kind, Identifier) :-
    status_kind(Status, Kind).
first_item_of_kind([item(_Identifier, Status, _Citation)|Items], Kind, Identifier) :-
    status_kind(Status, OtherKind),
    dif(OtherKind, Kind),
    first_item_of_kind(Items, Kind, Identifier).

information_sharing_within_article_45(Profile, input_problems(Problems), []) :-
    dora_information_sharing_arrangements_input_problems(Profile, Problems),
    Problems = [_|_].
information_sharing_within_article_45(Profile, Result, Citations) :-
    dora_information_sharing_arrangements_input_problems(Profile, []),
    sharing_answer(Profile, Result, Citations).

sharing_answer(Profile, sharing_outside_article_45, [cite(eu_reg_2022_2554_art_45_1), cite(eu_reg_2022_2554_art_45_1_a), cite(eu_reg_2022_2554_art_45_1_b), cite(eu_reg_2022_2554_art_45_1_c), cite(eu_reg_2022_2554_art_45_2)]) :-
    implements(eu_reg_2022_2554_art_45_1),
    sharing_items(Profile, Items),
    item_kinds(Items, Kinds),
    memberd_t(unmet, Kinds, true).
sharing_answer(Profile, indeterminate([MissingKey]), []) :-
    implements(eu_reg_2022_2554_art_45_1),
    sharing_items(Profile, Items),
    item_kinds(Items, Kinds),
    memberd_t(unmet, Kinds, false),
    memberd_t(absent, Kinds, true),
    first_item_of_kind(Items, absent, MissingKey).
sharing_answer(Profile, needs_legal_review(open_textured(UnsureKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_45_1),
    sharing_items(Profile, Items),
    item_kinds(Items, Kinds),
    memberd_t(unmet, Kinds, false),
    memberd_t(absent, Kinds, false),
    memberd_t(unsure, Kinds, true),
    first_item_of_kind(Items, unsure, UnsureKey),
    referral(_Situation, information_sharing_within_article_45/3, UnsureKey, Citation, Inputs),
    relied_pairs(Profile, Inputs, Pairs).
sharing_answer(Profile, sharing_within_article_45, [cite(eu_reg_2022_2554_art_45_1), cite(eu_reg_2022_2554_art_45_1_a), cite(eu_reg_2022_2554_art_45_1_b), cite(eu_reg_2022_2554_art_45_1_c), cite(eu_reg_2022_2554_art_45_2)]) :-
    implements(eu_reg_2022_2554_art_45_1),
    sharing_items(Profile, Items),
    item_kinds(Items, Kinds),
    memberd_t(unmet, Kinds, false),
    memberd_t(absent, Kinds, false),
    memberd_t(unsure, Kinds, false).

membership_notification_duty(Profile, input_problems(Problems), []) :-
    dora_information_sharing_arrangements_input_problems(Profile, Problems),
    Problems = [_|_].
membership_notification_duty(Profile, Result, Citations) :-
    dora_information_sharing_arrangements_input_problems(Profile, []),
    key_state(Profile, membership_event, EventState),
    key_state(Profile, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, ArrangementState),
    notification_answer(EventState, ArrangementState, Profile, Result, Citations).

membership_event_occurred(membership_validated).
membership_event_occurred(membership_cessation_took_effect).

notification_answer(no_membership_event, _ArrangementState, _Profile, no_notification_duty, [cite(eu_reg_2022_2554_art_45_3)]) :-
    implements(eu_reg_2022_2554_art_45_3).
notification_answer(EventState, false, _Profile, no_notification_duty, [cite(eu_reg_2022_2554_art_45_3)]) :-
    implements(eu_reg_2022_2554_art_45_3),
    dif(EventState, no_membership_event).
notification_answer(absent, ArrangementState, _Profile, indeterminate([membership_event]), []) :-
    implements(eu_reg_2022_2554_art_45_3),
    dif(ArrangementState, false).
notification_answer(EventState, absent, _Profile, indeterminate([arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1]), []) :-
    implements(eu_reg_2022_2554_art_45_3),
    membership_event_occurred(EventState).
notification_answer(EventState, unsure, Profile, needs_legal_review(open_textured(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_45_3),
    membership_event_occurred(EventState),
    referral(_Situation, membership_notification_duty/3, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, Citation, Inputs),
    relied_pairs(Profile, Inputs, Pairs).
notification_answer(membership_validated, true, _Profile, notify_participation_upon_validation, [cite(eu_reg_2022_2554_art_45_3)]) :-
    implements(eu_reg_2022_2554_art_45_3).
notification_answer(membership_cessation_took_effect, true, _Profile, notify_cessation_once_effective, [cite(eu_reg_2022_2554_art_45_3)]) :-
    implements(eu_reg_2022_2554_art_45_3).

decide_dora_information_sharing_arrangements(Profile, dora_information_sharing_arrangements_verdict(Status, Citations)) :-
    information_sharing_within_article_45(Profile, Status, Citations).

dora_information_sharing_arrangements_status(Profile, Status) :-
    decide_dora_information_sharing_arrangements(Profile, dora_information_sharing_arrangements_verdict(Status, _Citations)).

dora_information_sharing_arrangements_checklist(Profile, Items) :-
    dora_information_sharing_arrangements_input_problems(Profile, []),
    sharing_items(Profile, Items).

dora_information_sharing_arrangements_decision_resolvable(Profile) :-
    decide_dora_information_sharing_arrangements(Profile, _Verdict).

all_true_profile([attribute(information_is_cyber_threat_information_and_intelligence, true), attribute(sharing_aims_to_enhance_digital_operational_resilience, true), attribute(sharing_takes_place_within_trusted_community_of_financial_entities, true), attribute(arrangement_protects_sensitive_information_and_has_rules_of_conduct, true), attribute(arrangement_defines_participation_conditions_and_appropriate_details, true)]).

test(all_five_true_is_within_once) :-
    all_true_profile(Profile),
    findall(Result - Citations, information_sharing_within_article_45(Profile, Result, Citations), Answers),
    Answers == [sharing_within_article_45 - [cite(eu_reg_2022_2554_art_45_1), cite(eu_reg_2022_2554_art_45_1_a), cite(eu_reg_2022_2554_art_45_1_b), cite(eu_reg_2022_2554_art_45_1_c), cite(eu_reg_2022_2554_art_45_2)]].
test(one_false_decides_alone_once) :-
    Profile = [attribute(arrangement_defines_participation_conditions_and_appropriate_details, false), attribute(sharing_aims_to_enhance_digital_operational_resilience, unsure)],
    findall(Result, information_sharing_within_article_45(Profile, Result, _Citations), Results),
    Results == [sharing_outside_article_45].
test(absent_named_before_unsure) :-
    Profile = [attribute(information_is_cyber_threat_information_and_intelligence, unsure), attribute(sharing_aims_to_enhance_digital_operational_resilience, true)],
    findall(Result - Citations, information_sharing_within_article_45(Profile, Result, Citations), Answers),
    Answers == [indeterminate([sharing_takes_place_within_trusted_community_of_financial_entities]) - []].
test(first_unsure_is_referred_with_pairs) :-
    Profile = [attribute(arrangement_defines_participation_conditions_and_appropriate_details, unsure), attribute(information_is_cyber_threat_information_and_intelligence, true), attribute(sharing_aims_to_enhance_digital_operational_resilience, unsure), attribute(sharing_takes_place_within_trusted_community_of_financial_entities, true), attribute(arrangement_protects_sensitive_information_and_has_rules_of_conduct, true), attribute(membership_event, membership_validated)],
    findall(Result - Citations, information_sharing_within_article_45(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(sharing_aims_to_enhance_digital_operational_resilience, cite(eu_reg_2022_2554_art_45_1_a)), [inputs_relied_on([information_is_cyber_threat_information_and_intelligence - true, sharing_aims_to_enhance_digital_operational_resilience - unsure, sharing_takes_place_within_trusted_community_of_financial_entities - true, arrangement_protects_sensitive_information_and_has_rules_of_conduct - true, arrangement_defines_participation_conditions_and_appropriate_details - unsure])]) - []].
test(unknown_key_is_an_input_problem) :-
    findall(Result - Citations, information_sharing_within_article_45([attribute(entity_size, large)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(entity_size)]) - []].
test(duplicate_key_is_an_input_problem) :-
    Profile = [attribute(membership_event, membership_validated), attribute(membership_event, no_membership_event)],
    findall(Result, membership_notification_duty(Profile, Result, _Citations), Results),
    Results == [input_problems([duplicate_key(membership_event)])].
test(validation_gives_participation_notice_once) :-
    Profile = [attribute(membership_event, membership_validated), attribute(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, true)],
    findall(Result - Citations, membership_notification_duty(Profile, Result, Citations), Answers),
    Answers == [notify_participation_upon_validation - [cite(eu_reg_2022_2554_art_45_3)]].
test(cessation_gives_cessation_notice) :-
    Profile = [attribute(membership_event, membership_cessation_took_effect), attribute(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, true)],
    membership_notification_duty(Profile, notify_cessation_once_effective, [cite(eu_reg_2022_2554_art_45_3)]).
test(no_event_decides_alone) :-
    findall(Result, membership_notification_duty([attribute(membership_event, no_membership_event)], Result, _Citations), Results),
    Results == [no_notification_duty].
test(false_arrangement_decides_alone) :-
    findall(Result, membership_notification_duty([attribute(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, false)], Result, _Citations), Results),
    Results == [no_notification_duty].
test(absent_event_named_before_unsure_arrangement) :-
    findall(Result, membership_notification_duty([attribute(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, unsure)], Result, _Citations), Results),
    Results == [indeterminate([membership_event])].
test(absent_arrangement_after_event) :-
    findall(Result, membership_notification_duty([attribute(membership_event, membership_validated)], Result, _Citations), Results),
    Results == [indeterminate([arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1])].
test(unsure_arrangement_is_referred) :-
    Profile = [attribute(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, unsure), attribute(membership_event, membership_cessation_took_effect)],
    findall(Result - Citations, membership_notification_duty(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, cite(eu_reg_2022_2554_art_45_3)), [inputs_relied_on([membership_event - membership_cessation_took_effect, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1 - unsure])]) - []].
test(checklist_cites_every_condition) :-
    all_true_profile(Profile),
    dora_information_sharing_arrangements_checklist(Profile, Items),
    length(Items, 5),
    member(item(arrangement_defines_participation_conditions_and_appropriate_details, met, cite(eu_reg_2022_2554_art_45_2)), Items).

test(all_five_true_is_not_outside, fail) :-
    all_true_profile(Profile),
    information_sharing_within_article_45(Profile, sharing_outside_article_45, _Citations).
test(validation_is_not_cessation_notice, fail) :-
    Profile = [attribute(membership_event, membership_validated), attribute(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, true)],
    membership_notification_duty(Profile, notify_cessation_once_effective, _Citations).
