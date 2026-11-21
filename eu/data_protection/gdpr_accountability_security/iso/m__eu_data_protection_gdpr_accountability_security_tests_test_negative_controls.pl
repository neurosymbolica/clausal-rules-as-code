% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_accountability_security_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_accountability_security_gdpr_accountability_security, [gdpr_accountability_security_status/2, gdpr_accountability_security_status_values/1, duty_status/5, joint_controller_arrangement/3, joint_controller_arrangement_content/4]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_kernel, [gdpr_accountability_security_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_fixtures, [gdpr_accountability_security_profile_for/2]).

test(the_status_table_has_a_near_miss_atom) :-
    gdpr_accountability_security_status_values(StatusValues),
    StatusValues = [_, _|_].
test(security_true_is_met) :-
    gdpr_accountability_security_profile_for(all_statements_true, Profile),
    duty_status(Profile, security_of_processing, met, _, _).
test(security_false_is_not_met) :-
    gdpr_accountability_security_profile_for(security_statement_false, Profile),
    duty_status(Profile, security_of_processing, not_met, _, _).
test(the_facade_flips_with_the_security_statement) :-
    gdpr_accountability_security_profile_for(security_statement_false, Profile),
    gdpr_accountability_security_status(Profile, not_compliant).
test(an_absent_accountability_statement_refers) :-
    gdpr_accountability_security_profile_for(accountability_statement_absent, Profile),
    duty_status(Profile, accountability, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_5_2), cite(controller_compliance_demonstration)), _), [], []).
test(a_false_storage_aspect_is_not_met) :-
    gdpr_accountability_security_profile_for(by_default_storage_aspect_false, Profile),
    duty_status(Profile, data_protection_by_default, not_met, [outside_fact(by_default_storage_period_limited_to_necessary, _)], [cite(eu_reg_2016_679_art_25_2)]).
test(all_true_aspects_are_met) :-
    gdpr_accountability_security_profile_for(by_default_all_aspects_true, Profile),
    duty_status(Profile, data_protection_by_default, met, _, _).
test(a_false_crisp_fact_is_not_met_with_an_empty_basis) :-
    gdpr_accountability_security_profile_for(by_default_crisp_fact_false, Profile),
    duty_status(Profile, data_protection_by_default, not_met, [], [cite(eu_reg_2016_679_art_25_2)]).
test(a_true_crisp_fact_is_met) :-
    gdpr_accountability_security_profile_for(by_default_crisp_fact_true, Profile),
    duty_status(Profile, data_protection_by_default, met, _, _).
test(the_crisp_fact_is_read_by_no_other_duty) :-
    gdpr_accountability_security_profile_for(by_default_crisp_fact_false, Profile),
    duty_status(Profile, data_protection_by_design, met, _, _).
test(an_arrangement_in_place) :-
    gdpr_accountability_security_profile_for(joint_arrangement_in_place, Profile),
    joint_controller_arrangement(Profile, arrangement_in_place, _).
test(an_arrangement_missing) :-
    gdpr_accountability_security_profile_for(joint_arrangement_missing, Profile),
    joint_controller_arrangement(Profile, arrangement_missing, _).
test(an_unsure_judgement_goes_to_a_lawyer) :-
    gdpr_accountability_security_profile_for(joint_controllers_unsure, Profile),
    joint_controller_arrangement(Profile, needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_1)), _), []).
test(not_joint_controllers) :-
    gdpr_accountability_security_profile_for(not_joint_controllers, Profile),
    joint_controller_arrangement(Profile, not_joint_controllers, [cite(eu_reg_2016_679_art_26_1)]).
test(the_law_setting_responsibilities_needs_no_arrangement) :-
    gdpr_accountability_security_profile_for(joint_law_sets_responsibilities, Profile),
    joint_controller_arrangement(Profile, arrangement_not_required, _).
test(the_law_key_absent_is_indeterminate) :-
    gdpr_accountability_security_profile_for(joint_law_key_absent, Profile),
    joint_controller_arrangement(Profile, indeterminate([responsibilities_set_by_union_or_member_state_law]), []).
test(the_content_requirements_met) :-
    gdpr_accountability_security_profile_for(content_requirements_met, Profile),
    joint_controller_arrangement_content(Profile, content_requirements_met, _, _).
test(the_essence_not_available_is_not_met) :-
    gdpr_accountability_security_profile_for(content_essence_not_available, Profile),
    joint_controller_arrangement_content(Profile, content_requirements_not_met, [], _).
test(a_false_roles_statement_is_not_met) :-
    gdpr_accountability_security_profile_for(content_roles_statement_false, Profile),
    joint_controller_arrangement_content(Profile, content_requirements_not_met, [outside_fact(arrangement_reflects_roles_and_relationships, _)], _).
test(an_absent_roles_statement_refers) :-
    gdpr_accountability_security_profile_for(content_roles_statement_absent, Profile),
    joint_controller_arrangement_content(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_26_2), cite(arrangement_roles_statement)), _), [], []).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_accountability_security_profile_for(all_statements_true, Profile),
    gdpr_accountability_security_input_problems(Profile, []).
test(a_duplicated_statement_is_a_duplicate_key) :-
    gdpr_accountability_security_profile_for(duplicated_accountability_statement, Profile),
    gdpr_accountability_security_input_problems(Profile, [duplicate_key(accountability_demonstrated)]).
test(an_unknown_key_is_named) :-
    gdpr_accountability_security_profile_for(unknown_key_present, Profile),
    gdpr_accountability_security_input_problems(Profile, [unknown_key(controller_location)]).
