% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [decide_gdpr_common_definitions_roles_and_establishments/2, gdpr_common_definitions_roles_and_establishments_status/2, gdpr_common_definitions_roles_and_establishments_checklist/2, gdpr_common_definitions_roles_and_establishments_decision_resolvable/1, gdpr_common_definitions_roles_and_establishments_status_values/1, party_is_controller/2, party_is_processor/2, genetic_data/2, biometric_data/2, data_concerning_health/2, main_establishment/2, enterprise/2, group_of_undertakings/2, supervisory_authority_concerned/2, cross_border_processing/2, relevant_and_reasoned_objection/2, roles_and_establishments_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_fixtures, [gdpr_common_definitions_roles_and_establishments_subject/1, gdpr_common_definitions_roles_and_establishments_profile_for/2, gdpr_common_definitions_roles_and_establishments_assess/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_queries, [gdpr_common_definitions_roles_and_establishments_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_kernel, [gdpr_common_definitions_roles_and_establishments_input_problems/2]).

profile(Subject, Profile) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile).

test(controller_by_judgement_is_met) :-
    profile(controller_by_judgement, Profile),
    party_is_controller(Profile, definition_answer(met, determines_purposes_and_means, [cite(eu_reg_2016_679_art_4_7)])).
test(controller_judgement_false_is_not_met) :-
    profile(controller_judgement_false, Profile),
    party_is_controller(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_7)])).
test(law_designated_controller_attested_is_met) :-
    profile(law_designated_controller_attested, Profile),
    party_is_controller(Profile, definition_answer(met, provided_for_by_law, [cite(eu_reg_2016_679_art_4_7)])).
test(law_designated_controller_attested_false_is_not_met) :-
    profile(law_designated_controller_attested_false, Profile),
    party_is_controller(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_7)])).
test(law_designated_controller_unattested_refers) :-
    profile(law_designated_controller_unattested, Profile),
    party_is_controller(Profile, definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)), [resolution(cite(union_or_member_state_law_providing_for_controller), not_attempted), inputs_relied_on([party_determines_purposes_and_means - false, purposes_and_means_determined_by_law - true])]), none, [cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)])).
test(url_evidence_is_well_formed_copied_and_met) :-
    Attested = attested(true, attestation(by, at, reason, url('https://eur-lex.europa.eu/example', retrieved_at))),
    Profile = [attribute(party_determines_purposes_and_means, false), attribute(purposes_and_means_determined_by_law, true), attribute(party_provided_for_as_controller_by_law, Attested)],
    gdpr_common_definitions_roles_and_establishments_input_problems(Profile, []),
    roles_and_establishments_outside_facts(Profile, [outside_fact(party_provided_for_as_controller_by_law, attested(true, attestation(by, at, reason, url('https://eur-lex.europa.eu/example', retrieved_at))))]),
    party_is_controller(Profile, definition_answer(met, provided_for_by_law, [cite(eu_reg_2016_679_art_4_7)])).
test(document_evidence_is_well_formed_copied_and_not_met) :-
    Attested = attested(false, attestation(by, at, reason, document(upload_one, sha_digest))),
    Profile = [attribute(party_determines_purposes_and_means, false), attribute(purposes_and_means_determined_by_law, true), attribute(party_provided_for_as_controller_by_law, Attested)],
    gdpr_common_definitions_roles_and_establishments_input_problems(Profile, []),
    roles_and_establishments_outside_facts(Profile, [outside_fact(party_provided_for_as_controller_by_law, attested(false, attestation(by, at, reason, document(upload_one, sha_digest))))]),
    party_is_controller(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_7)])).
test(provenance_item_destructures_and_is_not_appended_to_pairs) :-
    Item = provenance(open_textured, [cite(eu_reg_2016_679_art_4_24)]),
    Item = provenance(Clause, Citations),
    Clause == open_textured,
    Citations == [cite(eu_reg_2016_679_art_4_24)],
    profile(objection_risks_unsure, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(needs_legal_review(_, [inputs_relied_on(Pairs)]), none, _)),
    Pairs == [objection_to_draft_decision - true, objection_concerns_infringement_or_envisaged_action - true, objection_demonstrates_significance_of_risks - unsure].
