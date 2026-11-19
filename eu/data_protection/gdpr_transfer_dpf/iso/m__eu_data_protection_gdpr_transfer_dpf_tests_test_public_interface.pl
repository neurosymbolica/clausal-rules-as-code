% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_gdpr_transfer_dpf, [decide_gdpr_transfer_dpf/2, gdpr_transfer_dpf_status/2, gdpr_transfer_dpf_checklist/2, gdpr_transfer_dpf_decision_resolvable/1, gdpr_transfer_dpf_status_values/1, data_privacy_framework_adequacy/4]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_fixtures, [gdpr_transfer_dpf_subject/1, gdpr_transfer_dpf_profile_for/2, gdpr_transfer_dpf_assess/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_kernel, [gdpr_transfer_dpf_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_queries, [gdpr_transfer_dpf_what_if/4, gdpr_transfer_dpf_compliance_check/2, gdpr_transfer_dpf_profile_keys/1]).

expected(all_conditions_hold, covered_by_data_privacy_framework_adequacy, [data_privacy_framework_decision_in_force, recipient_on_data_privacy_framework_list, certification_covers_transferred_data], [cite(eu_dec_2023_1795_art_1), cite(eu_reg_2016_679_art_45_1)]).
expected(not_from_union, not_covered_by_data_privacy_framework_adequacy, [], [cite(eu_dec_2023_1795_art_1)]).
expected(recipient_outside_united_states, not_covered_by_data_privacy_framework_adequacy, [], [cite(eu_dec_2023_1795_art_1)]).
expected(decision_not_in_force, not_covered_by_data_privacy_framework_adequacy, [data_privacy_framework_decision_in_force], [cite(eu_dec_2023_1795_art_1)]).
expected(recipient_off_list, not_covered_by_data_privacy_framework_adequacy, [recipient_on_data_privacy_framework_list], [cite(eu_dec_2023_1795_art_1)]).
expected(human_resources_data_not_declared, not_covered_by_data_privacy_framework_adequacy, [certification_covers_transferred_data], [cite(eu_dec_2023_1795_art_1)]).
expected(two_facts_denied, not_covered_by_data_privacy_framework_adequacy, [data_privacy_framework_decision_in_force, certification_covers_transferred_data], [cite(eu_dec_2023_1795_art_1)]).
expected(crisp_false_with_facts_absent, not_covered_by_data_privacy_framework_adequacy, [], [cite(eu_dec_2023_1795_art_1)]).
expected(decision_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_decision_in_force_statement)), [resolution(cite(data_privacy_framework_decision_in_force_statement), not_attempted), inputs_relied_on([data_privacy_framework_decision_in_force - absent])]), [], []).
expected(list_statement_absent_union_absent, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_list_entry_statement)), [resolution(cite(data_privacy_framework_list_entry_statement), not_attempted), inputs_relied_on([recipient_on_data_privacy_framework_list - absent])]), [], []).
expected(coverage_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_certification_coverage_statement)), [resolution(cite(data_privacy_framework_certification_coverage_statement), not_attempted), inputs_relied_on([certification_covers_transferred_data - absent])]), [], []).
expected(union_absent, indeterminate([transfer_from_union]), [], []).
expected(recipient_absent, indeterminate([recipient_is_organisation_in_united_states]), [], []).
expected(bare_boolean_outside_fact, input_problems([wrong_type(recipient_on_data_privacy_framework_list)]), [], []).
expected(duplicate_and_unknown, input_problems([duplicate_key(transfer_from_union), unknown_key(colour)]), [], []).
expected(unbound_attestation_argument, input_problems([wrong_type(certification_covers_transferred_data)]), [], []).
expected(partial_list_profile, input_problems([wrong_type(profile)]), [], []).

subject_answer(Subject, Result, Basis, Citations) :-
    gdpr_transfer_dpf_profile_for(Subject, Profile),
    findall(Answer - Grounds - Cites, data_privacy_framework_adequacy(Profile, Answer, Grounds, Cites), Answers),
    length(Answers, 1),
    Answers = [Result - Basis - Citations].

