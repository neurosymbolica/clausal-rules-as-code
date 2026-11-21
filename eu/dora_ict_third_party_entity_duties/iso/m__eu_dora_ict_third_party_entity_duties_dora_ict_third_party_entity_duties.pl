% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_dora_ict_third_party_entity_duties, [decide_dora_ict_third_party_entity_duties/2, dora_ict_third_party_entity_duties_status/2, dora_ict_third_party_entity_duties_checklist/2, dora_ict_third_party_entity_duties_decision_resolvable/1, dora_ict_third_party_entity_duties_status_values/1, entity_duties_required/3, entity_duties_complete/3, entity_duties_outstanding/3, ict_third_party_strategy_required/3, complete/0, incomplete/0, none_outstanding/0, strategy_required/0, strategy_not_required/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(library(reif), [memberd_t/3]).

complete.

incomplete.

none_outstanding.

strategy_required.

strategy_not_required.

dora_ict_third_party_entity_duties_status_values([complete, incomplete, indeterminate, needs_legal_review, input_problems]).

arrangement_keys([assessed_whether_arrangement_supports_critical_or_important_function, assessed_supervisory_conditions_for_contracting, identified_and_assessed_relevant_risks, undertook_due_diligence_on_provider, identified_and_assessed_conflicts_of_interest, provider_complies_with_appropriate_information_security_standards, entity_exercises_access_inspection_and_audit_rights, audit_frequency_and_areas_predetermined, arrangement_entails_high_technical_complexity, auditor_skills_and_knowledge_verified, supports_critical_or_important_function, considered_most_up_to_date_information_security_standards, exit_strategy_in_place, able_to_exit_without_business_disruption, able_to_exit_without_limiting_regulatory_compliance, able_to_exit_without_detriment_to_client_services, exit_plans_comprehensive_documented_tested_and_reviewed, alternative_solutions_and_transition_plans_in_place, contingency_measures_in_place, considered_concentration_risk, weighed_alternative_solutions, considered_insolvency_law_and_data_recovery_constraints, arrangement_allows_further_subcontracting, weighed_subcontracting_benefits_and_risks, assessed_impact_of_subcontracting_chains, provider_established_in_third_country, considered_third_country_data_protection_and_enforcement]).

trigger_keys([entity_exercises_access_inspection_and_audit_rights, arrangement_entails_high_technical_complexity, supports_critical_or_important_function, arrangement_allows_further_subcontracting, provider_established_in_third_country]).

trigger(entity_exercises_access_inspection_and_audit_rights, []).
trigger(arrangement_entails_high_technical_complexity, [entity_exercises_access_inspection_and_audit_rights]).
trigger(supports_critical_or_important_function, []).
trigger(arrangement_allows_further_subcontracting, [supports_critical_or_important_function]).
trigger(provider_established_in_third_country, [supports_critical_or_important_function]).

duty(assessment_of_critical_or_important_function, assessed_whether_arrangement_supports_critical_or_important_function, [], [cite(eu_reg_2022_2554_art_28_4_a)]).
duty(assessment_of_supervisory_conditions, assessed_supervisory_conditions_for_contracting, [], [cite(eu_reg_2022_2554_art_28_4_b)]).
duty(risk_identification_and_assessment, identified_and_assessed_relevant_risks, [], [cite(eu_reg_2022_2554_art_28_4_c)]).
duty(due_diligence_on_provider, undertook_due_diligence_on_provider, [], [cite(eu_reg_2022_2554_art_28_4_d)]).
duty(conflicts_of_interest_assessment, identified_and_assessed_conflicts_of_interest, [], [cite(eu_reg_2022_2554_art_28_4_e)]).
duty(provider_with_appropriate_information_security_standards, provider_complies_with_appropriate_information_security_standards, [], [cite(eu_reg_2022_2554_art_28_5)]).
duty(consideration_of_most_up_to_date_information_security_standards, considered_most_up_to_date_information_security_standards, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_28_5)]).
duty(predetermined_audit_frequency_and_areas, audit_frequency_and_areas_predetermined, [entity_exercises_access_inspection_and_audit_rights], [cite(eu_reg_2022_2554_art_28_6)]).
duty(verification_of_auditor_skills, auditor_skills_and_knowledge_verified, [entity_exercises_access_inspection_and_audit_rights, arrangement_entails_high_technical_complexity], [cite(eu_reg_2022_2554_art_28_6)]).
duty(exit_strategy, exit_strategy_in_place, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_28_8)]).
duty(exit_without_business_disruption, able_to_exit_without_business_disruption, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_28_8_a)]).
duty(exit_without_limiting_regulatory_compliance, able_to_exit_without_limiting_regulatory_compliance, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_28_8_b)]).
duty(exit_without_detriment_to_client_services, able_to_exit_without_detriment_to_client_services, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_28_8_c)]).
duty(tested_and_reviewed_exit_plans, exit_plans_comprehensive_documented_tested_and_reviewed, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_28_8)]).
duty(alternative_solutions_and_transition_plans, alternative_solutions_and_transition_plans_in_place, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_28_8)]).
duty(contingency_measures, contingency_measures_in_place, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_28_8)]).
duty(concentration_risk_consideration, considered_concentration_risk, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_29_1), cite(eu_reg_2022_2554_art_29_1_a), cite(eu_reg_2022_2554_art_29_1_b)]).
duty(weighing_of_alternative_solutions, weighed_alternative_solutions, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_29_1)]).
duty(weighing_of_subcontracting_benefits_and_risks, weighed_subcontracting_benefits_and_risks, [supports_critical_or_important_function, arrangement_allows_further_subcontracting], [cite(eu_reg_2022_2554_art_29_2)]).
duty(consideration_of_insolvency_law_and_data_recovery, considered_insolvency_law_and_data_recovery_constraints, [supports_critical_or_important_function], [cite(eu_reg_2022_2554_art_29_2)]).
duty(consideration_of_third_country_data_protection_and_enforcement, considered_third_country_data_protection_and_enforcement, [supports_critical_or_important_function, provider_established_in_third_country], [cite(eu_reg_2022_2554_art_29_2)]).
duty(assessment_of_subcontracting_chains, assessed_impact_of_subcontracting_chains, [supports_critical_or_important_function, arrangement_allows_further_subcontracting], [cite(eu_reg_2022_2554_art_29_2)]).

