% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_binding_corporate_rules_queries, [gdpr_binding_corporate_rules_profile_keys/1, gdpr_binding_corporate_rules_what_if/4, checklist_item/3, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_kernel, [gdpr_binding_corporate_rules_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_gdpr_binding_corporate_rules, [binding_corporate_rules_definition/3, binding_corporate_rules_content/3]).

definition_element_keys([policies_are_personal_data_protection_policies, policies_adhered_to_by_adhering_party, adhering_party_is_controller_or_processor, adhering_party_established_on_territory_of_member_state, policies_cover_transfers_to_third_countries, recipients_are_controllers_or_processors, transfers_within_group_of_undertakings_or_group_of_enterprises]).

content_point_keys([rules_specify_group_structure_and_contact_details, rules_specify_data_transfers, rules_specify_legally_binding_nature, rules_specify_application_of_general_data_protection_principles, rules_specify_data_subject_rights_and_means_to_exercise_them, rules_specify_acceptance_of_liability_for_members_outside_union, rules_specify_how_information_is_provided_to_data_subjects, rules_specify_tasks_of_compliance_monitoring_persons, rules_specify_complaint_procedures, rules_specify_compliance_verification_mechanisms, rules_specify_change_reporting_and_recording_mechanisms, rules_specify_cooperation_mechanism_with_supervisory_authority, rules_specify_reporting_of_third_country_legal_requirements, rules_specify_appropriate_data_protection_training]).

gdpr_binding_corporate_rules_profile_keys(Keys) :-
    definition_element_keys(DefinitionKeys),
    content_point_keys(PointKeys),
    append(DefinitionKeys, PointKeys, Keys).

gdpr_binding_corporate_rules_what_if(Profile, Key, Value, gdpr_binding_corporate_rules_verdict(Result, Citations)) :-
    hypothesis(Profile, Key, Value, Hypothesis),
    key_route(Key, Route),
    routed_answer(Route, Hypothesis, Result, Citations).

hypothesis(Profile, Key, Value, Hypothesis) :-
    gdpr_binding_corporate_rules_input_problems(Profile, Problems),
    profile_shape(Problems, Shape),
    shaped_hypothesis(Shape, Profile, Key, Value, Hypothesis).

profile_shape(Problems, not_attribute_list) :-
    Problems == [wrong_type(profile)].
profile_shape(Problems, attribute_list) :-
    Problems \== [wrong_type(profile)].

shaped_hypothesis(not_attribute_list, Profile, _, _, Profile).
shaped_hypothesis(attribute_list, Profile, Key, Value, Hypothesis) :-
    without_key(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], Hypothesis).

without_key([], _, []).
without_key([attribute(ElementKey, _)|Elements], Key, Kept) :-
    ElementKey == Key,
    without_key(Elements, Key, Kept).
without_key([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Kept]) :-
    ElementKey \== Key,
    without_key(Elements, Key, Kept).

key_route(Key, Route) :-
    definition_element_keys(DefinitionKeys),
    content_point_keys(PointKeys),
    identical_member_t(Key, DefinitionKeys, InDefinition),
    identical_member_t(Key, PointKeys, InContent),
    route_for(InDefinition, InContent, Route).

route_for(true, _, definition).
route_for(false, true, content).
route_for(false, false, definition).

identical_member_t(_, [], false).
identical_member_t(Key, [Known|_], true) :-
    Known == Key.
identical_member_t(Key, [Known|Knowns], Truth) :-
    Known \== Key,
    identical_member_t(Key, Knowns, Truth).

routed_answer(definition, Hypothesis, Result, Citations) :-
    binding_corporate_rules_definition(Hypothesis, Result, Citations).
routed_answer(content, Hypothesis, Result, Citations) :-
    binding_corporate_rules_content(Hypothesis, Result, Citations).

checklist_item(Key, Citation, State) :-
    checklist_point(Key, Citation),
    checklist_state(State).

checklist_point(rules_specify_group_structure_and_contact_details, cite(eu_reg_2016_679_art_47_2_a)).
checklist_point(rules_specify_data_transfers, cite(eu_reg_2016_679_art_47_2_b)).
checklist_point(rules_specify_legally_binding_nature, cite(eu_reg_2016_679_art_47_2_c)).
checklist_point(rules_specify_application_of_general_data_protection_principles, cite(eu_reg_2016_679_art_47_2_d)).
checklist_point(rules_specify_data_subject_rights_and_means_to_exercise_them, cite(eu_reg_2016_679_art_47_2_e)).
checklist_point(rules_specify_acceptance_of_liability_for_members_outside_union, cite(eu_reg_2016_679_art_47_2_f)).
checklist_point(rules_specify_how_information_is_provided_to_data_subjects, cite(eu_reg_2016_679_art_47_2_g)).
checklist_point(rules_specify_tasks_of_compliance_monitoring_persons, cite(eu_reg_2016_679_art_47_2_h)).
checklist_point(rules_specify_complaint_procedures, cite(eu_reg_2016_679_art_47_2_i)).
checklist_point(rules_specify_compliance_verification_mechanisms, cite(eu_reg_2016_679_art_47_2_j)).
checklist_point(rules_specify_change_reporting_and_recording_mechanisms, cite(eu_reg_2016_679_art_47_2_k)).
checklist_point(rules_specify_cooperation_mechanism_with_supervisory_authority, cite(eu_reg_2016_679_art_47_2_l)).
checklist_point(rules_specify_reporting_of_third_country_legal_requirements, cite(eu_reg_2016_679_art_47_2_m)).
checklist_point(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)).

