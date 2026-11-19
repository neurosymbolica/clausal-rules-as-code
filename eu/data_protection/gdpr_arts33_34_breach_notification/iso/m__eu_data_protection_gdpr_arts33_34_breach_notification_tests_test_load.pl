% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_citations, [citation/2, implements/1]).

test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_requirement_atoms_are_distinct) :-
    dif(without_undue_delay, reasons_for_delay).
test(the_final_compound_is_not_a_bare_verdict_atom) :-
    dif(notification_requirement_not_met(without_undue_delay), eligible),
    dif(notification_requirement_not_met(reasons_for_delay), ineligible).
test(the_content_results_are_distinct) :-
    dif(all_requirements_met, requirements_not_met([contact_point])),
    dif(requirements_not_met([contact_point]), information_to_follow_in_phases([contact_point])).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)]),
    Verdict = breach_notification_verdict_verdict(Status, Citations),
    Status == eligible,
    Citations == [cite(eu_reg_2016_679_art_33_1)].
test(a_status_verdict_carries_no_citations) :-
    Verdict = breach_notification_verdict_verdict(indeterminate([breach_unlikely_to_result_in_risk]), []),
    Verdict = breach_notification_verdict_verdict(indeterminate(MissingKeys), Citations),
    MissingKeys == [breach_unlikely_to_result_in_risk],
    Citations == [].
test(a_referral_destructures) :-
    Referral = needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 73, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - unsure])]),
    Referral = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on([hours_elapsed - HoursElapsed|Pairs])]),
    Key == delay_justified_by_reasons,
    Citation == cite(eu_reg_2016_679_art_33_1),
    HoursElapsed == 73,
    Pairs == [breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - unsure].
test(a_period_end_destructures) :-
    PeriodEnd = period_end(date(2025, 11, 3), 11),
    PeriodEnd = period_end(date(Year, Month, Day), EndHour),
    Year == 2025,
    Month == 11,
    Day == 3,
    EndHour == 11.
test(an_obligation_list_destructures) :-
    Obligation = [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))],
    Obligation = [First, Second, Third],
    First == notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)),
    Second == document_breach(cite(eu_reg_2016_679_art_33_5)),
    Third == public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c)).
test(the_primary_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_33_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_communication_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_34_1, _Record).
test(the_period_citation_is_recorded) :-
    citation(eu_reg_1971_1182_art_3_1, _Record).
test(the_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_33_5).
test(the_input_check_accepts_an_empty_profile) :-
    gdpr_arts33_34_breach_notification_input_problems([], Problems),
    Problems == [].
test(the_input_check_refuses_a_non_list) :-
    gdpr_arts33_34_breach_notification_input_problems(controller, Problems),
    Problems == [wrong_type(profile)].
test(the_input_check_names_an_unknown_key) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(as_of_date, true)], Problems),
    Problems == [unknown_key(as_of_date)].

test(the_marker_fails_for_an_invented_key, fail) :-
    implements(gdpr_art_33_1).
test(an_invented_citation_does_not_resolve, fail) :-
    citation(eu_todo_primary_source, _Record).
test(the_input_check_does_not_accept_an_unknown_key_silently, fail) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(as_of_date, true)], []).

cp_test_names([the_verdict_atoms_are_distinct, the_requirement_atoms_are_distinct, the_final_compound_is_not_a_bare_verdict_atom, the_content_results_are_distinct, the_verdict_term_carries_status_and_citations, a_status_verdict_carries_no_citations, a_referral_destructures, a_period_end_destructures, an_obligation_list_destructures, the_primary_citation_is_recorded, the_communication_citation_is_recorded, the_period_citation_is_recorded, the_marker_succeeds_for_a_recorded_key, the_input_check_accepts_an_empty_profile, the_input_check_refuses_a_non_list, the_input_check_names_an_unknown_key]).
cp_test_fail_names([the_marker_fails_for_an_invented_key, an_invented_citation_does_not_resolve, the_input_check_does_not_accept_an_unknown_key_silently]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
