% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_policies_and_controls_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2, clausal_is_list/1, clausal_msort/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_dora_rts_simplified_policies_and_controls, [decide_dora_rts_simplified_policies_and_controls/2, dora_rts_simplified_policies_and_controls_status/2, dora_rts_simplified_policies_and_controls_checklist/2, dora_rts_simplified_policies_and_controls_decision_resolvable/1, dora_rts_simplified_policies_and_controls_status_values/1, simplified_policies_and_controls_duties_required/3, simplified_policies_and_controls_duties_complete/3, simplified_policies_and_controls_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_fixtures, [dora_rts_simplified_policies_and_controls_subject/1, dora_rts_simplified_policies_and_controls_profile_for/2, dora_rts_simplified_policies_and_controls_assess/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_kernel, [dora_rts_simplified_policies_and_controls_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_queries, [dora_rts_simplified_policies_and_controls_what_if/4, dora_rts_simplified_policies_and_controls_eligibility/2, dora_rts_simplified_policies_and_controls_compliance_check/3, dora_rts_simplified_policies_and_controls_justification/3]).

subject_status(Subject, Status) :-
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    dora_rts_simplified_policies_and_controls_status(Profile, Status).

fixed_citation_set(Sorted) :-
    clausal_msort([cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2024_1774_art_28_1), cite(eu_reg_2024_1774_art_28_2), cite(eu_reg_2024_1774_art_28_4), cite(eu_reg_2024_1774_art_28_5), cite(eu_reg_2024_1774_art_28_6), cite(eu_reg_2024_1774_art_29_1), cite(eu_reg_2024_1774_art_29_2), cite(eu_reg_2024_1774_art_30_1), cite(eu_reg_2024_1774_art_30_2), cite(eu_reg_2024_1774_art_31_1), cite(eu_reg_2024_1774_art_31_2), cite(eu_reg_2024_1774_art_31_3), cite(eu_reg_2024_1774_art_31_4), cite(eu_reg_2024_1774_art_32_1), cite(eu_reg_2024_1774_art_32_2), cite(eu_reg_2024_1774_art_32_3), cite(eu_reg_2024_1774_art_33), cite(eu_reg_2024_1774_art_34), cite(eu_reg_2024_1774_art_35)], Sorted).

is_fixed_citation_set(Citations) :-
    clausal_msort(Citations, Sorted),
    fixed_citation_set(Sorted).

subjects_answer_once([]).
subjects_answer_once([Subject|Subjects]) :-
    findall(Verdict, dora_rts_simplified_policies_and_controls_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1),
    subjects_answer_once(Subjects).

items_cited([]).
items_cited([item(_, _, cite(CitationKey))|Items]) :-
    atom(CitationKey),
    items_cited(Items).

referral_context_tail([]).
referral_context_tail([provenance(_Clause, ProvenanceCitations)]) :-
    clausal_is_list(ProvenanceCitations).

test(every_subject_yields_exactly_one_verdict) :-
    findall(Subject, dora_rts_simplified_policies_and_controls_subject(Subject), Subjects),
    length(Subjects, 15),
    subjects_answer_once(Subjects).
test(every_status_functor_is_in_the_vocabulary) :-
    dora_rts_simplified_policies_and_controls_assess(gate_absent_entity, dora_rts_simplified_policies_and_controls_verdict(Status, _)),
    functor(Status, Name, _),
    dora_rts_simplified_policies_and_controls_status_values(StatusValues),
    member(Name, StatusValues).
test(decision_is_resolvable_and_checklist_non_empty) :-
    dora_rts_simplified_policies_and_controls_profile_for(all_duties_performed, Profile),
    dora_rts_simplified_policies_and_controls_decision_resolvable(Profile),
    dora_rts_simplified_policies_and_controls_checklist(Profile, [_FirstItem|_OtherItems]).
test(all_duties_performed_is_complete) :-
    dora_rts_simplified_policies_and_controls_assess(all_duties_performed, dora_rts_simplified_policies_and_controls_verdict(complete, Citations)),
    is_fixed_citation_set(Citations).
test(one_duty_not_performed_is_incomplete) :-
    dora_rts_simplified_policies_and_controls_assess(one_duty_not_performed, dora_rts_simplified_policies_and_controls_verdict(incomplete, Citations)),
    is_fixed_citation_set(Citations).
test(gate_false_entity_is_not_article_16_1_entity) :-
    dora_rts_simplified_policies_and_controls_assess(gate_false_entity, dora_rts_simplified_policies_and_controls_verdict(not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)])).