referral(assessed_whether_arrangement_supports_critical_or_important_function, cite(eu_reg_2022_2554_art_28_4_a)).
referral(assessed_supervisory_conditions_for_contracting, cite(eu_reg_2022_2554_art_28_4_b)).
referral(identified_and_assessed_relevant_risks, cite(eu_reg_2022_2554_art_28_4_c)).
referral(undertook_due_diligence_on_provider, cite(eu_reg_2022_2554_art_28_4_d)).
referral(identified_and_assessed_conflicts_of_interest, cite(eu_reg_2022_2554_art_28_4_e)).
referral(provider_complies_with_appropriate_information_security_standards, cite(eu_reg_2022_2554_art_28_5)).
referral(audit_frequency_and_areas_predetermined, cite(eu_reg_2022_2554_art_28_6)).
referral(arrangement_entails_high_technical_complexity, cite(eu_reg_2022_2554_art_28_6)).
referral(auditor_skills_and_knowledge_verified, cite(eu_reg_2022_2554_art_28_6)).
referral(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_28_4_a)).
referral(considered_most_up_to_date_information_security_standards, cite(eu_reg_2022_2554_art_28_5)).
referral(exit_strategy_in_place, cite(eu_reg_2022_2554_art_28_8)).
referral(able_to_exit_without_business_disruption, cite(eu_reg_2022_2554_art_28_8_a)).
referral(able_to_exit_without_limiting_regulatory_compliance, cite(eu_reg_2022_2554_art_28_8_b)).
referral(able_to_exit_without_detriment_to_client_services, cite(eu_reg_2022_2554_art_28_8_c)).
referral(exit_plans_comprehensive_documented_tested_and_reviewed, cite(eu_reg_2022_2554_art_28_8)).
referral(alternative_solutions_and_transition_plans_in_place, cite(eu_reg_2022_2554_art_28_8)).
referral(contingency_measures_in_place, cite(eu_reg_2022_2554_art_28_8)).
referral(considered_concentration_risk, cite(eu_reg_2022_2554_art_29_1)).
referral(weighed_alternative_solutions, cite(eu_reg_2022_2554_art_29_1)).
referral(considered_insolvency_law_and_data_recovery_constraints, cite(eu_reg_2022_2554_art_29_2)).
referral(weighed_subcontracting_benefits_and_risks, cite(eu_reg_2022_2554_art_29_2)).
referral(assessed_impact_of_subcontracting_chains, cite(eu_reg_2022_2554_art_29_2)).
referral(considered_third_country_data_protection_and_enforcement, cite(eu_reg_2022_2554_art_29_2)).

