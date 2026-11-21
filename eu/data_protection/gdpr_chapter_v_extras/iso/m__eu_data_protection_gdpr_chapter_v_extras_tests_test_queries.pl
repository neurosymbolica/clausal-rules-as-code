% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_queries, [gdpr_chapter_v_extras_profile_keys/1, gdpr_chapter_v_extras_what_if/4, duty_met/0, not_barred_by_article_48/0, document_assessment_and_safeguards/0]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [gdpr_chapter_v_extras_status/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_chapter_v_extras_profile_keys(ProfileKeys),
    ProfileKeys == [transfer_relies_on_article_49_1_second_subparagraph, party_role, supervisory_authority_informed_of_transfer, data_subject_informed_of_transfer, data_subject_informed_of_compelling_legitimate_interests, assessment_documented_in_records, suitable_safeguards_documented_in_records, third_country_judgment_or_decision_requires_transfer, international_agreement_basis_for_judgment_or_decision, transfer_is_onward_transfer, onward_transfer_has_chapter_v_basis].
test(compliance_check_duty_answers_once) :-
    gdpr_chapter_v_extras_profile_for(data_subject_fully_informed, Profile),
    findall(Result - Citations, second_subparagraph_duty(Profile, inform_data_subject, Result, _, Citations), Answers),
    Answers == [duty_met - [cite(eu_reg_2016_679_art_49_1_second_subpara)]].
test(status_determination_article_48_answers_once) :-
    gdpr_chapter_v_extras_profile_for(judgment_without_international_agreement, Profile),
    findall(Result, foreign_judgment_or_decision_recognition(Profile, Result, _, _), Results),
    Results == [not_recognisable_or_enforceable].
test(facade_status_answers_once) :-
    gdpr_chapter_v_extras_profile_for(onward_transfer_without_chapter_v_basis, Profile),
    findall(Status, gdpr_chapter_v_extras_status(Profile, Status), Statuses),
    Statuses == [onward_transfer_may_not_take_place].
test(re_exported_onward_query_answers_once) :-
    gdpr_chapter_v_extras_profile_for(transfer_not_onward, Profile),
    findall(Result, onward_transfer_condition(Profile, Result, _, _), Results),
    Results == [not_an_onward_transfer].
test(what_if_makes_a_transfer_onward) :-
    gdpr_chapter_v_extras_profile_for(transfer_not_onward, Profile),
    findall(Status, gdpr_chapter_v_extras_what_if(Profile, transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none)), Status), Statuses),
    Statuses == [onward_transfer_may_take_place].
test(what_if_on_an_unread_key_changes_nothing) :-
    gdpr_chapter_v_extras_profile_for(onward_transfer_without_chapter_v_basis, Profile),
    findall(Status, gdpr_chapter_v_extras_what_if(Profile, party_role, processor, Status), Statuses),
    Statuses == [onward_transfer_may_not_take_place].
test(what_if_with_a_bad_value_gives_input_problems) :-
    gdpr_chapter_v_extras_profile_for(onward_transfer_with_chapter_v_basis, Profile),
    findall(Status, gdpr_chapter_v_extras_what_if(Profile, party_role, banana, Status), Statuses),
    Statuses == [input_problems([wrong_type(party_role)])].
test(what_if_removing_the_basis_refers) :-
    findall(Status, gdpr_chapter_v_extras_what_if([], transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none)), Status), Statuses),
    Statuses = [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_44), cite(onward_transfer_chapter_v_basis_statement)), _)].
test(re_exported_input_check_well_formed) :-
    gdpr_chapter_v_extras_profile_for(complete_transfer_file, Profile),
    findall(Problems, gdpr_chapter_v_extras_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(constructor_atoms_resolve) :-
    duty_met,
    not_barred_by_article_48,
    document_assessment_and_safeguards.

cp_test_names([profile_keys_are_the_contract_keys, compliance_check_duty_answers_once, status_determination_article_48_answers_once, facade_status_answers_once, re_exported_onward_query_answers_once, what_if_makes_a_transfer_onward, what_if_on_an_unread_key_changes_nothing, what_if_with_a_bad_value_gives_input_problems, what_if_removing_the_basis_refers, re_exported_input_check_well_formed, constructor_atoms_resolve]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
