% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_special_categories_permitted_bases, [decide_permitted_bases/2, permitted_bases_status/2, permitted_bases_checklist/2, permitted_bases_decision_resolvable/1, permitted_bases_status_values/1, permitted_bases/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_special_categories_kernel, [gdpr_special_categories_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_special_categories_processing_permitted, [decide_special_category_processing/2]).

permitted_bases_status_values([art9_2_a, art9_2_b, art9_2_c, art9_2_d, art9_2_e, art9_2_f, art9_2_g, art9_2_h, art9_2_i, art9_2_j, art10_official_authority, art10_authorised_by_law, not_special_category_data]).

basis_provision(art9_2_a, cite(eu_reg_2016_679_art_9_2_a)).
basis_provision(art9_2_b, cite(eu_reg_2016_679_art_9_2_b)).
basis_provision(art9_2_c, cite(eu_reg_2016_679_art_9_2_c)).
basis_provision(art9_2_d, cite(eu_reg_2016_679_art_9_2_d)).
basis_provision(art9_2_e, cite(eu_reg_2016_679_art_9_2_e)).
basis_provision(art9_2_f, cite(eu_reg_2016_679_art_9_2_f)).
basis_provision(art9_2_g, cite(eu_reg_2016_679_art_9_2_g)).
basis_provision(art9_2_h, cite(eu_reg_2016_679_art_9_2_h)).
basis_provision(art9_2_i, cite(eu_reg_2016_679_art_9_2_i)).
basis_provision(art9_2_j, cite(eu_reg_2016_679_art_9_2_j)).
basis_provision(art10_official_authority, cite(eu_reg_2016_679_art_10)).
basis_provision(art10_authorised_by_law, cite(eu_reg_2016_679_art_10)).
basis_provision(not_special_category_data, cite(eu_reg_2016_679_art_9_1)).

permitted_bases(Profile, Bases) :-
    implements(eu_reg_2016_679_art_9_1),
    decide_special_category_processing(Profile, special_category_verdict(eligible, Bases, _, _)).
permitted_bases(Profile, []) :-
    decide_special_category_processing(Profile, special_category_verdict(Status, _, _, _)),
    dif(Status, eligible).

decide_permitted_bases(Profile, permitted_bases_verdict(Status, Bases, Citations)) :-
    decide_special_category_processing(Profile, special_category_verdict(Status, _, _, Citations)),
    permitted_bases(Profile, Bases).

permitted_bases_status(Profile, Status) :-
    decide_permitted_bases(Profile, permitted_bases_verdict(Status, _, _)).

permitted_bases_decision_resolvable(Profile) :-
    decide_permitted_bases(Profile, _).

permitted_bases_checklist(Profile, []) :-
    gdpr_special_categories_input_problems(Profile, [_|_]).
permitted_bases_checklist(Profile, Items) :-
    gdpr_special_categories_input_problems(Profile, []),
    decide_special_category_processing(Profile, special_category_verdict(eligible, Bases, _, _)),
    maplist(basis_item, Bases, Items).
permitted_bases_checklist(Profile, [item(permitted_bases, not_applicable, cite(eu_reg_2016_679_art_9_1))]) :-
    gdpr_special_categories_input_problems(Profile, []),
    decide_special_category_processing(Profile, special_category_verdict(Status, _, _, _)),
    dif(Status, eligible).

basis_item(Basis, item(Basis, met, Citation)) :-
    basis_provision(Basis, Citation).

no_category_profile([attribute(reveals_racial_or_ethnic_origin, false), attribute(reveals_political_opinions, false), attribute(reveals_religious_or_philosophical_beliefs, false), attribute(reveals_trade_union_membership, false), attribute(genetic_data_present, false), attribute(biometric_data_present, false), attribute(concerns_health, false), attribute(concerns_sex_life_or_sexual_orientation, false), attribute(criminal_offence_data_present, false)]).

consent_profile([attribute(exception_claimed, art9_2_a), attribute(concerns_health, true), attribute(criminal_offence_data_present, false), attribute(explicit_consent_given, true), attribute(consent_purposes_specified, true), attribute(consent_satisfies_definition, true)]).

test(no_special_category_data_basis_once) :-
    no_category_profile(Profile),
    findall(Bases, permitted_bases(Profile, Bases), Answers),
    Answers == [[not_special_category_data]].
test(explicit_consent_basis_once) :-
    consent_profile(Profile),
    findall(Bases, permitted_bases(Profile, Bases), Answers),
    Answers == [[art9_2_a]].
test(article_9_and_article_10_bases_together) :-
    consent_profile(Base),
    select(attribute(criminal_offence_data_present, false), Base, Rest),
    Profile = [attribute(criminal_offence_data_present, true), attribute(processing_under_official_authority_control, true)|Rest],
    findall(Bases, permitted_bases(Profile, Bases), Answers),
    Answers == [[art9_2_a, art10_official_authority]].
test(no_claim_gives_no_basis) :-
    findall(Bases, permitted_bases([attribute(concerns_health, true), attribute(criminal_offence_data_present, false)], Bases), Answers),
    Answers == [[]].
test(an_indeterminate_profile_gives_no_basis) :-
    findall(Bases, permitted_bases([], Bases), Answers),
    Answers == [[]].
test(input_problems_give_no_basis) :-
    findall(Bases, permitted_bases([attribute(colour, red)], Bases), Answers),
    Answers == [[]].
test(slice_verdict_projects_status_and_bases) :-
    consent_profile(Profile),
    decide_permitted_bases(Profile, permitted_bases_verdict(eligible, [art9_2_a], [cite(eu_reg_2016_679_art_9_1), cite(eu_reg_2016_679_art_9_2_a)])).
test(checklist_carries_the_basis_cite) :-
    consent_profile(Profile),
    permitted_bases_checklist(Profile, [item(art9_2_a, met, cite(eu_reg_2016_679_art_9_2_a))]).
test(checklist_for_an_ineligible_profile) :-
    permitted_bases_checklist([attribute(concerns_health, true), attribute(criminal_offence_data_present, false)], [item(permitted_bases, not_applicable, cite(eu_reg_2016_679_art_9_1))]).
test(every_basis_has_a_provision) :-
    permitted_bases_status_values(Values),
    maplist(basis_item, Values, Items),
    length(Items, 13).

test(explicit_consent_is_not_another_point, fail) :-
    consent_profile(Profile),
    permitted_bases(Profile, [art9_2_b]).
test(no_claim_is_not_explicit_consent, fail) :-
    permitted_bases([attribute(concerns_health, true), attribute(criminal_offence_data_present, false)], [art9_2_a]).
