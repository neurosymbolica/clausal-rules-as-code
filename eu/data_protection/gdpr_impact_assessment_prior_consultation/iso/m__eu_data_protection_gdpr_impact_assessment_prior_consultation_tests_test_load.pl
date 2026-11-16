% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_kernel, [gdpr_impact_assessment_prior_consultation_input_problems/2, gdpr_impact_assessment_prior_consultation_outside_fact_reading/3]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_citations, [citation/2, implements/1, basis_citation/2]).

test(the_final_statuses_are_distinct) :-
    dif(required, not_required).
test(the_bases_are_distinct) :-
    dif(art36_1_residual_high_risk, art36_5_member_state_prior_authorisation),
    dif(art36_1_residual_high_risk, art36_1_condition_not_met),
    dif(art36_5_member_state_prior_authorisation, art36_1_condition_not_met).
test(the_referral_reasons_are_distinct) :-
    dif(open_textured(assessment_indicates_high_risk_absent_mitigation, cite(eu_reg_2016_679_art_36_1)), not_governed_here([cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_36_1)])),
    dif(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_5), cite(member_state_law_requiring_prior_consultation_and_authorisation)), not_governed_here([cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_36_1)])).
test(a_final_verdict_builds_and_destructures) :-
    Verdict = prior_consultation_verdict(required, [art36_1_residual_high_risk], [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true])], [cite(eu_reg_2016_679_art_36_1)]),
    Verdict = prior_consultation_verdict(Status, Bases, Context, Citations),
    Status == required,
    Bases == [art36_1_residual_high_risk],
    Context == [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true])],
    Citations == [cite(eu_reg_2016_679_art_36_1)].
test(an_open_verdict_carries_the_missing_keys) :-
    Verdict = prior_consultation_verdict(indeterminate([impact_assessment_carried_out]), [], [], []),
    Verdict = prior_consultation_verdict(indeterminate(MissingKeys), Bases, Context, Citations),
    MissingKeys == [impact_assessment_carried_out],
    Bases == [],
    Context == [],
    Citations == [].
test(a_referral_verdict_destructures) :-
    Status = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_5), cite(member_state_law_requiring_prior_consultation_and_authorisation)), [resolution(cite(member_state_law_requiring_prior_consultation_and_authorisation), not_attempted), inputs_relied_on([member_state_requires_prior_authorisation - absent])]),
    Status = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Resolution), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_36_5,
    Target == member_state_law_requiring_prior_consultation_and_authorisation,
    Resolution == not_attempted,
    Pairs == [member_state_requires_prior_authorisation - absent].
test(the_residual_risk_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_36_1, _Record).
test(the_member_state_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_36_5, _Record).
test(the_marker_resolves_a_recorded_key) :-
    implements(eu_reg_2016_679_art_35_1).
test(the_residual_risk_basis_cites_article_36_1) :-
    findall(Citation, basis_citation(art36_1_residual_high_risk, Citation), Citations),
    Citations == [cite(eu_reg_2016_679_art_36_1)].
test(the_input_check_loads_and_answers_once) :-
    findall(Problems, gdpr_impact_assessment_prior_consultation_input_problems([attribute(mitigating_measures_taken, false)], Problems), Answers),
    Answers == [[]].
test(the_input_check_names_an_unknown_key) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(foreign_key, true)], [unknown_key(foreign_key)]).
test(the_outside_fact_reading_loads) :-
    gdpr_impact_assessment_prior_consultation_outside_fact_reading([attribute(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none)))], member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none))).
test(an_absent_outside_fact_reads_absent) :-
    gdpr_impact_assessment_prior_consultation_outside_fact_reading([], member_state_requires_prior_authorisation, absent).

test(a_final_status_is_not_an_open_one, fail) :-
    required = indeterminate(_).
test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_final_statuses_are_distinct, the_bases_are_distinct, the_referral_reasons_are_distinct, a_final_verdict_builds_and_destructures, an_open_verdict_carries_the_missing_keys, a_referral_verdict_destructures, the_residual_risk_citation_is_recorded, the_member_state_citation_is_recorded, the_marker_resolves_a_recorded_key, the_residual_risk_basis_cites_article_36_1, the_input_check_loads_and_answers_once, the_input_check_names_an_unknown_key, the_outside_fact_reading_loads, an_absent_outside_fact_reads_absent]).
cp_test_fail_names([a_final_status_is_not_an_open_one, the_placeholder_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
