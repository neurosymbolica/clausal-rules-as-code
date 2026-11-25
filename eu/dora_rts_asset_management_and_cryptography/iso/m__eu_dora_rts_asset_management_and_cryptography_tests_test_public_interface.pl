% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_asset_management_and_cryptography_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_dora_rts_asset_management_and_cryptography, [decide_dora_rts_asset_management_and_cryptography/2, dora_rts_asset_management_and_cryptography_status/2, dora_rts_asset_management_and_cryptography_checklist/2, dora_rts_asset_management_and_cryptography_decision_resolvable/1, dora_rts_asset_management_and_cryptography_status_values/1]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_fixtures, [dora_rts_asset_management_and_cryptography_subject/1, dora_rts_asset_management_and_cryptography_profile_for/2, dora_rts_asset_management_and_cryptography_assess/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_dora_rts_asset_management_and_cryptography, [rts_asset_management_and_cryptography_duties_required/3, rts_asset_management_and_cryptography_duties_complete/3, rts_asset_management_and_cryptography_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_kernel, [dora_rts_asset_management_and_cryptography_input_problems/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_queries, [dora_rts_asset_management_and_cryptography_what_if/4]).

expected_status(gate_true_entity, simplified_framework_entity).
expected_status(gate_false_all_performed, complete).
expected_status(gate_absent_entity, indeterminate([financial_entity_is_article_16_1_entity])).
expected_status(microenterprise_all_performed, complete).
expected_status(one_duty_not_performed, incomplete).
expected_status(microenterprise_legacy_records_not_performed, complete).
expected_status(non_microenterprise_legacy_records_not_performed, incomplete).
expected_status(trigger_absent_legacy_records_not_performed, indeterminate([financial_entity_is_microenterprise])).
expected_status(trigger_absent_legacy_records_performed, complete).
expected_status(always_duty_key_absent, indeterminate([ict_asset_management_policy_developed_documented_and_implemented])).
expected_status(false_duty_before_absent_key, incomplete).
expected_status(unsure_judgement_referred, needs_legal_review(open_textured(encryption_policy_has_rules_for_data_in_use_where_necessary, cite(eu_reg_2024_1774_art_6_2_b)), [inputs_relied_on(_)])).
expected_status(absent_key_before_unsure_judgement, indeterminate([certificates_renewed_promptly_before_expiration])).
expected_status(two_duties_not_performed, incomplete).
expected_status(duplicate_and_unknown_keys, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(foreign_contract_key)])).
expected_status(gate_given_unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
expected_status(not_an_attribute_list, input_problems([wrong_type(profile)])).

assessed_status(Subject, Status) :-
    dora_rts_asset_management_and_cryptography_assess(Subject, dora_rts_asset_management_and_cryptography_verdict(Status, _)).

status_matches(Subject - ExpectedStatus) :-
    assessed_status(Subject, Status),
    Status = ExpectedStatus.

one_answer_each(Subject) :-
    dora_rts_asset_management_and_cryptography_profile_for(Subject, Profile),
    findall(Verdict, decide_dora_rts_asset_management_and_cryptography(Profile, Verdict), Verdicts),
    length(Verdicts, 1),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_required(Profile, Result, Citations), RequiredAnswers),
    length(RequiredAnswers, 1),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations), CompleteAnswers),
    length(CompleteAnswers, 1),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_outstanding(Profile, Result, Citations), OutstandingAnswers),
    length(OutstandingAnswers, 1),
    findall(Problems, dora_rts_asset_management_and_cryptography_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1).

status_in_vocabulary(Subject) :-
    assessed_status(Subject, Status),
    functor(Status, StatusName, _),
    dora_rts_asset_management_and_cryptography_status_values(StatusValues),
    member(StatusName, StatusValues).

checklist_matches(Subject) :-
    dora_rts_asset_management_and_cryptography_profile_for(Subject, Profile),
    dora_rts_asset_management_and_cryptography_decision_resolvable(Profile),
    dora_rts_asset_management_and_cryptography_input_problems(Profile, Problems),
    checklist_for_problems(Problems, Profile).

checklist_for_problems([], Profile) :-
    dora_rts_asset_management_and_cryptography_checklist(Profile, [_|_]).
