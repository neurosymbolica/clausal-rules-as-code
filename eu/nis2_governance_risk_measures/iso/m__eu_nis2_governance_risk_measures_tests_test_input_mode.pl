% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [nis2_governance_risk_measures_status/2, management_body_duties/2, risk_management_measures/2, proportionality_factors/2, supply_chain_considerations/2, corrective_measures_duty/3]).
:- use_module(m__eu_nis2_governance_risk_measures_kernel, [nis2_governance_risk_measures_input_problems/2]).
:- use_module(m__eu_nis2_governance_risk_measures_fixtures, [nis2_governance_risk_measures_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_status(Profile, duties_apply).
test(out_of_scope_status_bound) :-
    nis2_governance_risk_measures_profile_for(out_of_scope_entity, Profile),
    nis2_governance_risk_measures_status(Profile, no_duties_apply).
test(absent_entity_class_status_bound) :-
    nis2_governance_risk_measures_profile_for(entity_class_absent, Profile),
    nis2_governance_risk_measures_status(Profile, indeterminate([entity_class])).
test(out_of_scope_duties_bound_to_empty_list) :-
    management_body_duties([attribute(entity_class, out_of_scope)], []).
test(point_j_unsure_referral_bound) :-
    risk_management_measures([attribute(entity_class, important_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, unsure)], needs_legal_review(open_textured(multi_factor_authentication_and_secured_communications_appropriate, cite(eu_dir_2022_2555_art_21_2_j)), [inputs_relied_on([multi_factor_authentication_and_secured_communications_appropriate - unsure])])).
test(point_j_missing_bound) :-
    risk_management_measures([attribute(entity_class, important_entity)], indeterminate([multi_factor_authentication_and_secured_communications_appropriate])).
test(standards_missing_bound) :-
    proportionality_factors([attribute(entity_class, essential_entity)], indeterminate([relevant_european_or_international_standards_apply])).
test(coordinated_assessment_missing_bound) :-
    supply_chain_considerations([attribute(entity_class, essential_entity)], indeterminate([coordinated_supply_chain_risk_assessment_carried_out])).
test(corrective_duty_bound) :-
    corrective_measures_duty([attribute(entity_class, important_entity), attribute(non_compliance_with_the_art_21_2_measures_found, true)], must_take_corrective_measures_without_undue_delay, [cite(eu_dir_2022_2555_art_21_4)]).
test(corrective_duty_out_of_scope_reads_no_other_key) :-
    corrective_measures_duty([attribute(entity_class, out_of_scope)], no_corrective_measures_duty, [cite(eu_dir_2022_2555_art_21_4)]).
test(corrective_duty_missing_key_bound) :-
    corrective_measures_duty([attribute(entity_class, essential_entity)], indeterminate([non_compliance_with_the_art_21_2_measures_found]), []).
test(input_check_accepts_a_good_profile) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_input_problems(Profile, []).
test(input_check_names_an_unknown_key) :-
    nis2_governance_risk_measures_input_problems([attribute(entity_class, essential_entity), attribute(surprise, true)], [unknown_key(surprise)]).
test(input_check_names_a_wrong_type) :-
    nis2_governance_risk_measures_input_problems([attribute(relevant_european_or_international_standards_apply, unsure)], [wrong_type(relevant_european_or_international_standards_apply)]).
test(input_check_names_a_duplicate_key) :-
    nis2_governance_risk_measures_input_problems([attribute(entity_class, essential_entity), attribute(entity_class, out_of_scope)], [duplicate_key(entity_class)]).
test(input_check_orders_contract_keys_before_unknown_keys) :-
    nis2_governance_risk_measures_input_problems([attribute(surprise, true), attribute(entity_class, maybe)], [wrong_type(entity_class), unknown_key(surprise)]).
test(input_check_a_non_list_is_a_wrong_type_profile) :-
    nis2_governance_risk_measures_input_problems(not_a_profile, [wrong_type(profile)]).
test(input_check_a_list_with_a_non_attribute_is_a_wrong_type_profile) :-
    nis2_governance_risk_measures_input_problems([attribute(entity_class, essential_entity), oops], [wrong_type(profile)]).
test(duties_answer_input_problems_when_bound) :-
    management_body_duties([attribute(entity_class, essential_entity), attribute(entity_class, essential_entity)], input_problems([duplicate_key(entity_class)])).
test(corrective_answer_input_problems_have_empty_citations) :-
    corrective_measures_duty([attribute(entity_class, essential_entity), attribute(surprise, true)], input_problems([unknown_key(surprise)]), []).

test(the_wrong_bound_status_is_rejected, fail) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_status(Profile, no_duties_apply).
test(out_of_scope_wrong_bound_status_is_rejected, fail) :-
    nis2_governance_risk_measures_profile_for(out_of_scope_entity, Profile),
    nis2_governance_risk_measures_status(Profile, duties_apply).
test(corrective_duty_wrong_bound_result_is_rejected, fail) :-
    corrective_measures_duty([attribute(entity_class, important_entity), attribute(non_compliance_with_the_art_21_2_measures_found, true)], no_corrective_measures_duty, _).

cp_test_names([status_holds_with_the_verdict_bound, out_of_scope_status_bound, absent_entity_class_status_bound, out_of_scope_duties_bound_to_empty_list, point_j_unsure_referral_bound, point_j_missing_bound, standards_missing_bound, coordinated_assessment_missing_bound, corrective_duty_bound, corrective_duty_out_of_scope_reads_no_other_key, corrective_duty_missing_key_bound, input_check_accepts_a_good_profile, input_check_names_an_unknown_key, input_check_names_a_wrong_type, input_check_names_a_duplicate_key, input_check_orders_contract_keys_before_unknown_keys, input_check_a_non_list_is_a_wrong_type_profile, input_check_a_list_with_a_non_attribute_is_a_wrong_type_profile, duties_answer_input_problems_when_bound, corrective_answer_input_problems_have_empty_citations]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, out_of_scope_wrong_bound_status_is_rejected, corrective_duty_wrong_bound_result_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
