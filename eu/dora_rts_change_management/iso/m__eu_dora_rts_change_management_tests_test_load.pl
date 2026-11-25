% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_change_management_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_change_management_kernel, [dora_rts_change_management_input_problems/2]).
:- use_module(m__eu_dora_rts_change_management_citations, [citation/2, implements/1]).

test(the_article_17_1_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_17_1, _Record).
test(the_article_17_2_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_17_2, _Record).
test(the_dora_article_16_1_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(the_citation_record_has_label_ref_and_verbatim) :-
    citation(eu_reg_2024_1774_art_17_2, Record),
    Record = [label - Label, ref - Reference, verbatim - Verbatim],
    atom(Label),
    atom(Reference),
    atom(Verbatim).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2024_1774_art_17_1).
test(the_complete_and_incomplete_atoms_are_distinct) :-
    dif(complete, incomplete).
test(the_final_atoms_are_distinct_from_the_gate_answer) :-
    dif(complete, simplified_framework_entity),
    dif(incomplete, simplified_framework_entity),
    dif(none_outstanding, simplified_framework_entity),
    dif(none_outstanding, complete).
test(the_two_central_entity_types_are_distinct) :-
    dif(central_counterparty, central_securities_depository).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_rts_change_management_verdict(complete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]),
    Verdict = dora_rts_change_management_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)].
test(the_required_term_destructures) :-
    Result = required([verification_of_ict_security_requirements, stringent_testing_after_significant_changes]),
    Result = required(Duties),
    Duties = [FirstDuty|_],
    FirstDuty == verification_of_ict_security_requirements.
test(the_outstanding_term_destructures) :-
    Result = outstanding([central_counterparty_involvement_of_parties_in_testing]),
    Result = outstanding(Duties),
    Duties == [central_counterparty_involvement_of_parties_in_testing].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate([MissingKey]),
    MissingKey == financial_entity_is_article_16_1_entity.
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(change_procedures_ensure_independence_of_approving_functions, cite(eu_reg_2024_1774_art_17_1)), [inputs_relied_on([financial_entity_is_article_16_1_entity - false, change_procedures_ensure_independence_of_approving_functions - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == change_procedures_ensure_independence_of_approving_functions,
    citation(CitationKey, _Record),
    Pairs = [_|_].
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dora_rts_change_management_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, central_counterparty), attribute(significant_changes_made_to_ict_systems, true), attribute(change_procedures_verify_whether_ict_security_requirements_met, unsure)],
    findall(Problems, dora_rts_change_management_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, dora_rts_change_management_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, dora_rts_change_management_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_entity_type_outside_the_list_is_wrong_type) :-
    dora_rts_change_management_input_problems([attribute(dora_entity_type, bank)], Problems),
    Problems == [wrong_type(dora_entity_type)].
test(an_unsure_gate_is_wrong_type) :-
    dora_rts_change_management_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity)].
test(a_repeated_contract_key_is_duplicate_key_only) :-
    dora_rts_change_management_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, maybe)], Problems),
    Problems == [duplicate_key(financial_entity_is_article_16_1_entity)].
test(a_key_outside_the_contract_is_unknown_key_after_contract_problems) :-
    dora_rts_change_management_input_problems([attribute(colour, _Value), attribute(dora_entity_type, bank)], Problems),
    Problems == [wrong_type(dora_entity_type), unknown_key(colour)].

test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2024_1774_art_17_3).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_article_17_1_citation_is_recorded, the_article_17_2_citation_is_recorded, the_dora_article_16_1_citation_is_recorded, the_citation_record_has_label_ref_and_verbatim, the_provenance_marker_holds_for_a_recorded_key, the_complete_and_incomplete_atoms_are_distinct, the_final_atoms_are_distinct_from_the_gate_answer, the_two_central_entity_types_are_distinct, the_verdict_term_carries_status_and_citations, the_required_term_destructures, the_outstanding_term_destructures, the_indeterminate_term_names_one_key, the_referral_term_destructures, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, an_entity_type_outside_the_list_is_wrong_type, an_unsure_gate_is_wrong_type, a_repeated_contract_key_is_duplicate_key_only, a_key_outside_the_contract_is_unknown_key_after_contract_problems]).
cp_test_fail_names([the_provenance_marker_fails_for_an_unrecorded_key, the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