test(cloud_processor_is_met) :-
    profile(cloud_processor, Profile),
    party_is_processor(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_8)])).
test(not_on_behalf_of_controller_is_not_met) :-
    profile(not_on_behalf_of_controller, Profile),
    party_is_processor(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_8)])).
test(genetic_test_laboratory_is_met) :-
    profile(genetic_test_laboratory, Profile),
    genetic_data(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_13)])).
test(genetic_data_not_personal_is_not_met) :-
    profile(genetic_data_not_personal, Profile),
    genetic_data(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_13)])).
test(biometric_access_control_is_met) :-
    profile(biometric_access_control, Profile),
    biometric_data(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_14)])).
test(biometric_personal_data_unsure_refers_to_point_one) :-
    profile(biometric_personal_data_unsure, Profile),
    biometric_data(Profile, definition_answer(needs_legal_review(open_textured(data_are_personal_data, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([data_are_personal_data - unsure])]), none, [cite(eu_reg_2016_679_art_4_1)])).
test(hospital_health_data_is_met) :-
    profile(hospital_health_data, Profile),
    data_concerning_health(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_15)])).
test(health_status_not_revealed_is_not_met) :-
    profile(health_status_not_revealed, Profile),
    data_concerning_health(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_15)])).
test(controller_with_deciding_establishment_is_met) :-
    profile(controller_with_deciding_establishment, Profile),
    main_establishment(Profile, definition_answer(met, establishment_taking_decisions, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])).
test(controller_central_administration_is_met) :-
    profile(controller_central_administration, Profile),
    main_establishment(Profile, definition_answer(met, central_administration, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])).
test(controller_without_main_establishment_is_not_met) :-
    profile(controller_without_main_establishment, Profile),
    main_establishment(Profile, definition_answer(not_met, no_main_establishment_identified, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])).
test(controller_power_to_implement_unsure_names_central_administration) :-
    profile(controller_power_to_implement_unsure, Profile),
    main_establishment(Profile, definition_answer(indeterminate([central_administration_in_union]), none, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])).
test(single_member_state_party_is_not_met) :-
    profile(single_member_state_party, Profile),
    main_establishment(Profile, definition_answer(not_met, not_established_in_more_than_one_member_state, [cite(eu_reg_2016_679_art_4_16)])).
test(cloud_processor_two_member_states_is_met) :-
    profile(cloud_processor_two_member_states, Profile),
    main_establishment(Profile, definition_answer(met, establishment_of_main_processing_activities, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_b)])).
test(processor_without_specific_obligations_is_not_met) :-
    profile(processor_without_specific_obligations, Profile),
    main_establishment(Profile, definition_answer(not_met, no_main_establishment_identified, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_b)])).
test(trading_partnership_is_met) :-
    profile(trading_partnership, Profile),
    enterprise(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_18)])).
test(partnership_without_economic_activity_is_not_met) :-
    profile(partnership_without_economic_activity, Profile),
    enterprise(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_18)])).
test(holding_group_is_met) :-
    profile(holding_group, Profile),
    group_of_undertakings(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_19)])).
test(undertakings_without_control_is_not_met) :-
    profile(undertakings_without_control, Profile),
    group_of_undertakings(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_19)])).
test(complaint_only_authority_is_met_by_point_c) :-
    profile(complaint_only_authority, Profile),
    supervisory_authority_concerned(Profile, definition_answer(met, point_c, [cite(eu_reg_2016_679_art_4_22), cite(eu_reg_2016_679_art_4_22_c)])).
test(authority_not_concerned_is_not_met) :-
    profile(authority_not_concerned, Profile),
    supervisory_authority_concerned(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_22)])).
test(complaint_with_unsure_effect_names_point_c) :-
    profile(complaint_with_unsure_effect, Profile),
    supervisory_authority_concerned(Profile, definition_answer(met, point_c, [cite(eu_reg_2016_679_art_4_22), cite(eu_reg_2016_679_art_4_22_c)])).
