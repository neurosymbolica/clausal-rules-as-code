% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_queries, [gdpr_chapter_v_extras_profile_keys/1, gdpr_chapter_v_extras_what_if/4, duty_met/0, not_barred_by_article_48/0, document_assessment_and_safeguards/0]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_profile_for/2]).

fixture_attested(Value, attested(Value, attestation(host_user, host_timestamp, fixture_statement, none))).

test(profile_keys_are_the_contract_keys) :-
    gdpr_chapter_v_extras_profile_keys(ProfileKeys),
    ProfileKeys == [transfer_relies_on_article_49_1_second_subparagraph, party_role, supervisory_authority_informed_of_transfer, data_subject_informed_of_transfer, data_subject_informed_of_compelling_legitimate_interests, assessment_documented_in_records, suitable_safeguards_documented_in_records, third_country_judgment_or_decision_requires_transfer, international_agreement_basis_for_judgment_or_decision, transfer_is_onward_transfer, onward_transfer_has_chapter_v_basis].
test(the_re_exported_input_check_names_a_wrong_type) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(party_role, owner)], Problems), Answers),
    Answers == [[wrong_type(party_role)]].
test(a_what_if_documenting_the_safeguards_clears_the_breach) :-
    gdpr_chapter_v_extras_profile_for(controller_safeguards_not_documented, Profile),
    findall(Status, gdpr_chapter_v_extras_what_if(Profile, suitable_safeguards_documented_in_records, true, Status), Statuses),
    Statuses == [no_condition_breached].
test(a_what_if_undocumenting_the_safeguards_breaches) :-
    gdpr_chapter_v_extras_profile_for(controller_all_duties_met, Profile),
    gdpr_chapter_v_extras_what_if(Profile, suitable_safeguards_documented_in_records, false, condition_breached).
test(a_what_if_naming_the_controller_settles_the_status) :-
    gdpr_chapter_v_extras_profile_for(party_role_unstated, Profile),
    gdpr_chapter_v_extras_what_if(Profile, party_role, controller, no_condition_breached).
test(a_what_if_to_processor_lifts_the_duty_to_inform) :-
    gdpr_chapter_v_extras_profile_for(controller_supervisory_authority_not_informed, Profile),
    gdpr_chapter_v_extras_what_if(Profile, party_role, processor, no_condition_breached).
test(a_what_if_removing_the_onward_basis_breaches) :-
    gdpr_chapter_v_extras_profile_for(onward_transfer_with_basis, Profile),
    fixture_attested(false, Statement),
    gdpr_chapter_v_extras_what_if(Profile, onward_transfer_has_chapter_v_basis, Statement, condition_breached).
test(a_what_if_adding_an_agreement_lifts_the_article_48_bar) :-
    gdpr_chapter_v_extras_profile_for(foreign_judgment_without_agreement, Profile),
    fixture_attested(true, Statement),
    gdpr_chapter_v_extras_what_if(Profile, international_agreement_basis_for_judgment_or_decision, Statement, no_condition_breached).
test(a_what_if_on_a_key_outside_the_contract_is_an_input_problem) :-
    gdpr_chapter_v_extras_what_if([], colour, blue, input_problems([unknown_key(colour)])).
test(the_root_export_atoms_resolve) :-
    duty_met,
    not_barred_by_article_48,
    document_assessment_and_safeguards.

test(a_what_if_adding_an_agreement_is_not_a_breach, fail) :-
    gdpr_chapter_v_extras_profile_for(foreign_judgment_without_agreement, Profile),
    fixture_attested(true, Statement),
    gdpr_chapter_v_extras_what_if(Profile, international_agreement_basis_for_judgment_or_decision, Statement, condition_breached).

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_names_a_wrong_type, a_what_if_documenting_the_safeguards_clears_the_breach, a_what_if_undocumenting_the_safeguards_breaches, a_what_if_naming_the_controller_settles_the_status, a_what_if_to_processor_lifts_the_duty_to_inform, a_what_if_removing_the_onward_basis_breaches, a_what_if_adding_an_agreement_lifts_the_article_48_bar, a_what_if_on_a_key_outside_the_contract_is_an_input_problem, the_root_export_atoms_resolve]).
cp_test_fail_names([a_what_if_adding_an_agreement_is_not_a_breach]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
