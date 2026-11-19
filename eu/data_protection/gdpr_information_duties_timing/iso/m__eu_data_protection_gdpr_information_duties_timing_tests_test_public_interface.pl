% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [decide_information_deadline_basis/2, information_deadline_basis_status/2, information_deadline_basis_checklist/2, information_deadline_basis_decision_resolvable/1, information_deadline_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_subject/1, gdpr_information_duties_timing_profile_for/2, gdpr_information_duties_timing_assess/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_queries, [information_deadline/2, information_deadline_basis/2, information_timing_verdict/3, gdpr_information_duties_timing_what_if/4, gdpr_information_duties_timing_compliance_check/3, gdpr_information_duties_timing_obligation/2, provenance/2, url/2, document/2, attested/2, attestation/4]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [gdpr_information_duties_timing_input_problems/2]).

expected(art13_on_obtaining_day, date(2026, 3, 10), art13_1, timely, [cite(eu_reg_2016_679_art_13_1)]).
expected(art13_day_after_obtaining, date(2026, 3, 10), art13_1, late, [cite(eu_reg_2016_679_art_13_1)]).
expected(art13_with_unread_keys, date(2026, 3, 10), art13_1, timely, [cite(eu_reg_2016_679_art_13_1)]).
expected(art14_limb_a_last_day, date(2026, 2, 16), art14_3_a, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected(art14_limb_a_day_after, date(2026, 2, 16), art14_3_a, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected(art14_first_communication_day, date(2026, 1, 20), art14_3_b, timely, [cite(eu_reg_2016_679_art_14_3_b)]).
expected(art14_day_after_first_communication, date(2026, 1, 20), art14_3_b, late, [cite(eu_reg_2016_679_art_14_3_b)]).
expected(art14_first_disclosure_day, date(2026, 2, 1), art14_3_c, timely, [cite(eu_reg_2016_679_art_14_3_c)]).
expected(art14_day_after_first_disclosure, date(2026, 2, 1), art14_3_c, late, [cite(eu_reg_2016_679_art_14_3_c)]).
expected(art14_attested_holiday_shift, date(2027, 2, 2), art14_3_a, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected(art14_day_after_attested_holiday_shift, date(2027, 2, 2), art14_3_a, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected(art14_leap_day, date(2028, 2, 29), art14_3_a, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected(art14_day_after_leap_day, date(2028, 2, 29), art14_3_a, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected(art14_holidays_absent_on_limb_a_day, needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), [resolution(cite(public_holidays_applicable_to_the_period), not_attempted), inputs_relied_on([])]), art14_3_a, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected(art14_holidays_absent_after_limb_a_day, needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), [resolution(cite(public_holidays_applicable_to_the_period), not_attempted), inputs_relied_on([])]), art14_3_a, needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), [resolution(cite(public_holidays_applicable_to_the_period), not_attempted), inputs_relied_on([provided_within_reasonable_period - true])]), []).
expected(art14_reasonable_period_false, date(2026, 2, 16), art14_3_a, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected(art14_reasonable_period_unsure, date(2026, 2, 16), art14_3_a, needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure])]), []).
expected(route_unknown, indeterminate([personal_data_collected_from_data_subject]), indeterminate([personal_data_collected_from_data_subject]), indeterminate([personal_data_collected_from_data_subject]), []).
expected(items_provided_wrong_type, input_problems([wrong_type(items_provided)]), input_problems([wrong_type(items_provided)]), input_problems([wrong_type(items_provided)]), []).
expected(route_key_duplicated, input_problems([duplicate_key(personal_data_collected_from_data_subject)]), input_problems([duplicate_key(personal_data_collected_from_data_subject)]), input_problems([duplicate_key(personal_data_collected_from_data_subject)]), []).

near_miss_pair(art13_on_obtaining_day, art13_day_after_obtaining).
near_miss_pair(art14_limb_a_last_day, art14_limb_a_day_after).
near_miss_pair(art14_first_communication_day, art14_day_after_first_communication).
near_miss_pair(art14_first_disclosure_day, art14_day_after_first_disclosure).
near_miss_pair(art14_attested_holiday_shift, art14_day_after_attested_holiday_shift).
near_miss_pair(art14_leap_day, art14_day_after_leap_day).

