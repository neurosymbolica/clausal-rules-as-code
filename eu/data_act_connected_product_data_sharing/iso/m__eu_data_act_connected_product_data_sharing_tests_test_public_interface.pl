% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_act_connected_product_data_sharing_data_act_connected_product_data_sharing, [product_design_duty_status/3, pre_contract_information_duty_status/3, user_access_request_status/3, third_party_sharing_request_status/3, decide_data_act_connected_product_data_sharing/2, data_act_connected_product_data_sharing_status/2, data_act_connected_product_data_sharing_checklist/2, data_act_connected_product_data_sharing_decision_resolvable/1, data_act_connected_product_data_sharing_status_values/1]).
:- use_module(m__eu_data_act_connected_product_data_sharing_kernel, [data_act_connected_product_data_sharing_input_problems/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_fixtures, [data_act_connected_product_data_sharing_subject/1, data_act_connected_product_data_sharing_profile_for/2, data_act_connected_product_data_sharing_assess/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_queries, [data_act_connected_product_data_sharing_what_if/4, data_act_connected_product_data_sharing_profile_keys/1]).

access_answers(Subject, Answers) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    findall(Result - Citations, user_access_request_status(Profile, Result, Citations), Answers).

sharing_answers(Subject, Answers) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    findall(Result - Citations, third_party_sharing_request_status(Profile, Result, Citations), Answers).

design_answers(Subject, Answers) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    findall(Result - Citations, product_design_duty_status(Profile, Result, Citations), Answers).

information_answers(Subject, Answers) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    findall(Result - Citations, pre_contract_information_duty_status(Profile, Result, Citations), Answers).

subject_checklist(Subject, Items) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    data_act_connected_product_data_sharing_checklist(Profile, Items).

answers_exactly_once(Subject) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    findall(Result, product_design_duty_status(Profile, Result, _), DesignResults),
    length(DesignResults, 1),
    findall(Result, pre_contract_information_duty_status(Profile, Result, _), InformationResults),
    length(InformationResults, 1),
    findall(Result, user_access_request_status(Profile, Result, _), AccessResults),
    length(AccessResults, 1),
    findall(Result, third_party_sharing_request_status(Profile, Result, _), SharingResults),
    length(SharingResults, 1),
    findall(Verdict, decide_data_act_connected_product_data_sharing(Profile, Verdict), Verdicts),
    length(Verdicts, 1),
    findall(Problems, data_act_connected_product_data_sharing_input_problems(Profile, Problems), ProblemLists),
    length(ProblemLists, 1),
    data_act_connected_product_data_sharing_decision_resolvable(Profile).

test(every_subject_answers_each_query_exactly_once) :-
    findall(Subject, data_act_connected_product_data_sharing_subject(Subject), Subjects),
    length(Subjects, 33),
    maplist(answers_exactly_once, Subjects).
test(status_vocabulary_is_eligible_and_ineligible) :-
    data_act_connected_product_data_sharing_status_values(StatusValues),
    StatusValues == [eligible, ineligible].
test(profile_keys_are_the_twenty_two) :-
    data_act_connected_product_data_sharing_profile_keys(Keys),
    length(Keys, 22).
test(thermostat_access_is_due) :-
    access_answers(thermostat_access_due, Answers),
    Answers == [access_due - [cite(eu_reg_2023_2854_art_4_1)]].
test(thermostat_is_eligible) :-
    data_act_connected_product_data_sharing_assess(thermostat_access_due, data_act_connected_product_data_sharing_verdict(eligible, [cite(eu_reg_2023_2854_art_4_1)])).
test(direct_access_near_miss_is_not_applicable) :-
    access_answers(thermostat_directly_accessible, Answers),
    Answers == [not_applicable - [cite(eu_reg_2023_2854_art_4_1)]].
test(direct_access_near_miss_is_ineligible) :-
    data_act_connected_product_data_sharing_assess(thermostat_directly_accessible, data_act_connected_product_data_sharing_verdict(ineligible, [cite(eu_reg_2023_2854_art_4_1)])).
test(security_restriction_permits_refusal) :-
    access_answers(thermostat_security_restriction, Answers),
    Answers == [refusal_permitted_security_restriction - [cite(eu_reg_2023_2854_art_4_2)]].
test(security_restriction_is_ineligible) :-
    data_act_connected_product_data_sharing_profile_for(thermostat_security_restriction, Profile),
    data_act_connected_product_data_sharing_status(Profile, ineligible).
test(other_person_data_without_basis_is_withheld) :-
    access_answers(wearable_other_person_data_without_basis, Answers),
    Answers == [personal_data_not_to_be_made_available - [cite(eu_reg_2023_2854_art_4_12)]].
test(other_person_data_with_basis_near_miss_is_due) :-
    access_answers(wearable_other_person_data_with_basis, Answers),
    Answers == [access_due - [cite(eu_reg_2023_2854_art_4_1)]].
test(other_person_data_eligibility_flips) :-
    data_act_connected_product_data_sharing_assess(wearable_other_person_data_without_basis, data_act_connected_product_data_sharing_verdict(ineligible, [cite(eu_reg_2023_2854_art_4_12)])),
    data_act_connected_product_data_sharing_assess(wearable_other_person_data_with_basis, data_act_connected_product_data_sharing_verdict(eligible, [cite(eu_reg_2023_2854_art_4_1)])).
test(trade_secret_measures_breached_permit_withholding) :-
    access_answers(tractor_trade_secret_measures_breached, Answers),
    Answers == [withholding_permitted_trade_secrets - [cite(eu_reg_2023_2854_art_4_7)]].
test(trade_secret_measures_kept_near_miss_is_due) :-
    access_answers(tractor_trade_secret_measures_kept, Answers),
    Answers == [access_due - [cite(eu_reg_2023_2854_art_4_1)]].
test(trade_secret_breach_is_ineligible) :-
    data_act_connected_product_data_sharing_assess(tractor_trade_secret_measures_breached, data_act_connected_product_data_sharing_verdict(ineligible, [cite(eu_reg_2023_2854_art_4_7)])).
test(exceptional_refusal_goes_to_a_lawyer) :-
    access_answers(tractor_exceptional_refusal, Answers),
    Answers == [needs_legal_review(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_4_8)), [inputs_relied_on([connected_product_or_related_service - true, small_enterprise_exemption_applies - false, requester_is_user - true, addressee_is_data_holder - true, requested_data_readily_available - true, data_directly_accessible_by_user - false, security_restriction_agreed_applies - false, other_persons_personal_data_requested - false, gdpr_conditions_for_making_available_met - true, requested_data_identified_as_trade_secrets - true, trade_secret_measures_agreed_and_kept - true, exceptional_trade_secret_refusal_invoked - true])]) - []].
