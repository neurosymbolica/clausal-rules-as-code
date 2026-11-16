% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_status/2, child_consent_outside_facts/2, decide_child_consent_status/2, child_consent_status_status/2, child_consent_status_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_parental_verification, [parental_verification/2, decide_parental_verification/2, parental_verification_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_fixtures, [gdpr_child_consent_age_fields_profile_for/2]).

referral(Pairs, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_8_1_second_subpara), cite(member_state_digital_consent_age_law)), [resolution(cite(member_state_digital_consent_age_law), not_attempted), inputs_relied_on(Pairs)])).

expected(not_engaged_not_directed, eligible, not_applicable).
expected(age_16_own_consent, eligible, not_applicable).
expected(age_15_national_16, ineligible, not_applicable).
expected(age_15_national_15, eligible, not_applicable).
expected(age_14_national_15, ineligible, not_applicable).
expected(age_13_national_13, eligible, not_applicable).
expected(age_12_parent_given, eligible, efforts_reasonable).
expected(age_12_no_parent, ineligible, not_applicable).
expected(age_14_national_absent, Status, not_reached) :-
    referral([child_age_years - 14, parental_consent_given - false, member_state - austria, member_state_selection_test - controller_establishment, consent_date - date(2026, 5, 1)], Status).
expected(age_14_other_state_fact, Status, not_reached) :-
    referral([child_age_years - 14, parental_consent_given - false, member_state - austria, member_state_selection_test - controller_establishment, consent_date - date(2026, 5, 1)], Status).
expected(service_unsure, needs_legal_review(open_textured(information_society_service, cite(eu_reg_2016_679_art_4_25)), [inputs_relied_on([processing_rests_on_consent - true, information_society_service - unsure, offered_directly_to_child - true])]), not_reached).
expected(age_missing, indeterminate([child_age_years]), not_reached).
expected(invalid_age, input_problems([wrong_type(child_age_years)]), not_reached).
expected(parent_given_efforts_not_reasonable, eligible, efforts_not_reasonable).
expected(parent_given_efforts_unsure, eligible, needs_legal_review(open_textured(verification_efforts_reasonable, cite(eu_reg_2016_679_art_8_2)), [inputs_relied_on([verification_efforts_reasonable - unsure])])).
expected(age_14_member_state_missing, indeterminate([member_state]), not_reached).

answers_once(Subject) :-
    expected(Subject, ExpectedStatus, ExpectedVerification),
    gdpr_child_consent_age_fields_profile_for(Subject, Profile),
    findall(Status, child_consent_status(Profile, Status), Statuses),
    Statuses == [ExpectedStatus],
    findall(Verification, parental_verification(Profile, Verification), Verifications),
    Verifications == [ExpectedVerification].

test(not_engaged_answers_once) :-
    answers_once(not_engaged_not_directed).
test(age_16_answers_once) :-
    answers_once(age_16_own_consent).
test(age_15_national_16_answers_once) :-
    answers_once(age_15_national_16).
test(age_15_national_15_answers_once) :-
    answers_once(age_15_national_15).
test(age_14_national_15_answers_once) :-
    answers_once(age_14_national_15).
test(age_13_national_13_answers_once) :-
    answers_once(age_13_national_13).
test(age_12_parent_given_answers_once) :-
    answers_once(age_12_parent_given).
test(age_12_no_parent_answers_once) :-
    answers_once(age_12_no_parent).
test(age_14_national_absent_answers_once) :-
    answers_once(age_14_national_absent).
test(age_14_other_state_fact_answers_once) :-
    answers_once(age_14_other_state_fact).
test(service_unsure_answers_once) :-
    answers_once(service_unsure).
test(age_missing_answers_once) :-
    answers_once(age_missing).
test(invalid_age_answers_once) :-
    answers_once(invalid_age).
test(efforts_not_reasonable_answers_once) :-
    answers_once(parent_given_efforts_not_reasonable).
test(efforts_unsure_answers_once) :-
    answers_once(parent_given_efforts_unsure).
test(member_state_missing_answers_once) :-
    answers_once(age_14_member_state_missing).
test(age_16_verdict_cites_art_8_1) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    decide_child_consent_status(Profile, child_consent_status_verdict(eligible, [cite(eu_reg_2016_679_art_8_1)])).
test(below_13_verdict_cites_second_subparagraph) :-
    gdpr_child_consent_age_fields_profile_for(age_12_no_parent, Profile),
    decide_child_consent_status(Profile, child_consent_status_verdict(ineligible, [cite(eu_reg_2016_679_art_8_1_second_subpara)])).
test(national_age_verdict_cites_second_subparagraph) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_15, Profile),
    decide_child_consent_status(Profile, child_consent_status_verdict(eligible, [cite(eu_reg_2016_679_art_8_1_second_subpara)])).
test(verification_verdict_cites_art_8_2) :-
    gdpr_child_consent_age_fields_profile_for(age_12_parent_given, Profile),
    decide_parental_verification(Profile, parental_verification_verdict(efforts_reasonable, [cite(eu_reg_2016_679_art_8_2)])).
test(the_verification_checklist_has_one_cited_row) :-
    gdpr_child_consent_age_fields_profile_for(age_12_parent_given, Profile),
    parental_verification_checklist(Profile, [item(verification_efforts, met, cite(eu_reg_2016_679_art_8_2))]).
test(the_status_checklist_for_a_16_year_old) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    child_consent_status_checklist(Profile, [item(engagement, met, cite(eu_reg_2016_679_art_8_1)), item(age_at_least_16, met, cite(eu_reg_2016_679_art_8_1)), item(parental_consent, not_reached, cite(eu_reg_2016_679_art_8_1)), item(national_age_reached, not_reached, cite(eu_reg_2016_679_art_8_1_second_subpara))]).
test(an_attested_age_is_recorded_as_given) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    findall(Facts, child_consent_outside_facts(Profile, Facts), FactLists),
    FactLists = [[outside_fact(member_state_digital_consent_age, attested(national_digital_consent_age(germany, 16, _Provision), _Attestation))]].
test(an_absent_age_is_recorded_as_absent) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_absent, Profile),
    findall(Facts, child_consent_outside_facts(Profile, Facts), FactLists),
    FactLists == [[outside_fact(member_state_digital_consent_age, absent)]].
test(the_record_does_not_depend_on_status) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    child_consent_outside_facts(Profile, [outside_fact(member_state_digital_consent_age, absent)]).
test(the_status_projection_is_answered_once) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    findall(Status, child_consent_status_status(Profile, Status), Statuses),
    Statuses == [eligible].

cp_test_names([not_engaged_answers_once, age_16_answers_once, age_15_national_16_answers_once, age_15_national_15_answers_once, age_14_national_15_answers_once, age_13_national_13_answers_once, age_12_parent_given_answers_once, age_12_no_parent_answers_once, age_14_national_absent_answers_once, age_14_other_state_fact_answers_once, service_unsure_answers_once, age_missing_answers_once, invalid_age_answers_once, efforts_not_reasonable_answers_once, efforts_unsure_answers_once, member_state_missing_answers_once, age_16_verdict_cites_art_8_1, below_13_verdict_cites_second_subparagraph, national_age_verdict_cites_second_subparagraph, verification_verdict_cites_art_8_2, the_verification_checklist_has_one_cited_row, the_status_checklist_for_a_16_year_old, an_attested_age_is_recorded_as_given, an_absent_age_is_recorded_as_absent, the_record_does_not_depend_on_status, the_status_projection_is_answered_once]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
