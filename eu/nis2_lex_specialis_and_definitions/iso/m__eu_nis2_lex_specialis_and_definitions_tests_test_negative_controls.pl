% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_nis2_lex_specialis_and_definitions, [nis2_risk_management_provisions_status/3, nis2_incident_notification_provisions_status/3, nis2_lex_specialis_and_definitions_status_values/1]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_fixtures, [nis2_lex_specialis_and_definitions_profile_for/2]).

risk_answer(Subject, Result) :-
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    nis2_risk_management_provisions_status(Profile, Result, _).

notification_answer(Subject, Result) :-
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    nis2_incident_notification_provisions_status(Profile, Result, _).

test(the_status_table_has_a_near_miss_atom) :-
    nis2_lex_specialis_and_definitions_status_values(StatusValues),
    StatusValues = [_, _|_].
test(a3_positive_risk_disapplied) :-
    risk_answer(essential_all_equivalent, nis2_provisions_disapplied).
test(a3_near_miss_applies) :-
    risk_answer(essential_risk_not_equivalent, nis2_provisions_apply).
test(b6_positive_notification_disapplied) :-
    notification_answer(essential_all_equivalent, nis2_provisions_disapplied).
test(b6_near_miss_applies) :-
    notification_answer(important_requirements_not_equivalent, nis2_provisions_apply).
test(b3_positive_access_false_applies) :-
    notification_answer(important_only_point_a_met, nis2_provisions_apply).
test(b3_access_false_beside_absent_equivalence_applies) :-
    nis2_incident_notification_provisions_status([attribute(entity_class, important_entity), attribute(dora_gives_immediate_access_to_incident_notifications, false)], nis2_provisions_apply, _).
test(a2_positive_out_of_scope) :-
    risk_answer(out_of_scope_entity, out_of_scope).
test(b2_positive_out_of_scope) :-
    notification_answer(out_of_scope_entity, out_of_scope).
test(a4_positive_risk_judgement_named) :-
    risk_answer(essential_judgements_missing, indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect])).
test(a4_near_miss_given_true_is_disapplied) :-
    nis2_risk_management_provisions_status([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, true)], nis2_provisions_disapplied, _).
test(a1_positive_class_named) :-
    risk_answer(class_missing, indeterminate([entity_class])).
test(b1_positive_class_named) :-
    notification_answer(class_missing, indeterminate([entity_class])).
test(a5_positive_risk_referred) :-
    risk_answer(class_given_all_unsure, needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure])])).
test(b4a_positive_access_named) :-
    notification_answer(access_missing_requirements_unsure, indeterminate([dora_gives_immediate_access_to_incident_notifications])).
test(b4a_near_miss_access_true_is_referred) :-
    nis2_incident_notification_provisions_status([attribute(entity_class, important_entity), attribute(dora_gives_immediate_access_to_incident_notifications, true), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, unsure)], needs_legal_review(open_textured(dora_incident_notification_requirements_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_b)), _), _).
test(b4b_positive_equivalence_named) :-
    notification_answer(access_unsure_requirements_missing, indeterminate([dora_incident_notification_requirements_at_least_equivalent_in_effect])).
test(b4b_near_miss_equivalence_false_applies) :-
    nis2_incident_notification_provisions_status([attribute(entity_class, important_entity), attribute(dora_gives_immediate_access_to_incident_notifications, unsure), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, false)], nis2_provisions_apply, _).
test(b5a_positive_access_referred) :-
    notification_answer(class_given_all_unsure, needs_legal_review(open_textured(dora_gives_immediate_access_to_incident_notifications, cite(eu_dir_2022_2555_art_4_2_b)), _)).
test(b5b_positive_equivalence_referred) :-
    notification_answer(access_true_requirements_unsure, needs_legal_review(open_textured(dora_incident_notification_requirements_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_b)), _)).
test(a0_positive_input_problems) :-
    risk_answer(malformed_duplicate_and_unknown, input_problems([duplicate_key(entity_class), unknown_key(sector)])).
test(b0_positive_input_problems) :-
    notification_answer(malformed_wrong_type, input_problems([wrong_type(entity_class)])).