checklist_for_problems([_|_], Profile) :-
    dora_rts_asset_management_and_cryptography_checklist(Profile, []).

all_subjects(Subjects) :-
    findall(Subject, dora_rts_asset_management_and_cryptography_subject(Subject), Subjects).

context_item_name(inputs_relied_on(_), inputs_relied_on).
context_item_name(provenance(_, _), provenance).

test(every_subject_has_an_expected_status) :-
    all_subjects(Subjects),
    sort(Subjects, SortedSubjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    sort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(each_subject_resolves_to_its_expected_status) :-
    findall(Subject - ExpectedStatus, expected_status(Subject, ExpectedStatus), ExpectedRows),
    maplist(status_matches, ExpectedRows).
test(every_subject_gets_exactly_one_answer_from_each_query) :-
    all_subjects(Subjects),
    maplist(one_answer_each, Subjects).
test(every_status_is_in_the_vocabulary) :-
    all_subjects(Subjects),
    maplist(status_in_vocabulary, Subjects).
test(every_well_formed_subject_has_a_non_empty_checklist) :-
    all_subjects(Subjects),
    maplist(checklist_matches, Subjects).
test(gate_true_is_a_simplified_framework_entity) :-
    dora_rts_asset_management_and_cryptography_assess(gate_true_entity, dora_rts_asset_management_and_cryptography_verdict(simplified_framework_entity, Citations)),
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(gate_false_all_performed_is_complete_with_the_fixed_citations) :-
    dora_rts_asset_management_and_cryptography_assess(gate_false_all_performed, dora_rts_asset_management_and_cryptography_verdict(complete, Citations)),
    sort(Citations, SortedCitations),
    length(SortedCitations, 14),
    member(cite(eu_reg_2024_1774_art_4_2), SortedCitations).
test(gate_absent_is_asked_first) :-
    assessed_status(gate_absent_entity, indeterminate([financial_entity_is_article_16_1_entity])).
test(gate_checklist_has_the_gate_item) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_true_entity, Profile),
    dora_rts_asset_management_and_cryptography_checklist(Profile, [item(_, _, cite(eu_reg_2022_2554_art_16_1))]).
test(one_duty_not_performed_is_incomplete) :-
    assessed_status(one_duty_not_performed, incomplete).
test(a_false_duty_decides_before_an_absent_key) :-
    assessed_status(false_duty_before_absent_key, incomplete).
test(microenterprise_is_excused_the_legacy_records) :-
    assessed_status(microenterprise_legacy_records_not_performed, complete).
test(non_microenterprise_owes_the_legacy_records) :-
    assessed_status(non_microenterprise_legacy_records_not_performed, incomplete).
test(microenterprise_has_twenty_three_required_duties) :-
    dora_rts_asset_management_and_cryptography_profile_for(microenterprise_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, required(Duties), Citations),
    length(Duties, 23),
    sort(Citations, SortedCitations),
    length(SortedCitations, 14),
    member(cite(eu_reg_2024_1774_art_4_2), SortedCitations).
test(non_microenterprise_has_twenty_four_required_duties) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, required(Duties), _),
    length(Duties, 24),
    Duties = [ict_asset_management_policy, ict_asset_lifecycle_monitoring_and_management, ict_asset_records, legacy_ict_system_risk_assessment_records|_],
    last(Duties, prompt_certificate_renewal).
