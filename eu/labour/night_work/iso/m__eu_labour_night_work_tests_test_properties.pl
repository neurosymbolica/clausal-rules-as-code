% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_labour_night_work_night_work, [decide_night_work/2, night_work_status_values/1, night_work_average_status/7, hazardous_night_work_status/7]).
:- use_module(m__eu_labour_night_work_fixtures, [night_work_subject/1, night_work_profile_for/2, night_work_assess/2]).

citation_vocabulary([eu_dir_2003_88_art_2_1, eu_dir_2003_88_art_2_3, eu_dir_2003_88_art_2_4, eu_dir_2003_88_art_2_7, eu_dir_2003_88_art_8, eu_dir_2003_88_art_8_a, eu_dir_2003_88_art_8_b, eu_dir_2003_88_art_8_final_subpara, eu_dir_2003_88_art_16_c, eu_dir_2003_88_art_16_final_subpara, eu_dir_2003_88_art_17_1, eu_dir_2003_88_art_17_3, eu_dir_2003_88_art_18_first_subpara, eu_dir_2003_88_art_18_second_subpara, eu_dir_2003_88_art_20_1, eu_dir_2003_88_art_21_1]).

subject_classifies(Subject) :-
    night_work_subject(Subject),
    night_work_assess(Subject, _).

answer_count(Subject, Count) :-
    night_work_profile_for(Subject, Case),
    findall(Verdict, decide_night_work(Case, Verdict), Verdicts),
    length(Verdicts, Count).

profile_with(Category, NightTimeStart, NightTimeEnd, [attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(night_time_start, NightTimeStart), attribute(night_time_end, NightTimeEnd), attribute(night_work_reference_period_days, 7), attribute(worker_category, Category), attribute(night_worker, true), attribute(special_hazards_or_heavy_strain, true), attribute(derogation_from_article_8, no_derogation)]).

six_nights([shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 6, 0), work), shift(worker_1, date_time(2026, 3, 3, 22, 0), date_time(2026, 3, 4, 6, 0), work), shift(worker_1, date_time(2026, 3, 4, 22, 0), date_time(2026, 3, 5, 6, 0), work), shift(worker_1, date_time(2026, 3, 5, 22, 0), date_time(2026, 3, 6, 6, 0), work), shift(worker_1, date_time(2026, 3, 6, 22, 0), date_time(2026, 3, 7, 6, 0), work), shift(worker_1, date_time(2026, 3, 7, 22, 0), date_time(2026, 3, 8, 6, 0), work)]).

test(totality_every_subject_classifies) :-
    findall(Subject, night_work_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_some_subject_yields_exactly_one_verdict) :-
    answer_count(average_at_the_limit_kept, 1).
test(every_subject_has_exactly_one_case) :-
    findall(Subject - Case, (night_work_subject(Subject), night_work_profile_for(Subject, Case)), Pairs),
    findall(Subject, night_work_subject(Subject), Subjects),
    same_length(Pairs, Subjects).
test(a_final_verdict_cites_the_vocabulary) :-
    night_work_assess(average_at_the_limit_kept, night_work_verdict(Status, [cite(Key)|_])),
    atom(Status),
    citation_vocabulary(Vocabulary),
    memberd_t(Key, Vocabulary, true).
test(a_not_final_verdict_has_no_citation) :-
    night_work_assess(average_absent_reference_period_asked, night_work_verdict(Status, [])),
    compound(Status).
test(the_kept_average_comes_first_for_every_category) :-
    six_nights(Shifts),
    findall(Result, (member(Category, [other_worker, mobile_worker, seagoing_fishing_vessel_worker]), profile_with(Category, 1320, 300, Profile), night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), Result, _)), Results),
    Results == [average_night_hours_kept, average_night_hours_kept, average_night_hours_kept].
test(the_average_does_not_read_the_night_time) :-
    six_nights(Shifts),
    profile_with(other_worker, 0, 420, Profile),
    night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), average_night_hours_kept, _).
test(the_hazardous_limit_is_kept_for_eight_hour_nights_under_another_night_time) :-
    six_nights(Shifts),
    profile_with(other_worker, 0, 420, Profile),
    hazardous_night_work_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), hazardous_night_work_hours_kept, _).

test(determinism_no_subject_yields_two_verdicts, fail) :-
    night_work_subject(Subject),
    answer_count(Subject, Count),
    Count > 1.
test(totality_no_subject_yields_no_verdict, fail) :-
    night_work_subject(Subject),
    answer_count(Subject, 0).
test(no_final_verdict_cites_outside_the_vocabulary, fail) :-
    night_work_subject(Subject),
    night_work_assess(Subject, night_work_verdict(Status, Citations)),
    atom(Status),
    member(cite(Key), Citations),
    citation_vocabulary(Vocabulary),
    memberd_t(Key, Vocabulary, false).
test(no_final_verdict_has_an_empty_citation_list, fail) :-
    night_work_subject(Subject),
    night_work_assess(Subject, night_work_verdict(Status, [])),
    atom(Status).
test(no_not_final_verdict_has_a_citation, fail) :-
    night_work_subject(Subject),
    night_work_assess(Subject, night_work_verdict(Status, [_|_])),
    compound(Status).
test(no_citation_list_repeats_a_term, fail) :-
    night_work_subject(Subject),
    night_work_assess(Subject, night_work_verdict(_, Citations)),
    clausal_msort(Citations, Sorted),
    sort(Citations, Set),
    length(Sorted, SortedLength),
    length(Set, SetLength),
    SortedLength > SetLength.
test(no_final_status_is_outside_the_status_table, fail) :-
    night_work_subject(Subject),
    night_work_assess(Subject, night_work_verdict(Status, _)),
    atom(Status),
    night_work_status_values(StatusValues),
    memberd_t(Status, StatusValues, false).

cp_test_names([totality_every_subject_classifies, determinism_some_subject_yields_exactly_one_verdict, every_subject_has_exactly_one_case, a_final_verdict_cites_the_vocabulary, a_not_final_verdict_has_no_citation, the_kept_average_comes_first_for_every_category, the_average_does_not_read_the_night_time, the_hazardous_limit_is_kept_for_eight_hour_nights_under_another_night_time]).
cp_test_fail_names([determinism_no_subject_yields_two_verdicts, totality_no_subject_yields_no_verdict, no_final_verdict_cites_outside_the_vocabulary, no_final_verdict_has_an_empty_citation_list, no_not_final_verdict_has_a_citation, no_citation_list_repeats_a_term, no_final_status_is_outside_the_status_table]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
