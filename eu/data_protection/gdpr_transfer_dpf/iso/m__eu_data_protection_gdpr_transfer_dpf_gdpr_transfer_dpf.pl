% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_gdpr_transfer_dpf, [data_privacy_framework_adequacy/4, decide_gdpr_transfer_dpf/2, gdpr_transfer_dpf_status/2, gdpr_transfer_dpf_checklist/2, gdpr_transfer_dpf_decision_resolvable/1, gdpr_transfer_dpf_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_kernel, [gdpr_transfer_dpf_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_citations, [implements/1]).

gdpr_transfer_dpf_status_values([covered_by_data_privacy_framework_adequacy, not_covered_by_data_privacy_framework_adequacy]).

adequacy_condition(transfer_from_union, crisp, cite(eu_dec_2023_1795_art_1)).
adequacy_condition(recipient_is_organisation_in_united_states, crisp, cite(eu_dec_2023_1795_art_1)).
adequacy_condition(data_privacy_framework_decision_in_force, outside_fact, cite(eu_dec_2023_1795_art_1)).
adequacy_condition(recipient_on_data_privacy_framework_list, outside_fact, cite(eu_dec_2023_1795_art_1)).
adequacy_condition(certification_covers_transferred_data, outside_fact, cite(eu_dec_2023_1795_art_1)).

outside_fact_referral(data_privacy_framework_decision_in_force, cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_decision_in_force_statement)).
outside_fact_referral(recipient_on_data_privacy_framework_list, cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_list_entry_statement)).
outside_fact_referral(certification_covers_transferred_data, cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_certification_coverage_statement)).

data_privacy_framework_adequacy(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_transfer_dpf_input_problems(Profile, [Problem|Problems]).
data_privacy_framework_adequacy(Profile, Result, Basis, Citations) :-
    gdpr_transfer_dpf_input_problems(Profile, []),
    profile_conditions(Profile, CrispConditions, OutsideConditions),
    adequacy_answer(CrispConditions, OutsideConditions, Result, Basis, Citations).

profile_conditions(Profile, [UnionCondition, OrganisationCondition], [ForceCondition, ListCondition, CoverageCondition]) :-
    crisp_condition(Profile, transfer_from_union, UnionCondition),
    crisp_condition(Profile, recipient_is_organisation_in_united_states, OrganisationCondition),
    outside_condition(Profile, data_privacy_framework_decision_in_force, ForceCondition),
    outside_condition(Profile, recipient_on_data_privacy_framework_list, ListCondition),
    outside_condition(Profile, certification_covers_transferred_data, CoverageCondition).

crisp_condition(Profile, ConditionKey, condition(ConditionKey, absent)) :-
    implements(eu_dec_2023_1795_art_1),
    adequacy_condition(ConditionKey, crisp, _),
    profile_lacks(Profile, ConditionKey).
crisp_condition(Profile, ConditionKey, condition(ConditionKey, State)) :-
    implements(eu_dec_2023_1795_art_1),
    adequacy_condition(ConditionKey, crisp, _),
    profile_get(Profile, ConditionKey, Value),
    crisp_state(Value, State).

crisp_state(true, holds([])).
crisp_state(false, fails([])).

outside_condition(Profile, ConditionKey, condition(ConditionKey, absent)) :-
    implements(eu_dec_2023_1795_art_1),
    adequacy_condition(ConditionKey, outside_fact, _),
    profile_lacks(Profile, ConditionKey).
outside_condition(Profile, ConditionKey, condition(ConditionKey, State)) :-
    implements(eu_dec_2023_1795_art_1),
    adequacy_condition(ConditionKey, outside_fact, _),
    profile_get(Profile, ConditionKey, Attested),
    Attested = attested(Value, _),
    outside_state(Value, ConditionKey, Attested, State).

outside_state(true, ConditionKey, Attested, holds([outside_fact(ConditionKey, Attested)])).
outside_state(false, ConditionKey, Attested, fails([outside_fact(ConditionKey, Attested)])).

adequacy_answer(CrispConditions, OutsideConditions, not_covered_by_data_privacy_framework_adequacy, Basis, [cite(eu_dec_2023_1795_art_1)]) :-
    implements(eu_dec_2023_1795_art_1),
    append(CrispConditions, OutsideConditions, AllConditions),
    any_fails_t(AllConditions, true),
    failed_basis(OutsideConditions, Basis).
adequacy_answer(CrispConditions, OutsideConditions, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([ConditionKey - absent])]), [], []) :-
    implements(eu_dec_2023_1795_art_1),
    append(CrispConditions, OutsideConditions, AllConditions),
    any_fails_t(AllConditions, false),
    first_absent(OutsideConditions, first(ConditionKey)),
    outside_fact_referral(ConditionKey, Citation, Target).
