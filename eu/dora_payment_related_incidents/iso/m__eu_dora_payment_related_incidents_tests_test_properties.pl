% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_payment_related_incidents_kernel, [dora_payment_related_incidents_input_problems/2]).
:- use_module(m__eu_dora_payment_related_incidents_dora_payment_related_incidents, [decide_dora_payment_related_incidents/2, payment_related_incident_status/3, payment_related_incident_report_recipients/3, dora_payment_related_incidents_status_values/1]).
:- use_module(m__eu_dora_payment_related_incidents_fixtures, [dora_payment_related_incidents_subject/1, dora_payment_related_incidents_profile_for/2]).
:- use_module(library(reif), [memberd_t/3]).

all_entity_types([credit_institution, institution_exempted_pursuant_to_directive_2013_36, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty, trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider, insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary, institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types]).

reached_entity_types([credit_institution, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution]).

major_profile(EntityType, [attribute(dora_entity_type, EntityType), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true)]).

full_profile(EntityType, Significant, MemberState, [attribute(dora_entity_type, EntityType), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true), attribute(credit_institution_classified_as_significant, Significant), attribute(member_state_requires_reports_to_directive_2022_2555_authorities, MemberState)]).

subject_classifies(Subject) :-
    dora_payment_related_incidents_subject(Subject),
    dora_payment_related_incidents_profile_for(Subject, Profile),
    decide_dora_payment_related_incidents(Profile, _Verdict).

subject_status_count(Subject, Count) :-
    dora_payment_related_incidents_profile_for(Subject, Profile),
    findall(Status - Citations, payment_related_incident_status(Profile, Status, Citations), Answers),
    length(Answers, Count).

subject_recipients_count(Subject, Count) :-
    dora_payment_related_incidents_profile_for(Subject, Profile),
    findall(Result - Citations, payment_related_incident_report_recipients(Profile, Result, Citations), Answers),
    length(Answers, Count).

type_status_count(EntityType, Count) :-
    major_profile(EntityType, Profile),
    findall(Status, payment_related_incident_status(Profile, Status, _Citations), Statuses),
    length(Statuses, Count).

non_final(indeterminate(_MissingKeys)).
non_final(needs_legal_review(_Reason, _Context)).
non_final(input_problems(_Problems)).

final_status(Status) :-
    dora_payment_related_incidents_status_values(StatusValues),
    member(Status, StatusValues).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_payment_related_incidents_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_status) :-
    findall(Count, (dora_payment_related_incidents_subject(Subject), subject_status_count(Subject, Count)), Counts),
    sort(Counts, [1]).
test(determinism_every_subject_has_exactly_one_recipients_answer) :-
    findall(Count, (dora_payment_related_incidents_subject(Subject), subject_recipients_count(Subject, Count)), Counts),
    sort(Counts, [1]).
test(every_non_final_status_cites_nothing) :-
    findall(Citations, (dora_payment_related_incidents_subject(Subject), dora_payment_related_incidents_profile_for(Subject, Profile), payment_related_incident_status(Profile, Status, Citations), non_final(Status)), CitationLists),
    sort(CitationLists, [[]]).
test(every_non_final_recipients_answer_cites_nothing) :-
    findall(Citations, (dora_payment_related_incidents_subject(Subject), dora_payment_related_incidents_profile_for(Subject, Profile), payment_related_incident_report_recipients(Profile, Result, Citations), non_final(Result)), CitationLists),
    sort(CitationLists, [[]]).
test(every_final_status_cites_article_23) :-
    findall(Cited, (dora_payment_related_incidents_subject(Subject), dora_payment_related_incidents_profile_for(Subject, Profile), payment_related_incident_status(Profile, Status, Citations), final_status(Status), memberd_t(cite(eu_reg_2022_2554_art_23), Citations, Cited)), Flags),
    sort(Flags, [true]).
test(every_entity_type_gives_exactly_one_status) :-
    all_entity_types(EntityTypes),
    findall(Count, (member(EntityType, EntityTypes), type_status_count(EntityType, Count)), Counts),
    length(Counts, 29),
    sort(Counts, [1]).
test(exactly_the_six_reached_types_are_reported) :-
    all_entity_types(EntityTypes),
    findall(EntityType, (member(EntityType, EntityTypes), major_profile(EntityType, Profile), payment_related_incident_status(Profile, chapter_requirements_and_article_19_reporting_apply, _Citations)), Reached),
    reached_entity_types(Reached).
test(every_other_type_is_not_an_article_23_entity) :-
    all_entity_types(EntityTypes),
    findall(EntityType, (member(EntityType, EntityTypes), major_profile(EntityType, Profile), payment_related_incident_status(Profile, not_an_article_23_entity, _Citations)), NotReached),
    length(NotReached, 23).
test(every_combination_gives_exactly_one_recipients_answer) :-
    all_entity_types(EntityTypes),
    findall(Result, (member(EntityType, EntityTypes), member(Significant, [true, false]), member(MemberState, [true, false]), full_profile(EntityType, Significant, MemberState, Profile), payment_related_incident_report_recipients(Profile, Result, _Citations)), Results),
    length(Results, 116).
test(a_recipients_list_is_never_empty) :-
    all_entity_types(EntityTypes),
    findall(List, (member(EntityType, EntityTypes), member(Significant, [true, false]), member(MemberState, [true, false]), full_profile(EntityType, Significant, MemberState, Profile), payment_related_incident_report_recipients(Profile, recipients(List), _Citations)), Lists),
    length(Lists, 24),
    memberd_t([], Lists, false).
test(the_type_is_the_gate_whatever_the_incident_judgement) :-
    findall(Status - Citations, (member(IncidentValue, [true, false, unsure]), payment_related_incident_status([attribute(incident_is_operational_or_security_payment_related, IncidentValue)], Status, Citations)), Answers),
    sort(Answers, [indeterminate([dora_entity_type]) - []]),
    length(Answers, 3).
test(the_input_check_has_exactly_one_answer_for_any_term) :-
    findall(Problems, (member(Term, [_UnboundProfile, no_profile, [credit_institution], [attribute(_UnboundKey, credit_institution)], [attribute(dora_entity_type, _UnboundValue)], [attribute(colour, red)|_PartialTail]]), dora_payment_related_incidents_input_problems(Term, Problems)), AllProblems),
    length(AllProblems, 6).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_status, determinism_every_subject_has_exactly_one_recipients_answer, every_non_final_status_cites_nothing, every_non_final_recipients_answer_cites_nothing, every_final_status_cites_article_23, every_entity_type_gives_exactly_one_status, exactly_the_six_reached_types_are_reported, every_other_type_is_not_an_article_23_entity, every_combination_gives_exactly_one_recipients_answer, a_recipients_list_is_never_empty, the_type_is_the_gate_whatever_the_incident_judgement, the_input_check_has_exactly_one_answer_for_any_term]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