checked_citations([cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5), cite(eu_reg_2022_2554_art_28_6), cite(eu_reg_2022_2554_art_28_8), cite(eu_reg_2022_2554_art_29_1), cite(eu_reg_2022_2554_art_29_2)]).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

key_state_pair(Profile, Key, Key - State) :-
    key_state(Profile, Key, State).

arrangement_states(Profile, States) :-
    arrangement_keys(Keys),
    maplist(key_state_pair(Profile), Keys, States).

state_of(States, Key, State) :-
    member(Key - State, States).

state_t(States, Key, Wanted, Truth) :-
    state_of(States, Key, State),
    equal_t(State, Wanted, Truth).

equal_t(Left, Right, true) :-
    Left == Right.
equal_t(Left, Right, false) :-
    Left \== Right.

present_pairs(States, Keys, Pairs) :-
    findall(Key - Value, (member(Key, Keys), state_of(States, Key, Value), Value \== absent), Pairs).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

truth_not(true, false).
truth_not(false, true).

all_t(_, [], true).
all_t(Test, [Element|Elements], Truth) :-
    call(Test, Element, ElementTruth),
    all_t_step(ElementTruth, Test, Elements, Truth).

all_t_step(true, Test, Elements, Truth) :-
    all_t(Test, Elements, Truth).
all_t_step(false, _, _, false).

any_t(_, [], false).
any_t(Test, [Element|Elements], Truth) :-
    call(Test, Element, ElementTruth),
    any_t_step(ElementTruth, Test, Elements, Truth).

any_t_step(true, _, _, true).
any_t_step(false, Test, Elements, Truth) :-
    any_t(Test, Elements, Truth).

first_matching([], _, none).
first_matching([Key|Keys], Test, Result) :-
    call(Test, Key, Truth),
    first_matching_step(Truth, Key, Keys, Test, Result).

first_matching_step(true, Key, _, _, key(Key)).
first_matching_step(false, _, Keys, Test, Result) :-
    first_matching(Keys, Test, Result).

remove_key([], _, []).
remove_key([Element|Elements], Key, Rest) :-
    Element == Key,
    remove_key(Elements, Key, Rest).
remove_key([Element|Elements], Key, [Element|Rest]) :-
    Element \== Key,
    remove_key(Elements, Key, Rest).

within_t(Within, Key, Truth) :-
    memberd_t(Key, Within, Truth).

is_true_t(States, Key, Truth) :-
    state_t(States, Key, true, Truth).

not_true_t(States, Key, Truth) :-
    state_t(States, Key, true, IsTrue),
    truth_not(IsTrue, Truth).

not_false_t(States, Key, Truth) :-
    state_t(States, Key, false, IsFalse),
    truth_not(IsFalse, Truth).

true_or_unsure_t(States, Key, Truth) :-
    state_of(States, Key, State),
    memberd_t(State, [true, unsure], Truth).

applies_t(States, Triggers, Truth) :-
    implements(eu_reg_2022_2554_art_28_4),
    implements(eu_reg_2022_2554_art_28_1_b),
    all_t(is_true_t(States), Triggers, Truth).

open_t(States, Triggers, Truth) :-
    implements(eu_reg_2022_2554_art_28_4),
    all_t(not_false_t(States), Triggers, Truth).

fails_t(States, Duty, Truth) :-
    implements(eu_reg_2022_2554_art_28_4),
    duty(Duty, Key, Triggers, _),
    applies_t(States, Triggers, Applies),
    state_t(States, Key, false, IsFalse),
    truth_and(Applies, IsFalse, Truth).

duty_names(Duties) :-
    findall(Duty, duty(Duty, _, _, _), Duties).

duties_under(Trigger, Duties) :-
    findall(Duty, (duty(Duty, _, Triggers, _), memberd_t(Trigger, Triggers, true)), Duties).

duties_not_under(Trigger, Duties) :-
    findall(Duty, (duty(Duty, _, Triggers, _), memberd_t(Trigger, Triggers, false)), Duties).

applying_duties(States, Duties) :-
    findall(Duty, (duty(Duty, _, Triggers, _), applies_t(States, Triggers, true)), Duties).

failing_duties(States, Duties) :-
    findall(Duty, (duty(Duty, _, _, _), fails_t(States, Duty, true)), Duties).

