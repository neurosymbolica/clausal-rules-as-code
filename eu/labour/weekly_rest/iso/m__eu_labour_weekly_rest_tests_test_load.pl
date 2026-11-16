% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_weekly_rest_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_weekly_rest_kernel, [weekly_rest_input_problems/2]).
:- use_module(m__eu_labour_weekly_rest_citations, [citation/2, implements/1]).

test(the_four_result_atoms_are_distinct) :-
    dif(weekly_rest_given, weekly_rest_not_given),
    dif(weekly_rest_given, weekly_rest_not_applied_to_worker),
    dif(weekly_rest_given, weekly_rest_derogation_applies),
    dif(weekly_rest_not_given, weekly_rest_not_applied_to_worker),
    dif(weekly_rest_not_given, weekly_rest_derogation_applies),
    dif(weekly_rest_not_applied_to_worker, weekly_rest_derogation_applies).
test(no_period_without_weekly_rest_is_not_a_result_atom) :-
    dif(no_period_without_weekly_rest, weekly_rest_given),
    dif(no_period_without_weekly_rest, weekly_rest_not_given).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = weekly_rest_verdict(weekly_rest_given, [cite(eu_dir_2003_88_art_5_first_subpara)]),
    Verdict = weekly_rest_verdict(Status, Citations),
    Status == weekly_rest_given,
    Citations == [cite(eu_dir_2003_88_art_5_first_subpara)].
test(an_indeterminate_status_names_one_key) :-
    Status = indeterminate([worker_category]),
    Status = indeterminate([Key]),
    Key == worker_category.
test(a_referral_builds_and_destructures) :-
    Status = needs_legal_review(open_textured(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - unsure])]),
    Status = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == on_call_on_site_counts_as_working_time,
    CitationKey == eu_dir_2003_88_art_2_1,
    Pairs == [on_call_on_site_counts_as_working_time - unsure].
test(an_input_problems_status_carries_its_list) :-
    Status = input_problems([wrong_type(period_end)]),
    Status = input_problems(Problems),
    Problems == [wrong_type(period_end)].
test(the_weekly_rest_citation_is_recorded) :-
    citation(eu_dir_2003_88_art_5_first_subpara, _Record).
test(the_working_time_citation_is_recorded) :-
    citation(eu_dir_2003_88_art_2_1, _Record).
test(the_record_has_label_reference_and_verbatim) :-
    citation(eu_dir_2003_88_art_20_1, Record),
    Record = [label - _, ref - _, verbatim - Verbatim],
    Verbatim == 'Articles 3, 4, 5 and 8 shall not apply to mobile workers.'.
test(implements_succeeds_for_a_recorded_key) :-
    implements(eu_dir_2003_88_art_16_a).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, weekly_rest_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_full_good_profile_has_no_problem) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, unsure), attribute(on_call_standby_counts_as_working_time, false), attribute(weekly_rest_minimum, rest_of_24_plus_11_hours), attribute(weekly_rest_reference_period, seven_day_period), attribute(worker_category, other_worker), attribute(derogation_from_article_5, no_derogation)],
    findall(Problems, weekly_rest_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(an_unbound_profile_is_the_wrong_type) :-
    findall(Problems, weekly_rest_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_atom_is_not_an_attribute_list) :-
    findall(Problems, weekly_rest_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_element_is_not_an_attribute_list) :-
    findall(Problems, weekly_rest_input_problems([attribute(worker_category, other_worker), worker_category], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_value_outside_its_type_then_an_unknown_key) :-
    findall(Problems, weekly_rest_input_problems([attribute(extra_key, 1), attribute(weekly_rest_minimum, forty_hours)], Problems), Answers),
    Answers == [[wrong_type(weekly_rest_minimum), unknown_key(extra_key)]].
test(a_repeated_key_is_a_duplicate_only) :-
    findall(Problems, weekly_rest_input_problems([attribute(worker_category, other_worker), attribute(worker_category, sailor)], Problems), Answers),
    Answers == [[duplicate_key(worker_category)]].
test(an_unbound_value_is_the_wrong_type) :-
    findall(Problems, weekly_rest_input_problems([attribute(derogation_from_article_5, _)], Problems), Answers),
    Answers == [[wrong_type(derogation_from_article_5)]].
test(a_good_profile_is_reported_as_clean) :-
    weekly_rest_input_problems([attribute(worker_category, mobile_worker)], []).

test(the_verdict_term_does_not_take_another_status, fail) :-
    Verdict = weekly_rest_verdict(weekly_rest_given, []),
    Verdict = weekly_rest_verdict(weekly_rest_not_given, _).
test(implements_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).
test(a_good_profile_is_not_reported_as_wrong, fail) :-
    weekly_rest_input_problems([attribute(worker_category, mobile_worker)], [_|_]).

cp_test_names([the_four_result_atoms_are_distinct, no_period_without_weekly_rest_is_not_a_result_atom, the_verdict_term_carries_status_and_citations, an_indeterminate_status_names_one_key, a_referral_builds_and_destructures, an_input_problems_status_carries_its_list, the_weekly_rest_citation_is_recorded, the_working_time_citation_is_recorded, the_record_has_label_reference_and_verbatim, implements_succeeds_for_a_recorded_key, an_empty_profile_has_no_problem, a_full_good_profile_has_no_problem, an_unbound_profile_is_the_wrong_type, an_atom_is_not_an_attribute_list, a_list_with_a_foreign_element_is_not_an_attribute_list, a_value_outside_its_type_then_an_unknown_key, a_repeated_key_is_a_duplicate_only, an_unbound_value_is_the_wrong_type, a_good_profile_is_reported_as_clean]).
cp_test_fail_names([the_verdict_term_does_not_take_another_status, implements_fails_for_an_unrecorded_key, a_good_profile_is_not_reported_as_wrong]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