test(exceptional_refusal_passes_through_the_facade) :-
    data_act_connected_product_data_sharing_profile_for(tractor_exceptional_refusal, Profile),
    data_act_connected_product_data_sharing_status(Profile, needs_legal_review(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_4_8)), _)).
test(absent_requester_is_asked_for) :-
    access_answers(access_requester_absent, Answers),
    Answers == [indeterminate([requester_is_user]) - []].
test(absent_requester_is_indeterminate_through_the_facade) :-
    data_act_connected_product_data_sharing_assess(access_requester_absent, data_act_connected_product_data_sharing_verdict(indeterminate([requester_is_user]), [])).
test(unsure_data_holder_is_referred) :-
    access_answers(access_data_holder_unsure, Answers),
    Answers == [needs_legal_review(open_textured(addressee_is_data_holder, cite(eu_reg_2023_2854_art_2_13)), [inputs_relied_on([connected_product_or_related_service - true, small_enterprise_exemption_applies - false, requester_is_user - true, addressee_is_data_holder - unsure, requested_data_readily_available - true, data_directly_accessible_by_user - false, security_restriction_agreed_applies - false, other_persons_personal_data_requested - false, gdpr_conditions_for_making_available_met - true, requested_data_identified_as_trade_secrets - false, trade_secret_measures_agreed_and_kept - true, exceptional_trade_secret_refusal_invoked - false])]) - []].
