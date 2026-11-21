% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_tlpt_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_tlpt_kernel, [dora_tlpt_input_problems/2]).
:- use_module(m__eu_dora_tlpt_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_tlpt_verdict(tlpt_required(at_least_every_three_years), [cite(eu_reg_2022_2554_art_26_1), cite(eu_reg_2022_2554_art_26_8)]),
    Verdict = dora_tlpt_verdict(Status, Citations),
    Status = tlpt_required(Frequency),
    Frequency == at_least_every_three_years,
    Citations == [cite(eu_reg_2022_2554_art_26_1), cite(eu_reg_2022_2554_art_26_8)].
test(the_identification_result_destructures) :-
    Result = listed_for_tlpt(point_g),
    Result = listed_for_tlpt(Point),
    Point == point_g.
test(the_exclusion_result_destructures) :-
    Result = excluded_from_tlpt(article_16_1_entity),
    Result = excluded_from_tlpt(Ground),
    Ground == article_16_1_entity.
test(the_indeterminate_status_holds_one_bare_key) :-
    Status = indeterminate([dora_entity_type]),
    Status = indeterminate([MissingKey]),
    MissingKey == dora_entity_type.
test(the_listed_compound_unifies_with_its_own_form) :-
    listed_for_tlpt(point_a) = listed_for_tlpt(_).
test(the_grounds_are_distinct) :-
    dif(article_16_1_entity, microenterprise),
    dif(article_16_1_entity, not_identified),
    dif(microenterprise, not_identified).
test(the_frequencies_are_distinct) :-
    dif(at_least_every_three_years, frequency_set_by_competent_authority).
test(the_points_are_distinct) :-
    Points = [point_a, point_b, point_c, point_d, point_e, point_f, point_g],
    sort(Points, SortedPoints),
    length(SortedPoints, Count),
    Count == 7.
test(the_duty_results_are_distinct) :-
    dif(no_tlpt_duty(not_identified), tlpt_required(at_least_every_three_years)).
test(the_duty_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_26_1, _Record).
test(the_identification_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_26_8, _Record).
test(the_list_citation_is_recorded) :-
    citation(eu_reg_2025_1190_art_2_2_g, _Record).
test(every_vocabulary_citation_is_recorded) :-
    Keys = [eu_reg_2022_2554_art_26_1, eu_reg_2022_2554_art_26_8, eu_reg_2025_1190_art_2_1, eu_reg_2025_1190_art_2_2, eu_reg_2025_1190_art_2_2_a, eu_reg_2025_1190_art_2_2_b, eu_reg_2025_1190_art_2_2_c, eu_reg_2025_1190_art_2_2_d, eu_reg_2025_1190_art_2_2_e, eu_reg_2025_1190_art_2_2_f, eu_reg_2025_1190_art_2_2_g],
    maplist(implements, Keys).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2025_1190_art_2_1).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dora_tlpt_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_counterparty), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true), attribute(tlpt_frequency_changed_by_competent_authority, false)],
    findall(Problems, dora_tlpt_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_float_figure_is_wrong_type) :-
    dora_tlpt_input_problems([attribute(gross_written_premium_eur, 1500000000.0)], Problems),
    Problems == [wrong_type(gross_written_premium_eur)].
test(an_integer_figure_is_not_wrong_type) :-
    dora_tlpt_input_problems([attribute(gross_written_premium_eur, 1500000000)], Problems),
    Problems == [].
test(a_repeated_key_is_a_duplicate) :-
    dora_tlpt_input_problems([attribute(dora_entity_type, trading_venue), attribute(dora_entity_type, trading_venue)], Problems),
    Problems == [duplicate_key(dora_entity_type)].
test(a_key_outside_the_contract_is_unknown) :-
    dora_tlpt_input_problems([attribute(entity_name, true)], Problems),
    Problems == [unknown_key(entity_name)].
test(a_term_that_is_not_an_attribute_list_is_wrong_type) :-
    findall(Problems, dora_tlpt_input_problems(not_a_list, Problems), Answers),
    Answers == [[wrong_type(profile)]].

test(the_not_listed_atom_is_not_the_listed_compound, fail) :-
    not_listed_for_tlpt = listed_for_tlpt(_).
test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2025_1190_art_2_9).

cp_test_names([the_verdict_term_carries_status_and_citations, the_identification_result_destructures, the_exclusion_result_destructures, the_indeterminate_status_holds_one_bare_key, the_listed_compound_unifies_with_its_own_form, the_grounds_are_distinct, the_frequencies_are_distinct, the_points_are_distinct, the_duty_results_are_distinct, the_duty_citation_is_recorded, the_identification_citation_is_recorded, the_list_citation_is_recorded, every_vocabulary_citation_is_recorded, a_recorded_key_is_implemented, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_float_figure_is_wrong_type, an_integer_figure_is_not_wrong_type, a_repeated_key_is_a_duplicate, a_key_outside_the_contract_is_unknown, a_term_that_is_not_an_attribute_list_is_wrong_type]).
cp_test_fail_names([the_not_listed_atom_is_not_the_listed_compound, an_unrecorded_key_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
