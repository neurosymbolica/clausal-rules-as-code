% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, decide_gdpr_compensation_and_liability/2, gdpr_compensation_and_liability_status/2, gdpr_compensation_and_liability_checklist/2, gdpr_compensation_and_liability_decision_resolvable/1, gdpr_compensation_and_liability_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_keys/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_kernel, [gdpr_compensation_and_liability_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_citations, [implements/1]).

gdpr_compensation_and_liability_status_values([right_not_established, not_liable_for_damage, exempt_from_liability, liable_for_damage]).

deferred_provision(cite(eu_reg_2016_679_art_82_4), joint_liability_for_the_entire_damage).
deferred_provision(cite(eu_reg_2016_679_art_82_5), recourse_between_those_involved).
deferred_provision(cite(eu_reg_2016_679_art_82_6), courts_competent_for_the_proceedings).

key_state(Profile, ProfileKey, KeyState) :-
    profile_keys(Profile, PresentKeys),
    memberd_t(ProfileKey, PresentKeys, Present),
    present_state(Present, Profile, ProfileKey, KeyState).

present_state(false, _, _, absent).
present_state(true, Profile, ProfileKey, present(Value)) :-
    profile_get(Profile, ProfileKey, Value).

first_with(_, [], none).
first_with(Wanted, [ProfileKey - KeyState|_], found(ProfileKey)) :-
    KeyState == Wanted.
first_with(Wanted, [_ - KeyState|Remaining], Found) :-
    KeyState \== Wanted,
    first_with(Wanted, Remaining, Found).

judgement_key_states(Profile, [damage_suffered - DamageState, infringement_of_the_regulation_occurred - InfringementState, damage_resulted_from_the_infringement - CausationState]) :-
    key_state(Profile, damage_suffered, DamageState),
    key_state(Profile, infringement_of_the_regulation_occurred, InfringementState),
    key_state(Profile, damage_resulted_from_the_infringement, CausationState).

judgement_summary(Profile, Summary) :-
    implements(eu_reg_2016_679_art_82_1),
    judgement_key_states(Profile, KeyStates),
    pairs_values(KeyStates, StateValues),
    memberd_t(present(false), StateValues, HasFalse),
    summary_after_false(HasFalse, KeyStates, Summary).

summary_after_false(true, _, some_false).
summary_after_false(false, KeyStates, Summary) :-
    first_with(absent, KeyStates, FirstAbsent),
    summary_after_absent(FirstAbsent, KeyStates, Summary).

summary_after_absent(found(JudgementKey), _, judgement_absent(JudgementKey)).
summary_after_absent(none, KeyStates, Summary) :-
    first_with(present(unsure), KeyStates, FirstUnsure),
    summary_after_unsure(FirstUnsure, Summary).

summary_after_unsure(found(JudgementKey), judgement_unsure(JudgementKey)).
summary_after_unsure(none, all_true).

position_readable(all_true).
position_readable(judgement_unsure(_)).

judgement_pairs(Profile, [damage_suffered - DamageValue, infringement_of_the_regulation_occurred - InfringementValue, damage_resulted_from_the_infringement - CausationValue]) :-
    profile_get(Profile, damage_suffered, DamageValue),
    profile_get(Profile, infringement_of_the_regulation_occurred, InfringementValue),
    profile_get(Profile, damage_resulted_from_the_infringement, CausationValue).

caller_position(Profile, Position) :-
    implements(eu_reg_2016_679_art_82_2),
    key_state(Profile, party_role, RoleState),
    role_position(RoleState, Profile, Position).

role_position(absent, _, undecided(party_role)).
role_position(present(controller), Profile, Position) :-
    implements(eu_reg_2016_679_art_82_2),
    key_state(Profile, involved_in_the_processing, InvolvedState),
    controller_position(InvolvedState, Position).
role_position(present(processor), Profile, Position) :-
    implements(eu_reg_2016_679_art_82_2),
    key_state(Profile, processor_breached_obligations_directed_to_processors, BreachState),
    key_state(Profile, processor_acted_outside_or_contrary_to_lawful_instructions, InstructionState),
    memberd_t(present(true), [BreachState, InstructionState], AnyTrue),
    processor_position(AnyTrue, [processor_breached_obligations_directed_to_processors - BreachState, processor_acted_outside_or_contrary_to_lawful_instructions - InstructionState], Position).

