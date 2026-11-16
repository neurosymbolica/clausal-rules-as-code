% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [cooperation_duty/4, decide_gdpr_cooperation_with_the_supervisory_authority/2, gdpr_cooperation_with_the_supervisory_authority_status/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_profile_for/2]).

subject_statuses(Subject, Statuses) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    findall(Status, gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status), Statuses).

subject_answers(Subject, Answers) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    findall(answer(Result, Basis, Citations), cooperation_duty(Profile, Result, Basis, Citations), Answers).

test(wrong_type_reads_out_once) :-
    subject_answers(wrong_type_role_key, Answers),
    Answers == [answer(input_problems([wrong_type(acts_as_controller)]), [], [])].
test(duplicate_reads_out_once) :-
    subject_answers(duplicate_role_key, Answers),
    Answers == [answer(input_problems([duplicate_key(acts_as_controller)]), [], [])].
test(unknown_key_is_named_once) :-
    subject_answers(unknown_key_given, Answers),
    Answers == [answer(input_problems([unknown_key(as_of_date)]), [], [])].
test(no_request_reads_out_once) :-
    subject_answers(no_request_made, Answers),
    Answers == [answer(cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)])].
test(outside_tasks_reads_out_once) :-
    subject_statuses(request_outside_authority_tasks, Statuses),
    Statuses == [cooperation_not_required].
test(not_bound_reads_out_once) :-
    subject_statuses(caller_not_bound, Statuses),
    Statuses == [cooperation_not_required].
test(the_first_missing_key_alone_is_named) :-
    cooperation_duty([], Result, Basis, Citations),
    Result == indeterminate([acts_as_controller]),
    Basis == [],
    Citations == [].
test(a_bound_caller_names_the_request_key) :-
    subject_answers(request_key_missing, Answers),
    Answers == [answer(indeterminate([authority_request_made]), [], [])].
test(the_referral_reads_out_once) :-
    subject_answers(unsure_and_statement_absent, Answers),
    Answers == [answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure, cooperation_given - absent])]), [], [])].
test(the_open_textured_referral_reads_out_once) :-
    subject_answers(unsure_and_statement_given, Answers),
    Answers == [answer(needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]), [], [])].
test(the_met_basis_copies_the_statement) :-
    subject_answers(tasks_judgement_true, Answers),
    Answers == [answer(cooperation_met, [outside_fact(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, url(address_seven, retrieved_2026_11_12))))], [cite(eu_reg_2016_679_art_31)])].
test(the_not_met_basis_copies_the_statement) :-
    subject_answers(cooperation_statement_attested_false, Answers),
    Answers == [answer(cooperation_not_met, [outside_fact(cooperation_given, attested(false, attestation(compliance_desk, received_2026_11_12, no_reply_sent, document(upload_seven, digest_seven))))], [cite(eu_reg_2016_679_art_31)])].
test(the_verdict_carries_a_citation) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(request_made_and_cooperated, Profile),
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations)),
    Status == cooperation_met,
    Citations == [cite(eu_reg_2016_679_art_31)].

cp_test_names([wrong_type_reads_out_once, duplicate_reads_out_once, unknown_key_is_named_once, no_request_reads_out_once, outside_tasks_reads_out_once, not_bound_reads_out_once, the_first_missing_key_alone_is_named, a_bound_caller_names_the_request_key, the_referral_reads_out_once, the_open_textured_referral_reads_out_once, the_met_basis_copies_the_statement, the_not_met_basis_copies_the_statement, the_verdict_carries_a_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
