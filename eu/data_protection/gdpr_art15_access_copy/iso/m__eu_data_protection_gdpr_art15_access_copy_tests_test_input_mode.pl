% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art15_access_copy_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_gdpr_art15_access_copy, [gdpr_art15_access_copy_status/2, gdpr_art15_access_copy_status_values/1, access_answer_items/4, access_answer_items_missing/4, copy_scope/3, copy_fee/3, information_form/3]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_kernel, [gdpr_art15_access_copy_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_fixtures, [gdpr_art15_access_copy_profile_for/2]).

test(complete_status_holds_bound) :-
    gdpr_art15_access_copy_profile_for(full_answer_all_items_given, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_complete).
test(incomplete_status_holds_bound) :-
    gdpr_art15_access_copy_profile_for(full_answer_copy_not_given, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_incomplete).
test(awaiting_status_holds_bound) :-
    gdpr_art15_access_copy_profile_for(processing_not_stated, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_awaiting_input).
test(referred_status_holds_bound) :-
    gdpr_art15_access_copy_profile_for(article_22_statement_absent, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_referred_for_legal_review).
test(rejected_status_holds_bound) :-
    gdpr_art15_access_copy_profile_for(duplicate_and_unknown_keys, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_input_rejected).
test(the_bound_statuses_are_table_values) :-
    gdpr_art15_access_copy_status_values(Values),
    member(access_answer_complete, Values),
    member(access_answer_incomplete, Values),
    member(access_answer_awaiting_input, Values),
    member(access_answer_referred_for_legal_review, Values),
    member(access_answer_input_rejected, Values).
test(items_bound_confirmation_only) :-
    access_answer_items([attribute(personal_data_concerning_data_subject_processed, false)], [confirmation_of_processing], [], [cite(eu_reg_2016_679_art_15_1)]).
test(missing_bound_one_item) :-
    gdpr_art15_access_copy_profile_for(full_answer_copy_not_given, Profile),
    access_answer_items_missing(Profile, [copy_of_personal_data], [], [cite(eu_reg_2016_679_art_15_3)]).
test(copy_scope_bound_full_copy) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_false, Profile),
    copy_scope(Profile, full_copy, [cite(eu_reg_2016_679_art_15_3)]).
test(copy_scope_bound_limited) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_true, Profile),
    copy_scope(Profile, copy_limited_by_rights_and_freedoms_of_others, Citations),
    sort(Citations, [cite(eu_reg_2016_679_art_15_3), cite(eu_reg_2016_679_art_15_4)]).
test(copy_fee_bound_reasonable_fee) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_true, Profile),
    copy_fee(Profile, reasonable_fee_permitted, [cite(eu_reg_2016_679_art_15_3)]).
test(information_form_bound_other_form) :-
    gdpr_art15_access_copy_profile_for(full_answer_copy_not_given, Profile),
    information_form(Profile, other_form_requested, [cite(eu_reg_2016_679_art_15_3)]).
test(unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, gdpr_art15_access_copy_input_problems(_Unbound, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(atom_profile_is_not_an_attribute_list) :-
    gdpr_art15_access_copy_input_problems(nothing, Problems),
    Problems == [wrong_type(profile)].
test(partial_list_is_not_an_attribute_list) :-
    findall(Problems, gdpr_art15_access_copy_input_problems([attribute(items_provided, [])|_Tail], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(unbound_element_is_not_an_attribute_list) :-
    findall(Problems, gdpr_art15_access_copy_input_problems([attribute(items_provided, []), _Element], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(foreign_element_is_not_an_attribute_list) :-
    gdpr_art15_access_copy_input_problems([attribute(items_provided, []), colour], Problems),
    Problems == [wrong_type(profile)].
test(empty_profile_has_no_problem) :-
    gdpr_art15_access_copy_input_problems([], Problems),
    Problems == [].
test(number_key_is_unknown) :-
    gdpr_art15_access_copy_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(compound_key_is_unknown_as_given) :-
    gdpr_art15_access_copy_input_problems([attribute(key(colour), true)], Problems),
    Problems == [unknown_key(key(colour))].
test(repeated_unknown_key_is_named_once) :-
    gdpr_art15_access_copy_input_problems([attribute(colour, blue), attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(duplicate_key_with_equal_values) :-
    gdpr_art15_access_copy_input_problems([attribute(further_copy_requested, true), attribute(further_copy_requested, true)], Problems),
    Problems == [duplicate_key(further_copy_requested)].
test(duplicate_key_is_never_also_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(further_copy_requested, maybe), attribute(further_copy_requested, true)], Problems),
    Problems == [duplicate_key(further_copy_requested)].
test(problems_come_in_contract_order_then_unknown_keys) :-
    gdpr_art15_access_copy_input_problems([attribute(colour, blue), attribute(further_copy_requested, maybe), attribute(items_provided, [nonsense])], Problems),
    Problems == [wrong_type(items_provided), wrong_type(further_copy_requested), unknown_key(colour)].
test(unbound_value_is_wrong_type) :-
    findall(Problems, gdpr_art15_access_copy_input_problems([attribute(further_copy_requested, _Value)], Problems), Answers),
    Answers == [[wrong_type(further_copy_requested)]].
test(items_provided_partial_list_is_wrong_type) :-
    findall(Problems, gdpr_art15_access_copy_input_problems([attribute(items_provided, [confirmation_of_processing|_Rest])], Problems), Answers),
    Answers == [[wrong_type(items_provided)]].
test(items_provided_foreign_item_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(items_provided, [confirmation_of_processing, weather_report])], Problems),
    Problems == [wrong_type(items_provided)].
test(items_provided_repeated_item_is_accepted) :-
    gdpr_art15_access_copy_input_problems([attribute(items_provided, [confirmation_of_processing, confirmation_of_processing])], Problems),
    Problems == [].
test(crisp_key_unsure_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(further_copy_requested, unsure)], Problems),
    Problems == [wrong_type(further_copy_requested)].
test(judgement_unsure_is_well_formed) :-
    gdpr_art15_access_copy_input_problems([attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, unsure)], Problems),
    Problems == [].
test(judgement_attested_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, attested(true, attestation(host, recorded_at, reason, none)))], Problems),
    Problems == [wrong_type(copy_would_adversely_affect_rights_and_freedoms_of_others)].
test(crisp_key_attested_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(personal_data_concerning_data_subject_processed, attested(true, attestation(host, recorded_at, reason, none)))], Problems),
    Problems == [wrong_type(personal_data_concerning_data_subject_processed)].
test(outside_fact_bare_true_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(transfer_subject_to_article_46_safeguards, true)], Problems),
    Problems == [wrong_type(transfer_subject_to_article_46_safeguards)].
