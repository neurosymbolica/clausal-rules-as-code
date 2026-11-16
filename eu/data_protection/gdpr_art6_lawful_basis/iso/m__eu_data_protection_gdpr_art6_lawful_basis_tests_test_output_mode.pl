% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, decide_gdpr_art6_lawful_basis/2, gdpr_art6_lawful_basis_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_profile_for/2]).

lawful_answers(Subject, Answers) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, lawful_basis_status(Profile, Result, Basis, Citations), Answers).

compatibility_answers(Subject, Answers) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, purpose_compatibility(Profile, Result, Basis, Citations), Answers).

profile_value(Subject, ProfileKey, Value) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    member(attribute(ProfileKey, Value), Profile).

same_citations(Citations, Expected) :-
    sort(Citations, Sorted),
    sort(Expected, Sorted).

test(contract_alone_unclaimed_is_eligible_once) :-
    lawful_answers(contract_alone_unclaimed, [eligible - [] - Citations]),
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
test(two_ways_hold_cite_both_and_flag_the_special_category) :-
    profile_value(two_ways_hold_with_special_category, special_category, Special),
    lawful_answers(two_ways_hold_with_special_category, [eligible - Basis - Citations]),
    Basis == [flagged(special_category, Special)],
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b), cite(eu_reg_2016_679_art_6_1_d)]).
test(point_c_holding_cites_art_6_3_and_copies_the_law_statement) :-
    profile_value(legal_obligation_laid_down_by_law_true, legal_obligation_laid_down_by_law, LawStated),
    lawful_answers(legal_obligation_laid_down_by_law_true, [eligible - Basis - Citations]),
    Basis == [outside_fact(legal_obligation_laid_down_by_law, LawStated)],
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]).
test(point_e_holding_cites_art_6_3) :-
    profile_value(public_interest_task_laid_down_by_law_true, public_interest_task_laid_down_by_law, LawStated),
    lawful_answers(public_interest_task_laid_down_by_law_true, [eligible - Basis - Citations]),
    Basis == [outside_fact(public_interest_task_laid_down_by_law, LawStated)],
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_3)]).
test(point_f_holding_flags_child_then_special_category) :-
    profile_value(legitimate_interests_balance_for_controller, child_data_subject, Child),
    profile_value(legitimate_interests_balance_for_controller, special_category, Special),
    lawful_answers(legitimate_interests_balance_for_controller, [eligible - Basis - Citations]),
    Basis == [flagged(child_data_subject, Child), flagged(special_category, Special)],
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
test(refused_consent_is_ineligible_with_the_statement) :-
    profile_value(consent_claimed_attested_false, consent_given_and_conditions_met, Refused),
    lawful_answers(consent_claimed_attested_false, [ineligible - Basis - Citations]),
    Basis == [outside_fact(consent_given_and_conditions_met, Refused)],
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]).
test(law_statement_attested_false_adds_art_6_3) :-
    profile_value(legal_obligation_laid_down_by_law_false, legal_obligation_laid_down_by_law, LawRefused),
    lawful_answers(legal_obligation_laid_down_by_law_false, [ineligible - Basis - Citations]),
    Basis == [outside_fact(legal_obligation_laid_down_by_law, LawRefused)],
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]).
test(public_task_not_necessary_does_not_cite_art_6_3) :-
    lawful_answers(public_interest_task_not_necessary, [ineligible - [] - Citations]),
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_e)]).
test(public_authority_failing_cites_the_last_subparagraph) :-
    lawful_answers(legitimate_interests_public_authority, [ineligible - [] - Citations]),
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
test(overridden_interests_cite_point_f_only) :-
    lawful_answers(legitimate_interests_overridden, [ineligible - [] - Citations]),
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f)]).
test(empty_profile_names_one_key) :-
    lawful_answers(empty_profile, Answers),
    Answers == [indeterminate([contract_necessary]) - [] - []].
test(absent_consent_of_the_last_open_way_is_referred) :-
    lawful_answers(consent_statement_absent_for_last_open_way, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])]) - [] - []].
test(absent_law_statement_of_a_one_step_way_is_referred) :-
    lawful_answers(legal_obligation_law_statement_absent_one_step, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), [resolution(cite(legal_obligation_law_statement), not_attempted), inputs_relied_on([legal_obligation_laid_down_by_law - absent])]) - [] - []].
test(missing_crisp_key_is_named_before_the_unsure_judgement) :-
    lawful_answers(public_authority_question_missing_beside_unsure, Answers),
    Answers == [indeterminate([processing_by_public_authority_in_its_tasks]) - [] - []].
test(absent_law_statement_is_referred_before_the_unsure_judgement) :-
    lawful_answers(legal_obligation_unsure_law_statement_absent, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), [resolution(cite(legal_obligation_law_statement), not_attempted), inputs_relied_on([legal_obligation_laid_down_by_law - absent])]) - [] - []].
test(unsure_public_task_goes_to_a_lawyer_with_the_present_pairs) :-
    profile_value(public_task_necessity_unsure_after_authority_stated, consent_given_and_conditions_met, Refused),
    profile_value(public_task_necessity_unsure_after_authority_stated, public_interest_task_laid_down_by_law, LawStated),
    lawful_answers(public_task_necessity_unsure_after_authority_stated, Answers),
    Answers == [needs_legal_review(open_textured(public_interest_task_necessary, cite(eu_reg_2016_679_art_6_1_e)), [inputs_relied_on([consent_given_and_conditions_met - Refused, contract_necessary - false, legal_obligation_necessary - false, vital_interests_necessary - false, public_interest_task_necessary - unsure, public_interest_task_laid_down_by_law - LawStated, processing_by_public_authority_in_its_tasks - true])]) - [] - []].
