% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_payments_psa_licence_class_psa_licence_class, [decide_psa_licence_class/2, psa_licence_class_status/2, psa_licence_class_checklist/2, psa_licence_class_decision_resolvable/1, psa_licence_class_status_values/1]).
:- use_module(m__sg_payments_psa_licence_class_fixtures, [psa_licence_class_subject/1, psa_licence_class_profile_for/2, psa_licence_class_assess/2]).
:- use_module(m__sg_payments_psa_licence_class_queries, [psa_licence_class_what_if/4, psa_licence_class_threshold/3, psa_licence_class_profile_keys/1]).

test(no_services_is_no_licence_required) :-
    psa_licence_class_assess(no_services, psa_licence(no_licence_required, [], 0, [])).
test(no_services_near_miss_is_spi) :-
    psa_licence_class_assess(no_services_near_miss, psa_licence(standard_payment_institution_licence, [], 0, [sg_psa_2019_s6_4])).
test(exempt_basic_is_exempt) :-
    psa_licence_class_assess(exempt_basic, psa_licence(exempt_payment_service_provider, [], 0, [sg_psa_2019_s5_1_b])).
test(exempt_near_miss_is_spi) :-
    psa_licence_class_assess(exempt_near_miss, psa_licence(standard_payment_institution_licence, [], 0, [sg_psa_2019_s6_4])).
test(money_changing_only_is_money_changing_licence) :-
    psa_licence_class_assess(money_changing_only, psa_licence(money_changing_licence, [], 0, [sg_psa_2019_s6_3])).
test(money_changing_near_miss_is_spi) :-
    psa_licence_class_assess(money_changing_near_miss, psa_licence(standard_payment_institution_licence, [], 0, [sg_psa_2019_s6_4])).
test(single_volume_mpi_is_mpi) :-
    psa_licence_class_assess(single_volume_mpi, psa_licence(major_payment_institution_licence, [single_service_volume], 300000001, [sg_psa_2019_s6_4, sg_psa_2019_s6_5_a_ii_a])).
test(single_volume_at_threshold_is_spi) :-
    psa_licence_class_assess(single_volume_at_threshold, psa_licence(standard_payment_institution_licence, [], 300000000, [sg_psa_2019_s6_4])).
test(multi_volume_mpi_is_mpi) :-
    psa_licence_class_assess(multi_volume_mpi, psa_licence(major_payment_institution_licence, [multi_service_volume], 610000000, [sg_psa_2019_s6_4, sg_psa_2019_s6_5_a_ii_b])).
test(multi_volume_at_threshold_is_spi) :-
    psa_licence_class_assess(multi_volume_at_threshold, psa_licence(standard_payment_institution_licence, [], 600000000, [sg_psa_2019_s6_4])).
test(e_money_float_mpi_is_mpi) :-
    psa_licence_class_assess(e_money_float_mpi, psa_licence(major_payment_institution_licence, [e_money_account_float], 0, [sg_psa_2019_s6_4, sg_psa_2019_s6_5_b])).
test(e_money_float_at_threshold_is_spi) :-
    psa_licence_class_assess(e_money_float_at_threshold, psa_licence(standard_payment_institution_licence, [], 0, [sg_psa_2019_s6_4])).
test(e_money_issued_mpi_is_mpi) :-
    psa_licence_class_assess(e_money_issued_mpi, psa_licence(major_payment_institution_licence, [e_money_issued], 0, [sg_psa_2019_s6_4, sg_psa_2019_s6_5_c])).
test(e_money_issued_at_threshold_is_spi) :-
    psa_licence_class_assess(e_money_issued_at_threshold, psa_licence(standard_payment_institution_licence, [], 0, [sg_psa_2019_s6_4])).
test(indeterminate_missing_services) :-
    psa_licence_class_assess(indeterminate_missing_services, psa_licence(indeterminate, [], n_a, [])).
test(indeterminate_missing_exempt) :-
    psa_licence_class_assess(indeterminate_missing_exempt, psa_licence(indeterminate, [], n_a, [])).
test(status_determination_no_services) :-
    psa_licence_class_profile_for(no_services, Profile),
    psa_licence_class_status(Profile, no_licence_required).
test(status_determination_mpi) :-
    psa_licence_class_profile_for(single_volume_mpi, Profile),
    psa_licence_class_status(Profile, major_payment_institution_licence).
test(status_determination_spi) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    psa_licence_class_status(Profile, standard_payment_institution_licence).
test(status_determination_indeterminate) :-
    psa_licence_class_profile_for(indeterminate_missing_services, Profile),
    psa_licence_class_status(Profile, indeterminate).
test(checklist_non_empty_spi) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    psa_licence_class_checklist(Profile, [_Item|_Rest]).
test(checklist_non_empty_mpi) :-
    psa_licence_class_profile_for(single_volume_mpi, Profile),
    psa_licence_class_checklist(Profile, [_Item|_Rest]).
