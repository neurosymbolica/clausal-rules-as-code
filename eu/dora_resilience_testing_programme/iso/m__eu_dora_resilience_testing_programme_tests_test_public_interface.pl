% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_resilience_testing_programme_dora_resilience_testing_programme, [decide_dora_resilience_testing_programme/2, dora_resilience_testing_programme_status/2, dora_resilience_testing_programme_checklist/2, dora_resilience_testing_programme_decision_resolvable/1, dora_resilience_testing_programme_status_values/1, resilience_testing_duties_required/3, resilience_testing_duties_complete/3, resilience_testing_duties_outstanding/3]).
:- use_module(m__eu_dora_resilience_testing_programme_fixtures, [dora_resilience_testing_programme_subject/1, dora_resilience_testing_programme_profile_for/2, dora_resilience_testing_programme_assess/2]).
:- use_module(m__eu_dora_resilience_testing_programme_kernel, [dora_resilience_testing_programme_input_problems/2]).

expected_status(credit_institution_every_duty_performed, complete).
expected_status(credit_institution_yearly_testing_not_performed, incomplete).
expected_status(central_counterparty_vulnerability_assessments_performed, complete).
expected_status(central_counterparty_vulnerability_assessments_not_performed, incomplete).
expected_status(trading_venue_vulnerability_assessments_not_performed, complete).
expected_status(central_securities_depository_vulnerability_assessments_unstated, indeterminate([vulnerability_assessments_performed_before_deployment])).
expected_status(internal_tester_resourced, complete).
expected_status(internal_tester_not_resourced, incomplete).
expected_status(external_testers_only_resources_not_dedicated, complete).
expected_status(internal_tester_unstated_but_resourced, complete).
expected_status(internal_tester_unstated_and_not_resourced, indeterminate([tests_undertaken_by_internal_tester])).
expected_status(microenterprise_testing_risk_based_and_planned, complete).
expected_status(microenterprise_testing_not_planned, incomplete).
expected_status(microenterprise_testing_unstated, indeterminate([microenterprise_tests_risk_based_and_planned])).
expected_status(microenterprise_given_as_central_securities_depository, complete).
expected_status(size_unstated_both_routes_performed, complete).
expected_status(size_unstated_branch_open, indeterminate([financial_entity_is_microenterprise])).
expected_status(programme_judgement_unstated, indeterminate([resilience_testing_programme_established_maintained_and_reviewed])).
expected_status(fact_key_given_unsure, input_problems([wrong_type(tests_undertaken_by_internal_tester)])).

referred_subject(programme_judgement_unsure).

assessed_once(Subject, Status, Citations) :-
    findall(Status0 - Citations0, dora_resilience_testing_programme_assess(Subject, dora_resilience_testing_programme_verdict(Status0, Citations0)), Answers),
    length(Answers, 1),
    Answers = [Status - Citations].

has_expected_status(Subject) :-
    expected_status(Subject, Expected),
    assessed_once(Subject, Status, _),
    Status == Expected.
has_expected_status(Subject) :-
    referred_subject(Subject),
    assessed_once(Subject, needs_legal_review(_, _), []).

final_citations_are_nine(complete, Citations) :-
    length(Citations, 9).
final_citations_are_nine(incomplete, Citations) :-
    length(Citations, 9).

item_cited(item(_, _, cite(_))).

test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject, dora_resilience_testing_programme_subject(Subject), Subjects),
    length(Subjects, 20),
    maplist(has_expected_status, Subjects).
test(every_status_is_in_the_status_vocabulary) :-
    dora_resilience_testing_programme_status_values(StatusValues),
    findall(Status, (dora_resilience_testing_programme_subject(Subject), assessed_once(Subject, Status, _)), Statuses),
    length(Statuses, 20),
    maplist(status_in_vocabulary(StatusValues), Statuses).
test(every_duty_performed_is_complete) :-
    assessed_once(credit_institution_every_duty_performed, Status, Citations),
    Status == complete,
    final_citations_are_nine(Status, Citations),
    member(cite(eu_reg_2022_2554_art_25_3), Citations).
