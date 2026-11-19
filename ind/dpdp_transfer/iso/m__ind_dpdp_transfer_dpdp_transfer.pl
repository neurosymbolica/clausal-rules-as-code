% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_dpdp_transfer, [decide_dpdp_transfer/2, dpdp_transfer_status/2, dpdp_transfer_checklist/2, dpdp_transfer_decision_resolvable/1, dpdp_transfer_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_kernel, [dpdp_transfer_input_problems/2]).
:- use_module(m__ind_dpdp_transfer_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

dpdp_transfer_status_values([restricted_see_notification, requirements_apply_see_order, not_restricted, not_in_force]).

rule_15_commencement_date(date(2027, 5, 13), cite(in_dpdp_rules_2025_r_1_4)).

decide_dpdp_transfer(restriction_request(Restriction, Profile), Verdict) :-
    dpdp_transfer_input_problems(Profile, Problems),
    checked_verdict(Problems, Restriction, Profile, Verdict).

checked_verdict([Problem|Problems], _, _, dpdp_transfer_verdict(input_problems([Problem|Problems]), [])).
checked_verdict([], notified_destination, Profile, dpdp_transfer_verdict(Result, Citations)) :-
    key_state(Profile, section_16_in_force_on_reference_date, InForceState),
    key_state(Profile, destination_restricted_by_notification, NotificationState),
    notified_destination_step(InForceState, NotificationState, Result, Citations).
checked_verdict([], foreign_state_requirements, Profile, dpdp_transfer_verdict(Result, Citations)) :-
    key_state(Profile, section_16_in_force_on_reference_date, InForceState),
    key_state(Profile, reference_date, ReferenceDateState),
    reference_phase(ReferenceDateState, PhaseState),
    key_state(Profile, recipient_is_foreign_state_or_its_entity, RecipientState),
    key_state(Profile, foreign_state_requirements_specified, RequirementsState),
    foreign_state_step(InForceState, PhaseState, RecipientState, RequirementsState, Result, Citations).

key_state(Profile, Key, present(Value)) :-
    profile_get(Profile, Key, Value).
key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

reference_phase(absent, absent).
reference_phase(present(ReferenceDate), before_commencement) :-
    implements(in_dpdp_rules_2025_r_1_4),
    rule_15_commencement_date(CommencementDate, _),
    ReferenceDate @< CommencementDate.
reference_phase(present(ReferenceDate), on_or_after_commencement) :-
    implements(in_dpdp_rules_2025_r_1_4),
    rule_15_commencement_date(CommencementDate, _),
    ReferenceDate @>= CommencementDate.

notified_destination_step(present(false), _, not_in_force, [cite(in_dpdp_act_2023_s_16_1)]) :-
    implements(in_dpdp_act_2023_s_16_1).
notified_destination_step(absent, _, indeterminate([section_16_in_force_on_reference_date]), []) :-
    implements(in_dpdp_act_2023_s_16_1).
notified_destination_step(present(true), present(false), not_restricted, [cite(in_dpdp_act_2023_s_16_1), cite(in_dpdp_act_2023_s_16_2)]) :-
    implements(in_dpdp_act_2023_s_16_1),
    implements(in_dpdp_act_2023_s_16_2).
notified_destination_step(present(true), absent, indeterminate([destination_restricted_by_notification]), []) :-
    implements(in_dpdp_act_2023_s_16_1).
notified_destination_step(present(true), present(unsure), needs_legal_review(open_textured(destination_restricted_by_notification, cite(in_dpdp_act_2023_s_16_1)), [inputs_relied_on([destination_restricted_by_notification - unsure])]), []) :-
    implements(in_dpdp_act_2023_s_16_1).
notified_destination_step(present(true), present(true), restricted_see_notification, [cite(in_dpdp_act_2023_s_16_1)]) :-
    implements(in_dpdp_act_2023_s_16_1).

foreign_state_step(present(false), _, _, _, not_in_force, [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]) :-
    implements(in_dpdp_rules_2025_r_15),
    implements(in_dpdp_act_2023_s_16_1).
foreign_state_step(InForceState, before_commencement, _, _, not_in_force, [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]) :-
    implements(in_dpdp_rules_2025_r_1_4),
    in_force_not_false(InForceState).
foreign_state_step(absent, PhaseState, _, _, indeterminate([section_16_in_force_on_reference_date]), []) :-
    implements(in_dpdp_rules_2025_r_15),
    phase_not_before(PhaseState).
foreign_state_step(present(true), absent, _, _, indeterminate([reference_date]), []) :-
    implements(in_dpdp_rules_2025_r_1_4).
foreign_state_step(present(true), on_or_after_commencement, present(false), _, not_restricted, [cite(in_dpdp_rules_2025_r_15)]) :-
    implements(in_dpdp_rules_2025_r_15).
foreign_state_step(present(true), on_or_after_commencement, RecipientState, present(false), not_restricted, [cite(in_dpdp_rules_2025_r_15)]) :-
    implements(in_dpdp_rules_2025_r_15),
    recipient_not_false(RecipientState).
foreign_state_step(present(true), on_or_after_commencement, absent, RequirementsState, indeterminate([recipient_is_foreign_state_or_its_entity]), []) :-
    implements(in_dpdp_rules_2025_r_15),
    requirements_not_false(RequirementsState).
foreign_state_step(present(true), on_or_after_commencement, RecipientState, absent, indeterminate([foreign_state_requirements_specified]), []) :-
    implements(in_dpdp_rules_2025_r_15),
    recipient_true_or_unsure(RecipientState).
foreign_state_step(present(true), on_or_after_commencement, present(unsure), present(true), needs_legal_review(open_textured(recipient_is_foreign_state_or_its_entity, cite(in_dpdp_rules_2025_r_15)), [inputs_relied_on([recipient_is_foreign_state_or_its_entity - unsure])]), []) :-
    implements(in_dpdp_rules_2025_r_15).
foreign_state_step(present(true), on_or_after_commencement, present(true), present(true), requirements_apply_see_order, [cite(in_dpdp_rules_2025_r_15)]) :-
    implements(in_dpdp_rules_2025_r_15).

in_force_not_false(absent).
in_force_not_false(present(true)).

phase_not_before(absent).
phase_not_before(on_or_after_commencement).

recipient_not_false(absent).
recipient_not_false(present(true)).
recipient_not_false(present(unsure)).

recipient_true_or_unsure(present(true)).
recipient_true_or_unsure(present(unsure)).

requirements_not_false(absent).
requirements_not_false(present(true)).

dpdp_transfer_status(Request, Status) :-
    decide_dpdp_transfer(Request, dpdp_transfer_verdict(Status, _Citations)).

dpdp_transfer_checklist(restriction_request(Restriction, Profile), Items) :-
    dpdp_transfer_input_problems(Profile, Problems),
    checked_checklist(Problems, Restriction, Profile, Items).

checked_checklist([Problem|Problems], _, _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(in_dpdp_act_2023_s_16_1))]).
checked_checklist([], notified_destination, Profile, [item(section_16_in_force, InForceStatus, cite(in_dpdp_act_2023_s_16_1)), item(destination_restricted_by_notification, NotificationStatus, cite(in_dpdp_act_2023_s_16_1))]) :-
    key_state(Profile, section_16_in_force_on_reference_date, InForceState),
    item_status(section_16_in_force_on_reference_date, InForceState, InForceStatus),
    key_state(Profile, destination_restricted_by_notification, NotificationState),
    item_status(destination_restricted_by_notification, NotificationState, NotificationStatus).
