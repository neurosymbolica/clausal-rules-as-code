% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, decide_gdpr_art6_lawful_basis/2, gdpr_art6_lawful_basis_status/2, gdpr_art6_lawful_basis_checklist/2, gdpr_art6_lawful_basis_decision_resolvable/1, gdpr_art6_lawful_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_queries, [gdpr_art6_lawful_basis_what_if/4, gdpr_art6_lawful_basis_profile_keys/1]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_subject/1, gdpr_art6_lawful_basis_profile_for/2, gdpr_art6_lawful_basis_assess/2]).

expected_lawful(claimed_consent_holds, eligible, [outside_fact(consent_given_and_conditions_met, attested(true, attestation(host_system, recorded_moment, stated_reason, none)))], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]).
expected_lawful(claimed_consent_refused, ineligible, [outside_fact(consent_given_and_conditions_met, attested(false, attestation(host_system, recorded_moment, stated_reason, none)))], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]).
expected_lawful(claimed_consent_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])]), [], []).
expected_lawful(claimed_contract_holds, eligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
expected_lawful(claimed_contract_not_necessary, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
expected_lawful(claimed_legal_obligation_holds, eligible, [outside_fact(legal_obligation_laid_down_by_law, attested(true, attestation(host_system, recorded_moment, stated_reason, url(statute_address, retrieved_moment))))], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]).
expected_lawful(claimed_legal_obligation_law_refused, ineligible, [outside_fact(legal_obligation_laid_down_by_law, attested(false, attestation(host_system, recorded_moment, stated_reason, none)))], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]).
expected_lawful(claimed_legal_obligation_necessity_absent, indeterminate([legal_obligation_necessary]), [], []).
expected_lawful(claimed_legal_obligation_necessity_unsure_law_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), [resolution(cite(legal_obligation_law_statement), not_attempted), inputs_relied_on([legal_obligation_laid_down_by_law - absent])]), [], []).
expected_lawful(claimed_vital_interests_holds, eligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_d)]).
expected_lawful(claimed_vital_interests_not_necessary, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_d)]).
expected_lawful(claimed_public_interest_task_holds, eligible, [outside_fact(public_interest_task_laid_down_by_law, attested(true, attestation(host_system, recorded_moment, stated_reason, document(upload_identifier, content_digest))))], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_3)]).
expected_lawful(claimed_public_interest_task_law_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(public_interest_task_law_statement)), [resolution(cite(public_interest_task_law_statement), not_attempted), inputs_relied_on([public_interest_task_laid_down_by_law - absent])]), [], []).
expected_lawful(claimed_legitimate_interests_holds, eligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
expected_lawful(claimed_legitimate_interests_overridden, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f)]).
expected_lawful(claimed_legitimate_interests_public_authority, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
expected_lawful(claimed_legitimate_interests_balance_absent, indeterminate([interests_overridden]), [], []).
expected_lawful(claimed_legitimate_interests_balance_unsure_child, needs_legal_review(open_textured(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)), [inputs_relied_on([basis_claimed - legitimate_interests, processing_by_public_authority_in_its_tasks - false, legitimate_interests_pursued - true, interests_overridden - unsure, child_data_subject - attested(true, attestation(host_system, recorded_moment, stated_reason, none))])]), [], []).
expected_lawful(legitimate_interests_holds_child_flagged, eligible, [flagged(child_data_subject, attested(true, attestation(host_system, recorded_moment, stated_reason, none)))], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
expected_lawful(consent_holds_special_category_flagged, eligible, [outside_fact(consent_given_and_conditions_met, attested(true, attestation(host_system, recorded_moment, stated_reason, none))), flagged(special_category, attested(true, attestation(host_system, recorded_moment, stated_reason, none)))], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]).
expected_lawful(every_way_fails, ineligible, [outside_fact(consent_given_and_conditions_met, attested(false, attestation(host_system, recorded_moment, stated_reason, none)))], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a), cite(eu_reg_2016_679_art_6_1_b), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_1_d), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_1_f)]).
expected_lawful(empty_profile, indeterminate([contract_necessary]), [], []).
expected_lawful(unsure_contract_vital_interests_absent, indeterminate([vital_interests_necessary]), [], []).
expected_lawful(only_unsure_contract_left, needs_legal_review(open_textured(contract_necessary, cite(eu_reg_2016_679_art_6_1_b)), [inputs_relied_on([consent_given_and_conditions_met - attested(false, attestation(host_system, recorded_moment, stated_reason, none)), contract_necessary - unsure, legal_obligation_necessary - false, vital_interests_necessary - false, public_interest_task_necessary - false, legitimate_interests_pursued - false])]), [], []).
expected_lawful(purpose_test_not_engaged, indeterminate([contract_necessary]), [], []).
expected_lawful(purpose_compatible, indeterminate([contract_necessary]), [], []).
expected_lawful(purpose_not_compatible, indeterminate([contract_necessary]), [], []).
expected_lawful(purpose_factor_left_out, indeterminate([contract_necessary]), [], []).
expected_lawful(purpose_factors_all_taken, indeterminate([contract_necessary]), [], []).
expected_lawful(purpose_judgement_absent, indeterminate([contract_necessary]), [], []).
expected_lawful(purpose_judgement_unsure, indeterminate([contract_necessary]), [], []).
expected_lawful(input_duplicate_key, input_problems([duplicate_key(contract_necessary)]), [], []).
expected_lawful(input_attested_judgement, input_problems([wrong_type(contract_necessary)]), [], []).
expected_lawful(input_bare_outside_fact, input_problems([wrong_type(consent_given_and_conditions_met)]), [], []).
expected_lawful(input_attestation_argument_unbound, input_problems([wrong_type(special_category)]), [], []).
expected_lawful(input_unknown_number_key, input_problems([unknown_key(42)]), [], []).
expected_lawful(input_partial_list, input_problems([wrong_type(profile)]), [], []).

