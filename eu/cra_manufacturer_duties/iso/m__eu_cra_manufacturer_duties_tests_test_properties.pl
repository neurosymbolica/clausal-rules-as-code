% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_manufacturer_duties_kernel, [date_not_earlier/2]).
:- use_module(m__eu_cra_manufacturer_duties_cra_manufacturer_duties, [decide_cra_manufacturer_duties/2, support_period_minimum/4, retention_end_date/5, cra_manufacturer_duties_checklist/2]).
:- use_module(m__eu_cra_manufacturer_duties_fixtures, [cra_manufacturer_duties_subject/1, cra_manufacturer_duties_profile_for/2, cra_manufacturer_duties_assess/2]).

subject_classifies(Subject) :-
    cra_manufacturer_duties_subject(Subject),
    cra_manufacturer_duties_profile_for(Subject, Question),
    decide_cra_manufacturer_duties(Question, _Verdict).

subject_answers_once(Subject) :-
    findall(Result, cra_manufacturer_duties_assess(Subject, Result), Results),
    Results = [_].

subject_checklist_once(Subject) :-
    cra_manufacturer_duties_profile_for(Subject, Question),
    findall(Items, cra_manufacturer_duties_checklist(Question, Items), Checklists),
    Checklists = [_].

subject_citations_fit(Subject) :-
    cra_manufacturer_duties_assess(Subject, cra_manufacturer_duties_verdict(Verdict, Citations)),
    verdict_kind(Verdict, Kind),
    citations_fit(Kind, Citations).

verdict_kind(subject_to_requirements, final).
verdict_kind(article_14_only, final).
verdict_kind(not_yet_applicable, final).
verdict_kind(not_applicable_outside_support_period, final).
verdict_kind(minimum_support_period(_), final).
verdict_kind(keep_until(_), final).
verdict_kind(indeterminate([_]), status).
verdict_kind(needs_legal_review(_, _), status).
verdict_kind(input_problems([_|_]), status).

citations_fit(status, []).
citations_fit(final, [Citation|Citations]) :-
    maplist(canonical_citation, [Citation|Citations]).

canonical_citation(cite(Key)) :-
    member(Key, [eu_reg_2024_2847_art_71_2, eu_reg_2024_2847_art_69_2, eu_reg_2024_2847_art_69_3, eu_reg_2024_2847_art_13_8, eu_reg_2024_2847_art_13_9, eu_reg_2024_2847_art_13_13, eu_reg_2024_2847_art_13_18]).

subject_checklist_cited(Subject) :-
    cra_manufacturer_duties_profile_for(Subject, Question),
    cra_manufacturer_duties_checklist(Question, Items),
    maplist(item_cited, Items).

item_cited(item(_, _, cite(Key))) :-
    atom(Key).

floor_bounded(ExpectedMonths) :-
    support_period_minimum([attribute(expected_use_time_in_months, ExpectedMonths)], date(2028, 3, 1), minimum_support_period(FloorMonths), _),
    FloorMonths =< 60,
    FloorMonths =< ExpectedMonths.

keep_until_not_earlier(EndYear) :-
    retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(EndYear, 6, 30))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity, keep_until(KeepDate), _),
    date_not_earlier(KeepDate, date(EndYear, 6, 30)),
    date_not_earlier(KeepDate, date(2038, 2, 1)).

test(totality_every_subject_classifies) :-
    findall(Subject, cra_manufacturer_duties_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_answers_exactly_once) :-
    findall(Subject, cra_manufacturer_duties_subject(Subject), Subjects),
    maplist(subject_answers_once, Subjects).
test(determinism_every_subject_has_one_checklist) :-
    findall(Subject, cra_manufacturer_duties_subject(Subject), Subjects),
    maplist(subject_checklist_once, Subjects).
test(citations_fit_the_verdict_kind) :-
    findall(Subject, cra_manufacturer_duties_subject(Subject), Subjects),
    maplist(subject_citations_fit, Subjects).
test(every_checklist_item_is_cited) :-
    findall(Subject, cra_manufacturer_duties_subject(Subject), Subjects),
    maplist(subject_checklist_cited, Subjects).
test(the_floor_never_exceeds_sixty_nor_the_use_time) :-
    numlist(0, 120, ExpectedMonthsList),
    maplist(floor_bounded, ExpectedMonthsList).
test(keep_until_is_never_earlier_than_either_end) :-
    numlist(2028, 2045, EndYears),
    maplist(keep_until_not_earlier, EndYears).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_answers_exactly_once, determinism_every_subject_has_one_checklist, citations_fit_the_verdict_kind, every_checklist_item_is_cited, the_floor_never_exceeds_sixty_nor_the_use_time, keep_until_is_never_earlier_than_either_end]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
