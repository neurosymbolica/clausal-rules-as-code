% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_28_minors_order_dsa_art_28_minors_order, [section_3_application_status/4, art_28_1_obligation_status/4, art_28_1_compliance_status/4, art_28_2_advertising_status/4, decide_dsa_art_28_minors_order/2, dsa_art_28_minors_order_status/2]).
:- use_module(m__eu_dsa_art_28_minors_order_fixtures, [dsa_art_28_minors_order_subject/1, dsa_art_28_minors_order_profile_for/2]).

expected_status(medium_provider_accessible_platform_measures_adequate, dsa_art_28_minors_order_complied).
expected_status(medium_provider_accessible_platform_measures_inadequate, dsa_art_28_minors_order_breached).
expected_status(medium_provider_platform_not_accessible_to_minors, dsa_art_28_minors_order_not_engaged).
expected_status(profiled_advertising_to_recipient_known_minor, dsa_art_28_minors_order_breached).
expected_status(profiled_advertising_recipient_not_known_minor, dsa_art_28_minors_order_not_engaged).
expected_status(small_enterprise_stated_not_designated, dsa_art_28_minors_order_not_engaged).
expected_status(small_enterprise_stated_designated, dsa_art_28_minors_order_breached).
expected_status(provider_within_twelve_months_stated_not_designated, dsa_art_28_minors_order_not_engaged).
expected_status(provider_past_twelve_months_medium_enterprise, dsa_art_28_minors_order_complied).
expected_status(small_enterprise_designation_not_shown, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([platform_accessible_to_minors - true, designated_as_very_large_online_platform - absent, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - true])])).
expected_status(designated_provider_enterprise_facts_absent, dsa_art_28_minors_order_complied).
expected_status(empty_profile, indeterminate([platform_accessible_to_minors])).
expected_status(enterprise_run_off_fact_absent, indeterminate([provider_within_12_months_after_losing_micro_or_small_status])).
expected_status(accessibility_judgement_unsure, needs_legal_review(open_textured(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - unsure, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - true])])).
expected_status(measures_judgement_unsure, needs_legal_review(open_textured(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - true, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - unsure])])).
expected_status(profiling_judgement_unsure, needs_legal_review(open_textured(advertisements_based_on_profiling_of_recipient, cite(eu_reg_2022_2065_art_28_2)), [inputs_relied_on([advertisements_based_on_profiling_of_recipient - unsure, aware_with_reasonable_certainty_recipient_is_minor - true])])).
expected_status(awareness_judgement_unsure, needs_legal_review(open_textured(aware_with_reasonable_certainty_recipient_is_minor, cite(eu_reg_2022_2065_art_28_2)), [inputs_relied_on([advertisements_based_on_profiling_of_recipient - true, aware_with_reasonable_certainty_recipient_is_minor - unsure])])).
expected_status(profile_with_unknown_key, input_problems([unknown_key(colour)])).
expected_status(profile_with_wrong_type, input_problems([wrong_type(platform_accessible_to_minors)])).
expected_status(profile_with_duplicate_key, input_problems([duplicate_key(provider_qualifies_as_micro_or_small_enterprise)])).

subject_status_matches(Subject) :-
    dsa_art_28_minors_order_subject(Subject),
    expected_status(Subject, ExpectedStatus),
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    findall(Status, dsa_art_28_minors_order_status(Profile, Status), Statuses),
    Statuses == [ExpectedStatus].

test(every_fixture_gives_its_one_expected_status) :-
    findall(Subject, dsa_art_28_minors_order_subject(Subject), Subjects),
    findall(Subject, subject_status_matches(Subject), MatchingSubjects),
    MatchingSubjects == Subjects.
test(a_final_verdict_cites_all_four_provisions) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    findall(Verdict, decide_dsa_art_28_minors_order(Profile, Verdict), Verdicts),
    Verdicts == [dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_complied, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1), cite(eu_reg_2022_2065_art_28_2)])].
test(a_not_final_verdict_cites_nothing) :-
    dsa_art_28_minors_order_profile_for(empty_profile, Profile),
    findall(Verdict, decide_dsa_art_28_minors_order(Profile, Verdict), Verdicts),
    Verdicts == [dsa_art_28_minors_order_verdict(indeterminate([platform_accessible_to_minors]), [])].
test(step_1_neither_exempt_fact_gives_section_3_applies) :-
    dsa_art_28_minors_order_profile_for(provider_past_twelve_months_medium_enterprise, Profile),
    findall(Result - Basis - Citations, section_3_application_status(Profile, Result, Basis, Citations), Answers),
    Answers == [section_3_applies - [] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]].
test(step_2_designation_gives_section_3_applies_with_an_empty_basis) :-
    dsa_art_28_minors_order_profile_for(designated_provider_enterprise_facts_absent, Profile),
    findall(Result - Basis - Citations, section_3_application_status(Profile, Result, Basis, Citations), Answers),
    Answers == [section_3_applies - [] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]].