test(yearly_testing_not_performed_is_incomplete) :-
    assessed_once(credit_institution_yearly_testing_not_performed, Status, Citations),
    Status == incomplete,
    final_citations_are_nine(Status, Citations).
test(central_counterparty_assessed_is_complete) :-
    assessed_once(central_counterparty_vulnerability_assessments_performed, complete, _).
test(central_counterparty_not_assessed_is_incomplete) :-
    assessed_once(central_counterparty_vulnerability_assessments_not_performed, incomplete, _).
test(trading_venue_not_assessed_is_complete) :-
    assessed_once(trading_venue_vulnerability_assessments_not_performed, complete, _).
test(central_securities_depository_unstated_names_the_vulnerability_key) :-
    assessed_once(central_securities_depository_vulnerability_assessments_unstated, Status, Citations),
    Status == indeterminate([vulnerability_assessments_performed_before_deployment]),
    Citations == [].
test(internal_tester_resourced_is_complete) :-
    assessed_once(internal_tester_resourced, complete, _).
test(internal_tester_not_resourced_is_incomplete) :-
    assessed_once(internal_tester_not_resourced, incomplete, _).
test(external_testers_only_is_complete) :-
    assessed_once(external_testers_only_resources_not_dedicated, complete, _).
test(unstated_tester_with_resources_is_complete) :-
    assessed_once(internal_tester_unstated_but_resourced, complete, _).
test(unstated_tester_without_resources_names_the_tester_key) :-
    assessed_once(internal_tester_unstated_and_not_resourced, Status, []),
    Status == indeterminate([tests_undertaken_by_internal_tester]).
test(microenterprise_planned_testing_is_complete) :-
    assessed_once(microenterprise_testing_risk_based_and_planned, Status, Citations),
    Status == complete,
    final_citations_are_nine(Status, Citations).
test(microenterprise_unplanned_testing_is_incomplete) :-
    assessed_once(microenterprise_testing_not_planned, incomplete, _).
test(microenterprise_unstated_testing_names_its_key) :-
    assessed_once(microenterprise_testing_unstated, Status, []),
    Status == indeterminate([microenterprise_tests_risk_based_and_planned]).
test(microenterprise_given_as_central_securities_depository_is_complete) :-
    assessed_once(microenterprise_given_as_central_securities_depository, complete, _).
test(size_unstated_with_both_routes_performed_is_complete) :-
    assessed_once(size_unstated_both_routes_performed, complete, _).
test(size_unstated_with_the_branch_open_names_the_size_key) :-
    assessed_once(size_unstated_branch_open, Status, []),
    Status == indeterminate([financial_entity_is_microenterprise]).
test(an_unsure_programme_judgement_is_referred) :-
    assessed_once(programme_judgement_unsure, needs_legal_review(Reason, [inputs_relied_on(Pairs)]), Citations),
    Reason == open_textured(resilience_testing_programme_established_maintained_and_reviewed, cite(eu_reg_2022_2554_art_24_1)),
    Citations == [],
    Pairs = [financial_entity_is_microenterprise - false, dora_entity_type - credit_institution|_],
    member(resilience_testing_programme_established_maintained_and_reviewed - unsure, Pairs),
    length(Pairs, 11).
test(an_absent_programme_judgement_is_named_not_referred) :-
    assessed_once(programme_judgement_unstated, Status, []),
    Status == indeterminate([resilience_testing_programme_established_maintained_and_reviewed]).
test(a_review_context_may_carry_an_unscored_provenance_item) :-
    Context = [inputs_relied_on([financial_entity_is_microenterprise - true]), provenance(micro_complete, [cite(eu_reg_2022_2554_art_25_3)])],
    Context = [inputs_relied_on(Pairs)|Optional],
    Pairs == [financial_entity_is_microenterprise - true],
    Optional = [provenance(Clause, ProvenanceCitations)],
    Clause == micro_complete,
    ProvenanceCitations == [cite(eu_reg_2022_2554_art_25_3)].
