% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s4_criminal_provisions_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_swiss_fadp_s4_criminal_provisions, [swiss_fadp_s4_criminal_provisions_status_values/1, swiss_offence_punishable/3, swiss_prosecution_complaint_condition/3, swiss_prosecution_limitation/5, swiss_business_ordered_to_pay_fine/3, eu_administrative_fine_ceiling/3, compare_swiss_eu_fine_provided/5]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_kernel, [swiss_fadp_s4_criminal_provisions_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_fixtures, [swiss_fadp_s4_criminal_provisions_profile_for/2]).

test(the_status_table_holds_both_verdicts) :-
    swiss_fadp_s4_criminal_provisions_status_values(StatusValues),
    member(punishable_by_fine_under_article_63, StatusValues),
    member(not_punishable_under_examined_offence, StatusValues).
test(article_63_punishable) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_63, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_63, _).
test(article_63_near_miss_is_not_punishable) :-
    swiss_fadp_s4_criminal_provisions_profile_for(private_person_false_article_63, Profile),
    swiss_offence_punishable(Profile, not_punishable_under_examined_offence, _).
test(article_62_2_punishable) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_62_2_after_training, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_62_2, _).
test(article_62_2_near_miss_is_not_punishable) :-
    swiss_fadp_s4_criminal_provisions_profile_for(not_wilful_article_62_2, Profile),
    swiss_offence_punishable(Profile, not_punishable_under_examined_offence, _).
test(article_61_a_punishable) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_61_a, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_61_a, _).
test(article_61_a_public_body_is_not_punishable) :-
    swiss_fadp_s4_criminal_provisions_profile_for(public_body_article_61_a, Profile),
    swiss_offence_punishable(Profile, not_punishable_under_examined_offence, _).
test(article_60_1_b_1_punishable) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_60_1_b_1, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_60_1_b_1, _).
test(article_60_1_b_1_conduct_not_met_is_not_punishable) :-
    swiss_fadp_s4_criminal_provisions_profile_for(conduct_not_met_article_60_1_b_1, Profile),
    swiss_offence_punishable(Profile, not_punishable_under_examined_offence, _).
test(complaint_filed) :-
    swiss_fadp_s4_criminal_provisions_profile_for(complaint_filed_article_61_c, Profile),
    swiss_prosecution_complaint_condition(Profile, complaint_offence_complaint_filed, _).
test(complaint_missing_is_asked_for) :-
    swiss_fadp_s4_criminal_provisions_profile_for(complaint_missing_article_61_c, Profile),
    swiss_prosecution_complaint_condition(Profile, indeterminate([criminal_complaint_filed]), []).
test(complaint_not_filed) :-
    swiss_prosecution_complaint_condition([attribute(examined_offence, article_61_c), attribute(criminal_complaint_filed, false)], complaint_offence_no_complaint_filed, _).
test(article_60_2_is_ex_officio) :-
    swiss_fadp_s4_criminal_provisions_profile_for(ex_officio_article_60_2, Profile),
    swiss_prosecution_complaint_condition(Profile, prosecuted_ex_officio, _).
test(limitation_not_expired_on_the_anniversary) :-
    swiss_prosecution_limitation([], date(2021, 6, 30), date(2026, 6, 30), five_year_limitation_period_not_expired, _).
test(limitation_expired_the_day_after) :-
    swiss_prosecution_limitation([], date(2021, 6, 30), date(2026, 7, 1), five_year_limitation_period_expired, _).
test(business_at_50000_may_pay) :-
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50000, Profile),
    swiss_business_ordered_to_pay_fine(Profile, business_may_be_ordered_to_pay_fine, _).
test(business_at_50001_not_available) :-
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50001, Profile),
    swiss_business_ordered_to_pay_fine(Profile, business_substitution_not_available, _).
test(eu_established_gets_the_higher_ceiling) :-
    swiss_fadp_s4_criminal_provisions_profile_for(eu_listed_83_5_established, Profile),
    eu_administrative_fine_ceiling(Profile, fine_up_to_20_million_euro_or_4_percent_of_turnover, _).
test(eu_unsure_is_referred) :-
    swiss_fadp_s4_criminal_provisions_profile_for(eu_listed_83_5_unsure_infringement, Profile),
    eu_administrative_fine_ceiling(Profile, needs_legal_review(open_textured(eu_infringement_established, cite(eu_reg_2016_679_art_83_5)), _), []).
test(comparison_same) :-
    swiss_fadp_s4_criminal_provisions_profile_for(wilful_and_eu_ceiling, Profile),
    compare_swiss_eu_fine_provided(Profile, _, _, same, []).
