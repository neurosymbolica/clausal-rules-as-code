% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [gdpr_consent_conditions_status/2, consent_conditions_status/4, consent_declaration_effect/3, consent_assessment_factors/2, identification_obligation/4, identification_information_duty/4, identification_rights_effect/4]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_profile_for/2]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_kernel, [gdpr_consent_conditions_input_problems/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(not_met_with_citations_bound) :-
    gdpr_consent_conditions_profile_for(consent_two_conditions_unmet, Profile),
    consent_conditions_status(Profile, conditions_not_met, _Basis, [cite(eu_reg_2016_679_art_7_1), cite(eu_reg_2016_679_art_7_4)]).
test(scope_false_is_not_applicable) :-
    gdpr_consent_conditions_profile_for(processing_not_on_consent, Profile),
    consent_conditions_status(Profile, not_applicable, [], []).
test(scope_absent_is_indeterminate) :-
    gdpr_consent_conditions_profile_for(consent_scope_not_stated, Profile),
    consent_conditions_status(Profile, indeterminate([processing_based_on_consent]), [], []).
test(absent_outside_fact_refers) :-
    gdpr_consent_conditions_profile_for(consent_freely_given_not_stated, Profile),
    consent_conditions_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_7_4), cite(consent_freely_given_statement)), [resolution(cite(consent_freely_given_statement), not_attempted), inputs_relied_on([consent_freely_given - absent])]), [], []).
test(declaration_effect_not_binding) :-
    gdpr_consent_conditions_profile_for(declaration_part_infringing, Profile),
    consent_declaration_effect(Profile, part_not_binding, [cite(eu_reg_2016_679_art_7_2)]).
test(factor_reported) :-
    gdpr_consent_conditions_profile_for(contract_conditional_consent, Profile),
    consent_assessment_factors(Profile, [factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))]).
test(factor_empty_when_unconditional) :-
    gdpr_consent_conditions_profile_for(contract_unconditional_consent, Profile),
    consent_assessment_factors(Profile, []).
test(obligation_relief) :-
    gdpr_consent_conditions_profile_for(identification_not_required, Profile),
    identification_obligation(Profile, not_obliged_to_acquire_identifying_information, _Basis, [cite(eu_reg_2016_679_art_11_1)]).
test(duty_must_inform) :-
    gdpr_consent_conditions_profile_for(identification_not_required, Profile),
    identification_information_duty(Profile, must_inform_data_subject, _Basis, [cite(eu_reg_2016_679_art_11_2)]).
test(duty_need_not_inform) :-
    gdpr_consent_conditions_profile_for(identification_information_provided, Profile),
    identification_information_duty(Profile, need_not_inform_data_subject, _Basis, [cite(eu_reg_2016_679_art_11_2)]).
test(rights_do_not_apply) :-
    gdpr_consent_conditions_profile_for(identification_not_required, Profile),
    identification_rights_effect(Profile, articles_15_to_20_do_not_apply, _Basis, [cite(eu_reg_2016_679_art_11_2)]).
test(rights_apply) :-
    gdpr_consent_conditions_profile_for(identification_information_provided, Profile),
    identification_rights_effect(Profile, articles_15_to_20_apply, _Basis, [cite(eu_reg_2016_679_art_11_2)]).
test(rights_indeterminate_without_key) :-
    gdpr_consent_conditions_profile_for(identification_rights_not_stated, Profile),
    identification_rights_effect(Profile, indeterminate([additional_identifying_information_provided]), [], []).
test(input_problems_bound) :-
    gdpr_consent_conditions_profile_for(input_problem_profile, Profile),
    gdpr_consent_conditions_input_problems(Profile, [duplicate_key(processing_based_on_consent), unknown_key(unexpected_key)]).
test(non_list_profile_is_wrong_type) :-
    gdpr_consent_conditions_input_problems(not_a_list, [wrong_type(profile)]).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    gdpr_consent_conditions_status(Profile, conditions_not_met).

cp_test_names([status_holds_with_the_verdict_bound, not_met_with_citations_bound, scope_false_is_not_applicable, scope_absent_is_indeterminate, absent_outside_fact_refers, declaration_effect_not_binding, factor_reported, factor_empty_when_unconditional, obligation_relief, duty_must_inform, duty_need_not_inform, rights_do_not_apply, rights_apply, rights_indeterminate_without_key, input_problems_bound, non_list_profile_is_wrong_type]).
cp_test_fail_names([the_wrong_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