controller_position(absent, undecided(involved_in_the_processing)).
controller_position(present(true), inside) :-
    implements(eu_reg_2016_679_art_82_2).
controller_position(present(false), outside) :-
    implements(eu_reg_2016_679_art_82_2).

processor_position(true, _, inside) :-
    implements(eu_reg_2016_679_art_82_2).
processor_position(false, ProcessorStates, Position) :-
    implements(eu_reg_2016_679_art_82_2),
    first_with(absent, ProcessorStates, FirstAbsent),
    processor_undecided(FirstAbsent, Position).

processor_undecided(found(ProcessorKey), undecided(ProcessorKey)).
processor_undecided(none, outside).

outside_fact_state(Profile, OutsideFactState) :-
    key_state(Profile, not_in_any_way_responsible_for_the_event, OutsideFactState).

compensation_liability(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_compensation_and_liability_input_problems(Profile, [Problem|Problems]).
compensation_liability(Profile, right_not_established, [], [cite(eu_reg_2016_679_art_82_1)]) :-
    implements(eu_reg_2016_679_art_82_1),
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_summary(Profile, some_false).
compensation_liability(Profile, indeterminate([JudgementKey]), [], []) :-
    implements(eu_reg_2016_679_art_82_1),
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_summary(Profile, judgement_absent(JudgementKey)).
compensation_liability(Profile, indeterminate([LimbKey]), [], []) :-
    implements(eu_reg_2016_679_art_82_2),
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_summary(Profile, Summary),
    position_readable(Summary),
    caller_position(Profile, undecided(LimbKey)).
compensation_liability(Profile, not_liable_for_damage, [], [cite(eu_reg_2016_679_art_82_2)]) :-
    implements(eu_reg_2016_679_art_82_2),
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_summary(Profile, all_true),
    caller_position(Profile, outside).
compensation_liability(Profile, needs_legal_review(open_textured(JudgementKey, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on(JudgementPairs)]), [], []) :-
    implements(eu_reg_2016_679_art_82_1),
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_summary(Profile, judgement_unsure(JudgementKey)),
    caller_position(Profile, outside),
    judgement_pairs(Profile, JudgementPairs).
compensation_liability(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on(ReliedPairs)]), [], []) :-
    implements(eu_reg_2016_679_art_82_3),
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_summary(Profile, Summary),
    position_readable(Summary),
    caller_position(Profile, inside),
    outside_fact_state(Profile, absent),
    judgement_pairs(Profile, JudgementPairs),
    append(JudgementPairs, [not_in_any_way_responsible_for_the_event - absent], ReliedPairs).
compensation_liability(Profile, needs_legal_review(open_textured(JudgementKey, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on(JudgementPairs)]), [], []) :-
    implements(eu_reg_2016_679_art_82_1),
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_summary(Profile, judgement_unsure(JudgementKey)),
    caller_position(Profile, inside),
    outside_fact_state(Profile, present(_)),
    judgement_pairs(Profile, JudgementPairs).
compensation_liability(Profile, exempt_from_liability, [outside_fact(not_in_any_way_responsible_for_the_event, Attested)], [cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]) :-
    implements(eu_reg_2016_679_art_82_3),
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_summary(Profile, all_true),
    caller_position(Profile, inside),
    outside_fact_state(Profile, present(Attested)),
    Attested = attested(true, _).
compensation_liability(Profile, liable_for_damage, [outside_fact(not_in_any_way_responsible_for_the_event, Attested)], [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]) :-
    implements(eu_reg_2016_679_art_82_1),
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_summary(Profile, all_true),
    caller_position(Profile, inside),
    outside_fact_state(Profile, present(Attested)),
    Attested = attested(false, _).

decide_gdpr_compensation_and_liability(Profile, gdpr_compensation_and_liability_verdict(Result, Citations)) :-
    compensation_liability(Profile, Result, _Basis, Citations).

gdpr_compensation_and_liability_status(Profile, Status) :-
    decide_gdpr_compensation_and_liability(Profile, gdpr_compensation_and_liability_verdict(Status, _Citations)).

gdpr_compensation_and_liability_decision_resolvable(Profile) :-
    decide_gdpr_compensation_and_liability(Profile, _Verdict).

