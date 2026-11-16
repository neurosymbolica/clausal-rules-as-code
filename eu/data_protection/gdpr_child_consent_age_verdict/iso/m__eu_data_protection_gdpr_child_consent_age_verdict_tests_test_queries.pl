% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_verdict_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_queries, [gdpr_child_consent_age_verdict_profile_keys/1, gdpr_child_consent_age_verdict_what_if/4, gdpr_child_consent_age_verdict_compliance_check/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_child_consent_ground, [child_consent_ground_status/2, child_consent_ground_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_fixtures, [gdpr_child_consent_age_verdict_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_child_consent_age_verdict_profile_keys(ProfileKeys),
    ProfileKeys == [processing_rests_on_consent, information_society_service, offered_directly_to_child, child_age_years, parental_consent_given, member_state, member_state_selection_test, consent_date, member_state_digital_consent_age, verification_efforts_reasonable].
test(status_determination_is_single_valued) :-
    gdpr_child_consent_age_verdict_profile_for(thirteen_below_national_age, Profile),
    findall(Status, child_consent_ground_status(Profile, Status), Statuses),
    Statuses == [ineligible].
test(what_if_an_older_child_flips_to_eligible) :-
    gdpr_child_consent_age_verdict_profile_for(thirteen_below_national_age, Profile),
    findall(NewStatus, gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, 14, NewStatus), Statuses),
    Statuses == [eligible].
test(what_if_leaves_the_original_status_unchanged_for_the_same_value) :-
    gdpr_child_consent_age_verdict_profile_for(thirteen_below_national_age, Profile),
    findall(NewStatus, gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, 13, NewStatus), Statuses),
    Statuses == [ineligible].
test(what_if_adds_a_missing_key) :-
    gdpr_child_consent_age_verdict_profile_for(fifteen_without_parental_answer, Profile),
    findall(NewStatus, gdpr_child_consent_age_verdict_what_if(Profile, parental_consent_given, true, NewStatus), Statuses),
    Statuses == [eligible].
test(what_if_a_bad_value_is_an_input_problem) :-
    gdpr_child_consent_age_verdict_profile_for(adult_at_sixteen, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, -3, input_problems([wrong_type(child_age_years)])).
test(compliance_not_barred_at_sixteen) :-
    gdpr_child_consent_age_verdict_profile_for(adult_at_sixteen, Profile),
    findall(Result, gdpr_child_consent_age_verdict_compliance_check(Profile, Result), Results),
    Results == [not_barred].
test(compliance_barred_below_thirteen_without_parent) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_without_parental_consent, Profile),
    findall(Result, gdpr_child_consent_age_verdict_compliance_check(Profile, Result), Results),
    Results == [barred].
test(compliance_undetermined_when_a_key_is_missing) :-
    gdpr_child_consent_age_verdict_profile_for(no_age_given, Profile),
    gdpr_child_consent_age_verdict_compliance_check(Profile, undetermined).
test(compliance_refers_when_the_national_age_is_not_shown) :-
    gdpr_child_consent_age_verdict_profile_for(fifteen_national_age_not_shown, Profile),
    gdpr_child_consent_age_verdict_compliance_check(Profile, refer_to_lawyer).
test(compliance_rejects_malformed_input) :-
    gdpr_child_consent_age_verdict_profile_for(negative_age, Profile),
    gdpr_child_consent_age_verdict_compliance_check(Profile, input_rejected).
test(justification_checklist_has_one_cited_item_per_requirement) :-
    gdpr_child_consent_age_verdict_profile_for(adult_at_sixteen, Profile),
    child_consent_ground_checklist(Profile, Checklist),
    length(Checklist, 5),
    Checklist = [item(art8_engaged, met, cite(eu_reg_2016_679_art_8_1)), item(child_at_least_16, met, cite(eu_reg_2016_679_art_8_1))|_].
test(justification_checklist_agrees_with_the_verdict_for_a_national_age) :-
    gdpr_child_consent_age_verdict_profile_for(thirteen_below_national_age, Profile),
    child_consent_ground_checklist(Profile, Checklist),
    member(item(child_at_least_national_age, unmet(below_national_age), cite(eu_reg_2016_679_art_8_1_second_subpara)), Checklist).
test(justification_checklist_for_input_problems_is_one_item) :-
    gdpr_child_consent_age_verdict_profile_for(negative_age, Profile),
    child_consent_ground_checklist(Profile, [item(input_check, unmet(input_problems([wrong_type(child_age_years)])), cite(eu_reg_2016_679_art_8_1))]).

test(compliance_barred_is_not_not_barred, fail) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_without_parental_consent, Profile),
    gdpr_child_consent_age_verdict_compliance_check(Profile, not_barred).

cp_test_names([profile_keys_are_the_contract_keys, status_determination_is_single_valued, what_if_an_older_child_flips_to_eligible, what_if_leaves_the_original_status_unchanged_for_the_same_value, what_if_adds_a_missing_key, what_if_a_bad_value_is_an_input_problem, compliance_not_barred_at_sixteen, compliance_barred_below_thirteen_without_parent, compliance_undetermined_when_a_key_is_missing, compliance_refers_when_the_national_age_is_not_shown, compliance_rejects_malformed_input, justification_checklist_has_one_cited_item_per_requirement, justification_checklist_agrees_with_the_verdict_for_a_national_age, justification_checklist_for_input_problems_is_one_item]).
cp_test_fail_names([compliance_barred_is_not_not_barred]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
