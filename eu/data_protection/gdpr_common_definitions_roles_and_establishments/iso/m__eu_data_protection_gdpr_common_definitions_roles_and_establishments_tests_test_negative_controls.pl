% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [party_is_controller/2, party_is_processor/2, genetic_data/2, biometric_data/2, data_concerning_health/2, main_establishment/2, enterprise/2, group_of_undertakings/2, supervisory_authority_concerned/2, cross_border_processing/2, relevant_and_reasoned_objection/2, gdpr_common_definitions_roles_and_establishments_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_fixtures, [gdpr_common_definitions_roles_and_establishments_profile_for/2]).

answer_of(Relation, Subject, Answer) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    call(Relation, Profile, Answer).

test(the_near_miss_statuses_are_real_status_atoms) :-
    gdpr_common_definitions_roles_and_establishments_status_values(StatusValues),
    member(not_met, StatusValues),
    member(met, StatusValues).
test(controller_by_determination) :-
    answer_of(party_is_controller, controller_determines, definition_answer(met, determines_purposes_and_means, _)).
test(controller_by_law_route) :-
    answer_of(party_is_controller, controller_by_law, definition_answer(met, provided_for_by_law, _)).
test(law_not_providing_for_the_party_is_not_met) :-
    answer_of(party_is_controller, controller_law_not_provided, definition_answer(not_met, none, _)).
test(an_unattested_law_fact_refers_rather_than_decides) :-
    answer_of(party_is_controller, controller_law_unattested, definition_answer(needs_legal_review(cross_reference_unresolved(_, _), _), none, _)).
test(processor_route) :-
    answer_of(party_is_processor, processor_on_behalf, definition_answer(met, none, _)).
test(processor_not_on_behalf_is_not_met) :-
    answer_of(party_is_processor, processor_not_on_behalf, definition_answer(not_met, none, _)).
test(genetic_route) :-
    answer_of(genetic_data, genetic_data_met, definition_answer(met, none, _)).
test(genetic_not_genetic_is_not_met) :-
    answer_of(genetic_data, genetic_data_not_genetic, definition_answer(not_met, none, _)).
test(biometric_route) :-
    answer_of(biometric_data, biometric_data_met, definition_answer(met, none, _)).
test(biometric_not_personal_data_is_not_met) :-
    answer_of(biometric_data, biometric_not_personal_data, definition_answer(not_met, none, _)).
test(health_route) :-
    answer_of(data_concerning_health, health_data_met, definition_answer(met, none, _)).
test(health_not_health_is_not_met) :-
    answer_of(data_concerning_health, health_data_not_health, definition_answer(not_met, none, _)).
test(main_establishment_where_decisions_are_taken) :-
    answer_of(main_establishment, main_decisions_elsewhere, definition_answer(met, establishment_taking_decisions, _)).
test(main_central_administration_route) :-
    answer_of(main_establishment, main_central_administration, definition_answer(met, central_administration, _)).
test(main_no_place_gap) :-
    answer_of(main_establishment, main_no_place, definition_answer(not_met, no_main_establishment_identified, _)).
test(main_processor_central_route) :-
    answer_of(main_establishment, main_processor_central, definition_answer(met, central_administration, _)).
test(main_processor_main_activities_route) :-
    answer_of(main_establishment, main_processor_main_activities, definition_answer(met, establishment_of_main_processing_activities, _)).
test(main_processor_not_subject_is_not_met) :-
    answer_of(main_establishment, main_processor_not_subject, definition_answer(not_met, no_main_establishment_identified, _)).
test(main_single_member_state_does_not_apply) :-
    answer_of(main_establishment, main_single_member_state, definition_answer(not_met, not_established_in_more_than_one_member_state, _)).
test(main_role_missing_is_indeterminate) :-
    answer_of(main_establishment, main_role_missing, definition_answer(indeterminate([party_role]), none, _)).
test(enterprise_route) :-
    answer_of(enterprise, enterprise_met, definition_answer(met, none, _)).
test(enterprise_not_economic_is_not_met) :-
    answer_of(enterprise, enterprise_not_economic, definition_answer(not_met, none, _)).
test(group_route) :-
    answer_of(group_of_undertakings, group_met, definition_answer(met, none, _)).
test(group_not_met_is_not_met) :-
    answer_of(group_of_undertakings, group_not_met, definition_answer(not_met, none, _)).
test(authority_point_a) :-
    answer_of(supervisory_authority_concerned, authority_established, definition_answer(met, point_a, _)).
test(authority_point_b) :-
    answer_of(supervisory_authority_concerned, authority_affected, definition_answer(met, point_b, _)).
test(authority_point_c) :-
    answer_of(supervisory_authority_concerned, authority_complaint, definition_answer(met, point_c, _)).
test(authority_none_is_not_met) :-
    answer_of(supervisory_authority_concerned, authority_none, definition_answer(not_met, none, _)).
test(cross_border_point_a) :-
    answer_of(cross_border_processing, cross_border_several, definition_answer(met, point_a, _)).
test(cross_border_point_b) :-
    answer_of(cross_border_processing, cross_border_single, definition_answer(met, point_b, _)).
test(cross_border_none_is_not_met) :-
    answer_of(cross_border_processing, cross_border_none, definition_answer(not_met, none, _)).
test(objection_route) :-
    answer_of(relevant_and_reasoned_objection, objection_met, definition_answer(met, none, _)).
test(objection_no_risk_is_not_met) :-
    answer_of(relevant_and_reasoned_objection, objection_no_risk, definition_answer(not_met, none, _)).