test(required_asks_the_absent_trigger) :-
    dora_rts_asset_management_and_cryptography_profile_for(trigger_absent_legacy_records_performed, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(absent_trigger_decides_alone_when_legacy_records_false) :-
    assessed_status(trigger_absent_legacy_records_not_performed, indeterminate([financial_entity_is_microenterprise])).
test(absent_trigger_does_not_matter_when_legacy_records_performed) :-
    assessed_status(trigger_absent_legacy_records_performed, complete).
test(outstanding_asks_the_trigger_when_legacy_records_false) :-
    dora_rts_asset_management_and_cryptography_profile_for(trigger_absent_legacy_records_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(an_absent_duty_key_is_named) :-
    assessed_status(always_duty_key_absent, indeterminate([ict_asset_management_policy_developed_documented_and_implemented])).
test(an_absent_key_is_named_before_an_unsure_judgement) :-
    assessed_status(absent_key_before_unsure_judgement, indeterminate([certificates_renewed_promptly_before_expiration])).
test(an_unsure_judgement_is_referred_with_every_present_pair) :-
    dora_rts_asset_management_and_cryptography_assess(unsure_judgement_referred, dora_rts_asset_management_and_cryptography_verdict(needs_legal_review(open_textured(encryption_policy_has_rules_for_data_in_use_where_necessary, cite(eu_reg_2024_1774_art_6_2_b)), [inputs_relied_on(Pairs)]), Citations)),
    Citations == [],
    length(Pairs, 26),
    Pairs = [financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false|_],
    member(encryption_policy_has_rules_for_data_in_use_where_necessary - unsure, Pairs).
test(outstanding_refers_the_unsure_judgement) :-
    dora_rts_asset_management_and_cryptography_profile_for(unsure_judgement_referred, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, needs_legal_review(open_textured(encryption_policy_has_rules_for_data_in_use_where_necessary, cite(eu_reg_2024_1774_art_6_2_b)), _), []).
test(provenance_is_a_context_item_constructor_of_arity_two) :-
    Item = provenance(complete_review, [cite(eu_reg_2024_1774_art_6_2_b)]),
    functor(Item, provenance, 2),
    context_item_name(Item, provenance).
test(the_referral_context_names_only_inputs_relied_on) :-
    dora_rts_asset_management_and_cryptography_profile_for(unsure_judgement_referred, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, needs_legal_review(_, Context), []),
    maplist(context_item_name, Context, ItemNames),
    ItemNames == [inputs_relied_on].
test(two_duties_not_performed_are_outstanding_by_their_points) :-
    dora_rts_asset_management_and_cryptography_profile_for(two_duties_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, outstanding(Duties), Citations),
    Duties == [ict_asset_records, certificate_register],
    sort(Citations, SortedCitations),
    SortedCitations == [cite(eu_reg_2024_1774_art_4_2_b), cite(eu_reg_2024_1774_art_7_4)].
test(all_performed_has_none_outstanding) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, none_outstanding, Citations),
    sort(Citations, SortedCitations),
    length(SortedCitations, 14).
test(microenterprise_legacy_records_are_not_outstanding) :-
    dora_rts_asset_management_and_cryptography_profile_for(microenterprise_legacy_records_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, none_outstanding, _).
test(non_microenterprise_legacy_records_are_outstanding) :-
    dora_rts_asset_management_and_cryptography_profile_for(non_microenterprise_legacy_records_not_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, outstanding([legacy_ict_system_risk_assessment_records]), [cite(eu_reg_2024_1774_art_4_2_c)]).
test(duplicate_then_unknown_keys_in_order) :-
    dora_rts_asset_management_and_cryptography_profile_for(duplicate_and_unknown_keys, Profile),
    dora_rts_asset_management_and_cryptography_input_problems(Profile, [duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(foreign_contract_key)]),
    rts_asset_management_and_cryptography_duties_required(Profile, input_problems(_), []),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, input_problems(_), []).
test(unsure_is_wrong_type_for_the_gate) :-
    assessed_status(gate_given_unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
test(a_non_list_profile_is_wrong_type) :-
    assessed_status(not_an_attribute_list, input_problems([wrong_type(profile)])).
test(a_well_formed_profile_has_no_problem) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_input_problems(Profile, []).
test(what_if_the_gate_were_false) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_true_entity, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, financial_entity_is_article_16_1_entity, false, complete).
test(what_if_one_duty_were_not_performed) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, key_replacement_methods_developed_and_implemented, false, incomplete).
test(status_projection_matches_the_verdict) :-
    dora_rts_asset_management_and_cryptography_profile_for(one_duty_not_performed, Profile),
    dora_rts_asset_management_and_cryptography_status(Profile, incomplete).

test(gate_true_is_not_complete, fail) :-
    assessed_status(gate_true_entity, complete).
test(gate_false_all_performed_is_not_simplified, fail) :-
    assessed_status(gate_false_all_performed, simplified_framework_entity).
test(one_duty_not_performed_is_not_complete, fail) :-
    assessed_status(one_duty_not_performed, complete).
test(all_performed_is_not_incomplete, fail) :-
    assessed_status(gate_false_all_performed, incomplete).
