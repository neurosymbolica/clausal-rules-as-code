% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_scc_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_kernel, [gdpr_transfer_scc_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_citations, [citation/2, implements/1]).

test(the_module_atoms_are_distinct) :-
    dif(module_one, module_two),
    dif(module_one, module_three),
    dif(module_one, module_four),
    dif(module_two, module_three),
    dif(module_two, module_four),
    dif(module_three, module_four).
test(the_availability_atoms_are_distinct) :-
    dif(clauses_available, clauses_not_available).
test(the_safeguard_atoms_are_distinct) :-
    dif(appropriate_safeguards_provided, appropriate_safeguards_not_provided).
test(the_appendix_atoms_are_distinct) :-
    dif(appendix_complete, appendix_incomplete).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_transfer_scc_verdict(appropriate_safeguards_provided, [cite(eu_dec_2021_914_art_1)]),
    Verdict = gdpr_transfer_scc_verdict(Status, Citations),
    Status == appropriate_safeguards_provided,
    Citations == [cite(eu_dec_2021_914_art_1)].
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([exporter_role]),
    Result = indeterminate([MissingKey]),
    MissingKey == exporter_role.
test(the_cross_reference_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_dec_2021_914_art_1), cite(standard_contractual_clauses_decision_in_force_statement)), [resolution(cite(standard_contractual_clauses_decision_in_force_statement), not_attempted), inputs_relied_on([standard_contractual_clauses_decision_in_force - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), Context),
    Context = [resolution(cite(Target), Resolution), inputs_relied_on([Key - Value])],
    Citation == eu_dec_2021_914_art_1,
    Resolution == not_attempted,
    Key == standard_contractual_clauses_decision_in_force,
    Value == absent.
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(added_clauses_contradict_clauses, cite(eu_dec_2021_914_annex_cl_2_a)), [inputs_relied_on([added_clauses_contradict_clauses - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == added_clauses_contradict_clauses,
    Citation == eu_dec_2021_914_annex_cl_2_a,
    Pairs == [added_clauses_contradict_clauses - unsure].
test(the_basis_item_carries_the_attested_term) :-
    Attested = attested(true, attestation(by, at, reason, none)),
    Item = outside_fact(exporter_processing_subject_to_gdpr, Attested),
    Item = outside_fact(Key, attested(Value, attestation(_, _, _, Evidence))),
    Key == exporter_processing_subject_to_gdpr,
    Value == true,
    Evidence == none.
test(the_article_one_citation_is_recorded) :-
    citation(eu_dec_2021_914_art_1, _Record).
test(the_clause_fourteen_citation_is_recorded) :-
    citation(eu_dec_2021_914_annex_cl_14_m1m2m3m4_a, _Record).
test(the_article_forty_six_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_46_2_c, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_dec_2021_914_annex_ii).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_transfer_scc_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(standard_contractual_clauses_decision_in_force, attested(true, attestation(by, at, reason, none))), attribute(exporter_processing_subject_to_gdpr, attested(true, attestation(by, at, reason, none))), attribute(importer_processing_subject_to_gdpr, attested(false, attestation(by, at, reason, none))), attribute(exporter_role, controller), attribute(importer_role, processor), attribute(module_selected, module_two), attribute(added_clauses_contradict_clauses, unsure), attribute(sub_processor_authorisation_option, specific_prior_authorisation), attribute(annex_iii_list_of_sub_processors_completed, true)],
    findall(Problems, gdpr_transfer_scc_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, gdpr_transfer_scc_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, gdpr_transfer_scc_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_bare_boolean_outside_fact_is_wrong_type) :-
    gdpr_transfer_scc_input_problems([attribute(standard_contractual_clauses_decision_in_force, true)], Problems),
    Problems == [wrong_type(standard_contractual_clauses_decision_in_force)].
test(an_attested_role_is_wrong_type) :-
    gdpr_transfer_scc_input_problems([attribute(exporter_role, attested(true, attestation(by, at, reason, none)))], Problems),
    Problems == [wrong_type(exporter_role)].
test(an_unsure_crisp_key_is_wrong_type) :-
    gdpr_transfer_scc_input_problems([attribute(clauses_modified, unsure)], Problems),
    Problems == [wrong_type(clauses_modified)].
test(problems_come_in_contract_order_then_unknown_keys) :-
    Profile = [attribute(unlisted_key, true), attribute(importer_role, maybe), attribute(exporter_role, controller), attribute(exporter_role, processor)],
    findall(Problems, gdpr_transfer_scc_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(exporter_role), wrong_type(importer_role), unknown_key(unlisted_key)]].
test(a_duplicate_key_is_named_once) :-
    gdpr_transfer_scc_input_problems([attribute(exporter_role, nonsense), attribute(exporter_role, controller)], [duplicate_key(exporter_role)]).

test(a_placeholder_key_is_not_implemented, fail) :-
    implements(eu_todo_primary_source).
test(a_duplicate_key_is_not_also_wrong_type, fail) :-
    gdpr_transfer_scc_input_problems([attribute(exporter_role, nonsense), attribute(exporter_role, controller)], [wrong_type(exporter_role)]).

cp_test_names([the_module_atoms_are_distinct, the_availability_atoms_are_distinct, the_safeguard_atoms_are_distinct, the_appendix_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_status_names_one_key, the_cross_reference_referral_destructures, the_open_textured_referral_destructures, the_basis_item_carries_the_attested_term, the_article_one_citation_is_recorded, the_clause_fourteen_citation_is_recorded, the_article_forty_six_citation_is_recorded, a_recorded_key_is_implemented, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, a_bare_boolean_outside_fact_is_wrong_type, an_attested_role_is_wrong_type, an_unsure_crisp_key_is_wrong_type, problems_come_in_contract_order_then_unknown_keys, a_duplicate_key_is_named_once]).
cp_test_fail_names([a_placeholder_key_is_not_implemented, a_duplicate_key_is_not_also_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
