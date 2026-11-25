% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_nis2_lex_specialis_and_definitions, [nis2_risk_management_provisions_status/3, nis2_incident_notification_provisions_status/3, decide_nis2_lex_specialis_and_definitions/2, nis2_lex_specialis_and_definitions_status/2, nis2_lex_specialis_and_definitions_checklist/2, nis2_lex_specialis_and_definitions_decision_resolvable/1, nis2_lex_specialis_and_definitions_status_values/1, nis2_provisions_disapplied/0, nis2_provisions_apply/0, out_of_scope/0, essential_entity/0, important_entity/0]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_kernel, [nis2_lex_specialis_and_definitions_input_problems/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_fixtures, [nis2_lex_specialis_and_definitions_subject/1, nis2_lex_specialis_and_definitions_profile_for/2, nis2_lex_specialis_and_definitions_assess/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_queries, [nis2_lex_specialis_and_definitions_what_if/4, nis2_lex_specialis_and_definitions_profile_keys/1]).

expected_status(essential_all_equivalent, nis2_groups(nis2_provisions_disapplied, nis2_provisions_disapplied)).
expected_status(essential_risk_not_equivalent, nis2_groups(nis2_provisions_apply, nis2_provisions_disapplied)).
expected_status(important_only_point_a_met, nis2_groups(nis2_provisions_disapplied, nis2_provisions_apply)).
expected_status(important_requirements_not_equivalent, nis2_groups(nis2_provisions_disapplied, nis2_provisions_apply)).
expected_status(out_of_scope_entity, nis2_groups(out_of_scope, out_of_scope)).
expected_status(essential_judgements_missing, nis2_groups(indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect]), indeterminate([dora_gives_immediate_access_to_incident_notifications]))).
expected_status(class_missing, nis2_groups(indeterminate([entity_class]), indeterminate([entity_class]))).
expected_status(class_given_all_unsure, nis2_groups(needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure])]), needs_legal_review(open_textured(dora_gives_immediate_access_to_incident_notifications, cite(eu_dir_2022_2555_art_4_2_b)), [inputs_relied_on([entity_class - essential_entity, dora_gives_immediate_access_to_incident_notifications - unsure, dora_incident_notification_requirements_at_least_equivalent_in_effect - unsure])]))).
expected_status(unsure_risk_measures, nis2_groups(needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure])]), nis2_provisions_apply)).
expected_status(access_missing_requirements_unsure, nis2_groups(indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect]), indeterminate([dora_gives_immediate_access_to_incident_notifications]))).
expected_status(access_unsure_requirements_missing, nis2_groups(nis2_provisions_disapplied, indeterminate([dora_incident_notification_requirements_at_least_equivalent_in_effect]))).
expected_status(access_true_requirements_unsure, nis2_groups(nis2_provisions_disapplied, needs_legal_review(open_textured(dora_incident_notification_requirements_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_b)), [inputs_relied_on([entity_class - essential_entity, dora_gives_immediate_access_to_incident_notifications - true, dora_incident_notification_requirements_at_least_equivalent_in_effect - unsure])]))).
expected_status(malformed_duplicate_and_unknown, nis2_groups(input_problems([duplicate_key(entity_class), unknown_key(sector)]), input_problems([duplicate_key(entity_class), unknown_key(sector)]))).
expected_status(malformed_wrong_type, nis2_groups(input_problems([wrong_type(entity_class)]), input_problems([wrong_type(entity_class)]))).

risk_citations([cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_a), cite(eu_reg_2022_2554_art_1_2)]).

notification_citations([cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_b), cite(eu_reg_2022_2554_art_1_2)]).

resolves_to_expected(Subject) :-
    expected_status(Subject, Expected),
    findall(Status, nis2_lex_specialis_and_definitions_assess(Subject, nis2_lex_specialis_and_definitions_verdict(Status, _Citations)), Statuses),
    Statuses == [Expected].

checklist_is_cited(Subject) :-
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    nis2_lex_specialis_and_definitions_checklist(Profile, Items),
    Items = [_|_],
    maplist(item_is_cited, Items).

item_is_cited(item(_RequirementId, _Status, [cite(_)|_])).

is_resolvable(Subject) :-
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    nis2_lex_specialis_and_definitions_decision_resolvable(Profile).

risk_answers(Subject, Answers) :-
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    findall(Result - Citations, nis2_risk_management_provisions_status(Profile, Result, Citations), Answers).

notification_answers(Subject, Answers) :-
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    findall(Result - Citations, nis2_incident_notification_provisions_status(Profile, Result, Citations), Answers).

