% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_28_minors_order_dsa_art_28_minors_order, [section_3_application_status/4, art_28_1_obligation_status/4, art_28_1_compliance_status/4, art_28_2_advertising_status/4, dsa_art_28_minors_order_status/2, dsa_art_28_minors_order_status_values/1]).
:- use_module(m__eu_dsa_art_28_minors_order_kernel, [dsa_art_28_minors_order_input_problems/2]).
:- use_module(m__eu_dsa_art_28_minors_order_fixtures, [dsa_art_28_minors_order_profile_for/2]).

test(complied_holds_with_the_status_bound) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    dsa_art_28_minors_order_status(Profile, dsa_art_28_minors_order_complied).
test(breached_holds_with_the_status_bound) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_inadequate, Profile),
    dsa_art_28_minors_order_status(Profile, dsa_art_28_minors_order_breached).
test(not_engaged_holds_with_the_status_bound) :-
    dsa_art_28_minors_order_profile_for(medium_provider_platform_not_accessible_to_minors, Profile),
    dsa_art_28_minors_order_status(Profile, dsa_art_28_minors_order_not_engaged).
test(the_bound_status_atoms_are_in_the_table) :-
    dsa_art_28_minors_order_status_values(StatusValues),
    member(dsa_art_28_minors_order_complied, StatusValues),
    member(dsa_art_28_minors_order_breached, StatusValues),
    member(dsa_art_28_minors_order_not_engaged, StatusValues).
test(section_3_applies_holds_with_every_output_bound) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    section_3_application_status(Profile, section_3_applies, [], [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]).
test(section_3_not_applicable_holds_with_its_basis_bound) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_not_designated, Profile),
    section_3_application_status(Profile, section_3_not_applicable, [outside_fact(designated_as_very_large_online_platform, attested(false, attestation(host_user, recorded_moment, commission_list_checked, none)))], [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]).
test(obligation_not_applicable_holds_with_every_output_bound) :-
    dsa_art_28_minors_order_profile_for(medium_provider_platform_not_accessible_to_minors, Profile),
    art_28_1_obligation_status(Profile, art_28_1_obligation_not_applicable, [], [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
test(measures_not_compliant_holds_with_every_output_bound) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_inadequate, Profile),
    art_28_1_compliance_status(Profile, art_28_1_measures_not_compliant, [], [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
test(presentation_prohibited_holds_with_every_output_bound) :-
    dsa_art_28_minors_order_profile_for(profiled_advertising_to_recipient_known_minor, Profile),
    art_28_2_advertising_status(Profile, art_28_2_presentation_prohibited, [], [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)]).
test(a_list_with_a_foreign_element_is_wrong_type) :-
    dsa_art_28_minors_order_input_problems([attribute(platform_accessible_to_minors, true), colour], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_is_not_a_profile) :-
    dsa_art_28_minors_order_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(an_empty_profile_has_no_problem) :-
    dsa_art_28_minors_order_input_problems([], Problems),
    Problems == [].
test(a_numeric_key_is_an_unknown_key) :-
    dsa_art_28_minors_order_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    dsa_art_28_minors_order_input_problems([attribute(advertisements_presented_to_recipient_on_interface, unsure)], Problems),
    Problems == [wrong_type(advertisements_presented_to_recipient_on_interface)].
test(a_judgement_given_unsure_is_well_formed) :-
    dsa_art_28_minors_order_input_problems([attribute(platform_accessible_to_minors, unsure)], Problems),
    Problems == [].
test(a_plain_designation_value_is_wrong_type) :-
    dsa_art_28_minors_order_input_problems([attribute(designated_as_very_large_online_platform, true)], Problems),
    Problems == [wrong_type(designated_as_very_large_online_platform)].
test(an_attestation_of_three_arguments_is_wrong_type) :-
    dsa_art_28_minors_order_input_problems([attribute(designated_as_very_large_online_platform, attested(true, attestation(host_user, recorded_moment, stated)))], Problems),
    Problems == [wrong_type(designated_as_very_large_online_platform)].
test(an_attested_value_outside_true_and_false_is_wrong_type) :-
    dsa_art_28_minors_order_input_problems([attribute(designated_as_very_large_online_platform, attested(unsure, attestation(host_user, recorded_moment, stated, none)))], Problems),
    Problems == [wrong_type(designated_as_very_large_online_platform)].
test(an_attestation_with_any_four_arguments_is_well_formed) :-
    dsa_art_28_minors_order_input_problems([attribute(designated_as_very_large_online_platform, attested(true, attestation(host_user, recorded_moment, commission_list_checked, url(address, retrieved_moment))))], Problems),
    Problems == [].
test(a_repeated_contract_key_is_one_duplicate_key) :-
    dsa_art_28_minors_order_input_problems([attribute(platform_accessible_to_minors, true), attribute(platform_accessible_to_minors, maybe)], Problems),
    Problems == [duplicate_key(platform_accessible_to_minors)].
test(a_repeated_unknown_key_is_named_once) :-
    dsa_art_28_minors_order_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(problems_come_in_contract_order_then_unknown_keys) :-
    dsa_art_28_minors_order_input_problems([attribute(colour, red), attribute(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, maybe), attribute(platform_accessible_to_minors, maybe)], Problems),
    Problems == [wrong_type(platform_accessible_to_minors), wrong_type(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors), unknown_key(colour)].
test(every_query_answers_input_problems_with_no_basis_and_no_citation) :-
    WrongProfile = [attribute(platform_accessible_to_minors, maybe)],
    findall(Result - Basis - Citations, section_3_application_status(WrongProfile, Result, Basis, Citations), SectionAnswers),
    findall(Result - Basis - Citations, art_28_1_obligation_status(WrongProfile, Result, Basis, Citations), ObligationAnswers),
    findall(Result - Basis - Citations, art_28_1_compliance_status(WrongProfile, Result, Basis, Citations), ComplianceAnswers),
    findall(Result - Basis - Citations, art_28_2_advertising_status(WrongProfile, Result, Basis, Citations), AdvertisingAnswers),
    SectionAnswers == [input_problems([wrong_type(platform_accessible_to_minors)]) - [] - []],
    ObligationAnswers == [input_problems([wrong_type(platform_accessible_to_minors)]) - [] - []],
    ComplianceAnswers == [input_problems([wrong_type(platform_accessible_to_minors)]) - [] - []],
    AdvertisingAnswers == [input_problems([wrong_type(platform_accessible_to_minors)]) - [] - []].
test(a_term_that_is_not_a_profile_is_answered_by_every_query) :-
    findall(Result, section_3_application_status(not_a_profile, Result, _, _), SectionResults),
    findall(Result, art_28_2_advertising_status(not_a_profile, Result, _, _), AdvertisingResults),
    SectionResults == [input_problems([wrong_type(profile)])],
    AdvertisingResults == [input_problems([wrong_type(profile)])].
test(a_key_no_query_reads_is_still_checked) :-
    findall(Result, section_3_application_status([attribute(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, maybe)], Result, _, _), Results),
    Results == [input_problems([wrong_type(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors)])].

test(the_complied_profile_rejects_breached, fail) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    dsa_art_28_minors_order_status(Profile, dsa_art_28_minors_order_breached).
test(the_complied_profile_rejects_not_engaged, fail) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    dsa_art_28_minors_order_status(Profile, dsa_art_28_minors_order_not_engaged).
test(the_breached_profile_rejects_complied, fail) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_inadequate, Profile),
    dsa_art_28_minors_order_status(Profile, dsa_art_28_minors_order_complied).
test(section_3_applies_rejects_a_shortened_citation_list, fail) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    section_3_application_status(Profile, section_3_applies, [], [cite(eu_reg_2022_2065_art_19_1)]).
test(section_3_not_applicable_rejects_an_empty_basis, fail) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_not_designated, Profile),
    section_3_application_status(Profile, section_3_not_applicable, [], _).