test(checklist_all_met_when_access_is_due) :-
    subject_checklist(thermostat_access_due, Items),
    length(Items, 10),
    member(item(no_direct_access, met, cite(eu_reg_2023_2854_art_4_1)), Items),
    member(item(personal_data_legal_basis, met, cite(eu_reg_2023_2854_art_4_12)), Items).
test(checklist_marks_direct_access_unmet) :-
    subject_checklist(thermostat_directly_accessible, [_FirstItem|_OtherItems]),
    subject_checklist(thermostat_directly_accessible, Items),
    member(item(no_direct_access, unmet(data_directly_accessible), cite(eu_reg_2023_2854_art_4_1)), Items).
test(checklist_marks_unsure_data_holder_unknown) :-
    subject_checklist(access_data_holder_unsure, Items),
    member(item(addressee_data_holder, unknown([addressee_is_data_holder]), cite(eu_reg_2023_2854_art_2_13)), Items).
test(checklist_marks_absent_requester_unknown) :-
    subject_checklist(access_requester_absent, Items),
    member(item(requester_user, unknown([requester_is_user]), cite(eu_reg_2023_2854_art_2_12)), Items).
test(checklist_marks_breached_measures_unmet) :-
    subject_checklist(tractor_trade_secret_measures_breached, Items),
    member(item(trade_secret_measures, unmet(trade_secret_measures_not_kept), cite(eu_reg_2023_2854_art_4_7)), Items).
test(checklist_present_for_a_well_formed_profile) :-
    subject_checklist(small_enterprise_exempt, [_FirstItem|_OtherItems]).
test(not_connected_product_is_not_applicable_everywhere) :-
    design_answers(not_connected_product_only, DesignAnswers),
    DesignAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_3_1)]],
    information_answers(not_connected_product_only, InformationAnswers),
    InformationAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_3_2), cite(eu_reg_2023_2854_art_3_3)]],
    access_answers(not_connected_product_only, AccessAnswers),
    AccessAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_4_1)]],
    sharing_answers(not_connected_product_only, SharingAnswers),
    SharingAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_5_1)]].
test(small_enterprise_exempt_is_not_applicable_everywhere) :-
    design_answers(small_enterprise_exempt, DesignAnswers),
    DesignAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_3_1)]],
    information_answers(small_enterprise_exempt, InformationAnswers),
    InformationAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_3_2), cite(eu_reg_2023_2854_art_3_3)]],
    access_answers(small_enterprise_exempt, AccessAnswers),
    AccessAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_4_1)]],
    sharing_answers(small_enterprise_exempt, SharingAnswers),
    SharingAnswers == [not_applicable - [cite(eu_reg_2023_2854_art_5_1)]].
test(small_enterprise_not_exempt_near_miss_asks_for_the_next_key) :-
    access_answers(small_enterprise_not_exempt, AccessAnswers),
    AccessAnswers == [indeterminate([requester_is_user]) - []],
    design_answers(small_enterprise_not_exempt, DesignAnswers),
    DesignAnswers == [indeterminate([placed_on_market_after_12_september_2026]) - []].
test(design_duty_met_on_a_complete_profile) :-
    design_answers(design_duty_met_complete, Answers),
    Answers == [design_duty_met - [cite(eu_reg_2023_2854_art_3_1)]].
test(design_default_access_missing_near_miss_is_not_met) :-
    design_answers(design_default_access_missing, Answers),
    Answers == [design_duty_not_met - [cite(eu_reg_2023_2854_art_3_1)]].
test(placed_before_september_2026_is_not_applicable) :-
    design_answers(placed_before_september_2026, Answers),
    Answers == [not_applicable - [cite(eu_reg_2023_2854_art_3_1)]].
test(purchase_information_given_is_met) :-
    information_answers(purchase_information_given, Answers),
    Answers == [information_duty_met - [cite(eu_reg_2023_2854_art_3_2)]].
test(related_service_information_given_is_met) :-
    information_answers(related_service_information_given, Answers),
    Answers == [information_duty_met - [cite(eu_reg_2023_2854_art_3_3)]].
test(related_service_information_withheld_near_miss_is_not_met) :-
    information_answers(related_service_information_withheld, Answers),
    Answers == [information_duty_not_met - [cite(eu_reg_2023_2854_art_3_3)]].
