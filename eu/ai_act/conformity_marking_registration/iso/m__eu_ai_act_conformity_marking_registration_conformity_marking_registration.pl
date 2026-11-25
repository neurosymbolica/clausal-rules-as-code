% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_conformity_marking_registration, [conformity_assessment_procedure/4, annex_vii_notified_body/4, new_conformity_assessment_status/4, declaration_of_conformity_status/4, declaration_keeping_status/4, ce_marking_status/5, registration_status/5, listed_items/3, decide_conformity_marking_registration/2, conformity_marking_registration_status/2, conformity_marking_registration_checklist/2, conformity_marking_registration_decision_resolvable/1, conformity_marking_registration_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [group_pairs_by_key/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_ai_act_conformity_marking_registration_kernel, [conformity_marking_registration_input_problems/2, real_calendar_day_t/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_citations, [implements/1]).

statutory_day(annex_iii_application_day, date(2027, 12, 2), cite(eu_reg_2024_1689_art_113_c_i)).
statutory_day(annex_i_application_day, date(2028, 8, 2), cite(eu_reg_2024_1689_art_113_c_ii)).
statutory_day(public_authority_compliance_day, date(2030, 8, 2), cite(eu_reg_2024_1689_art_111_2)).
statutory_day(annex_x_compliance_day, date(2030, 12, 31), cite(eu_reg_2024_1689_art_111_1)).

conformity_marking_registration_status_values([high_risk_obligations_apply, not_applicable_on_date, not_high_risk_under_annex_iii_or_section_a_of_annex_i, compliance_required_by_31_december_2030, compliance_required_by_2_august_2030, not_applicable_to_a_system_placed_before_the_application_day]).

classification_keys([annex_iii_point, provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_application_day, significant_changes_in_design_from_the_application_day, intended_to_be_used_by_public_authorities]).

query_keys(conformity_assessment_procedure, Keys) :-
    classification_keys(Common),
    append(Common, [harmonised_standards_or_common_specifications_applied_in_full, applied_harmonised_standard_published_with_a_restriction, harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment], Keys).
query_keys(annex_vii_notified_body, Keys) :-
    classification_keys(Common),
    append(Common, [intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies], Keys).
query_keys(new_conformity_assessment_status, Keys) :-
    classification_keys(Common),
    append(Common, [already_subject_to_a_conformity_assessment_procedure, change_pre_determined_for_a_system_that_continues_to_learn, substantial_modification], Keys).
query_keys(declaration_of_conformity_status, Keys) :-
    classification_keys(Common),
    append(Common, [other_union_harmonisation_legislation_requires_an_eu_declaration_of_conformity], Keys).
query_keys(ce_marking_status, Keys) :-
    classification_keys(Common),
    append(Common, [provided_digitally, affixing_to_the_system_possible_and_warranted, notified_body_involved_in_the_conformity_assessment, other_union_law_provides_for_affixing_the_ce_marking], Keys).
query_keys(registration_status, [annex_iii_point, provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_application_day, significant_changes_in_design_from_the_application_day, intended_to_be_used_by_public_authorities, deployer_is_a_public_authority_or_union_institution_body_office_or_agency_or_acts_on_their_behalf]).

read_keys(Query, none, Keys) :-
    query_keys(Query, Keys).
read_keys(ce_marking_status, element(Element), Keys) :-
    element_keys(Element, Extra),
    classification_keys(Common),
    append(Common, Extra, Keys).
read_keys(registration_status, registrant(provider), [annex_iii_point, provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_application_day, significant_changes_in_design_from_the_application_day, intended_to_be_used_by_public_authorities]).
read_keys(registration_status, registrant(deployer), Keys) :-
    query_keys(registration_status, Keys).

judgement_key(significant_changes_in_design_from_the_application_day).
judgement_key(intended_to_be_used_by_public_authorities).
judgement_key(intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies).
judgement_key(substantial_modification).
judgement_key(affixing_to_the_system_possible_and_warranted).

key_domain(annex_iii_point, [not_listed_in_annex_iii, annex_iii_point_1, annex_iii_point_2, annex_iii_point_3, annex_iii_point_6]).
key_domain(Key, [true, false]) :-
    dif(Key, annex_iii_point).

referral(conformity_assessment_procedure, significant_changes_in_design_from_the_application_day, cite(eu_reg_2024_1689_art_111_2)).
referral(conformity_assessment_procedure, intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)).
referral(annex_vii_notified_body, significant_changes_in_design_from_the_application_day, cite(eu_reg_2024_1689_art_111_2)).
referral(annex_vii_notified_body, intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)).
referral(annex_vii_notified_body, intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies, cite(eu_reg_2024_1689_art_43_1)).
referral(new_conformity_assessment_status, significant_changes_in_design_from_the_application_day, cite(eu_reg_2024_1689_art_111_2)).
referral(new_conformity_assessment_status, intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)).
referral(new_conformity_assessment_status, substantial_modification, cite(eu_reg_2024_1689_art_3_23)).
referral(declaration_of_conformity_status, significant_changes_in_design_from_the_application_day, cite(eu_reg_2024_1689_art_111_2)).
referral(declaration_of_conformity_status, intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)).
referral(ce_marking_status, significant_changes_in_design_from_the_application_day, cite(eu_reg_2024_1689_art_111_2)).
referral(ce_marking_status, intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)).
referral(ce_marking_status, affixing_to_the_system_possible_and_warranted, cite(eu_reg_2024_1689_art_48_3)).
referral(registration_status, significant_changes_in_design_from_the_application_day, cite(eu_reg_2024_1689_art_111_2)).
referral(registration_status, intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)).

common_step(application_gate, step(before(annex_iii_application_day), not_applicable_on_date, [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i)])).
common_step(section_a_gate, step(all([negation(annex_iii_high_risk), before(annex_i_application_day)]), not_applicable_on_date, [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_ii)])).
common_step(annex_x_transition, step(all([key(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, true), before(annex_x_compliance_day)]), compliance_required_by_31_december_2030, [cite(eu_reg_2024_1689_art_111_1)])).
common_step(public_authority_transition, step(all([key(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), key(placed_on_the_market_or_put_into_service_before_the_application_day, true), key(significant_changes_in_design_from_the_application_day, false), key(intended_to_be_used_by_public_authorities, true), before(public_authority_compliance_day)]), compliance_required_by_2_august_2030, [cite(eu_reg_2024_1689_art_111_2)])).
common_step(placed_before_application_day, step(all([key(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), key(placed_on_the_market_or_put_into_service_before_the_application_day, true), key(significant_changes_in_design_from_the_application_day, false), key(intended_to_be_used_by_public_authorities, false)]), not_applicable_to_a_system_placed_before_the_application_day, [cite(eu_reg_2024_1689_art_111_2)])).

