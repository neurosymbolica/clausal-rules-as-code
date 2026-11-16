% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [information_timing_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [information_deadline/2, information_deadline_basis/2, decide_information_deadline_basis/2, information_deadline_basis_status/2, information_deadline_basis_checklist/2, information_deadline_basis_decision_resolvable/1, information_deadline_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [gdpr_information_duties_timing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_subject/1, gdpr_information_duties_timing_profile_for/2, gdpr_information_duties_timing_assess/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_queries, [gdpr_information_duties_timing_what_if/4]).

test(art13_on_the_obtaining_day_is_timely) :-
    gdpr_information_duties_timing_assess(art13_provided_on_obtaining_day, information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_13_1)])).
test(art13_the_day_after_is_late) :-
    gdpr_information_duties_timing_assess(art13_provided_day_after_obtaining, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_13_1)])).
test(art13_deadline_and_basis) :-
    gdpr_information_duties_timing_profile_for(art13_provided_on_obtaining_day, Profile),
    information_deadline(Profile, date(2026, 3, 10)),
    information_deadline_basis(Profile, art13_1).
test(art14_one_month_last_day_is_timely) :-
    gdpr_information_duties_timing_assess(art14_one_month_last_day, information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_a)])).
test(art14_one_month_day_after_is_late) :-
    gdpr_information_duties_timing_assess(art14_one_month_day_after, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])).
test(art14_one_month_deadline_element_wise) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_last_day, Profile),
    information_deadline(Profile, date(DeadlineYear, DeadlineMonth, DeadlineDay)),
    DeadlineYear =:= 2026,
    DeadlineMonth =:= 2,
    DeadlineDay =:= 16.
test(art14_leap_day_last_day_is_timely) :-
    gdpr_information_duties_timing_assess(art14_leap_day_last_day, information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_a)])).
test(art14_leap_day_day_after_is_late) :-
    gdpr_information_duties_timing_assess(art14_leap_day_day_after, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])).
test(art14_leap_day_deadline) :-
    gdpr_information_duties_timing_profile_for(art14_leap_day_last_day, Profile),
    information_deadline(Profile, date(2028, 2, 29)).
test(art14_holiday_shift_last_day_is_timely) :-
    gdpr_information_duties_timing_assess(art14_holiday_shift_last_day, information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_a)])).
test(art14_holiday_shift_day_after_is_late) :-
    gdpr_information_duties_timing_assess(art14_holiday_shift_day_after, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])).
test(art14_holiday_shift_deadline) :-
    gdpr_information_duties_timing_profile_for(art14_holiday_shift_last_day, Profile),
    information_deadline(Profile, date(2027, 2, 2)).
test(art14_tie_goes_to_limb_a) :-
    gdpr_information_duties_timing_profile_for(art14_tie_with_communication_last_day, Profile),
    findall(Basis, information_deadline_basis(Profile, Basis), Bases),
    Bases == [art14_3_a].
test(art14_tie_is_timely_citing_limb_a) :-
    gdpr_information_duties_timing_assess(art14_tie_with_communication_last_day, information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_a)])).
test(art14_first_communication_on_day_is_timely) :-
    gdpr_information_duties_timing_assess(art14_first_communication_on_day, information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_b)])).
test(art14_first_communication_day_after_is_late) :-
    gdpr_information_duties_timing_assess(art14_first_communication_day_after, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_b)])).
test(art14_first_communication_basis) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_on_day, Profile),
    information_deadline_basis(Profile, art14_3_b),
    information_deadline(Profile, date(2026, 1, 20)).
test(art14_first_disclosure_on_day_is_timely) :-
    gdpr_information_duties_timing_assess(art14_first_disclosure_on_day, information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_c)])).
test(art14_first_disclosure_day_after_is_late) :-
    gdpr_information_duties_timing_assess(art14_first_disclosure_day_after, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_c)])).
test(art14_first_disclosure_basis) :-
    gdpr_information_duties_timing_profile_for(art14_first_disclosure_on_day, Profile),
    information_deadline_basis(Profile, art14_3_c).
