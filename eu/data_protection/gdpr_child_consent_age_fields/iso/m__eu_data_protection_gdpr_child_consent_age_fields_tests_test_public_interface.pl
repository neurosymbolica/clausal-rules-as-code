% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_status/2, child_consent_outside_facts/2, decide_child_consent_status/2, child_consent_status_checklist/2, child_consent_status_decision_resolvable/1, child_consent_status_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_parental_verification, [parental_verification/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_kernel, [gdpr_child_consent_age_fields_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_queries, [gdpr_child_consent_age_fields_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_fixtures, [gdpr_child_consent_age_fields_subject/1, gdpr_child_consent_age_fields_profile_for/2, gdpr_child_consent_age_fields_assess/2]).

test(not_engaged_is_eligible) :-
    gdpr_child_consent_age_fields_profile_for(not_engaged_not_directed, Profile),
    child_consent_status(Profile, eligible).
test(age_16_is_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    child_consent_status(Profile, eligible).
test(age_15_with_national_16_is_ineligible) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    child_consent_status(Profile, ineligible).
test(age_15_with_national_15_is_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_15, Profile),
    child_consent_status(Profile, eligible).
test(age_14_with_national_15_is_ineligible) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_15, Profile),
    child_consent_status(Profile, ineligible).
test(age_13_with_national_13_is_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_13_national_13, Profile),
    child_consent_status(Profile, eligible).
test(age_12_with_parent_is_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_12_parent_given, Profile),
    child_consent_status(Profile, eligible).
test(age_12_without_parent_is_ineligible) :-
    gdpr_child_consent_age_fields_profile_for(age_12_no_parent, Profile),
    child_consent_status(Profile, ineligible).
test(an_absent_national_age_refers) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_absent, Profile),
    child_consent_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_8_1_second_subpara), cite(member_state_digital_consent_age_law)), [resolution(cite(member_state_digital_consent_age_law), not_attempted), inputs_relied_on(Pairs)])),
    Pairs == [child_age_years - 14, parental_consent_given - false, member_state - austria, member_state_selection_test - controller_establishment, consent_date - date(2026, 5, 1)].
test(another_states_age_refers) :-
    gdpr_child_consent_age_fields_profile_for(age_14_other_state_fact, Profile),
    child_consent_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_8_1_second_subpara), cite(member_state_digital_consent_age_law)), _Context)).
test(an_unsure_service_refers) :-
    gdpr_child_consent_age_fields_profile_for(service_unsure, Profile),
    child_consent_status(Profile, needs_legal_review(open_textured(information_society_service, cite(eu_reg_2016_679_art_4_25)), [inputs_relied_on(Pairs)])),
    Pairs == [processing_rests_on_consent - true, information_society_service - unsure, offered_directly_to_child - true].
test(a_missing_age_is_indeterminate) :-
    gdpr_child_consent_age_fields_profile_for(age_missing, Profile),
    child_consent_status(Profile, indeterminate([child_age_years])).
test(a_missing_member_state_is_indeterminate) :-
    gdpr_child_consent_age_fields_profile_for(age_14_member_state_missing, Profile),
    child_consent_status(Profile, indeterminate([member_state])).
test(an_invalid_age_is_an_input_problem) :-
    gdpr_child_consent_age_fields_profile_for(invalid_age, Profile),
    child_consent_status(Profile, input_problems([wrong_type(child_age_years)])),
    gdpr_child_consent_age_fields_input_problems(Profile, [wrong_type(child_age_years)]).
