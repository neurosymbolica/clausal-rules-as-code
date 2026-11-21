% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_cra_administrative_fines_kernel, [cra_administrative_fines_input_problems/2, cra_administrative_fines_calendar_day_t/2, cra_administrative_fines_contract_keys/1]).
:- use_module(m__eu_cra_administrative_fines_citations, [citation/2, implements/1]).

test(the_contract_keys_load_in_order) :-
    cra_administrative_fines_contract_keys(Keys),
    Keys == [infringed_provision, offender_is_open_source_software_steward, offender_is_undertaking, total_worldwide_annual_turnover_in_euros].
test(a_well_formed_profile_has_no_problem) :-
    cra_administrative_fines_input_problems([attribute(infringed_provision, article_14), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000)], Problems),
    Problems == [].
test(the_input_check_gives_one_answer) :-
    findall(Problems, cra_administrative_fines_input_problems([attribute(infringed_provision, article_53)], Problems), Answers),
    Answers == [[]].
test(an_unknown_key_is_named) :-
    cra_administrative_fines_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(a_float_turnover_is_wrong_type) :-
    cra_administrative_fines_input_problems([attribute(total_worldwide_annual_turnover_in_euros, 60.0)], Problems),
    Problems == [wrong_type(total_worldwide_annual_turnover_in_euros)].
test(an_unsure_judgement_is_in_type) :-
    cra_administrative_fines_input_problems([attribute(offender_is_open_source_software_steward, unsure)], Problems),
    Problems == [].
test(the_application_day_is_a_calendar_day) :-
    cra_administrative_fines_calendar_day_t(date(2027, 12, 11), true).
test(the_thirtieth_of_february_is_not_a_calendar_day) :-
    cra_administrative_fines_calendar_day_t(date(2028, 2, 30), false).
test(the_final_answer_atoms_are_distinct) :-
    dif(not_yet_applicable, not_listed_in_article_64).
test(the_tiers_are_distinct) :-
    dif(highest_maximum_tier, middle_maximum_tier),
    dif(highest_maximum_tier, lowest_maximum_tier),
    dif(middle_maximum_tier, lowest_maximum_tier).
test(the_bases_are_distinct) :-
    dif(fixed_amount, percentage_of_turnover),
    dif(fixed_amount, fixed_amount_for_non_undertaking),
    dif(percentage_of_turnover, fixed_amount_for_non_undertaking).
test(the_input_problem_terms_are_distinct) :-
    dif(duplicate_key(offender_is_undertaking), wrong_type(offender_is_undertaking)),
    dif(wrong_type(offender_is_undertaking), unknown_key(offender_is_undertaking)).
test(the_fine_maximum_term_carries_tier_basis_and_cap) :-
    Verdict = fine_maximum(highest_maximum_tier, fixed_amount, 1500000000),
    Verdict = fine_maximum(Tier, Basis, CapInEuroCents),
    Tier == highest_maximum_tier,
    Basis == fixed_amount,
    integer(CapInEuroCents),
    CapInEuroCents #= 1500000000.
test(the_fine_excluded_term_carries_the_exception) :-
    Verdict = fine_excluded(open_source_software_steward),
    Verdict = fine_excluded(Exception),
    Exception == open_source_software_steward.
test(the_indeterminate_term_carries_one_key) :-
    Verdict = indeterminate([infringed_provision]),
    Verdict = indeterminate([MissingKey]),
    MissingKey == infringed_provision.
test(the_referral_term_carries_reason_and_context) :-
    Verdict = needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_2)), [inputs_relied_on([offender_is_undertaking - unsure])]),
    Verdict = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == offender_is_undertaking,
    CitationKey == eu_reg_2024_2847_art_64_2,
    Pairs == [offender_is_undertaking - unsure],
    citation(CitationKey, _Record).
test(the_input_problems_term_carries_the_list) :-
    Verdict = input_problems([wrong_type(infringement_date)]),
    Verdict = input_problems(Problems),
    Problems == [wrong_type(infringement_date)].
test(the_highest_tier_citation_is_recorded) :-
    citation(eu_reg_2024_2847_art_64_2, _Record).
test(every_returned_citation_is_recorded) :-
    citation(eu_reg_2024_2847_art_71_2, _DateRecord),
    citation(eu_reg_2024_2847_art_64_1, _PenaltiesRecord),
    citation(eu_reg_2024_2847_art_64_3, _MiddleRecord),
    citation(eu_reg_2024_2847_art_64_4, _LowestRecord),
    citation(eu_reg_2024_2847_art_64_10_b, _StewardRecord).
test(the_marker_keys_resolve) :-
    implements(eu_reg_2024_2847_art_64_10),
    implements(eu_reg_2024_2847_art_3_14).

test(an_unsure_judgement_is_not_a_problem, fail) :-
    cra_administrative_fines_input_problems([attribute(offender_is_open_source_software_steward, unsure)], [_|_]).
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(art_64_2, _Record).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_contract_keys_load_in_order, a_well_formed_profile_has_no_problem, the_input_check_gives_one_answer, an_unknown_key_is_named, a_float_turnover_is_wrong_type, an_unsure_judgement_is_in_type, the_application_day_is_a_calendar_day, the_thirtieth_of_february_is_not_a_calendar_day, the_final_answer_atoms_are_distinct, the_tiers_are_distinct, the_bases_are_distinct, the_input_problem_terms_are_distinct, the_fine_maximum_term_carries_tier_basis_and_cap, the_fine_excluded_term_carries_the_exception, the_indeterminate_term_carries_one_key, the_referral_term_carries_reason_and_context, the_input_problems_term_carries_the_list, the_highest_tier_citation_is_recorded, every_returned_citation_is_recorded, the_marker_keys_resolve]).
cp_test_fail_names([an_unsure_judgement_is_not_a_problem, a_shortened_citation_is_not_recorded, the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
