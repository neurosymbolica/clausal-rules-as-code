% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5, decide_gdpr_procedural_regulation/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_fixtures, [gdpr_procedural_regulation_subject/1, gdpr_procedural_regulation_profile_for/2]).

query_name(complaint_admissibility).
query_name(prior_request_condition).
query_name(early_resolution).
query_name(simple_cooperation_procedure).
query_name(draft_decision_time_limit).
query_name(late_step_effect).

query_answer(complaint_admissibility, Profile, answer(Result, [], Citations)) :-
    complaint_admissibility(Profile, Result, Citations).
query_answer(prior_request_condition, Profile, answer(Result, [], Citations)) :-
    prior_request_condition(Profile, Result, Citations).
query_answer(early_resolution, Profile, answer(Result, [], Citations)) :-
    early_resolution(Profile, Result, Citations).
query_answer(simple_cooperation_procedure, Profile, answer(Result, Basis, Citations)) :-
    simple_cooperation_procedure(Profile, Result, Basis, Citations).
query_answer(draft_decision_time_limit, Profile, answer(Result, Basis, Citations)) :-
    draft_decision_time_limit(Profile, Result, Basis, Citations).
query_answer(late_step_effect, Profile, answer(Result, Basis, Citations)) :-
    late_step_effect(Profile, Result, Basis, Citations).

subject_query(Subject - QueryName) :-
    gdpr_procedural_regulation_subject(Subject),
    query_name(QueryName).

answers_once(Subject - QueryName) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(Answer, query_answer(QueryName, Profile, Answer), Answers),
    length(Answers, 1).

subject_answer(Subject, QueryName, Answer) :-
    gdpr_procedural_regulation_subject(Subject),
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    query_name(QueryName),
    query_answer(QueryName, Profile, Answer).

non_final(indeterminate(_)).
non_final(needs_legal_review(_, _)).
non_final(input_problems(_)).

final_result(Result) :-
    atom(Result).
final_result(draft_decision_limit(_, _)).

time_limit_steps([declare_complaint_inadmissible, transmit_complaint_to_presumed_lead_authority, confirm_competence_or_refer_to_board, object_to_early_resolution, establish_early_resolution, submit_early_resolution_draft_decision, notify_simple_cooperation_procedure, object_to_simple_cooperation_procedure, provide_summary_of_key_issues, comment_on_summary_of_key_issues, respond_to_comments_on_summary_of_key_issues, submit_draft_decision, inform_of_draft_decision_extension, object_to_draft_decision_extension, submit_draft_decision_in_simple_procedure, inform_of_simple_procedure_extension]).

step_limit_once(ProceduralStep) :-
    findall(Limit, procedural_time_limit([], ProceduralStep, Limit, _), Limits),
    length(Limits, 1).

probe_date(date(2026, 12, 31)).
probe_date(date(2027, 4, 1)).
probe_date(date(2027, 4, 2)).
probe_date(date(2027, 4, 3)).
probe_date(date(2030, 2, 28)).

regulation_part(complaints_and_early_resolution).
regulation_part(cooperation_and_files).
regulation_part(dispute_resolution_and_urgency).

part_date(RegulationPart - EventDate) :-
    regulation_part(RegulationPart),
    probe_date(EventDate).

part_date_once(RegulationPart - EventDate) :-
    findall(Result, temporal_application([], RegulationPart, EventDate, Result, _), Results),
    length(Results, 1).

subject_classifies(Subject) :-
    gdpr_procedural_regulation_subject(Subject),
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    decide_gdpr_procedural_regulation(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_procedural_regulation_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_answers_every_query_exactly_once) :-
    findall(Pairing, subject_query(Pairing), Pairings),
    findall(Pairing, (subject_query(Pairing), answers_once(Pairing)), OncePairings),
    OncePairings == Pairings.
test(determinism_every_step_has_exactly_one_limit) :-
    time_limit_steps(ProceduralSteps),
    findall(ProceduralStep, (member(ProceduralStep, ProceduralSteps), step_limit_once(ProceduralStep)), OnceSteps),
    OnceSteps == ProceduralSteps.
test(determinism_every_part_and_date_has_exactly_one_result) :-
    findall(Probe, part_date(Probe), Probes),
    findall(Probe, (part_date(Probe), part_date_once(Probe)), OnceProbes),
    OnceProbes == Probes.
test(every_non_final_answer_has_empty_basis_and_citations) :-
    findall(Subject - QueryName, (subject_answer(Subject, QueryName, answer(Result, _, _)), non_final(Result)), NonFinal),
    findall(Subject - QueryName, (subject_answer(Subject, QueryName, answer(Result, [], [])), non_final(Result)), NonFinalEmpty),
    NonFinalEmpty == NonFinal.
test(every_final_answer_carries_a_citation) :-
    findall(Subject - QueryName, (subject_answer(Subject, QueryName, answer(Result, _, _)), final_result(Result)), Finals),
    findall(Subject - QueryName, (subject_answer(Subject, QueryName, answer(Result, _, [_|_])), final_result(Result)), CitedFinals),
    CitedFinals == Finals.
test(the_fixtures_reach_a_final_answer_somewhere) :-
    findall(Subject, (subject_answer(Subject, _, answer(Result, _, _)), final_result(Result)), Finals),
    Finals = [_|_].
test(the_fixtures_reach_a_non_final_answer_somewhere) :-
    findall(Subject, (subject_answer(Subject, _, answer(Result, _, _)), non_final(Result)), NonFinals),
    NonFinals = [_|_].
test(a_key_admissibility_does_not_read_leaves_its_answer_unchanged) :-
    gdpr_procedural_regulation_profile_for(admissible_data_subject_complaint, Profile),
    append(Profile, [attribute(board_request_under_article_11_6_made, true), attribute(complaint_concerns_right_exercised_by_request, unsure)], Extended),
    findall(Result - Citations, complaint_admissibility(Profile, Result, Citations), Plain),
    findall(Result - Citations, complaint_admissibility(Extended, Result, Citations), WithUnreadKeys),
    WithUnreadKeys == Plain.
test(the_point_c_mandate_is_not_read_for_an_independent_body) :-
    gdpr_procedural_regulation_profile_for(admissible_article_80_2_complaint_without_mandate_key, Profile),
    append(Profile, [attribute(proof_of_data_subject_mandate_included, false)], Extended),
    complaint_admissibility(Extended, admissible, _).
test(the_simple_procedure_draft_limit_does_not_read_the_board_request) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_draft_decision_without_extension, Profile),
    append(Profile, [attribute(board_request_under_article_11_6_made, true)], Extended),
    draft_decision_time_limit(Extended, draft_decision_limit(12, no_extension), [], _).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_answers_every_query_exactly_once, determinism_every_step_has_exactly_one_limit, determinism_every_part_and_date_has_exactly_one_result, every_non_final_answer_has_empty_basis_and_citations, every_final_answer_carries_a_citation, the_fixtures_reach_a_final_answer_somewhere, the_fixtures_reach_a_non_final_answer_somewhere, a_key_admissibility_does_not_read_leaves_its_answer_unchanged, the_point_c_mandate_is_not_read_for_an_independent_body, the_simple_procedure_draft_limit_does_not_read_the_board_request]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
