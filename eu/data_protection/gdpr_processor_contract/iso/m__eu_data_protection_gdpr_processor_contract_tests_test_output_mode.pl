% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(formalize_lib, [not_member/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [decide_processor_contract/2, decide_processor_contract_status/2, processor_contract_status_status/2, contract_checklist/2, processor_contract_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_fixtures, [gdpr_processor_contract_subject/1, gdpr_processor_contract_profile_for/2]).

base_citations([cite(eu_reg_2016_679_art_28_3), cite(eu_reg_2016_679_art_28_9), cite(eu_reg_2016_679_art_28_1), cite(eu_reg_2016_679_art_28_3_f), cite(eu_reg_2016_679_art_28_3_e), cite(eu_reg_2016_679_art_28_3_d), cite(eu_reg_2016_679_art_28_3_b), cite(eu_reg_2016_679_art_28_3_g), cite(eu_reg_2016_679_art_28_3_h), cite(eu_reg_2016_679_art_28_3_second_subpara), cite(eu_reg_2016_679_art_28_3_a), cite(eu_reg_2016_679_art_28_3_c), cite(eu_reg_2016_679_art_28_2)]).

subprocessor_citations(Citations) :-
    base_citations(Base),
    append(Base, [cite(eu_reg_2016_679_art_28_4)], Citations).

general_written_citations([cite(eu_reg_2016_679_art_28_3), cite(eu_reg_2016_679_art_28_9), cite(eu_reg_2016_679_art_28_2), cite(eu_reg_2016_679_art_28_1), cite(eu_reg_2016_679_art_28_3_f), cite(eu_reg_2016_679_art_28_3_e), cite(eu_reg_2016_679_art_28_3_d), cite(eu_reg_2016_679_art_28_3_b), cite(eu_reg_2016_679_art_28_3_g), cite(eu_reg_2016_679_art_28_3_h), cite(eu_reg_2016_679_art_28_3_second_subpara), cite(eu_reg_2016_679_art_28_3_a), cite(eu_reg_2016_679_art_28_3_c), cite(eu_reg_2016_679_art_28_4)]).

expected_verdict(eligible_without_subprocessor, processor_contract_verdict(eligible, [], Citations)) :-
    base_citations(Citations).
expected_verdict(eligible_with_standard_clauses_recorded, processor_contract_verdict(eligible, [], Citations)) :-
    base_citations(Citations).
expected_verdict(near_miss_malformed_standard_clauses, processor_contract_verdict(input_problems([wrong_type(standard_clauses_adopted)]), [], [])).
expected_verdict(near_miss_missing_point_h, processor_contract_verdict(ineligible, [stipulates_information_and_audit_rights], [cite(eu_reg_2016_679_art_28_3_h)])).
expected_verdict(near_miss_partial_point_a_recorded_false, processor_contract_verdict(ineligible, [stipulates_processing_only_on_documented_instructions], [cite(eu_reg_2016_679_art_28_3_a)])).
expected_verdict(near_miss_third_country_law, processor_contract_verdict(ineligible, [contract_governed_by_union_or_member_state_law], [cite(eu_reg_2016_679_art_28_3)])).
expected_verdict(near_miss_insufficient_guarantees, processor_contract_verdict(ineligible, [processor_provides_sufficient_guarantees], [cite(eu_reg_2016_679_art_28_1)])).
expected_verdict(eligible_specific_written_authorisation, processor_contract_verdict(eligible, [], Citations)) :-
    subprocessor_citations(Citations).
expected_verdict(near_miss_authorisation_none, processor_contract_verdict(ineligible, [subprocessor_authorisation], [cite(eu_reg_2016_679_art_28_2)])).
expected_verdict(subprocessor_obligations_unsure, processor_contract_verdict(needs_legal_review(open_textured(subprocessor_obligations_same, cite(eu_reg_2016_679_art_28_4)), [inputs_relied_on([contract_binding_on_processor - true, contract_governed_by_union_or_member_state_law - true, processing_on_behalf_of_controller - true, processor_determines_purposes_and_means - false, processor_provides_sufficient_guarantees - true, standard_clauses_adopted - absent, subprocessor_contract_governed_by_union_or_member_state_law - true, subprocessor_obligations_same - unsure, subprocessor_provides_sufficient_guarantees - true])]), [], [])).
expected_verdict(eligible_general_written_authorisation, processor_contract_verdict(eligible, [], Citations)) :-
    general_written_citations(Citations).
expected_verdict(near_miss_general_written_without_objection_opportunity, processor_contract_verdict(ineligible, [controller_given_opportunity_to_object], [cite(eu_reg_2016_679_art_28_2)])).
expected_verdict(not_applicable_not_on_behalf, processor_contract_verdict(not_applicable, [], [cite(eu_reg_2016_679_art_4_8)])).
expected_verdict(role_controller_deferred, processor_contract_verdict(needs_legal_review(deferred_provision(cite(eu_reg_2016_679_art_28_10)), [inputs_relied_on([processing_on_behalf_of_controller - true, processor_determines_purposes_and_means - true, standard_clauses_adopted - absent])]), [], [])).
expected_verdict(role_processing_unsure, processor_contract_verdict(needs_legal_review(open_textured(processing_on_behalf_of_controller, cite(eu_reg_2016_679_art_4_8)), [inputs_relied_on([processing_on_behalf_of_controller - unsure, standard_clauses_adopted - absent])]), [], [])).
expected_verdict(role_purposes_and_means_unsure, processor_contract_verdict(needs_legal_review(open_textured(processor_determines_purposes_and_means, cite(eu_reg_2016_679_art_28_10)), [inputs_relied_on([processing_on_behalf_of_controller - true, processor_determines_purposes_and_means - unsure, standard_clauses_adopted - absent])]), [], [])).
expected_verdict(role_processing_absent, processor_contract_verdict(indeterminate([processing_on_behalf_of_controller]), [], [])).
expected_verdict(role_purposes_and_means_absent, processor_contract_verdict(indeterminate([processor_determines_purposes_and_means]), [], [])).
expected_verdict(absent_keys_list_all, processor_contract_verdict(indeterminate([contract_in_writing, stipulates_security_measures]), [], [])).
expected_verdict(near_miss_unmet_dominates_absence, processor_contract_verdict(ineligible, [stipulates_security_measures], [cite(eu_reg_2016_679_art_28_3_c)])).
expected_verdict(checklist_binding_unsure, processor_contract_verdict(needs_legal_review(open_textured(contract_binding_on_processor, cite(eu_reg_2016_679_art_28_3)), [inputs_relied_on([contract_binding_on_processor - unsure, contract_governed_by_union_or_member_state_law - true, processing_on_behalf_of_controller - true, processor_determines_purposes_and_means - false, processor_provides_sufficient_guarantees - true, standard_clauses_adopted - absent])]), [], [])).
expected_verdict(unread_keys_ignored, processor_contract_verdict(eligible, [], Citations)) :-
    base_citations(Citations).
expected_verdict(input_problems_mixed, processor_contract_verdict(input_problems([wrong_type(contract_in_writing), duplicate_key(subprocessor_engaged), unknown_key(stray_key)]), [], [])).

gives_expected_verdict_once(Subject) :-
    expected_verdict(Subject, Expected),
    gdpr_processor_contract_profile_for(Subject, Profile),
    findall(Verdict, decide_processor_contract(Profile, Verdict), Verdicts),
    Verdicts == [Expected].

item_state(State, checklist_item(_, _, State)).

item_key(checklist_item(Key, _, _), Key).

test(every_subject_has_one_expected_verdict) :-
    findall(Subject, gdpr_processor_contract_subject(Subject), Registered),
    findall(Subject, expected_verdict(Subject, _), Expected),
    clausal_msort(Registered, RegisteredSorted),
    clausal_msort(Expected, ExpectedSorted),
    RegisteredSorted == ExpectedSorted.
test(every_subject_gives_its_expected_verdict_exactly_once) :-
    findall(Subject, gdpr_processor_contract_subject(Subject), Subjects),
    maplist(gives_expected_verdict_once, Subjects).
test(the_baseline_profile_yields_exactly_one_status) :-
    gdpr_processor_contract_profile_for(todo_baseline_subject, Profile),
    findall(Status, processor_contract_status_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(the_scaffold_verdict_carries_the_citations) :-
    gdpr_processor_contract_profile_for(todo_baseline_subject, Profile),
    base_citations(Citations),
    decide_processor_contract_status(Profile, processor_contract_status_verdict(eligible, Citations)).
test(checklist_without_subprocessor_lists_twenty_one_met_items) :-
    gdpr_processor_contract_profile_for(eligible_without_subprocessor, Profile),
    findall(Items, contract_checklist(Profile, Items), [Checklist]),
    length(Checklist, 21),
    maplist(item_state(met), Checklist).
test(checklist_with_specific_authorisation_lists_twenty_seven_items) :-
    gdpr_processor_contract_profile_for(eligible_specific_written_authorisation, Profile),
    contract_checklist(Profile, Items),
    length(Items, 27),
    maplist(item_state(met), Items).
test(checklist_with_general_authorisation_lists_twenty_nine_items) :-
    gdpr_processor_contract_profile_for(eligible_general_written_authorisation, Profile),
    contract_checklist(Profile, Items),
    length(Items, 29).
test(checklist_without_authorisation_skips_the_before_engagement_limb) :-
    gdpr_processor_contract_profile_for(near_miss_authorisation_none, Profile),
    contract_checklist(Profile, Items),
    length(Items, 26),
    member(checklist_item(subprocessor_authorisation, cite(eu_reg_2016_679_art_28_2), unmet), Items),
    maplist(item_key, Items, Keys),
    not_member(subprocessor_authorisation_given_before_engagement, Keys).
test(checklist_marks_an_unsure_judgement) :-
    gdpr_processor_contract_profile_for(subprocessor_obligations_unsure, Profile),
    contract_checklist(Profile, Items),
    member(checklist_item(subprocessor_obligations_same, cite(eu_reg_2016_679_art_28_4), open_by_judgement), Items).
test(checklist_marks_absent_keys) :-
    gdpr_processor_contract_profile_for(absent_keys_list_all, Profile),
    contract_checklist(Profile, Items),
    member(checklist_item(contract_in_writing, cite(eu_reg_2016_679_art_28_9), open_by_absence), Items),
    member(checklist_item(stipulates_security_measures, cite(eu_reg_2016_679_art_28_3_c), open_by_absence), Items).
test(outside_fact_absent_is_read_out) :-
    gdpr_processor_contract_profile_for(eligible_without_subprocessor, Profile),
    findall(OutsideFacts, processor_contract_outside_facts(Profile, OutsideFacts), Answers),
    Answers == [[outside_fact(standard_clauses_adopted, absent)]].
test(outside_fact_attested_is_copied_whatever_the_status) :-
    gdpr_processor_contract_profile_for(unread_keys_ignored, Profile),
    processor_contract_outside_facts(Profile, OutsideFacts),
    OutsideFacts == [outside_fact(standard_clauses_adopted, attested(false, attestation(host, moment, reason, none)))].
test(outside_facts_with_input_problems) :-
    gdpr_processor_contract_profile_for(near_miss_malformed_standard_clauses, Profile),
    processor_contract_outside_facts(Profile, input_problems([wrong_type(standard_clauses_adopted)])).

cp_test_names([every_subject_has_one_expected_verdict, every_subject_gives_its_expected_verdict_exactly_once, the_baseline_profile_yields_exactly_one_status, the_scaffold_verdict_carries_the_citations, checklist_without_subprocessor_lists_twenty_one_met_items, checklist_with_specific_authorisation_lists_twenty_seven_items, checklist_with_general_authorisation_lists_twenty_nine_items, checklist_without_authorisation_skips_the_before_engagement_limb, checklist_marks_an_unsure_judgement, checklist_marks_absent_keys, outside_fact_absent_is_read_out, outside_fact_attested_is_copied_whatever_the_status, outside_facts_with_input_problems]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