test(information_kind_absent_is_asked_for) :-
    information_answers(information_kind_absent, Answers),
    Answers == [indeterminate([pre_contract_contract_kind]) - []].
test(sharing_is_due_on_a_clean_profile) :-
    sharing_answers(sharing_due_clean, Answers),
    Answers == [sharing_due - [cite(eu_reg_2023_2854_art_5_1)]].
test(gatekeeper_is_not_an_eligible_third_party) :-
    sharing_answers(gatekeeper_recipient, Answers),
    Answers == [third_party_not_eligible_gatekeeper - [cite(eu_reg_2023_2854_art_5_3)]].
test(prototype_testing_not_permitted_is_not_applicable) :-
    sharing_answers(prototype_testing_not_permitted, Answers),
    Answers == [not_applicable - [cite(eu_reg_2023_2854_art_5_1)]].
test(prototype_testing_permitted_near_miss_is_due) :-
    sharing_answers(prototype_testing_permitted, Answers),
    Answers == [sharing_due - [cite(eu_reg_2023_2854_art_5_1)]].
test(sharing_other_person_data_without_basis_is_withheld) :-
    sharing_answers(sharing_other_person_data_without_basis, Answers),
    Answers == [personal_data_not_to_be_made_available - [cite(eu_reg_2023_2854_art_5_7)]].
test(sharing_trade_secret_not_strictly_necessary_is_not_permitted) :-
    sharing_answers(sharing_trade_secret_not_strictly_necessary, Answers),
    Answers == [trade_secret_disclosure_not_permitted - [cite(eu_reg_2023_2854_art_5_9)]].
test(sharing_trade_secret_measures_breached_permit_withholding) :-
    sharing_answers(sharing_trade_secret_measures_breached, Answers),
    Answers == [withholding_permitted_trade_secrets - [cite(eu_reg_2023_2854_art_5_10)]].
test(sharing_exceptional_refusal_goes_to_a_lawyer) :-
    sharing_answers(sharing_exceptional_refusal, Answers),
    Answers == [needs_legal_review(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_5_11)), [inputs_relied_on([connected_product_or_related_service - true, small_enterprise_exemption_applies - false, request_by_or_on_behalf_of_user - true, addressee_is_data_holder - true, requested_data_readily_available - true, testing_data_not_yet_on_market - false, third_party_use_contractually_permitted - false, third_party_is_designated_gatekeeper - false, other_persons_personal_data_requested - false, gdpr_conditions_for_making_available_met - true, requested_data_identified_as_trade_secrets - true, trade_secret_disclosure_strictly_necessary - true, trade_secret_measures_agreed_and_kept - true, exceptional_trade_secret_refusal_invoked - true])]) - []].