gdpr_compensation_and_liability_checklist(Profile, [item(damage_suffered, DamageStatus, cite(eu_reg_2016_679_art_82_1)), item(infringement_of_the_regulation_occurred, InfringementStatus, cite(eu_reg_2016_679_art_82_1)), item(damage_resulted_from_the_infringement, CausationStatus, cite(eu_reg_2016_679_art_82_1)), item(liability_limb_of_article_82_2, LimbStatus, cite(eu_reg_2016_679_art_82_2)), item(no_exemption_under_article_82_3, ExemptionStatus, cite(eu_reg_2016_679_art_82_3))]) :-
    gdpr_compensation_and_liability_input_problems(Profile, []),
    judgement_requirement(Profile, damage_suffered, damage_not_suffered, DamageStatus),
    judgement_requirement(Profile, infringement_of_the_regulation_occurred, no_infringement, InfringementStatus),
    judgement_requirement(Profile, damage_resulted_from_the_infringement, damage_not_resulting_from_the_infringement, CausationStatus),
    limb_requirement(Profile, LimbStatus),
    exemption_requirement(Profile, ExemptionStatus).

judgement_requirement(Profile, JudgementKey, Reason, Status) :-
    implements(eu_reg_2016_679_art_82_1),
    key_state(Profile, JudgementKey, KeyState),
    judgement_item_status(KeyState, JudgementKey, Reason, Status).

judgement_item_status(present(true), _, _, met).
judgement_item_status(present(false), _, Reason, unmet(Reason)).
judgement_item_status(present(unsure), JudgementKey, _, unknown([JudgementKey])).
judgement_item_status(absent, JudgementKey, _, unknown([JudgementKey])).

limb_requirement(Profile, Status) :-
    implements(eu_reg_2016_679_art_82_2),
    caller_position(Profile, Position),
    limb_item_status(Position, Status).

limb_item_status(inside, met).
limb_item_status(outside, unmet(outside_article_82_2)).
limb_item_status(undecided(LimbKey), unknown([LimbKey])).

exemption_requirement(Profile, Status) :-
    implements(eu_reg_2016_679_art_82_3),
    outside_fact_state(Profile, OutsideFactState),
    exemption_item_status(OutsideFactState, Status).

exemption_item_status(absent, unknown([not_in_any_way_responsible_for_the_event])).
exemption_item_status(present(attested(false, _)), met).
exemption_item_status(present(attested(true, _)), unmet(exempt_on_attested_statement)).

test(the_deferred_provisions_are_recorded) :-
    findall(Citation, deferred_provision(Citation, _Deferral), Citations),
    Citations == [cite(eu_reg_2016_679_art_82_4), cite(eu_reg_2016_679_art_82_5), cite(eu_reg_2016_679_art_82_6)].
test(a_false_damage_judgement_alone_is_right_not_established) :-
    compensation_liability([attribute(damage_suffered, false)], right_not_established, [], [cite(eu_reg_2016_679_art_82_1)]).
test(a_false_infringement_beats_an_absent_damage) :-
    compensation_liability([attribute(infringement_of_the_regulation_occurred, false)], right_not_established, [], _).
test(a_false_causation_beats_an_outside_processor) :-
    compensation_liability([attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, false), attribute(processor_acted_outside_or_contrary_to_lawful_instructions, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, false)], right_not_established, [], _).
test(an_empty_profile_names_damage_suffered) :-
    compensation_liability([], indeterminate([damage_suffered]), [], []).
test(the_first_absent_judgement_is_named) :-
    compensation_liability([attribute(damage_suffered, true), attribute(damage_resulted_from_the_infringement, unsure)], indeterminate([infringement_of_the_regulation_occurred]), [], []).
test(an_absent_role_is_named) :-
    compensation_liability([attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)], indeterminate([party_role]), [], []).
test(a_controller_without_involvement_names_it) :-
    compensation_liability([attribute(party_role, controller), attribute(processor_breached_obligations_directed_to_processors, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, unsure), attribute(damage_resulted_from_the_infringement, true)], indeterminate([involved_in_the_processing]), [], []).
test(a_processor_with_one_false_ground_names_the_other) :-
    compensation_liability([attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)], indeterminate([processor_acted_outside_or_contrary_to_lawful_instructions]), [], []).
