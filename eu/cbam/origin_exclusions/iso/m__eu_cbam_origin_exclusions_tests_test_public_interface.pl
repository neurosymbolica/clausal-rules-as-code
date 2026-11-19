% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_cbam_origin_exclusions_origin_exclusions, [origin_exclusion/3, decide_origin_exclusions/2, origin_exclusions_status/2, origin_exclusions_checklist/2, origin_exclusions_decision_resolvable/1, origin_exclusions_status_values/1]).
:- use_module(m__eu_cbam_origin_exclusions_fixtures, [origin_exclusions_subject/1, origin_exclusions_profile_for/2, origin_exclusions_assess/2]).
:- use_module(m__eu_cbam_origin_exclusions_queries, [origin_exclusions_eligibility/2, origin_exclusions_what_if/4]).
:- use_module(m__eu_cbam_origin_exclusions_kernel, [origin_exclusions_input_problems/2]).

expected_status(military_activities_yes, excluded_military_activities).
expected_status(military_activities_no_control, no_origin_exclusion).
expected_status(origin_norway, excluded_origin_annex_iii_point_1).
expected_status(origin_switzerland, excluded_origin_annex_iii_point_1).
expected_status(origin_busingen, excluded_origin_annex_iii_point_1).
expected_status(origin_other_third_country_control, no_origin_exclusion).
expected_status(electricity_member_state_shelf, excluded_electricity_continental_shelf_or_eez).
expected_status(electricity_other_third_country_shelf_control, no_origin_exclusion).
expected_status(electricity_iceland_shelf, excluded_electricity_continental_shelf_or_eez).
expected_status(electricity_not_on_shelf_control, no_origin_exclusion).
expected_status(hydrogen_member_state_zone, excluded_hydrogen_continental_shelf_or_eez).
expected_status(hydrogen_other_third_country_zone_control, no_origin_exclusion).
expected_status(hydrogen_liechtenstein_shelf, excluded_hydrogen_continental_shelf_or_eez).
expected_status(other_goods_liechtenstein_shelf_control, no_origin_exclusion).
expected_status(member_state_origin, not_third_country_origin).
expected_status(military_activities_absent, indeterminate([military_activities])).
expected_status(military_activities_unsure, indeterminate([military_activities])).
expected_status(origin_absent, indeterminate([non_preferential_origin])).
expected_status(goods_kind_absent_member_state_shelf, indeterminate([goods_kind])).
expected_status(goods_kind_absent_not_on_shelf_control, no_origin_exclusion).
expected_status(electricity_shelf_absent, indeterminate([continental_shelf_or_eez_of])).
expected_status(other_goods_shelf_absent_control, no_origin_exclusion).
expected_status(norway_origin_military_absent, excluded_origin_annex_iii_point_1).
expected_status(norway_hydrogen_norway_shelf, excluded_origin_annex_iii_point_1).
expected_status(unknown_key_profile, input_problems([unknown_key(colour)])).
expected_status(duplicate_key_profile, input_problems([duplicate_key(military_activities)])).
expected_status(wrong_type_profile, input_problems([wrong_type(military_activities)])).
expected_status(not_an_attribute_list_profile, input_problems([wrong_type(profile)])).

expected_eligibility(Subject, Eligibility) :-
    expected_status(Subject, Status),
    status_eligibility(Status, Eligibility).

status_eligibility(no_origin_exclusion, ineligible).
status_eligibility(indeterminate(_), undetermined).
status_eligibility(input_problems(_), undetermined).
status_eligibility(Status, eligible) :-
    atom(Status),
    dif(Status, no_origin_exclusion).

status_kind(Status, final) :-
    atom(Status).
status_kind(indeterminate(_), judged_not_final).
status_kind(input_problems(_), refused).

near_miss(military_activities_yes, military_activities_no_control).
near_miss(origin_norway, origin_other_third_country_control).
near_miss(electricity_member_state_shelf, electricity_other_third_country_shelf_control).
near_miss(electricity_iceland_shelf, electricity_not_on_shelf_control).
near_miss(hydrogen_member_state_zone, hydrogen_other_third_country_zone_control).
near_miss(hydrogen_liechtenstein_shelf, other_goods_liechtenstein_shelf_control).
near_miss(member_state_origin, origin_other_third_country_control).
near_miss(military_activities_absent, military_activities_no_control).
near_miss(military_activities_unsure, military_activities_no_control).
near_miss(origin_absent, origin_other_third_country_control).
near_miss(goods_kind_absent_member_state_shelf, goods_kind_absent_not_on_shelf_control).
near_miss(electricity_shelf_absent, other_goods_shelf_absent_control).
near_miss(unknown_key_profile, military_activities_no_control).
near_miss(duplicate_key_profile, military_activities_no_control).
near_miss(wrong_type_profile, military_activities_no_control).

subject_eligibility(Subject, Eligibility) :-
    origin_exclusions_profile_for(Subject, Profile),
    origin_exclusions_eligibility(Profile, Eligibility).