common_steps(NotHighRiskCitations, Steps) :-
    implements(eu_reg_2024_1689_art_113_c),
    common_step(application_gate, ApplicationGate),
    common_step(section_a_gate, SectionAGate),
    transition_steps(Transitions),
    append([ApplicationGate, step(negation(high_risk), not_high_risk_under_annex_iii_or_section_a_of_annex_i, NotHighRiskCitations), SectionAGate], Transitions, Steps).

transition_steps([AnnexTenStep, PublicAuthorityStep, PlacedBeforeStep]) :-
    implements(eu_reg_2024_1689_art_111_2),
    implements(eu_reg_2024_1689_art_3_9),
    implements(eu_reg_2024_1689_art_3_11),
    common_step(annex_x_transition, AnnexTenStep),
    common_step(public_authority_transition, PublicAuthorityStep),
    common_step(placed_before_application_day, PlacedBeforeStep).

query_ladder(conformity_assessment_procedure, none, Steps) :-
    implements(eu_reg_2024_1689_art_43_3),
    implements(eu_reg_2024_1689_art_43_1_second_subparagraph),
    implements(eu_reg_2024_1689_art_3_27),
    implements(eu_reg_2024_1689_art_3_28),
    common_steps([cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_2), cite(eu_reg_2024_1689_art_43_3)], Common),
    append(Common, [step(all([key(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, true), key(harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment, true), key(harmonised_standards_or_common_specifications_applied_in_full, true)]), procedure_of_the_union_harmonisation_legislation_with_the_option_without_a_third_party, [cite(eu_reg_2024_1689_art_43_3)]), step(all([key(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, true), key(harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment, true)]), procedure_of_the_union_harmonisation_legislation_with_third_party_assessment, [cite(eu_reg_2024_1689_art_43_3)]), step(key(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, true), procedure_of_the_union_harmonisation_legislation, [cite(eu_reg_2024_1689_art_43_3)]), step(all([key(annex_iii_point, annex_iii_point_1), key(harmonised_standards_or_common_specifications_applied_in_full, false)]), notified_body_procedure_under_annex_vii, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_1_second_subparagraph_a), cite(eu_reg_2024_1689_art_43_1_second_subparagraph_b), cite(eu_reg_2024_1689_art_43_1_second_subparagraph_c), cite(eu_reg_2024_1689_annex_vii)]), step(all([key(annex_iii_point, annex_iii_point_1), key(applied_harmonised_standard_published_with_a_restriction, true)]), choice_of_annex_vi_or_annex_vii_with_annex_vii_for_the_restricted_part, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_1_first_subparagraph_a), cite(eu_reg_2024_1689_art_43_1_first_subparagraph_b), cite(eu_reg_2024_1689_art_43_1_second_subparagraph_d), cite(eu_reg_2024_1689_annex_vi), cite(eu_reg_2024_1689_annex_vii)]), step(key(annex_iii_point, annex_iii_point_1), choice_of_internal_control_under_annex_vi_or_notified_body_procedure_under_annex_vii, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_1_first_subparagraph_a), cite(eu_reg_2024_1689_art_43_1_first_subparagraph_b), cite(eu_reg_2024_1689_annex_vi), cite(eu_reg_2024_1689_annex_vii)]), step(always, internal_control_under_annex_vi, [cite(eu_reg_2024_1689_art_43_2), cite(eu_reg_2024_1689_annex_vi)])], Steps).
query_ladder(annex_vii_notified_body, none, Steps) :-
    implements(eu_reg_2024_1689_art_43_1_third_subparagraph),
    implements(eu_reg_2024_1689_art_3_26),
    common_step(application_gate, ApplicationGate),
    common_step(section_a_gate, SectionAGate),
    transition_steps(Transitions),
    append([[ApplicationGate, step(negation(high_risk), not_high_risk_under_annex_iii_or_section_a_of_annex_i, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_2), cite(eu_reg_2024_1689_art_43_3)]), SectionAGate, step(any([key(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, true), negation(key(annex_iii_point, annex_iii_point_1))]), article_43_1_not_applicable, [cite(eu_reg_2024_1689_art_43_1), cite(eu_reg_2024_1689_art_43_2), cite(eu_reg_2024_1689_art_43_3)])], Transitions, [step(key(intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies, true), market_surveillance_authority_acts_as_notified_body, [cite(eu_reg_2024_1689_art_43_1)]), step(always, notified_body_of_the_providers_choice, [cite(eu_reg_2024_1689_art_43_1)])]], Steps).
query_ladder(new_conformity_assessment_status, none, Steps) :-
    implements(eu_reg_2024_1689_art_43_4),
    implements(eu_reg_2024_1689_art_3_20),
    common_steps([cite(eu_reg_2024_1689_art_43_4)], Common),
    append(Common, [step(key(already_subject_to_a_conformity_assessment_procedure, false), no_previous_conformity_assessment, [cite(eu_reg_2024_1689_art_43_4)]), step(key(change_pre_determined_for_a_system_that_continues_to_learn, true), new_conformity_assessment_not_required, [cite(eu_reg_2024_1689_art_43_4), cite(eu_reg_2024_1689_art_3_23)]), step(key(substantial_modification, true), new_conformity_assessment_required, [cite(eu_reg_2024_1689_art_43_4), cite(eu_reg_2024_1689_art_3_23)]), step(always, new_conformity_assessment_not_required, [cite(eu_reg_2024_1689_art_43_4), cite(eu_reg_2024_1689_art_3_23)])], Steps).
query_ladder(declaration_of_conformity_status, none, Steps) :-
    implements(eu_reg_2024_1689_art_47_3),
    common_steps([cite(eu_reg_2024_1689_art_47_1)], Common),
    append(Common, [step(key(other_union_harmonisation_legislation_requires_an_eu_declaration_of_conformity, true), single_declaration_for_all_applicable_union_law, [cite(eu_reg_2024_1689_art_47_1), cite(eu_reg_2024_1689_art_47_3)]), step(always, declaration_under_this_regulation, [cite(eu_reg_2024_1689_art_47_1)])], Steps).
