% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_28_minors_order_queries, [dsa_art_28_minors_order_profile_keys/1, dsa_art_28_minors_order_what_if/4, platform_accessible_to_minors/0, advertisements_presented_to_recipient_on_interface/0, advertisements_based_on_profiling_of_recipient/0, aware_with_reasonable_certainty_recipient_is_minor/0, provider_qualifies_as_micro_or_small_enterprise/0, provider_within_12_months_after_losing_micro_or_small_status/0, designated_as_very_large_online_platform/0, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors/0, unsure/0, absent/0, not_attempted/0]).
:- use_module(m__eu_dsa_art_28_minors_order_kernel, [dsa_art_28_minors_order_input_problems/2]).
:- use_module(m__eu_dsa_art_28_minors_order_dsa_art_28_minors_order, [decide_dsa_art_28_minors_order/2, dsa_art_28_minors_order_checklist/2]).
:- use_module(m__eu_dsa_art_28_minors_order_fixtures, [dsa_art_28_minors_order_profile_for/2, dsa_art_28_minors_order_assess/2]).

test(profile_keys_are_the_contract_keys) :-
    dsa_art_28_minors_order_profile_keys(ProfileKeys),
    ProfileKeys == [platform_accessible_to_minors, advertisements_presented_to_recipient_on_interface, advertisements_based_on_profiling_of_recipient, aware_with_reasonable_certainty_recipient_is_minor, provider_qualifies_as_micro_or_small_enterprise, provider_within_12_months_after_losing_micro_or_small_status, designated_as_very_large_online_platform, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors].
test(every_root_atom_is_served) :-
    platform_accessible_to_minors,
    advertisements_presented_to_recipient_on_interface,
    advertisements_based_on_profiling_of_recipient,
    aware_with_reasonable_certainty_recipient_is_minor,
    provider_qualifies_as_micro_or_small_enterprise,
    provider_within_12_months_after_losing_micro_or_small_status,
    designated_as_very_large_online_platform,
    measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors,
    unsure,
    absent,
    not_attempted.
test(the_re_exported_input_check_answers_once) :-
    findall(Problems, dsa_art_28_minors_order_input_problems([attribute(colour, red)], Problems), ProblemLists),
    ProblemLists == [[unknown_key(colour)]].
test(the_verdict_of_a_breach_cites_every_provision) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_inadequate, Profile),
    findall(Verdict, decide_dsa_art_28_minors_order(Profile, Verdict), Verdicts),
    Verdicts == [dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_breached, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1), cite(eu_reg_2022_2065_art_28_2)])].
test(the_assess_wrapper_gives_the_same_verdict) :-
    findall(Verdict, dsa_art_28_minors_order_assess(small_enterprise_stated_not_designated, Verdict), Verdicts),
    Verdicts == [dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_not_engaged, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1), cite(eu_reg_2022_2065_art_28_2)])].
test(the_checklist_gives_one_cited_row_per_question) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    findall(Rows, dsa_art_28_minors_order_checklist(Profile, Rows), Checklists),
    Checklists == [[item(section_3_application, section_3_applies, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]), item(art_28_1_obligation, art_28_1_obligation_applies, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]), item(art_28_1_compliance, art_28_1_measures_compliant, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]), item(art_28_2_advertising, art_28_2_presentation_not_prohibited, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)])]].
test(the_checklist_outside_section_3_keeps_its_citations) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_not_designated, Profile),
    findall(Rows, dsa_art_28_minors_order_checklist(Profile, Rows), Checklists),
    Checklists == [[item(section_3_application, section_3_not_applicable, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]), item(art_28_1_obligation, art_28_1_obligation_not_applicable, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]), item(art_28_1_compliance, art_28_1_measures_not_required, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]), item(art_28_2_advertising, art_28_2_presentation_not_prohibited, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)])]].
test(a_not_final_checklist_row_cites_nothing) :-
    dsa_art_28_minors_order_profile_for(empty_profile, Profile),
    dsa_art_28_minors_order_checklist(Profile, Rows),
    member(item(section_3_application, indeterminate([provider_qualifies_as_micro_or_small_enterprise]), []), Rows).
test(what_if_designation_attested_true_gives_a_breach) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_designation_not_shown, Profile),
    findall(NewStatus, dsa_art_28_minors_order_what_if(Profile, designated_as_very_large_online_platform, attested(true, attestation(host_user, recorded_moment, commission_list_checked, none)), NewStatus), Statuses),
    Statuses == [dsa_art_28_minors_order_breached].
test(what_if_replaces_an_existing_key_without_duplicating_it) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    findall(NewStatus, dsa_art_28_minors_order_what_if(Profile, platform_accessible_to_minors, false, NewStatus), Statuses),
    Statuses == [dsa_art_28_minors_order_not_engaged].
test(what_if_an_unknown_key_is_an_input_problem) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    findall(NewStatus, dsa_art_28_minors_order_what_if(Profile, colour, red, NewStatus), Statuses),
    Statuses == [input_problems([unknown_key(colour)])].
test(what_if_on_a_term_that_is_not_a_profile) :-
    findall(NewStatus, dsa_art_28_minors_order_what_if(not_a_profile, platform_accessible_to_minors, true, NewStatus), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].

cp_test_names([profile_keys_are_the_contract_keys, every_root_atom_is_served, the_re_exported_input_check_answers_once, the_verdict_of_a_breach_cites_every_provision, the_assess_wrapper_gives_the_same_verdict, the_checklist_gives_one_cited_row_per_question, the_checklist_outside_section_3_keeps_its_citations, a_not_final_checklist_row_cites_nothing, what_if_designation_attested_true_gives_a_breach, what_if_replaces_an_existing_key_without_duplicating_it, what_if_an_unknown_key_is_an_input_problem, what_if_on_a_term_that_is_not_a_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
