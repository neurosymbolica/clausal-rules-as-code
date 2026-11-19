% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_queries, [information_deadline/2, information_deadline_basis/2, information_timing_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [gdpr_information_duties_timing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_profile_for/2]).

test(art13_verdict_bound_timely) :-
    gdpr_information_duties_timing_profile_for(art13_on_obtaining_day, Profile),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_13_1)]).
test(art13_deadline_bound) :-
    gdpr_information_duties_timing_profile_for(art13_on_obtaining_day, Profile),
    information_deadline(Profile, date(2026, 3, 10)).
test(art13_basis_bound) :-
    gdpr_information_duties_timing_profile_for(art13_on_obtaining_day, Profile),
    information_deadline_basis(Profile, art13_1).
test(limb_a_deadline_bound_element_wise) :-
    gdpr_information_duties_timing_profile_for(art14_limb_a_last_day, Profile),
    information_deadline(Profile, date(Year, Month, Day)),
    Year =:= 2026,
    Month =:= 2,
    Day =:= 16.
test(limb_b_basis_bound) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_day, Profile),
    information_deadline_basis(Profile, art14_3_b).
test(limb_c_verdict_bound_late) :-
    gdpr_information_duties_timing_profile_for(art14_day_after_first_disclosure, Profile),
    information_timing_verdict(Profile, late, [cite(eu_reg_2016_679_art_14_3_c)]).
test(unread_keys_are_accepted_and_ignored) :-
    gdpr_information_duties_timing_profile_for(art13_with_unread_keys, Profile),
    gdpr_information_duties_timing_input_problems(Profile, []),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_13_1)]).
test(a_non_list_profile_is_refused_by_every_relation) :-
    information_deadline(profile, input_problems([wrong_type(profile)])),
    information_deadline_basis(profile, input_problems([wrong_type(profile)])),
    information_timing_verdict(profile, input_problems([wrong_type(profile)]), []).
test(unsure_on_a_crisp_key_is_wrong_type) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, unsure)], input_problems([wrong_type(personal_data_collected_from_data_subject)]), []).
test(wrong_types_come_before_unknown_keys) :-
    gdpr_information_duties_timing_input_problems([attribute(colour, blue), attribute(provision_date, date(2026, 2, 30))], Problems),
    Problems == [wrong_type(provision_date), unknown_key(colour)].
test(other_purpose_information_is_not_an_item_provided) :-
    gdpr_information_duties_timing_profile_for(items_provided_wrong_type, Profile),
    information_deadline_basis(Profile, input_problems([wrong_type(items_provided)])).
test(a_duplicated_key_is_never_also_wrong_type) :-
    gdpr_information_duties_timing_input_problems([attribute(obtaining_date, date(2026, 2, 30)), attribute(obtaining_date, nonsense)], Problems),
    Problems == [duplicate_key(obtaining_date)].
test(a_string_value_is_wrong_type) :-
    gdpr_information_duties_timing_input_problems([attribute(obtaining_date, date(2026, 1, x))], [wrong_type(obtaining_date)]).
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_information_duties_timing_input_problems([attribute(public_holidays, [date(2026, 12, 25)])], [wrong_type(public_holidays)]).
test(an_attested_holiday_list_is_accepted) :-
    gdpr_information_duties_timing_input_problems([attribute(public_holidays, attested([date(2026, 12, 25)], attestation(by, at, reason, none)))], []).

test(art13_verdict_bound_late_is_rejected, fail) :-
    gdpr_information_duties_timing_profile_for(art13_on_obtaining_day, Profile),
    information_timing_verdict(Profile, late, _).
test(art13_deadline_bound_to_the_next_day_is_rejected, fail) :-
    gdpr_information_duties_timing_profile_for(art13_on_obtaining_day, Profile),
    information_deadline(Profile, date(2026, 3, 11)).
test(art13_basis_bound_to_limb_a_is_rejected, fail) :-
    gdpr_information_duties_timing_profile_for(art13_on_obtaining_day, Profile),
    information_deadline_basis(Profile, art14_3_a).
test(limb_a_deadline_is_not_the_sunday, fail) :-
    gdpr_information_duties_timing_profile_for(art14_limb_a_last_day, Profile),
    information_deadline(Profile, date(2026, 2, 15)).
test(limb_b_basis_bound_to_limb_a_is_rejected, fail) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_day, Profile),
    information_deadline_basis(Profile, art14_3_a).
test(limb_c_late_does_not_cite_limb_a, fail) :-
    gdpr_information_duties_timing_profile_for(art14_day_after_first_disclosure, Profile),
    information_timing_verdict(Profile, late, [cite(eu_reg_2016_679_art_14_3_a)]).
test(unsure_on_a_crisp_key_is_not_a_verdict, fail) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, unsure)], timely, _).

cp_test_names([art13_verdict_bound_timely, art13_deadline_bound, art13_basis_bound, limb_a_deadline_bound_element_wise, limb_b_basis_bound, limb_c_verdict_bound_late, unread_keys_are_accepted_and_ignored, a_non_list_profile_is_refused_by_every_relation, unsure_on_a_crisp_key_is_wrong_type, wrong_types_come_before_unknown_keys, other_purpose_information_is_not_an_item_provided, a_duplicated_key_is_never_also_wrong_type, a_string_value_is_wrong_type, a_bare_outside_fact_is_wrong_type, an_attested_holiday_list_is_accepted]).
cp_test_fail_names([art13_verdict_bound_late_is_rejected, art13_deadline_bound_to_the_next_day_is_rejected, art13_basis_bound_to_limb_a_is_rejected, limb_a_deadline_is_not_the_sunday, limb_b_basis_bound_to_limb_a_is_rejected, limb_c_late_does_not_cite_limb_a, unsure_on_a_crisp_key_is_not_a_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