expected_purpose(purpose_test_not_engaged, compatibility_test_not_engaged, [], [cite(eu_reg_2016_679_art_6_4)]).
expected_purpose(empty_profile, indeterminate([new_purpose_processing]), [], []).
expected_purpose(purpose_compatible, purpose_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
expected_purpose(purpose_not_compatible, purpose_not_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
expected_purpose(purpose_factor_left_out, compatibility_not_ascertained, [], [cite(eu_reg_2016_679_art_6_4), cite(eu_reg_2016_679_art_6_4_a), cite(eu_reg_2016_679_art_6_4_b), cite(eu_reg_2016_679_art_6_4_c), cite(eu_reg_2016_679_art_6_4_d), cite(eu_reg_2016_679_art_6_4_e)]).
expected_purpose(purpose_factors_all_taken, purpose_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
expected_purpose(purpose_judgement_absent, indeterminate([compatible_purpose]), [], []).
expected_purpose(purpose_judgement_unsure, needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing - true, compatible_purpose - unsure])]), [], []).
expected_purpose(claimed_contract_holds, indeterminate([new_purpose_processing]), [], []).
expected_purpose(input_duplicate_key, input_problems([duplicate_key(contract_necessary)]), [], []).
expected_purpose(input_attested_judgement, input_problems([wrong_type(contract_necessary)]), [], []).
expected_purpose(input_bare_outside_fact, input_problems([wrong_type(consent_given_and_conditions_met)]), [], []).
expected_purpose(input_attestation_argument_unbound, input_problems([wrong_type(special_category)]), [], []).
expected_purpose(input_unknown_number_key, input_problems([unknown_key(42)]), [], []).
expected_purpose(input_partial_list, input_problems([wrong_type(profile)]), [], []).

same_citations(FoundCitations, ExpectedCitations) :-
    sort(FoundCitations, SortedCitations),
    sort(ExpectedCitations, SortedCitations).

lawful_answer_is(Subject) :-
    expected_lawful(Subject, ExpectedResult, ExpectedBasis, ExpectedCitations),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    findall(answer(FoundResult, FoundBasis, FoundCitations), lawful_basis_status(Profile, FoundResult, FoundBasis, FoundCitations), Answers),
    Answers = [answer(Result, Basis, Citations)],
    Result == ExpectedResult,
    Basis == ExpectedBasis,
    same_citations(Citations, ExpectedCitations).

purpose_answer_is(Subject) :-
    expected_purpose(Subject, ExpectedResult, ExpectedBasis, ExpectedCitations),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    findall(answer(FoundResult, FoundBasis, FoundCitations), purpose_compatibility(Profile, FoundResult, FoundBasis, FoundCitations), Answers),
    Answers = [answer(Result, Basis, Citations)],
    Result == ExpectedResult,
    Basis == ExpectedBasis,
    same_citations(Citations, ExpectedCitations).

has_expected_lawful(Subject) :-
    expected_lawful(Subject, _, _, _).

