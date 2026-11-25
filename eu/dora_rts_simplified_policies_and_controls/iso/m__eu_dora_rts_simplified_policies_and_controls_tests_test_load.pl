% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_policies_and_controls_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_kernel, [dora_rts_simplified_policies_and_controls_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, dora_rts_simplified_policies_and_controls_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, dora_rts_simplified_policies_and_controls_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(simplified_internal_governance_and_control_framework_in_place, unsure), attribute(teleworking_and_private_device_measures_implemented, false)], Problems), Answers),
    Answers == [[]].
test(an_unsure_gate_is_wrong_type) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity)].
test(an_unsure_judgement_is_in_its_type) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(user_accountability_ensured, unsure)], []).
test(a_number_judgement_is_wrong_type) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(user_accountability_ensured, 1)], Problems),
    Problems == [wrong_type(user_accountability_ensured)].
test(a_repeated_contract_key_is_a_duplicate_only) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, unsure)], Problems),
    Problems == [duplicate_key(financial_entity_is_article_16_1_entity)].
test(a_key_of_another_order_is_unknown) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(financial_entity_is_microenterprise, true), attribute(financial_entity_is_microenterprise, true)], Problems),
    Problems == [unknown_key(financial_entity_is_microenterprise)].
test(contract_problems_come_before_unknown_keys) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(dora_entity_type, credit_institution), attribute(user_accountability_ensured, maybe)], Problems),
    Problems == [wrong_type(user_accountability_ensured), unknown_key(dora_entity_type)].
test(an_atom_is_not_an_attribute_list) :-
    dora_rts_simplified_policies_and_controls_input_problems(profile_atom, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_rts_simplified_policies_and_controls_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_list_with_a_stray_item_is_not_an_attribute_list) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(financial_entity_is_article_16_1_entity, true), stray], Problems),
    Problems == [wrong_type(profile)].
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_rts_simplified_policies_and_controls_verdict(complete, [cite(eu_reg_2022_2554_art_16_1)]),
    Verdict = dora_rts_simplified_policies_and_controls_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(user_accountability_ensured, cite(eu_reg_2024_1774_art_33)), [inputs_relied_on([financial_entity_is_article_16_1_entity - true, user_accountability_ensured - unsure])]),
    Result = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == user_accountability_ensured,
    Citation == cite(eu_reg_2024_1774_art_33),
    length(Pairs, 2).
test(the_missing_key_term_holds_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate([Key]),
    Key == financial_entity_is_article_16_1_entity.
test(the_result_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, none_outstanding),
    dif(complete, not_article_16_1_entity),
    dif(incomplete, none_outstanding),
    dif(incomplete, not_article_16_1_entity),
    dif(none_outstanding, not_article_16_1_entity).
test(the_gate_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(an_access_control_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_33, _Record).
test(the_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2024_1774_art_28_1).
test(twenty_citations_are_recorded) :-
    findall(Key, citation(Key, _), Keys),
    sort(Keys, DistinctKeys),
    length(DistinctKeys, 20).

test(a_true_gate_is_not_a_problem, fail) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(financial_entity_is_article_16_1_entity, true)], [_|_]).
test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_unsure_gate_is_wrong_type, an_unsure_judgement_is_in_its_type, a_number_judgement_is_wrong_type, a_repeated_contract_key_is_a_duplicate_only, a_key_of_another_order_is_unknown, contract_problems_come_before_unknown_keys, an_atom_is_not_an_attribute_list, an_unbound_profile_is_not_an_attribute_list, a_list_with_a_stray_item_is_not_an_attribute_list, the_verdict_term_carries_status_and_citations, the_referral_term_destructures, the_missing_key_term_holds_one_key, the_result_atoms_are_distinct, the_gate_citation_is_recorded, an_access_control_citation_is_recorded, the_marker_succeeds_for_a_recorded_key, twenty_citations_are_recorded]).
cp_test_fail_names([a_true_gate_is_not_a_problem, the_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
