% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s4_criminal_provisions_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_queries, [swiss_fadp_s4_criminal_provisions_profile_keys/1, swiss_fadp_s4_criminal_provisions_what_if/4, swiss_fadp_s4_criminal_provisions_business_threshold/1, swiss_prosecution_limitation_last_day/2, unsure/0, conduct_meets_offence_description/0, eu_infringed_obligation_listed_in/0, article_60_1_a/0, article_63/0, listed_in_article_83_4/0, not_listed_in_article_83_4_to_83_6/0]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_swiss_fadp_s4_criminal_provisions, [swiss_offence_punishable/3, compare_swiss_eu_fine_provided/5, swiss_fadp_s4_criminal_provisions_checklist/2]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_fixtures, [swiss_fadp_s4_criminal_provisions_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    swiss_fadp_s4_criminal_provisions_profile_keys(ProfileKeys),
    ProfileKeys == [conduct_meets_offence_description, acted_wilfully, examined_offence, offender_is_private_person, criminal_complaint_filed, offence_committed_in_business, fine_in_consideration_in_francs, identifying_punishable_persons_requires_disproportionate_investigation, eu_infringement_established, eu_infringed_obligation_listed_in].
test(root_atoms_are_served) :-
    unsure,
    conduct_meets_offence_description,
    eu_infringed_obligation_listed_in,
    article_60_1_a,
    article_63,
    listed_in_article_83_4,
    not_listed_in_article_83_4_to_83_6.
test(status_determination_names_the_offence) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_60_1_b_1, Profile),
    findall(Result - Citations, swiss_offence_punishable(Profile, Result, Citations), Answers),
    Answers == [punishable_by_fine_under_article_60_1_b_1 - [cite(ch_fadp_art_60_1), cite(ch_fadp_art_60_1_b), cite(ch_fadp_art_60_1_b_1)]].
test(comparison_sets_the_two_laws_side_by_side) :-
    swiss_fadp_s4_criminal_provisions_profile_for(wilful_and_eu_ceiling, Profile),
    findall(answer(SwissSide, EuropeanSide, Difference, ChangedBy), compare_swiss_eu_fine_provided(Profile, SwissSide, EuropeanSide, Difference, ChangedBy), Answers),
    Answers == [answer(punishable_by_fine_under_article_62_1, fine_up_to_10_million_euro_or_2_percent_of_turnover, same, [])].
test(comparison_on_the_empty_profile_asks_for_conduct) :-
    compare_swiss_eu_fine_provided([], SwissSide, EuropeanSide, Difference, ChangedBy),
    SwissSide == indeterminate([conduct_meets_offence_description]),
    EuropeanSide == indeterminate([eu_infringement_established]),
    Difference == indeterminate([conduct_meets_offence_description]),
    ChangedBy == [].
test(business_threshold_is_the_inclusive_flip_point) :-
    findall(Threshold, swiss_fadp_s4_criminal_provisions_business_threshold(Threshold), Thresholds),
    Thresholds = [threshold(fine_in_consideration_in_francs, MaximumFrancs, cite(ch_fadp_art_64_2))],
    MaximumFrancs =:= 50000.
test(checklist_items_each_carry_a_citation) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_63, Profile),
    swiss_fadp_s4_criminal_provisions_checklist(Profile, Items),
    Items == [item(offence_description, met, cite(ch_fadp_art_63)), item(wilful_conduct, met, cite(ch_fadp_art_63)), item(private_person, met, cite(ch_fadp_art_63))].
test(checklist_marks_the_private_person_inapplicable_for_article_62) :-
    swiss_fadp_s4_criminal_provisions_profile_for(wilful_and_eu_ceiling, Profile),
    swiss_fadp_s4_criminal_provisions_checklist(Profile, Items),
    member(item(private_person, inapplicable, cite(ch_fadp_art_62_1)), Items).
test(checklist_of_a_malformed_profile_reports_the_problem) :-
    swiss_fadp_s4_criminal_provisions_profile_for(malformed_duplicate_key, Profile),
    swiss_fadp_s4_criminal_provisions_checklist(Profile, Items),
    Items == [item(input_check, unmet(input_problems([duplicate_key(acted_wilfully)])), cite(ch_fadp_art_60_to_63))].
test(last_day_is_the_fifth_anniversary) :-
    findall(LastDay, swiss_prosecution_limitation_last_day(date(2021, 6, 30), LastDay), LastDays),
    LastDays == [date(2026, 6, 30)].
test(last_day_of_a_leap_day_offence) :-
    findall(LastDay, swiss_prosecution_limitation_last_day(date(2016, 2, 29), LastDay), LastDays),
    LastDays == [date(2021, 2, 28)].
test(what_if_wilful_turns_the_status) :-
    swiss_fadp_s4_criminal_provisions_profile_for(not_wilful_article_62_2, Profile),
    swiss_fadp_s4_criminal_provisions_what_if(Profile, acted_wilfully, true, Status),
    Status == punishable_by_fine_under_article_62_2.
test(what_if_overrides_every_duplicate) :-
    swiss_fadp_s4_criminal_provisions_profile_for(malformed_duplicate_key, Profile),
    findall(Status, swiss_fadp_s4_criminal_provisions_what_if(Profile, acted_wilfully, false, Status), Statuses),
    Statuses == [not_punishable_under_examined_offence].

test(malformed_offence_date_has_no_last_day, fail) :-
    swiss_prosecution_limitation_last_day(stray, _).

cp_test_names([profile_keys_are_the_contract_keys, root_atoms_are_served, status_determination_names_the_offence, comparison_sets_the_two_laws_side_by_side, comparison_on_the_empty_profile_asks_for_conduct, business_threshold_is_the_inclusive_flip_point, checklist_items_each_carry_a_citation, checklist_marks_the_private_person_inapplicable_for_article_62, checklist_of_a_malformed_profile_reports_the_problem, last_day_is_the_fifth_anniversary, last_day_of_a_leap_day_offence, what_if_wilful_turns_the_status, what_if_overrides_every_duplicate]).
cp_test_fail_names([malformed_offence_date_has_no_last_day]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
