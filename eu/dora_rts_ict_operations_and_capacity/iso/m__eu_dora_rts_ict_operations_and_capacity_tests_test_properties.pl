% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_ict_operations_and_capacity_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3, clausal_is_list/1, clausal_msort/2]).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_dora_rts_ict_operations_and_capacity, [decide_dora_rts_ict_operations_and_capacity/2, rts_ict_operations_and_capacity_duties_required/3, rts_ict_operations_and_capacity_duties_complete/3, rts_ict_operations_and_capacity_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_fixtures, [dora_rts_ict_operations_and_capacity_subject/1, dora_rts_ict_operations_and_capacity_profile_for/2]).

subject_classifies(Subject) :-
    dora_rts_ict_operations_and_capacity_subject(Subject),
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    decide_dora_rts_ict_operations_and_capacity(Profile, _Verdict).

registered_subjects(Subjects) :-
    findall(Subject, dora_rts_ict_operations_and_capacity_subject(Subject), Found),
    sort(Found, Subjects).

one_required_answer(Subject) :-
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    findall(Result - Citations, rts_ict_operations_and_capacity_duties_required(Profile, Result, Citations), [_]).

one_complete_answer(Subject) :-
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    findall(Result - Citations, rts_ict_operations_and_capacity_duties_complete(Profile, Result, Citations), [_]).

one_outstanding_answer(Subject) :-
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    findall(Result - Citations, rts_ict_operations_and_capacity_duties_outstanding(Profile, Result, Citations), [_]).

fixed_citations([cite(eu_reg_2024_1774_art_8_1), cite(eu_reg_2024_1774_art_8_2), cite(eu_reg_2024_1774_art_9_1), cite(eu_reg_2024_1774_art_9_2)]).

fixed_set(Citations) :-
    fixed_citations(Fixed),
    clausal_msort(Fixed, Sorted),
    clausal_msort(Citations, Sorted).

citation_vocabulary([cite(eu_reg_2024_1774_art_8_1), cite(eu_reg_2024_1774_art_8_2), cite(eu_reg_2024_1774_art_9_1), cite(eu_reg_2024_1774_art_9_2), cite(eu_reg_2024_1774_art_8_2_a_i), cite(eu_reg_2024_1774_art_8_2_a_ii), cite(eu_reg_2024_1774_art_8_2_a_iii), cite(eu_reg_2024_1774_art_8_2_b_i), cite(eu_reg_2024_1774_art_8_2_b_ii), cite(eu_reg_2024_1774_art_8_2_b_iii), cite(eu_reg_2024_1774_art_8_2_b_iv), cite(eu_reg_2024_1774_art_8_2_b_v), cite(eu_reg_2024_1774_art_8_2_b_vi), cite(eu_reg_2024_1774_art_8_2_b_vii), cite(eu_reg_2024_1774_art_8_2_c_i), cite(eu_reg_2024_1774_art_8_2_c_ii), cite(eu_reg_2024_1774_art_8_2_c_iii), cite(eu_reg_2024_1774_art_9_1_a), cite(eu_reg_2024_1774_art_9_1_b), cite(eu_reg_2024_1774_art_9_1_c_i), cite(eu_reg_2024_1774_art_9_1_c_ii), cite(eu_reg_2024_1774_art_9_1_c_iii), cite(eu_reg_2022_2554_art_16_1)]).

from_vocabulary(Citations) :-
    citation_vocabulary(Vocabulary),
    subtract(Citations, Vocabulary, Rest),
    Rest == [].

written_once(Items) :-
    sort(Items, Unique),
    same_length(Items, Unique).

well_shaped(indeterminate([Key]), []) :-
    atom(Key).
well_shaped(needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]), []) :-
    atom(Key),
    atom(CitationKey),
    clausal_is_list(Pairs).
well_shaped(input_problems([_|_]), []).
well_shaped(simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
well_shaped(complete, Citations) :-
    fixed_set(Citations).
well_shaped(incomplete, Citations) :-
    fixed_set(Citations).
well_shaped(none_outstanding, Citations) :-
    fixed_set(Citations).
well_shaped(required([Duty|Duties]), Citations) :-
    written_once([Duty|Duties]),
    fixed_set(Citations).
well_shaped(outstanding([Duty|Duties]), [Citation|Citations]) :-
    written_once([Duty|Duties]),
    written_once([Citation|Citations]),
    from_vocabulary([Citation|Citations]).

shaped_answers(Subject) :-
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    rts_ict_operations_and_capacity_duties_required(Profile, RequiredResult, RequiredCitations),
    well_shaped(RequiredResult, RequiredCitations),
    rts_ict_operations_and_capacity_duties_complete(Profile, CompleteResult, CompleteCitations),
    well_shaped(CompleteResult, CompleteCitations),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, OutstandingResult, OutstandingCitations),
    well_shaped(OutstandingResult, OutstandingCitations).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_rts_ict_operations_and_capacity_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_of_the_required_query) :-
    registered_subjects(Subjects),
    maplist(one_required_answer, Subjects).
test(determinism_of_the_complete_query) :-
    registered_subjects(Subjects),
    maplist(one_complete_answer, Subjects).
test(determinism_of_the_outstanding_query) :-
    registered_subjects(Subjects),
    maplist(one_outstanding_answer, Subjects).
test(every_answer_is_well_shaped) :-
    registered_subjects(Subjects),
    maplist(shaped_answers, Subjects).
test(the_baseline_answer_is_well_shaped) :-
    shaped_answers(every_duty_performed_without_production).
test(some_subject_is_complete) :-
    dora_rts_ict_operations_and_capacity_subject(Subject),
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, complete, _),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, none_outstanding, _).
test(some_subject_has_outstanding_required_duties) :-
    dora_rts_ict_operations_and_capacity_subject(Subject),
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, outstanding(Outstanding), _),
    rts_ict_operations_and_capacity_duties_required(Profile, required(Required), _),
    subtract(Outstanding, Required, []).

test(no_complete_subject_has_outstanding_duties, fail) :-
    dora_rts_ict_operations_and_capacity_subject(Subject),
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    rts_ict_operations_and_capacity_duties_complete(Profile, complete, _),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, outstanding(_), _).
test(no_outstanding_duty_is_outside_the_required_duties, fail) :-
    dora_rts_ict_operations_and_capacity_subject(Subject),
    dora_rts_ict_operations_and_capacity_profile_for(Subject, Profile),
    rts_ict_operations_and_capacity_duties_outstanding(Profile, outstanding(Outstanding), _),
    rts_ict_operations_and_capacity_duties_required(Profile, required(Required), _),
    subtract(Outstanding, Required, [_|_]).

cp_test_names([totality_every_subject_classifies, determinism_of_the_required_query, determinism_of_the_complete_query, determinism_of_the_outstanding_query, every_answer_is_well_shaped, the_baseline_answer_is_well_shaped, some_subject_is_complete, some_subject_has_outstanding_required_duties]).
cp_test_fail_names([no_complete_subject_has_outstanding_duties, no_outstanding_duty_is_outside_the_required_duties]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