entity_duties_required(Profile, Result, Citations) :-
    dora_ict_third_party_entity_duties_input_problems(Profile, Problems),
    required_route(Problems, Profile, Result, Citations).

required_route([Problem|Problems], _, input_problems([Problem|Problems]), []).
required_route([], Profile, Result, Citations) :-
    arrangement_states(Profile, States),
    trigger_keys(Triggers),
    first_matching(Triggers, absent_trigger_t(States), Absent),
    required_after_absent(Absent, States, Result, Citations).

absent_trigger_t(States, Key, Truth) :-
    state_t(States, Key, absent, IsAbsent),
    trigger(Key, OwnTriggers),
    open_t(States, OwnTriggers, Open),
    truth_and(IsAbsent, Open, Truth).

unsure_trigger_t(States, Key, Truth) :-
    state_t(States, Key, unsure, IsUnsure),
    trigger(Key, OwnTriggers),
    open_t(States, OwnTriggers, Open),
    truth_and(IsUnsure, Open, Truth).

required_after_absent(key(Key), _, indeterminate([Key]), []).
required_after_absent(none, States, Result, Citations) :-
    trigger_keys(Triggers),
    first_matching(Triggers, unsure_trigger_t(States), Unsure),
    required_after_unsure(Unsure, States, Result, Citations).

required_after_unsure(key(Key), States, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    referral(Key, Citation),
    trigger_keys(Triggers),
    present_pairs(States, Triggers, Pairs).
required_after_unsure(none, States, required(Duties), Citations) :-
    implements(eu_reg_2022_2554_art_28_4),
    applying_duties(States, Duties),
    required_citations(States, Citations).

required_citations(States, Citations) :-
    state_of(States, entity_exercises_access_inspection_and_audit_rights, AuditState),
    state_of(States, supports_critical_or_important_function, FunctionState),
    audit_citations(AuditState, AuditCitations),
    function_citations(FunctionState, FunctionCitations),
    append([[cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5)], AuditCitations, FunctionCitations], Citations).

audit_citations(true, [cite(eu_reg_2022_2554_art_28_6)]) :-
    implements(eu_reg_2022_2554_art_28_6).
audit_citations(false, []).

function_citations(true, [cite(eu_reg_2022_2554_art_28_8), cite(eu_reg_2022_2554_art_29_1), cite(eu_reg_2022_2554_art_29_2)]) :-
    implements(eu_reg_2022_2554_art_28_8).
function_citations(false, []).

entity_duties_complete(Profile, Result, Citations) :-
    dora_ict_third_party_entity_duties_input_problems(Profile, Problems),
    complete_route(Problems, Profile, Result, Citations).

complete_route([Problem|Problems], _, input_problems([Problem|Problems]), []).
complete_route([], Profile, Result, Citations) :-
    arrangement_states(Profile, States),
    duty_names(Duties),
    any_t(fails_t(States), Duties, SomeFails),
    complete_after_failure(SomeFails, States, Result, Citations).

complete_after_failure(true, _, incomplete, Citations) :-
    implements(eu_reg_2022_2554_art_28_4),
    checked_citations(Citations).
complete_after_failure(false, States, Result, Citations) :-
    arrangement_keys(Keys),
    findall(Key, (member(Key, Keys), state_of(States, Key, absent), can_change_answer_t(States, Key, true)), Candidates),
    first_matching(Candidates, not_behind_t(States, Candidates), Named),
    complete_after_absent(Named, Candidates, States, Result, Citations).

complete_after_absent(key(Key), _, _, indeterminate([Key]), []).
complete_after_absent(none, [Key|_], _, indeterminate([Key]), []).
complete_after_absent(none, [], States, Result, Citations) :-
    arrangement_keys(Keys),
    first_matching(Keys, unsure_answer_changeable_t(States), Unsure),
    complete_after_unsure(Unsure, States, Result, Citations).