opposite_eligibility(_ - _ - PositiveEligibility - ControlEligibility) :-
    dif(PositiveEligibility, ControlEligibility).

test(every_subject_resolves_to_its_expected_status_once) :-
    findall(Subject - Status, (origin_exclusions_subject(Subject), origin_exclusions_assess(Subject, origin_exclusions_verdict(Status, _))), Pairs),
    findall(Subject - Status, expected_status(Subject, Status), Expected),
    clausal_msort(Pairs, SortedPairs),
    clausal_msort(Expected, SortedExpected),
    SortedPairs == SortedExpected.
test(every_subject_has_its_expected_eligibility_once) :-
    findall(Subject - Eligibility, (origin_exclusions_subject(Subject), subject_eligibility(Subject, Eligibility)), Pairs),
    findall(Subject - Eligibility, (origin_exclusions_subject(Subject), expected_eligibility(Subject, Eligibility)), Expected),
    clausal_msort(Pairs, SortedPairs),
    clausal_msort(Expected, SortedExpected),
    SortedPairs == SortedExpected.
test(near_miss_controls_get_the_opposite_eligibility) :-
    findall(Positive - Control - PositiveEligibility - ControlEligibility, (near_miss(Positive, Control), subject_eligibility(Positive, PositiveEligibility), subject_eligibility(Control, ControlEligibility)), Rows),
    findall(Positive, near_miss(Positive, _), Positives),
    length(Positives, Count),
    length(Rows, Count),
    maplist(opposite_eligibility, Rows).
test(final_answers_are_cited_and_others_are_not) :-
    findall(Subject, (expected_status(Subject, Status), status_kind(Status, final)), Finals),
    findall(Subject, (origin_exclusions_subject(Subject), origin_exclusions_assess(Subject, origin_exclusions_verdict(_, [_|_]))), Cited),
    clausal_msort(Finals, SortedFinals),
    clausal_msort(Cited, SortedCited),
    SortedFinals == SortedCited.
test(final_statuses_are_in_the_vocabulary) :-
    origin_exclusions_status_values(StatusValues),
    findall(Status, (origin_exclusions_subject(Subject), origin_exclusions_assess(Subject, origin_exclusions_verdict(Status, _)), atom(Status)), Statuses),
    sort(Statuses, Distinct),
    clausal_msort(StatusValues, SortedValues),
    Distinct == SortedValues.
test(judged_profiles_have_a_non_empty_checklist) :-
    findall(Subject, (expected_status(Subject, Status), status_kind(Status, Kind), dif(Kind, refused)), Judged),
    findall(Subject, (origin_exclusions_subject(Subject), origin_exclusions_profile_for(Subject, Profile), origin_exclusions_checklist(Profile, [_|_])), WithItems),
    clausal_msort(Judged, SortedJudged),
    clausal_msort(WithItems, SortedWithItems),
    SortedJudged == SortedWithItems.
test(refused_profiles_have_an_empty_checklist) :-
    findall(Subject, (expected_status(Subject, Status), status_kind(Status, refused)), Refused),
    findall(Subject, (origin_exclusions_subject(Subject), origin_exclusions_profile_for(Subject, Profile), origin_exclusions_checklist(Profile, [])), Empty),
    clausal_msort(Refused, SortedRefused),
    clausal_msort(Empty, SortedEmpty),
    SortedRefused == SortedEmpty.
test(every_subject_is_resolvable) :-
    findall(Subject, (origin_exclusions_subject(Subject), origin_exclusions_profile_for(Subject, Profile), origin_exclusions_decision_resolvable(Profile)), Resolved),
    findall(Subject, origin_exclusions_subject(Subject), Subjects),
    clausal_msort(Resolved, SortedResolved),
    clausal_msort(Subjects, SortedSubjects),
    SortedResolved == SortedSubjects.
test(military_yes_answer_and_citations) :-
    origin_exclusions_profile_for(military_activities_yes, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [excluded_military_activities - [cite(eu_reg_2023_956_art_2_3)]].
test(military_no_control_answer_and_citations) :-
    origin_exclusions_profile_for(military_activities_no_control, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [no_origin_exclusion - [cite(eu_reg_2023_956_art_2_3), cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_annex_3_1)]].
test(norway_origin_answer_and_citations) :-
    origin_exclusions_profile_for(origin_norway, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [excluded_origin_annex_iii_point_1 - [cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_annex_3_1)]].
test(electricity_member_state_shelf_citations) :-
    origin_exclusions_profile_for(electricity_member_state_shelf, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [excluded_electricity_continental_shelf_or_eez - [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_a), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9)]].
test(electricity_iceland_shelf_cites_annex_iii_point_1) :-
    origin_exclusions_profile_for(electricity_iceland_shelf, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [excluded_electricity_continental_shelf_or_eez - [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_a), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9), cite(eu_reg_2023_956_annex_3_1)]].