single_answer_for_every_query(Subject) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    findall(LawfulResult, lawful_basis_status(Profile, LawfulResult, _, _), LawfulResults),
    length(LawfulResults, 1),
    findall(PurposeResult, purpose_compatibility(Profile, PurposeResult, _, _), PurposeResults),
    length(PurposeResults, 1),
    findall(Problems, gdpr_art6_lawful_basis_input_problems(Profile, Problems), ProblemLists),
    length(ProblemLists, 1),
    findall(Status, gdpr_art6_lawful_basis_status(Profile, Status), Statuses),
    length(Statuses, 1).

item_carries_citation(item(_, _, cite(_))).

checklist_is_cited(Subject) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, [FirstItem|OtherItems]),
    maplist(item_carries_citation, [FirstItem|OtherItems]).

assess_agrees_with_lawful_status(Subject) :-
    expected_lawful(Subject, ExpectedResult, _, ExpectedCitations),
    gdpr_art6_lawful_basis_assess(Subject, gdpr_art6_lawful_basis_verdict(Status, Citations)),
    Status == ExpectedResult,
    same_citations(Citations, ExpectedCitations).

final_status_is_listed(Subject) :-
    gdpr_art6_lawful_basis_assess(Subject, gdpr_art6_lawful_basis_verdict(Status, [_|_])),
    gdpr_art6_lawful_basis_status_values(StatusValues),
    member(Status, StatusValues).

is_provenance(provenance(_, _)).

scored_context(Subject, Context, ScoredContext) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    lawful_basis_status(Profile, Result, _, _),
    Result = needs_legal_review(_, Context),
    exclude(is_provenance, Context, ScoredContext).

test(every_subject_has_an_expected_lawful_answer) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    maplist(has_expected_lawful, Subjects).
test(every_subject_gives_exactly_one_answer_per_query) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    maplist(single_answer_for_every_query, Subjects).
test(every_subject_checklist_is_non_empty_and_cited) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    maplist(checklist_is_cited, Subjects).
test(every_subject_assess_agrees_with_lawful_basis_status) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    maplist(assess_agrees_with_lawful_status, Subjects).
test(final_subjects_give_a_listed_status) :-
    maplist(final_status_is_listed, [claimed_consent_holds, claimed_consent_refused, claimed_contract_holds, claimed_contract_not_necessary, claimed_legal_obligation_holds, claimed_legal_obligation_law_refused, claimed_vital_interests_holds, claimed_vital_interests_not_necessary, claimed_public_interest_task_holds, claimed_legitimate_interests_holds, claimed_legitimate_interests_overridden, claimed_legitimate_interests_public_authority, legitimate_interests_holds_child_flagged, consent_holds_special_category_flagged, every_way_fails]).
test(claimed_consent_holds_is_eligible) :-
    lawful_answer_is(claimed_consent_holds).
test(claimed_consent_refused_is_ineligible) :-
    lawful_answer_is(claimed_consent_refused).
test(claimed_consent_statement_absent_is_referred) :-
    lawful_answer_is(claimed_consent_statement_absent).
test(claimed_contract_holds_is_eligible) :-
    lawful_answer_is(claimed_contract_holds).
test(claimed_contract_not_necessary_is_ineligible) :-
    lawful_answer_is(claimed_contract_not_necessary).
test(claimed_legal_obligation_holds_is_eligible) :-
    lawful_answer_is(claimed_legal_obligation_holds).
test(claimed_legal_obligation_law_refused_is_ineligible) :-
    lawful_answer_is(claimed_legal_obligation_law_refused).
test(claimed_legal_obligation_necessity_absent_is_named) :-
    lawful_answer_is(claimed_legal_obligation_necessity_absent).
test(claimed_legal_obligation_law_absent_is_referred_before_unsure) :-
    lawful_answer_is(claimed_legal_obligation_necessity_unsure_law_absent).
test(claimed_vital_interests_holds_is_eligible) :-
    lawful_answer_is(claimed_vital_interests_holds).
test(claimed_vital_interests_not_necessary_is_ineligible) :-
    lawful_answer_is(claimed_vital_interests_not_necessary).
test(claimed_public_interest_task_holds_is_eligible) :-
    lawful_answer_is(claimed_public_interest_task_holds).
test(claimed_public_interest_task_law_absent_is_referred) :-
    lawful_answer_is(claimed_public_interest_task_law_absent).
test(claimed_legitimate_interests_holds_is_eligible) :-
    lawful_answer_is(claimed_legitimate_interests_holds).
