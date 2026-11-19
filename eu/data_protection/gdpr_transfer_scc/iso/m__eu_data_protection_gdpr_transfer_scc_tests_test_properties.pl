% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_scc_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_gdpr_transfer_scc, [decide_gdpr_transfer_scc/2, gdpr_transfer_scc_status/2, standard_contractual_clauses_module/3, standard_contractual_clauses_appendix/3]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_kernel, [gdpr_transfer_scc_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_fixtures, [gdpr_transfer_scc_subject/1, gdpr_transfer_scc_profile_for/2, gdpr_transfer_scc_expected/2]).

subject_set(SubjectSet) :-
    findall(Subject, gdpr_transfer_scc_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    gdpr_transfer_scc_subject(Subject),
    gdpr_transfer_scc_profile_for(Subject, Profile),
    decide_gdpr_transfer_scc(Profile, _Verdict).

subject_verdict_count(Subject, Count) :-
    gdpr_transfer_scc_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_transfer_scc(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

subject_agrees(Subject) :-
    gdpr_transfer_scc_subject(Subject),
    gdpr_transfer_scc_profile_for(Subject, Profile),
    gdpr_transfer_scc_status(Profile, Status),
    gdpr_transfer_scc_expected(Subject, Expected),
    Status == Expected.

status_citation_shape(appropriate_safeguards_provided, [_FirstCitation|_OtherCitations]).
status_citation_shape(appropriate_safeguards_not_provided, [_FirstCitation|_OtherCitations]).
status_citation_shape(indeterminate(_MissingKeys), []).
status_citation_shape(needs_legal_review(_Reason, _Context), []).
status_citation_shape(input_problems(_Problems), []).

subject_citations_well_shaped(Subject) :-
    gdpr_transfer_scc_subject(Subject),
    gdpr_transfer_scc_profile_for(Subject, Profile),
    decide_gdpr_transfer_scc(Profile, gdpr_transfer_scc_verdict(Status, Citations)),
    status_citation_shape(Status, Citations).

input_check_solution_count(Term, Count) :-
    findall(Problems, gdpr_transfer_scc_input_problems(Term, Problems), Solutions),
    length(Solutions, Count).

test(totality_every_subject_classifies) :-
    subject_set(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_yields_exactly_one_verdict) :-
    findall(Count, (gdpr_transfer_scc_subject(Subject), subject_verdict_count(Subject, Count)), Counts),
    sort(Counts, [1]).
test(every_subject_gets_its_expected_status) :-
    subject_set(SubjectSet),
    findall(Subject, subject_agrees(Subject), AgreeingSubjects),
    sort(AgreeingSubjects, SubjectSet).
test(settled_verdicts_cite_and_statuses_do_not) :-
    subject_set(SubjectSet),
    findall(Subject, subject_citations_well_shaped(Subject), WellShaped),
    sort(WellShaped, SubjectSet).
test(the_input_check_yields_one_solution_for_every_term) :-
    findall(Count, (member(Term, [_UnboundTerm, 42, not_a_list, [_|_], [_], [attribute(_, _)], [attribute(colour, red)|tail], []]), input_check_solution_count(Term, Count)), Counts),
    sort(Counts, [1]).
test(an_appendix_key_does_not_change_the_safeguard) :-
    gdpr_transfer_scc_profile_for(module_two_all_met, CompleteProfile),
    gdpr_transfer_scc_profile_for(module_two_list_of_parties_incomplete, IncompleteProfile),
    gdpr_transfer_scc_status(CompleteProfile, CompleteStatus),
    gdpr_transfer_scc_status(IncompleteProfile, IncompleteStatus),
    CompleteStatus == IncompleteStatus,
    standard_contractual_clauses_appendix(CompleteProfile, appendix_complete, _CompleteCitations),
    standard_contractual_clauses_appendix(IncompleteProfile, appendix_incomplete, _IncompleteCitations).
test(unread_keys_do_not_change_the_module) :-
    gdpr_transfer_scc_profile_for(module_two_all_met, Profile),
    findall(Result, standard_contractual_clauses_module(Profile, Result, _FullCitations), FullResults),
    findall(Result, standard_contractual_clauses_module([attribute(exporter_role, controller), attribute(importer_role, processor)], Result, _RoleCitations), RoleResults),
    FullResults == RoleResults,
    FullResults == [module_two].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_yields_exactly_one_verdict, every_subject_gets_its_expected_status, settled_verdicts_cite_and_statuses_do_not, the_input_check_yields_one_solution_for_every_term, an_appendix_key_does_not_change_the_safeguard, unread_keys_do_not_change_the_module]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
