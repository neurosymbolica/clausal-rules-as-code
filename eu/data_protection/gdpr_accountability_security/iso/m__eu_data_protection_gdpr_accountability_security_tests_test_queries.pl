% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_accountability_security_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_accountability_security_queries, [gdpr_accountability_security_profile_keys/1, gdpr_accountability_security_what_if/4, met/0, not_met/0, content_requirements_met/0, accountability/0, data_protection_by_default/0, security_measures/0, accountability_principles/0, unsure/0, accountability_demonstrated/0, by_default_not_accessible_to_indefinite_number_without_intervention/0]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_fixtures, [gdpr_accountability_security_profile_for/2]).

true_statement(attested(true, attestation(host_system, attestation_time, controller_statement, none))).

false_statement(attested(false, attestation(host_system, attestation_time, controller_statement, none))).

test(profile_keys_are_the_contract_keys) :-
    gdpr_accountability_security_profile_keys(ProfileKeys),
    ProfileKeys == [accountability_demonstrated, controller_measures_implemented_and_reviewed, data_protection_policies_implemented, by_design_measures_implemented, by_default_only_necessary_data_processed, security_level_appropriate_to_risk, authorised_persons_process_only_on_instructions, controllers_jointly_determine_purposes_and_means, responsibilities_set_by_union_or_member_state_law, arrangement_between_controllers_exists, arrangement_reflects_roles_and_relationships, essence_of_arrangement_made_available, by_default_amount_collected_limited_to_necessary, by_default_extent_of_processing_limited_to_necessary, by_default_storage_period_limited_to_necessary, by_default_accessibility_limited_to_necessary, by_default_not_accessible_to_indefinite_number_without_intervention].
test(what_if_a_false_security_statement_is_not_compliant) :-
    gdpr_accountability_security_profile_for(all_statements_true, Profile),
    false_statement(FalseStatement),
    findall(Status, gdpr_accountability_security_what_if(Profile, security_level_appropriate_to_risk, FalseStatement, Status), Statuses),
    Statuses == [not_compliant].
test(what_if_a_true_security_statement_is_compliant) :-
    gdpr_accountability_security_profile_for(security_statement_false, Profile),
    true_statement(TrueStatement),
    gdpr_accountability_security_what_if(Profile, security_level_appropriate_to_risk, TrueStatement, compliant).
test(what_if_the_absent_statement_is_supplied) :-
    gdpr_accountability_security_profile_for(accountability_statement_absent, Profile),
    true_statement(TrueStatement),
    gdpr_accountability_security_what_if(Profile, accountability_demonstrated, TrueStatement, compliant).
test(what_if_replaces_every_duplicate) :-
    gdpr_accountability_security_profile_for(duplicated_accountability_statement, Profile),
    true_statement(TrueStatement),
    gdpr_accountability_security_what_if(Profile, accountability_demonstrated, TrueStatement, compliant).
test(what_if_a_false_crisp_default_is_not_compliant) :-
    gdpr_accountability_security_profile_for(by_default_crisp_fact_true, Profile),
    gdpr_accountability_security_what_if(Profile, by_default_not_accessible_to_indefinite_number_without_intervention, false, not_compliant).
test(what_if_an_unknown_key_is_an_input_problem) :-
    gdpr_accountability_security_profile_for(all_statements_true, Profile),
    gdpr_accountability_security_what_if(Profile, stray, true, input_problems([unknown_key(stray)])).
test(what_if_a_wrong_value_is_an_input_problem) :-
    gdpr_accountability_security_profile_for(all_statements_true, Profile),
    gdpr_accountability_security_what_if(Profile, essence_of_arrangement_made_available, maybe, input_problems([wrong_type(essence_of_arrangement_made_available)])).
test(the_root_atoms_are_defined) :-
    met,
    not_met,
    content_requirements_met,
    accountability,
    data_protection_by_default,
    security_measures,
    accountability_principles,
    unsure,
    accountability_demonstrated,
    by_default_not_accessible_to_indefinite_number_without_intervention.
test(the_result_constructors_are_data) :-
    Missing = indeterminate([accountability_demonstrated]),
    Missing = indeterminate(MissingKeys),
    MissingKeys == [accountability_demonstrated],
    Review = needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_1)), []),
    Review = needs_legal_review(open_textured(Input, _Citation), Context),
    Input == controllers_jointly_determine_purposes_and_means,
    Context == [],
    Refusal = input_problems([]),
    Refusal = input_problems(Problems),
    Problems == [].

test(what_if_keeps_the_other_items, fail) :-
    gdpr_accountability_security_profile_for(security_statement_false, Profile),
    true_statement(TrueStatement),
    gdpr_accountability_security_what_if(Profile, accountability_demonstrated, TrueStatement, compliant).

cp_test_names([profile_keys_are_the_contract_keys, what_if_a_false_security_statement_is_not_compliant, what_if_a_true_security_statement_is_compliant, what_if_the_absent_statement_is_supplied, what_if_replaces_every_duplicate, what_if_a_false_crisp_default_is_not_compliant, what_if_an_unknown_key_is_an_input_problem, what_if_a_wrong_value_is_an_input_problem, the_root_atoms_are_defined, the_result_constructors_are_data]).
cp_test_fail_names([what_if_keeps_the_other_items]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