test(unsure_on_a_fact_key_is_an_input_problem) :-
    assessed_once(fact_key_given_unsure, Status, Citations),
    Status == input_problems([wrong_type(tests_undertaken_by_internal_tester)]),
    Citations == [].
test(a_repeated_key_is_a_duplicate_key) :-
    dora_resilience_testing_programme_input_problems([attribute(dora_entity_type, credit_institution), attribute(dora_entity_type, bank)], Problems),
    Problems == [duplicate_key(dora_entity_type)].
test(a_duplicate_key_refuses_every_query) :-
    Profile = [attribute(financial_entity_is_microenterprise, true), attribute(financial_entity_is_microenterprise, true)],
    resilience_testing_duties_required(Profile, Required, RequiredCitations),
    Required == input_problems([duplicate_key(financial_entity_is_microenterprise)]),
    RequiredCitations == [],
    resilience_testing_duties_complete(Profile, Complete, []),
    Complete == input_problems([duplicate_key(financial_entity_is_microenterprise)]),
    resilience_testing_duties_outstanding(Profile, Outstanding, []),
    Outstanding == input_problems([duplicate_key(financial_entity_is_microenterprise)]).
test(required_for_a_microenterprise_is_its_one_duty) :-
    dora_resilience_testing_programme_profile_for(microenterprise_testing_unstated, Profile),
    findall(Result - Citations, resilience_testing_duties_required(Profile, Result, Citations), Answers),
    Answers == [required([microenterprise_risk_based_planned_testing]) - [cite(eu_reg_2022_2554_art_25_3)]].
test(required_for_a_central_counterparty_includes_article_25_2) :-
    dora_resilience_testing_programme_profile_for(central_counterparty_vulnerability_assessments_performed, Profile),
    resilience_testing_duties_required(Profile, required(Duties), Citations),
    length(Duties, 9),
    last(Duties, vulnerability_assessments_before_deployment),
    length(Citations, 8),
    member(cite(eu_reg_2022_2554_art_25_2), Citations).
test(required_for_a_credit_institution_has_eight_duties) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    resilience_testing_duties_required(Profile, required(Duties), Citations),
    length(Duties, 8),
    length(Citations, 7).
test(required_with_the_size_unstated_names_the_size_key) :-
    resilience_testing_duties_required([], Result, Citations),
    Result == indeterminate([financial_entity_is_microenterprise]),
    Citations == [].
test(complete_query_gives_one_answer_per_profile) :-
    dora_resilience_testing_programme_profile_for(credit_institution_yearly_testing_not_performed, Profile),
    findall(Result, resilience_testing_duties_complete(Profile, Result, _), Results),
    Results == [incomplete].
test(complete_query_says_complete_for_every_duty_performed) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    resilience_testing_duties_complete(Profile, complete, Citations),
    length(Citations, 9).
test(outstanding_lists_the_yearly_testing_duty) :-
    dora_resilience_testing_programme_profile_for(credit_institution_yearly_testing_not_performed, Profile),
    findall(Result - Citations, resilience_testing_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([yearly_testing_of_critical_ict_systems]) - [cite(eu_reg_2022_2554_art_24_6)]].
test(outstanding_lists_the_internal_tester_duty) :-
    dora_resilience_testing_programme_profile_for(internal_tester_not_resourced, Profile),
    resilience_testing_duties_outstanding(Profile, Result, Citations),
    Result == outstanding([internal_tester_resources_and_conflicts_of_interest]),
    Citations == [cite(eu_reg_2022_2554_art_24_4)].
test(outstanding_is_none_when_every_duty_is_performed) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    resilience_testing_duties_outstanding(Profile, none_outstanding, Citations),
    length(Citations, 9).
test(the_status_projection_matches_the_verdict) :-
    dora_resilience_testing_programme_profile_for(internal_tester_not_resourced, Profile),
    findall(Status, dora_resilience_testing_programme_status(Profile, Status), Statuses),
    Statuses == [incomplete].
