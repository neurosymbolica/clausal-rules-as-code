% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [gdpr_consent_conditions_status_values/1, consent_conditions_status/4, consent_declaration_effect/3, consent_assessment_factors/2, identification_obligation/4, identification_information_duty/4, identification_rights_effect/4]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_profile_for/2]).

affirmed_statement(attested(true, attestation(by, at, reason, none))).

consent_status_of(Subject, Status) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    consent_conditions_status(Profile, Status, _, _).

declaration_effect_of(Subject, Status) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    consent_declaration_effect(Profile, Status, _).

factors_of(Subject, Factors) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    consent_assessment_factors(Profile, Factors).

obligation_of(Subject, Status) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    identification_obligation(Profile, Status, _, _).

information_duty_of(Subject, Status) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    identification_information_duty(Profile, Status, _, _).

rights_effect_of(Subject, Status) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    identification_rights_effect(Profile, Status, _, _).

test(the_status_table_spells_the_final_consent_statuses) :-
    gdpr_consent_conditions_status_values(StatusValues),
    StatusValues == [not_applicable, conditions_met, conditions_not_met].
test(demonstration_positive_conditions_met) :-
    consent_status_of(consent_all_conditions_met, conditions_met).
test(demonstration_near_miss_flips_to_conditions_not_met) :-
    consent_status_of(consent_demonstration_not_shown, conditions_not_met).
test(presentation_positive_conditions_met) :-
    consent_status_of(consent_declaration_request_clear, conditions_met).
test(presentation_near_miss_flips_to_conditions_not_met) :-
    gdpr_consent_conditions_profile_for(consent_declaration_request_unclear, Profile),
    consent_conditions_status(Profile, conditions_not_met, _, [cite(eu_reg_2016_679_art_7_2)]).
test(with_a_declaration_article_7_2_is_cited) :-
    gdpr_consent_conditions_profile_for(consent_declaration_request_clear, Profile),
    consent_conditions_status(Profile, _, _, Citations),
    member(cite(eu_reg_2016_679_art_7_2), Citations).
test(withdrawal_information_near_miss_flips) :-
    gdpr_consent_conditions_profile_for(consent_withdrawal_not_informed, Profile),
    consent_conditions_status(Profile, conditions_not_met, [], [cite(eu_reg_2016_679_art_7_3)]).
test(withdrawal_ease_near_miss_flips) :-
    consent_status_of(consent_withdrawal_harder_than_giving, conditions_not_met).
test(freely_given_near_miss_flips) :-
    gdpr_consent_conditions_profile_for(consent_not_freely_given, Profile),
    consent_conditions_status(Profile, conditions_not_met, _, [cite(eu_reg_2016_679_art_7_4)]).
test(scope_near_miss_flips_to_not_applicable) :-
    consent_status_of(processing_not_based_on_consent, not_applicable).
test(scope_dropped_flips_to_indeterminate) :-
    consent_status_of(consent_scope_absent, indeterminate([processing_based_on_consent])).
test(statement_dropped_flips_to_a_referral) :-
    consent_status_of(consent_demonstration_statement_absent, needs_legal_review(_, _)).
test(an_unknown_key_flips_to_input_problems) :-
    consent_status_of(consent_unknown_key_profile, input_problems([unknown_key(colour)])).
test(without_the_unknown_key_the_crisp_keys_are_named) :-
    consent_conditions_status([attribute(processing_based_on_consent, true)], indeterminate([consent_in_declaration_with_other_matters, informed_of_withdrawal_right_before_consent]), [], []).
test(declaration_positive_part_not_binding) :-
    declaration_effect_of(declaration_part_infringing, part_not_binding).
test(declaration_near_miss_no_part_infringing) :-
    declaration_effect_of(declaration_no_part_infringing, no_part_infringing).
test(declaration_without_other_matters_is_not_applicable) :-
    declaration_effect_of(declaration_without_other_matters, not_applicable).
test(factor_positive_is_reported) :-
    factors_of(contract_conditional_on_unneeded_consent_factor, [factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))]).
test(factor_near_miss_reports_nothing) :-
    factors_of(contract_not_conditional_on_unneeded_consent, []).
test(the_factor_decides_no_consent_status) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    consent_conditions_status([attribute(contract_conditional_on_unneeded_consent, true)|Profile], conditions_met, _, _).
test(obligation_positive_relief) :-
    obligation_of(identification_not_required, not_obliged_to_acquire_identifying_information).
test(obligation_near_miss_not_engaged) :-
    obligation_of(identification_required, art11_1_not_engaged).
test(duty_positive_must_inform) :-
    information_duty_of(informing_data_subject_is_possible, must_inform_data_subject).
test(duty_near_miss_need_not_inform) :-
    information_duty_of(informing_data_subject_is_impossible, need_not_inform_data_subject).
test(engagement_near_miss_not_engaged) :-
    information_duty_of(inability_to_identify_not_demonstrated, art11_2_not_engaged).
test(rights_defeater_positive_articles_apply) :-
    rights_effect_of(identifying_information_provided, articles_15_to_20_apply).
test(rights_defeater_near_miss_articles_do_not_apply) :-
    rights_effect_of(identifying_information_not_provided, articles_15_to_20_do_not_apply).
test(rights_open_case_names_the_crisp_key) :-
    rights_effect_of(rights_engagement_open_information_key_absent, indeterminate([additional_identifying_information_provided])).
