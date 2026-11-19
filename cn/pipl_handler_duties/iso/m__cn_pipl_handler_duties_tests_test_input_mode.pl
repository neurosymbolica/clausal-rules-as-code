% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_handler_duties_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_handler_duties_pipl_handler_duties, [duty_status/4, duty_contents/2, pipl_handler_duties_status/2]).
:- use_module(m__cn_pipl_handler_duties_kernel, [pipl_handler_duties_input_problems/2]).
:- use_module(m__cn_pipl_handler_duties_fixtures, [pipl_handler_duties_profile_for/2]).

test(bound_required_holds_for_a_handler) :-
    pipl_handler_duties_profile_for(handler_only, Profile),
    duty_status(compliance_measures, Profile, required, [cite(cn_pipl_art_51_p1), cite(cn_pipl_art_73_p1_i1)]).
test(bound_missing_key_holds) :-
    pipl_handler_duties_profile_for(handler_unstated, Profile),
    duty_status(compliance_audit, Profile, indeterminate([decides_purposes_and_means]), []).
test(bound_referral_holds) :-
    pipl_handler_duties_profile_for(handler_unsure, Profile),
    duty_status(compliance_audit, Profile, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure])]), []).
test(bound_not_in_force_holds) :-
    pipl_handler_duties_profile_for(day_before_entry_into_force, Profile),
    duty_status(impact_assessment, Profile, not_in_force, [cite(cn_pipl_art_74_p1)]).
test(bound_pinned_text_not_applicable_holds) :-
    pipl_handler_duties_profile_for(amended_text, Profile),
    duty_status(large_platform_obligations, Profile, pinned_text_not_applicable, []).
test(bound_three_year_retention_holds) :-
    pipl_handler_duties_profile_for(automated_decision_handler, Profile),
    duty_status(assessment_record_retention, Profile, required_for_at_least_three_years, [cite(cn_pipl_art_56_p2), cite(cn_pipl_art_55_p1), cite(cn_pipl_art_55_p1_i1), cite(cn_pipl_art_55_p1_i2), cite(cn_pipl_art_55_p1_i3), cite(cn_pipl_art_55_p1_i4), cite(cn_pipl_art_55_p1_i5), cite(cn_pipl_art_73_p1_i1), cite(cn_pipl_art_73_p1_i2)]).
test(bound_immediate_remedial_measures_hold) :-
    pipl_handler_duties_profile_for(incident_harm_not_avoided, Profile),
    duty_status(breach_remedial_measures, Profile, required_immediately, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_73_p1_i1)]).
test(bound_contents_hold) :-
    duty_contents(impact_assessment, [content_item(lawfulness_legitimacy_and_necessity_of_purpose_and_method, cite(cn_pipl_art_56_p1_i1)), content_item(impact_on_rights_and_security_risks, cite(cn_pipl_art_56_p1_i2)), content_item(lawfulness_effectiveness_and_proportionality_of_protection_measures, cite(cn_pipl_art_56_p1_i3))]).
test(bound_facade_status_holds) :-
    pipl_handler_duties_profile_for(handler_only, Profile),
    pipl_handler_duties_status(Profile, duties_owed).
test(attribute_order_does_not_change_the_answer) :-
    pipl_handler_duties_profile_for(offshore_services_handler, Profile),
    reverse(Profile, ReversedProfile),
    duty_status(china_representative, ReversedProfile, required, _).
test(an_absent_key_is_not_a_problem) :-
    pipl_handler_duties_input_problems([], []).
test(an_atom_profile_is_not_an_attribute_list) :-
    pipl_handler_duties_input_problems(stray, [wrong_type(profile)]).
test(a_number_key_is_unknown) :-
    pipl_handler_duties_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_compound_key_is_unknown_as_given) :-
    pipl_handler_duties_input_problems([attribute(colour(red), true)], [unknown_key(colour(red))]).
test(a_date_as_an_atom_is_wrong_type) :-
    pipl_handler_duties_input_problems([attribute(reference_date, '2024-01-01')], [wrong_type(reference_date)]).
test(february_the_thirtieth_is_wrong_type) :-
    pipl_handler_duties_input_problems([attribute(reference_date, date(2024, 2, 30))], [wrong_type(reference_date)]).
test(month_thirteen_is_wrong_type) :-
    pipl_handler_duties_input_problems([attribute(reference_date, date(2024, 13, 1))], [wrong_type(reference_date)]).
