% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_asset_management_and_cryptography_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_dora_rts_asset_management_and_cryptography, [decide_dora_rts_asset_management_and_cryptography/2, dora_rts_asset_management_and_cryptography_status/2, dora_rts_asset_management_and_cryptography_checklist/2, rts_asset_management_and_cryptography_duties_required/3, rts_asset_management_and_cryptography_duties_complete/3, rts_asset_management_and_cryptography_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_fixtures, [dora_rts_asset_management_and_cryptography_profile_for/2]).

all_duties([ict_asset_management_policy, ict_asset_lifecycle_monitoring_and_management, ict_asset_records, legacy_ict_system_risk_assessment_records, ict_asset_management_procedure, criticality_assessment_criteria, encryption_and_cryptographic_controls_policy, encryption_policy_design_basis, rules_for_encryption_of_data_at_rest_and_in_transit, rules_for_encryption_of_data_in_use, rules_for_encryption_of_network_connections_and_external_traffic, rules_for_cryptographic_key_management, protection_of_data_in_use_where_encryption_not_possible, cryptographic_technique_selection_criteria, mitigation_where_leading_practices_not_followed, cryptographic_technology_update_provisions, mitigation_where_cryptographic_technology_not_updated, recording_of_mitigation_and_monitoring_measures, cryptographic_key_lifecycle_requirements, cryptographic_key_protection_controls, key_protection_controls_design_basis, cryptographic_key_replacement_methods, certificate_register, prompt_certificate_renewal]).

fixed_citation_list([cite(eu_reg_2024_1774_art_4_1), cite(eu_reg_2024_1774_art_4_2), cite(eu_reg_2024_1774_art_5_1), cite(eu_reg_2024_1774_art_5_2), cite(eu_reg_2024_1774_art_6_1), cite(eu_reg_2024_1774_art_6_2), cite(eu_reg_2024_1774_art_6_3), cite(eu_reg_2024_1774_art_6_4), cite(eu_reg_2024_1774_art_6_5), cite(eu_reg_2024_1774_art_7_1), cite(eu_reg_2024_1774_art_7_2), cite(eu_reg_2024_1774_art_7_3), cite(eu_reg_2024_1774_art_7_4), cite(eu_reg_2024_1774_art_7_5)]).

same_citation_set(Citations, Expected) :-
    clausal_msort(Citations, SortedCitations),
    clausal_msort(Expected, SortedExpected),
    SortedCitations == SortedExpected.

with_value([], _, _, []).
with_value([attribute(ProfileKey, _)|RemainingElements], ProfileKey, NewValue, [attribute(ProfileKey, NewValue)|NewElements]) :-
    with_value(RemainingElements, ProfileKey, NewValue, NewElements).
with_value([attribute(OtherKey, OldValue)|RemainingElements], ProfileKey, NewValue, [attribute(OtherKey, OldValue)|NewElements]) :-
    dif(OtherKey, ProfileKey),
    with_value(RemainingElements, ProfileKey, NewValue, NewElements).

test(required_reads_out_every_duty_for_a_non_microenterprise) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_required(Profile, Result, Citations), [required(Duties) - Citations]),
    all_duties(Expected),
    Duties == Expected,
    fixed_citation_list(FixedCitations),
    same_citation_set(Citations, FixedCitations).
test(required_reads_out_twenty_three_duties_for_a_microenterprise) :-
    dora_rts_asset_management_and_cryptography_profile_for(microenterprise_all_performed, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_required(Profile, Result, Citations), [required(Duties) - Citations]),
    all_duties(AllDuties),
    select(legacy_ict_system_risk_assessment_records, AllDuties, Expected),
    Duties == Expected,
    fixed_citation_list(FixedCitations),
    same_citation_set(Citations, FixedCitations).
test(required_reads_out_the_trigger_when_absent) :-
    dora_rts_asset_management_and_cryptography_profile_for(trigger_absent_legacy_records_performed, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_required(Profile, Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_is_microenterprise]) - []].
test(required_reads_out_the_gate) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_true_entity, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_required(Profile, Result, Citations), Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(complete_reads_out_complete_with_the_fixed_citations) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations), [complete - Citations]),
    fixed_citation_list(FixedCitations),
    same_citation_set(Citations, FixedCitations).
test(complete_reads_out_incomplete_with_the_fixed_citations) :-
    dora_rts_asset_management_and_cryptography_profile_for(false_duty_before_absent_key, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations), [incomplete - Citations]),
    fixed_citation_list(FixedCitations),
    same_citation_set(Citations, FixedCitations).
test(complete_reads_out_the_first_absent_key) :-
    dora_rts_asset_management_and_cryptography_profile_for(absent_key_before_unsure_judgement, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations), Answers),
    Answers == [indeterminate([certificates_renewed_promptly_before_expiration]) - []].