test(establishments_in_several_member_states_is_point_a) :-
    profile(establishments_in_several_member_states, Profile),
    cross_border_processing(Profile, definition_answer(met, point_a, [cite(eu_reg_2016_679_art_4_23), cite(eu_reg_2016_679_art_4_23_a)])).
test(single_establishment_cross_border_is_point_b) :-
    profile(single_establishment_cross_border, Profile),
    cross_border_processing(Profile, definition_answer(met, point_b, [cite(eu_reg_2016_679_art_4_23), cite(eu_reg_2016_679_art_4_23_b)])).
test(single_establishment_local_effect_is_not_met) :-
    profile(single_establishment_local_effect, Profile),
    cross_border_processing(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_23)])).
test(reasoned_objection_is_met) :-
    profile(reasoned_objection, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_24)])).
test(objection_incomplete_is_not_met) :-
    profile(objection_incomplete, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(not_met, none, [cite(eu_reg_2016_679_art_4_24)])).
test(objection_risks_unsure_refers) :-
    profile(objection_risks_unsure, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(needs_legal_review(open_textured(objection_demonstrates_significance_of_risks, cite(eu_reg_2016_679_art_4_24)), [inputs_relied_on([objection_to_draft_decision - true, objection_concerns_infringement_or_envisaged_action - true, objection_demonstrates_significance_of_risks - unsure])]), none, [cite(eu_reg_2016_679_art_4_24)])).
test(malformed_profile_has_its_problems) :-
    profile(malformed_profile_duplicate_and_unknown, Profile),
    gdpr_common_definitions_roles_and_establishments_input_problems(Profile, [duplicate_key(party_role), unknown_key(stray)]).
test(malformed_profile_answers_every_relation_with_input_problems) :-
    profile(malformed_profile_duplicate_and_unknown, Profile),
    main_establishment(Profile, definition_answer(input_problems([duplicate_key(party_role), unknown_key(stray)]), none, [])),
    party_is_controller(Profile, definition_answer(input_problems([duplicate_key(party_role), unknown_key(stray)]), none, [])),
    roles_and_establishments_outside_facts(Profile, input_problems([duplicate_key(party_role), unknown_key(stray)])).
test(a_well_formed_fixture_has_no_problem) :-
    profile(cloud_processor_two_member_states, Profile),
    gdpr_common_definitions_roles_and_establishments_input_problems(Profile, []).
test(outside_fact_as_given) :-
    profile(law_designated_controller_attested, Profile),
    roles_and_establishments_outside_facts(Profile, [outside_fact(party_provided_for_as_controller_by_law, attested(true, attestation(by, at, reason, none)))]).
test(outside_fact_absent) :-
    profile(law_designated_controller_unattested, Profile),
    roles_and_establishments_outside_facts(Profile, [outside_fact(party_provided_for_as_controller_by_law, absent)]).
test(every_subject_answers_exactly_once) :-
    findall(Subject, gdpr_common_definitions_roles_and_establishments_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(answers_once, Subjects).
test(every_subject_has_a_full_checklist) :-
    findall(Subject, gdpr_common_definitions_roles_and_establishments_subject(Subject), Subjects),
    maplist(checklist_carries_items, Subjects).
test(checklist_item_carries_cite_provenance) :-
    profile(hospital_health_data, Profile),
    gdpr_common_definitions_roles_and_establishments_checklist(Profile, Items),
    member(item(data_concerning_health, met, [cite(eu_reg_2016_679_art_4_15)]), Items).
test(verdict_lists_the_definition_and_its_citation) :-
    profile(holding_group, Profile),
    decide_gdpr_common_definitions_roles_and_establishments(Profile, gdpr_common_definitions_roles_and_establishments_verdict(Definitions, Citations)),
    member(defined_term(group_of_undertakings, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_19)])), Definitions),
    member(cite(eu_reg_2016_679_art_4_19), Citations).
test(status_projection_gives_the_eleven_definitions) :-
    profile(reasoned_objection, Profile),
    gdpr_common_definitions_roles_and_establishments_status(Profile, Statuses),
    length(Statuses, 11),
    member(defined_term(relevant_and_reasoned_objection, definition_answer(met, none, _)), Statuses).
test(terminal_status_values) :-
    gdpr_common_definitions_roles_and_establishments_status_values([met, not_met]).