test(outside_fact_attested_unsure_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(transfer_subject_to_article_46_safeguards, attested(unsure, attestation(host, recorded_at, reason, none)))], Problems),
    Problems == [wrong_type(transfer_subject_to_article_46_safeguards)].
test(outside_fact_three_part_attestation_is_wrong_type) :-
    gdpr_art15_access_copy_input_problems([attribute(automated_decision_making_referred_to_in_article_22, attested(true, attestation(host, recorded_at, reason)))], Problems),
    Problems == [wrong_type(automated_decision_making_referred_to_in_article_22)].
test(outside_fact_with_url_evidence_is_well_formed) :-
    gdpr_art15_access_copy_input_problems([attribute(automated_decision_making_referred_to_in_article_22, attested(false, attestation(host, recorded_at, reason, url(address, retrieved_at))))], Problems),
    Problems == [].
test(input_check_yields_one_solution) :-
    findall(Problems, gdpr_art15_access_copy_input_problems([attribute(colour, blue), attribute(42, _Value), attribute(items_provided, oops)], Problems), Solutions),
    length(Solutions, 1).
test(every_query_gives_input_problems_first) :-
    Profile = [attribute(colour, blue), attribute(personal_data_concerning_data_subject_processed, false)],
    access_answer_items(Profile, input_problems([unknown_key(colour)]), [], []),
    access_answer_items_missing(Profile, input_problems([unknown_key(colour)]), [], []),
    copy_scope(Profile, input_problems([unknown_key(colour)]), []),
    copy_fee(Profile, input_problems([unknown_key(colour)]), []),
    information_form(Profile, input_problems([unknown_key(colour)]), []).
test(the_profile_order_does_not_change_the_answer) :-
    copy_scope([attribute(personal_data_concerning_data_subject_processed, true), attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, false)], First, _),
    copy_scope([attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, false), attribute(personal_data_concerning_data_subject_processed, true)], Second, _),
    First == full_copy,
    Second == full_copy.

test(complete_profile_rejects_incomplete_bound, fail) :-
    gdpr_art15_access_copy_profile_for(full_answer_all_items_given, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_incomplete).
test(incomplete_profile_rejects_complete_bound, fail) :-
    gdpr_art15_access_copy_profile_for(full_answer_copy_not_given, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_complete).

cp_test_names([complete_status_holds_bound, incomplete_status_holds_bound, awaiting_status_holds_bound, referred_status_holds_bound, rejected_status_holds_bound, the_bound_statuses_are_table_values, items_bound_confirmation_only, missing_bound_one_item, copy_scope_bound_full_copy, copy_scope_bound_limited, copy_fee_bound_reasonable_fee, information_form_bound_other_form, unbound_profile_is_not_an_attribute_list, atom_profile_is_not_an_attribute_list, partial_list_is_not_an_attribute_list, unbound_element_is_not_an_attribute_list, foreign_element_is_not_an_attribute_list, empty_profile_has_no_problem, number_key_is_unknown, compound_key_is_unknown_as_given, repeated_unknown_key_is_named_once, duplicate_key_with_equal_values, duplicate_key_is_never_also_wrong_type, problems_come_in_contract_order_then_unknown_keys, unbound_value_is_wrong_type, items_provided_partial_list_is_wrong_type, items_provided_foreign_item_is_wrong_type, items_provided_repeated_item_is_accepted, crisp_key_unsure_is_wrong_type, judgement_unsure_is_well_formed, judgement_attested_is_wrong_type, crisp_key_attested_is_wrong_type, outside_fact_bare_true_is_wrong_type, outside_fact_attested_unsure_is_wrong_type, outside_fact_three_part_attestation_is_wrong_type, outside_fact_with_url_evidence_is_well_formed, input_check_yields_one_solution, every_query_gives_input_problems_first, the_profile_order_does_not_change_the_answer]).
cp_test_fail_names([complete_profile_rejects_incomplete_bound, incomplete_profile_rejects_complete_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