test(every_well_formed_subject_has_a_cited_checklist_row_per_duty) :-
    findall(Subject, (dora_resilience_testing_programme_subject(Subject), dif(Subject, fact_key_given_unsure)), Subjects),
    length(Subjects, 19),
    maplist(subject_has_full_checklist, Subjects).
test(the_checklist_marks_the_unperformed_duty) :-
    dora_resilience_testing_programme_profile_for(internal_tester_not_resourced, Profile),
    dora_resilience_testing_programme_checklist(Profile, Items),
    member(item(internal_tester_resources_and_conflicts_of_interest, unmet(internal_tester_resourced_and_conflicts_of_interest_avoided), cite(eu_reg_2022_2554_art_24_4)), Items),
    member(item(microenterprise_risk_based_planned_testing, inapplicable, cite(eu_reg_2022_2554_art_25_3)), Items).
test(the_checklist_of_a_performed_duty_is_met) :-
    dora_resilience_testing_programme_profile_for(internal_tester_resourced, Profile),
    dora_resilience_testing_programme_checklist(Profile, Items),
    member(item(internal_tester_resources_and_conflicts_of_interest, met, cite(eu_reg_2022_2554_art_24_4)), Items).
test(a_profile_with_input_problems_has_no_checklist_rows) :-
    dora_resilience_testing_programme_profile_for(fact_key_given_unsure, Profile),
    dora_resilience_testing_programme_checklist(Profile, Items),
    Items == [].
test(the_decision_is_resolvable_directly) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    decide_dora_resilience_testing_programme(Profile, dora_resilience_testing_programme_verdict(complete, _)).

status_in_vocabulary(StatusValues, Status) :-
    member(Pattern, StatusValues),
    subsumes_term(Pattern, Status).

test(yearly_testing_not_performed_is_not_complete, fail) :-
    dora_resilience_testing_programme_assess(credit_institution_yearly_testing_not_performed, dora_resilience_testing_programme_verdict(complete, _)).
test(every_duty_performed_is_not_incomplete, fail) :-
    dora_resilience_testing_programme_assess(credit_institution_every_duty_performed, dora_resilience_testing_programme_verdict(incomplete, _)).
test(central_counterparty_not_assessed_is_not_complete, fail) :-
    dora_resilience_testing_programme_assess(central_counterparty_vulnerability_assessments_not_performed, dora_resilience_testing_programme_verdict(complete, _)).
test(trading_venue_not_assessed_is_not_incomplete, fail) :-
    dora_resilience_testing_programme_assess(trading_venue_vulnerability_assessments_not_performed, dora_resilience_testing_programme_verdict(incomplete, _)).
test(internal_tester_not_resourced_is_not_complete, fail) :-
    dora_resilience_testing_programme_assess(internal_tester_not_resourced, dora_resilience_testing_programme_verdict(complete, _)).
test(external_testers_only_is_not_incomplete, fail) :-
    dora_resilience_testing_programme_assess(external_testers_only_resources_not_dedicated, dora_resilience_testing_programme_verdict(incomplete, _)).
test(unstated_tester_without_resources_is_not_complete, fail) :-
    dora_resilience_testing_programme_assess(internal_tester_unstated_and_not_resourced, dora_resilience_testing_programme_verdict(complete, _)).
test(microenterprise_unplanned_testing_is_not_complete, fail) :-
    dora_resilience_testing_programme_assess(microenterprise_testing_not_planned, dora_resilience_testing_programme_verdict(complete, _)).
test(size_unstated_with_the_branch_open_is_not_complete, fail) :-
    dora_resilience_testing_programme_assess(size_unstated_branch_open, dora_resilience_testing_programme_verdict(complete, _)).
test(an_unsure_programme_judgement_is_not_complete, fail) :-
    dora_resilience_testing_programme_assess(programme_judgement_unsure, dora_resilience_testing_programme_verdict(complete, _)).
test(unsure_on_a_fact_key_is_not_indeterminate, fail) :-
    dora_resilience_testing_programme_assess(fact_key_given_unsure, dora_resilience_testing_programme_verdict(indeterminate(_), _)).
