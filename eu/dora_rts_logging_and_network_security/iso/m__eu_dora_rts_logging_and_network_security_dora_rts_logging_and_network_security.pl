% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_logging_and_network_security_dora_rts_logging_and_network_security, [decide_dora_rts_logging_and_network_security/2, dora_rts_logging_and_network_security_status/2, dora_rts_logging_and_network_security_checklist/2, dora_rts_logging_and_network_security_decision_resolvable/1, dora_rts_logging_and_network_security_status_values/1, rts_logging_and_network_security_duties_required/3, rts_logging_and_network_security_duties_complete/3, rts_logging_and_network_security_duties_outstanding/3, complete/0, incomplete/0, none_outstanding/0, simplified_framework_entity/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(m__eu_dora_rts_logging_and_network_security_kernel, [dora_rts_logging_and_network_security_input_problems/2]).
:- use_module(m__eu_dora_rts_logging_and_network_security_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

complete.

incomplete.

none_outstanding.

simplified_framework_entity.

duty(logging_procedures_protocols_and_tools, logging_procedures_protocols_and_tools_developed_documented_and_implemented, always, [cite(eu_reg_2024_1774_art_12_1)], cite(eu_reg_2024_1774_art_12_1)).
duty(logged_events_retention_and_log_data_security, logging_procedures_identify_logged_events_retention_and_log_data_security, always, [cite(eu_reg_2024_1774_art_12_2_a)], cite(eu_reg_2024_1774_art_12_2_a)).
duty(log_detail_aligned_with_purpose, logging_detail_aligned_with_purpose_and_usage, always, [cite(eu_reg_2024_1774_art_12_2_b)], cite(eu_reg_2024_1774_art_12_2_b)).
duty(logging_of_access_control_and_identity_management_events, logging_covers_access_control_and_identity_management_events, always, [cite(eu_reg_2024_1774_art_12_2_c_i)], cite(eu_reg_2024_1774_art_12_2_c_i)).
duty(logging_of_capacity_management_events, logging_covers_capacity_management_events, always, [cite(eu_reg_2024_1774_art_12_2_c_ii)], cite(eu_reg_2024_1774_art_12_2_c_ii)).
duty(logging_of_change_management_events, logging_covers_change_management_events, always, [cite(eu_reg_2024_1774_art_12_2_c_iii)], cite(eu_reg_2024_1774_art_12_2_c_iii)).
duty(logging_of_ict_operations_events, logging_covers_ict_operations_events, always, [cite(eu_reg_2024_1774_art_12_2_c_iv)], cite(eu_reg_2024_1774_art_12_2_c_iv)).
duty(logging_of_network_traffic_events, logging_covers_network_traffic_events, always, [cite(eu_reg_2024_1774_art_12_2_c_v)], cite(eu_reg_2024_1774_art_12_2_c_v)).
duty(protection_of_logging_systems_and_log_information, logging_systems_and_log_information_protected, always, [cite(eu_reg_2024_1774_art_12_2_d)], cite(eu_reg_2024_1774_art_12_2_d)).
duty(detection_of_logging_system_failure, logging_system_failure_detection_measures_in_place, always, [cite(eu_reg_2024_1774_art_12_2_e)], cite(eu_reg_2024_1774_art_12_2_e)).
duty(clock_synchronisation, ict_system_clocks_synchronised_to_reliable_reference_time_source, always, [cite(eu_reg_2024_1774_art_12_2_f)], cite(eu_reg_2024_1774_art_12_2_f)).
duty(log_retention_period, log_retention_period_established_taking_into_account_required_considerations, always, [cite(eu_reg_2024_1774_art_12_2)], cite(eu_reg_2024_1774_art_12_2)).
duty(network_security_management_policies_procedures_protocols_and_tools, network_security_management_policies_procedures_protocols_and_tools_developed_documented_and_implemented, always, [cite(eu_reg_2024_1774_art_13)], cite(eu_reg_2024_1774_art_13)).
duty(network_segregation_and_segmentation, network_segregation_and_segmentation_considering_criticality_classification_and_risk_profile, always, [cite(eu_reg_2024_1774_art_13_a), cite(eu_reg_2024_1774_art_13_a_i), cite(eu_reg_2024_1774_art_13_a_ii), cite(eu_reg_2024_1774_art_13_a_iii)], cite(eu_reg_2024_1774_art_13_a)).
duty(documentation_of_network_connections_and_data_flows, network_connections_and_data_flows_documented, always, [cite(eu_reg_2024_1774_art_13_b)], cite(eu_reg_2024_1774_art_13_b)).
duty(separate_administration_network, separate_dedicated_administration_network_used, always, [cite(eu_reg_2024_1774_art_13_c)], cite(eu_reg_2024_1774_art_13_c)).
duty(network_access_controls, network_access_controls_identified_and_implemented, always, [cite(eu_reg_2024_1774_art_13_d)], cite(eu_reg_2024_1774_art_13_d)).
duty(encryption_of_network_connections, network_connections_encrypted, always, [cite(eu_reg_2024_1774_art_13_e)], cite(eu_reg_2024_1774_art_13_e)).
duty(network_design, networks_designed_in_line_with_ict_security_requirements, always, [cite(eu_reg_2024_1774_art_13_f)], cite(eu_reg_2024_1774_art_13_f)).
duty(securing_of_external_network_traffic, traffic_to_internet_and_external_connections_secured, always, [cite(eu_reg_2024_1774_art_13_g)], cite(eu_reg_2024_1774_art_13_g)).
duty(firewall_rule_roles_responsibilities_and_steps, firewall_rules_roles_responsibilities_and_steps_identified, always, [cite(eu_reg_2024_1774_art_13_h)], cite(eu_reg_2024_1774_art_13_h)).
duty(yearly_network_architecture_review, network_architecture_and_security_design_reviewed_once_a_year, when(financial_entity_is_microenterprise, false), [cite(eu_reg_2024_1774_art_13_i)], cite(eu_reg_2024_1774_art_13_i)).
duty(periodic_network_architecture_review, network_architecture_and_security_design_reviewed_periodically, when(financial_entity_is_microenterprise, true), [cite(eu_reg_2024_1774_art_13_i)], cite(eu_reg_2024_1774_art_13_i)).
duty(network_isolation_measures, subnetworks_and_network_components_isolation_measures_in_place, always, [cite(eu_reg_2024_1774_art_13_j)], cite(eu_reg_2024_1774_art_13_j)).
duty(secure_configuration_baseline_and_hardening, secure_network_configuration_baseline_and_hardening_implemented, always, [cite(eu_reg_2024_1774_art_13_k)], cite(eu_reg_2024_1774_art_13_k)).
duty(inactive_session_limitation, inactive_system_and_remote_sessions_limited_locked_and_terminated, always, [cite(eu_reg_2024_1774_art_13_l)], cite(eu_reg_2024_1774_art_13_l)).
duty(network_services_security_measures_and_service_levels, network_services_security_measures_and_service_levels_specified, always, [cite(eu_reg_2024_1774_art_13_m_i)], cite(eu_reg_2024_1774_art_13_m_i)).
duty(network_services_provider_identification, network_services_provider_type_identified, always, [cite(eu_reg_2024_1774_art_13_m_ii)], cite(eu_reg_2024_1774_art_13_m_ii)).
duty(regular_firewall_rule_review, firewall_rules_and_connection_filters_reviewed_on_a_regular_basis, always, [cite(eu_reg_2024_1774_art_13)], cite(eu_reg_2024_1774_art_13)).
duty(six_monthly_firewall_rule_verification, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, when(financial_entity_has_ict_systems_supporting_critical_or_important_functions, true), [cite(eu_reg_2024_1774_art_13)], cite(eu_reg_2024_1774_art_13)).
duty(information_in_transit_policies_procedures_protocols_and_tools, information_in_transit_policies_procedures_protocols_and_tools_developed_documented_and_implemented, always, [cite(eu_reg_2024_1774_art_14_1)], cite(eu_reg_2024_1774_art_14_1)).
duty(data_security_during_network_transmission, data_protected_during_network_transmission_with_compliance_assessment, always, [cite(eu_reg_2024_1774_art_14_1_a)], cite(eu_reg_2024_1774_art_14_1_a)).
duty(data_leakage_prevention_and_secure_external_transfer, data_leakage_prevented_and_detected_and_external_transfer_secured, always, [cite(eu_reg_2024_1774_art_14_1_b)], cite(eu_reg_2024_1774_art_14_1_b)).
duty(confidentiality_and_non_disclosure_requirements, confidentiality_and_non_disclosure_requirements_implemented_documented_and_reviewed, always, [cite(eu_reg_2024_1774_art_14_1_c)], cite(eu_reg_2024_1774_art_14_1_c)).
duty(information_in_transit_design_basis, information_in_transit_policies_designed_on_classification_and_risk_assessment, always, [cite(eu_reg_2024_1774_art_14_2)], cite(eu_reg_2024_1774_art_14_2)).

trigger_key(financial_entity_is_article_16_1_entity).
trigger_key(financial_entity_is_microenterprise).
trigger_key(financial_entity_has_ict_systems_supporting_critical_or_important_functions).

root_key(ProfileKey) :-
    trigger_key(ProfileKey).
root_key(ProfileKey) :-
    duty(_, ProfileKey, _, _, _).

dora_rts_logging_and_network_security_status_values([complete, incomplete, simplified_framework_entity, indeterminate, needs_legal_review, input_problems]).

key_state(Profile, ProfileKey, present(Value)) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, Value).
key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).