adequacy_answer(CrispConditions, OutsideConditions, indeterminate([ConditionKey]), [], []) :-
    implements(eu_dec_2023_1795_art_1),
    append(CrispConditions, OutsideConditions, AllConditions),
    any_fails_t(AllConditions, false),
    first_absent(OutsideConditions, none_absent),
    first_absent(CrispConditions, first(ConditionKey)).
adequacy_answer(CrispConditions, OutsideConditions, covered_by_data_privacy_framework_adequacy, Basis, [cite(eu_dec_2023_1795_art_1), cite(eu_reg_2016_679_art_45_1)]) :-
    implements(eu_dec_2023_1795_art_1),
    implements(eu_reg_2016_679_art_45_1),
    append(CrispConditions, OutsideConditions, AllConditions),
    any_fails_t(AllConditions, false),
    first_absent(OutsideConditions, none_absent),
    first_absent(CrispConditions, none_absent),
    held_basis(OutsideConditions, Basis).

any_fails_t([], false).
any_fails_t([condition(_, fails(_))|_], true).
any_fails_t([condition(_, holds(_))|Remaining], Truth) :-
    any_fails_t(Remaining, Truth).
any_fails_t([condition(_, absent)|Remaining], Truth) :-
    any_fails_t(Remaining, Truth).

first_absent([], none_absent).
first_absent([condition(ConditionKey, absent)|_], first(ConditionKey)).
first_absent([condition(_, holds(_))|Remaining], Outcome) :-
    first_absent(Remaining, Outcome).
first_absent([condition(_, fails(_))|Remaining], Outcome) :-
    first_absent(Remaining, Outcome).

failed_basis([], []).
failed_basis([condition(_, fails(Items))|Remaining], Basis) :-
    failed_basis(Remaining, RemainingBasis),
    append(Items, RemainingBasis, Basis).
failed_basis([condition(_, holds(_))|Remaining], Basis) :-
    failed_basis(Remaining, Basis).
failed_basis([condition(_, absent)|Remaining], Basis) :-
    failed_basis(Remaining, Basis).

held_basis([], []).
held_basis([condition(_, holds(Items))|Remaining], Basis) :-
    held_basis(Remaining, RemainingBasis),
    append(Items, RemainingBasis, Basis).
held_basis([condition(_, fails(_))|Remaining], Basis) :-
    held_basis(Remaining, Basis).
held_basis([condition(_, absent)|Remaining], Basis) :-
    held_basis(Remaining, Basis).

decide_gdpr_transfer_dpf(Profile, gdpr_transfer_dpf_verdict(Result, Citations)) :-
    data_privacy_framework_adequacy(Profile, Result, _Basis, Citations).

gdpr_transfer_dpf_status(Profile, Status) :-
    decide_gdpr_transfer_dpf(Profile, gdpr_transfer_dpf_verdict(Status, _Citations)).

gdpr_transfer_dpf_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_dec_2023_1795_art_1))]) :-
    gdpr_transfer_dpf_input_problems(Profile, [Problem|Problems]).
gdpr_transfer_dpf_checklist(Profile, Checklist) :-
    gdpr_transfer_dpf_input_problems(Profile, []),
    profile_conditions(Profile, CrispConditions, OutsideConditions),
    append(CrispConditions, OutsideConditions, AllConditions),
    condition_items(AllConditions, Checklist).

condition_items([], []).
condition_items([Condition|Remaining], [Item|Items]) :-
    condition_item(Condition, Item),
    condition_items(Remaining, Items).

condition_item(condition(ConditionKey, holds(_)), item(ConditionKey, met, Citation)) :-
    implements(eu_dec_2023_1795_art_1),
    adequacy_condition(ConditionKey, _, Citation).
condition_item(condition(ConditionKey, fails(_)), item(ConditionKey, unmet(condition_fails), Citation)) :-
    implements(eu_dec_2023_1795_art_1),
    adequacy_condition(ConditionKey, _, Citation).
condition_item(condition(ConditionKey, absent), item(ConditionKey, unknown([ConditionKey]), Citation)) :-
    implements(eu_dec_2023_1795_art_1),
    adequacy_condition(ConditionKey, _, Citation).

gdpr_transfer_dpf_decision_resolvable(Profile) :-
    decide_gdpr_transfer_dpf(Profile, _Verdict).

