% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_night_work_kernel, [night_work_input_problems/2]).
:- use_module(m__eu_labour_night_work_citations, [citation/2, implements/1]).

test(the_input_check_loads_and_accepts_an_empty_profile) :-
    night_work_input_problems([], []).
test(the_input_check_gives_exactly_one_answer) :-
    findall(Problems, night_work_input_problems([attribute(night_worker, true)], Problems), Answers),
    Answers == [[]].
test(the_input_check_names_a_wrong_profile) :-
    night_work_input_problems(profile, [wrong_type(profile)]).
test(the_input_check_names_an_unknown_key) :-
    night_work_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(the_indeterminate_status_carries_one_key) :-
    Result = indeterminate([night_worker]),
    Result = indeterminate([MissingKey]),
    MissingKey == night_worker.
test(the_legal_review_status_builds_and_destructures) :-
    Result = needs_legal_review(open_textured(night_worker, cite(eu_dir_2003_88_art_2_4)), [inputs_relied_on([on_call_on_site_counts_as_working_time - true, night_worker - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == night_worker,
    CitationKey == eu_dir_2003_88_art_2_4,
    Pairs == [on_call_on_site_counts_as_working_time - true, night_worker - unsure].
test(the_input_problems_status_builds_and_destructures) :-
    Result = input_problems([duplicate_key(worker_category), wrong_type(worker), unknown_key(colour)]),
    Result = input_problems([First, Second, Third]),
    First == duplicate_key(worker_category),
    Second == wrong_type(worker),
    Third == unknown_key(colour).
test(the_shift_row_builds_and_destructures) :-
    Row = shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 6, 0), work),
    Row = shift(WorkerIdentifier, date_time(_, _, _, StartHour, _), date_time(_, _, EndDay, _, _), Kind),
    WorkerIdentifier == worker_1,
    StartHour == 22,
    EndDay == 3,
    Kind == work.
test(the_average_result_atoms_are_distinct) :-
    dif(average_night_hours_kept, average_night_hours_exceeded),
    dif(average_night_hours_kept, night_work_limits_not_applied_to_worker),
    dif(average_night_hours_exceeded, not_a_night_worker),
    dif(not_a_night_worker, night_work_derogation_applies).
test(the_hazardous_result_atoms_are_distinct) :-
    dif(hazardous_night_work_hours_kept, hazardous_night_work_hours_exceeded),
    dif(hazardous_night_work_hours_kept, no_special_hazards_or_heavy_strain),
    dif(hazardous_night_work_hours_exceeded, night_work_derogation_applies),
    dif(no_special_hazards_or_heavy_strain, not_a_night_worker).
test(the_kept_atoms_of_the_two_limits_differ) :-
    dif(average_night_hours_kept, hazardous_night_work_hours_kept).
test(the_article_8_a_citation_is_recorded) :-
    citation(eu_dir_2003_88_art_8_a, Record),
    member(label - _, Record).
test(the_article_8_b_citation_is_recorded) :-
    citation(eu_dir_2003_88_art_8_b, _).
test(the_referral_citations_are_marked) :-
    implements(eu_dir_2003_88_art_2_1),
    implements(eu_dir_2003_88_art_2_4),
    implements(eu_dir_2003_88_art_8_final_subpara).

test(a_good_profile_is_not_reported_as_a_problem, fail) :-
    night_work_input_problems([attribute(worker_category, other_worker)], [_|_]).
test(a_shortened_citation_key_is_not_recorded, fail) :-
    citation(art_8_a, _).

cp_test_names([the_input_check_loads_and_accepts_an_empty_profile, the_input_check_gives_exactly_one_answer, the_input_check_names_a_wrong_profile, the_input_check_names_an_unknown_key, the_indeterminate_status_carries_one_key, the_legal_review_status_builds_and_destructures, the_input_problems_status_builds_and_destructures, the_shift_row_builds_and_destructures, the_average_result_atoms_are_distinct, the_hazardous_result_atoms_are_distinct, the_kept_atoms_of_the_two_limits_differ, the_article_8_a_citation_is_recorded, the_article_8_b_citation_is_recorded, the_referral_citations_are_marked]).
cp_test_fail_names([a_good_profile_is_not_reported_as_a_problem, a_shortened_citation_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