test(claimed_legitimate_interests_overridden_is_ineligible) :-
    lawful_answer_is(claimed_legitimate_interests_overridden).
test(claimed_legitimate_interests_public_authority_is_ineligible) :-
    lawful_answer_is(claimed_legitimate_interests_public_authority).
test(claimed_legitimate_interests_balance_absent_is_named) :-
    lawful_answer_is(claimed_legitimate_interests_balance_absent).
test(claimed_legitimate_interests_balance_unsure_goes_to_a_lawyer) :-
    lawful_answer_is(claimed_legitimate_interests_balance_unsure_child).
test(legitimate_interests_holding_flags_the_child) :-
    lawful_answer_is(legitimate_interests_holds_child_flagged).
test(consent_holding_flags_special_category) :-
    lawful_answer_is(consent_holds_special_category_flagged).
test(every_way_failing_is_ineligible) :-
    lawful_answer_is(every_way_fails).
test(empty_profile_names_contract_necessary) :-
    lawful_answer_is(empty_profile).
test(missing_vital_interests_is_named_before_an_unsure_contract) :-
    lawful_answer_is(unsure_contract_vital_interests_absent).
test(only_an_unsure_contract_left_goes_to_a_lawyer) :-
    lawful_answer_is(only_unsure_contract_left).
test(open_textured_context_has_no_provenance_item) :-
    scored_context(only_unsure_contract_left, Context, ScoredContext),
    ScoredContext == Context,
    Context = [inputs_relied_on(_)].
test(cross_reference_context_has_no_provenance_item) :-
    scored_context(claimed_consent_statement_absent, Context, ScoredContext),
    ScoredContext == Context,
    Context = [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on(_)].
test(a_provenance_item_is_left_out_of_the_scored_context) :-
    exclude(is_provenance, [inputs_relied_on([contract_necessary - unsure]), provenance(contract_clause, [cite(eu_reg_2016_679_art_6_1_b)])], ScoredContext),
    ScoredContext == [inputs_relied_on([contract_necessary - unsure])].
test(purpose_subjects_leave_the_lawful_basis_open) :-
    maplist(lawful_answer_is, [purpose_test_not_engaged, purpose_compatible, purpose_not_compatible, purpose_factor_left_out, purpose_factors_all_taken, purpose_judgement_absent, purpose_judgement_unsure]).
test(purpose_test_not_engaged) :-
    purpose_answer_is(purpose_test_not_engaged).
test(purpose_new_purpose_absent_is_named) :-
    purpose_answer_is(empty_profile).
test(purpose_new_purpose_absent_on_a_lawful_basis_profile) :-
    purpose_answer_is(claimed_contract_holds).
test(purpose_compatible) :-
    purpose_answer_is(purpose_compatible).
test(purpose_not_compatible) :-
    purpose_answer_is(purpose_not_compatible).
test(purpose_factor_left_out_is_not_ascertained) :-
    purpose_answer_is(purpose_factor_left_out).
test(purpose_factors_all_taken_is_compatible) :-
    purpose_answer_is(purpose_factors_all_taken).
test(purpose_judgement_absent_is_named) :-
    purpose_answer_is(purpose_judgement_absent).
test(purpose_judgement_unsure_goes_to_a_lawyer) :-
    purpose_answer_is(purpose_judgement_unsure).
test(input_problems_for_both_queries) :-
    maplist(lawful_answer_is, [input_duplicate_key, input_attested_judgement, input_bare_outside_fact, input_attestation_argument_unbound, input_unknown_number_key, input_partial_list]),
    maplist(purpose_answer_is, [input_duplicate_key, input_attested_judgement, input_bare_outside_fact, input_attestation_argument_unbound, input_unknown_number_key, input_partial_list]).
test(input_check_names_the_duplicate_key) :-
    gdpr_art6_lawful_basis_profile_for(input_duplicate_key, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, [duplicate_key(contract_necessary)]).
test(input_check_is_clean_on_a_good_profile) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legal_obligation_holds, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, []).
test(input_problem_checklist_is_one_cited_row) :-
    gdpr_art6_lawful_basis_profile_for(input_partial_list, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, Items),
    Items == [item(overall, input_problems([wrong_type(profile)]), cite(eu_reg_2016_679_art_6_1))].
test(decide_carries_status_and_citations) :-
    gdpr_art6_lawful_basis_profile_for(claimed_public_interest_task_holds, Profile),
    decide_gdpr_art6_lawful_basis(Profile, gdpr_art6_lawful_basis_verdict(Status, Citations)),
    Status == eligible,
    same_citations(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_3)]).