subject_answers_as_expected(Subject) :-
    expected(Subject, Deadline, Basis, Verdict, Citations),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(FoundDeadline, information_deadline(Profile, FoundDeadline), Deadlines),
    Deadlines == [Deadline],
    findall(FoundBasis, information_deadline_basis(Profile, FoundBasis), Bases),
    Bases == [Basis],
    findall(FoundVerdict - FoundCitations, information_timing_verdict(Profile, FoundVerdict, FoundCitations), Answers),
    Answers == [Verdict - Citations].

verdict_of(Subject, Verdict) :-
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_timing_verdict(Profile, Verdict, _).

near_miss_flips(Positive - Control) :-
    verdict_of(Positive, PositiveVerdict),
    PositiveVerdict == timely,
    verdict_of(Control, ControlVerdict),
    ControlVerdict == late.

checklist_is_non_empty(Subject) :-
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_deadline_basis_checklist(Profile, [_|_]).

test(every_subject_has_an_expected_answer) :-
    findall(RegisteredSubject, gdpr_information_duties_timing_subject(RegisteredSubject), RegisteredSubjects),
    findall(ExpectedSubject, expected(ExpectedSubject, _, _, _, _), ExpectedSubjects),
    clausal_msort(RegisteredSubjects, SortedRegistered),
    clausal_msort(ExpectedSubjects, SortedExpected),
    SortedRegistered == SortedExpected,
    length(RegisteredSubjects, 20).
test(every_subject_resolves_to_its_expected_answers_once) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    maplist(subject_answers_as_expected, Subjects).
test(every_near_miss_control_gets_the_opposite_verdict) :-
    findall(Positive - Control, near_miss_pair(Positive, Control), Pairs),
    length(Pairs, 6),
    maplist(near_miss_flips, Pairs).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    maplist(checklist_is_non_empty, Subjects).
test(art13_on_obtaining_day_is_timely) :-
    verdict_of(art13_on_obtaining_day, timely).
test(art13_day_after_obtaining_is_late) :-
    verdict_of(art13_day_after_obtaining, late).
test(art13_unread_keys_do_not_change_the_answer) :-
    verdict_of(art13_with_unread_keys, timely).
test(art14_limb_a_last_day_is_timely) :-
    verdict_of(art14_limb_a_last_day, timely).
test(art14_limb_a_day_after_is_late) :-
    verdict_of(art14_limb_a_day_after, late).
test(art14_first_communication_day_is_timely) :-
    verdict_of(art14_first_communication_day, timely).
test(art14_day_after_first_communication_is_late) :-
    verdict_of(art14_day_after_first_communication, late).
test(art14_first_disclosure_day_is_timely) :-
    verdict_of(art14_first_disclosure_day, timely).
test(art14_day_after_first_disclosure_is_late) :-
    verdict_of(art14_day_after_first_disclosure, late).
test(art14_attested_holiday_shift_is_timely) :-
    verdict_of(art14_attested_holiday_shift, timely).
test(art14_day_after_attested_holiday_shift_is_late) :-
    verdict_of(art14_day_after_attested_holiday_shift, late).
test(art14_leap_day_is_timely) :-
    verdict_of(art14_leap_day, timely).
test(art14_day_after_leap_day_is_late) :-
    verdict_of(art14_day_after_leap_day, late).
test(art14_false_judgement_is_late) :-
    verdict_of(art14_reasonable_period_false, late).
test(art14_unsure_judgement_is_handed_to_the_user) :-
    verdict_of(art14_reasonable_period_unsure, needs_legal_review(open_textured(provided_within_reasonable_period, _), _)).
test(holidays_absent_on_limb_a_day_is_timely) :-
    verdict_of(art14_holidays_absent_on_limb_a_day, timely).
