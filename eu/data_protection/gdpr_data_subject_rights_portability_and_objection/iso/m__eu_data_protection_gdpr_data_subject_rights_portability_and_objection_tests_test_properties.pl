% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_queries, [decide_data_subject_request/2, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_fixtures, [gdpr_data_subject_rights_portability_and_objection_subject/1, gdpr_data_subject_rights_portability_and_objection_profile_for/2]).

subject_has_one_verdict(Subject) :-
    gdpr_data_subject_rights_portability_and_objection_subject(Subject),
    gdpr_data_subject_rights_portability_and_objection_profile_for(Subject, Profile),
    findall(Verdict, decide_data_subject_request(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_one_basis(Subject) :-
    gdpr_data_subject_rights_portability_and_objection_subject(Subject),
    gdpr_data_subject_rights_portability_and_objection_profile_for(Subject, Profile),
    findall(Basis, request_basis(Profile, Basis), Bases),
    length(Bases, 1).

basis_disagrees(Subject) :-
    gdpr_data_subject_rights_portability_and_objection_subject(Subject),
    gdpr_data_subject_rights_portability_and_objection_profile_for(Subject, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(Comply, VerdictBasis, _, _, _)),
    Comply \= input_problems(_),
    request_basis(Profile, Basis),
    dif(VerdictBasis, Basis).

final_without_citation(Subject) :-
    gdpr_data_subject_rights_portability_and_objection_subject(Subject),
    gdpr_data_subject_rights_portability_and_objection_profile_for(Subject, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(must_comply, _, _, _, [])).

test(totality_every_subject_has_exactly_one_verdict) :-
    findall(Subject, gdpr_data_subject_rights_portability_and_objection_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_has_one_verdict(Subject), CountedSubjects),
    sort(CountedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_basis) :-
    findall(Subject, gdpr_data_subject_rights_portability_and_objection_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_has_one_basis(Subject), CountedSubjects),
    sort(CountedSubjects, SubjectSet).
test(a_key_no_limb_reads_does_not_change_the_answer) :-
    decide_data_subject_request([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(consent_withdrawn, true), attribute(personal_data_inaccurate, false)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [cite(eu_reg_2016_679_art_20_1)]).
test(input_problems_come_before_every_other_step) :-
    decide_data_subject_request([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(no_such_key, true)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(input_problems([unknown_key(no_such_key)]), none, none, [], []).
test(a_duplicate_key_is_an_input_problem) :-
    decide_data_subject_request([attribute(request_type, portability), attribute(request_type, portability)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(input_problems([duplicate_key(request_type)]), none, none, [], []).
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    decide_data_subject_request([attribute(request_type, portability), attribute(processing_carried_out_by_automated_means, unsure)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(input_problems([wrong_type(processing_carried_out_by_automated_means)]), none, none, [], []).

test(the_basis_field_agrees_with_the_verdict, fail) :-
    basis_disagrees(_).
test(a_must_comply_verdict_always_cites_its_right, fail) :-
    final_without_citation(_).

cp_test_names([totality_every_subject_has_exactly_one_verdict, determinism_every_subject_has_exactly_one_basis, a_key_no_limb_reads_does_not_change_the_answer, input_problems_come_before_every_other_step, a_duplicate_key_is_an_input_problem, a_crisp_key_given_unsure_is_a_wrong_type]).
cp_test_fail_names([the_basis_field_agrees_with_the_verdict, a_must_comply_verdict_always_cites_its_right]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
