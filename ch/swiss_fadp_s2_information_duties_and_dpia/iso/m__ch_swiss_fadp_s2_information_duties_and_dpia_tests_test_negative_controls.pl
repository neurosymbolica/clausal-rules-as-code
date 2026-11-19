% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s2_information_duties_and_dpia_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_swiss_fadp_s2_information_duties_and_dpia, [swiss_fadp_s2_information_duties_and_dpia_status_values/1, swiss_information_duty/3, swiss_minimum_information_item/4, swiss_automated_decision_information/3, swiss_automated_decision_review/3, swiss_automated_decision_marking/3, swiss_impact_assessment/3, eu_information_duty/3, eu_automated_decision_information/3, eu_impact_assessment/3]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_fixtures, [swiss_fadp_s2_information_duties_and_dpia_profile_for/2]).

swiss_duty(Subject, Result) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    swiss_information_duty(Profile, Result, _).

automated_information(Subject, Result) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    swiss_automated_decision_information(Profile, Result, _).

review_rights(Subject, Result) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    swiss_automated_decision_review(Profile, Result, _).

marking(Subject, Result) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    swiss_automated_decision_marking(Profile, Result, _).

impact(Subject, Result) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    swiss_impact_assessment(Profile, Result, _).

eu_duty(Subject, Result) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    eu_information_duty(Profile, Result, _).

eu_automated(Subject, Result) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    eu_automated_decision_information(Profile, Result, _).

eu_impact(Subject, Result) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    eu_impact_assessment(Profile, Result, _).

minimum_item_result(Subject, Item, Result) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    swiss_minimum_information_item(Profile, Item, Result, _).

test(the_status_table_has_the_three_headline_atoms) :-
    swiss_fadp_s2_information_duties_and_dpia_status_values(StatusValues),
    StatusValues == [information_required, information_not_required, information_may_be_restricted_deferred_or_omitted].
test(already_informed_is_not_required) :-
    swiss_duty(already_informed_exception, information_not_required).
test(baseline_must_inform) :-
    swiss_duty(private_controller_must_inform, information_required).
test(private_secrecy_is_not_required) :-
    swiss_duty(private_secrecy_exception, information_not_required).
test(federal_body_secrecy_must_inform) :-
    swiss_duty(federal_body_secrecy_near_miss, information_required).
test(indirect_disproportionate_is_not_required) :-
    swiss_duty(indirect_collection_disproportionate_effort, information_not_required).
test(direct_disproportionate_must_inform) :-
    swiss_duty(direct_collection_disproportionate_effort_near_miss, information_required).
test(third_party_interests_permit_restriction) :-
    swiss_duty(third_party_interests_restriction, information_may_be_restricted_deferred_or_omitted).
test(private_interests_without_disclosure_permit_restriction) :-
    swiss_duty(private_interests_without_disclosure, information_may_be_restricted_deferred_or_omitted).
test(private_interests_with_disclosure_must_inform) :-
    swiss_duty(private_interests_with_disclosure_near_miss, information_required).
test(federal_investigation_permits_restriction) :-
    swiss_duty(federal_investigation_restriction, information_may_be_restricted_deferred_or_omitted).
test(federal_body_without_ground_must_inform) :-
    swiss_duty(federal_body_without_restriction_ground, information_required).
test(exception_prevails_over_restriction) :-
    swiss_duty(exception_prevails_over_restriction, information_not_required).
test(automated_decision_must_be_disclosed) :-
    automated_information(automated_decision_private_controller, automated_decision_information_required).
test(consent_removes_the_duty) :-
    automated_information(automated_decision_explicit_consent, automated_decision_information_not_required).
test(contract_request_granted_removes_the_duty) :-
    automated_information(automated_decision_contract_request_granted, automated_decision_information_not_required).
test(contract_request_refused_keeps_the_duty) :-
    automated_information(automated_decision_contract_request_refused, automated_decision_information_required).
test(federal_decision_with_hearing_keeps_review) :-
    review_rights(federal_automated_decision_with_hearing, view_and_review_rights_apply).
test(federal_decision_without_hearing_loses_review) :-
    review_rights(federal_automated_decision_without_hearing, view_and_review_rights_do_not_apply).
