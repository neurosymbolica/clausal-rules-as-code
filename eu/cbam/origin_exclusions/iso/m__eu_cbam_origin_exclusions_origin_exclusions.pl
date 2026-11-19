% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions_origin_exclusions, [origin_exclusion/3, decide_origin_exclusions/2, origin_exclusions_status/2, origin_exclusions_checklist/2, origin_exclusions_decision_resolvable/1, origin_exclusions_status_values/1, excluded_military_activities/0, excluded_origin_annex_iii_point_1/0, excluded_electricity_continental_shelf_or_eez/0, excluded_hydrogen_continental_shelf_or_eez/0, not_third_country_origin/0, no_origin_exclusion/0, indeterminate/1, input_problems/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_cbam_origin_exclusions_kernel, [origin_exclusions_input_problems/2]).
:- use_module(m__eu_cbam_origin_exclusions_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

excluded_military_activities.

excluded_origin_annex_iii_point_1.

excluded_electricity_continental_shelf_or_eez.

excluded_hydrogen_continental_shelf_or_eez.

not_third_country_origin.

no_origin_exclusion.

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

input_problems(Problems) :-
    clausal_is_list(Problems).

annex_iii_point_1_listed(iceland, cite(eu_reg_2023_956_annex_3_1)).
annex_iii_point_1_listed(liechtenstein, cite(eu_reg_2023_956_annex_3_1)).
annex_iii_point_1_listed(norway, cite(eu_reg_2023_956_annex_3_1)).
annex_iii_point_1_listed(switzerland, cite(eu_reg_2023_956_annex_3_1)).
annex_iii_point_1_listed(busingen, cite(eu_reg_2023_956_annex_3_1)).
annex_iii_point_1_listed(heligoland, cite(eu_reg_2023_956_annex_3_1)).
annex_iii_point_1_listed(livigno, cite(eu_reg_2023_956_annex_3_1)).
annex_iii_point_1_listed(ceuta, cite(eu_reg_2023_956_annex_3_1)).
annex_iii_point_1_listed(melilla, cite(eu_reg_2023_956_annex_3_1)).

origin_exclusions_status_values([excluded_military_activities, excluded_origin_annex_iii_point_1, excluded_electricity_continental_shelf_or_eez, excluded_hydrogen_continental_shelf_or_eez, not_third_country_origin, no_origin_exclusion]).

key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_state(Profile, ProfileKey, value(Value)) :-
    profile_get(Profile, ProfileKey, Value).

profile_states(Profile, MilitaryState, OriginClass, GoodsKind, ShelfGroup) :-
    key_state(Profile, military_activities, MilitaryKeyState),
    military_state(MilitaryKeyState, MilitaryState),
    key_state(Profile, non_preferential_origin, OriginKeyState),
    origin_state(OriginKeyState, OriginClass),
    key_state(Profile, goods_kind, GoodsKindKeyState),
    goods_kind_state(GoodsKindKeyState, GoodsKind),
    key_state(Profile, continental_shelf_or_eez_of, ShelfKeyState),
    shelf_state(ShelfKeyState, ShelfGroup).

military_state(absent, absent).
military_state(value(Value), MilitaryState) :-
    military_value_state(Value, MilitaryState).

military_value_state(yes, yes).
military_value_state(no, no).
military_value_state(unsure, absent).

origin_state(absent, absent).
origin_state(value(Value), OriginClass) :-
    place_class(Value, OriginClass).

place_class(member_state, member_state).
place_class(other_third_country, other_third_country).
place_class(Place, listed) :-
    implements(eu_reg_2023_956_annex_3_1),
    annex_iii_point_1_listed(Place, _).

goods_kind_state(absent, absent).
goods_kind_state(value(Value), Value).

shelf_state(absent, absent).
shelf_state(value(not_on_continental_shelf_or_eez), outside).
shelf_state(value(Place), ShelfGroup) :-
    dif(Place, not_on_continental_shelf_or_eez),
    place_class(Place, PlaceClass),
    shelf_group(PlaceClass, ShelfGroup).

shelf_group(member_state, member_state).
shelf_group(listed, listed).
shelf_group(other_third_country, outside).

zone_route(electricity, member_state, electricity_member_state) :-
    implements(eu_reg_2023_956_art_2_3a_a).
zone_route(electricity, listed, electricity_listed) :-
    implements(eu_reg_2023_956_art_2_3a_a).
zone_route(hydrogen, member_state, hydrogen_member_state) :-
    implements(eu_reg_2023_956_art_2_3a_b).
zone_route(hydrogen, listed, hydrogen_listed) :-
    implements(eu_reg_2023_956_art_2_3a_b).
zone_route(GoodsKind, ShelfGroup, none) :-
    implements(eu_reg_2023_956_art_2_3a),
    zone_goods_kind(GoodsKind),
    non_qualifying_shelf(ShelfGroup).
zone_route(GoodsKind, _, none) :-
    implements(eu_reg_2023_956_art_2_3a),
    non_zone_goods_kind(GoodsKind).

zone_goods_kind(electricity).
zone_goods_kind(hydrogen).

non_zone_goods_kind(other_annex_i_goods).
non_zone_goods_kind(absent).

non_qualifying_shelf(outside).
non_qualifying_shelf(absent).

qualifying_shelf(member_state).
qualifying_shelf(listed).

not_yes(no).
not_yes(absent).

unlisted_origin(member_state).
unlisted_origin(other_third_country).
unlisted_origin(absent).

remaining_origin(other_third_country).
remaining_origin(absent).

goods_kind_relevant_shelf(absent).
goods_kind_relevant_shelf(member_state).
goods_kind_relevant_shelf(listed).

settled_without_exclusion(other_annex_i_goods, _).
settled_without_exclusion(absent, outside).
settled_without_exclusion(GoodsKind, outside) :-
    zone_goods_kind(GoodsKind).

limb(yes, _, _, _, origin_exclusions_verdict(excluded_military_activities, [cite(eu_reg_2023_956_art_2_3)])) :-
    implements(eu_reg_2023_956_art_2_3).
limb(MilitaryState, listed, _, _, origin_exclusions_verdict(excluded_origin_annex_iii_point_1, [cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_annex_3_1)])) :-
    implements(eu_reg_2023_956_art_2_4),
    not_yes(MilitaryState).