query_ladder(ce_marking_status, element(Element), Steps) :-
    implements(eu_reg_2024_1689_art_48_1),
    implements(eu_reg_2024_1689_art_3_22),
    implements(eu_reg_2024_1689_art_3_24),
    element_rule(Element, RequiredTest, ElementCitations),
    common_steps([cite(eu_reg_2024_1689_art_48_1)], Common),
    append(Common, [step(RequiredTest, marking_element_required, ElementCitations), step(always, marking_element_not_required, ElementCitations)], Steps).
query_ladder(registration_status, registrant(provider), Steps) :-
    implements(eu_reg_2024_1689_art_49_1),
    common_step(application_gate, ApplicationGate),
    transition_steps(Transitions),
    append([[ApplicationGate, step(negation(listed), no_registration_duty, [cite(eu_reg_2024_1689_art_49_1), cite(eu_reg_2024_1689_art_49_2)]), step(all([key(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, true), key(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, true), before(annex_x_compliance_day)]), compliance_required_by_31_december_2030, [cite(eu_reg_2024_1689_art_111_1)]), step(all([key(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, true), secure_section_point]), registration_in_the_secure_non_public_section_of_the_eu_database, [cite(eu_reg_2024_1689_art_49_2), cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_b)]), step(key(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, true), registration_in_the_eu_database, [cite(eu_reg_2024_1689_art_49_2)])], Transitions, [step(key(annex_iii_point, annex_iii_point_2), registration_at_national_level, [cite(eu_reg_2024_1689_art_49_1), cite(eu_reg_2024_1689_art_49_5)]), step(secure_section_point, registration_in_the_secure_non_public_section_of_the_eu_database, [cite(eu_reg_2024_1689_art_49_1), cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_a)]), step(always, registration_in_the_eu_database, [cite(eu_reg_2024_1689_art_49_1)])]], Steps).
query_ladder(registration_status, registrant(deployer), Steps) :-
    implements(eu_reg_2024_1689_art_49_3),
    common_step(application_gate, ApplicationGate),
    transition_steps(Transitions),
    append([[ApplicationGate, step(any([negation(listed), key(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, true), key(annex_iii_point, annex_iii_point_2), key(deployer_is_a_public_authority_or_union_institution_body_office_or_agency_or_acts_on_their_behalf, false)]), no_registration_duty, [cite(eu_reg_2024_1689_art_49_3)])], Transitions, [step(secure_section_point, registration_in_the_secure_non_public_section_of_the_eu_database, [cite(eu_reg_2024_1689_art_49_3), cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_c)]), step(always, registration_in_the_eu_database, [cite(eu_reg_2024_1689_art_49_3)])]], Steps).

element_rule(digital_ce_marking, key(provided_digitally, true), [cite(eu_reg_2024_1689_art_48_1), cite(eu_reg_2024_1689_art_48_2)]).
element_rule(ce_marking_affixed_to_the_system, all([key(provided_digitally, false), key(affixing_to_the_system_possible_and_warranted, true)]), [cite(eu_reg_2024_1689_art_48_1), cite(eu_reg_2024_1689_art_48_2), cite(eu_reg_2024_1689_art_48_3)]).
element_rule(ce_marking_affixed_to_the_packaging_or_accompanying_documentation, all([key(provided_digitally, false), key(affixing_to_the_system_possible_and_warranted, false)]), [cite(eu_reg_2024_1689_art_48_1), cite(eu_reg_2024_1689_art_48_2), cite(eu_reg_2024_1689_art_48_3)]).
element_rule(identification_number_of_the_notified_body, key(notified_body_involved_in_the_conformity_assessment, true), [cite(eu_reg_2024_1689_art_48_1), cite(eu_reg_2024_1689_art_48_4)]).
element_rule(indication_of_the_other_union_law, key(other_union_law_provides_for_affixing_the_ce_marking, true), [cite(eu_reg_2024_1689_art_48_1), cite(eu_reg_2024_1689_art_48_5)]).

element_keys(digital_ce_marking, [provided_digitally]).
element_keys(ce_marking_affixed_to_the_system, [provided_digitally, affixing_to_the_system_possible_and_warranted]).
element_keys(ce_marking_affixed_to_the_packaging_or_accompanying_documentation, [provided_digitally, affixing_to_the_system_possible_and_warranted]).
element_keys(identification_number_of_the_notified_body, [notified_body_involved_in_the_conformity_assessment]).
element_keys(indication_of_the_other_union_law, [other_union_law_provides_for_affixing_the_ce_marking]).

test_t(key(Key, Wanted), Context, Truth) :-
    context_value(Context, Key, Value),
    memberd_t(Value, [Wanted], Truth).
test_t(all([]), _, true).
test_t(all([Test|Tests]), Context, Truth) :-
    test_t(Test, Context, FirstTruth),
    all_continue(FirstTruth, Tests, Context, Truth).
test_t(any([]), _, false).
test_t(any([Test|Tests]), Context, Truth) :-
    test_t(Test, Context, FirstTruth),
    any_continue(FirstTruth, Tests, Context, Truth).
test_t(negation(Test), Context, Truth) :-
    test_t(Test, Context, InnerTruth),
    truth_negation(InnerTruth, Truth).
test_t(before(DayName), context(AssessmentDate, _), Truth) :-
    implements(eu_reg_2024_1689_art_113),
    statutory_day(DayName, StatutoryDate, _),
    date_before_t(AssessmentDate, StatutoryDate, Truth).
test_t(listed, Context, Truth) :-
    implements(eu_reg_2024_1689_art_6_2),
    test_t(negation(key(annex_iii_point, not_listed_in_annex_iii)), Context, Truth).
test_t(annex_iii_high_risk, Context, Truth) :-
    implements(eu_reg_2024_1689_art_6_3),
    test_t(all([listed, key(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, false)]), Context, Truth).
test_t(high_risk, Context, Truth) :-
    implements(eu_reg_2024_1689_art_6_1),
    test_t(any([annex_iii_high_risk, key(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, true)]), Context, Truth).
test_t(secure_section_point, Context, Truth) :-
    implements(eu_reg_2024_1689_art_49_4),
    test_t(any([key(annex_iii_point, annex_iii_point_1), key(annex_iii_point, annex_iii_point_6), key(annex_iii_point, annex_iii_point_7)]), Context, Truth).
test_t(always, _, true).

all_continue(false, _, _, false).
all_continue(true, Tests, Context, Truth) :-
    test_t(all(Tests), Context, Truth).

any_continue(true, _, _, true).
any_continue(false, Tests, Context, Truth) :-
    test_t(any(Tests), Context, Truth).

truth_negation(true, false).
truth_negation(false, true).

context_value(context(_, Facts), Key, Value) :-
    member(Key - Value, Facts).

