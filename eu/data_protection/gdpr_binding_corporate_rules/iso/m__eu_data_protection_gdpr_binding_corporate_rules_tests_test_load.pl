% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_binding_corporate_rules_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_kernel, [gdpr_binding_corporate_rules_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_binding_corporate_rules_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(policies_are_personal_data_protection_policies, true), attribute(adhering_party_is_controller_or_processor, unsure), attribute(rules_specify_appropriate_data_protection_training, false)],
    findall(Problems, gdpr_binding_corporate_rules_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    Profile = [attribute(rules_specify_complaint_procedures, unsure)],
    findall(Problems, gdpr_binding_corporate_rules_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(rules_specify_complaint_procedures)]].
test(an_attested_value_is_wrong_type) :-
    Profile = [attribute(transfers_within_group_of_undertakings_or_group_of_enterprises, attested(true))],
    gdpr_binding_corporate_rules_input_problems(Profile, Problems),
    Problems == [wrong_type(transfers_within_group_of_undertakings_or_group_of_enterprises)].
test(a_compound_value_is_wrong_type) :-
    Profile = [attribute(policies_adhered_to_by_adhering_party, maybe(true))],
    gdpr_binding_corporate_rules_input_problems(Profile, Problems),
    Problems == [wrong_type(policies_adhered_to_by_adhering_party)].
test(a_repeated_key_is_a_duplicate_only) :-
    Profile = [attribute(rules_specify_data_transfers, true), attribute(rules_specify_data_transfers, maybe)],
    findall(Problems, gdpr_binding_corporate_rules_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(rules_specify_data_transfers)]].
test(a_key_outside_the_contract_is_unknown_once) :-
    Profile = [attribute(approval_granted, true), attribute(approval_granted, false)],
    gdpr_binding_corporate_rules_input_problems(Profile, Problems),
    Problems == [unknown_key(approval_granted)].
test(contract_problems_come_before_unknown_keys) :-
    Profile = [attribute(approval_granted, true), attribute(rules_specify_legally_binding_nature, yes)],
    gdpr_binding_corporate_rules_input_problems(Profile, Problems),
    Problems == [wrong_type(rules_specify_legally_binding_nature), unknown_key(approval_granted)].
test(a_term_that_is_not_a_list_is_not_a_profile) :-
    findall(Problems, gdpr_binding_corporate_rules_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_not_a_profile) :-
    findall(Problems, gdpr_binding_corporate_rules_input_problems(_Unbound, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_element_is_not_a_profile) :-
    Profile = [attribute(rules_specify_data_transfers, true), rules_specify_complaint_procedures],
    gdpr_binding_corporate_rules_input_problems(Profile, Problems),
    Problems == [wrong_type(profile)].
test(the_referral_term_carries_its_input_citation_and_pairs) :-
    Result = needs_legal_review(open_textured(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)), [inputs_relied_on([rules_specify_appropriate_data_protection_training - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == rules_specify_appropriate_data_protection_training,
    Citation == eu_reg_2016_679_art_47_2_n,
    Pairs == [rules_specify_appropriate_data_protection_training - unsure].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([policies_cover_transfers_to_third_countries]),
    Result = indeterminate([MissingKey]),
    MissingKey == policies_cover_transfers_to_third_countries.
test(the_checklist_item_carries_key_citation_and_state) :-
    Item = checklist_item(rules_specify_complaint_procedures, cite(eu_reg_2016_679_art_47_2_i), met),
    Item = checklist_item(Key, cite(Citation), State),
    Key == rules_specify_complaint_procedures,
    Citation == eu_reg_2016_679_art_47_2_i,
    State == met.
test(the_input_problems_term_wraps_the_problem_list) :-
    Result = input_problems([wrong_type(profile)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(profile)].
test(the_definition_atoms_are_distinct) :-
    dif(binding_corporate_rules, not_binding_corporate_rules).
test(the_content_atoms_are_distinct) :-
    dif(content_complete, content_incomplete).
test(the_state_atoms_are_distinct) :-
    dif(met, unmet),
    dif(met, open_by_absence),
    dif(met, open_by_judgement),
    dif(unmet, open_by_absence),
    dif(unmet, open_by_judgement),
    dif(open_by_absence, open_by_judgement).
test(the_definition_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_4_20, _Record).
test(the_content_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_47_2, _Record).
test(the_training_point_citation_is_recorded) :-
    implements(eu_reg_2016_679_art_47_2_n).
test(the_definition_record_has_label_reference_and_verbatim) :-
    citation(eu_reg_2016_679_art_4_20, [label - _Label, ref - _Reference, verbatim - _Verbatim]).

test(a_crisp_key_given_unsure_is_not_accepted, fail) :-
    gdpr_binding_corporate_rules_input_problems([attribute(rules_specify_complaint_procedures, unsure)], []).
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(art_47_2, _Record).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, an_attested_value_is_wrong_type, a_compound_value_is_wrong_type, a_repeated_key_is_a_duplicate_only, a_key_outside_the_contract_is_unknown_once, contract_problems_come_before_unknown_keys, a_term_that_is_not_a_list_is_not_a_profile, an_unbound_profile_is_not_a_profile, a_list_with_a_foreign_element_is_not_a_profile, the_referral_term_carries_its_input_citation_and_pairs, the_indeterminate_term_names_one_key, the_checklist_item_carries_key_citation_and_state, the_input_problems_term_wraps_the_problem_list, the_definition_atoms_are_distinct, the_content_atoms_are_distinct, the_state_atoms_are_distinct, the_definition_citation_is_recorded, the_content_citation_is_recorded, the_training_point_citation_is_recorded, the_definition_record_has_label_reference_and_verbatim]).
cp_test_fail_names([a_crisp_key_given_unsure_is_not_accepted, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