complete_after_unsure(key(Key), States, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    referral(Key, Citation),
    arrangement_keys(Keys),
    present_pairs(States, Keys, Pairs).
complete_after_unsure(none, _, complete, Citations) :-
    implements(eu_reg_2022_2554_art_28_4),
    checked_citations(Citations).

unsure_answer_changeable_t(States, Key, Truth) :-
    state_t(States, Key, unsure, IsUnsure),
    can_change_answer_t(States, Key, CanChange),
    truth_and(IsUnsure, CanChange, Truth).

can_change_answer_t(States, Key, Truth) :-
    duty(_, Key, Triggers, _),
    open_t(States, Triggers, Open),
    duty_names(Duties),
    any_t(masks_t(States, Triggers), Duties, Masked),
    truth_not(Masked, Unmasked),
    truth_and(Open, Unmasked, Truth).
can_change_answer_t(States, Key, Truth) :-
    trigger(Key, _),
    duties_under(Key, Under),
    any_t(changeable_under_t(States, Key), Under, Truth).

changeable_under_t(States, Trigger, Duty, Truth) :-
    duty(Duty, DutyKey, Triggers, _),
    open_t(States, Triggers, Open),
    not_true_t(States, DutyKey, NotTrue),
    remove_key(Triggers, Trigger, OtherTriggers),
    duties_not_under(Trigger, NotUnder),
    any_t(masks_t(States, OtherTriggers), NotUnder, Masked),
    truth_not(Masked, Unmasked),
    truth_and(Open, NotTrue, Partial),
    truth_and(Partial, Unmasked, Truth).

masks_t(States, Cover, Duty, Truth) :-
    duty(Duty, Key, Triggers, _),
    state_t(States, Key, false, IsFalse),
    all_t(covered_t(States, Cover), Triggers, Covered),
    truth_and(IsFalse, Covered, Truth).

covered_t(States, Cover, Trigger, Truth) :-
    memberd_t(Trigger, Cover, InCover),
    state_t(States, Trigger, true, IsTrue),
    truth_or(InCover, IsTrue, Truth).

not_behind_t(States, Candidates, Key, Truth) :-
    any_t(behind_t(States, Key), Candidates, Behind),
    truth_not(Behind, Truth).

behind_t(States, Behind, Ahead, Truth) :-
    key_triggers(Behind, BehindTriggers),
    key_triggers(Ahead, AheadTriggers),
    relies_within_t(States, Ahead, BehindTriggers, AheadAlone),
    relies_within_t(States, Behind, AheadTriggers, BehindAlone),
    truth_not(BehindAlone, BehindNotAlone),
    truth_and(AheadAlone, BehindNotAlone, Truth).

key_triggers(Key, Triggers) :-
    duty(_, Key, Triggers, _).
key_triggers(Key, Triggers) :-
    trigger(Key, Triggers).

relies_within_t(States, Key, Within, Truth) :-
    decides_alone(States, Key, Alone),
    alone_within_t(Alone, Within, Truth).

alone_within_t(not_alone, _, false).
alone_within_t(alone(Reliance), Within, Truth) :-
    all_t(within_t(Within), Reliance, Truth).

decides_alone(States, Key, Alone) :-
    duty(_, Key, Triggers, _),
    all_t(true_or_unsure_t(States), Triggers, Reachable),
    unsure_among(States, Triggers, Reliance),
    alone_result(Reachable, Reliance, Alone).
decides_alone(States, Key, Alone) :-
    trigger(Key, _),
    findall(Reliance, trigger_reliance(States, Key, Reliance), Reliances),
    fewest(Reliances, Alone).

trigger_reliance(States, Trigger, Reliance) :-
    duty(_, DutyKey, Triggers, _),
    memberd_t(Trigger, Triggers, true),
    state_of(States, DutyKey, false),
    remove_key(Triggers, Trigger, OtherTriggers),
    all_t(true_or_unsure_t(States), OtherTriggers, true),
    unsure_among(States, OtherTriggers, Reliance).

alone_result(true, Reliance, alone(Reliance)).
alone_result(false, _, not_alone).

unsure_among(States, Keys, Unsure) :-
    findall(Key, (member(Key, Keys), state_of(States, Key, unsure)), Unsure).

fewest([], not_alone).
fewest([Reliance|Reliances], alone(Fewest)) :-
    foldl(shorter_reliance, Reliances, Reliance, Fewest).

shorter_reliance(Reliance, Accumulated, Reliance) :-
    length(Reliance, RelianceLength),
    length(Accumulated, AccumulatedLength),
    RelianceLength < AccumulatedLength.
shorter_reliance(Reliance, Accumulated, Accumulated) :-
    length(Reliance, RelianceLength),
    length(Accumulated, AccumulatedLength),
    RelianceLength >= AccumulatedLength.

entity_duties_outstanding(Profile, Result, Citations) :-
    dora_ict_third_party_entity_duties_input_problems(Profile, Problems),
    outstanding_route(Problems, Profile, Result, Citations).

outstanding_route([Problem|Problems], _, input_problems([Problem|Problems]), []).
outstanding_route([], Profile, Result, Citations) :-
    arrangement_states(Profile, States),
    arrangement_keys(Keys),
    first_matching(Keys, absent_list_changeable_t(States), Absent),
    outstanding_after_absent(Absent, States, Result, Citations).

outstanding_after_absent(key(Key), _, indeterminate([Key]), []).
outstanding_after_absent(none, States, Result, Citations) :-
    arrangement_keys(Keys),
    first_matching(Keys, unsure_list_changeable_t(States), Unsure),
    outstanding_after_unsure(Unsure, States, Result, Citations).

outstanding_after_unsure(key(Key), States, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    referral(Key, Citation),
    arrangement_keys(Keys),
    present_pairs(States, Keys, Pairs).
outstanding_after_unsure(none, States, Result, Citations) :-
    failing_duties(States, Failing),
    outstanding_answer(Failing, Result, Citations).

outstanding_answer([], none_outstanding, Citations) :-
    implements(eu_reg_2022_2554_art_28_4),
    checked_citations(Citations).
outstanding_answer([Duty|Duties], outstanding([Duty|Duties]), Citations) :-
    implements(eu_reg_2022_2554_art_28_4),
    findall(Citation, (member(Failing, [Duty|Duties]), duty(Failing, _, _, DutyCitations), member(Citation, DutyCitations)), AllCitations),
    sort(AllCitations, Citations).

absent_list_changeable_t(States, Key, Truth) :-
    state_t(States, Key, absent, IsAbsent),
    can_change_list_t(States, Key, CanChange),
    truth_and(IsAbsent, CanChange, Truth).

unsure_list_changeable_t(States, Key, Truth) :-
    state_t(States, Key, unsure, IsUnsure),
    can_change_list_t(States, Key, CanChange),
    truth_and(IsUnsure, CanChange, Truth).

can_change_list_t(States, Key, Truth) :-
    duty(_, Key, Triggers, _),
    open_t(States, Triggers, Truth).
can_change_list_t(States, Key, Truth) :-
    trigger(Key, _),
    duties_under(Key, Under),
    any_t(open_untrue_t(States), Under, Truth).

open_untrue_t(States, Duty, Truth) :-
    duty(Duty, DutyKey, Triggers, _),
    open_t(States, Triggers, Open),
    not_true_t(States, DutyKey, NotTrue),
    truth_and(Open, NotTrue, Truth).

ict_third_party_strategy_required(Profile, Result, Citations) :-
    dora_ict_third_party_entity_duties_input_problems(Profile, Problems),
    strategy_route(Problems, Profile, Result, Citations).

strategy_route([Problem|Problems], _, input_problems([Problem|Problems]), []).
strategy_route([], Profile, Result, Citations) :-
    key_state(Profile, financial_entity_is_article_16_1_entity, ArticleSixteenState),
    key_state(Profile, financial_entity_is_microenterprise, MicroenterpriseState),
    strategy_answer(ArticleSixteenState, MicroenterpriseState, Result, Citations).

strategy_answer(true, _, strategy_not_required, [cite(eu_reg_2022_2554_art_28_2)]) :-
    implements(eu_reg_2022_2554_art_28_2).
strategy_answer(false, true, strategy_not_required, [cite(eu_reg_2022_2554_art_28_2)]) :-
    implements(eu_reg_2022_2554_art_28_2).
strategy_answer(absent, true, strategy_not_required, [cite(eu_reg_2022_2554_art_28_2)]) :-
    implements(eu_reg_2022_2554_art_28_2).
strategy_answer(absent, false, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_28_2).
strategy_answer(absent, absent, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_28_2).
strategy_answer(false, absent, indeterminate([financial_entity_is_microenterprise]), []) :-
    implements(eu_reg_2022_2554_art_28_2).
strategy_answer(false, false, strategy_required, [cite(eu_reg_2022_2554_art_28_2)]) :-
    implements(eu_reg_2022_2554_art_28_2).

decide_dora_ict_third_party_entity_duties(Profile, dora_ict_third_party_entity_duties_verdict(Status, Citations)) :-
    entity_duties_complete(Profile, Status, Citations).

dora_ict_third_party_entity_duties_status(Profile, Status) :-
    decide_dora_ict_third_party_entity_duties(Profile, dora_ict_third_party_entity_duties_verdict(Status, _Citations)).

dora_ict_third_party_entity_duties_decision_resolvable(Profile) :-
    decide_dora_ict_third_party_entity_duties(Profile, _Verdict).

dora_ict_third_party_entity_duties_checklist(Profile, Items) :-
    dora_ict_third_party_entity_duties_input_problems(Profile, Problems),
    checklist_route(Problems, Profile, Items).

checklist_route([Problem|Problems], _, [item(profile, unmet(input_problems([Problem|Problems])), cite(eu_reg_2022_2554_art_28_4))]).
checklist_route([], Profile, Items) :-
    arrangement_states(Profile, States),
    findall(item(Duty, Status, Citation), (duty(Duty, Key, Triggers, [Citation|_]), open_t(States, Triggers, true), duty_item_status(States, Key, Triggers, Status)), Items).

duty_item_status(States, Key, _, met) :-
    implements(eu_reg_2022_2554_art_28_4),
    state_of(States, Key, true).
duty_item_status(States, Key, Triggers, unmet(not_performed)) :-
    implements(eu_reg_2022_2554_art_28_4),
    state_of(States, Key, false),
    applies_t(States, Triggers, true).
duty_item_status(States, Key, Triggers, unknown([Trigger])) :-
    state_of(States, Key, false),
    applies_t(States, Triggers, false),
    first_matching(Triggers, not_true_t(States), key(Trigger)).
duty_item_status(States, Key, _, unknown([Key])) :-
    state_of(States, Key, unsure).
duty_item_status(States, Key, _, unknown([Key])) :-
    state_of(States, Key, absent).

test_profile(Pairs, Profile) :-
    maplist(pair_attribute, Pairs, Profile).

pair_attribute(Key - Value, attribute(Key, Value)).

six_duties_true([assessed_whether_arrangement_supports_critical_or_important_function - true, assessed_supervisory_conditions_for_contracting - true, identified_and_assessed_relevant_risks - true, undertook_due_diligence_on_provider - true, identified_and_assessed_conflicts_of_interest - true, provider_complies_with_appropriate_information_security_standards - true]).

plain_profile(Profile) :-
    six_duties_true(Duties),
    append(Duties, [entity_exercises_access_inspection_and_audit_rights - false, supports_critical_or_important_function - false], Pairs),
    test_profile(Pairs, Profile).

test(required_with_no_trigger_true) :-
    test_profile([entity_exercises_access_inspection_and_audit_rights - false, supports_critical_or_important_function - false], Profile),
    findall(Result - Citations, entity_duties_required(Profile, Result, Citations), Answers),
    Answers == [required([assessment_of_critical_or_important_function, assessment_of_supervisory_conditions, risk_identification_and_assessment, due_diligence_on_provider, conflicts_of_interest_assessment, provider_with_appropriate_information_security_standards]) - [cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5)]].
test(required_with_every_trigger_true) :-
    test_profile([entity_exercises_access_inspection_and_audit_rights - true, arrangement_entails_high_technical_complexity - true, supports_critical_or_important_function - true, arrangement_allows_further_subcontracting - true, provider_established_in_third_country - true], Profile),
    findall(Result - Citations, entity_duties_required(Profile, Result, Citations), Answers),
    Answers == [required([assessment_of_critical_or_important_function, assessment_of_supervisory_conditions, risk_identification_and_assessment, due_diligence_on_provider, conflicts_of_interest_assessment, provider_with_appropriate_information_security_standards, consideration_of_most_up_to_date_information_security_standards, predetermined_audit_frequency_and_areas, verification_of_auditor_skills, exit_strategy, exit_without_business_disruption, exit_without_limiting_regulatory_compliance, exit_without_detriment_to_client_services, tested_and_reviewed_exit_plans, alternative_solutions_and_transition_plans, contingency_measures, concentration_risk_consideration, weighing_of_alternative_solutions, weighing_of_subcontracting_benefits_and_risks, consideration_of_insolvency_law_and_data_recovery, consideration_of_third_country_data_protection_and_enforcement, assessment_of_subcontracting_chains]) - [cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5), cite(eu_reg_2022_2554_art_28_6), cite(eu_reg_2022_2554_art_28_8), cite(eu_reg_2022_2554_art_29_1), cite(eu_reg_2022_2554_art_29_2)]].
