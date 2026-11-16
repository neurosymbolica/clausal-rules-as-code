% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_provider_side_duties_kernel, [provider_side_duties_input_problems/2, provider_side_duties_calendar_date_t/2, provider_side_duties_leap_year_t/2, provider_side_duties_month_length/3, provider_side_duties_day_key/2, provider_side_duties_date_before_t/3]).
:- use_module(m__eu_ai_act_provider_side_duties_citations, [citation/2, implements/1]).

test(the_ten_result_atoms_are_distinct) :-
    Atoms = [not_applicable_on_date, earlier_text_not_formalised, not_an_ai_system, not_a_high_risk_ai_system, not_the_addressee_of_the_duty, compliance_required_by_31_december_2030, compliance_required_by_2_august_2030, system_already_placed_without_significant_change, duty_not_triggered, duty_applies],
    sort(Atoms, UniqueAtoms),
    length(UniqueAtoms, Count),
    Count == 10.
test(the_verdict_atoms_are_distinct) :-
    dif(duty_applies, duty_not_triggered),
    dif(not_applicable_on_date, earlier_text_not_formalised),
    dif(compliance_required_by_31_december_2030, compliance_required_by_2_august_2030),
    dif(not_an_ai_system, not_a_high_risk_ai_system).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = provider_side_duties_verdict(duty_applies, [cite(eu_reg_2024_1689_art_16_a)]),
    Verdict = provider_side_duties_verdict(Status, Citations),
    Status == duty_applies,
    Citations == [cite(eu_reg_2024_1689_art_16_a)].
test(the_indeterminate_status_holds_one_bare_key) :-
    Status = indeterminate([actor_role]),
    Status = indeterminate([MissingKey]),
    MissingKey == actor_role.
test(the_referral_status_destructures) :-
    Status = needs_legal_review(open_textured(ai_system, cite(eu_reg_2024_1689_art_3_1)), [inputs_relied_on([ai_system - unsure])]),
    Status = needs_legal_review(open_textured(Judgement, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Judgement == ai_system,
    CitationKey == eu_reg_2024_1689_art_3_1,
    Pairs == [ai_system - unsure].
test(the_input_problems_status_destructures) :-
    Status = input_problems([wrong_type(duty), wrong_type(assessment_date)]),
    Status = input_problems(Problems),
    Problems == [wrong_type(duty), wrong_type(assessment_date)].
test(a_date_term_destructures) :-
    EndDate = date(2038, 3, 15),
    EndDate = date(YearNumber, MonthNumber, DayNumber),
    YearNumber == 2038,
    MonthNumber == 3,
    DayNumber == 15.
test(the_art_4_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_4_1, _Record).
test(the_retention_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_19_1, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2024_1689_art_111_2).
test(a_well_formed_profile_has_no_problem) :-
    provider_side_duties_input_problems([attribute(actor_role, importer), attribute(high_risk_ai_system, true)], []).
test(an_unknown_key_is_named) :-
    provider_side_duties_input_problems([attribute(colour, blue)], [unknown_key(colour)]).
test(a_real_calendar_day) :-
    provider_side_duties_calendar_date_t(date(2027, 12, 2), true).
test(an_impossible_day) :-
    provider_side_duties_calendar_date_t(date(2027, 2, 29), false).
test(a_leap_year) :-
    provider_side_duties_leap_year_t(2028, true).
test(february_in_a_leap_year) :-
    provider_side_duties_month_length(2028, 2, 29).
test(the_day_key_orders_days) :-
    provider_side_duties_day_key(date(2028, 8, 2), DayKey),
    DayKey == 20280802.
test(the_day_before_the_application_date_is_before) :-
    provider_side_duties_date_before_t(date(2027, 12, 1), date(2027, 12, 2), true).
test(the_application_date_itself_is_not_before) :-
    provider_side_duties_date_before_t(date(2027, 12, 2), date(2027, 12, 2), false).

test(a_verdict_atom_is_not_another, fail) :-
    duty_applies = duty_not_triggered.
test(a_shortened_key_is_not_recorded, fail) :-
    citation(eu_reg_2024_1689_art_111, _Record).
test(an_unknown_key_is_not_a_clean_profile, fail) :-
    provider_side_duties_input_problems([attribute(colour, blue)], []).
test(the_application_date_itself_is_never_before, fail) :-
    provider_side_duties_date_before_t(date(2027, 12, 2), date(2027, 12, 2), true).

cp_test_names([the_ten_result_atoms_are_distinct, the_verdict_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_status_holds_one_bare_key, the_referral_status_destructures, the_input_problems_status_destructures, a_date_term_destructures, the_art_4_citation_is_recorded, the_retention_citation_is_recorded, a_recorded_key_is_implemented, a_well_formed_profile_has_no_problem, an_unknown_key_is_named, a_real_calendar_day, an_impossible_day, a_leap_year, february_in_a_leap_year, the_day_key_orders_days, the_day_before_the_application_date_is_before, the_application_date_itself_is_not_before]).
cp_test_fail_names([a_verdict_atom_is_not_another, a_shortened_key_is_not_recorded, an_unknown_key_is_not_a_clean_profile, the_application_date_itself_is_never_before]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