test(a_processor_with_one_true_ground_needs_not_the_other) :-
    compensation_liability([attribute(party_role, processor), attribute(processor_acted_outside_or_contrary_to_lawful_instructions, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, none)))], liable_for_damage, [outside_fact(not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, none)))], _).
test(an_uninvolved_controller_is_not_liable) :-
    compensation_liability([attribute(party_role, controller), attribute(involved_in_the_processing, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)], not_liable_for_damage, [], [cite(eu_reg_2016_679_art_82_2)]).
test(an_uninvolved_controller_with_an_unsure_judgement_is_referred) :-
    compensation_liability([attribute(party_role, controller), attribute(involved_in_the_processing, false), attribute(damage_suffered, unsure), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, unsure)], needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - unsure])]), [], []).
test(an_absent_statement_refers_before_an_unsure_judgement) :-
    compensation_liability([attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, unsure), attribute(damage_resulted_from_the_infringement, true)], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - unsure, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])]), [], []).
test(a_present_statement_with_an_unsure_judgement_is_referred) :-
    compensation_liability([attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, unsure), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, none)))], needs_legal_review(open_textured(infringement_of_the_regulation_occurred, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - unsure, damage_resulted_from_the_infringement - true])]), [], []).
test(an_attested_true_statement_exempts) :-
    compensation_liability([attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(true, attestation(host, at, reason, url(address, retrieved))))], exempt_from_liability, [outside_fact(not_in_any_way_responsible_for_the_event, attested(true, attestation(host, at, reason, url(address, retrieved))))], [cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
test(an_attested_false_statement_is_liable) :-
    compensation_liability([attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, none)))], liable_for_damage, _, [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
test(an_unknown_key_is_an_input_problem) :-
    compensation_liability([attribute(colour, blue)], input_problems([unknown_key(colour)]), [], []).
test(each_profile_has_exactly_one_answer) :-
    findall(Result - Basis - Citations, compensation_liability([attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, true), attribute(processor_acted_outside_or_contrary_to_lawful_instructions, true), attribute(damage_suffered, false), attribute(infringement_of_the_regulation_occurred, false)], Result, Basis, Citations), Answers),
    length(Answers, 1).
test(the_status_projection_reads_the_result) :-
    gdpr_compensation_and_liability_status([attribute(damage_suffered, false)], right_not_established).
test(the_checklist_cites_each_ground) :-
    gdpr_compensation_and_liability_checklist([attribute(party_role, controller), attribute(involved_in_the_processing, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, unsure)], [item(damage_suffered, met, cite(eu_reg_2016_679_art_82_1)), item(infringement_of_the_regulation_occurred, unknown([infringement_of_the_regulation_occurred]), cite(eu_reg_2016_679_art_82_1)), item(damage_resulted_from_the_infringement, unknown([damage_resulted_from_the_infringement]), cite(eu_reg_2016_679_art_82_1)), item(liability_limb_of_article_82_2, unmet(outside_article_82_2), cite(eu_reg_2016_679_art_82_2)), item(no_exemption_under_article_82_3, unknown([not_in_any_way_responsible_for_the_event]), cite(eu_reg_2016_679_art_82_3))]).

test(a_deferred_provision_is_never_a_liability_citation, fail) :-
    deferred_provision(cite(eu_reg_2016_679_art_82_1), _Deferral).
test(a_false_causation_is_not_not_liable, fail) :-
    compensation_liability([attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, false), attribute(processor_acted_outside_or_contrary_to_lawful_instructions, false), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, false)], not_liable_for_damage, _, _).
test(an_uninvolved_controller_with_an_unsure_judgement_is_not_not_liable, fail) :-
    compensation_liability([attribute(party_role, controller), attribute(involved_in_the_processing, false), attribute(damage_suffered, unsure), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)], not_liable_for_damage, _, _).
test(an_attested_true_statement_is_not_liable_for_damage, fail) :-
    compensation_liability([attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(true, attestation(host, at, reason, none)))], liable_for_damage, _, _).
test(a_profile_with_an_input_problem_gets_no_final_answer, fail) :-
    compensation_liability([attribute(colour, blue), attribute(damage_suffered, false)], right_not_established, _, _).
