% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_ict_operations_and_capacity_dora_rts_ict_operations_and_capacity, [rts_ict_operations_and_capacity_duties_required/3, rts_ict_operations_and_capacity_duties_complete/3, rts_ict_operations_and_capacity_duties_outstanding/3, decide_dora_rts_ict_operations_and_capacity/2, dora_rts_ict_operations_and_capacity_status/2, dora_rts_ict_operations_and_capacity_checklist/2, dora_rts_ict_operations_and_capacity_decision_resolvable/1, dora_rts_ict_operations_and_capacity_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_kernel, [dora_rts_ict_operations_and_capacity_input_problems/2]).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3]).

dora_rts_ict_operations_and_capacity_status_values([complete, incomplete, simplified_framework_entity]).

fixed_citations([cite(eu_reg_2024_1774_art_8_1), cite(eu_reg_2024_1774_art_8_2), cite(eu_reg_2024_1774_art_9_1), cite(eu_reg_2024_1774_art_9_2)]).

duty(ict_operations_policies_and_procedures, ict_operations_policies_and_procedures_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_8_1), always).
duty(ict_operations_policies_specify_management_of_ict_assets, ict_operations_policies_specify_operation_monitoring_control_and_restoration_of_ict_assets, cite(eu_reg_2024_1774_art_8_1), always).
duty(secure_installation_maintenance_configuration_and_deinstallation, ict_operations_policies_cover_secure_installation_to_deinstallation_of_ict_systems, cite(eu_reg_2024_1774_art_8_2_a_i), always).
duty(management_of_information_assets, ict_operations_policies_cover_management_of_information_assets_used_by_ict_assets, cite(eu_reg_2024_1774_art_8_2_a_ii), always).
duty(identification_and_control_of_legacy_ict_systems, ict_operations_policies_cover_identification_and_control_of_legacy_ict_systems, cite(eu_reg_2024_1774_art_8_2_a_iii), always).
duty(backup_and_restore_requirements, ict_operations_policies_cover_backup_and_restore_requirements, cite(eu_reg_2024_1774_art_8_2_b_i), always).
duty(scheduling_requirements, ict_operations_policies_cover_scheduling_requirements_considering_interdependencies, cite(eu_reg_2024_1774_art_8_2_b_ii), always).
duty(audit_trail_and_system_log_protocols, ict_operations_policies_cover_audit_trail_and_system_log_protocols, cite(eu_reg_2024_1774_art_8_2_b_iii), always).
duty(audit_and_testing_with_minimal_disruption, ict_operations_policies_cover_internal_audit_and_testing_minimising_disruption, cite(eu_reg_2024_1774_art_8_2_b_iv), always).
duty(separation_of_production_environments, ict_operations_policies_cover_separation_of_production_from_non_production_environments, cite(eu_reg_2024_1774_art_8_2_b_v), always).
duty(development_and_testing_in_separated_environments, ict_operations_policies_cover_development_and_testing_in_separated_environments, cite(eu_reg_2024_1774_art_8_2_b_vi), always).
duty(development_and_testing_in_production_environments, ict_operations_policies_cover_development_and_testing_in_production_environments, cite(eu_reg_2024_1774_art_8_2_b_vii), always).
duty(error_handling_procedures_and_protocols, ict_operations_policies_cover_error_handling_procedures_and_protocols, cite(eu_reg_2024_1774_art_8_2_c_i), always).
duty(support_and_escalation_contacts, ict_operations_policies_cover_support_and_escalation_contacts, cite(eu_reg_2024_1774_art_8_2_c_ii), always).
duty(restart_rollback_and_recovery_procedures, ict_operations_policies_cover_restart_rollback_and_recovery_procedures, cite(eu_reg_2024_1774_art_8_2_c_iii), always).
duty(separation_considers_all_environment_components, environment_separation_considers_all_components_of_the_environment, cite(eu_reg_2024_1774_art_8_2), always).
duty(production_testing_instances_identified_and_approved, production_testing_instances_identified_reasoned_time_limited_and_approved, cite(eu_reg_2024_1774_art_8_2), always).
duty(security_during_production_testing, security_of_ict_systems_and_production_data_ensured_during_production_testing, cite(eu_reg_2024_1774_art_8_2), production).
duty(capacity_and_performance_management_procedures, capacity_and_performance_management_procedures_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_9_1), always).
duty(identification_of_capacity_requirements, capacity_procedures_identify_capacity_requirements_of_ict_systems, cite(eu_reg_2024_1774_art_9_1_a), always).
duty(application_of_resource_optimisation, capacity_procedures_apply_resource_optimisation, cite(eu_reg_2024_1774_art_9_1_b), always).
duty(monitoring_of_availability, capacity_monitoring_maintains_and_improves_availability_of_data_and_ict_systems, cite(eu_reg_2024_1774_art_9_1_c_i), always).
duty(monitoring_of_efficiency, capacity_monitoring_maintains_and_improves_efficiency_of_ict_systems, cite(eu_reg_2024_1774_art_9_1_c_ii), always).
duty(prevention_of_capacity_shortages, capacity_monitoring_maintains_and_improves_prevention_of_ict_capacity_shortages, cite(eu_reg_2024_1774_art_9_1_c_iii), always).
duty(measures_for_long_procurement_or_resource_intensive_systems, capacity_procedures_ensure_measures_for_long_procurement_or_resource_intensive_systems, cite(eu_reg_2024_1774_art_9_2), always).

