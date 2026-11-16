% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_eprivacy_art_5_3_terminal_equipment, [terminal_equipment_storage_or_access_permitted/3, decide_eprivacy_art_5_3_terminal_equipment/2, eprivacy_art_5_3_terminal_equipment_status/2, eprivacy_art_5_3_terminal_equipment_checklist/2]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_fixtures, [eprivacy_art_5_3_terminal_equipment_profile_for/2]).

only_answer(Subject, Answer) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(Subject, Profile),
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted(Profile, Result, Citations), Answers),
    Answers == [Answer].

test(attested_value_is_an_input_problem) :-
    only_answer(attested_value, input_problems([wrong_type(storage_or_access_in_terminal_equipment)]) - []).
test(duplicate_and_unknown_keys_are_input_problems) :-
    only_answer(duplicate_scope_key, input_problems([duplicate_key(storage_or_access_in_terminal_equipment), unknown_key(zzz)]) - []).
test(not_an_attribute_list_is_an_input_problem) :-
    only_answer(not_attribute_list, input_problems([wrong_type(profile)]) - []).
test(empty_profile_asks_for_the_scope) :-
    only_answer(empty_profile, indeterminate([storage_or_access_in_terminal_equipment]) - []).
test(out_of_scope_is_not_applicable) :-
    only_answer(out_of_scope, not_applicable - [cite(eu_dir_2002_58_art_5_3)]).
test(transmission_only_is_permitted) :-
    only_answer(transmission_only, permitted - [cite(eu_dir_2002_58_art_5_3)]).
test(requested_and_strictly_necessary_is_permitted) :-
    only_answer(requested_and_strictly_necessary, permitted - [cite(eu_dir_2002_58_art_5_3)]).
test(requested_but_not_strictly_necessary_is_not_permitted) :-
    only_answer(requested_but_not_strictly_necessary, not_permitted - [cite(eu_dir_2002_58_art_5_3)]).
test(informed_consent_is_permitted) :-
    only_answer(informed_consent, permitted - [cite(eu_dir_2002_58_art_5_3)]).
test(consent_without_information_is_not_permitted) :-
    only_answer(consent_without_information, not_permitted - [cite(eu_dir_2002_58_art_5_3)]).
test(all_ways_failed_is_not_permitted) :-
    only_answer(all_ways_failed, not_permitted - [cite(eu_dir_2002_58_art_5_3)]).
test(transmission_restores_permission) :-
    only_answer(transmission_restores_permission, permitted - [cite(eu_dir_2002_58_art_5_3)]).
test(full_row_with_transmission_met_is_permitted) :-
    only_answer(full_row_transmission_met, permitted - [cite(eu_dir_2002_58_art_5_3)]).
test(scope_unsure_with_a_met_way_refers_on_the_scope) :-
    only_answer(scope_unsure_settled_permitted, needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - unsure, storage_or_access_solely_for_transmission - true])]) - []).
test(scope_unsure_with_three_failed_ways_refers_on_the_scope) :-
    only_answer(scope_unsure_settled_forbidden, needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - unsure, storage_or_access_solely_for_transmission - false, service_explicitly_requested_by_user - false, user_consent_given - false])]) - []).
test(scope_only_asks_for_transmission) :-
    only_answer(scope_only, indeterminate([storage_or_access_solely_for_transmission]) - []).
test(tie_between_ways_broken_by_contract_order) :-
    only_answer(transmission_failed_alone, indeterminate([service_explicitly_requested_by_user]) - []).
test(way_with_fewest_unresolved_keys_first) :-
    only_answer(fewest_unresolved_first, indeterminate([strictly_necessary_to_provide_requested_service]) - []).
test(missing_key_before_an_unsure_transmission) :-
    only_answer(unsure_open_way_skipped_for_missing, indeterminate([service_explicitly_requested_by_user]) - []).