value_is_t(absent, _, false).
value_is_t(present(Value), Wanted, true) :-
    Value == Wanted.
value_is_t(present(Value), Wanted, false) :-
    Value \== Wanted.

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

exclusive_or(true, true, false).
exclusive_or(true, false, true).
exclusive_or(false, true, true).
exclusive_or(false, false, false).

list_non_empty_t([], false).
list_non_empty_t([_|_], true).

duty_standing(_, always, applies).
duty_standing(Profile, when(financial_entity_is_microenterprise, Wanted), Standing) :-
    implements(eu_reg_2024_1774_art_13_i),
    key_state(Profile, financial_entity_is_microenterprise, TriggerState),
    trigger_standing(TriggerState, Wanted, Standing).
duty_standing(Profile, when(financial_entity_has_ict_systems_supporting_critical_or_important_functions, Wanted), Standing) :-
    implements(eu_reg_2024_1774_art_13),
    key_state(Profile, financial_entity_has_ict_systems_supporting_critical_or_important_functions, TriggerState),
    trigger_standing(TriggerState, Wanted, Standing).

trigger_standing(absent, _, possible).
trigger_standing(present(Value), Wanted, applies) :-
    Value == Wanted.
trigger_standing(present(Value), Wanted, inapplicable) :-
    Value \== Wanted.

