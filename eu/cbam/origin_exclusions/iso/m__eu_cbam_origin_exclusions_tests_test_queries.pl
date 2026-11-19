% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_origin_exclusions_queries, [origin_exclusions_profile_keys/1, origin_exclusions_what_if/4, origin_exclusions_eligibility/2]).
:- use_module(m__eu_cbam_origin_exclusions_kernel, [origin_exclusions_input_problems/2]).
:- use_module(m__eu_cbam_origin_exclusions_origin_exclusions, [origin_exclusions_checklist/2]).
:- use_module(m__eu_cbam_origin_exclusions_fixtures, [origin_exclusions_profile_for/2]).

eligibilities_of(Subject, Eligibilities) :-
    origin_exclusions_profile_for(Subject, Profile),
    findall(Eligibility, origin_exclusions_eligibility(Profile, Eligibility), Eligibilities).

what_if_statuses(Subject, OverriddenKey, NewValue, Statuses) :-
    origin_exclusions_profile_for(Subject, Profile),
    findall(Status, origin_exclusions_what_if(Profile, OverriddenKey, NewValue, Status), Statuses).

cited_item(item(_, _, cite(_))).

test(profile_keys_are_the_contract_keys) :-
    origin_exclusions_profile_keys(ProfileKeys),
    ProfileKeys == [military_activities, non_preferential_origin, goods_kind, continental_shelf_or_eez_of].
test(input_check_through_the_query_layer) :-
    findall(Problems, origin_exclusions_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(input_check_well_formed_profile) :-
    origin_exclusions_profile_for(military_activities_no_control, Profile),
    origin_exclusions_input_problems(Profile, []).
test(eligibility_military_route) :-
    eligibilities_of(military_activities_yes, Eligibilities),
    Eligibilities == [eligible].
test(eligibility_listed_origin) :-
    eligibilities_of(origin_norway, Eligibilities),
    Eligibilities == [eligible].
test(eligibility_electricity_shelf) :-
    eligibilities_of(electricity_iceland_shelf, Eligibilities),
    Eligibilities == [eligible].
test(eligibility_hydrogen_zone) :-
    eligibilities_of(hydrogen_member_state_zone, Eligibilities),
    Eligibilities == [eligible].
test(eligibility_member_state_origin) :-
    eligibilities_of(member_state_origin, Eligibilities),
    Eligibilities == [eligible].
test(eligibility_no_exclusion) :-
    eligibilities_of(military_activities_no_control, Eligibilities),
    Eligibilities == [ineligible].
test(eligibility_missing_key) :-
    eligibilities_of(military_activities_unsure, Eligibilities),
    Eligibilities == [undetermined].
test(eligibility_input_problems) :-
    eligibilities_of(not_an_attribute_list_profile, Eligibilities),
    Eligibilities == [undetermined].
test(checklist_has_one_cited_row_per_limb) :-
    origin_exclusions_profile_for(military_activities_yes, Profile),
    origin_exclusions_checklist(Profile, Items),
    length(Items, 5),
    maplist(cited_item, Items),
    member(item(military_activities, met, cite(eu_reg_2023_956_art_2_3)), Items).
test(checklist_names_the_missing_key) :-
    origin_exclusions_profile_for(military_activities_unsure, Profile),
    origin_exclusions_checklist(Profile, Items),
    member(item(military_activities, unknown([military_activities]), cite(eu_reg_2023_956_art_2_3)), Items).
test(checklist_of_a_profile_with_input_problems_is_empty) :-
    origin_exclusions_profile_for(unknown_key_profile, Profile),
    findall(Items, origin_exclusions_checklist(Profile, Items), Checklists),
    Checklists == [[]].
test(what_if_military_yes_flips_to_military_exclusion) :-
    what_if_statuses(military_activities_no_control, military_activities, yes, Statuses),
    Statuses == [excluded_military_activities].
test(what_if_origin_switzerland_flips_to_origin_exclusion) :-
    what_if_statuses(military_activities_no_control, non_preferential_origin, switzerland, Statuses),
    Statuses == [excluded_origin_annex_iii_point_1].
test(what_if_supplies_the_missing_shelf) :-
    what_if_statuses(electricity_shelf_absent, continental_shelf_or_eez_of, member_state, Statuses),
    Statuses == [excluded_electricity_continental_shelf_or_eez].
test(what_if_unsure_to_no_settles_the_answer) :-
    what_if_statuses(military_activities_unsure, military_activities, no, Statuses),
    Statuses == [no_origin_exclusion].
test(what_if_repairs_a_duplicate_key) :-
    what_if_statuses(duplicate_key_profile, military_activities, yes, Statuses),
    Statuses == [excluded_military_activities].
test(what_if_with_a_bad_value_reports_it) :-
    what_if_statuses(military_activities_no_control, goods_kind, steel, Statuses),
    Statuses == [input_problems([wrong_type(goods_kind)])].
test(what_if_goods_kind_is_irrelevant_after_military_yes) :-
    what_if_statuses(military_activities_yes, goods_kind, hydrogen, Statuses),
    Statuses == [excluded_military_activities].

test(eligibility_no_exclusion_is_not_eligible, fail) :-
    origin_exclusions_profile_for(military_activities_no_control, Profile),
    origin_exclusions_eligibility(Profile, eligible).
test(what_if_military_no_does_not_exclude, fail) :-
    origin_exclusions_profile_for(military_activities_yes, Profile),
    origin_exclusions_what_if(Profile, military_activities, no, excluded_military_activities).

cp_test_names([profile_keys_are_the_contract_keys, input_check_through_the_query_layer, input_check_well_formed_profile, eligibility_military_route, eligibility_listed_origin, eligibility_electricity_shelf, eligibility_hydrogen_zone, eligibility_member_state_origin, eligibility_no_exclusion, eligibility_missing_key, eligibility_input_problems, checklist_has_one_cited_row_per_limb, checklist_names_the_missing_key, checklist_of_a_profile_with_input_problems_is_empty, what_if_military_yes_flips_to_military_exclusion, what_if_origin_switzerland_flips_to_origin_exclusion, what_if_supplies_the_missing_shelf, what_if_unsure_to_no_settles_the_answer, what_if_repairs_a_duplicate_key, what_if_with_a_bad_value_reports_it, what_if_goods_kind_is_irrelevant_after_military_yes]).
cp_test_fail_names([eligibility_no_exclusion_is_not_eligible, what_if_military_no_does_not_exclude]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