test(missing_key_named_beside_an_unsure_scope) :-
    only_answer(scope_unsure_missing_named, indeterminate([storage_or_access_solely_for_transmission]) - []).
test(unsure_transmission_is_referred) :-
    only_answer(transmission_unsure_referred, needs_legal_review(open_textured(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)), [inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - unsure, service_explicitly_requested_by_user - false, user_consent_given - false])]) - []).
test(unsure_consent_is_referred_to_article_2_f) :-
    only_answer(consent_unsure_referred, needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_2_f)), [inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - false, service_explicitly_requested_by_user - false, user_consent_given - unsure, clear_and_comprehensive_information_provided - true])]) - []).
test(unsure_information_is_referred_to_the_first_sentence) :-
    only_answer(information_unsure_referred, needs_legal_review(open_textured(clear_and_comprehensive_information_provided, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - false, service_explicitly_requested_by_user - false, user_consent_given - true, clear_and_comprehensive_information_provided - unsure])]) - []).
test(full_referral_row_carries_all_six_pairs) :-
    only_answer(full_referral_row, needs_legal_review(open_textured(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)), [inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - unsure, service_explicitly_requested_by_user - unsure, strictly_necessary_to_provide_requested_service - unsure, user_consent_given - unsure, clear_and_comprehensive_information_provided - unsure])]) - []).
test(the_status_projection_yields_exactly_one_status) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(informed_consent, Profile),
    findall(Status, eprivacy_art_5_3_terminal_equipment_status(Profile, Status), Statuses),
    Statuses == [permitted].
test(the_final_verdict_carries_a_citation) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(informed_consent, Profile),
    decide_eprivacy_art_5_3_terminal_equipment(Profile, eprivacy_art_5_3_terminal_equipment_verdict(permitted, [cite(eu_dir_2002_58_art_5_3)])).
test(the_checklist_rows_for_three_failed_ways) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(all_ways_failed, Profile),
    findall(Items, eprivacy_art_5_3_terminal_equipment_checklist(Profile, Items), Checklists),
    Checklists == [[item(scope, met, cite(eu_dir_2002_58_art_5_3_s1)), item(transmission, unmet(way_failed), cite(eu_dir_2002_58_art_5_3_s2)), item(strictly_necessary, unmet(way_failed), cite(eu_dir_2002_58_art_5_3_s2)), item(consent, unmet(way_failed), cite(eu_dir_2002_58_art_5_3_s1))]].
test(the_checklist_of_a_bad_profile_is_one_input_row) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(not_attribute_list, Profile),
    eprivacy_art_5_3_terminal_equipment_checklist(Profile, [item(input_check, unmet(input_problems([wrong_type(profile)])), cite(eu_dir_2002_58_art_5_3))]).

cp_test_names([attested_value_is_an_input_problem, duplicate_and_unknown_keys_are_input_problems, not_an_attribute_list_is_an_input_problem, empty_profile_asks_for_the_scope, out_of_scope_is_not_applicable, transmission_only_is_permitted, requested_and_strictly_necessary_is_permitted, requested_but_not_strictly_necessary_is_not_permitted, informed_consent_is_permitted, consent_without_information_is_not_permitted, all_ways_failed_is_not_permitted, transmission_restores_permission, full_row_with_transmission_met_is_permitted, scope_unsure_with_a_met_way_refers_on_the_scope, scope_unsure_with_three_failed_ways_refers_on_the_scope, scope_only_asks_for_transmission, tie_between_ways_broken_by_contract_order, way_with_fewest_unresolved_keys_first, missing_key_before_an_unsure_transmission, missing_key_named_beside_an_unsure_scope, unsure_transmission_is_referred, unsure_consent_is_referred_to_article_2_f, unsure_information_is_referred_to_the_first_sentence, full_referral_row_carries_all_six_pairs, the_status_projection_yields_exactly_one_status, the_final_verdict_carries_a_citation, the_checklist_rows_for_three_failed_ways, the_checklist_of_a_bad_profile_is_one_input_row]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
