% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [nis2_governance_risk_measures_status/2, nis2_governance_risk_measures_status_values/1, management_body_duties/2, risk_management_measures/2, proportionality_factors/2, supply_chain_considerations/2, corrective_measures_duty/3]).

test(both_verdict_atoms_are_real_status_values) :-
    nis2_governance_risk_measures_status_values(StatusValues),
    member(duties_apply, StatusValues),
    member(no_duties_apply, StatusValues).
test(an_essential_entity_has_duties_apply) :-
    nis2_governance_risk_measures_status([attribute(entity_class, essential_entity)], duties_apply).
test(an_out_of_scope_entity_has_no_duties_apply) :-
    nis2_governance_risk_measures_status([attribute(entity_class, out_of_scope)], no_duties_apply).
test(an_absent_entity_class_is_indeterminate) :-
    management_body_duties([], indeterminate([entity_class])).
test(point_j_true_lists_the_authentication_measure) :-
    risk_management_measures([attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, true)], Measures),
    member(measure(multi_factor_or_continuous_authentication_and_secured_communications, cite(eu_dir_2022_2555_art_21_2_j)), Measures).
test(point_j_false_still_lists_cryptography) :-
    risk_management_measures([attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, false)], Measures),
    member(measure(policies_and_procedures_on_the_use_of_cryptography_and_encryption, cite(eu_dir_2022_2555_art_21_2_h)), Measures).
test(point_j_unsure_is_a_referral) :-
    risk_management_measures([attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, unsure)], needs_legal_review(open_textured(_, cite(eu_dir_2022_2555_art_21_2_j)), _)).
test(point_j_absent_is_indeterminate_not_a_referral) :-
    risk_management_measures([attribute(entity_class, essential_entity)], indeterminate([multi_factor_authentication_and_secured_communications_appropriate])).
test(standards_true_lists_the_standards_factor) :-
    proportionality_factors([attribute(entity_class, essential_entity), attribute(relevant_european_or_international_standards_apply, true)], Factors),
    member(factor(relevant_european_and_international_standards, cite(eu_dir_2022_2555_art_21_1)), Factors).
test(standards_false_still_lists_the_state_of_the_art) :-
    proportionality_factors([attribute(entity_class, essential_entity), attribute(relevant_european_or_international_standards_apply, false)], Factors),
    member(factor(state_of_the_art, cite(eu_dir_2022_2555_art_21_1)), Factors).
test(coordinated_true_lists_the_assessment_results) :-
    supply_chain_considerations([attribute(entity_class, important_entity), attribute(coordinated_supply_chain_risk_assessment_carried_out, true)], Considerations),
    member(consideration(results_of_the_coordinated_security_risk_assessments_of_critical_supply_chains, cite(eu_dir_2022_2555_art_21_3)), Considerations).
test(coordinated_false_still_lists_supplier_vulnerabilities) :-
    supply_chain_considerations([attribute(entity_class, important_entity), attribute(coordinated_supply_chain_risk_assessment_carried_out, false)], Considerations),
    member(consideration(vulnerabilities_specific_to_each_direct_supplier_and_service_provider, cite(eu_dir_2022_2555_art_21_3)), Considerations).
test(non_compliance_found_must_take_corrective_measures) :-
    corrective_measures_duty([attribute(entity_class, essential_entity), attribute(non_compliance_with_the_art_21_2_measures_found, true)], must_take_corrective_measures_without_undue_delay, [cite(eu_dir_2022_2555_art_21_4)]).
test(no_non_compliance_found_is_no_duty) :-
    corrective_measures_duty([attribute(entity_class, essential_entity), attribute(non_compliance_with_the_art_21_2_measures_found, false)], no_corrective_measures_duty, [cite(eu_dir_2022_2555_art_21_4)]).
test(out_of_scope_with_non_compliance_found_is_no_duty) :-
    corrective_measures_duty([attribute(entity_class, out_of_scope), attribute(non_compliance_with_the_art_21_2_measures_found, true)], no_corrective_measures_duty, [cite(eu_dir_2022_2555_art_21_4)]).
test(an_unknown_key_gives_input_problems) :-
    management_body_duties([attribute(entity_class, essential_entity), attribute(surprise, true)], input_problems([unknown_key(surprise)])).
test(a_wrong_type_value_gives_input_problems_before_any_referral) :-
    risk_management_measures([attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, maybe)], input_problems([wrong_type(multi_factor_authentication_and_secured_communications_appropriate)])).

