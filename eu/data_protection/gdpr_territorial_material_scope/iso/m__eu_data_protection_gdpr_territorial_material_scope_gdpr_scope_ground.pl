% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_scope_ground, [decide_gdpr_scope_ground/2, gdpr_scope_ground_status/2, gdpr_scope_ground_checklist/2, gdpr_scope_ground_decision_resolvable/1, gdpr_scope_ground_status_values/1, gdpr_scope_ground/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_kernel, [gdpr_territorial_material_scope_input_problems/2, scope_ground/2, limb_items/3]).

gdpr_scope_ground_status_values([art3_1, art3_2_a, art3_2_b, art3_3, art2_1_not_met, art2_2_a, art2_2_b, art2_2_c, art2_2_d, art2_3, art3_not_met, none]).

ground_citation_list(art3_1, [cite(eu_reg_2016_679_art_3_1)]).
ground_citation_list(art3_2_a, [cite(eu_reg_2016_679_art_3_2_a)]).
ground_citation_list(art3_2_b, [cite(eu_reg_2016_679_art_3_2_b)]).
ground_citation_list(art3_3, [cite(eu_reg_2016_679_art_3_3)]).
ground_citation_list(art2_1_not_met, [cite(eu_reg_2016_679_art_2_1)]).
ground_citation_list(art2_2_a, [cite(eu_reg_2016_679_art_2_2_a)]).
ground_citation_list(art2_2_b, [cite(eu_reg_2016_679_art_2_2_b)]).
ground_citation_list(art2_2_c, [cite(eu_reg_2016_679_art_2_2_c)]).
ground_citation_list(art2_2_d, [cite(eu_reg_2016_679_art_2_2_d)]).
ground_citation_list(art2_3, [cite(eu_reg_2016_679_art_2_3)]).
ground_citation_list(art3_not_met, [cite(eu_reg_2016_679_art_3_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_3_3)]).
ground_citation_list(none, []).

gdpr_scope_ground(Profile, Ground) :-
    decide_gdpr_scope_ground(Profile, gdpr_scope_ground_verdict(Ground, _Citations)).

decide_gdpr_scope_ground(Profile, Verdict) :-
    gdpr_territorial_material_scope_input_problems(Profile, Problems),
    ground_given(Problems, Profile, Verdict).

ground_given([_|_], _, gdpr_scope_ground_verdict(none, [])).
ground_given([], Profile, gdpr_scope_ground_verdict(Ground, Citations)) :-
    implements(eu_reg_2016_679_art_3_1),
    scope_ground(Profile, Ground),
    ground_citation_list(Ground, Citations).

gdpr_scope_ground_status(Profile, Status) :-
    decide_gdpr_scope_ground(Profile, gdpr_scope_ground_verdict(Status, _Citations)).

gdpr_scope_ground_checklist(Profile, Items) :-
    gdpr_territorial_material_scope_input_problems(Profile, Problems),
    checklist_given(Problems, Profile, Items).

checklist_given([_|_], _, [item(input_check, unknown, cite(eu_reg_2016_679_art_2_1))]).
checklist_given([], Profile, Items) :-
    limb_items([s1_head, s1_means, x_a, x_b, x_c, x_d, x_e, l31, l32a, l32b, l33], Profile, Items).

gdpr_scope_ground_decision_resolvable(Profile) :-
    decide_gdpr_scope_ground(Profile, _Verdict).
