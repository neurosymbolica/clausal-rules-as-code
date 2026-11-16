% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_binding_corporate_rules_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(clausal_hof, [include/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_gdpr_binding_corporate_rules, [binding_corporate_rules_definition/3, binding_corporate_rules_content/3, binding_corporate_rules_content_checklist/2, decide_gdpr_binding_corporate_rules/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_kernel, [gdpr_binding_corporate_rules_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_fixtures, [gdpr_binding_corporate_rules_subject/1, gdpr_binding_corporate_rules_profile_for/2]).

all_subjects(Subjects) :-
    findall(Subject, gdpr_binding_corporate_rules_subject(Subject), Found),
    sort(Found, Subjects).

well_formed_subjects(Subjects) :-
    findall(Subject, well_formed_subject(Subject), Found),
    sort(Found, Subjects).

well_formed_subject(Subject) :-
    gdpr_binding_corporate_rules_subject(Subject),
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    gdpr_binding_corporate_rules_input_problems(Profile, []).

definition_key_list([policies_are_personal_data_protection_policies, policies_adhered_to_by_adhering_party, adhering_party_is_controller_or_processor, adhering_party_established_on_territory_of_member_state, policies_cover_transfers_to_third_countries, recipients_are_controllers_or_processors, transfers_within_group_of_undertakings_or_group_of_enterprises]).

point_key_list([rules_specify_group_structure_and_contact_details, rules_specify_data_transfers, rules_specify_legally_binding_nature, rules_specify_application_of_general_data_protection_principles, rules_specify_data_subject_rights_and_means_to_exercise_them, rules_specify_acceptance_of_liability_for_members_outside_union, rules_specify_how_information_is_provided_to_data_subjects, rules_specify_tasks_of_compliance_monitoring_persons, rules_specify_complaint_procedures, rules_specify_compliance_verification_mechanisms, rules_specify_change_reporting_and_recording_mechanisms, rules_specify_cooperation_mechanism_with_supervisory_authority, rules_specify_reporting_of_third_country_legal_requirements, rules_specify_appropriate_data_protection_training]).

complete_citations([cite(eu_reg_2016_679_art_47_2), cite(eu_reg_2016_679_art_47_2_a), cite(eu_reg_2016_679_art_47_2_b), cite(eu_reg_2016_679_art_47_2_c), cite(eu_reg_2016_679_art_47_2_d), cite(eu_reg_2016_679_art_47_2_e), cite(eu_reg_2016_679_art_47_2_f), cite(eu_reg_2016_679_art_47_2_g), cite(eu_reg_2016_679_art_47_2_h), cite(eu_reg_2016_679_art_47_2_i), cite(eu_reg_2016_679_art_47_2_j), cite(eu_reg_2016_679_art_47_2_k), cite(eu_reg_2016_679_art_47_2_l), cite(eu_reg_2016_679_art_47_2_m), cite(eu_reg_2016_679_art_47_2_n)]).

one_definition_answer(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Result - Citations, binding_corporate_rules_definition(Profile, Result, Citations), Answers),
    length(Answers, 1).

one_content_answer(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Result - Citations, binding_corporate_rules_content(Profile, Result, Citations), Answers),
    length(Answers, 1).

one_checklist_answer(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Items, binding_corporate_rules_content_checklist(Profile, Items), Answers),
    length(Answers, 1).

one_input_check_answer(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Problems, gdpr_binding_corporate_rules_input_problems(Profile, Problems), Answers),
    length(Answers, 1).

one_facade_verdict(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_binding_corporate_rules(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

test(totality_and_determinism_of_the_definition) :-
    all_subjects(Subjects),
    maplist(one_definition_answer, Subjects).
test(totality_and_determinism_of_the_content) :-
    all_subjects(Subjects),
    maplist(one_content_answer, Subjects).
test(totality_and_determinism_of_the_checklist) :-
    all_subjects(Subjects),
    maplist(one_checklist_answer, Subjects).
test(totality_and_determinism_of_the_input_check) :-
    all_subjects(Subjects),
    maplist(one_input_check_answer, Subjects).
test(totality_and_determinism_of_the_facade) :-
    all_subjects(Subjects),
    maplist(one_facade_verdict, Subjects).
test(every_definition_answer_has_its_citation_shape) :-
    all_subjects(Subjects),
    maplist(definition_citations_fit, Subjects).
test(every_content_answer_has_its_citation_shape) :-
    all_subjects(Subjects),
    maplist(content_citations_fit, Subjects).
test(every_checklist_has_fourteen_points_in_order_or_input_problems) :-
    all_subjects(Subjects),
    maplist(checklist_fits, Subjects).
test(the_content_answer_agrees_with_its_checklist) :-
    well_formed_subjects(Subjects),
    maplist(content_agrees_with_checklist, Subjects).
test(the_definition_ignores_the_point_keys) :-
    well_formed_subjects(Subjects),
    maplist(definition_ignores_point_keys, Subjects).
test(the_content_ignores_the_definition_keys) :-
    well_formed_subjects(Subjects),
    maplist(content_ignores_definition_keys, Subjects).
test(the_well_formed_subject_set_is_not_vacuous) :-
    well_formed_subjects(Subjects),
    length(Subjects, Count),
    Count >= 15.

definition_citation_shape(binding_corporate_rules, [cite(eu_reg_2016_679_art_4_20)]).
definition_citation_shape(not_binding_corporate_rules, [cite(eu_reg_2016_679_art_4_20)]).
definition_citation_shape(indeterminate([_]), []).
definition_citation_shape(needs_legal_review(open_textured(_, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([_, _, _])]), []).
definition_citation_shape(input_problems([_|_]), []).

content_citation_shape(content_complete, Citations) :-
    complete_citations(Citations).
content_citation_shape(content_incomplete, [cite(eu_reg_2016_679_art_47_2)]).
content_citation_shape(indeterminate([_]), []).
content_citation_shape(needs_legal_review(open_textured(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)), [inputs_relied_on([rules_specify_appropriate_data_protection_training - unsure])]), []).
content_citation_shape(input_problems([_|_]), []).

definition_citations_fit(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    binding_corporate_rules_definition(Profile, Result, Citations),
    definition_citation_shape(Result, Citations).

content_citations_fit(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    binding_corporate_rules_content(Profile, Result, Citations),
    content_citation_shape(Result, Citations).

checklist_shape(input_problems([_|_])).
checklist_shape(Items) :-
    is_list(Items),
    point_key_list(Keys),
    maplist(item_fits, Keys, Items).

item_fits(Key, checklist_item(Key, cite(_), State)) :-
    member(State, [met, unmet, open_by_absence, open_by_judgement]).

checklist_fits(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    binding_corporate_rules_content_checklist(Profile, Items),
    checklist_shape(Items).

item_state(checklist_item(_, _, State), State).

agreement(content_complete, States) :-
    memberd_t(unmet, States, false),
    memberd_t(open_by_absence, States, false),
    memberd_t(open_by_judgement, States, false).
agreement(content_incomplete, States) :-
    memberd_t(unmet, States, true).
agreement(indeterminate(_), States) :-
    memberd_t(unmet, States, false),
    memberd_t(open_by_absence, States, true).
agreement(needs_legal_review(_, _), States) :-
    memberd_t(unmet, States, false),
    memberd_t(open_by_absence, States, false),
    memberd_t(open_by_judgement, States, true).

content_agrees_with_checklist(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    findall(Result, binding_corporate_rules_content(Profile, Result, _Citations), [Result]),
    findall(Items, binding_corporate_rules_content_checklist(Profile, Items), [Items]),
    maplist(item_state, Items, States),
    agreement(Result, States).

definition_attribute(attribute(Key, _)) :-
    definition_key_list(Keys),
    member(Key, Keys).

point_attribute(attribute(Key, _)) :-
    point_key_list(Keys),
    member(Key, Keys).

definition_ignores_point_keys(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    include(definition_attribute, Profile, Kept),
    findall(Result - Citations, binding_corporate_rules_definition(Profile, Result, Citations), Whole),
    findall(Result - Citations, binding_corporate_rules_definition(Kept, Result, Citations), Filtered),
    Whole == Filtered.

content_ignores_definition_keys(Subject) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    include(point_attribute, Profile, Kept),
    findall(Result - Citations, binding_corporate_rules_content(Profile, Result, Citations), Whole),
    findall(Result - Citations, binding_corporate_rules_content(Kept, Result, Citations), Filtered),
    Whole == Filtered.

cp_test_names([totality_and_determinism_of_the_definition, totality_and_determinism_of_the_content, totality_and_determinism_of_the_checklist, totality_and_determinism_of_the_input_check, totality_and_determinism_of_the_facade, every_definition_answer_has_its_citation_shape, every_content_answer_has_its_citation_shape, every_checklist_has_fourteen_points_in_order_or_input_problems, the_content_answer_agrees_with_its_checklist, the_definition_ignores_the_point_keys, the_content_ignores_the_definition_keys, the_well_formed_subject_set_is_not_vacuous]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
