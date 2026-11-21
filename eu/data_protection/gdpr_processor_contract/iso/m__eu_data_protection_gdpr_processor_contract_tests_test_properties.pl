% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [not_member/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [decide_processor_contract/2, processor_contract_status/2, contract_missing_stipulations/2, contract_checklist/2, processor_contract_outside_facts/2, decide_processor_contract_status/2, processor_contract_status_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_fixtures, [gdpr_processor_contract_subject/1, gdpr_processor_contract_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_processor_contract_subject(Subject),
    gdpr_processor_contract_profile_for(Subject, Profile),
    decide_processor_contract_status(Profile, _Verdict).

solution_count(Template, Goal, Count) :-
    findall(Template, Goal, Solutions),
    length(Solutions, Count).

answers_once(Subject) :-
    gdpr_processor_contract_profile_for(Subject, Profile),
    solution_count(Verdict, decide_processor_contract(Profile, Verdict), 1),
    solution_count(Status, processor_contract_status(Profile, Status), 1),
    solution_count(Missing, contract_missing_stipulations(Profile, Missing), 1),
    solution_count(Items, contract_checklist(Profile, Items), 1),
    solution_count(OutsideFacts, processor_contract_outside_facts(Profile, OutsideFacts), 1).

projections_agree(Subject) :-
    gdpr_processor_contract_profile_for(Subject, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(Status, Missing, _)),
    processor_contract_status(Profile, Status),
    contract_missing_stipulations(Profile, Missing).

verdict_invariant(processor_contract_verdict(eligible, [], [Citation|Citations])) :-
    not_member(cite(eu_reg_2016_679_art_4_8), [Citation|Citations]),
    not_member(cite(eu_reg_2016_679_art_28_10), [Citation|Citations]).
verdict_invariant(processor_contract_verdict(ineligible, [Key|Keys], Citations)) :-
    same_length([Key|Keys], Citations).
verdict_invariant(processor_contract_verdict(not_applicable, [], [cite(eu_reg_2016_679_art_4_8)])).
verdict_invariant(processor_contract_verdict(indeterminate([_|_]), [], [])).
verdict_invariant(processor_contract_verdict(needs_legal_review(Reason, [inputs_relied_on(_)]), [], [])) :-
    referral_reason(Reason).
verdict_invariant(processor_contract_verdict(input_problems([_|_]), [], [])).

referral_reason(open_textured(_, cite(_))).
referral_reason(deferred_provision(cite(_))).

subject_verdict_invariant(Subject) :-
    gdpr_processor_contract_profile_for(Subject, Profile),
    decide_processor_contract(Profile, Verdict),
    verdict_invariant(Verdict).

item_well_formed(checklist_item(Key, cite(Citation), State)) :-
    atom(Key),
    atom(Citation),
    member(State, [met, unmet, open_by_absence, open_by_judgement]).

subject_checklist_well_formed(Subject) :-
    gdpr_processor_contract_profile_for(Subject, Profile),
    contract_checklist(Profile, Items),
    maplist(item_well_formed, Items).

checklist_of(Subject, Items) :-
    gdpr_processor_contract_profile_for(Subject, Profile),
    contract_checklist(Profile, Items).

verdict_of(Subject, Verdict) :-
    gdpr_processor_contract_profile_for(Subject, Profile),
    decide_processor_contract(Profile, Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_processor_contract_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_once) :-
    findall(Subject, gdpr_processor_contract_subject(Subject), Subjects),
    maplist(answers_once, Subjects).
test(projections_agree_with_the_verdict) :-
    findall(Subject, gdpr_processor_contract_subject(Subject), Subjects),
    maplist(projections_agree, Subjects).
test(every_verdict_has_the_shape_of_its_status) :-
    findall(Subject, gdpr_processor_contract_subject(Subject), Subjects),
    maplist(subject_verdict_invariant, Subjects).
test(every_checklist_item_is_cited_and_stated) :-
    findall(Subject, gdpr_processor_contract_subject(Subject), Subjects),
    maplist(subject_checklist_well_formed, Subjects).
test(the_checklist_is_independent_of_the_first_gate) :-
    checklist_of(eligible_without_subprocessor, Base),
    checklist_of(not_applicable_not_on_behalf, Gated),
    Base == Gated.
test(the_checklist_is_independent_of_the_second_gate) :-
    checklist_of(eligible_without_subprocessor, Base),
    checklist_of(role_controller_deferred, Gated),
    Base == Gated.
test(the_outside_fact_never_changes_the_verdict) :-
    verdict_of(eligible_without_subprocessor, Without),
    verdict_of(eligible_with_standard_clauses_recorded, With),
    Without == With.
test(unread_keys_never_change_the_verdict) :-
    verdict_of(eligible_without_subprocessor, Base),
    verdict_of(unread_keys_ignored, Unread),
    Base == Unread.
test(the_status_table_is_the_bare_vocabulary) :-
    processor_contract_status_status_values(Values),
    Values == [eligible, ineligible, not_applicable].
test(the_bare_indeterminate_has_a_compound_twin) :-
    gdpr_processor_contract_profile_for(role_processing_absent, Profile),
    processor_contract_status(Profile, indeterminate([processing_on_behalf_of_controller])).
test(invariant_accepts_a_well_formed_eligible) :-
    verdict_invariant(processor_contract_verdict(eligible, [], [cite(eu_reg_2016_679_art_28_3)])).
test(item_check_accepts_a_known_state) :-
    item_well_formed(checklist_item(contract_in_writing, cite(eu_reg_2016_679_art_28_9), open_by_absence)).

test(the_bare_indeterminate_is_never_a_status, fail) :-
    gdpr_processor_contract_subject(Subject),
    gdpr_processor_contract_profile_for(Subject, Profile),
    processor_contract_status(Profile, indeterminate).
test(invariant_rejects_ineligible_without_missing, fail) :-
    verdict_invariant(processor_contract_verdict(ineligible, [], [])).
test(invariant_rejects_misaligned_citations, fail) :-
    verdict_invariant(processor_contract_verdict(ineligible, [contract_in_writing], [])).
test(invariant_rejects_a_gate_citation_in_eligible, fail) :-
    verdict_invariant(processor_contract_verdict(eligible, [], [cite(eu_reg_2016_679_art_28_3), cite(eu_reg_2016_679_art_4_8)])).
test(invariant_rejects_an_empty_missing_key_list, fail) :-
    verdict_invariant(processor_contract_verdict(indeterminate([]), [], [])).
test(item_check_rejects_an_unknown_state, fail) :-
    item_well_formed(checklist_item(contract_in_writing, cite(eu_reg_2016_679_art_28_9), unknown)).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_once, projections_agree_with_the_verdict, every_verdict_has_the_shape_of_its_status, every_checklist_item_is_cited_and_stated, the_checklist_is_independent_of_the_first_gate, the_checklist_is_independent_of_the_second_gate, the_outside_fact_never_changes_the_verdict, unread_keys_never_change_the_verdict, the_status_table_is_the_bare_vocabulary, the_bare_indeterminate_has_a_compound_twin, invariant_accepts_a_well_formed_eligible, item_check_accepts_a_known_state]).
cp_test_fail_names([the_bare_indeterminate_is_never_a_status, invariant_rejects_ineligible_without_missing, invariant_rejects_misaligned_citations, invariant_rejects_a_gate_citation_in_eligible, invariant_rejects_an_empty_missing_key_list, item_check_rejects_an_unknown_state]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
