% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_deployer_duties_fria_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_deployer_duties_fria_deployer_duties_fria, [deployer_duties_fria_status/2, deployer_duties_fria_status_values/1]).
:- use_module(m__eu_ai_act_deployer_duties_fria_queries, [deployer_duties_fria_what_if/4]).
:- use_module(m__eu_ai_act_deployer_duties_fria_fixtures, [deployer_duties_fria_profile_for/2]).

subject_status(Subject, Status) :-
    deployer_duties_fria_profile_for(Subject, Request),
    deployer_duties_fria_status(Request, Status).

subject_what_if(Subject, ProfileKey, NewValue, Status) :-
    deployer_duties_fria_profile_for(Subject, Request),
    deployer_duties_fria_what_if(Request, ProfileKey, NewValue, Status).

table_atom(StatusValues, Atom) :-
    member(Atom, StatusValues).

test(every_near_miss_atom_is_a_vocabulary_atom) :-
    deployer_duties_fria_status_values(StatusValues),
    maplist(table_atom(StatusValues), [not_applicable_on_date, not_a_deployer, not_a_high_risk_ai_system, obligation_does_not_apply, information_under_article_13_of_directive_2016_680, compliance_required_by_31_december_2030, existing_system_without_significant_changes_not_covered, compliance_required_by_2_august_2030, obligation_applies, period_set_by_other_union_or_national_law, retention_period_of_at_least_six_months, retention_period_shorter_than_six_months]).
test(general_date_positive) :-
    subject_status(day_before_first_chapter_iii_day, not_applicable_on_date).
test(general_date_near_miss_gets_its_own_answer) :-
    subject_status(first_chapter_iii_day, obligation_applies).
test(deployer_route_positive) :-
    subject_status(actor_not_the_deployer, not_a_deployer).
test(high_risk_route_positive) :-
    subject_status(system_not_high_risk, not_a_high_risk_ai_system).
test(annex_i_date_positive) :-
    subject_status(product_legislation_system_day_before, not_applicable_on_date).
test(annex_i_date_does_not_hold_back_an_annex_iii_system) :-
    subject_what_if(product_legislation_system_day_before, system_is_a_high_risk_ai_system_listed_in_annex_iii, true, obligation_applies).
test(log_retention_positive) :-
    subject_status(log_retention_applies, obligation_applies).
test(log_retention_near_miss_answer) :-
    subject_status(logs_not_under_control, obligation_does_not_apply).
test(workers_positive) :-
    subject_status(employer_informs_workers, obligation_applies).
test(workers_near_miss_not_at_the_workplace) :-
    subject_what_if(employer_informs_workers, put_into_service_or_used_at_the_workplace, false, obligation_does_not_apply).
test(natural_persons_positive) :-
    subject_status(decisions_about_natural_persons, obligation_applies).
test(natural_persons_annex_i_only_system_is_not_referred_to_in_annex_iii) :-
    deployer_duties_fria_profile_for(decisions_about_natural_persons, deployer_obligation_request(Profile, Obligation, _)),
    deployer_duties_fria_what_if(deployer_obligation_request(Profile, Obligation, date(2029, 1, 1)), system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, true, AnnexIStatus),
    AnnexIStatus == obligation_applies.
test(law_enforcement_positive) :-
    subject_status(law_enforcement_decisions, information_under_article_13_of_directive_2016_680).
test(law_enforcement_outside_the_first_sentence_does_not_apply) :-
    subject_what_if(law_enforcement_decisions, makes_or_assists_in_making_decisions_related_to_natural_persons, false, obligation_does_not_apply).
test(impact_assessment_positive) :-
    subject_status(public_body_impact_assessment, obligation_applies).
test(impact_assessment_credit_scoring_positive) :-
    subject_status(credit_scoring_impact_assessment, obligation_applies).
test(impact_assessment_credit_scoring_near_miss) :-
    subject_what_if(credit_scoring_impact_assessment, system_listed_under_point_5_b_of_annex_iii, false, obligation_does_not_apply).
test(impact_assessment_insurance_pricing) :-
    deployer_duties_fria_profile_for(credit_scoring_impact_assessment, deployer_obligation_request(Profile, Obligation, AssessmentDate)),
    deployer_duties_fria_what_if(deployer_obligation_request(Profile, Obligation, AssessmentDate), system_listed_under_point_5_c_of_annex_iii, true, BothStatus),
    BothStatus == obligation_applies.
test(notification_positive) :-
    subject_status(public_body_notification, obligation_applies).
test(notification_follows_the_assessment) :-
    subject_what_if(public_body_notification, system_listed_under_point_2_of_annex_iii, true, obligation_does_not_apply).
test(annex_x_positive) :-
    subject_status(annex_x_component_day_before_compliance, compliance_required_by_31_december_2030).
test(annex_x_component_keeps_its_date_for_public_authorities) :-
    subject_what_if(annex_x_component_day_before_compliance, intended_to_be_used_by_public_authorities, true, compliance_required_by_31_december_2030).
test(existing_system_positive) :-
    subject_status(existing_system_unchanged, existing_system_without_significant_changes_not_covered).
test(public_authorities_positive) :-
    subject_status(public_authority_system_day_before, compliance_required_by_2_august_2030).
test(public_authorities_changed_system_is_covered_from_its_date) :-
    subject_what_if(public_authority_system_day_before, significant_changes_in_design_as_from_the_chapter_iii_date, true, obligation_applies).
test(an_own_condition_answers_before_the_transitional_rule) :-
    subject_what_if(existing_system_unchanged, logs_automatically_generated_by_the_system_under_the_deployers_control, false, obligation_does_not_apply).
