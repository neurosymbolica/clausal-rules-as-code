% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_payment_related_incidents_dora_payment_related_incidents, [payment_related_incident_status/3, payment_related_incident_report_recipients/3, dora_payment_related_incidents_status/2, dora_payment_related_incidents_status_values/1]).
:- use_module(m__eu_dora_payment_related_incidents_fixtures, [dora_payment_related_incidents_profile_for/2]).

test(s9_holds_with_the_reporting_status_bound) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    payment_related_incident_status(Profile, chapter_requirements_and_article_19_reporting_apply, _Citations).
test(s8_holds_with_the_chapter_status_bound) :-
    dora_payment_related_incidents_profile_for(non_major_payment_institution_incident, Profile),
    payment_related_incident_status(Profile, chapter_requirements_apply, _Citations).
test(s2_holds_with_status_and_citation_bound) :-
    dora_payment_related_incidents_profile_for(ict_third_party_service_provider_incident, Profile),
    payment_related_incident_status(Profile, not_an_article_23_entity, [cite(eu_reg_2022_2554_art_23)]).
test(s3_holds_with_status_and_citations_bound) :-
    dora_payment_related_incidents_profile_for(not_payment_related_electronic_money_incident, Profile),
    payment_related_incident_status(Profile, not_a_payment_related_incident, [cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9)]).
test(s1_holds_with_the_gate_bound) :-
    dora_payment_related_incidents_profile_for(missing_entity_type, Profile),
    payment_related_incident_status(Profile, indeterminate([dora_entity_type]), []).
test(s4_holds_with_the_missing_incident_bound) :-
    dora_payment_related_incidents_profile_for(missing_incident_judgement, Profile),
    payment_related_incident_status(Profile, indeterminate([incident_is_operational_or_security_payment_related]), []).
test(s5_holds_with_the_missing_major_bound) :-
    dora_payment_related_incidents_profile_for(missing_major_with_unsure_incident, Profile),
    payment_related_incident_status(Profile, indeterminate([payment_related_incident_is_major]), []).
test(s6_holds_with_the_referral_bound) :-
    dora_payment_related_incidents_profile_for(unsure_payment_related_incident, Profile),
    payment_related_incident_status(Profile, needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on([dora_entity_type - account_information_service_provider, incident_is_operational_or_security_payment_related - unsure, payment_related_incident_is_major - true])]), []).
test(s7_holds_with_the_referral_bound) :-
    dora_payment_related_incidents_profile_for(unsure_major_incident, Profile),
    payment_related_incident_status(Profile, needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on([dora_entity_type - exempted_electronic_money_institution, incident_is_operational_or_security_payment_related - true, payment_related_incident_is_major - unsure])]), []).
test(s0_holds_with_the_problems_bound) :-
    dora_payment_related_incidents_profile_for(malformed_entity_type, Profile),
    payment_related_incident_status(Profile, input_problems([wrong_type(dora_entity_type)]), []).
test(r11_holds_with_the_list_bound) :-
    dora_payment_related_incidents_profile_for(significant_credit_institution_major_incident, Profile),
    payment_related_incident_report_recipients(Profile, recipients([national_competent_authority_designated_under_directive_2013_36, directive_2022_2555_competent_authority_or_csirt]), _Citations).
test(r7_holds_with_the_missing_significance_bound) :-
    dora_payment_related_incidents_profile_for(missing_significance, Profile),
    payment_related_incident_report_recipients(Profile, indeterminate([credit_institution_classified_as_significant]), []).
test(the_baseline_status_holds_with_the_verdict_bound) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    findall(Status, dora_payment_related_incidents_status(Profile, Status), [BaselineStatus]),
    dora_payment_related_incidents_status(Profile, BaselineStatus).
test(the_order_of_the_attributes_does_not_change_the_answer) :-
    dora_payment_related_incidents_profile_for(significant_credit_institution_major_incident, Profile),
    reverse(Profile, ReversedProfile),
    findall(Result, payment_related_incident_report_recipients(ReversedProfile, Result, _Citations), Results),
    Results == [recipients([national_competent_authority_designated_under_directive_2013_36, directive_2022_2555_competent_authority_or_csirt])].
test(an_atom_profile_is_wrong_type_profile) :-
    payment_related_incident_status(no_profile, input_problems([wrong_type(profile)]), []).
test(an_unbound_profile_is_wrong_type_profile) :-
    payment_related_incident_report_recipients(_Profile, input_problems([wrong_type(profile)]), []).
test(a_list_of_pairs_is_not_an_attribute_list) :-
    payment_related_incident_status([dora_entity_type - credit_institution], input_problems([wrong_type(profile)]), []).
test(a_repeated_key_is_a_duplicate_key) :-
    payment_related_incident_status([attribute(dora_entity_type, credit_institution), attribute(dora_entity_type, payment_institution)], input_problems([duplicate_key(dora_entity_type)]), []).
test(an_unknown_key_with_an_unbound_value_is_only_unknown) :-
    payment_related_incident_status([attribute(colour, _Value)], input_problems([unknown_key(colour)]), []).
test(unsure_for_a_fact_key_is_wrong_type) :-
    payment_related_incident_report_recipients([attribute(member_state_requires_reports_to_directive_2022_2555_authorities, unsure)], input_problems([wrong_type(member_state_requires_reports_to_directive_2022_2555_authorities)]), []).
test(a_number_for_a_judgement_key_is_wrong_type) :-
    payment_related_incident_status([attribute(payment_related_incident_is_major, 1)], input_problems([wrong_type(payment_related_incident_is_major)]), []).
test(a_compound_key_is_an_unknown_key) :-
    payment_related_incident_status([attribute(key(dora_entity_type), credit_institution)], input_problems([unknown_key(key(dora_entity_type))]), []).
test(a_significance_fact_for_another_type_is_accepted_and_not_read) :-
    findall(Result, payment_related_incident_report_recipients([attribute(dora_entity_type, electronic_money_institution), attribute(incident_is_operational_or_security_payment_related, true), attribute(payment_related_incident_is_major, true), attribute(credit_institution_classified_as_significant, true), attribute(member_state_requires_reports_to_directive_2022_2555_authorities, false)], Result, _Citations), Results),
    Results == [recipients([relevant_competent_authority])].

test(every_other_bound_status_is_rejected, fail) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    findall(Status, dora_payment_related_incidents_status(Profile, Status), [BaselineStatus]),
    dora_payment_related_incidents_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_payment_related_incidents_status(Profile, Other).

cp_test_names([s9_holds_with_the_reporting_status_bound, s8_holds_with_the_chapter_status_bound, s2_holds_with_status_and_citation_bound, s3_holds_with_status_and_citations_bound, s1_holds_with_the_gate_bound, s4_holds_with_the_missing_incident_bound, s5_holds_with_the_missing_major_bound, s6_holds_with_the_referral_bound, s7_holds_with_the_referral_bound, s0_holds_with_the_problems_bound, r11_holds_with_the_list_bound, r7_holds_with_the_missing_significance_bound, the_baseline_status_holds_with_the_verdict_bound, the_order_of_the_attributes_does_not_change_the_answer, an_atom_profile_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, a_list_of_pairs_is_not_an_attribute_list, a_repeated_key_is_a_duplicate_key, an_unknown_key_with_an_unbound_value_is_only_unknown, unsure_for_a_fact_key_is_wrong_type, a_number_for_a_judgement_key_is_wrong_type, a_compound_key_is_an_unknown_key, a_significance_fact_for_another_type_is_accepted_and_not_read]).
cp_test_fail_names([every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
