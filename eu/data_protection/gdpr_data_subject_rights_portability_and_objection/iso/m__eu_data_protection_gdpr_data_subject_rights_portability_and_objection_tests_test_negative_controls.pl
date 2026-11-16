% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_queries, [decide_data_subject_request/2, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_fixtures, [gdpr_data_subject_rights_portability_and_objection_profile_for/2]).

comply_of(Subject, Comply) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(Subject, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(Comply, _, _, _, _)).

exception_of(Subject, Exception) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(Subject, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(_, _, Exception, _, _)).

test(portability_engaged_must_comply) :-
    comply_of(portability_positive, must_comply).
test(portability_not_automated_need_not_comply) :-
    comply_of(portability_not_automated, need_not_comply).
test(public_task_relieves) :-
    exception_of(portability_public_task, art20_3_public_task).
test(public_task_false_must_comply) :-
    comply_of(portability_public_task_false, must_comply).
test(rights_of_others_relieves) :-
    exception_of(portability_rights_of_others, art20_4_rights_of_others).
test(rights_of_others_false_must_comply) :-
    comply_of(portability_rights_of_others_false, must_comply).
test(unconfirmed_identity_suspends) :-
    comply_of(portability_suspended, suspended(art12_6_identity_not_confirmed)).
test(confirmed_identity_must_comply) :-
    comply_of(portability_identity_confirmed, must_comply).
test(absent_key_is_indeterminate) :-
    comply_of(portability_missing_key, indeterminate([personal_data_provided_by_data_subject])).
test(unsure_judgement_refers) :-
    comply_of(portability_public_task_unsure, needs_legal_review(open_textured(processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_20_3)), _)).
test(unable_to_identify_relieves) :-
    exception_of(portability_unable_to_identify, art12_2_unable_to_identify).
test(attested_restriction_relieves) :-
    exception_of(portability_restriction_attested, art23_legislative_restriction).
test(denied_restriction_must_comply) :-
    comply_of(portability_restriction_denied, must_comply).
test(art21_1_engaged_must_comply) :-
    comply_of(objection_art21_1_positive, must_comply).
test(art21_1_not_art6_e_f_need_not_comply) :-
    comply_of(objection_art21_1_not_art6_e_f, need_not_comply).
test(art21_1_compelling_grounds_relieve) :-
    exception_of(objection_art21_1_compelling, art21_1_compelling_legitimate_grounds).
test(art21_1_legal_claims_relieve) :-
    exception_of(objection_art21_1_legal_claims, art21_1_legal_claims).
test(art21_1_no_grounds_must_comply) :-
    comply_of(objection_art21_1_compelling_false, must_comply).
test(art21_2_marketing_must_comply) :-
    comply_of(objection_art21_2_positive, must_comply).
test(art21_2_not_marketing_need_not_comply) :-
    comply_of(objection_art21_2_not_marketing, need_not_comply).
test(art21_2_excessive_relieves) :-
    exception_of(objection_art21_2_excessive, art12_5_manifestly_unfounded_or_excessive).
test(art21_2_not_excessive_must_comply) :-
    comply_of(objection_art21_2_not_excessive, must_comply).
test(art21_6_engaged_must_comply) :-
    comply_of(objection_art21_6_positive, must_comply).
test(art21_6_not_research_need_not_comply) :-
    comply_of(objection_art21_6_not_research, need_not_comply).
test(art21_6_public_task_relieves) :-
    exception_of(objection_art21_6_public_task, art21_6_public_interest_task).
test(missing_ground_is_indeterminate) :-
    comply_of(objection_missing_ground, indeterminate([objection_ground_claimed])).
test(input_problem_is_reported) :-
    comply_of(unknown_key_problem, input_problems([unknown_key(no_such_key)])).
test(absent_request_type_is_indeterminate) :-
    comply_of(absent_request_type, indeterminate([request_type])).

test(portability_not_automated_is_not_must_comply, fail) :-
    comply_of(portability_not_automated, must_comply).
