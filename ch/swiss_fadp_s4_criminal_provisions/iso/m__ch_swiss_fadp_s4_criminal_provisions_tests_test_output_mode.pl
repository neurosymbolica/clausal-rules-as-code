% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s4_criminal_provisions_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_swiss_fadp_s4_criminal_provisions, [decide_swiss_fadp_s4_criminal_provisions/2, swiss_fadp_s4_criminal_provisions_status/2, swiss_offence_punishable/3, swiss_prosecution_complaint_condition/3, swiss_prosecution_limitation/5, swiss_business_ordered_to_pay_fine/3, eu_administrative_fine_ceiling/3, compare_swiss_eu_fine_provided/5]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_fixtures, [swiss_fadp_s4_criminal_provisions_profile_for/2]).

offence_answer(Offence, Result) :-
    member(Offence, [article_60_1_a, article_60_1_b_1, article_60_1_b_2, article_60_2, article_61_a, article_61_b, article_61_c, article_62_1, article_62_2, article_63]),
    swiss_offence_punishable([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, true), attribute(examined_offence, Offence), attribute(offender_is_private_person, true)], Result, _).

complaint_answer(Offence, Result) :-
    member(Offence, [article_60_1_a, article_60_1_b_1, article_60_1_b_2, article_60_2, article_61_a, article_61_b, article_61_c, article_62_1, article_62_2, article_63]),
    swiss_prosecution_complaint_condition([attribute(examined_offence, Offence), attribute(criminal_complaint_filed, false)], Result, _).

test(every_offence_names_itself_once) :-
    findall(Offence - Result, offence_answer(Offence, Result), Answers),
    Answers == [article_60_1_a - punishable_by_fine_under_article_60_1_a, article_60_1_b_1 - punishable_by_fine_under_article_60_1_b_1, article_60_1_b_2 - punishable_by_fine_under_article_60_1_b_2, article_60_2 - punishable_by_fine_under_article_60_2, article_61_a - punishable_by_fine_under_article_61_a, article_61_b - punishable_by_fine_under_article_61_b, article_61_c - punishable_by_fine_under_article_61_c, article_62_1 - punishable_by_fine_under_article_62_1, article_62_2 - punishable_by_fine_under_article_62_2, article_63 - punishable_by_fine_under_article_63].
test(article_62_2_cites_paragraphs_one_two_and_three) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_62_2_after_training, Profile),
    findall(Result - Citations, swiss_offence_punishable(Profile, Result, Citations), Answers),
    Answers == [punishable_by_fine_under_article_62_2 - [cite(ch_fadp_art_62_1), cite(ch_fadp_art_62_2), cite(ch_fadp_art_62_3)]].
test(not_punishable_carries_all_fourteen_citations) :-
    swiss_fadp_s4_criminal_provisions_profile_for(not_wilful_article_62_2, Profile),
    findall(Citations, swiss_offence_punishable(Profile, not_punishable_under_examined_offence, Citations), [Citations]),
    length(Citations, 14).
test(missing_offence_is_asked_for) :-
    findall(Result, swiss_offence_punishable([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, true)], Result, _), Results),
    Results == [indeterminate([examined_offence])].
test(private_person_is_asked_for_a_private_person_offence) :-
    swiss_offence_punishable([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, true), attribute(examined_offence, article_61_a)], Result, Citations),
    Result == indeterminate([offender_is_private_person]),
    Citations == [].
test(unsure_private_person_is_not_read_for_article_62) :-
    swiss_offence_punishable([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, true), attribute(examined_offence, article_62_2), attribute(offender_is_private_person, unsure)], Result, _),
    Result == punishable_by_fine_under_article_62_2.
test(unsure_private_person_goes_to_review_for_article_60_2) :-
    swiss_offence_punishable([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, true), attribute(examined_offence, article_60_2), attribute(offender_is_private_person, unsure)], Result, Citations),
    Result == needs_legal_review(open_textured(offender_is_private_person, cite(ch_fadp_art_60_2)), [inputs_relied_on([conduct_meets_offence_description - true, acted_wilfully - true, examined_offence - article_60_2, offender_is_private_person - unsure])]),
    Citations == [].