key_state(Profile, Key, State) :-
    findall(Value, profile_get(Profile, Key, Value), Values),
    value_state(Values, State).

value_state([], absent).
value_state([Value], present(Value)).

root_keys([financial_entity_is_article_16_1_entity, development_or_testing_performed_in_production_environment|DutyKeys]) :-
    findall(Key, duty(_, Key, _, _), DutyKeys).

relied_pairs(Profile, Pairs) :-
    root_keys(Keys),
    findall(Key - Value, (member(Key, Keys), profile_get(Profile, Key, Value)), Pairs).

condition_standing(always, _, applies).
condition_standing(production, present(true), applies) :-
    implements(eu_reg_2024_1774_art_8_2).
condition_standing(production, present(false), excluded) :-
    implements(eu_reg_2024_1774_art_8_2).
condition_standing(production, absent, open).

duty_states(Profile, TriggerState, States) :-
    findall(duty(Duty, Key, Citation, Condition), duty(Duty, Key, Citation, Condition), Duties),
    maplist(duty_state(Profile, TriggerState), Duties, States).

duty_state(Profile, TriggerState, duty(Duty, Key, Citation, Condition), state(Duty, Key, Citation, Standing, Value)) :-
    condition_standing(Condition, TriggerState, Standing),
    key_state(Profile, Key, Value).

profile_duty_states(Profile, States) :-
    key_state(Profile, development_or_testing_performed_in_production_environment, TriggerState),
    duty_states(Profile, TriggerState, States).

not_true(absent).
not_true(present(false)).
not_true(present(unsure)).

open_standing(applies).
open_standing(open).

failing_duties(States, Duties) :-
    implements(eu_reg_2024_1774_art_8_1),
    findall(Duty, member(state(Duty, _, _, applies, present(false)), States), Duties).

absent_applying_keys(States, Keys) :-
    findall(Key, member(state(_, Key, _, applies, absent), States), Keys).

deciding_trigger(States, Triggers) :-
    implements(eu_reg_2024_1774_art_8_2),
    findall(development_or_testing_performed_in_production_environment, member(state(_, _, _, open, present(false)), States), Found),
    sort(Found, Triggers).

changing_trigger(States, Triggers) :-
    implements(eu_reg_2024_1774_art_8_2),
    findall(development_or_testing_performed_in_production_environment, (member(state(_, _, _, open, Value), States), not_true(Value)), Found),
    sort(Found, Triggers).

unsure_open_keys(States, Unsure) :-
    findall(unsure(Key, Citation), (member(state(_, Key, Citation, Standing, present(unsure)), States), open_standing(Standing)), Unsure).

preliminary(Profile, Outcome) :-
    dora_rts_ict_operations_and_capacity_input_problems(Profile, Problems),
    preliminary_after_check(Problems, Profile, Outcome).

preliminary_after_check([Problem|Problems], _, answer(input_problems([Problem|Problems]), [])).
preliminary_after_check([], Profile, Outcome) :-
    key_state(Profile, financial_entity_is_article_16_1_entity, GateState),
    preliminary_after_gate(GateState, Outcome).

preliminary_after_gate(present(true), answer(simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)])) :-
    implements(eu_reg_2022_2554_art_16_1).
preliminary_after_gate(absent, answer(indeterminate([financial_entity_is_article_16_1_entity]), [])).
preliminary_after_gate(present(false), proceed) :-
    implements(eu_reg_2022_2554_art_16_1).

rts_ict_operations_and_capacity_duties_required(Profile, Result, Citations) :-
    preliminary(Profile, Outcome),
    required_answer(Outcome, Profile, Result, Citations).

