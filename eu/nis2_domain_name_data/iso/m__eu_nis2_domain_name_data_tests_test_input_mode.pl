% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [nis2_domain_name_data_status/2, provider_duties/2, required_registration_data/2, publication_duty/3, access_duty/3, access_reply_timeliness/3]).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_profile_for/2, nis2_domain_name_data_hours_for/2]).

test(another_entity_holds_with_no_duty_bound) :-
    nis2_domain_name_data_profile_for(other_entity, Profile),
    provider_duties(Profile, []).
test(an_absent_provider_type_holds_with_indeterminate_bound) :-
    nis2_domain_name_data_profile_for(provider_type_absent, Profile),
    provider_duties(Profile, indeterminate([provider_type])).
test(the_first_duty_of_a_registrar_entity_is_bound) :-
    nis2_domain_name_data_profile_for(registrar_entity_profile, Profile),
    provider_duties(Profile, [duty(collect_and_maintain_accurate_and_complete_registration_data, cite(eu_dir_2022_2555_art_28_1))|_]).
test(the_telephone_key_is_bound_as_missing) :-
    nis2_domain_name_data_profile_for(point_of_contact_telephone_absent, Profile),
    required_registration_data(Profile, indeterminate([point_of_contact_telephone_number_differs_from_registrant])).
test(non_personal_data_holds_with_must_publish_bound) :-
    nis2_domain_name_data_profile_for(non_personal_data, Profile),
    publication_duty(Profile, must_publish_without_undue_delay, [cite(eu_dir_2022_2555_art_28_4)]).
test(personal_data_holds_with_no_publication_duty_bound) :-
    nis2_domain_name_data_profile_for(personal_data, Profile),
    publication_duty(Profile, no_publication_duty, [cite(eu_dir_2022_2555_art_28_4)]).
test(both_access_conditions_hold_with_must_provide_access_bound) :-
    nis2_domain_name_data_profile_for(access_both_true, Profile),
    access_duty(Profile, must_provide_access, [cite(eu_dir_2022_2555_art_28_5)]).
test(a_false_seeker_holds_with_no_duty_bound) :-
    nis2_domain_name_data_profile_for(access_seeker_false_lawful_true, Profile),
    access_duty(Profile, no_duty_to_provide_access, [cite(eu_dir_2022_2555_art_28_5)]).
test(the_seventy_two_hour_reply_holds_with_on_time_bound) :-
    nis2_domain_name_data_profile_for(reply_72_hours_on_time, Profile),
    nis2_domain_name_data_hours_for(reply_72_hours_on_time, HoursElapsed),
    access_reply_timeliness(Profile, HoursElapsed, on_time).
test(the_seventy_three_hour_reply_holds_with_hour_limit_bound) :-
    nis2_domain_name_data_profile_for(reply_73_hours_late, Profile),
    nis2_domain_name_data_hours_for(reply_73_hours_late, HoursElapsed),
    access_reply_timeliness(Profile, HoursElapsed, late(hour_limit)).
test(the_facade_holds_with_addressed_provider_bound) :-
    nis2_domain_name_data_profile_for(registry_full_profile, Profile),
    nis2_domain_name_data_status(Profile, addressed_provider).
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, nis2_domain_name_data_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_atom_profile_is_wrong_type_profile) :-
    nis2_domain_name_data_profile_for(not_attribute_list, Profile),
    provider_duties(Profile, input_problems([wrong_type(profile)])).
