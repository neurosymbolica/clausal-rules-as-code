% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_scope_and_entity_types_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_scope_and_entity_types_kernel, [dora_scope_and_entity_types_input_problems/2]).
:- use_module(m__eu_dora_scope_and_entity_types_citations, [citation/2, implements/1]).

test(the_in_scope_result_carries_its_type) :-
    Result = in_scope(credit_institution),
    Result = in_scope(Type),
    Type == credit_institution.
test(the_indeterminate_result_names_one_key) :-
    Result = indeterminate([dora_entity_type]),
    Result = indeterminate(MissingKeys),
    MissingKeys == [dora_entity_type],
    length(MissingKeys, 1).
test(the_input_problems_result_carries_its_list) :-
    Result = input_problems([wrong_type(profile)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(profile)].
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_scope_and_entity_types_verdict(in_scope(credit_institution), [cite(eu_reg_2022_2554_art_2_1_a)]),
    Verdict = dora_scope_and_entity_types_verdict(Status, Citations),
    Status == in_scope(credit_institution),
    Citations == [cite(eu_reg_2022_2554_art_2_1_a)].
test(the_scope_results_are_distinct) :-
    dif(in_scope(credit_institution), out_of_scope),
    dif(in_scope(credit_institution), in_scope(investment_firm)).
test(the_category_results_are_distinct) :-
    dif(financial_entity, ict_third_party_service_provider),
    dif(financial_entity, out_of_scope),
    dif(ict_third_party_service_provider, out_of_scope).
test(the_problem_terms_are_distinct) :-
    dif(duplicate_key(dora_entity_type), wrong_type(dora_entity_type)),
    dif(wrong_type(dora_entity_type), unknown_key(dora_entity_type)).
test(the_credit_institution_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_2_1_a, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_financial_entities_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_2_2, _).
test(the_member_state_option_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_2_4, _).
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2022_2554_art_3_60).
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, dora_scope_and_entity_types_input_problems([attribute(dora_entity_type, credit_institution), attribute(post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, false)], Problems), Answers),
    Answers == [[]].
test(the_empty_profile_has_no_problem) :-
    findall(Problems, dora_scope_and_entity_types_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_float_member_count_is_wrong_type) :-
    findall(Problems, dora_scope_and_entity_types_input_problems([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 15.0)], Problems), Answers),
    Answers == [[wrong_type(iorp_pension_scheme_members_total)]].
test(an_integer_member_count_is_well_formed) :-
    dora_scope_and_entity_types_input_problems([attribute(iorp_pension_scheme_members_total, 15)], []).
test(a_negative_member_count_is_wrong_type) :-
    dora_scope_and_entity_types_input_problems([attribute(iorp_pension_scheme_members_total, -1)], [wrong_type(iorp_pension_scheme_members_total)]).
test(an_unsure_crisp_value_is_wrong_type) :-
    dora_scope_and_entity_types_input_problems([attribute(financial_entity_is_microenterprise, unsure)], [wrong_type(financial_entity_is_microenterprise)]).
test(a_repeated_key_is_a_duplicate_only) :-
    findall(Problems, dora_scope_and_entity_types_input_problems([attribute(dora_entity_type, credit_institution), attribute(dora_entity_type, bogus)], Problems), Answers),
    Answers == [[duplicate_key(dora_entity_type)]].
test(contract_problems_come_before_unknown_keys) :-
    findall(Problems, dora_scope_and_entity_types_input_problems([attribute(colour, blue), attribute(dora_entity_type, bogus), attribute(colour, red)], Problems), Answers),
    Answers == [[wrong_type(dora_entity_type), unknown_key(colour)]].
test(an_unbound_key_is_reported_as_given) :-
    findall(Key - Problems, dora_scope_and_entity_types_input_problems([attribute(Key, true)], Problems), Answers),
    Answers = [FoundKey - [unknown_key(ReportedKey)]],
    FoundKey == ReportedKey.
test(an_unbound_value_is_wrong_type) :-
    dora_scope_and_entity_types_input_problems([attribute(exempted_from_dora_scope_by_member_state, _)], [wrong_type(exempted_from_dora_scope_by_member_state)]).
test(an_atom_profile_is_not_an_attribute_list) :-
    findall(Problems, dora_scope_and_entity_types_input_problems(profile_atom, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_scope_and_entity_types_input_problems(_, [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    dora_scope_and_entity_types_input_problems([attribute(dora_entity_type, credit_institution)|_], [wrong_type(profile)]).
test(a_stray_element_makes_the_profile_wrong_alone) :-
    findall(Problems, dora_scope_and_entity_types_input_problems([attribute(colour, blue), stray], Problems), Answers),
    Answers == [[wrong_type(profile)]].

test(the_out_of_scope_atom_is_not_an_in_scope_result, fail) :-
    out_of_scope = in_scope(_).
test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).
test(a_well_formed_profile_is_not_refused, fail) :-
    dora_scope_and_entity_types_input_problems([attribute(dora_entity_type, credit_institution)], [_|_]).

cp_test_names([the_in_scope_result_carries_its_type, the_indeterminate_result_names_one_key, the_input_problems_result_carries_its_list, the_verdict_term_carries_status_and_citations, the_scope_results_are_distinct, the_category_results_are_distinct, the_problem_terms_are_distinct, the_credit_institution_citation_is_recorded, the_financial_entities_citation_is_recorded, the_member_state_option_citation_is_recorded, the_marker_holds_for_a_recorded_key, a_well_formed_profile_has_no_problem, the_empty_profile_has_no_problem, a_float_member_count_is_wrong_type, an_integer_member_count_is_well_formed, a_negative_member_count_is_wrong_type, an_unsure_crisp_value_is_wrong_type, a_repeated_key_is_a_duplicate_only, contract_problems_come_before_unknown_keys, an_unbound_key_is_reported_as_given, an_unbound_value_is_wrong_type, an_atom_profile_is_not_an_attribute_list, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_stray_element_makes_the_profile_wrong_alone]).
cp_test_fail_names([the_out_of_scope_atom_is_not_an_in_scope_result, the_marker_fails_for_an_unrecorded_key, a_well_formed_profile_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
