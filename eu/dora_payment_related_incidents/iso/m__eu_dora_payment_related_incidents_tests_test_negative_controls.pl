% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_payment_related_incidents_dora_payment_related_incidents, [payment_related_incident_status/3, payment_related_incident_report_recipients/3, dora_payment_related_incidents_status/2, dora_payment_related_incidents_status_values/1]).
:- use_module(m__eu_dora_payment_related_incidents_fixtures, [dora_payment_related_incidents_profile_for/2]).

subject_status(Subject, Status) :-
    dora_payment_related_incidents_profile_for(Subject, Profile),
    payment_related_incident_status(Profile, Status, _Citations).

subject_result(Subject, Result) :-
    dora_payment_related_incidents_profile_for(Subject, Profile),
    payment_related_incident_report_recipients(Profile, Result, _Citations).

test(the_status_table_holds_every_final_atom) :-
    dora_payment_related_incidents_status_values(StatusValues),
    StatusValues == [chapter_requirements_and_article_19_reporting_apply, chapter_requirements_apply, not_a_payment_related_incident, not_an_article_23_entity].
test(major_incident_is_reported) :-
    subject_status(major_payment_institution_incident, chapter_requirements_and_article_19_reporting_apply).
test(non_major_incident_brings_the_chapter) :-
    subject_status(non_major_payment_institution_incident, chapter_requirements_apply).
test(ict_provider_is_not_reached) :-
    subject_status(ict_third_party_service_provider_incident, not_an_article_23_entity).
test(institution_exempted_under_directive_2013_36_is_not_reached) :-
    subject_status(exempted_institution_under_directive_2013_36_major_incident, not_an_article_23_entity).
test(not_payment_related_incident) :-
    subject_status(not_payment_related_electronic_money_incident, not_a_payment_related_incident).
test(unsure_incident_is_referred) :-
    subject_status(unsure_payment_related_incident, needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, _Citation), _Context)).
test(unsure_major_is_referred) :-
    subject_status(unsure_major_incident, needs_legal_review(open_textured(payment_related_incident_is_major, _Citation), _Context)).
test(missing_type_is_named) :-
    subject_status(missing_entity_type, indeterminate([dora_entity_type])).
test(missing_incident_is_named) :-
    subject_status(missing_incident_judgement, indeterminate([incident_is_operational_or_security_payment_related])).
test(missing_major_is_named_with_unsure_incident) :-
    subject_status(missing_major_with_unsure_incident, indeterminate([payment_related_incident_is_major])).
test(malformed_profile_is_refused) :-
    subject_status(malformed_entity_type, input_problems([wrong_type(dora_entity_type)])).
test(significant_credit_institution_reports_to_the_national_authority) :-
    subject_result(significant_credit_institution_major_incident, recipients([national_competent_authority_designated_under_directive_2013_36|_Others])).
test(non_significant_credit_institution_reports_to_the_relevant_authority) :-
    subject_result(non_significant_credit_institution_major_incident, recipients([relevant_competent_authority|_Others])).
test(member_state_determination_adds_the_csirt) :-
    subject_result(significant_credit_institution_major_incident, recipients(List)),
    member(directive_2022_2555_competent_authority_or_csirt, List).
test(not_major_gives_the_chapter_answer) :-
    subject_result(non_major_payment_institution_incident, chapter_requirements_apply).
test(missing_significance_is_named_for_a_credit_institution) :-
    subject_result(missing_significance, indeterminate([credit_institution_classified_as_significant])).
test(missing_member_state_key_is_named_for_a_payment_institution) :-
    payment_related_incident_report_recipients([attribute(dora_entity_type, payment_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true)], indeterminate([member_state_requires_reports_to_directive_2022_2555_authorities]), _Citations).
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    findall(Status, dora_payment_related_incidents_status(Profile, Status), [_OneStatus]).

test(non_major_incident_is_not_reported, fail) :-
    subject_status(non_major_payment_institution_incident, chapter_requirements_and_article_19_reporting_apply).
test(major_incident_is_not_only_the_chapter, fail) :-
    subject_status(major_payment_institution_incident, chapter_requirements_apply).
test(exempted_payment_institution_is_reached, fail) :-
    subject_status(exempted_payment_institution_incident, not_an_article_23_entity).