limb(MilitaryState, OriginClass, GoodsKind, ShelfGroup, origin_exclusions_verdict(excluded_electricity_continental_shelf_or_eez, [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_a), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9)])) :-
    implements(eu_reg_2023_956_art_2_3a_a),
    not_yes(MilitaryState),
    unlisted_origin(OriginClass),
    zone_route(GoodsKind, ShelfGroup, electricity_member_state).
limb(MilitaryState, OriginClass, GoodsKind, ShelfGroup, origin_exclusions_verdict(excluded_electricity_continental_shelf_or_eez, [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_a), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9), cite(eu_reg_2023_956_annex_3_1)])) :-
    implements(eu_reg_2023_956_art_2_3a_a),
    not_yes(MilitaryState),
    unlisted_origin(OriginClass),
    zone_route(GoodsKind, ShelfGroup, electricity_listed).
limb(MilitaryState, OriginClass, GoodsKind, ShelfGroup, origin_exclusions_verdict(excluded_hydrogen_continental_shelf_or_eez, [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_b), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9)])) :-
    implements(eu_reg_2023_956_art_2_3a_b),
    not_yes(MilitaryState),
    unlisted_origin(OriginClass),
    zone_route(GoodsKind, ShelfGroup, hydrogen_member_state).
limb(MilitaryState, OriginClass, GoodsKind, ShelfGroup, origin_exclusions_verdict(excluded_hydrogen_continental_shelf_or_eez, [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_b), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9), cite(eu_reg_2023_956_annex_3_1)])) :-
    implements(eu_reg_2023_956_art_2_3a_b),
    not_yes(MilitaryState),
    unlisted_origin(OriginClass),
    zone_route(GoodsKind, ShelfGroup, hydrogen_listed).
limb(MilitaryState, member_state, GoodsKind, ShelfGroup, origin_exclusions_verdict(not_third_country_origin, [cite(eu_reg_2023_956_art_2_1), cite(eu_reg_2023_956_art_2_5), cite(eu_reg_2023_956_art_3_7)])) :-
    implements(eu_reg_2023_956_art_3_7),
    not_yes(MilitaryState),
    zone_route(GoodsKind, ShelfGroup, none).
limb(absent, OriginClass, GoodsKind, ShelfGroup, origin_exclusions_verdict(indeterminate([military_activities]), [])) :-
    remaining_origin(OriginClass),
    zone_route(GoodsKind, ShelfGroup, none).
limb(no, absent, GoodsKind, ShelfGroup, origin_exclusions_verdict(indeterminate([non_preferential_origin]), [])) :-
    zone_route(GoodsKind, ShelfGroup, none).
limb(no, other_third_country, absent, ShelfGroup, origin_exclusions_verdict(indeterminate([goods_kind]), [])) :-
    goods_kind_relevant_shelf(ShelfGroup).
limb(no, other_third_country, GoodsKind, absent, origin_exclusions_verdict(indeterminate([continental_shelf_or_eez_of]), [])) :-
    zone_goods_kind(GoodsKind).
limb(no, other_third_country, GoodsKind, ShelfGroup, origin_exclusions_verdict(no_origin_exclusion, [cite(eu_reg_2023_956_art_2_3), cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_4), cite(eu_reg_2023_956_annex_3_1)])) :-
    implements(eu_reg_2023_956_art_2_4),
    settled_without_exclusion(GoodsKind, ShelfGroup).