checked_checklist([], foreign_state_requirements, Profile, [item(section_16_in_force, InForceStatus, cite(in_dpdp_act_2023_s_16_1)), item(rule_15_in_force, PhaseStatus, cite(in_dpdp_rules_2025_r_1_4)), item(recipient_is_foreign_state_or_its_entity, RecipientStatus, cite(in_dpdp_rules_2025_r_15)), item(foreign_state_requirements_specified, RequirementsStatus, cite(in_dpdp_rules_2025_r_15))]) :-
    key_state(Profile, section_16_in_force_on_reference_date, InForceState),
    item_status(section_16_in_force_on_reference_date, InForceState, InForceStatus),
    key_state(Profile, reference_date, ReferenceDateState),
    reference_phase(ReferenceDateState, PhaseState),
    phase_item_status(PhaseState, PhaseStatus),
    key_state(Profile, recipient_is_foreign_state_or_its_entity, RecipientState),
    item_status(recipient_is_foreign_state_or_its_entity, RecipientState, RecipientStatus),
    key_state(Profile, foreign_state_requirements_specified, RequirementsState),
    item_status(foreign_state_requirements_specified, RequirementsState, RequirementsStatus).

item_status(_, present(true), met).
item_status(Key, present(false), unmet(Key)).
item_status(Key, present(unsure), unknown([Key])).
item_status(Key, absent, unknown([Key])).

phase_item_status(on_or_after_commencement, met).
phase_item_status(before_commencement, unmet(reference_date_before_rule_15_commencement)).
phase_item_status(absent, unknown([reference_date])).

dpdp_transfer_decision_resolvable(Request) :-
    decide_dpdp_transfer(Request, _Verdict).

test(notified_restricted_see_notification) :-
    findall(Result - Citations, decide_dpdp_transfer(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)]), dpdp_transfer_verdict(Result, Citations)), Answers),
    Answers == [restricted_see_notification - [cite(in_dpdp_act_2023_s_16_1)]].
test(notified_section_16_not_in_force_whatever_notification) :-
    findall(Result - Citations, decide_dpdp_transfer(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, false), attribute(destination_restricted_by_notification, unsure)]), dpdp_transfer_verdict(Result, Citations)), Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_16_1)]].