first_met([step(Test, Result, Citations)|Steps], Context, Answer) :-
    test_t(Test, Context, Truth),
    step_outcome(Truth, Result, Citations, Steps, Context, Answer).

step_outcome(true, Result, Citations, _, _, answer(Result, Citations)).
step_outcome(false, _, _, Steps, Context, Answer) :-
    first_met(Steps, Context, Answer).

day_number(date(Year, Month, DayOfMonth), Number) :-
    Number #= Year * 10000 + Month * 100 + DayOfMonth.

date_before_t(FirstDate, SecondDate, true) :-
    day_number(FirstDate, FirstNumber),
    day_number(SecondDate, SecondNumber),
    FirstNumber #< SecondNumber.
date_before_t(FirstDate, SecondDate, false) :-
    day_number(FirstDate, FirstNumber),
    day_number(SecondDate, SecondNumber),
    FirstNumber #>= SecondNumber.

date_after_t(FirstDate, SecondDate, Truth) :-
    date_before_t(SecondDate, FirstDate, Truth).

argument_known_t(Term, Allowed, Truth) :-
    term_variables(Term, Variables),
    ground_argument_t(Variables, Term, Allowed, Truth).

ground_argument_t([_|_], _, _, false).
ground_argument_t([], Term, Allowed, Truth) :-
    memberd_t(Term, Allowed, Truth).

problems_for(true, _, []).
problems_for(false, Name, [wrong_type(Name)]).

argument_problems(none, []).
argument_problems(element(Element), Problems) :-
    findall(Name, element_rule(Name, _, _), Names),
    argument_known_t(Element, Names, Known),
    problems_for(Known, element, Problems).
argument_problems(registrant(Registrant), Problems) :-
    argument_known_t(Registrant, [provider, deployer], Known),
    problems_for(Known, registrant, Problems).

conformity_assessment_procedure(Profile, AssessmentDate, Result, Citations) :-
    implements(eu_reg_2024_1689_art_43_1),
    query_answer(conformity_assessment_procedure, none, Profile, AssessmentDate, Result, Citations).

annex_vii_notified_body(Profile, AssessmentDate, Result, Citations) :-
    implements(eu_reg_2024_1689_art_43_1_third_subparagraph),
    query_answer(annex_vii_notified_body, none, Profile, AssessmentDate, Result, Citations).

new_conformity_assessment_status(Profile, AssessmentDate, Result, Citations) :-
    implements(eu_reg_2024_1689_art_43_4),
    query_answer(new_conformity_assessment_status, none, Profile, AssessmentDate, Result, Citations).

declaration_of_conformity_status(Profile, AssessmentDate, Result, Citations) :-
    implements(eu_reg_2024_1689_art_47_1),
    query_answer(declaration_of_conformity_status, none, Profile, AssessmentDate, Result, Citations).

ce_marking_status(Profile, Element, AssessmentDate, Result, Citations) :-
    implements(eu_reg_2024_1689_art_48_1),
    query_answer(ce_marking_status, element(Element), Profile, AssessmentDate, Result, Citations).

registration_status(Profile, Registrant, AssessmentDate, Result, Citations) :-
    implements(eu_reg_2024_1689_art_49_1),
    query_answer(registration_status, registrant(Registrant), Profile, AssessmentDate, Result, Citations).

query_answer(Query, Argument, Profile, AssessmentDate, Result, Citations) :-
    conformity_marking_registration_input_problems(Profile, ProfileProblems),
    argument_problems(Argument, ArgumentProblems),
    real_calendar_day_t(AssessmentDate, DateIsReal),
    problems_for(DateIsReal, assessment_date, DateProblems),
    append([ProfileProblems, ArgumentProblems, DateProblems], Problems),
    answer_for_problems(Problems, Query, Argument, Profile, AssessmentDate, Result, Citations).

answer_for_problems([Problem|Problems], _, _, _, _, input_problems([Problem|Problems]), []).
answer_for_problems([], Query, Argument, Profile, AssessmentDate, Result, Citations) :-
    statutory_day(annex_iii_application_day, ApplicationDay, _),
    date_before_t(AssessmentDate, ApplicationDay, Early),
    determine_by_date(Early, Query, Argument, Profile, AssessmentDate, Result, Citations).

determine_by_date(true, _, _, _, _, not_applicable_on_date, Citations) :-
    implements(eu_reg_2024_1689_art_113_c_i),
    common_step(application_gate, step(_, not_applicable_on_date, Citations)).
determine_by_date(false, Query, Argument, Profile, AssessmentDate, Result, Citations) :-
    status_rule(Query, Argument, Profile, AssessmentDate, Result, Citations).

status_rule(Query, Argument, Profile, AssessmentDate, Result, Citations) :-
    query_keys(Query, QueryKeys),
    read_keys(Query, Argument, ReadKeys),
    key_slots(ReadKeys, Profile, Fixed, Free),
    query_ladder(Query, Argument, Steps),
    findall(Values - Answer, completion_answer(Free, Fixed, AssessmentDate, Steps, Values, Answer), Entries),
    findall(Answer, member(_ - Answer, Entries), Answers),
    sort(Answers, DistinctAnswers),
    resolve_answers(DistinctAnswers, Query, QueryKeys, Profile, Free, Entries, Result, Citations).

key_slots([], _, [], []).
key_slots([Key|Keys], Profile, Fixed, Free) :-
    key_slot(Profile, Key, Slot),
    key_slots(Keys, Profile, RestFixed, RestFree),
    place_slot(Slot, RestFixed, RestFree, Fixed, Free).

key_slot(Profile, Key, free(Key, absent)) :-
    profile_lacks(Profile, Key).
key_slot(Profile, Key, free(Key, unsure)) :-
    profile_get(Profile, Key, unsure).
key_slot(Profile, Key, fixed(Key, Value)) :-
    profile_get(Profile, Key, Value),
    dif(Value, unsure).

place_slot(fixed(Key, Value), RestFixed, RestFree, [Key - Value|RestFixed], RestFree).
place_slot(free(Key, Kind), RestFixed, RestFree, RestFixed, [free(Key, Kind)|RestFree]).

completion_answer(Free, Fixed, AssessmentDate, Steps, Values, answer(Result, SortedCitations)) :-
    completion(Free, Values, Assigned),
    append(Fixed, Assigned, Facts),
    first_met(Steps, context(AssessmentDate, Facts), answer(Result, Citations)),
    sort(Citations, SortedCitations).

completion([], [], []).
completion([free(Key, _)|Frees], [Value|Values], [Key - Value|Assigned]) :-
    key_domain(Key, Domain),
    member(Value, Domain),
    completion(Frees, Values, Assigned).

