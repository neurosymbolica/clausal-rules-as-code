% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [decide_swiss_fadp_art24_breach_notification/2, swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_profile_for/2]).

test(controller_required) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    findall(Result - Citations, swiss_controller_report_to_commissioner(Profile, Result, Citations), Answers),
    Answers == [authority_notification_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]].
test(controller_not_required_without_high_risk) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_without_high_risk, Profile),
    findall(Result - Citations, swiss_controller_report_to_commissioner(Profile, Result, Citations), Answers),
    Answers == [authority_notification_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]].
test(controller_not_required_settled_by_risk) :-
    swiss_fadp_art24_breach_notification_profile_for(controller_unsure_breach_settled_by_risk, Profile),
    findall(Result - Citations, swiss_controller_report_to_commissioner(Profile, Result, Citations), Answers),
    Answers == [authority_notification_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]].
test(controller_names_missing_risk) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_only, Profile),
    findall(Result - Citations, swiss_controller_report_to_commissioner(Profile, Result, Citations), Answers),
    Answers == [indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]) - []].
test(controller_refers_unsure_breach) :-
    swiss_fadp_art24_breach_notification_profile_for(controller_unsure_breach, Profile),
    findall(Result - Citations, swiss_controller_report_to_commissioner(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - true])]) - []].
test(processor_required_for_any_breach) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_only, Profile),
    findall(Result - Citations, swiss_processor_report_to_controller(Profile, Result, Citations), Answers),
    Answers == [report_to_controller_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]].
test(processor_not_required_without_breach) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    findall(Result - Citations, swiss_processor_report_to_controller(Profile, Result, Citations), Answers),
    Answers == [report_to_controller_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]].
test(processor_names_missing_breach) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_key_true, Profile),
    findall(Result - Citations, swiss_processor_report_to_controller(Profile, Result, Citations), Answers),
    Answers == [indeterminate([breach_of_data_security]) - []].
test(information_required_when_necessary_and_no_exception) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [information_of_data_subject_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(information_may_be_restricted_on_request_with_announcement) :-
    swiss_fadp_art24_breach_notification_profile_for(information_commissioner_request_with_public_announcement, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [information_of_data_subject_may_be_restricted_deferred_or_omitted - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(information_required_on_request_without_exception) :-
    swiss_fadp_art24_breach_notification_profile_for(information_commissioner_request_without_exception, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [information_of_data_subject_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(information_not_required_when_ground_fails) :-
    swiss_fadp_art24_breach_notification_profile_for(information_ground_failed, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [information_of_data_subject_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]].
test(information_not_required_without_breach) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [information_of_data_subject_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]].
test(information_refers_unsure_exception) :-
    swiss_fadp_art24_breach_notification_profile_for(information_exception_unsure, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(information_impossible_or_requires_disproportionate_effort, cite(ch_fadp_art_24_5_b)), [inputs_relied_on([breach_of_data_security - true, information_necessary_for_protection_of_data_subject - true, article_26_ground_or_statutory_secrecy_obligation_applies - false, information_impossible_or_requires_disproportionate_effort - unsure, information_ensured_comparably_by_public_announcement - false])]) - []].
test(information_names_missing_breach_on_request) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_key_true, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [indeterminate([breach_of_data_security]) - []].
test(information_names_missing_necessity) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_only, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [indeterminate([information_necessary_for_protection_of_data_subject]) - []].
test(eu_required) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    findall(Result - Citations, eu_controller_notification_to_supervisory_authority(Profile, Result, Citations), Answers),
    Answers == [authority_notification_required - [cite(eu_reg_2016_679_art_33_1)]].
test(eu_not_required_when_unlikely) :-
    swiss_fadp_art24_breach_notification_profile_for(eu_unlikely_risk_settles_absent_breach, Profile),
    findall(Result - Citations, eu_controller_notification_to_supervisory_authority(Profile, Result, Citations), Answers),
    Answers == [authority_notification_not_required - [cite(eu_reg_2016_679_art_33_1)]].
test(eu_names_missing_breach) :-
    swiss_fadp_art24_breach_notification_profile_for(eu_not_unlikely_risk_absent_breach, Profile),
    findall(Result - Citations, eu_controller_notification_to_supervisory_authority(Profile, Result, Citations), Answers),
    Answers == [indeterminate([personal_data_breach]) - []].
test(comparison_differs_on_both_true_thresholds) :-
    swiss_fadp_art24_breach_notification_profile_for(swiss_and_eu_both_true_thresholds, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(authority_notification_required, authority_notification_not_required, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)])].
test(comparison_differs_without_high_risk) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_without_high_risk, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(authority_notification_not_required, authority_notification_required, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)])].
test(comparison_same_when_both_required) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(authority_notification_required, authority_notification_required, same, [])].
test(comparison_same_when_no_breach) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(authority_notification_not_required, authority_notification_not_required, same, [])].
test(comparison_not_comparable_copies_each_side) :-
    swiss_fadp_art24_breach_notification_profile_for(controller_unsure_breach, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - true])]), indeterminate([personal_data_breach]), not_comparable, [])].
test(comparison_with_input_problems) :-
    swiss_fadp_art24_breach_notification_profile_for(duplicate_and_unknown_keys, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(input_problems([duplicate_key(breach_of_data_security), unknown_key(colour)]), input_problems([duplicate_key(breach_of_data_security), unknown_key(colour)]), not_comparable, [])].
test(headline_verdict_carries_citations) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    findall(Verdict, decide_swiss_fadp_art24_breach_notification(Profile, Verdict), Verdicts),
    Verdicts == [swiss_fadp_art24_breach_notification_verdict(authority_notification_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)])].
test(headline_verdict_not_final_has_no_citations) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_only, Profile),
    findall(Verdict, decide_swiss_fadp_art24_breach_notification(Profile, Verdict), Verdicts),
    Verdicts == [swiss_fadp_art24_breach_notification_verdict(indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), [])].

cp_test_names([controller_required, controller_not_required_without_high_risk, controller_not_required_settled_by_risk, controller_names_missing_risk, controller_refers_unsure_breach, processor_required_for_any_breach, processor_not_required_without_breach, processor_names_missing_breach, information_required_when_necessary_and_no_exception, information_may_be_restricted_on_request_with_announcement, information_required_on_request_without_exception, information_not_required_when_ground_fails, information_not_required_without_breach, information_refers_unsure_exception, information_names_missing_breach_on_request, information_names_missing_necessity, eu_required, eu_not_required_when_unlikely, eu_names_missing_breach, comparison_differs_on_both_true_thresholds, comparison_differs_without_high_risk, comparison_same_when_both_required, comparison_same_when_no_breach, comparison_not_comparable_copies_each_side, comparison_with_input_problems, headline_verdict_carries_citations, headline_verdict_not_final_has_no_citations]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
