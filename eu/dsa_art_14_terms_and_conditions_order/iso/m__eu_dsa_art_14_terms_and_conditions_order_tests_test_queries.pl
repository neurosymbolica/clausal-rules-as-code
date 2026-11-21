% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_14_terms_and_conditions_order_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_queries, [dsa_art_14_terms_and_conditions_order_profile_keys/1, dsa_art_14_terms_and_conditions_order_what_if/4, art_14_1_terms_and_conditions_compliant/0, art_14_5_summary_not_required/0, terms_and_conditions_changed/0, unsure/0, absent/0, not_attempted/0]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_kernel, [dsa_art_14_terms_and_conditions_order_input_problems/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_dsa_art_14_terms_and_conditions_order, [dsa_art_14_terms_and_conditions_order_status/2, dsa_art_14_terms_and_conditions_order_checklist/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_fixtures, [dsa_art_14_terms_and_conditions_order_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dsa_art_14_terms_and_conditions_order_profile_keys(ProfileKeys),
    ProfileKeys == [terms_and_conditions_include_information_on_restrictions_on_recipient_information, terms_and_conditions_include_information_on_content_moderation, terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, provider_has_internal_complaint_handling_system, terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system, terms_and_conditions_changed, change_to_terms_and_conditions_is_significant, recipients_informed_of_change_to_terms_and_conditions, service_primarily_directed_at_minors, service_predominantly_used_by_minors, conditions_and_restrictions_explained_in_way_minors_can_understand, provider_applies_or_enforces_restriction, restriction_applied_in_diligent_objective_and_proportionate_manner, restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties, concise_clear_machine_readable_summary_of_terms_and_conditions_provided, terms_and_conditions_published_in_official_languages_of_all_member_states_of_service, designated_as_very_large_online_platform_or_search_engine].
test(eligibility_status_for_a_small_hosting_service) :-
    dsa_art_14_terms_and_conditions_order_profile_for(small_hosting_service_no_complaint_system, Profile),
    findall(Status, dsa_art_14_terms_and_conditions_order_status(Profile, Status), Statuses),
    Statuses == [dsa_art_14_terms_and_conditions_order_compliant].
test(eligibility_status_for_an_unsure_judgement_is_indeterminate) :-
    dsa_art_14_terms_and_conditions_order_profile_for(unsure_language_judgement, Profile),
    dsa_art_14_terms_and_conditions_order_status(Profile, dsa_art_14_terms_and_conditions_order_indeterminate).
test(justification_every_item_carries_its_paragraph_citation) :-
    dsa_art_14_terms_and_conditions_order_profile_for(fully_compliant_very_large_platform, Profile),
    dsa_art_14_terms_and_conditions_order_checklist(Profile, Items),
    Items == [item(art_14_1, met, cite(eu_reg_2022_2065_art_14_1)), item(art_14_2, met, cite(eu_reg_2022_2065_art_14_2)), item(art_14_3, met, cite(eu_reg_2022_2065_art_14_3)), item(art_14_4, met, cite(eu_reg_2022_2065_art_14_4)), item(art_14_5, met, cite(eu_reg_2022_2065_art_14_5)), item(art_14_6, met, cite(eu_reg_2022_2065_art_14_6))].
test(justification_names_the_breached_paragraph) :-
    dsa_art_14_terms_and_conditions_order_profile_for(missing_content_moderation_information, Profile),
    dsa_art_14_terms_and_conditions_order_checklist(Profile, Items),
    member(item(art_14_1, unmet(art_14_1_terms_and_conditions_not_compliant), cite(eu_reg_2022_2065_art_14_1)), Items).
test(justification_names_the_referred_outside_fact) :-
    dsa_art_14_terms_and_conditions_order_profile_for(designation_absent_summary_unsure, Profile),
    dsa_art_14_terms_and_conditions_order_checklist(Profile, Items),
    member(item(art_14_6, unknown([designated_as_very_large_online_platform_or_search_engine]), cite(eu_reg_2022_2065_art_14_6)), Items).
test(what_if_withdrawing_the_summary_breaches_art_14_5) :-
    dsa_art_14_terms_and_conditions_order_profile_for(fully_compliant_very_large_platform, Profile),
    findall(NewStatus, dsa_art_14_terms_and_conditions_order_what_if(Profile, concise_clear_machine_readable_summary_of_terms_and_conditions_provided, false, NewStatus), Statuses),
    Statuses == [dsa_art_14_terms_and_conditions_order_not_compliant].
test(what_if_the_designation_is_attested_false_stays_compliant) :-
    dsa_art_14_terms_and_conditions_order_profile_for(fully_compliant_very_large_platform, Profile),
    dsa_art_14_terms_and_conditions_order_what_if(Profile, designated_as_very_large_online_platform_or_search_engine, attested(false, attestation(host_service, attestation_time, commission_designation_list, none)), dsa_art_14_terms_and_conditions_order_compliant).
test(what_if_a_restriction_is_enforced_asks_for_the_judgements) :-
    dsa_art_14_terms_and_conditions_order_profile_for(small_hosting_service_no_complaint_system, Profile),
    dsa_art_14_terms_and_conditions_order_what_if(Profile, provider_applies_or_enforces_restriction, true, dsa_art_14_terms_and_conditions_order_indeterminate).
test(the_reexported_input_check_reports_problems) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(terms_and_conditions_changed, unsure)], [wrong_type(terms_and_conditions_changed)]).
test(the_root_atoms_are_reachable) :-
    art_14_1_terms_and_conditions_compliant,
    art_14_5_summary_not_required,
    terms_and_conditions_changed,
    unsure,
    absent,
    not_attempted.

test(what_if_a_restriction_is_enforced_is_not_still_compliant, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(small_hosting_service_no_complaint_system, Profile),
    dsa_art_14_terms_and_conditions_order_what_if(Profile, provider_applies_or_enforces_restriction, true, dsa_art_14_terms_and_conditions_order_compliant).

cp_test_names([profile_keys_are_the_contract_keys, eligibility_status_for_a_small_hosting_service, eligibility_status_for_an_unsure_judgement_is_indeterminate, justification_every_item_carries_its_paragraph_citation, justification_names_the_breached_paragraph, justification_names_the_referred_outside_fact, what_if_withdrawing_the_summary_breaches_art_14_5, what_if_the_designation_is_attested_false_stays_compliant, what_if_a_restriction_is_enforced_asks_for_the_judgements, the_reexported_input_check_reports_problems, the_root_atoms_are_reachable]).
cp_test_fail_names([what_if_a_restriction_is_enforced_is_not_still_compliant]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