test(rights_open_case_with_the_crisp_key_refers) :-
    affirmed_statement(Affirmed),
    identification_rights_effect([attribute(able_to_demonstrate_not_in_position_to_identify, Affirmed), attribute(additional_identifying_information_provided, false)], needs_legal_review(_, _), [], []).

test(demonstration_near_miss_is_not_conditions_met, fail) :-
    consent_status_of(consent_demonstration_not_shown, conditions_met).
test(demonstration_positive_is_not_conditions_not_met, fail) :-
    consent_status_of(consent_all_conditions_met, conditions_not_met).
test(presentation_near_miss_is_not_conditions_met, fail) :-
    consent_status_of(consent_declaration_request_unclear, conditions_met).
test(without_a_declaration_article_7_2_is_not_cited, fail) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    consent_conditions_status(Profile, _, _, Citations),
    member(cite(eu_reg_2016_679_art_7_2), Citations).
test(withdrawal_information_near_miss_is_not_conditions_met, fail) :-
    consent_status_of(consent_withdrawal_not_informed, conditions_met).
test(withdrawal_ease_near_miss_is_not_conditions_met, fail) :-
    consent_status_of(consent_withdrawal_harder_than_giving, conditions_met).
test(freely_given_near_miss_is_not_conditions_met, fail) :-
    consent_status_of(consent_not_freely_given, conditions_met).
test(scope_near_miss_is_not_conditions_met, fail) :-
    consent_status_of(processing_not_based_on_consent, conditions_met).
test(scope_dropped_is_not_not_applicable, fail) :-
    consent_status_of(consent_scope_absent, not_applicable).
test(statement_dropped_is_not_conditions_met, fail) :-
    consent_status_of(consent_demonstration_statement_absent, conditions_met).
test(statement_dropped_is_never_named_missing, fail) :-
    consent_status_of(consent_demonstration_statement_absent, indeterminate(_)).
test(without_the_unknown_key_there_are_no_input_problems, fail) :-
    consent_conditions_status([attribute(processing_based_on_consent, true)], input_problems(_), _, _).
test(declaration_near_miss_is_not_part_not_binding, fail) :-
    declaration_effect_of(declaration_no_part_infringing, part_not_binding).
test(declaration_without_other_matters_is_not_part_not_binding, fail) :-
    declaration_effect_of(declaration_without_other_matters, part_not_binding).
test(factor_near_miss_is_not_reported, fail) :-
    factors_of(contract_not_conditional_on_unneeded_consent, [_|_]).
test(obligation_near_miss_is_not_relief, fail) :-
    obligation_of(identification_required, not_obliged_to_acquire_identifying_information).
test(duty_near_miss_is_not_must_inform, fail) :-
    information_duty_of(informing_data_subject_is_impossible, must_inform_data_subject).
test(engagement_near_miss_is_not_must_inform, fail) :-
    information_duty_of(inability_to_identify_not_demonstrated, must_inform_data_subject).
test(rights_defeater_near_miss_is_not_articles_apply, fail) :-
    rights_effect_of(identifying_information_not_provided, articles_15_to_20_apply).
test(rights_open_case_is_not_a_referral, fail) :-
    rights_effect_of(rights_engagement_open_information_key_absent, needs_legal_review(_, _)).

cp_test_names([the_status_table_spells_the_final_consent_statuses, demonstration_positive_conditions_met, demonstration_near_miss_flips_to_conditions_not_met, presentation_positive_conditions_met, presentation_near_miss_flips_to_conditions_not_met, with_a_declaration_article_7_2_is_cited, withdrawal_information_near_miss_flips, withdrawal_ease_near_miss_flips, freely_given_near_miss_flips, scope_near_miss_flips_to_not_applicable, scope_dropped_flips_to_indeterminate, statement_dropped_flips_to_a_referral, an_unknown_key_flips_to_input_problems, without_the_unknown_key_the_crisp_keys_are_named, declaration_positive_part_not_binding, declaration_near_miss_no_part_infringing, declaration_without_other_matters_is_not_applicable, factor_positive_is_reported, factor_near_miss_reports_nothing, the_factor_decides_no_consent_status, obligation_positive_relief, obligation_near_miss_not_engaged, duty_positive_must_inform, duty_near_miss_need_not_inform, engagement_near_miss_not_engaged, rights_defeater_positive_articles_apply, rights_defeater_near_miss_articles_do_not_apply, rights_open_case_names_the_crisp_key, rights_open_case_with_the_crisp_key_refers]).
cp_test_fail_names([demonstration_near_miss_is_not_conditions_met, demonstration_positive_is_not_conditions_not_met, presentation_near_miss_is_not_conditions_met, without_a_declaration_article_7_2_is_not_cited, withdrawal_information_near_miss_is_not_conditions_met, withdrawal_ease_near_miss_is_not_conditions_met, freely_given_near_miss_is_not_conditions_met, scope_near_miss_is_not_conditions_met, scope_dropped_is_not_not_applicable, statement_dropped_is_not_conditions_met, statement_dropped_is_never_named_missing, without_the_unknown_key_there_are_no_input_problems, declaration_near_miss_is_not_part_not_binding, declaration_without_other_matters_is_not_part_not_binding, factor_near_miss_is_not_reported, obligation_near_miss_is_not_relief, duty_near_miss_is_not_must_inform, engagement_near_miss_is_not_must_inform, rights_defeater_near_miss_is_not_articles_apply, rights_open_case_is_not_a_referral]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