test(every_subject_has_an_expected_status) :-
    findall(Subject, nis2_lex_specialis_and_definitions_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_status_once) :-
    findall(Subject, nis2_lex_specialis_and_definitions_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(resolves_to_expected, Subjects).
test(every_subject_has_a_non_empty_cited_checklist) :-
    findall(Subject, nis2_lex_specialis_and_definitions_subject(Subject), Subjects),
    maplist(checklist_is_cited, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, nis2_lex_specialis_and_definitions_subject(Subject), Subjects),
    maplist(is_resolvable, Subjects).
test(all_equivalent_risk_is_disapplied_with_its_citations) :-
    risk_answers(essential_all_equivalent, Answers),
    risk_citations(Citations),
    Answers == [nis2_provisions_disapplied - Citations].
test(all_equivalent_notification_is_disapplied_with_its_citations) :-
    notification_answers(essential_all_equivalent, Answers),
    notification_citations(Citations),
    Answers == [nis2_provisions_disapplied - Citations].
test(risk_not_equivalent_applies) :-
    risk_answers(essential_risk_not_equivalent, Answers),
    risk_citations(Citations),
    Answers == [nis2_provisions_apply - Citations].
test(point_a_alone_does_not_disapply_notification) :-
    notification_answers(important_only_point_a_met, Answers),
    notification_citations(Citations),
    Answers == [nis2_provisions_apply - Citations].
test(requirements_not_equivalent_notification_applies) :-
    notification_answers(important_requirements_not_equivalent, Answers),
    notification_citations(Citations),
    Answers == [nis2_provisions_apply - Citations].
test(out_of_scope_is_answered_out_of_scope_with_citations) :-
    risk_answers(out_of_scope_entity, RiskAnswers),
    notification_answers(out_of_scope_entity, NotificationAnswers),
    risk_citations(RiskCitations),
    notification_citations(NotificationCitations),
    RiskAnswers == [out_of_scope - RiskCitations],
    NotificationAnswers == [out_of_scope - NotificationCitations].
test(essential_with_missing_judgements_is_indeterminate) :-
    risk_answers(essential_judgements_missing, Answers),
    Answers == [indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect]) - []].
test(class_missing_names_entity_class_with_no_citations) :-
    notification_answers(class_missing, Answers),
    Answers == [indeterminate([entity_class]) - []].
test(class_given_unsure_is_referred_not_indeterminate) :-
    risk_answers(class_given_all_unsure, Answers),
    Answers == [needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure])]) - []].
test(absent_access_named_before_unsure_requirements) :-
    notification_answers(access_missing_requirements_unsure, Answers),
    Answers == [indeterminate([dora_gives_immediate_access_to_incident_notifications]) - []].
test(absent_requirements_named_before_unsure_access) :-
    notification_answers(access_unsure_requirements_missing, Answers),
    Answers == [indeterminate([dora_incident_notification_requirements_at_least_equivalent_in_effect]) - []].
test(unsure_requirements_beside_true_access_is_referred) :-
    notification_answers(access_true_requirements_unsure, Answers),
    Answers == [needs_legal_review(open_textured(dora_incident_notification_requirements_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_b)), [inputs_relied_on([entity_class - essential_entity, dora_gives_immediate_access_to_incident_notifications - true, dora_incident_notification_requirements_at_least_equivalent_in_effect - unsure])]) - []].
test(malformed_profile_lists_its_problems_in_order) :-
    nis2_lex_specialis_and_definitions_profile_for(malformed_duplicate_and_unknown, Profile),
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(entity_class), unknown_key(sector)]].
test(malformed_profile_gets_input_problems_with_no_citations) :-
    risk_answers(malformed_wrong_type, Answers),
    Answers == [input_problems([wrong_type(entity_class)]) - []].
test(well_formed_control_has_no_problems) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_all_equivalent, Profile),
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(not_a_list_is_wrong_type_profile) :-
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems(not_a_list, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(facade_unions_both_citation_lists) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_all_equivalent, Profile),
    findall(Citations, decide_nis2_lex_specialis_and_definitions(Profile, nis2_lex_specialis_and_definitions_verdict(_, Citations)), Answers),
    sort([cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_a), cite(eu_dir_2022_2555_art_4_2_b), cite(eu_reg_2022_2554_art_1_2)], Expected),
    Answers == [Expected].
test(facade_status_compounds_carry_no_citations) :-
    nis2_lex_specialis_and_definitions_profile_for(class_missing, Profile),
    decide_nis2_lex_specialis_and_definitions(Profile, nis2_lex_specialis_and_definitions_verdict(_, Citations)),
    Citations == [].
test(status_projection_matches_the_verdict) :-
    nis2_lex_specialis_and_definitions_profile_for(important_only_point_a_met, Profile),
    findall(Status, nis2_lex_specialis_and_definitions_status(Profile, Status), Statuses),
    Statuses == [nis2_groups(nis2_provisions_disapplied, nis2_provisions_apply)].
