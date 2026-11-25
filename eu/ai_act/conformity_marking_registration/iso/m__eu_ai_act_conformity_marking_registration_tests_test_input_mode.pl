% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_conformity_marking_registration_conformity_marking_registration, [conformity_assessment_procedure/4, annex_vii_notified_body/4, new_conformity_assessment_status/4, declaration_of_conformity_status/4, declaration_keeping_status/4, ce_marking_status/5, registration_status/5, listed_items/3, conformity_marking_registration_status/2, conformity_marking_registration_status_values/1]).
:- use_module(m__eu_ai_act_conformity_marking_registration_kernel, [conformity_marking_registration_input_problems/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_fixtures, [conformity_marking_registration_profile_for/2]).

subject_case(Subject, Profile, AssessmentDate) :-
    conformity_marking_registration_profile_for(Subject, assessment(Profile, AssessmentDate)).

test(status_holds_with_the_verdict_bound) :-
    conformity_marking_registration_profile_for(point_three_internal_control, AssessmentCase),
    conformity_marking_registration_status(AssessmentCase, high_risk_obligations_apply).
test(the_procedure_holds_with_the_result_bound) :-
    subject_case(point_two_internal_control, Profile, AssessmentDate),
    conformity_assessment_procedure(Profile, AssessmentDate, internal_control_under_annex_vi, _).
test(the_notified_body_holds_with_the_result_bound) :-
    subject_case(point_one_law_enforcement, Profile, AssessmentDate),
    annex_vii_notified_body(Profile, AssessmentDate, market_surveillance_authority_acts_as_notified_body, [cite(eu_reg_2024_1689_art_43_1)]).
test(the_new_assessment_holds_with_the_result_bound) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    new_conformity_assessment_status(Profile, AssessmentDate, new_conformity_assessment_required, _).
test(the_declaration_holds_with_the_result_bound) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    declaration_of_conformity_status(Profile, AssessmentDate, declaration_under_this_regulation, [cite(eu_reg_2024_1689_art_47_1)]).
test(the_marking_element_holds_with_the_result_bound) :-
    subject_case(point_three_internal_control, Profile, AssessmentDate),
    ce_marking_status(Profile, ce_marking_affixed_to_the_system, AssessmentDate, marking_element_required, _).
test(the_registration_holds_with_the_result_bound) :-
    subject_case(point_two_internal_control, Profile, AssessmentDate),
    registration_status(Profile, provider, AssessmentDate, registration_at_national_level, _).
test(the_keeping_status_holds_fully_bound) :-
    declaration_keeping_status(date(2027, 12, 2), date(2037, 12, 2), declaration_to_be_kept, [cite(eu_reg_2024_1689_art_47_1)]).
test(the_items_hold_fully_bound) :-
    listed_items(annex_viii_section_c_secure_section, [name_address_and_contact_details_of_the_deployer, name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_deployer, url_of_the_providers_entry_in_the_eu_database], _).
test(an_unknown_key_is_named) :-
    conformity_marking_registration_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(an_unknown_key_is_named_once_however_often_it_repeats) :-
    conformity_marking_registration_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(a_number_key_is_an_unknown_key) :-
    conformity_marking_registration_input_problems([attribute(42, true)], [unknown_key(42)]).
test(an_unbound_key_is_an_unknown_key_as_given) :-
    conformity_marking_registration_input_problems([attribute(Key, true)], Problems),
    Problems = [unknown_key(Found)],
    Found == Key.
test(an_unbound_value_is_a_wrong_type) :-
    conformity_marking_registration_input_problems([attribute(provided_digitally, _)], [wrong_type(provided_digitally)]).
test(a_judgement_given_maybe_is_a_wrong_type) :-
    conformity_marking_registration_input_problems([attribute(substantial_modification, maybe)], [wrong_type(substantial_modification)]).
test(a_judgement_given_unsure_is_well_typed) :-
    conformity_marking_registration_input_problems([attribute(substantial_modification, unsure)], []).
test(an_unknown_point_is_a_wrong_type) :-
    conformity_marking_registration_input_problems([attribute(annex_iii_point, annex_iii_point_9)], [wrong_type(annex_iii_point)]).
test(a_duplicate_key_is_never_also_a_wrong_type) :-
    conformity_marking_registration_input_problems([attribute(substantial_modification, maybe), attribute(substantial_modification, maybe)], [duplicate_key(substantial_modification)]).
test(contract_problems_come_in_contract_order_then_unknown_keys) :-
    conformity_marking_registration_input_problems([attribute(colour, red), attribute(provided_digitally, unsure), attribute(annex_iii_point, nine)], [wrong_type(annex_iii_point), wrong_type(provided_digitally), unknown_key(colour)]).
test(a_partial_list_is_not_a_profile) :-
    conformity_marking_registration_input_problems([attribute(provided_digitally, true)|_], [wrong_type(profile)]).
test(a_list_with_a_stray_element_is_not_a_profile) :-
    conformity_marking_registration_input_problems([attribute(provided_digitally, true), colour], [wrong_type(profile)]).
test(a_list_with_an_unbound_element_is_not_a_profile) :-
    conformity_marking_registration_input_problems([_], [wrong_type(profile)]).
test(a_profile_problem_answers_first) :-
    conformity_assessment_procedure([attribute(colour, red)], date(2029, 1, 1), input_problems([unknown_key(colour)]), []).
test(a_profile_problem_answers_even_before_the_application_day) :-
    new_conformity_assessment_status([attribute(provided_digitally, maybe)], date(2026, 1, 1), input_problems([wrong_type(provided_digitally)]), []).
test(an_impossible_assessment_date_is_a_wrong_type) :-
    declaration_of_conformity_status([], date(2029, 2, 29), input_problems([wrong_type(assessment_date)]), []).
test(an_unbound_assessment_date_is_a_wrong_type) :-
    annex_vii_notified_body([], _, input_problems([wrong_type(assessment_date)]), []).
test(the_element_problem_sits_between_the_profile_and_the_date) :-
    ce_marking_status([attribute(colour, red)], colour, tomorrow, input_problems([unknown_key(colour), wrong_type(element), wrong_type(assessment_date)]), []).
test(an_unbound_element_is_a_wrong_type) :-
    ce_marking_status([], _, date(2029, 1, 1), input_problems([wrong_type(element)]), []).
test(an_unknown_registrant_is_a_wrong_type) :-
    registration_status([], importer, date(2029, 1, 1), input_problems([wrong_type(registrant)]), []).
test(an_unknown_item_list_is_a_wrong_type) :-
    listed_items(annex_x, input_problems([wrong_type(item_list)]), []).
test(an_unbound_item_list_is_a_wrong_type) :-
    listed_items(_, input_problems([wrong_type(item_list)]), []).
test(both_keeping_dates_impossible) :-
    declaration_keeping_status(today, date(2029, 13, 1), input_problems([wrong_type(placing_date), wrong_type(assessment_date)]), []).
test(an_assessment_before_the_placing_is_the_added_check) :-
    declaration_keeping_status(date(2030, 1, 2), date(2030, 1, 1), input_problems([wrong_type(assessment_date)]), []).
test(an_assessment_on_the_placing_day_passes_the_added_check) :-
    declaration_keeping_status(date(2030, 1, 2), date(2030, 1, 2), declaration_to_be_kept, [cite(eu_reg_2024_1689_art_47_1)]).

test(every_other_bound_status_is_rejected, fail) :-
    conformity_marking_registration_profile_for(point_three_internal_control, AssessmentCase),
    conformity_marking_registration_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, high_risk_obligations_apply),
    conformity_marking_registration_status(AssessmentCase, Other).
