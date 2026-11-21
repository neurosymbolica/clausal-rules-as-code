% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_queries, [gdpr_common_definitions_roles_and_establishments_profile_keys/1, gdpr_common_definitions_roles_and_establishments_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_kernel, [gdpr_common_definitions_roles_and_establishments_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [gdpr_common_definitions_roles_and_establishments_status/2, gdpr_common_definitions_roles_and_establishments_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_fixtures, [gdpr_common_definitions_roles_and_establishments_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_common_definitions_roles_and_establishments_profile_keys(ProfileKeys),
    ProfileKeys == [data_are_personal_data, party_determines_purposes_and_means, purposes_and_means_determined_by_law, party_provided_for_as_controller_by_law, party_processes_on_behalf_of_controller, data_relate_to_genetic_characteristics_giving_unique_information, data_result_from_technical_processing_allowing_unique_identification, data_relate_to_health_and_reveal_health_status, party_role, established_in_more_than_one_member_state, central_administration_in_union, decisions_taken_in_other_union_establishment, other_establishment_can_have_decisions_implemented, processor_subject_to_specific_obligations, entity_is_person_partnership_or_association, entity_engaged_in_economic_activity, controlling_undertaking_and_controlled_undertakings, party_established_in_authority_member_state, data_subjects_in_authority_member_state_substantially_affected, complaint_lodged_with_authority, processing_in_context_of_establishments_in_more_than_one_member_state, processing_in_context_of_single_union_establishment, substantially_affects_data_subjects_in_more_than_one_member_state, objection_to_draft_decision, objection_concerns_infringement_or_envisaged_action, objection_demonstrates_significance_of_risks].
test(profile_keys_number_twenty_six) :-
    gdpr_common_definitions_roles_and_establishments_profile_keys(ProfileKeys),
    length(ProfileKeys, 26).
test(the_input_check_is_reachable_through_the_query_layer) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(stray, 1)], [unknown_key(stray)]).
test(status_determination_answers_every_definition) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(trading_partnership, Profile),
    gdpr_common_definitions_roles_and_establishments_status(Profile, Statuses),
    length(Statuses, 11),
    member(defined_term(enterprise, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_18)])), Statuses).
test(justification_checklist_carries_cite_provenance) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(complaint_only_authority, Profile),
    gdpr_common_definitions_roles_and_establishments_checklist(Profile, Items),
    member(item(supervisory_authority_concerned, met, [cite(eu_reg_2016_679_art_4_22), cite(eu_reg_2016_679_art_4_22_c)]), Items).
test(justification_checklist_of_a_referral_cites_its_citation) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(objection_risks_unsure, Profile),
    gdpr_common_definitions_roles_and_establishments_checklist(Profile, Items),
    member(item(relevant_and_reasoned_objection, needs_legal_review(open_textured(objection_demonstrates_significance_of_risks, cite(eu_reg_2016_679_art_4_24)), _), [cite(eu_reg_2016_679_art_4_24)]), Items).
test(what_if_baseline_is_not_met) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(partnership_without_economic_activity, Profile),
    gdpr_common_definitions_roles_and_establishments_status(Profile, Statuses),
    member(defined_term(enterprise, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_18)])), Statuses).
test(what_if_flips_the_near_miss_back) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(partnership_without_economic_activity, Profile),
    gdpr_common_definitions_roles_and_establishments_what_if(Profile, entity_engaged_in_economic_activity, true, Statuses),
    member(defined_term(enterprise, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_18)])), Statuses).
test(what_if_supplying_central_administration_refers_the_power_to_implement) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_power_to_implement_unsure, Profile),
    findall(Statuses, gdpr_common_definitions_roles_and_establishments_what_if(Profile, central_administration_in_union, true, Statuses), Results),
    Results = [OnlyStatuses],
    member(defined_term(main_establishment, definition_answer(needs_legal_review(open_textured(other_establishment_can_have_decisions_implemented, cite(eu_reg_2016_679_art_4_16_a)), [inputs_relied_on([decisions_taken_in_other_union_establishment - true, other_establishment_can_have_decisions_implemented - unsure])]), none, [cite(eu_reg_2016_679_art_4_16_a)])), OnlyStatuses).
test(what_if_repairs_a_duplicate_key) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(malformed_profile_duplicate_and_unknown, Profile),
    gdpr_common_definitions_roles_and_establishments_what_if(Profile, party_role, processor, Statuses),
    member(defined_term(enterprise, definition_answer(input_problems([unknown_key(stray)]), none, [])), Statuses).
test(what_if_over_a_non_list_profile_reports_the_profile) :-
    gdpr_common_definitions_roles_and_establishments_what_if(not_a_profile, party_role, controller, Statuses),
    member(defined_term(party_is_processor, definition_answer(input_problems([wrong_type(profile)]), none, [])), Statuses).
test(what_if_to_an_ill_typed_value_reports_it) :-
    gdpr_common_definitions_roles_and_establishments_what_if([], party_role, other, Statuses),
    member(defined_term(main_establishment, definition_answer(input_problems([wrong_type(party_role)]), none, [])), Statuses).

test(what_if_does_not_leave_the_baseline_answer, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(partnership_without_economic_activity, Profile),
    gdpr_common_definitions_roles_and_establishments_what_if(Profile, entity_engaged_in_economic_activity, true, Statuses),
    member(defined_term(enterprise, definition_answer(not_met, _, _)), Statuses).

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_number_twenty_six, the_input_check_is_reachable_through_the_query_layer, status_determination_answers_every_definition, justification_checklist_carries_cite_provenance, justification_checklist_of_a_referral_cites_its_citation, what_if_baseline_is_not_met, what_if_flips_the_near_miss_back, what_if_supplying_central_administration_refers_the_power_to_implement, what_if_repairs_a_duplicate_key, what_if_over_a_non_list_profile_reports_the_profile, what_if_to_an_ill_typed_value_reports_it]).
cp_test_fail_names([what_if_does_not_leave_the_baseline_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
