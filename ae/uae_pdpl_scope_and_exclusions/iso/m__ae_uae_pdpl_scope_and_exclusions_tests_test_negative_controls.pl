% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [pdpl_applies/3, pdpl_in_force/3, uae_pdpl_scope_and_exclusions_status/2, uae_pdpl_scope_and_exclusions_status_values/1]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_fixtures, [uae_pdpl_scope_and_exclusions_profile_for/2]).

status_of(Subject, Status) :-
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    pdpl_applies(Profile, Status, _).

in_force_of(Subject, Status) :-
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    pdpl_in_force(Profile, Status, _).

exclusion_subject(government_data_excluded).
exclusion_subject(governmental_entity_excluded).
exclusion_subject(security_or_judicial_authorities_excluded).
exclusion_subject(personal_purposes_excluded).
exclusion_subject(health_data_with_own_legislation_excluded).
exclusion_subject(banking_or_credit_data_with_own_legislation_excluded).
exclusion_subject(free_zone_establishment_excluded).

test(the_status_table_has_a_near_miss_atom) :-
    uae_pdpl_scope_and_exclusions_status_values(StatusValues),
    StatusValues = [_, _|_].
test(every_final_atom_used_here_is_a_table_status) :-
    uae_pdpl_scope_and_exclusions_status_values(StatusValues),
    member(applies, StatusValues),
    member(does_not_apply, StatusValues),
    member(not_in_force, StatusValues).
test(commencement_day_applies) :-
    status_of(applies_on_commencement_day, applies).
test(day_before_commencement_is_not_in_force) :-
    status_of(not_in_force_on_day_before_commencement, not_in_force).
test(not_processing_does_not_apply) :-
    status_of(not_processing_of_personal_data, does_not_apply).
test(no_way_does_not_apply) :-
    status_of(no_way_of_scope_met, does_not_apply).
test(one_way_through_a_data_subject_inside_applies) :-
    status_of(foreign_controller_with_data_subject_inside_state, applies).
test(one_way_through_a_resident_controller_applies) :-
    status_of(resident_controller_with_data_subjects_abroad, applies).
test(every_exclusion_does_not_apply) :-
    findall(Subject, (exclusion_subject(Subject), status_of(Subject, does_not_apply)), Found),
    length(Found, 7).
test(the_free_zone_exclusion_does_not_apply) :-
    status_of(free_zone_establishment_excluded, does_not_apply).
test(a_missing_day_is_indeterminate) :-
    status_of(processing_date_missing, indeterminate([processing_date])).
test(missing_way_keys_are_indeterminate) :-
    status_of(way_keys_missing, indeterminate([data_subject_resides_or_has_place_of_business_in_state])).
test(an_unsure_judgement_is_referred) :-
    status_of(processing_judgement_unsure, needs_legal_review(open_textured(activity_is_processing_of_personal_data, cite(uae_pdpl_art_1_personal_data)), _)).
test(a_missing_key_behind_an_unsure_one_is_named) :-
    status_of(government_data_unsure_with_free_zone_missing, indeterminate([free_zone_company_or_establishment_with_own_data_protection_legislation])).
test(an_impossible_day_is_an_input_problem) :-
    status_of(impossible_processing_date, input_problems([wrong_type(processing_date)])).
test(a_leap_day_applies) :-
    status_of(leap_day_processing_date, applies).
test(a_duplicate_is_named_as_duplicate) :-
    status_of(duplicate_data_subject_inside_state, input_problems([duplicate_key(data_subject_inside_state)])).
test(in_force_on_the_commencement_day) :-
    in_force_of(applies_on_commencement_day, in_force).
test(not_in_force_on_the_day_before) :-
    in_force_of(not_in_force_on_day_before_commencement, not_in_force).

