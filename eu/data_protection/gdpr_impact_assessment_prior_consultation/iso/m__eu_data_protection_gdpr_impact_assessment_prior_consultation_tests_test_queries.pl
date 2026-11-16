% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_queries, [gdpr_impact_assessment_prior_consultation_profile_keys/1, decide_prior_consultation/2, prior_consultation_duty/2, impact_assessment_outside_facts/2, gdpr_impact_assessment_prior_consultation_what_if/4, gdpr_impact_assessment_prior_consultation_compliance_check/3]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_kernel, [gdpr_impact_assessment_prior_consultation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_prior_consultation_duty, [prior_consultation_duty_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_fixtures, [gdpr_impact_assessment_prior_consultation_profile_for/2]).

item_cited(item(_, _, cite(_))).

fixture_check(Subject, Action, Verdict) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    gdpr_impact_assessment_prior_consultation_compliance_check(Profile, Action, Verdict).

test(profile_keys_are_the_contract_keys) :-
    gdpr_impact_assessment_prior_consultation_profile_keys(ProfileKeys),
    ProfileKeys == [assessment_indicates_high_risk_absent_mitigation, automated_evaluation_including_profiling, criminal_offence_data_processed, datasets_matched_or_combined, decisions_based_on_evaluation, decisions_produce_legal_effects, decisions_similarly_significantly_affect, description_of_processing_and_purposes_present, envisaged_measures_described, highly_personal_data_processed, impact_assessment_carried_out, lawful_basis_is_legal_obligation_or_public_task, legal_basis_with_general_impact_assessment, legitimate_interest_described, legitimate_interest_pursued, likely_high_risk_to_rights_and_freedoms, measures_reduce_residual_risk_below_high, member_state_requires_assessment_despite_general_one, member_state_requires_prior_authorisation, mitigating_measures_taken, monitoring_is_systematic, national_list_exempts_assessment, national_list_exempts_item, national_list_requires_assessment, national_list_requires_item, necessity_and_proportionality_assessed, processing_for_public_interest_task, processing_on_large_scale, processing_prevents_exercise_of_right_or_service, publicly_accessible_area_monitored, risks_to_data_subjects_assessed, route_approvals, special_category_data_processed, systematic_and_extensive_evaluation, uses_new_technologies, vulnerable_data_subjects].
test(there_are_thirty_six_contract_keys) :-
    gdpr_impact_assessment_prior_consultation_profile_keys(ProfileKeys),
    length(ProfileKeys, 36).
test(the_status_relation_answers_exactly_once) :-
    gdpr_impact_assessment_prior_consultation_profile_for(member_state_prior_authorisation, Profile),
    findall(Status, prior_consultation_duty(Profile, Status), Statuses),
    Statuses == [required].
test(the_empty_profile_names_every_missing_key) :-
    findall(Status, prior_consultation_duty([], Status), Statuses),
    Statuses == [indeterminate([assessment_indicates_high_risk_absent_mitigation, impact_assessment_carried_out, measures_reduce_residual_risk_below_high, mitigating_measures_taken, processing_for_public_interest_task])].
test(every_checklist_item_carries_a_citation) :-
    gdpr_impact_assessment_prior_consultation_profile_for(residual_high_risk_no_measures, Profile),
    prior_consultation_duty_checklist(Profile, Items),
    length(Items, 7),
    maplist(item_cited, Items).
test(the_checklist_shows_the_unmet_member_state_way) :-
    gdpr_impact_assessment_prior_consultation_profile_for(residual_high_risk_no_measures, Profile),
    prior_consultation_duty_checklist(Profile, Items),
    member(item(art36_5_member_state_prior_authorisation, unmet(art36_5_member_state_prior_authorisation), cite(eu_reg_2016_679_art_36_5)), Items),
    member(item(member_state_requires_prior_authorisation, unknown([member_state_requires_prior_authorisation]), cite(eu_reg_2016_679_art_36_5)), Items).
test(the_checklist_of_a_problem_profile_is_one_cited_row) :-
    gdpr_impact_assessment_prior_consultation_profile_for(duplicate_and_unknown_keys, Profile),
    prior_consultation_duty_checklist(Profile, [item(input_check, unmet(input_problems(_)), cite(eu_reg_2016_679_art_36_1))]).
test(article_36_1_prohibits_processing_without_consultation) :-
    fixture_check(residual_high_risk_no_measures, begin_processing_without_prior_consultation, prohibited).
test(article_36_1_permits_processing_after_consultation) :-
    fixture_check(residual_high_risk_no_measures, begin_processing_after_prior_consultation, permitted).
test(article_36_5_prohibits_processing_after_consultation_alone) :-
    fixture_check(member_state_prior_authorisation, begin_processing_after_prior_consultation, prohibited).
test(article_36_5_permits_processing_after_authorisation) :-
    fixture_check(member_state_prior_authorisation, begin_processing_after_prior_authorisation, permitted).
test(not_required_permits_processing_without_consultation) :-
    fixture_check(measures_bring_risk_below_high, begin_processing_without_prior_consultation, permitted).
test(a_referral_decides_no_action) :-
    fixture_check(no_assessment_public_interest_unmet, begin_processing_without_prior_consultation, not_decided(needs_legal_review(not_governed_here(_), _))).
test(input_problems_decide_no_action) :-
    fixture_check(duplicate_and_unknown_keys, begin_processing_without_prior_consultation, not_decided(input_problems(_))).
test(the_compliance_check_answers_once_per_action) :-
    findall(Action - Verdict, fixture_check(member_state_prior_authorisation, Action, Verdict), Answers),
    Answers == [begin_processing_without_prior_consultation - prohibited, begin_processing_after_prior_consultation - prohibited, begin_processing_after_prior_authorisation - permitted].
test(what_if_measures_leave_the_risk_high_flips_to_required) :-
    gdpr_impact_assessment_prior_consultation_profile_for(measures_bring_risk_below_high, Profile),
    gdpr_impact_assessment_prior_consultation_what_if(Profile, measures_reduce_residual_risk_below_high, false, Verdict),
    Verdict == prior_consultation_verdict(required, [art36_1_residual_high_risk], [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true, measures_reduce_residual_risk_below_high - false])], [cite(eu_reg_2016_679_art_36_1)]).
