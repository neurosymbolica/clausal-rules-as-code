% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_pecr_cookie_exemptions_and_fines_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_uk_pecr_cookie_exemptions_and_fines, [decide_uk_pecr_cookie_exemptions_and_fines/2, uk_terminal_equipment_storage_or_access/3, eu_terminal_equipment_storage_or_access/3, compare_uk_eu_terminal_equipment_storage_or_access/5, uk_breach_notification_timing/3, uk_penalty_maximum_tier/3, uk_penalty_maximum_amount_in_pence/3]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_fixtures, [uk_pecr_cookie_exemptions_and_fines_subject/1, uk_pecr_cookie_exemptions_and_fines_profile_for/2]).

subject_classifies(Subject) :-
    uk_pecr_cookie_exemptions_and_fines_subject(Subject),
    uk_pecr_cookie_exemptions_and_fines_profile_for(Subject, Profile),
    decide_uk_pecr_cookie_exemptions_and_fines(Profile, _Verdict).

query_answers(united_kingdom, Profile, Answers) :-
    findall(Result - Citations, uk_terminal_equipment_storage_or_access(Profile, Result, Citations), Answers).
query_answers(union, Profile, Answers) :-
    findall(Result - Citations, eu_terminal_equipment_storage_or_access(Profile, Result, Citations), Answers).
query_answers(comparison, Profile, Answers) :-
    findall(answer(UnitedKingdomResult, UnionResult, Difference, ChangedBy), compare_uk_eu_terminal_equipment_storage_or_access(Profile, UnitedKingdomResult, UnionResult, Difference, ChangedBy), Answers).
query_answers(breach, Profile, Answers) :-
    findall(Result - Citations, uk_breach_notification_timing(Profile, Result, Citations), Answers).
query_answers(tier, Profile, Answers) :-
    findall(Result - Citations, uk_penalty_maximum_tier(Profile, Result, Citations), Answers).
query_answers(amount, Profile, Answers) :-
    findall(Result - Citations, uk_penalty_maximum_amount_in_pence(Profile, Result, Citations), Answers).
query_answers(verdict, Profile, Answers) :-
    findall(Verdict, decide_uk_pecr_cookie_exemptions_and_fines(Profile, Verdict), Answers).

query_names([united_kingdom, union, comparison, breach, tier, amount, verdict]).

cited_query_names([united_kingdom, union, breach, tier, amount]).

one_answer(Profile, QueryName) :-
    query_answers(QueryName, Profile, [_]).

subject_profile(Subject, Profile) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(Subject, Profile).

subject_is_deterministic(Subject) :-
    subject_profile(Subject, Profile),
    query_names(QueryNames),
    maplist(one_answer(Profile), QueryNames).

answer_shape_holds(Result - Citations) :-
    atom(Result),
    Citations = [_|_].
answer_shape_holds(Result - Citations) :-
    integer(Result),
    Citations = [_|_].
answer_shape_holds(Result - []) :-
    compound(Result).

shape_holds_for(Profile, QueryName) :-
    query_answers(QueryName, Profile, Answers),
    maplist(answer_shape_holds, Answers).

subject_shapes_hold(Subject) :-
    subject_profile(Subject, Profile),
    cited_query_names(QueryNames),
    maplist(shape_holds_for(Profile), QueryNames).

test(totality_every_subject_classifies) :-
    findall(Subject, uk_pecr_cookie_exemptions_and_fines_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_one_answer_per_subject) :-
    findall(Subject, uk_pecr_cookie_exemptions_and_fines_subject(Subject), Subjects),
    maplist(subject_is_deterministic, Subjects).
test(not_final_answers_carry_no_citations) :-
    findall(Subject, uk_pecr_cookie_exemptions_and_fines_subject(Subject), Subjects),
    maplist(subject_shapes_hold, Subjects).
test(permitted_and_not_permitted_share_citations) :-
    subject_profile(cookie_consent_given, PermittedProfile),
    subject_profile(cookie_consent_withheld, RefusedProfile),
    uk_terminal_equipment_storage_or_access(PermittedProfile, permitted, PermittedCitations),
    uk_terminal_equipment_storage_or_access(RefusedProfile, not_permitted, RefusedCitations),
    PermittedCitations == RefusedCitations.
test(comparison_sides_equal_the_side_queries) :-
    subject_profile(comparison_differs, Profile),
    uk_terminal_equipment_storage_or_access(Profile, UnitedKingdomResult, _),
    eu_terminal_equipment_storage_or_access(Profile, UnionResult, _),
    compare_uk_eu_terminal_equipment_storage_or_access(Profile, CompareUnitedKingdom, CompareUnion, _, _),
    UnitedKingdomResult == CompareUnitedKingdom,
    UnionResult == CompareUnion.
test(amount_monotone_in_turnover) :-
    subject_profile(amount_higher_tie, TieProfile),
    subject_profile(amount_higher_above_tie, AboveProfile),
    uk_penalty_maximum_amount_in_pence(TieProfile, TieAmount, _),
    uk_penalty_maximum_amount_in_pence(AboveProfile, AboveAmount, _),
    TieAmount =< AboveAmount.

cp_test_names([totality_every_subject_classifies, determinism_every_query_one_answer_per_subject, not_final_answers_carry_no_citations, permitted_and_not_permitted_share_citations, comparison_sides_equal_the_side_queries, amount_monotone_in_turnover]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
