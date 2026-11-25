% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_register_of_information_dora_register_of_information, [register_of_information_duties_required/3, register_of_information_duties_complete/3, register_of_information_duties_outstanding/3, decide_dora_register_of_information/2, dora_register_of_information_status/2, dora_register_of_information_checklist/2, dora_register_of_information_decision_resolvable/1, dora_register_of_information_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(formalize_lib, [profile_get/3, not_member/2]).
:- use_module(m__eu_dora_register_of_information_kernel, [dora_register_of_information_input_problems/2, present_pairs/2, first_in_key_order/2, contract_keys/1]).
:- use_module(m__eu_dora_register_of_information_citations, [implements/1, paragraph_of/2, fixed_citations/1]).

dora_register_of_information_status_values([complete, incomplete, indeterminate, needs_legal_review, input_problems]).

trigger_key(financial_entity_responsible_for_sub_consolidated_register).
trigger_key(financial_entity_responsible_for_consolidated_register).
trigger_key(competent_authority_requested_register).
trigger_key(entity_plans_arrangement_supporting_critical_or_important_function).
trigger_key(function_has_become_critical_or_important).
trigger_key(entity_uses_ict_services_supporting_critical_or_important_functions).
trigger_key(entity_has_branches_outside_home_country).
trigger_key(ict_service_supply_chain_partly_intra_group).

duty(register_at_entity_level, register_maintained_and_updated_at_entity_level, always, [cite(eu_reg_2022_2554_art_28_3), cite(eu_reg_2024_2956_art_3_1)]).
duty(register_at_sub_consolidated_level, register_maintained_and_updated_at_sub_consolidated_level, trigger(financial_entity_responsible_for_sub_consolidated_register), [cite(eu_reg_2022_2554_art_28_3), cite(eu_reg_2024_2956_art_3_1), cite(eu_reg_2024_2956_art_6_1), cite(eu_reg_2024_2956_art_6_2)]).
duty(register_at_consolidated_level, register_maintained_and_updated_at_consolidated_level, trigger(financial_entity_responsible_for_consolidated_register), [cite(eu_reg_2022_2554_art_28_3), cite(eu_reg_2024_2956_art_3_1), cite(eu_reg_2024_2956_art_6_1), cite(eu_reg_2024_2956_art_6_2)]).
duty(documentation_distinguishing_critical_or_important_functions, arrangements_documented_distinguishing_critical_or_important_functions, always, [cite(eu_reg_2022_2554_art_28_3)]).
duty(yearly_report_to_competent_authorities, reported_to_competent_authorities_at_least_yearly, always, [cite(eu_reg_2022_2554_art_28_3)]).
duty(register_made_available_on_request, register_made_available_to_competent_authority_on_request, trigger(competent_authority_requested_register), [cite(eu_reg_2022_2554_art_28_3)]).
duty(information_on_planned_arrangement, competent_authority_informed_of_planned_arrangement, trigger(entity_plans_arrangement_supporting_critical_or_important_function), [cite(eu_reg_2022_2554_art_28_3)]).
duty(information_on_function_become_critical_or_important, competent_authority_informed_that_function_has_become_critical_or_important, trigger(function_has_become_critical_or_important), [cite(eu_reg_2022_2554_art_28_3)]).
duty(ranking_of_providers, rank_assigned_to_each_ict_third_party_service_provider, always, [cite(eu_reg_2024_2956_art_2)]).
duty(information_on_ict_services_of_direct_providers, templates_include_information_on_all_ict_services_of_direct_providers, always, [cite(eu_reg_2024_2956_art_3_2_a)]).
duty(information_on_subcontractors_underpinning_critical_or_important_functions, templates_include_information_on_subcontractors_underpinning_critical_or_important_functions, trigger(entity_uses_ict_services_supporting_critical_or_important_functions), [cite(eu_reg_2024_2956_art_3_2_b)]).
duty(data_quality, template_information_meets_data_quality_principles, always, [cite(eu_reg_2024_2956_art_3_3), cite(eu_reg_2024_2956_art_3_4)]).
duty(regular_review_and_correction, template_information_reviewed_regularly_and_errors_corrected, always, [cite(eu_reg_2024_2956_art_3_3)]).
duty(consistency_with_sub_consolidated_level, entity_level_information_consistent_with_sub_consolidated_level, trigger(financial_entity_responsible_for_sub_consolidated_register), [cite(eu_reg_2024_2956_art_3_3)]).
duty(consistency_with_consolidated_level, entity_level_information_consistent_with_consolidated_level, trigger(financial_entity_responsible_for_consolidated_register), [cite(eu_reg_2024_2956_art_3_3)]).
duty(identifiers_of_providers, providers_identified_by_legal_entity_identifier_or_european_unique_identifier, always, [cite(eu_reg_2024_2956_art_3_5)]).
duty(identifiers_of_subcontractors, subcontractors_identified_by_legal_entity_identifier_or_european_unique_identifier, trigger(entity_uses_ict_services_supporting_critical_or_important_functions), [cite(eu_reg_2024_2956_art_3_6)]).
duty(single_value_per_data_element, data_elements_completed_with_single_values, always, [cite(eu_reg_2024_2956_art_4_1), cite(eu_reg_2024_2956_art_4_2)]).
duty(all_data_elements_completed, all_data_elements_completed_at_each_applicable_level, always, [cite(eu_reg_2024_2956_art_4_3)]).
duty(general_information_on_maintaining_entity, register_includes_general_information_on_maintaining_entity, always, [cite(eu_reg_2024_2956_art_5_1_a)]).
duty(general_information_on_entities_in_consolidation, register_includes_general_information_on_entities_in_consolidation, always, [cite(eu_reg_2024_2956_art_5_1_b)]).
duty(identification_of_branches_outside_home_country, register_includes_identification_of_branches_outside_home_country, trigger(entity_has_branches_outside_home_country), [cite(eu_reg_2024_2956_art_5_1_c)]).
duty(general_information_on_contractual_arrangements, register_includes_general_information_on_contractual_arrangements, always, [cite(eu_reg_2024_2956_art_5_1_d)]).
duty(specific_information_on_contractual_arrangements, register_includes_specific_information_on_contractual_arrangements, always, [cite(eu_reg_2024_2956_art_5_1_e)]).
duty(links_between_intra_group_and_other_arrangements, register_includes_links_between_intra_group_and_other_arrangements, trigger(ict_service_supply_chain_partly_intra_group), [cite(eu_reg_2024_2956_art_5_1_f)]).
duty(entities_signing_arrangements_for_receiving_ict_services, register_includes_entities_signing_arrangements_for_receiving_ict_services, always, [cite(eu_reg_2024_2956_art_5_1_g)]).
duty(providers_signing_arrangements_for_providing_ict_services, register_includes_providers_signing_arrangements_for_providing_ict_services, always, [cite(eu_reg_2024_2956_art_5_1_h)]).
duty(entities_providing_ict_services_within_consolidation, register_includes_entities_providing_ict_services_within_consolidation, always, [cite(eu_reg_2024_2956_art_5_1_i)]).
duty(entities_making_use_of_ict_services, register_includes_entities_making_use_of_ict_services, always, [cite(eu_reg_2024_2956_art_5_1_j)]).
duty(direct_providers_and_subcontractors, register_includes_information_on_direct_providers_and_subcontractors, always, [cite(eu_reg_2024_2956_art_5_1_k)]).
duty(ict_service_supply_chain, register_includes_information_on_ict_service_supply_chain, always, [cite(eu_reg_2024_2956_art_5_1_l)]).
duty(identification_of_functions, register_includes_identification_of_functions, always, [cite(eu_reg_2024_2956_art_5_1_m)]).
duty(assessment_of_ict_services_supporting_critical_or_important_functions, register_includes_assessment_of_ict_services_supporting_critical_or_important_functions, trigger(entity_uses_ict_services_supporting_critical_or_important_functions), [cite(eu_reg_2024_2956_art_5_1_n)]).
duty(terminology_and_closed_lists, register_includes_terminology_and_closed_lists, always, [cite(eu_reg_2024_2956_art_5_1_o)]).

key_state(Profile, Key, State) :-
    findall(Value, profile_get(Profile, Key, Value), Values),
    values_state(Values, State).

values_state([], absent).
values_state([Value], Value).

condition_state(_, always, holds).
condition_state(Profile, trigger(financial_entity_responsible_for_sub_consolidated_register), State) :-
    implements(eu_reg_2024_2956_art_6_1),
    trigger_state(Profile, financial_entity_responsible_for_sub_consolidated_register, State).
condition_state(Profile, trigger(financial_entity_responsible_for_consolidated_register), State) :-
    implements(eu_reg_2024_2956_art_6_1),
    trigger_state(Profile, financial_entity_responsible_for_consolidated_register, State).
condition_state(Profile, trigger(competent_authority_requested_register), State) :-
    implements(eu_reg_2022_2554_art_28_3),
    trigger_state(Profile, competent_authority_requested_register, State).
condition_state(Profile, trigger(entity_plans_arrangement_supporting_critical_or_important_function), State) :-
    implements(eu_reg_2022_2554_art_28_3),
    trigger_state(Profile, entity_plans_arrangement_supporting_critical_or_important_function, State).
condition_state(Profile, trigger(function_has_become_critical_or_important), State) :-
    implements(eu_reg_2022_2554_art_28_3),
    trigger_state(Profile, function_has_become_critical_or_important, State).
condition_state(Profile, trigger(entity_uses_ict_services_supporting_critical_or_important_functions), State) :-
    implements(eu_reg_2024_2956_art_3_2),
    implements(eu_reg_2024_2956_art_3_2_b),
    trigger_state(Profile, entity_uses_ict_services_supporting_critical_or_important_functions, State).
condition_state(Profile, trigger(entity_has_branches_outside_home_country), State) :-
    implements(eu_reg_2024_2956_art_5_1),
    implements(eu_reg_2024_2956_art_5_1_c),
    trigger_state(Profile, entity_has_branches_outside_home_country, State).
condition_state(Profile, trigger(ict_service_supply_chain_partly_intra_group), State) :-
    implements(eu_reg_2024_2956_art_5_1),
    implements(eu_reg_2024_2956_art_5_1_f),
    trigger_state(Profile, ict_service_supply_chain_partly_intra_group, State).

trigger_state(Profile, Trigger, State) :-
    key_state(Profile, Trigger, KeyState),
    trigger_condition_state(KeyState, State).

trigger_condition_state(absent, open).
trigger_condition_state(true, holds).
trigger_condition_state(false, fails).

open_state(holds).
open_state(open).

not_true_state(false).
not_true_state(unsure).
not_true_state(absent).

duty_records(Profile, Records) :-
    implements(eu_reg_2022_2554_art_28_3),
    findall(record(Duty, Key, Condition, ConditionState, KeyState), (duty(Duty, Key, Condition, _), condition_state(Profile, Condition, ConditionState), key_state(Profile, Key, KeyState)), Records).

failing_duties(Records, Failing) :-
    implements(eu_reg_2022_2554_art_28_3),
    findall(Duty, member(record(Duty, _, _, holds, false), Records), Failing).

false_open_triggers(Records, Triggers) :-
    findall(Trigger, member(record(_, _, trigger(Trigger), open, false), Records), AllTriggers),
    sort(AllTriggers, Triggers).

not_true_open_triggers(Records, Triggers) :-
    findall(Trigger, (member(record(_, _, trigger(Trigger), open, KeyState), Records), not_true_state(KeyState)), AllTriggers),
    sort(AllTriggers, Triggers).

unshadowed(always, _).
unshadowed(trigger(Trigger), FalseTriggers) :-
    not_member(Trigger, FalseTriggers).

first_choice([], none).
first_choice([Candidate|Candidates], key(First)) :-
    first_in_key_order([Candidate|Candidates], First).

deciding_choice([Decider|Deciders], _, key(First)) :-
    first_in_key_order([Decider|Deciders], First).
deciding_choice([], Candidates, Choice) :-
    first_choice(Candidates, Choice).

referral_citation(Key, Citation) :-
    duty(_, Key, _, [Citation|_]).

register_of_information_duties_required(Profile, Result, Citations) :-
    dora_register_of_information_input_problems(Profile, Problems),
    required_answer(Problems, Profile, Result, Citations).

required_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
required_answer([], Profile, Result, Citations) :-
    absent_trigger_choice(Profile, Choice),
    required_after_triggers(Choice, Profile, Result, Citations).

absent_trigger_choice(Profile, Choice) :-
    findall(Trigger, (trigger_key(Trigger), key_state(Profile, Trigger, absent)), AbsentTriggers),
    first_choice(AbsentTriggers, Choice).

required_after_triggers(key(Trigger), _, indeterminate([Trigger]), []).
required_after_triggers(none, Profile, required(Duties), Citations) :-
    implements(eu_reg_2022_2554_art_28_3),
    applying_duties(Profile, Duties),
    required_citations(Duties, Citations).

applying_duties(Profile, Duties) :-
    implements(eu_reg_2022_2554_art_28_3),
    findall(Duty, (duty(Duty, _, Condition, _), condition_state(Profile, Condition, holds)), Duties).

required_citations(Duties, Citations) :-
    findall(cite(Paragraph), (member(Duty, Duties), duty(Duty, _, _, DutyCitations), member(cite(CitationKey), DutyCitations), paragraph_of(CitationKey, Paragraph)), AllCitations),
    sort(AllCitations, Citations).

register_of_information_duties_complete(Profile, Result, Citations) :-
    dora_register_of_information_input_problems(Profile, Problems),
    complete_answer(Problems, Profile, Result, Citations).

complete_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
complete_answer([], Profile, Result, Citations) :-
    duty_records(Profile, Records),
    failing_duties(Records, Failing),
    complete_after_failing(Failing, Profile, Records, Result, Citations).

complete_after_failing([_|_], _, _, incomplete, Citations) :-
    implements(eu_reg_2022_2554_art_28_3),
    fixed_citations(Citations).
complete_after_failing([], Profile, Records, Result, Citations) :-
    complete_missing_choice(Records, Choice),
    complete_after_missing(Choice, Profile, Records, Result, Citations).

complete_missing_choice(Records, Choice) :-
    false_open_triggers(Records, FalseTriggers),
    findall(Key, (member(record(_, Key, Condition, ConditionState, absent), Records), open_state(ConditionState), unshadowed(Condition, FalseTriggers)), DutyKeys),
    not_true_open_triggers(Records, TriggerKeys),
    append(DutyKeys, TriggerKeys, Candidates),
    findall(Key, member(record(_, Key, _, holds, absent), Records), ApplyingKeys),
    append(ApplyingKeys, FalseTriggers, Deciders),
    deciding_choice(Deciders, Candidates, Choice).

complete_after_missing(key(Key), _, _, indeterminate([Key]), []).
complete_after_missing(none, Profile, Records, Result, Citations) :-
    complete_unsure_choice(Records, Choice),
    complete_after_unsure(Choice, Profile, Result, Citations).

complete_unsure_choice(Records, Choice) :-
    false_open_triggers(Records, FalseTriggers),
    findall(Key, (member(record(_, Key, Condition, ConditionState, unsure), Records), open_state(ConditionState), unshadowed(Condition, FalseTriggers)), UnsureKeys),
    first_choice(UnsureKeys, Choice).

complete_after_unsure(key(Key), Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    referral_citation(Key, Citation),
    present_pairs(Profile, Pairs).
complete_after_unsure(none, _, complete, Citations) :-
    implements(eu_reg_2022_2554_art_28_3),
    fixed_citations(Citations).

register_of_information_duties_outstanding(Profile, Result, Citations) :-
    dora_register_of_information_input_problems(Profile, Problems),
    outstanding_answer(Problems, Profile, Result, Citations).

outstanding_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
outstanding_answer([], Profile, Result, Citations) :-
    duty_records(Profile, Records),
    outstanding_missing_choice(Records, Choice),
    outstanding_after_missing(Choice, Profile, Records, Result, Citations).

outstanding_missing_choice(Records, Choice) :-
    findall(Key, (member(record(_, Key, _, ConditionState, absent), Records), open_state(ConditionState)), DutyKeys),
    not_true_open_triggers(Records, TriggerKeys),
    append(DutyKeys, TriggerKeys, Candidates),
    first_choice(Candidates, Choice).

outstanding_after_missing(key(Key), _, _, indeterminate([Key]), []).
outstanding_after_missing(none, Profile, Records, Result, Citations) :-
    outstanding_unsure_choice(Records, Choice),
    outstanding_after_unsure(Choice, Profile, Records, Result, Citations).

outstanding_unsure_choice(Records, Choice) :-
    findall(Key, (member(record(_, Key, _, ConditionState, unsure), Records), open_state(ConditionState)), UnsureKeys),
    first_choice(UnsureKeys, Choice).

outstanding_after_unsure(key(Key), Profile, _, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    referral_citation(Key, Citation),
    present_pairs(Profile, Pairs).
outstanding_after_unsure(none, _, Records, Result, Citations) :-
    failing_duties(Records, Failing),
    outstanding_final(Failing, Result, Citations).

outstanding_final([], none_outstanding, Citations) :-
    implements(eu_reg_2022_2554_art_28_3),
    fixed_citations(Citations).
outstanding_final([Duty|Duties], outstanding([Duty|Duties]), Citations) :-
    implements(eu_reg_2022_2554_art_28_3),
    outstanding_citations([Duty|Duties], Citations).

outstanding_citations(Duties, Citations) :-
    findall(Citation, (member(Duty, Duties), duty(Duty, _, _, DutyCitations), member(Citation, DutyCitations)), AllCitations),
    sort(AllCitations, Citations).

decide_dora_register_of_information(Profile, dora_register_of_information_verdict(Result, Citations)) :-
    register_of_information_duties_complete(Profile, Result, Citations).

dora_register_of_information_status(Profile, Status) :-
    decide_dora_register_of_information(Profile, dora_register_of_information_verdict(Result, _Citations)),
    status_name(Result, Status).

status_name(complete, complete).
status_name(incomplete, incomplete).
status_name(indeterminate(_), indeterminate).
status_name(needs_legal_review(_, _), needs_legal_review).
status_name(input_problems(_), input_problems).

dora_register_of_information_checklist(Profile, Items) :-
    dora_register_of_information_input_problems(Profile, Problems),
    checklist_items(Problems, Profile, Items).

checklist_items([_|_], _, []).
checklist_items([], Profile, Items) :-
    duty_records(Profile, Records),
    findall(item(Duty, Status, Citations), (member(record(Duty, Key, Condition, ConditionState, KeyState), Records), duty(Duty, _, _, Citations), item_status(ConditionState, KeyState, Condition, Key, Status)), Items).

item_status(fails, _, _, _, inapplicable).
item_status(open, _, trigger(Trigger), _, unknown([Trigger])).
item_status(holds, true, _, _, met) :-
    implements(eu_reg_2022_2554_art_28_3).
item_status(holds, false, _, _, unmet(not_performed)) :-
    implements(eu_reg_2022_2554_art_28_3).
item_status(holds, unsure, _, Key, unknown([Key])) :-
    implements(eu_reg_2022_2554_art_28_3).
item_status(holds, absent, _, Key, unknown([Key])) :-
    implements(eu_reg_2022_2554_art_28_3).

dora_register_of_information_decision_resolvable(Profile) :-
    decide_dora_register_of_information(Profile, _Verdict).

triggers_false(Attributes) :-
    findall(attribute(Trigger, false), trigger_key(Trigger), Attributes).

always_duties_true(Attributes) :-
    findall(attribute(Key, true), duty(_, Key, always, _), Attributes).

base_profile(Profile) :-
    triggers_false(TriggerAttributes),
    always_duties_true(DutyAttributes),
    append(TriggerAttributes, DutyAttributes, Profile).

with_value([], _, _, []).
with_value([attribute(Key, _)|Rest], Key, Value, [attribute(Key, Value)|NewRest]) :-
    with_value(Rest, Key, Value, NewRest).
with_value([attribute(Other, OtherValue)|Rest], Key, Value, [attribute(Other, OtherValue)|NewRest]) :-
    dif(Other, Key),
    with_value(Rest, Key, Value, NewRest).

test(thirty_four_duties_twenty_two_always) :-
    findall(Duty, duty(Duty, _, _, _), Duties),
    length(Duties, 34),
    findall(Duty, duty(Duty, _, always, _), AlwaysDuties),
    length(AlwaysDuties, 22).
test(duty_keys_follow_the_contract_order) :-
    contract_keys(Keys),
    findall(Trigger, trigger_key(Trigger), Triggers),
    findall(Key, duty(_, Key, _, _), DutyKeys),
    append(Triggers, DutyKeys, Ordered),
    Ordered == Keys.
test(required_empty_profile_names_the_first_trigger) :-
    findall(Result - Citations, register_of_information_duties_required([], Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_responsible_for_sub_consolidated_register]) - []].
test(required_all_triggers_false_lists_the_always_duties) :-
    triggers_false(Profile),
    findall(Result - Citations, register_of_information_duties_required(Profile, Result, Citations), Answers),
    Answers = [required(Duties) - Citations],
    findall(Duty, duty(Duty, _, always, _), Expected),
    Duties == Expected,
    length(Citations, 11).
test(required_sub_consolidated_trigger_adds_its_duties) :-
    triggers_false(Base),
    with_value(Base, financial_entity_responsible_for_sub_consolidated_register, true, Profile),
    register_of_information_duties_required(Profile, required(Duties), Citations),
    member(register_at_sub_consolidated_level, Duties),
    member(consistency_with_sub_consolidated_level, Duties),
    member(cite(eu_reg_2024_2956_art_6_2), Citations).
test(required_reads_no_judgement) :-
    triggers_false(Base),
    append(Base, [attribute(register_maintained_and_updated_at_entity_level, false)], Profile),
    register_of_information_duties_required(Profile, required(_), _).
test(complete_empty_profile_names_the_entity_level_key) :-
    findall(Result - Citations, register_of_information_duties_complete([], Result, Citations), Answers),
    Answers == [indeterminate([register_maintained_and_updated_at_entity_level]) - []].
test(complete_base_profile_is_complete) :-
    base_profile(Profile),
    findall(Result - Citations, register_of_information_duties_complete(Profile, Result, Citations), Answers),
    Answers = [complete - Citations],
    fixed_citations(Fixed),
    Citations == Fixed.
test(complete_a_false_duty_decides_before_absent_keys) :-
    findall(Result, register_of_information_duties_complete([attribute(template_information_meets_data_quality_principles, false)], Result, _), Results),
    Results == [incomplete].
test(complete_a_trigger_that_decides_alone_is_named_first) :-
    always_duties_true(Base),
    append(Base, [attribute(competent_authority_informed_of_planned_arrangement, false)], Profile),
    register_of_information_duties_complete(Profile, Result, Citations),
    Result == indeterminate([entity_plans_arrangement_supporting_critical_or_important_function]),
    Citations == [].
test(complete_unsure_is_referred) :-
    base_profile(Base),
    with_value(Base, template_information_meets_data_quality_principles, unsure, Profile),
    findall(Result, register_of_information_duties_complete(Profile, Result, []), Results),
    Results = [needs_legal_review(open_textured(template_information_meets_data_quality_principles, cite(eu_reg_2024_2956_art_3_3)), [inputs_relied_on(Pairs)])],
    length(Pairs, 30).
test(outstanding_empty_profile_names_the_first_trigger) :-
    register_of_information_duties_outstanding([], Result, []),
    Result == indeterminate([financial_entity_responsible_for_sub_consolidated_register]).
test(outstanding_a_false_duty_does_not_end_the_query) :-
    register_of_information_duties_outstanding([attribute(register_maintained_and_updated_at_entity_level, false)], Result, _),
    Result == indeterminate([financial_entity_responsible_for_sub_consolidated_register]).
test(outstanding_lists_failing_duties_in_duty_order) :-
    base_profile(Base),
    with_value(Base, template_information_meets_data_quality_principles, false, Middle),
    with_value(Middle, register_maintained_and_updated_at_entity_level, false, Profile),
    findall(Result - Citations, register_of_information_duties_outstanding(Profile, Result, Citations), Answers),
    Answers = [outstanding(Duties) - Citations],
    Duties == [register_at_entity_level, data_quality],
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_28_3), cite(eu_reg_2024_2956_art_3_1), cite(eu_reg_2024_2956_art_3_3), cite(eu_reg_2024_2956_art_3_4)].
test(outstanding_base_profile_none_outstanding) :-
    base_profile(Profile),
    register_of_information_duties_outstanding(Profile, none_outstanding, Citations),
    length(Citations, 14).
test(input_problems_come_first) :-
    findall(Result - Citations, register_of_information_duties_complete([attribute(dora_entity_type, credit_institution)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(dora_entity_type)]) - []].
test(facade_verdict_follows_complete) :-
    base_profile(Profile),
    dora_register_of_information_status(Profile, complete),
    dora_register_of_information_checklist(Profile, Items),
    length(Items, 34),
    member(item(register_at_sub_consolidated_level, inapplicable, _), Items),
    member(item(register_at_entity_level, met, [cite(eu_reg_2022_2554_art_28_3), cite(eu_reg_2024_2956_art_3_1)]), Items).

test(complete_base_profile_is_not_incomplete, fail) :-
    base_profile(Profile),
    register_of_information_duties_complete(Profile, incomplete, _).
