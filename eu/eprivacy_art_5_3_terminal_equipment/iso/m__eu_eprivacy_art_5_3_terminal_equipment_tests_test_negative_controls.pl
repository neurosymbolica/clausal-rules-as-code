% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_eprivacy_art_5_3_terminal_equipment, [terminal_equipment_storage_or_access_permitted/3, eprivacy_art_5_3_terminal_equipment_status_values/1]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_fixtures, [eprivacy_art_5_3_terminal_equipment_profile_for/2]).

subject_result(Subject, Result) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(Subject, Profile),
    terminal_equipment_storage_or_access_permitted(Profile, Result, _Citations).

test(permitted_is_a_real_verdict_atom) :-
    eprivacy_art_5_3_terminal_equipment_status_values(StatusValues),
    member(permitted, StatusValues).
test(not_permitted_is_a_real_verdict_atom) :-
    eprivacy_art_5_3_terminal_equipment_status_values(StatusValues),
    member(not_permitted, StatusValues).
test(not_applicable_is_a_real_verdict_atom) :-
    eprivacy_art_5_3_terminal_equipment_status_values(StatusValues),
    member(not_applicable, StatusValues).
test(attested_scope_is_an_input_problem) :-
    subject_result(attested_value, input_problems([wrong_type(storage_or_access_in_terminal_equipment)])).
test(bare_scope_asks_for_transmission) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true)], indeterminate([storage_or_access_solely_for_transmission]), []).
test(absent_scope_asks_for_the_scope) :-
    subject_result(empty_profile, indeterminate([storage_or_access_in_terminal_equipment])).
test(scope_false_is_not_applicable) :-
    subject_result(out_of_scope, not_applicable).
test(transmission_way_permits) :-
    subject_result(transmission_only, permitted).
test(transmission_false_asks_for_the_request) :-
    subject_result(transmission_failed_alone, indeterminate([service_explicitly_requested_by_user])).
test(requested_and_strictly_necessary_permits) :-
    subject_result(requested_and_strictly_necessary, permitted).
test(not_strictly_necessary_is_not_permitted) :-
    subject_result(requested_but_not_strictly_necessary, not_permitted).
test(informed_consent_permits) :-
    subject_result(informed_consent, permitted).
test(consent_without_information_is_not_permitted) :-
    subject_result(consent_without_information, not_permitted).
test(three_failed_ways_are_not_permitted) :-
    subject_result(all_ways_failed, not_permitted).
test(transmission_true_restores_permission) :-
    subject_result(transmission_restores_permission, permitted).
test(scope_unsure_with_a_met_way_is_referred) :-
    subject_result(scope_unsure_settled_permitted, needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), _Context)).
test(fewest_unresolved_way_names_its_key) :-
    subject_result(fewest_unresolved_first, indeterminate([strictly_necessary_to_provide_requested_service])).
test(strictly_necessary_given_permits) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(service_explicitly_requested_by_user, true), attribute(strictly_necessary_to_provide_requested_service, true)], permitted, [cite(eu_dir_2002_58_art_5_3)]).
test(missing_key_beats_an_unsure_judgement) :-
    subject_result(unsure_open_way_skipped_for_missing, indeterminate([service_explicitly_requested_by_user])).
test(unsure_transmission_is_referred) :-
    subject_result(transmission_unsure_referred, needs_legal_review(open_textured(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)), _Context)).
test(unsure_consent_cites_article_2_f) :-
    subject_result(consent_unsure_referred, needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_2_f)), _Context)).
test(full_referral_row_refers_transmission_first) :-
    subject_result(full_referral_row, needs_legal_review(open_textured(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)), _Context)).
test(full_row_with_transmission_met_permits) :-
    subject_result(full_row_transmission_met, permitted).

test(bare_scope_is_not_an_input_problem, fail) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true)], input_problems(_Problems), _Citations).
test(present_scope_does_not_ask_for_the_scope, fail) :-
    subject_result(scope_only, indeterminate([storage_or_access_in_terminal_equipment])).
test(scope_true_is_not_not_applicable, fail) :-
    subject_result(scope_only, not_applicable).
test(transmission_false_does_not_permit, fail) :-
    subject_result(transmission_failed_alone, permitted).
test(not_strictly_necessary_does_not_permit, fail) :-
    subject_result(requested_but_not_strictly_necessary, permitted).
test(consent_without_information_does_not_permit, fail) :-
    subject_result(consent_without_information, permitted).
test(transmission_true_is_not_not_permitted, fail) :-
    subject_result(transmission_restores_permission, not_permitted).
test(scope_unsure_with_a_met_way_is_not_permitted_outright, fail) :-
    subject_result(scope_unsure_settled_permitted, permitted).
test(scope_true_with_the_same_way_is_not_referred, fail) :-
    subject_result(transmission_only, needs_legal_review(_Reason, _Context)).
test(fewest_unresolved_way_does_not_name_a_consent_key, fail) :-
    subject_result(fewest_unresolved_first, indeterminate([user_consent_given])).
test(missing_key_case_is_not_referred, fail) :-
    subject_result(unsure_open_way_skipped_for_missing, needs_legal_review(_Reason, _Context)).
test(true_transmission_is_not_referred, fail) :-
    subject_result(transmission_restores_permission, needs_legal_review(_Reason, _Context)).
test(unsure_consent_does_not_cite_the_first_sentence, fail) :-
    subject_result(consent_unsure_referred, needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_5_3_s1)), _Context)).
test(full_row_with_transmission_met_is_not_referred, fail) :-
    subject_result(full_row_transmission_met, needs_legal_review(_Reason, _Context)).

cp_test_names([permitted_is_a_real_verdict_atom, not_permitted_is_a_real_verdict_atom, not_applicable_is_a_real_verdict_atom, attested_scope_is_an_input_problem, bare_scope_asks_for_transmission, absent_scope_asks_for_the_scope, scope_false_is_not_applicable, transmission_way_permits, transmission_false_asks_for_the_request, requested_and_strictly_necessary_permits, not_strictly_necessary_is_not_permitted, informed_consent_permits, consent_without_information_is_not_permitted, three_failed_ways_are_not_permitted, transmission_true_restores_permission, scope_unsure_with_a_met_way_is_referred, fewest_unresolved_way_names_its_key, strictly_necessary_given_permits, missing_key_beats_an_unsure_judgement, unsure_transmission_is_referred, unsure_consent_cites_article_2_f, full_referral_row_refers_transmission_first, full_row_with_transmission_met_permits]).
cp_test_fail_names([bare_scope_is_not_an_input_problem, present_scope_does_not_ask_for_the_scope, scope_true_is_not_not_applicable, transmission_false_does_not_permit, not_strictly_necessary_does_not_permit, consent_without_information_does_not_permit, transmission_true_is_not_not_permitted, scope_unsure_with_a_met_way_is_not_permitted_outright, scope_true_with_the_same_way_is_not_referred, fewest_unresolved_way_does_not_name_a_consent_key, missing_key_case_is_not_referred, true_transmission_is_not_referred, unsure_consent_does_not_cite_the_first_sentence, full_row_with_transmission_met_is_not_referred]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
