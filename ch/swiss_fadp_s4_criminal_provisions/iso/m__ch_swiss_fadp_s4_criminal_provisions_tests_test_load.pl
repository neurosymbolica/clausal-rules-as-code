% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s4_criminal_provisions_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_kernel, [swiss_fadp_s4_criminal_provisions_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, swiss_fadp_s4_criminal_provisions_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, swiss_fadp_s4_criminal_provisions_input_problems([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, unsure), attribute(examined_offence, article_62_2), attribute(criminal_complaint_filed, false), attribute(fine_in_consideration_in_francs, 50000), attribute(eu_infringed_obligation_listed_in, listed_in_article_83_4)], Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, swiss_fadp_s4_criminal_provisions_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_holding_a_non_attribute_is_wrong_type_profile) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(acted_wilfully, true), stray_item], Problems),
    Problems == [wrong_type(profile)].
test(a_judgement_outside_its_type_is_wrong_type) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(acted_wilfully, maybe)], Problems),
    Problems == [wrong_type(acted_wilfully)].
test(unsure_is_not_a_crisp_value) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(criminal_complaint_filed, unsure)], Problems),
    Problems == [wrong_type(criminal_complaint_filed)].
test(a_negative_fine_is_wrong_type) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(fine_in_consideration_in_francs, -1)], Problems),
    Problems == [wrong_type(fine_in_consideration_in_francs)].
test(a_repeated_key_is_duplicate_key_only) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(acted_wilfully, true), attribute(acted_wilfully, maybe)], Problems),
    Problems == [duplicate_key(acted_wilfully)].
test(contract_problems_come_before_unknown_keys) :-
    swiss_fadp_s4_criminal_provisions_input_problems([attribute(stray_key, 1), attribute(examined_offence, article_99), attribute(stray_key, 2)], Problems),
    Problems == [wrong_type(examined_offence), unknown_key(stray_key)].
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = swiss_fadp_s4_criminal_provisions_verdict(punishable_by_fine_under_article_63, [cite(ch_fadp_art_63)]),
    Verdict = swiss_fadp_s4_criminal_provisions_verdict(Status, Citations),
    Status == punishable_by_fine_under_article_63,
    Citations == [cite(ch_fadp_art_63)].
test(the_referral_term_destructures) :-
    Referral = needs_legal_review(open_textured(acted_wilfully, cite(ch_fadp_art_63)), [inputs_relied_on([acted_wilfully - unsure, examined_offence - article_63])]),
    Referral = needs_legal_review(open_textured(Key, cite(CiteKey)), [inputs_relied_on(Pairs)]),
    Key == acted_wilfully,
    CiteKey == ch_fadp_art_63,
    Pairs == [acted_wilfully - unsure, examined_offence - article_63].
test(the_indeterminate_term_holds_one_key) :-
    Status = indeterminate([examined_offence]),
    Status = indeterminate([Key]),
    Key == examined_offence.
test(the_offence_verdicts_are_distinct) :-
    dif(punishable_by_fine_under_article_62_1, not_punishable_under_examined_offence),
    dif(punishable_by_fine_under_article_62_1, punishable_by_fine_under_article_62_2).
test(the_complaint_verdicts_are_distinct) :-
    dif(prosecuted_ex_officio, complaint_offence_complaint_filed),
    dif(complaint_offence_complaint_filed, complaint_offence_no_complaint_filed).
test(the_limitation_verdicts_are_distinct) :-
    dif(five_year_limitation_period_expired, five_year_limitation_period_not_expired).
test(the_business_verdicts_are_distinct) :-
    dif(business_may_be_ordered_to_pay_fine, business_substitution_not_available).
test(the_ceiling_verdicts_are_distinct) :-
    dif(fine_up_to_10_million_euro_or_2_percent_of_turnover, fine_up_to_20_million_euro_or_4_percent_of_turnover),
    dif(fine_up_to_20_million_euro_or_4_percent_of_turnover, no_administrative_fine_under_article_83_4_to_83_6).
test(the_comparison_verdicts_are_distinct) :-
    dif(same, differs).
test(the_limitation_citation_is_recorded) :-
    citation(ch_fadp_art_66, Record),
    Record = [label - _, ref - _, verbatim - Verbatim],
    Verbatim == 'Die Strafverfolgung verj\xE4\hrt nach f\xFC\nf Jahren.'.
test(the_business_citation_is_recorded) :-
    citation(ch_fadp_art_64_2, _).
test(the_eu_ceiling_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_83_5, _).
test(the_grouped_citation_has_no_verbatim) :-
    citation(ch_fadp_art_60_to_63, Record),
    Record = [label - _, ref - _].
test(implements_holds_for_a_recorded_key) :-
    implements(ch_fadp_art_60_1_b_2).

test(implements_fails_for_a_misspelt_key, fail) :-
    implements(ch_fadp_article_66).
test(a_misspelt_citation_is_not_recorded, fail) :-
    citation(ch_todo_primary_source, _).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_a_list_is_wrong_type_profile, a_list_holding_a_non_attribute_is_wrong_type_profile, a_judgement_outside_its_type_is_wrong_type, unsure_is_not_a_crisp_value, a_negative_fine_is_wrong_type, a_repeated_key_is_duplicate_key_only, contract_problems_come_before_unknown_keys, the_verdict_term_carries_status_and_citations, the_referral_term_destructures, the_indeterminate_term_holds_one_key, the_offence_verdicts_are_distinct, the_complaint_verdicts_are_distinct, the_limitation_verdicts_are_distinct, the_business_verdicts_are_distinct, the_ceiling_verdicts_are_distinct, the_comparison_verdicts_are_distinct, the_limitation_citation_is_recorded, the_business_citation_is_recorded, the_eu_ceiling_citation_is_recorded, the_grouped_citation_has_no_verbatim, implements_holds_for_a_recorded_key]).
cp_test_fail_names([implements_fails_for_a_misspelt_key, a_misspelt_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
