% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_kernel, [dora_rts_incident_policy_and_detection_input_problems/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, dora_rts_incident_policy_and_detection_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, dora_rts_incident_policy_and_detection_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(ict_related_incident_policy_developed_documented_and_implemented, unsure), attribute(criticality_of_affected_services_considered, true)], Problems), Answers),
    Answers == [[]].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, dora_rts_incident_policy_and_detection_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_stray_element_is_not_an_attribute_list) :-
    findall(Problems, dora_rts_incident_policy_and_detection_input_problems([attribute(financial_entity_is_article_16_1_entity, false), stray], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(unsure_is_wrong_type_for_the_gate) :-
    dora_rts_incident_policy_and_detection_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity)].
test(unsure_is_in_type_for_a_judgement) :-
    dora_rts_incident_policy_and_detection_input_problems([attribute(criteria_triggering_incident_detection_and_response_considered, unsure)], Problems),
    Problems == [].
test(a_repeated_contract_key_is_a_duplicate_only) :-
    dora_rts_incident_policy_and_detection_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, maybe)], Problems),
    Problems == [duplicate_key(financial_entity_is_article_16_1_entity)].
test(contract_problems_come_before_unknown_keys) :-
    dora_rts_incident_policy_and_detection_input_problems([attribute(some_other_key, 1), attribute(financial_entity_is_article_16_1_entity, unsure)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity), unknown_key(some_other_key)].
test(an_unbound_key_is_named_as_given) :-
    dora_rts_incident_policy_and_detection_input_problems([attribute(Key, true)], Problems),
    Problems = [unknown_key(Named)],
    Named == Key.
test(the_required_term_builds_and_destructures) :-
    Result = required([ict_related_incident_policy, documentation_of_incident_management_process]),
    Result = required(Duties),
    Duties == [ict_related_incident_policy, documentation_of_incident_management_process].
test(the_outstanding_term_builds_and_destructures) :-
    Result = outstanding([consideration_of_criticality_of_affected_services]),
    Result = outstanding(Duties),
    Duties == [consideration_of_criticality_of_affected_services].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate([MissingKey]),
    MissingKey == financial_entity_is_article_16_1_entity.
test(the_referral_term_builds_and_destructures) :-
    Result = needs_legal_review(open_textured(criticality_of_affected_services_considered, cite(eu_reg_2024_1774_art_23_6)), [inputs_relied_on([criticality_of_affected_services_considered - unsure])]),
    Result = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == criticality_of_affected_services_considered,
    Citation == cite(eu_reg_2024_1774_art_23_6),
    Pairs == [criticality_of_affected_services_considered - unsure].
test(the_input_problems_term_builds_and_destructures) :-
    Result = input_problems([wrong_type(profile)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(profile)].
test(the_complete_query_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, simplified_framework_entity),
    dif(incomplete, simplified_framework_entity).
test(the_outstanding_query_atom_is_distinct) :-
    dif(none_outstanding, complete),
    dif(none_outstanding, simplified_framework_entity).
test(the_judgement_value_is_distinct_from_the_booleans) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_article_22_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_22, _Record).
test(the_article_23_6_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_23_6, _Record).
test(the_gate_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(the_citation_record_has_label_ref_and_verbatim) :-
    citation(eu_reg_2024_1774_art_23_1, Record),
    Record = [label - _Label, ref - _Reference, verbatim - _Verbatim].
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2024_1774_art_23_2_b).

test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_unbound_profile_is_not_an_attribute_list, a_list_with_a_stray_element_is_not_an_attribute_list, unsure_is_wrong_type_for_the_gate, unsure_is_in_type_for_a_judgement, a_repeated_contract_key_is_a_duplicate_only, contract_problems_come_before_unknown_keys, an_unbound_key_is_named_as_given, the_required_term_builds_and_destructures, the_outstanding_term_builds_and_destructures, the_indeterminate_term_names_one_key, the_referral_term_builds_and_destructures, the_input_problems_term_builds_and_destructures, the_complete_query_atoms_are_distinct, the_outstanding_query_atom_is_distinct, the_judgement_value_is_distinct_from_the_booleans, the_article_22_citation_is_recorded, the_article_23_6_citation_is_recorded, the_gate_citation_is_recorded, the_citation_record_has_label_ref_and_verbatim, the_marker_holds_for_a_recorded_key]).
cp_test_fail_names([the_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