test(all_five_hold_is_covered) :-
    Attested = attested(true, attestation(by, at, reason, none)),
    findall(Result - Basis - Citations, data_privacy_framework_adequacy([attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Attested), attribute(recipient_on_data_privacy_framework_list, Attested), attribute(certification_covers_transferred_data, Attested)], Result, Basis, Citations), Answers),
    Answers == [covered_by_data_privacy_framework_adequacy - [outside_fact(data_privacy_framework_decision_in_force, Attested), outside_fact(recipient_on_data_privacy_framework_list, Attested), outside_fact(certification_covers_transferred_data, Attested)] - [cite(eu_dec_2023_1795_art_1), cite(eu_reg_2016_679_art_45_1)]].
test(a_crisp_false_key_decides_with_empty_basis) :-
    findall(Result - Basis - Citations, data_privacy_framework_adequacy([attribute(transfer_from_union, false)], Result, Basis, Citations), Answers),
    Answers == [not_covered_by_data_privacy_framework_adequacy - [] - [cite(eu_dec_2023_1795_art_1)]].
test(every_outside_fact_stated_false_is_in_the_basis) :-
    False = attested(false, attestation(by, at, reason, none)),
    True = attested(true, attestation(by, at, reason, none)),
    findall(Result - Basis, data_privacy_framework_adequacy([attribute(data_privacy_framework_decision_in_force, False), attribute(recipient_on_data_privacy_framework_list, True), attribute(certification_covers_transferred_data, False)], Result, Basis, _), Answers),
    Answers == [not_covered_by_data_privacy_framework_adequacy - [outside_fact(data_privacy_framework_decision_in_force, False), outside_fact(certification_covers_transferred_data, False)]].
test(an_absent_outside_fact_is_referred_before_a_missing_crisp_key) :-
    findall(Result - Basis - Citations, data_privacy_framework_adequacy([], Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_decision_in_force_statement)), [resolution(cite(data_privacy_framework_decision_in_force_statement), not_attempted), inputs_relied_on([data_privacy_framework_decision_in_force - absent])]) - [] - []].
test(the_first_absent_outside_fact_in_order_is_referred) :-
    True = attested(true, attestation(by, at, reason, none)),
    data_privacy_framework_adequacy([attribute(data_privacy_framework_decision_in_force, True)], needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_list_entry_statement)), [resolution(cite(data_privacy_framework_list_entry_statement), not_attempted), inputs_relied_on([recipient_on_data_privacy_framework_list - absent])]), [], []).
test(a_missing_crisp_key_is_named_once_outside_facts_are_true) :-
    True = attested(true, attestation(by, at, reason, none)),
    findall(Result, data_privacy_framework_adequacy([attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, True), attribute(recipient_on_data_privacy_framework_list, True), attribute(certification_covers_transferred_data, True)], Result, _, _), Results),
    Results == [indeterminate([transfer_from_union])].
test(input_problems_come_first) :-
    findall(Result - Basis - Citations, data_privacy_framework_adequacy([attribute(transfer_from_union, false), attribute(colour, red)], Result, Basis, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - [] - []].
test(an_unbound_profile_is_an_input_problem) :-
    data_privacy_framework_adequacy(_, input_problems([wrong_type(profile)]), [], []).
test(the_verdict_projection) :-
    gdpr_transfer_dpf_status([attribute(recipient_is_organisation_in_united_states, false)], not_covered_by_data_privacy_framework_adequacy).
test(the_checklist_names_each_condition) :-
    False = attested(false, attestation(by, at, reason, none)),
    gdpr_transfer_dpf_checklist([attribute(transfer_from_union, true), attribute(recipient_on_data_privacy_framework_list, False)], [item(transfer_from_union, met, cite(eu_dec_2023_1795_art_1)), item(recipient_is_organisation_in_united_states, unknown([recipient_is_organisation_in_united_states]), cite(eu_dec_2023_1795_art_1)), item(data_privacy_framework_decision_in_force, unknown([data_privacy_framework_decision_in_force]), cite(eu_dec_2023_1795_art_1)), item(recipient_on_data_privacy_framework_list, unmet(condition_fails), cite(eu_dec_2023_1795_art_1)), item(certification_covers_transferred_data, unknown([certification_covers_transferred_data]), cite(eu_dec_2023_1795_art_1))]).

test(a_crisp_false_key_is_not_covered_rather_than_covered, fail) :-
    data_privacy_framework_adequacy([attribute(transfer_from_union, false)], covered_by_data_privacy_framework_adequacy, _, _).
