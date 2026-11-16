% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [decide_nis2_governance_risk_measures/2, nis2_governance_risk_measures_status/2, nis2_governance_risk_measures_checklist/2, nis2_governance_risk_measures_decision_resolvable/1, nis2_governance_risk_measures_status_values/1, management_body_duties/2, risk_management_measures/2, proportionality_factors/2, supply_chain_considerations/2, corrective_measures_duty/3]).
:- use_module(m__eu_nis2_governance_risk_measures_fixtures, [nis2_governance_risk_measures_subject/1, nis2_governance_risk_measures_profile_for/2, nis2_governance_risk_measures_assess/2]).
:- use_module(m__eu_nis2_governance_risk_measures_queries, [nis2_governance_risk_measures_what_if/4]).
:- use_module(m__eu_nis2_governance_risk_measures_kernel, [nis2_governance_risk_measures_input_problems/2]).

test(essential_entity_duties_apply) :-
    nis2_governance_risk_measures_assess(essential_all_true, nis2_governance_risk_measures_verdict(duties_apply, [_|_])).
test(important_entity_duties_apply) :-
    nis2_governance_risk_measures_assess(important_all_false, nis2_governance_risk_measures_verdict(duties_apply, [_|_])).
test(out_of_scope_gets_no_duties_apply) :-
    nis2_governance_risk_measures_assess(out_of_scope_entity, nis2_governance_risk_measures_verdict(no_duties_apply, [])).
test(absent_entity_class_is_indeterminate) :-
    nis2_governance_risk_measures_assess(entity_class_absent, nis2_governance_risk_measures_verdict(indeterminate([entity_class]), [])).
test(unsure_point_j_does_not_change_the_duty_rollup) :-
    nis2_governance_risk_measures_assess(important_point_j_unsure, nis2_governance_risk_measures_verdict(duties_apply, _)).
test(unknown_key_gives_input_problems) :-
    nis2_governance_risk_measures_assess(essential_unknown_key, nis2_governance_risk_measures_verdict(input_problems([unknown_key(surprise)]), [])).
test(wrong_type_gives_input_problems) :-
    nis2_governance_risk_measures_assess(essential_wrong_type, nis2_governance_risk_measures_verdict(input_problems([wrong_type(relevant_european_or_international_standards_apply)]), [])).
test(status_atom_is_in_the_status_values) :-
    nis2_governance_risk_measures_subject(essential_all_true),
    nis2_governance_risk_measures_assess(essential_all_true, nis2_governance_risk_measures_verdict(Status, _Citations)),
    nis2_governance_risk_measures_status_values(StatusValues),
    member(Status, StatusValues).
test(status_predicate_agrees_with_the_verdict) :-
    nis2_governance_risk_measures_profile_for(out_of_scope_entity, Profile),
    nis2_governance_risk_measures_status(Profile, no_duties_apply).
test(every_subject_resolves) :-
    nis2_governance_risk_measures_subject(Subject),
    nis2_governance_risk_measures_profile_for(Subject, Profile),
    nis2_governance_risk_measures_decision_resolvable(Profile).
test(each_assessment_yields_exactly_one_verdict) :-
    findall(Result, nis2_governance_risk_measures_assess(essential_all_true, Result), Results),
    length(Results, 1).
test(checklist_is_non_empty_and_cited_for_an_essential_entity) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_checklist(Profile, [item(_, met, cite(_))|_]).
test(checklist_has_four_rows_for_an_important_entity) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    nis2_governance_risk_measures_checklist(Profile, Items),
    length(Items, 4).
test(checklist_of_an_out_of_scope_entity_is_empty) :-
    nis2_governance_risk_measures_profile_for(out_of_scope_entity, Profile),
    nis2_governance_risk_measures_checklist(Profile, []).
test(checklist_of_an_absent_class_names_the_key) :-
    nis2_governance_risk_measures_profile_for(entity_class_absent, Profile),
    nis2_governance_risk_measures_checklist(Profile, [item(overall, indeterminate([entity_class]), cite(eu_dir_2022_2555_art_20_1))]).
test(management_duties_of_an_essential_entity) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    management_body_duties(Profile, [duty(approve_the_cybersecurity_risk_management_measures, cite(eu_dir_2022_2555_art_20_1)), duty(oversee_the_implementation_of_the_measures, cite(eu_dir_2022_2555_art_20_1)), duty(can_be_held_liable_for_infringements_of_article_21, cite(eu_dir_2022_2555_art_20_1)), duty(members_of_the_management_bodies_follow_training, cite(eu_dir_2022_2555_art_20_2))]).
test(management_duties_out_of_scope_is_empty) :-
    nis2_governance_risk_measures_profile_for(out_of_scope_entity, Profile),
    management_body_duties(Profile, []).