test(holidays_absent_after_limb_a_day_is_referred) :-
    verdict_of(art14_holidays_absent_after_limb_a_day, needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), _), _)).
test(route_unknown_names_the_route) :-
    verdict_of(route_unknown, indeterminate([personal_data_collected_from_data_subject])).
test(other_purpose_information_in_items_provided_is_wrong_type) :-
    gdpr_information_duties_timing_profile_for(items_provided_wrong_type, Profile),
    gdpr_information_duties_timing_input_problems(Profile, [wrong_type(items_provided)]).
test(a_duplicated_key_is_an_input_problem) :-
    gdpr_information_duties_timing_profile_for(route_key_duplicated, Profile),
    gdpr_information_duties_timing_input_problems(Profile, [duplicate_key(personal_data_collected_from_data_subject)]).
test(a_well_formed_fixture_has_no_input_problem) :-
    gdpr_information_duties_timing_profile_for(art13_with_unread_keys, Profile),
    gdpr_information_duties_timing_input_problems(Profile, []).
test(the_assess_wrapper_gives_the_timing_verdict) :-
    findall(Result, gdpr_information_duties_timing_assess(art14_limb_a_last_day, Result), Results),
    Results == [information_timing_verdict_verdict(timely, [cite(eu_reg_2016_679_art_14_3_a)])].
test(the_basis_decision_carries_its_citation) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_day, Profile),
    decide_information_deadline_basis(Profile, information_deadline_basis_verdict(art14_3_b, [cite(eu_reg_2016_679_art_14_3_b)])),
    information_deadline_basis_status(Profile, art14_3_b),
    information_deadline_basis_decision_resolvable(Profile).
test(the_basis_status_values_are_the_four_limbs) :-
    information_deadline_basis_status_values(Values),
    Values == [art13_1, art14_3_a, art14_3_b, art14_3_c].
test(what_if_the_information_came_on_the_last_day) :-
    gdpr_information_duties_timing_profile_for(art14_limb_a_day_after, Profile),
    findall(Verdict, gdpr_information_duties_timing_what_if(Profile, provision_date, date(2026, 2, 16), Verdict), Verdicts),
    Verdicts == [timely].
test(compliance_check_on_the_deadline_is_allowed) :-
    gdpr_information_duties_timing_profile_for(art14_first_disclosure_day, Profile),
    gdpr_information_duties_timing_compliance_check(Profile, date(2026, 2, 1), timely).
test(compliance_check_after_the_deadline_is_late) :-
    gdpr_information_duties_timing_profile_for(art14_first_disclosure_day, Profile),
    gdpr_information_duties_timing_compliance_check(Profile, date(2026, 2, 2), late).
test(the_obligation_surfaces_deadline_and_basis) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_day, Profile),
    findall(Obligation, gdpr_information_duties_timing_obligation(Profile, Obligation), Obligations),
    Obligations == [obligation(provide_information, by(date(2026, 1, 20)), basis(art14_3_b), consequence(late), [cite(eu_reg_2016_679_art_14_3_b)])].
test(the_obligation_with_the_route_unknown_names_the_route) :-
    gdpr_information_duties_timing_profile_for(route_unknown, Profile),
    gdpr_information_duties_timing_obligation(Profile, indeterminate([personal_data_collected_from_data_subject])).
test(provenance_recognizes_a_clause_and_its_citations) :-
    provenance(reasonable_period_verdict, [cite(eu_reg_2016_679_art_14_3_a)]).
test(provenance_recognizes_an_empty_citation_list) :-
    provenance(deadline_answer, []).
test(url_recognizes_an_address_and_its_retrieval_time) :-
    url('https://eur-lex.europa.eu/oj/direct-access.html', retrieved_at(2026, 11, 18)).
