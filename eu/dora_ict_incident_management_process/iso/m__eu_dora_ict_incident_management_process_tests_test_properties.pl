% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_incident_management_process_dora_ict_incident_management_process, [ict_incident_management_process_duties_required/3, ict_incident_management_process_duties_complete/3, ict_incident_management_process_duties_outstanding/3, decide_dora_ict_incident_management_process/2]).
:- use_module(m__eu_dora_ict_incident_management_process_queries, [dora_ict_incident_management_process_profile_keys/1]).
:- use_module(m__eu_dora_ict_incident_management_process_fixtures, [dora_ict_incident_management_process_subject/1, dora_ict_incident_management_process_profile_for/2]).

subject_classifies(Subject) :-
    dora_ict_incident_management_process_subject(Subject),
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    decide_dora_ict_incident_management_process(Profile, _Verdict).

one_answer_per_query(Profile) :-
    findall(Result - Citations, ict_incident_management_process_duties_required(Profile, Result, Citations), [_]),
    findall(Result - Citations, ict_incident_management_process_duties_complete(Profile, Result, Citations), [_]),
    findall(Result - Citations, ict_incident_management_process_duties_outstanding(Profile, Result, Citations), [_]).

subject_is_deterministic(Subject) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    one_answer_per_query(Profile).

variant_profile(TargetKey, TargetValue, Profile) :-
    dora_ict_incident_management_process_profile_keys(ProfileKeys),
    variant_entries(ProfileKeys, TargetKey, TargetValue, Profile).

variant_entries([], _, _, []).
variant_entries([ProfileKey|ProfileKeys], TargetKey, TargetValue, Profile) :-
    ProfileKey == TargetKey,
    target_entries(TargetValue, ProfileKey, RemainingEntries, Profile),
    variant_entries(ProfileKeys, TargetKey, TargetValue, RemainingEntries).
variant_entries([ProfileKey|ProfileKeys], TargetKey, TargetValue, [attribute(ProfileKey, true)|RemainingEntries]) :-
    ProfileKey \== TargetKey,
    variant_entries(ProfileKeys, TargetKey, TargetValue, RemainingEntries).

target_entries(absent, _, RemainingEntries, RemainingEntries).
target_entries(JudgementValue, ProfileKey, RemainingEntries, [attribute(ProfileKey, JudgementValue)|RemainingEntries]) :-
    dif(JudgementValue, absent).

variant_cases(Cases) :-
    dora_ict_incident_management_process_profile_keys(ProfileKeys),
    findall(ProfileKey - JudgementValue, (member(ProfileKey, ProfileKeys), member(JudgementValue, [true, false, unsure, absent])), Cases).

variant_is_deterministic(ProfileKey - JudgementValue) :-
    variant_profile(ProfileKey, JudgementValue, Profile),
    one_answer_per_query(Profile).

variant_answer_holds(_ - true) :-
    variant_profile(early_warning_indicators_put_in_place, true, Profile),
    ict_incident_management_process_duties_complete(Profile, complete, _),
    ict_incident_management_process_duties_outstanding(Profile, none_outstanding, _).
variant_answer_holds(ProfileKey - false) :-
    variant_profile(ProfileKey, false, Profile),
    ict_incident_management_process_duties_complete(Profile, incomplete, _),
    ict_incident_management_process_duties_outstanding(Profile, outstanding([_]), [_]).
variant_answer_holds(ProfileKey - unsure) :-
    variant_profile(ProfileKey, unsure, Profile),
    ict_incident_management_process_duties_complete(Profile, needs_legal_review(open_textured(CompleteNamedKey, cite(_)), [inputs_relied_on(CompletePairs)]), []),
    CompleteNamedKey == ProfileKey,
    length(CompletePairs, 10),
    ict_incident_management_process_duties_outstanding(Profile, needs_legal_review(open_textured(OutstandingNamedKey, cite(_)), [inputs_relied_on(_)]), []),
    OutstandingNamedKey == ProfileKey.
variant_answer_holds(ProfileKey - absent) :-
    variant_profile(ProfileKey, absent, Profile),
    ict_incident_management_process_duties_complete(Profile, indeterminate([CompleteNamedKey]), []),
    CompleteNamedKey == ProfileKey,
    ict_incident_management_process_duties_outstanding(Profile, indeterminate([OutstandingNamedKey]), []),
    OutstandingNamedKey == ProfileKey.

queries_agree(Subject) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    ict_incident_management_process_duties_complete(Profile, CompleteResult, _),
    ict_incident_management_process_duties_outstanding(Profile, OutstandingResult, _),
    agreement(CompleteResult, OutstandingResult).

agreement(complete, none_outstanding).
agreement(incomplete, outstanding(_)).
agreement(incomplete, indeterminate(_)).
agreement(indeterminate(MissingKeys), indeterminate(MissingKeys)).
agreement(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
agreement(input_problems(Problems), input_problems(Problems)).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_ict_incident_management_process_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_one_answer_per_query) :-
    findall(Subject, dora_ict_incident_management_process_subject(Subject), Subjects),
    maplist(subject_is_deterministic, Subjects).
test(determinism_every_one_key_variation) :-
    variant_cases(Cases),
    length(Cases, 40),
    maplist(variant_is_deterministic, Cases).
test(every_one_key_variation_gets_its_limb) :-
    variant_cases(Cases),
    maplist(variant_answer_holds, Cases).
test(the_two_final_queries_agree_on_every_subject) :-
    findall(Subject, dora_ict_incident_management_process_subject(Subject), Subjects),
    maplist(queries_agree, Subjects).
test(required_is_the_same_for_every_well_formed_profile) :-
    variant_cases(Cases),
    findall(Result, (member(ProfileKey - JudgementValue, Cases), variant_profile(ProfileKey, JudgementValue, Profile), ict_incident_management_process_duties_required(Profile, Result, _)), Results),
    sort(Results, DistinctResults),
    DistinctResults = [required(Duties)],
    length(Duties, 10).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_one_answer_per_query, determinism_every_one_key_variation, every_one_key_variation_gets_its_limb, the_two_final_queries_agree_on_every_subject, required_is_the_same_for_every_well_formed_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
