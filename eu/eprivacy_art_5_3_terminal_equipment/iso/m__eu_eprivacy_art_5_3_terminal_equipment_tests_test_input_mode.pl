% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_eprivacy_art_5_3_terminal_equipment, [terminal_equipment_storage_or_access_permitted/3, eprivacy_art_5_3_terminal_equipment_status/2]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_kernel, [eprivacy_art_5_3_terminal_equipment_input_problems/2]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_fixtures, [eprivacy_art_5_3_terminal_equipment_profile_for/2]).

test(permitted_holds_with_the_verdict_bound) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(transmission_only, Profile),
    terminal_equipment_storage_or_access_permitted(Profile, permitted, [cite(eu_dir_2002_58_art_5_3)]).
test(not_permitted_holds_with_the_verdict_bound) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(all_ways_failed, Profile),
    eprivacy_art_5_3_terminal_equipment_status(Profile, not_permitted).
test(not_applicable_holds_with_the_verdict_bound) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(out_of_scope, Profile),
    terminal_equipment_storage_or_access_permitted(Profile, not_applicable, [cite(eu_dir_2002_58_art_5_3)]).
test(missing_scope_holds_with_the_verdict_bound) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(empty_profile, Profile),
    terminal_equipment_storage_or_access_permitted(Profile, indeterminate([storage_or_access_in_terminal_equipment]), []).
test(referral_holds_with_the_reason_bound) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(consent_unsure_referred, Profile),
    terminal_equipment_storage_or_access_permitted(Profile, needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_2_f)), _Context), []).
test(a_list_with_a_non_attribute_element_is_not_an_attribute_list) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(storage_or_access_in_terminal_equipment, true), foo], Problems),
    Problems == [wrong_type(profile)].
test(a_non_list_profile_is_refused_by_the_called_contract) :-
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted(not_a_list, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(a_value_outside_the_judgement_type_is_wrong_type) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(storage_or_access_solely_for_transmission, yes)], Problems),
    Problems == [wrong_type(storage_or_access_solely_for_transmission)].
test(a_number_key_is_an_unknown_key) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(an_unknown_key_is_named_once_however_often_it_repeats) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(zzz, 1), attribute(storage_or_access_in_terminal_equipment, true), attribute(zzz, 2)], Problems),
    Problems == [unknown_key(zzz)].
test(a_duplicate_with_a_bad_value_is_only_a_duplicate) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(user_consent_given, true), attribute(user_consent_given, maybe)], Problems),
    Problems == [duplicate_key(user_consent_given)].
test(problems_follow_contract_order_then_unknown_keys) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(other, 1), attribute(clear_and_comprehensive_information_provided, 3), attribute(storage_or_access_in_terminal_equipment, attested(true))], Problems),
    Problems == [wrong_type(storage_or_access_in_terminal_equipment), wrong_type(clear_and_comprehensive_information_provided), unknown_key(other)].
test(the_input_check_has_exactly_one_answer) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems([attribute(storage_or_access_in_terminal_equipment, unsure)], Problems), Answers),
    Answers == [[]].
test(an_absent_key_is_not_a_problem) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(user_consent_given, unsure)], []).
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems([attribute(user_consent_given, true)|_Tail], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_element_is_not_an_attribute_list) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems([attribute(user_consent_given, true), _Element], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems([attribute(user_consent_given, _Value)], Problems), Answers),
    Answers == [[wrong_type(user_consent_given)]].

test(permitted_with_empty_citations_is_rejected, fail) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(transmission_only, Profile),
    terminal_equipment_storage_or_access_permitted(Profile, permitted, []).
test(the_wrong_bound_status_is_rejected, fail) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(all_ways_failed, Profile),
    eprivacy_art_5_3_terminal_equipment_status(Profile, permitted).
test(referral_with_the_wrong_citation_is_rejected, fail) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(consent_unsure_referred, Profile),
    terminal_equipment_storage_or_access_permitted(Profile, needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_5_3_s1)), _Context), []).

cp_test_names([permitted_holds_with_the_verdict_bound, not_permitted_holds_with_the_verdict_bound, not_applicable_holds_with_the_verdict_bound, missing_scope_holds_with_the_verdict_bound, referral_holds_with_the_reason_bound, a_list_with_a_non_attribute_element_is_not_an_attribute_list, a_non_list_profile_is_refused_by_the_called_contract, a_value_outside_the_judgement_type_is_wrong_type, a_number_key_is_an_unknown_key, an_unknown_key_is_named_once_however_often_it_repeats, a_duplicate_with_a_bad_value_is_only_a_duplicate, problems_follow_contract_order_then_unknown_keys, the_input_check_has_exactly_one_answer, an_absent_key_is_not_a_problem, a_partial_list_is_not_an_attribute_list, an_unbound_element_is_not_an_attribute_list, an_unbound_profile_is_not_an_attribute_list, an_unbound_value_is_wrong_type]).
cp_test_fail_names([permitted_with_empty_citations_is_rejected, the_wrong_bound_status_is_rejected, referral_with_the_wrong_citation_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
