% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_act_connected_product_data_sharing_data_act_connected_product_data_sharing, [product_design_duty_status/3, pre_contract_information_duty_status/3, user_access_request_status/3, third_party_sharing_request_status/3, data_act_connected_product_data_sharing_status/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_fixtures, [data_act_connected_product_data_sharing_profile_for/2]).

fixture(Subject, Profile) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile).

test(design_met_positive) :-
    fixture(design_duty_met_complete, Profile),
    product_design_duty_status(Profile, design_duty_met, [cite(eu_reg_2023_2854_art_3_1)]).
test(design_not_met_positive) :-
    fixture(design_default_access_missing, Profile),
    product_design_duty_status(Profile, design_duty_not_met, [cite(eu_reg_2023_2854_art_3_1)]).
test(design_not_applicable_positive) :-
    fixture(placed_before_september_2026, Profile),
    product_design_duty_status(Profile, not_applicable, [cite(eu_reg_2023_2854_art_3_1)]).
test(information_met_positive) :-
    fixture(related_service_information_given, Profile),
    pre_contract_information_duty_status(Profile, information_duty_met, [cite(eu_reg_2023_2854_art_3_3)]).
test(information_not_met_positive) :-
    fixture(related_service_information_withheld, Profile),
    pre_contract_information_duty_status(Profile, information_duty_not_met, [cite(eu_reg_2023_2854_art_3_3)]).
test(information_not_applicable_positive) :-
    fixture(small_enterprise_exempt, Profile),
    pre_contract_information_duty_status(Profile, not_applicable, [cite(eu_reg_2023_2854_art_3_2), cite(eu_reg_2023_2854_art_3_3)]).
test(information_not_exempt_asks_for_the_kind) :-
    fixture(small_enterprise_not_exempt, Profile),
    pre_contract_information_duty_status(Profile, indeterminate([pre_contract_contract_kind]), []).
test(access_due_positive) :-
    fixture(thermostat_access_due, Profile),
    user_access_request_status(Profile, access_due, [cite(eu_reg_2023_2854_art_4_1)]).
test(access_not_applicable_positive) :-
    fixture(thermostat_directly_accessible, Profile),
    user_access_request_status(Profile, not_applicable, [cite(eu_reg_2023_2854_art_4_1)]).
test(security_restriction_positive) :-
    fixture(thermostat_security_restriction, Profile),
    user_access_request_status(Profile, refusal_permitted_security_restriction, [cite(eu_reg_2023_2854_art_4_2)]).
test(access_personal_data_positive) :-
    fixture(wearable_other_person_data_without_basis, Profile),
    user_access_request_status(Profile, personal_data_not_to_be_made_available, [cite(eu_reg_2023_2854_art_4_12)]).
test(access_withholding_positive) :-
    fixture(tractor_trade_secret_measures_breached, Profile),
    user_access_request_status(Profile, withholding_permitted_trade_secrets, [cite(eu_reg_2023_2854_art_4_7)]).
test(access_exceptional_refusal_positive) :-
    fixture(tractor_exceptional_refusal, Profile),
    user_access_request_status(Profile, needs_legal_review(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_4_8)), _), []).
test(access_indeterminate_positive) :-
    fixture(access_requester_absent, Profile),
    user_access_request_status(Profile, indeterminate([requester_is_user]), []).
test(access_unsure_referral_positive) :-
    fixture(access_data_holder_unsure, Profile),
    user_access_request_status(Profile, needs_legal_review(open_textured(addressee_is_data_holder, cite(eu_reg_2023_2854_art_2_13)), _), []).
test(sharing_due_positive) :-
    fixture(sharing_due_clean, Profile),
    third_party_sharing_request_status(Profile, sharing_due, [cite(eu_reg_2023_2854_art_5_1)]).
test(gatekeeper_positive) :-
    fixture(gatekeeper_recipient, Profile),
    third_party_sharing_request_status(Profile, third_party_not_eligible_gatekeeper, [cite(eu_reg_2023_2854_art_5_3)]).
test(testing_data_positive) :-
    fixture(prototype_testing_not_permitted, Profile),
    third_party_sharing_request_status(Profile, not_applicable, [cite(eu_reg_2023_2854_art_5_1)]).
test(sharing_personal_data_positive) :-
    fixture(sharing_other_person_data_without_basis, Profile),
    third_party_sharing_request_status(Profile, personal_data_not_to_be_made_available, [cite(eu_reg_2023_2854_art_5_7)]).
test(strictly_necessary_positive) :-
    fixture(sharing_trade_secret_not_strictly_necessary, Profile),
    third_party_sharing_request_status(Profile, trade_secret_disclosure_not_permitted, [cite(eu_reg_2023_2854_art_5_9)]).
test(sharing_withholding_positive) :-
    fixture(sharing_trade_secret_measures_breached, Profile),
    third_party_sharing_request_status(Profile, withholding_permitted_trade_secrets, [cite(eu_reg_2023_2854_art_5_10)]).
test(sharing_exceptional_refusal_positive) :-
    fixture(sharing_exceptional_refusal, Profile),
    third_party_sharing_request_status(Profile, needs_legal_review(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_5_11)), _), []).
test(input_problem_positive) :-
    fixture(input_unknown_key, Profile),
    user_access_request_status(Profile, input_problems([unknown_key(colour)]), []).
test(facade_eligible_positive) :-
    fixture(thermostat_access_due, Profile),
    data_act_connected_product_data_sharing_status(Profile, eligible).
test(facade_ineligible_positive) :-
    fixture(thermostat_directly_accessible, Profile),
    data_act_connected_product_data_sharing_status(Profile, ineligible).