test(management_duties_once_only) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    findall(Duties, management_body_duties(Profile, Duties), All),
    length(All, 1).
test(point_j_true_lists_twelve_measures) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    risk_management_measures(Profile, Measures),
    length(Measures, 12).
test(point_j_true_ends_with_point_j) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    risk_management_measures(Profile, Measures),
    last(Measures, measure(multi_factor_or_continuous_authentication_and_secured_communications, cite(eu_dir_2022_2555_art_21_2_j))).
test(point_j_false_lists_eleven_measures) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    risk_management_measures(Profile, Measures),
    length(Measures, 11).
test(point_j_unsure_is_referred) :-
    nis2_governance_risk_measures_profile_for(important_point_j_unsure, Profile),
    risk_management_measures(Profile, needs_legal_review(open_textured(multi_factor_authentication_and_secured_communications_appropriate, cite(eu_dir_2022_2555_art_21_2_j)), [inputs_relied_on([multi_factor_authentication_and_secured_communications_appropriate - unsure])])).
test(measures_absent_class_is_indeterminate) :-
    nis2_governance_risk_measures_profile_for(entity_class_absent, Profile),
    risk_management_measures(Profile, indeterminate([entity_class])).
test(measures_missing_judgement_key_is_indeterminate) :-
    risk_management_measures([attribute(entity_class, essential_entity)], indeterminate([multi_factor_authentication_and_secured_communications_appropriate])).
test(standards_true_lists_seven_factors) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    proportionality_factors(Profile, Factors),
    length(Factors, 7).
test(standards_false_lists_six_factors) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    proportionality_factors(Profile, Factors),
    length(Factors, 6).
test(factors_missing_key_is_indeterminate) :-
    proportionality_factors([attribute(entity_class, important_entity)], indeterminate([relevant_european_or_international_standards_apply])).
test(coordinated_assessment_true_lists_three_considerations) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    supply_chain_considerations(Profile, Considerations),
    length(Considerations, 3).
test(coordinated_assessment_false_lists_two_considerations) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    supply_chain_considerations(Profile, Considerations),
    length(Considerations, 2).
test(considerations_missing_key_is_indeterminate) :-
    supply_chain_considerations([attribute(entity_class, essential_entity)], indeterminate([coordinated_supply_chain_risk_assessment_carried_out])).
test(non_compliance_found_must_take_corrective_measures) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    corrective_measures_duty(Profile, must_take_corrective_measures_without_undue_delay, [cite(eu_dir_2022_2555_art_21_4)]).
test(non_compliance_not_found_gives_no_duty) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    corrective_measures_duty(Profile, no_corrective_measures_duty, [cite(eu_dir_2022_2555_art_21_4)]).
test(out_of_scope_has_no_corrective_duty) :-
    nis2_governance_risk_measures_profile_for(out_of_scope_entity, Profile),
    corrective_measures_duty(Profile, no_corrective_measures_duty, [cite(eu_dir_2022_2555_art_21_4)]).
test(corrective_missing_key_is_indeterminate) :-
    corrective_measures_duty([attribute(entity_class, essential_entity)], indeterminate([non_compliance_with_the_art_21_2_measures_found]), []).
test(corrective_input_problems_have_empty_citations) :-
    nis2_governance_risk_measures_profile_for(essential_unknown_key, Profile),
    corrective_measures_duty(Profile, input_problems([unknown_key(surprise)]), []).
test(well_formed_profile_has_no_problems) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_input_problems(Profile, []).
test(unknown_key_is_named) :-
    nis2_governance_risk_measures_profile_for(essential_unknown_key, Profile),
    nis2_governance_risk_measures_input_problems(Profile, [unknown_key(surprise)]).
test(wrong_type_is_named) :-
    nis2_governance_risk_measures_profile_for(essential_wrong_type, Profile),
    nis2_governance_risk_measures_input_problems(Profile, [wrong_type(relevant_european_or_international_standards_apply)]).
test(duplicate_key_is_named) :-
    nis2_governance_risk_measures_input_problems([attribute(entity_class, essential_entity), attribute(entity_class, out_of_scope)], [duplicate_key(entity_class)]).
test(a_non_attribute_list_is_a_wrong_profile) :-
    nis2_governance_risk_measures_input_problems([not_an_attribute], [wrong_type(profile)]).