test(a_wrong_bound_procedure_is_rejected, fail) :-
    subject_case(point_two_internal_control, Profile, AssessmentDate),
    conformity_assessment_procedure(Profile, AssessmentDate, notified_body_procedure_under_annex_vii, _).
test(the_providers_choice_is_rejected_for_law_enforcement, fail) :-
    subject_case(point_one_law_enforcement, Profile, AssessmentDate),
    annex_vii_notified_body(Profile, AssessmentDate, notified_body_of_the_providers_choice, _).
test(the_keeping_status_rejects_the_ended_atom_on_the_end_day, fail) :-
    declaration_keeping_status(date(2027, 12, 2), date(2037, 12, 2), keeping_period_ended, _).
test(the_items_reject_a_different_order, fail) :-
    listed_items(annex_viii_section_c_secure_section, [name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_deployer, name_address_and_contact_details_of_the_deployer, url_of_the_providers_entry_in_the_eu_database], _).

cp_test_names([status_holds_with_the_verdict_bound, the_procedure_holds_with_the_result_bound, the_notified_body_holds_with_the_result_bound, the_new_assessment_holds_with_the_result_bound, the_declaration_holds_with_the_result_bound, the_marking_element_holds_with_the_result_bound, the_registration_holds_with_the_result_bound, the_keeping_status_holds_fully_bound, the_items_hold_fully_bound, an_unknown_key_is_named, an_unknown_key_is_named_once_however_often_it_repeats, a_number_key_is_an_unknown_key, an_unbound_key_is_an_unknown_key_as_given, an_unbound_value_is_a_wrong_type, a_judgement_given_maybe_is_a_wrong_type, a_judgement_given_unsure_is_well_typed, an_unknown_point_is_a_wrong_type, a_duplicate_key_is_never_also_a_wrong_type, contract_problems_come_in_contract_order_then_unknown_keys, a_partial_list_is_not_a_profile, a_list_with_a_stray_element_is_not_a_profile, a_list_with_an_unbound_element_is_not_a_profile, a_profile_problem_answers_first, a_profile_problem_answers_even_before_the_application_day, an_impossible_assessment_date_is_a_wrong_type, an_unbound_assessment_date_is_a_wrong_type, the_element_problem_sits_between_the_profile_and_the_date, an_unbound_element_is_a_wrong_type, an_unknown_registrant_is_a_wrong_type, an_unknown_item_list_is_a_wrong_type, an_unbound_item_list_is_a_wrong_type, both_keeping_dates_impossible, an_assessment_before_the_placing_is_the_added_check, an_assessment_on_the_placing_day_passes_the_added_check]).
cp_test_fail_names([every_other_bound_status_is_rejected, a_wrong_bound_procedure_is_rejected, the_providers_choice_is_rejected_for_law_enforcement, the_keeping_status_rejects_the_ended_atom_on_the_end_day, the_items_reject_a_different_order]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
