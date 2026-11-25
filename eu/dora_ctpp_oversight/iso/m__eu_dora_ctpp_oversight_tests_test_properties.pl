% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_oversight_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(clausal_arith, [gcd/3]).
:- use_module(m__eu_dora_ctpp_oversight_dora_ctpp_oversight, [ctpp_oversight_duties_required/3, ctpp_lead_overseer_powers/3, ctpp_response_window_status/3, ctpp_periodic_penalty_payment_status/3, ctpp_periodic_penalty_payment_limits/3, ctpp_competent_authority_measure_condition/3, decide_dora_ctpp_oversight/2]).
:- use_module(m__eu_dora_ctpp_oversight_fixtures, [dora_ctpp_oversight_subject/1, dora_ctpp_oversight_profile_for/2]).

query_name(duties).
query_name(powers).
query_name(window).
query_name(penalty_status).
query_name(penalty_limits).
query_name(measure).

query_answer(duties, Profile, Result, Citations) :-
    ctpp_oversight_duties_required(Profile, Result, Citations).
query_answer(powers, Profile, Result, Citations) :-
    ctpp_lead_overseer_powers(Profile, Result, Citations).
query_answer(window, Profile, Result, Citations) :-
    ctpp_response_window_status(Profile, Result, Citations).
query_answer(penalty_status, Profile, Result, Citations) :-
    ctpp_periodic_penalty_payment_status(Profile, Result, Citations).
query_answer(penalty_limits, Profile, Result, Citations) :-
    ctpp_periodic_penalty_payment_limits(Profile, Result, Citations).
query_answer(measure, Profile, Result, Citations) :-
    ctpp_competent_authority_measure_condition(Profile, Result, Citations).

query_citation_vocabulary(duties, [cite(eu_reg_2022_2554_art_35_1_d), cite(eu_reg_2022_2554_art_35_5)]).
query_citation_vocabulary(powers, [cite(eu_reg_2022_2554_art_35_1), cite(eu_reg_2022_2554_art_35_1_a), cite(eu_reg_2022_2554_art_35_1_b), cite(eu_reg_2022_2554_art_35_1_c), cite(eu_reg_2022_2554_art_35_1_d), cite(eu_reg_2022_2554_art_35_1_d_iv)]).
query_citation_vocabulary(window, [cite(eu_reg_2022_2554_art_33_4), cite(eu_reg_2022_2554_art_35_3)]).
query_citation_vocabulary(penalty_status, [cite(eu_reg_2022_2554_art_35_6)]).
query_citation_vocabulary(penalty_limits, [cite(eu_reg_2022_2554_art_35_7), cite(eu_reg_2022_2554_art_35_8)]).
query_citation_vocabulary(measure, [cite(eu_reg_2022_2554_art_33_5)]).

result_kind(not_designated_as_critical, final).
result_kind(required(_), final).
result_kind(powers(_), final).
result_kind(window_open(_), final).
result_kind(window_closed(_), final).
result_kind(window_not_yet_open(_), final).
result_kind(no_penalty_ground_recommendation, final).
result_kind(no_penalty_ground_full_compliance, final).
result_kind(penalty_decision_required, final).
result_kind(penalty_waiting_period_running(_), final).
result_kind(penalty_limits(_, _), final).
result_kind(lead_overseer_agreement_required, final).
result_kind(no_article_33_5_condition, final).
result_kind(indeterminate(_), status).
result_kind(input_problems(_), status).

subject_answer(Subject, Query, Result, Citations) :-
    dora_ctpp_oversight_subject(Subject),
    dora_ctpp_oversight_profile_for(Subject, Profile),
    query_name(Query),
    query_answer(Query, Profile, Result, Citations).

subject_classifies(Subject) :-
    dora_ctpp_oversight_subject(Subject),
    dora_ctpp_oversight_profile_for(Subject, Profile),
    decide_dora_ctpp_oversight(Profile, _Verdict).

