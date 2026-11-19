% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [intersection/3]).
:- use_module(clausal_hof, [include/3]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [decide_gdpr_procedural_regulation/2, complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_fixtures, [gdpr_procedural_regulation_subject/1, gdpr_procedural_regulation_profile_for/2]).

fixture_profile(Profile) :-
    gdpr_procedural_regulation_subject(Subject),
    gdpr_procedural_regulation_profile_for(Subject, Profile).
fixture_profile([]).

step_atom(declare_complaint_inadmissible).
step_atom(transmit_complaint_to_presumed_lead_authority).
step_atom(confirm_competence_or_refer_to_board).
step_atom(object_to_early_resolution).
step_atom(establish_early_resolution).
step_atom(submit_early_resolution_draft_decision).
step_atom(notify_simple_cooperation_procedure).
step_atom(object_to_simple_cooperation_procedure).
step_atom(provide_summary_of_key_issues).
step_atom(comment_on_summary_of_key_issues).
step_atom(respond_to_comments_on_summary_of_key_issues).
step_atom(submit_draft_decision).
step_atom(inform_of_draft_decision_extension).
step_atom(object_to_draft_decision_extension).
step_atom(submit_draft_decision_in_simple_procedure).
step_atom(inform_of_simple_procedure_extension).

part_atom(complaints_and_early_resolution).
part_atom(cooperation_and_files).
part_atom(dispute_resolution_and_urgency).

probe_date(date(2026, 12, 31)).
probe_date(date(2027, 4, 1)).
probe_date(date(2027, 4, 2)).
probe_date(date(2027, 4, 3)).
probe_date(date(2030, 1, 1)).

query_name(complaint_admissibility).
query_name(prior_request_condition).
query_name(early_resolution).
query_name(simple_cooperation_procedure).
query_name(draft_decision_time_limit).
query_name(late_step_effect).
query_name(procedural_time_limit(Step)) :-
    step_atom(Step).
query_name(temporal_application(Part, EventDate)) :-
    part_atom(Part),
    probe_date(EventDate).

query_answers(Profile, complaint_admissibility, Answers) :-
    findall(Result - [] - Citations, complaint_admissibility(Profile, Result, Citations), Answers).
query_answers(Profile, prior_request_condition, Answers) :-
    findall(Result - [] - Citations, prior_request_condition(Profile, Result, Citations), Answers).
query_answers(Profile, early_resolution, Answers) :-
    findall(Result - [] - Citations, early_resolution(Profile, Result, Citations), Answers).
query_answers(Profile, simple_cooperation_procedure, Answers) :-
    findall(Result - Basis - Citations, simple_cooperation_procedure(Profile, Result, Basis, Citations), Answers).
query_answers(Profile, draft_decision_time_limit, Answers) :-
    findall(Result - Basis - Citations, draft_decision_time_limit(Profile, Result, Basis, Citations), Answers).
query_answers(Profile, late_step_effect, Answers) :-
    findall(Result - Basis - Citations, late_step_effect(Profile, Result, Basis, Citations), Answers).
query_answers(Profile, procedural_time_limit(Step), Answers) :-
    findall(Limit - [] - Citations, procedural_time_limit(Profile, Step, Limit, Citations), Answers).
query_answers(Profile, temporal_application(Part, EventDate), Answers) :-
    findall(Result - [] - Citations, temporal_application(Profile, Part, EventDate, Result, Citations), Answers).

answer_count(Count) :-
    fixture_profile(Profile),
    query_name(Query),
    query_answers(Profile, Query, Answers),
    length(Answers, Count).

result_kind(indeterminate(_), status).
result_kind(needs_legal_review(_, _), status).
result_kind(input_problems(_), status).
result_kind(draft_decision_limit(_, _), final).
result_kind(limit(_, _, _, _, _), final).
result_kind(Result, final) :-
    atom(Result).

status_shape([], [], good).
status_shape([_|_], _, bad).
status_shape([], [_|_], bad).

final_shape([], bad).
final_shape([Citation|Citations], Shape) :-
    sort([Citation|Citations], CitationSet),
    length(CitationSet, SetLength),
    length([Citation|Citations], ListLength),
    compare(Order, SetLength, ListLength),
    order_shape(Order, Shape).

order_shape(=, good).
order_shape(<, bad).

kind_shape(status, Basis, Citations, Shape) :-
    status_shape(Basis, Citations, Shape).
kind_shape(final, _, Citations, Shape) :-
    final_shape(Citations, Shape).

answer_shape(Shape) :-
    fixture_profile(Profile),
    query_name(Query),
    query_answers(Profile, Query, Answers),
    member(Result - Basis - Citations, Answers),
    result_kind(Result, Kind),
    kind_shape(Kind, Basis, Citations, Shape).

subject_classifies(Subject) :-
    gdpr_procedural_regulation_subject(Subject),
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    decide_gdpr_procedural_regulation(Profile, _Verdict).

result_atoms(Query, Atoms) :-
    findall(Result, (fixture_profile(Profile), query_answers(Profile, Query, Answers), member(Result - _ - _, Answers)), Results),
    include(atom, Results, ResultAtoms),
    sort(ResultAtoms, Atoms).

same_answer_shape(Before, After, Shape) :-
    compare(Order, Before, After),
    order_same(Order, Shape).

order_same(=, same).
order_same(<, changed).
order_same(>, changed).

admissibility_subject(admissible_data_subject_complaint).
admissibility_subject(data_subject_complaint_without_description).
admissibility_subject(admissible_article_80_1_body_complaint).
admissibility_subject(article_80_1_body_complaint_without_mandate).
admissibility_subject(admissible_article_80_2_body_complaint).
admissibility_subject(article_80_2_body_complaint_without_constitution).
admissibility_subject(complaint_without_lodger).

late_step_subject(late_step_after_regulation_time_limit).
late_step_subject(late_step_after_other_time_limit).
late_step_subject(late_step_statement_missing_case).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_procedural_regulation_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_exactly_once) :-
    findall(Count, answer_count(Count), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(final_answers_cite_and_statuses_carry_nothing) :-
    findall(Shape, answer_shape(Shape), Shapes),
    Shapes = [_|_],
    sort(Shapes, [good]).
test(an_outside_fact_is_never_a_missing_key) :-
    findall(Key, (fixture_profile(Profile), query_name(Query), query_answers(Profile, Query, Answers), member(indeterminate([Key]) - _ - _, Answers)), MissingKeys),
    MissingKeys = [_|_],
    intersection(MissingKeys, [case_handled_under_article_56_2, national_law_requires_domestic_proceedings_after_time_limit, time_limit_set_by_this_regulation_or_article_65_6], Common),
    Common == [].
test(an_unread_outside_fact_does_not_change_admissibility) :-
    Extra = attribute(time_limit_set_by_this_regulation_or_article_65_6, attested(true, attestation(host, instant, reason, none))),
    findall(Shape, (admissibility_subject(Subject), gdpr_procedural_regulation_profile_for(Subject, Profile), complaint_admissibility(Profile, Before, BeforeCitations), complaint_admissibility([Extra|Profile], After, AfterCitations), same_answer_shape(Before - BeforeCitations, After - AfterCitations, Shape)), Shapes),
    length(Shapes, 7),
    sort(Shapes, [same]).
test(an_unread_crisp_key_does_not_change_the_late_step_effect) :-
    Extra = attribute(simple_cooperation_procedure_applied, true),
    findall(Shape, (late_step_subject(Subject), gdpr_procedural_regulation_profile_for(Subject, Profile), late_step_effect(Profile, Before, BeforeBasis, BeforeCitations), late_step_effect([Extra|Profile], After, AfterBasis, AfterCitations), same_answer_shape(Before - BeforeBasis - BeforeCitations, After - AfterBasis - AfterCitations, Shape)), Shapes),
    length(Shapes, 3),
    sort(Shapes, [same]).
test(every_admissibility_result_is_reached) :-
    result_atoms(complaint_admissibility, Atoms),
    Atoms == [admissible, inadmissible].
test(every_prior_request_result_is_reached) :-
    result_atoms(prior_request_condition, Atoms),
    Atoms == [prior_request_made, prior_request_not_made, prior_request_not_required].
test(every_early_resolution_result_is_reached) :-
    result_atoms(early_resolution, Atoms),
    Atoms == [complaint_not_devoid_of_purpose, draft_decision_establishing_resolution, early_resolution_not_available, early_resolution_objected, resolution_established_by_receiving_authority].
test(every_simple_procedure_result_is_reached) :-
    result_atoms(simple_cooperation_procedure, Atoms),
    Atoms == [chapter_iii_not_applicable, simple_procedure_available, simple_procedure_excluded_by_objection, simple_procedure_not_available].
test(every_late_step_result_is_reached) :-
    result_atoms(late_step_effect, Atoms),
    Atoms == [legality_and_validity_not_affected, not_governed_by_article_14].
test(the_input_check_answers_once_for_odd_terms) :-
    Terms = [_, foo, 42, [a], [attribute(_, _)], [attribute(a)|_], [attribute(complaint_lodged_by, _)], [attribute(complaint_lodged_by, data_subject)|_]],
    findall(Count, (member(Term, Terms), findall(Problems, gdpr_procedural_regulation_input_problems(Term, Problems), AllProblems), length(AllProblems, Count)), Counts),
    length(Counts, 8),
    sort(Counts, [1]).
test(the_sixteen_steps_have_positive_lengths) :-
    findall(PeriodLength, (step_atom(Step), procedural_time_limit([], Step, limit(PeriodLength, _, _, _, _), _), PeriodLength > 0), Lengths),
    length(Lengths, 16).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_exactly_once, final_answers_cite_and_statuses_carry_nothing, an_outside_fact_is_never_a_missing_key, an_unread_outside_fact_does_not_change_admissibility, an_unread_crisp_key_does_not_change_the_late_step_effect, every_admissibility_result_is_reached, every_prior_request_result_is_reached, every_early_resolution_result_is_reached, every_simple_procedure_result_is_reached, every_late_step_result_is_reached, the_input_check_answers_once_for_odd_terms, the_sixteen_steps_have_positive_lengths]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