test(gate_false_decides_before_a_false_duty) :-
    subject_status(gate_false_with_duty_not_performed, not_article_16_1_entity).
test(gate_absent_is_named_before_a_false_duty) :-
    dora_rts_simplified_policies_and_controls_assess(gate_absent_entity, dora_rts_simplified_policies_and_controls_verdict(indeterminate([financial_entity_is_article_16_1_entity]), [])).
test(one_duty_absent_is_indeterminate_on_that_key) :-
    dora_rts_simplified_policies_and_controls_assess(one_duty_absent, dora_rts_simplified_policies_and_controls_verdict(indeterminate([access_operations_and_change_events_logged]), [])).
test(one_duty_unsure_is_referred_to_a_lawyer) :-
    dora_rts_simplified_policies_and_controls_assess(one_duty_unsure, dora_rts_simplified_policies_and_controls_verdict(needs_legal_review(open_textured(cyber_threat_information_monitored, cite(eu_reg_2024_1774_art_34)), [inputs_relied_on(Pairs)]), [])),
    length(Pairs, 52),
    Pairs = [financial_entity_is_article_16_1_entity - true|_],
    member(cyber_threat_information_monitored - unsure, Pairs).
test(complete_referral_context_has_at_most_one_provenance_item) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_unsure, Profile),
    simplified_policies_and_controls_duties_complete(Profile, needs_legal_review(open_textured(_, _), Context), []),
    Context = [inputs_relied_on(_)|Rest],
    referral_context_tail(Rest).
test(outstanding_referral_context_has_at_most_one_provenance_item) :-
    dora_rts_simplified_policies_and_controls_profile_for(false_and_unsure, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, needs_legal_review(open_textured(_, _), Context), []),
    Context = [inputs_relied_on(_)|Rest],
    referral_context_tail(Rest).
test(a_provenance_item_is_accepted_after_inputs_relied_on) :-
    referral_context_tail([provenance(complete_from_flags, [cite(eu_reg_2024_1774_art_34)])]).
test(false_and_absent_is_incomplete) :-
    subject_status(false_and_absent, incomplete).
test(false_and_unsure_is_incomplete) :-
    subject_status(false_and_unsure, incomplete).
test(absent_is_named_before_unsure) :-
    subject_status(absent_before_unsure, indeterminate([teleworking_and_private_device_measures_implemented])).
test(several_duties_not_performed_is_incomplete) :-
    subject_status(several_duties_not_performed, incomplete).
test(gate_unsure_is_wrong_type) :-
    subject_status(gate_unsure_wrong_type, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
test(duplicate_contract_key_is_duplicate_key_only) :-
    subject_status(duplicate_contract_key, input_problems([duplicate_key(user_accountability_ensured)])).
test(microenterprise_key_is_unknown_key) :-
    subject_status(microenterprise_key_unknown, input_problems([unknown_key(financial_entity_is_microenterprise)])).
test(numeric_value_is_wrong_type) :-
    subject_status(numeric_value_wrong_type, input_problems([wrong_type(secure_data_deletion_process_in_place)])).
test(not_an_attribute_list_is_wrong_type_profile) :-
    dora_rts_simplified_policies_and_controls_input_problems(not_a_profile, [wrong_type(profile)]).
test(a_well_formed_profile_has_no_problems) :-
    dora_rts_simplified_policies_and_controls_profile_for(all_duties_performed, Profile),
    dora_rts_simplified_policies_and_controls_input_problems(Profile, []).
test(required_lists_all_fifty_one_duties_in_duty_order) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_not_performed, Profile),
    findall(Result - Citations, simplified_policies_and_controls_duties_required(Profile, Result, Citations), [required(Duties) - Citations]),
    length(Duties, 51),
    Duties = [internal_governance_and_control_framework|_],
    last(Duties, teleworking_and_private_devices),
    is_fixed_citation_set(Citations).
test(required_for_gate_false_is_not_article_16_1_entity) :-
    dora_rts_simplified_policies_and_controls_profile_for(gate_false_entity, Profile),
    simplified_policies_and_controls_duties_required(Profile, not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(all_duties_performed_has_none_outstanding) :-
    dora_rts_simplified_policies_and_controls_profile_for(all_duties_performed, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, none_outstanding, Citations),
    is_fixed_citation_set(Citations).
test(several_duties_outstanding_in_duty_order) :-
    dora_rts_simplified_policies_and_controls_profile_for(several_duties_not_performed, Profile),
    findall(Result - Citations, simplified_policies_and_controls_duties_outstanding(Profile, Result, Citations), [Result - Citations]),
    Result == outstanding([internal_governance_and_control_framework, protection_of_premises_and_data_centres, user_accountability]),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2024_1774_art_28_1), cite(eu_reg_2024_1774_art_32_2), cite(eu_reg_2024_1774_art_32_3), cite(eu_reg_2024_1774_art_33)].
