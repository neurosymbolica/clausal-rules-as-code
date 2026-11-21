% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, decide_gdpr_art6_lawful_basis/2, gdpr_art6_lawful_basis_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_profile_for/2]).

lawful_answer(Subject, Result, Basis, SortedCitations) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    lawful_basis_status(Profile, Result, Basis, Citations),
    sort(Citations, SortedCitations).

purpose_answer(Subject, Result, Basis, SortedCitations) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    purpose_compatibility(Profile, Result, Basis, Citations),
    sort(Citations, SortedCitations).

has_only_lawful_answer(Subject, Result, Basis, Citations) :-
    findall(FoundResult - FoundBasis - FoundCitations, lawful_answer(Subject, FoundResult, FoundBasis, FoundCitations), Answers),
    sort(Citations, SortedCitations),
    Answers == [Result - Basis - SortedCitations].

has_only_purpose_answer(Subject, Result, Basis, Citations) :-
    findall(FoundResult - FoundBasis - FoundCitations, purpose_answer(Subject, FoundResult, FoundBasis, FoundCitations), Answers),
    sort(Citations, SortedCitations),
    Answers == [Result - Basis - SortedCitations].

statement_of(Subject, FactKey, Statement) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    member(attribute(FactKey, Statement), Profile).

test(consent_holds) :-
    statement_of(claimed_consent_holds, consent_given_and_conditions_met, Statement),
    has_only_lawful_answer(claimed_consent_holds, eligible, [outside_fact(consent_given_and_conditions_met, Statement)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]).
test(consent_refused) :-
    statement_of(claimed_consent_refused, consent_given_and_conditions_met, Statement),
    has_only_lawful_answer(claimed_consent_refused, ineligible, [outside_fact(consent_given_and_conditions_met, Statement)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]).
test(contract_holds) :-
    has_only_lawful_answer(claimed_contract_holds, eligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
test(contract_not_necessary) :-
    has_only_lawful_answer(claimed_contract_not_necessary, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
test(legal_obligation_holds) :-
    statement_of(claimed_legal_obligation_holds, legal_obligation_laid_down_by_law, Statement),
    has_only_lawful_answer(claimed_legal_obligation_holds, eligible, [outside_fact(legal_obligation_laid_down_by_law, Statement)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]).
test(legal_obligation_law_refused) :-
    statement_of(claimed_legal_obligation_law_refused, legal_obligation_laid_down_by_law, Statement),
    has_only_lawful_answer(claimed_legal_obligation_law_refused, ineligible, [outside_fact(legal_obligation_laid_down_by_law, Statement)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]).
test(vital_interests_holds) :-
    has_only_lawful_answer(claimed_vital_interests_holds, eligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_d)]).
test(vital_interests_not_necessary) :-
    has_only_lawful_answer(claimed_vital_interests_not_necessary, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_d)]).
test(public_interest_task_holds) :-
    statement_of(claimed_public_interest_task_holds, public_interest_task_laid_down_by_law, Statement),
    has_only_lawful_answer(claimed_public_interest_task_holds, eligible, [outside_fact(public_interest_task_laid_down_by_law, Statement)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_3)]).
test(legitimate_interests_holds) :-
    has_only_lawful_answer(claimed_legitimate_interests_holds, eligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
test(legitimate_interests_overridden) :-
    has_only_lawful_answer(claimed_legitimate_interests_overridden, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f)]).
test(legitimate_interests_public_authority) :-
    has_only_lawful_answer(claimed_legitimate_interests_public_authority, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
test(legitimate_interests_child_flagged) :-
    statement_of(legitimate_interests_holds_child_flagged, child_data_subject, Statement),
    has_only_lawful_answer(legitimate_interests_holds_child_flagged, eligible, [flagged(child_data_subject, Statement)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
test(consent_special_category_flagged) :-
    statement_of(consent_holds_special_category_flagged, consent_given_and_conditions_met, ConsentStatement),
    statement_of(consent_holds_special_category_flagged, special_category, SpecialStatement),
    has_only_lawful_answer(consent_holds_special_category_flagged, eligible, [outside_fact(consent_given_and_conditions_met, ConsentStatement), flagged(special_category, SpecialStatement)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]).
test(every_way_fails) :-
    statement_of(every_way_fails, consent_given_and_conditions_met, Statement),
    has_only_lawful_answer(every_way_fails, ineligible, [outside_fact(consent_given_and_conditions_met, Statement)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a), cite(eu_reg_2016_679_art_6_1_b), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_1_d), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_1_f)]).
test(empty_profile_names_contract_necessary) :-
    has_only_lawful_answer(empty_profile, indeterminate([contract_necessary]), [], []).
test(consent_statement_absent_is_referred) :-
    has_only_lawful_answer(claimed_consent_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])]), [], []).
test(legal_obligation_necessity_absent_is_named) :-
    has_only_lawful_answer(claimed_legal_obligation_necessity_absent, indeterminate([legal_obligation_necessary]), [], []).
test(unsure_necessity_with_absent_law_refers_the_law) :-
    has_only_lawful_answer(claimed_legal_obligation_necessity_unsure_law_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), [resolution(cite(legal_obligation_law_statement), not_attempted), inputs_relied_on([legal_obligation_laid_down_by_law - absent])]), [], []).