test(document_recognizes_an_upload_and_its_digest) :-
    document(upload_holiday_notice, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855').
test(an_attested_fact_with_url_evidence_is_recognized) :-
    Evidence = url('https://eur-lex.europa.eu/oj/direct-access.html', retrieved_at(2026, 11, 18)),
    attestation(fixture_host, fixture_time, fixture_reason, Evidence),
    attested([date(2026, 12, 25)], attestation(fixture_host, fixture_time, fixture_reason, Evidence)).

test(art13_day_after_obtaining_is_not_timely, fail) :-
    verdict_of(art13_day_after_obtaining, timely).
test(art14_limb_a_day_after_is_not_timely, fail) :-
    verdict_of(art14_limb_a_day_after, timely).
test(art14_false_judgement_is_not_timely, fail) :-
    verdict_of(art14_reasonable_period_false, timely).
test(art14_unsure_judgement_is_not_timely, fail) :-
    verdict_of(art14_reasonable_period_unsure, timely).
test(holidays_absent_after_limb_a_day_is_not_late, fail) :-
    verdict_of(art14_holidays_absent_after_limb_a_day, late).
test(provenance_refuses_citations_that_are_not_a_list, fail) :-
    provenance(reasonable_period_verdict, cite(eu_reg_2016_679_art_14_3_a)).
test(provenance_refuses_an_unbound_clause, fail) :-
    provenance(_, [cite(eu_reg_2016_679_art_14_3_a)]).
test(url_refuses_a_compound_address, fail) :-
    url(address(eur_lex), retrieved_at(2026, 11, 18)).
test(url_refuses_an_unbound_retrieval_time, fail) :-
    url('https://eur-lex.europa.eu/oj/direct-access.html', _).
test(document_refuses_a_compound_digest, fail) :-
    document(upload_holiday_notice, digest(sha256)).
test(document_refuses_an_unbound_upload, fail) :-
    document(_, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855').
test(an_attestation_with_an_unbound_part_is_refused, fail) :-
    attestation(fixture_host, _, fixture_reason, none).

cp_test_names([every_subject_has_an_expected_answer, every_subject_resolves_to_its_expected_answers_once, every_near_miss_control_gets_the_opposite_verdict, every_subject_has_a_non_empty_checklist, art13_on_obtaining_day_is_timely, art13_day_after_obtaining_is_late, art13_unread_keys_do_not_change_the_answer, art14_limb_a_last_day_is_timely, art14_limb_a_day_after_is_late, art14_first_communication_day_is_timely, art14_day_after_first_communication_is_late, art14_first_disclosure_day_is_timely, art14_day_after_first_disclosure_is_late, art14_attested_holiday_shift_is_timely, art14_day_after_attested_holiday_shift_is_late, art14_leap_day_is_timely, art14_day_after_leap_day_is_late, art14_false_judgement_is_late, art14_unsure_judgement_is_handed_to_the_user, holidays_absent_on_limb_a_day_is_timely, holidays_absent_after_limb_a_day_is_referred, route_unknown_names_the_route, other_purpose_information_in_items_provided_is_wrong_type, a_duplicated_key_is_an_input_problem, a_well_formed_fixture_has_no_input_problem, the_assess_wrapper_gives_the_timing_verdict, the_basis_decision_carries_its_citation, the_basis_status_values_are_the_four_limbs, what_if_the_information_came_on_the_last_day, compliance_check_on_the_deadline_is_allowed, compliance_check_after_the_deadline_is_late, the_obligation_surfaces_deadline_and_basis, the_obligation_with_the_route_unknown_names_the_route, provenance_recognizes_a_clause_and_its_citations, provenance_recognizes_an_empty_citation_list, url_recognizes_an_address_and_its_retrieval_time, document_recognizes_an_upload_and_its_digest, an_attested_fact_with_url_evidence_is_recognized]).
cp_test_fail_names([art13_day_after_obtaining_is_not_timely, art14_limb_a_day_after_is_not_timely, art14_false_judgement_is_not_timely, art14_unsure_judgement_is_not_timely, holidays_absent_after_limb_a_day_is_not_late, provenance_refuses_citations_that_are_not_a_list, provenance_refuses_an_unbound_clause, url_refuses_a_compound_address, url_refuses_an_unbound_retrieval_time, document_refuses_a_compound_digest, document_refuses_an_unbound_upload, an_attestation_with_an_unbound_part_is_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