test(status_values_are_the_final_atoms) :-
    nis2_lex_specialis_and_definitions_status_values(Values),
    Values == [nis2_provisions_disapplied, nis2_provisions_apply, out_of_scope].
test(what_if_turns_the_near_miss_into_the_positive_case) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_risk_not_equivalent, Profile),
    findall(Status, nis2_lex_specialis_and_definitions_what_if(Profile, dora_risk_management_measures_at_least_equivalent_in_effect, true, Status), Statuses),
    Statuses == [nis2_groups(nis2_provisions_disapplied, nis2_provisions_disapplied)].
test(profile_keys_are_the_four_contract_keys) :-
    nis2_lex_specialis_and_definitions_profile_keys(Keys),
    length(Keys, 4).
test(result_and_class_atoms_are_exported) :-
    nis2_provisions_disapplied,
    nis2_provisions_apply,
    out_of_scope,
    essential_entity,
    important_entity.
test(provenance_term_builds_for_a_risk_referral_clause) :-
    Term = provenance(risk_management_equivalence_unclear, [cite(eu_dir_2022_2555_art_4_2_a)]),
    Term = provenance(Clause, Citations),
    Clause == risk_management_equivalence_unclear,
    Citations == [cite(eu_dir_2022_2555_art_4_2_a)].
test(provenance_term_builds_for_a_notification_referral_clause) :-
    Term = provenance(incident_notification_equivalence_unclear, [cite(eu_dir_2022_2555_art_4_2_b)]),
    Term = provenance(Clause, Citations),
    Clause == incident_notification_equivalence_unclear,
    Citations == [cite(eu_dir_2022_2555_art_4_2_b)].
test(provenance_item_follows_inputs_relied_on_in_a_context) :-
    Context = [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure]), provenance(risk_management_equivalence_unclear, [cite(eu_dir_2022_2555_art_4_2_a)])],
    Context = [inputs_relied_on(_Pairs), provenance(Clause, Citations)],
    Clause == risk_management_equivalence_unclear,
    Citations == [cite(eu_dir_2022_2555_art_4_2_a)].

test(risk_not_equivalent_is_not_disapplied, fail) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_risk_not_equivalent, Profile),
    nis2_risk_management_provisions_status(Profile, nis2_provisions_disapplied, _).
test(point_a_alone_notification_is_not_disapplied, fail) :-
    nis2_lex_specialis_and_definitions_profile_for(important_only_point_a_met, Profile),
    nis2_incident_notification_provisions_status(Profile, nis2_provisions_disapplied, _).
test(essential_with_missing_judgements_is_not_out_of_scope, fail) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_judgements_missing, Profile),
    nis2_risk_management_provisions_status(Profile, out_of_scope, _).
test(class_given_unsure_is_not_indeterminate_on_class, fail) :-
    nis2_lex_specialis_and_definitions_profile_for(class_given_all_unsure, Profile),
    nis2_risk_management_provisions_status(Profile, indeterminate([entity_class]), _).
test(unsure_requirements_is_not_disapplied, fail) :-
    nis2_lex_specialis_and_definitions_profile_for(access_true_requirements_unsure, Profile),
    nis2_incident_notification_provisions_status(Profile, nis2_provisions_disapplied, _).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status_once, every_subject_has_a_non_empty_cited_checklist, every_subject_is_resolvable, all_equivalent_risk_is_disapplied_with_its_citations, all_equivalent_notification_is_disapplied_with_its_citations, risk_not_equivalent_applies, point_a_alone_does_not_disapply_notification, requirements_not_equivalent_notification_applies, out_of_scope_is_answered_out_of_scope_with_citations, essential_with_missing_judgements_is_indeterminate, class_missing_names_entity_class_with_no_citations, class_given_unsure_is_referred_not_indeterminate, absent_access_named_before_unsure_requirements, absent_requirements_named_before_unsure_access, unsure_requirements_beside_true_access_is_referred, malformed_profile_lists_its_problems_in_order, malformed_profile_gets_input_problems_with_no_citations, well_formed_control_has_no_problems, not_a_list_is_wrong_type_profile, facade_unions_both_citation_lists, facade_status_compounds_carry_no_citations, status_projection_matches_the_verdict, status_values_are_the_final_atoms, what_if_turns_the_near_miss_into_the_positive_case, profile_keys_are_the_four_contract_keys, result_and_class_atoms_are_exported, provenance_term_builds_for_a_risk_referral_clause, provenance_term_builds_for_a_notification_referral_clause, provenance_item_follows_inputs_relied_on_in_a_context]).
cp_test_fail_names([risk_not_equivalent_is_not_disapplied, point_a_alone_notification_is_not_disapplied, essential_with_missing_judgements_is_not_out_of_scope, class_given_unsure_is_not_indeterminate_on_class, unsure_requirements_is_not_disapplied]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