test(the_status_is_answered_once) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_15, Profile),
    findall(Status, child_consent_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(the_verdict_carries_a_citation) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    decide_child_consent_status(Profile, child_consent_status_verdict(eligible, [cite(eu_reg_2016_679_art_8_1)])).
test(the_checklist_is_not_empty) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    child_consent_status_checklist(Profile, [item(engagement, met, cite(eu_reg_2016_679_art_8_1))|_OtherItems]).
test(the_decision_is_resolvable) :-
    gdpr_child_consent_age_fields_profile_for(age_12_no_parent, Profile),
    child_consent_status_decision_resolvable(Profile).
test(the_status_values_are_pinned) :-
    child_consent_status_status_values([eligible, ineligible]).
test(the_wrapper_resolves_a_subject) :-
    gdpr_child_consent_age_fields_subject(Subject),
    gdpr_child_consent_age_fields_assess(Subject, child_consent_status_verdict(_Status, _Citations)).
test(reasonable_efforts) :-
    gdpr_child_consent_age_fields_profile_for(age_12_parent_given, Profile),
    parental_verification(Profile, efforts_reasonable).
test(unreasonable_efforts_leave_the_status_eligible) :-
    gdpr_child_consent_age_fields_profile_for(parent_given_efforts_not_reasonable, Profile),
    parental_verification(Profile, efforts_not_reasonable),
    child_consent_status(Profile, eligible).
test(an_unsure_effort_refers) :-
    gdpr_child_consent_age_fields_profile_for(parent_given_efforts_unsure, Profile),
    parental_verification(Profile, needs_legal_review(open_textured(verification_efforts_reasonable, cite(eu_reg_2016_679_art_8_2)), [inputs_relied_on([verification_efforts_reasonable - unsure])])).
test(age_16_needs_no_verification) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    parental_verification(Profile, not_applicable).
test(not_engaged_needs_no_verification) :-
    gdpr_child_consent_age_fields_profile_for(not_engaged_not_directed, Profile),
    parental_verification(Profile, not_applicable).
test(an_ineligible_processing_needs_no_verification) :-
    gdpr_child_consent_age_fields_profile_for(age_12_no_parent, Profile),
    parental_verification(Profile, not_applicable).
test(a_non_final_status_is_not_reached) :-
    gdpr_child_consent_age_fields_profile_for(age_missing, Profile),
    parental_verification(Profile, not_reached).
test(an_input_problem_is_not_reached) :-
    gdpr_child_consent_age_fields_profile_for(invalid_age, Profile),
    parental_verification(Profile, not_reached).
test(an_absent_national_age_is_recorded_as_absent) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_absent, Profile),
    child_consent_outside_facts(Profile, [outside_fact(member_state_digital_consent_age, absent)]).
test(an_attested_national_age_is_recorded_as_given) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_15, Profile),
    child_consent_outside_facts(Profile, [outside_fact(member_state_digital_consent_age, attested(national_digital_consent_age(france, 15, _Provision), _Attestation))]).
test(an_input_problem_is_recorded_in_the_outside_facts) :-
    gdpr_child_consent_age_fields_profile_for(invalid_age, Profile),
    child_consent_outside_facts(Profile, input_problems([wrong_type(child_age_years)])).
test(raising_the_age_to_the_national_age_flips_to_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_15, Profile),
    gdpr_child_consent_age_fields_what_if(Profile, child_age_years, 15, eligible).
test(the_original_age_stays_ineligible) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_15, Profile),
    gdpr_child_consent_age_fields_what_if(Profile, child_age_years, 14, ineligible).

test(age_15_with_national_16_is_not_eligible, fail) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    child_consent_status(Profile, eligible).
test(age_14_with_national_15_is_not_eligible, fail) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_15, Profile),
    child_consent_status(Profile, eligible).
test(age_12_without_parent_is_not_eligible, fail) :-
    gdpr_child_consent_age_fields_profile_for(age_12_no_parent, Profile),
    child_consent_status(Profile, eligible).
test(unreasonable_efforts_are_not_reasonable_efforts, fail) :-
    gdpr_child_consent_age_fields_profile_for(parent_given_efforts_not_reasonable, Profile),
    parental_verification(Profile, efforts_reasonable).

cp_test_names([not_engaged_is_eligible, age_16_is_eligible, age_15_with_national_16_is_ineligible, age_15_with_national_15_is_eligible, age_14_with_national_15_is_ineligible, age_13_with_national_13_is_eligible, age_12_with_parent_is_eligible, age_12_without_parent_is_ineligible, an_absent_national_age_refers, another_states_age_refers, an_unsure_service_refers, a_missing_age_is_indeterminate, a_missing_member_state_is_indeterminate, an_invalid_age_is_an_input_problem, the_status_is_answered_once, the_verdict_carries_a_citation, the_checklist_is_not_empty, the_decision_is_resolvable, the_status_values_are_pinned, the_wrapper_resolves_a_subject, reasonable_efforts, unreasonable_efforts_leave_the_status_eligible, an_unsure_effort_refers, age_16_needs_no_verification, not_engaged_needs_no_verification, an_ineligible_processing_needs_no_verification, a_non_final_status_is_not_reached, an_input_problem_is_not_reached, an_absent_national_age_is_recorded_as_absent, an_attested_national_age_is_recorded_as_given, an_input_problem_is_recorded_in_the_outside_facts, raising_the_age_to_the_national_age_flips_to_eligible, the_original_age_stays_ineligible]).
cp_test_fail_names([age_15_with_national_16_is_not_eligible, age_14_with_national_15_is_not_eligible, age_12_without_parent_is_not_eligible, unreasonable_efforts_are_not_reasonable_efforts]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
