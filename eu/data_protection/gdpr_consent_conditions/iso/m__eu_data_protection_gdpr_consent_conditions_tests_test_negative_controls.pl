% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [gdpr_consent_conditions_status/2, gdpr_consent_conditions_status_values/1, consent_conditions_status/4, consent_declaration_effect/3, consent_assessment_factors/2, identification_obligation/4, identification_information_duty/4, identification_rights_effect/4]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_profile_for/2]).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    gdpr_consent_conditions_status_values(StatusValues),
    member(conditions_not_met, StatusValues).
test(demonstrable_true_met) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(demonstrable_false_not_met) :-
    gdpr_consent_conditions_profile_for(consent_not_demonstrable, Profile),
    gdpr_consent_conditions_status(Profile, conditions_not_met).
test(request_clear_met) :-
    gdpr_consent_conditions_profile_for(consent_met_with_declaration, Profile),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(request_unclear_not_met) :-
    gdpr_consent_conditions_profile_for(consent_request_unclear, Profile),
    gdpr_consent_conditions_status(Profile, conditions_not_met).
test(informed_false_not_met) :-
    gdpr_consent_conditions_profile_for(consent_withdrawal_not_informed, Profile),
    gdpr_consent_conditions_status(Profile, conditions_not_met).
test(freely_false_not_met) :-
    gdpr_consent_conditions_profile_for(consent_not_freely_given, Profile),
    gdpr_consent_conditions_status(Profile, conditions_not_met).
test(scope_false_not_applicable) :-
    gdpr_consent_conditions_profile_for(processing_not_on_consent, Profile),
    gdpr_consent_conditions_status(Profile, not_applicable).
test(absent_freely_given_refers) :-
    gdpr_consent_conditions_profile_for(consent_freely_given_not_stated, Profile),
    gdpr_consent_conditions_status(Profile, needs_legal_review(_, _)).
test(infringing_part_not_binding) :-
    gdpr_consent_conditions_profile_for(declaration_part_infringing, Profile),
    consent_declaration_effect(Profile, part_not_binding, _).
test(clean_declaration_no_part_infringing) :-
    gdpr_consent_conditions_profile_for(consent_met_with_declaration, Profile),
    consent_declaration_effect(Profile, no_part_infringing, _).
test(factor_reported_when_true) :-
    gdpr_consent_conditions_profile_for(contract_conditional_consent, Profile),
    consent_assessment_factors(Profile, [factor(contract_conditional_on_unneeded_consent, _)]).
test(factor_list_empty_when_false) :-
    gdpr_consent_conditions_profile_for(contract_unconditional_consent, Profile),
    consent_assessment_factors(Profile, []).
test(purposes_true_relief) :-
    gdpr_consent_conditions_profile_for(identification_not_required, Profile),
    identification_obligation(Profile, not_obliged_to_acquire_identifying_information, _, _).
test(purposes_false_not_engaged) :-
    gdpr_consent_conditions_profile_for(identification_purposes_require, Profile),
    identification_obligation(Profile, art11_1_not_engaged, _, _).
test(possible_true_must_inform) :-
    gdpr_consent_conditions_profile_for(identification_not_required, Profile),
    identification_information_duty(Profile, must_inform_data_subject, _, _).
test(possible_false_need_not_inform) :-
    gdpr_consent_conditions_profile_for(identification_information_provided, Profile),
    identification_information_duty(Profile, need_not_inform_data_subject, _, _).
test(purposes_false_duty_not_engaged) :-
    gdpr_consent_conditions_profile_for(identification_purposes_require, Profile),
    identification_information_duty(Profile, art11_2_not_engaged, _, _).
test(provided_true_rights_apply) :-
    gdpr_consent_conditions_profile_for(identification_information_provided, Profile),
    identification_rights_effect(Profile, articles_15_to_20_apply, _, _).
test(provided_false_rights_do_not_apply) :-
    gdpr_consent_conditions_profile_for(identification_not_required, Profile),
    identification_rights_effect(Profile, articles_15_to_20_do_not_apply, _, _).
test(purposes_false_rights_not_engaged) :-
    gdpr_consent_conditions_profile_for(identification_purposes_require, Profile),
    identification_rights_effect(Profile, art11_2_not_engaged, _, _).

test(the_plain_profile_is_not_conditions_not_met, fail) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    gdpr_consent_conditions_status(Profile, conditions_not_met).
test(demonstrable_false_is_not_met_status, fail) :-
    gdpr_consent_conditions_profile_for(consent_not_demonstrable, Profile),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(request_unclear_is_not_met_status, fail) :-
    gdpr_consent_conditions_profile_for(consent_request_unclear, Profile),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(informed_false_is_not_met_status, fail) :-
    gdpr_consent_conditions_profile_for(consent_withdrawal_not_informed, Profile),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(freely_false_is_not_met_status, fail) :-
    gdpr_consent_conditions_profile_for(consent_not_freely_given, Profile),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(scope_false_is_not_conditions_met, fail) :-
    gdpr_consent_conditions_profile_for(processing_not_on_consent, Profile),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(absent_freely_given_is_not_met, fail) :-
    gdpr_consent_conditions_profile_for(consent_freely_given_not_stated, Profile),
    gdpr_consent_conditions_status(Profile, conditions_met).
test(clean_declaration_is_not_part_not_binding, fail) :-
    gdpr_consent_conditions_profile_for(consent_met_with_declaration, Profile),
    consent_declaration_effect(Profile, part_not_binding, _).
test(factor_not_reported_when_false, fail) :-
    gdpr_consent_conditions_profile_for(contract_unconditional_consent, Profile),
    consent_assessment_factors(Profile, [factor(_, _)]).
test(purposes_false_has_no_relief, fail) :-
    gdpr_consent_conditions_profile_for(identification_purposes_require, Profile),
    identification_obligation(Profile, not_obliged_to_acquire_identifying_information, _, _).
test(possible_false_is_not_must_inform, fail) :-
    gdpr_consent_conditions_profile_for(identification_information_provided, Profile),
    identification_information_duty(Profile, must_inform_data_subject, _, _).
test(provided_false_is_not_apply, fail) :-
    gdpr_consent_conditions_profile_for(identification_not_required, Profile),
    identification_rights_effect(Profile, articles_15_to_20_apply, _, _).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, demonstrable_true_met, demonstrable_false_not_met, request_clear_met, request_unclear_not_met, informed_false_not_met, freely_false_not_met, scope_false_not_applicable, absent_freely_given_refers, infringing_part_not_binding, clean_declaration_no_part_infringing, factor_reported_when_true, factor_list_empty_when_false, purposes_true_relief, purposes_false_not_engaged, possible_true_must_inform, possible_false_need_not_inform, purposes_false_duty_not_engaged, provided_true_rights_apply, provided_false_rights_do_not_apply, purposes_false_rights_not_engaged]).
cp_test_fail_names([the_plain_profile_is_not_conditions_not_met, demonstrable_false_is_not_met_status, request_unclear_is_not_met_status, informed_false_is_not_met_status, freely_false_is_not_met_status, scope_false_is_not_conditions_met, absent_freely_given_is_not_met, clean_declaration_is_not_part_not_binding, factor_not_reported_when_false, purposes_false_has_no_relief, possible_false_is_not_must_inform, provided_false_is_not_apply]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