test(federal_decision_is_marked) :-
    marking(federal_automated_decision_with_hearing, decision_marking_required).
test(private_decision_is_not_marked) :-
    marking(automated_decision_private_controller, decision_marking_not_required).
test(private_controller_obliged_by_law_is_exempt) :-
    impact(private_controller_obliged_by_law, impact_assessment_not_required).
test(federal_body_obliged_by_law_must_assess) :-
    impact(federal_body_obliged_by_law_near_miss, impact_assessment_required).
test(certified_system_may_omit) :-
    impact(certified_system_may_omit_assessment, impact_assessment_may_be_omitted).
test(complete_code_may_omit) :-
    impact(complete_code_of_conduct_may_omit_assessment, impact_assessment_may_be_omitted).
test(unsubmitted_code_must_assess) :-
    impact(code_of_conduct_not_submitted_near_miss, impact_assessment_required).
test(no_high_risk_needs_no_assessment) :-
    impact(private_controller_must_inform, impact_assessment_not_required).
test(safeguards_item_owed_on_disclosure_abroad) :-
    minimum_item_result(disclosure_abroad_with_safeguards, safeguards_or_exception_relied_on, information_item_required).
test(safeguards_item_not_owed_without_disclosure_abroad) :-
    minimum_item_result(reliance_without_disclosure_abroad, safeguards_or_exception_relied_on, information_item_not_required).
test(categories_item_owed_on_indirect_collection) :-
    minimum_item_result(disclosure_abroad_with_safeguards, categories_of_personal_data_processed, information_item_required).
test(categories_item_not_owed_on_direct_collection) :-
    minimum_item_result(private_controller_must_inform, categories_of_personal_data_processed, information_item_not_required).
test(eu_indirect_secrecy_is_not_required) :-
    eu_duty(eu_indirect_professional_secrecy, information_not_required).
test(eu_direct_secrecy_must_inform) :-
    eu_duty(eu_direct_professional_secrecy_near_miss, information_required).
test(eu_automated_decision_must_be_disclosed) :-
    eu_automated(automated_decision_both_regimes, automated_decision_information_required).
test(eu_already_informed_removes_automated_duty) :-
    eu_automated(automated_decision_eu_already_informed, automated_decision_information_not_required).
test(eu_listed_case_requires_assessment) :-
    eu_impact(eu_listed_case_without_exemption, impact_assessment_required).
test(eu_article_35_10_exemption_lifts_assessment) :-
    eu_impact(eu_article_35_10_exemption, impact_assessment_not_required).
test(unsure_judgement_refers_to_a_lawyer) :-
    swiss_duty(already_informed_unsure, needs_legal_review(open_textured(data_subject_already_has_information, cite(ch_fadp_art_20_1_a)), [inputs_relied_on(_)])).
test(malformed_value_is_an_input_problem) :-
    swiss_duty(malformed_federal_body_value, input_problems([wrong_type(controller_is_federal_body)])).

test(already_informed_is_not_required_duty, fail) :-
    swiss_duty(already_informed_exception, information_required).
test(baseline_is_not_exempt, fail) :-
    swiss_duty(private_controller_must_inform, information_not_required).
test(federal_body_secrecy_is_not_exempt, fail) :-
    swiss_duty(federal_body_secrecy_near_miss, information_not_required).
test(direct_disproportionate_is_not_exempt, fail) :-
    swiss_duty(direct_collection_disproportionate_effort_near_miss, information_not_required).
test(private_interests_with_disclosure_permit_nothing, fail) :-
    swiss_duty(private_interests_with_disclosure_near_miss, information_may_be_restricted_deferred_or_omitted).
test(federal_body_without_ground_permits_nothing, fail) :-
    swiss_duty(federal_body_without_restriction_ground, information_may_be_restricted_deferred_or_omitted).
test(exception_prevails_no_permission, fail) :-
    swiss_duty(exception_prevails_over_restriction, information_may_be_restricted_deferred_or_omitted).
test(consent_is_not_a_duty, fail) :-
    automated_information(automated_decision_explicit_consent, automated_decision_information_required).
