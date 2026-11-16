% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [party_is_controller/2, party_is_processor/2, genetic_data/2, biometric_data/2, data_concerning_health/2, main_establishment/2, enterprise/2, group_of_undertakings/2, supervisory_authority_concerned/2, cross_border_processing/2, relevant_and_reasoned_objection/2, decide_gdpr_common_definitions_roles_and_establishments/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_fixtures, [gdpr_common_definitions_roles_and_establishments_profile_for/2]).

answers_of(Relation, Subject, Answers) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    findall(Answer, call(Relation, Profile, Answer), Answers).

test(controller_determines) :-
    answers_of(party_is_controller, controller_determines, Answers),
    Answers == [definition_answer(met, determines_purposes_and_means, [cite(eu_reg_2016_679_art_4_7)])].
test(controller_by_law) :-
    answers_of(party_is_controller, controller_by_law, Answers),
    Answers == [definition_answer(met, provided_for_by_law, [cite(eu_reg_2016_679_art_4_7)])].
test(controller_law_not_provided) :-
    answers_of(party_is_controller, controller_law_not_provided, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_7)])].
test(controller_law_unattested_refers) :-
    answers_of(party_is_controller, controller_law_unattested, Answers),
    Answers == [definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)), [resolution(cite(union_or_member_state_law_providing_for_controller), not_attempted), inputs_relied_on([party_determines_purposes_and_means - false, purposes_and_means_determined_by_law - true])]), none, [cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)])].
test(controller_judgement_unsure) :-
    answers_of(party_is_controller, controller_judgement_unsure, Answers),
    Answers == [definition_answer(needs_legal_review(open_textured(party_determines_purposes_and_means, cite(eu_reg_2016_679_art_4_7)), [inputs_relied_on([party_determines_purposes_and_means - unsure, purposes_and_means_determined_by_law - false])]), none, [cite(eu_reg_2016_679_art_4_7)])].
test(controller_nothing_stated) :-
    answers_of(party_is_controller, controller_nothing_stated, Answers),
    Answers == [definition_answer(indeterminate([party_determines_purposes_and_means, purposes_and_means_determined_by_law]), none, [cite(eu_reg_2016_679_art_4_7)])].
test(processor_on_behalf) :-
    answers_of(party_is_processor, processor_on_behalf, Answers),
    Answers == [definition_answer(met, none, [cite(eu_reg_2016_679_art_4_8)])].
test(processor_not_on_behalf) :-
    answers_of(party_is_processor, processor_not_on_behalf, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_8)])].
test(genetic_data_met) :-
    answers_of(genetic_data, genetic_data_met, Answers),
    Answers == [definition_answer(met, none, [cite(eu_reg_2016_679_art_4_13)])].
test(genetic_data_not_genetic) :-
    answers_of(genetic_data, genetic_data_not_genetic, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_13)])].
test(genetic_personal_data_unsure_refers_to_4_1) :-
    answers_of(genetic_data, genetic_personal_data_unsure, Answers),
    Answers == [definition_answer(needs_legal_review(open_textured(data_are_personal_data, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([data_are_personal_data - unsure])]), none, [cite(eu_reg_2016_679_art_4_1)])].
test(biometric_data_met) :-
    answers_of(biometric_data, biometric_data_met, Answers),
    Answers == [definition_answer(met, none, [cite(eu_reg_2016_679_art_4_14)])].
test(biometric_not_personal_data) :-
    answers_of(biometric_data, biometric_not_personal_data, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_14)])].
test(health_data_met) :-
    answers_of(data_concerning_health, health_data_met, Answers),
    Answers == [definition_answer(met, none, [cite(eu_reg_2016_679_art_4_15)])].
test(health_data_not_health) :-
    answers_of(data_concerning_health, health_data_not_health, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_15)])].
test(main_decisions_elsewhere) :-
    answers_of(main_establishment, main_decisions_elsewhere, Answers),
    Answers == [definition_answer(met, establishment_taking_decisions, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])].
test(main_central_administration) :-
    answers_of(main_establishment, main_central_administration, Answers),
    Answers == [definition_answer(met, central_administration, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])].
test(main_no_place) :-
    answers_of(main_establishment, main_no_place, Answers),
    Answers == [definition_answer(not_met, no_main_establishment_identified, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])].
test(main_processor_central) :-
    answers_of(main_establishment, main_processor_central, Answers),
    Answers == [definition_answer(met, central_administration, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_b)])].
test(main_processor_main_activities) :-
    answers_of(main_establishment, main_processor_main_activities, Answers),
    Answers == [definition_answer(met, establishment_of_main_processing_activities, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_b)])].
test(main_processor_not_subject) :-
    answers_of(main_establishment, main_processor_not_subject, Answers),
    Answers == [definition_answer(not_met, no_main_establishment_identified, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_b)])].
test(main_single_member_state) :-
    answers_of(main_establishment, main_single_member_state, Answers),
    Answers == [definition_answer(not_met, not_established_in_more_than_one_member_state, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])].
test(main_role_missing) :-
    answers_of(main_establishment, main_role_missing, Answers),
    Answers == [definition_answer(indeterminate([party_role]), none, [cite(eu_reg_2016_679_art_4_16)])].
