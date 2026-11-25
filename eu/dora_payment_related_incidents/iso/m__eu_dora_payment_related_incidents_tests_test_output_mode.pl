% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_payment_related_incidents_dora_payment_related_incidents, [decide_dora_payment_related_incidents/2, payment_related_incident_status/3, payment_related_incident_report_recipients/3]).
:- use_module(m__eu_dora_payment_related_incidents_fixtures, [dora_payment_related_incidents_profile_for/2]).

reporting_citations([cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11), cite(eu_reg_2022_2554_art_18_3_a), cite(eu_reg_2022_2554_art_19_1)]).

chapter_citations([cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11)]).

status_answers(Subject, Answers) :-
    dora_payment_related_incidents_profile_for(Subject, Profile),
    findall(Status - Citations, payment_related_incident_status(Profile, Status, Citations), Answers).

recipient_answers(Subject, Answers) :-
    dora_payment_related_incidents_profile_for(Subject, Profile),
    findall(Result - Citations, payment_related_incident_report_recipients(Profile, Result, Citations), Answers).

test(s9_a_major_incident_is_reported) :-
    status_answers(major_payment_institution_incident, Answers),
    reporting_citations(Citations),
    Answers == [chapter_requirements_and_article_19_reporting_apply - Citations].
test(s8_an_incident_that_is_not_major_brings_the_chapter) :-
    status_answers(non_major_payment_institution_incident, Answers),
    chapter_citations(Citations),
    Answers == [chapter_requirements_apply - Citations].
test(s2_an_ict_provider_is_not_reached) :-
    status_answers(ict_third_party_service_provider_incident, Answers),
    Answers == [not_an_article_23_entity - [cite(eu_reg_2022_2554_art_23)]].
test(s2_the_institution_exempted_under_directive_2013_36_is_not_reached) :-
    status_answers(exempted_institution_under_directive_2013_36_major_incident, Answers),
    Answers == [not_an_article_23_entity - [cite(eu_reg_2022_2554_art_23)]].
test(s9_an_exempted_payment_institution_is_reached) :-
    status_answers(exempted_payment_institution_incident, Answers),
    reporting_citations(Citations),
    Answers == [chapter_requirements_and_article_19_reporting_apply - Citations].
test(s3_not_payment_related) :-
    status_answers(not_payment_related_electronic_money_incident, Answers),
    Answers == [not_a_payment_related_incident - [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9)]].
test(s1_the_gate) :-
    status_answers(missing_entity_type, Answers),
    Answers == [indeterminate([dora_entity_type]) - []].
test(s4_the_missing_incident_judgement) :-
    status_answers(missing_incident_judgement, Answers),
    Answers == [indeterminate([incident_is_operational_or_security_payment_related]) - []].
test(s5_major_named_before_the_unsure_incident_is_referred) :-
    status_answers(missing_major_with_unsure_incident, Answers),
    Answers == [indeterminate([payment_related_incident_is_major]) - []].
test(s6_the_unsure_incident_is_referred) :-
    status_answers(unsure_payment_related_incident, Answers),
    Answers == [needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on([dora_entity_type - account_information_service_provider, incident_is_operational_or_security_payment_related - unsure, payment_related_incident_is_major - true])]) - []].
test(s7_the_unsure_major_is_referred) :-
    status_answers(unsure_major_incident, Answers),
    Answers == [needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on([dora_entity_type - exempted_electronic_money_institution, incident_is_operational_or_security_payment_related - true, payment_related_incident_is_major - unsure])]) - []].
