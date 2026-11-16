% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [decide_gdpr_consent_conditions/2, gdpr_consent_conditions_status/2, gdpr_consent_conditions_checklist/2, consent_conditions_status/4, consent_declaration_effect/3, consent_assessment_factors/2, identification_obligation/4, identification_information_duty/4, identification_rights_effect/4]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_profile_for/2]).

test(the_plain_profile_yields_exactly_one_status) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    findall(Status, gdpr_consent_conditions_status(Profile, Status), Statuses),
    Statuses == [conditions_met].
test(the_verdict_carries_a_citation) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    decide_gdpr_consent_conditions(Profile, gdpr_consent_conditions_verdict(conditions_met, [_FirstCitation|_OtherCitations])).
test(met_basis_lists_three_outside_facts_in_order) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    findall(Basis, consent_conditions_status(Profile, conditions_met, Basis, _), Bases),
    Bases = [[outside_fact(consent_demonstrable, _), outside_fact(withdrawal_as_easy_as_giving_consent, _), outside_fact(consent_freely_given, _)]].
test(met_with_declaration_cites_all_four_limbs) :-
    gdpr_consent_conditions_profile_for(consent_met_with_declaration, Profile),
    findall(Citations, consent_conditions_status(Profile, conditions_met, _, Citations), CitationLists),
    CitationLists == [[cite(eu_reg_2016_679_art_7_1), cite(eu_reg_2016_679_art_7_2), cite(eu_reg_2016_679_art_7_3), cite(eu_reg_2016_679_art_7_4)]].
test(not_met_basis_copies_only_the_false_outside_facts) :-
    gdpr_consent_conditions_profile_for(consent_two_conditions_unmet, Profile),
    findall(Basis, consent_conditions_status(Profile, conditions_not_met, Basis, _), Bases),
    Bases = [[outside_fact(consent_demonstrable, attested(false, _)), outside_fact(consent_freely_given, attested(false, _))]].
test(unclear_request_cites_art_7_2_alone) :-
    gdpr_consent_conditions_profile_for(consent_request_unclear, Profile),
    findall(Citations, consent_conditions_status(Profile, conditions_not_met, _, Citations), CitationLists),
    CitationLists == [[cite(eu_reg_2016_679_art_7_2)]].
test(withdrawal_not_informed_has_empty_basis) :-
    gdpr_consent_conditions_profile_for(consent_withdrawal_not_informed, Profile),
    findall(Basis - Citations, consent_conditions_status(Profile, conditions_not_met, Basis, Citations), Answers),
    Answers == [[] - [cite(eu_reg_2016_679_art_7_3)]].
test(declaration_effect_one_solution) :-
    gdpr_consent_conditions_profile_for(consent_met_with_declaration, Profile),
    findall(Status - Citations, consent_declaration_effect(Profile, Status, Citations), Answers),
    Answers == [no_part_infringing - [cite(eu_reg_2016_679_art_7_2)]].
test(declaration_effect_not_applicable_without_declaration) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    findall(Status, consent_declaration_effect(Profile, Status, _), Statuses),
    Statuses == [not_applicable].
test(factors_single_list_solution) :-
    gdpr_consent_conditions_profile_for(contract_conditional_consent, Profile),
    findall(Factors, consent_assessment_factors(Profile, Factors), FactorLists),
    FactorLists == [[factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))]].
test(factors_indeterminate_without_key) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    findall(Factors, consent_assessment_factors(Profile, Factors), FactorLists),
    FactorLists == [indeterminate([contract_conditional_on_unneeded_consent])].
test(obligation_not_engaged_one_solution) :-
    gdpr_consent_conditions_profile_for(identification_purposes_require, Profile),
    findall(Status, identification_obligation(Profile, Status, _, _), Statuses),
    Statuses == [art11_1_not_engaged].
test(duty_not_engaged_basis_names_the_false_fact) :-
    gdpr_consent_conditions_profile_for(identification_inability_denied, Profile),
    findall(Status - Basis, identification_information_duty(Profile, Status, Basis, _), Answers),
    Answers = [art11_2_not_engaged - [outside_fact(able_to_demonstrate_not_in_position_to_identify, attested(false, _))]].
test(duty_referral_names_first_absent_fact) :-
    gdpr_consent_conditions_profile_for(identification_statements_absent, Profile),
    findall(Status, identification_information_duty(Profile, Status, _, _), Statuses),
    Statuses == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_11_1), cite(identification_not_required_statement)), [resolution(cite(identification_not_required_statement), not_attempted), inputs_relied_on([purposes_do_not_require_identification - absent])])].
test(rights_effect_one_solution) :-
    gdpr_consent_conditions_profile_for(identification_information_provided, Profile),
    findall(Status, identification_rights_effect(Profile, Status, _, _), Statuses),
    Statuses == [articles_15_to_20_apply].
test(checklist_has_six_items) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    gdpr_consent_conditions_checklist(Profile, Items),
    length(Items, 6).
test(input_problem_profile_yields_input_problems) :-
    gdpr_consent_conditions_profile_for(input_problem_profile, Profile),
    findall(Status - Basis - Citations, consent_conditions_status(Profile, Status, Basis, Citations), Answers),
    Answers == [input_problems([duplicate_key(processing_based_on_consent), unknown_key(unexpected_key)]) - [] - []].

cp_test_names([the_plain_profile_yields_exactly_one_status, the_verdict_carries_a_citation, met_basis_lists_three_outside_facts_in_order, met_with_declaration_cites_all_four_limbs, not_met_basis_copies_only_the_false_outside_facts, unclear_request_cites_art_7_2_alone, withdrawal_not_informed_has_empty_basis, declaration_effect_one_solution, declaration_effect_not_applicable_without_declaration, factors_single_list_solution, factors_indeterminate_without_key, obligation_not_engaged_one_solution, duty_not_engaged_basis_names_the_false_fact, duty_referral_names_first_absent_fact, rights_effect_one_solution, checklist_has_six_items, input_problem_profile_yields_input_problems]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
