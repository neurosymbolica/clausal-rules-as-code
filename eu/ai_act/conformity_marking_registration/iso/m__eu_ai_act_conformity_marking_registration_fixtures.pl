% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_fixtures, [conformity_marking_registration_subject/1, conformity_marking_registration_profile_for/2, conformity_marking_registration_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_conformity_marking_registration_kernel, [conformity_marking_registration_input_problems/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_conformity_marking_registration, [decide_conformity_marking_registration/2]).

base_values([annex_iii_point - annex_iii_point_3, provider_concluded_under_article_6_3_that_the_system_is_not_high_risk - false, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i - false, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027 - false, placed_on_the_market_or_put_into_service_before_the_application_day - false, significant_changes_in_design_from_the_application_day - false, intended_to_be_used_by_public_authorities - false, harmonised_standards_or_common_specifications_applied_in_full - true, applied_harmonised_standard_published_with_a_restriction - false, harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment - false, intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies - false, already_subject_to_a_conformity_assessment_procedure - true, change_pre_determined_for_a_system_that_continues_to_learn - false, substantial_modification - true, other_union_harmonisation_legislation_requires_an_eu_declaration_of_conformity - false, provided_digitally - false, affixing_to_the_system_possible_and_warranted - true, notified_body_involved_in_the_conformity_assessment - false, other_union_law_provides_for_affixing_the_ce_marking - false, deployer_is_a_public_authority_or_union_institution_body_office_or_agency_or_acts_on_their_behalf - true]).

subject_row(point_three_internal_control, [], date(2029, 1, 1)).
subject_row(point_three_on_application_day, [], date(2027, 12, 2)).
subject_row(point_three_day_before_application_day, [], date(2027, 12, 1)).
subject_row(point_three_concluded_not_high_risk, [provider_concluded_under_article_6_3_that_the_system_is_not_high_risk - true], date(2029, 1, 1)).
subject_row(point_one_full_standards, [annex_iii_point - annex_iii_point_1], date(2029, 1, 1)).
subject_row(point_one_partial_standards, [annex_iii_point - annex_iii_point_1, harmonised_standards_or_common_specifications_applied_in_full - false], date(2029, 1, 1)).
subject_row(point_one_restricted_standard, [annex_iii_point - annex_iii_point_1, applied_harmonised_standard_published_with_a_restriction - true], date(2029, 1, 1)).
subject_row(point_one_standards_unstated, [annex_iii_point - annex_iii_point_1, harmonised_standards_or_common_specifications_applied_in_full - omitted], date(2029, 1, 1)).
subject_row(point_one_law_enforcement, [annex_iii_point - annex_iii_point_1, intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies - true], date(2029, 1, 1)).
subject_row(point_one_concluded_not_high_risk, [annex_iii_point - annex_iii_point_1, provider_concluded_under_article_6_3_that_the_system_is_not_high_risk - true], date(2029, 1, 1)).
subject_row(point_two_internal_control, [annex_iii_point - annex_iii_point_2], date(2029, 1, 1)).
subject_row(section_a_product_on_application_day, [annex_iii_point - not_listed_in_annex_iii, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i - true], date(2028, 8, 2)).
subject_row(section_a_product_day_before_application_day, [annex_iii_point - not_listed_in_annex_iii, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i - true], date(2028, 8, 1)).
subject_row(section_a_product_option_with_full_standards, [annex_iii_point - not_listed_in_annex_iii, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i - true, harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment - true], date(2029, 1, 1)).
subject_row(section_a_product_option_without_full_standards, [annex_iii_point - not_listed_in_annex_iii, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i - true, harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment - true, harmonised_standards_or_common_specifications_applied_in_full - false], date(2029, 1, 1)).
subject_row(annex_x_component_day_before_compliance_day, [component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027 - true], date(2030, 12, 30)).
subject_row(annex_x_component_on_compliance_day, [component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027 - true], date(2030, 12, 31)).
subject_row(public_authority_legacy_day_before_compliance_day, [placed_on_the_market_or_put_into_service_before_the_application_day - true, intended_to_be_used_by_public_authorities - true], date(2030, 8, 1)).
subject_row(public_authority_legacy_on_compliance_day, [placed_on_the_market_or_put_into_service_before_the_application_day - true, intended_to_be_used_by_public_authorities - true], date(2030, 8, 2)).
subject_row(legacy_system_without_significant_changes, [placed_on_the_market_or_put_into_service_before_the_application_day - true], date(2029, 1, 1)).
subject_row(legacy_system_with_significant_changes, [placed_on_the_market_or_put_into_service_before_the_application_day - true, significant_changes_in_design_from_the_application_day - true], date(2029, 1, 1)).
subject_row(legacy_system_significant_changes_unsure, [placed_on_the_market_or_put_into_service_before_the_application_day - true, significant_changes_in_design_from_the_application_day - unsure], date(2029, 1, 1)).
subject_row(point_three_private_deployer, [deployer_is_a_public_authority_or_union_institution_body_office_or_agency_or_acts_on_their_behalf - false], date(2029, 1, 1)).
subject_row(point_three_other_declaration, [other_union_harmonisation_legislation_requires_an_eu_declaration_of_conformity - true], date(2029, 1, 1)).
subject_row(point_three_not_substantial, [substantial_modification - false], date(2029, 1, 1)).
subject_row(point_three_predetermined_change, [change_pre_determined_for_a_system_that_continues_to_learn - true], date(2029, 1, 1)).
subject_row(point_three_first_assessment, [already_subject_to_a_conformity_assessment_procedure - false], date(2029, 1, 1)).
subject_row(point_three_substantial_unsure, [substantial_modification - unsure], date(2029, 1, 1)).
subject_row(point_three_provided_digitally, [provided_digitally - true], date(2029, 1, 1)).
subject_row(point_three_affixing_unsure, [affixing_to_the_system_possible_and_warranted - unsure], date(2029, 1, 1)).

conformity_marking_registration_subject(SubjectName) :-
    subject_row(SubjectName, _, _).

conformity_marking_registration_profile_for(SubjectName, assessment(Profile, AssessmentDate)) :-
    subject_row(SubjectName, Overrides, AssessmentDate),
    base_values(BaseValues),
    maplist(attribute_entries(Overrides), BaseValues, NestedEntries),
    append(NestedEntries, Profile).

attribute_entries(Overrides, WantedKey - DefaultValue, Entries) :-
    chosen_value(Overrides, WantedKey, DefaultValue, ChosenValue),
    entry_for(ChosenValue, WantedKey, Entries).

chosen_value([], _, DefaultValue, DefaultValue).
chosen_value([OverrideKey - OverrideValue|_], WantedKey, _, OverrideValue) :-
    OverrideKey == WantedKey.
chosen_value([OverrideKey - _|Overrides], WantedKey, DefaultValue, ChosenValue) :-
    dif(OverrideKey, WantedKey),
    chosen_value(Overrides, WantedKey, DefaultValue, ChosenValue).

entry_for(omitted, _, []).
entry_for(ChosenValue, WantedKey, [attribute(WantedKey, ChosenValue)]) :-
    dif(ChosenValue, omitted).

conformity_marking_registration_assess(SubjectName, Verdict) :-
    conformity_marking_registration_profile_for(SubjectName, AssessmentCase),
    decide_conformity_marking_registration(AssessmentCase, Verdict).

well_formed_subject(SubjectName) :-
    conformity_marking_registration_profile_for(SubjectName, assessment(Profile, _)),
    conformity_marking_registration_input_problems(Profile, []).

test(every_subject_profile_is_well_formed) :-
    findall(SubjectName, conformity_marking_registration_subject(SubjectName), SubjectNames),
    SubjectNames = [_|_],
    maplist(well_formed_subject, SubjectNames).
test(the_base_profile_gives_every_contract_key) :-
    conformity_marking_registration_profile_for(point_three_internal_control, assessment(Profile, _)),
    length(Profile, 20).
test(an_omitted_key_is_absent) :-
    conformity_marking_registration_profile_for(point_one_standards_unstated, assessment(Profile, _)),
    length(Profile, 19).
test(an_override_replaces_the_base_value) :-
    conformity_marking_registration_profile_for(point_two_internal_control, assessment(Profile, _)),
    member(attribute(annex_iii_point, annex_iii_point_2), Profile).
test(each_subject_has_one_case) :-
    findall(AssessmentCase, conformity_marking_registration_profile_for(point_three_internal_control, AssessmentCase), Cases),
    length(Cases, 1).
test(the_baseline_subject_is_assessed) :-
    conformity_marking_registration_assess(point_three_internal_control, conformity_marking_registration_verdict(high_risk_obligations_apply, [_|_])).

test(an_override_leaves_no_base_value_behind, fail) :-
    conformity_marking_registration_profile_for(point_two_internal_control, assessment(Profile, _)),
    member(attribute(annex_iii_point, annex_iii_point_3), Profile).