open_standing(applies, true).
open_standing(possible, false).

duty_applies(Profile, DutyAtom) :-
    duty(DutyAtom, _, Applicability, _, _),
    duty_standing(Profile, Applicability, applies).

duty_fails(Profile, DutyAtom) :-
    duty(DutyAtom, ProfileKey, Applicability, _, _),
    duty_standing(Profile, Applicability, applies),
    key_state(Profile, ProfileKey, present(false)).

failing_duties(Profile, Failing) :-
    findall(DutyAtom, duty_fails(Profile, DutyAtom), Failing).

review_states(Profile, YearlyState, PeriodicState) :-
    key_state(Profile, network_architecture_and_security_design_reviewed_once_a_year, YearlyState),
    key_state(Profile, network_architecture_and_security_design_reviewed_periodically, PeriodicState).

both_reviews_false_t(Profile, Truth) :-
    implements(eu_reg_2024_1774_art_13_i),
    review_states(Profile, YearlyState, PeriodicState),
    value_is_t(YearlyState, false, YearlyFalse),
    value_is_t(PeriodicState, false, PeriodicFalse),
    truth_and(YearlyFalse, PeriodicFalse, Truth).

missing_candidates(Profile, Candidates) :-
    microenterprise_candidates(Profile, MicroenterpriseCandidates),
    critical_function_candidates(Profile, CriticalFunctionCandidates),
    findall(ProfileKey - DecidesAlone, duty_key_candidate(Profile, ProfileKey, DecidesAlone), DutyCandidates),
    append([MicroenterpriseCandidates, CriticalFunctionCandidates, DutyCandidates], Candidates).

