% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_3_gatekeeper_order_kernel, [dma_art_3_gatekeeper_order_input_problems/2, dma_art_3_gatekeeper_order_contract_key/2, dma_art_3_gatekeeper_order_outside_fact/3, dma_art_3_gatekeeper_order_merge_citations/3]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dma_art_3_gatekeeper_order_verdict(requirements_presumed_met, [cite(eu_reg_2022_1925_art_3_1), cite(eu_reg_2022_1925_art_3_2)]),
    Verdict = dma_art_3_gatekeeper_order_verdict(Status, Citations),
    Status == requirements_presumed_met,
    Citations == [cite(eu_reg_2022_1925_art_3_1), cite(eu_reg_2022_1925_art_3_2)].
test(the_indeterminate_status_names_one_key) :-
    Verdict = dma_art_3_gatekeeper_order_verdict(indeterminate([rebuttal_arguments_presented]), []),
    Verdict = dma_art_3_gatekeeper_order_verdict(indeterminate(MissingKeys), Citations),
    MissingKeys == [rebuttal_arguments_presented],
    Citations == [].
test(the_cross_reference_referral_destructures) :-
    Status = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_3_9), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]),
    Status = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(ResolutionTarget), Resolution), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2022_1925_art_3_9,
    Target == commission_designation_decision,
    ResolutionTarget == Target,
    Resolution == not_attempted,
    Pairs == [designated_as_gatekeeper_for_core_platform_service - absent].
test(the_open_textured_referral_destructures) :-
    Status = needs_legal_review(open_textured(entrenched_and_durable_position, cite(eu_reg_2022_1925_art_3_1_c)), [inputs_relied_on([significant_impact_on_internal_market - true, core_platform_service_is_important_gateway - true, entrenched_and_durable_position - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == entrenched_and_durable_position,
    Citation == eu_reg_2022_1925_art_3_1_c,
    length(Pairs, 3).
test(the_basis_copies_an_outside_fact) :-
    Basis = [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host, today, reason, none)))],
    Basis = [outside_fact(Key, attested(Value, attestation(_, _, _, Evidence)))],
    Key == designated_as_gatekeeper_for_core_platform_service,
    Value == true,
    Evidence == none.
test(the_threshold_atoms_are_distinct) :-
    dif(impact_threshold_met, impact_threshold_not_met),
    dif(gateway_threshold_met, gateway_threshold_not_met),
    dif(entrenchment_threshold_met, entrenchment_threshold_not_met).
test(the_presumption_atoms_are_distinct) :-
    dif(gatekeeper_presumed, gatekeeper_not_presumed).
test(the_requirement_atoms_are_distinct) :-
    dif(requirements_presumed_met, requirements_met),
    dif(requirements_presumed_met, requirements_not_met),
    dif(requirements_met, requirements_not_met).
test(the_designation_atoms_are_distinct) :-
    dif(designated_gatekeeper, not_designated_gatekeeper).
test(the_impact_threshold_citation_is_recorded) :-
    citation(eu_reg_2022_1925_art_3_2_a, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_designation_citation_is_recorded) :-
    citation(eu_reg_2022_1925_art_3_9, _Record).
test(the_referral_target_is_recorded_without_verbatim) :-
    citation(commission_rebuttal_conclusion, Record),
    Record = [label - _, ref - _].
test(a_recorded_key_implements) :-
    implements(eu_reg_2022_1925_art_3_5).
test(the_contract_has_seventeen_keys) :-
    findall(Key, dma_art_3_gatekeeper_order_contract_key(Key, _), Keys),
    length(Keys, 17).
test(the_crisp_key_is_boolean) :-
    dma_art_3_gatekeeper_order_contract_key(rebuttal_arguments_presented, boolean).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dma_art_3_gatekeeper_order_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_negative_figure_is_wrong_type) :-
    dma_art_3_gatekeeper_order_input_problems([attribute(member_states_where_core_platform_service_provided, -1)], [wrong_type(member_states_where_core_platform_service_provided)]).
test(an_absent_outside_fact_reads_absent) :-
    dma_art_3_gatekeeper_order_outside_fact([], rebuttal_accepted_by_commission, absent).
test(citations_merge_each_once) :-
    dma_art_3_gatekeeper_order_merge_citations([cite(eu_reg_2022_1925_art_3_2_a)], [cite(eu_reg_2022_1925_art_3_2_a), cite(eu_reg_2022_1925_art_3_2_b)], Merged),
    Merged == [cite(eu_reg_2022_1925_art_3_2_a), cite(eu_reg_2022_1925_art_3_2_b)].

test(the_met_atom_is_not_the_not_met_atom, fail) :-
    impact_threshold_met = impact_threshold_not_met.
test(an_unrecorded_key_does_not_implement, fail) :-
    implements(eu_reg_2022_1925_art_3_8).
test(a_negative_figure_has_some_problem, fail) :-
    dma_art_3_gatekeeper_order_input_problems([attribute(member_states_where_core_platform_service_provided, -1)], []).

cp_test_names([the_verdict_term_carries_status_and_citations, the_indeterminate_status_names_one_key, the_cross_reference_referral_destructures, the_open_textured_referral_destructures, the_basis_copies_an_outside_fact, the_threshold_atoms_are_distinct, the_presumption_atoms_are_distinct, the_requirement_atoms_are_distinct, the_designation_atoms_are_distinct, the_impact_threshold_citation_is_recorded, the_designation_citation_is_recorded, the_referral_target_is_recorded_without_verbatim, a_recorded_key_implements, the_contract_has_seventeen_keys, the_crisp_key_is_boolean, an_empty_profile_has_no_problem, a_negative_figure_is_wrong_type, an_absent_outside_fact_reads_absent, citations_merge_each_once]).
cp_test_fail_names([the_met_atom_is_not_the_not_met_atom, an_unrecorded_key_does_not_implement, a_negative_figure_has_some_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