test(art14_reasonable_period_unsure_needs_legal_review) :-
    gdpr_information_duties_timing_profile_for(art14_reasonable_period_unsure, Profile),
    information_timing_verdict(Profile, needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure])|_]), []).
test(art14_reasonable_period_unsure_carries_provenance) :-
    gdpr_information_duties_timing_profile_for(art14_reasonable_period_unsure, Profile),
    findall(Verdict - Citations, information_timing_verdict(Profile, Verdict, Citations), Answers),
    Answers == [needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure]), provenance(reasonable_period_for_art14_information, [cite(eu_reg_2016_679_art_14_3_a)])]) - []].
test(art14_reasonable_period_false_is_late) :-
    gdpr_information_duties_timing_assess(art14_reasonable_period_false, information_timing_verdict_verdict(late, [cite(eu_reg_2016_679_art_14_3_a)])).
test(art14_reasonable_period_absent_is_indeterminate) :-
    gdpr_information_duties_timing_assess(art14_reasonable_period_absent, information_timing_verdict_verdict(indeterminate([provided_within_reasonable_period]), [])).
test(route_unknown_is_indeterminate) :-
    gdpr_information_duties_timing_assess(route_unknown, information_timing_verdict_verdict(indeterminate([personal_data_collected_from_data_subject, obtaining_date, provision_date]), [])).
test(route_unknown_deadline_is_indeterminate) :-
    gdpr_information_duties_timing_profile_for(route_unknown, Profile),
    information_deadline(Profile, indeterminate([personal_data_collected_from_data_subject, obtaining_date])).
test(crisp_flag_given_unsure_is_an_input_problem) :-
    gdpr_information_duties_timing_profile_for(crisp_flag_given_unsure, Profile),
    gdpr_information_duties_timing_input_problems(Profile, [wrong_type(personal_data_collected_from_data_subject)]),
    information_timing_verdict(Profile, input_problems([wrong_type(personal_data_collected_from_data_subject)]), []),
    information_deadline(Profile, input_problems([wrong_type(personal_data_collected_from_data_subject)])),
    information_deadline_basis(Profile, input_problems([wrong_type(personal_data_collected_from_data_subject)])).
test(a_repeated_key_is_a_duplicate_key_on_every_relation) :-
    Profile = [attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(obtaining_date, date(2026, 3, 11)), attribute(provision_date, date(2026, 3, 10))],
    gdpr_information_duties_timing_input_problems(Profile, [duplicate_key(obtaining_date)]),
    findall(Verdict - Citations, information_timing_verdict(Profile, Verdict, Citations), Answers),
    Answers == [input_problems([duplicate_key(obtaining_date)]) - []],
    information_deadline(Profile, input_problems([duplicate_key(obtaining_date)])),
    information_deadline_basis(Profile, input_problems([duplicate_key(obtaining_date)])).
test(a_repeated_key_is_never_also_wrong_type) :-
    gdpr_information_duties_timing_input_problems([attribute(provision_date, not_a_date), attribute(provision_date, date(2026, 3, 10))], [duplicate_key(provision_date)]).
test(an_attested_holiday_list_with_url_evidence_shifts_the_deadline) :-
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 12, 31)), attribute(provision_date, date(2027, 2, 2)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true), attribute(public_holidays, attested([date(2027, 2, 1)], attestation(host, moment, official_journal_notice, url('https://eur-lex.europa.eu/oj/c-series', retrieved_moment))))],
    gdpr_information_duties_timing_input_problems(Profile, []),
    information_deadline(Profile, date(2027, 2, 2)),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
test(an_attested_empty_holiday_list_shifts_weekends_only) :-
    information_deadline([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 12, 31)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(public_holidays, attested([], attestation(host, moment, reason, none)))], date(2027, 2, 1)).