basis_keys(Basis, SortedKeys) :-
    findall(FactKey, member(outside_fact(FactKey, _), Basis), FactKeys),
    clausal_msort(FactKeys, SortedKeys).

basis_item_supplied(Profile, outside_fact(FactKey, Attested)) :-
    member(attribute(ProfileKey, ProfileValue), Profile),
    ProfileKey == FactKey,
    ProfileValue == Attested.

subject_matches_expected(Subject) :-
    expected(Subject, ExpectedResult, ExpectedKeys, ExpectedCitations),
    subject_answer(Subject, Result, Basis, Citations),
    Result == ExpectedResult,
    basis_keys(Basis, BasisKeys),
    clausal_msort(ExpectedKeys, SortedExpectedKeys),
    BasisKeys == SortedExpectedKeys,
    length(Basis, BasisLength),
    length(ExpectedKeys, BasisLength),
    clausal_msort(Citations, SortedCitations),
    clausal_msort(ExpectedCitations, SortedExpectedCitations),
    SortedCitations == SortedExpectedCitations,
    gdpr_transfer_dpf_profile_for(Subject, Profile),
    maplist(basis_item_supplied(Profile), Basis).

subject_has_expected(Subject) :-
    findall(Result, expected(Subject, Result, _, _), Results),
    length(Results, 1).

subject_checklist_non_empty(Subject) :-
    gdpr_transfer_dpf_profile_for(Subject, Profile),
    findall(Checklist, gdpr_transfer_dpf_checklist(Profile, Checklist), Checklists),
    length(Checklists, 1),
    Checklists = [[_FirstRow|_OtherRows]].

subject_resolvable(Subject) :-
    gdpr_transfer_dpf_profile_for(Subject, Profile),
    gdpr_transfer_dpf_decision_resolvable(Profile).

test(every_subject_has_one_expected_answer) :-
    findall(Subject, gdpr_transfer_dpf_subject(Subject), Subjects),
    length(Subjects, 17),
    maplist(subject_has_expected, Subjects).
test(every_subject_resolves_to_its_expected_answer) :-
    findall(Subject, gdpr_transfer_dpf_subject(Subject), Subjects),
    maplist(subject_matches_expected, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, gdpr_transfer_dpf_subject(Subject), Subjects),
    maplist(subject_checklist_non_empty, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, gdpr_transfer_dpf_subject(Subject), Subjects),
    maplist(subject_resolvable, Subjects).
test(all_conditions_hold_is_covered) :-
    subject_matches_expected(all_conditions_hold).
test(not_from_union_is_not_covered) :-
    subject_matches_expected(not_from_union).
test(recipient_outside_united_states_is_not_covered) :-
    subject_matches_expected(recipient_outside_united_states).
test(decision_not_in_force_is_not_covered) :-
    subject_matches_expected(decision_not_in_force).
test(recipient_off_list_is_not_covered) :-
    subject_matches_expected(recipient_off_list).
test(human_resources_data_not_declared_is_not_covered) :-
    subject_matches_expected(human_resources_data_not_declared).
test(two_facts_denied_lists_both_in_the_basis) :-
    subject_matches_expected(two_facts_denied).
test(crisp_false_with_facts_absent_is_not_covered) :-
    subject_matches_expected(crisp_false_with_facts_absent).
test(decision_statement_absent_is_referred) :-
    subject_matches_expected(decision_statement_absent).
test(list_statement_absent_is_referred_before_a_missing_crisp_key) :-
    subject_matches_expected(list_statement_absent_union_absent).
test(coverage_statement_absent_is_referred) :-
    subject_matches_expected(coverage_statement_absent).
test(union_absent_is_indeterminate) :-
    subject_matches_expected(union_absent).
test(recipient_absent_is_indeterminate) :-
    subject_matches_expected(recipient_absent).
test(bare_boolean_outside_fact_is_an_input_problem) :-
    subject_matches_expected(bare_boolean_outside_fact).
test(duplicate_comes_before_unknown) :-
    subject_matches_expected(duplicate_and_unknown).
