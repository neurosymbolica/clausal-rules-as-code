% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_queries, [gdpr_data_subject_rights_response_period_profile_keys/1, gdpr_data_subject_rights_response_period_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_gdpr_data_subject_rights_response_period, [gdpr_data_subject_rights_response_period_status/2, response_deadline/3]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_data_subject_rights_response_period_profile_keys(ProfileKeys),
    ProfileKeys == [request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays].
test(status_query_gives_one_status) :-
    findall(Status, gdpr_data_subject_rights_response_period_status([attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, unsure)], Status), Statuses),
    Statuses == [needs_legal_review].
test(deadline_query_gives_one_date) :-
    findall(Deadline, response_deadline(date(2026, 1, 31), first_period, Deadline), Deadlines),
    Deadlines == [date(2026, 3, 2)].
test(what_if_unsure_necessity_refers) :-
    findall(Status, gdpr_data_subject_rights_response_period_what_if([attribute(extension_claimed, true)], extension_necessary_for_complexity_and_number, unsure, Status), Statuses),
    Statuses == [needs_legal_review].
test(what_if_withdrawing_the_claim_gives_first_period) :-
    findall(Status, gdpr_data_subject_rights_response_period_what_if([attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true)], extension_claimed, false, Status), Statuses),
    Statuses == [first_period].
test(what_if_claiming_without_judgement_is_indeterminate) :-
    findall(Status, gdpr_data_subject_rights_response_period_what_if([], extension_claimed, true, Status), Statuses),
    Statuses == [indeterminate].
test(what_if_a_bad_value_is_an_input_problem) :-
    findall(Status, gdpr_data_subject_rights_response_period_what_if([], extension_claimed, unsure, Status), Statuses),
    Statuses == [input_problems].
test(what_if_a_duplicate_is_replaced) :-
    findall(Status, gdpr_data_subject_rights_response_period_what_if([attribute(extension_claimed, true), attribute(extension_claimed, false), attribute(extension_necessary_for_complexity_and_number, true)], extension_claimed, true, Status), Statuses),
    Statuses == [extended_period].
test(what_if_on_a_non_list_keeps_the_input_problem) :-
    findall(Status, gdpr_data_subject_rights_response_period_what_if(not_a_list, extension_claimed, true, Status), Statuses),
    Statuses == [input_problems].
test(result_constructor_terms_destructure) :-
    Referral = needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])]),
    Referral = needs_legal_review(open_textured(Input, _), [inputs_relied_on(Pairs)]),
    Input == extension_necessary_for_complexity_and_number,
    Pairs == [extension_necessary_for_complexity_and_number - unsure],
    Item = outside_fact(public_holidays, attested(true, attestation(by, at, reason, url(address, retrieved)))),
    Item = outside_fact(Key, attested(Value, attestation(_, _, _, url(Address, _)))),
    Key == public_holidays,
    Value == true,
    Address == address.

cp_test_names([profile_keys_are_the_contract_keys, status_query_gives_one_status, deadline_query_gives_one_date, what_if_unsure_necessity_refers, what_if_withdrawing_the_claim_gives_first_period, what_if_claiming_without_judgement_is_indeterminate, what_if_a_bad_value_is_an_input_problem, what_if_a_duplicate_is_replaced, what_if_on_a_non_list_keeps_the_input_problem, result_constructor_terms_destructure]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
