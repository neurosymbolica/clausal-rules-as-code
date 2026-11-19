% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s4_criminal_provisions_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_swiss_fadp_s4_criminal_provisions, [swiss_fadp_s4_criminal_provisions_status/2, swiss_offence_punishable/3, swiss_prosecution_complaint_condition/3, swiss_prosecution_limitation/5, swiss_business_ordered_to_pay_fine/3, eu_administrative_fine_ceiling/3, compare_swiss_eu_fine_provided/5]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_kernel, [swiss_fadp_s4_criminal_provisions_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_fixtures, [swiss_fadp_s4_criminal_provisions_profile_for/2]).

test(bound_punishable_verdict_holds) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_63, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_63, [cite(ch_fadp_art_63)]).
test(bound_status_holds) :-
    swiss_fadp_s4_criminal_provisions_profile_for(private_person_false_article_63, Profile),
    swiss_fadp_s4_criminal_provisions_status(Profile, not_punishable_under_examined_offence).
test(bound_complaint_answer_holds) :-
    swiss_fadp_s4_criminal_provisions_profile_for(complaint_filed_article_61_c, Profile),
    swiss_prosecution_complaint_condition(Profile, complaint_offence_complaint_filed, _).
test(bound_limitation_answer_holds) :-
    swiss_prosecution_limitation([], date(2020, 3, 15), date(2025, 3, 15), five_year_limitation_period_not_expired, [cite(ch_fadp_art_66)]).
test(bound_business_answer_holds) :-
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50000, Profile),
    swiss_business_ordered_to_pay_fine(Profile, business_may_be_ordered_to_pay_fine, [cite(ch_fadp_art_64_2)]).
test(bound_eu_answer_holds) :-
    swiss_fadp_s4_criminal_provisions_profile_for(eu_listed_83_5_established, Profile),
    eu_administrative_fine_ceiling(Profile, fine_up_to_20_million_euro_or_4_percent_of_turnover, _).
test(bound_comparison_answer_holds) :-
    swiss_fadp_s4_criminal_provisions_profile_for(wilful_and_eu_ceiling, Profile),
    compare_swiss_eu_fine_provided(Profile, punishable_by_fine_under_article_62_1, fine_up_to_10_million_euro_or_2_percent_of_turnover, same, []).
test(unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, swiss_fadp_s4_criminal_provisions_input_problems(_Unbound, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(non_attribute_element_is_not_an_attribute_list) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(acted_wilfully, true), stray], Problems),
    Problems == [wrong_type(profile)].
test(non_atom_key_is_unknown) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(unsure_is_not_a_crisp_value) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(criminal_complaint_filed, unsure)], Problems),
    Problems == [wrong_type(criminal_complaint_filed)].
test(unsure_is_not_an_enumeration_value) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(examined_offence, unsure)], Problems),
    Problems == [wrong_type(examined_offence)].
test(negative_and_fractional_fines_are_wrong_type) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(fine_in_consideration_in_francs, -1)], NegativeProblems),
    NegativeProblems == [wrong_type(fine_in_consideration_in_francs)],
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(fine_in_consideration_in_francs, 1.5)], FractionProblems),
    FractionProblems == [wrong_type(fine_in_consideration_in_francs)].
test(problem_order_is_contract_keys_then_unknown_keys) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(colour, blue), attribute(eu_infringed_obligation_listed_in, elsewhere), attribute(acted_wilfully, maybe), attribute(acted_wilfully, true), attribute(colour, red), attribute(shape, round)], Problems),
    Problems == [duplicate_key(acted_wilfully), wrong_type(eu_infringed_obligation_listed_in), unknown_key(colour), unknown_key(shape)].
test(a_malformed_profile_gets_input_problems_from_every_query) :-
    swiss_fadp_s4_criminal_provisions_profile_for(malformed_duplicate_key, Profile),
    swiss_offence_punishable(Profile, OffenceResult, OffenceCitations),
    OffenceResult == input_problems([duplicate_key(acted_wilfully)]),
    OffenceCitations == [],
    swiss_prosecution_complaint_condition(Profile, ComplaintResult, []),
    ComplaintResult == input_problems([duplicate_key(acted_wilfully)]),
    swiss_business_ordered_to_pay_fine(Profile, BusinessResult, []),
    BusinessResult == input_problems([duplicate_key(acted_wilfully)]),
    eu_administrative_fine_ceiling(Profile, EuropeanResult, []),
    EuropeanResult == input_problems([duplicate_key(acted_wilfully)]),
    compare_swiss_eu_fine_provided(Profile, SwissSide, EuropeanSide, Difference, ChangedBy),
    SwissSide == input_problems([duplicate_key(acted_wilfully)]),
    EuropeanSide == input_problems([duplicate_key(acted_wilfully)]),
    Difference == input_problems([duplicate_key(acted_wilfully)]),
    ChangedBy == [].
test(malformed_dates_follow_the_profile_problems) :-
    swiss_prosecution_limitation([attribute(colour, blue)], stray, date(2025, 13, 1), Result, Citations),
    Result == input_problems([unknown_key(colour), wrong_type(offence_date), wrong_type(assessment_date)]),
    Citations == [].
test(a_29_february_in_a_common_year_is_not_a_date) :-
    swiss_prosecution_limitation([], date(2023, 2, 29), date(2025, 1, 1), Result, _),
    Result == input_problems([wrong_type(offence_date)]).

test(bound_wrong_verdict_is_rejected, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_63, Profile),
    swiss_offence_punishable(Profile, not_punishable_under_examined_offence, _).
test(bound_other_offence_status_is_rejected, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_63, Profile),
    swiss_fadp_s4_criminal_provisions_status(Profile, punishable_by_fine_under_article_60_2).
test(bound_ex_officio_is_rejected_for_a_complaint_offence, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(complaint_filed_article_61_c, Profile),
    swiss_prosecution_complaint_condition(Profile, prosecuted_ex_officio, _).
test(bound_expired_on_the_anniversary_is_rejected, fail) :-
    swiss_prosecution_limitation([], date(2020, 3, 15), date(2025, 3, 15), five_year_limitation_period_expired, _).
test(bound_lower_eu_ceiling_is_rejected, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(eu_listed_83_5_established, Profile),
    eu_administrative_fine_ceiling(Profile, fine_up_to_10_million_euro_or_2_percent_of_turnover, _).

cp_test_names([bound_punishable_verdict_holds, bound_status_holds, bound_complaint_answer_holds, bound_limitation_answer_holds, bound_business_answer_holds, bound_eu_answer_holds, bound_comparison_answer_holds, unbound_profile_is_not_an_attribute_list, non_attribute_element_is_not_an_attribute_list, non_atom_key_is_unknown, unsure_is_not_a_crisp_value, unsure_is_not_an_enumeration_value, negative_and_fractional_fines_are_wrong_type, problem_order_is_contract_keys_then_unknown_keys, a_malformed_profile_gets_input_problems_from_every_query, malformed_dates_follow_the_profile_problems, a_29_february_in_a_common_year_is_not_a_date]).
cp_test_fail_names([bound_wrong_verdict_is_rejected, bound_other_offence_status_is_rejected, bound_ex_officio_is_rejected_for_a_complaint_offence, bound_expired_on_the_anniversary_is_rejected, bound_lower_eu_ceiling_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
