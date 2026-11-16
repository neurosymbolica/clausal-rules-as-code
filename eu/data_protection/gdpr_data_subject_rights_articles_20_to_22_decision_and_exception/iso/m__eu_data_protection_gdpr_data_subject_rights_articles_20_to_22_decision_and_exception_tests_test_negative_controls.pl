% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_queries, [request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_exception_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

comply_of(Subject, Comply) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile),
    request_decision(Profile, Comply).

exception_of(Subject, Exception) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile),
    request_exception(Profile, Exception).

test(exception_atoms_are_real_values) :-
    request_exception_status_values(Values),
    member(art20_4_rights_of_others, Values),
    member(art22_2_b, Values),
    member(art23_legislative_restriction, Values).
test(portability_engaged_complies) :-
    comply_of(portability_engaged, must_comply).
test(portability_not_automated_is_relieved) :-
    comply_of(portability_not_automated, need_not_comply).
test(public_task_relieves) :-
    exception_of(portability_public_task, art20_3_public_task).
test(public_task_denied_complies) :-
    comply_of(portability_public_task_denied, must_comply).
test(rights_of_others_relieves) :-
    exception_of(portability_rights_of_others, art20_4_rights_of_others).
test(rights_of_others_denied_complies) :-
    comply_of(portability_rights_of_others_denied, must_comply).
test(manifestly_excessive_relieves) :-
    exception_of(portability_manifestly_excessive, art12_5_manifestly_unfounded_or_excessive).
test(manifestly_excessive_denied_complies) :-
    comply_of(portability_manifestly_excessive_denied, must_comply).
test(unable_to_identify_relieves) :-
    exception_of(portability_unable_to_identify, art12_2_unable_to_identify).
test(unable_to_identify_denied_complies) :-
    comply_of(portability_unable_to_identify_denied, must_comply).
test(restriction_relieves) :-
    exception_of(portability_restricted_by_law, art23_legislative_restriction).
test(restriction_denied_complies) :-
    comply_of(portability_restriction_denied, must_comply).
test(identity_unconfirmed_suspends) :-
    comply_of(portability_identity_unconfirmed, suspended(art12_6_identity_not_confirmed)).
test(identity_confirmed_complies) :-
    comply_of(portability_identity_confirmed, must_comply).
test(art21_1_engaged_complies) :-
    comply_of(objection_art21_1_engaged, must_comply).
test(art21_1_not_particular_flips) :-
    comply_of(objection_art21_1_not_particular, need_not_comply).
test(art21_1_compelling_relieves) :-
    exception_of(objection_art21_1_compelling, art21_1_compelling_legitimate_grounds).
test(art21_1_compelling_denied_complies) :-
    comply_of(objection_art21_1_compelling_denied, must_comply).
test(art21_1_legal_claims_relieves) :-
    exception_of(objection_art21_1_legal_claims, art21_1_legal_claims).
test(art21_2_engaged_complies) :-
    comply_of(objection_art21_2_engaged, must_comply).
test(art21_2_not_marketing_flips) :-
    comply_of(objection_art21_2_not_marketing, need_not_comply).
test(art21_6_engaged_complies) :-
    comply_of(objection_art21_6_engaged, must_comply).
test(art21_6_not_research_flips) :-
    comply_of(objection_art21_6_not_research, need_not_comply).
test(art21_6_public_interest_relieves) :-
    exception_of(objection_art21_6_public_interest, art21_6_public_interest_task).
test(art21_6_public_interest_denied_complies) :-
    comply_of(objection_art21_6_public_interest_denied, must_comply).
test(art22_engaged_complies) :-
    comply_of(automated_engaged, must_comply).
test(art22_not_solely_flips) :-
    comply_of(automated_not_solely, need_not_comply).
test(art22_contract_relieves) :-
    exception_of(automated_contract, art22_2_a).
test(art22_contract_denied_complies) :-
    comply_of(automated_contract_denied, must_comply).
test(art22_law_relieves) :-
    exception_of(automated_law_authorised, art22_2_b).
test(art22_law_not_authorised_complies) :-
    comply_of(automated_law_not_authorised, must_comply).
test(art22_consent_relieves) :-
    exception_of(automated_consent, art22_2_c).
test(art22_consent_special_bar_removes_relief) :-
    comply_of(automated_consent_special_bar, must_comply).
test(art22_consent_special_safeguarded_relieves) :-
    exception_of(automated_consent_special_safeguarded, art22_2_c).