test(step_3_a_stated_non_designation_is_copied_into_the_basis) :-
    dsa_art_28_minors_order_profile_for(provider_within_twelve_months_stated_not_designated, Profile),
    findall(Result - Basis - Citations, section_3_application_status(Profile, Result, Basis, Citations), Answers),
    Answers == [section_3_not_applicable - [outside_fact(designated_as_very_large_online_platform, attested(false, attestation(host_user, recorded_moment, commission_list_checked, none)))] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]].
test(step_4_an_absent_designation_is_referred_on) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_designation_not_shown, Profile),
    findall(Result - Basis - Citations, section_3_application_status(Profile, Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform - absent])]) - [] - []].
test(step_5_the_absent_run_off_fact_is_named) :-
    dsa_art_28_minors_order_profile_for(enterprise_run_off_fact_absent, Profile),
    findall(Result - Basis - Citations, section_3_application_status(Profile, Result, Basis, Citations), Answers),
    Answers == [indeterminate([provider_within_12_months_after_losing_micro_or_small_status]) - [] - []].
test(step_7_outside_section_3_the_basis_is_not_copied) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_not_designated, Profile),
    findall(Result - Basis - Citations, art_28_1_obligation_status(Profile, Result, Basis, Citations), Answers),
    Answers == [art_28_1_obligation_not_applicable - [] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]].
test(step_8_the_obligation_applies) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    findall(Result - Basis - Citations, art_28_1_obligation_status(Profile, Result, Basis, Citations), Answers),
    Answers == [art_28_1_obligation_applies - [] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]].
test(step_11_the_obligation_waits_on_the_designation) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_designation_not_shown, Profile),
    findall(Result, art_28_1_obligation_status(Profile, Result, _, _), Results),
    Results == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([platform_accessible_to_minors - true, designated_as_very_large_online_platform - absent])])].
test(step_13_no_measures_are_required_outside_the_obligation) :-
    dsa_art_28_minors_order_profile_for(medium_provider_platform_not_accessible_to_minors, Profile),
    findall(Result - Basis - Citations, art_28_1_compliance_status(Profile, Result, Basis, Citations), Answers),
    Answers == [art_28_1_measures_not_required - [] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]].
test(step_14_adequate_measures_comply) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    findall(Result - Basis - Citations, art_28_1_compliance_status(Profile, Result, Basis, Citations), Answers),
    Answers == [art_28_1_measures_compliant - [] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]].
test(step_20_a_false_element_gives_not_prohibited) :-
    dsa_art_28_minors_order_profile_for(profiled_advertising_recipient_not_known_minor, Profile),
    findall(Result - Basis - Citations, art_28_2_advertising_status(Profile, Result, Basis, Citations), Answers),
    Answers == [art_28_2_presentation_not_prohibited - [] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)]].
test(step_21_outside_section_3_gives_the_same_answer) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_not_designated, Profile),
    findall(Result - Basis - Citations, art_28_2_advertising_status(Profile, Result, Basis, Citations), Answers),
    Answers == [art_28_2_presentation_not_prohibited - [] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)]].
test(step_25_the_advertising_ban_waits_on_the_designation) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_designation_not_shown, Profile),
    findall(Result, art_28_2_advertising_status(Profile, Result, _, _), Results),
    Results == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([advertisements_based_on_profiling_of_recipient - true, aware_with_reasonable_certainty_recipient_is_minor - true, designated_as_very_large_online_platform - absent])])].
test(step_23_an_empty_profile_names_the_first_element) :-
    dsa_art_28_minors_order_profile_for(empty_profile, Profile),
    findall(Result, art_28_2_advertising_status(Profile, Result, _, _), Results),
    Results == [indeterminate([advertisements_presented_to_recipient_on_interface])].

cp_test_names([every_fixture_gives_its_one_expected_status, a_final_verdict_cites_all_four_provisions, a_not_final_verdict_cites_nothing, step_1_neither_exempt_fact_gives_section_3_applies, step_2_designation_gives_section_3_applies_with_an_empty_basis, step_3_a_stated_non_designation_is_copied_into_the_basis, step_4_an_absent_designation_is_referred_on, step_5_the_absent_run_off_fact_is_named, step_7_outside_section_3_the_basis_is_not_copied, step_8_the_obligation_applies, step_11_the_obligation_waits_on_the_designation, step_13_no_measures_are_required_outside_the_obligation, step_14_adequate_measures_comply, step_20_a_false_element_gives_not_prohibited, step_21_outside_section_3_gives_the_same_answer, step_25_the_advertising_ban_waits_on_the_designation, step_23_an_empty_profile_names_the_first_element]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
