% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_high_risk_requirements_queries, [high_risk_requirements_profile_keys/1, high_risk_requirements_what_if/4, high_risk_requirements_obligations/3, high_risk_requirements_compliance_date/4, system_is_a_high_risk_ai_system_listed_in_annex_iii/0, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i/0, system_listed_under_point_1_a_of_annex_iii/0, used_for_the_purposes_of_law_enforcement_migration_border_control_or_asylum/0, union_or_national_law_considers_the_separate_verification_disproportionate/0, uses_techniques_involving_the_training_of_ai_models_with_data/0, provider_is_an_sme_including_a_start_up_or_an_smc/0, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027/0, placed_on_the_market_or_put_into_service_before_the_chapter_iii_date/0, significant_changes_in_design_as_from_the_chapter_iii_date/0, intended_to_be_used_by_public_authorities/0, system_is_a_component_of_products/0, pre_determined_changes_to_the_system_and_its_performance/0, related_to_a_product_covered_by_annex_i_section_a/0, risk_management_system/0, data_and_data_governance/0, technical_documentation/0, record_keeping/0, minimum_logging_capabilities_for_point_1_a_systems/0, transparency_and_instructions_for_use/0, human_oversight/0, separate_verification_by_at_least_two_natural_persons/0, accuracy_robustness_and_cybersecurity/0, annex_iv_point_1_a/0, annex_iv_point_1_b/0, annex_iv_point_1_c/0, annex_iv_point_1_d/0, annex_iv_point_1_e/0, annex_iv_point_1_f/0, annex_iv_point_1_g/0, annex_iv_point_1_h/0, annex_iv_point_2_a/0, annex_iv_point_2_b/0, annex_iv_point_2_c/0, annex_iv_point_2_d/0, annex_iv_point_2_e/0, annex_iv_point_2_f/0, annex_iv_point_2_g/0, annex_iv_point_2_h/0, annex_iv_point_3/0, annex_iv_point_4/0, annex_iv_point_5/0, annex_iv_point_6/0, annex_iv_point_7/0, annex_iv_point_8/0, annex_iv_point_9/0, article_11_2_information_under_annex_i_section_a_legislation/0, article_13_3_point_a/0, article_13_3_point_b_i/0, article_13_3_point_b_ii/0, article_13_3_point_b_iii/0, article_13_3_point_b_iv/0, article_13_3_point_b_v/0, article_13_3_point_b_vi/0, article_13_3_point_b_vii/0, article_13_3_point_c/0, article_13_3_point_d/0, article_13_3_point_e/0, article_13_3_point_f/0, article_15_3_levels_of_accuracy_and_accuracy_metrics/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [include/3]).
:- use_module(m__eu_ai_act_high_risk_requirements_kernel, [high_risk_requirements_input_problems/2]).
:- use_module(m__eu_ai_act_high_risk_requirements_high_risk_requirements, [decide_high_risk_requirements/2, high_risk_requirement_status/5]).
:- use_module(m__eu_ai_act_high_risk_requirements_citations, [implements/1]).

system_is_a_high_risk_ai_system_listed_in_annex_iii.

system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i.

system_listed_under_point_1_a_of_annex_iii.

used_for_the_purposes_of_law_enforcement_migration_border_control_or_asylum.

union_or_national_law_considers_the_separate_verification_disproportionate.

uses_techniques_involving_the_training_of_ai_models_with_data.

provider_is_an_sme_including_a_start_up_or_an_smc.

component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027.

placed_on_the_market_or_put_into_service_before_the_chapter_iii_date.

significant_changes_in_design_as_from_the_chapter_iii_date.

intended_to_be_used_by_public_authorities.

system_is_a_component_of_products.

pre_determined_changes_to_the_system_and_its_performance.

related_to_a_product_covered_by_annex_i_section_a.

risk_management_system.

data_and_data_governance.

technical_documentation.

record_keeping.

minimum_logging_capabilities_for_point_1_a_systems.

transparency_and_instructions_for_use.

human_oversight.

separate_verification_by_at_least_two_natural_persons.

accuracy_robustness_and_cybersecurity.

annex_iv_point_1_a.

annex_iv_point_1_b.

annex_iv_point_1_c.

annex_iv_point_1_d.

annex_iv_point_1_e.

annex_iv_point_1_f.

annex_iv_point_1_g.

annex_iv_point_1_h.

annex_iv_point_2_a.

annex_iv_point_2_b.

annex_iv_point_2_c.

annex_iv_point_2_d.

annex_iv_point_2_e.

annex_iv_point_2_f.

annex_iv_point_2_g.