resolve_answers([answer(Result, Citations)], _, _, _, _, _, Result, Citations).
resolve_answers([_, _|_], Query, QueryKeys, Profile, Free, Entries, Result, Citations) :-
    witness_rows(Free, 0, Entries, Rows),
    mattering_rows(Rows, MatteringRows),
    absent_rows(Rows, AbsentRows),
    absent_rows(MatteringRows, AbsentMatteringRows),
    unsettled_answer(AbsentMatteringRows, AbsentRows, MatteringRows, Query, QueryKeys, Profile, Result, Citations).

unsettled_answer([First|Others], AbsentRows, _, _, _, _, indeterminate([Key]), []) :-
    unbehind_rows([First|Others], AbsentRows, Candidates),
    chosen_row(Candidates, First, witnesses(Key, _, _, _)).
unsettled_answer([], _, [witnesses(Judgement, _, _, _)|_], Query, QueryKeys, Profile, needs_legal_review(open_textured(Judgement, Citation), [inputs_relied_on(Pairs)]), []) :-
    referral(Query, Judgement, Citation),
    relied_pairs(QueryKeys, Profile, Pairs).

chosen_row([Row|_], _, Row).
chosen_row([], Fallback, Fallback).

relied_pairs(QueryKeys, Profile, Pairs) :-
    findall(Key - Value, relied_pair(QueryKeys, Profile, Key, Value), Pairs).

relied_pair(QueryKeys, Profile, Key, Value) :-
    member(Key, QueryKeys),
    judgement_key(Key),
    profile_get(Profile, Key, Value).

witness_rows([], _, _, []).
witness_rows([free(Key, Kind)|Frees], Index, Entries, [witnesses(Key, Kind, Index, Tuples)|Rows]) :-
    key_witness_tuples(Entries, Index, Tuples),
    NextIndex #= Index + 1,
    witness_rows(Frees, NextIndex, Entries, Rows).

key_witness_tuples(Entries, Index, Tuples) :-
    findall(Rest - (Tuple - Answer), keyed_entry(Entries, Index, Rest, Tuple, Answer), Keyed),
    keysort(Keyed, Sorted),
    group_pairs_by_key(Sorted, Groups),
    findall(Tuple, varying_tuple(Groups, Tuple), Tuples).

keyed_entry(Entries, Index, Rest, Tuple, Answer) :-
    member(Tuple - Answer, Entries),
    without_position(Index, Tuple, Rest).

varying_tuple(Groups, Tuple) :-
    member(_ - Members, Groups),
    varying_members(Members),
    member(Tuple - _, Members).

varying_members(Members) :-
    findall(Answer, member(_ - Answer, Members), Answers),
    sort(Answers, [_, _|_]).

without_position(0, [_|Rest], Rest).
without_position(Index, [Value|Values], [Value|Rest]) :-
    Index #> 0,
    Previous #= Index - 1,
    without_position(Previous, Values, Rest).

mattering_rows([], []).
mattering_rows([witnesses(_, _, _, [])|Rows], Mattering) :-
    mattering_rows(Rows, Mattering).
mattering_rows([witnesses(Key, Kind, Index, [Tuple|Tuples])|Rows], [witnesses(Key, Kind, Index, [Tuple|Tuples])|Mattering]) :-
    mattering_rows(Rows, Mattering).

absent_rows([], []).
absent_rows([witnesses(_, unsure, _, _)|Rows], Absent) :-
    absent_rows(Rows, Absent).
absent_rows([witnesses(Key, absent, Index, Tuples)|Rows], [witnesses(Key, absent, Index, Tuples)|Absent]) :-
    absent_rows(Rows, Absent).

unbehind_rows([], _, []).
unbehind_rows([Row|Rows], AbsentRows, Candidates) :-
    behind_some_t(Row, AbsentRows, Truth),
    keep_unbehind(Truth, Row, Rest, Candidates),
    unbehind_rows(Rows, AbsentRows, Rest).

keep_unbehind(true, _, Rest, Rest).
keep_unbehind(false, Row, Rest, [Row|Rest]).

behind_some_t(_, [], false).
behind_some_t(Row, [Other|Others], Truth) :-
    behind_t(Row, Other, FirstTruth),
    behind_continue(FirstTruth, Row, Others, Truth).

behind_continue(true, _, _, true).
behind_continue(false, Row, Others, Truth) :-
    behind_some_t(Row, Others, Truth).

behind_t(witnesses(Key, _, _, _), witnesses(Key, _, _, _), false).
behind_t(witnesses(Key, _, KeyIndex, KeyTuples), witnesses(OtherKey, _, OtherIndex, OtherTuples), Truth) :-
    dif(Key, OtherKey),
    projected_count(KeyTuples, OtherIndex, OtherSeen),
    key_domain(OtherKey, OtherDomain),
    length(OtherDomain, OtherSize),
    projected_count(OtherTuples, KeyIndex, KeySeen),
    key_domain(Key, KeyDomain),
    length(KeyDomain, KeySize),
    behind_counts_t(OtherSeen, OtherSize, KeySeen, KeySize, Truth).

behind_counts_t(OtherSeen, OtherSize, KeySeen, KeySize, true) :-
    OtherSeen #< OtherSize,
    KeySeen #= KeySize.
behind_counts_t(OtherSeen, OtherSize, _, _, false) :-
    OtherSeen #>= OtherSize.
behind_counts_t(OtherSeen, OtherSize, KeySeen, KeySize, false) :-
    OtherSeen #< OtherSize,
    KeySeen #< KeySize.

projected_count(Tuples, Index, Count) :-
    findall(Value, projected_value(Tuples, Index, Value), Values),
    sort(Values, Distinct),
    length(Distinct, Count).

projected_value(Tuples, Index, Value) :-
    member(Tuple, Tuples),
    nth0(Index, Tuple, Value).

declaration_keeping_status(PlacingDate, AssessmentDate, Result, Citations) :-
    implements(eu_reg_2024_1689_art_47_1),
    real_calendar_day_t(PlacingDate, PlacingIsReal),
    real_calendar_day_t(AssessmentDate, AssessmentIsReal),
    keeping_problems(PlacingIsReal, AssessmentIsReal, PlacingDate, AssessmentDate, Problems),
    keeping_answer(Problems, PlacingDate, AssessmentDate, Result, Citations).

keeping_problems(true, true, PlacingDate, AssessmentDate, Problems) :-
    date_before_t(AssessmentDate, PlacingDate, Earlier),
    problems_for_order(Earlier, Problems).
