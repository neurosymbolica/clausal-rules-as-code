% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5, decide_swiss_fadp_art24_breach_notification/2, swiss_fadp_art24_breach_notification_status/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_subject/1, swiss_fadp_art24_breach_notification_profile_for/2]).

test(the_baseline_profile_yields_exactly_one_status) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_status(Profile, Status), Statuses),
    Statuses == [authority_notification_required].
test(the_verdict_carries_a_citation) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    decide_swiss_fadp_art24_breach_notification(Profile, swiss_fadp_art24_breach_notification_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(controller_answers_read_out) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_false_control, Profile),
    findall(Result - Citations, swiss_controller_report_to_commissioner(Profile, Result, Citations), Answers),
    Answers == [authority_notification_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]].
test(controller_names_the_missing_key_before_an_unsure_one) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_unsure_high_risk_absent, Profile),
    findall(Result - Citations, swiss_controller_report_to_commissioner(Profile, Result, Citations), Answers),
    Answers == [indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]) - []].
test(processor_referral_read_out) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_unsure_high_risk_absent, Profile),
    findall(Result - Citations, swiss_processor_report_to_controller(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure])]) - []].
test(information_required_read_out) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [information_of_data_subject_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(information_names_the_first_needed_absent_exception) :-
    swiss_fadp_art24_breach_notification_profile_for(exception_partly_open, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [indeterminate([information_ensured_comparably_by_public_announcement]) - []].
test(information_refers_the_unsure_necessity) :-
    swiss_fadp_art24_breach_notification_profile_for(necessity_unsure, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(information_necessary_for_protection_of_data_subject, cite(ch_fadp_art_24_4)), [inputs_relied_on([breach_of_data_security - true, information_necessary_for_protection_of_data_subject - unsure, commissioner_requested_information_of_data_subject - false, article_26_ground_or_statutory_secrecy_obligation_applies - false, information_impossible_or_requires_disproportionate_effort - false, information_ensured_comparably_by_public_announcement - false])]) - []].
test(eu_names_its_first_missing_key) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    findall(Result - Citations, eu_controller_notification_to_supervisory_authority(Profile, Result, Citations), Answers),
    Answers == [indeterminate([personal_data_breach]) - []].
test(comparison_copies_each_side_unchanged) :-
    swiss_fadp_art24_breach_notification_profile_for(eu_unsure, Profile),
    findall(answer(Swiss, Union, Difference, Changed), compare_swiss_eu_authority_notification(Profile, Swiss, Union, Difference, Changed), Answers),
    Answers == [answer(authority_notification_required, needs_legal_review(open_textured(personal_data_breach, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([personal_data_breach - unsure, breach_unlikely_to_result_in_risk - false])]), not_comparable, [])].
test(comparison_same_read_out) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    findall(answer(Swiss, Union, Difference, Changed), compare_swiss_eu_authority_notification(Profile, Swiss, Union, Difference, Changed), Answers),
    Answers == [answer(authority_notification_required, authority_notification_required, same, [])].
test(input_problems_read_out_bare) :-
    swiss_fadp_art24_breach_notification_profile_for(duplicate_and_unknown, Profile),
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(breach_of_data_security), wrong_type(breach_unlikely_to_result_in_risk), unknown_key(severity)]].
test(a_well_formed_profile_reads_out_no_problem) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_true_control, Profile),
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(every_subject_yields_one_status) :-
    findall(Subject, swiss_fadp_art24_breach_notification_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, one_status(Subject), SingleSubjects),
    sort(SingleSubjects, SubjectSet).

one_status(Subject) :-
    swiss_fadp_art24_breach_notification_subject(Subject),
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_status(Profile, Status), [_OneStatus]).

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, controller_answers_read_out, controller_names_the_missing_key_before_an_unsure_one, processor_referral_read_out, information_required_read_out, information_names_the_first_needed_absent_exception, information_refers_the_unsure_necessity, eu_names_its_first_missing_key, comparison_copies_each_side_unchanged, comparison_same_read_out, input_problems_read_out_bare, a_well_formed_profile_reads_out_no_problem, every_subject_yields_one_status]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
