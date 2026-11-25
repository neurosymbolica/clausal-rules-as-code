% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_payment_related_incidents_queries, [dora_payment_related_incidents_profile_keys/1, dora_payment_related_incidents_what_if/4]).
:- use_module(m__eu_dora_payment_related_incidents_kernel, [dora_payment_related_incidents_input_problems/2]).
:- use_module(m__eu_dora_payment_related_incidents_dora_payment_related_incidents, [decide_dora_payment_related_incidents/2, dora_payment_related_incidents_checklist/2]).
:- use_module(m__eu_dora_payment_related_incidents_fixtures, [dora_payment_related_incidents_profile_for/2]).

what_if_answers(Subject, Key, Value, Statuses) :-
    dora_payment_related_incidents_profile_for(Subject, Profile),
    findall(Status, dora_payment_related_incidents_what_if(Profile, Key, Value, Status), Statuses).

test(profile_keys_are_the_contract_keys) :-
    dora_payment_related_incidents_profile_keys(ProfileKeys),
    ProfileKeys == [dora_entity_type, incident_is_operational_or_security_payment_related, payment_related_incident_is_major, credit_institution_classified_as_significant, member_state_requires_reports_to_directive_2022_2555_authorities].
test(the_input_check_passes_a_fixture) :-
    dora_payment_related_incidents_profile_for(significant_credit_institution_major_incident, Profile),
    dora_payment_related_incidents_input_problems(Profile, Problems),
    Problems == [].
test(the_input_check_names_an_unknown_key) :-
    dora_payment_related_incidents_profile_for(unknown_key_profile, Profile),
    findall(Problems, dora_payment_related_incidents_input_problems(Profile, Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(what_if_unsure_incident_is_referred) :-
    what_if_answers(settled_payment_related_incident, incident_is_operational_or_security_payment_related, unsure, Statuses),
    Statuses == [needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on([dora_entity_type - account_information_service_provider, incident_is_operational_or_security_payment_related - unsure, payment_related_incident_is_major - true])])].
test(what_if_settled_incident_is_reported) :-
    what_if_answers(unsure_payment_related_incident, incident_is_operational_or_security_payment_related, true, Statuses),
    Statuses == [chapter_requirements_and_article_19_reporting_apply].
test(what_if_not_payment_related) :-
    what_if_answers(settled_major_incident, incident_is_operational_or_security_payment_related, false, Statuses),
    Statuses == [not_a_payment_related_incident].
test(what_if_another_type_is_not_reached) :-
    what_if_answers(major_payment_institution_incident, dora_entity_type, institution_exempted_pursuant_to_directive_2013_36, Statuses),
    Statuses == [not_an_article_23_entity].
test(what_if_unsure_major_is_referred) :-
    what_if_answers(settled_major_incident, payment_related_incident_is_major, unsure, Statuses),
    Statuses == [needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on([dora_entity_type - exempted_electronic_money_institution, incident_is_operational_or_security_payment_related - true, payment_related_incident_is_major - unsure])])].
test(what_if_on_a_duplicate_key_gives_its_problem) :-
    findall(Status, dora_payment_related_incidents_what_if([attribute(dora_entity_type, credit_institution), attribute(dora_entity_type, credit_institution)], dora_entity_type, payment_institution, Status), Statuses),
    Statuses == [input_problems([duplicate_key(dora_entity_type)])].
test(the_verdict_is_the_status_with_its_citations) :-
    dora_payment_related_incidents_profile_for(ict_third_party_service_provider_incident, Profile),
    findall(Verdict, decide_dora_payment_related_incidents(Profile, Verdict), Verdicts),
    Verdicts == [dora_payment_related_incidents_verdict(not_an_article_23_entity, [cite(eu_reg_2022_2554_art_23)])].
test(the_checklist_cites_every_requirement_of_a_major_incident) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    dora_payment_related_incidents_checklist(Profile, Items),
    length(Items, 3),
    member(item(article_23_entity, met, cite(eu_reg_2022_2554_art_23)), Items),
    member(item(payment_related_incident, met, cite(eu_reg_2022_2554_art_3_9)), Items),
    member(item(major_incident, met, cite(eu_reg_2022_2554_art_3_11)), Items).
test(the_checklist_marks_a_type_not_reached_unmet) :-
    dora_payment_related_incidents_profile_for(ict_third_party_service_provider_incident, Profile),
    dora_payment_related_incidents_checklist(Profile, Items),
    member(item(article_23_entity, unmet(not_an_article_23_entity), cite(eu_reg_2022_2554_art_23)), Items).
test(the_checklist_marks_an_unsure_judgement_unknown) :-
    dora_payment_related_incidents_profile_for(unsure_major_incident, Profile),
    dora_payment_related_incidents_checklist(Profile, Items),
    member(item(major_incident, unknown([payment_related_incident_is_major]), cite(eu_reg_2022_2554_art_3_11)), Items).

test(what_if_does_not_keep_the_old_value, fail) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    dora_payment_related_incidents_what_if(Profile, payment_related_incident_is_major, false, chapter_requirements_and_article_19_reporting_apply).

cp_test_names([profile_keys_are_the_contract_keys, the_input_check_passes_a_fixture, the_input_check_names_an_unknown_key, what_if_unsure_incident_is_referred, what_if_settled_incident_is_reported, what_if_not_payment_related, what_if_another_type_is_not_reached, what_if_unsure_major_is_referred, what_if_on_a_duplicate_key_gives_its_problem, the_verdict_is_the_status_with_its_citations, the_checklist_cites_every_requirement_of_a_major_incident, the_checklist_marks_a_type_not_reached_unmet, the_checklist_marks_an_unsure_judgement_unknown]).
cp_test_fail_names([what_if_does_not_keep_the_old_value]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