test(a_wrong_type_judgement_is_named) :-
    gdpr_accountability_security_profile_for(wrong_type_judgement, Profile),
    gdpr_accountability_security_input_problems(Profile, [wrong_type(controllers_jointly_determine_purposes_and_means)]).
test(a_crisp_unsure_is_a_problem) :-
    gdpr_accountability_security_input_problems([attribute(essence_of_arrangement_made_available, unsure)], [wrong_type(essence_of_arrangement_made_available)]).
test(a_crisp_true_is_no_problem) :-
    gdpr_accountability_security_input_problems([attribute(essence_of_arrangement_made_available, true)], []).

test(security_false_is_never_met, fail) :-
    gdpr_accountability_security_profile_for(security_statement_false, Profile),
    duty_status(Profile, security_of_processing, met, _, _).
test(the_facade_is_not_compliant_only_with_a_false_statement, fail) :-
    gdpr_accountability_security_profile_for(all_statements_true, Profile),
    gdpr_accountability_security_status(Profile, not_compliant).
test(an_absent_accountability_statement_is_never_met, fail) :-
    gdpr_accountability_security_profile_for(accountability_statement_absent, Profile),
    duty_status(Profile, accountability, met, _, _).
test(an_absent_statement_is_never_indeterminate, fail) :-
    gdpr_accountability_security_profile_for(accountability_statement_absent, Profile),
    duty_status(Profile, accountability, indeterminate(_), _, _).
test(all_true_aspects_are_never_not_met, fail) :-
    gdpr_accountability_security_profile_for(by_default_all_aspects_true, Profile),
    duty_status(Profile, data_protection_by_default, not_met, _, _).
test(a_true_crisp_fact_is_never_not_met, fail) :-
    gdpr_accountability_security_profile_for(by_default_crisp_fact_true, Profile),
    duty_status(Profile, data_protection_by_default, not_met, _, _).
test(a_missing_arrangement_is_never_in_place, fail) :-
    gdpr_accountability_security_profile_for(joint_arrangement_missing, Profile),
    joint_controller_arrangement(Profile, arrangement_in_place, _).
test(an_unsure_judgement_is_never_in_place, fail) :-
    gdpr_accountability_security_profile_for(joint_controllers_unsure, Profile),
    joint_controller_arrangement(Profile, arrangement_in_place, _).
test(not_joint_controllers_never_need_the_law_key, fail) :-
    gdpr_accountability_security_profile_for(not_joint_controllers, Profile),
    joint_controller_arrangement(Profile, indeterminate(_), _).
test(the_law_key_absent_never_needs_no_arrangement, fail) :-
    gdpr_accountability_security_profile_for(joint_law_key_absent, Profile),
    joint_controller_arrangement(Profile, arrangement_not_required, _).
test(the_essence_not_available_is_never_met, fail) :-
    gdpr_accountability_security_profile_for(content_essence_not_available, Profile),
    joint_controller_arrangement_content(Profile, content_requirements_met, _, _).
test(a_false_roles_statement_is_never_met, fail) :-
    gdpr_accountability_security_profile_for(content_roles_statement_false, Profile),
    joint_controller_arrangement_content(Profile, content_requirements_met, _, _).
test(an_absent_roles_statement_is_never_met, fail) :-
    gdpr_accountability_security_profile_for(content_roles_statement_absent, Profile),
    joint_controller_arrangement_content(Profile, content_requirements_met, _, _).
test(a_duplicated_statement_gets_no_duty_answer, fail) :-
    gdpr_accountability_security_profile_for(duplicated_accountability_statement, Profile),
    duty_status(Profile, accountability, met, _, _).
test(a_wrong_type_judgement_gets_no_arrangement_answer, fail) :-
    gdpr_accountability_security_profile_for(wrong_type_judgement, Profile),
    joint_controller_arrangement(Profile, indeterminate(_), _).

cp_test_names([the_status_table_has_a_near_miss_atom, security_true_is_met, security_false_is_not_met, the_facade_flips_with_the_security_statement, an_absent_accountability_statement_refers, a_false_storage_aspect_is_not_met, all_true_aspects_are_met, a_false_crisp_fact_is_not_met_with_an_empty_basis, a_true_crisp_fact_is_met, the_crisp_fact_is_read_by_no_other_duty, an_arrangement_in_place, an_arrangement_missing, an_unsure_judgement_goes_to_a_lawyer, not_joint_controllers, the_law_setting_responsibilities_needs_no_arrangement, the_law_key_absent_is_indeterminate, the_content_requirements_met, the_essence_not_available_is_not_met, a_false_roles_statement_is_not_met, an_absent_roles_statement_refers, a_well_formed_profile_has_no_problem, a_duplicated_statement_is_a_duplicate_key, an_unknown_key_is_named, a_wrong_type_judgement_is_named, a_crisp_unsure_is_a_problem, a_crisp_true_is_no_problem]).
cp_test_fail_names([security_false_is_never_met, the_facade_is_not_compliant_only_with_a_false_statement, an_absent_accountability_statement_is_never_met, an_absent_statement_is_never_indeterminate, all_true_aspects_are_never_not_met, a_true_crisp_fact_is_never_not_met, a_missing_arrangement_is_never_in_place, an_unsure_judgement_is_never_in_place, not_joint_controllers_never_need_the_law_key, the_law_key_absent_never_needs_no_arrangement, the_essence_not_available_is_never_met, a_false_roles_statement_is_never_met, an_absent_roles_statement_is_never_met, a_duplicated_statement_gets_no_duty_answer, a_wrong_type_judgement_gets_no_arrangement_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
