% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_complaints_to_the_commissioner_queries, [uk_complaints_to_the_commissioner_profile_keys/1, uk_complaints_to_the_commissioner_what_if/4, complaint_under_section_164a/0, not_a_complaint_under_section_164a/0, complaint_under_section_165_2/0, not_a_complaint_under_section_165_2/0, acknowledgement_duty_does_not_apply/0]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_kernel, [uk_complaints_to_the_commissioner_input_problems/2]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_fixtures, [uk_complaints_to_the_commissioner_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    uk_complaints_to_the_commissioner_profile_keys(ProfileKeys),
    ProfileKeys == [complaint_by_data_subject_about_own_personal_data, infringement_considered, complaint_made_to_the_controller].
test(the_re_exported_input_check_answers_once) :-
    uk_complaints_to_the_commissioner_profile_for(badly_typed_profile, Profile),
    findall(Problems, uk_complaints_to_the_commissioner_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(infringement_considered), unknown_key(colour)]].
test(what_if_sending_to_the_controller_flips_to_a_complaint) :-
    what_if_answers(complaint_to_processor, complaint_made_to_the_controller, true, Statuses),
    Statuses == [complaint_under_section_164a].
test(what_if_part_4_flips_to_not_a_complaint) :-
    what_if_answers(gdpr_complaint_to_controller, infringement_considered, dpa_2018_part_4, Statuses),
    Statuses == [not_a_complaint_under_section_164a].
test(what_if_stating_the_missing_key_settles) :-
    what_if_answers(recipient_not_stated, complaint_made_to_the_controller, true, Statuses),
    Statuses == [complaint_under_section_164a].
test(what_if_replaces_every_duplicate) :-
    what_if_answers(duplicated_key_profile, infringement_considered, uk_gdpr, Statuses),
    Statuses == [complaint_under_section_164a].
test(what_if_a_bad_value_is_an_input_problem) :-
    what_if_answers(gdpr_complaint_to_controller, infringement_considered, gdpr, Statuses),
    Statuses == [input_problems([wrong_type(infringement_considered)])].
test(what_if_an_unknown_key_is_an_input_problem) :-
    what_if_answers(empty_profile, colour, red, Statuses),
    Statuses == [input_problems([unknown_key(colour)])].
test(what_if_on_a_non_list_reports_the_profile) :-
    findall(Status, uk_complaints_to_the_commissioner_what_if(nothing, infringement_considered, uk_gdpr, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(what_if_the_same_value_changes_nothing) :-
    what_if_answers(part_4_complaint_to_controller, infringement_considered, dpa_2018_part_4, Statuses),
    Statuses == [not_a_complaint_under_section_164a].
test(the_result_atoms_are_served) :-
    complaint_under_section_164a,
    not_a_complaint_under_section_164a,
    complaint_under_section_165_2,
    not_a_complaint_under_section_165_2,
    acknowledgement_duty_does_not_apply.
test(the_result_constructors_build_terms) :-
    MissingTerm = indeterminate([infringement_considered]),
    functor(MissingTerm, indeterminate, 1),
    ProblemsTerm = input_problems([wrong_type(receipt_date)]),
    functor(ProblemsTerm, input_problems, 1),
    UnknownTerm = unknown_key(colour),
    functor(UnknownTerm, unknown_key, 1),
    WrongTerm = wrong_type(profile),
    functor(WrongTerm, wrong_type, 1),
    DuplicateTerm = duplicate_key(infringement_considered),
    functor(DuplicateTerm, duplicate_key, 1).

what_if_answers(Subject, OverriddenKey, NewValue, Statuses) :-
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile),
    findall(Status, uk_complaints_to_the_commissioner_what_if(Profile, OverriddenKey, NewValue, Status), Statuses).

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_answers_once, what_if_sending_to_the_controller_flips_to_a_complaint, what_if_part_4_flips_to_not_a_complaint, what_if_stating_the_missing_key_settles, what_if_replaces_every_duplicate, what_if_a_bad_value_is_an_input_problem, what_if_an_unknown_key_is_an_input_problem, what_if_on_a_non_list_reports_the_profile, what_if_the_same_value_changes_nothing, the_result_atoms_are_served, the_result_constructors_build_terms]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