test(false_and_absent_outstanding_names_the_absent_key) :-
    dora_rts_simplified_policies_and_controls_profile_for(false_and_absent, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, indeterminate([access_operations_and_change_events_logged]), []).
test(false_and_unsure_outstanding_refers_the_unsure_key) :-
    dora_rts_simplified_policies_and_controls_profile_for(false_and_unsure, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, needs_legal_review(open_textured(cyber_threat_information_monitored, cite(eu_reg_2024_1774_art_34)), [inputs_relied_on(_)]), []).
test(what_if_the_failing_duty_is_performed_is_complete) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_not_performed, Profile),
    dora_rts_simplified_policies_and_controls_what_if(Profile, premises_and_data_centres_protected, true, complete).
test(what_if_the_gate_is_false_is_not_article_16_1_entity) :-
    dora_rts_simplified_policies_and_controls_profile_for(all_duties_performed, Profile),
    dora_rts_simplified_policies_and_controls_what_if(Profile, financial_entity_is_article_16_1_entity, false, not_article_16_1_entity).
test(what_if_replaces_a_duplicated_key) :-
    dora_rts_simplified_policies_and_controls_profile_for(duplicate_contract_key, Profile),
    dora_rts_simplified_policies_and_controls_what_if(Profile, user_accountability_ensured, true, complete).
test(eligibility_bound_by_title_iii) :-
    dora_rts_simplified_policies_and_controls_profile_for(all_duties_performed, Profile),
    dora_rts_simplified_policies_and_controls_eligibility(Profile, eligibility(bound_by_title_iii, [item(article_16_1_entity, met, cite(eu_reg_2022_2554_art_16_1))])).
test(eligibility_gate_false_is_not_bound) :-
    dora_rts_simplified_policies_and_controls_profile_for(gate_false_entity, Profile),
    dora_rts_simplified_policies_and_controls_eligibility(Profile, eligibility(not_article_16_1_entity, [_GateItem])).
test(eligibility_gate_absent_is_indeterminate) :-
    dora_rts_simplified_policies_and_controls_profile_for(gate_absent_entity, Profile),
    dora_rts_simplified_policies_and_controls_eligibility(Profile, eligibility(indeterminate([financial_entity_is_article_16_1_entity]), [_GateItem])).
test(compliance_performed_duty) :-
    dora_rts_simplified_policies_and_controls_profile_for(all_duties_performed, Profile),
    dora_rts_simplified_policies_and_controls_compliance_check(Profile, protection_of_premises_and_data_centres, compliance(protection_of_premises_and_data_centres, performed, cite(eu_reg_2024_1774_art_32_2))).
test(compliance_omitted_duty) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_not_performed, Profile),
    dora_rts_simplified_policies_and_controls_compliance_check(Profile, protection_of_premises_and_data_centres, compliance(protection_of_premises_and_data_centres, omitted, cite(eu_reg_2024_1774_art_32_2))).
test(compliance_gate_false) :-
    dora_rts_simplified_policies_and_controls_profile_for(gate_false_entity, Profile),
    dora_rts_simplified_policies_and_controls_compliance_check(Profile, event_logging, not_article_16_1_entity).
test(compliance_absent_duty_is_indeterminate) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_absent, Profile),
    dora_rts_simplified_policies_and_controls_compliance_check(Profile, event_logging, indeterminate([access_operations_and_change_events_logged])).
test(compliance_unsure_duty_is_referred) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_unsure, Profile),
    dora_rts_simplified_policies_and_controls_compliance_check(Profile, cyber_threat_information_monitoring, needs_legal_review(open_textured(cyber_threat_information_monitored, cite(eu_reg_2024_1774_art_34)), [inputs_relied_on(Pairs)])),
    length(Pairs, 52).
test(compliance_referral_context_has_at_most_one_provenance_item) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_unsure, Profile),
    dora_rts_simplified_policies_and_controls_compliance_check(Profile, cyber_threat_information_monitoring, needs_legal_review(_, Context)),
    Context = [inputs_relied_on(_)|Rest],
    referral_context_tail(Rest).
test(compliance_answers_once_per_duty) :-
    dora_rts_simplified_policies_and_controls_profile_for(all_duties_performed, Profile),
    findall(Duty - Verdict, dora_rts_simplified_policies_and_controls_compliance_check(Profile, Duty, Verdict), Answers),
    length(Answers, 51).
