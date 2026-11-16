% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [decide_processor_contract/2, processor_contract_status/2, contract_missing_stipulations/2, contract_checklist/2, processor_contract_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_fixtures, [gdpr_processor_contract_profile_for/2, gdpr_processor_contract_assess/2]).

test(the_base_profile_yields_exactly_one_status) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    findall(Status, processor_contract_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(the_base_profile_yields_exactly_one_verdict) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    findall(Verdict, decide_processor_contract(Profile, Verdict), Verdicts),
    length(Verdicts, 1).
test(the_eligible_verdict_carries_citations) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(eligible, [], [_FirstCitation|_OtherCitations])).
test(the_assess_wrapper_agrees_with_decide) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    decide_processor_contract(Profile, Verdict),
    gdpr_processor_contract_assess(audit_clause_missing, Verdict).
test(the_missing_list_is_one_solution) :-
    gdpr_processor_contract_profile_for(confidentiality_and_security_missing, Profile),
    findall(Missing, contract_missing_stipulations(Profile, Missing), Lists),
    Lists == [[stipulates_confidentiality_commitment, stipulates_security_measures]].
test(the_ineligible_citations_align_with_the_missing_keys) :-
    gdpr_processor_contract_profile_for(confidentiality_and_security_missing, Profile),
    findall(Citations, decide_processor_contract(Profile, processor_contract_verdict(ineligible, _, Citations)), CitationLists),
    CitationLists == [[cite(eu_reg_2016_679_art_28_3_b), cite(eu_reg_2016_679_art_28_3_c)]].
test(the_checklist_of_the_base_has_twentyone_met_items) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    findall(Items, contract_checklist(Profile, Items), ItemLists),
    ItemLists = [Items],
    length(Items, 21),
    findall(Key, member(checklist_item(Key, _, met), Items), MetKeys),
    length(MetKeys, 21).
test(the_checklist_starts_with_the_first_limb_in_key_order) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    contract_checklist(Profile, [checklist_item(contract_binding_on_processor, cite(eu_reg_2016_679_art_28_3), met)|_]).
test(the_checklist_ends_with_the_engaged_flag_when_no_other_processor) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    contract_checklist(Profile, Items),
    last(Items, checklist_item(subprocessor_engaged, cite(eu_reg_2016_679_art_28_2), met)).
test(a_specific_subprocessor_adds_six_limbs) :-
    gdpr_processor_contract_profile_for(compliant_with_specific_subprocessor, Profile),
    contract_checklist(Profile, Items),
    length(Items, 27).
test(a_general_subprocessor_adds_eight_limbs) :-
    gdpr_processor_contract_profile_for(compliant_with_general_subprocessor, Profile),
    contract_checklist(Profile, Items),
    length(Items, 29).
test(the_checklist_is_independent_of_the_role_gate) :-
    gdpr_processor_contract_profile_for(not_a_processor, Profile),
    contract_checklist(Profile, Items),
    length(Items, 21),
    member(checklist_item(contract_in_writing, cite(eu_reg_2016_679_art_28_9), met), Items).
test(the_checklist_shows_an_absent_key_as_open_by_absence) :-
    gdpr_processor_contract_profile_for(in_writing_unestablished, Profile),
    contract_checklist(Profile, Items),
    member(checklist_item(contract_in_writing, cite(eu_reg_2016_679_art_28_9), open_by_absence), Items).
test(the_checklist_shows_unsure_as_open_by_judgement) :-
    gdpr_processor_contract_profile_for(guarantees_unsure, Profile),
    contract_checklist(Profile, Items),
    member(checklist_item(processor_provides_sufficient_guarantees, cite(eu_reg_2016_679_art_28_1), open_by_judgement), Items).
test(the_checklist_with_input_problems_is_empty) :-
    gdpr_processor_contract_profile_for(input_problem_in_writing_unsure, Profile),
    findall(Items, contract_checklist(Profile, Items), ItemLists),
    ItemLists == [[]].
test(the_empty_profile_checklist_lists_every_always_limb_open) :-
    contract_checklist([], Items),
    length(Items, 21),
    member(checklist_item(subprocessor_engaged, cite(eu_reg_2016_679_art_28_2), open_by_absence), Items).
test(the_outside_fact_is_one_solution_whatever_the_status) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    findall(Facts, processor_contract_outside_facts(Profile, Facts), FactLists),
    FactLists == [[outside_fact(standard_clauses_adopted, absent)]].
test(late_authorisation_names_the_art_28_2_limb) :-
    gdpr_processor_contract_profile_for(specific_authorisation_given_late, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(ineligible, [subprocessor_authorisation_given_before_engagement], [cite(eu_reg_2016_679_art_28_2)])).
test(no_opportunity_to_object_names_the_art_28_2_limb) :-
    gdpr_processor_contract_profile_for(general_authorisation_without_opportunity_to_object, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(ineligible, [controller_given_opportunity_to_object], [cite(eu_reg_2016_679_art_28_2)])).
test(no_authorisation_reads_no_timing_key) :-
    gdpr_processor_contract_profile_for(subprocessor_engaged_without_authorisation, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(ineligible, [subprocessor_authorisation], [cite(eu_reg_2016_679_art_28_2)])).
test(an_unsure_subprocessor_judgement_refers) :-
    gdpr_processor_contract_profile_for(subprocessor_obligations_unsure, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(needs_legal_review(open_textured(subprocessor_obligations_same, cite(eu_reg_2016_679_art_28_4)), [inputs_relied_on(_)]), [], [])).
test(the_gate_precedes_the_checklist) :-
    gdpr_processor_contract_profile_for(controller_with_missing_clause, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(needs_legal_review(deferred_provision(cite(eu_reg_2016_679_art_28_10)), _), [], [])).

test(the_eligible_citations_never_name_the_processor_gate, fail) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(eligible, _, Citations)),
    member(cite(eu_reg_2016_679_art_4_8), Citations).
test(the_eligible_citations_never_name_the_controller_gate, fail) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(eligible, _, Citations)),
    member(cite(eu_reg_2016_679_art_28_10), Citations).

cp_test_names([the_base_profile_yields_exactly_one_status, the_base_profile_yields_exactly_one_verdict, the_eligible_verdict_carries_citations, the_assess_wrapper_agrees_with_decide, the_missing_list_is_one_solution, the_ineligible_citations_align_with_the_missing_keys, the_checklist_of_the_base_has_twentyone_met_items, the_checklist_starts_with_the_first_limb_in_key_order, the_checklist_ends_with_the_engaged_flag_when_no_other_processor, a_specific_subprocessor_adds_six_limbs, a_general_subprocessor_adds_eight_limbs, the_checklist_is_independent_of_the_role_gate, the_checklist_shows_an_absent_key_as_open_by_absence, the_checklist_shows_unsure_as_open_by_judgement, the_checklist_with_input_problems_is_empty, the_empty_profile_checklist_lists_every_always_limb_open, the_outside_fact_is_one_solution_whatever_the_status, late_authorisation_names_the_art_28_2_limb, no_opportunity_to_object_names_the_art_28_2_limb, no_authorisation_reads_no_timing_key, an_unsure_subprocessor_judgement_refers, the_gate_precedes_the_checklist]).
cp_test_fail_names([the_eligible_citations_never_name_the_processor_gate, the_eligible_citations_never_name_the_controller_gate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
