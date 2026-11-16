% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_scope_and_roles_fixtures, [scope_and_roles_subject/1, scope_and_roles_profile_for/2, scope_and_roles_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_scope_and_roles_scope_and_roles, [regulation_scope_status/4, defined_role_status/5, value_chain_provider_status/4, initial_provider_status/4, supplier_agreement_status/4]).

subject_question(eu_provider_placing_on_market, regulation_scope, date(2026, 8, 1)).
subject_question(eu_provider_not_placing_on_market, regulation_scope, date(2026, 8, 1)).
subject_question(third_country_provider_output_in_union, regulation_scope, date(2026, 8, 1)).
subject_question(third_country_provider_output_outside_union, regulation_scope, date(2026, 8, 1)).
subject_question(professional_deployer_in_union, regulation_scope, date(2026, 8, 1)).
subject_question(personal_use_deployer, regulation_scope, date(2026, 8, 1)).
subject_question(military_system_excluded, regulation_scope, date(2026, 8, 1)).
subject_question(open_source_not_high_risk_excluded, regulation_scope, date(2026, 8, 1)).
subject_question(open_source_high_risk_in_scope, regulation_scope, date(2026, 8, 1)).
subject_question(section_b_high_risk_listed_provisions, regulation_scope, date(2026, 8, 1)).
subject_question(authorised_representative_of_third_country_provider, regulation_scope, date(2026, 8, 1)).
subject_question(authorised_representative_of_union_provider, regulation_scope, date(2026, 8, 1)).
subject_question(pre_market_testing_excluded, regulation_scope, date(2026, 8, 1)).
subject_question(real_world_testing_in_scope, regulation_scope, date(2026, 8, 1)).
subject_question(third_country_authority_with_safeguards, regulation_scope, date(2026, 8, 1)).
subject_question(third_country_authority_without_safeguards, regulation_scope, date(2026, 8, 1)).
subject_question(date_before_application, regulation_scope, date(2025, 2, 1)).
subject_question(date_in_earlier_text_window, regulation_scope, date(2025, 2, 2)).
subject_question(date_last_day_of_earlier_text, regulation_scope, date(2026, 7, 26)).
subject_question(date_first_day_of_pinned_text, regulation_scope, date(2026, 7, 27)).
subject_question(missing_actor_role_indeterminate, regulation_scope, date(2026, 8, 1)).
subject_question(unsure_ai_system_referral, regulation_scope, date(2026, 8, 1)).
subject_question(malformed_judgement_input_problem, regulation_scope, date(2026, 8, 1)).
subject_question(provider_role_holds, defined_role(provider), date(2026, 8, 1)).
subject_question(developer_without_placing_not_provider, defined_role(provider), date(2026, 8, 1)).
subject_question(plain_distributor_role_holds, defined_role(distributor), date(2026, 8, 1)).
subject_question(distributor_that_is_importer, defined_role(distributor), date(2026, 8, 1)).
subject_question(product_manufacturer_is_operator, defined_role(operator), date(2026, 8, 1)).
subject_question(no_role_is_not_operator, defined_role(operator), date(2026, 8, 1)).
subject_question(rebranding_distributor_considered_provider, value_chain_provider, date(2028, 9, 1)).
subject_question(distributor_without_change_not_provider, value_chain_provider, date(2028, 9, 1)).
subject_question(annex_iii_before_article_25_applies, value_chain_provider, date(2027, 12, 1)).
subject_question(annex_iii_on_article_25_day, value_chain_provider, date(2027, 12, 2)).
subject_question(annex_i_in_window_not_applicable, value_chain_provider, date(2028, 8, 1)).
subject_question(annex_i_on_application_day, value_chain_provider, date(2028, 8, 2)).
subject_question(initial_provider_clearly_specified, initial_provider, date(2028, 9, 1)).
subject_question(initial_provider_must_cooperate, initial_provider, date(2028, 9, 1)).
subject_question(initial_provider_unaffected_case, initial_provider, date(2028, 9, 1)).
subject_question(open_source_supplier_no_agreement, supplier_agreement, date(2028, 9, 1)).
subject_question(general_purpose_model_supplier_agreement_required, supplier_agreement, date(2028, 9, 1)).