keeping_problems(true, false, _, _, [wrong_type(assessment_date)]).
keeping_problems(false, true, _, _, [wrong_type(placing_date)]).
keeping_problems(false, false, _, _, [wrong_type(placing_date), wrong_type(assessment_date)]).

problems_for_order(true, [wrong_type(assessment_date)]).
problems_for_order(false, []).

keeping_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
keeping_answer([], PlacingDate, AssessmentDate, Result, Citations) :-
    keeping_end_day(PlacingDate, EndDay),
    date_after_t(AssessmentDate, EndDay, After),
    keeping_result(After, Result, Citations).

keeping_result(true, keeping_period_ended, [cite(eu_reg_2024_1689_art_47_1)]).
keeping_result(false, declaration_to_be_kept, [cite(eu_reg_2024_1689_art_47_1)]).

keeping_end_day(date(Year, Month, DayOfMonth), date(EndYear, Month, EndDayOfMonth)) :-
    implements(eu_reg_2024_1689_art_47_1),
    EndYear #= Year + 10,
    month_last_day(EndYear, Month, LastDayOfMonth),
    EndDayOfMonth #= min(DayOfMonth, LastDayOfMonth).

item_list(annex_vi_internal_control, [verification_of_the_quality_management_system_against_article_17, examination_of_the_technical_documentation_against_the_essential_requirements, verification_of_the_consistency_of_design_development_and_post_market_monitoring_with_the_technical_documentation], [cite(eu_reg_2024_1689_annex_vi), cite(eu_reg_2024_1689_annex_vi_1), cite(eu_reg_2024_1689_annex_vi_2), cite(eu_reg_2024_1689_annex_vi_3), cite(eu_reg_2024_1689_annex_vi_4)]).
item_list(annex_vii_quality_management_system_application, [name_and_address_of_the_provider_and_of_any_authorised_representative_lodging_the_application, list_of_ai_systems_covered_by_the_quality_management_system, technical_documentation_for_each_ai_system_covered, documentation_of_the_quality_management_system, description_of_the_procedures_keeping_the_quality_management_system_adequate_and_effective, written_declaration_that_the_application_has_not_been_lodged_with_another_notified_body], [cite(eu_reg_2024_1689_annex_vii), cite(eu_reg_2024_1689_annex_vii_1), cite(eu_reg_2024_1689_annex_vii_3_1), cite(eu_reg_2024_1689_annex_vii_3_1_a), cite(eu_reg_2024_1689_annex_vii_3_1_b), cite(eu_reg_2024_1689_annex_vii_3_1_c), cite(eu_reg_2024_1689_annex_vii_3_1_d), cite(eu_reg_2024_1689_annex_vii_3_1_e), cite(eu_reg_2024_1689_annex_vii_3_1_f)]).
item_list(annex_vii_technical_documentation_application, [name_and_address_of_the_provider, written_declaration_that_the_application_has_not_been_lodged_with_another_notified_body, technical_documentation_referred_to_in_annex_iv], [cite(eu_reg_2024_1689_annex_vii), cite(eu_reg_2024_1689_annex_vii_1), cite(eu_reg_2024_1689_annex_vii_4_2), cite(eu_reg_2024_1689_annex_vii_4_2_a), cite(eu_reg_2024_1689_annex_vii_4_2_b), cite(eu_reg_2024_1689_annex_vii_4_2_c)]).
item_list(annex_viii_section_a, [name_address_and_contact_details_of_the_provider, name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_provider, name_address_and_contact_details_of_the_authorised_representative, trade_name_and_unambiguous_reference_for_identification_and_traceability, description_of_the_intended_purpose_and_of_the_components_and_functions, description_of_the_information_used_and_of_the_operating_logic, status_of_the_ai_system, type_number_and_expiry_date_of_the_certificate_and_name_or_number_of_the_notified_body, scanned_copy_of_the_certificate, member_states_where_placed_on_the_market_put_into_service_or_made_available, copy_of_the_eu_declaration_of_conformity, electronic_instructions_for_use, url_for_additional_information], [cite(eu_reg_2024_1689_annex_viii), cite(eu_reg_2024_1689_annex_viii_section_a), cite(eu_reg_2024_1689_annex_viii_section_a_1), cite(eu_reg_2024_1689_annex_viii_section_a_2), cite(eu_reg_2024_1689_annex_viii_section_a_3), cite(eu_reg_2024_1689_annex_viii_section_a_4), cite(eu_reg_2024_1689_annex_viii_section_a_5), cite(eu_reg_2024_1689_annex_viii_section_a_6), cite(eu_reg_2024_1689_annex_viii_section_a_7), cite(eu_reg_2024_1689_annex_viii_section_a_8), cite(eu_reg_2024_1689_annex_viii_section_a_9), cite(eu_reg_2024_1689_annex_viii_section_a_10), cite(eu_reg_2024_1689_annex_viii_section_a_11), cite(eu_reg_2024_1689_annex_viii_section_a_12), cite(eu_reg_2024_1689_annex_viii_section_a_13)]).
item_list(annex_viii_section_b, [name_address_and_contact_details_of_the_provider, name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_provider, name_address_and_contact_details_of_the_authorised_representative, trade_name_and_unambiguous_reference_for_identification_and_traceability, description_of_the_intended_purpose, conditions_under_article_6_3_on_which_the_system_is_considered_not_high_risk, status_of_the_ai_system], [cite(eu_reg_2024_1689_annex_viii), cite(eu_reg_2024_1689_annex_viii_section_b), cite(eu_reg_2024_1689_annex_viii_section_b_1), cite(eu_reg_2024_1689_annex_viii_section_b_2), cite(eu_reg_2024_1689_annex_viii_section_b_3), cite(eu_reg_2024_1689_annex_viii_section_b_4), cite(eu_reg_2024_1689_annex_viii_section_b_5), cite(eu_reg_2024_1689_annex_viii_section_b_6), cite(eu_reg_2024_1689_annex_viii_section_b_8)]).
item_list(annex_viii_section_c, [name_address_and_contact_details_of_the_deployer, name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_deployer, url_of_the_providers_entry_in_the_eu_database, summary_of_the_findings_of_the_fundamental_rights_impact_assessment, summary_of_the_data_protection_impact_assessment], [cite(eu_reg_2024_1689_annex_viii), cite(eu_reg_2024_1689_annex_viii_section_c), cite(eu_reg_2024_1689_annex_viii_section_c_1), cite(eu_reg_2024_1689_annex_viii_section_c_2), cite(eu_reg_2024_1689_annex_viii_section_c_3), cite(eu_reg_2024_1689_annex_viii_section_c_4), cite(eu_reg_2024_1689_annex_viii_section_c_5)]).
item_list(annex_ix, [union_wide_unique_single_identification_number_of_the_testing, name_and_contact_details_of_the_provider_and_of_the_deployers_involved_in_the_testing, brief_description_of_the_ai_system_and_of_its_intended_purpose, summary_of_the_main_characteristics_of_the_testing_plan, information_on_suspension_or_termination_of_the_testing], [cite(eu_reg_2024_1689_annex_ix), cite(eu_reg_2024_1689_annex_ix_1), cite(eu_reg_2024_1689_annex_ix_2), cite(eu_reg_2024_1689_annex_ix_3), cite(eu_reg_2024_1689_annex_ix_4), cite(eu_reg_2024_1689_annex_ix_5)]).
item_list(annex_viii_section_a_secure_section, [name_address_and_contact_details_of_the_provider, name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_provider, name_address_and_contact_details_of_the_authorised_representative, trade_name_and_unambiguous_reference_for_identification_and_traceability, description_of_the_intended_purpose_and_of_the_components_and_functions, status_of_the_ai_system, member_states_where_placed_on_the_market_put_into_service_or_made_available], [cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_a), cite(eu_reg_2024_1689_annex_viii_section_a), cite(eu_reg_2024_1689_annex_viii_section_a_1), cite(eu_reg_2024_1689_annex_viii_section_a_2), cite(eu_reg_2024_1689_annex_viii_section_a_3), cite(eu_reg_2024_1689_annex_viii_section_a_4), cite(eu_reg_2024_1689_annex_viii_section_a_5), cite(eu_reg_2024_1689_annex_viii_section_a_7), cite(eu_reg_2024_1689_annex_viii_section_a_10)]).
item_list(annex_viii_section_b_secure_section, [name_address_and_contact_details_of_the_provider, name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_provider, name_address_and_contact_details_of_the_authorised_representative, trade_name_and_unambiguous_reference_for_identification_and_traceability, description_of_the_intended_purpose, status_of_the_ai_system], [cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_b), cite(eu_reg_2024_1689_annex_viii_section_b), cite(eu_reg_2024_1689_annex_viii_section_b_1), cite(eu_reg_2024_1689_annex_viii_section_b_2), cite(eu_reg_2024_1689_annex_viii_section_b_3), cite(eu_reg_2024_1689_annex_viii_section_b_4), cite(eu_reg_2024_1689_annex_viii_section_b_5), cite(eu_reg_2024_1689_annex_viii_section_b_8)]).
item_list(annex_viii_section_c_secure_section, [name_address_and_contact_details_of_the_deployer, name_address_and_contact_details_of_the_person_submitting_on_behalf_of_the_deployer, url_of_the_providers_entry_in_the_eu_database], [cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_c), cite(eu_reg_2024_1689_annex_viii_section_c), cite(eu_reg_2024_1689_annex_viii_section_c_1), cite(eu_reg_2024_1689_annex_viii_section_c_2), cite(eu_reg_2024_1689_annex_viii_section_c_3)]).
item_list(annex_ix_secure_section, [union_wide_unique_single_identification_number_of_the_testing, name_and_contact_details_of_the_provider_and_of_the_deployers_involved_in_the_testing, brief_description_of_the_ai_system_and_of_its_intended_purpose, information_on_suspension_or_termination_of_the_testing], [cite(eu_reg_2024_1689_art_49_4), cite(eu_reg_2024_1689_art_49_4_d), cite(eu_reg_2024_1689_annex_ix), cite(eu_reg_2024_1689_annex_ix_1), cite(eu_reg_2024_1689_annex_ix_2), cite(eu_reg_2024_1689_annex_ix_3), cite(eu_reg_2024_1689_annex_ix_5)]).

