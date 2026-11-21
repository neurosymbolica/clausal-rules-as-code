% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_fixtures, [gber_general_conditions_subject/1, gber_general_conditions_profile_for/2, gber_general_conditions_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_gber_general_conditions_gber_general_conditions, [decide_gber_general_conditions/2]).

gber_general_conditions_subject(compliant_sme_grant).
gber_general_conditions_subject(same_day_application).
gber_general_conditions_subject(application_day_before_start).
gber_general_conditions_subject(threshold_at_figure).
gber_general_conditions_subject(threshold_one_cent_over).
gber_general_conditions_subject(other_category_row).
gber_general_conditions_subject(de_minimis_at_intensity).
gber_general_conditions_subject(de_minimis_one_cent_over).
gber_general_conditions_subject(difficulty_unsure).
gber_general_conditions_subject(difficulty_without_exception).
gber_general_conditions_subject(difficulty_with_derogation).
gber_general_conditions_subject(recovery_order_outstanding).
gber_general_conditions_subject(transparent_loan).
gber_general_conditions_subject(non_transparent_other_form).
gber_general_conditions_subject(ad_hoc_large_enterprise_verified).
gber_general_conditions_subject(ad_hoc_large_enterprise_unverified).
gber_general_conditions_subject(doubled_industrial_research).
gber_general_conditions_subject(undoubled_industrial_research).
gber_general_conditions_subject(doubled_research_at_twice_figure).
gber_general_conditions_subject(doubled_research_one_cent_over_twice).
gber_general_conditions_subject(not_an_enterprise_size).
gber_general_conditions_subject(large_enterprise_scheme_aid).
gber_general_conditions_subject(empty_profile).

base_profile([attribute(scheme_excluded_by_article_1_2_a_or_b, false), attribute(export_or_domestic_goods_aid, false), attribute(aided_sector, other_sector), attribute(sector_exception_applies, false), attribute(price_or_pass_on_condition, false), attribute(article_13_regional_aid_category, false), attribute(also_active_in_excluded_sector, false), attribute(separation_of_activities_or_costs_ensured, true), attribute(recovery_order_exclusion_applies, false), attribute(undertaking_in_difficulty, false), attribute(difficulty_exception_applies, false), attribute(difficulty_2020_2021_derogation, false), attribute(non_severable_violation_of_union_law, false), attribute(article_4_category, sme_investment), attribute(research_project_doubled, false), attribute(aid_form, grant), attribute(form_transparency_condition_met, false), attribute(category_transparency_condition_met, false), attribute(transparent_under_article_5_1, false), attribute(article_6_5_category_conditions_met, false), attribute(tax_measure_conditions_met, false), attribute(application_contains_required_information, true), attribute(aid_type, scheme), attribute(size_class, small_enterprise), attribute(large_enterprise_verification_done, false), attribute(identifiable_eligible_costs, true)]).

profile_with(Overrides, Profile) :-
    base_profile(Base),
    override_attributes(Base, Overrides, Profile).

override_attributes(Profile, [], Profile).
override_attributes(Profile, [attribute(Key, Value)|Overrides], Result) :-
    replace_attribute(Profile, Key, Value, Next),
    override_attributes(Next, Overrides, Result).

replace_attribute([], _, _, []).
replace_attribute([attribute(ElementKey, _)|Elements], Key, Value, [attribute(ElementKey, Value)|Replaced]) :-
    ElementKey == Key,
    replace_attribute(Elements, Key, Value, Replaced).
replace_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Replaced]) :-
    ElementKey \== Key,
    replace_attribute(Elements, Key, Value, Replaced).

gber_general_conditions_profile_for(compliant_sme_grant, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    base_profile(Profile).
gber_general_conditions_profile_for(same_day_application, gber_case(Profile, 800000000, date(2024, 2, 1), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    base_profile(Profile).
gber_general_conditions_profile_for(application_day_before_start, gber_case(Profile, 800000000, date(2024, 1, 31), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    base_profile(Profile).
gber_general_conditions_profile_for(threshold_at_figure, gber_case(Profile, 825000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    base_profile(Profile).
gber_general_conditions_profile_for(threshold_one_cent_over, gber_case(Profile, 825000001, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    base_profile(Profile).
gber_general_conditions_profile_for(other_category_row, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(article_4_category, other_category)], Profile).
gber_general_conditions_profile_for(de_minimis_at_intensity, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 200000000, 5000)) :-
    base_profile(Profile).
gber_general_conditions_profile_for(de_minimis_one_cent_over, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 200000001, 5000)) :-
    base_profile(Profile).
gber_general_conditions_profile_for(difficulty_unsure, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(undertaking_in_difficulty, unsure)], Profile).
gber_general_conditions_profile_for(difficulty_without_exception, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(undertaking_in_difficulty, true)], Profile).
gber_general_conditions_profile_for(difficulty_with_derogation, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(undertaking_in_difficulty, true), attribute(difficulty_2020_2021_derogation, true)], Profile).
gber_general_conditions_profile_for(recovery_order_outstanding, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(recovery_order_exclusion_applies, true)], Profile).
gber_general_conditions_profile_for(transparent_loan, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(aid_form, loan), attribute(form_transparency_condition_met, true)], Profile).
gber_general_conditions_profile_for(non_transparent_other_form, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(aid_form, other_form)], Profile).
gber_general_conditions_profile_for(ad_hoc_large_enterprise_verified, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(aid_type, ad_hoc_aid), attribute(size_class, large_enterprise), attribute(large_enterprise_verification_done, true)], Profile).
gber_general_conditions_profile_for(ad_hoc_large_enterprise_unverified, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(aid_type, ad_hoc_aid), attribute(size_class, large_enterprise), attribute(large_enterprise_verification_done, false)], Profile).
gber_general_conditions_profile_for(doubled_industrial_research, gber_case(Profile, 5000000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(article_4_category, industrial_research), attribute(research_project_doubled, true)], Profile).
gber_general_conditions_profile_for(undoubled_industrial_research, gber_case(Profile, 5000000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(article_4_category, industrial_research), attribute(research_project_doubled, false)], Profile).
gber_general_conditions_profile_for(doubled_research_at_twice_figure, gber_case(Profile, 7000000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(article_4_category, industrial_research), attribute(research_project_doubled, true)], Profile).
gber_general_conditions_profile_for(doubled_research_one_cent_over_twice, gber_case(Profile, 7000000001, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(article_4_category, industrial_research), attribute(research_project_doubled, true)], Profile).
gber_general_conditions_profile_for(not_an_enterprise_size, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(size_class, not_an_enterprise)], Profile).
gber_general_conditions_profile_for(large_enterprise_scheme_aid, gber_case(Profile, 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)) :-
    profile_with([attribute(size_class, large_enterprise)], Profile).
gber_general_conditions_profile_for(empty_profile, gber_case([], 800000000, date(2024, 1, 10), date(2024, 2, 1), 2000000000, 800000000, 0, 5000)).

gber_general_conditions_assess(Subject, Result) :-
    gber_general_conditions_profile_for(Subject, Case),
    decide_gber_general_conditions(Case, Result).

subject_has_case(Subject) :-
    gber_general_conditions_profile_for(Subject, gber_case(_, _, _, _, _, _, _, _)).

test(every_subject_has_a_case) :-
    findall(Subject, gber_general_conditions_subject(Subject), Subjects),
    maplist(subject_has_case, Subjects).
test(an_override_keeps_twenty_six_keys) :-
    profile_with([attribute(aid_form, loan)], Profile),
    length(Profile, 26).
test(the_compliant_subject_is_met) :-
    gber_general_conditions_assess(compliant_sme_grant, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
