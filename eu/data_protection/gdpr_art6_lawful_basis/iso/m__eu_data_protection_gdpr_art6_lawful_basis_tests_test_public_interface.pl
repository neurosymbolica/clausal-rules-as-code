% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [decide_gdpr_art6_lawful_basis/2, gdpr_art6_lawful_basis_status/2, gdpr_art6_lawful_basis_checklist/2, gdpr_art6_lawful_basis_decision_resolvable/1, gdpr_art6_lawful_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_subject/1, gdpr_art6_lawful_basis_profile_for/2, gdpr_art6_lawful_basis_assess/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_queries, [gdpr_art6_lawful_basis_what_if/4, gdpr_art6_lawful_basis_profile_keys/1]).

host_statement(Value, attested(Value, attestation(host_system, recorded_moment, stated_by_host, none))).

expected_status(consent_claimed_attested_true, eligible).
expected_status(consent_claimed_attested_false, ineligible).
expected_status(contract_claimed_necessary, eligible).
expected_status(contract_claimed_not_necessary, ineligible).
expected_status(legal_obligation_laid_down_by_law_true, eligible).
expected_status(legal_obligation_laid_down_by_law_false, ineligible).
expected_status(vital_interests_claimed_necessary, eligible).
expected_status(vital_interests_claimed_not_necessary, ineligible).
expected_status(public_interest_task_laid_down_by_law_true, eligible).
expected_status(public_interest_task_not_necessary, ineligible).
expected_status(legitimate_interests_balance_for_controller, eligible).
expected_status(legitimate_interests_public_authority, ineligible).
expected_status(legitimate_interests_overridden, ineligible).
expected_status(two_ways_hold_with_special_category, eligible).
expected_status(contract_alone_unclaimed, eligible).
expected_status(empty_profile, indeterminate([contract_necessary])).
expected_status(consent_statement_attested_for_last_open_way, eligible).
expected_status(consent_statement_absent_for_last_open_way, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])])).
expected_status(legal_obligation_law_statement_absent_one_step, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), [resolution(cite(legal_obligation_law_statement), not_attempted), inputs_relied_on([legal_obligation_laid_down_by_law - absent])])).
expected_status(public_authority_question_missing_beside_unsure, indeterminate([processing_by_public_authority_in_its_tasks])).
expected_status(public_task_necessity_unsure_after_authority_stated, needs_legal_review(open_textured(public_interest_task_necessary, cite(eu_reg_2016_679_art_6_1_e)), [inputs_relied_on([consent_given_and_conditions_met - Refused, contract_necessary - false, legal_obligation_necessary - false, vital_interests_necessary - false, public_interest_task_necessary - unsure, public_interest_task_laid_down_by_law - LawStated, processing_by_public_authority_in_its_tasks - true])])) :-
    host_statement(false, Refused),
    host_statement(true, LawStated).
expected_status(legal_obligation_unsure_law_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), [resolution(cite(legal_obligation_law_statement), not_attempted), inputs_relied_on([legal_obligation_laid_down_by_law - absent])])).
expected_status(legal_obligation_unsure_law_statement_attested, needs_legal_review(open_textured(legal_obligation_necessary, cite(eu_reg_2016_679_art_6_1_c)), [inputs_relied_on([basis_claimed - legal_obligation, legal_obligation_necessary - unsure, legal_obligation_laid_down_by_law - LawStated])])) :-
    host_statement(true, LawStated).
expected_status(legitimate_interests_balance_unsure, needs_legal_review(open_textured(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)), [inputs_relied_on([basis_claimed - legitimate_interests, processing_by_public_authority_in_its_tasks - false, legitimate_interests_pursued - true, interests_overridden - unsure, child_data_subject - Child])])) :-
    host_statement(true, Child).