test(required_on_an_empty_profile_names_the_first_trigger) :-
    findall(Result - Citations, entity_duties_required([], Result, Citations), Answers),
    Answers == [indeterminate([entity_exercises_access_inspection_and_audit_rights]) - []].
test(required_refers_an_unsure_function_judgement) :-
    test_profile([entity_exercises_access_inspection_and_audit_rights - false, supports_critical_or_important_function - unsure, arrangement_allows_further_subcontracting - false, provider_established_in_third_country - false], Profile),
    findall(Result - Citations, entity_duties_required(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_28_4_a)), [inputs_relied_on([entity_exercises_access_inspection_and_audit_rights - false, supports_critical_or_important_function - unsure, arrangement_allows_further_subcontracting - false, provider_established_in_third_country - false])]) - []].
test(complete_when_every_applying_duty_is_performed) :-
    plain_profile(Profile),
    findall(Result, entity_duties_complete(Profile, Result, _), Results),
    Results == [complete].
test(incomplete_when_one_duty_is_not_performed) :-
    test_profile([assessed_supervisory_conditions_for_contracting - false], Profile),
    findall(Result, entity_duties_complete(Profile, Result, _), Results),
    Results == [incomplete].
test(complete_on_an_empty_profile_names_the_first_key) :-
    findall(Result, entity_duties_complete([], Result, _), Results),
    Results == [indeterminate([assessed_whether_arrangement_supports_critical_or_important_function])].
