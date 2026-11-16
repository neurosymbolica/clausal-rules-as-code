% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_act_connected_product_data_sharing_data_act_connected_product_data_sharing, [product_design_duty_status/3, pre_contract_information_duty_status/3, user_access_request_status/3, third_party_sharing_request_status/3, decide_data_act_connected_product_data_sharing/2, data_act_connected_product_data_sharing_status/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_fixtures, [data_act_connected_product_data_sharing_profile_for/2]).

fixture(Subject, Profile) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile).

answers(Query, Subject, Answers) :-
    fixture(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers).

test(empty_profile_design) :-
    findall(Result - Citations, product_design_duty_status([], Result, Citations), Answers),
    Answers == [indeterminate([connected_product_or_related_service]) - []].
test(empty_profile_information) :-
    findall(Result - Citations, pre_contract_information_duty_status([], Result, Citations), Answers),
    Answers == [indeterminate([connected_product_or_related_service]) - []].
test(empty_profile_access) :-
    findall(Result - Citations, user_access_request_status([], Result, Citations), Answers),
    Answers == [indeterminate([connected_product_or_related_service]) - []].
test(empty_profile_sharing) :-
    findall(Result - Citations, third_party_sharing_request_status([], Result, Citations), Answers),
    Answers == [indeterminate([connected_product_or_related_service]) - []].
test(not_connected_product_in_every_query) :-
    answers(product_design_duty_status, not_connected_product_only, DesignAnswers),
    DesignAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_3_1)]],
    answers(pre_contract_information_duty_status, not_connected_product_only, InformationAnswers),
    InformationAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_3_2), cite(eu_reg_2023_2854_art_3_3)]],
    answers(user_access_request_status, not_connected_product_only, AccessAnswers),
    AccessAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_4_1)]],
    answers(third_party_sharing_request_status, not_connected_product_only, SharingAnswers),
    SharingAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_5_1)]].
test(small_enterprise_exempt_in_every_query) :-
    answers(product_design_duty_status, small_enterprise_exempt, DesignAnswers),
    DesignAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_3_1)]],
    answers(user_access_request_status, small_enterprise_exempt, AccessAnswers),
    AccessAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_4_1)]],
    answers(third_party_sharing_request_status, small_enterprise_exempt, SharingAnswers),
    SharingAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_5_1)]].
test(small_enterprise_not_exempt_asks_for_the_next_key) :-
    answers(product_design_duty_status, small_enterprise_not_exempt, DesignAnswers),
    DesignAnswers == [indeterminate([placed_on_market_after_12_september_2026]) - []],
    answers(pre_contract_information_duty_status, small_enterprise_not_exempt, InformationAnswers),
    InformationAnswers == [indeterminate([pre_contract_contract_kind]) - []],
    answers(user_access_request_status, small_enterprise_not_exempt, AccessAnswers),
    AccessAnswers == [indeterminate([requester_is_user]) - []],
    answers(third_party_sharing_request_status, small_enterprise_not_exempt, SharingAnswers),
    SharingAnswers == [indeterminate([request_by_or_on_behalf_of_user]) - []].
test(design_routes) :-
    answers(product_design_duty_status, design_duty_met_complete, MetAnswers),
    MetAnswers == [design_duty_met - [cite(eu_reg_2023_2854_art_3_1)]],
    answers(product_design_duty_status, design_default_access_missing, NotMetAnswers),
    NotMetAnswers == [design_duty_not_met - [cite(eu_reg_2023_2854_art_3_1)]],
    answers(product_design_duty_status, placed_before_september_2026, EarlyAnswers),
    EarlyAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_3_1)]].
test(information_routes) :-
    answers(pre_contract_information_duty_status, purchase_information_given, PurchaseAnswers),
    PurchaseAnswers == [information_duty_met - [cite(eu_reg_2023_2854_art_3_2)]],
    answers(pre_contract_information_duty_status, related_service_information_given, ServiceAnswers),
    ServiceAnswers == [information_duty_met - [cite(eu_reg_2023_2854_art_3_3)]],
    answers(pre_contract_information_duty_status, related_service_information_withheld, WithheldAnswers),
    WithheldAnswers == [information_duty_not_met - [cite(eu_reg_2023_2854_art_3_3)]],
    answers(pre_contract_information_duty_status, information_kind_absent, KindAnswers),
    KindAnswers == [indeterminate([pre_contract_contract_kind]) - []].
test(access_routes) :-
    answers(user_access_request_status, thermostat_access_due, DueAnswers),
    DueAnswers == [access_due - [cite(eu_reg_2023_2854_art_4_1)]],
    answers(user_access_request_status, thermostat_directly_accessible, DirectAnswers),
    DirectAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_4_1)]],
    answers(user_access_request_status, thermostat_security_restriction, SecurityAnswers),
    SecurityAnswers == [refusal_permitted_security_restriction - [cite(eu_reg_2023_2854_art_4_2)]],
    answers(user_access_request_status, wearable_other_person_data_without_basis, PersonalAnswers),
    PersonalAnswers == [personal_data_not_to_be_made_available - [cite(eu_reg_2023_2854_art_4_12)]],
    answers(user_access_request_status, wearable_other_person_data_with_basis, BasisAnswers),
    BasisAnswers == [access_due - [cite(eu_reg_2023_2854_art_4_1)]],
    answers(user_access_request_status, tractor_trade_secret_measures_breached, BreachedAnswers),
    BreachedAnswers == [withholding_permitted_trade_secrets - [cite(eu_reg_2023_2854_art_4_7)]],
    answers(user_access_request_status, tractor_trade_secret_measures_kept, KeptAnswers),
    KeptAnswers == [access_due - [cite(eu_reg_2023_2854_art_4_1)]],
    answers(user_access_request_status, access_requester_absent, AbsentAnswers),
    AbsentAnswers == [indeterminate([requester_is_user]) - []].
