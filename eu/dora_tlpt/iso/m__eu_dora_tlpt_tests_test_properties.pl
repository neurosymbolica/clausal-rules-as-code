% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_tlpt_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_tlpt_dora_tlpt, [decide_dora_tlpt/2, dora_tlpt_checklist/2, tlpt_identification_basis/3, tlpt_duty/3]).
:- use_module(m__eu_dora_tlpt_kernel, [dora_tlpt_input_problems/2]).
:- use_module(m__eu_dora_tlpt_fixtures, [dora_tlpt_subject/1, dora_tlpt_profile_for/2]).

subject_classifies(Subject) :-
    dora_tlpt_subject(Subject),
    dora_tlpt_profile_for(Subject, Profile),
    decide_dora_tlpt(Profile, _Verdict).

identification_answer_count(Subject, AnswerCount) :-
    dora_tlpt_profile_for(Subject, Profile),
    findall(Result - Citations, tlpt_identification_basis(Profile, Result, Citations), Answers),
    length(Answers, AnswerCount).

duty_answer_count(Subject, AnswerCount) :-
    dora_tlpt_profile_for(Subject, Profile),
    findall(Result - Citations, tlpt_duty(Profile, Result, Citations), Answers),
    length(Answers, AnswerCount).

identification_of(Subject, Result, Citations) :-
    dora_tlpt_profile_for(Subject, Profile),
    tlpt_identification_basis(Profile, Result, Citations).

duty_of(Subject, Result, Citations) :-
    dora_tlpt_profile_for(Subject, Profile),
    tlpt_duty(Profile, Result, Citations).

answer_shape(excluded_from_tlpt(_), [_|_]).
answer_shape(listed_for_tlpt(_), [_|_]).
answer_shape(not_listed_for_tlpt, [_|_]).
answer_shape(no_tlpt_duty(_), [_|_]).
answer_shape(tlpt_required(_), [_|_]).
answer_shape(indeterminate([MissingKey]), []) :-
    atom(MissingKey).
answer_shape(input_problems([_|_]), []).

citations_once(Citations) :-
    clausal_msort(Citations, SortedCitations),
    sort(Citations, SortedCitations).

all_subjects(Subjects) :-
    findall(Subject, dora_tlpt_subject(Subject), Subjects).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_identification_one_answer_per_subject) :-
    all_subjects(Subjects),
    findall(Subject, (dora_tlpt_subject(Subject), identification_answer_count(Subject, 1)), OneAnswerSubjects),
    OneAnswerSubjects == Subjects.
test(determinism_duty_one_answer_per_subject) :-
    all_subjects(Subjects),
    findall(Subject, (dora_tlpt_subject(Subject), duty_answer_count(Subject, 1)), OneAnswerSubjects),
    OneAnswerSubjects == Subjects.
test(every_identification_answer_has_its_shape) :-
    all_subjects(Subjects),
    findall(Subject, (identification_of(Subject, Result, Citations), answer_shape(Result, Citations)), ShapedSubjects),
    ShapedSubjects == Subjects.
test(every_duty_answer_has_its_shape) :-
    all_subjects(Subjects),
    findall(Subject, (duty_of(Subject, Result, Citations), answer_shape(Result, Citations)), ShapedSubjects),
    ShapedSubjects == Subjects.
test(every_citation_is_written_once) :-
    all_subjects(Subjects),
    findall(Subject, (identification_of(Subject, _, IdentificationCitations), citations_once(IdentificationCitations), duty_of(Subject, _, DutyCitations), citations_once(DutyCitations)), OnceSubjects),
    OnceSubjects == Subjects.
test(a_carve_out_answers_both_queries_alike) :-
    findall(Subject - Ground, (dora_tlpt_subject(Subject), identification_of(Subject, excluded_from_tlpt(Ground), _)), Excluded),
    findall(Subject - Ground, (dora_tlpt_subject(Subject), duty_of(Subject, no_tlpt_duty(Ground), _), dif(Ground, not_identified)), NoDuty),
    Excluded = [_|_],
    Excluded == NoDuty.
test(the_list_is_not_the_duty) :-
    identification_of(trade_repository_identified, not_listed_for_tlpt, _),
    duty_of(trade_repository_identified, tlpt_required(at_least_every_three_years), _),
    identification_of(central_counterparty_not_identified, listed_for_tlpt(point_e), _),
    duty_of(central_counterparty_not_identified, no_tlpt_duty(not_identified), _).
test(every_well_formed_subject_has_a_checklist) :-
    findall(Subject, (dora_tlpt_subject(Subject), dora_tlpt_profile_for(Subject, Profile), dora_tlpt_input_problems(Profile, [])), WellFormedSubjects),
    findall(Subject, (dora_tlpt_subject(Subject), dora_tlpt_profile_for(Subject, Profile), dora_tlpt_checklist(Profile, _)), ChecklistSubjects),
    WellFormedSubjects = [_|_],
    ChecklistSubjects == WellFormedSubjects.

test(no_subject_has_two_identification_answers, fail) :-
    dora_tlpt_subject(Subject),
    identification_answer_count(Subject, AnswerCount),
    AnswerCount > 1.
test(no_subject_has_two_duty_answers, fail) :-
    dora_tlpt_subject(Subject),
    duty_answer_count(Subject, AnswerCount),
    AnswerCount > 1.
test(the_shape_rejects_a_status_with_a_citation, fail) :-
    answer_shape(indeterminate([dora_entity_type]), [cite(eu_reg_2022_2554_art_26_1)]).
test(the_shape_rejects_a_final_answer_without_citation, fail) :-
    answer_shape(listed_for_tlpt(point_a), []).
test(the_shape_rejects_two_missing_keys, fail) :-
    answer_shape(indeterminate([dora_entity_type, financial_entity_is_microenterprise]), []).
test(a_repeated_citation_is_detected, fail) :-
    citations_once([cite(eu_reg_2022_2554_art_26_1), cite(eu_reg_2022_2554_art_26_1)]).
test(a_subject_with_input_problems_has_no_checklist, fail) :-
    dora_tlpt_profile_for(float_premium_figure, Profile),
    dora_tlpt_checklist(Profile, _).

cp_test_names([totality_every_subject_classifies, determinism_identification_one_answer_per_subject, determinism_duty_one_answer_per_subject, every_identification_answer_has_its_shape, every_duty_answer_has_its_shape, every_citation_is_written_once, a_carve_out_answers_both_queries_alike, the_list_is_not_the_duty, every_well_formed_subject_has_a_checklist]).
cp_test_fail_names([no_subject_has_two_identification_answers, no_subject_has_two_duty_answers, the_shape_rejects_a_status_with_a_citation, the_shape_rejects_a_final_answer_without_citation, the_shape_rejects_two_missing_keys, a_repeated_citation_is_detected, a_subject_with_input_problems_has_no_checklist]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