test(s0_an_unknown_key) :-
    status_answers(unknown_key_profile, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(r11_significant_credit_institution_with_member_state_determination) :-
    recipient_answers(significant_credit_institution_major_incident, Answers),
    reporting_citations(Citations),
    Answers == [recipients([national_competent_authority_designated_under_directive_2013_36, directive_2022_2555_competent_authority_or_csirt]) - Citations].
test(r11_non_significant_credit_institution) :-
    recipient_answers(non_significant_credit_institution_major_incident, Answers),
    reporting_citations(Citations),
    Answers == [recipients([relevant_competent_authority, directive_2022_2555_competent_authority_or_csirt]) - Citations].
test(r11_significant_credit_institution_without_member_state_determination) :-
    recipient_answers(significant_credit_institution_without_member_state_determination, Answers),
    reporting_citations(Citations),
    Answers == [recipients([national_competent_authority_designated_under_directive_2013_36]) - Citations].
test(r11_payment_institution_reports_to_the_relevant_authority_only) :-
    recipient_answers(major_payment_institution_incident, Answers),
    reporting_citations(Citations),
    Answers == [recipients([relevant_competent_authority]) - Citations].
test(r11_exempted_electronic_money_institution_with_determination) :-
    recipient_answers(settled_major_incident, Answers),
    reporting_citations(Citations),
    Answers == [recipients([relevant_competent_authority, directive_2022_2555_competent_authority_or_csirt]) - Citations].
test(r6_not_major_gives_the_chapter) :-
    recipient_answers(non_major_payment_institution_incident, Answers),
    chapter_citations(Citations),
    Answers == [chapter_requirements_apply - Citations].
test(r2_a_type_not_reached) :-
    recipient_answers(exempted_institution_under_directive_2013_36_major_incident, Answers),
    Answers == [not_an_article_23_entity - [cite(eu_reg_2022_2554_art_23)]].
test(r3_not_payment_related) :-
    recipient_answers(not_payment_related_electronic_money_incident, Answers),
    Answers == [not_a_payment_related_incident - [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9)]].
test(r7_the_missing_significance) :-
    recipient_answers(missing_significance, Answers),
    Answers == [indeterminate([credit_institution_classified_as_significant]) - []].
test(r8_the_missing_member_state_determination) :-
    findall(Result - Citations, payment_related_incident_report_recipients([attribute(dora_entity_type, payment_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true)], Result, Citations), Answers),
    Answers == [indeterminate([member_state_requires_reports_to_directive_2022_2555_authorities]) - []].
test(r9_the_unsure_incident_is_referred_with_every_present_pair) :-
    recipient_answers(unsure_payment_related_incident, Answers),
    Answers == [needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on([dora_entity_type - account_information_service_provider, incident_is_operational_or_security_payment_related - unsure, payment_related_incident_is_major - true, member_state_requires_reports_to_directive_2022_2555_authorities - false])]) - []].
test(r10_the_unsure_major_is_referred_with_every_present_pair) :-
    recipient_answers(unsure_major_incident, Answers),
    Answers == [needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on([dora_entity_type - exempted_electronic_money_institution, incident_is_operational_or_security_payment_related - true, payment_related_incident_is_major - unsure, member_state_requires_reports_to_directive_2022_2555_authorities - true])]) - []].
test(r6_unsure_incident_not_major_is_referred_without_reading_the_facts) :-
    findall(Result, payment_related_incident_report_recipients([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, unsure), attribute(payment_related_incident_is_major, false)], Result, _Citations), Results),
    Results == [needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on([dora_entity_type - credit_institution, incident_is_operational_or_security_payment_related - unsure, payment_related_incident_is_major - false])])].
test(r0_a_malformed_value) :-
    recipient_answers(malformed_entity_type, Answers),
    Answers == [input_problems([wrong_type(dora_entity_type)]) - []].
test(the_verdict_carries_a_citation) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    decide_dora_payment_related_incidents(Profile, dora_payment_related_incidents_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(the_verdict_has_exactly_one_answer) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    findall(Verdict, decide_dora_payment_related_incidents(Profile, Verdict), Verdicts),
    Verdicts = [_OneVerdict].

cp_test_names([s9_a_major_incident_is_reported, s8_an_incident_that_is_not_major_brings_the_chapter, s2_an_ict_provider_is_not_reached, s2_the_institution_exempted_under_directive_2013_36_is_not_reached, s9_an_exempted_payment_institution_is_reached, s3_not_payment_related, s1_the_gate, s4_the_missing_incident_judgement, s5_major_named_before_the_unsure_incident_is_referred, s6_the_unsure_incident_is_referred, s7_the_unsure_major_is_referred, s0_an_unknown_key, r11_significant_credit_institution_with_member_state_determination, r11_non_significant_credit_institution, r11_significant_credit_institution_without_member_state_determination, r11_payment_institution_reports_to_the_relevant_authority_only, r11_exempted_electronic_money_institution_with_determination, r6_not_major_gives_the_chapter, r2_a_type_not_reached, r3_not_payment_related, r7_the_missing_significance, r8_the_missing_member_state_determination, r9_the_unsure_incident_is_referred_with_every_present_pair, r10_the_unsure_major_is_referred_with_every_present_pair, r6_unsure_incident_not_major_is_referred_without_reading_the_facts, r0_a_malformed_value, the_verdict_carries_a_citation, the_verdict_has_exactly_one_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
