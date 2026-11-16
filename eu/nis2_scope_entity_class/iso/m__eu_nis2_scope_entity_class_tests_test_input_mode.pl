% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [nis2_scope_entity_class_status/2, size_class/3, scope_decision/3, entity_class/3]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_profile_for/2]).

test(baseline_status_holds_with_the_verdict_bound) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    nis2_scope_entity_class_status(Profile, ineligible).
test(critical_entity_status_bound) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    nis2_scope_entity_class_status(Profile, eligible).
test(size_bound_micro) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    size_class(Profile, microenterprise, [cite(eu_dir_2022_2555_art_2_1)]).
test(scope_bound_in_scope) :-
    nis2_scope_entity_class_profile_for(domain_registrar, Profile),
    scope_decision(Profile, in_scope, [cite(eu_dir_2022_2555_art_2_4)]).
test(class_bound_important_default) :-
    nis2_scope_entity_class_profile_for(domain_registrar, Profile), entity_class(Profile, important_entity, [cite(eu_dir_2022_3_2_placeholder)]) ; nis2_scope_entity_class_profile_for(domain_registrar, Profile), entity_class(Profile, important_entity, [cite(eu_dir_2022_2555_art_3_2)]).
test(class_bound_essential) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    entity_class(Profile, essential_entity, [cite(eu_dir_2022_2555_art_3_1_f)]).
test(exclusion_bound_out_of_scope) :-
    nis2_scope_entity_class_profile_for(national_security_exclusion, Profile),
    scope_decision(Profile, out_of_scope, [cite(eu_dir_2022_2555_art_2_7), cite(eu_dir_2022_2555_art_2_9)]).
test(unknown_key_is_an_input_problem) :-
    scope_decision([attribute(bogus, true)], input_problems([unknown_key(bogus)]), []).
test(unknown_key_checked_by_size_class_too) :-
    size_class([attribute(bogus, true)], input_problems([unknown_key(bogus)]), []).
test(unknown_key_checked_by_entity_class_too) :-
    entity_class([attribute(bogus, true)], input_problems([unknown_key(bogus)]), []).
test(negative_headcount_is_wrong_type) :-
    size_class([attribute(staff_headcount, -1)], input_problems([wrong_type(staff_headcount)]), []).
test(unsure_in_a_crisp_key_is_wrong_type) :-
    scope_decision([attribute(tld_name_registry, unsure)], input_problems([wrong_type(tld_name_registry)]), []).
test(a_non_list_profile_is_wrong_type_profile) :-
    scope_decision(not_a_profile, input_problems([wrong_type(profile)]), []).
test(duplicate_key_is_named_once) :-
    nis2_scope_entity_class_profile_for(duplicate_key_profile, Profile),
    entity_class(Profile, input_problems([duplicate_key(staff_headcount)]), []).
test(absent_headcount_is_indeterminate) :-
    size_class([], indeterminate([staff_headcount]), []).

test(the_wrong_bound_status_is_rejected, fail) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    nis2_scope_entity_class_status(Profile, eligible).
test(critical_entity_wrong_bound_status_rejected, fail) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    nis2_scope_entity_class_status(Profile, ineligible).
test(size_bound_wrong_is_rejected, fail) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    size_class(Profile, small_enterprise, _).

cp_test_names([baseline_status_holds_with_the_verdict_bound, critical_entity_status_bound, size_bound_micro, scope_bound_in_scope, class_bound_important_default, class_bound_essential, exclusion_bound_out_of_scope, unknown_key_is_an_input_problem, unknown_key_checked_by_size_class_too, unknown_key_checked_by_entity_class_too, negative_headcount_is_wrong_type, unsure_in_a_crisp_key_is_wrong_type, a_non_list_profile_is_wrong_type_profile, duplicate_key_is_named_once, absent_headcount_is_indeterminate]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, critical_entity_wrong_bound_status_rejected, size_bound_wrong_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