test(a_leap_day_in_a_leap_year_is_a_day) :-
    pipl_handler_duties_input_problems([attribute(reference_date, date(2024, 2, 29))], []).
test(a_judgement_given_another_atom_is_wrong_type) :-
    pipl_handler_duties_input_problems([attribute(important_platform_handler, maybe)], [wrong_type(important_platform_handler)]).
test(a_judgement_given_unsure_is_well_formed) :-
    pipl_handler_duties_input_problems([attribute(important_platform_handler, unsure)], []).
test(a_duplicate_is_named_whatever_its_values) :-
    pipl_handler_duties_input_problems([attribute(decides_purposes_and_means, true), attribute(decides_purposes_and_means, true)], [duplicate_key(decides_purposes_and_means)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    pipl_handler_duties_input_problems([attribute(colour, red), attribute(important_platform_handler, maybe), attribute(reference_date, date(2024, 1, 1)), attribute(reference_date, date(2024, 1, 2))], [duplicate_key(reference_date), wrong_type(important_platform_handler), unknown_key(colour)]).
test(a_profile_with_problems_gets_only_its_problems) :-
    duty_status(compliance_measures, [attribute(reaches_officer_quantity, unsure)], input_problems([wrong_type(reaches_officer_quantity)]), []).
test(the_input_check_comes_before_not_in_force) :-
    duty_status(compliance_measures, [attribute(reference_date, date(2020, 1, 1)), attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(a_key_the_duty_does_not_read_is_still_checked) :-
    pipl_handler_duties_profile_for(entrusted_party, Profile),
    append(Profile, [attribute(handler_located_outside_china, unsure)], BadProfile),
    duty_status(entrusted_party_safeguards, BadProfile, input_problems([wrong_type(handler_located_outside_china)]), []).

test(bound_not_required_is_rejected_for_a_handler, fail) :-
    pipl_handler_duties_profile_for(handler_only, Profile),
    duty_status(compliance_measures, Profile, not_required, _).
test(bound_citations_of_another_duty_are_rejected, fail) :-
    pipl_handler_duties_profile_for(handler_only, Profile),
    duty_status(compliance_measures, Profile, required, [cite(cn_pipl_art_54_p1), cite(cn_pipl_art_73_p1_i1)]).
test(bound_contents_in_another_order_are_rejected, fail) :-
    duty_contents(breach_notice, [content_item(handler_contact_details, cite(cn_pipl_art_57_p1_i3)), content_item(categories_causes_and_possible_harm, cite(cn_pipl_art_57_p1_i1)), content_item(remedial_measures_and_steps_individuals_can_take, cite(cn_pipl_art_57_p1_i2))]).
test(bound_other_facade_status_is_rejected, fail) :-
    pipl_handler_duties_profile_for(handler_only, Profile),
    pipl_handler_duties_status(Profile, no_duties_owed).
test(a_problem_profile_gets_no_final_answer, fail) :-
    duty_status(entrusted_party_safeguards, [attribute(processes_on_entrustment, unsure)], required, _).

cp_test_names([bound_required_holds_for_a_handler, bound_missing_key_holds, bound_referral_holds, bound_not_in_force_holds, bound_pinned_text_not_applicable_holds, bound_three_year_retention_holds, bound_immediate_remedial_measures_hold, bound_contents_hold, bound_facade_status_holds, attribute_order_does_not_change_the_answer, an_absent_key_is_not_a_problem, an_atom_profile_is_not_an_attribute_list, a_number_key_is_unknown, a_compound_key_is_unknown_as_given, a_date_as_an_atom_is_wrong_type, february_the_thirtieth_is_wrong_type, month_thirteen_is_wrong_type, a_leap_day_in_a_leap_year_is_a_day, a_judgement_given_another_atom_is_wrong_type, a_judgement_given_unsure_is_well_formed, a_duplicate_is_named_whatever_its_values, problems_come_in_contract_order_then_unknown_keys, a_profile_with_problems_gets_only_its_problems, the_input_check_comes_before_not_in_force, a_key_the_duty_does_not_read_is_still_checked]).
cp_test_fail_names([bound_not_required_is_rejected_for_a_handler, bound_citations_of_another_duty_are_rejected, bound_contents_in_another_order_are_rejected, bound_other_facade_status_is_rejected, a_problem_profile_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