test(input_problems_come_before_every_query) :-
    nis2_governance_risk_measures_profile_for(essential_unknown_key, Profile),
    management_body_duties(Profile, input_problems([unknown_key(surprise)])),
    risk_management_measures(Profile, input_problems([unknown_key(surprise)])),
    proportionality_factors(Profile, input_problems([unknown_key(surprise)])),
    supply_chain_considerations(Profile, input_problems([unknown_key(surprise)])).
test(what_if_out_of_scope_flips_the_verdict) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_what_if(Profile, entity_class, out_of_scope, no_duties_apply).
test(what_if_important_keeps_duties_apply) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_what_if(Profile, entity_class, important_entity, duties_apply).
test(what_if_restores_a_missing_class) :-
    nis2_governance_risk_measures_profile_for(entity_class_absent, Profile),
    nis2_governance_risk_measures_what_if(Profile, entity_class, essential_entity, duties_apply).
test(what_if_yields_one_answer) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    findall(Status, nis2_governance_risk_measures_what_if(Profile, entity_class, out_of_scope, Status), Statuses),
    Statuses == [no_duties_apply].

test(out_of_scope_is_not_duties_apply, fail) :-
    nis2_governance_risk_measures_assess(out_of_scope_entity, nis2_governance_risk_measures_verdict(duties_apply, _)).
test(essential_is_not_no_duties_apply, fail) :-
    nis2_governance_risk_measures_assess(essential_all_true, nis2_governance_risk_measures_verdict(no_duties_apply, _)).
test(point_j_false_omits_point_j, fail) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    risk_management_measures(Profile, Measures),
    member(measure(multi_factor_or_continuous_authentication_and_secured_communications, _), Measures).
test(standards_false_omits_the_standards_factor, fail) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    proportionality_factors(Profile, Factors),
    member(factor(relevant_european_and_international_standards, _), Factors).
test(coordinated_assessment_false_omits_the_third, fail) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    supply_chain_considerations(Profile, Considerations),
    member(consideration(results_of_the_coordinated_security_risk_assessments_of_critical_supply_chains, _), Considerations).
test(non_compliance_not_found_is_not_a_must, fail) :-
    nis2_governance_risk_measures_profile_for(important_all_false, Profile),
    corrective_measures_duty(Profile, must_take_corrective_measures_without_undue_delay, _).
test(what_if_out_of_scope_is_not_duties_apply, fail) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    nis2_governance_risk_measures_what_if(Profile, entity_class, out_of_scope, duties_apply).

cp_test_names([essential_entity_duties_apply, important_entity_duties_apply, out_of_scope_gets_no_duties_apply, absent_entity_class_is_indeterminate, unsure_point_j_does_not_change_the_duty_rollup, unknown_key_gives_input_problems, wrong_type_gives_input_problems, status_atom_is_in_the_status_values, status_predicate_agrees_with_the_verdict, every_subject_resolves, each_assessment_yields_exactly_one_verdict, checklist_is_non_empty_and_cited_for_an_essential_entity, checklist_has_four_rows_for_an_important_entity, checklist_of_an_out_of_scope_entity_is_empty, checklist_of_an_absent_class_names_the_key, management_duties_of_an_essential_entity, management_duties_out_of_scope_is_empty, management_duties_once_only, point_j_true_lists_twelve_measures, point_j_true_ends_with_point_j, point_j_false_lists_eleven_measures, point_j_unsure_is_referred, measures_absent_class_is_indeterminate, measures_missing_judgement_key_is_indeterminate, standards_true_lists_seven_factors, standards_false_lists_six_factors, factors_missing_key_is_indeterminate, coordinated_assessment_true_lists_three_considerations, coordinated_assessment_false_lists_two_considerations, considerations_missing_key_is_indeterminate, non_compliance_found_must_take_corrective_measures, non_compliance_not_found_gives_no_duty, out_of_scope_has_no_corrective_duty, corrective_missing_key_is_indeterminate, corrective_input_problems_have_empty_citations, well_formed_profile_has_no_problems, unknown_key_is_named, wrong_type_is_named, duplicate_key_is_named, a_non_attribute_list_is_a_wrong_profile, input_problems_come_before_every_query, what_if_out_of_scope_flips_the_verdict, what_if_important_keeps_duties_apply, what_if_restores_a_missing_class, what_if_yields_one_answer]).
cp_test_fail_names([out_of_scope_is_not_duties_apply, essential_is_not_no_duties_apply, point_j_false_omits_point_j, standards_false_omits_the_standards_factor, coordinated_assessment_false_omits_the_third, non_compliance_not_found_is_not_a_must, what_if_out_of_scope_is_not_duties_apply]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