test(unknown_key_is_an_input_problem) :-
    access_answers(input_unknown_key, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(duplicate_key_is_an_input_problem) :-
    data_act_connected_product_data_sharing_profile_for(input_duplicate_key, Profile),
    data_act_connected_product_data_sharing_input_problems(Profile, [duplicate_key(requester_is_user)]),
    sharing_answers(input_duplicate_key, Answers),
    Answers == [input_problems([duplicate_key(requester_is_user)]) - []].
test(unsure_boolean_is_wrong_type) :-
    design_answers(input_unsure_boolean, Answers),
    Answers == [input_problems([wrong_type(other_persons_personal_data_requested)]) - []].
test(attested_value_is_wrong_type) :-
    information_answers(input_attested_value, Answers),
    Answers == [input_problems([wrong_type(requester_is_user)]) - []].
test(non_list_profile_is_wrong_type_profile) :-
    access_answers(input_not_a_list, Answers),
    Answers == [input_problems([wrong_type(profile)]) - []],
    data_act_connected_product_data_sharing_assess(input_not_a_list, data_act_connected_product_data_sharing_verdict(input_problems([wrong_type(profile)]), [])).
test(well_formed_profile_has_no_input_problem) :-
    data_act_connected_product_data_sharing_profile_for(thermostat_access_due, Profile),
    data_act_connected_product_data_sharing_input_problems(Profile, []).
test(what_if_direct_access_makes_thermostat_ineligible) :-
    data_act_connected_product_data_sharing_profile_for(thermostat_access_due, Profile),
    findall(Status, data_act_connected_product_data_sharing_what_if(Profile, data_directly_accessible_by_user, true, Status), Statuses),
    Statuses == [ineligible].
test(what_if_measures_kept_makes_tractor_eligible) :-
    data_act_connected_product_data_sharing_profile_for(tractor_trade_secret_measures_breached, Profile),
    data_act_connected_product_data_sharing_what_if(Profile, trade_secret_measures_agreed_and_kept, true, eligible).
test(what_if_supplies_the_absent_requester) :-
    data_act_connected_product_data_sharing_profile_for(access_requester_absent, Profile),
    data_act_connected_product_data_sharing_what_if(Profile, requester_is_user, true, eligible).

test(thermostat_access_due_is_not_not_applicable, fail) :-
    data_act_connected_product_data_sharing_profile_for(thermostat_access_due, Profile),
    user_access_request_status(Profile, not_applicable, _).
test(thermostat_is_not_ineligible, fail) :-
    data_act_connected_product_data_sharing_assess(thermostat_access_due, data_act_connected_product_data_sharing_verdict(ineligible, _)).
test(direct_access_near_miss_is_not_eligible, fail) :-
    data_act_connected_product_data_sharing_assess(thermostat_directly_accessible, data_act_connected_product_data_sharing_verdict(eligible, _)).
test(security_restriction_is_not_access_due, fail) :-
    data_act_connected_product_data_sharing_profile_for(thermostat_security_restriction, Profile),
    user_access_request_status(Profile, access_due, _).
test(other_person_data_with_basis_is_not_withheld, fail) :-
    data_act_connected_product_data_sharing_profile_for(wearable_other_person_data_with_basis, Profile),
    user_access_request_status(Profile, personal_data_not_to_be_made_available, _).
test(trade_secret_measures_kept_is_not_withholding, fail) :-
    data_act_connected_product_data_sharing_profile_for(tractor_trade_secret_measures_kept, Profile),
    user_access_request_status(Profile, withholding_permitted_trade_secrets, _).
test(exceptional_refusal_is_not_eligible, fail) :-
    data_act_connected_product_data_sharing_profile_for(tractor_exceptional_refusal, Profile),
    data_act_connected_product_data_sharing_status(Profile, eligible).
test(absent_requester_is_not_eligible, fail) :-
    data_act_connected_product_data_sharing_assess(access_requester_absent, data_act_connected_product_data_sharing_verdict(eligible, _)).
test(unsure_data_holder_is_not_access_due, fail) :-
    data_act_connected_product_data_sharing_profile_for(access_data_holder_unsure, Profile),
    user_access_request_status(Profile, access_due, _).
test(checklist_refused_for_an_input_problem, fail) :-
    subject_checklist(input_unknown_key, _).
test(small_enterprise_not_exempt_is_not_not_applicable, fail) :-
    data_act_connected_product_data_sharing_profile_for(small_enterprise_not_exempt, Profile),
    user_access_request_status(Profile, not_applicable, _).
test(design_default_access_missing_is_not_met_only, fail) :-
    data_act_connected_product_data_sharing_profile_for(design_default_access_missing, Profile),
    product_design_duty_status(Profile, design_duty_met, _).
test(placed_before_september_2026_is_not_met, fail) :-
    data_act_connected_product_data_sharing_profile_for(placed_before_september_2026, Profile),
    product_design_duty_status(Profile, design_duty_met, _).
test(related_service_information_withheld_is_not_met_only, fail) :-
    data_act_connected_product_data_sharing_profile_for(related_service_information_withheld, Profile),
    pre_contract_information_duty_status(Profile, information_duty_met, _).
test(gatekeeper_is_not_sharing_due, fail) :-
    data_act_connected_product_data_sharing_profile_for(gatekeeper_recipient, Profile),
    third_party_sharing_request_status(Profile, sharing_due, _).
test(prototype_testing_permitted_is_not_not_applicable, fail) :-
    data_act_connected_product_data_sharing_profile_for(prototype_testing_permitted, Profile),
    third_party_sharing_request_status(Profile, not_applicable, _).
test(sharing_trade_secret_measures_breached_is_not_sharing_due, fail) :-
    data_act_connected_product_data_sharing_profile_for(sharing_trade_secret_measures_breached, Profile),
    third_party_sharing_request_status(Profile, sharing_due, _).
test(input_problem_profile_gets_no_final_answer, fail) :-
    data_act_connected_product_data_sharing_profile_for(input_unknown_key, Profile),
    user_access_request_status(Profile, not_applicable, _).
test(what_if_measures_kept_is_not_ineligible, fail) :-
    data_act_connected_product_data_sharing_profile_for(tractor_trade_secret_measures_breached, Profile),
    data_act_connected_product_data_sharing_what_if(Profile, trade_secret_measures_agreed_and_kept, true, ineligible).

cp_test_names([every_subject_answers_each_query_exactly_once, status_vocabulary_is_eligible_and_ineligible, profile_keys_are_the_twenty_two, thermostat_access_is_due, thermostat_is_eligible, direct_access_near_miss_is_not_applicable, direct_access_near_miss_is_ineligible, security_restriction_permits_refusal, security_restriction_is_ineligible, other_person_data_without_basis_is_withheld, other_person_data_with_basis_near_miss_is_due, other_person_data_eligibility_flips, trade_secret_measures_breached_permit_withholding, trade_secret_measures_kept_near_miss_is_due, trade_secret_breach_is_ineligible, exceptional_refusal_goes_to_a_lawyer, exceptional_refusal_passes_through_the_facade, absent_requester_is_asked_for, absent_requester_is_indeterminate_through_the_facade, unsure_data_holder_is_referred, checklist_all_met_when_access_is_due, checklist_marks_direct_access_unmet, checklist_marks_unsure_data_holder_unknown, checklist_marks_absent_requester_unknown, checklist_marks_breached_measures_unmet, checklist_present_for_a_well_formed_profile, not_connected_product_is_not_applicable_everywhere, small_enterprise_exempt_is_not_applicable_everywhere, small_enterprise_not_exempt_near_miss_asks_for_the_next_key, design_duty_met_on_a_complete_profile, design_default_access_missing_near_miss_is_not_met, placed_before_september_2026_is_not_applicable, purchase_information_given_is_met, related_service_information_given_is_met, related_service_information_withheld_near_miss_is_not_met, information_kind_absent_is_asked_for, sharing_is_due_on_a_clean_profile, gatekeeper_is_not_an_eligible_third_party, prototype_testing_not_permitted_is_not_applicable, prototype_testing_permitted_near_miss_is_due, sharing_other_person_data_without_basis_is_withheld, sharing_trade_secret_not_strictly_necessary_is_not_permitted, sharing_trade_secret_measures_breached_permit_withholding, sharing_exceptional_refusal_goes_to_a_lawyer, unknown_key_is_an_input_problem, duplicate_key_is_an_input_problem, unsure_boolean_is_wrong_type, attested_value_is_wrong_type, non_list_profile_is_wrong_type_profile, well_formed_profile_has_no_input_problem, what_if_direct_access_makes_thermostat_ineligible, what_if_measures_kept_makes_tractor_eligible, what_if_supplies_the_absent_requester]).
cp_test_fail_names([thermostat_access_due_is_not_not_applicable, thermostat_is_not_ineligible, direct_access_near_miss_is_not_eligible, security_restriction_is_not_access_due, other_person_data_with_basis_is_not_withheld, trade_secret_measures_kept_is_not_withholding, exceptional_refusal_is_not_eligible, absent_requester_is_not_eligible, unsure_data_holder_is_not_access_due, checklist_refused_for_an_input_problem, small_enterprise_not_exempt_is_not_not_applicable, design_default_access_missing_is_not_met_only, placed_before_september_2026_is_not_met, related_service_information_withheld_is_not_met_only, gatekeeper_is_not_sharing_due, prototype_testing_permitted_is_not_not_applicable, sharing_trade_secret_measures_breached_is_not_sharing_due, input_problem_profile_gets_no_final_answer, what_if_measures_kept_is_not_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