test(credit_institution_is_reached, fail) :-
    subject_status(significant_credit_institution_without_member_state_determination, not_an_article_23_entity).
test(payment_related_incident_is_not_refused, fail) :-
    subject_status(payment_related_electronic_money_incident, not_a_payment_related_incident).
test(settled_incident_is_not_referred, fail) :-
    subject_status(settled_payment_related_incident, needs_legal_review(_Reason, _Context)).
test(settled_major_is_not_referred, fail) :-
    subject_status(settled_major_incident, needs_legal_review(_Reason, _Context)).
test(present_type_is_not_named, fail) :-
    payment_related_incident_status([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, false)], indeterminate([dora_entity_type]), _Citations).
test(missing_incident_is_not_named_for_a_type_not_reached, fail) :-
    payment_related_incident_status([attribute(dora_entity_type, investment_firm), attribute(payment_related_incident_is_major, true)], indeterminate(_MissingKeys), _Citations).
test(missing_major_is_not_named_when_incident_is_false, fail) :-
    payment_related_incident_status([attribute(dora_entity_type, credit_institution), attribute(incident_is_operational_or_security_payment_related, false)], indeterminate([payment_related_incident_is_major]), _Citations).
test(well_formed_profile_is_not_refused, fail) :-
    subject_status(major_payment_institution_incident, input_problems(_Problems)).
test(non_significant_credit_institution_does_not, fail) :-
    subject_result(non_significant_credit_institution_major_incident, recipients([national_competent_authority_designated_under_directive_2013_36|_Others])).
test(significant_credit_institution_does_not_report_to_the_relevant_authority, fail) :-
    subject_result(significant_credit_institution_major_incident, recipients([relevant_competent_authority|_Others])).
test(no_member_state_determination_adds_no_csirt, fail) :-
    subject_result(significant_credit_institution_without_member_state_determination, recipients(List)),
    member(directive_2022_2555_competent_authority_or_csirt, List).
test(not_major_gives_no_list, fail) :-
    subject_result(non_major_payment_institution_incident, recipients(_List)).
test(missing_significance_is_not_named_for_a_payment_institution, fail) :-
    payment_related_incident_report_recipients([attribute(dora_entity_type, payment_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true)], indeterminate([credit_institution_classified_as_significant]), _Citations).
test(missing_member_state_key_is_not_named_when_not_major, fail) :-
    payment_related_incident_report_recipients([attribute(dora_entity_type, payment_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, false)], indeterminate(_MissingKeys), _Citations).
test(the_baseline_profile_yields_no_other_table_status, fail) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    findall(Status, dora_payment_related_incidents_status(Profile, Status), [BaselineStatus]),
    dora_payment_related_incidents_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_payment_related_incidents_status(Profile, Other).

cp_test_names([the_status_table_holds_every_final_atom, major_incident_is_reported, non_major_incident_brings_the_chapter, ict_provider_is_not_reached, institution_exempted_under_directive_2013_36_is_not_reached, not_payment_related_incident, unsure_incident_is_referred, unsure_major_is_referred, missing_type_is_named, missing_incident_is_named, missing_major_is_named_with_unsure_incident, malformed_profile_is_refused, significant_credit_institution_reports_to_the_national_authority, non_significant_credit_institution_reports_to_the_relevant_authority, member_state_determination_adds_the_csirt, not_major_gives_the_chapter_answer, missing_significance_is_named_for_a_credit_institution, missing_member_state_key_is_named_for_a_payment_institution, the_baseline_profile_yields_exactly_one_status]).
cp_test_fail_names([non_major_incident_is_not_reported, major_incident_is_not_only_the_chapter, exempted_payment_institution_is_reached, credit_institution_is_reached, payment_related_incident_is_not_refused, settled_incident_is_not_referred, settled_major_is_not_referred, present_type_is_not_named, missing_incident_is_not_named_for_a_type_not_reached, missing_major_is_not_named_when_incident_is_false, well_formed_profile_is_not_refused, non_significant_credit_institution_does_not, significant_credit_institution_does_not_report_to_the_relevant_authority, no_member_state_determination_adds_no_csirt, not_major_gives_no_list, missing_significance_is_not_named_for_a_payment_institution, missing_member_state_key_is_not_named_when_not_major, the_baseline_profile_yields_no_other_table_status]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
