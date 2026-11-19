% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_queries, [information_deadline/2, information_timing_verdict/3, gdpr_information_duties_timing_profile_keys/1, gdpr_information_duties_timing_what_if/4, gdpr_information_duties_timing_compliance_check/3, gdpr_information_duties_timing_obligation/2, indeterminate/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_information_duties_timing_profile_keys(ProfileKeys),
    ProfileKeys == [personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, first_communication_date, disclosure_to_another_recipient_envisaged, first_disclosure_date, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law, further_processing_for_another_purpose_intended, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing, public_holidays].
test(eligibility_verdict_with_its_citation) :-
    gdpr_information_duties_timing_profile_for(art14_day_after_first_communication, Profile),
    findall(Verdict - Citations, information_timing_verdict(Profile, Verdict, Citations), Answers),
    Answers == [late - [cite(eu_reg_2016_679_art_14_3_b)]].
test(deadline_of_the_year_end_sunday) :-
    information_deadline([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 12, 31)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(public_holidays, attested([], attestation(by, at, reason, none)))], Deadline),
    Deadline == date(2027, 2, 1).
test(what_if_the_information_came_on_the_obtaining_day) :-
    gdpr_information_duties_timing_profile_for(art13_day_after_obtaining, Profile),
    gdpr_information_duties_timing_what_if(Profile, provision_date, date(2026, 3, 10), Verdict),
    Verdict == timely.
test(what_if_the_data_were_not_collected_from_the_data_subject) :-
    gdpr_information_duties_timing_profile_for(art13_on_obtaining_day, Profile),
    findall(Verdict, gdpr_information_duties_timing_what_if(Profile, personal_data_collected_from_data_subject, false, Verdict), Verdicts),
    Verdicts == [indeterminate([data_used_for_communication_with_data_subject, disclosure_to_another_recipient_envisaged])].
test(compliance_check_allows_the_limb_a_last_day) :-
    gdpr_information_duties_timing_profile_for(art14_limb_a_last_day, Profile),
    gdpr_information_duties_timing_compliance_check(Profile, date(2026, 2, 16), timely).
test(compliance_check_refuses_the_day_after) :-
    gdpr_information_duties_timing_profile_for(art14_limb_a_last_day, Profile),
    gdpr_information_duties_timing_compliance_check(Profile, date(2026, 2, 17), late).
test(obligation_by_the_first_communication) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_day, Profile),
    findall(Obligation, gdpr_information_duties_timing_obligation(Profile, Obligation), Obligations),
    Obligations == [obligation(provide_information, by(date(2026, 1, 20)), basis(art14_3_b), consequence(late), [cite(eu_reg_2016_679_art_14_3_b)])].
test(obligation_with_holidays_absent_is_referred) :-
    gdpr_information_duties_timing_profile_for(art14_holidays_absent_on_limb_a_day, Profile),
    gdpr_information_duties_timing_obligation(Profile, Obligation),
    Obligation == needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), [resolution(cite(public_holidays_applicable_to_the_period), not_attempted), inputs_relied_on([])]).
test(obligation_with_an_input_problem) :-
    gdpr_information_duties_timing_profile_for(items_provided_wrong_type, Profile),
    gdpr_information_duties_timing_obligation(Profile, input_problems([wrong_type(items_provided)])).
test(indeterminate_recognizes_a_non_empty_key_list) :-
    indeterminate([obtaining_date]).

test(compliance_check_does_not_allow_the_day_after, fail) :-
    gdpr_information_duties_timing_profile_for(art14_limb_a_last_day, Profile),
    gdpr_information_duties_timing_compliance_check(Profile, date(2026, 2, 17), timely).
test(indeterminate_refuses_an_empty_key_list, fail) :-
    indeterminate([]).

cp_test_names([profile_keys_are_the_contract_keys, eligibility_verdict_with_its_citation, deadline_of_the_year_end_sunday, what_if_the_information_came_on_the_obtaining_day, what_if_the_data_were_not_collected_from_the_data_subject, compliance_check_allows_the_limb_a_last_day, compliance_check_refuses_the_day_after, obligation_by_the_first_communication, obligation_with_holidays_absent_is_referred, obligation_with_an_input_problem, indeterminate_recognizes_a_non_empty_key_list]).
cp_test_fail_names([compliance_check_does_not_allow_the_day_after, indeterminate_refuses_an_empty_key_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