test(presentation_prohibited_rejects_not_prohibited, fail) :-
    dsa_art_28_minors_order_profile_for(profiled_advertising_to_recipient_known_minor, Profile),
    art_28_2_advertising_status(Profile, art_28_2_presentation_not_prohibited, _, _).

cp_test_names([complied_holds_with_the_status_bound, breached_holds_with_the_status_bound, not_engaged_holds_with_the_status_bound, the_bound_status_atoms_are_in_the_table, section_3_applies_holds_with_every_output_bound, section_3_not_applicable_holds_with_its_basis_bound, obligation_not_applicable_holds_with_every_output_bound, measures_not_compliant_holds_with_every_output_bound, presentation_prohibited_holds_with_every_output_bound, a_list_with_a_foreign_element_is_wrong_type, an_atom_is_not_a_profile, an_empty_profile_has_no_problem, a_numeric_key_is_an_unknown_key, a_crisp_key_given_unsure_is_wrong_type, a_judgement_given_unsure_is_well_formed, a_plain_designation_value_is_wrong_type, an_attestation_of_three_arguments_is_wrong_type, an_attested_value_outside_true_and_false_is_wrong_type, an_attestation_with_any_four_arguments_is_well_formed, a_repeated_contract_key_is_one_duplicate_key, a_repeated_unknown_key_is_named_once, problems_come_in_contract_order_then_unknown_keys, every_query_answers_input_problems_with_no_basis_and_no_citation, a_term_that_is_not_a_profile_is_answered_by_every_query, a_key_no_query_reads_is_still_checked]).
cp_test_fail_names([the_complied_profile_rejects_breached, the_complied_profile_rejects_not_engaged, the_breached_profile_rejects_complied, section_3_applies_rejects_a_shortened_citation_list, section_3_not_applicable_rejects_an_empty_basis, presentation_prohibited_rejects_not_prohibited]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