test(public_interest_task_law_absent_is_referred) :-
    has_only_lawful_answer(claimed_public_interest_task_law_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(public_interest_task_law_statement)), [resolution(cite(public_interest_task_law_statement), not_attempted), inputs_relied_on([public_interest_task_laid_down_by_law - absent])]), [], []).
test(balance_absent_is_named) :-
    has_only_lawful_answer(claimed_legitimate_interests_balance_absent, indeterminate([interests_overridden]), [], []).
test(unsure_balance_refers_with_the_child_pair) :-
    statement_of(claimed_legitimate_interests_balance_unsure_child, child_data_subject, Statement),
    has_only_lawful_answer(claimed_legitimate_interests_balance_unsure_child, needs_legal_review(open_textured(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)), [inputs_relied_on([basis_claimed - legitimate_interests, processing_by_public_authority_in_its_tasks - false, legitimate_interests_pursued - true, interests_overridden - unsure, child_data_subject - Statement])]), [], []).
test(one_step_key_is_named_before_an_unsure_judgement) :-
    has_only_lawful_answer(unsure_contract_vital_interests_absent, indeterminate([vital_interests_necessary]), [], []).
test(only_unsure_contract_goes_to_a_lawyer) :-
    statement_of(only_unsure_contract_left, consent_given_and_conditions_met, Statement),
    has_only_lawful_answer(only_unsure_contract_left, needs_legal_review(open_textured(contract_necessary, cite(eu_reg_2016_679_art_6_1_b)), [inputs_relied_on([consent_given_and_conditions_met - Statement, contract_necessary - unsure, legal_obligation_necessary - false, vital_interests_necessary - false, public_interest_task_necessary - false, legitimate_interests_pursued - false])]), [], []).
test(duplicate_key_gives_input_problems) :-
    has_only_lawful_answer(input_duplicate_key, input_problems([duplicate_key(contract_necessary)]), [], []).
test(purpose_test_not_engaged) :-
    has_only_purpose_answer(purpose_test_not_engaged, compatibility_test_not_engaged, [], [cite(eu_reg_2016_679_art_6_4)]).
test(purpose_new_purpose_absent) :-
    has_only_purpose_answer(empty_profile, indeterminate([new_purpose_processing]), [], []).
test(purpose_compatible) :-
    has_only_purpose_answer(purpose_compatible, purpose_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
test(purpose_not_compatible) :-
    has_only_purpose_answer(purpose_not_compatible, purpose_not_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
test(purpose_factor_left_out) :-
    has_only_purpose_answer(purpose_factor_left_out, compatibility_not_ascertained, [], [cite(eu_reg_2016_679_art_6_4), cite(eu_reg_2016_679_art_6_4_a), cite(eu_reg_2016_679_art_6_4_b), cite(eu_reg_2016_679_art_6_4_c), cite(eu_reg_2016_679_art_6_4_d), cite(eu_reg_2016_679_art_6_4_e)]).
test(purpose_factors_all_taken) :-
    has_only_purpose_answer(purpose_factors_all_taken, purpose_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
test(purpose_judgement_absent) :-
    has_only_purpose_answer(purpose_judgement_absent, indeterminate([compatible_purpose]), [], []).
test(purpose_judgement_unsure) :-
    has_only_purpose_answer(purpose_judgement_unsure, needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing - true, compatible_purpose - unsure])]), [], []).
test(purpose_input_problems) :-
    has_only_purpose_answer(input_bare_outside_fact, input_problems([wrong_type(consent_given_and_conditions_met)]), [], []).
test(the_verdict_carries_a_citation) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_holds, Profile),
    findall(Verdict, decide_gdpr_art6_lawful_basis(Profile, Verdict), Verdicts),
    Verdicts = [gdpr_art6_lawful_basis_verdict(eligible, [_FirstCitation|_OtherCitations])].
test(checklist_reads_out_one_item_per_way) :-
    findall(Items, gdpr_art6_lawful_basis_checklist([], Items), [Items]),
    length(Items, 6).
test(checklist_marks_a_failing_way) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_not_necessary, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, Items),
    Items == [item(way_b, unmet(failing_keys([contract_necessary])), cite(eu_reg_2016_679_art_6_1_b))].

cp_test_names([consent_holds, consent_refused, contract_holds, contract_not_necessary, legal_obligation_holds, legal_obligation_law_refused, vital_interests_holds, vital_interests_not_necessary, public_interest_task_holds, legitimate_interests_holds, legitimate_interests_overridden, legitimate_interests_public_authority, legitimate_interests_child_flagged, consent_special_category_flagged, every_way_fails, empty_profile_names_contract_necessary, consent_statement_absent_is_referred, legal_obligation_necessity_absent_is_named, unsure_necessity_with_absent_law_refers_the_law, public_interest_task_law_absent_is_referred, balance_absent_is_named, unsure_balance_refers_with_the_child_pair, one_step_key_is_named_before_an_unsure_judgement, only_unsure_contract_goes_to_a_lawyer, duplicate_key_gives_input_problems, purpose_test_not_engaged, purpose_new_purpose_absent, purpose_compatible, purpose_not_compatible, purpose_factor_left_out, purpose_factors_all_taken, purpose_judgement_absent, purpose_judgement_unsure, purpose_input_problems, the_verdict_carries_a_citation, checklist_reads_out_one_item_per_way, checklist_marks_a_failing_way]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