test(article_62_referral_pairs_omit_the_private_person) :-
    swiss_offence_punishable([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, unsure), attribute(examined_offence, article_62_1), attribute(offender_is_private_person, true)], Result, _),
    Result == needs_legal_review(open_textured(acted_wilfully, cite(ch_fadp_art_62_1)), [inputs_relied_on([conduct_meets_offence_description - true, acted_wilfully - unsure, examined_offence - article_62_1])]).
test(facade_verdict_wraps_the_contract_answer) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_61_a, Profile),
    findall(Verdict, decide_swiss_fadp_s4_criminal_provisions(Profile, Verdict), Verdicts),
    Verdicts == [swiss_fadp_s4_criminal_provisions_verdict(punishable_by_fine_under_article_61_a, [cite(ch_fadp_art_61), cite(ch_fadp_art_61_a)])].
test(facade_status_on_the_empty_profile) :-
    swiss_fadp_s4_criminal_provisions_profile_for(empty_profile, Profile),
    findall(Status, swiss_fadp_s4_criminal_provisions_status(Profile, Status), Statuses),
    Statuses == [indeterminate([conduct_meets_offence_description])].
test(complaint_answer_for_every_offence) :-
    findall(Offence - Result, complaint_answer(Offence, Result), Answers),
    Answers == [article_60_1_a - complaint_offence_no_complaint_filed, article_60_1_b_1 - complaint_offence_no_complaint_filed, article_60_1_b_2 - complaint_offence_no_complaint_filed, article_60_2 - prosecuted_ex_officio, article_61_a - complaint_offence_no_complaint_filed, article_61_b - complaint_offence_no_complaint_filed, article_61_c - complaint_offence_no_complaint_filed, article_62_1 - complaint_offence_no_complaint_filed, article_62_2 - complaint_offence_no_complaint_filed, article_63 - prosecuted_ex_officio].
test(complaint_without_offence_asks_for_it) :-
    swiss_prosecution_complaint_condition([attribute(criminal_complaint_filed, true)], Result, Citations),
    Result == indeterminate([examined_offence]),
    Citations == [].
test(ex_officio_citations) :-
    swiss_fadp_s4_criminal_provisions_profile_for(ex_officio_article_60_2, Profile),
    swiss_prosecution_complaint_condition(Profile, prosecuted_ex_officio, Citations),
    Citations == [cite(ch_fadp_art_60_2), cite(ch_fadp_art_63)].
test(limitation_boundary_pair) :-
    findall(Result, swiss_prosecution_limitation([], date(2020, 3, 15), date(2025, 3, 15), Result, _), OnResults),
    OnResults == [five_year_limitation_period_not_expired],
    findall(Result, swiss_prosecution_limitation([], date(2020, 3, 15), date(2025, 3, 16), Result, _), AfterResults),
    AfterResults == [five_year_limitation_period_expired].
test(limitation_leap_day_boundary_pair) :-
    swiss_prosecution_limitation([], date(2016, 2, 29), date(2021, 2, 28), OnResult, _),
    OnResult == five_year_limitation_period_not_expired,
    swiss_prosecution_limitation([], date(2016, 2, 29), date(2021, 3, 1), AfterResult, _),
    AfterResult == five_year_limitation_period_expired.
test(limitation_leap_day_into_a_leap_year_keeps_29_february) :-
    swiss_prosecution_limitation([], date(2019, 2, 28), date(2024, 2, 29), Result, _),
    Result == five_year_limitation_period_expired,
    swiss_prosecution_limitation([], date(2020, 2, 29), date(2025, 2, 28), SecondResult, _),
    SecondResult == five_year_limitation_period_not_expired.
test(assessment_before_offence_is_not_expired) :-
    swiss_prosecution_limitation([], date(2020, 3, 15), date(2019, 1, 1), Result, Citations),
    Result == five_year_limitation_period_not_expired,
    Citations == [cite(ch_fadp_art_66)].
test(business_boundary_pair) :-
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50000, AtProfile),
    findall(Result, swiss_business_ordered_to_pay_fine(AtProfile, Result, _), AtResults),
    AtResults == [business_may_be_ordered_to_pay_fine],
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50001, OverProfile),
    findall(Result, swiss_business_ordered_to_pay_fine(OverProfile, Result, _), OverResults),
    OverResults == [business_substitution_not_available].
test(business_first_missing_key) :-
    swiss_business_ordered_to_pay_fine([attribute(fine_in_consideration_in_francs, 100)], Result, Citations),
    Result == indeterminate([offence_committed_in_business]),
    Citations == [].