test(a_list_with_a_foreign_element_is_wrong_type_profile) :-
    findall(Problems, nis2_domain_name_data_input_problems([attribute(provider_type, other), provider_type], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_attribute_without_a_value_is_wrong_type_profile) :-
    nis2_domain_name_data_input_problems([attribute(provider_type, other), attribute(provider_type)], [wrong_type(profile)]).
test(an_improper_list_is_wrong_type_profile) :-
    nis2_domain_name_data_input_problems([attribute(provider_type, other)|not_a_list_tail], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type_of_its_key) :-
    findall(Problems, nis2_domain_name_data_input_problems([attribute(provider_type, _)], Problems), Answers),
    Answers == [[wrong_type(provider_type)]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    nis2_domain_name_data_profile_for(wrong_type_profile, Profile),
    nis2_domain_name_data_input_problems(Profile, [wrong_type(point_of_contact_email_address_differs_from_registrant)]).
test(a_repeated_unknown_key_is_named_once) :-
    nis2_domain_name_data_profile_for(unknown_key_profile, Profile),
    nis2_domain_name_data_input_problems(Profile, [unknown_key(colour)]).
test(contract_problems_come_before_unknown_keys) :-
    findall(Problems, nis2_domain_name_data_input_problems([attribute(colour, blue), attribute(reply_without_undue_delay, maybe), attribute(provider_type, other), attribute(provider_type, tld_name_registry)], Problems), Answers),
    Answers == [[duplicate_key(provider_type), wrong_type(reply_without_undue_delay), unknown_key(colour)]].
test(a_duplicate_key_is_never_also_wrong_type) :-
    nis2_domain_name_data_input_problems([attribute(registration_data_is_personal_data, maybe), attribute(registration_data_is_personal_data, perhaps)], [duplicate_key(registration_data_is_personal_data)]).
test(an_absent_key_is_not_a_problem) :-
    nis2_domain_name_data_input_problems([], []).
test(an_input_problem_is_answered_by_every_query) :-
    nis2_domain_name_data_profile_for(duplicate_key_profile, Profile),
    required_registration_data(Profile, input_problems([duplicate_key(provider_type)])),
    publication_duty(Profile, input_problems([duplicate_key(provider_type)]), []),
    access_duty(Profile, input_problems([duplicate_key(provider_type)]), []),
    access_reply_timeliness(Profile, 10, input_problems([duplicate_key(provider_type)])).
test(an_unbound_hour_count_is_wrong_type) :-
    findall(Result, access_reply_timeliness([], _, Result), Answers),
    Answers == [input_problems([wrong_type(hours_elapsed)])].
test(an_atom_hour_count_is_wrong_type) :-
    access_reply_timeliness([], seventy_two, input_problems([wrong_type(hours_elapsed)])).
test(a_bad_profile_and_a_negative_hour_count_are_both_named) :-
    findall(Result, access_reply_timeliness(not_a_profile, -3, Result), Answers),
    Answers == [input_problems([wrong_type(profile), wrong_type(hours_elapsed)])].
test(profile_problems_come_before_the_hour_problem) :-
    access_reply_timeliness([attribute(colour, blue)], -1, input_problems([unknown_key(colour), wrong_type(hours_elapsed)])).

cp_test_names([another_entity_holds_with_no_duty_bound, an_absent_provider_type_holds_with_indeterminate_bound, the_first_duty_of_a_registrar_entity_is_bound, the_telephone_key_is_bound_as_missing, non_personal_data_holds_with_must_publish_bound, personal_data_holds_with_no_publication_duty_bound, both_access_conditions_hold_with_must_provide_access_bound, a_false_seeker_holds_with_no_duty_bound, the_seventy_two_hour_reply_holds_with_on_time_bound, the_seventy_three_hour_reply_holds_with_hour_limit_bound, the_facade_holds_with_addressed_provider_bound, an_unbound_profile_is_wrong_type_profile, an_atom_profile_is_wrong_type_profile, a_list_with_a_foreign_element_is_wrong_type_profile, an_attribute_without_a_value_is_wrong_type_profile, an_improper_list_is_wrong_type_profile, an_unbound_value_is_wrong_type_of_its_key, a_crisp_key_given_unsure_is_wrong_type, a_repeated_unknown_key_is_named_once, contract_problems_come_before_unknown_keys, a_duplicate_key_is_never_also_wrong_type, an_absent_key_is_not_a_problem, an_input_problem_is_answered_by_every_query, an_unbound_hour_count_is_wrong_type, an_atom_hour_count_is_wrong_type, a_bad_profile_and_a_negative_hour_count_are_both_named, profile_problems_come_before_the_hour_problem]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