test(what_if_member_state_law_requires_authorisation_flips_to_required) :-
    gdpr_impact_assessment_prior_consultation_profile_for(member_state_law_does_not_require_authorisation, Profile),
    gdpr_impact_assessment_prior_consultation_what_if(Profile, member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none)), prior_consultation_verdict(required, [art36_5_member_state_prior_authorisation], _, [cite(eu_reg_2016_679_art_36_5)])).
test(what_if_an_ill_typed_edit_is_an_input_problem) :-
    gdpr_impact_assessment_prior_consultation_profile_for(residual_high_risk_no_measures, Profile),
    gdpr_impact_assessment_prior_consultation_what_if(Profile, mitigating_measures_taken, unsure, prior_consultation_verdict(input_problems([wrong_type(mitigating_measures_taken)]), [], [], [])).
test(what_if_answers_exactly_once) :-
    gdpr_impact_assessment_prior_consultation_profile_for(no_assessment_public_interest_unmet, Profile),
    findall(Verdict, gdpr_impact_assessment_prior_consultation_what_if(Profile, impact_assessment_carried_out, true, Verdict), Verdicts),
    Verdicts == [prior_consultation_verdict(required, [art36_1_residual_high_risk], [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true])], [cite(eu_reg_2016_679_art_36_1)])].
test(what_if_on_an_empty_profile_adds_the_key) :-
    gdpr_impact_assessment_prior_consultation_what_if([], impact_assessment_carried_out, true, prior_consultation_verdict(indeterminate([assessment_indicates_high_risk_absent_mitigation, measures_reduce_residual_risk_below_high, mitigating_measures_taken, processing_for_public_interest_task]), [], [], [])).
test(the_whole_verdict_is_served) :-
    gdpr_impact_assessment_prior_consultation_profile_for(both_ways_met, Profile),
    decide_prior_consultation(Profile, prior_consultation_verdict(required, [art36_1_residual_high_risk], _, _)).
test(the_outside_facts_are_five_items) :-
    gdpr_impact_assessment_prior_consultation_profile_for(member_state_prior_authorisation, Profile),
    impact_assessment_outside_facts(Profile, OutsideFacts),
    length(OutsideFacts, 5),
    member(outside_fact(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none))), OutsideFacts).
test(the_input_check_answers_once) :-
    gdpr_impact_assessment_prior_consultation_profile_for(duplicate_and_unknown_keys, Profile),
    findall(Problems, gdpr_impact_assessment_prior_consultation_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(impact_assessment_carried_out), wrong_type(mitigating_measures_taken), unknown_key(stray_flag)]].

test(article_36_5_does_not_permit_consultation_alone, fail) :-
    fixture_check(member_state_prior_authorisation, begin_processing_after_prior_consultation, permitted).
test(an_unknown_action_has_no_answer, fail) :-
    fixture_check(residual_high_risk_no_measures, delete_the_data, _).

cp_test_names([profile_keys_are_the_contract_keys, there_are_thirty_six_contract_keys, the_status_relation_answers_exactly_once, the_empty_profile_names_every_missing_key, every_checklist_item_carries_a_citation, the_checklist_shows_the_unmet_member_state_way, the_checklist_of_a_problem_profile_is_one_cited_row, article_36_1_prohibits_processing_without_consultation, article_36_1_permits_processing_after_consultation, article_36_5_prohibits_processing_after_consultation_alone, article_36_5_permits_processing_after_authorisation, not_required_permits_processing_without_consultation, a_referral_decides_no_action, input_problems_decide_no_action, the_compliance_check_answers_once_per_action, what_if_measures_leave_the_risk_high_flips_to_required, what_if_member_state_law_requires_authorisation_flips_to_required, what_if_an_ill_typed_edit_is_an_input_problem, what_if_answers_exactly_once, what_if_on_an_empty_profile_adds_the_key, the_whole_verdict_is_served, the_outside_facts_are_five_items, the_input_check_answers_once]).
cp_test_fail_names([article_36_5_does_not_permit_consultation_alone, an_unknown_action_has_no_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
