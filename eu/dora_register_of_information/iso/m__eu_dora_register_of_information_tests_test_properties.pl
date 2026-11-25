% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_register_of_information_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_register_of_information_dora_register_of_information, [register_of_information_duties_required/3, register_of_information_duties_complete/3, register_of_information_duties_outstanding/3, decide_dora_register_of_information/2, dora_register_of_information_checklist/2]).
:- use_module(m__eu_dora_register_of_information_fixtures, [dora_register_of_information_subject/1, dora_register_of_information_profile_for/2]).
:- use_module(m__eu_dora_register_of_information_citations, [citation/2, fixed_citations/1]).
:- use_module(m__eu_dora_register_of_information_kernel, [contract_keys/1]).
:- use_module(formalize_lib, [profile_lacks/2]).

subject_profile(Subject, Profile) :-
    dora_register_of_information_subject(Subject),
    dora_register_of_information_profile_for(Subject, Profile).

query_answer(Profile, Result, Citations) :-
    register_of_information_duties_required(Profile, Result, Citations).
query_answer(Profile, Result, Citations) :-
    register_of_information_duties_complete(Profile, Result, Citations).
query_answer(Profile, Result, Citations) :-
    register_of_information_duties_outstanding(Profile, Result, Citations).

status_compound(indeterminate(_)).
status_compound(needs_legal_review(_, _)).
status_compound(input_problems(_)).

recorded_citation(Key) :-
    citation(Key, _).

with_value([], Key, Value, [attribute(Key, Value)]).
with_value([attribute(ElementKey, _)|Elements], Key, Value, [attribute(Key, Value)|Elements]) :-
    ElementKey == Key.
with_value([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Rest]) :-
    ElementKey \== Key,
    with_value(Elements, Key, Value, Rest).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_register_of_information_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, (subject_profile(Subject, Profile), decide_dora_register_of_information(Profile, _)), Classified),
    sort(Classified, SubjectSet).
test(determinism_required) :-
    findall(Count, (subject_profile(_, Profile), findall(R - C, register_of_information_duties_required(Profile, R, C), Answers), length(Answers, Count)), Counts),
    sort(Counts, [1]).
test(determinism_complete) :-
    findall(Count, (subject_profile(_, Profile), findall(R - C, register_of_information_duties_complete(Profile, R, C), Answers), length(Answers, Count)), Counts),
    sort(Counts, [1]).
test(determinism_outstanding) :-
    findall(Count, (subject_profile(_, Profile), findall(R - C, register_of_information_duties_outstanding(Profile, R, C), Answers), length(Answers, Count)), Counts),
    sort(Counts, [1]).
test(determinism_facade_and_checklist) :-
    findall(Count, (subject_profile(_, Profile), findall(V, decide_dora_register_of_information(Profile, V), Verdicts), length(Verdicts, Count)), Counts),
    sort(Counts, [1]),
    findall(ItemCount, (subject_profile(_, Profile), findall(I, dora_register_of_information_checklist(Profile, I), Lists), length(Lists, ItemCount)), ItemCounts),
    sort(ItemCounts, [1]).
test(every_returned_citation_is_recorded) :-
    findall(Key, (subject_profile(_, Profile), query_answer(Profile, _, Citations), member(cite(Key), Citations)), Keys),
    sort(Keys, KeySet),
    KeySet = [_|_],
    maplist(recorded_citation, KeySet).
test(every_referral_citation_is_recorded) :-
    findall(Key, (subject_profile(_, Profile), query_answer(Profile, needs_legal_review(open_textured(_, cite(Key)), _), _)), Keys),
    Keys = [_|_],
    maplist(recorded_citation, Keys).
test(every_status_compound_has_no_citations) :-
    findall(Citations, (subject_profile(_, Profile), query_answer(Profile, Result, Citations), status_compound(Result)), CitationLists),
    CitationLists = [_|_],
    sort(CitationLists, [[]]).
test(complete_agrees_with_none_outstanding) :-
    findall(Outstanding, (subject_profile(_, Profile), register_of_information_duties_complete(Profile, complete, _), register_of_information_duties_outstanding(Profile, Outstanding, _)), Results),
    length(Results, 6),
    sort(Results, [none_outstanding]).
test(complete_and_none_outstanding_cite_the_same_fixed_keys) :-
    fixed_citations(Fixed),
    length(Fixed, 14),
    findall(Citations, (subject_profile(_, Profile), register_of_information_duties_outstanding(Profile, none_outstanding, Citations)), Lists),
    sort(Lists, [Fixed]).
test(each_false_always_duty_decides_incomplete) :-
    dora_register_of_information_profile_for(solo_entity_all_performed, Solo),
    findall(Result, (member(attribute(Key, true), Solo), with_value(Solo, Key, false, Profile), register_of_information_duties_complete(Profile, Result, _)), Results),
    length(Results, 22),
    sort(Results, [incomplete]).
test(each_false_key_under_a_false_trigger_is_not_read) :-
    dora_register_of_information_profile_for(solo_entity_all_performed, Solo),
    contract_keys(Keys),
    findall(Key, (member(Key, Keys), profile_lacks(Solo, Key)), Conditioned),
    length(Conditioned, 12),
    findall(Result, (member(Key, Conditioned), append(Solo, [attribute(Key, false)], Profile), register_of_information_duties_complete(Profile, Result, _)), Results),
    length(Results, 12),
    sort(Results, [complete]).

cp_test_names([totality_every_subject_classifies, determinism_required, determinism_complete, determinism_outstanding, determinism_facade_and_checklist, every_returned_citation_is_recorded, every_referral_citation_is_recorded, every_status_compound_has_no_citations, complete_agrees_with_none_outstanding, complete_and_none_outstanding_cite_the_same_fixed_keys, each_false_always_duty_decides_incomplete, each_false_key_under_a_false_trigger_is_not_read]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
