% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_3_gatekeeper_order_dma_art_3_gatekeeper_order, [decide_dma_art_3_gatekeeper_order/2, impact_threshold_status/3, gateway_threshold_status/3, entrenchment_threshold_status/3, presumption_status/3, designation_requirements_status/4, gatekeeper_status/4]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_fixtures, [dma_art_3_gatekeeper_order_subject/1, dma_art_3_gatekeeper_order_profile_for/2]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_kernel, [dma_art_3_gatekeeper_order_input_problems/2]).

subject_classifies(Subject) :-
    dma_art_3_gatekeeper_order_subject(Subject),
    dma_art_3_gatekeeper_order_profile_for(Subject, Profile),
    decide_dma_art_3_gatekeeper_order(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, dma_art_3_gatekeeper_order_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject - Count, (dma_art_3_gatekeeper_order_subject(Subject), subject_verdict_count(Subject, Count)), Observed),
    findall(Subject - 1, dma_art_3_gatekeeper_order_subject(Subject), Observed).
test(determinism_every_query_yields_exactly_one_solution_per_subject) :-
    findall(Subject - Query - Count, subject_query_count(Subject, Query, Count), Observed),
    findall(Subject - Query - 1, (dma_art_3_gatekeeper_order_subject(Subject), query_name(Query)), Observed).
test(determinism_every_query_yields_one_solution_on_the_empty_profile) :-
    findall(Query - Count, (query_name(Query), query_answer_count(Query, [], Count)), Observed),
    findall(Query - 1, query_name(Query), Observed).
test(totality_the_input_check_answers_once_for_a_non_profile) :-
    findall(Problems, dma_art_3_gatekeeper_order_input_problems(nothing, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(citation_completeness_final_cites_and_open_does_not) :-
    findall(Subject - Shape, subject_citation_shape(Subject, Shape), Observed),
    findall(Subject - consistent, dma_art_3_gatekeeper_order_subject(Subject), Observed).
test(invariant_is_not_vacuous_a_subject_meets_both) :-
    dma_art_3_gatekeeper_order_profile_for(all_thresholds_at_boundary, Profile),
    entrenchment_threshold_status(Profile, entrenchment_threshold_met, _),
    gateway_threshold_status(Profile, gateway_threshold_met, _).

subject_verdict_count(Subject, Count) :-
    dma_art_3_gatekeeper_order_profile_for(Subject, Profile),
    findall(Verdict, decide_dma_art_3_gatekeeper_order(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

query_name(impact).
query_name(gateway).
query_name(entrenchment).
query_name(presumption).
query_name(designation_requirements).
query_name(gatekeeper).

query_answer_count(impact, Profile, Count) :-
    findall(Result - Citations, impact_threshold_status(Profile, Result, Citations), Answers),
    length(Answers, Count).
query_answer_count(gateway, Profile, Count) :-
    findall(Result - Citations, gateway_threshold_status(Profile, Result, Citations), Answers),
    length(Answers, Count).
query_answer_count(entrenchment, Profile, Count) :-
    findall(Result - Citations, entrenchment_threshold_status(Profile, Result, Citations), Answers),
    length(Answers, Count).
query_answer_count(presumption, Profile, Count) :-
    findall(Result - Citations, presumption_status(Profile, Result, Citations), Answers),
    length(Answers, Count).
query_answer_count(designation_requirements, Profile, Count) :-
    findall(Result - Basis - Citations, designation_requirements_status(Profile, Result, Basis, Citations), Answers),
    length(Answers, Count).
query_answer_count(gatekeeper, Profile, Count) :-
    findall(Result - Basis - Citations, gatekeeper_status(Profile, Result, Basis, Citations), Answers),
    length(Answers, Count).

subject_query_count(Subject, Query, Count) :-
    dma_art_3_gatekeeper_order_subject(Subject),
    dma_art_3_gatekeeper_order_profile_for(Subject, Profile),
    query_name(Query),
    query_answer_count(Query, Profile, Count).

status_kind(requirements_presumed_met, final).
status_kind(requirements_met, final).
status_kind(requirements_not_met, final).
status_kind(indeterminate(_), open).
status_kind(needs_legal_review(_, _), open).
status_kind(input_problems(_), open).

citation_shape(final, [_|_], consistent).
citation_shape(final, [], inconsistent).
citation_shape(open, [], consistent).
citation_shape(open, [_|_], inconsistent).

subject_citation_shape(Subject, Shape) :-
    dma_art_3_gatekeeper_order_subject(Subject),
    dma_art_3_gatekeeper_order_profile_for(Subject, Profile),
    decide_dma_art_3_gatekeeper_order(Profile, dma_art_3_gatekeeper_order_verdict(Status, Citations)),
    status_kind(Status, Kind),
    citation_shape(Kind, Citations, Shape).

entrenchment_met_without_gateway_met(Subject) :-
    dma_art_3_gatekeeper_order_subject(Subject),
    dma_art_3_gatekeeper_order_profile_for(Subject, Profile),
    entrenchment_threshold_status(Profile, entrenchment_threshold_met, _),
    gateway_threshold_status(Profile, GatewayResult, _),
    dif(GatewayResult, gateway_threshold_met).

test(invariant_entrenchment_met_implies_gateway_met, fail) :-
    entrenchment_met_without_gateway_met(_Subject).
test(invariant_presumption_needs_the_impact_threshold, fail) :-
    presumed_without_all_points(_Subject).

presumed_without_all_points(Subject) :-
    dma_art_3_gatekeeper_order_subject(Subject),
    dma_art_3_gatekeeper_order_profile_for(Subject, Profile),
    presumption_status(Profile, gatekeeper_presumed, _),
    impact_threshold_status(Profile, ImpactResult, _),
    dif(ImpactResult, impact_threshold_met).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_query_yields_exactly_one_solution_per_subject, determinism_every_query_yields_one_solution_on_the_empty_profile, totality_the_input_check_answers_once_for_a_non_profile, citation_completeness_final_cites_and_open_does_not, invariant_is_not_vacuous_a_subject_meets_both]).
cp_test_fail_names([invariant_entrenchment_met_implies_gateway_met, invariant_presumption_needs_the_impact_threshold]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