test(business_unsure_goes_to_review) :-
    swiss_business_ordered_to_pay_fine([attribute(offence_committed_in_business, unsure), attribute(fine_in_consideration_in_francs, 100), attribute(identifying_punishable_persons_requires_disproportionate_investigation, true)], Result, _),
    Result == needs_legal_review(open_textured(offence_committed_in_business, cite(ch_fadp_art_64_2)), [inputs_relied_on([offence_committed_in_business - unsure, fine_in_consideration_in_francs - 100, identifying_punishable_persons_requires_disproportionate_investigation - true])]).
test(business_fine_over_settles_despite_unsure) :-
    swiss_business_ordered_to_pay_fine([attribute(offence_committed_in_business, unsure), attribute(fine_in_consideration_in_francs, 60000)], Result, _),
    Result == business_substitution_not_available.
test(eu_missing_keys_in_order) :-
    eu_administrative_fine_ceiling([], EmptyResult, _),
    EmptyResult == indeterminate([eu_infringement_established]),
    eu_administrative_fine_ceiling([attribute(eu_infringement_established, unsure)], UnsureResult, _),
    UnsureResult == indeterminate([eu_infringed_obligation_listed_in]).
test(eu_not_listed_settles) :-
    eu_administrative_fine_ceiling([attribute(eu_infringed_obligation_listed_in, not_listed_in_article_83_4_to_83_6)], Result, Citations),
    Result == no_administrative_fine_under_article_83_4_to_83_6,
    length(Citations, 11).
test(eu_unsure_goes_to_review) :-
    swiss_fadp_s4_criminal_provisions_profile_for(eu_listed_83_5_unsure_infringement, Profile),
    eu_administrative_fine_ceiling(Profile, Result, []),
    Result == needs_legal_review(open_textured(eu_infringement_established, cite(eu_reg_2016_679_art_83_5)), [inputs_relied_on([eu_infringement_established - unsure, eu_infringed_obligation_listed_in - listed_in_article_83_5_or_83_6])]).
test(comparison_differs_lists_the_fine_provisions) :-
    swiss_fadp_s4_criminal_provisions_profile_for(conduct_met_article_61_b, Profile),
    findall(Difference - ChangedBy, compare_swiss_eu_fine_provided(Profile, _, _, Difference, ChangedBy), Answers),
    Answers == [differs - [cite(ch_fadp_art_60_1), cite(ch_fadp_art_60_2), cite(ch_fadp_art_61), cite(ch_fadp_art_62_1), cite(ch_fadp_art_62_2), cite(ch_fadp_art_63), cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]].
test(comparison_referral_on_a_swiss_judgement_uses_the_fixed_citation) :-
    swiss_fadp_s4_criminal_provisions_profile_for(unsure_conduct_article_61_b, Profile),
    compare_swiss_eu_fine_provided(Profile, SwissSide, EuropeanSide, Difference, ChangedBy),
    SwissSide = needs_legal_review(open_textured(conduct_meets_offence_description, cite(ch_fadp_art_61_b)), _),
    EuropeanSide == no_administrative_fine_under_article_83_4_to_83_6,
    Difference = needs_legal_review(open_textured(conduct_meets_offence_description, cite(ch_fadp_art_60_to_63)), [inputs_relied_on(_)]),
    ChangedBy == [].

cp_test_names([every_offence_names_itself_once, article_62_2_cites_paragraphs_one_two_and_three, not_punishable_carries_all_fourteen_citations, missing_offence_is_asked_for, private_person_is_asked_for_a_private_person_offence, unsure_private_person_is_not_read_for_article_62, unsure_private_person_goes_to_review_for_article_60_2, article_62_referral_pairs_omit_the_private_person, facade_verdict_wraps_the_contract_answer, facade_status_on_the_empty_profile, complaint_answer_for_every_offence, complaint_without_offence_asks_for_it, ex_officio_citations, limitation_boundary_pair, limitation_leap_day_boundary_pair, limitation_leap_day_into_a_leap_year_keeps_29_february, assessment_before_offence_is_not_expired, business_boundary_pair, business_first_missing_key, business_unsure_goes_to_review, business_fine_over_settles_despite_unsure, eu_missing_keys_in_order, eu_not_listed_settles, eu_unsure_goes_to_review, comparison_differs_lists_the_fine_provisions, comparison_referral_on_a_swiss_judgement_uses_the_fixed_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