test(checklist_non_empty_indeterminate) :-
    psa_licence_class_profile_for(indeterminate_missing_services, Profile),
    psa_licence_class_checklist(Profile, [_Item|_Rest]).
test(decision_resolvable_on_spi) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    psa_licence_class_decision_resolvable(Profile).
test(decision_resolvable_on_indeterminate) :-
    psa_licence_class_profile_for(indeterminate_missing_services, Profile),
    psa_licence_class_decision_resolvable(Profile).
test(status_values_complete) :-
    psa_licence_class_status_values(StatusValues),
    member(no_licence_required, StatusValues),
    member(exempt_payment_service_provider, StatusValues),
    member(money_changing_licence, StatusValues),
    member(standard_payment_institution_licence, StatusValues),
    member(major_payment_institution_licence, StatusValues),
    member(indeterminate, StatusValues).
test(what_if_override_exempt_to_true) :-
    psa_licence_class_profile_for(no_services_near_miss, Profile),
    psa_licence_class_what_if(Profile, exempt_payment_service_provider, true, exempt_payment_service_provider).
test(what_if_override_exempt_to_false) :-
    psa_licence_class_profile_for(exempt_basic, Profile),
    psa_licence_class_what_if(Profile, exempt_payment_service_provider, false, standard_payment_institution_licence).
test(threshold_single_service) :-
    psa_licence_class_threshold(single_service_volume, 300000001, sg_psa_2019_s6_5_a_ii_a).
test(threshold_multi_service) :-
    psa_licence_class_threshold(multi_service_volume, 600000001, sg_psa_2019_s6_5_a_ii_b).
test(threshold_e_money_float) :-
    psa_licence_class_threshold(e_money_account_float, 500000001, sg_psa_2019_s6_5_b).
test(threshold_e_money_issued) :-
    psa_licence_class_threshold(e_money_issued, 500000001, sg_psa_2019_s6_5_c).
test(profile_keys_complete) :-
    psa_licence_class_profile_keys(Keys),
    member(services, Keys),
    member(exempt_payment_service_provider, Keys),
    member(monthly_average_volumes, Keys),
    member(resident_e_money_float_cents, Keys),
    member(singapore_issued_other_e_money_float_cents, Keys),
    member(specified_e_money_issued_cents, Keys).

test(no_services_is_not_mpi, fail) :-
    psa_licence_class_assess(no_services, psa_licence(major_payment_institution_licence, _, _, _)).
test(exempt_basic_is_not_spi, fail) :-
    psa_licence_class_assess(exempt_basic, psa_licence(standard_payment_institution_licence, _, _, _)).
test(money_changing_only_is_not_spi, fail) :-
    psa_licence_class_assess(money_changing_only, psa_licence(standard_payment_institution_licence, _, _, _)).
test(single_volume_at_threshold_is_not_mpi, fail) :-
    psa_licence_class_assess(single_volume_at_threshold, psa_licence(major_payment_institution_licence, _, _, _)).
test(multi_volume_at_threshold_is_not_mpi, fail) :-
    psa_licence_class_assess(multi_volume_at_threshold, psa_licence(major_payment_institution_licence, _, _, _)).
test(e_money_float_at_threshold_is_not_mpi, fail) :-
    psa_licence_class_assess(e_money_float_at_threshold, psa_licence(major_payment_institution_licence, _, _, _)).
test(e_money_issued_at_threshold_is_not_mpi, fail) :-
    psa_licence_class_assess(e_money_issued_at_threshold, psa_licence(major_payment_institution_licence, _, _, _)).

cp_test_names([no_services_is_no_licence_required, no_services_near_miss_is_spi, exempt_basic_is_exempt, exempt_near_miss_is_spi, money_changing_only_is_money_changing_licence, money_changing_near_miss_is_spi, single_volume_mpi_is_mpi, single_volume_at_threshold_is_spi, multi_volume_mpi_is_mpi, multi_volume_at_threshold_is_spi, e_money_float_mpi_is_mpi, e_money_float_at_threshold_is_spi, e_money_issued_mpi_is_mpi, e_money_issued_at_threshold_is_spi, indeterminate_missing_services, indeterminate_missing_exempt, status_determination_no_services, status_determination_mpi, status_determination_spi, status_determination_indeterminate, checklist_non_empty_spi, checklist_non_empty_mpi, checklist_non_empty_indeterminate, decision_resolvable_on_spi, decision_resolvable_on_indeterminate, status_values_complete, what_if_override_exempt_to_true, what_if_override_exempt_to_false, threshold_single_service, threshold_multi_service, threshold_e_money_float, threshold_e_money_issued, profile_keys_complete]).
cp_test_fail_names([no_services_is_not_mpi, exempt_basic_is_not_spi, money_changing_only_is_not_spi, single_volume_at_threshold_is_not_mpi, multi_volume_at_threshold_is_not_mpi, e_money_float_at_threshold_is_not_mpi, e_money_issued_at_threshold_is_not_mpi]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
