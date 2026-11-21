% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_colorado_cpa_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_colorado_cpa_kernel, [colorado_cpa_input_problems/2, query_problems/3, date_plus_days/3, date_later_of/3]).
:- use_module(m__us_colorado_cpa_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = colorado_cpa_verdict(in_scope, [cite(us_co_crs_6_1_1304_1_a)]),
    Verdict = colorado_cpa_verdict(Status, Citations),
    Status == in_scope,
    Citations == [cite(us_co_crs_6_1_1304_1_a)].
test(the_indeterminate_compound_destructures) :-
    Answer = indeterminate([entity_category]),
    Answer = indeterminate(MissingKeys),
    MissingKeys == [entity_category].
test(the_needs_legal_review_compound_destructures) :-
    Answer = needs_legal_review(open_textured(colorado_link_for_minors_duties, cite(us_co_crs_6_1_1304_1_b)), [inputs_relied_on([colorado_link_for_minors_duties - unsure])]),
    Answer = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == colorado_link_for_minors_duties,
    CitationKey == us_co_crs_6_1_1304_1_b,
    Pairs == [colorado_link_for_minors_duties - unsure].
test(the_applicability_atoms_are_distinct) :-
    dif(in_scope, biometric_only_scope),
    dif(in_scope, out_of_scope),
    dif(in_scope, exempt_entity),
    dif(biometric_only_scope, out_of_scope),
    dif(biometric_only_scope, exempt_entity),
    dif(out_of_scope, exempt_entity).
test(the_action_status_atoms_are_distinct) :-
    dif(cure_provision_not_in_force, cure_requirement_not_applicable),
    dif(notice_not_yet_received, cure_period_running),
    dif(action_may_be_brought, no_action_for_cured_violation),
    dif(cure_period_running, action_may_be_brought).
test(the_coverage_citation_is_recorded) :-
    citation(us_co_crs_6_1_1304_1_a, _Record).
test(the_cure_citation_is_recorded) :-
    citation(us_co_crs_6_1_1311_1_d_ii, _Record).
test(a_recorded_key_is_implemented) :-
    implements(us_co_crs_6_1_1306_2_a).
test(an_empty_profile_has_no_problem) :-
    colorado_cpa_input_problems([], []).
test(a_non_list_profile_is_wrong_type) :-
    colorado_cpa_input_problems(nonsense, [wrong_type(profile)]).
test(a_real_date_argument_has_no_problem) :-
    query_problems([], [received_date - date(2026, 1, 1)], []).
test(forty_five_days_after_a_date) :-
    date_plus_days(date(2026, 1, 1), 45, date(2026, 2, 15)).
test(the_later_of_two_dates) :-
    date_later_of(date(2024, 7, 1), date(2025, 1, 15), date(2025, 1, 15)).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(us_todo_primary_source).
test(a_non_list_profile_is_not_problem_free, fail) :-
    colorado_cpa_input_problems(nonsense, []).

cp_test_names([the_verdict_term_carries_status_and_citations, the_indeterminate_compound_destructures, the_needs_legal_review_compound_destructures, the_applicability_atoms_are_distinct, the_action_status_atoms_are_distinct, the_coverage_citation_is_recorded, the_cure_citation_is_recorded, a_recorded_key_is_implemented, an_empty_profile_has_no_problem, a_non_list_profile_is_wrong_type, a_real_date_argument_has_no_problem, forty_five_days_after_a_date, the_later_of_two_dates]).
cp_test_fail_names([an_unrecorded_key_is_not_implemented, a_non_list_profile_is_not_problem_free]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
