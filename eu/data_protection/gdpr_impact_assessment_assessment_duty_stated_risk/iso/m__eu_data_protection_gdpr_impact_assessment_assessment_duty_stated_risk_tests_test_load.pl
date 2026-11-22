% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_kernel, [gdpr_impact_assessment_assessment_duty_stated_risk_input_problems/2, strong_and/2, strong_or/2, strong_not/2, leaf_crisp/3, leaf_judgement/3, leaf_outside_blocking/3, leaf_outside_enabling/3]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_citations, [citation/2, implements/1]).

test(the_assessment_verdict_term_builds_and_destructures) :-
    Verdict = impact_assessment_verdict(required, [art35_3_b_large_scale_sensitive_data], [risk_assessment], [inputs_relied_on([processing_on_large_scale - true])], [cite(eu_reg_2016_679_art_35_3_b), cite(eu_reg_2016_679_art_35_7_c)], []),
    Verdict = impact_assessment_verdict(Status, Bases, MissingContents, Context, Citations, RoutesReliedOn),
    Status == required,
    Bases == [art35_3_b_large_scale_sensitive_data],
    MissingContents == [risk_assessment],
    Context == [inputs_relied_on([processing_on_large_scale - true])],
    Citations == [cite(eu_reg_2016_679_art_35_3_b), cite(eu_reg_2016_679_art_35_7_c)],
    RoutesReliedOn == [].
test(the_officer_advice_verdict_term_builds_and_destructures) :-
    Verdict = officer_advice_verdict(not_applicable, [cite(eu_reg_2016_679_art_35_2)]),
    Verdict = officer_advice_verdict(Status, Citations),
    Status == not_applicable,
    Citations == [cite(eu_reg_2016_679_art_35_2)].
test(the_indeterminate_status_is_a_compound_with_one_key) :-
    Verdict = impact_assessment_verdict(indeterminate([processing_on_large_scale]), [], [], [], [], []),
    Verdict = impact_assessment_verdict(indeterminate(MissingKeys), _, _, _, _, _),
    MissingKeys == [processing_on_large_scale].
test(the_referral_status_builds_and_destructures) :-
    Status = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_35_10), cite(member_state_decision_requiring_impact_assessment_before_processing)), [resolution(cite(member_state_decision_requiring_impact_assessment_before_processing), not_attempted), inputs_relied_on([member_state_requires_assessment_despite_general_one - absent])]),
    Status = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(_, Resolution), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_35_10,
    Target == member_state_decision_requiring_impact_assessment_before_processing,
    Resolution == not_attempted,
    Pairs == [member_state_requires_assessment_despite_general_one - absent].
test(the_assessment_status_atoms_are_distinct) :-
    dif(required, not_required).
test(the_officer_status_atoms_are_distinct) :-
    dif(met, not_met),
    dif(met, not_applicable),
    dif(not_met, not_applicable).
test(the_general_duty_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_35_1, _Record).
test(the_officer_advice_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_35_2, _Record).
test(a_national_list_item_citation_is_recorded) :-
    citation(fr_cnil_35_5_list, _Record).
test(the_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_35_10).
test(an_empty_profile_has_no_input_problem) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([], []).
test(an_unknown_key_is_an_input_problem) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(a_crisp_leaf_reads_true_as_met) :-
    leaf_crisp([attribute(special_category_data_processed, true)], special_category_data_processed, met).
test(an_absent_crisp_leaf_is_open_by_absence) :-
    leaf_crisp([], special_category_data_processed, open(absence, special_category_data_processed)).
test(an_unsure_judgement_is_open_by_judgement) :-
    leaf_judgement([attribute(processing_on_large_scale, unsure)], processing_on_large_scale, open(judgement, processing_on_large_scale)).
test(an_absent_blocking_fact_is_unmet) :-
    leaf_outside_blocking([], national_list_requires_assessment, unmet).
test(an_absent_enabling_fact_is_open_by_cross_reference) :-
    leaf_outside_enabling([], member_state_requires_assessment_despite_general_one, open(cross_reference, member_state_requires_assessment_despite_general_one)).
test(the_strong_kleene_combinators_answer) :-
    strong_and([met, unmet], unmet),
    strong_or([unmet, met], met),
    strong_not(unmet, met).

test(a_required_verdict_is_not_a_not_required_verdict, fail) :-
    impact_assessment_verdict(required, [], [], [], [], []) = impact_assessment_verdict(not_required, [], [], [], [], []).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).
test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).
test(an_unknown_key_is_not_a_clean_profile, fail) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(colour, red)], []).

cp_test_names([the_assessment_verdict_term_builds_and_destructures, the_officer_advice_verdict_term_builds_and_destructures, the_indeterminate_status_is_a_compound_with_one_key, the_referral_status_builds_and_destructures, the_assessment_status_atoms_are_distinct, the_officer_status_atoms_are_distinct, the_general_duty_citation_is_recorded, the_officer_advice_citation_is_recorded, a_national_list_item_citation_is_recorded, the_marker_succeeds_for_a_recorded_key, an_empty_profile_has_no_input_problem, an_unknown_key_is_an_input_problem, a_crisp_leaf_reads_true_as_met, an_absent_crisp_leaf_is_open_by_absence, an_unsure_judgement_is_open_by_judgement, an_absent_blocking_fact_is_unmet, an_absent_enabling_fact_is_open_by_cross_reference, the_strong_kleene_combinators_answer]).
cp_test_fail_names([a_required_verdict_is_not_a_not_required_verdict, the_placeholder_citation_is_gone, the_marker_fails_for_an_unrecorded_key, an_unknown_key_is_not_a_clean_profile]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
