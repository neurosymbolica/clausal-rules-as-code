% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_post_market_monitoring_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_post_market_monitoring_post_market_monitoring, [decide_post_market_monitoring/2, post_market_monitoring_duty_status/4, post_market_monitoring_integration_status/3, post_market_monitoring_status_values/1]).
:- use_module(m__eu_ai_act_post_market_monitoring_fixtures, [post_market_monitoring_subject/1, post_market_monitoring_profile_for/2]).

subject_set(SubjectSet) :-
    findall(Subject, post_market_monitoring_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    post_market_monitoring_subject(Subject),
    post_market_monitoring_profile_for(Subject, Request),
    decide_post_market_monitoring(Request, _Verdict).

subject_answer_count(Subject, Count) :-
    post_market_monitoring_profile_for(Subject, Request),
    findall(Verdict, decide_post_market_monitoring(Request, Verdict), Verdicts),
    length(Verdicts, Count).

subject_well_formed(Subject) :-
    post_market_monitoring_subject(Subject),
    post_market_monitoring_profile_for(Subject, Request),
    decide_post_market_monitoring(Request, Verdict),
    well_formed_verdict(Verdict).

well_formed_verdict(post_market_monitoring_verdict(Status, Citations)) :-
    atom(Status),
    post_market_monitoring_status_values(StatusValues),
    member(Status, StatusValues),
    Citations = [_|_],
    sort(Citations, SortedCitations),
    length(Citations, CitationCount),
    length(SortedCitations, CitationCount),
    maplist(cite_term, Citations).
well_formed_verdict(post_market_monitoring_verdict(Status, [])) :-
    compound(Status),
    functor(Status, Name, Arity),
    member(Name/Arity, [indeterminate/1, needs_legal_review/2, input_problems/1]).

cite_term(cite(CitationKey)) :-
    atom(CitationKey).

duty_keys([provider_of_the_system, system_is_a_high_risk_ai_system_listed_in_annex_iii, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, significant_changes_in_design_as_from_the_chapter_iii_date, intended_to_be_used_by_public_authorities]).

integration_keys([provider_of_the_system, system_is_a_high_risk_ai_system_listed_in_annex_iii, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, point_5_annex_iii_system_of_a_financial_institution_under_union_financial_services_law, post_market_monitoring_system_and_plan_already_established_under_that_legislation, integration_achieves_an_equivalent_level_of_protection]).

truth_value(true).
truth_value(false).

attribute_pair(ProfileKey, Value, attribute(ProfileKey, Value)).

complete_profile(ProfileKeys, Profile) :-
    length(ProfileKeys, KeyCount),
    length(Values, KeyCount),
    maplist(truth_value, Values),
    maplist(attribute_pair, ProfileKeys, Values, Profile).

non_provider_profile(ProfileKeys, Profile) :-
    ProfileKeys = [_|OtherKeys],
    length(OtherKeys, OtherCount),
    length(OtherValues, OtherCount),
    maplist(truth_value, OtherValues),
    maplist(attribute_pair, ProfileKeys, [false|OtherValues], Profile).

duty_final_atom(Status) :-
    member(Status, [not_applicable_on_date, not_a_provider, not_a_high_risk_ai_system, compliance_required_by_31_december_2030, existing_system_without_significant_changes_not_covered, compliance_required_by_2_august_2030, duty_applies]).

integration_final_atom(Status) :-
    member(Status, [not_a_provider, not_a_high_risk_ai_system, integration_not_available, integration_available]).

test(totality_every_subject_classifies) :-
    subject_set(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_yields_exactly_one_verdict) :-
    subject_set(SubjectSet),
    findall(Subject, (post_market_monitoring_subject(Subject), subject_answer_count(Subject, 1)), DeterministicSubjects),
    sort(DeterministicSubjects, SubjectSet).
test(every_subject_verdict_is_well_formed) :-
    subject_set(SubjectSet),
    findall(Subject, subject_well_formed(Subject), WellFormedSubjects),
    sort(WellFormedSubjects, SubjectSet).
test(every_complete_duty_profile_yields_one_final_answer) :-
    duty_keys(ProfileKeys),
    findall(Status, (complete_profile(ProfileKeys, Profile), post_market_monitoring_duty_status(Profile, date(2029, 1, 1), Status, [_|_]), duty_final_atom(Status)), Statuses),
    length(Statuses, 128).
test(every_complete_integration_profile_yields_one_final_answer) :-
    integration_keys(ProfileKeys),
    findall(Status, (complete_profile(ProfileKeys, Profile), post_market_monitoring_integration_status(Profile, Status, [cite(eu_reg_2024_1689_art_72_4)]), integration_final_atom(Status)), Statuses),
    length(Statuses, 128).
test(before_2_december_2027_nothing_applies_whatever_the_profile) :-
    duty_keys(ProfileKeys),
    findall(Status, (complete_profile(ProfileKeys, Profile), post_market_monitoring_duty_status(Profile, date(2027, 12, 1), Status, _)), Statuses),
    length(Statuses, 128),
    sort(Statuses, [not_applicable_on_date]).
test(a_non_provider_is_never_bound_on_a_live_date) :-
    duty_keys(ProfileKeys),
    findall(Status, (non_provider_profile(ProfileKeys, Profile), post_market_monitoring_duty_status(Profile, date(2031, 1, 1), Status, _)), Statuses),
    length(Statuses, 64),
    sort(Statuses, [not_a_provider]).
test(a_non_provider_never_has_the_integration_choice) :-
    integration_keys(ProfileKeys),
    findall(Status, (non_provider_profile(ProfileKeys, Profile), post_market_monitoring_integration_status(Profile, Status, _)), Statuses),
    length(Statuses, 64),
    sort(Statuses, [not_a_provider]).
test(from_2031_every_complete_duty_answer_is_settled_without_transitional_dates) :-
    duty_keys(ProfileKeys),
    findall(Status, (complete_profile(ProfileKeys, Profile), post_market_monitoring_duty_status(Profile, date(2031, 1, 1), Status, _)), Statuses),
    sort(Statuses, DistinctStatuses),
    DistinctStatuses == [duty_applies, existing_system_without_significant_changes_not_covered, not_a_high_risk_ai_system, not_a_provider].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_yields_exactly_one_verdict, every_subject_verdict_is_well_formed, every_complete_duty_profile_yields_one_final_answer, every_complete_integration_profile_yields_one_final_answer, before_2_december_2027_nothing_applies_whatever_the_profile, a_non_provider_is_never_bound_on_a_live_date, a_non_provider_never_has_the_integration_choice, from_2031_every_complete_duty_answer_is_settled_without_transitional_dates]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