test(b0_out_of_scope_beside_a_judgement_is_out_of_scope) :-
    nis2_incident_notification_provisions_status([attribute(entity_class, out_of_scope), attribute(dora_gives_immediate_access_to_incident_notifications, unsure)], out_of_scope, _).

test(a3_near_miss_is_not_disapplied, fail) :-
    risk_answer(essential_risk_not_equivalent, nis2_provisions_disapplied).
test(b6_near_miss_is_not_disapplied, fail) :-
    notification_answer(important_requirements_not_equivalent, nis2_provisions_disapplied).
test(b3_near_miss_does_not_apply, fail) :-
    notification_answer(essential_all_equivalent, nis2_provisions_apply).
test(a2_near_miss_is_not_out_of_scope, fail) :-
    risk_answer(essential_judgements_missing, out_of_scope).
test(b2_near_miss_is_not_out_of_scope, fail) :-
    notification_answer(essential_judgements_missing, out_of_scope).
test(a4_near_miss_given_true_is_not_indeterminate, fail) :-
    nis2_risk_management_provisions_status([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, true)], indeterminate(_), _).
test(a1_near_miss_is_not_class_indeterminate, fail) :-
    risk_answer(class_given_all_unsure, indeterminate([entity_class])).
test(a5_near_miss_is_not_referred, fail) :-
    risk_answer(essential_all_equivalent, needs_legal_review(_, _)).
test(b4a_near_miss_access_true_is_not_indeterminate, fail) :-
    nis2_incident_notification_provisions_status([attribute(entity_class, important_entity), attribute(dora_gives_immediate_access_to_incident_notifications, true), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, unsure)], indeterminate(_), _).
test(b4b_near_miss_equivalence_false_is_not_indeterminate, fail) :-
    nis2_incident_notification_provisions_status([attribute(entity_class, important_entity), attribute(dora_gives_immediate_access_to_incident_notifications, unsure), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, false)], indeterminate(_), _).
test(b5a_near_miss_access_true_does_not_refer_access, fail) :-
    notification_answer(access_true_requirements_unsure, needs_legal_review(open_textured(dora_gives_immediate_access_to_incident_notifications, _), _)).
test(b5b_near_miss_is_not_referred, fail) :-
    notification_answer(essential_all_equivalent, needs_legal_review(_, _)).
test(a0_near_miss_well_formed_has_no_input_problems, fail) :-
    risk_answer(essential_all_equivalent, input_problems(_)).
test(b0_out_of_scope_beside_a_judgement_is_not_a_problem, fail) :-
    nis2_incident_notification_provisions_status([attribute(entity_class, out_of_scope), attribute(dora_gives_immediate_access_to_incident_notifications, unsure)], input_problems(_), _).

cp_test_names([the_status_table_has_a_near_miss_atom, a3_positive_risk_disapplied, a3_near_miss_applies, b6_positive_notification_disapplied, b6_near_miss_applies, b3_positive_access_false_applies, b3_access_false_beside_absent_equivalence_applies, a2_positive_out_of_scope, b2_positive_out_of_scope, a4_positive_risk_judgement_named, a4_near_miss_given_true_is_disapplied, a1_positive_class_named, b1_positive_class_named, a5_positive_risk_referred, b4a_positive_access_named, b4a_near_miss_access_true_is_referred, b4b_positive_equivalence_named, b4b_near_miss_equivalence_false_applies, b5a_positive_access_referred, b5b_positive_equivalence_referred, a0_positive_input_problems, b0_positive_input_problems, b0_out_of_scope_beside_a_judgement_is_out_of_scope]).
cp_test_fail_names([a3_near_miss_is_not_disapplied, b6_near_miss_is_not_disapplied, b3_near_miss_does_not_apply, a2_near_miss_is_not_out_of_scope, b2_near_miss_is_not_out_of_scope, a4_near_miss_given_true_is_not_indeterminate, a1_near_miss_is_not_class_indeterminate, a5_near_miss_is_not_referred, b4a_near_miss_access_true_is_not_indeterminate, b4b_near_miss_equivalence_false_is_not_indeterminate, b5a_near_miss_access_true_does_not_refer_access, b5b_near_miss_is_not_referred, a0_near_miss_well_formed_has_no_input_problems, b0_out_of_scope_beside_a_judgement_is_not_a_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