microenterprise_candidates(Profile, Candidates) :-
    implements(eu_reg_2024_1774_art_13_i),
    key_state(Profile, financial_entity_is_microenterprise, MicroenterpriseState),
    review_states(Profile, YearlyState, PeriodicState),
    microenterprise_candidates_from(MicroenterpriseState, YearlyState, PeriodicState, Candidates).

microenterprise_candidates_from(present(_), _, _, []).
microenterprise_candidates_from(absent, YearlyState, PeriodicState, Candidates) :-
    value_is_t(YearlyState, true, YearlyTrue),
    value_is_t(PeriodicState, true, PeriodicTrue),
    truth_and(YearlyTrue, PeriodicTrue, BothTrue),
    value_is_t(YearlyState, false, YearlyFalse),
    value_is_t(PeriodicState, false, PeriodicFalse),
    exclusive_or(YearlyFalse, PeriodicFalse, DecidesAlone),
    microenterprise_candidate_when(BothTrue, DecidesAlone, Candidates).

microenterprise_candidate_when(true, _, []).
microenterprise_candidate_when(false, DecidesAlone, [financial_entity_is_microenterprise - DecidesAlone]).

critical_function_candidates(Profile, Candidates) :-
    implements(eu_reg_2024_1774_art_13),
    key_state(Profile, financial_entity_has_ict_systems_supporting_critical_or_important_functions, CriticalFunctionState),
    key_state(Profile, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, VerificationState),
    critical_function_candidates_from(CriticalFunctionState, VerificationState, Candidates).

critical_function_candidates_from(present(_), _, []).
critical_function_candidates_from(absent, VerificationState, Candidates) :-
    value_is_t(VerificationState, true, VerificationTrue),
    value_is_t(VerificationState, false, VerificationFalse),
    critical_function_candidate_when(VerificationTrue, VerificationFalse, Candidates).

critical_function_candidate_when(true, _, []).
critical_function_candidate_when(false, DecidesAlone, [financial_entity_has_ict_systems_supporting_critical_or_important_functions - DecidesAlone]).

duty_key_candidate(Profile, ProfileKey, DecidesAlone) :-
    duty(_, ProfileKey, Applicability, _, _),
    key_state(Profile, ProfileKey, absent),
    duty_standing(Profile, Applicability, Standing),
    open_standing(Standing, DecidesAlone).

first_named([ProfileKey|_], _, missing(ProfileKey)).
first_named([], [ProfileKey|_], missing(ProfileKey)).
first_named([], [], no_missing_key).

completeness_missing_key(Candidates, Choice) :-
    findall(ProfileKey, member(ProfileKey - true, Candidates), AloneKeys),
    pairs_keys(Candidates, CandidateKeys),
    first_named(AloneKeys, CandidateKeys, Choice).

outstanding_missing_key(Candidates, Choice) :-
    pairs_keys(Candidates, CandidateKeys),
    first_named([], CandidateKeys, Choice).

unsure_open_key(Profile, ProfileKey, Referral) :-
    duty(_, ProfileKey, Applicability, _, Referral),
    key_state(Profile, ProfileKey, present(unsure)),
    duty_standing(Profile, Applicability, Standing),
    open_standing(Standing, _).

unsure_open_keys(Profile, Unsure) :-
    findall(ProfileKey - Referral, unsure_open_key(Profile, ProfileKey, Referral), Unsure).

relied_pair(Profile, ProfileKey, Value) :-
    root_key(ProfileKey),
    key_state(Profile, ProfileKey, present(Value)).

