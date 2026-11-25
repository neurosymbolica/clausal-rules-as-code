% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_asset_management_and_cryptography_dora_rts_asset_management_and_cryptography, [rts_asset_management_and_cryptography_duties_required/3, rts_asset_management_and_cryptography_duties_complete/3, rts_asset_management_and_cryptography_duties_outstanding/3, decide_dora_rts_asset_management_and_cryptography/2, dora_rts_asset_management_and_cryptography_status/2, dora_rts_asset_management_and_cryptography_checklist/2, dora_rts_asset_management_and_cryptography_decision_resolvable/1, dora_rts_asset_management_and_cryptography_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2, pairs_values/2]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_kernel, [dora_rts_asset_management_and_cryptography_input_problems/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_citations, [implements/1]).

dora_rts_asset_management_and_cryptography_status_values([complete, incomplete, simplified_framework_entity, indeterminate, needs_legal_review, input_problems]).

fixed_citations([cite(eu_reg_2024_1774_art_4_1), cite(eu_reg_2024_1774_art_4_2), cite(eu_reg_2024_1774_art_5_1), cite(eu_reg_2024_1774_art_5_2), cite(eu_reg_2024_1774_art_6_1), cite(eu_reg_2024_1774_art_6_2), cite(eu_reg_2024_1774_art_6_3), cite(eu_reg_2024_1774_art_6_4), cite(eu_reg_2024_1774_art_6_5), cite(eu_reg_2024_1774_art_7_1), cite(eu_reg_2024_1774_art_7_2), cite(eu_reg_2024_1774_art_7_3), cite(eu_reg_2024_1774_art_7_4), cite(eu_reg_2024_1774_art_7_5)]).

duty_row(ict_asset_management_policy, ict_asset_management_policy_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_4_1), always).
duty_row(ict_asset_lifecycle_monitoring_and_management, asset_policy_prescribes_monitoring_and_management_of_asset_lifecycle, cite(eu_reg_2024_1774_art_4_2_a), always).
duty_row(ict_asset_records, asset_policy_prescribes_records_of_ict_assets, cite(eu_reg_2024_1774_art_4_2_b), always).
duty_row(legacy_ict_system_risk_assessment_records, asset_policy_prescribes_records_for_legacy_system_risk_assessment, cite(eu_reg_2024_1774_art_4_2_c), non_microenterprise).
duty_row(ict_asset_management_procedure, ict_asset_management_procedure_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_5_1), always).
duty_row(criticality_assessment_criteria, asset_procedure_specifies_criticality_assessment_criteria, cite(eu_reg_2024_1774_art_5_2), always).
duty_row(encryption_and_cryptographic_controls_policy, encryption_policy_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_6_1), always).
duty_row(encryption_policy_design_basis, encryption_policy_designed_on_data_classification_and_ict_risk_assessment, cite(eu_reg_2024_1774_art_6_2), always).
duty_row(rules_for_encryption_of_data_at_rest_and_in_transit, encryption_policy_has_rules_for_data_at_rest_and_in_transit, cite(eu_reg_2024_1774_art_6_2_a), always).
duty_row(rules_for_encryption_of_data_in_use, encryption_policy_has_rules_for_data_in_use_where_necessary, cite(eu_reg_2024_1774_art_6_2_b), always).
duty_row(rules_for_encryption_of_network_connections_and_external_traffic, encryption_policy_has_rules_for_network_connections_and_external_traffic, cite(eu_reg_2024_1774_art_6_2_c), always).
duty_row(rules_for_cryptographic_key_management, encryption_policy_has_rules_for_cryptographic_key_management, cite(eu_reg_2024_1774_art_6_2_d), always).
duty_row(protection_of_data_in_use_where_encryption_not_possible, data_in_use_protected_where_its_encryption_is_not_possible, cite(eu_reg_2024_1774_art_6_2), always).
duty_row(cryptographic_technique_selection_criteria, encryption_policy_has_criteria_for_selecting_cryptographic_techniques, cite(eu_reg_2024_1774_art_6_3), always).
duty_row(mitigation_where_leading_practices_not_followed, mitigation_and_monitoring_where_leading_practices_or_standards_not_followed, cite(eu_reg_2024_1774_art_6_3), always).
duty_row(cryptographic_technology_update_provisions, encryption_policy_has_provisions_for_updating_cryptographic_technology, cite(eu_reg_2024_1774_art_6_4), always).
duty_row(mitigation_where_cryptographic_technology_not_updated, mitigation_and_monitoring_where_cryptographic_technology_not_updated, cite(eu_reg_2024_1774_art_6_4), always).
duty_row(recording_of_mitigation_and_monitoring_measures, encryption_policy_requires_recording_of_mitigation_measures_with_reasons, cite(eu_reg_2024_1774_art_6_5), always).
duty_row(cryptographic_key_lifecycle_requirements, key_management_policy_has_requirements_for_whole_key_lifecycle, cite(eu_reg_2024_1774_art_7_1), always).
duty_row(cryptographic_key_protection_controls, key_protection_controls_identified_and_implemented, cite(eu_reg_2024_1774_art_7_2), always).
duty_row(key_protection_controls_design_basis, key_protection_controls_designed_on_data_classification_and_ict_risk_assessment, cite(eu_reg_2024_1774_art_7_2), always).
duty_row(cryptographic_key_replacement_methods, key_replacement_methods_developed_and_implemented, cite(eu_reg_2024_1774_art_7_3), always).
duty_row(certificate_register, certificate_register_created_maintained_and_kept_up_to_date, cite(eu_reg_2024_1774_art_7_4), always).
duty_row(prompt_certificate_renewal, certificates_renewed_promptly_before_expiration, cite(eu_reg_2024_1774_art_7_5), always).