test(decision_resolvable_on_a_fixture) :-
    profile(controller_by_judgement, Profile),
    gdpr_common_definitions_roles_and_establishments_decision_resolvable(Profile).
test(what_if_flips_the_near_miss_controller) :-
    profile(controller_judgement_false, Profile),
    gdpr_common_definitions_roles_and_establishments_what_if(Profile, party_determines_purposes_and_means, true, Statuses),
    member(defined_term(party_is_controller, definition_answer(met, determines_purposes_and_means, [cite(eu_reg_2016_679_art_4_7)])), Statuses).
test(what_if_flips_the_near_miss_processor_main_establishment) :-
    profile(processor_without_specific_obligations, Profile),
    gdpr_common_definitions_roles_and_establishments_what_if(Profile, processor_subject_to_specific_obligations, true, Statuses),
    member(defined_term(main_establishment, definition_answer(met, establishment_of_main_processing_activities, _)), Statuses).

test(controller_judgement_false_is_not_met_as_well, fail) :-
    profile(controller_judgement_false, Profile),
    party_is_controller(Profile, definition_answer(met, _, _)).
test(law_designated_controller_unattested_is_not_final, fail) :-
    profile(law_designated_controller_unattested, Profile),
    party_is_controller(Profile, definition_answer(met, _, _)).
test(url_evidence_attested_true_is_not_not_met, fail) :-
    Profile = [attribute(party_determines_purposes_and_means, false), attribute(purposes_and_means_determined_by_law, true), attribute(party_provided_for_as_controller_by_law, attested(true, attestation(by, at, reason, url('https://eur-lex.europa.eu/example', retrieved_at))))],
    party_is_controller(Profile, definition_answer(not_met, _, _)).
test(document_evidence_attested_false_is_not_met_only, fail) :-
    Profile = [attribute(party_determines_purposes_and_means, false), attribute(purposes_and_means_determined_by_law, true), attribute(party_provided_for_as_controller_by_law, attested(false, attestation(by, at, reason, document(upload_one, sha_digest))))],
    party_is_controller(Profile, definition_answer(met, _, _)).
test(provenance_item_is_absent_from_the_pairs, fail) :-
    profile(objection_risks_unsure, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(needs_legal_review(_, [inputs_relied_on(Pairs)]), none, _)),
    member(provenance(_, _), Pairs).
test(not_on_behalf_of_controller_is_not_met_as_well, fail) :-
    profile(not_on_behalf_of_controller, Profile),
    party_is_processor(Profile, definition_answer(met, _, _)).
test(genetic_data_not_personal_is_not_met_as_well, fail) :-
    profile(genetic_data_not_personal, Profile),
    genetic_data(Profile, definition_answer(met, _, _)).
test(biometric_personal_data_unsure_is_not_met, fail) :-
    profile(biometric_personal_data_unsure, Profile),
    biometric_data(Profile, definition_answer(met, _, _)).
test(health_status_not_revealed_is_not_met_as_well, fail) :-
    profile(health_status_not_revealed, Profile),
    data_concerning_health(Profile, definition_answer(met, _, _)).
test(controller_without_main_establishment_is_not_met_as_well, fail) :-
    profile(controller_without_main_establishment, Profile),
    main_establishment(Profile, definition_answer(met, _, _)).
test(processor_without_specific_obligations_is_not_met_as_well, fail) :-
    profile(processor_without_specific_obligations, Profile),
    main_establishment(Profile, definition_answer(met, _, _)).
test(partnership_without_economic_activity_is_not_met_as_well, fail) :-
    profile(partnership_without_economic_activity, Profile),
    enterprise(Profile, definition_answer(met, _, _)).
test(undertakings_without_control_is_not_met_as_well, fail) :-
    profile(undertakings_without_control, Profile),
    group_of_undertakings(Profile, definition_answer(met, _, _)).
test(authority_not_concerned_is_not_met_as_well, fail) :-
    profile(authority_not_concerned, Profile),
    supervisory_authority_concerned(Profile, definition_answer(met, _, _)).
