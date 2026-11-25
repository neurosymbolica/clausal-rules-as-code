% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_queries, [nis2_lex_specialis_and_definitions_profile_keys/1, nis2_lex_specialis_and_definitions_what_if/4]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_kernel, [nis2_lex_specialis_and_definitions_input_problems/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_nis2_lex_specialis_and_definitions, [nis2_lex_specialis_and_definitions_status/2, nis2_lex_specialis_and_definitions_checklist/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_fixtures, [nis2_lex_specialis_and_definitions_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_lex_specialis_and_definitions_profile_keys(ProfileKeys),
    ProfileKeys == [entity_class, dora_risk_management_measures_at_least_equivalent_in_effect, dora_gives_immediate_access_to_incident_notifications, dora_incident_notification_requirements_at_least_equivalent_in_effect].
test(input_problems_is_re_exported) :-
    nis2_lex_specialis_and_definitions_profile_for(malformed_duplicate_and_unknown, Profile),
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems(Profile, Problems), Solutions),
    Solutions == [[duplicate_key(entity_class), unknown_key(sector)]].
test(status_answers_once) :-
    nis2_lex_specialis_and_definitions_profile_for(important_only_point_a_met, Profile),
    findall(Status, nis2_lex_specialis_and_definitions_status(Profile, Status), Statuses),
    Statuses == [nis2_groups(nis2_provisions_disapplied, nis2_provisions_apply)].
test(checklist_items_carry_cited_provenance) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_all_equivalent, Profile),
    findall(Checklist, nis2_lex_specialis_and_definitions_checklist(Profile, Checklist), Checklists),
    Checklists == [[item(risk_management_provisions, nis2_provisions_disapplied, [cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_a), cite(eu_reg_2022_2554_art_1_2)]), item(incident_notification_provisions, nis2_provisions_disapplied, [cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_b), cite(eu_reg_2022_2554_art_1_2)])]].
test(checklist_reports_a_referral_item) :-
    nis2_lex_specialis_and_definitions_profile_for(unsure_risk_measures, Profile),
    nis2_lex_specialis_and_definitions_checklist(Profile, [item(risk_management_provisions, needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), _), _), item(incident_notification_provisions, nis2_provisions_apply, _)]).
test(what_if_access_false_flips_the_notification_group) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_all_equivalent, Profile),
    findall(Status, nis2_lex_specialis_and_definitions_what_if(Profile, dora_gives_immediate_access_to_incident_notifications, false, Status), Statuses),
    Statuses == [nis2_groups(nis2_provisions_disapplied, nis2_provisions_apply)].
test(what_if_unsure_risk_is_referred_with_pairs_in_contract_order) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_all_equivalent, Profile),
    findall(Status, nis2_lex_specialis_and_definitions_what_if(Profile, dora_risk_management_measures_at_least_equivalent_in_effect, unsure, Status), Statuses),
    Statuses == [nis2_groups(needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure])]), nis2_provisions_disapplied)].
test(what_if_class_given_unblocks_both_referrals) :-
    nis2_lex_specialis_and_definitions_profile_for(class_missing, Profile),
    findall(Status, nis2_lex_specialis_and_definitions_what_if(Profile, entity_class, important_entity, Status), Statuses),
    Statuses = [nis2_groups(needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, _), _), needs_legal_review(open_textured(dora_gives_immediate_access_to_incident_notifications, _), _))].
test(what_if_a_wrong_value_gives_input_problems) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_all_equivalent, Profile),
    findall(Status, nis2_lex_specialis_and_definitions_what_if(Profile, entity_class, large, Status), Statuses),
    Statuses == [nis2_groups(input_problems([wrong_type(entity_class)]), input_problems([wrong_type(entity_class)]))].

test(what_if_access_false_is_not_disapplied, fail) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_all_equivalent, Profile),
    nis2_lex_specialis_and_definitions_what_if(Profile, dora_gives_immediate_access_to_incident_notifications, false, nis2_groups(_, nis2_provisions_disapplied)).

cp_test_names([profile_keys_are_the_contract_keys, input_problems_is_re_exported, status_answers_once, checklist_items_carry_cited_provenance, checklist_reports_a_referral_item, what_if_access_false_flips_the_notification_group, what_if_unsure_risk_is_referred_with_pairs_in_contract_order, what_if_class_given_unblocks_both_referrals, what_if_a_wrong_value_gives_input_problems]).
cp_test_fail_names([what_if_access_false_is_not_disapplied]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