profile_value(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
profile_value(Profile, ProfileKey, KeyValue) :-
    profile_get(Profile, ProfileKey, KeyValue).

contract_keys([financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise|DutyKeys]) :-
    findall(DutyKey, duty_row(_, DutyKey, _, _), DutyKeys).

relied_on_pairs(Profile, Pairs) :-
    contract_keys(ContractKeys),
    present_pairs(ContractKeys, Profile, Pairs).

present_pairs([], _, []).
present_pairs([ProfileKey|RemainingKeys], Profile, Pairs) :-
    profile_value(Profile, ProfileKey, KeyValue),
    present_pair_step(KeyValue, ProfileKey, RemainingKeys, Profile, Pairs).

present_pair_step(absent, _, RemainingKeys, Profile, Pairs) :-
    present_pairs(RemainingKeys, Profile, Pairs).
present_pair_step(KeyValue, ProfileKey, RemainingKeys, Profile, [ProfileKey - KeyValue|Pairs]) :-
    dif(KeyValue, absent),
    present_pairs(RemainingKeys, Profile, Pairs).

condition_status(always, _, holds).
condition_status(non_microenterprise, false, holds) :-
    implements(eu_reg_2024_1774_art_4_2_c).
condition_status(non_microenterprise, true, fails) :-
    implements(eu_reg_2024_1774_art_4_2_c).
condition_status(non_microenterprise, absent, open) :-
    implements(eu_reg_2024_1774_art_4_2_c).

duty_entries(Profile, TriggerValue, Entries) :-
    findall(duty(DutyName, DutyKey, Citation, Condition), duty_row(DutyName, DutyKey, Citation, Condition), Rows),
    maplist(duty_entry(Profile, TriggerValue), Rows, Entries).

duty_entry(Profile, TriggerValue, duty(DutyName, DutyKey, Citation, Condition), entry(DutyName, DutyKey, Citation, ConditionStatus, KeyValue)) :-
    condition_status(Condition, TriggerValue, ConditionStatus),
    profile_value(Profile, DutyKey, KeyValue).

applying_duties([], []).
applying_duties([entry(DutyName, _, _, holds, _)|RemainingEntries], [DutyName|Duties]) :-
    applying_duties(RemainingEntries, Duties).
applying_duties([entry(_, _, _, fails, _)|RemainingEntries], Duties) :-
    applying_duties(RemainingEntries, Duties).
applying_duties([entry(_, _, _, open, _)|RemainingEntries], Duties) :-
    applying_duties(RemainingEntries, Duties).

duty_fails_t(holds, false, true).
duty_fails_t(holds, true, false).
duty_fails_t(holds, unsure, false).
duty_fails_t(holds, absent, false).
duty_fails_t(fails, _, false).
duty_fails_t(open, _, false).

failing_duties([], []).
failing_duties([entry(DutyName, _, Citation, ConditionStatus, KeyValue)|RemainingEntries], Failing) :-
    duty_fails_t(ConditionStatus, KeyValue, Fails),
    failing_step(Fails, DutyName, Citation, RemainingEntries, Failing).

failing_step(true, DutyName, Citation, RemainingEntries, [DutyName - Citation|Failing]) :-
    failing_duties(RemainingEntries, Failing).
failing_step(false, _, _, RemainingEntries, Failing) :-
    failing_duties(RemainingEntries, Failing).

first_entry([], _, none).
first_entry([entry(_, DutyKey, Citation, ConditionStatus, KeyValue)|RemainingEntries], Wanted, Found) :-
    entry_matches_t(ConditionStatus, KeyValue, Wanted, Matches),
    first_entry_step(Matches, DutyKey, Citation, RemainingEntries, Wanted, Found).

first_entry_step(true, DutyKey, Citation, _, _, found(DutyKey, Citation)).
first_entry_step(false, _, _, RemainingEntries, Wanted, Found) :-
    first_entry(RemainingEntries, Wanted, Found).

entry_matches_t(holds, Wanted, Wanted, true).
entry_matches_t(holds, KeyValue, Wanted, false) :-
    dif(KeyValue, Wanted).
entry_matches_t(fails, _, _, false).
entry_matches_t(open, _, _, false).

trigger_decides_alone(absent, false, yes) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_decides_alone(absent, true, no) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_decides_alone(absent, unsure, no) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_decides_alone(absent, absent, no) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_decides_alone(true, _, no) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_decides_alone(false, _, no) :-
    implements(eu_reg_2024_1774_art_4_2_c).

trigger_pending(absent, false, yes) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_pending(absent, unsure, yes) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_pending(absent, absent, yes) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_pending(absent, true, no) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_pending(true, _, no) :-
    implements(eu_reg_2024_1774_art_4_2_c).
trigger_pending(false, _, no) :-
    implements(eu_reg_2024_1774_art_4_2_c).

rts_asset_management_and_cryptography_duties_required(Profile, Result, Citations) :-
    dora_rts_asset_management_and_cryptography_input_problems(Profile, Problems),
    query_after_check(Problems, required_duties, Profile, Result, Citations).

rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations) :-
    dora_rts_asset_management_and_cryptography_input_problems(Profile, Problems),
    query_after_check(Problems, completeness, Profile, Result, Citations).