annex_iv_point_2_h.

annex_iv_point_3.

annex_iv_point_4.

annex_iv_point_5.

annex_iv_point_6.

annex_iv_point_7.

annex_iv_point_8.

annex_iv_point_9.

article_11_2_information_under_annex_i_section_a_legislation.

article_13_3_point_a.

article_13_3_point_b_i.

article_13_3_point_b_ii.

article_13_3_point_b_iii.

article_13_3_point_b_iv.

article_13_3_point_b_v.

article_13_3_point_b_vi.

article_13_3_point_b_vii.

article_13_3_point_c.

article_13_3_point_d.

article_13_3_point_e.

article_13_3_point_f.

article_15_3_levels_of_accuracy_and_accuracy_metrics.

unsure.

high_risk_requirements_profile_keys([system_is_a_high_risk_ai_system_listed_in_annex_iii, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, system_listed_under_point_1_a_of_annex_iii, used_for_the_purposes_of_law_enforcement_migration_border_control_or_asylum, union_or_national_law_considers_the_separate_verification_disproportionate, uses_techniques_involving_the_training_of_ai_models_with_data, provider_is_an_sme_including_a_start_up_or_an_smc, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, significant_changes_in_design_as_from_the_chapter_iii_date, intended_to_be_used_by_public_authorities, system_is_a_component_of_products, pre_determined_changes_to_the_system_and_its_performance, related_to_a_product_covered_by_annex_i_section_a]).

requirement_atoms([risk_management_system, data_and_data_governance, technical_documentation, record_keeping, minimum_logging_capabilities_for_point_1_a_systems, transparency_and_instructions_for_use, human_oversight, separate_verification_by_at_least_two_natural_persons, accuracy_robustness_and_cybersecurity]).

high_risk_requirements_what_if(requirement_case(Profile, Requirement, AssessmentDate), Key, Value, Verdict) :-
    hypothetical_profile(Profile, Key, Value, Hypothesis),
    decide_high_risk_requirements(requirement_case(Hypothesis, Requirement, AssessmentDate), Verdict).
high_risk_requirements_what_if(element_case(Profile, Element), Key, Value, Verdict) :-
    hypothetical_profile(Profile, Key, Value, Hypothesis),
    decide_high_risk_requirements(element_case(Hypothesis, Element), Verdict).

hypothetical_profile(Profile, Key, Value, Hypothesis) :-
    attribute_items_t(Profile, IsAttributeList),
    edited_profile(IsAttributeList, Profile, Key, Value, Hypothesis).

edited_profile(false, Profile, _, _, Profile).
edited_profile(true, Profile, Key, Value, Hypothesis) :-
    without_key(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], Hypothesis).

without_key([], _, []).
without_key([attribute(Name, _)|Attributes], Key, Kept) :-
    Name == Key,
    without_key(Attributes, Key, Kept).
without_key([attribute(Name, Value)|Attributes], Key, [attribute(Name, Value)|Kept]) :-
    Name \== Key,
    without_key(Attributes, Key, Kept).

attribute_items_t(Term, false) :-
    var(Term).
attribute_items_t(Term, true) :-
    Term == [].
attribute_items_t(Term, Truth) :-
    nonvar(Term),
    Term = [Item|Items],
    attribute_item_t(Item, ItemTruth),
    attribute_items_t(Items, ItemsTruth),
    both_true(ItemTruth, ItemsTruth, Truth).
attribute_items_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_item_t(Item, false) :-
    var(Item).
attribute_item_t(Item, true) :-
    nonvar(Item),
    Item = attribute(_, _).
attribute_item_t(Item, false) :-
    nonvar(Item),
    Item \= attribute(_, _).

both_true(true, Truth, Truth).
both_true(false, _, false).

high_risk_requirements_obligations(Profile, AssessmentDate, Obligations) :-
    implements(eu_reg_2024_1689_art_8_1),
    requirement_atoms(Requirements),
    maplist(requirement_item(Profile, AssessmentDate), Requirements, Items),
    first_open_item(Items, Found),
    obligations_from(Found, Items, Obligations).

requirement_item(Profile, AssessmentDate, Requirement, item(Requirement, Result, Citations)) :-
    high_risk_requirement_status(Profile, Requirement, AssessmentDate, Result, Citations).

first_open_item([], none).
first_open_item([item(Requirement, Result, Citations)|Items], Found) :-
    result_kind(Result, Kind),
    open_item_by_kind(Kind, item(Requirement, Result, Citations), Items, Found).

open_item_by_kind(problem, item(_, Result, _), _, found(item(input_check, Result, []))).
open_item_by_kind(open, Item, _, found(Item)).
open_item_by_kind(duty, _, Items, Found) :-
    first_open_item(Items, Found).