test(status_projects_the_result) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_overridden, Profile),
    gdpr_art6_lawful_basis_status(Profile, ineligible).
test(checklist_item_for_a_holding_way) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_holds, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, Items),
    Items == [item(way_b, met, cite(eu_reg_2016_679_art_6_1_b))].
test(checklist_item_for_a_failing_way_names_the_key) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legal_obligation_law_refused, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, Items),
    Items == [item(way_c, unmet(failing_keys([legal_obligation_laid_down_by_law])), cite(eu_reg_2016_679_art_6_1_c))].
test(checklist_has_six_rows_without_a_claim) :-
    gdpr_art6_lawful_basis_profile_for(empty_profile, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, Items),
    length(Items, 6).
test(decision_is_resolvable_on_every_subject) :-
    findall(Profile, (gdpr_art6_lawful_basis_subject(Subject), gdpr_art6_lawful_basis_profile_for(Subject, Profile)), Profiles),
    maplist(gdpr_art6_lawful_basis_decision_resolvable, Profiles).
test(status_values_are_the_final_atoms) :-
    gdpr_art6_lawful_basis_status_values(StatusValues),
    StatusValues == [eligible, ineligible].
test(profile_keys_are_the_twenty_contract_keys) :-
    gdpr_art6_lawful_basis_profile_keys(ProfileKeys),
    length(ProfileKeys, 20).
test(what_if_contract_necessary_flips_to_eligible) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_not_necessary, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, contract_necessary, true, eligible).
test(what_if_contract_not_necessary_flips_to_ineligible) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_holds, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, contract_necessary, false, ineligible).
test(what_if_removing_the_consent_statement_refers) :-
    gdpr_art6_lawful_basis_profile_for(claimed_consent_holds, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, consent_given_and_conditions_met, absent, Status),
    Status == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])]).
test(what_if_settles_the_balance) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_balance_absent, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, interests_overridden, false, eligible).
test(what_if_replaces_a_duplicated_key) :-
    gdpr_art6_lawful_basis_profile_for(input_duplicate_key, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, contract_necessary, true, eligible).
test(what_if_on_a_partial_list_reports_the_profile) :-
    gdpr_art6_lawful_basis_profile_for(input_partial_list, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, contract_necessary, true, input_problems([wrong_type(profile)])).
test(what_if_gives_exactly_one_solution) :-
    gdpr_art6_lawful_basis_profile_for(empty_profile, Profile),
    findall(Status, gdpr_art6_lawful_basis_what_if(Profile, vital_interests_necessary, true, Status), Statuses),
    Statuses == [eligible].

test(claimed_consent_refused_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_consent_refused, Profile),
    lawful_basis_status(Profile, eligible, _, _).
test(claimed_contract_holds_is_not_ineligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_holds, Profile),
    lawful_basis_status(Profile, ineligible, _, _).
test(claimed_contract_not_necessary_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_not_necessary, Profile),
    lawful_basis_status(Profile, eligible, _, _).
test(claimed_legal_obligation_law_refused_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legal_obligation_law_refused, Profile),
    lawful_basis_status(Profile, eligible, _, _).
test(claimed_vital_interests_not_necessary_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_vital_interests_not_necessary, Profile),
    lawful_basis_status(Profile, eligible, _, _).
test(claimed_public_interest_task_law_absent_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_public_interest_task_law_absent, Profile),
    lawful_basis_status(Profile, eligible, _, _).
test(claimed_legitimate_interests_overridden_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_overridden, Profile),
    lawful_basis_status(Profile, eligible, _, _).
test(claimed_legitimate_interests_public_authority_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_public_authority, Profile),
    lawful_basis_status(Profile, eligible, _, _).
test(the_child_is_never_named_missing, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_balance_absent, Profile),
    lawful_basis_status(Profile, indeterminate([child_data_subject]), _, _).