expected_status(duplicate_contract_key, input_problems([duplicate_key(contract_necessary)])).
expected_status(bare_outside_fact_value, input_problems([wrong_type(consent_given_and_conditions_met)])).
expected_status(attested_judgement_value, input_problems([wrong_type(contract_necessary)])).
expected_status(crisp_key_given_unsure, input_problems([wrong_type(processing_by_public_authority_in_its_tasks)])).
expected_status(basis_claimed_outside_its_list, input_problems([wrong_type(basis_claimed)])).
expected_status(unknown_and_numeric_keys, input_problems([unknown_key(favourite_colour), unknown_key(42)])).
expected_status(unbound_attestation_argument, input_problems([wrong_type(consent_given_and_conditions_met)])).
expected_status(partial_list_profile, input_problems([wrong_type(profile)])).
expected_status(new_purpose_not_engaged, indeterminate([contract_necessary])).
expected_status(new_purpose_absent, indeterminate([contract_necessary])).
expected_status(new_purpose_compatible, indeterminate([contract_necessary])).
expected_status(new_purpose_not_compatible, indeterminate([contract_necessary])).
expected_status(new_purpose_compatibility_absent, indeterminate([contract_necessary])).
expected_status(new_purpose_compatibility_unsure, indeterminate([contract_necessary])).

expected_final(consent_claimed_attested_true, eligible, [outside_fact(consent_given_and_conditions_met, Consent)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]) :-
    host_statement(true, Consent).
expected_final(consent_claimed_attested_false, ineligible, [outside_fact(consent_given_and_conditions_met, Refused)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]) :-
    host_statement(false, Refused).
expected_final(contract_claimed_necessary, eligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
expected_final(contract_claimed_not_necessary, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
expected_final(legal_obligation_laid_down_by_law_true, eligible, [outside_fact(legal_obligation_laid_down_by_law, LawStated)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]) :-
    host_statement(true, LawStated).
expected_final(legal_obligation_laid_down_by_law_false, ineligible, [outside_fact(legal_obligation_laid_down_by_law, LawRefused)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]) :-
    host_statement(false, LawRefused).
expected_final(vital_interests_claimed_necessary, eligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_d)]).
expected_final(vital_interests_claimed_not_necessary, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_d)]).
expected_final(public_interest_task_laid_down_by_law_true, eligible, [outside_fact(public_interest_task_laid_down_by_law, LawStated)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_3)]) :-
    host_statement(true, LawStated).
expected_final(public_interest_task_not_necessary, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_e)]).
expected_final(legitimate_interests_balance_for_controller, eligible, [flagged(child_data_subject, Child), flagged(special_category, Special)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]) :-
    host_statement(true, Child),
    host_statement(true, Special).
expected_final(legitimate_interests_public_authority, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
expected_final(legitimate_interests_overridden, ineligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f)]).
expected_final(two_ways_hold_with_special_category, eligible, [flagged(special_category, Special)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b), cite(eu_reg_2016_679_art_6_1_d)]) :-
    host_statement(true, Special).
expected_final(contract_alone_unclaimed, eligible, [], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
expected_final(consent_statement_attested_for_last_open_way, eligible, [outside_fact(consent_given_and_conditions_met, Consent)], [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)]) :-
    host_statement(true, Consent).

expected_compatibility(new_purpose_not_engaged, compatibility_test_not_engaged, [cite(eu_reg_2016_679_art_6_4)]).
expected_compatibility(new_purpose_absent, indeterminate([new_purpose_processing]), []).
expected_compatibility(new_purpose_compatible, purpose_compatible, [cite(eu_reg_2016_679_art_6_4)]).
expected_compatibility(new_purpose_not_compatible, purpose_not_compatible, [cite(eu_reg_2016_679_art_6_4)]).
expected_compatibility(new_purpose_compatibility_absent, indeterminate([compatible_purpose]), []).
expected_compatibility(new_purpose_compatibility_unsure, needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing - true, compatible_purpose - unsure])]), []).

final_matches(Subject, Result, Basis, Citations) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    findall(Found - FoundBasis - FoundCitations, lawful_basis_status(Profile, Found, FoundBasis, FoundCitations), Answers),
    Answers = [Single - SingleBasis - SingleCitations],
    Single == Result,
    SingleBasis == Basis,
    sort(SingleCitations, SortedCitations),
    sort(Citations, SortedCitations).

compatibility_matches(Subject, Result, Citations) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    findall(Found - FoundBasis - FoundCitations, purpose_compatibility(Profile, Found, FoundBasis, FoundCitations), Answers),
    Answers == [Result - [] - Citations].