test(main_power_unsure) :-
    answers_of(main_establishment, main_power_unsure, Answers),
    Answers == [definition_answer(needs_legal_review(open_textured(other_establishment_can_have_decisions_implemented, cite(eu_reg_2016_679_art_4_16_a)), [inputs_relied_on([decisions_taken_in_other_union_establishment - true, other_establishment_can_have_decisions_implemented - unsure])]), none, [cite(eu_reg_2016_679_art_4_16_a)])].
test(enterprise_met) :-
    answers_of(enterprise, enterprise_met, Answers),
    Answers == [definition_answer(met, none, [cite(eu_reg_2016_679_art_4_18)])].
test(enterprise_not_economic) :-
    answers_of(enterprise, enterprise_not_economic, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_18)])].
test(group_met) :-
    answers_of(group_of_undertakings, group_met, Answers),
    Answers == [definition_answer(met, none, [cite(eu_reg_2016_679_art_4_19)])].
test(group_not_met) :-
    answers_of(group_of_undertakings, group_not_met, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_19)])].
test(authority_established) :-
    answers_of(supervisory_authority_concerned, authority_established, Answers),
    Answers == [definition_answer(met, point_a, [cite(eu_reg_2016_679_art_4_22), cite(eu_reg_2016_679_art_4_22_a)])].
test(authority_affected) :-
    answers_of(supervisory_authority_concerned, authority_affected, Answers),
    Answers == [definition_answer(met, point_b, [cite(eu_reg_2016_679_art_4_22), cite(eu_reg_2016_679_art_4_22_b)])].
test(authority_complaint) :-
    answers_of(supervisory_authority_concerned, authority_complaint, Answers),
    Answers == [definition_answer(met, point_c, [cite(eu_reg_2016_679_art_4_22), cite(eu_reg_2016_679_art_4_22_c)])].
test(authority_none) :-
    answers_of(supervisory_authority_concerned, authority_none, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_22)])].
test(cross_border_several) :-
    answers_of(cross_border_processing, cross_border_several, Answers),
    Answers == [definition_answer(met, point_a, [cite(eu_reg_2016_679_art_4_23), cite(eu_reg_2016_679_art_4_23_a)])].
test(cross_border_single) :-
    answers_of(cross_border_processing, cross_border_single, Answers),
    Answers == [definition_answer(met, point_b, [cite(eu_reg_2016_679_art_4_23), cite(eu_reg_2016_679_art_4_23_b)])].
test(cross_border_none) :-
    answers_of(cross_border_processing, cross_border_none, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_23)])].
test(objection_met) :-
    answers_of(relevant_and_reasoned_objection, objection_met, Answers),
    Answers == [definition_answer(met, none, [cite(eu_reg_2016_679_art_4_24)])].
test(objection_no_risk) :-
    answers_of(relevant_and_reasoned_objection, objection_no_risk, Answers),
    Answers == [definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_24)])].
test(objection_risk_unsure) :-
    answers_of(relevant_and_reasoned_objection, objection_risk_unsure, Answers),
    Answers == [definition_answer(needs_legal_review(open_textured(objection_demonstrates_significance_of_risks, cite(eu_reg_2016_679_art_4_24)), [inputs_relied_on([objection_to_draft_decision - true, objection_concerns_infringement_or_envisaged_action - true, objection_demonstrates_significance_of_risks - unsure])]), none, [cite(eu_reg_2016_679_art_4_24)])].
test(unknown_key_gives_input_problems) :-
    answers_of(enterprise, unknown_key_profile, Answers),
    Answers == [definition_answer(input_problems([unknown_key(not_a_contract_key)]), none, [])].
test(wrong_type_gives_input_problems) :-
    answers_of(cross_border_processing, wrong_type_profile, Answers),
    Answers == [definition_answer(input_problems([wrong_type(party_role)]), none, [])].
test(non_list_gives_input_problems) :-
    answers_of(party_is_controller, not_an_attribute_list, Answers),
    Answers == [definition_answer(input_problems([wrong_type(profile)]), none, [])].
test(the_verdict_carries_a_citation) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_determines, Profile),
    findall(Verdict, decide_gdpr_common_definitions_roles_and_establishments(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_common_definitions_roles_and_establishments_verdict(met, [cite(eu_reg_2016_679_art_4_7)])].

cp_test_names([controller_determines, controller_by_law, controller_law_not_provided, controller_law_unattested_refers, controller_judgement_unsure, controller_nothing_stated, processor_on_behalf, processor_not_on_behalf, genetic_data_met, genetic_data_not_genetic, genetic_personal_data_unsure_refers_to_4_1, biometric_data_met, biometric_not_personal_data, health_data_met, health_data_not_health, main_decisions_elsewhere, main_central_administration, main_no_place, main_processor_central, main_processor_main_activities, main_processor_not_subject, main_single_member_state, main_role_missing, main_power_unsure, enterprise_met, enterprise_not_economic, group_met, group_not_met, authority_established, authority_affected, authority_complaint, authority_none, cross_border_several, cross_border_single, cross_border_none, objection_met, objection_no_risk, objection_risk_unsure, unknown_key_gives_input_problems, wrong_type_gives_input_problems, non_list_gives_input_problems, the_verdict_carries_a_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