test(complete_names_a_key_that_decides_alone_first) :-
    six_duties_true(Duties),
    append(Duties, [entity_exercises_access_inspection_and_audit_rights - true, audit_frequency_and_areas_predetermined - true, supports_critical_or_important_function - true, considered_most_up_to_date_information_security_standards - true, able_to_exit_without_business_disruption - true, able_to_exit_without_limiting_regulatory_compliance - true, able_to_exit_without_detriment_to_client_services - true, exit_plans_comprehensive_documented_tested_and_reviewed - true, alternative_solutions_and_transition_plans_in_place - true, contingency_measures_in_place - true, considered_concentration_risk - true, weighed_alternative_solutions - true, considered_insolvency_law_and_data_recovery_constraints - true, arrangement_allows_further_subcontracting - false, provider_established_in_third_country - false], Pairs),
    test_profile(Pairs, Profile),
    findall(Result, entity_duties_complete(Profile, Result, _), Results),
    Results == [indeterminate([exit_strategy_in_place])].
test(outstanding_lists_the_failing_duty) :-
    test_profile([assessed_whether_arrangement_supports_critical_or_important_function - true, assessed_supervisory_conditions_for_contracting - false, identified_and_assessed_relevant_risks - true, undertook_due_diligence_on_provider - true, identified_and_assessed_conflicts_of_interest - true, provider_complies_with_appropriate_information_security_standards - true, entity_exercises_access_inspection_and_audit_rights - false, supports_critical_or_important_function - false], Profile),
    findall(Result - Citations, entity_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([assessment_of_supervisory_conditions]) - [cite(eu_reg_2022_2554_art_28_4_b)]].