test(every_checklist_item_carries_a_citation) :-
    dora_rts_simplified_policies_and_controls_profile_for(several_duties_not_performed, Profile),
    dora_rts_simplified_policies_and_controls_checklist(Profile, Items),
    length(Items, 52),
    items_cited(Items).
test(justification_of_one_item) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_not_performed, Profile),
    dora_rts_simplified_policies_and_controls_justification(Profile, protection_of_premises_and_data_centres, cite(eu_reg_2024_1774_art_32_2)).
test(justification_of_the_gate) :-
    dora_rts_simplified_policies_and_controls_profile_for(gate_false_entity, Profile),
    dora_rts_simplified_policies_and_controls_justification(Profile, article_16_1_entity, cite(eu_reg_2022_2554_art_16_1)).

test(all_duties_performed_is_not_incomplete, fail) :-
    subject_status(all_duties_performed, incomplete).
test(one_duty_not_performed_is_not_complete, fail) :-
    subject_status(one_duty_not_performed, complete).
test(gate_false_entity_is_not_complete, fail) :-
    subject_status(gate_false_entity, complete).
test(gate_absent_is_not_incomplete, fail) :-
    subject_status(gate_absent_entity, incomplete).
test(one_duty_unsure_is_not_complete, fail) :-
    subject_status(one_duty_unsure, complete).
test(provenance_never_precedes_inputs_relied_on, fail) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_unsure, Profile),
    simplified_policies_and_controls_duties_complete(Profile, needs_legal_review(_, [provenance(_, _)|_]), _).
test(eligibility_gate_false_is_not_bound_by_title_iii, fail) :-
    dora_rts_simplified_policies_and_controls_profile_for(gate_false_entity, Profile),
    dora_rts_simplified_policies_and_controls_eligibility(Profile, eligibility(bound_by_title_iii, _)).
test(compliance_omitted_duty_is_not_performed, fail) :-
    dora_rts_simplified_policies_and_controls_profile_for(one_duty_not_performed, Profile),
    dora_rts_simplified_policies_and_controls_compliance_check(Profile, protection_of_premises_and_data_centres, compliance(_, performed, _)).

cp_test_names([every_subject_yields_exactly_one_verdict, every_status_functor_is_in_the_vocabulary, decision_is_resolvable_and_checklist_non_empty, all_duties_performed_is_complete, one_duty_not_performed_is_incomplete, gate_false_entity_is_not_article_16_1_entity, gate_false_decides_before_a_false_duty, gate_absent_is_named_before_a_false_duty, one_duty_absent_is_indeterminate_on_that_key, one_duty_unsure_is_referred_to_a_lawyer, complete_referral_context_has_at_most_one_provenance_item, outstanding_referral_context_has_at_most_one_provenance_item, a_provenance_item_is_accepted_after_inputs_relied_on, false_and_absent_is_incomplete, false_and_unsure_is_incomplete, absent_is_named_before_unsure, several_duties_not_performed_is_incomplete, gate_unsure_is_wrong_type, duplicate_contract_key_is_duplicate_key_only, microenterprise_key_is_unknown_key, numeric_value_is_wrong_type, not_an_attribute_list_is_wrong_type_profile, a_well_formed_profile_has_no_problems, required_lists_all_fifty_one_duties_in_duty_order, required_for_gate_false_is_not_article_16_1_entity, all_duties_performed_has_none_outstanding, several_duties_outstanding_in_duty_order, false_and_absent_outstanding_names_the_absent_key, false_and_unsure_outstanding_refers_the_unsure_key, what_if_the_failing_duty_is_performed_is_complete, what_if_the_gate_is_false_is_not_article_16_1_entity, what_if_replaces_a_duplicated_key, eligibility_bound_by_title_iii, eligibility_gate_false_is_not_bound, eligibility_gate_absent_is_indeterminate, compliance_performed_duty, compliance_omitted_duty, compliance_gate_false, compliance_absent_duty_is_indeterminate, compliance_unsure_duty_is_referred, compliance_referral_context_has_at_most_one_provenance_item, compliance_answers_once_per_duty, every_checklist_item_carries_a_citation, justification_of_one_item, justification_of_the_gate]).
cp_test_fail_names([all_duties_performed_is_not_incomplete, one_duty_not_performed_is_not_complete, gate_false_entity_is_not_complete, gate_absent_is_not_incomplete, one_duty_unsure_is_not_complete, provenance_never_precedes_inputs_relied_on, eligibility_gate_false_is_not_bound_by_title_iii, compliance_omitted_duty_is_not_performed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