required_answer(answer(Result, Citations), _, Result, Citations).
required_answer(proceed, Profile, Result, Citations) :-
    key_state(Profile, development_or_testing_performed_in_production_environment, TriggerState),
    required_after_trigger(TriggerState, Profile, Result, Citations).

required_after_trigger(absent, _, indeterminate([development_or_testing_performed_in_production_environment]), []) :-
    implements(eu_reg_2024_1774_art_8_2).
required_after_trigger(present(TriggerValue), Profile, required(Duties), Citations) :-
    implements(eu_reg_2024_1774_art_8_1),
    duty_states(Profile, present(TriggerValue), States),
    findall(Duty, member(state(Duty, _, _, applies, _), States), Duties),
    fixed_citations(Citations).

rts_ict_operations_and_capacity_duties_complete(Profile, Result, Citations) :-
    preliminary(Profile, Outcome),
    complete_answer(Outcome, Profile, Result, Citations).

complete_answer(answer(Result, Citations), _, Result, Citations).
complete_answer(proceed, Profile, Result, Citations) :-
    profile_duty_states(Profile, States),
    failing_duties(States, Failing),
    complete_from_failing(Failing, States, Finding),
    complete_result(Finding, Profile, Result, Citations).

complete_from_failing([_|_], _, failing).
complete_from_failing([], States, Finding) :-
    deciding_trigger(States, DecidingTrigger),
    absent_applying_keys(States, AbsentKeys),
    changing_trigger(States, ChangingTrigger),
    append(DecidingTrigger, AbsentKeys, Leading),
    append(Leading, ChangingTrigger, Candidates),
    from_missing(Candidates, States, Finding).

from_missing([Key|_], _, missing(Key)).
from_missing([], States, Finding) :-
    unsure_open_keys(States, Unsure),
    from_unsure(Unsure, Finding).

from_unsure([unsure(Key, Citation)|_], referral(Key, Citation)).
from_unsure([], settled).

complete_result(failing, _, incomplete, Citations) :-
    implements(eu_reg_2024_1774_art_8_1),
    fixed_citations(Citations).
