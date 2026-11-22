% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_citations, [citation/2, implements/1]).

test(the_kernel_input_check_loads) :-
    gdpr_arts33_34_breach_notification_input_problems([], Problems),
    Problems == [].
test(the_kernel_input_check_refuses_a_non_list) :-
    gdpr_arts33_34_breach_notification_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(the_kernel_input_check_has_exactly_one_answer) :-
    findall(Problems, gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller)], Problems), Answers),
    Answers == [[]].
test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_requirement_atoms_are_distinct) :-
    dif(without_undue_delay, reasons_for_delay).
test(the_final_compound_is_not_a_bare_verdict) :-
    dif(notification_requirement_not_met(without_undue_delay), eligible),
    dif(notification_requirement_not_met(reasons_for_delay), ineligible).
test(the_content_results_are_distinct) :-
    dif(all_requirements_met, requirements_not_met([nature_of_breach])),
    dif(requirements_not_met([contact_point]), information_to_follow_in_phases([contact_point])).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)]),
    Verdict = breach_notification_verdict_verdict(Status, Citations),
    Status == eligible,
    Citations == [cite(eu_reg_2016_679_art_33_1)].
test(the_status_compound_destructures) :-
    Status = indeterminate([breach_unlikely_to_result_in_risk]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [breach_unlikely_to_result_in_risk].
test(the_referral_term_destructures) :-
    Referral = needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])]),
    Referral = needs_legal_review(open_textured(Key, cite(CitationKey)), Context),
    Key == breach_unlikely_to_result_in_risk,
    CitationKey == eu_reg_2016_679_art_33_1,
    Context == [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])].
test(the_period_end_term_destructures) :-
    PeriodEnd = period_end(date(2025, 11, 3), 11),
    PeriodEnd = period_end(date(Year, Month, Day), EndHour),
    Year == 2025,
    Month == 11,
    Day == 3,
    EndHour == 11.
test(the_obligation_list_destructures) :-
    Obligation = [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))],
    Obligation = [First, Second, Third],
    First = notify_supervisory_authority(cite(FirstKey)),
    Second = document_breach(cite(SecondKey)),
    Third = public_communication_or_similar_measure(cite(ThirdKey)),
    FirstKey == eu_reg_2016_679_art_33_1,
    SecondKey == eu_reg_2016_679_art_33_5,
    ThirdKey == eu_reg_2016_679_art_34_3_c.
test(the_primary_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_33_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_documentation_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_33_5, _).
test(the_period_citation_is_recorded) :-
    citation(eu_reg_1971_1182_art_3_2_a, _).
test(the_primary_citation_implements) :-
    implements(eu_reg_2016_679_art_34_1).

test(an_unrecorded_citation_does_not_resolve, fail) :-
    citation(eu_todo_primary_source, _).

cp_test_names([the_kernel_input_check_loads, the_kernel_input_check_refuses_a_non_list, the_kernel_input_check_has_exactly_one_answer, the_verdict_atoms_are_distinct, the_requirement_atoms_are_distinct, the_final_compound_is_not_a_bare_verdict, the_content_results_are_distinct, the_verdict_term_carries_status_and_citations, the_status_compound_destructures, the_referral_term_destructures, the_period_end_term_destructures, the_obligation_list_destructures, the_primary_citation_is_recorded, the_documentation_citation_is_recorded, the_period_citation_is_recorded, the_primary_citation_implements]).
cp_test_fail_names([an_unrecorded_citation_does_not_resolve]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
