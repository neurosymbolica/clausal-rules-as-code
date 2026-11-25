% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_oversight_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ctpp_oversight_kernel, [dora_ctpp_oversight_input_problems/2]).
:- use_module(m__eu_dora_ctpp_oversight_citations, [citation/2, implements/1]).

test(the_input_check_loads_and_accepts_an_empty_profile) :-
    findall(Problems, dora_ctpp_oversight_input_problems([], Problems), Answers),
    Answers == [[]].
test(the_input_check_names_an_unknown_key) :-
    dora_ctpp_oversight_input_problems([attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(the_input_check_refuses_a_non_list_profile) :-
    dora_ctpp_oversight_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(the_final_answer_atoms_are_distinct) :-
    dif(not_designated_as_critical, penalty_decision_required),
    dif(no_penalty_ground_recommendation, no_penalty_ground_full_compliance),
    dif(no_penalty_ground_full_compliance, penalty_decision_required),
    dif(lead_overseer_agreement_required, no_article_33_5_condition),
    dif(not_designated_as_critical, lead_overseer_agreement_required).
test(the_duty_atoms_are_distinct) :-
    dif(transmit_subcontracting_information_to_lead_overseer, cooperate_in_good_faith_with_lead_overseer).
test(the_power_atoms_are_distinct) :-
    Powers = [request_information_and_documentation, conduct_general_investigations_and_inspections, request_remediation_reports, issue_recommendations, recommend_refraining_from_further_subcontracting],
    sort(Powers, SortedPowers),
    length(Powers, PowerCount),
    length(SortedPowers, SortedPowerCount),
    PowerCount == SortedPowerCount.
test(the_window_constructors_are_distinct) :-
    dif(window_open(date(2026, 1, 16)), window_closed(date(2026, 1, 16))),
    dif(window_open(date(2026, 1, 16)), window_not_yet_open(date(2026, 1, 16))).
test(the_duties_result_builds_and_destructures) :-
    Result = required([transmit_subcontracting_information_to_lead_overseer, cooperate_in_good_faith_with_lead_overseer]),
    Result = required(Duties),
    Duties == [transmit_subcontracting_information_to_lead_overseer, cooperate_in_good_faith_with_lead_overseer].
test(the_powers_result_builds_and_destructures) :-
    Result = powers([request_information_and_documentation, issue_recommendations]),
    Result = powers([FirstPower|_]),
    FirstPower == request_information_and_documentation.
test(the_window_result_carries_its_last_day) :-
    Result = window_open(date(2026, 1, 16)),
    Result = window_open(date(Year, Month, DayNumber)),
    Year == 2026,
    Month == 1,
    DayNumber == 16.
test(the_waiting_period_result_carries_its_first_day) :-
    Result = penalty_waiting_period_running(date(2026, 2, 1)),
    Result = penalty_waiting_period_running(FirstDay),
    FirstDay == date(2026, 2, 1).
test(the_penalty_limits_result_builds_and_destructures) :-
    Result = penalty_limits(amount(1000000, 73), date(2027, 2, 28)),
    Result = penalty_limits(amount(Numerator, Denominator), LastDay),
    Numerator == 1000000,
    Denominator == 73,
    LastDay == date(2027, 2, 28).
test(the_nothing_amount_is_zero_over_one) :-
    Maximum = amount(0, 1),
    Maximum = amount(Numerator, Denominator),
    Numerator == 0,
    Denominator == 1.
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([provider_designated_as_critical]),
    Result = indeterminate(MissingKeys),
    MissingKeys == [provider_designated_as_critical].
test(the_input_problems_status_carries_its_problems) :-
    Result = input_problems([duplicate_key(measure_power), wrong_type(assessment_date), unknown_key(colour)]),
    Result = input_problems([duplicate_key(DuplicateKey)|_]),
    DuplicateKey == measure_power.
test(the_status_compound_has_arity_one) :-
    functor(indeterminate([provider_designated_as_critical]), Name, Arity),
    Name == indeterminate,
    Arity == 1.
test(the_facade_verdict_term_carries_status_and_citations) :-
    Verdict = dora_ctpp_oversight_verdict(subject_to_lead_overseer_oversight, [cite(eu_reg_2022_2554_art_35_5)]),
    Verdict = dora_ctpp_oversight_verdict(Status, Citations),
    Status == subject_to_lead_overseer_oversight,
    Citations == [cite(eu_reg_2022_2554_art_35_5)].
test(the_penalty_ground_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_35_6, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_designation_query_citations_are_recorded) :-
    implements(eu_reg_2022_2554_art_35_5),
    implements(eu_reg_2022_2554_art_35_1),
    implements(eu_reg_2022_2554_art_33_4),
    implements(eu_reg_2022_2554_art_35_3),
    implements(eu_reg_2022_2554_art_35_6),
    implements(eu_reg_2022_2554_art_35_7),
    implements(eu_reg_2022_2554_art_35_8),
    implements(eu_reg_2022_2554_art_33_5).

test(the_status_compound_is_not_the_bare_atom, fail) :-
    indeterminate([provider_designated_as_critical]) == indeterminate.
test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _).
test(article_31_is_not_recorded, fail) :-
    implements(eu_reg_2022_2554_art_31).

cp_test_names([the_input_check_loads_and_accepts_an_empty_profile, the_input_check_names_an_unknown_key, the_input_check_refuses_a_non_list_profile, the_final_answer_atoms_are_distinct, the_duty_atoms_are_distinct, the_power_atoms_are_distinct, the_window_constructors_are_distinct, the_duties_result_builds_and_destructures, the_powers_result_builds_and_destructures, the_window_result_carries_its_last_day, the_waiting_period_result_carries_its_first_day, the_penalty_limits_result_builds_and_destructures, the_nothing_amount_is_zero_over_one, the_indeterminate_status_names_one_key, the_input_problems_status_carries_its_problems, the_status_compound_has_arity_one, the_facade_verdict_term_carries_status_and_citations, the_penalty_ground_citation_is_recorded, the_designation_query_citations_are_recorded]).
cp_test_fail_names([the_status_compound_is_not_the_bare_atom, the_placeholder_citation_is_not_recorded, article_31_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