not_final_matches(Subject) :-
    expected_status(Subject, Result),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    findall(Found - FoundBasis - FoundCitations, lawful_basis_status(Profile, Found, FoundBasis, FoundCitations), Answers),
    Answers == [Result - [] - []].

test(every_fixture_subject_gets_exactly_its_expected_status) :-
    findall(Subject - Status, (gdpr_art6_lawful_basis_subject(Subject), gdpr_art6_lawful_basis_assess(Subject, gdpr_art6_lawful_basis_verdict(Status, _))), Answers),
    findall(ExpectedSubject - ExpectedStatus, expected_status(ExpectedSubject, ExpectedStatus), Expected),
    msort(Answers, SortedAnswers),
    msort(Expected, SortedExpected),
    SortedAnswers == SortedExpected.
test(every_final_subject_carries_its_basis_and_citations) :-
    findall(Subject, expected_final(Subject, _, _, _), Subjects),
    findall(Matched, (expected_final(Matched, Result, Basis, Citations), final_matches(Matched, Result, Basis, Citations)), MatchedSubjects),
    MatchedSubjects == Subjects.
test(final_statuses_are_in_the_status_vocabulary) :-
    gdpr_art6_lawful_basis_status_values(StatusValues),
    findall(Subject, expected_final(Subject, _, _, _), Subjects),
    findall(Listed, (expected_final(Listed, _, _, _), gdpr_art6_lawful_basis_assess(Listed, gdpr_art6_lawful_basis_verdict(Status, [_|_])), member(Status, StatusValues)), ListedSubjects),
    ListedSubjects == Subjects.
test(not_final_answers_carry_empty_basis_and_citations) :-
    not_final_matches(empty_profile),
    not_final_matches(consent_statement_absent_for_last_open_way),
    not_final_matches(legal_obligation_law_statement_absent_one_step),
    not_final_matches(public_authority_question_missing_beside_unsure),
    not_final_matches(public_task_necessity_unsure_after_authority_stated),
    not_final_matches(legal_obligation_unsure_law_statement_absent),
    not_final_matches(legal_obligation_unsure_law_statement_attested),
    not_final_matches(legitimate_interests_balance_unsure),
    not_final_matches(duplicate_contract_key),
    not_final_matches(partial_list_profile).
test(every_compatibility_subject_gets_its_answer_once) :-
    findall(Subject, expected_compatibility(Subject, _, _), Subjects),
    findall(Matched, (expected_compatibility(Matched, Result, Citations), compatibility_matches(Matched, Result, Citations)), MatchedSubjects),
    MatchedSubjects == Subjects.
test(every_fixture_subject_is_resolvable_with_a_non_empty_checklist) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    findall(Resolved, (gdpr_art6_lawful_basis_subject(Resolved), gdpr_art6_lawful_basis_profile_for(Resolved, Profile), gdpr_art6_lawful_basis_decision_resolvable(Profile), gdpr_art6_lawful_basis_checklist(Profile, [_|_])), ResolvedSubjects),
    ResolvedSubjects == Subjects.
