% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_applies, [decide_gdpr_applies/2, gdpr_applies_status/2, gdpr_applies_checklist/2, gdpr_applies_decision_resolvable/1, gdpr_applies_status_values/1, gdpr_applies/2, scope_outside_facts/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_kernel, [gdpr_territorial_material_scope_input_problems/2, scope_key_order/1, citation_order/1, judgement_citation/2, limb_citation/2, stage_limbs/2, all_status/2, limb_status/3, stage_statuses/4, limbs_absent_keys/3, present_pairs/3, ordered_members/3, scope_ground/2, limb_items/3]).

gdpr_applies_status_values([applies, does_not_apply]).

ground_citations(art3_1, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_1)]).
ground_citations(art3_2_a, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a)]).
ground_citations(art3_2_b, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_b)]).
ground_citations(art3_3, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_3)]).
ground_citations(art2_1_not_met, [cite(eu_reg_2016_679_art_2_1)]).
ground_citations(art2_2_a, [cite(eu_reg_2016_679_art_2_2_a)]).
ground_citations(art2_2_b, [cite(eu_reg_2016_679_art_2_2_b)]).
ground_citations(art2_2_c, [cite(eu_reg_2016_679_art_2_2_c)]).
ground_citations(art2_2_d, [cite(eu_reg_2016_679_art_2_2_d)]).
ground_citations(art2_3, [cite(eu_reg_2016_679_art_2_3)]).
ground_citations(art3_not_met, [cite(eu_reg_2016_679_art_3_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_3_3)]).

stage_citations(one, [cite(eu_reg_2016_679_art_2_1)]).
stage_citations(two, [cite(eu_reg_2016_679_art_2_2_a), cite(eu_reg_2016_679_art_2_2_b), cite(eu_reg_2016_679_art_2_2_c), cite(eu_reg_2016_679_art_2_2_d), cite(eu_reg_2016_679_art_2_3)]).
stage_citations(three, [cite(eu_reg_2016_679_art_3_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_3_3)]).

limb_judgement(x_c, purely_personal_or_household_activity, two).
limb_judgement(l31, processing_in_context_of_establishment_activities, three).
limb_judgement(l32a, offering_goods_or_services_to_data_subjects_in_union, three).
limb_judgement(l32b, monitoring_behaviour_of_data_subjects_in_union, three).

gdpr_applies(Profile, Applies) :-
    decide_gdpr_applies(Profile, gdpr_applies_verdict(Applies, _Citations)).

gdpr_applies_status(Profile, Status) :-
    decide_gdpr_applies(Profile, gdpr_applies_verdict(Status, _Citations)).

decide_gdpr_applies(Profile, Verdict) :-
    gdpr_territorial_material_scope_input_problems(Profile, Problems),
    decide_given(Problems, Profile, Verdict).

decide_given([Problem|Problems], _, gdpr_applies_verdict(input_problems([Problem|Problems]), [])).
decide_given([], Profile, Verdict) :-
    stage_statuses(Profile, One, Two, Three),
    all_status([One, Two, Three], Combined),
    decide_combined(Combined, [One, Two, Three], Profile, Verdict).

decide_combined(unmet, _, Profile, gdpr_applies_verdict(does_not_apply, Citations)) :-
    implements(eu_reg_2016_679_art_2_1),
    scope_ground(Profile, Ground),
    ground_citations(Ground, Citations).
decide_combined(met, _, Profile, gdpr_applies_verdict(applies, Citations)) :-
    implements(eu_reg_2016_679_art_2_1),
    scope_ground(Profile, Ground),
    ground_citations(Ground, Citations).
decide_combined(absent, [One, Two, Three], Profile, gdpr_applies_verdict(indeterminate(Keys), Citations)) :-
    implements(eu_reg_2016_679_art_2_1),
    stage_missing(One, Profile, one, OneKeys),
    stage_missing(Two, Profile, two, TwoKeys),
    stage_missing(Three, Profile, three, ThreeKeys),
    append([OneKeys, TwoKeys, ThreeKeys], Collected),
    scope_key_order(Order),
    ordered_members(Order, Collected, Keys),
    stage_open_citations(One, one, OneCites),
    stage_open_citations(Two, two, TwoCites),
    stage_open_citations(Three, three, ThreeCites),
    append([OneCites, TwoCites, ThreeCites], CollectedCites),
    citation_order(CitationOrder),
    ordered_members(CitationOrder, CollectedCites, Citations).