relied_pairs(Profile, Pairs) :-
    findall(ProfileKey - Value, relied_pair(Profile, ProfileKey, Value), Pairs).

duty_citation(DutyAtom, Citation) :-
    duty(DutyAtom, _, _, DutyCitations, _),
    member(Citation, DutyCitations).

listed_duty_citation(Duties, Citation) :-
    member(DutyAtom, Duties),
    duty_citation(DutyAtom, Citation).

all_duty_citations(Citations) :-
    findall(Citation, duty_citation(_, Citation), AllCitations),
    sort(AllCitations, Citations).

citations_of_duties(Duties, Citations) :-
    findall(Citation, listed_duty_citation(Duties, Citation), AllCitations),
    sort(AllCitations, Citations).

rts_logging_and_network_security_duties_required(Profile, Result, Citations) :-
    dora_rts_logging_and_network_security_input_problems(Profile, Problems),
    query_after_check(required, Problems, Profile, Result, Citations).

rts_logging_and_network_security_duties_complete(Profile, Result, Citations) :-
    dora_rts_logging_and_network_security_input_problems(Profile, Problems),
    query_after_check(complete, Problems, Profile, Result, Citations).

rts_logging_and_network_security_duties_outstanding(Profile, Result, Citations) :-
    dora_rts_logging_and_network_security_input_problems(Profile, Problems),
    query_after_check(outstanding, Problems, Profile, Result, Citations).

query_after_check(_, [Problem|Problems], _, input_problems([Problem|Problems]), []).
query_after_check(Query, [], Profile, Result, Citations) :-
    key_state(Profile, financial_entity_is_article_16_1_entity, GateState),
    query_after_gate(Query, GateState, Profile, Result, Citations).