test(public_task_false_is_not_the_exception, fail) :-
    exception_of(portability_public_task_false, art20_3_public_task).
test(rights_of_others_false_is_not_the_exception, fail) :-
    exception_of(portability_rights_of_others_false, art20_4_rights_of_others).
test(confirmed_identity_is_not_suspended, fail) :-
    comply_of(portability_identity_confirmed, suspended(_)).
test(complete_profile_is_not_indeterminate, fail) :-
    comply_of(portability_positive, indeterminate(_)).
test(false_judgement_does_not_refer, fail) :-
    comply_of(portability_public_task_false, needs_legal_review(_, _)).
test(without_the_demonstration_no_relief, fail) :-
    exception_of(portability_positive, art12_2_unable_to_identify).
test(denied_restriction_is_not_the_exception, fail) :-
    exception_of(portability_restriction_denied, art23_legislative_restriction).
test(art21_1_not_art6_e_f_is_not_must_comply, fail) :-
    comply_of(objection_art21_1_not_art6_e_f, must_comply).
test(art21_1_no_grounds_is_not_relieved, fail) :-
    exception_of(objection_art21_1_compelling_false, art21_1_compelling_legitimate_grounds).
test(art21_2_not_marketing_is_not_must_comply, fail) :-
    comply_of(objection_art21_2_not_marketing, must_comply).
test(art21_2_not_excessive_is_not_relieved, fail) :-
    exception_of(objection_art21_2_not_excessive, art12_5_manifestly_unfounded_or_excessive).
test(art21_6_not_research_is_not_must_comply, fail) :-
    comply_of(objection_art21_6_not_research, must_comply).
test(art21_6_engaged_is_not_relieved, fail) :-
    exception_of(objection_art21_6_positive, art21_6_public_interest_task).
test(a_given_ground_is_not_indeterminate, fail) :-
    comply_of(objection_art21_2_positive, indeterminate(_)).
test(input_problem_is_not_must_comply, fail) :-
    comply_of(unknown_key_problem, must_comply).
test(absent_request_type_is_not_need_not_comply, fail) :-
    comply_of(absent_request_type, need_not_comply).

cp_test_names([portability_engaged_must_comply, portability_not_automated_need_not_comply, public_task_relieves, public_task_false_must_comply, rights_of_others_relieves, rights_of_others_false_must_comply, unconfirmed_identity_suspends, confirmed_identity_must_comply, absent_key_is_indeterminate, unsure_judgement_refers, unable_to_identify_relieves, attested_restriction_relieves, denied_restriction_must_comply, art21_1_engaged_must_comply, art21_1_not_art6_e_f_need_not_comply, art21_1_compelling_grounds_relieve, art21_1_legal_claims_relieve, art21_1_no_grounds_must_comply, art21_2_marketing_must_comply, art21_2_not_marketing_need_not_comply, art21_2_excessive_relieves, art21_2_not_excessive_must_comply, art21_6_engaged_must_comply, art21_6_not_research_need_not_comply, art21_6_public_task_relieves, missing_ground_is_indeterminate, input_problem_is_reported, absent_request_type_is_indeterminate]).
cp_test_fail_names([portability_not_automated_is_not_must_comply, public_task_false_is_not_the_exception, rights_of_others_false_is_not_the_exception, confirmed_identity_is_not_suspended, complete_profile_is_not_indeterminate, false_judgement_does_not_refer, without_the_demonstration_no_relief, denied_restriction_is_not_the_exception, art21_1_not_art6_e_f_is_not_must_comply, art21_1_no_grounds_is_not_relieved, art21_2_not_marketing_is_not_must_comply, art21_2_not_excessive_is_not_relieved, art21_6_not_research_is_not_must_comply, art21_6_engaged_is_not_relieved, a_given_ground_is_not_indeterminate, input_problem_is_not_must_comply, absent_request_type_is_not_need_not_comply]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