test(missing_request_type_is_indeterminate) :-
    comply_of(no_request_type, indeterminate([request_type])).
test(missing_ground_is_indeterminate) :-
    comply_of(objection_missing_ground, indeterminate([objection_ground_claimed])).

test(portability_not_automated_flips, fail) :-
    comply_of(portability_not_automated, must_comply).
test(public_task_denied_has_no_exception, fail) :-
    exception_of(portability_public_task_denied, art20_3_public_task).
test(rights_of_others_denied_has_no_exception, fail) :-
    exception_of(portability_rights_of_others_denied, art20_4_rights_of_others).
test(manifestly_excessive_denied_has_no_exception, fail) :-
    exception_of(portability_manifestly_excessive_denied, art12_5_manifestly_unfounded_or_excessive).
test(unable_to_identify_denied_has_no_exception, fail) :-
    exception_of(portability_unable_to_identify_denied, art12_2_unable_to_identify).
test(restriction_denied_has_no_exception, fail) :-
    exception_of(portability_restriction_denied, art23_legislative_restriction).
test(identity_confirmed_is_not_suspended, fail) :-
    comply_of(portability_identity_confirmed, suspended(art12_6_identity_not_confirmed)).
test(art21_1_not_particular_not_must_comply, fail) :-
    comply_of(objection_art21_1_not_particular, must_comply).
test(art21_1_legal_claims_not_when_absent, fail) :-
    exception_of(objection_art21_1_engaged, art21_1_legal_claims).
test(art21_2_not_marketing_not_must_comply, fail) :-
    comply_of(objection_art21_2_not_marketing, must_comply).
test(art21_6_public_interest_denied_has_no_exception, fail) :-
    exception_of(objection_art21_6_public_interest_denied, art21_6_public_interest_task).
test(art22_not_solely_not_must_comply, fail) :-
    comply_of(automated_not_solely, must_comply).
test(art22_contract_denied_has_no_exception, fail) :-
    exception_of(automated_contract_denied, art22_2_a).
test(art22_law_not_authorised_has_no_exception, fail) :-
    exception_of(automated_law_not_authorised, art22_2_b).
test(art22_consent_special_bar_has_no_exception, fail) :-
    exception_of(automated_consent_special_bar, art22_2_c).
test(request_type_present_is_not_missing, fail) :-
    comply_of(portability_engaged, indeterminate([request_type])).
test(ground_present_is_not_missing, fail) :-
    comply_of(objection_art21_2_engaged, indeterminate([objection_ground_claimed])).

cp_test_names([exception_atoms_are_real_values, portability_engaged_complies, portability_not_automated_is_relieved, public_task_relieves, public_task_denied_complies, rights_of_others_relieves, rights_of_others_denied_complies, manifestly_excessive_relieves, manifestly_excessive_denied_complies, unable_to_identify_relieves, unable_to_identify_denied_complies, restriction_relieves, restriction_denied_complies, identity_unconfirmed_suspends, identity_confirmed_complies, art21_1_engaged_complies, art21_1_not_particular_flips, art21_1_compelling_relieves, art21_1_compelling_denied_complies, art21_1_legal_claims_relieves, art21_2_engaged_complies, art21_2_not_marketing_flips, art21_6_engaged_complies, art21_6_not_research_flips, art21_6_public_interest_relieves, art21_6_public_interest_denied_complies, art22_engaged_complies, art22_not_solely_flips, art22_contract_relieves, art22_contract_denied_complies, art22_law_relieves, art22_law_not_authorised_complies, art22_consent_relieves, art22_consent_special_bar_removes_relief, art22_consent_special_safeguarded_relieves, missing_request_type_is_indeterminate, missing_ground_is_indeterminate]).
cp_test_fail_names([portability_not_automated_flips, public_task_denied_has_no_exception, rights_of_others_denied_has_no_exception, manifestly_excessive_denied_has_no_exception, unable_to_identify_denied_has_no_exception, restriction_denied_has_no_exception, identity_confirmed_is_not_suspended, art21_1_not_particular_not_must_comply, art21_1_legal_claims_not_when_absent, art21_2_not_marketing_not_must_comply, art21_6_public_interest_denied_has_no_exception, art22_not_solely_not_must_comply, art22_contract_denied_has_no_exception, art22_law_not_authorised_has_no_exception, art22_consent_special_bar_has_no_exception, request_type_present_is_not_missing, ground_present_is_not_missing]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
