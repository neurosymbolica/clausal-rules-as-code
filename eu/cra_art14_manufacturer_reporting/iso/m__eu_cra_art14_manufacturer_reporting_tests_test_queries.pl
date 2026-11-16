% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_queries, [cra_art14_manufacturer_reporting_profile_keys/1, cra_art14_manufacturer_reporting_what_if/4, severe/0, not_severe/0, on_time/0, date/3, step_due/3, late/1, indeterminate/1, needs_legal_review/2, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_fixtures, [cra_art14_manufacturer_reporting_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    cra_art14_manufacturer_reporting_profile_keys(ProfileKeys),
    ProfileKeys == [affects_protection_of_sensitive_or_important_data_or_functions, leads_to_malicious_code_in_product_or_user_systems, early_warning_without_undue_delay, notification_without_undue_delay].
test(the_re_exported_input_check_finds_no_problem_in_a_good_profile) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_input_problems(Profile, []).
test(the_re_exported_input_check_names_an_unknown_key) :-
    cra_art14_manufacturer_reporting_profile_for(unknown_extra_key, Profile),
    cra_art14_manufacturer_reporting_input_problems(Profile, [unknown_key(severity_score)]).
test(what_if_protection_true_turns_not_severe_into_severe) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    findall(Status, cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, true, Status), Statuses),
    Statuses == [severe].
test(what_if_protection_false_leaves_the_other_limb_missing) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, false, indeterminate([leads_to_malicious_code_in_product_or_user_systems])).
test(what_if_on_an_empty_profile_adds_the_key) :-
    cra_art14_manufacturer_reporting_what_if([], leads_to_malicious_code_in_product_or_user_systems, true, severe).
test(what_if_unsure_gives_a_referral) :-
    cra_art14_manufacturer_reporting_profile_for(not_severe_both_limbs_false, Profile),
    cra_art14_manufacturer_reporting_what_if(Profile, leads_to_malicious_code_in_product_or_user_systems, unsure, needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), _Context)).
test(what_if_replaces_every_duplicate_of_the_key) :-
    cra_art14_manufacturer_reporting_profile_for(duplicate_protection_key, Profile),
    findall(Status, cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, false, Status), Statuses),
    Statuses == [indeterminate([leads_to_malicious_code_in_product_or_user_systems])].
test(what_if_keeps_an_unknown_key_problem) :-
    cra_art14_manufacturer_reporting_profile_for(unknown_extra_key, Profile),
    cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, true, input_problems([unknown_key(severity_score)])).
test(what_if_on_a_non_attribute_list_keeps_the_problem) :-
    cra_art14_manufacturer_reporting_profile_for(not_an_attribute_list, Profile),
    findall(Status, cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, true, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(what_if_a_wrong_value_is_a_wrong_type) :-
    cra_art14_manufacturer_reporting_what_if([], affects_protection_of_sensitive_or_important_data_or_functions, yes, input_problems([wrong_type(affects_protection_of_sensitive_or_important_data_or_functions)])).
test(result_constructors_are_defined) :-
    severe,
    not_severe,
    on_time,
    step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)),
    late(hour_limit),
    indeterminate([notification_without_undue_delay]).
test(the_date_constructor_answers_its_ground_instance) :-
    findall(Year - Month - Day, date(Year, Month, Day), Answers),
    Answers == [2026 - 9 - 11],
    date(2026, 9, 11).
test(the_date_constructor_is_the_application_day) :-
    date(2026, 9, 11).
test(the_duplicate_key_constructor_answers_its_ground_instance) :-
    duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions).
test(the_input_problems_constructor_answers_its_ground_instance) :-
    input_problems([wrong_type(profile)]).
test(the_needs_legal_review_constructor_answers_its_ground_instance) :-
    needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_b)), [inputs_relied_on([notification_without_undue_delay - unsure])]).
test(the_provenance_constructor_answers_its_ground_instance) :-
    provenance(undue_delay_result, [cite(eu_reg_2024_2847_art_14_2_b)]).
test(the_unknown_key_constructor_answers_its_ground_instance) :-
    unknown_key(severity_score).
test(the_wrong_type_constructor_answers_its_ground_instance) :-
    wrong_type(profile).

test(what_if_false_does_not_give_severe, fail) :-
    cra_art14_manufacturer_reporting_profile_for(severe_by_protection_limb, Profile),
    cra_art14_manufacturer_reporting_what_if(Profile, affects_protection_of_sensitive_or_important_data_or_functions, false, severe).

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_finds_no_problem_in_a_good_profile, the_re_exported_input_check_names_an_unknown_key, what_if_protection_true_turns_not_severe_into_severe, what_if_protection_false_leaves_the_other_limb_missing, what_if_on_an_empty_profile_adds_the_key, what_if_unsure_gives_a_referral, what_if_replaces_every_duplicate_of_the_key, what_if_keeps_an_unknown_key_problem, what_if_on_a_non_attribute_list_keeps_the_problem, what_if_a_wrong_value_is_a_wrong_type, result_constructors_are_defined, the_date_constructor_answers_its_ground_instance, the_date_constructor_is_the_application_day, the_duplicate_key_constructor_answers_its_ground_instance, the_input_problems_constructor_answers_its_ground_instance, the_needs_legal_review_constructor_answers_its_ground_instance, the_provenance_constructor_answers_its_ground_instance, the_unknown_key_constructor_answers_its_ground_instance, the_wrong_type_constructor_answers_its_ground_instance]).
cp_test_fail_names([what_if_false_does_not_give_severe]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