complete_result(missing(Key), _, indeterminate([Key]), []).
complete_result(referral(Key, Citation), Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    relied_pairs(Profile, Pairs).
complete_result(settled, _, complete, Citations) :-
    implements(eu_reg_2024_1774_art_8_1),
    fixed_citations(Citations).

rts_ict_operations_and_capacity_duties_outstanding(Profile, Result, Citations) :-
    preliminary(Profile, Outcome),
    outstanding_answer(Outcome, Profile, Result, Citations).

outstanding_answer(answer(Result, Citations), _, Result, Citations).
outstanding_answer(proceed, Profile, Result, Citations) :-
    profile_duty_states(Profile, States),
    changing_trigger(States, ChangingTrigger),
    absent_applying_keys(States, AbsentKeys),
    append(ChangingTrigger, AbsentKeys, Candidates),
    outstanding_from_missing(Candidates, States, Finding),
    outstanding_result(Finding, Profile, Result, Citations).

outstanding_from_missing([Key|_], _, missing(Key)).
outstanding_from_missing([], States, Finding) :-
    unsure_open_keys(States, Unsure),
    outstanding_from_unsure(Unsure, States, Finding).

outstanding_from_unsure([unsure(Key, Citation)|_], _, referral(Key, Citation)).
outstanding_from_unsure([], States, final(Duties, Citations)) :-
    failing_duties(States, Duties),
    findall(Citation, member(state(_, _, Citation, applies, present(false)), States), Found),
    sort(Found, Citations).

outstanding_result(missing(Key), _, indeterminate([Key]), []).
outstanding_result(referral(Key, Citation), Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    relied_pairs(Profile, Pairs).
outstanding_result(final([], _), _, none_outstanding, Citations) :-
    implements(eu_reg_2024_1774_art_8_1),
    fixed_citations(Citations).
outstanding_result(final([Duty|Duties], Citations), _, outstanding([Duty|Duties]), Citations) :-
    implements(eu_reg_2024_1774_art_8_1).

decide_dora_rts_ict_operations_and_capacity(Profile, dora_rts_ict_operations_and_capacity_verdict(Status, Citations)) :-
    rts_ict_operations_and_capacity_duties_complete(Profile, Status, Citations).

dora_rts_ict_operations_and_capacity_status(Profile, Status) :-
    decide_dora_rts_ict_operations_and_capacity(Profile, dora_rts_ict_operations_and_capacity_verdict(Status, _Citations)).

dora_rts_ict_operations_and_capacity_checklist(Profile, Items) :-
    dora_rts_ict_operations_and_capacity_input_problems(Profile, []),
    key_state(Profile, financial_entity_is_article_16_1_entity, GateState),
    checklist_after_gate(GateState, Profile, Items).

checklist_after_gate(present(true), _, [item(article_16_1_entity, met, cite(eu_reg_2022_2554_art_16_1))]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_after_gate(absent, _, [item(article_16_1_entity, unknown([financial_entity_is_article_16_1_entity]), cite(eu_reg_2022_2554_art_16_1))]).
checklist_after_gate(present(false), Profile, [item(article_16_1_entity, unmet(not_article_16_1_entity), cite(eu_reg_2022_2554_art_16_1))|Items]) :-
    implements(eu_reg_2022_2554_art_16_1),
    profile_duty_states(Profile, States),
    maplist(state_item, States, Items).

state_item(state(Duty, _, Citation, applies, present(true)), item(Duty, met, Citation)).
state_item(state(Duty, _, Citation, applies, present(false)), item(Duty, unmet(not_performed), Citation)).
state_item(state(Duty, Key, Citation, applies, present(unsure)), item(Duty, unknown([Key]), Citation)).
state_item(state(Duty, Key, Citation, applies, absent), item(Duty, unknown([Key]), Citation)).
state_item(state(Duty, _, Citation, excluded, _), item(Duty, inapplicable, Citation)).
state_item(state(Duty, _, Citation, open, _), item(Duty, unknown([development_or_testing_performed_in_production_environment]), Citation)).

dora_rts_ict_operations_and_capacity_decision_resolvable(Profile) :-
    decide_dora_rts_ict_operations_and_capacity(Profile, _Verdict).

test_profile(TriggerValue, Profile) :-
    findall(attribute(Key, true), duty(_, Key, _, _), DutyAttributes),
    Profile = [attribute(financial_entity_is_article_16_1_entity, false), attribute(development_or_testing_performed_in_production_environment, TriggerValue)|DutyAttributes].

remove_key([], _, []).
remove_key([attribute(Key, _)|Rest], Key, Remaining) :-
    remove_key(Rest, Key, Remaining).
remove_key([attribute(Other, Value)|Rest], Key, [attribute(Other, Value)|Remaining]) :-
    dif(Other, Key),
    remove_key(Rest, Key, Remaining).

set_key([], _, _, []).
set_key([attribute(Key, _)|Rest], Key, Value, [attribute(Key, Value)|Changed]) :-
    set_key(Rest, Key, Value, Changed).
set_key([attribute(Other, OldValue)|Rest], Key, Value, [attribute(Other, OldValue)|Changed]) :-
    dif(Other, Key),
    set_key(Rest, Key, Value, Changed).

same_citations(Citations, Expected) :-
    clausal_msort(Citations, Sorted),
    clausal_msort(Expected, Sorted).

test(an_unknown_key_is_an_input_problem) :-
    rts_ict_operations_and_capacity_duties_complete([attribute(colour, true)], input_problems([unknown_key(colour)]), []).
test(a_repeated_key_is_a_duplicate) :-
    rts_ict_operations_and_capacity_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_article_16_1_entity, false)], input_problems([duplicate_key(financial_entity_is_article_16_1_entity)]), []).