decide_origin_exclusions(Profile, Verdict) :-
    origin_exclusions_input_problems(Profile, Problems),
    verdict_for_problems(Problems, Profile, Verdict).

verdict_for_problems([Problem|Problems], _, origin_exclusions_verdict(input_problems([Problem|Problems]), [])).
verdict_for_problems([], Profile, Verdict) :-
    profile_states(Profile, MilitaryState, OriginClass, GoodsKind, ShelfGroup),
    limb(MilitaryState, OriginClass, GoodsKind, ShelfGroup, Verdict).

origin_exclusion(Profile, Result, Citations) :-
    decide_origin_exclusions(Profile, origin_exclusions_verdict(Result, Citations)).

origin_exclusions_status(Profile, Status) :-
    decide_origin_exclusions(Profile, origin_exclusions_verdict(Status, _)).

origin_exclusions_checklist(Profile, Items) :-
    origin_exclusions_input_problems(Profile, Problems),
    checklist_for_problems(Problems, Profile, Items).

checklist_for_problems([_|_], _, []).
checklist_for_problems([], Profile, [item(military_activities, MilitaryStatus, cite(eu_reg_2023_956_art_2_3)), item(origin_annex_iii_point_1, OriginStatus, cite(eu_reg_2023_956_art_2_4)), item(electricity_continental_shelf_or_eez, ElectricityStatus, cite(eu_reg_2023_956_art_2_3a_a)), item(hydrogen_continental_shelf_or_eez, HydrogenStatus, cite(eu_reg_2023_956_art_2_3a_b)), item(not_third_country_origin, MemberStateStatus, cite(eu_reg_2023_956_art_2_1))]) :-
    profile_states(Profile, MilitaryState, OriginClass, GoodsKind, ShelfGroup),
    military_item_status(MilitaryState, MilitaryStatus),
    origin_item_status(OriginClass, OriginStatus),
    zone_item_status(electricity, GoodsKind, ShelfGroup, ElectricityStatus),
    zone_item_status(hydrogen, GoodsKind, ShelfGroup, HydrogenStatus),
    member_state_item_status(OriginClass, MemberStateStatus).

military_item_status(yes, met) :-
    implements(eu_reg_2023_956_art_2_3).
military_item_status(no, unmet(not_for_military_activities)) :-
    implements(eu_reg_2023_956_art_2_3).
military_item_status(absent, unknown([military_activities])).

origin_item_status(listed, met) :-
    implements(eu_reg_2023_956_art_2_4).
origin_item_status(member_state, unmet(origin_not_listed_in_annex_iii_point_1)) :-
    implements(eu_reg_2023_956_art_2_4).
origin_item_status(other_third_country, unmet(origin_not_listed_in_annex_iii_point_1)) :-
    implements(eu_reg_2023_956_art_2_4).
origin_item_status(absent, unknown([non_preferential_origin])).

known_goods_kind(electricity).
known_goods_kind(hydrogen).
known_goods_kind(other_annex_i_goods).

zone_item_status(TargetKind, TargetKind, ShelfGroup, met) :-
    implements(eu_reg_2023_956_art_2_3a),
    qualifying_shelf(ShelfGroup).
zone_item_status(TargetKind, TargetKind, outside, unmet(not_on_qualifying_continental_shelf_or_eez)) :-
    implements(eu_reg_2023_956_art_2_3a).
zone_item_status(TargetKind, TargetKind, absent, unknown([continental_shelf_or_eez_of])).
zone_item_status(TargetKind, GoodsKind, _, unmet(other_goods_kind)) :-
    implements(eu_reg_2023_956_art_2_3a),
    known_goods_kind(GoodsKind),
    dif(GoodsKind, TargetKind).
zone_item_status(_, absent, outside, unmet(not_on_qualifying_continental_shelf_or_eez)) :-
    implements(eu_reg_2023_956_art_2_3a).
zone_item_status(_, absent, ShelfGroup, unknown([goods_kind])) :-
    goods_kind_relevant_shelf(ShelfGroup).

member_state_item_status(member_state, met) :-
    implements(eu_reg_2023_956_art_3_7).
member_state_item_status(listed, unmet(third_country_origin)) :-
    implements(eu_reg_2023_956_art_3_7).
member_state_item_status(other_third_country, unmet(third_country_origin)) :-
    implements(eu_reg_2023_956_art_3_7).
member_state_item_status(absent, unknown([non_preferential_origin])).

origin_exclusions_decision_resolvable(Profile) :-
    decide_origin_exclusions(Profile, _).

