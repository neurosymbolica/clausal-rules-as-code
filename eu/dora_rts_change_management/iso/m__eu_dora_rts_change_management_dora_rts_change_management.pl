% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_change_management_dora_rts_change_management, [ict_change_management_duties_required/3, ict_change_management_duties_complete/3, ict_change_management_duties_outstanding/3, decide_dora_rts_change_management/2, dora_rts_change_management_status/2, dora_rts_change_management_checklist/2, dora_rts_change_management_decision_resolvable/1, dora_rts_change_management_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_rts_change_management_kernel, [dora_rts_change_management_input_problems/2]).
:- use_module(m__eu_dora_rts_change_management_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_change_management_status_values([complete, incomplete, simplified_framework_entity]).

duty_order([verification_of_ict_security_requirements, independence_of_change_approval_functions, roles_for_specifying_and_planning_changes, roles_for_designing_the_transition, roles_for_controlled_testing_and_finalisation, roles_for_quality_assurance, documentation_of_purpose_and_scope_of_change, documentation_of_implementation_timeline, documentation_of_expected_outcomes, fall_back_procedures_and_responsibilities, management_of_emergency_changes, review_of_emergency_changes_after_implementation, impact_of_change_on_ict_security_measures, stringent_testing_after_significant_changes, central_counterparty_involvement_of_parties_in_testing, central_securities_depository_involvement_of_parties_in_testing]).

duty(verification_of_ict_security_requirements, change_procedures_verify_whether_ict_security_requirements_met, cite(eu_reg_2024_1774_art_17_1), []).
duty(independence_of_change_approval_functions, change_procedures_ensure_independence_of_approving_functions, cite(eu_reg_2024_1774_art_17_1), []).
duty(roles_for_specifying_and_planning_changes, change_roles_described_for_specifying_and_planning, cite(eu_reg_2024_1774_art_17_1), []).
duty(roles_for_designing_the_transition, change_roles_described_for_designing_adequate_transition, cite(eu_reg_2024_1774_art_17_1), []).
duty(roles_for_controlled_testing_and_finalisation, change_roles_described_for_controlled_testing_and_finalisation, cite(eu_reg_2024_1774_art_17_1), []).
duty(roles_for_quality_assurance, change_roles_described_for_effective_quality_assurance, cite(eu_reg_2024_1774_art_17_1), []).
duty(documentation_of_purpose_and_scope_of_change, change_purpose_and_scope_documented_and_communicated, cite(eu_reg_2024_1774_art_17_1), []).
duty(documentation_of_implementation_timeline, change_implementation_timeline_documented_and_communicated, cite(eu_reg_2024_1774_art_17_1), []).
duty(documentation_of_expected_outcomes, change_expected_outcomes_documented_and_communicated, cite(eu_reg_2024_1774_art_17_1), []).
duty(fall_back_procedures_and_responsibilities, change_fall_back_procedures_and_responsibilities_identified, cite(eu_reg_2024_1774_art_17_1), []).
duty(management_of_emergency_changes, emergency_change_procedures_protocols_and_tools_provide_adequate_safeguards, cite(eu_reg_2024_1774_art_17_1), []).
duty(review_of_emergency_changes_after_implementation, emergency_changes_documented_reevaluated_assessed_and_approved_after_implementation, cite(eu_reg_2024_1774_art_17_1), []).
duty(impact_of_change_on_ict_security_measures, change_impact_on_ict_security_measures_identified_and_assessed, cite(eu_reg_2024_1774_art_17_1), []).
duty(stringent_testing_after_significant_changes, ict_systems_submitted_to_stringent_testing_simulating_stressed_conditions, cite(eu_reg_2024_1774_art_17_2), [condition(dora_entity_type, [central_counterparty, central_securities_depository]), condition(significant_changes_made_to_ict_systems, [true])]).
duty(central_counterparty_involvement_of_parties_in_testing, clearing_members_clients_and_other_parties_involved_in_testing, cite(eu_reg_2024_1774_art_17_2), [condition(dora_entity_type, [central_counterparty]), condition(significant_changes_made_to_ict_systems, [true])]).
duty(central_securities_depository_involvement_of_parties_in_testing, users_service_providers_and_other_parties_involved_in_testing, cite(eu_reg_2024_1774_art_17_2), [condition(dora_entity_type, [central_securities_depository]), condition(significant_changes_made_to_ict_systems, [true])]).

referral(verification_of_ict_security_requirements_unclear, open_textured, change_procedures_verify_whether_ict_security_requirements_met, cite(eu_reg_2024_1774_art_17_1)).
referral(independence_of_change_approval_functions_unclear, open_textured, change_procedures_ensure_independence_of_approving_functions, cite(eu_reg_2024_1774_art_17_1)).
referral(roles_for_specifying_and_planning_changes_unclear, open_textured, change_roles_described_for_specifying_and_planning, cite(eu_reg_2024_1774_art_17_1)).
referral(roles_for_designing_the_transition_unclear, open_textured, change_roles_described_for_designing_adequate_transition, cite(eu_reg_2024_1774_art_17_1)).
referral(roles_for_controlled_testing_and_finalisation_unclear, open_textured, change_roles_described_for_controlled_testing_and_finalisation, cite(eu_reg_2024_1774_art_17_1)).
referral(roles_for_quality_assurance_unclear, open_textured, change_roles_described_for_effective_quality_assurance, cite(eu_reg_2024_1774_art_17_1)).
referral(documentation_of_purpose_and_scope_of_change_unclear, open_textured, change_purpose_and_scope_documented_and_communicated, cite(eu_reg_2024_1774_art_17_1)).
referral(documentation_of_implementation_timeline_unclear, open_textured, change_implementation_timeline_documented_and_communicated, cite(eu_reg_2024_1774_art_17_1)).
referral(documentation_of_expected_outcomes_unclear, open_textured, change_expected_outcomes_documented_and_communicated, cite(eu_reg_2024_1774_art_17_1)).
referral(fall_back_procedures_and_responsibilities_unclear, open_textured, change_fall_back_procedures_and_responsibilities_identified, cite(eu_reg_2024_1774_art_17_1)).
referral(management_of_emergency_changes_unclear, open_textured, emergency_change_procedures_protocols_and_tools_provide_adequate_safeguards, cite(eu_reg_2024_1774_art_17_1)).
referral(review_of_emergency_changes_after_implementation_unclear, open_textured, emergency_changes_documented_reevaluated_assessed_and_approved_after_implementation, cite(eu_reg_2024_1774_art_17_1)).
referral(impact_of_change_on_ict_security_measures_unclear, open_textured, change_impact_on_ict_security_measures_identified_and_assessed, cite(eu_reg_2024_1774_art_17_1)).
referral(stringent_testing_after_significant_changes_unclear, open_textured, ict_systems_submitted_to_stringent_testing_simulating_stressed_conditions, cite(eu_reg_2024_1774_art_17_2)).
referral(central_counterparty_involvement_of_parties_in_testing_unclear, open_textured, clearing_members_clients_and_other_parties_involved_in_testing, cite(eu_reg_2024_1774_art_17_2)).
referral(central_securities_depository_involvement_of_parties_in_testing_unclear, open_textured, users_service_providers_and_other_parties_involved_in_testing, cite(eu_reg_2024_1774_art_17_2)).

conditional_keys([dora_entity_type, significant_changes_made_to_ict_systems]).

key_domain(dora_entity_type, [credit_institution, institution_exempted_pursuant_to_directive_2013_36, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty, trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider, insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary, institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types]).
key_domain(significant_changes_made_to_ict_systems, [true, false]).

duty_profile_key(DutyAtom, ProfileKey) :-
    duty(DutyAtom, ProfileKey, _, _).

duty_keys(DutyKeys) :-
    duty_order(Duties),
    maplist(duty_profile_key, Duties, DutyKeys).

query_keys(QueryKeys) :-
    conditional_keys(ConditionKeys),
    duty_keys(DutyKeys),
    append(ConditionKeys, DutyKeys, QueryKeys).

root_keys([financial_entity_is_article_16_1_entity|QueryKeys]) :-
    query_keys(QueryKeys).

key_kind(ProfileKey, condition(ProfileKey)) :-
    key_domain(ProfileKey, _).
key_kind(ProfileKey, duty(DutyAtom)) :-
    duty(DutyAtom, ProfileKey, _, _).

key_value(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_value(Profile, ProfileKey, given(Value)) :-
    profile_get(Profile, ProfileKey, Value).

found_absent_t(absent, true).
found_absent_t(given(_), false).

found_value_t(absent, _, false).
found_value_t(given(Value), Wanted, Truth) :-
    memberd_t(Value, [Wanted], Truth).

found_not_true_t(Found, Truth) :-
    found_value_t(Found, true, IsTrue),
    truth_not(IsTrue, Truth).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

truth_not(true, false).
truth_not(false, true).

different_t(Left, Right, Truth) :-
    memberd_t(Left, [Right], IsSame),
    truth_not(IsSame, Truth).

some_t(_, [], false).
some_t(TestGoal, [Element|Elements], Truth) :-
    call(TestGoal, Element, FirstTruth),
    some_t(TestGoal, Elements, LaterTruth),
    truth_or(FirstTruth, LaterTruth, Truth).

every_t(_, [], true).
every_t(TestGoal, [Element|Elements], Truth) :-
    call(TestGoal, Element, FirstTruth),
    every_t(TestGoal, Elements, LaterTruth),
    truth_and(FirstTruth, LaterTruth, Truth).

keep_true(_, [], []).
keep_true(TestGoal, [Element|Elements], KeptElements) :-
    call(TestGoal, Element, Truth),
    keep_true(TestGoal, Elements, LaterElements),
    keep_if(Truth, Element, LaterElements, KeptElements).

keep_if(true, Element, LaterElements, [Element|LaterElements]).
keep_if(false, _, LaterElements, LaterElements).

first_key([], _, none).
first_key([ProfileKey|ProfileKeys], TestGoal, Selected) :-
    call(TestGoal, ProfileKey, Truth),
    first_key_after(Truth, ProfileKey, ProfileKeys, TestGoal, Selected).

first_key_after(true, ProfileKey, _, _, key(ProfileKey)).
first_key_after(false, _, ProfileKeys, TestGoal, Selected) :-
    first_key(ProfileKeys, TestGoal, Selected).

condition_state(Profile, condition(ConditionKey, Values), State) :-
    implements(eu_reg_2024_1774_art_17_2),
    key_value(Profile, ConditionKey, Found),
    found_condition_state(Found, Values, State).

found_condition_state(absent, _, open).
found_condition_state(given(Value), Values, State) :-
    memberd_t(Value, Values, Truth),
    truth_condition_state(Truth, State).

truth_condition_state(true, holds).
truth_condition_state(false, fails).

condition_holds_t(Profile, Condition, Truth) :-
    condition_state(Profile, Condition, State),
    state_holds_t(State, Truth).

state_holds_t(holds, true).
state_holds_t(open, false).
state_holds_t(fails, false).

condition_open_t(Profile, Condition, Truth) :-
    condition_state(Profile, Condition, State),
    state_open_condition_t(State, Truth).

state_open_condition_t(holds, false).
state_open_condition_t(open, true).
state_open_condition_t(fails, false).

conditions_state(_, [], applies).
conditions_state(Profile, [Condition|Conditions], State) :-
    implements(eu_reg_2024_1774_art_17_2),
    condition_state(Profile, Condition, FirstState),
    conditions_state(Profile, Conditions, LaterState),
    combined_state(FirstState, LaterState, State).

combined_state(holds, LaterState, LaterState).
combined_state(open, applies, pending).
combined_state(open, pending, pending).
combined_state(open, fails, fails).
combined_state(fails, _, fails).

condition_on([], _, none).
condition_on([condition(ConditionKey, Values)|Conditions], WantedKey, OnKey) :-
    memberd_t(ConditionKey, [WantedKey], IsWanted),
    condition_on_found(IsWanted, Values, Conditions, WantedKey, OnKey).

condition_on_found(true, Values, _, _, values(Values)).
condition_on_found(false, _, Conditions, WantedKey, OnKey) :-
    condition_on(Conditions, WantedKey, OnKey).

on_key_present_t(none, false).
on_key_present_t(values(_), true).

on_key_allows_t(none, _, true).
on_key_allows_t(values(Values), OtherValue, Truth) :-
    memberd_t(OtherValue, Values, Truth).

other_conditions([], _, []).
other_conditions([condition(ConditionKey, Values)|Conditions], ExcludedKey, Remaining) :-
    memberd_t(ConditionKey, [ExcludedKey], IsExcluded),
    other_conditions(Conditions, ExcludedKey, LaterConditions),
    keep_condition(IsExcluded, condition(ConditionKey, Values), LaterConditions, Remaining).

keep_condition(true, _, LaterConditions, LaterConditions).
keep_condition(false, Condition, LaterConditions, [Condition|LaterConditions]).

condition_key(condition(ConditionKey, _), ConditionKey).

duty_state(Profile, DutyAtom, State) :-
    implements(eu_reg_2024_1774_art_17_1),
    duty(DutyAtom, _, _, Conditions),
    conditions_state(Profile, Conditions, State).

state_applies_t(applies, true).
state_applies_t(pending, false).
state_applies_t(fails, false).

state_open_t(applies, true).
state_open_t(pending, true).
state_open_t(fails, false).

duty_applies_t(Profile, DutyAtom, Truth) :-
    duty_state(Profile, DutyAtom, State),
    state_applies_t(State, Truth).

duty_open_t(Profile, DutyAtom, Truth) :-
    duty_state(Profile, DutyAtom, State),
    state_open_t(State, Truth).

duty_found(Profile, DutyAtom, Found) :-
    duty(DutyAtom, ProfileKey, _, _),
    key_value(Profile, ProfileKey, Found).

duty_key_false_t(Profile, DutyAtom, Truth) :-
    duty_found(Profile, DutyAtom, Found),
    found_value_t(Found, false, Truth).

duty_key_not_true_t(Profile, DutyAtom, Truth) :-
    duty_found(Profile, DutyAtom, Found),
    found_not_true_t(Found, Truth).

duty_fails_t(Profile, DutyAtom, Truth) :-
    implements(eu_reg_2024_1774_art_17_1),
    duty_applies_t(Profile, DutyAtom, Applies),
    duty_key_false_t(Profile, DutyAtom, IsFalse),
    truth_and(Applies, IsFalse, Truth).

duty_open_not_true_t(Profile, DutyAtom, Truth) :-
    duty_open_t(Profile, DutyAtom, IsOpen),
    duty_key_not_true_t(Profile, DutyAtom, NotTrue),
    truth_and(IsOpen, NotTrue, Truth).

duty_citation(DutyAtom, Citation) :-
    duty(DutyAtom, _, Citation, _).

duty_citations(DutyAtoms, Citations) :-
    maplist(duty_citation, DutyAtoms, Cites),
    sort(Cites, Citations).

covered_t(Profile, DutyConditions, Condition, Truth) :-
    condition_holds_t(Profile, Condition, Holds),
    memberd_t(Condition, DutyConditions, Among),
    truth_or(Holds, Among, Truth).

blocks_t(Profile, DutyAtom, DutyConditions, OtherDuty, Truth) :-
    different_t(OtherDuty, DutyAtom, Different),
    duty_key_false_t(Profile, OtherDuty, OtherFalse),
    duty(OtherDuty, _, _, OtherConditions),
    every_t(covered_t(Profile, DutyConditions), OtherConditions, Covered),
    truth_and(Different, OtherFalse, FirstPair),
    truth_and(FirstPair, Covered, Truth).

duty_key_can_change_t(Profile, DutyAtom, Truth) :-
    implements(eu_reg_2024_1774_art_17_1),
    duty(DutyAtom, _, _, DutyConditions),
    duty_open_t(Profile, DutyAtom, IsOpen),
    duty_order(Duties),
    some_t(blocks_t(Profile, DutyAtom, DutyConditions), Duties, Blocked),
    truth_not(Blocked, Unblocked),
    truth_and(IsOpen, Unblocked, Truth).

condition_key_can_change_t(Profile, ConditionKey, Truth) :-
    implements(eu_reg_2024_1774_art_17_2),
    duty_order(Duties),
    some_t(drives_change_t(Profile, ConditionKey), Duties, Truth).

drives_change_t(Profile, ConditionKey, DutyAtom, Truth) :-
    duty(DutyAtom, _, _, Conditions),
    condition_on(Conditions, ConditionKey, OnKey),
    drives_on(OnKey, Profile, ConditionKey, DutyAtom, Conditions, Truth).

drives_on(none, _, _, _, _, false).
drives_on(values(Values), Profile, ConditionKey, DutyAtom, Conditions, Truth) :-
    duty_open_not_true_t(Profile, DutyAtom, OpenNotTrue),
    key_domain(ConditionKey, Domain),
    some_t(unblocked_other_value_t(Profile, ConditionKey, DutyAtom, Conditions, Values), Domain, Witness),
    truth_and(OpenNotTrue, Witness, Truth).

unblocked_other_value_t(Profile, ConditionKey, DutyAtom, Conditions, Values, OtherValue, Truth) :-
    memberd_t(OtherValue, Values, Holds),
    truth_not(Holds, NotHolds),
    duty_order(Duties),
    some_t(blocks_for_value_t(Profile, ConditionKey, OtherValue, DutyAtom, Conditions), Duties, Blocked),
    truth_not(Blocked, Unblocked),
    truth_and(NotHolds, Unblocked, Truth).

blocks_for_value_t(Profile, ConditionKey, OtherValue, DutyAtom, DutyConditions, OtherDuty, Truth) :-
    different_t(OtherDuty, DutyAtom, Different),
    duty_key_false_t(Profile, OtherDuty, OtherFalse),
    duty(OtherDuty, _, _, OtherConditions),
    condition_on(OtherConditions, ConditionKey, OtherOnKey),
    on_key_allows_t(OtherOnKey, OtherValue, Allows),
    other_conditions(OtherConditions, ConditionKey, Remaining),
    every_t(covered_t(Profile, DutyConditions), Remaining, Covered),
    truth_and(Different, OtherFalse, FirstPair),
    truth_and(Allows, Covered, SecondPair),
    truth_and(FirstPair, SecondPair, Truth).

can_change_t(Profile, ProfileKey, Truth) :-
    key_kind(ProfileKey, KeyKind),
    kind_can_change_t(KeyKind, Profile, Truth).

kind_can_change_t(duty(DutyAtom), Profile, Truth) :-
    duty_key_can_change_t(Profile, DutyAtom, Truth).
kind_can_change_t(condition(ConditionKey), Profile, Truth) :-
    condition_key_can_change_t(Profile, ConditionKey, Truth).

absent_can_change_t(Profile, ProfileKey, Truth) :-
    key_value(Profile, ProfileKey, Found),
    found_absent_t(Found, IsAbsent),
    can_change_t(Profile, ProfileKey, Changes),
    truth_and(IsAbsent, Changes, Truth).

decides_alone_t(Profile, ProfileKey, Truth) :-
    key_kind(ProfileKey, KeyKind),
    kind_decides_alone_t(KeyKind, Profile, Truth).

kind_decides_alone_t(duty(DutyAtom), Profile, Truth) :-
    duty_applies_t(Profile, DutyAtom, Truth).
kind_decides_alone_t(condition(ConditionKey), Profile, Truth) :-
    duty_order(Duties),
    some_t(false_duty_on_key_t(Profile, ConditionKey), Duties, Truth).

false_duty_on_key_t(Profile, ConditionKey, OtherDuty, Truth) :-
    duty_key_false_t(Profile, OtherDuty, OtherFalse),
    duty(OtherDuty, _, _, OtherConditions),
    condition_on(OtherConditions, ConditionKey, OnKey),
    on_key_present_t(OnKey, HasCondition),
    other_conditions(OtherConditions, ConditionKey, Remaining),
    every_t(condition_holds_t(Profile), Remaining, RemainingHold),
    truth_and(OtherFalse, HasCondition, FirstPair),
    truth_and(FirstPair, RemainingHold, Truth).

named_key([ProfileKey|_], _, key(ProfileKey)).
named_key([], [ProfileKey|_], key(ProfileKey)).
named_key([], [], none).

unsure_referable_t(Profile, ProfileKey, Truth) :-
    duty(DutyAtom, ProfileKey, _, _),
    key_value(Profile, ProfileKey, Found),
    found_value_t(Found, unsure, IsUnsure),
    duty_key_can_change_t(Profile, DutyAtom, Changes),
    truth_and(IsUnsure, Changes, Truth).

present_pairs(_, [], []).
present_pairs(Profile, [ProfileKey|ProfileKeys], Pairs) :-
    key_value(Profile, ProfileKey, Found),
    present_pairs(Profile, ProfileKeys, LaterPairs),
    add_pair(Found, ProfileKey, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(given(Value), ProfileKey, Pairs, [ProfileKey - Value|Pairs]).

referral_answer(key(ProfileKey), Profile, needs_legal_review(open_textured(ProfileKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    referral(_, open_textured, ProfileKey, Citation),
    root_keys(RootKeys),
    present_pairs(Profile, RootKeys, Pairs).

ict_change_management_duties_required(Profile, Result, Citations) :-
    dora_rts_change_management_input_problems(Profile, Problems),
    checked_answer(Problems, duties_required, Profile, Result, Citations).

ict_change_management_duties_complete(Profile, Result, Citations) :-
    dora_rts_change_management_input_problems(Profile, Problems),
    checked_answer(Problems, duties_complete, Profile, Result, Citations).

ict_change_management_duties_outstanding(Profile, Result, Citations) :-
    dora_rts_change_management_input_problems(Profile, Problems),
    checked_answer(Problems, duties_outstanding, Profile, Result, Citations).

checked_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
checked_answer([], QueryName, Profile, Result, Citations) :-
    key_value(Profile, financial_entity_is_article_16_1_entity, GateFound),
    gated_answer(GateFound, QueryName, Profile, Result, Citations).

gated_answer(given(true), _, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
gated_answer(absent, _, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
gated_answer(given(false), QueryName, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    article_17_answer(QueryName, Profile, Result, Citations).

article_17_answer(duties_required, Profile, Result, Citations) :-
    implements(eu_reg_2024_1774_art_17_2),
    conditional_keys(ConditionKeys),
    first_key(ConditionKeys, required_missing_key_t(Profile), Selected),
    required_selected(Selected, Profile, Result, Citations).
article_17_answer(duties_complete, Profile, Result, Citations) :-
    implements(eu_reg_2024_1774_art_17_1),
    duty_order(Duties),
    some_t(duty_fails_t(Profile), Duties, AnyFails),
    complete_after_failure(AnyFails, Profile, Result, Citations).
article_17_answer(duties_outstanding, Profile, Result, Citations) :-
    implements(eu_reg_2024_1774_art_17_1),
    query_keys(QueryKeys),
    first_key(QueryKeys, list_missing_key_t(Profile), Selected),
    outstanding_missing(Selected, Profile, Result, Citations).

required_missing_key_t(Profile, ProfileKey, Truth) :-
    key_value(Profile, ProfileKey, Found),
    found_absent_t(Found, IsAbsent),
    carries_open_condition_t(Profile, ProfileKey, Carries),
    truth_and(IsAbsent, Carries, Truth).

carries_open_condition_t(Profile, ConditionKey, Truth) :-
    duty_order(Duties),
    some_t(open_duty_on_key_t(Profile, ConditionKey), Duties, Truth).

open_duty_on_key_t(Profile, ConditionKey, DutyAtom, Truth) :-
    duty(DutyAtom, _, _, Conditions),
    condition_on(Conditions, ConditionKey, OnKey),
    on_key_present_t(OnKey, HasCondition),
    duty_open_t(Profile, DutyAtom, IsOpen),
    truth_and(HasCondition, IsOpen, Truth).

required_selected(key(ProfileKey), _, indeterminate([ProfileKey]), []).
required_selected(none, Profile, required(Applying), Citations) :-
    implements(eu_reg_2024_1774_art_17_1),
    duty_order(Duties),
    keep_true(duty_applies_t(Profile), Duties, Applying),
    duty_citations(Applying, Citations).

complete_after_failure(true, _, incomplete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]) :-
    implements(eu_reg_2024_1774_art_17_1).
complete_after_failure(false, Profile, Result, Citations) :-
    implements(eu_reg_2024_1774_art_17_1),
    duty_order(Duties),
    some_t(duty_open_not_true_t(Profile), Duties, AnyOpenNotTrue),
    complete_after_open(AnyOpenNotTrue, Profile, Result, Citations).

complete_after_open(false, _, complete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]) :-
    implements(eu_reg_2024_1774_art_17_1).
complete_after_open(true, Profile, Result, Citations) :-
    query_keys(QueryKeys),
    keep_true(absent_can_change_t(Profile), QueryKeys, Changers),
    keep_true(decides_alone_t(Profile), Changers, Alone),
    named_key(Alone, Changers, Named),
    complete_missing(Named, Profile, Result, Citations).

complete_missing(key(ProfileKey), _, indeterminate([ProfileKey]), []).
complete_missing(none, Profile, Result, Citations) :-
    duty_keys(DutyKeys),
    first_key(DutyKeys, unsure_referable_t(Profile), Selected),
    referral_answer(Selected, Profile, Result, Citations).

list_missing_key_t(Profile, ProfileKey, Truth) :-
    key_value(Profile, ProfileKey, Found),
    found_absent_t(Found, IsAbsent),
    key_kind(ProfileKey, KeyKind),
    kind_changes_list_t(KeyKind, Profile, Changes),
    truth_and(IsAbsent, Changes, Truth).

kind_changes_list_t(duty(DutyAtom), Profile, Truth) :-
    duty_open_t(Profile, DutyAtom, Truth).
kind_changes_list_t(condition(ConditionKey), Profile, Truth) :-
    duty_order(Duties),
    some_t(open_duty_on_key_not_true_t(Profile, ConditionKey), Duties, Truth).

open_duty_on_key_not_true_t(Profile, ConditionKey, DutyAtom, Truth) :-
    open_duty_on_key_t(Profile, ConditionKey, DutyAtom, OpenOnKey),
    duty_key_not_true_t(Profile, DutyAtom, NotTrue),
    truth_and(OpenOnKey, NotTrue, Truth).

unsure_open_t(Profile, ProfileKey, Truth) :-
    duty(DutyAtom, ProfileKey, _, _),
    key_value(Profile, ProfileKey, Found),
    found_value_t(Found, unsure, IsUnsure),
    duty_open_t(Profile, DutyAtom, IsOpen),
    truth_and(IsUnsure, IsOpen, Truth).

outstanding_missing(key(ProfileKey), _, indeterminate([ProfileKey]), []).
outstanding_missing(none, Profile, Result, Citations) :-
    duty_keys(DutyKeys),
    first_key(DutyKeys, unsure_open_t(Profile), Selected),
    outstanding_referral(Selected, Profile, Result, Citations).

outstanding_referral(key(ProfileKey), Profile, Result, Citations) :-
    referral_answer(key(ProfileKey), Profile, Result, Citations).
outstanding_referral(none, Profile, Result, Citations) :-
    implements(eu_reg_2024_1774_art_17_1),
    duty_order(Duties),
    keep_true(duty_fails_t(Profile), Duties, Failing),
    outstanding_list(Failing, Result, Citations).

outstanding_list([], none_outstanding, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
outstanding_list([Failed|Failures], outstanding([Failed|Failures]), Citations) :-
    duty_citations([Failed|Failures], Citations).

decide_dora_rts_change_management(Profile, dora_rts_change_management_verdict(Status, Citations)) :-
    ict_change_management_duties_complete(Profile, Status, Citations).

dora_rts_change_management_status(Profile, Status) :-
    decide_dora_rts_change_management(Profile, dora_rts_change_management_verdict(Status, _Citations)).

dora_rts_change_management_decision_resolvable(Profile) :-
    decide_dora_rts_change_management(Profile, _Verdict).

dora_rts_change_management_checklist(Profile, Items) :-
    dora_rts_change_management_input_problems(Profile, Problems),
    checklist_after_problems(Problems, Profile, Items).

checklist_after_problems([Problem|Problems], _, [item(input_check, input_problems([Problem|Problems]), cite(eu_reg_2024_1774_art_17_1))]).
checklist_after_problems([], Profile, Items) :-
    key_value(Profile, financial_entity_is_article_16_1_entity, GateFound),
    checklist_after_gate(GateFound, Profile, Items).

checklist_after_gate(given(true), _, [item(article_16_1_entity, inapplicable, cite(eu_reg_2022_2554_art_16_1))]).
checklist_after_gate(absent, _, [item(article_16_1_entity, unknown([financial_entity_is_article_16_1_entity]), cite(eu_reg_2022_2554_art_16_1))]).
checklist_after_gate(given(false), Profile, Items) :-
    duty_order(Duties),
    maplist(duty_item(Profile), Duties, Items).

duty_item(Profile, DutyAtom, item(DutyAtom, Status, Citation)) :-
    duty(DutyAtom, ProfileKey, Citation, Conditions),
    duty_state(Profile, DutyAtom, State),
    key_value(Profile, ProfileKey, Found),
    keep_true(condition_open_t(Profile), Conditions, OpenConditions),
    maplist(condition_key, OpenConditions, OpenKeys),
    item_status(State, Found, ProfileKey, OpenKeys, Status).

item_status(fails, _, _, _, inapplicable).
item_status(applies, given(true), _, _, met).
item_status(applies, given(false), _, _, unmet(not_performed)).
item_status(applies, given(unsure), ProfileKey, _, unknown([ProfileKey])).
item_status(applies, absent, ProfileKey, _, unknown([ProfileKey])).
item_status(pending, given(true), _, _, met).
item_status(pending, given(false), _, OpenKeys, unknown(OpenKeys)).
item_status(pending, given(unsure), _, OpenKeys, unknown(OpenKeys)).
item_status(pending, absent, _, OpenKeys, unknown(OpenKeys)).

performed_except_first(FirstValue, [attribute(change_procedures_verify_whether_ict_security_requirements_met, FirstValue)|Performed]) :-
    findall(attribute(ProfileKey, true), (duty(_, ProfileKey, _, []), dif(ProfileKey, change_procedures_verify_whether_ict_security_requirements_met)), Performed).

test(gate_true_is_a_simplified_framework_entity) :-
    findall(Result - Citations, ict_change_management_duties_complete([attribute(financial_entity_is_article_16_1_entity, true)], Result, Citations), Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(gate_absent_is_asked_first) :-
    findall(Result - Citations, ict_change_management_duties_required([], Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(no_significant_changes_gives_thirteen_duties) :-
    findall(Result - Citations, ict_change_management_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(significant_changes_made_to_ict_systems, false)], Result, Citations), [required(Duties) - Citations]),
    length(Duties, 13),
    Citations == [cite(eu_reg_2024_1774_art_17_1)].
test(central_counterparty_after_significant_changes_has_fifteen_duties) :-
    findall(Result, ict_change_management_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, central_counterparty), attribute(significant_changes_made_to_ict_systems, true)], Result, _), [required(Duties)]),
    length(Duties, 15),
    last(Duties, central_counterparty_involvement_of_parties_in_testing).
test(type_absent_is_named_while_trigger_absent) :-
    ict_change_management_duties_required([attribute(financial_entity_is_article_16_1_entity, false)], Result, Citations),
    Result == indeterminate([dora_entity_type]),
    Citations == [].
test(other_type_does_not_ask_for_the_trigger) :-
    ict_change_management_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, investment_firm)], required(Duties), _),
    length(Duties, 13).
test(all_performed_is_complete) :-
    performed_except_first(true, Performed),
    findall(Result, ict_change_management_duties_complete([attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, investment_firm)|Performed], Result, _), Results),
    Results == [complete].
test(a_failing_duty_is_incomplete_whatever_is_absent) :-
    findall(Result, ict_change_management_duties_complete([attribute(financial_entity_is_article_16_1_entity, false), attribute(change_procedures_verify_whether_ict_security_requirements_met, false)], Result, _), Results),
    Results == [incomplete].
test(type_named_once_every_applying_key_is_present) :-
    performed_except_first(true, Performed),
    ict_change_management_duties_complete([attribute(financial_entity_is_article_16_1_entity, false)|Performed], Result, _),
    Result == indeterminate([dora_entity_type]).
test(an_absent_applying_duty_key_decides_alone) :-
    performed_except_first(true, [_|Performed]),
    ict_change_management_duties_complete([attribute(financial_entity_is_article_16_1_entity, false)|Performed], Result, _),
    Result == indeterminate([change_procedures_verify_whether_ict_security_requirements_met]).
test(an_unsure_judgement_goes_to_a_lawyer) :-
    performed_except_first(unsure, Performed),
    findall(Result, ict_change_management_duties_complete([attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, investment_firm)|Performed], Result, _), [needs_legal_review(open_textured(change_procedures_verify_whether_ict_security_requirements_met, cite(eu_reg_2024_1774_art_17_1)), [inputs_relied_on([financial_entity_is_article_16_1_entity - false, dora_entity_type - investment_firm, change_procedures_verify_whether_ict_security_requirements_met - unsure|_])])]).
test(outstanding_lists_the_failing_duty) :-
    performed_except_first(false, Performed),
    findall(Result - Citations, ict_change_management_duties_outstanding([attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, investment_firm)|Performed], Result, Citations), Answers),
    Answers == [outstanding([verification_of_ict_security_requirements]) - [cite(eu_reg_2024_1774_art_17_1)]].
test(nothing_outstanding) :-
    performed_except_first(true, Performed),
    ict_change_management_duties_outstanding([attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, investment_firm)|Performed], Result, _),
    Result == none_outstanding.
test(an_unknown_key_is_an_input_problem) :-
    findall(Result - Citations, ict_change_management_duties_outstanding([attribute(colour, blue)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].

test(a_failing_duty_is_not_complete, fail) :-
    ict_change_management_duties_complete([attribute(financial_entity_is_article_16_1_entity, false), attribute(change_procedures_verify_whether_ict_security_requirements_met, false)], complete, _).
