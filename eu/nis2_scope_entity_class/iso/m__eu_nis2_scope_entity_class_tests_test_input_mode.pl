% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [size_class/3, scope_decision/3, entity_class/3, nis2_scope_entity_class_status/2]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_profile_for/2]).

profile_of(Subject, Profile) :-
    nis2_scope_entity_class_profile_for(Subject, Profile).

test(the_baseline_status_holds_bound) :-
    profile_of(baseline_micro_outside_annexes, Profile),
    nis2_scope_entity_class_status(Profile, out_of_scope).
test(a_critical_entity_is_essential_with_its_citation_bound) :-
    profile_of(critical_entity, Profile),
    entity_class(Profile, essential_entity, [cite(eu_dir_2022_2555_art_3_1_f)]).
test(a_critical_entity_is_in_scope_bound) :-
    profile_of(critical_entity, Profile),
    scope_decision(Profile, in_scope, [cite(eu_dir_2022_2555_art_2_3)]).
test(a_micro_size_bound) :-
    profile_of(size_micro_at_ceilings, Profile),
    size_class(Profile, microenterprise, [cite(eu_dir_2022_2555_art_2_1)]).
test(an_exempted_entity_is_out_of_scope_bound) :-
    profile_of(resilience_exempted_critical_entity, Profile),
    scope_decision(Profile, out_of_scope, [cite(eu_dir_2022_2555_art_2_10)]).
test(a_domain_name_registration_entity_is_important_bound) :-
    profile_of(domain_name_registration, Profile),
    entity_class(Profile, important_entity, [cite(eu_dir_2022_2555_art_3_2)]).
test(a_missing_exemption_is_named_bound) :-
    profile_of(partial_annex_one_only, Profile),
    scope_decision(Profile, indeterminate([exempted_from_dora_scope_by_member_state]), []).
test(the_attribute_order_does_not_change_the_answer) :-
    profile_of(central_government_annex_one, Profile),
    reverse(Profile, Reversed),
    entity_class(Reversed, essential_entity, [cite(eu_dir_2022_2555_art_3_1_d)]).
test(a_profile_that_is_not_a_list_is_refused) :-
    size_class(foo, input_problems([wrong_type(profile)]), []).
test(a_list_with_a_foreign_element_is_refused) :-
    scope_decision([attribute(annex_i_type, true), foo], input_problems([wrong_type(profile)]), []).
test(a_duplicate_key_is_refused) :-
    scope_decision([attribute(tld_name_registry, true), attribute(tld_name_registry, true)], input_problems([duplicate_key(tld_name_registry)]), []).
test(a_crisp_key_given_unsure_is_refused) :-
    entity_class([attribute(critical_entity_under_directive_2022_2557, unsure)], input_problems([wrong_type(critical_entity_under_directive_2022_2557)]), []).
test(a_fractional_headcount_is_refused) :-
    size_class([attribute(staff_headcount, 12.5)], input_problems([wrong_type(staff_headcount)]), []).
test(an_atom_headcount_is_refused) :-
    size_class([attribute(staff_headcount, many)], input_problems([wrong_type(staff_headcount)]), []).
test(an_unknown_key_is_refused_by_every_query) :-
    size_class([attribute(colour, red)], input_problems([unknown_key(colour)]), []),
    scope_decision([attribute(colour, red)], input_problems([unknown_key(colour)]), []),
    entity_class([attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(a_key_the_size_query_does_not_read_is_still_checked) :-
    size_class([attribute(staff_headcount, 250), attribute(annex_i_type, maybe)], input_problems([wrong_type(annex_i_type)]), []).
test(an_unsure_judgement_is_accepted) :-
    size_class([attribute(annex_i_type, unsure), attribute(staff_headcount, 250)], large_enterprise, [cite(eu_dir_2022_2555_art_2_1)]).

test(the_baseline_is_not_important, fail) :-
    profile_of(baseline_micro_outside_annexes, Profile),
    nis2_scope_entity_class_status(Profile, important_entity).
test(the_baseline_is_not_essential, fail) :-
    profile_of(baseline_micro_outside_annexes, Profile),
    nis2_scope_entity_class_status(Profile, essential_entity).
test(a_critical_entity_with_a_wrong_bound_citation_is_rejected, fail) :-
    profile_of(critical_entity, Profile),
    entity_class(Profile, essential_entity, [cite(eu_dir_2022_2555_art_3_1_a)]).
test(a_micro_size_is_not_small_bound, fail) :-
    profile_of(size_micro_at_ceilings, Profile),
    size_class(Profile, small_enterprise, _).
test(an_absent_key_is_not_an_input_problem, fail) :-
    size_class([attribute(staff_headcount, 5)], input_problems(_), _).

cp_test_names([the_baseline_status_holds_bound, a_critical_entity_is_essential_with_its_citation_bound, a_critical_entity_is_in_scope_bound, a_micro_size_bound, an_exempted_entity_is_out_of_scope_bound, a_domain_name_registration_entity_is_important_bound, a_missing_exemption_is_named_bound, the_attribute_order_does_not_change_the_answer, a_profile_that_is_not_a_list_is_refused, a_list_with_a_foreign_element_is_refused, a_duplicate_key_is_refused, a_crisp_key_given_unsure_is_refused, a_fractional_headcount_is_refused, an_atom_headcount_is_refused, an_unknown_key_is_refused_by_every_query, a_key_the_size_query_does_not_read_is_still_checked, an_unsure_judgement_is_accepted]).
cp_test_fail_names([the_baseline_is_not_important, the_baseline_is_not_essential, a_critical_entity_with_a_wrong_bound_citation_is_rejected, a_micro_size_is_not_small_bound, an_absent_key_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