query_after_gate(_, present(true), _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
query_after_gate(_, absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []).
query_after_gate(Query, present(false), Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    query_body(Query, Profile, Result, Citations).

query_body(required, Profile, Result, Citations) :-
    key_state(Profile, financial_entity_is_microenterprise, MicroenterpriseState),
    key_state(Profile, financial_entity_has_ict_systems_supporting_critical_or_important_functions, CriticalFunctionState),
    required_after_triggers(MicroenterpriseState, CriticalFunctionState, Profile, Result, Citations).
query_body(complete, Profile, Result, Citations) :-
    failing_duties(Profile, Failing),
    list_non_empty_t(Failing, SomeDutyFails),
    both_reviews_false_t(Profile, BothReviewsFalse),
    truth_or(SomeDutyFails, BothReviewsFalse, SettledIncomplete),
    completeness_after_failures(SettledIncomplete, Profile, Result, Citations).
query_body(outstanding, Profile, Result, Citations) :-
    missing_candidates(Profile, Candidates),
    outstanding_missing_key(Candidates, Choice),
    outstanding_after_missing(Choice, Profile, Result, Citations).

required_after_triggers(absent, _, _, indeterminate([financial_entity_is_microenterprise]), []).
required_after_triggers(present(_), absent, _, indeterminate([financial_entity_has_ict_systems_supporting_critical_or_important_functions]), []).
required_after_triggers(present(_), present(_), Profile, required(Duties), Citations) :-
    findall(DutyAtom, duty_applies(Profile, DutyAtom), Duties),
    citations_of_duties(Duties, Citations).

completeness_after_failures(true, _, incomplete, Citations) :-
    all_duty_citations(Citations).
completeness_after_failures(false, Profile, Result, Citations) :-
    missing_candidates(Profile, Candidates),
    completeness_missing_key(Candidates, Choice),
    completeness_after_missing(Choice, Profile, Result, Citations).

completeness_after_missing(missing(ProfileKey), _, indeterminate([ProfileKey]), []).
completeness_after_missing(no_missing_key, Profile, Result, Citations) :-
    unsure_open_keys(Profile, Unsure),
    completeness_after_unsure(Unsure, Profile, Result, Citations).

completeness_after_unsure([ProfileKey - Referral|_], Profile, needs_legal_review(open_textured(ProfileKey, Referral), [inputs_relied_on(Pairs)]), []) :-
    relied_pairs(Profile, Pairs).
completeness_after_unsure([], _, complete, Citations) :-
    all_duty_citations(Citations).

outstanding_after_missing(missing(ProfileKey), _, indeterminate([ProfileKey]), []).
outstanding_after_missing(no_missing_key, Profile, Result, Citations) :-
    unsure_open_keys(Profile, Unsure),
    outstanding_after_unsure(Unsure, Profile, Result, Citations).

outstanding_after_unsure([ProfileKey - Referral|_], Profile, needs_legal_review(open_textured(ProfileKey, Referral), [inputs_relied_on(Pairs)]), []) :-
    relied_pairs(Profile, Pairs).
outstanding_after_unsure([], Profile, Result, Citations) :-
    failing_duties(Profile, Failing),
    outstanding_answer(Failing, Result, Citations).

outstanding_answer([], none_outstanding, Citations) :-
    all_duty_citations(Citations).
outstanding_answer([DutyAtom|Duties], outstanding([DutyAtom|Duties]), Citations) :-
    citations_of_duties([DutyAtom|Duties], Citations).

decide_dora_rts_logging_and_network_security(Profile, dora_rts_logging_and_network_security_verdict(Status, Citations)) :-
    rts_logging_and_network_security_duties_complete(Profile, Status, Citations).

dora_rts_logging_and_network_security_status(Profile, Status) :-
    decide_dora_rts_logging_and_network_security(Profile, dora_rts_logging_and_network_security_verdict(Status, _Citations)).

dora_rts_logging_and_network_security_decision_resolvable(Profile) :-
    decide_dora_rts_logging_and_network_security(Profile, _Verdict).

dora_rts_logging_and_network_security_checklist(Profile, Items) :-
    dora_rts_logging_and_network_security_input_problems(Profile, Problems),
    checklist_after_check(Problems, Profile, Items).

checklist_after_check([Problem|Problems], _, [item(profile_input, unmet(input_problems([Problem|Problems])), [])]).
checklist_after_check([], Profile, Items) :-
    key_state(Profile, financial_entity_is_article_16_1_entity, GateState),
    checklist_after_gate(GateState, Profile, Items).

checklist_after_gate(present(true), _, [item(simplified_framework_entity, inapplicable, [cite(eu_reg_2022_2554_art_16_1)])]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_after_gate(absent, _, [item(simplified_framework_entity, unknown([financial_entity_is_article_16_1_entity]), [cite(eu_reg_2022_2554_art_16_1)])]).
checklist_after_gate(present(false), Profile, Items) :-
    findall(item(DutyAtom, Status, Citations), duty_item(Profile, DutyAtom, Status, Citations), Items).

duty_item(Profile, DutyAtom, Status, Citations) :-
    duty(DutyAtom, ProfileKey, Applicability, Citations, _),
    duty_standing(Profile, Applicability, Standing),
    key_state(Profile, ProfileKey, KeyState),
    applicability_triggers(Applicability, TriggerKeys),
    duty_item_status(Standing, KeyState, ProfileKey, TriggerKeys, Status).

applicability_triggers(always, []).
applicability_triggers(when(TriggerKey, _), [TriggerKey]).

duty_item_status(inapplicable, _, _, _, inapplicable).
duty_item_status(applies, present(true), _, _, met).
duty_item_status(applies, present(false), _, _, unmet(not_performed)).
duty_item_status(applies, present(unsure), ProfileKey, _, unknown([ProfileKey])).
duty_item_status(applies, absent, ProfileKey, _, unknown([ProfileKey])).
duty_item_status(possible, present(true), _, _, met).
duty_item_status(possible, present(false), _, TriggerKeys, unknown(TriggerKeys)).
duty_item_status(possible, present(unsure), ProfileKey, _, unknown([ProfileKey])).
duty_item_status(possible, absent, ProfileKey, _, unknown([ProfileKey])).

performed_profile(MicroenterpriseValue, CriticalFunctionValue, [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, MicroenterpriseValue), attribute(financial_entity_has_ict_systems_supporting_critical_or_important_functions, CriticalFunctionValue)|DutyAttributes]) :-
    findall(attribute(ProfileKey, true), duty(_, ProfileKey, _, _, _), DutyAttributes).

with_value([], _, _, []).
with_value([attribute(ProfileKey, _)|Remaining], Target, Value, [attribute(ProfileKey, Value)|NewRemaining]) :-
    ProfileKey == Target,
    with_value(Remaining, Target, Value, NewRemaining).
with_value([attribute(ProfileKey, OldValue)|Remaining], Target, Value, [attribute(ProfileKey, OldValue)|NewRemaining]) :-
    ProfileKey \== Target,
    with_value(Remaining, Target, Value, NewRemaining).

without_key([], _, []).
without_key([attribute(ProfileKey, _)|Remaining], Target, NewRemaining) :-
    ProfileKey == Target,
    without_key(Remaining, Target, NewRemaining).
without_key([attribute(ProfileKey, OldValue)|Remaining], Target, [attribute(ProfileKey, OldValue)|NewRemaining]) :-
    ProfileKey \== Target,
    without_key(Remaining, Target, NewRemaining).

test(a_simplified_framework_entity_is_answered_by_every_query) :-
    Profile = [attribute(financial_entity_is_article_16_1_entity, true)],
    rts_logging_and_network_security_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    rts_logging_and_network_security_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    rts_logging_and_network_security_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(an_empty_profile_asks_the_gate_first) :-
    rts_logging_and_network_security_duties_required([], indeterminate([financial_entity_is_article_16_1_entity]), []),
    rts_logging_and_network_security_duties_complete([], indeterminate([financial_entity_is_article_16_1_entity]), []),
    rts_logging_and_network_security_duties_outstanding([], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(every_duty_performed_is_complete) :-
    performed_profile(false, true, Profile),
    rts_logging_and_network_security_duties_complete(Profile, complete, Citations),
    length(Citations, 35).
test(every_duty_performed_is_none_outstanding) :-
    performed_profile(false, true, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, none_outstanding, Citations),
    length(Citations, 35).
test(the_completeness_query_answers_once) :-
    performed_profile(false, true, Profile),
    findall(Result - Citations, rts_logging_and_network_security_duties_complete(Profile, Result, Citations), Answers),
    length(Answers, 1).
test(an_entity_without_critical_systems_has_thirty_three_duties) :-
    performed_profile(false, false, Profile),
    rts_logging_and_network_security_duties_required(Profile, required(Duties), Citations),
    length(Duties, 33),
    member(yearly_network_architecture_review, Duties),
    length(Citations, 35).
test(a_microenterprise_has_the_periodic_review) :-
    performed_profile(true, true, Profile),
    rts_logging_and_network_security_duties_required(Profile, required(Duties), _),
    length(Duties, 34),
    member(periodic_network_architecture_review, Duties),
    member(six_monthly_firewall_rule_verification, Duties).
test(the_required_query_asks_the_size_class) :-
    rts_logging_and_network_security_duties_required([attribute(financial_entity_is_article_16_1_entity, false)], indeterminate([financial_entity_is_microenterprise]), []).
test(a_failed_duty_is_incomplete_and_outstanding) :-
    performed_profile(false, true, StartProfile),
    with_value(StartProfile, network_connections_encrypted, false, Profile),
    rts_logging_and_network_security_duties_complete(Profile, incomplete, Citations),
    length(Citations, 35),
    rts_logging_and_network_security_duties_outstanding(Profile, outstanding([encryption_of_network_connections]), [cite(eu_reg_2024_1774_art_13_e)]).
test(the_segmentation_duty_cites_its_four_keys) :-
    performed_profile(false, true, StartProfile),
    with_value(StartProfile, network_segregation_and_segmentation_considering_criticality_classification_and_risk_profile, false, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, outstanding([network_segregation_and_segmentation]), Citations),
    length(Citations, 4).
test(both_reviews_false_is_incomplete_whatever_the_size_class) :-
    performed_profile(false, true, StartProfile),
    without_key(StartProfile, financial_entity_is_microenterprise, NoSizeProfile),
    with_value(NoSizeProfile, network_architecture_and_security_design_reviewed_once_a_year, false, YearlyProfile),
    with_value(YearlyProfile, network_architecture_and_security_design_reviewed_periodically, false, Profile),
    rts_logging_and_network_security_duties_complete(Profile, incomplete, _),
    rts_logging_and_network_security_duties_outstanding(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(the_size_class_is_asked_when_it_alone_decides) :-
    Profile = [attribute(financial_entity_is_article_16_1_entity, false), attribute(network_architecture_and_security_design_reviewed_once_a_year, false)],
    rts_logging_and_network_security_duties_complete(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(an_always_duty_is_asked_before_the_triggers) :-
    Profile = [attribute(financial_entity_is_article_16_1_entity, false)],
    rts_logging_and_network_security_duties_complete(Profile, indeterminate([logging_procedures_protocols_and_tools_developed_documented_and_implemented]), []),
    rts_logging_and_network_security_duties_outstanding(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(the_critical_question_is_skipped_when_the_verification_is_performed) :-
    performed_profile(false, true, StartProfile),
    without_key(StartProfile, financial_entity_has_ict_systems_supporting_critical_or_important_functions, Profile),
    rts_logging_and_network_security_duties_complete(Profile, complete, _).
test(an_unsure_duty_goes_to_a_lawyer) :-
    performed_profile(false, true, StartProfile),
    with_value(StartProfile, network_connections_encrypted, unsure, Profile),
    rts_logging_and_network_security_duties_complete(Profile, needs_legal_review(open_textured(network_connections_encrypted, cite(eu_reg_2024_1774_art_13_e)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 38),
    member(network_connections_encrypted - unsure, Pairs).
test(a_false_duty_settles_completeness_before_an_unsure_one) :-
    performed_profile(false, true, StartProfile),
    with_value(StartProfile, network_connections_encrypted, unsure, UnsureProfile),
    with_value(UnsureProfile, networks_designed_in_line_with_ict_security_requirements, false, Profile),
    rts_logging_and_network_security_duties_complete(Profile, incomplete, _),
    rts_logging_and_network_security_duties_outstanding(Profile, needs_legal_review(open_textured(network_connections_encrypted, cite(eu_reg_2024_1774_art_13_e)), [inputs_relied_on(_)]), []).
test(an_inapplicable_verification_is_not_outstanding) :-
    performed_profile(false, false, StartProfile),
    with_value(StartProfile, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, false, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, none_outstanding, _).
test(an_unknown_key_is_an_input_problem) :-
    rts_logging_and_network_security_duties_complete([attribute(colour, blue)], input_problems([unknown_key(colour)]), []).
test(the_facade_verdict_follows_the_completeness_query) :-
    performed_profile(false, true, Profile),
    decide_dora_rts_logging_and_network_security(Profile, dora_rts_logging_and_network_security_verdict(complete, _)),
    dora_rts_logging_and_network_security_status(Profile, complete).
test(the_checklist_has_a_row_per_duty) :-
    performed_profile(false, true, Profile),
    dora_rts_logging_and_network_security_checklist(Profile, Items),
    length(Items, 35),
    member(item(periodic_network_architecture_review, inapplicable, [cite(eu_reg_2024_1774_art_13_i)]), Items),
    member(item(encryption_of_network_connections, met, [cite(eu_reg_2024_1774_art_13_e)]), Items).

test(a_larger_entity_has_no_periodic_review, fail) :-
    performed_profile(false, false, Profile),
    rts_logging_and_network_security_duties_required(Profile, required(Duties), _),
    member(periodic_network_architecture_review, Duties).
test(an_inapplicable_verification_gives_no_outstanding_list, fail) :-
    performed_profile(false, false, StartProfile),
    with_value(StartProfile, firewall_rules_and_connection_filters_for_critical_or_important_systems_verified_at_least_every_6_months, false, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, outstanding(_), _).
