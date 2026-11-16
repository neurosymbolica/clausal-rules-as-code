% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [decide_information_deadline_basis/2, information_deadline/2, information_deadline_basis/2, information_deadline_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [information_timing_verdict/3, information_timing_verdict_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_subject/1, gdpr_information_duties_timing_profile_for/2]).

expected_verdict(art13_provided_on_obtaining_day, timely, [cite(eu_reg_2016_679_art_13_1)]).
expected_verdict(art13_provided_day_after_obtaining, late, [cite(eu_reg_2016_679_art_13_1)]).
expected_verdict(art14_one_month_last_day, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_one_month_day_after, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_leap_day_last_day, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_leap_day_day_after, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_holiday_shift_last_day, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_holiday_shift_day_after, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_tie_with_communication_last_day, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_first_communication_on_day, timely, [cite(eu_reg_2016_679_art_14_3_b)]).
expected_verdict(art14_first_communication_day_after, late, [cite(eu_reg_2016_679_art_14_3_b)]).
expected_verdict(art14_first_disclosure_on_day, timely, [cite(eu_reg_2016_679_art_14_3_c)]).
expected_verdict(art14_first_disclosure_day_after, late, [cite(eu_reg_2016_679_art_14_3_c)]).
expected_verdict(art14_reasonable_period_unsure, needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure]), provenance(reasonable_period_for_art14_information, [cite(eu_reg_2016_679_art_14_3_a)])]), []).
expected_verdict(art14_reasonable_period_false, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_reasonable_period_absent, indeterminate([provided_within_reasonable_period]), []).
expected_verdict(route_unknown, indeterminate([personal_data_collected_from_data_subject, obtaining_date, provision_date]), []).
expected_verdict(crisp_flag_given_unsure, input_problems([wrong_type(personal_data_collected_from_data_subject)]), []).

expected_deadline(art13_provided_on_obtaining_day, date(2026, 3, 10), art13_1).
expected_deadline(art13_provided_day_after_obtaining, date(2026, 3, 10), art13_1).
expected_deadline(art14_one_month_last_day, date(2026, 2, 16), art14_3_a).
expected_deadline(art14_one_month_day_after, date(2026, 2, 16), art14_3_a).
expected_deadline(art14_leap_day_last_day, date(2028, 2, 29), art14_3_a).
expected_deadline(art14_leap_day_day_after, date(2028, 2, 29), art14_3_a).
expected_deadline(art14_holiday_shift_last_day, date(2027, 2, 2), art14_3_a).
expected_deadline(art14_holiday_shift_day_after, date(2027, 2, 2), art14_3_a).
expected_deadline(art14_tie_with_communication_last_day, date(2026, 2, 16), art14_3_a).
expected_deadline(art14_first_communication_on_day, date(2026, 1, 20), art14_3_b).
expected_deadline(art14_first_communication_day_after, date(2026, 1, 20), art14_3_b).
expected_deadline(art14_first_disclosure_on_day, date(2026, 1, 30), art14_3_c).
expected_deadline(art14_first_disclosure_day_after, date(2026, 1, 30), art14_3_c).
expected_deadline(art14_reasonable_period_unsure, date(2026, 2, 16), art14_3_a).
expected_deadline(art14_reasonable_period_false, date(2026, 2, 16), art14_3_a).
expected_deadline(art14_reasonable_period_absent, date(2026, 2, 16), art14_3_a).
expected_deadline(route_unknown, indeterminate([personal_data_collected_from_data_subject, obtaining_date]), indeterminate([personal_data_collected_from_data_subject, obtaining_date])).
expected_deadline(crisp_flag_given_unsure, input_problems([wrong_type(personal_data_collected_from_data_subject)]), input_problems([wrong_type(personal_data_collected_from_data_subject)])).

subject_yields_expected_verdict(Subject) :-
    expected_verdict(Subject, Verdict, Citations),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(Answer - AnswerCitations, information_timing_verdict(Profile, Answer, AnswerCitations), Answers),
    Answers == [Verdict - Citations].

subject_yields_expected_deadline(Subject) :-
    expected_deadline(Subject, Deadline, Basis),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(AnswerDeadline, information_deadline(Profile, AnswerDeadline), Deadlines),
    Deadlines == [Deadline],
    findall(AnswerBasis, information_deadline_basis(Profile, AnswerBasis), Bases),
    Bases == [Basis].

test(every_subject_yields_exactly_its_expected_verdict) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    findall(Subject, (gdpr_information_duties_timing_subject(Subject), subject_yields_expected_verdict(Subject)), MatchingSubjects),
    MatchingSubjects == Subjects.
test(every_subject_yields_exactly_its_expected_deadline_and_basis) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    findall(Subject, (gdpr_information_duties_timing_subject(Subject), subject_yields_expected_deadline(Subject)), MatchingSubjects),
    MatchingSubjects == Subjects.
test(the_tie_reads_out_limb_a_once) :-
    gdpr_information_duties_timing_profile_for(art14_tie_with_communication_last_day, Profile),
    findall(Basis, information_deadline_basis(Profile, Basis), Bases),
    Bases == [art14_3_a].
test(the_basis_verdict_reads_out_its_citation) :-
    gdpr_information_duties_timing_profile_for(art14_first_disclosure_on_day, Profile),
    findall(Verdict, decide_information_deadline_basis(Profile, Verdict), Verdicts),
    Verdicts == [information_deadline_basis_verdict(art14_3_c, [cite(eu_reg_2016_679_art_14_3_c)])].
test(a_non_final_basis_reads_out_no_citation) :-
    gdpr_information_duties_timing_profile_for(route_unknown, Profile),
    decide_information_deadline_basis(Profile, information_deadline_basis_verdict(_Status, Citations)),
    Citations == [].
test(the_verdict_vocabulary_enumerates) :-
    information_timing_verdict_status_values(TimingValues),
    TimingValues == [timely, late],
    information_deadline_basis_status_values(BasisValues),
    BasisValues == [art13_1, art14_3_a, art14_3_b, art14_3_c].

cp_test_names([every_subject_yields_exactly_its_expected_verdict, every_subject_yields_exactly_its_expected_deadline_and_basis, the_tie_reads_out_limb_a_once, the_basis_verdict_reads_out_its_citation, a_non_final_basis_reads_out_no_citation, the_verdict_vocabulary_enumerates]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
