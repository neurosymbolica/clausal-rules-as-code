% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, gdpr_art36_3_consultation_request_status/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_profile_for/2]).

sole_controller_statement(attested(false, attestation(privacy_counsel, attestation_moment, role_review, none))).

joint_controllers_statement(attested(true, attestation(privacy_counsel, attestation_moment, role_review, none))).

seven_citations([cite(eu_reg_2016_679_art_36_3), cite(eu_reg_2016_679_art_36_3_a), cite(eu_reg_2016_679_art_36_3_b), cite(eu_reg_2016_679_art_36_3_c), cite(eu_reg_2016_679_art_36_3_d), cite(eu_reg_2016_679_art_36_3_e), cite(eu_reg_2016_679_art_36_3_f)]).

roles_referral(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])])).

test(complete_holds_with_every_output_bound) :-
    gdpr_art36_3_consultation_request_profile_for(complete_sole_controller, Profile),
    sole_controller_statement(Statement),
    seven_citations(Citations),
    consultation_request_status(Profile, consultation_request_complete, [outside_fact(joint_controllers_or_processors_involved, Statement)], Citations).
test(incomplete_holds_with_every_output_bound) :-
    gdpr_art36_3_consultation_request_profile_for(joint_controllers_responsibilities_missing, Profile),
    joint_controllers_statement(Statement),
    seven_citations(Citations),
    consultation_request_status(Profile, consultation_request_incomplete, [outside_fact(joint_controllers_or_processors_involved, Statement)], Citations).
test(not_governed_holds_with_every_output_bound) :-
    gdpr_art36_3_consultation_request_profile_for(member_state_law_consultation, Profile),
    consultation_request_status(Profile, not_governed_by_article_36_3, [], [cite(eu_reg_2016_679_art_36_3)]).
test(not_governed_items_hold_with_every_output_bound) :-
    gdpr_art36_3_consultation_request_profile_for(member_state_law_consultation, Profile),
    missing_consultation_request_items(Profile, not_governed_by_article_36_3, [], [cite(eu_reg_2016_679_art_36_3)]).
test(unstated_footing_holds_bound) :-
    gdpr_art36_3_consultation_request_profile_for(consultation_footing_unstated, Profile),
    consultation_request_status(Profile, indeterminate([consultation_under_article_36_1]), [], []).
test(referral_holds_bound) :-
    gdpr_art36_3_consultation_request_profile_for(roles_unattested_referral, Profile),
    roles_referral(Referral),
    consultation_request_status(Profile, Referral, [], []),
    missing_consultation_request_items(Profile, Referral, [], []).
test(designation_question_holds_bound) :-
    gdpr_art36_3_consultation_request_profile_for(officer_designation_unknown, Profile),
    consultation_request_status(Profile, indeterminate([data_protection_officer_designated]), [], []).
test(missing_items_hold_bound) :-
    gdpr_art36_3_consultation_request_profile_for(officer_contact_details_missing, Profile),
    seven_citations(Citations),
    missing_consultation_request_items(Profile, [data_protection_officer_contact_details], [], Citations).
test(status_projection_holds_bound) :-
    gdpr_art36_3_consultation_request_profile_for(other_information_missing, Profile),
    gdpr_art36_3_consultation_request_status(Profile, consultation_request_incomplete).
test(an_atom_profile_is_wrong_type_for_items) :-
    missing_consultation_request_items(profile, Items, Basis, Citations),
    Items == input_problems([wrong_type(profile)]),
    Basis == [],
    Citations == [].
test(a_number_key_is_unknown) :-
    consultation_request_status([attribute(42, true)], Result, _, _),
    Result == input_problems([unknown_key(42)]).
test(a_repeated_key_is_a_duplicate) :-
    consultation_request_status([attribute(consultation_under_article_36_1, true), attribute(consultation_under_article_36_1, true)], Result, _, _),
    Result == input_problems([duplicate_key(consultation_under_article_36_1)]).
test(an_attested_crisp_key_is_refused) :-
    gdpr_art36_3_consultation_request_profile_for(malformed_attested_crisp_key, Profile),
    gdpr_art36_3_consultation_request_input_problems(Profile, [wrong_type(purposes_and_means_provided)]).
test(a_well_formed_fixture_has_no_problem_bound) :-
    gdpr_art36_3_consultation_request_profile_for(complete_joint_controllers, Profile),
    gdpr_art36_3_consultation_request_input_problems(Profile, []).

test(complete_rejects_incomplete_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(complete_sole_controller, Profile),
    consultation_request_status(Profile, consultation_request_incomplete, _, _).
test(complete_rejects_an_empty_basis_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(complete_sole_controller, Profile),
    consultation_request_status(Profile, consultation_request_complete, [], _).
test(incomplete_rejects_complete_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(joint_controllers_responsibilities_missing, Profile),
    consultation_request_status(Profile, consultation_request_complete, _, _).
test(not_governed_rejects_complete_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(member_state_law_consultation, Profile),
    consultation_request_status(Profile, consultation_request_complete, _, _).
test(referral_rejects_complete_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(roles_unattested_referral, Profile),
    consultation_request_status(Profile, consultation_request_complete, _, _).
test(missing_items_reject_an_empty_list_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(officer_contact_details_missing, Profile),
    missing_consultation_request_items(Profile, [], _, _).
test(a_malformed_profile_gets_no_verdict, fail) :-
    gdpr_art36_3_consultation_request_profile_for(malformed_attested_crisp_key, Profile),
    consultation_request_status(Profile, consultation_request_complete, _, _).

cp_test_names([complete_holds_with_every_output_bound, incomplete_holds_with_every_output_bound, not_governed_holds_with_every_output_bound, not_governed_items_hold_with_every_output_bound, unstated_footing_holds_bound, referral_holds_bound, designation_question_holds_bound, missing_items_hold_bound, status_projection_holds_bound, an_atom_profile_is_wrong_type_for_items, a_number_key_is_unknown, a_repeated_key_is_a_duplicate, an_attested_crisp_key_is_refused, a_well_formed_fixture_has_no_problem_bound]).
cp_test_fail_names([complete_rejects_incomplete_bound, complete_rejects_an_empty_basis_bound, incomplete_rejects_complete_bound, not_governed_rejects_complete_bound, referral_rejects_complete_bound, missing_items_reject_an_empty_list_bound, a_malformed_profile_gets_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