test(unbound_attestation_argument_is_an_input_problem) :-
    subject_matches_expected(unbound_attestation_argument).
test(partial_list_is_not_a_profile) :-
    subject_matches_expected(partial_list_profile).
test(assess_all_conditions_hold) :-
    gdpr_transfer_dpf_assess(all_conditions_hold, gdpr_transfer_dpf_verdict(covered_by_data_privacy_framework_adequacy, _Citations)).
test(assess_all_conditions_hold_is_final) :-
    gdpr_transfer_dpf_profile_for(all_conditions_hold, Profile),
    gdpr_transfer_dpf_status(Profile, Status),
    gdpr_transfer_dpf_status_values(StatusValues),
    member(Status, StatusValues).
test(assess_not_from_union) :-
    gdpr_transfer_dpf_assess(not_from_union, gdpr_transfer_dpf_verdict(not_covered_by_data_privacy_framework_adequacy, [cite(eu_dec_2023_1795_art_1)])).
test(assess_union_absent) :-
    gdpr_transfer_dpf_assess(union_absent, gdpr_transfer_dpf_verdict(indeterminate([transfer_from_union]), [])).
test(decide_through_the_facade) :-
    gdpr_transfer_dpf_profile_for(recipient_off_list, Profile),
    findall(Verdict, decide_gdpr_transfer_dpf(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_transfer_dpf_verdict(not_covered_by_data_privacy_framework_adequacy, [cite(eu_dec_2023_1795_art_1)])].
test(the_input_check_on_a_well_formed_fixture) :-
    gdpr_transfer_dpf_profile_for(all_conditions_hold, Profile),
    findall(Problems, gdpr_transfer_dpf_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(the_input_check_on_a_duplicate_fixture) :-
    gdpr_transfer_dpf_profile_for(duplicate_and_unknown, Profile),
    gdpr_transfer_dpf_input_problems(Profile, [duplicate_key(transfer_from_union), unknown_key(colour)]).
test(url_evidence_is_a_well_formed_attestation) :-
    Attested = attested(true, attestation(host_user, host_time, stated_from_published_record, url('https://www.dataprivacyframework.gov/list', '2026-11-01'))),
    findall(Problems, gdpr_transfer_dpf_input_problems([attribute(recipient_on_data_privacy_framework_list, Attested)], Problems), Answers),
    Answers == [[]].
test(url_evidence_with_an_unbound_argument_is_wrong_type) :-
    findall(Problems, gdpr_transfer_dpf_input_problems([attribute(recipient_on_data_privacy_framework_list, attested(true, attestation(host_user, host_time, stated_from_published_record, url(_RetrievedFrom, '2026-11-01'))))], Problems), Answers),
    Answers == [[wrong_type(recipient_on_data_privacy_framework_list)]].
test(document_evidence_is_a_well_formed_attestation) :-
    Attested = attested(false, attestation(host_user, host_time, stated_from_uploaded_record, document(upload_one, sha_value_one))),
    findall(Problems, gdpr_transfer_dpf_input_problems([attribute(certification_covers_transferred_data, Attested)], Problems), Answers),
    Answers == [[]].
test(document_evidence_with_an_unbound_argument_is_wrong_type) :-
    findall(Problems, gdpr_transfer_dpf_input_problems([attribute(certification_covers_transferred_data, attested(false, attestation(host_user, host_time, stated_from_uploaded_record, document(upload_one, _Digest))))], Problems), Answers),
    Answers == [[wrong_type(certification_covers_transferred_data)]].
test(document_evidence_is_copied_whole_into_a_not_covered_basis) :-
    Denied = attested(false, attestation(host_user, host_time, stated_from_uploaded_record, document(upload_one, sha_value_one))),
    findall(Result - Basis - Citations, data_privacy_framework_adequacy([attribute(certification_covers_transferred_data, Denied)], Result, Basis, Citations), Answers),
    Answers == [not_covered_by_data_privacy_framework_adequacy - [outside_fact(certification_covers_transferred_data, Denied)] - [cite(eu_dec_2023_1795_art_1)]].
test(url_evidence_is_copied_whole_into_a_covered_basis) :-
    Affirmed = attested(true, attestation(host_user, host_time, stated_from_published_record, url('https://www.dataprivacyframework.gov/list', '2026-11-01'))),
    findall(Result - Basis - Citations, data_privacy_framework_adequacy([attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)], Result, Basis, Citations), Answers),
    Answers == [covered_by_data_privacy_framework_adequacy - [outside_fact(data_privacy_framework_decision_in_force, Affirmed), outside_fact(recipient_on_data_privacy_framework_list, Affirmed), outside_fact(certification_covers_transferred_data, Affirmed)] - [cite(eu_dec_2023_1795_art_1), cite(eu_reg_2016_679_art_45_1)]].
test(stating_an_absent_fact_true_keeps_a_not_covered_answer) :-
    gdpr_transfer_dpf_profile_for(crisp_false_with_facts_absent, Profile),
    gdpr_transfer_dpf_what_if(Profile, data_privacy_framework_decision_in_force, attested(true, attestation(by, at, reason, none)), not_covered_by_data_privacy_framework_adequacy).
test(stating_an_absent_fact_false_keeps_a_not_covered_answer) :-
    gdpr_transfer_dpf_profile_for(crisp_false_with_facts_absent, Profile),
    gdpr_transfer_dpf_what_if(Profile, recipient_is_organisation_in_united_states, true, not_covered_by_data_privacy_framework_adequacy).
test(stating_the_missing_union_key_true_covers) :-
    gdpr_transfer_dpf_profile_for(union_absent, Profile),
    gdpr_transfer_dpf_what_if(Profile, transfer_from_union, true, covered_by_data_privacy_framework_adequacy).
test(stating_the_missing_union_key_false_does_not_cover) :-
    gdpr_transfer_dpf_profile_for(union_absent, Profile),
    gdpr_transfer_dpf_what_if(Profile, transfer_from_union, false, not_covered_by_data_privacy_framework_adequacy).
test(the_profile_keys_through_the_queries_layer) :-
    gdpr_transfer_dpf_profile_keys([transfer_from_union, recipient_is_organisation_in_united_states, data_privacy_framework_decision_in_force, recipient_on_data_privacy_framework_list, certification_covers_transferred_data]).
test(compliance_covered_fixture_needs_no_specific_authorisation) :-
    gdpr_transfer_dpf_profile_for(all_conditions_hold, Profile),
    findall(Answer, gdpr_transfer_dpf_compliance_check(Profile, Answer), Answers),
    Answers == [no_specific_authorisation_required].
test(compliance_near_miss_is_not_established_by_this_decision) :-
    gdpr_transfer_dpf_profile_for(recipient_off_list, Profile),
    gdpr_transfer_dpf_compliance_check(Profile, not_established_by_this_decision).
test(compliance_passes_an_indeterminate_status_through) :-
    gdpr_transfer_dpf_profile_for(recipient_absent, Profile),
    gdpr_transfer_dpf_compliance_check(Profile, indeterminate([recipient_is_organisation_in_united_states])).

test(all_conditions_hold_is_not_not_covered, fail) :-
    gdpr_transfer_dpf_assess(all_conditions_hold, gdpr_transfer_dpf_verdict(not_covered_by_data_privacy_framework_adequacy, _)).
test(not_from_union_is_not_covered_rather_than_covered, fail) :-
    gdpr_transfer_dpf_assess(not_from_union, gdpr_transfer_dpf_verdict(covered_by_data_privacy_framework_adequacy, _)).
test(recipient_outside_united_states_is_not_covered_rather_than_covered, fail) :-
    gdpr_transfer_dpf_assess(recipient_outside_united_states, gdpr_transfer_dpf_verdict(covered_by_data_privacy_framework_adequacy, _)).
test(decision_not_in_force_is_not_covered_rather_than_covered, fail) :-
    gdpr_transfer_dpf_assess(decision_not_in_force, gdpr_transfer_dpf_verdict(covered_by_data_privacy_framework_adequacy, _)).
test(recipient_off_list_is_not_covered_rather_than_covered, fail) :-
    gdpr_transfer_dpf_assess(recipient_off_list, gdpr_transfer_dpf_verdict(covered_by_data_privacy_framework_adequacy, _)).
test(human_resources_data_not_declared_is_not_covered_rather_than_covered, fail) :-
    gdpr_transfer_dpf_assess(human_resources_data_not_declared, gdpr_transfer_dpf_verdict(covered_by_data_privacy_framework_adequacy, _)).
test(list_statement_absent_does_not_name_the_crisp_key, fail) :-
    gdpr_transfer_dpf_assess(list_statement_absent_union_absent, gdpr_transfer_dpf_verdict(indeterminate(_), _)).
test(union_absent_is_not_covered_yet, fail) :-
    gdpr_transfer_dpf_assess(union_absent, gdpr_transfer_dpf_verdict(covered_by_data_privacy_framework_adequacy, _)).
test(bare_boolean_outside_fact_is_not_covered_yet, fail) :-
    gdpr_transfer_dpf_assess(bare_boolean_outside_fact, gdpr_transfer_dpf_verdict(covered_by_data_privacy_framework_adequacy, _)).
test(a_well_formed_fixture_has_no_problem_reported, fail) :-
    gdpr_transfer_dpf_profile_for(all_conditions_hold, Profile),
    gdpr_transfer_dpf_input_problems(Profile, [_|_]).
test(compliance_near_miss_is_not_reported_as_allowed, fail) :-
    gdpr_transfer_dpf_profile_for(recipient_off_list, Profile),
    gdpr_transfer_dpf_compliance_check(Profile, no_specific_authorisation_required).

cp_test_names([every_subject_has_one_expected_answer, every_subject_resolves_to_its_expected_answer, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, all_conditions_hold_is_covered, not_from_union_is_not_covered, recipient_outside_united_states_is_not_covered, decision_not_in_force_is_not_covered, recipient_off_list_is_not_covered, human_resources_data_not_declared_is_not_covered, two_facts_denied_lists_both_in_the_basis, crisp_false_with_facts_absent_is_not_covered, decision_statement_absent_is_referred, list_statement_absent_is_referred_before_a_missing_crisp_key, coverage_statement_absent_is_referred, union_absent_is_indeterminate, recipient_absent_is_indeterminate, bare_boolean_outside_fact_is_an_input_problem, duplicate_comes_before_unknown, unbound_attestation_argument_is_an_input_problem, partial_list_is_not_a_profile, assess_all_conditions_hold, assess_all_conditions_hold_is_final, assess_not_from_union, assess_union_absent, decide_through_the_facade, the_input_check_on_a_well_formed_fixture, the_input_check_on_a_duplicate_fixture, url_evidence_is_a_well_formed_attestation, url_evidence_with_an_unbound_argument_is_wrong_type, document_evidence_is_a_well_formed_attestation, document_evidence_with_an_unbound_argument_is_wrong_type, document_evidence_is_copied_whole_into_a_not_covered_basis, url_evidence_is_copied_whole_into_a_covered_basis, stating_an_absent_fact_true_keeps_a_not_covered_answer, stating_an_absent_fact_false_keeps_a_not_covered_answer, stating_the_missing_union_key_true_covers, stating_the_missing_union_key_false_does_not_cover, the_profile_keys_through_the_queries_layer, compliance_covered_fixture_needs_no_specific_authorisation, compliance_near_miss_is_not_established_by_this_decision, compliance_passes_an_indeterminate_status_through]).
cp_test_fail_names([all_conditions_hold_is_not_not_covered, not_from_union_is_not_covered_rather_than_covered, recipient_outside_united_states_is_not_covered_rather_than_covered, decision_not_in_force_is_not_covered_rather_than_covered, recipient_off_list_is_not_covered_rather_than_covered, human_resources_data_not_declared_is_not_covered_rather_than_covered, list_statement_absent_does_not_name_the_crisp_key, union_absent_is_not_covered_yet, bare_boolean_outside_fact_is_not_covered_yet, a_well_formed_fixture_has_no_problem_reported, compliance_near_miss_is_not_reported_as_allowed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