scope_and_roles_subject(Subject) :-
    subject_question(Subject, _Question, _AssessmentDate).

scope_base([attribute(ai_system, true), attribute(exclusively_for_military_defence_or_national_security_purposes, false), attribute(third_country_public_authority_or_international_organisation_in_law_enforcement_and_judicial_cooperation, false), attribute(adequate_safeguards_for_fundamental_rights_and_freedoms, false), attribute(specifically_developed_and_put_into_service_for_the_sole_purpose_of_scientific_research_and_development, false), attribute(research_testing_or_development_before_placing_on_the_market_or_putting_into_service, false), attribute(testing_in_real_world_conditions, false), attribute(released_under_free_and_open_source_licence, false), attribute(placed_on_the_market_or_put_into_service_as_high_risk_or_under_article_5_or_50, false), attribute(actor_role, provider), attribute(use_in_a_personal_non_professional_activity, false), attribute(places_or_puts_into_service_the_system_together_with_its_product, false), attribute(under_its_own_name_or_trademark, true), attribute(places_the_system_on_the_union_market, true), attribute(puts_the_system_into_service_in_the_union, false), attribute(established_or_located_in_the_union, true), attribute(located_in_the_union, true), attribute(output_used_in_the_union, true), attribute(represented_provider_established_in_the_union, true), attribute(high_risk_under_article_6_1_related_to_a_product_under_section_b_of_annex_i, false)]).

value_chain_base([attribute(high_risk_route, annex_iii), attribute(product_manufacturer_of_a_product_under_section_a_of_annex_i_with_the_system_as_safety_component, false), attribute(system_is_high_risk_after_the_change, false), attribute(puts_its_name_or_trademark_on_a_high_risk_system_already_placed_or_in_service, true), attribute(makes_a_substantial_modification_to_a_high_risk_system_already_placed_or_in_service, false), attribute(modifies_the_intended_purpose_of_a_system_not_classified_as_high_risk_already_placed_or_in_service, false), attribute(system_placed_on_the_market_together_with_the_product_under_the_manufacturer_name, false), attribute(system_put_into_service_under_the_manufacturer_name_after_the_product_was_placed, false)]).

distributor_base([attribute(ai_system, true), attribute(develops_or_has_developed_the_system, false), attribute(under_its_own_name_or_trademark, false), attribute(in_the_supply_chain, true), attribute(makes_the_system_available_on_the_union_market, true), attribute(places_the_system_on_the_union_market, false), attribute(puts_the_system_into_service_in_the_union, false), attribute(established_or_located_in_the_union, true), attribute(system_bears_the_name_or_trademark_of_a_person_established_in_a_third_country, false)]).

operator_base([attribute(ai_system, true), attribute(use_in_a_personal_non_professional_activity, false), attribute(develops_or_has_developed_the_system, false), attribute(under_its_own_name_or_trademark, false), attribute(uses_the_system_under_its_authority, false), attribute(written_mandate_from_a_provider_received_and_accepted, false), attribute(in_the_supply_chain, false), attribute(makes_the_system_available_on_the_union_market, false), attribute(is_a_product_manufacturer, true), attribute(places_the_system_on_the_union_market, false), attribute(puts_the_system_into_service_in_the_union, false), attribute(established_or_located_in_the_union, false), attribute(system_bears_the_name_or_trademark_of_a_person_established_in_a_third_country, false)]).

scope_and_roles_profile_for(Subject, Profile) :-
    subject_profile(Subject, Profile).

subject_profile(eu_provider_placing_on_market, Profile) :-
    scope_base(Profile).
subject_profile(eu_provider_not_placing_on_market, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(places_the_system_on_the_union_market, false)], Profile).
subject_profile(third_country_provider_output_in_union, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(places_the_system_on_the_union_market, false), attribute(established_or_located_in_the_union, false)], Profile).
subject_profile(third_country_provider_output_outside_union, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(places_the_system_on_the_union_market, false), attribute(established_or_located_in_the_union, false), attribute(output_used_in_the_union, false)], Profile).
subject_profile(professional_deployer_in_union, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(actor_role, deployer)], Profile).
subject_profile(personal_use_deployer, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(actor_role, deployer), attribute(use_in_a_personal_non_professional_activity, true)], Profile).
subject_profile(military_system_excluded, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(exclusively_for_military_defence_or_national_security_purposes, true)], Overridden),
    remove_attribute(Overridden, actor_role, Profile).