checklist_state(met).
checklist_state(unmet).
checklist_state(open_by_absence).
checklist_state(open_by_judgement).

indeterminate([Key]) :-
    gdpr_binding_corporate_rules_profile_keys(Keys),
    member(Key, Keys).

needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]) :-
    open_textured(Key, Citation),
    inputs_relied_on(Pairs).

open_textured(Key, Citation) :-
    referral_row(Key, Citation).

referral_row(adhering_party_is_controller_or_processor, cite(eu_reg_2016_679_art_4_20)).
referral_row(recipients_are_controllers_or_processors, cite(eu_reg_2016_679_art_4_20)).
referral_row(transfers_within_group_of_undertakings_or_group_of_enterprises, cite(eu_reg_2016_679_art_4_20)).
referral_row(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)).

inputs_relied_on(Pairs) :-
    is_list(Pairs),
    maplist(judgement_pair, Pairs).

judgement_pair(Key - Value) :-
    judgement_key(Key),
    judgement_value(Value).

judgement_key(adhering_party_is_controller_or_processor).
judgement_key(recipients_are_controllers_or_processors).
judgement_key(transfers_within_group_of_undertakings_or_group_of_enterprises).
judgement_key(rules_specify_appropriate_data_protection_training).

judgement_value(true).
judgement_value(false).
judgement_value(unsure).

input_problems(Problems) :-
    is_list(Problems),
    Problems = [_|_],
    maplist(input_problem, Problems).

input_problem(unknown_key(Key)) :-
    unknown_key(Key).
input_problem(wrong_type(Key)) :-
    wrong_type(Key).
input_problem(duplicate_key(Key)) :-
    duplicate_key(Key).

unknown_key(Key) :-
    gdpr_binding_corporate_rules_profile_keys(Keys),
    identical_member_t(Key, Keys, false).

wrong_type(profile).
wrong_type(Key) :-
    gdpr_binding_corporate_rules_profile_keys(Keys),
    member(Key, Keys).

duplicate_key(Key) :-
    gdpr_binding_corporate_rules_profile_keys(Keys),
    member(Key, Keys).

test(the_key_schema_holds_twenty_one_keys) :-
    gdpr_binding_corporate_rules_profile_keys(Keys),
    length(Keys, 21).
test(an_override_of_a_definition_key_reasks_the_definition) :-
    findall(Verdict, gdpr_binding_corporate_rules_what_if([attribute(policies_cover_transfers_to_third_countries, false)], policies_cover_transfers_to_third_countries, true, Verdict), Verdicts),
    Verdicts == [gdpr_binding_corporate_rules_verdict(indeterminate([policies_are_personal_data_protection_policies]), [])].
test(an_override_of_a_point_key_reasks_the_content) :-
    findall(Verdict, gdpr_binding_corporate_rules_what_if([], rules_specify_data_transfers, false, Verdict), Verdicts),
    Verdicts == [gdpr_binding_corporate_rules_verdict(content_incomplete, [cite(eu_reg_2016_679_art_47_2)])].
test(an_override_of_an_unknown_key_is_an_input_problem) :-
    findall(Verdict, gdpr_binding_corporate_rules_what_if([], colour, red, Verdict), Verdicts),
    Verdicts == [gdpr_binding_corporate_rules_verdict(input_problems([unknown_key(colour)]), [])].
test(a_profile_that_is_not_a_list_stays_an_input_problem) :-
    findall(Verdict, gdpr_binding_corporate_rules_what_if(nothing, policies_are_personal_data_protection_policies, true, Verdict), Verdicts),
    Verdicts == [gdpr_binding_corporate_rules_verdict(input_problems([wrong_type(profile)]), [])].
test(an_override_replaces_a_repeated_key) :-
    findall(Verdict, gdpr_binding_corporate_rules_what_if([attribute(rules_specify_complaint_procedures, true), attribute(rules_specify_complaint_procedures, false)], rules_specify_complaint_procedures, false, Verdict), Verdicts),
    Verdicts == [gdpr_binding_corporate_rules_verdict(content_incomplete, [cite(eu_reg_2016_679_art_47_2)])].
test(a_checklist_item_is_recognised) :-
    checklist_item(rules_specify_complaint_procedures, cite(eu_reg_2016_679_art_47_2_i), unmet).
test(a_referral_is_recognised) :-
    needs_legal_review(open_textured(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)), [inputs_relied_on([rules_specify_appropriate_data_protection_training - unsure])]).
test(an_outside_key_is_unknown) :-
    unknown_key(colour).

test(a_checklist_item_with_the_wrong_citation_is_not_recognised, fail) :-
    checklist_item(rules_specify_complaint_procedures, cite(eu_reg_2016_679_art_47_2_j), unmet).
test(a_contract_key_is_not_unknown, fail) :-
    unknown_key(rules_specify_data_transfers).