test(access_exceptional_refusal_context) :-
    answers(user_access_request_status, tractor_exceptional_refusal, Answers),
    Answers == [needs_legal_review(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_4_8)), [inputs_relied_on([connected_product_or_related_service - true, small_enterprise_exemption_applies - false, requester_is_user - true, addressee_is_data_holder - true, requested_data_readily_available - true, data_directly_accessible_by_user - false, security_restriction_agreed_applies - false, other_persons_personal_data_requested - false, gdpr_conditions_for_making_available_met - true, requested_data_identified_as_trade_secrets - true, trade_secret_measures_agreed_and_kept - true, exceptional_trade_secret_refusal_invoked - true])]) - []].
test(access_unsure_data_holder_context) :-
    answers(user_access_request_status, access_data_holder_unsure, Answers),
    Answers == [needs_legal_review(open_textured(addressee_is_data_holder, cite(eu_reg_2023_2854_art_2_13)), [inputs_relied_on([connected_product_or_related_service - true, small_enterprise_exemption_applies - false, requester_is_user - true, addressee_is_data_holder - unsure, requested_data_readily_available - true, data_directly_accessible_by_user - false, security_restriction_agreed_applies - false, other_persons_personal_data_requested - false, gdpr_conditions_for_making_available_met - true, requested_data_identified_as_trade_secrets - false, trade_secret_measures_agreed_and_kept - true, exceptional_trade_secret_refusal_invoked - false])]) - []].
test(sharing_routes) :-
    answers(third_party_sharing_request_status, sharing_due_clean, DueAnswers),
    DueAnswers == [sharing_due - [cite(eu_reg_2023_2854_art_5_1)]],
    answers(third_party_sharing_request_status, gatekeeper_recipient, GatekeeperAnswers),
    GatekeeperAnswers == [third_party_not_eligible_gatekeeper - [cite(eu_reg_2023_2854_art_5_3)]],
    answers(third_party_sharing_request_status, prototype_testing_not_permitted, TestingAnswers),
    TestingAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_5_1)]],
    answers(third_party_sharing_request_status, prototype_testing_permitted, PermittedAnswers),
    PermittedAnswers == [sharing_due - [cite(eu_reg_2023_2854_art_5_1)]],
    answers(third_party_sharing_request_status, sharing_other_person_data_without_basis, PersonalAnswers),
    PersonalAnswers == [personal_data_not_to_be_made_available - [cite(eu_reg_2023_2854_art_5_7)]],
    answers(third_party_sharing_request_status, sharing_trade_secret_not_strictly_necessary, NecessaryAnswers),
    NecessaryAnswers == [trade_secret_disclosure_not_permitted - [cite(eu_reg_2023_2854_art_5_9)]],
    answers(third_party_sharing_request_status, sharing_trade_secret_measures_breached, BreachedAnswers),
    BreachedAnswers == [withholding_permitted_trade_secrets - [cite(eu_reg_2023_2854_art_5_10)]].
test(sharing_exceptional_refusal_context) :-
    answers(third_party_sharing_request_status, sharing_exceptional_refusal, Answers),
    Answers == [needs_legal_review(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_5_11)), [inputs_relied_on([connected_product_or_related_service - true, small_enterprise_exemption_applies - false, request_by_or_on_behalf_of_user - true, addressee_is_data_holder - true, requested_data_readily_available - true, testing_data_not_yet_on_market - false, third_party_use_contractually_permitted - false, third_party_is_designated_gatekeeper - false, other_persons_personal_data_requested - false, gdpr_conditions_for_making_available_met - true, requested_data_identified_as_trade_secrets - true, trade_secret_disclosure_strictly_necessary - true, trade_secret_measures_agreed_and_kept - true, exceptional_trade_secret_refusal_invoked - true])]) - []].
test(the_verdict_carries_its_citation) :-
    fixture(thermostat_access_due, Profile),
    findall(Verdict, decide_data_act_connected_product_data_sharing(Profile, Verdict), Verdicts),
    Verdicts == [data_act_connected_product_data_sharing_verdict(eligible, [cite(eu_reg_2023_2854_art_4_1)])].
test(the_facade_passes_a_missing_key_through) :-
    fixture(access_requester_absent, Profile),
    findall(Status, data_act_connected_product_data_sharing_status(Profile, Status), Statuses),
    Statuses == [indeterminate([requester_is_user])].
test(the_facade_status_is_ineligible_for_a_refusal) :-
    fixture(thermostat_security_restriction, Profile),
    findall(Status, data_act_connected_product_data_sharing_status(Profile, Status), Statuses),
    Statuses == [ineligible].

cp_test_names([empty_profile_design, empty_profile_information, empty_profile_access, empty_profile_sharing, not_connected_product_in_every_query, small_enterprise_exempt_in_every_query, small_enterprise_not_exempt_asks_for_the_next_key, design_routes, information_routes, access_routes, access_exceptional_refusal_context, access_unsure_data_holder_context, sharing_routes, sharing_exceptional_refusal_context, the_verdict_carries_its_citation, the_facade_passes_a_missing_key_through, the_facade_status_is_ineligible_for_a_refusal]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
