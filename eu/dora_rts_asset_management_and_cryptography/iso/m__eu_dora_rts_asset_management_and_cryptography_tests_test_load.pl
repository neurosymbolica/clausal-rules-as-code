% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_asset_management_and_cryptography_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_kernel, [dora_rts_asset_management_and_cryptography_input_problems/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_citations, [citation/2, implements/1]).

test(the_completeness_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, simplified_framework_entity),
    dif(incomplete, simplified_framework_entity).
test(the_outstanding_atoms_are_distinct) :-
    dif(none_outstanding, simplified_framework_entity),
    dif(none_outstanding, complete),
    dif(none_outstanding, incomplete).
test(the_duty_atoms_are_distinct) :-
    dif(ict_asset_records, legacy_ict_system_risk_assessment_records),
    dif(certificate_register, prompt_certificate_renewal),
    dif(encryption_policy_design_basis, key_protection_controls_design_basis).
test(the_required_term_carries_its_duties) :-
    Result = required([ict_asset_management_policy, ict_asset_lifecycle_monitoring_and_management]),
    Result = required(Duties),
    Duties == [ict_asset_management_policy, ict_asset_lifecycle_monitoring_and_management].
test(the_outstanding_term_carries_its_duties) :-
    Result = outstanding([prompt_certificate_renewal]),
    Result = outstanding(Duties),
    Duties == [prompt_certificate_renewal].
test(the_indeterminate_term_carries_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate([MissingKey]),
    MissingKey == financial_entity_is_article_16_1_entity.
test(the_review_term_carries_reason_and_context) :-
    Result = needs_legal_review(open_textured(certificates_renewed_promptly_before_expiration, cite(eu_reg_2024_1774_art_7_5)), [inputs_relied_on([financial_entity_is_article_16_1_entity - false, certificates_renewed_promptly_before_expiration - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == certificates_renewed_promptly_before_expiration,
    CitationKey == eu_reg_2024_1774_art_7_5,
    Pairs == [financial_entity_is_article_16_1_entity - false, certificates_renewed_promptly_before_expiration - unsure].
test(the_input_problems_term_carries_its_problems) :-
    Result = input_problems([duplicate_key(financial_entity_is_microenterprise), unknown_key(colour)]),
    Result = input_problems(Problems),
    Problems == [duplicate_key(financial_entity_is_microenterprise), unknown_key(colour)].
test(an_empty_profile_has_no_problem_once) :-
    findall(Problems, dora_rts_asset_management_and_cryptography_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, true), attribute(certificates_renewed_promptly_before_expiration, unsure)], Problems),
    Problems == [].
test(a_profile_that_is_not_a_list_is_wrong_type) :-
    findall(Problems, dora_rts_asset_management_and_cryptography_input_problems(not_a_list, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type) :-
    dora_rts_asset_management_and_cryptography_input_problems(_Unbound, Problems),
    Problems == [wrong_type(profile)].
test(an_unsure_fact_is_wrong_type_before_an_unknown_key) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(colour, 7), attribute(financial_entity_is_microenterprise, unsure)], Problems),
    Problems == [wrong_type(financial_entity_is_microenterprise), unknown_key(colour)].
test(a_repeated_key_is_a_duplicate_and_not_wrong_type) :-
    dora_rts_asset_management_and_cryptography_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, maybe)], Problems),
    Problems == [duplicate_key(financial_entity_is_article_16_1_entity)].
test(the_first_paragraph_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_4_1, Record),
    member(label - _, Record).
test(the_gate_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(a_point_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_6_2_d, _Record).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2024_1774_art_7_5).

test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2024_1774_art_7_6).

cp_test_names([the_completeness_atoms_are_distinct, the_outstanding_atoms_are_distinct, the_duty_atoms_are_distinct, the_required_term_carries_its_duties, the_outstanding_term_carries_its_duties, the_indeterminate_term_carries_one_key, the_review_term_carries_reason_and_context, the_input_problems_term_carries_its_problems, an_empty_profile_has_no_problem_once, a_well_formed_profile_has_no_problem, a_profile_that_is_not_a_list_is_wrong_type, an_unbound_profile_is_wrong_type, an_unsure_fact_is_wrong_type_before_an_unknown_key, a_repeated_key_is_a_duplicate_and_not_wrong_type, the_first_paragraph_citation_is_recorded, the_gate_citation_is_recorded, a_point_citation_is_recorded, the_provenance_marker_holds_for_a_recorded_key]).
cp_test_fail_names([the_provenance_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
