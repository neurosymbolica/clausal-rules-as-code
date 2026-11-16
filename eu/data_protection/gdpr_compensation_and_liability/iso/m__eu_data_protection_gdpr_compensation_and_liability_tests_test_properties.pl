% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, decide_gdpr_compensation_and_liability/2, gdpr_compensation_and_liability_status/2, gdpr_compensation_and_liability_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_subject/1, gdpr_compensation_and_liability_profile_for/2]).

subject_set(SubjectSet) :-
    findall(Subject, gdpr_compensation_and_liability_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    gdpr_compensation_and_liability_subject(Subject),
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    decide_gdpr_compensation_and_liability(Profile, _Verdict).

subject_answer_count(Subject, Count) :-
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, compensation_liability(Profile, Result, Basis, Citations), Answers),
    length(Answers, Count).

subject_is_deterministic(Subject) :-
    gdpr_compensation_and_liability_subject(Subject),
    subject_answer_count(Subject, 1).

result_kind(right_not_established, final).
result_kind(not_liable_for_damage, final).
result_kind(exempt_from_liability, final).
result_kind(liable_for_damage, final).
result_kind(indeterminate(_), non_final).
result_kind(needs_legal_review(_, _), non_final).
result_kind(input_problems(_), non_final).

allowed_citation(cite(eu_reg_2016_679_art_82_1)).
allowed_citation(cite(eu_reg_2016_679_art_82_2)).
allowed_citation(cite(eu_reg_2016_679_art_82_3)).

basis_shape(right_not_established, []).
basis_shape(not_liable_for_damage, []).
basis_shape(exempt_from_liability, [outside_fact(not_in_any_way_responsible_for_the_event, attested(true, attestation(_, _, _, _)))]).
basis_shape(liable_for_damage, [outside_fact(not_in_any_way_responsible_for_the_event, attested(false, attestation(_, _, _, _)))]).

shape_for_kind(non_final, _, [], []).
shape_for_kind(final, Result, Basis, [Citation|Citations]) :-
    maplist(allowed_citation, [Citation|Citations]),
    sort([Citation|Citations], SortedCitations),
    length([Citation|Citations], CitationCount),
    length(SortedCitations, CitationCount),
    basis_shape(Result, Basis).

subject_well_shaped(Subject) :-
    gdpr_compensation_and_liability_subject(Subject),
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    compensation_liability(Profile, Result, Basis, Citations),
    result_kind(Result, Kind),
    shape_for_kind(Kind, Result, Basis, Citations).

judgement_key(damage_suffered).
judgement_key(infringement_of_the_regulation_occurred).
judgement_key(damage_resulted_from_the_infringement).

rests_on_settled_judgements(right_not_established, Profile) :-
    judgement_key(Key),
    member(attribute(Key, false), Profile).
rests_on_settled_judgements(Result, Profile) :-
    member(Result, [not_liable_for_damage, exempt_from_liability, liable_for_damage]),
    member(attribute(damage_suffered, true), Profile),
    member(attribute(infringement_of_the_regulation_occurred, true), Profile),
    member(attribute(damage_resulted_from_the_infringement, true), Profile).

final_subject(Subject) :-
    gdpr_compensation_and_liability_subject(Subject),
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    compensation_liability(Profile, Result, _, _),
    result_kind(Result, final).

final_subject_on_settled_judgements(Subject) :-
    gdpr_compensation_and_liability_subject(Subject),
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    compensation_liability(Profile, Result, _, _),
    result_kind(Result, final),
    rests_on_settled_judgements(Result, Profile).

reached_status(Statuses, Status) :-
    member(Status, Statuses).

subject_status(Status) :-
    gdpr_compensation_and_liability_subject(Subject),
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    gdpr_compensation_and_liability_status(Profile, Status).

subject_kind_shape(indeterminate) :-
    subject_status(indeterminate(_)).
subject_kind_shape(needs_legal_review) :-
    subject_status(needs_legal_review(_, _)).
subject_kind_shape(input_problems) :-
    subject_status(input_problems(_)).

test(totality_every_subject_classifies) :-
    subject_set(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_answer) :-
    subject_set(SubjectSet),
    findall(Subject, subject_is_deterministic(Subject), DeterministicSubjects),
    sort(DeterministicSubjects, SubjectSet).
test(every_answer_is_well_shaped) :-
    subject_set(SubjectSet),
    findall(Subject, subject_well_shaped(Subject), ShapedSubjects),
    sort(ShapedSubjects, SubjectSet).
test(a_final_answer_never_rests_on_an_unsure_judgement) :-
    findall(Subject, final_subject(Subject), FinalSubjects),
    sort(FinalSubjects, FinalSet),
    FinalSet = [_|_],
    findall(Subject, final_subject_on_settled_judgements(Subject), SettledSubjects),
    sort(SettledSubjects, FinalSet).
test(every_final_verdict_is_reached_by_a_subject) :-
    gdpr_compensation_and_liability_status_values(StatusValues),
    findall(Status, subject_status(Status), Statuses),
    sort(Statuses, StatusSet),
    maplist(reached_status(StatusSet), StatusValues).
test(every_non_final_kind_is_reached_by_a_subject) :-
    findall(Kind, subject_kind_shape(Kind), Kinds),
    sort(Kinds, KindSet),
    KindSet == [indeterminate, input_problems, needs_legal_review].
test(the_basis_copies_the_attestation_exactly) :-
    gdpr_compensation_and_liability_profile_for(controller_exempt, Profile),
    member(attribute(not_in_any_way_responsible_for_the_event, Attested), Profile),
    compensation_liability(Profile, exempt_from_liability, Basis, _),
    Basis == [outside_fact(not_in_any_way_responsible_for_the_event, Attested)].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_answer, every_answer_is_well_shaped, a_final_answer_never_rests_on_an_unsure_judgement, every_final_verdict_is_reached_by_a_subject, every_non_final_kind_is_reached_by_a_subject, the_basis_copies_the_attestation_exactly]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
