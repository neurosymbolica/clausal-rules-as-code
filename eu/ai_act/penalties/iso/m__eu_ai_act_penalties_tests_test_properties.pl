% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_penalties_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [not_member/2]).
:- use_module(m__eu_ai_act_penalties_penalties, [decide_penalties/2, penalties_status_values/1]).
:- use_module(m__eu_ai_act_penalties_fixtures, [penalties_subject/1, penalties_profile_for/2]).

citation_vocabulary([eu_reg_2024_1689_art_99_3, eu_reg_2024_1689_art_99_4, eu_reg_2024_1689_art_99_4_a, eu_reg_2024_1689_art_99_4_b, eu_reg_2024_1689_art_99_4_c, eu_reg_2024_1689_art_99_4_d, eu_reg_2024_1689_art_99_4_da, eu_reg_2024_1689_art_99_4_e, eu_reg_2024_1689_art_99_4_f, eu_reg_2024_1689_art_99_4_g, eu_reg_2024_1689_art_99_5, eu_reg_2024_1689_art_99_6, eu_reg_2024_1689_art_99_6a, eu_reg_2024_1689_art_99_8, eu_reg_2024_1689_art_100_1, eu_reg_2024_1689_art_100_2, eu_reg_2024_1689_art_100_3, eu_reg_2024_1689_art_113_a, eu_reg_2024_1689_art_101_1, eu_reg_2024_1689_art_101_1_a, eu_reg_2024_1689_art_101_1_b, eu_reg_2024_1689_art_101_1_c, eu_reg_2024_1689_art_101_1_d, eu_reg_2024_1689_art_113, eu_reg_2024_1689_art_113_b]).

subject_verdict(Subject, Verdict) :-
    penalties_profile_for(Subject, Request),
    decide_penalties(Request, Verdict).

subject_classifies(Subject) :-
    penalties_subject(Subject),
    subject_verdict(Subject, _).

subject_answer_count(Subject, Count) :-
    penalties_subject(Subject),
    findall(Verdict, subject_verdict(Subject, Verdict), Verdicts),
    length(Verdicts, Count).

test(totality_every_subject_classifies) :-
    findall(Subject, penalties_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(the_subject_ids_are_unique) :-
    findall(Subject, penalties_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    length(Subjects, SubjectCount),
    length(SubjectSet, SubjectCount).
test(a_subject_has_exactly_one_verdict) :-
    subject_answer_count(model_fine_intent_unsure, 1).
test(a_verdict_status_is_in_the_vocabulary) :-
    subject_verdict(public_authority_operator_breach, penalties_verdict(Status, _, _)),
    penalties_status_values(StatusValues),
    member(Status, StatusValues).
test(a_citation_is_in_the_vocabulary) :-
    subject_verdict(small_mid_cap_deployer, penalties_verdict(_, _, Citations)),
    citation_vocabulary(Keys),
    member(cite(eu_reg_2024_1689_art_99_6a), Citations),
    member(eu_reg_2024_1689_art_99_6a, Keys).
test(a_citation_list_is_a_set) :-
    subject_verdict(small_or_medium_enterprise_notified_body, penalties_verdict(_, _, Citations)),
    sort(Citations, CitationSet),
    length(Citations, 3),
    length(CitationSet, 3).
test(a_not_final_answer_has_no_citation) :-
    subject_verdict(model_fine_intent_unsure, penalties_verdict(legal_review_needed, _, [])).
test(a_determined_maximum_is_cited) :-
    subject_verdict(distributor_undertaking, penalties_verdict(union_maximum_determined, fine_maximum(_, _), [_|_])).
test(an_amount_is_an_exact_integer) :-
    subject_verdict(prohibition_turnover_above_boundary, penalties_verdict(_, fine_maximum(AmountEurCents, turnover_percentage), _)),
    integer(AmountEurCents),
    AmountEurCents #= 3500000007.

test(determinism_no_subject_has_another_count_of_verdicts, fail) :-
    subject_answer_count(_, Count),
    dif(Count, 1).
test(no_verdict_status_is_outside_the_vocabulary, fail) :-
    status_outside_vocabulary(_).
test(no_citation_is_outside_the_vocabulary, fail) :-
    citation_outside_vocabulary(_, _).
test(no_citation_list_repeats_a_citation, fail) :-
    duplicated_citation(_).
test(no_not_final_answer_has_a_citation, fail) :-
    not_final_with_citations(_).
test(no_determined_maximum_is_uncited, fail) :-
    subject_verdict(_, penalties_verdict(_, fine_maximum(_, _), [])).
test(no_amount_is_negative_inexact_or_of_another_basis, fail) :-
    bad_amount(_).

status_outside_vocabulary(Subject) :-
    subject_verdict(Subject, penalties_verdict(Status, _, _)),
    penalties_status_values(StatusValues),
    not_member(Status, StatusValues).

citation_not_in_vocabulary(Citation) :-
    functor(Citation, Name, Arity),
    dif(Name - Arity, cite - 1).
citation_not_in_vocabulary(cite(Key)) :-
    citation_vocabulary(Keys),
    not_member(Key, Keys).

citation_outside_vocabulary(Subject, Citation) :-
    subject_verdict(Subject, penalties_verdict(_, _, Citations)),
    member(Citation, Citations),
    citation_not_in_vocabulary(Citation).

duplicated_citation(Subject) :-
    subject_verdict(Subject, penalties_verdict(_, _, Citations)),
    sort(Citations, CitationSet),
    length(Citations, CitationCount),
    length(CitationSet, SetCount),
    dif(CitationCount, SetCount).

not_final_with_citations(Subject) :-
    subject_verdict(Subject, penalties_verdict(Status, _, [_|_])),
    member(Status, [information_missing, legal_review_needed, input_rejected]).

bad_amount(Subject) :-
    subject_verdict(Subject, penalties_verdict(_, fine_maximum(AmountEurCents, _), _)),
    integer(AmountEurCents),
    AmountEurCents #< 0.
bad_amount(Subject) :-
    subject_verdict(Subject, penalties_verdict(_, fine_maximum(AmountEurCents, _), _)),
    float(AmountEurCents).
bad_amount(Subject) :-
    subject_verdict(Subject, penalties_verdict(_, fine_maximum(_, Basis), _)),
    not_member(Basis, [fixed_amount, turnover_percentage]).

cp_test_names([totality_every_subject_classifies, the_subject_ids_are_unique, a_subject_has_exactly_one_verdict, a_verdict_status_is_in_the_vocabulary, a_citation_is_in_the_vocabulary, a_citation_list_is_a_set, a_not_final_answer_has_no_citation, a_determined_maximum_is_cited, an_amount_is_an_exact_integer]).
cp_test_fail_names([determinism_no_subject_has_another_count_of_verdicts, no_verdict_status_is_outside_the_vocabulary, no_citation_is_outside_the_vocabulary, no_citation_list_repeats_a_citation, no_not_final_answer_has_a_citation, no_determined_maximum_is_uncited, no_amount_is_negative_inexact_or_of_another_basis]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