test(complaint_with_unsure_effect_does_not_name_point_b, fail) :-
    profile(complaint_with_unsure_effect, Profile),
    supervisory_authority_concerned(Profile, definition_answer(met, point_b, _)).
test(single_establishment_local_effect_is_not_met_as_well, fail) :-
    profile(single_establishment_local_effect, Profile),
    cross_border_processing(Profile, definition_answer(met, _, _)).
test(objection_incomplete_is_not_met_as_well, fail) :-
    profile(objection_incomplete, Profile),
    relevant_and_reasoned_objection(Profile, definition_answer(met, _, _)).
test(malformed_profile_gets_no_final_answer, fail) :-
    profile(malformed_profile_duplicate_and_unknown, Profile),
    main_establishment(Profile, definition_answer(met, _, _)).

answers_once(Subject) :-
    findall(Result, gdpr_common_definitions_roles_and_establishments_assess(Subject, Result), Results),
    length(Results, 1),
    Results = [gdpr_common_definitions_roles_and_establishments_verdict(Definitions, _Citations)],
    length(Definitions, 11).

checklist_carries_items(Subject) :-
    profile(Subject, Profile),
    gdpr_common_definitions_roles_and_establishments_checklist(Profile, Items),
    Items = [_|_],
    length(Items, 11).

cp_test_names([controller_by_judgement_is_met, controller_judgement_false_is_not_met, law_designated_controller_attested_is_met, law_designated_controller_attested_false_is_not_met, law_designated_controller_unattested_refers, url_evidence_is_well_formed_copied_and_met, document_evidence_is_well_formed_copied_and_not_met, provenance_item_destructures_and_is_not_appended_to_pairs, cloud_processor_is_met, not_on_behalf_of_controller_is_not_met, genetic_test_laboratory_is_met, genetic_data_not_personal_is_not_met, biometric_access_control_is_met, biometric_personal_data_unsure_refers_to_point_one, hospital_health_data_is_met, health_status_not_revealed_is_not_met, controller_with_deciding_establishment_is_met, controller_central_administration_is_met, controller_without_main_establishment_is_not_met, controller_power_to_implement_unsure_names_central_administration, single_member_state_party_is_not_met, cloud_processor_two_member_states_is_met, processor_without_specific_obligations_is_not_met, trading_partnership_is_met, partnership_without_economic_activity_is_not_met, holding_group_is_met, undertakings_without_control_is_not_met, complaint_only_authority_is_met_by_point_c, authority_not_concerned_is_not_met, complaint_with_unsure_effect_names_point_c, establishments_in_several_member_states_is_point_a, single_establishment_cross_border_is_point_b, single_establishment_local_effect_is_not_met, reasoned_objection_is_met, objection_incomplete_is_not_met, objection_risks_unsure_refers, malformed_profile_has_its_problems, malformed_profile_answers_every_relation_with_input_problems, a_well_formed_fixture_has_no_problem, outside_fact_as_given, outside_fact_absent, every_subject_answers_exactly_once, every_subject_has_a_full_checklist, checklist_item_carries_cite_provenance, verdict_lists_the_definition_and_its_citation, status_projection_gives_the_eleven_definitions, terminal_status_values, decision_resolvable_on_a_fixture, what_if_flips_the_near_miss_controller, what_if_flips_the_near_miss_processor_main_establishment]).
cp_test_fail_names([controller_judgement_false_is_not_met_as_well, law_designated_controller_unattested_is_not_final, url_evidence_attested_true_is_not_not_met, document_evidence_attested_false_is_not_met_only, provenance_item_is_absent_from_the_pairs, not_on_behalf_of_controller_is_not_met_as_well, genetic_data_not_personal_is_not_met_as_well, biometric_personal_data_unsure_is_not_met, health_status_not_revealed_is_not_met_as_well, controller_without_main_establishment_is_not_met_as_well, processor_without_specific_obligations_is_not_met_as_well, partnership_without_economic_activity_is_not_met_as_well, undertakings_without_control_is_not_met_as_well, authority_not_concerned_is_not_met_as_well, complaint_with_unsure_effect_does_not_name_point_b, single_establishment_local_effect_is_not_met_as_well, objection_incomplete_is_not_met_as_well, malformed_profile_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