listed_items(ItemList, Items, Citations) :-
    findall(Name, item_list(Name, _, _), Names),
    argument_known_t(ItemList, Names, Known),
    listed_items_answer(Known, ItemList, Items, Citations).

listed_items_answer(true, ItemList, Items, Citations) :-
    implements(eu_reg_2024_1689_annex_viii),
    implements(eu_reg_2026_1744_art_1_42),
    item_list(ItemList, Items, Citations).
listed_items_answer(false, _, input_problems([wrong_type(item_list)]), []).

assessment_case_t(Case, false) :-
    var(Case).
assessment_case_t(Case, Truth) :-
    nonvar(Case),
    functor(Case, Name, Arity),
    memberd_t(Name/Arity, [assessment/2], Truth).

decide_conformity_marking_registration(Case, Verdict) :-
    assessment_case_t(Case, Truth),
    decide_case(Truth, Case, Verdict).

decide_case(true, assessment(Profile, AssessmentDate), conformity_marking_registration_verdict(Status, Citations)) :-
    implements(eu_reg_2024_1689_art_43_1),
    conformity_assessment_procedure(Profile, AssessmentDate, Result, Citations),
    status_row(Result, Status).
decide_case(false, _, conformity_marking_registration_verdict(input_problems([wrong_type(case)]), [])).