test(none_outstanding_when_complete) :-
    plain_profile(Profile),
    findall(Result, entity_duties_outstanding(Profile, Result, _), Results),
    Results == [none_outstanding].
test(input_problems_come_first) :-
    findall(Result - Citations, entity_duties_complete([attribute(unexpected_key, true)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(unexpected_key)]) - []].
test(strategy_needs_the_article_16_answer_first) :-
    findall(Result, ict_third_party_strategy_required([], Result, _), Results),
    Results == [indeterminate([financial_entity_is_article_16_1_entity])].
test(microenterprise_needs_no_strategy) :-
    test_profile([financial_entity_is_microenterprise - true], Profile),
    findall(Result - Citations, ict_third_party_strategy_required(Profile, Result, Citations), Answers),
    Answers == [strategy_not_required - [cite(eu_reg_2022_2554_art_28_2)]].
test(other_entity_needs_a_strategy) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false], Profile),
    findall(Result, ict_third_party_strategy_required(Profile, Result, _), Results),
    Results == [strategy_required].
test(checklist_carries_a_citation_per_item) :-
    plain_profile(Profile),
    dora_ict_third_party_entity_duties_checklist(Profile, Items),
    length(Items, 6),
    member(item(assessment_of_supervisory_conditions, met, cite(eu_reg_2022_2554_art_28_4_b)), Items).

test(complete_profile_is_not_incomplete, fail) :-
    plain_profile(Profile),
    entity_duties_complete(Profile, incomplete, _).
test(other_entity_is_not_exempt, fail) :-
    test_profile([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false], Profile),
    ict_third_party_strategy_required(Profile, strategy_not_required, _).