open_item_by_kind(no_duty, _, Items, Found) :-
    first_open_item(Items, Found).

obligations_from(found(Item), _, [Item]).
obligations_from(none, Items, Obligations) :-
    include(duty_item, Items, Obligations).

duty_item(item(_, Result, _)) :-
    result_kind(Result, duty).

result_kind(requirement_applies, duty) :-
    implements(eu_reg_2024_1689_art_8_1).
result_kind(requirement_applies_to_testing_data_sets_only, duty) :-
    implements(eu_reg_2024_1689_art_10_6).
result_kind(requirement_applies_and_the_simplified_form_may_be_used, duty) :-
    implements(eu_reg_2024_1689_art_11_1).
result_kind(compliance_required_by_31_december_2030, duty) :-
    implements(eu_reg_2024_1689_art_111_1).
result_kind(compliance_required_by_2_august_2030, duty) :-
    implements(eu_reg_2024_1689_art_111_2).
result_kind(not_applicable_on_date, no_duty) :-
    implements(eu_reg_2024_1689_art_113_c).
result_kind(not_a_high_risk_ai_system, no_duty) :-
    implements(eu_reg_2024_1689_art_8_1).
result_kind(requirement_does_not_apply, no_duty) :-
    implements(eu_reg_2024_1689_art_8_1).
result_kind(existing_system_without_significant_changes_not_covered, no_duty) :-
    implements(eu_reg_2024_1689_art_111_2).
result_kind(input_problems(_), problem).
result_kind(indeterminate(_), open).
result_kind(needs_legal_review(_, _), open).

compliance_candidate(date(2027, 12, 2), cite(eu_reg_2024_1689_art_113_c_i)).
compliance_candidate(date(2028, 8, 2), cite(eu_reg_2024_1689_art_113_c_ii)).
compliance_candidate(date(2030, 8, 2), cite(eu_reg_2024_1689_art_111_2)).
compliance_candidate(date(2030, 12, 31), cite(eu_reg_2024_1689_art_111_1)).

high_risk_requirements_compliance_date(Profile, Requirement, ComplianceDate, Citations) :-
    implements(eu_reg_2024_1689_art_113_c),
    findall(CandidateDate, compliance_candidate(CandidateDate, _), CandidateDates),
    compliance_probe(CandidateDates, Profile, Requirement, ComplianceDate, Citations).

compliance_probe([CandidateDate|CandidateDates], Profile, Requirement, ComplianceDate, Citations) :-
    high_risk_requirement_status(Profile, Requirement, CandidateDate, Result, ResultCitations),
    probe_kind(Result, Kind),
    probe_outcome(Kind, CandidateDate, Result, ResultCitations, CandidateDates, Profile, Requirement, ComplianceDate, Citations).

probe_outcome(applies, CandidateDate, _, ResultCitations, _, _, _, CandidateDate, ResultCitations).
probe_outcome(final, _, Result, ResultCitations, _, _, _, Result, ResultCitations).
probe_outcome(open, _, Result, _, _, _, _, Result, []).
probe_outcome(pass, _, _, _, CandidateDates, Profile, Requirement, ComplianceDate, Citations) :-
    compliance_probe(CandidateDates, Profile, Requirement, ComplianceDate, Citations).

probe_kind(requirement_applies, applies) :-
    implements(eu_reg_2024_1689_art_8_1).
probe_kind(requirement_applies_to_testing_data_sets_only, applies) :-
    implements(eu_reg_2024_1689_art_10_6).
probe_kind(requirement_applies_and_the_simplified_form_may_be_used, applies) :-
    implements(eu_reg_2024_1689_art_11_1).
probe_kind(not_applicable_on_date, pass) :-
    implements(eu_reg_2024_1689_art_113_c).
probe_kind(compliance_required_by_31_december_2030, pass) :-
    implements(eu_reg_2024_1689_art_111_1).
probe_kind(compliance_required_by_2_august_2030, pass) :-
    implements(eu_reg_2024_1689_art_111_2).
probe_kind(not_a_high_risk_ai_system, final) :-
    implements(eu_reg_2024_1689_art_8_1).
probe_kind(requirement_does_not_apply, final) :-
    implements(eu_reg_2024_1689_art_8_1).
probe_kind(existing_system_without_significant_changes_not_covered, final) :-
    implements(eu_reg_2024_1689_art_111_2).
probe_kind(input_problems(_), open).
probe_kind(indeterminate(_), open).
probe_kind(needs_legal_review(_, _), open).