test(objection_unsure_hands_the_judgement_to_the_user) :-
    answer_of(relevant_and_reasoned_objection, objection_risk_unsure, definition_answer(needs_legal_review(open_textured(objection_demonstrates_significance_of_risks, _), _), none, _)).

test(controller_by_determination_is_not_by_law, fail) :-
    answer_of(party_is_controller, controller_determines, definition_answer(_, provided_for_by_law, _)).
test(law_not_providing_for_the_party_is_not_controller, fail) :-
    answer_of(party_is_controller, controller_law_not_provided, definition_answer(met, _, _)).
test(an_unattested_law_fact_is_not_met, fail) :-
    answer_of(party_is_controller, controller_law_unattested, definition_answer(not_met, _, _)).
test(processor_not_on_behalf_near_miss, fail) :-
    answer_of(party_is_processor, processor_not_on_behalf, definition_answer(met, _, _)).
test(genetic_near_miss_not_genetic, fail) :-
    answer_of(genetic_data, genetic_data_not_genetic, definition_answer(met, _, _)).
test(biometric_near_miss_not_personal_data, fail) :-
    answer_of(biometric_data, biometric_not_personal_data, definition_answer(met, _, _)).
test(health_near_miss_not_health, fail) :-
    answer_of(data_concerning_health, health_data_not_health, definition_answer(met, _, _)).
test(main_decisions_elsewhere_is_not_central_administration, fail) :-
    answer_of(main_establishment, main_decisions_elsewhere, definition_answer(_, central_administration, _)).
test(main_central_administration_is_not_deciding_establishment, fail) :-
    answer_of(main_establishment, main_central_administration, definition_answer(_, establishment_taking_decisions, _)).
test(main_no_place_is_not_met_flip, fail) :-
    answer_of(main_establishment, main_no_place, definition_answer(met, _, _)).
test(main_processor_not_subject_near_miss, fail) :-
    answer_of(main_establishment, main_processor_not_subject, definition_answer(met, _, _)).
test(main_single_member_state_near_miss, fail) :-
    answer_of(main_establishment, main_single_member_state, definition_answer(met, _, _)).
test(enterprise_near_miss_not_economic, fail) :-
    answer_of(enterprise, enterprise_not_economic, definition_answer(met, _, _)).
test(group_near_miss, fail) :-
    answer_of(group_of_undertakings, group_not_met, definition_answer(met, _, _)).
test(authority_point_a_is_not_point_b, fail) :-
    answer_of(supervisory_authority_concerned, authority_established, definition_answer(_, point_b, _)).
test(authority_point_b_is_not_point_a, fail) :-
    answer_of(supervisory_authority_concerned, authority_affected, definition_answer(_, point_a, _)).
test(authority_point_c_is_not_point_b, fail) :-
    answer_of(supervisory_authority_concerned, authority_complaint, definition_answer(_, point_b, _)).
test(authority_none_near_miss, fail) :-
    answer_of(supervisory_authority_concerned, authority_none, definition_answer(met, _, _)).
test(cross_border_point_a_is_not_point_b, fail) :-
    answer_of(cross_border_processing, cross_border_several, definition_answer(_, point_b, _)).
test(cross_border_point_b_is_not_point_a, fail) :-
    answer_of(cross_border_processing, cross_border_single, definition_answer(_, point_a, _)).
test(cross_border_none_near_miss, fail) :-
    answer_of(cross_border_processing, cross_border_none, definition_answer(met, _, _)).
test(objection_near_miss_no_risk, fail) :-
    answer_of(relevant_and_reasoned_objection, objection_no_risk, definition_answer(met, _, _)).
test(objection_unsure_is_not_decided, fail) :-
    answer_of(relevant_and_reasoned_objection, objection_risk_unsure, definition_answer(not_met, _, _)).

cp_test_names([the_near_miss_statuses_are_real_status_atoms, controller_by_determination, controller_by_law_route, law_not_providing_for_the_party_is_not_met, an_unattested_law_fact_refers_rather_than_decides, processor_route, processor_not_on_behalf_is_not_met, genetic_route, genetic_not_genetic_is_not_met, biometric_route, biometric_not_personal_data_is_not_met, health_route, health_not_health_is_not_met, main_establishment_where_decisions_are_taken, main_central_administration_route, main_no_place_gap, main_processor_central_route, main_processor_main_activities_route, main_processor_not_subject_is_not_met, main_single_member_state_does_not_apply, main_role_missing_is_indeterminate, enterprise_route, enterprise_not_economic_is_not_met, group_route, group_not_met_is_not_met, authority_point_a, authority_point_b, authority_point_c, authority_none_is_not_met, cross_border_point_a, cross_border_point_b, cross_border_none_is_not_met, objection_route, objection_no_risk_is_not_met, objection_unsure_hands_the_judgement_to_the_user]).
cp_test_fail_names([controller_by_determination_is_not_by_law, law_not_providing_for_the_party_is_not_controller, an_unattested_law_fact_is_not_met, processor_not_on_behalf_near_miss, genetic_near_miss_not_genetic, biometric_near_miss_not_personal_data, health_near_miss_not_health, main_decisions_elsewhere_is_not_central_administration, main_central_administration_is_not_deciding_establishment, main_no_place_is_not_met_flip, main_processor_not_subject_near_miss, main_single_member_state_near_miss, enterprise_near_miss_not_economic, group_near_miss, authority_point_a_is_not_point_b, authority_point_b_is_not_point_a, authority_point_c_is_not_point_b, authority_none_near_miss, cross_border_point_a_is_not_point_b, cross_border_point_b_is_not_point_a, cross_border_none_near_miss, objection_near_miss_no_risk, objection_unsure_is_not_decided]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
