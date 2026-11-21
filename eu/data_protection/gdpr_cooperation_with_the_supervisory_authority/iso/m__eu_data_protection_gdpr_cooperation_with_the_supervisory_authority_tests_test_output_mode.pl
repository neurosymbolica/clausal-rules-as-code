% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [cooperation_duty/4, decide_gdpr_cooperation_with_the_supervisory_authority/2, gdpr_cooperation_with_the_supervisory_authority_status/2, gdpr_cooperation_with_the_supervisory_authority_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_profile_for/2]).

expected_status(controller_cooperated, cooperation_met).
expected_status(controller_refused, cooperation_not_met).
expected_status(representative_cooperated, cooperation_met).
expected_status(not_bound, cooperation_not_required).
expected_status(no_request, cooperation_not_required).
expected_status(no_request_roles_absent, cooperation_not_required).
expected_status(request_inside_tasks, cooperation_met).
expected_status(request_outside_tasks, cooperation_not_required).
expected_status(role_unknown, indeterminate([acts_as_controller])).
expected_status(role_stated_false, cooperation_not_required).
expected_status(two_keys_missing, indeterminate([authority_request_made])).
expected_status(statement_missing_true, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])])).
expected_status(statement_missing_unsure, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure, cooperation_given - absent])])).
expected_status(judgement_unsure, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])])).
expected_status(duplicate_and_unknown, input_problems([duplicate_key(acts_as_controller), unknown_key(colour)])).
expected_status(wrong_types, input_problems([wrong_type(acts_as_processor), wrong_type(cooperation_given)])).

observed_statuses(Subject, Statuses) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    findall(Status, gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status), Statuses).

test(every_subject_yields_exactly_its_status) :-
    findall(Subject - Statuses, (expected_status(Subject, _), observed_statuses(Subject, Statuses)), Observed),
    findall(Subject - [Status], expected_status(Subject, Status), Expected),
    Observed == Expected.
test(the_status_table_is_the_three_final_atoms) :-
    gdpr_cooperation_with_the_supervisory_authority_status_values(StatusValues),
    StatusValues == [cooperation_not_required, cooperation_met, cooperation_not_met].
test(the_met_answer_copies_the_attested_statement) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(representative_cooperated, Profile),
    member(attribute(cooperation_given, Statement), Profile),
    findall(Result - Basis - Citations, cooperation_duty(Profile, Result, Basis, Citations), Answers),
    Answers == [cooperation_met - [outside_fact(cooperation_given, Statement)] - [cite(eu_reg_2016_679_art_31)]].
test(the_not_met_answer_copies_the_attested_statement) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_refused, Profile),
    member(attribute(cooperation_given, Statement), Profile),
    findall(Result - Basis - Citations, cooperation_duty(Profile, Result, Basis, Citations), Answers),
    Answers == [cooperation_not_met - [outside_fact(cooperation_given, Statement)] - [cite(eu_reg_2016_679_art_31)]].
test(the_not_required_answer_has_an_empty_basis) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(request_outside_tasks, Profile),
    findall(Result - Basis - Citations, cooperation_duty(Profile, Result, Basis, Citations), Answers),
    Answers == [cooperation_not_required - [] - [cite(eu_reg_2016_679_art_31)]].
test(a_referral_carries_no_basis_and_no_citation) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(statement_missing_unsure, Profile),
    findall(Basis - Citations, cooperation_duty(Profile, _, Basis, Citations), Answers),
    Answers == [[] - []].
test(the_verdict_of_a_final_answer_carries_a_citation) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, gdpr_cooperation_with_the_supervisory_authority_verdict(cooperation_met, [cite(eu_reg_2016_679_art_31)])).
test(the_verdict_of_an_input_problem_carries_no_citation) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(wrong_types, Profile),
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, gdpr_cooperation_with_the_supervisory_authority_verdict(input_problems(_), [])).
test(an_empty_profile_names_only_the_first_role_key) :-
    findall(Result, cooperation_duty([], Result, _, _), Results),
    Results == [indeterminate([acts_as_controller])].
test(a_bound_caller_missing_the_judgement_names_it) :-
    findall(Result, cooperation_duty([attribute(acts_as_processor, true), attribute(authority_request_made, true)], Result, _, _), Results),
    Results == [indeterminate([request_is_in_performance_of_authority_tasks])].
test(a_true_role_makes_the_other_role_keys_unneeded) :-
    findall(Result, cooperation_duty([attribute(acts_as_representative_of_controller_or_processor, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true), attribute(cooperation_given, attested(true, attestation(host, at_time, reason, none)))], Result, _, _), Results),
    Results == [cooperation_met].

cp_test_names([every_subject_yields_exactly_its_status, the_status_table_is_the_three_final_atoms, the_met_answer_copies_the_attested_statement, the_not_met_answer_copies_the_attested_statement, the_not_required_answer_has_an_empty_basis, a_referral_carries_no_basis_and_no_citation, the_verdict_of_a_final_answer_carries_a_citation, the_verdict_of_an_input_problem_carries_no_citation, an_empty_profile_names_only_the_first_role_key, a_bound_caller_missing_the_judgement_names_it, a_true_role_makes_the_other_role_keys_unneeded]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