test(hydrogen_member_state_zone_citations) :-
    origin_exclusions_profile_for(hydrogen_member_state_zone, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [excluded_hydrogen_continental_shelf_or_eez - [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_b), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9)]].
test(hydrogen_liechtenstein_shelf_citations) :-
    origin_exclusions_profile_for(hydrogen_liechtenstein_shelf, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [excluded_hydrogen_continental_shelf_or_eez - [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_b), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9), cite(eu_reg_2023_956_annex_3_1)]].
test(member_state_origin_citations) :-
    origin_exclusions_profile_for(member_state_origin, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [not_third_country_origin - [cite(eu_reg_2023_956_art_2_1), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_art_3_7)]].
test(unsure_military_asks_for_military_activities) :-
    origin_exclusions_profile_for(military_activities_unsure, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [indeterminate([military_activities]) - []].
test(norway_hydrogen_gives_only_the_origin_exclusion) :-
    origin_exclusions_profile_for(norway_hydrogen_norway_shelf, Profile),
    findall(Result, origin_exclusion(Profile, Result, _), Results),
    Results == [excluded_origin_annex_iii_point_1].
test(unknown_key_answer) :-
    origin_exclusions_profile_for(unknown_key_profile, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(input_check_returns_the_bare_list) :-
    origin_exclusions_profile_for(duplicate_key_profile, Profile),
    findall(Problems, origin_exclusions_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(military_activities)]].
test(input_check_is_empty_for_a_good_profile) :-
    origin_exclusions_profile_for(military_activities_no_control, Profile),
    findall(Problems, origin_exclusions_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(status_projection_through_the_facade) :-
    origin_exclusions_profile_for(origin_switzerland, Profile),
    findall(Status, origin_exclusions_status(Profile, Status), Statuses),
    Statuses == [excluded_origin_annex_iii_point_1].
test(facade_verdict_term) :-
    origin_exclusions_profile_for(origin_busingen, Profile),
    decide_origin_exclusions(Profile, origin_exclusions_verdict(excluded_origin_annex_iii_point_1, [_|_])).
test(checklist_marks_military_met) :-
    origin_exclusions_profile_for(military_activities_yes, Profile),
    origin_exclusions_checklist(Profile, Items),
    member(item(military_activities, met, cite(eu_reg_2023_956_art_2_3)), Items).
test(checklist_marks_unsure_military_unknown) :-
    origin_exclusions_profile_for(military_activities_unsure, Profile),
    origin_exclusions_checklist(Profile, Items),
    member(item(military_activities, unknown([military_activities]), cite(eu_reg_2023_956_art_2_3)), Items).
test(eligibility_of_the_military_subject) :-
    subject_eligibility(military_activities_yes, eligible).
test(eligibility_of_the_control) :-
    subject_eligibility(military_activities_no_control, ineligible).
test(what_if_the_control_were_military) :-
    origin_exclusions_profile_for(military_activities_no_control, Profile),
    findall(Status, origin_exclusions_what_if(Profile, military_activities, yes, Status), Statuses),
    Statuses == [excluded_military_activities].

test(military_no_control_is_not_excluded, fail) :-
    origin_exclusions_profile_for(military_activities_no_control, Profile),
    origin_exclusion(Profile, excluded_military_activities, _).
test(norway_hydrogen_is_not_the_hydrogen_exclusion, fail) :-
    origin_exclusions_profile_for(norway_hydrogen_norway_shelf, Profile),
    origin_exclusion(Profile, excluded_hydrogen_continental_shelf_or_eez, _).
test(eligibility_of_the_control_is_not_eligible, fail) :-
    subject_eligibility(military_activities_no_control, eligible).

cp_test_names([every_subject_resolves_to_its_expected_status_once, every_subject_has_its_expected_eligibility_once, near_miss_controls_get_the_opposite_eligibility, final_answers_are_cited_and_others_are_not, final_statuses_are_in_the_vocabulary, judged_profiles_have_a_non_empty_checklist, refused_profiles_have_an_empty_checklist, every_subject_is_resolvable, military_yes_answer_and_citations, military_no_control_answer_and_citations, norway_origin_answer_and_citations, electricity_member_state_shelf_citations, electricity_iceland_shelf_cites_annex_iii_point_1, hydrogen_member_state_zone_citations, hydrogen_liechtenstein_shelf_citations, member_state_origin_citations, unsure_military_asks_for_military_activities, norway_hydrogen_gives_only_the_origin_exclusion, unknown_key_answer, input_check_returns_the_bare_list, input_check_is_empty_for_a_good_profile, status_projection_through_the_facade, facade_verdict_term, checklist_marks_military_met, checklist_marks_unsure_military_unknown, eligibility_of_the_military_subject, eligibility_of_the_control, what_if_the_control_were_military]).
cp_test_fail_names([military_no_control_is_not_excluded, norway_hydrogen_is_not_the_hydrogen_exclusion, eligibility_of_the_control_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