test(an_out_of_scope_entity_is_not_duties_apply, fail) :-
    nis2_governance_risk_measures_status([attribute(entity_class, out_of_scope)], duties_apply).
test(an_essential_entity_is_not_no_duties_apply, fail) :-
    nis2_governance_risk_measures_status([attribute(entity_class, essential_entity)], no_duties_apply).
test(a_present_entity_class_is_not_indeterminate, fail) :-
    management_body_duties([attribute(entity_class, important_entity)], indeterminate(_)).
test(an_absent_entity_class_gives_no_duty_list, fail) :-
    management_body_duties([], [_|_]).
test(point_j_false_omits_the_authentication_measure, fail) :-
    risk_management_measures([attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, false)], Measures),
    member(measure(multi_factor_or_continuous_authentication_and_secured_communications, _), Measures).
test(point_j_false_is_not_a_referral, fail) :-
    risk_management_measures([attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, false)], needs_legal_review(_, _)).
test(point_j_unsure_is_not_a_measure_list, fail) :-
    risk_management_measures([attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, unsure)], [_|_]).
test(standards_false_omits_the_standards_factor, fail) :-
    proportionality_factors([attribute(entity_class, essential_entity), attribute(relevant_european_or_international_standards_apply, false)], Factors),
    member(factor(relevant_european_and_international_standards, _), Factors).
test(coordinated_false_omits_the_assessment_results, fail) :-
    supply_chain_considerations([attribute(entity_class, important_entity), attribute(coordinated_supply_chain_risk_assessment_carried_out, false)], Considerations),
    member(consideration(results_of_the_coordinated_security_risk_assessments_of_critical_supply_chains, _), Considerations).
test(non_compliance_found_is_not_no_duty, fail) :-
    corrective_measures_duty([attribute(entity_class, essential_entity), attribute(non_compliance_with_the_art_21_2_measures_found, true)], no_corrective_measures_duty, _).
test(no_non_compliance_found_is_not_a_must, fail) :-
    corrective_measures_duty([attribute(entity_class, essential_entity), attribute(non_compliance_with_the_art_21_2_measures_found, false)], must_take_corrective_measures_without_undue_delay, _).
test(out_of_scope_with_non_compliance_found_is_not_a_must, fail) :-
    corrective_measures_duty([attribute(entity_class, out_of_scope), attribute(non_compliance_with_the_art_21_2_measures_found, true)], must_take_corrective_measures_without_undue_delay, _).
test(without_the_unknown_key_there_are_no_input_problems, fail) :-
    management_body_duties([attribute(entity_class, essential_entity)], input_problems(_)).
test(an_unsure_crisp_key_is_a_wrong_type_not_a_referral, fail) :-
    proportionality_factors([attribute(entity_class, essential_entity), attribute(relevant_european_or_international_standards_apply, unsure)], needs_legal_review(_, _)).

cp_test_names([both_verdict_atoms_are_real_status_values, an_essential_entity_has_duties_apply, an_out_of_scope_entity_has_no_duties_apply, an_absent_entity_class_is_indeterminate, point_j_true_lists_the_authentication_measure, point_j_false_still_lists_cryptography, point_j_unsure_is_a_referral, point_j_absent_is_indeterminate_not_a_referral, standards_true_lists_the_standards_factor, standards_false_still_lists_the_state_of_the_art, coordinated_true_lists_the_assessment_results, coordinated_false_still_lists_supplier_vulnerabilities, non_compliance_found_must_take_corrective_measures, no_non_compliance_found_is_no_duty, out_of_scope_with_non_compliance_found_is_no_duty, an_unknown_key_gives_input_problems, a_wrong_type_value_gives_input_problems_before_any_referral]).
cp_test_fail_names([an_out_of_scope_entity_is_not_duties_apply, an_essential_entity_is_not_no_duties_apply, a_present_entity_class_is_not_indeterminate, an_absent_entity_class_gives_no_duty_list, point_j_false_omits_the_authentication_measure, point_j_false_is_not_a_referral, point_j_unsure_is_not_a_measure_list, standards_false_omits_the_standards_factor, coordinated_false_omits_the_assessment_results, non_compliance_found_is_not_no_duty, no_non_compliance_found_is_not_a_must, out_of_scope_with_non_compliance_found_is_not_a_must, without_the_unknown_key_there_are_no_input_problems, an_unsure_crisp_key_is_a_wrong_type_not_a_referral]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