test(an_attested_law_fact_with_document_evidence_is_accepted_and_ignored) :-
    Profile = [attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10)), attribute(obtaining_or_disclosure_laid_down_by_law, attested(true, attestation(host, moment, statute_reading, document(upload_one, sha_value)))), attribute(professional_secrecy_obligation_by_law, attested(false, attestation(host, moment, reason, none)))],
    gdpr_information_duties_timing_input_problems(Profile, []),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_13_1)]).
test(a_law_fact_not_attested_is_wrong_type) :-
    gdpr_information_duties_timing_input_problems([attribute(obtaining_or_disclosure_laid_down_by_law, true)], [wrong_type(obtaining_or_disclosure_laid_down_by_law)]).
test(an_attested_value_outside_true_and_false_is_wrong_type) :-
    gdpr_information_duties_timing_input_problems([attribute(professional_secrecy_obligation_by_law, attested(unsure, attestation(host, moment, reason, document(upload_one, sha_value))))], [wrong_type(professional_secrecy_obligation_by_law)]).
test(an_attested_fact_without_an_attestation_is_wrong_type) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10)), attribute(public_holidays, attested([], url('https://eur-lex.europa.eu', moment)))], input_problems([wrong_type(public_holidays)]), []).
test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    findall(Subject - Result, (gdpr_information_duties_timing_subject(Subject), gdpr_information_duties_timing_assess(Subject, Result)), Answers),
    length(Subjects, SubjectCount),
    length(Answers, AnswerCount),
    SubjectCount =:= AnswerCount.
test(every_subject_has_exactly_one_deadline_and_basis) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    findall(Subject - Deadline - Basis, (gdpr_information_duties_timing_subject(Subject), gdpr_information_duties_timing_profile_for(Subject, Profile), information_deadline(Profile, Deadline), information_deadline_basis(Profile, Basis)), Answers),
    length(Subjects, SubjectCount),
    length(Answers, AnswerCount),
    SubjectCount =:= AnswerCount.
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    findall(Subject, (gdpr_information_duties_timing_subject(Subject), gdpr_information_duties_timing_profile_for(Subject, Profile), information_deadline_basis_checklist(Profile, [_FirstItem|_OtherItems])), Covered),
    Covered == Subjects.
test(the_basis_status_is_in_the_vocabulary) :-
    gdpr_information_duties_timing_profile_for(art14_first_disclosure_on_day, Profile),
    information_deadline_basis_decision_resolvable(Profile),
    information_deadline_basis_status(Profile, Status),
    information_deadline_basis_status_values(StatusValues),
    member(Status, StatusValues),
    Status == art14_3_c.
test(the_basis_decision_carries_its_citation) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_last_day, Profile),
    decide_information_deadline_basis(Profile, information_deadline_basis_verdict(art14_3_a, [cite(eu_reg_2016_679_art_14_3_a)])).
test(what_if_the_near_miss_is_moved_back_one_day) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_day_after, Profile),
    gdpr_information_duties_timing_what_if(Profile, provision_date, date(2026, 2, 16), timely).
test(what_if_the_positive_case_is_moved_on_one_day) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_last_day, Profile),
    gdpr_information_duties_timing_what_if(Profile, provision_date, date(2026, 2, 17), late).
test(what_if_an_unread_key_changes_nothing) :-
    gdpr_information_duties_timing_profile_for(art13_provided_on_obtaining_day, Profile),
    gdpr_information_duties_timing_what_if(Profile, transfer_intended, true, timely).

test(art13_on_the_obtaining_day_is_not_late, fail) :-
    gdpr_information_duties_timing_assess(art13_provided_on_obtaining_day, information_timing_verdict_verdict(late, _)).