subject_profile(open_source_not_high_risk_excluded, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(released_under_free_and_open_source_licence, true)], Profile).
subject_profile(open_source_high_risk_in_scope, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(released_under_free_and_open_source_licence, true), attribute(placed_on_the_market_or_put_into_service_as_high_risk_or_under_article_5_or_50, true)], Profile).
subject_profile(section_b_high_risk_listed_provisions, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(high_risk_under_article_6_1_related_to_a_product_under_section_b_of_annex_i, true)], Profile).
subject_profile(authorised_representative_of_third_country_provider, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(actor_role, authorised_representative), attribute(represented_provider_established_in_the_union, false)], Profile).
subject_profile(authorised_representative_of_union_provider, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(actor_role, authorised_representative)], Profile).
subject_profile(pre_market_testing_excluded, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(research_testing_or_development_before_placing_on_the_market_or_putting_into_service, true)], Profile).
subject_profile(real_world_testing_in_scope, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(research_testing_or_development_before_placing_on_the_market_or_putting_into_service, true), attribute(testing_in_real_world_conditions, true)], Profile).
subject_profile(third_country_authority_with_safeguards, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(third_country_public_authority_or_international_organisation_in_law_enforcement_and_judicial_cooperation, true), attribute(adequate_safeguards_for_fundamental_rights_and_freedoms, true)], Profile).
subject_profile(third_country_authority_without_safeguards, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(third_country_public_authority_or_international_organisation_in_law_enforcement_and_judicial_cooperation, true)], Profile).
subject_profile(date_before_application, Profile) :-
    scope_base(Profile).
subject_profile(date_in_earlier_text_window, Profile) :-
    scope_base(Profile).
subject_profile(date_last_day_of_earlier_text, Profile) :-
    scope_base(Profile).
subject_profile(date_first_day_of_pinned_text, Profile) :-
    scope_base(Profile).
subject_profile(missing_actor_role_indeterminate, Profile) :-
    scope_base(Base),
    remove_attribute(Base, actor_role, Profile).
subject_profile(unsure_ai_system_referral, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(ai_system, unsure)], Profile).
subject_profile(malformed_judgement_input_problem, Profile) :-
    scope_base(Base),
    override_all(Base, [attribute(ai_system, maybe)], Profile).
subject_profile(provider_role_holds, [attribute(ai_system, true), attribute(develops_or_has_developed_the_system, true), attribute(under_its_own_name_or_trademark, true), attribute(places_the_system_on_the_union_market, true), attribute(puts_the_system_into_service_in_the_union, false)]).
subject_profile(developer_without_placing_not_provider, [attribute(ai_system, true), attribute(develops_or_has_developed_the_system, true), attribute(under_its_own_name_or_trademark, true), attribute(places_the_system_on_the_union_market, false), attribute(puts_the_system_into_service_in_the_union, false)]).
subject_profile(plain_distributor_role_holds, Profile) :-
    distributor_base(Profile).
subject_profile(distributor_that_is_importer, Profile) :-
    distributor_base(Base),
    override_all(Base, [attribute(places_the_system_on_the_union_market, true), attribute(system_bears_the_name_or_trademark_of_a_person_established_in_a_third_country, true)], Profile).
subject_profile(product_manufacturer_is_operator, Profile) :-
    operator_base(Profile).
subject_profile(no_role_is_not_operator, Profile) :-
    operator_base(Base),
    override_all(Base, [attribute(is_a_product_manufacturer, false)], Profile).
subject_profile(rebranding_distributor_considered_provider, Profile) :-
    value_chain_base(Profile).
subject_profile(distributor_without_change_not_provider, Profile) :-
    value_chain_base(Base),
    override_all(Base, [attribute(puts_its_name_or_trademark_on_a_high_risk_system_already_placed_or_in_service, false)], Profile).
subject_profile(annex_iii_before_article_25_applies, Profile) :-
    value_chain_base(Profile).