test(complete_reads_out_the_trigger_that_decides_alone) :-
    dora_rts_asset_management_and_cryptography_profile_for(trigger_absent_legacy_records_not_performed, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_is_microenterprise]) - []].
test(complete_reads_out_the_referral_with_every_present_pair) :-
    dora_rts_asset_management_and_cryptography_profile_for(unsure_judgement_referred, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations), [needs_legal_review(Reason, [inputs_relied_on(Pairs)]) - []]),
    Reason == open_textured(encryption_policy_has_rules_for_data_in_use_where_necessary, cite(eu_reg_2024_1774_art_6_2_b)),
    length(Pairs, 26),
    nth1(1, Pairs, financial_entity_is_article_16_1_entity - false),
    nth1(2, Pairs, financial_entity_is_microenterprise - false),
    nth1(12, Pairs, encryption_policy_has_rules_for_data_in_use_where_necessary - unsure).
test(outstanding_reads_out_the_failing_duties_with_their_own_keys) :-
    dora_rts_asset_management_and_cryptography_profile_for(two_duties_not_performed, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_outstanding(Profile, Result, Citations), [outstanding(Duties) - Citations]),
    Duties == [ict_asset_records, certificate_register],
    same_citation_set(Citations, [cite(eu_reg_2024_1774_art_4_2_b), cite(eu_reg_2024_1774_art_7_4)]).
test(outstanding_writes_a_shared_citation_once) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, BaseProfile),
    with_value(BaseProfile, encryption_policy_has_criteria_for_selecting_cryptographic_techniques, false, FirstProfile),
    with_value(FirstProfile, mitigation_and_monitoring_where_leading_practices_or_standards_not_followed, false, SecondProfile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_outstanding(SecondProfile, Result, Citations), Answers),
    Answers == [outstanding([cryptographic_technique_selection_criteria, mitigation_where_leading_practices_not_followed]) - [cite(eu_reg_2024_1774_art_6_3)]].
test(outstanding_reads_out_none_outstanding) :-
    dora_rts_asset_management_and_cryptography_profile_for(microenterprise_legacy_records_not_performed, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_outstanding(Profile, Result, Citations), [none_outstanding - Citations]),
    fixed_citation_list(FixedCitations),
    same_citation_set(Citations, FixedCitations).
test(outstanding_reads_out_the_trigger_first) :-
    dora_rts_asset_management_and_cryptography_profile_for(trigger_absent_legacy_records_not_performed, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_is_microenterprise]) - []].
test(outstanding_reads_out_the_absent_key_despite_a_false_duty) :-
    dora_rts_asset_management_and_cryptography_profile_for(false_duty_before_absent_key, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [indeterminate([ict_asset_management_policy_developed_documented_and_implemented]) - []].
test(the_verdict_carries_a_citation) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    decide_dora_rts_asset_management_and_cryptography(Profile, dora_rts_asset_management_and_cryptography_verdict(complete, [_FirstCitation|_OtherCitations])).
test(the_status_projection_reads_out_one_status) :-
    dora_rts_asset_management_and_cryptography_profile_for(one_duty_not_performed, Profile),
    findall(Status, dora_rts_asset_management_and_cryptography_status(Profile, Status), Statuses),
    Statuses == [incomplete].
test(the_checklist_reads_out_cited_items) :-
    dora_rts_asset_management_and_cryptography_profile_for(one_duty_not_performed, Profile),
    dora_rts_asset_management_and_cryptography_checklist(Profile, Items),
    length(Items, 24),
    member(item(prompt_certificate_renewal, unmet(not_performed), cite(eu_reg_2024_1774_art_7_5)), Items),
    member(item(ict_asset_management_policy, met, cite(eu_reg_2024_1774_art_4_1)), Items).

cp_test_names([required_reads_out_every_duty_for_a_non_microenterprise, required_reads_out_twenty_three_duties_for_a_microenterprise, required_reads_out_the_trigger_when_absent, required_reads_out_the_gate, complete_reads_out_complete_with_the_fixed_citations, complete_reads_out_incomplete_with_the_fixed_citations, complete_reads_out_the_first_absent_key, complete_reads_out_the_trigger_that_decides_alone, complete_reads_out_the_referral_with_every_present_pair, outstanding_reads_out_the_failing_duties_with_their_own_keys, outstanding_writes_a_shared_citation_once, outstanding_reads_out_none_outstanding, outstanding_reads_out_the_trigger_first, outstanding_reads_out_the_absent_key_despite_a_false_duty, the_verdict_carries_a_citation, the_status_projection_reads_out_one_status, the_checklist_reads_out_cited_items]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