status_row(procedure_of_the_union_harmonisation_legislation, high_risk_obligations_apply).
status_row(procedure_of_the_union_harmonisation_legislation_with_the_option_without_a_third_party, high_risk_obligations_apply).
status_row(procedure_of_the_union_harmonisation_legislation_with_third_party_assessment, high_risk_obligations_apply).
status_row(choice_of_internal_control_under_annex_vi_or_notified_body_procedure_under_annex_vii, high_risk_obligations_apply).
status_row(choice_of_annex_vi_or_annex_vii_with_annex_vii_for_the_restricted_part, high_risk_obligations_apply).
status_row(notified_body_procedure_under_annex_vii, high_risk_obligations_apply).
status_row(internal_control_under_annex_vi, high_risk_obligations_apply).
status_row(not_applicable_on_date, not_applicable_on_date).
status_row(not_high_risk_under_annex_iii_or_section_a_of_annex_i, not_high_risk_under_annex_iii_or_section_a_of_annex_i).
status_row(compliance_required_by_31_december_2030, compliance_required_by_31_december_2030).
status_row(compliance_required_by_2_august_2030, compliance_required_by_2_august_2030).
status_row(not_applicable_to_a_system_placed_before_the_application_day, not_applicable_to_a_system_placed_before_the_application_day).
status_row(indeterminate(Keys), indeterminate(Keys)).
status_row(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
status_row(input_problems(Problems), input_problems(Problems)).

conformity_marking_registration_status(Case, Status) :-
    decide_conformity_marking_registration(Case, conformity_marking_registration_verdict(Status, _)).

conformity_marking_registration_checklist(Case, Items) :-
    assessment_case_t(Case, Truth),
    checklist_for(Truth, Case, Items).

checklist_for(true, assessment(Profile, AssessmentDate), Items) :-
    findall(item(Identifier, Result, Citations), checklist_row(Profile, AssessmentDate, Identifier, Result, Citations), Items).
checklist_for(false, _, [item(overall, input_problems([wrong_type(case)]), [])]).

checklist_row(Profile, AssessmentDate, conformity_assessment_procedure, Result, Citations) :-
    conformity_assessment_procedure(Profile, AssessmentDate, Result, Citations).
checklist_row(Profile, AssessmentDate, annex_vii_notified_body, Result, Citations) :-
    annex_vii_notified_body(Profile, AssessmentDate, Result, Citations).
checklist_row(Profile, AssessmentDate, new_conformity_assessment_status, Result, Citations) :-
    new_conformity_assessment_status(Profile, AssessmentDate, Result, Citations).
checklist_row(Profile, AssessmentDate, declaration_of_conformity_status, Result, Citations) :-
    declaration_of_conformity_status(Profile, AssessmentDate, Result, Citations).
checklist_row(Profile, AssessmentDate, Element, Result, Citations) :-
    element_rule(Element, _, _),
    ce_marking_status(Profile, Element, AssessmentDate, Result, Citations).
checklist_row(Profile, AssessmentDate, provider_registration, Result, Citations) :-
    registration_status(Profile, provider, AssessmentDate, Result, Citations).
checklist_row(Profile, AssessmentDate, deployer_registration, Result, Citations) :-
    registration_status(Profile, deployer, AssessmentDate, Result, Citations).

conformity_marking_registration_decision_resolvable(Case) :-
    decide_conformity_marking_registration(Case, _).

test(before_the_application_day_nothing_applies) :-
    conformity_assessment_procedure([], date(2027, 12, 1), Result, Citations),
    Result == not_applicable_on_date,
    member(cite(eu_reg_2024_1689_art_113_c_i), Citations).
test(a_point_three_system_follows_internal_control) :-
    conformity_assessment_procedure([attribute(annex_iii_point, annex_iii_point_3), attribute(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, false), attribute(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, false), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_application_day, false)], date(2029, 1, 1), Result, _),
    Result == internal_control_under_annex_vi.
test(a_point_one_system_without_full_standards_follows_annex_vii) :-
    conformity_assessment_procedure([attribute(annex_iii_point, annex_iii_point_1), attribute(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, false), attribute(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, false), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_application_day, false), attribute(harmonised_standards_or_common_specifications_applied_in_full, false)], date(2029, 1, 1), Result, _),
    Result == notified_body_procedure_under_annex_vii.
test(a_section_a_system_waits_for_august_2028) :-
    conformity_assessment_procedure([attribute(annex_iii_point, not_listed_in_annex_iii), attribute(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, true), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_application_day, false)], date(2028, 1, 1), Result, Citations),
    Result == not_applicable_on_date,
    member(cite(eu_reg_2024_1689_art_113_c_ii), Citations).
test(an_unsure_substantial_modification_goes_to_a_lawyer) :-
    new_conformity_assessment_status([attribute(annex_iii_point, annex_iii_point_3), attribute(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, false), attribute(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, false), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_application_day, false), attribute(already_subject_to_a_conformity_assessment_procedure, true), attribute(change_pre_determined_for_a_system_that_continues_to_learn, false), attribute(substantial_modification, unsure)], date(2029, 1, 1), Result, Citations),
    Result == needs_legal_review(open_textured(substantial_modification, cite(eu_reg_2024_1689_art_3_23)), [inputs_relied_on([substantial_modification - unsure])]),
    Citations == [].
test(an_empty_profile_asks_for_the_annex_iii_point_once) :-
    findall(Result - Citations, registration_status([], provider, date(2029, 1, 1), Result, Citations), Answers),
    Answers == [indeterminate([annex_iii_point]) - []].
test(a_public_deployer_of_a_point_one_system_registers_in_the_secure_section) :-
    registration_status([attribute(annex_iii_point, annex_iii_point_1), attribute(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, false), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_application_day, false), attribute(deployer_is_a_public_authority_or_union_institution_body_office_or_agency_or_acts_on_their_behalf, true)], deployer, date(2029, 1, 1), Result, _),
    Result == registration_in_the_secure_non_public_section_of_the_eu_database.
test(the_argument_problems_follow_the_profile_problems) :-
    registration_status([attribute(colour, red)], somebody, tomorrow, Result, Citations),
    Result == input_problems([unknown_key(colour), wrong_type(registrant), wrong_type(assessment_date)]),
    Citations == [].
test(an_unknown_element_is_a_problem) :-
    ce_marking_status([], colour, date(2029, 1, 1), Result, []),
    Result == input_problems([wrong_type(element)]).
test(a_leap_day_declaration_is_kept_to_28_february) :-
    declaration_keeping_status(date(2028, 2, 29), date(2038, 2, 28), declaration_to_be_kept, [cite(eu_reg_2024_1689_art_47_1)]).
test(the_keeping_period_ends_after_the_end_day) :-
    declaration_keeping_status(date(2028, 2, 29), date(2038, 3, 1), keeping_period_ended, [cite(eu_reg_2024_1689_art_47_1)]).
test(an_assessment_before_the_placing_is_a_problem) :-
    declaration_keeping_status(date(2028, 2, 29), date(2028, 2, 28), input_problems([wrong_type(assessment_date)]), []).
test(the_secure_section_b_list_has_six_items) :-
    listed_items(annex_viii_section_b_secure_section, Items, _),
    length(Items, 6).
test(an_unknown_list_is_a_problem) :-
    listed_items(colour, input_problems([wrong_type(item_list)]), []).
test(the_facade_projects_the_procedure) :-
    decide_conformity_marking_registration(assessment([attribute(annex_iii_point, annex_iii_point_3), attribute(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, false), attribute(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, false), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_application_day, false)], date(2029, 1, 1)), conformity_marking_registration_verdict(high_risk_obligations_apply, _)).

test(a_point_three_system_is_not_the_notified_body_procedure, fail) :-
    conformity_assessment_procedure([attribute(annex_iii_point, annex_iii_point_3), attribute(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, false), attribute(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, false), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_application_day, false)], date(2029, 1, 1), notified_body_procedure_under_annex_vii, _).
