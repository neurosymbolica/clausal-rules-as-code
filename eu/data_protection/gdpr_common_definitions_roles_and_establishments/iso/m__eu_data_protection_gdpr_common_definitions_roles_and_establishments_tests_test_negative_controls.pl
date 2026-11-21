% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [party_is_controller/2, party_is_processor/2, genetic_data/2, biometric_data/2, data_concerning_health/2, main_establishment/2, enterprise/2, group_of_undertakings/2, supervisory_authority_concerned/2, cross_border_processing/2, relevant_and_reasoned_objection/2, roles_and_establishments_outside_facts/2, gdpr_common_definitions_roles_and_establishments_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_fixtures, [gdpr_common_definitions_roles_and_establishments_profile_for/2]).

test(the_status_table_names_both_final_statuses) :-
    gdpr_common_definitions_roles_and_establishments_status_values(StatusValues),
    StatusValues == [met, not_met].
test(controller_judgement_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_by_judgement, Profile),
    party_is_controller(Profile, definition_answer(met, determines_purposes_and_means, [cite(eu_reg_2016_679_art_4_7)])).
test(controller_judgement_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_judgement_false, Profile),
    party_is_controller(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_7)])).
test(controller_law_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(law_designated_controller_attested, Profile),
    party_is_controller(Profile, definition_answer(met, provided_for_by_law, [cite(eu_reg_2016_679_art_4_7)])).
test(controller_law_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(law_designated_controller_attested_false, Profile),
    party_is_controller(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_7)])).
test(controller_law_unattested_refers) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(law_designated_controller_unattested, Profile),
    party_is_controller(Profile, definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)), [resolution(cite(union_or_member_state_law_providing_for_controller), not_attempted), inputs_relied_on([party_determines_purposes_and_means - false, purposes_and_means_determined_by_law - true])]), none, [cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)])).
test(processor_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(cloud_processor, Profile),
    party_is_processor(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_8)])).
test(processor_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(not_on_behalf_of_controller, Profile),
    party_is_processor(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_8)])).
test(genetic_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(genetic_test_laboratory, Profile),
    genetic_data(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_13)])).
test(genetic_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(genetic_data_not_personal, Profile),
    genetic_data(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_13)])).
test(biometric_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(biometric_access_control, Profile),
    biometric_data(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_14)])).
test(biometric_near_miss_refers_to_point_one) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(biometric_personal_data_unsure, Profile),
    biometric_data(Profile, definition_answer(needs_legal_review(open_textured(data_are_personal_data, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([data_are_personal_data - unsure])]), none, [cite(eu_reg_2016_679_art_4_1)])).
test(health_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(hospital_health_data, Profile),
    data_concerning_health(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_15)])).
test(health_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(health_status_not_revealed, Profile),
    data_concerning_health(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_15)])).
test(main_establishment_deciding_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_with_deciding_establishment, Profile),
    main_establishment(Profile, definition_answer(met, establishment_taking_decisions, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])).
test(main_establishment_deciding_near_miss_names_central_administration) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_power_to_implement_unsure, Profile),
    main_establishment(Profile, definition_answer(indeterminate([central_administration_in_union]), none, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])).
test(main_establishment_central_administration_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_central_administration, Profile),
    main_establishment(Profile, definition_answer(met, central_administration, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])).
test(main_establishment_central_administration_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_without_main_establishment, Profile),
    main_establishment(Profile, definition_answer(not_met, no_main_establishment_identified, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])).
test(main_establishment_single_member_state) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(single_member_state_party, Profile),
    main_establishment(Profile, definition_answer(not_met, not_established_in_more_than_one_member_state, [cite(eu_reg_2016_679_art_4_16)])).
test(main_establishment_processor_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(cloud_processor_two_member_states, Profile),
    main_establishment(Profile, definition_answer(met, establishment_of_main_processing_activities, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_b)])).
test(main_establishment_processor_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(processor_without_specific_obligations, Profile),
    main_establishment(Profile, definition_answer(not_met, no_main_establishment_identified, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_b)])).
test(enterprise_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(trading_partnership, Profile),
    enterprise(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_18)])).
test(enterprise_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(partnership_without_economic_activity, Profile),
    enterprise(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_18)])).
test(group_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(holding_group, Profile),
    group_of_undertakings(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_19)])).
test(group_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(undertakings_without_control, Profile),
    group_of_undertakings(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_19)])).
test(authority_positive_point_c) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(complaint_only_authority, Profile),
    supervisory_authority_concerned(Profile, definition_answer(met, point_c, [cite(eu_reg_2016_679_art_4_22), cite(eu_reg_2016_679_art_4_22_c)])).
test(authority_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(authority_not_concerned, Profile),
    supervisory_authority_concerned(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_22)])).
test(authority_point_a_comes_first) :-
    supervisory_authority_concerned([attribute(party_established_in_authority_member_state, true), attribute(complaint_lodged_with_authority, true)], definition_answer(met, point_a, [cite(eu_reg_2016_679_art_4_22), cite(eu_reg_2016_679_art_4_22_a)])).
test(cross_border_point_a_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(establishments_in_several_member_states, Profile),
    cross_border_processing(Profile, definition_answer(met, point_a, [cite(eu_reg_2016_679_art_4_23), cite(eu_reg_2016_679_art_4_23_a)])).
test(cross_border_point_b_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(single_establishment_cross_border, Profile),
    cross_border_processing(Profile, definition_answer(met, point_b, [cite(eu_reg_2016_679_art_4_23), cite(eu_reg_2016_679_art_4_23_b)])).
test(cross_border_point_b_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(single_establishment_local_effect, Profile),
    cross_border_processing(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_23)])).