subject_verdict_count(Subject, Count) :-
    dora_ctpp_oversight_subject(Subject),
    dora_ctpp_oversight_profile_for(Subject, Profile),
    findall(Verdict, decide_dora_ctpp_oversight(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

subject_query_count(Subject, Query, Count) :-
    dora_ctpp_oversight_subject(Subject),
    dora_ctpp_oversight_profile_for(Subject, Profile),
    query_name(Query),
    findall(Result - Citations, query_answer(Query, Profile, Result, Citations), Answers),
    length(Answers, Count).

classified_result(Result) :-
    result_kind(Result, _Kind).

empty_list([]).

non_empty_list([_|_]).

cites_within_vocabulary(Query - Citations) :-
    query_citation_vocabulary(Query, Vocabulary),
    maplist(in_vocabulary(Vocabulary), Citations).

in_vocabulary(Vocabulary, Citation) :-
    member(Citation, Vocabulary).

written_once(Citations) :-
    sort(Citations, Sorted),
    length(Citations, Count),
    length(Sorted, Count).

one_key([Key]) :-
    atom(Key).

ends_with_cooperation(Duties) :-
    last(Duties, cooperate_in_good_faith_with_lead_overseer).

starts_with_unconditional_powers([request_information_and_documentation, conduct_general_investigations_and_inspections|_]).

lowest_terms(Numerator - Denominator) :-
    integer(Numerator),
    integer(Denominator),
    Numerator >= 0,
    Denominator >= 1,
    gcd(Numerator, Denominator, Divisor),
    Divisor =:= 1.

test(totality_every_subject_classifies) :-
    findall(Subject, dora_ctpp_oversight_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Classified, subject_classifies(Classified), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_the_facade_gives_one_verdict_per_subject) :-
    findall(Count, subject_verdict_count(_, Count), Counts),
    sort(Counts, [1]).
test(determinism_every_query_gives_one_answer_per_subject) :-
    findall(Count, subject_query_count(_, _, Count), Counts),
    sort(Counts, [1]).
test(totality_every_query_answers_every_subject) :-
    findall(Subject, dora_ctpp_oversight_subject(Subject), Subjects),
    length(Subjects, SubjectCount),
    findall(Query, query_name(Query), Queries),
    length(Queries, QueryCount),
    Expected is SubjectCount * QueryCount,
    findall(Answered - Asked, subject_query_count(Answered, Asked, 1), Pairs),
    length(Pairs, Expected).
test(every_answer_is_final_or_a_status) :-
    findall(Result, subject_answer(_, _, Result, _), Results),
    Results = [_|_],
    maplist(classified_result, Results).
test(every_status_answer_has_no_citations) :-
    findall(Citations, (subject_answer(_, _, Result, Citations), result_kind(Result, status)), CitationLists),
    CitationLists = [_|_],
    maplist(empty_list, CitationLists).
test(every_final_answer_has_citations) :-
    findall(Citations, (subject_answer(_, _, Result, Citations), result_kind(Result, final)), CitationLists),
    CitationLists = [_|_],
    maplist(non_empty_list, CitationLists).
test(every_citation_is_in_its_query_vocabulary) :-
    findall(Query - Citations, subject_answer(_, Query, _, Citations), Pairs),
    Pairs = [_|_],
    maplist(cites_within_vocabulary, Pairs).
test(every_citation_is_written_once) :-
    findall(Citations, subject_answer(_, _, _, Citations), CitationLists),
    maplist(written_once, CitationLists).
test(every_missing_keys_list_holds_one_key) :-
    findall(Keys, subject_answer(_, _, indeterminate(Keys), _), KeyLists),
    KeyLists = [_|_],
    maplist(one_key, KeyLists).
test(every_duties_list_ends_with_good_faith_cooperation) :-
    findall(Duties, subject_answer(_, duties, required(Duties), _), DutyLists),
    DutyLists = [_|_],
    maplist(ends_with_cooperation, DutyLists).
test(every_powers_list_starts_with_the_unconditional_powers) :-
    findall(Powers, subject_answer(_, powers, powers(Powers), _), PowerLists),
    PowerLists = [_|_],
    maplist(starts_with_unconditional_powers, PowerLists).
test(every_penalty_ceiling_is_in_lowest_terms) :-
    findall(Numerator - Denominator, subject_answer(_, penalty_limits, penalty_limits(amount(Numerator, Denominator), _), _), Amounts),
    Amounts = [_|_],
    maplist(lowest_terms, Amounts).

cp_test_names([totality_every_subject_classifies, determinism_the_facade_gives_one_verdict_per_subject, determinism_every_query_gives_one_answer_per_subject, totality_every_query_answers_every_subject, every_answer_is_final_or_a_status, every_status_answer_has_no_citations, every_final_answer_has_citations, every_citation_is_in_its_query_vocabulary, every_citation_is_written_once, every_missing_keys_list_holds_one_key, every_duties_list_ends_with_good_faith_cooperation, every_powers_list_starts_with_the_unconditional_powers, every_penalty_ceiling_is_in_lowest_terms]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