test(minimum_period_positive) :-
    subject_status(retention_of_six_months, retention_period_of_at_least_six_months).
test(minimum_period_near_miss_answer) :-
    subject_status(retention_of_five_months, retention_period_shorter_than_six_months).
test(other_law_positive) :-
    subject_status(retention_set_by_other_law, period_set_by_other_union_or_national_law).
test(missing_key_positive) :-
    subject_status(missing_critical_infrastructure_key, indeterminate([system_listed_under_point_2_of_annex_iii])).
test(referral_positive) :-
    subject_status(unsure_public_body, needs_legal_review(open_textured(body_governed_by_public_law, cite(eu_reg_2024_1689_art_27_1)), _)).
test(an_unsure_judgement_the_answer_does_not_turn_on_is_not_referred) :-
    subject_what_if(public_body_impact_assessment, private_entity_providing_public_services, unsure, obligation_applies).

test(general_date_near_miss_on_the_day, fail) :-
    subject_status(first_chapter_iii_day, not_applicable_on_date).
test(deployer_route_near_miss, fail) :-
    subject_status(log_retention_applies, not_a_deployer).
test(high_risk_route_near_miss, fail) :-
    subject_what_if(system_not_high_risk, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, true, not_a_high_risk_ai_system).
test(annex_i_date_near_miss_on_the_day, fail) :-
    subject_status(product_legislation_system_on_its_date, not_applicable_on_date).
test(log_retention_near_miss, fail) :-
    subject_status(logs_not_under_control, obligation_applies).
test(workers_near_miss_not_an_employer, fail) :-
    subject_status(deployer_not_an_employer, obligation_applies).
test(natural_persons_near_miss, fail) :-
    subject_status(no_decisions_about_natural_persons, obligation_applies).
test(law_enforcement_near_miss, fail) :-
    subject_status(decisions_about_natural_persons, information_under_article_13_of_directive_2016_680).
test(law_enforcement_reads_only_the_natural_persons_duty, fail) :-
    deployer_duties_fria_profile_for(law_enforcement_decisions, deployer_obligation_request(Profile, _, AssessmentDate)),
    deployer_duties_fria_status(deployer_obligation_request(Profile, log_retention, AssessmentDate), information_under_article_13_of_directive_2016_680).
test(impact_assessment_near_miss_critical_infrastructure, fail) :-
    subject_status(critical_infrastructure_impact_assessment, obligation_applies).
test(notification_near_miss_exempt, fail) :-
    subject_status(exempt_notification, obligation_applies).
test(annex_x_near_miss_on_the_day, fail) :-
    subject_status(annex_x_component_on_compliance_day, compliance_required_by_31_december_2030).
test(existing_system_near_miss_changed, fail) :-
    subject_status(existing_system_significantly_changed, existing_system_without_significant_changes_not_covered).
test(public_authorities_near_miss_on_the_day, fail) :-
    subject_status(public_authority_system_on_compliance_day, compliance_required_by_2_august_2030).
test(minimum_period_near_miss, fail) :-
    subject_status(retention_of_five_months, retention_period_of_at_least_six_months).
test(six_months_are_not_short, fail) :-
    subject_status(retention_of_six_months, retention_period_shorter_than_six_months).
test(other_law_near_miss, fail) :-
    subject_status(retention_of_five_months, period_set_by_other_union_or_national_law).
test(missing_key_near_miss, fail) :-
    subject_status(credit_scoring_impact_assessment, indeterminate(_)).
test(referral_near_miss, fail) :-
    subject_status(public_body_impact_assessment, needs_legal_review(_, _)).

cp_test_names([every_near_miss_atom_is_a_vocabulary_atom, general_date_positive, general_date_near_miss_gets_its_own_answer, deployer_route_positive, high_risk_route_positive, annex_i_date_positive, annex_i_date_does_not_hold_back_an_annex_iii_system, log_retention_positive, log_retention_near_miss_answer, workers_positive, workers_near_miss_not_at_the_workplace, natural_persons_positive, natural_persons_annex_i_only_system_is_not_referred_to_in_annex_iii, law_enforcement_positive, law_enforcement_outside_the_first_sentence_does_not_apply, impact_assessment_positive, impact_assessment_credit_scoring_positive, impact_assessment_credit_scoring_near_miss, impact_assessment_insurance_pricing, notification_positive, notification_follows_the_assessment, annex_x_positive, annex_x_component_keeps_its_date_for_public_authorities, existing_system_positive, public_authorities_positive, public_authorities_changed_system_is_covered_from_its_date, an_own_condition_answers_before_the_transitional_rule, minimum_period_positive, minimum_period_near_miss_answer, other_law_positive, missing_key_positive, referral_positive, an_unsure_judgement_the_answer_does_not_turn_on_is_not_referred]).
cp_test_fail_names([general_date_near_miss_on_the_day, deployer_route_near_miss, high_risk_route_near_miss, annex_i_date_near_miss_on_the_day, log_retention_near_miss, workers_near_miss_not_an_employer, natural_persons_near_miss, law_enforcement_near_miss, law_enforcement_reads_only_the_natural_persons_duty, impact_assessment_near_miss_critical_infrastructure, notification_near_miss_exempt, annex_x_near_miss_on_the_day, existing_system_near_miss_changed, public_authorities_near_miss_on_the_day, minimum_period_near_miss, six_months_are_not_short, other_law_near_miss, missing_key_near_miss, referral_near_miss]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
