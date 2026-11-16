% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_small_items_kernel, [small_items_input_problems/2, small_items_assessment_date_t/2, small_items_date_before_t/3, small_items_step_zero_problems/3]).
:- use_module(m__eu_ai_act_small_items_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_result_and_citations) :-
    Verdict = small_items_verdict(bias_processing_permitted, [cite(eu_reg_2024_1689_art_4a_1)]),
    Verdict = small_items_verdict(Result, Citations),
    Result == bias_processing_permitted,
    Citations == [cite(eu_reg_2024_1689_art_4a_1)].
test(the_indeterminate_status_holds_one_bare_key) :-
    Status = indeterminate([bias_processing_capacity]),
    Status = indeterminate([Key]),
    Key == bias_processing_capacity.
test(the_referral_status_builds_and_destructures) :-
    Status = needs_legal_review(open_textured(consent_freely_given, cite(eu_reg_2024_1689_art_61_1)), [inputs_relied_on([consent_freely_given - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == consent_freely_given,
    Citation == eu_reg_2024_1689_art_61_1,
    Pairs == [consent_freely_given - unsure].
test(the_input_problems_status_builds_and_destructures) :-
    Status = input_problems([unknown_key(unheard_of), wrong_type(assessment_date)]),
    Status = input_problems(Problems),
    Problems == [unknown_key(unheard_of), wrong_type(assessment_date)].
test(the_bias_atoms_are_distinct) :-
    dif(bias_processing_permitted, bias_processing_not_permitted),
    dif(bias_processing_permitted, not_applicable_on_date),
    dif(bias_processing_not_permitted, not_applicable_on_date).
test(the_sandbox_atoms_are_distinct) :-
    dif(sandbox_processing_permitted, sandbox_processing_not_permitted).
test(the_testing_atoms_are_distinct) :-
    dif(testing_not_provided_for_by_the_member_state, subject_to_the_member_state_framework),
    dif(real_world_testing_permitted, real_world_testing_not_permitted),
    dif(subject_to_the_member_state_framework, real_world_testing_permitted).
test(the_consent_sme_and_explanation_atoms_are_distinct) :-
    dif(consent_meets_article_61, consent_does_not_meet_article_61),
    dif(may_comply_in_a_simplified_manner, no_simplified_compliance),
    dif(right_to_explanation_under_article_86, no_right_to_explanation_under_article_86).
test(the_bias_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_4a_1, _Record).
test(the_date_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_113, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2024_1689_art_86_1).
test(an_empty_profile_has_no_problem) :-
    small_items_input_problems([], Problems),
    Problems == [].
test(a_non_list_profile_is_wrong_type) :-
    small_items_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(a_real_assessment_date_is_valid) :-
    small_items_assessment_date_t(date(2026, 8, 2), true).
test(the_application_day_is_not_before_itself) :-
    small_items_date_before_t(date(2026, 8, 2), date(2026, 8, 2), false).
test(the_day_before_application_is_before) :-
    small_items_date_before_t(date(2026, 8, 1), date(2026, 8, 2), true).
test(step_zero_of_a_good_profile_and_date_is_empty) :-
    small_items_step_zero_problems([attribute(consent_freely_given, unsure)], date(2026, 8, 2), Problems),
    Problems == [].

test(an_unrecorded_key_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_verdict_term_carries_result_and_citations, the_indeterminate_status_holds_one_bare_key, the_referral_status_builds_and_destructures, the_input_problems_status_builds_and_destructures, the_bias_atoms_are_distinct, the_sandbox_atoms_are_distinct, the_testing_atoms_are_distinct, the_consent_sme_and_explanation_atoms_are_distinct, the_bias_citation_is_recorded, the_date_citation_is_recorded, a_recorded_key_is_implemented, an_empty_profile_has_no_problem, a_non_list_profile_is_wrong_type, a_real_assessment_date_is_valid, the_application_day_is_not_before_itself, the_day_before_application_is_before, step_zero_of_a_good_profile_and_date_is_empty]).
cp_test_fail_names([an_unrecorded_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