test(comparison_differs) :-
    swiss_fadp_s4_criminal_provisions_profile_for(not_wilful_but_eu_ceiling, Profile),
    compare_swiss_eu_fine_provided(Profile, not_punishable_under_examined_offence, fine_up_to_20_million_euro_or_4_percent_of_turnover, differs, [_|_]).
test(unsure_conduct_is_referred) :-
    swiss_fadp_s4_criminal_provisions_profile_for(unsure_conduct_article_61_b, Profile),
    swiss_offence_punishable(Profile, Result, []),
    Result == needs_legal_review(open_textured(conduct_meets_offence_description, cite(ch_fadp_art_61_b)), [inputs_relied_on([conduct_meets_offence_description - unsure, acted_wilfully - true, examined_offence - article_61_b, offender_is_private_person - true])]).
test(conduct_met_is_punishable) :-
    swiss_fadp_s4_criminal_provisions_profile_for(conduct_met_article_61_b, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_61_b, _).
test(duplicate_key_is_a_problem) :-
    swiss_fadp_s4_criminal_provisions_profile_for(malformed_duplicate_key, Profile),
    swiss_fadp_s4_criminal_provisions_input_problems(Profile, [duplicate_key(acted_wilfully)]).
test(single_key_has_no_problem) :-
    swiss_fadp_s4_criminal_provisions_profile_for(single_key_control, Profile),
    swiss_fadp_s4_criminal_provisions_input_problems(Profile, []).

test(article_63_near_miss_gets_no_fine, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(private_person_false_article_63, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_63, _).
test(article_62_2_near_miss_gets_no_fine, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(not_wilful_article_62_2, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_62_2, _).
test(article_61_a_public_body_gets_no_fine, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(public_body_article_61_a, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_61_a, _).
test(article_60_1_b_1_conduct_not_met_gets_no_fine, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(conduct_not_met_article_60_1_b_1, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_60_1_b_1, _).
test(complaint_missing_is_not_filed, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(complaint_missing_article_61_c, Profile),
    swiss_prosecution_complaint_condition(Profile, complaint_offence_complaint_filed, _).
test(article_61_c_is_not_ex_officio, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(complaint_missing_article_61_c, Profile),
    swiss_prosecution_complaint_condition(Profile, prosecuted_ex_officio, _).
test(limitation_not_expired_the_day_after_is_false, fail) :-
    swiss_prosecution_limitation([], date(2021, 6, 30), date(2026, 7, 1), five_year_limitation_period_not_expired, _).
test(business_at_50001_may_not_pay, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50001, Profile),
    swiss_business_ordered_to_pay_fine(Profile, business_may_be_ordered_to_pay_fine, _).
test(eu_unsure_gets_no_ceiling, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(eu_listed_83_5_unsure_infringement, Profile),
    eu_administrative_fine_ceiling(Profile, fine_up_to_20_million_euro_or_4_percent_of_turnover, _).
test(comparison_differs_is_not_same, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(not_wilful_but_eu_ceiling, Profile),
    compare_swiss_eu_fine_provided(Profile, _, _, same, _).
test(unsure_conduct_gets_no_fine, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(unsure_conduct_article_61_b, Profile),
    swiss_offence_punishable(Profile, punishable_by_fine_under_article_61_b, _).
test(single_key_is_not_a_duplicate, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(single_key_control, Profile),
    swiss_fadp_s4_criminal_provisions_input_problems(Profile, [duplicate_key(acted_wilfully)]).

cp_test_names([the_status_table_holds_both_verdicts, article_63_punishable, article_63_near_miss_is_not_punishable, article_62_2_punishable, article_62_2_near_miss_is_not_punishable, article_61_a_punishable, article_61_a_public_body_is_not_punishable, article_60_1_b_1_punishable, article_60_1_b_1_conduct_not_met_is_not_punishable, complaint_filed, complaint_missing_is_asked_for, complaint_not_filed, article_60_2_is_ex_officio, limitation_not_expired_on_the_anniversary, limitation_expired_the_day_after, business_at_50000_may_pay, business_at_50001_not_available, eu_established_gets_the_higher_ceiling, eu_unsure_is_referred, comparison_same, comparison_differs, unsure_conduct_is_referred, conduct_met_is_punishable, duplicate_key_is_a_problem, single_key_has_no_problem]).
cp_test_fail_names([article_63_near_miss_gets_no_fine, article_62_2_near_miss_gets_no_fine, article_61_a_public_body_gets_no_fine, article_60_1_b_1_conduct_not_met_gets_no_fine, complaint_missing_is_not_filed, article_61_c_is_not_ex_officio, limitation_not_expired_the_day_after_is_false, business_at_50001_may_not_pay, eu_unsure_gets_no_ceiling, comparison_differs_is_not_same, unsure_conduct_gets_no_fine, single_key_is_not_a_duplicate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