test(unsure_balance_goes_to_a_lawyer_with_the_child) :-
    profile_value(legitimate_interests_balance_unsure, child_data_subject, Child),
    lawful_answers(legitimate_interests_balance_unsure, Answers),
    Answers == [needs_legal_review(open_textured(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)), [inputs_relied_on([basis_claimed - legitimate_interests, processing_by_public_authority_in_its_tasks - false, legitimate_interests_pursued - true, interests_overridden - unsure, child_data_subject - Child])]) - [] - []].
test(unknown_keys_in_first_occurrence_order) :-
    lawful_answers(unknown_and_numeric_keys, Answers),
    Answers == [input_problems([unknown_key(favourite_colour), unknown_key(42)]) - [] - []].
test(duplicate_key_is_reported_once) :-
    lawful_answers(duplicate_contract_key, Answers),
    Answers == [input_problems([duplicate_key(contract_necessary)]) - [] - []].
test(bare_outside_fact_is_a_wrong_type) :-
    lawful_answers(bare_outside_fact_value, Answers),
    Answers == [input_problems([wrong_type(consent_given_and_conditions_met)]) - [] - []].
test(attested_judgement_is_a_wrong_type) :-
    lawful_answers(attested_judgement_value, Answers),
    Answers == [input_problems([wrong_type(contract_necessary)]) - [] - []].
test(unsure_crisp_key_is_a_wrong_type) :-
    compatibility_answers(crisp_key_given_unsure, Answers),
    Answers == [input_problems([wrong_type(processing_by_public_authority_in_its_tasks)]) - [] - []].
test(basis_outside_its_list_is_a_wrong_type) :-
    lawful_answers(basis_claimed_outside_its_list, Answers),
    Answers == [input_problems([wrong_type(basis_claimed)]) - [] - []].
test(compatibility_not_engaged_once) :-
    compatibility_answers(new_purpose_not_engaged, Answers),
    Answers == [compatibility_test_not_engaged - [] - [cite(eu_reg_2016_679_art_6_4)]].
test(compatibility_asks_for_the_new_purpose) :-
    compatibility_answers(new_purpose_absent, Answers),
    Answers == [indeterminate([new_purpose_processing]) - [] - []].
test(compatibility_compatible) :-
    compatibility_answers(new_purpose_compatible, Answers),
    Answers == [purpose_compatible - [] - [cite(eu_reg_2016_679_art_6_4)]].
test(compatibility_not_compatible) :-
    compatibility_answers(new_purpose_not_compatible, Answers),
    Answers == [purpose_not_compatible - [] - [cite(eu_reg_2016_679_art_6_4)]].
test(compatibility_asks_for_the_judgement) :-
    compatibility_answers(new_purpose_compatibility_absent, Answers),
    Answers == [indeterminate([compatible_purpose]) - [] - []].
test(compatibility_unsure_goes_to_a_lawyer) :-
    compatibility_answers(new_purpose_compatibility_unsure, Answers),
    Answers == [needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing - true, compatible_purpose - unsure])]) - [] - []].
test(the_verdict_carries_a_citation) :-
    gdpr_art6_lawful_basis_profile_for(contract_claimed_necessary, Profile),
    findall(Verdict, decide_gdpr_art6_lawful_basis(Profile, Verdict), [gdpr_art6_lawful_basis_verdict(eligible, [_FirstCitation|_OtherCitations])]).
test(the_checklist_cites_every_point) :-
    gdpr_art6_lawful_basis_profile_for(contract_alone_unclaimed, Profile),
    findall(Items, gdpr_art6_lawful_basis_checklist(Profile, Items), [Items]),
    findall(Citation, member(item(_, _, Citation), Items), Citations),
    Citations == [cite(eu_reg_2016_679_art_6_1_a), cite(eu_reg_2016_679_art_6_1_b), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_1_d), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_1_f)].
test(the_checklist_marks_unclaimed_ways_inapplicable) :-
    gdpr_art6_lawful_basis_profile_for(contract_claimed_necessary, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, Items),
    member(item(point_b, met, cite(eu_reg_2016_679_art_6_1_b)), Items),
    member(item(point_a, inapplicable, cite(eu_reg_2016_679_art_6_1_a)), Items).

cp_test_names([contract_alone_unclaimed_is_eligible_once, two_ways_hold_cite_both_and_flag_the_special_category, point_c_holding_cites_art_6_3_and_copies_the_law_statement, point_e_holding_cites_art_6_3, point_f_holding_flags_child_then_special_category, refused_consent_is_ineligible_with_the_statement, law_statement_attested_false_adds_art_6_3, public_task_not_necessary_does_not_cite_art_6_3, public_authority_failing_cites_the_last_subparagraph, overridden_interests_cite_point_f_only, empty_profile_names_one_key, absent_consent_of_the_last_open_way_is_referred, absent_law_statement_of_a_one_step_way_is_referred, missing_crisp_key_is_named_before_the_unsure_judgement, absent_law_statement_is_referred_before_the_unsure_judgement, unsure_public_task_goes_to_a_lawyer_with_the_present_pairs, unsure_balance_goes_to_a_lawyer_with_the_child, unknown_keys_in_first_occurrence_order, duplicate_key_is_reported_once, bare_outside_fact_is_a_wrong_type, attested_judgement_is_a_wrong_type, unsure_crisp_key_is_a_wrong_type, basis_outside_its_list_is_a_wrong_type, compatibility_not_engaged_once, compatibility_asks_for_the_new_purpose, compatibility_compatible, compatibility_not_compatible, compatibility_asks_for_the_judgement, compatibility_unsure_goes_to_a_lawyer, the_verdict_carries_a_citation, the_checklist_cites_every_point, the_checklist_marks_unclaimed_ways_inapplicable]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
