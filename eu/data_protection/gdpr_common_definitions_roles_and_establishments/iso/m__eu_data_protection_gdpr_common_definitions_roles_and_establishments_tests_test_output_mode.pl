% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [decide_gdpr_common_definitions_roles_and_establishments/2, gdpr_common_definitions_roles_and_establishments_status/2, gdpr_common_definitions_roles_and_establishments_checklist/2, party_is_controller/2, main_establishment/2, supervisory_authority_concerned/2, cross_border_processing/2, relevant_and_reasoned_objection/2, roles_and_establishments_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_fixtures, [gdpr_common_definitions_roles_and_establishments_profile_for/2]).

test(the_relation_reads_out_exactly_one_answer) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_central_administration, Profile),
    findall(Answer, main_establishment(Profile, Answer), Answers),
    Answers == [definition_answer(met, central_administration, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)])].
test(an_empty_profile_lists_every_missing_key_of_point_22) :-
    findall(Answer, supervisory_authority_concerned([], Answer), Answers),
    Answers == [definition_answer(indeterminate([party_established_in_authority_member_state, data_subjects_in_authority_member_state_substantially_affected, complaint_lodged_with_authority]), none, [cite(eu_reg_2016_679_art_4_22)])].
test(an_empty_profile_lists_every_missing_key_of_point_23) :-
    findall(Answer, cross_border_processing([], Answer), Answers),
    Answers == [definition_answer(indeterminate([established_in_more_than_one_member_state, processing_in_context_of_establishments_in_more_than_one_member_state, processing_in_context_of_single_union_establishment, substantially_affects_data_subjects_in_more_than_one_member_state]), none, [cite(eu_reg_2016_679_art_4_23)])].
test(an_unmet_branch_of_the_or_is_not_entered) :-
    findall(Answer, cross_border_processing([attribute(established_in_more_than_one_member_state, false)], Answer), Answers),
    Answers == [definition_answer(indeterminate([processing_in_context_of_single_union_establishment, substantially_affects_data_subjects_in_more_than_one_member_state]), none, [cite(eu_reg_2016_679_art_4_23)])].
test(an_empty_profile_lists_every_element_of_point_24) :-
    findall(Answer, relevant_and_reasoned_objection([], Answer), Answers),
    Answers == [definition_answer(indeterminate([objection_to_draft_decision, objection_concerns_infringement_or_envisaged_action, objection_demonstrates_significance_of_risks]), none, [cite(eu_reg_2016_679_art_4_24)])].
test(missing_keys_come_before_an_unsure_judgement) :-
    findall(Answer, relevant_and_reasoned_objection([attribute(objection_demonstrates_significance_of_risks, unsure)], Answer), Answers),
    Answers == [definition_answer(indeterminate([objection_to_draft_decision, objection_concerns_infringement_or_envisaged_action]), none, [cite(eu_reg_2016_679_art_4_24)])].
test(missing_keys_come_before_an_absent_outside_fact) :-
    findall(Answer, party_is_controller([attribute(purposes_and_means_determined_by_law, true)], Answer), Answers),
    Answers == [definition_answer(indeterminate([party_determines_purposes_and_means]), none, [cite(eu_reg_2016_679_art_4_7)])].
test(an_absent_outside_fact_comes_before_an_unsure_judgement) :-
    findall(Answer, party_is_controller([attribute(party_determines_purposes_and_means, unsure), attribute(purposes_and_means_determined_by_law, true)], Answer), Answers),
    Answers == [definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)), [resolution(cite(union_or_member_state_law_providing_for_controller), not_attempted), inputs_relied_on([party_determines_purposes_and_means - unsure, purposes_and_means_determined_by_law - true])]), none, [cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)])].
test(a_met_ground_names_the_first_way_met_on_the_profile_as_given) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(complaint_with_unsure_effect, Profile),
    findall(Answer, supervisory_authority_concerned(Profile, Answer), Answers),
    Answers == [definition_answer(met, point_c, [cite(eu_reg_2016_679_art_4_22), cite(eu_reg_2016_679_art_4_22_c)])].
test(the_unsure_power_to_implement_refers_once_central_administration_is_given) :-
    findall(Answer, main_establishment([attribute(party_role, controller), attribute(established_in_more_than_one_member_state, true), attribute(central_administration_in_union, false), attribute(decisions_taken_in_other_union_establishment, true), attribute(other_establishment_can_have_decisions_implemented, unsure)], Answer), Answers),
    Answers == [definition_answer(needs_legal_review(open_textured(other_establishment_can_have_decisions_implemented, cite(eu_reg_2016_679_art_4_16_a)), [inputs_relied_on([decisions_taken_in_other_union_establishment - true, other_establishment_can_have_decisions_implemented - unsure])]), none, [cite(eu_reg_2016_679_art_4_16_a)])].
test(the_verdict_reads_out_eleven_definitions_with_citations) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(hospital_health_data, Profile),
    findall(Verdict, decide_gdpr_common_definitions_roles_and_establishments(Profile, Verdict), Verdicts),
    Verdicts = [gdpr_common_definitions_roles_and_establishments_verdict(Definitions, [_|_])],
    length(Definitions, 11).
test(the_status_projection_reads_out_one_list) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(hospital_health_data, Profile),
    findall(Statuses, gdpr_common_definitions_roles_and_establishments_status(Profile, Statuses), Results),
    Results = [OnlyStatuses],
    member(defined_term(data_concerning_health, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_15)])), OnlyStatuses).
test(the_checklist_reads_out_one_item_per_definition_with_cites) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(hospital_health_data, Profile),
    gdpr_common_definitions_roles_and_establishments_checklist(Profile, Items),
    length(Items, 11),
    member(item(data_concerning_health, met, [cite(eu_reg_2016_679_art_4_15)]), Items).
test(outside_facts_reads_out_the_attested_term_as_given) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(law_designated_controller_attested, Profile),
    findall(OutsideFacts, roles_and_establishments_outside_facts(Profile, OutsideFacts), Results),
    Results == [[outside_fact(party_provided_for_as_controller_by_law, attested(true, attestation(by, at, reason, none)))]].
test(outside_facts_reads_out_absent) :-
    findall(OutsideFacts, roles_and_establishments_outside_facts([], OutsideFacts), Results),
    Results == [[outside_fact(party_provided_for_as_controller_by_law, absent)]].

cp_test_names([the_relation_reads_out_exactly_one_answer, an_empty_profile_lists_every_missing_key_of_point_22, an_empty_profile_lists_every_missing_key_of_point_23, an_unmet_branch_of_the_or_is_not_entered, an_empty_profile_lists_every_element_of_point_24, missing_keys_come_before_an_unsure_judgement, missing_keys_come_before_an_absent_outside_fact, an_absent_outside_fact_comes_before_an_unsure_judgement, a_met_ground_names_the_first_way_met_on_the_profile_as_given, the_unsure_power_to_implement_refers_once_central_administration_is_given, the_verdict_reads_out_eleven_definitions_with_citations, the_status_projection_reads_out_one_list, the_checklist_reads_out_one_item_per_definition_with_cites, outside_facts_reads_out_the_attested_term_as_given, outside_facts_reads_out_absent]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