test(contract_request_refused_is_not_exempt, fail) :-
    automated_information(automated_decision_contract_request_refused, automated_decision_information_not_required).
test(federal_decision_without_hearing_has_no_review, fail) :-
    review_rights(federal_automated_decision_without_hearing, view_and_review_rights_apply).
test(private_decision_marking_is_not_required, fail) :-
    marking(automated_decision_private_controller, decision_marking_required).
test(federal_body_obliged_by_law_is_not_exempt, fail) :-
    impact(federal_body_obliged_by_law_near_miss, impact_assessment_not_required).
test(unsubmitted_code_may_not_omit, fail) :-
    impact(code_of_conduct_not_submitted_near_miss, impact_assessment_may_be_omitted).
test(safeguards_item_without_disclosure_abroad_not_required, fail) :-
    minimum_item_result(reliance_without_disclosure_abroad, safeguards_or_exception_relied_on, information_item_required).
test(categories_item_on_direct_collection_not_required, fail) :-
    minimum_item_result(private_controller_must_inform, categories_of_personal_data_processed, information_item_required).
test(eu_direct_secrecy_is_not_exempt, fail) :-
    eu_duty(eu_direct_professional_secrecy_near_miss, information_not_required).
test(eu_already_informed_has_no_automated_duty, fail) :-
    eu_automated(automated_decision_eu_already_informed, automated_decision_information_required).
test(eu_article_35_10_exemption_is_not_required, fail) :-
    eu_impact(eu_article_35_10_exemption, impact_assessment_required).
test(unsure_judgement_is_not_final, fail) :-
    swiss_duty(already_informed_unsure, information_required).
test(malformed_value_gets_no_final_answer, fail) :-
    swiss_duty(malformed_federal_body_value, information_required).

cp_test_names([the_status_table_has_the_three_headline_atoms, already_informed_is_not_required, baseline_must_inform, private_secrecy_is_not_required, federal_body_secrecy_must_inform, indirect_disproportionate_is_not_required, direct_disproportionate_must_inform, third_party_interests_permit_restriction, private_interests_without_disclosure_permit_restriction, private_interests_with_disclosure_must_inform, federal_investigation_permits_restriction, federal_body_without_ground_must_inform, exception_prevails_over_restriction, automated_decision_must_be_disclosed, consent_removes_the_duty, contract_request_granted_removes_the_duty, contract_request_refused_keeps_the_duty, federal_decision_with_hearing_keeps_review, federal_decision_without_hearing_loses_review, federal_decision_is_marked, private_decision_is_not_marked, private_controller_obliged_by_law_is_exempt, federal_body_obliged_by_law_must_assess, certified_system_may_omit, complete_code_may_omit, unsubmitted_code_must_assess, no_high_risk_needs_no_assessment, safeguards_item_owed_on_disclosure_abroad, safeguards_item_not_owed_without_disclosure_abroad, categories_item_owed_on_indirect_collection, categories_item_not_owed_on_direct_collection, eu_indirect_secrecy_is_not_required, eu_direct_secrecy_must_inform, eu_automated_decision_must_be_disclosed, eu_already_informed_removes_automated_duty, eu_listed_case_requires_assessment, eu_article_35_10_exemption_lifts_assessment, unsure_judgement_refers_to_a_lawyer, malformed_value_is_an_input_problem]).
cp_test_fail_names([already_informed_is_not_required_duty, baseline_is_not_exempt, federal_body_secrecy_is_not_exempt, direct_disproportionate_is_not_exempt, private_interests_with_disclosure_permit_nothing, federal_body_without_ground_permits_nothing, exception_prevails_no_permission, consent_is_not_a_duty, contract_request_refused_is_not_exempt, federal_decision_without_hearing_has_no_review, private_decision_marking_is_not_required, federal_body_obliged_by_law_is_not_exempt, unsubmitted_code_may_not_omit, safeguards_item_without_disclosure_abroad_not_required, categories_item_on_direct_collection_not_required, eu_direct_secrecy_is_not_exempt, eu_already_informed_has_no_automated_duty, eu_article_35_10_exemption_is_not_required, unsure_judgement_is_not_final, malformed_value_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