test(objection_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(reasoned_objection, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_24)])).
test(objection_near_miss) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(objection_incomplete, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_24)])).
test(objection_unsure_risks_refers) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(objection_risks_unsure, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(needs_legal_review(open_textured(objection_demonstrates_significance_of_risks, cite(eu_reg_2016_679_art_4_24)), [inputs_relied_on([objection_to_draft_decision - true, objection_concerns_infringement_or_envisaged_action - true, objection_demonstrates_significance_of_risks - unsure])]), none, [cite(eu_reg_2016_679_art_4_24)])).
test(outside_fact_attested_positive) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(law_designated_controller_attested, Profile),
    roles_and_establishments_outside_facts(Profile, [outside_fact(party_provided_for_as_controller_by_law, attested(true, attestation(by, at, reason, none)))]).
test(outside_fact_near_miss_absent) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(law_designated_controller_unattested, Profile),
    roles_and_establishments_outside_facts(Profile, [outside_fact(party_provided_for_as_controller_by_law, absent)]).

test(controller_judgement_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_judgement_false, Profile),
    party_is_controller(Profile, definition_answer(met, _, _)).
test(controller_law_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(law_designated_controller_attested_false, Profile),
    party_is_controller(Profile, definition_answer(met, _, _)).
test(controller_law_unattested_is_not_final, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(law_designated_controller_unattested, Profile),
    party_is_controller(Profile, definition_answer(not_met, _, _)).
test(processor_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(not_on_behalf_of_controller, Profile),
    party_is_processor(Profile, definition_answer(met, _, _)).
test(genetic_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(genetic_data_not_personal, Profile),
    genetic_data(Profile, definition_answer(met, _, _)).
test(biometric_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(biometric_personal_data_unsure, Profile),
    biometric_data(Profile, definition_answer(met, _, _)).
test(health_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(health_status_not_revealed, Profile),
    data_concerning_health(Profile, definition_answer(met, _, _)).
test(main_establishment_deciding_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_power_to_implement_unsure, Profile),
    main_establishment(Profile, definition_answer(met, _, _)).
test(main_establishment_central_administration_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_without_main_establishment, Profile),
    main_establishment(Profile, definition_answer(met, _, _)).
test(main_establishment_single_member_state_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(single_member_state_party, Profile),
    main_establishment(Profile, definition_answer(met, _, _)).
test(main_establishment_processor_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(processor_without_specific_obligations, Profile),
    main_establishment(Profile, definition_answer(met, _, _)).
test(enterprise_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(partnership_without_economic_activity, Profile),
    enterprise(Profile, definition_answer(met, _, _)).
test(group_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(undertakings_without_control, Profile),
    group_of_undertakings(Profile, definition_answer(met, _, _)).
test(authority_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(authority_not_concerned, Profile),
    supervisory_authority_concerned(Profile, definition_answer(met, _, _)).
test(authority_point_a_is_not_point_c, fail) :-
    supervisory_authority_concerned([attribute(party_established_in_authority_member_state, true), attribute(complaint_lodged_with_authority, true)], definition_answer(met, point_c, _)).
test(cross_border_point_b_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(single_establishment_local_effect, Profile),
    cross_border_processing(Profile, definition_answer(met, _, _)).
test(objection_near_miss_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(objection_incomplete, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(met, _, _)).
test(objection_unsure_risks_is_not_met, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(objection_risks_unsure, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(met, _, _)).
test(outside_fact_near_miss_is_not_attested, fail) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(law_designated_controller_unattested, Profile),
    roles_and_establishments_outside_facts(Profile, [outside_fact(party_provided_for_as_controller_by_law, attested(_, _))]).

cp_test_names([the_status_table_names_both_final_statuses, controller_judgement_positive, controller_judgement_near_miss, controller_law_positive, controller_law_near_miss, controller_law_unattested_refers, processor_positive, processor_near_miss, genetic_positive, genetic_near_miss, biometric_positive, biometric_near_miss_refers_to_point_one, health_positive, health_near_miss, main_establishment_deciding_positive, main_establishment_deciding_near_miss_names_central_administration, main_establishment_central_administration_positive, main_establishment_central_administration_near_miss, main_establishment_single_member_state, main_establishment_processor_positive, main_establishment_processor_near_miss, enterprise_positive, enterprise_near_miss, group_positive, group_near_miss, authority_positive_point_c, authority_near_miss, authority_point_a_comes_first, cross_border_point_a_positive, cross_border_point_b_positive, cross_border_point_b_near_miss, objection_positive, objection_near_miss, objection_unsure_risks_refers, outside_fact_attested_positive, outside_fact_near_miss_absent]).
cp_test_fail_names([controller_judgement_near_miss_is_not_met, controller_law_near_miss_is_not_met, controller_law_unattested_is_not_final, processor_near_miss_is_not_met, genetic_near_miss_is_not_met, biometric_near_miss_is_not_met, health_near_miss_is_not_met, main_establishment_deciding_near_miss_is_not_met, main_establishment_central_administration_near_miss_is_not_met, main_establishment_single_member_state_is_not_met, main_establishment_processor_near_miss_is_not_met, enterprise_near_miss_is_not_met, group_near_miss_is_not_met, authority_near_miss_is_not_met, authority_point_a_is_not_point_c, cross_border_point_b_near_miss_is_not_met, objection_near_miss_is_not_met, objection_unsure_risks_is_not_met, outside_fact_near_miss_is_not_attested]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
