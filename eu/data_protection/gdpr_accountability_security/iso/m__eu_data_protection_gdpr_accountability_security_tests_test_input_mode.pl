% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_accountability_security_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_accountability_security_gdpr_accountability_security, [gdpr_accountability_security_status/2, gdpr_accountability_security_status_values/1, duty_status/5, non_binding_items/3, joint_controller_arrangement/3, joint_controller_arrangement_content/4]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_kernel, [gdpr_accountability_security_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_fixtures, [gdpr_accountability_security_profile_for/2]).

false_statement(attested(false, attestation(host_system, attestation_time, controller_statement, none))).

test(compliant_holds_with_the_verdict_bound) :-
    gdpr_accountability_security_profile_for(all_statements_true, Profile),
    gdpr_accountability_security_status(Profile, compliant).
test(not_compliant_holds_with_the_verdict_bound) :-
    gdpr_accountability_security_profile_for(security_statement_false, Profile),
    gdpr_accountability_security_status(Profile, not_compliant).
test(review_required_holds_with_the_verdict_bound) :-
    gdpr_accountability_security_profile_for(accountability_statement_absent, Profile),
    gdpr_accountability_security_status(Profile, review_required).
test(input_problems_hold_with_the_verdict_bound) :-
    gdpr_accountability_security_profile_for(duplicated_accountability_statement, Profile),
    gdpr_accountability_security_status(Profile, input_problems([duplicate_key(accountability_demonstrated)])).
test(duty_not_met_holds_with_every_output_bound) :-
    gdpr_accountability_security_profile_for(security_statement_false, Profile),
    false_statement(FalseStatement),
    duty_status(Profile, security_of_processing, not_met, [outside_fact(security_level_appropriate_to_risk, FalseStatement)], [cite(eu_reg_2016_679_art_32_1), cite(eu_reg_2016_679_art_32_2)]).
test(arrangement_in_place_holds_bound) :-
    gdpr_accountability_security_profile_for(joint_arrangement_in_place, Profile),
    joint_controller_arrangement(Profile, arrangement_in_place, [cite(eu_reg_2016_679_art_26_1)]).
test(content_not_met_holds_bound) :-
    gdpr_accountability_security_profile_for(content_essence_not_available, Profile),
    joint_controller_arrangement_content(Profile, content_requirements_not_met, [], [cite(eu_reg_2016_679_art_26_2)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, gdpr_accountability_security_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    gdpr_accountability_security_input_problems([attribute(essence_of_arrangement_made_available, true)|_Tail], [wrong_type(profile)]).
test(an_unbound_element_is_not_an_attribute) :-
    gdpr_accountability_security_input_problems([_Element], [wrong_type(profile)]).
test(a_foreign_element_makes_the_whole_profile_wrong) :-
    findall(Problems, gdpr_accountability_security_input_problems([attribute(stray, true), stray], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_atom_is_not_an_attribute_list) :-
    gdpr_accountability_security_input_problems(profile, [wrong_type(profile)]).
test(an_unbound_key_is_an_unknown_key_as_given) :-
    gdpr_accountability_security_input_problems([attribute(Key, true)], Problems),
    Problems = [unknown_key(Found)],
    Found == Key.
test(a_number_key_is_an_unknown_key) :-
    gdpr_accountability_security_input_problems([attribute(42, true)], [unknown_key(42)]).
test(an_unbound_value_is_a_wrong_type) :-
    gdpr_accountability_security_input_problems([attribute(essence_of_arrangement_made_available, _Value)], [wrong_type(essence_of_arrangement_made_available)]).
test(a_repeated_unknown_key_is_named_once) :-
    gdpr_accountability_security_input_problems([attribute(stray, first), attribute(stray, second)], [unknown_key(stray)]).
test(a_duplicate_key_is_never_also_a_wrong_type) :-
    gdpr_accountability_security_input_problems([attribute(essence_of_arrangement_made_available, true), attribute(essence_of_arrangement_made_available, maybe)], [duplicate_key(essence_of_arrangement_made_available)]).
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    gdpr_accountability_security_input_problems([attribute(arrangement_between_controllers_exists, unsure)], [wrong_type(arrangement_between_controllers_exists)]).
test(the_judgement_accepts_unsure) :-
    gdpr_accountability_security_input_problems([attribute(controllers_jointly_determine_purposes_and_means, unsure)], []).
test(a_bare_boolean_outside_fact_is_a_wrong_type) :-
    gdpr_accountability_security_input_problems([attribute(accountability_demonstrated, true)], [wrong_type(accountability_demonstrated)]).
test(an_attestation_of_three_arguments_is_a_wrong_type) :-
    gdpr_accountability_security_input_problems([attribute(accountability_demonstrated, attested(true, attestation(host, moment, statement)))], [wrong_type(accountability_demonstrated)]).
test(contract_problems_come_before_unknown_keys) :-
    gdpr_accountability_security_input_problems([attribute(stray, true), attribute(essence_of_arrangement_made_available, maybe)], [wrong_type(essence_of_arrangement_made_available), unknown_key(stray)]).
test(an_absent_key_is_never_a_problem) :-
    gdpr_accountability_security_input_problems([], []).
test(duty_status_passes_input_problems_on) :-
    findall(Result - Basis - Citations, duty_status([stray], accountability, Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - [] - []].
test(non_binding_items_pass_input_problems_on_alone) :-
    findall(Items, non_binding_items(_Profile, accountability_principles, Items), Answers),
    Answers == [input_problems([wrong_type(profile)])].
test(joint_arrangement_passes_input_problems_on) :-
    joint_controller_arrangement([attribute(stray, true)], input_problems([unknown_key(stray)]), []).
test(content_passes_input_problems_on) :-
    joint_controller_arrangement_content([attribute(essence_of_arrangement_made_available, maybe)], input_problems([wrong_type(essence_of_arrangement_made_available)]), [], []).

test(every_other_bound_status_is_rejected, fail) :-
    gdpr_accountability_security_profile_for(all_statements_true, Profile),
    gdpr_accountability_security_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, compliant),
    gdpr_accountability_security_status(Profile, Other).
test(duty_met_is_rejected_when_the_statement_is_false, fail) :-
    gdpr_accountability_security_profile_for(security_statement_false, Profile),
    duty_status(Profile, security_of_processing, met, _, _).

cp_test_names([compliant_holds_with_the_verdict_bound, not_compliant_holds_with_the_verdict_bound, review_required_holds_with_the_verdict_bound, input_problems_hold_with_the_verdict_bound, duty_not_met_holds_with_every_output_bound, arrangement_in_place_holds_bound, content_not_met_holds_bound, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_unbound_element_is_not_an_attribute, a_foreign_element_makes_the_whole_profile_wrong, an_atom_is_not_an_attribute_list, an_unbound_key_is_an_unknown_key_as_given, a_number_key_is_an_unknown_key, an_unbound_value_is_a_wrong_type, a_repeated_unknown_key_is_named_once, a_duplicate_key_is_never_also_a_wrong_type, a_crisp_key_given_unsure_is_a_wrong_type, the_judgement_accepts_unsure, a_bare_boolean_outside_fact_is_a_wrong_type, an_attestation_of_three_arguments_is_a_wrong_type, contract_problems_come_before_unknown_keys, an_absent_key_is_never_a_problem, duty_status_passes_input_problems_on, non_binding_items_pass_input_problems_on_alone, joint_arrangement_passes_input_problems_on, content_passes_input_problems_on]).
cp_test_fail_names([every_other_bound_status_is_rejected, duty_met_is_rejected_when_the_statement_is_false]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
