% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_verdict_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_child_consent_ground, [decide_child_consent/2, child_consent_ground_status/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_fixtures, [gdpr_child_consent_age_verdict_profile_for/2]).

test(the_sixteen_year_old_yields_exactly_one_status) :-
    gdpr_child_consent_age_verdict_profile_for(adult_at_sixteen, Profile),
    findall(Status, child_consent_ground_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(not_engaged_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(consent_not_the_basis, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(eligible, art8_not_engaged, not_applicable, [cite(eu_reg_2016_679_art_8_1)])].
test(service_key_missing_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(service_key_missing, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(indeterminate([information_society_service]), none, not_reached, [cite(eu_reg_2016_679_art_8_1)])].
test(service_judgement_unsure_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(service_judgement_unsure, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(needs_legal_review(open_textured(information_society_service, cite(eu_reg_2016_679_art_4_25)), [inputs_relied_on([processing_rests_on_consent - true, information_society_service - unsure, offered_directly_to_child - true])]), none, not_reached, [cite(eu_reg_2016_679_art_4_25)])].
test(no_age_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(no_age_given, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(indeterminate([child_age_years]), none, not_reached, [cite(eu_reg_2016_679_art_8_1)])].
test(fifteen_without_parental_answer_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(fifteen_without_parental_answer, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(indeterminate([parental_consent_given]), none, not_reached, [cite(eu_reg_2016_679_art_8_1)])].
test(national_age_not_shown_refers) :-
    gdpr_child_consent_age_verdict_profile_for(fifteen_national_age_not_shown, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_8_1_second_subpara), cite(member_state_digital_consent_age_law)), [resolution(cite(member_state_digital_consent_age_law), not_attempted), inputs_relied_on([child_age_years - 15, parental_consent_given - false, member_state - austria, member_state_selection_test - controller_establishment, consent_date - date(2026, 10, 1)])]), none, not_reached, [cite(eu_reg_2016_679_art_8_1_second_subpara), cite(member_state_digital_consent_age_law)])].
test(national_age_of_another_state_refers) :-
    gdpr_child_consent_age_verdict_profile_for(fourteen_national_age_other_state, Profile),
    child_consent_ground_status(Profile, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(fourteen_at_national_age_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(fourteen_at_national_age, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(eligible, child_at_least_national_age, not_applicable, [cite(eu_reg_2016_679_art_8_1), cite(eu_reg_2016_679_art_8_1_second_subpara)])].
test(thirteen_below_national_age_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(thirteen_below_national_age, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(ineligible, parental_consent_missing_below_national_age, not_applicable, [cite(eu_reg_2016_679_art_8_1), cite(eu_reg_2016_679_art_8_1_second_subpara)])].
test(missing_consent_date_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(fourteen_missing_consent_date, Profile),
    child_consent_ground_status(Profile, indeterminate([consent_date])).
test(reasonable_verification_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_with_reasonable_verification, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(eligible, parental_consent_given, efforts_reasonable, [cite(eu_reg_2016_679_art_8_1), cite(eu_reg_2016_679_art_8_2)])].
test(unreasonable_verification_verdict_keeps_status) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_with_unreasonable_verification, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(eligible, parental_consent_given, efforts_not_reasonable, [cite(eu_reg_2016_679_art_8_1), cite(eu_reg_2016_679_art_8_2)])].
test(unsure_verification_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_with_unsure_verification, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(eligible, parental_consent_given, needs_legal_review(open_textured(verification_efforts_reasonable, cite(eu_reg_2016_679_art_8_2)), [inputs_relied_on([verification_efforts_reasonable - unsure])]), [cite(eu_reg_2016_679_art_8_1), cite(eu_reg_2016_679_art_8_2)])].
test(absent_verification_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_without_verification_answer, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(eligible, parental_consent_given, indeterminate([verification_efforts_reasonable]), [cite(eu_reg_2016_679_art_8_1), cite(eu_reg_2016_679_art_8_2)])].
test(negative_age_verdict) :-
    gdpr_child_consent_age_verdict_profile_for(negative_age, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(input_problems([wrong_type(child_age_years)]), none, not_reached, [])].

cp_test_names([the_sixteen_year_old_yields_exactly_one_status, not_engaged_verdict, service_key_missing_verdict, service_judgement_unsure_verdict, no_age_verdict, fifteen_without_parental_answer_verdict, national_age_not_shown_refers, national_age_of_another_state_refers, fourteen_at_national_age_verdict, thirteen_below_national_age_verdict, missing_consent_date_verdict, reasonable_verification_verdict, unreasonable_verification_verdict_keeps_status, unsure_verification_verdict, absent_verification_verdict, negative_age_verdict]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