test(notified_not_restricted_cites_section_16_2) :-
    findall(Result - Citations, decide_dpdp_transfer(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, false)]), dpdp_transfer_verdict(Result, Citations)), Answers),
    Answers == [not_restricted - [cite(in_dpdp_act_2023_s_16_1), cite(in_dpdp_act_2023_s_16_2)]].
test(notified_section_16_named_first) :-
    findall(Result, dpdp_transfer_status(restriction_request(notified_destination, []), Result), Results),
    Results == [indeterminate([section_16_in_force_on_reference_date])].
test(notified_notification_named_once_in_force) :-
    findall(Result, dpdp_transfer_status(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true)]), Result), Results),
    Results == [indeterminate([destination_restricted_by_notification])].
test(notified_unsure_referred) :-
    findall(Result - Citations, decide_dpdp_transfer(restriction_request(notified_destination, [attribute(destination_restricted_by_notification, unsure), attribute(section_16_in_force_on_reference_date, true)]), dpdp_transfer_verdict(Result, Citations)), Answers),
    Answers == [needs_legal_review(open_textured(destination_restricted_by_notification, cite(in_dpdp_act_2023_s_16_1)), [inputs_relied_on([destination_restricted_by_notification - unsure])]) - []].
test(foreign_requirements_apply_on_commencement_day) :-
    findall(Result - Citations, decide_dpdp_transfer(restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)]), dpdp_transfer_verdict(Result, Citations)), Answers),
    Answers == [requirements_apply_see_order - [cite(in_dpdp_rules_2025_r_15)]].
test(foreign_day_before_commencement_not_in_force) :-
    findall(Result - Citations, decide_dpdp_transfer(restriction_request(foreign_state_requirements, [attribute(reference_date, date(2027, 5, 12))]), dpdp_transfer_verdict(Result, Citations)), Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].
test(foreign_section_16_false_not_in_force) :-
    findall(Result, dpdp_transfer_status(restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, false)]), Result), Results),
    Results == [not_in_force].
test(foreign_section_16_named_before_date) :-
    findall(Result, dpdp_transfer_status(restriction_request(foreign_state_requirements, []), Result), Results),
    Results == [indeterminate([section_16_in_force_on_reference_date])].
test(foreign_date_named_when_in_force) :-
    findall(Result, dpdp_transfer_status(restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true)]), Result), Results),
    Results == [indeterminate([reference_date])].
test(foreign_no_order_not_restricted_with_recipient_absent) :-
    findall(Result, dpdp_transfer_status(restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2028, 1, 1)), attribute(foreign_state_requirements_specified, false)]), Result), Results),
    Results == [not_restricted].
test(foreign_requirements_named_before_referral) :-
    findall(Result, dpdp_transfer_status(restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2028, 1, 1)), attribute(recipient_is_foreign_state_or_its_entity, unsure)]), Result), Results),
    Results == [indeterminate([foreign_state_requirements_specified])].
test(foreign_unsure_referred) :-
    findall(Result - Citations, decide_dpdp_transfer(restriction_request(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2028, 1, 1)), attribute(recipient_is_foreign_state_or_its_entity, unsure), attribute(foreign_state_requirements_specified, true)]), dpdp_transfer_verdict(Result, Citations)), Answers),
    Answers == [needs_legal_review(open_textured(recipient_is_foreign_state_or_its_entity, cite(in_dpdp_rules_2025_r_15)), [inputs_relied_on([recipient_is_foreign_state_or_its_entity - unsure])]) - []].
test(input_problems_come_first) :-
    findall(Result - Citations, decide_dpdp_transfer(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, unsure), attribute(colour, blue)]), dpdp_transfer_verdict(Result, Citations)), Answers),
    Answers == [input_problems([wrong_type(section_16_in_force_on_reference_date), unknown_key(colour)]) - []].
test(checklist_carries_citations) :-
    findall(Items, dpdp_transfer_checklist(restriction_request(foreign_state_requirements, [attribute(reference_date, date(2027, 5, 12))]), Items), Checklists),
    Checklists == [[item(section_16_in_force, unknown([section_16_in_force_on_reference_date]), cite(in_dpdp_act_2023_s_16_1)), item(rule_15_in_force, unmet(reference_date_before_rule_15_commencement), cite(in_dpdp_rules_2025_r_1_4)), item(recipient_is_foreign_state_or_its_entity, unknown([recipient_is_foreign_state_or_its_entity]), cite(in_dpdp_rules_2025_r_15)), item(foreign_state_requirements_specified, unknown([foreign_state_requirements_specified]), cite(in_dpdp_rules_2025_r_15))]].

test(notified_restricted_is_not_not_restricted, fail) :-
    dpdp_transfer_status(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)]), not_restricted).