test(art13_the_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_assess(art13_provided_day_after_obtaining, information_timing_verdict_verdict(timely, _)).
test(art14_one_month_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_assess(art14_one_month_day_after, information_timing_verdict_verdict(timely, _)).
test(art14_leap_day_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_assess(art14_leap_day_day_after, information_timing_verdict_verdict(timely, _)).
test(art14_holiday_shift_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_assess(art14_holiday_shift_day_after, information_timing_verdict_verdict(timely, _)).
test(art14_first_communication_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_assess(art14_first_communication_day_after, information_timing_verdict_verdict(timely, _)).
test(art14_first_disclosure_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_assess(art14_first_disclosure_day_after, information_timing_verdict_verdict(timely, _)).
test(art14_reasonable_period_true_carries_no_provenance, fail) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_last_day, Profile),
    information_timing_verdict(Profile, needs_legal_review(_, [_, provenance(_, _)]), _).
test(art14_reasonable_period_unsure_is_not_timely, fail) :-
    gdpr_information_duties_timing_profile_for(art14_reasonable_period_unsure, Profile),
    information_timing_verdict(Profile, timely, _).
test(art14_reasonable_period_false_is_not_timely, fail) :-
    gdpr_information_duties_timing_assess(art14_reasonable_period_false, information_timing_verdict_verdict(timely, _)).
test(crisp_flag_given_unsure_is_not_timely, fail) :-
    gdpr_information_duties_timing_assess(crisp_flag_given_unsure, information_timing_verdict_verdict(timely, _)).
test(a_repeated_key_is_not_timely, fail) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))], timely, _).
test(an_attested_empty_holiday_list_does_not_reach_february_second, fail) :-
    information_deadline([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 12, 31)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(public_holidays, attested([], attestation(host, moment, reason, none)))], date(2027, 2, 2)).

cp_test_names([art13_on_the_obtaining_day_is_timely, art13_the_day_after_is_late, art13_deadline_and_basis, art14_one_month_last_day_is_timely, art14_one_month_day_after_is_late, art14_one_month_deadline_element_wise, art14_leap_day_last_day_is_timely, art14_leap_day_day_after_is_late, art14_leap_day_deadline, art14_holiday_shift_last_day_is_timely, art14_holiday_shift_day_after_is_late, art14_holiday_shift_deadline, art14_tie_goes_to_limb_a, art14_tie_is_timely_citing_limb_a, art14_first_communication_on_day_is_timely, art14_first_communication_day_after_is_late, art14_first_communication_basis, art14_first_disclosure_on_day_is_timely, art14_first_disclosure_day_after_is_late, art14_first_disclosure_basis, art14_reasonable_period_unsure_needs_legal_review, art14_reasonable_period_unsure_carries_provenance, art14_reasonable_period_false_is_late, art14_reasonable_period_absent_is_indeterminate, route_unknown_is_indeterminate, route_unknown_deadline_is_indeterminate, crisp_flag_given_unsure_is_an_input_problem, a_repeated_key_is_a_duplicate_key_on_every_relation, a_repeated_key_is_never_also_wrong_type, an_attested_holiday_list_with_url_evidence_shifts_the_deadline, an_attested_empty_holiday_list_shifts_weekends_only, an_attested_law_fact_with_document_evidence_is_accepted_and_ignored, a_law_fact_not_attested_is_wrong_type, an_attested_value_outside_true_and_false_is_wrong_type, an_attested_fact_without_an_attestation_is_wrong_type, every_subject_has_exactly_one_verdict, every_subject_has_exactly_one_deadline_and_basis, every_subject_has_a_non_empty_checklist, the_basis_status_is_in_the_vocabulary, the_basis_decision_carries_its_citation, what_if_the_near_miss_is_moved_back_one_day, what_if_the_positive_case_is_moved_on_one_day, what_if_an_unread_key_changes_nothing]).
cp_test_fail_names([art13_on_the_obtaining_day_is_not_late, art13_the_day_after_is_not_timely, art14_one_month_day_after_is_not_timely, art14_leap_day_day_after_is_not_timely, art14_holiday_shift_day_after_is_not_timely, art14_first_communication_day_after_is_not_timely, art14_first_disclosure_day_after_is_not_timely, art14_reasonable_period_true_carries_no_provenance, art14_reasonable_period_unsure_is_not_timely, art14_reasonable_period_false_is_not_timely, crisp_flag_given_unsure_is_not_timely, a_repeated_key_is_not_timely, an_attested_empty_holiday_list_does_not_reach_february_second]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