rts_asset_management_and_cryptography_duties_outstanding(Profile, Result, Citations) :-
    dora_rts_asset_management_and_cryptography_input_problems(Profile, Problems),
    query_after_check(Problems, outstanding_duties, Profile, Result, Citations).

query_after_check([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
query_after_check([], Query, Profile, Result, Citations) :-
    profile_value(Profile, financial_entity_is_article_16_1_entity, GateValue),
    query_gate(GateValue, Query, Profile, Result, Citations).

query_gate(true, _, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
query_gate(absent, _, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
query_gate(false, Query, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    profile_value(Profile, financial_entity_is_microenterprise, TriggerValue),
    duty_entries(Profile, TriggerValue, Entries),
    query_body(Query, Profile, TriggerValue, Entries, Result, Citations).

query_body(required_duties, _, TriggerValue, Entries, Result, Citations) :-
    required_answer(TriggerValue, Entries, Result, Citations).
query_body(completeness, Profile, TriggerValue, Entries, Result, Citations) :-
    failing_duties(Entries, Failing),
    profile_value(Profile, asset_policy_prescribes_records_for_legacy_system_risk_assessment, LegacyValue),
    complete_answer(Failing, Profile, TriggerValue, LegacyValue, Entries, Result, Citations).
query_body(outstanding_duties, Profile, TriggerValue, Entries, Result, Citations) :-
    profile_value(Profile, asset_policy_prescribes_records_for_legacy_system_risk_assessment, LegacyValue),
    trigger_pending(TriggerValue, LegacyValue, Pending),
    outstanding_pending(Pending, Profile, Entries, Result, Citations).

required_answer(absent, _, indeterminate([financial_entity_is_microenterprise]), []) :-
    implements(eu_reg_2024_1774_art_4_2_c).
required_answer(true, Entries, required(Duties), Citations) :-
    implements(eu_reg_2024_1774_art_4_1),
    applying_duties(Entries, Duties),
    fixed_citations(Citations).
required_answer(false, Entries, required(Duties), Citations) :-
    implements(eu_reg_2024_1774_art_4_1),
    applying_duties(Entries, Duties),
    fixed_citations(Citations).

complete_answer([_|_], _, _, _, _, incomplete, Citations) :-
    implements(eu_reg_2024_1774_art_4_1),
    fixed_citations(Citations).
complete_answer([], Profile, TriggerValue, LegacyValue, Entries, Result, Citations) :-
    trigger_decides_alone(TriggerValue, LegacyValue, Alone),
    complete_alone(Alone, Profile, TriggerValue, LegacyValue, Entries, Result, Citations).

complete_alone(yes, _, _, _, _, indeterminate([financial_entity_is_microenterprise]), []).
complete_alone(no, Profile, TriggerValue, LegacyValue, Entries, Result, Citations) :-
    first_entry(Entries, absent, Found),
    complete_missing(Found, Profile, TriggerValue, LegacyValue, Entries, Result, Citations).

complete_missing(found(MissingKey, _), _, _, _, _, indeterminate([MissingKey]), []).
complete_missing(none, Profile, TriggerValue, LegacyValue, Entries, Result, Citations) :-
    trigger_pending(TriggerValue, LegacyValue, Pending),
    complete_pending(Pending, Profile, Entries, Result, Citations).

complete_pending(yes, _, _, indeterminate([financial_entity_is_microenterprise]), []).
complete_pending(no, Profile, Entries, Result, Citations) :-
    first_entry(Entries, unsure, Found),
    complete_review(Found, Profile, Result, Citations).

complete_review(found(UnsureKey, Citation), Profile, needs_legal_review(open_textured(UnsureKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    relied_on_pairs(Profile, Pairs).
complete_review(none, _, complete, Citations) :-
    implements(eu_reg_2024_1774_art_4_1),
    fixed_citations(Citations).

outstanding_pending(yes, _, _, indeterminate([financial_entity_is_microenterprise]), []).
outstanding_pending(no, Profile, Entries, Result, Citations) :-
    first_entry(Entries, absent, Found),
    outstanding_missing(Found, Profile, Entries, Result, Citations).

outstanding_missing(found(MissingKey, _), _, _, indeterminate([MissingKey]), []).
outstanding_missing(none, Profile, Entries, Result, Citations) :-
    first_entry(Entries, unsure, Found),
    outstanding_review(Found, Profile, Entries, Result, Citations).

outstanding_review(found(UnsureKey, Citation), Profile, _, needs_legal_review(open_textured(UnsureKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    relied_on_pairs(Profile, Pairs).
outstanding_review(none, _, Entries, Result, Citations) :-
    failing_duties(Entries, Failing),
    outstanding_final(Failing, Result, Citations).

outstanding_final([], none_outstanding, Citations) :-
    implements(eu_reg_2024_1774_art_4_1),
    fixed_citations(Citations).
outstanding_final([FirstFailing|LaterFailing], outstanding(Duties), Citations) :-
    implements(eu_reg_2024_1774_art_4_1),
    pairs_keys([FirstFailing|LaterFailing], Duties),
    pairs_values([FirstFailing|LaterFailing], FailingCitations),
    sort(FailingCitations, Citations).

decide_dora_rts_asset_management_and_cryptography(Profile, dora_rts_asset_management_and_cryptography_verdict(Status, Citations)) :-
    rts_asset_management_and_cryptography_duties_complete(Profile, Status, Citations).

dora_rts_asset_management_and_cryptography_status(Profile, Status) :-
    decide_dora_rts_asset_management_and_cryptography(Profile, dora_rts_asset_management_and_cryptography_verdict(Status, _Citations)).

dora_rts_asset_management_and_cryptography_checklist(Profile, Items) :-
    dora_rts_asset_management_and_cryptography_input_problems(Profile, Problems),
    checklist_after_check(Problems, Profile, Items).

checklist_after_check([_|_], _, []).
checklist_after_check([], Profile, Items) :-
    profile_value(Profile, financial_entity_is_article_16_1_entity, GateValue),
    checklist_gate(GateValue, Profile, Items).

checklist_gate(true, _, [item(simplified_framework_entity, inapplicable, cite(eu_reg_2022_2554_art_16_1))]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_gate(absent, _, [item(simplified_framework_entity, unknown([financial_entity_is_article_16_1_entity]), cite(eu_reg_2022_2554_art_16_1))]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_gate(false, Profile, Items) :-
    implements(eu_reg_2022_2554_art_16_1),
    profile_value(Profile, financial_entity_is_microenterprise, TriggerValue),
    duty_entries(Profile, TriggerValue, Entries),
    maplist(entry_item, Entries, Items).

entry_item(entry(DutyName, DutyKey, Citation, ConditionStatus, KeyValue), item(DutyName, ItemStatus, Citation)) :-
    item_status(ConditionStatus, KeyValue, DutyKey, ItemStatus).

item_status(holds, true, _, met).
item_status(holds, false, _, unmet(not_performed)).
item_status(holds, unsure, DutyKey, unknown([DutyKey])).
item_status(holds, absent, DutyKey, unknown([DutyKey])).
item_status(fails, _, _, inapplicable).
item_status(open, _, _, unknown([financial_entity_is_microenterprise])).

dora_rts_asset_management_and_cryptography_decision_resolvable(Profile) :-
    decide_dora_rts_asset_management_and_cryptography(Profile, _Verdict).

fixture_profile(TriggerValue, Overrides, Profile) :-
    findall(DutyKey, duty_row(_, DutyKey, _, _), DutyKeys),
    fixture_attributes(DutyKeys, Overrides, DutyAttributes),
    fixture_trigger(TriggerValue, TriggerAttributes),
    append(TriggerAttributes, DutyAttributes, LaterAttributes),
    Profile = [attribute(financial_entity_is_article_16_1_entity, false)|LaterAttributes].

fixture_trigger(absent, []).
fixture_trigger(true, [attribute(financial_entity_is_microenterprise, true)]).
fixture_trigger(false, [attribute(financial_entity_is_microenterprise, false)]).

fixture_attributes([], _, []).
fixture_attributes([DutyKey|RemainingKeys], Overrides, Attributes) :-
    override_value(Overrides, DutyKey, KeyValue),
    fixture_attribute_step(KeyValue, DutyKey, RemainingKeys, Overrides, Attributes).

fixture_attribute_step(absent, _, RemainingKeys, Overrides, Attributes) :-
    fixture_attributes(RemainingKeys, Overrides, Attributes).
fixture_attribute_step(KeyValue, DutyKey, RemainingKeys, Overrides, [attribute(DutyKey, KeyValue)|Attributes]) :-
    dif(KeyValue, absent),
    fixture_attributes(RemainingKeys, Overrides, Attributes).

override_value([], _, true).
override_value([DutyKey - KeyValue|_], DutyKey, KeyValue).
override_value([OtherKey - _|LaterOverrides], DutyKey, KeyValue) :-
    dif(OtherKey, DutyKey),
    override_value(LaterOverrides, DutyKey, KeyValue).

test(gate_true_gives_simplified_framework_entity) :-
    rts_asset_management_and_cryptography_duties_required([attribute(financial_entity_is_article_16_1_entity, true)], simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(empty_profile_asks_the_gate) :-
    rts_asset_management_and_cryptography_duties_complete([], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(required_asks_the_trigger) :-
    rts_asset_management_and_cryptography_duties_required([attribute(financial_entity_is_article_16_1_entity, false)], indeterminate([financial_entity_is_microenterprise]), []).
test(microenterprise_has_twenty_three_duties) :-
    fixture_profile(true, [], Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, required(Duties), Citations),
    length(Duties, 23),
    length(Citations, 14).
test(non_microenterprise_has_twenty_four_duties) :-
    fixture_profile(false, [], Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, required(Duties), _),
    length(Duties, 24),
    nth1(4, Duties, legacy_ict_system_risk_assessment_records).
test(all_performed_is_complete) :-
    fixture_profile(false, [], Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, complete, Citations),
    length(Citations, 14).
test(one_false_duty_is_incomplete) :-
    fixture_profile(false, [certificates_renewed_promptly_before_expiration - false], Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, incomplete, _).
test(a_false_duty_decides_before_an_absent_key) :-
    fixture_profile(false, [ict_asset_management_policy_developed_documented_and_implemented - absent, certificates_renewed_promptly_before_expiration - false], Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, incomplete, _).
test(legacy_records_outstanding_for_non_microenterprise) :-
    fixture_profile(false, [asset_policy_prescribes_records_for_legacy_system_risk_assessment - false], Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, outstanding([legacy_ict_system_risk_assessment_records]), [cite(eu_reg_2024_1774_art_4_2_c)]).
test(microenterprise_is_excused_legacy_records) :-
    fixture_profile(true, [asset_policy_prescribes_records_for_legacy_system_risk_assessment - false], Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, complete, _).
test(absent_trigger_decides_alone_when_legacy_false) :-
    fixture_profile(absent, [asset_policy_prescribes_records_for_legacy_system_risk_assessment - false], Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(absent_always_key_before_trigger_in_complete) :-
    fixture_profile(absent, [asset_policy_prescribes_records_for_legacy_system_risk_assessment - unsure, certificates_renewed_promptly_before_expiration - absent], Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, indeterminate([certificates_renewed_promptly_before_expiration]), []).
test(trigger_first_in_outstanding) :-
    fixture_profile(absent, [asset_policy_prescribes_records_for_legacy_system_risk_assessment - unsure, certificates_renewed_promptly_before_expiration - absent], Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(a_false_duty_does_not_end_outstanding) :-
    fixture_profile(false, [ict_asset_management_policy_developed_documented_and_implemented - false, certificates_renewed_promptly_before_expiration - absent], Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, indeterminate([certificates_renewed_promptly_before_expiration]), []).
test(unsure_judgement_is_referred) :-
    fixture_profile(false, [encryption_policy_has_rules_for_data_in_use_where_necessary - unsure], Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, needs_legal_review(open_textured(encryption_policy_has_rules_for_data_in_use_where_necessary, cite(eu_reg_2024_1774_art_6_2_b)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 26).
test(unknown_key_is_an_input_problem) :-
    rts_asset_management_and_cryptography_duties_complete([attribute(foreign_key_atom, true)], input_problems([unknown_key(foreign_key_atom)]), []).
test(each_query_yields_one_solution) :-
    fixture_profile(false, [asset_policy_prescribes_records_of_ict_assets - false, certificate_register_created_maintained_and_kept_up_to_date - false], Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([ict_asset_records, certificate_register]) - [cite(eu_reg_2024_1774_art_4_2_b), cite(eu_reg_2024_1774_art_7_4)]].
test(checklist_has_one_item_per_duty) :-
    fixture_profile(true, [], Profile),
    dora_rts_asset_management_and_cryptography_checklist(Profile, Items),
    length(Items, 24),
    member(item(legacy_ict_system_risk_assessment_records, inapplicable, cite(eu_reg_2024_1774_art_4_2_c)), Items).

test(microenterprise_has_no_legacy_records_duty, fail) :-
    fixture_profile(true, [], Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, required(Duties), _),
    member(legacy_ict_system_risk_assessment_records, Duties).
test(all_performed_is_not_incomplete, fail) :-
    fixture_profile(false, [], Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, incomplete, _).
