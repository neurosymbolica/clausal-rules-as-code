% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_gpai_models_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_ai_act_gpai_models_gpai_models, [decide_gpai_models/2, gpai_models_status_values/1, systemic_risk_classification_status/4, provider_obligation_status/5]).
:- use_module(m__eu_ai_act_gpai_models_fixtures, [gpai_models_subject/1, gpai_models_profile_for/2]).

subject_classifies(Subject) :-
    gpai_models_subject(Subject),
    gpai_models_profile_for(Subject, Request),
    decide_gpai_models(Request, _Verdict).

subject_verdict_count(Subject, Count) :-
    gpai_models_profile_for(Subject, Request),
    findall(Verdict, decide_gpai_models(Request, Verdict), Verdicts),
    length(Verdicts, Count).

result_form(indeterminate(_), not_final).
result_form(needs_legal_review(_, _), not_final).
result_form(input_problems(_), not_final).
result_form(Status, final) :-
    atom(Status),
    gpai_models_status_values(StatusValues),
    member(Status, StatusValues).
result_form([Element|Elements], element_list) :-
    is_list([Element|Elements]).

citations_fit(not_final, []).
citations_fit(final, [Citation|Citations]) :-
    maplist(citation_term, [Citation|Citations]).
citations_fit(element_list, [Citation|Citations]) :-
    maplist(citation_term, [Citation|Citations]).

citation_term(cite(CitationKey)) :-
    atom(CitationKey).

subject_consistent(Subject) :-
    gpai_models_subject(Subject),
    gpai_models_profile_for(Subject, Request),
    decide_gpai_models(Request, gpai_models_verdict(Status, Citations)),
    result_form(Status, ResultForm),
    citations_fit(ResultForm, Citations).

classification_at_computation(Computation, Status) :-
    systemic_risk_classification_status([attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, Computation), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, false)], date(2026, 1, 15), Status, _).

designated_status(Computation, HighImpact, Accepted, Status) :-
    systemic_risk_classification_status([attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, Computation), attribute(high_impact_capabilities, HighImpact), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, true), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, Accepted)], date(2026, 1, 15), Status, _).

obligation_for(Obligation, Licence, Public, Computation, Status) :-
    provider_obligation_status([attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, Computation), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, false), attribute(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, Licence), attribute(parameters_weights_architecture_and_usage_information_made_publicly_available, Public), attribute(provider_established_in_a_third_country, false), attribute(placed_on_the_market_before_2_august_2025, false)], Obligation, date(2026, 1, 15), Status, _).

test(totality_every_subject_classifies) :-
    findall(Subject, gpai_models_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_yields_exactly_one_verdict) :-
    findall(Count, (gpai_models_subject(Subject), subject_verdict_count(Subject, Count)), Counts),
    Counts = [_|_],
    maplist(=(1), Counts).
test(consistency_citations_follow_the_finality_of_the_answer) :-
    findall(Subject, gpai_models_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_consistent(Subject), ConsistentSubjects),
    sort(ConsistentSubjects, SubjectSet).
test(the_threshold_is_monotone_and_strict) :-
    maplist(classification_at_computation, [0, 9999999999999999999999999, 10000000000000000000000000, 10000000000000000000000001, 100000000000000000000000000], Statuses),
    Statuses == [general_purpose_ai_model_without_systemic_risk, general_purpose_ai_model_without_systemic_risk, general_purpose_ai_model_without_systemic_risk, general_purpose_ai_model_with_systemic_risk, general_purpose_ai_model_with_systemic_risk].
test(a_designation_classifies_whatever_the_arguments) :-
    findall(Status, (member(Computation, [0, 10000000000000000000000001]), member(HighImpact, [true, false]), member(Accepted, [true, false]), designated_status(Computation, HighImpact, Accepted, Status)), Statuses),
    length(Statuses, 8),
    maplist(==(general_purpose_ai_model_with_systemic_risk), Statuses).
test(duties_without_an_exception_always_apply) :-
    findall(Status, (member(Obligation, [copyright_policy, training_content_summary, cooperation_with_authorities]), member(Licence, [true, false]), member(Public, [true, false]), member(Computation, [0, 10000000000000000000000001]), obligation_for(Obligation, Licence, Public, Computation, Status)), Statuses),
    length(Statuses, 24),
    maplist(==(obligation_applies), Statuses).
test(article_55_duties_do_not_apply_without_systemic_risk) :-
    findall(Status, (member(Obligation, [model_evaluation, systemic_risk_assessment_and_mitigation, serious_incident_reporting, cybersecurity_protection]), member(Licence, [true, false]), obligation_for(Obligation, Licence, true, 0, Status)), Statuses),
    length(Statuses, 8),
    maplist(==(obligation_does_not_apply), Statuses).
test(article_55_duties_apply_with_systemic_risk) :-
    findall(Status, (member(Obligation, [model_evaluation, systemic_risk_assessment_and_mitigation, serious_incident_reporting, cybersecurity_protection]), member(Licence, [true, false]), obligation_for(Obligation, Licence, true, 10000000000000000000000001, Status)), Statuses),
    length(Statuses, 8),
    maplist(==(obligation_applies), Statuses).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_yields_exactly_one_verdict, consistency_citations_follow_the_finality_of_the_answer, the_threshold_is_monotone_and_strict, a_designation_classifies_whatever_the_arguments, duties_without_an_exception_always_apply, article_55_duties_do_not_apply_without_systemic_risk, article_55_duties_apply_with_systemic_risk]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