test(design_met_near_miss_default_access_missing, fail) :-
    fixture(design_default_access_missing, Profile),
    product_design_duty_status(Profile, design_duty_met, _).
test(design_not_met_near_miss_complete, fail) :-
    fixture(design_duty_met_complete, Profile),
    product_design_duty_status(Profile, design_duty_not_met, _).
test(design_not_applicable_near_miss_placed_after, fail) :-
    fixture(design_duty_met_complete, Profile),
    product_design_duty_status(Profile, not_applicable, _).
test(information_met_near_miss_withheld, fail) :-
    fixture(related_service_information_withheld, Profile),
    pre_contract_information_duty_status(Profile, information_duty_met, _).
test(information_not_met_near_miss_given, fail) :-
    fixture(related_service_information_given, Profile),
    pre_contract_information_duty_status(Profile, information_duty_not_met, _).
test(information_not_applicable_near_miss_not_exempt, fail) :-
    fixture(small_enterprise_not_exempt, Profile),
    pre_contract_information_duty_status(Profile, not_applicable, _).
test(access_due_near_miss_direct_access, fail) :-
    fixture(thermostat_directly_accessible, Profile),
    user_access_request_status(Profile, access_due, _).
test(access_not_applicable_near_miss, fail) :-
    fixture(thermostat_access_due, Profile),
    user_access_request_status(Profile, not_applicable, _).
test(security_restriction_near_miss, fail) :-
    fixture(thermostat_access_due, Profile),
    user_access_request_status(Profile, refusal_permitted_security_restriction, _).
test(access_personal_data_near_miss_with_basis, fail) :-
    fixture(wearable_other_person_data_with_basis, Profile),
    user_access_request_status(Profile, personal_data_not_to_be_made_available, _).
test(access_withholding_near_miss_measures_kept, fail) :-
    fixture(tractor_trade_secret_measures_kept, Profile),
    user_access_request_status(Profile, withholding_permitted_trade_secrets, _).
test(access_exceptional_refusal_near_miss_not_invoked, fail) :-
    fixture(tractor_trade_secret_measures_kept, Profile),
    user_access_request_status(Profile, needs_legal_review(_, _), _).
test(access_indeterminate_near_miss_complete, fail) :-
    fixture(thermostat_access_due, Profile),
    user_access_request_status(Profile, indeterminate(_), _).
test(sharing_due_near_miss_gatekeeper, fail) :-
    fixture(gatekeeper_recipient, Profile),
    third_party_sharing_request_status(Profile, sharing_due, _).
test(gatekeeper_near_miss, fail) :-
    fixture(sharing_due_clean, Profile),
    third_party_sharing_request_status(Profile, third_party_not_eligible_gatekeeper, _).
test(testing_data_near_miss_permitted, fail) :-
    fixture(prototype_testing_permitted, Profile),
    third_party_sharing_request_status(Profile, not_applicable, _).
test(sharing_personal_data_near_miss, fail) :-
    fixture(sharing_due_clean, Profile),
    third_party_sharing_request_status(Profile, personal_data_not_to_be_made_available, _).
test(strictly_necessary_near_miss, fail) :-
    fixture(sharing_trade_secret_measures_breached, Profile),
    third_party_sharing_request_status(Profile, trade_secret_disclosure_not_permitted, _).
test(sharing_withholding_near_miss, fail) :-
    fixture(sharing_due_clean, Profile),
    third_party_sharing_request_status(Profile, withholding_permitted_trade_secrets, _).
test(sharing_exceptional_refusal_near_miss, fail) :-
    fixture(sharing_due_clean, Profile),
    third_party_sharing_request_status(Profile, needs_legal_review(_, _), _).
test(input_problem_near_miss_clean, fail) :-
    fixture(thermostat_access_due, Profile),
    user_access_request_status(Profile, input_problems(_), _).
test(facade_eligible_near_miss, fail) :-
    fixture(thermostat_directly_accessible, Profile),
    data_act_connected_product_data_sharing_status(Profile, eligible).

cp_test_names([design_met_positive, design_not_met_positive, design_not_applicable_positive, information_met_positive, information_not_met_positive, information_not_applicable_positive, information_not_exempt_asks_for_the_kind, access_due_positive, access_not_applicable_positive, security_restriction_positive, access_personal_data_positive, access_withholding_positive, access_exceptional_refusal_positive, access_indeterminate_positive, access_unsure_referral_positive, sharing_due_positive, gatekeeper_positive, testing_data_positive, sharing_personal_data_positive, strictly_necessary_positive, sharing_withholding_positive, sharing_exceptional_refusal_positive, input_problem_positive, facade_eligible_positive, facade_ineligible_positive]).
cp_test_fail_names([design_met_near_miss_default_access_missing, design_not_met_near_miss_complete, design_not_applicable_near_miss_placed_after, information_met_near_miss_withheld, information_not_met_near_miss_given, information_not_applicable_near_miss_not_exempt, access_due_near_miss_direct_access, access_not_applicable_near_miss, security_restriction_near_miss, access_personal_data_near_miss_with_basis, access_withholding_near_miss_measures_kept, access_exceptional_refusal_near_miss_not_invoked, access_indeterminate_near_miss_complete, sharing_due_near_miss_gatekeeper, gatekeeper_near_miss, testing_data_near_miss_permitted, sharing_personal_data_near_miss, strictly_necessary_near_miss, sharing_withholding_near_miss, sharing_exceptional_refusal_near_miss, input_problem_near_miss_clean, facade_eligible_near_miss]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
