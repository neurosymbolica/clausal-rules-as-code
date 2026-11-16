% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_state_aid_sme_definition_sme_definition, [decide_sme_definition/2, sme_definition_checklist/2]).
:- use_module(m__eu_state_aid_sme_definition_fixtures, [sme_definition_subject/1, sme_definition_profile_for/2]).

subject_set(SubjectSet) :-
    findall(Subject, sme_definition_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    sme_definition_subject(Subject),
    sme_definition_profile_for(Subject, Request),
    decide_sme_definition(Request, _Verdict).

subject_deterministic(Subject) :-
    sme_definition_subject(Subject),
    sme_definition_profile_for(Subject, Request),
    findall(Verdict, decide_sme_definition(Request, Verdict), Verdicts),
    length(Verdicts, 1).

test(totality_every_subject_classifies) :-
    subject_set(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    subject_set(SubjectSet),
    findall(Subject, subject_deterministic(Subject), DeterministicSubjects),
    msort(DeterministicSubjects, SubjectSet).
test(text_changes_only_the_citations) :-
    findall(Subject, final_subject(Subject), Finals),
    sort(Finals, FinalSet),
    findall(Subject, final_subject_same_under_twin(Subject), Same),
    sort(Same, FinalSet).
test(every_citation_is_a_cite_of_the_texts_instrument) :-
    findall(Pair, subject_citation(Pair), Pairs),
    msort(Pairs, AllSorted),
    findall(Pair, subject_citation_of_its_text(Pair), Matching),
    msort(Matching, AllSorted).
test(there_are_citations_to_check) :-
    findall(Pair, subject_citation(Pair), Pairs),
    length(Pairs, Count),
    Count #>= 1.
test(a_non_final_answer_carries_no_citation) :-
    findall(Subject, non_final_subject(Subject), NonFinals),
    sort(NonFinals, NonFinalSet),
    length(NonFinalSet, Count),
    Count #>= 3,
    findall(Subject, non_final_subject_without_citations(Subject), Clean),
    sort(Clean, NonFinalSet).
test(the_checklist_has_one_item_per_citation) :-
    subject_set(SubjectSet),
    findall(Subject, checklist_matches(Subject), Matching),
    sort(Matching, SubjectSet).
test(the_period_class_never_falls_as_staff_rises) :-
    maplist(staff_rank, [0, 999, 1000, 4999, 5000, 24999, 25000, 100000], Ranks),
    non_decreasing(Ranks),
    Ranks == [1, 1, 2, 2, 3, 3, 4, 4].

text_twin(recommendation_2003_361_annex, gber_annex_i).
text_twin(gber_annex_i, recommendation_2003_361_annex).

final_subject(Subject) :-
    sme_definition_subject(Subject),
    sme_definition_profile_for(Subject, Request),
    decide_sme_definition(Request, sme_definition_verdict(Result, _)),
    atom(Result).

final_subject_same_under_twin(Subject) :-
    sme_definition_subject(Subject),
    sme_definition_profile_for(Subject, query(Query, Text, Profile)),
    decide_sme_definition(query(Query, Text, Profile), sme_definition_verdict(Result, _)),
    atom(Result),
    text_twin(Text, Twin),
    decide_sme_definition(query(Query, Twin, Profile), sme_definition_verdict(TwinResult, _)),
    TwinResult == Result.

text_prefix(recommendation_2003_361_annex, eu_rec_2003_361_annex_).
text_prefix(gber_annex_i, eu_reg_651_2014_annex_i_).

subject_citation(Subject - Citation) :-
    sme_definition_subject(Subject),
    sme_definition_profile_for(Subject, Request),
    decide_sme_definition(Request, sme_definition_verdict(_, Citations)),
    member(Citation, Citations).

subject_citation_of_its_text(Subject - Citation) :-
    sme_definition_subject(Subject),
    sme_definition_profile_for(Subject, query(Query, Text, Profile)),
    decide_sme_definition(query(Query, Text, Profile), sme_definition_verdict(_, Citations)),
    member(Citation, Citations),
    Citation = cite(Key),
    atom(Key),
    text_prefix(Text, Prefix),
    sub_atom(Key, 0, _, _, Prefix).

non_final_subject(Subject) :-
    sme_definition_subject(Subject),
    sme_definition_profile_for(Subject, Request),
    decide_sme_definition(Request, sme_definition_verdict(Result, _)),
    compound(Result).

non_final_subject_without_citations(Subject) :-
    sme_definition_subject(Subject),
    sme_definition_profile_for(Subject, Request),
    decide_sme_definition(Request, sme_definition_verdict(Result, Citations)),
    compound(Result),
    Citations == [].

checklist_matches(Subject) :-
    sme_definition_subject(Subject),
    sme_definition_profile_for(Subject, Request),
    decide_sme_definition(Request, sme_definition_verdict(Result, Citations)),
    sme_definition_checklist(Request, [item(determination, Result, Citations)|Items]),
    same_length(Items, Citations).

class_order(micro_enterprise, 1).
class_order(small_enterprise, 2).
class_order(medium_sized_enterprise, 3).
class_order(large_enterprise, 4).

staff_rank(Staff, Rank) :-
    decide_sme_definition(query(period_size_class, recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, Staff), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, []), attribute(linked_enterprises, [])]), sme_definition_verdict(Class, _)),
    class_order(Class, Rank).

non_decreasing([]).
non_decreasing([_]).
non_decreasing([First, Second|Rest]) :-
    First #=< Second,
    non_decreasing([Second|Rest]).

test(a_falling_rank_list_is_caught, fail) :-
    non_decreasing([1, 3, 2]).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, text_changes_only_the_citations, every_citation_is_a_cite_of_the_texts_instrument, there_are_citations_to_check, a_non_final_answer_carries_no_citation, the_checklist_has_one_item_per_citation, the_period_class_never_falls_as_staff_rises]).
cp_test_fail_names([a_falling_rank_list_is_caught]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