test(microenterprise_legacy_records_not_performed_is_not_incomplete, fail) :-
    assessed_status(microenterprise_legacy_records_not_performed, incomplete).
test(non_microenterprise_legacy_records_not_performed_is_not_complete, fail) :-
    assessed_status(non_microenterprise_legacy_records_not_performed, complete).
test(microenterprise_required_lacks_the_legacy_records, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(microenterprise_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, required(Duties), _),
    member(legacy_ict_system_risk_assessment_records, Duties).
test(absent_trigger_with_legacy_records_false_is_not_complete, fail) :-
    assessed_status(trigger_absent_legacy_records_not_performed, complete).
test(absent_trigger_with_legacy_records_performed_is_not_indeterminate, fail) :-
    assessed_status(trigger_absent_legacy_records_performed, indeterminate(_)).
test(an_absent_duty_key_is_not_complete, fail) :-
    assessed_status(always_duty_key_absent, complete).
test(an_unsure_judgement_is_not_complete, fail) :-
    assessed_status(unsure_judgement_referred, complete).
test(the_referral_context_carries_no_provenance_item, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(unsure_judgement_referred, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, needs_legal_review(_, [inputs_relied_on(_), provenance(_, _)]), _).
test(the_outstanding_referral_carries_no_provenance_item, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(unsure_judgement_referred, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, needs_legal_review(_, [inputs_relied_on(_), provenance(_, _)]), _).
test(all_performed_has_nothing_outstanding, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, outstanding(_), _).
test(what_if_one_duty_were_not_performed_is_not_complete, fail) :-
    dora_rts_asset_management_and_cryptography_profile_for(gate_false_all_performed, Profile),
    dora_rts_asset_management_and_cryptography_what_if(Profile, key_replacement_methods_developed_and_implemented, false, complete).

cp_test_names([every_subject_has_an_expected_status, each_subject_resolves_to_its_expected_status, every_subject_gets_exactly_one_answer_from_each_query, every_status_is_in_the_vocabulary, every_well_formed_subject_has_a_non_empty_checklist, gate_true_is_a_simplified_framework_entity, gate_false_all_performed_is_complete_with_the_fixed_citations, gate_absent_is_asked_first, gate_checklist_has_the_gate_item, one_duty_not_performed_is_incomplete, a_false_duty_decides_before_an_absent_key, microenterprise_is_excused_the_legacy_records, non_microenterprise_owes_the_legacy_records, microenterprise_has_twenty_three_required_duties, non_microenterprise_has_twenty_four_required_duties, required_asks_the_absent_trigger, absent_trigger_decides_alone_when_legacy_records_false, absent_trigger_does_not_matter_when_legacy_records_performed, outstanding_asks_the_trigger_when_legacy_records_false, an_absent_duty_key_is_named, an_absent_key_is_named_before_an_unsure_judgement, an_unsure_judgement_is_referred_with_every_present_pair, outstanding_refers_the_unsure_judgement, provenance_is_a_context_item_constructor_of_arity_two, the_referral_context_names_only_inputs_relied_on, two_duties_not_performed_are_outstanding_by_their_points, all_performed_has_none_outstanding, microenterprise_legacy_records_are_not_outstanding, non_microenterprise_legacy_records_are_outstanding, duplicate_then_unknown_keys_in_order, unsure_is_wrong_type_for_the_gate, a_non_list_profile_is_wrong_type, a_well_formed_profile_has_no_problem, what_if_the_gate_were_false, what_if_one_duty_were_not_performed, status_projection_matches_the_verdict]).
cp_test_fail_names([gate_true_is_not_complete, gate_false_all_performed_is_not_simplified, one_duty_not_performed_is_not_complete, all_performed_is_not_incomplete, microenterprise_legacy_records_not_performed_is_not_incomplete, non_microenterprise_legacy_records_not_performed_is_not_complete, microenterprise_required_lacks_the_legacy_records, absent_trigger_with_legacy_records_false_is_not_complete, absent_trigger_with_legacy_records_performed_is_not_indeterminate, an_absent_duty_key_is_not_complete, an_unsure_judgement_is_not_complete, the_referral_context_carries_no_provenance_item, the_outstanding_referral_carries_no_provenance_item, all_performed_has_nothing_outstanding, what_if_one_duty_were_not_performed_is_not_complete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