test(every_way_failing_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(every_way_fails, Profile),
    lawful_basis_status(Profile, eligible, _, _).
test(an_outside_fact_is_never_named_missing, fail) :-
    gdpr_art6_lawful_basis_profile_for(empty_profile, Profile),
    lawful_basis_status(Profile, indeterminate([consent_given_and_conditions_met]), _, _).
test(no_referral_context_holds_a_provenance_item, fail) :-
    scored_context(only_unsure_contract_left, Context, _),
    member(provenance(_, _), Context).
test(purpose_not_compatible_is_not_compatible_answer, fail) :-
    gdpr_art6_lawful_basis_profile_for(purpose_not_compatible, Profile),
    purpose_compatibility(Profile, purpose_compatible, _, _).
test(purpose_factor_left_out_is_not_purpose_compatible, fail) :-
    gdpr_art6_lawful_basis_profile_for(purpose_factor_left_out, Profile),
    purpose_compatibility(Profile, purpose_compatible, _, _).
test(an_absent_factor_key_is_never_named, fail) :-
    gdpr_art6_lawful_basis_profile_for(purpose_judgement_absent, Profile),
    purpose_compatibility(Profile, indeterminate([collection_context_taken_into_account]), _, _).

cp_test_names([every_subject_has_an_expected_lawful_answer, every_subject_gives_exactly_one_answer_per_query, every_subject_checklist_is_non_empty_and_cited, every_subject_assess_agrees_with_lawful_basis_status, final_subjects_give_a_listed_status, claimed_consent_holds_is_eligible, claimed_consent_refused_is_ineligible, claimed_consent_statement_absent_is_referred, claimed_contract_holds_is_eligible, claimed_contract_not_necessary_is_ineligible, claimed_legal_obligation_holds_is_eligible, claimed_legal_obligation_law_refused_is_ineligible, claimed_legal_obligation_necessity_absent_is_named, claimed_legal_obligation_law_absent_is_referred_before_unsure, claimed_vital_interests_holds_is_eligible, claimed_vital_interests_not_necessary_is_ineligible, claimed_public_interest_task_holds_is_eligible, claimed_public_interest_task_law_absent_is_referred, claimed_legitimate_interests_holds_is_eligible, claimed_legitimate_interests_overridden_is_ineligible, claimed_legitimate_interests_public_authority_is_ineligible, claimed_legitimate_interests_balance_absent_is_named, claimed_legitimate_interests_balance_unsure_goes_to_a_lawyer, legitimate_interests_holding_flags_the_child, consent_holding_flags_special_category, every_way_failing_is_ineligible, empty_profile_names_contract_necessary, missing_vital_interests_is_named_before_an_unsure_contract, only_an_unsure_contract_left_goes_to_a_lawyer, open_textured_context_has_no_provenance_item, cross_reference_context_has_no_provenance_item, a_provenance_item_is_left_out_of_the_scored_context, purpose_subjects_leave_the_lawful_basis_open, purpose_test_not_engaged, purpose_new_purpose_absent_is_named, purpose_new_purpose_absent_on_a_lawful_basis_profile, purpose_compatible, purpose_not_compatible, purpose_factor_left_out_is_not_ascertained, purpose_factors_all_taken_is_compatible, purpose_judgement_absent_is_named, purpose_judgement_unsure_goes_to_a_lawyer, input_problems_for_both_queries, input_check_names_the_duplicate_key, input_check_is_clean_on_a_good_profile, input_problem_checklist_is_one_cited_row, decide_carries_status_and_citations, status_projects_the_result, checklist_item_for_a_holding_way, checklist_item_for_a_failing_way_names_the_key, checklist_has_six_rows_without_a_claim, decision_is_resolvable_on_every_subject, status_values_are_the_final_atoms, profile_keys_are_the_twenty_contract_keys, what_if_contract_necessary_flips_to_eligible, what_if_contract_not_necessary_flips_to_ineligible, what_if_removing_the_consent_statement_refers, what_if_settles_the_balance, what_if_replaces_a_duplicated_key, what_if_on_a_partial_list_reports_the_profile, what_if_gives_exactly_one_solution]).
cp_test_fail_names([claimed_consent_refused_is_not_eligible, claimed_contract_holds_is_not_ineligible, claimed_contract_not_necessary_is_not_eligible, claimed_legal_obligation_law_refused_is_not_eligible, claimed_vital_interests_not_necessary_is_not_eligible, claimed_public_interest_task_law_absent_is_not_eligible, claimed_legitimate_interests_overridden_is_not_eligible, claimed_legitimate_interests_public_authority_is_not_eligible, the_child_is_never_named_missing, every_way_failing_is_not_eligible, an_outside_fact_is_never_named_missing, no_referral_context_holds_a_provenance_item, purpose_not_compatible_is_not_compatible_answer, purpose_factor_left_out_is_not_purpose_compatible, an_absent_factor_key_is_never_named]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