subject_profile(annex_iii_on_article_25_day, Profile) :-
    value_chain_base(Profile).
subject_profile(annex_i_in_window_not_applicable, Profile) :-
    value_chain_base(Base),
    override_all(Base, [attribute(high_risk_route, annex_i)], Profile).
subject_profile(annex_i_on_application_day, Profile) :-
    value_chain_base(Base),
    override_all(Base, [attribute(high_risk_route, annex_i)], Profile).
subject_profile(initial_provider_clearly_specified, [attribute(high_risk_route, annex_iii), attribute(another_person_became_the_provider_under_paragraph_1, true), attribute(initial_provider_clearly_specified_the_system_is_not_to_be_changed_into_high_risk, true)]).
subject_profile(initial_provider_must_cooperate, [attribute(high_risk_route, annex_iii), attribute(another_person_became_the_provider_under_paragraph_1, true), attribute(initial_provider_clearly_specified_the_system_is_not_to_be_changed_into_high_risk, false)]).
subject_profile(initial_provider_unaffected_case, [attribute(high_risk_route, annex_iii), attribute(another_person_became_the_provider_under_paragraph_1, false), attribute(initial_provider_clearly_specified_the_system_is_not_to_be_changed_into_high_risk, false)]).
subject_profile(open_source_supplier_no_agreement, [attribute(high_risk_route, annex_iii), attribute(supplies_items_used_or_integrated_in_a_high_risk_system, true), attribute(makes_the_items_accessible_to_the_public_under_a_free_and_open_source_licence, true), attribute(supplied_items_include_a_general_purpose_ai_model, false)]).
subject_profile(general_purpose_model_supplier_agreement_required, [attribute(high_risk_route, annex_iii), attribute(supplies_items_used_or_integrated_in_a_high_risk_system, true), attribute(makes_the_items_accessible_to_the_public_under_a_free_and_open_source_licence, true), attribute(supplied_items_include_a_general_purpose_ai_model, true)]).

override_all(Profile, [], Profile).
override_all(Profile, [attribute(Key, Value)|Overrides], Result) :-
    set_attribute(Profile, Key, Value, Updated),
    override_all(Updated, Overrides, Result).

set_attribute([], Key, Value, [attribute(Key, Value)]).
set_attribute([attribute(PresentKey, PresentValue)|Rest], Key, Value, [attribute(PresentKey, PresentValue)|Out]) :-
    dif(PresentKey, Key),
    set_attribute(Rest, Key, Value, Out).
set_attribute([attribute(PresentKey, _)|Rest], Key, Value, [attribute(Key, Value)|Rest]) :-
    PresentKey == Key.

remove_attribute([], _, []).
remove_attribute([attribute(PresentKey, PresentValue)|Rest], Key, [attribute(PresentKey, PresentValue)|Out]) :-
    dif(PresentKey, Key),
    remove_attribute(Rest, Key, Out).
remove_attribute([attribute(PresentKey, _)|Rest], Key, Out) :-
    PresentKey == Key,
    remove_attribute(Rest, Key, Out).

scope_and_roles_assess(Subject, scope_and_roles_verdict(Status, Citations)) :-
    subject_question(Subject, Question, AssessmentDate),
    subject_profile(Subject, Profile),
    question_answer(Question, Profile, AssessmentDate, Status, Citations).

question_answer(regulation_scope, Profile, AssessmentDate, Status, Citations) :-
    regulation_scope_status(Profile, AssessmentDate, Status, Citations).
question_answer(defined_role(DefinedRole), Profile, AssessmentDate, Status, Citations) :-
    defined_role_status(Profile, DefinedRole, AssessmentDate, Status, Citations).
question_answer(value_chain_provider, Profile, AssessmentDate, Status, Citations) :-
    value_chain_provider_status(Profile, AssessmentDate, Status, Citations).
question_answer(initial_provider, Profile, AssessmentDate, Status, Citations) :-
    initial_provider_status(Profile, AssessmentDate, Status, Citations).
question_answer(supplier_agreement, Profile, AssessmentDate, Status, Citations) :-
    supplier_agreement_status(Profile, AssessmentDate, Status, Citations).