test(the_gate_true_gives_the_simplified_framework) :-
    rts_ict_operations_and_capacity_duties_complete([attribute(financial_entity_is_article_16_1_entity, true), attribute(capacity_procedures_apply_resource_optimisation, false)], simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(the_gate_absent_is_asked_first) :-
    rts_ict_operations_and_capacity_duties_outstanding([attribute(capacity_procedures_apply_resource_optimisation, false)], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(required_asks_for_the_trigger) :-
    rts_ict_operations_and_capacity_duties_required([attribute(financial_entity_is_article_16_1_entity, false)], indeterminate([development_or_testing_performed_in_production_environment]), []).
test(required_without_production_lists_twenty_four_duties) :-
    test_profile(false, Profile),
    rts_ict_operations_and_capacity_duties_required(Profile, required(Duties), Citations),
    length(Duties, 24),
    fixed_citations(Fixed),
    same_citations(Citations, Fixed).
test(required_with_production_lists_twenty_five_duties) :-
    test_profile(true, Profile),
    rts_ict_operations_and_capacity_duties_required(Profile, required(Duties), _),
    length(Duties, 25),
    member(security_during_production_testing, Duties).
test(all_duties_performed_is_complete) :-
    test_profile(false, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, complete, Citations),
    fixed_citations(Fixed),
    same_citations(Citations, Fixed).
test(a_failing_duty_decides_before_absent_keys) :-
    rts_ict_operations_and_capacity_duties_complete([attribute(financial_entity_is_article_16_1_entity, false), attribute(capacity_procedures_apply_resource_optimisation, false)], incomplete, _).
test(the_trigger_decides_alone_when_the_conditional_duty_is_false) :-
    test_profile(true, Start),
    remove_key(Start, development_or_testing_performed_in_production_environment, WithoutTrigger),
    set_key(WithoutTrigger, security_of_ict_systems_and_production_data_ensured_during_production_testing, false, WithFalse),
    remove_key(WithFalse, capacity_procedures_apply_resource_optimisation, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, indeterminate([development_or_testing_performed_in_production_environment]), []).
test(an_always_duty_waits_for_nothing_when_the_trigger_cannot_decide_alone) :-
    test_profile(true, Start),
    remove_key(Start, development_or_testing_performed_in_production_environment, WithoutTrigger),
    remove_key(WithoutTrigger, security_of_ict_systems_and_production_data_ensured_during_production_testing, WithoutSecurity),
    remove_key(WithoutSecurity, capacity_procedures_apply_resource_optimisation, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, indeterminate([capacity_procedures_apply_resource_optimisation]), []).
test(outstanding_asks_the_trigger_first) :-
    test_profile(true, Start),
    remove_key(Start, development_or_testing_performed_in_production_environment, WithoutTrigger),
    remove_key(WithoutTrigger, security_of_ict_systems_and_production_data_ensured_during_production_testing, WithoutSecurity),
    remove_key(WithoutSecurity, capacity_procedures_apply_resource_optimisation, Profile),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, indeterminate([development_or_testing_performed_in_production_environment]), []).
test(the_trigger_is_not_needed_when_the_conditional_duty_is_true) :-
    test_profile(true, Start),
    remove_key(Start, development_or_testing_performed_in_production_environment, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, complete, _).
test(an_unsure_judgement_is_referred) :-
    test_profile(false, Start),
    set_key(Start, capacity_procedures_apply_resource_optimisation, unsure, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, needs_legal_review(open_textured(capacity_procedures_apply_resource_optimisation, cite(eu_reg_2024_1774_art_9_1_b)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 27),
    member(capacity_procedures_apply_resource_optimisation - unsure, Pairs).
test(outstanding_lists_failing_duties_in_duty_order) :-
    test_profile(true, Start),
    set_key(Start, security_of_ict_systems_and_production_data_ensured_during_production_testing, false, WithSecurity),
    set_key(WithSecurity, ict_operations_policies_cover_backup_and_restore_requirements, false, Profile),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, outstanding([backup_and_restore_requirements, security_during_production_testing]), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1774_art_8_2), cite(eu_reg_2024_1774_art_8_2_b_i)]).
test(a_duty_that_does_not_apply_is_not_outstanding) :-
    test_profile(false, Start),
    set_key(Start, security_of_ict_systems_and_production_data_ensured_during_production_testing, false, Profile),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, none_outstanding, _).
test(each_query_yields_exactly_one_solution) :-
    test_profile(true, Start),
    set_key(Start, ict_operations_policies_cover_backup_and_restore_requirements, false, Profile),
    findall(Result - Citations, rts_ict_operations_and_capacity_duties_required(Profile, Result, Citations), Required),
    findall(Result - Citations, rts_ict_operations_and_capacity_duties_complete(Profile, Result, Citations), Complete),
    findall(Result - Citations, rts_ict_operations_and_capacity_duties_outstanding(Profile, Result, Citations), Outstanding),
    length(Required, 1),
    length(Complete, 1),
    length(Outstanding, 1).
test(the_checklist_has_a_row_per_duty) :-
    test_profile(false, Profile),
    dora_rts_ict_operations_and_capacity_checklist(Profile, [item(article_16_1_entity, unmet(not_article_16_1_entity), cite(eu_reg_2022_2554_art_16_1))|Items]),
    length(Items, 25),
    member(item(security_during_production_testing, inapplicable, cite(eu_reg_2024_1774_art_8_2)), Items).
test(the_facade_status_is_the_complete_result) :-
    test_profile(false, Profile),
    dora_rts_ict_operations_and_capacity_status(Profile, complete).

test(required_without_production_omits_the_security_duty, fail) :-
    test_profile(false, Profile),
    rts_ict_operations_and_capacity_duties_required(Profile, required(Duties), _),
    member(security_during_production_testing, Duties).
test(a_failing_duty_is_not_complete, fail) :-
    rts_ict_operations_and_capacity_duties_complete([attribute(financial_entity_is_article_16_1_entity, false), attribute(capacity_procedures_apply_resource_optimisation, false)], complete, _).