test(required_for_a_credit_institution_omits_article_25_2, fail) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    resilience_testing_duties_required(Profile, required(Duties), _),
    member(vulnerability_assessments_before_deployment, Duties).
test(outstanding_is_not_none_when_a_duty_is_not_performed, fail) :-
    dora_resilience_testing_programme_profile_for(credit_institution_yearly_testing_not_performed, Profile),
    resilience_testing_duties_outstanding(Profile, none_outstanding, _).
test(the_checklist_of_a_performed_duty_is_not_unmet, fail) :-
    dora_resilience_testing_programme_profile_for(internal_tester_resourced, Profile),
    dora_resilience_testing_programme_checklist(Profile, Items),
    member(item(internal_tester_resources_and_conflicts_of_interest, unmet(_), _), Items).

subject_has_full_checklist(Subject) :-
    dora_resilience_testing_programme_profile_for(Subject, Profile),
    dora_resilience_testing_programme_decision_resolvable(Profile),
    dora_resilience_testing_programme_checklist(Profile, [FirstItem|OtherItems]),
    length([FirstItem|OtherItems], 11),
    maplist(item_cited, [FirstItem|OtherItems]).

cp_test_names([every_subject_resolves_to_its_expected_status, every_status_is_in_the_status_vocabulary, every_duty_performed_is_complete, yearly_testing_not_performed_is_incomplete, central_counterparty_assessed_is_complete, central_counterparty_not_assessed_is_incomplete, trading_venue_not_assessed_is_complete, central_securities_depository_unstated_names_the_vulnerability_key, internal_tester_resourced_is_complete, internal_tester_not_resourced_is_incomplete, external_testers_only_is_complete, unstated_tester_with_resources_is_complete, unstated_tester_without_resources_names_the_tester_key, microenterprise_planned_testing_is_complete, microenterprise_unplanned_testing_is_incomplete, microenterprise_unstated_testing_names_its_key, microenterprise_given_as_central_securities_depository_is_complete, size_unstated_with_both_routes_performed_is_complete, size_unstated_with_the_branch_open_names_the_size_key, an_unsure_programme_judgement_is_referred, an_absent_programme_judgement_is_named_not_referred, a_review_context_may_carry_an_unscored_provenance_item, unsure_on_a_fact_key_is_an_input_problem, a_repeated_key_is_a_duplicate_key, a_duplicate_key_refuses_every_query, required_for_a_microenterprise_is_its_one_duty, required_for_a_central_counterparty_includes_article_25_2, required_for_a_credit_institution_has_eight_duties, required_with_the_size_unstated_names_the_size_key, complete_query_gives_one_answer_per_profile, complete_query_says_complete_for_every_duty_performed, outstanding_lists_the_yearly_testing_duty, outstanding_lists_the_internal_tester_duty, outstanding_is_none_when_every_duty_is_performed, the_status_projection_matches_the_verdict, every_well_formed_subject_has_a_cited_checklist_row_per_duty, the_checklist_marks_the_unperformed_duty, the_checklist_of_a_performed_duty_is_met, a_profile_with_input_problems_has_no_checklist_rows, the_decision_is_resolvable_directly]).
cp_test_fail_names([yearly_testing_not_performed_is_not_complete, every_duty_performed_is_not_incomplete, central_counterparty_not_assessed_is_not_complete, trading_venue_not_assessed_is_not_incomplete, internal_tester_not_resourced_is_not_complete, external_testers_only_is_not_incomplete, unstated_tester_without_resources_is_not_complete, microenterprise_unplanned_testing_is_not_complete, size_unstated_with_the_branch_open_is_not_complete, an_unsure_programme_judgement_is_not_complete, unsure_on_a_fact_key_is_not_indeterminate, required_for_a_credit_institution_omits_article_25_2, outstanding_is_not_none_when_a_duty_is_not_performed, the_checklist_of_a_performed_duty_is_not_unmet]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