test(the_baseline_profile_yields_no_other_table_status, fail) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    findall(Status, uae_pdpl_scope_and_exclusions_status(Profile, Status), [BaselineStatus]),
    uae_pdpl_scope_and_exclusions_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    uae_pdpl_scope_and_exclusions_status(Profile, Other).
test(commencement_day_is_not_not_in_force, fail) :-
    status_of(applies_on_commencement_day, not_in_force).
test(day_before_commencement_does_not_apply_wrongly, fail) :-
    status_of(not_in_force_on_day_before_commencement, applies).
test(not_processing_is_not_applies, fail) :-
    status_of(not_processing_of_personal_data, applies).
test(the_baseline_is_not_does_not_apply, fail) :-
    status_of(applies_on_commencement_day, does_not_apply).
test(no_way_is_not_applies, fail) :-
    status_of(no_way_of_scope_met, applies).
test(one_way_through_a_data_subject_inside_is_not_does_not_apply, fail) :-
    status_of(foreign_controller_with_data_subject_inside_state, does_not_apply).
test(no_exclusion_applies, fail) :-
    exclusion_subject(Subject),
    status_of(Subject, applies).
test(the_free_zone_exclusion_is_not_applies, fail) :-
    status_of(free_zone_establishment_excluded, applies).
test(the_baseline_is_not_indeterminate, fail) :-
    status_of(applies_on_commencement_day, indeterminate(_)).
test(one_true_way_is_not_indeterminate, fail) :-
    status_of(foreign_controller_with_data_subject_inside_state, indeterminate(_)).
test(the_baseline_is_not_referred, fail) :-
    status_of(applies_on_commencement_day, needs_legal_review(_, _)).
test(a_missing_key_behind_an_unsure_one_is_not_referred, fail) :-
    status_of(government_data_unsure_with_free_zone_missing, needs_legal_review(_, _)).
test(a_leap_day_is_not_an_input_problem, fail) :-
    status_of(leap_day_processing_date, input_problems(_)).
test(a_duplicate_is_never_also_wrong_type, fail) :-
    status_of(duplicate_data_subject_inside_state, input_problems([wrong_type(data_subject_inside_state)])).
test(in_force_on_the_commencement_day_is_not_not_in_force, fail) :-
    in_force_of(applies_on_commencement_day, not_in_force).
test(not_in_force_on_the_day_before_is_not_in_force, fail) :-
    in_force_of(not_in_force_on_day_before_commencement, in_force).

cp_test_names([the_status_table_has_a_near_miss_atom, every_final_atom_used_here_is_a_table_status, commencement_day_applies, day_before_commencement_is_not_in_force, not_processing_does_not_apply, no_way_does_not_apply, one_way_through_a_data_subject_inside_applies, one_way_through_a_resident_controller_applies, every_exclusion_does_not_apply, the_free_zone_exclusion_does_not_apply, a_missing_day_is_indeterminate, missing_way_keys_are_indeterminate, an_unsure_judgement_is_referred, a_missing_key_behind_an_unsure_one_is_named, an_impossible_day_is_an_input_problem, a_leap_day_applies, a_duplicate_is_named_as_duplicate, in_force_on_the_commencement_day, not_in_force_on_the_day_before]).
cp_test_fail_names([the_baseline_profile_yields_no_other_table_status, commencement_day_is_not_not_in_force, day_before_commencement_does_not_apply_wrongly, not_processing_is_not_applies, the_baseline_is_not_does_not_apply, no_way_is_not_applies, one_way_through_a_data_subject_inside_is_not_does_not_apply, no_exclusion_applies, the_free_zone_exclusion_is_not_applies, the_baseline_is_not_indeterminate, one_true_way_is_not_indeterminate, the_baseline_is_not_referred, a_missing_key_behind_an_unsure_one_is_not_referred, a_leap_day_is_not_an_input_problem, a_duplicate_is_never_also_wrong_type, in_force_on_the_commencement_day_is_not_not_in_force, not_in_force_on_the_day_before_is_not_in_force]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