decide_combined(fact, _, Profile, gdpr_applies_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_3_3), cite(public_international_law_member_state_law_applies)), [resolution(cite(public_international_law_member_state_law_applies), not_attempted), inputs_relied_on(Pairs)]), [cite(eu_reg_2016_679_art_3_3), cite(public_international_law_member_state_law_applies)])) :-
    implements(eu_reg_2016_679_art_3_3),
    present_pairs(Profile, [party_role, established_in_union], BasePairs),
    open_limb_pairs(Profile, three, LimbPairs),
    append(BasePairs, LimbPairs, Pairs).
decide_combined(judgement, _, Profile, gdpr_applies_verdict(needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]), [Citation])) :-
    implements(eu_reg_2016_679_art_2_1),
    findall(row(Limb, Key, Stage), limb_judgement(Limb, Key, Stage), Rows),
    first_open_row(Rows, Profile, row(_, Input, EndingStage)),
    judgement_citation(Input, Citation),
    open_limb_pairs(Profile, EndingStage, Pairs).

stage_missing(absent, Profile, Stage, Keys) :-
    stage_limbs(Stage, Limbs),
    limbs_absent_keys(Limbs, Profile, Keys).
stage_missing(Status, _, _, []) :-
    dif(Status, absent).

stage_open_citations(met, _, []).
stage_open_citations(Status, Stage, Citations) :-
    dif(Status, met),
    stage_citations(Stage, Citations).

first_open_row([Row|Rows], Profile, Found) :-
    Row = row(Limb, _, _),
    limb_status(Profile, Limb, Status),
    first_open_step(Status, Row, Rows, Profile, Found).

first_open_step(judgement, Row, _, _, Row).
first_open_step(Status, _, Rows, Profile, Found) :-
    dif(Status, judgement),
    first_open_row(Rows, Profile, Found).

open_limb_pairs(Profile, Stage, Pairs) :-
    findall(Limb - Key, limb_judgement(Limb, Key, Stage), Rows),
    rows_pairs(Rows, Profile, Pairs).

rows_pairs([], _, []).
rows_pairs([Limb - Key|Rows], Profile, Pairs) :-
    limb_status(Profile, Limb, Status),
    row_pairs(Status, Profile, Key, Mine),
    rows_pairs(Rows, Profile, Rest),
    append(Mine, Rest, Pairs).

row_pairs(judgement, Profile, Key, [Key - Value]) :-
    profile_get(Profile, Key, Value).
row_pairs(Status, _, _, []) :-
    dif(Status, judgement).

scope_outside_facts(Profile, Facts) :-
    gdpr_territorial_material_scope_input_problems(Profile, Problems),
    outside_given(Problems, Profile, Facts).

outside_given([Problem|Problems], _, input_problems([Problem|Problems])).
outside_given([], Profile, [outside_fact(member_state_law_applies_by_public_international_law, Attested)]) :-
    profile_get(Profile, member_state_law_applies_by_public_international_law, Attested).
outside_given([], Profile, [outside_fact(member_state_law_applies_by_public_international_law, absent)]) :-
    profile_lacks(Profile, member_state_law_applies_by_public_international_law).

gdpr_applies_checklist(Profile, Items) :-
    gdpr_territorial_material_scope_input_problems(Profile, Problems),
    checklist_given(Problems, Profile, Items).

checklist_given([_|_], _, [item(input_check, unknown, cite(eu_reg_2016_679_art_2_1))]).
checklist_given([], Profile, Items) :-
    limb_items([s1_head, s1_means, x_a, x_b, x_c, x_d, x_e, l31, l32a, l32b, l33], Profile, Items).

gdpr_applies_decision_resolvable(Profile) :-
    decide_gdpr_applies(Profile, _Verdict).