test(consent_attested_true_is_eligible) :-
    gdpr_art6_lawful_basis_assess(consent_claimed_attested_true, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(consent_attested_false_is_ineligible) :-
    gdpr_art6_lawful_basis_assess(consent_claimed_attested_false, gdpr_art6_lawful_basis_verdict(ineligible, _)).
test(contract_necessary_is_eligible) :-
    gdpr_art6_lawful_basis_assess(contract_claimed_necessary, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(contract_not_necessary_is_ineligible) :-
    gdpr_art6_lawful_basis_assess(contract_claimed_not_necessary, gdpr_art6_lawful_basis_verdict(ineligible, _)).
test(legal_obligation_with_its_law_is_eligible) :-
    gdpr_art6_lawful_basis_assess(legal_obligation_laid_down_by_law_true, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(legal_obligation_without_its_law_is_ineligible) :-
    gdpr_art6_lawful_basis_assess(legal_obligation_laid_down_by_law_false, gdpr_art6_lawful_basis_verdict(ineligible, _)).
test(vital_interests_necessary_is_eligible) :-
    gdpr_art6_lawful_basis_assess(vital_interests_claimed_necessary, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(vital_interests_not_necessary_is_ineligible) :-
    gdpr_art6_lawful_basis_assess(vital_interests_claimed_not_necessary, gdpr_art6_lawful_basis_verdict(ineligible, _)).
test(public_task_with_its_law_is_eligible) :-
    gdpr_art6_lawful_basis_assess(public_interest_task_laid_down_by_law_true, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(public_task_not_necessary_is_ineligible) :-
    gdpr_art6_lawful_basis_assess(public_interest_task_not_necessary, gdpr_art6_lawful_basis_verdict(ineligible, _)).
test(balance_for_the_controller_is_eligible) :-
    gdpr_art6_lawful_basis_assess(legitimate_interests_balance_for_controller, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(public_authority_cannot_rely_on_point_f) :-
    gdpr_art6_lawful_basis_assess(legitimate_interests_public_authority, gdpr_art6_lawful_basis_verdict(ineligible, _)).
test(overridden_interests_are_ineligible) :-
    gdpr_art6_lawful_basis_assess(legitimate_interests_overridden, gdpr_art6_lawful_basis_verdict(ineligible, _)).
test(empty_profile_asks_for_the_contract_judgement) :-
    gdpr_art6_lawful_basis_status_of(empty_profile, indeterminate([contract_necessary])).
test(contract_stated_settles_the_empty_profile) :-
    gdpr_art6_lawful_basis_status_of(contract_alone_unclaimed, eligible).
test(absent_consent_statement_is_referred) :-
    gdpr_art6_lawful_basis_status_of(consent_statement_absent_for_last_open_way, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), _)).
test(attested_consent_statement_settles_the_referral) :-
    gdpr_art6_lawful_basis_status_of(consent_statement_attested_for_last_open_way, eligible).
test(missing_crisp_key_comes_before_the_unsure_judgement) :-
    gdpr_art6_lawful_basis_status_of(public_authority_question_missing_beside_unsure, indeterminate([processing_by_public_authority_in_its_tasks])).
test(stated_crisp_key_leaves_the_unsure_judgement_to_a_lawyer) :-
    gdpr_art6_lawful_basis_status_of(public_task_necessity_unsure_after_authority_stated, needs_legal_review(open_textured(public_interest_task_necessary, cite(eu_reg_2016_679_art_6_1_e)), _)).
test(absent_law_statement_comes_before_the_unsure_judgement) :-
    gdpr_art6_lawful_basis_status_of(legal_obligation_unsure_law_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), _)).
test(attested_law_statement_leaves_the_unsure_judgement_to_a_lawyer) :-
    gdpr_art6_lawful_basis_status_of(legal_obligation_unsure_law_statement_attested, needs_legal_review(open_textured(legal_obligation_necessary, cite(eu_reg_2016_679_art_6_1_c)), _)).
test(a_well_formed_profile_has_no_input_problem) :-
    gdpr_art6_lawful_basis_profile_for(legitimate_interests_balance_for_controller, Profile),
    findall(Problems, gdpr_art6_lawful_basis_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(duplicate_key_is_never_also_wrong_type) :-
    gdpr_art6_lawful_basis_profile_for(duplicate_contract_key, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, [duplicate_key(contract_necessary)]).
test(input_problems_give_a_one_item_checklist) :-
    gdpr_art6_lawful_basis_profile_for(duplicate_contract_key, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, [item(input_check, unmet(input_problems([duplicate_key(contract_necessary)])), cite(eu_reg_2016_679_art_6_1))]).
test(input_problems_also_answer_purpose_compatibility) :-
    gdpr_art6_lawful_basis_profile_for(crisp_key_given_unsure, Profile),
    purpose_compatibility(Profile, input_problems([wrong_type(processing_by_public_authority_in_its_tasks)]), [], []).
test(url_evidence_is_well_formed) :-
    Attested = attested(true, attestation(host_system, recorded_moment, stated_by_host, url(source_address, retrieved_moment))),
    findall(Problems, gdpr_art6_lawful_basis_input_problems([attribute(consent_given_and_conditions_met, Attested)], Problems), Answers),
    Answers == [[]].
test(url_evidence_is_copied_unchanged_into_basis) :-
    Attested = attested(true, attestation(host_system, recorded_moment, stated_by_host, url(source_address, retrieved_moment))),
    findall(Result - Basis, lawful_basis_status([attribute(consent_given_and_conditions_met, Attested)], Result, Basis, _), Answers),
    Answers == [eligible - [outside_fact(consent_given_and_conditions_met, Attested)]].
test(url_evidence_in_a_three_argument_attestation_is_wrong_type) :-
    Attested = attested(true, attestation(host_system, recorded_moment, url(source_address, retrieved_moment))),
    gdpr_art6_lawful_basis_input_problems([attribute(consent_given_and_conditions_met, Attested)], [wrong_type(consent_given_and_conditions_met)]).
test(document_evidence_is_well_formed) :-
    Attested = attested(false, attestation(host_system, recorded_moment, stated_by_host, document(upload_identifier, content_hash))),
    findall(Problems, gdpr_art6_lawful_basis_input_problems([attribute(legal_obligation_laid_down_by_law, Attested)], Problems), Answers),
    Answers == [[]].
test(document_evidence_attested_false_is_copied_into_ineligible_basis) :-
    Attested = attested(false, attestation(host_system, recorded_moment, stated_by_host, document(upload_identifier, content_hash))),
    Profile = [attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true), attribute(legal_obligation_laid_down_by_law, Attested)],
    findall(Result - Basis, lawful_basis_status(Profile, Result, Basis, _), Answers),
    Answers == [ineligible - [outside_fact(legal_obligation_laid_down_by_law, Attested)]].
test(provenance_follows_inputs_relied_on_in_the_context) :-
    gdpr_art6_lawful_basis_profile_for(legitimate_interests_balance_unsure, Profile),
    lawful_basis_status(Profile, needs_legal_review(Reason, Context), [], []),
    append(Context, [provenance(step_six, [cite(eu_reg_2016_679_art_6_1)])], Extended),
    Extended = [inputs_relied_on(Pairs), provenance(Clause, ProvenanceCitations)],
    Reason = open_textured(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)),
    Clause == step_six,
    ProvenanceCitations == [cite(eu_reg_2016_679_art_6_1)],
    member(interests_overridden - unsure, Pairs).
test(checklist_marks_the_holding_way_met_with_its_citation) :-
    gdpr_art6_lawful_basis_profile_for(legitimate_interests_balance_for_controller, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, Items),
    length(Items, 6),
    member(item(point_f, met, cite(eu_reg_2016_679_art_6_1_f)), Items),
    member(item(point_a, inapplicable, cite(eu_reg_2016_679_art_6_1_a)), Items).
test(checklist_names_the_unresolved_keys_of_an_open_way) :-
    gdpr_art6_lawful_basis_profile_for(empty_profile, Profile),
    gdpr_art6_lawful_basis_checklist(Profile, Items),
    member(item(point_c, unknown([legal_obligation_necessary, legal_obligation_laid_down_by_law]), cite(eu_reg_2016_679_art_6_1_c)), Items).
test(status_projection_equals_the_verdict_status) :-
    gdpr_art6_lawful_basis_profile_for(two_ways_hold_with_special_category, Profile),
    gdpr_art6_lawful_basis_status(Profile, eligible),
    decide_gdpr_art6_lawful_basis(Profile, gdpr_art6_lawful_basis_verdict(eligible, [_|_])).
test(what_if_flips_the_near_miss_back) :-
    gdpr_art6_lawful_basis_profile_for(legitimate_interests_overridden, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, interests_overridden, false, eligible).
test(what_if_unflipped_stays_ineligible) :-
    gdpr_art6_lawful_basis_profile_for(legitimate_interests_overridden, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, interests_overridden, true, ineligible).
test(profile_keys_are_fifteen) :-
    gdpr_art6_lawful_basis_profile_keys(ProfileKeys),
    length(ProfileKeys, 15).

test(consent_attested_false_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_assess(consent_claimed_attested_false, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(contract_not_necessary_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_assess(contract_claimed_not_necessary, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(legal_obligation_without_its_law_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_assess(legal_obligation_laid_down_by_law_false, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(vital_interests_not_necessary_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_assess(vital_interests_claimed_not_necessary, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(public_task_not_necessary_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_assess(public_interest_task_not_necessary, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(public_authority_is_not_eligible_on_point_f, fail) :-
    gdpr_art6_lawful_basis_assess(legitimate_interests_public_authority, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(overridden_interests_are_not_eligible, fail) :-
    gdpr_art6_lawful_basis_assess(legitimate_interests_overridden, gdpr_art6_lawful_basis_verdict(eligible, _)).
test(empty_profile_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_status_of(empty_profile, eligible).
test(absent_consent_statement_is_not_ineligible, fail) :-
    gdpr_art6_lawful_basis_status_of(consent_statement_absent_for_last_open_way, ineligible).
test(unsure_balance_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_status_of(legitimate_interests_balance_unsure, eligible).
test(input_problems_are_not_eligible, fail) :-
    gdpr_art6_lawful_basis_status_of(basis_claimed_outside_its_list, eligible).
test(document_evidence_attested_false_is_not_eligible, fail) :-
    Attested = attested(false, attestation(host_system, recorded_moment, stated_by_host, document(upload_identifier, content_hash))),
    lawful_basis_status([attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true), attribute(legal_obligation_laid_down_by_law, Attested)], eligible, _, _).
test(provenance_is_never_inside_the_pairs, fail) :-
    gdpr_art6_lawful_basis_profile_for(legitimate_interests_balance_unsure, Profile),
    lawful_basis_status(Profile, needs_legal_review(_, [inputs_relied_on(Pairs)|_]), [], []),
    member(provenance(_, _), Pairs).

gdpr_art6_lawful_basis_status_of(Subject, Status) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    findall(Found, gdpr_art6_lawful_basis_status(Profile, Found), Answers),
    Answers = [Status].

cp_test_names([every_fixture_subject_gets_exactly_its_expected_status, every_final_subject_carries_its_basis_and_citations, final_statuses_are_in_the_status_vocabulary, not_final_answers_carry_empty_basis_and_citations, every_compatibility_subject_gets_its_answer_once, every_fixture_subject_is_resolvable_with_a_non_empty_checklist, consent_attested_true_is_eligible, consent_attested_false_is_ineligible, contract_necessary_is_eligible, contract_not_necessary_is_ineligible, legal_obligation_with_its_law_is_eligible, legal_obligation_without_its_law_is_ineligible, vital_interests_necessary_is_eligible, vital_interests_not_necessary_is_ineligible, public_task_with_its_law_is_eligible, public_task_not_necessary_is_ineligible, balance_for_the_controller_is_eligible, public_authority_cannot_rely_on_point_f, overridden_interests_are_ineligible, empty_profile_asks_for_the_contract_judgement, contract_stated_settles_the_empty_profile, absent_consent_statement_is_referred, attested_consent_statement_settles_the_referral, missing_crisp_key_comes_before_the_unsure_judgement, stated_crisp_key_leaves_the_unsure_judgement_to_a_lawyer, absent_law_statement_comes_before_the_unsure_judgement, attested_law_statement_leaves_the_unsure_judgement_to_a_lawyer, a_well_formed_profile_has_no_input_problem, duplicate_key_is_never_also_wrong_type, input_problems_give_a_one_item_checklist, input_problems_also_answer_purpose_compatibility, url_evidence_is_well_formed, url_evidence_is_copied_unchanged_into_basis, url_evidence_in_a_three_argument_attestation_is_wrong_type, document_evidence_is_well_formed, document_evidence_attested_false_is_copied_into_ineligible_basis, provenance_follows_inputs_relied_on_in_the_context, checklist_marks_the_holding_way_met_with_its_citation, checklist_names_the_unresolved_keys_of_an_open_way, status_projection_equals_the_verdict_status, what_if_flips_the_near_miss_back, what_if_unflipped_stays_ineligible, profile_keys_are_fifteen]).
cp_test_fail_names([consent_attested_false_is_not_eligible, contract_not_necessary_is_not_eligible, legal_obligation_without_its_law_is_not_eligible, vital_interests_not_necessary_is_not_eligible, public_task_not_necessary_is_not_eligible, public_authority_is_not_eligible_on_point_f, overridden_interests_are_not_eligible, empty_profile_is_not_eligible, absent_consent_statement_is_not_ineligible, unsure_balance_is_not_eligible, input_problems_are_not_eligible, document_evidence_attested_false_is_not_eligible, provenance_is_never_inside_the_pairs]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