test(military_yes_is_excluded) :-
    findall(Result - Citations, origin_exclusion([attribute(military_activities, yes)], Result, Citations), Answers),
    Answers == [excluded_military_activities - [cite(eu_reg_2023_956_art_2_3)]].
test(norway_origin_with_military_absent_is_excluded) :-
    findall(Result, origin_exclusion([attribute(non_preferential_origin, norway)], Result, _), Results),
    Results == [excluded_origin_annex_iii_point_1].
test(norway_hydrogen_from_norwegian_shelf_gives_origin_first) :-
    findall(Result, origin_exclusion([attribute(military_activities, no), attribute(non_preferential_origin, norway), attribute(goods_kind, hydrogen), attribute(continental_shelf_or_eez_of, norway)], Result, _), Results),
    Results == [excluded_origin_annex_iii_point_1].
test(electricity_member_state_shelf_before_member_state_origin) :-
    findall(Result, origin_exclusion([attribute(military_activities, no), attribute(non_preferential_origin, member_state), attribute(goods_kind, electricity), attribute(continental_shelf_or_eez_of, member_state)], Result, _), Results),
    Results == [excluded_electricity_continental_shelf_or_eez].
test(electricity_iceland_shelf_cites_annex) :-
    findall(Result - Citations, origin_exclusion([attribute(goods_kind, electricity), attribute(continental_shelf_or_eez_of, iceland)], Result, Citations), Answers),
    Answers == [excluded_electricity_continental_shelf_or_eez - [cite(eu_reg_2023_956_art_2_3a), cite(eu_reg_2023_956_art_2_3a_a), cite(eu_reg_2023_956_art_3_8), cite(eu_reg_2023_956_art_3_9), cite(eu_reg_2023_956_annex_3_1)]].
test(hydrogen_member_state_zone_is_excluded) :-
    findall(Result, origin_exclusion([attribute(military_activities, no), attribute(non_preferential_origin, other_third_country), attribute(goods_kind, hydrogen), attribute(continental_shelf_or_eez_of, member_state)], Result, _), Results),
    Results == [excluded_hydrogen_continental_shelf_or_eez].
test(member_state_origin_is_not_third_country) :-
    findall(Result, origin_exclusion([attribute(military_activities, no), attribute(non_preferential_origin, member_state), attribute(goods_kind, other_annex_i_goods)], Result, _), Results),
    Results == [not_third_country_origin].
test(empty_profile_asks_for_military_activities) :-
    findall(Result - Citations, origin_exclusion([], Result, Citations), Answers),
    Answers == [indeterminate([military_activities]) - []].
test(unsure_is_treated_as_absent) :-
    findall(Result, origin_exclusion([attribute(military_activities, unsure), attribute(non_preferential_origin, other_third_country)], Result, _), Results),
    Results == [indeterminate([military_activities])].
test(origin_absent_is_asked_for) :-
    findall(Result, origin_exclusion([attribute(military_activities, no)], Result, _), Results),
    Results == [indeterminate([non_preferential_origin])].
test(goods_kind_absent_is_asked_for) :-
    findall(Result, origin_exclusion([attribute(military_activities, no), attribute(non_preferential_origin, other_third_country)], Result, _), Results),
    Results == [indeterminate([goods_kind])].
test(shelf_absent_is_asked_for_electricity) :-
    findall(Result, origin_exclusion([attribute(military_activities, no), attribute(non_preferential_origin, other_third_country), attribute(goods_kind, electricity)], Result, _), Results),
    Results == [indeterminate([continental_shelf_or_eez_of])].
test(other_goods_have_no_origin_exclusion) :-
    findall(Result, origin_exclusion([attribute(military_activities, no), attribute(non_preferential_origin, other_third_country), attribute(goods_kind, other_annex_i_goods)], Result, _), Results),
    Results == [no_origin_exclusion].
test(goods_kind_absent_outside_zone_has_no_origin_exclusion) :-
    findall(Result, origin_exclusion([attribute(military_activities, no), attribute(non_preferential_origin, other_third_country), attribute(continental_shelf_or_eez_of, not_on_continental_shelf_or_eez)], Result, _), Results),
    Results == [no_origin_exclusion].
test(unknown_key_is_an_input_problem) :-
    findall(Result - Citations, origin_exclusion([attribute(colour, red)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(checklist_marks_military_met) :-
    origin_exclusions_checklist([attribute(military_activities, yes)], Items),
    member(item(military_activities, met, cite(eu_reg_2023_956_art_2_3)), Items).
test(status_projection) :-
    origin_exclusions_status([attribute(non_preferential_origin, ceuta)], excluded_origin_annex_iii_point_1).

test(other_goods_are_not_excluded, fail) :-
    origin_exclusion([attribute(military_activities, no), attribute(non_preferential_origin, other_third_country), attribute(goods_kind, other_annex_i_goods)], excluded_military_activities, _).
