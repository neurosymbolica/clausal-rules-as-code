% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_governance_risk_measures_queries, [nis2_governance_risk_measures_profile_keys/1, nis2_governance_risk_measures_what_if/4]).
:- use_module(m__eu_nis2_governance_risk_measures_kernel, [nis2_governance_risk_measures_input_problems/2]).
:- use_module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [nis2_governance_risk_measures_status/2, nis2_governance_risk_measures_checklist/2]).
:- use_module(m__eu_nis2_governance_risk_measures_fixtures, [nis2_governance_risk_measures_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_governance_risk_measures_profile_keys(ProfileKeys),
    ProfileKeys == [entity_class, multi_factor_authentication_and_secured_communications_appropriate, relevant_european_or_international_standards_apply, coordinated_supply_chain_risk_assessment_carried_out, non_compliance_with_the_art_21_2_measures_found].
test(what_if_out_of_scope_removes_the_duties) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_status(Profile, duties_apply),
    nis2_governance_risk_measures_what_if(Profile, entity_class, out_of_scope, no_duties_apply).
test(what_if_important_keeps_the_duties) :-
    nis2_governance_risk_measures_profile_for(out_of_scope_entity, Profile),
    nis2_governance_risk_measures_status(Profile, no_duties_apply),
    nis2_governance_risk_measures_what_if(Profile, entity_class, important_entity, duties_apply).
test(what_if_adds_a_missing_key) :-
    nis2_governance_risk_measures_what_if([], entity_class, essential_entity, duties_apply).
test(what_if_on_an_unrelated_key_leaves_the_verdict) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_what_if(Profile, non_compliance_with_the_art_21_2_measures_found, false, duties_apply).
test(what_if_a_wrong_type_value_gives_input_problems) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_what_if(Profile, entity_class, maybe, input_problems([wrong_type(entity_class)])).
test(what_if_an_unknown_key_gives_input_problems) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_what_if(Profile, surprise, true, input_problems([unknown_key(surprise)])).
test(what_if_replaces_a_duplicate_key_with_one_value) :-
    nis2_governance_risk_measures_what_if([attribute(entity_class, essential_entity), attribute(entity_class, out_of_scope)], entity_class, important_entity, duties_apply).
test(what_if_has_exactly_one_solution) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    findall(Status, nis2_governance_risk_measures_what_if(Profile, entity_class, out_of_scope, Status), Statuses),
    Statuses == [no_duties_apply].
test(input_problems_through_the_query_layer) :-
    nis2_governance_risk_measures_input_problems([attribute(surprise, true)], [unknown_key(surprise)]).
test(input_problems_through_the_query_layer_empty_for_a_good_profile) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    findall(Problems, nis2_governance_risk_measures_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(eligibility_status_is_a_verdict_atom) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    nis2_governance_risk_measures_status(Profile, duties_apply).
test(justification_checklist_rows_all_carry_a_cite) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    nis2_governance_risk_measures_checklist(Profile, Items),
    length(Items, 4),
    Items = [item(approve_the_cybersecurity_risk_management_measures, met, cite(eu_dir_2022_2555_art_20_1)), item(oversee_the_implementation_of_the_measures, met, cite(eu_dir_2022_2555_art_20_1)), item(can_be_held_liable_for_infringements_of_article_21, met, cite(eu_dir_2022_2555_art_20_1)), item(members_of_the_management_bodies_follow_training, met, cite(eu_dir_2022_2555_art_20_2))].
test(justification_checklist_is_empty_out_of_scope) :-
    nis2_governance_risk_measures_profile_for(out_of_scope_entity, Profile),
    nis2_governance_risk_measures_checklist(Profile, []).
test(justification_checklist_names_the_missing_key_when_indeterminate) :-
    nis2_governance_risk_measures_profile_for(entity_class_absent, Profile),
    nis2_governance_risk_measures_checklist(Profile, [item(overall, indeterminate([entity_class]), cite(eu_dir_2022_2555_art_20_1))]).

test(what_if_out_of_scope_is_not_duties_apply, fail) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_what_if(Profile, entity_class, out_of_scope, duties_apply).

cp_test_names([profile_keys_are_the_contract_keys, what_if_out_of_scope_removes_the_duties, what_if_important_keeps_the_duties, what_if_adds_a_missing_key, what_if_on_an_unrelated_key_leaves_the_verdict, what_if_a_wrong_type_value_gives_input_problems, what_if_an_unknown_key_gives_input_problems, what_if_replaces_a_duplicate_key_with_one_value, what_if_has_exactly_one_solution, input_problems_through_the_query_layer, input_problems_through_the_query_layer_empty_for_a_good_profile, eligibility_status_is_a_verdict_atom, justification_checklist_rows_all_carry_a_cite, justification_checklist_is_empty_out_of_scope, justification_checklist_names_the_missing_key_when_indeterminate]).
cp_test_fail_names([what_if_out_of_scope_is_not_duties_apply]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
