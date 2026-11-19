% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_queries, [gdpr_data_subject_rights_response_duties_profile_keys/1, gdpr_data_subject_rights_response_duties_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_kernel, [gdpr_data_subject_rights_response_duties_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [gdpr_data_subject_rights_response_duties_status/2, request_response_deadline/2, response_duties/2, recipient_notification/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_data_subject_rights_response_duties_profile_keys(ProfileKeys),
    ProfileKeys == [request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays].
test(profile_keys_number_fifty_four) :-
    gdpr_data_subject_rights_response_duties_profile_keys(ProfileKeys),
    length(ProfileKeys, 54).
test(the_reexported_input_check_reads_the_profile) :-
    gdpr_data_subject_rights_response_duties_input_problems([attribute(request_type, access), attribute(favourite_colour, blue)], Problems),
    Problems == [unknown_key(favourite_colour)].
test(status_query_two) :-
    gdpr_data_subject_rights_response_duties_status([attribute(request_type, access)], Status),
    Status == must_comply.
test(obligation_query_fourteen) :-
    findall(Duties, response_duties([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(processing_necessary_for_public_task_or_official_authority, true)], Duties), AllDuties),
    AllDuties == [[inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]].
test(obligation_query_fourteen_for_recipients) :-
    findall(Duties, recipient_notification([attribute(request_type, restriction), attribute(accuracy_contested_by_data_subject, true), attribute(personal_data_disclosed_to_recipients, true)], Duties), AllDuties),
    AllDuties == [indeterminate([recipient_notification_impossible_or_disproportionate_effort])].
test(deadline_query_fifteen_leap_year) :-
    findall(Deadline, request_response_deadline([attribute(request_type, access), attribute(request_received_on, date(2028, 1, 31))], Deadline), Deadlines),
    Deadlines == [date(2028, 2, 29)].
test(deadline_query_fifteen_year_carry) :-
    findall(Deadline, request_response_deadline([attribute(request_type, access), attribute(request_received_on, date(2026, 12, 31))], Deadline), Deadlines),
    Deadlines == [date(2027, 2, 1)].
test(deadline_query_fifteen_extended_sunday_shift) :-
    findall(Deadline, request_response_deadline([attribute(request_type, access), attribute(request_received_on, date(2026, 11, 30)), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, true)], Deadline), Deadlines),
    Deadlines == [date(2027, 3, 1)].
test(what_if_query_sixteen_flips_a_refusal) :-
    gdpr_data_subject_rights_response_duties_what_if([attribute(request_type, access), attribute(controller_demonstrates_unable_to_identify_data_subject, true)], controller_demonstrates_unable_to_identify_data_subject, false, Status),
    Status == must_comply.
test(what_if_query_sixteen_adds_a_missing_key) :-
    gdpr_data_subject_rights_response_duties_what_if([attribute(request_type, rectification)], personal_data_inaccurate, true, Status),
    Status == must_comply.
test(what_if_query_sixteen_never_duplicates_a_key) :-
    gdpr_data_subject_rights_response_duties_what_if([attribute(request_type, access)], request_type, erasure, Status),
    Status == indeterminate.

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_number_fifty_four, the_reexported_input_check_reads_the_profile, status_query_two, obligation_query_fourteen, obligation_query_fourteen_for_recipients, deadline_query_fifteen_leap_year, deadline_query_fifteen_year_carry, deadline_query_fifteen_extended_sunday_shift, what_if_query_sixteen_flips_a_refusal, what_if_query_sixteen_adds_a_missing_key, what_if_query_sixteen_never_duplicates_a_key]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
