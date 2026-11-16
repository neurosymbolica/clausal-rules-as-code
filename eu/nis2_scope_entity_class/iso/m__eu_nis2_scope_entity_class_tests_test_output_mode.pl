% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [decide_nis2_scope_entity_class/2, nis2_scope_entity_class_status/2, size_class/3, scope_decision/3, entity_class/3]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_profile_for/2]).

size_of(Subject, Size) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    findall(Answer, size_class(Profile, Answer, _), Sizes),
    Sizes = [Size].

scope_of(Subject, Result) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    findall(Answer, scope_decision(Profile, Answer, _), Results),
    Results = [Result].

class_of(Subject, Class) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    findall(Answer, entity_class(Profile, Answer, _), Classes),
    Classes = [Class].

test(baseline_yields_exactly_one_status) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    findall(Status, nis2_scope_entity_class_status(Profile, Status), Statuses),
    Statuses == [ineligible].
test(critical_entity_yields_exactly_one_status) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    findall(Status, nis2_scope_entity_class_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(the_verdict_carries_a_citation) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    decide_nis2_scope_entity_class(Profile, nis2_scope_entity_class_verdict(ineligible, [cite(_)|_])).
test(out_of_scope_names_the_four_paragraphs) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    findall(Citations, scope_decision(Profile, out_of_scope, Citations), All),
    All == [[cite(eu_dir_2022_2555_art_2_1), cite(eu_dir_2022_2555_art_2_2), cite(eu_dir_2022_2555_art_2_3), cite(eu_dir_2022_2555_art_2_4)]].
test(size_micro_at_ceiling) :-
    size_of(micro_at_ceiling, microenterprise).
test(size_staff_ten_is_small) :-
    size_of(small_staff_at_ten, small_enterprise).
test(size_one_euro_over_micro_is_small) :-
    size_of(small_one_euro_over_micro, small_enterprise).
test(size_fifty_is_medium) :-
    size_of(medium_annex_at_staff_floor, medium_sized_enterprise).
test(size_forty_nine_at_ceiling_is_small) :-
    size_of(small_annex_just_below, small_enterprise).
test(size_one_figure_over_is_still_small) :-
    size_of(small_annex_one_figure_over, small_enterprise).
test(size_both_over_is_medium) :-
    size_of(small_annex_one_euro_over_both, medium_sized_enterprise).
test(size_250_is_large) :-
    size_of(large_annex_by_staff, large_enterprise).
test(size_249_is_medium) :-
    size_of(medium_annex_staff_just_below_large, medium_sized_enterprise).
test(size_both_financials_over_is_large) :-
    size_of(large_annex_by_financials, large_enterprise).
test(size_one_financial_at_ceiling_is_medium) :-
    size_of(medium_annex_one_figure_at_ceiling, medium_sized_enterprise).
test(size_large_by_staff_cites_art_2_1) :-
    nis2_scope_entity_class_profile_for(large_annex_by_staff, Profile),
    findall(Citations, size_class(Profile, large_enterprise, Citations), All),
    All == [[cite(eu_dir_2022_2555_art_2_1)]].
test(scope_medium_in) :-
    scope_of(medium_annex_at_staff_floor, in_scope).
test(scope_small_just_below_out) :-
    scope_of(small_annex_just_below, out_of_scope).
test(scope_one_figure_over_out) :-
    scope_of(small_annex_one_figure_over, out_of_scope).
test(scope_both_over_in) :-
    scope_of(small_annex_one_euro_over_both, in_scope).
test(scope_micro_without_annex_out) :-
    scope_of(micro_at_ceiling, out_of_scope).
test(scope_sole_provider_without_annex_out) :-
    scope_of(sole_provider_without_annex_type, out_of_scope).
test(scope_other_public_administration_out) :-
    scope_of(other_public_administration, out_of_scope).
test(scope_dora_exemption_out) :-
    scope_of(dora_exemption, out_of_scope).
test(scope_citation_of_the_first_true_ground) :-
    nis2_scope_entity_class_profile_for(tld_registry, Profile),
    findall(Citations, scope_decision(Profile, in_scope, Citations), All),
    All == [[cite(eu_dir_2022_2555_art_2_2_a_iii)]].
test(scope_size_rule_cites_art_2_1) :-
    nis2_scope_entity_class_profile_for(medium_annex_at_staff_floor, Profile),
    findall(Citations, scope_decision(Profile, in_scope, Citations), All),
    All == [[cite(eu_dir_2022_2555_art_2_1)]].
test(scope_exclusion_cites_art_2_10) :-
    nis2_scope_entity_class_profile_for(dora_exemption, Profile),
    findall(Citations, scope_decision(Profile, out_of_scope, Citations), All),
    All == [[cite(eu_dir_2022_2555_art_2_10)]].
test(art_2_9_disapplies_art_2_7_for_a_trust_provider) :-
    scope_of(national_security_trust_provider, in_scope).
test(class_large_annex_i_essential) :-
    class_of(large_annex_by_staff, essential_entity).
test(class_medium_annex_important) :-
    class_of(medium_annex_staff_just_below_large, important_entity).
test(class_qualified_trust_essential) :-
    class_of(qualified_trust_provider, essential_entity).
test(class_non_qualified_trust_important) :-
    class_of(non_qualified_trust_provider, important_entity).
test(class_tld_essential) :-
    class_of(tld_registry, essential_entity).
test(class_dns_essential) :-
    class_of(dns_provider, essential_entity).
test(class_medium_communications_essential) :-
    class_of(electronic_communications_medium, essential_entity).
test(class_micro_communications_important) :-
    class_of(electronic_communications_micro, important_entity).
test(class_central_government_essential) :-
    class_of(central_government, essential_entity).
test(class_regional_government_important) :-
    class_of(regional_government, important_entity).
test(class_identified_essential) :-
    class_of(identified_essential, essential_entity).
test(class_sole_provider_important) :-
    class_of(sole_provider, important_entity).
test(class_former_operator_essential) :-
    class_of(former_operator_essential, essential_entity).
test(class_critical_essential) :-
    class_of(critical_entity, essential_entity).
test(class_registrar_default_important) :-
    class_of(domain_registrar, important_entity).
test(class_out_of_scope_follows_scope) :-
    class_of(baseline_out_of_scope, out_of_scope).
test(class_exclusion_keeps_scope_citations) :-
    nis2_scope_entity_class_profile_for(national_security_exclusion, Profile),
    findall(Citations, entity_class(Profile, out_of_scope, Citations), All),
    All == [[cite(eu_dir_2022_2555_art_2_7), cite(eu_dir_2022_2555_art_2_9)]].
test(class_trust_provider_essential_before_critical) :-
    nis2_scope_entity_class_profile_for(national_security_trust_provider, Profile),
    findall(Citations, entity_class(Profile, essential_entity, Citations), All),
    All == [[cite(eu_dir_2022_2555_art_3_1_b)]].
test(class_default_cites_art_3_2) :-
    nis2_scope_entity_class_profile_for(medium_annex_staff_just_below_large, Profile),
    findall(Citations, entity_class(Profile, important_entity, Citations), All),
    All == [[cite(eu_dir_2022_2555_art_3_2)]].
test(empty_profile_scope_names_the_exclusion_keys) :-
    nis2_scope_entity_class_profile_for(empty_profile, Profile),
    findall(Result - Citations, scope_decision(Profile, Result, Citations), All),
    All == [indeterminate([trust_service_provider_status, public_administration_in_national_security_defence_or_law_enforcement, exempted_from_dora_scope_by_member_state]) - []].
test(unsure_sole_provider_is_handed_to_the_user) :-
    nis2_scope_entity_class_profile_for(unsure_sole_provider, Profile),
    findall(Result - Citations, scope_decision(Profile, Result, Citations), All),
    All == [needs_legal_review(open_textured(sole_provider_of_an_essential_service_in_a_member_state, cite(eu_dir_2022_2555_art_2_2_b)), [inputs_relied_on([annex_i_type - false, annex_ii_type - true, sole_provider_of_an_essential_service_in_a_member_state - unsure, disruption_could_significantly_impact_public_safety_security_or_health - false, disruption_could_induce_a_significant_systemic_risk - false, critical_by_specific_national_or_regional_importance - false])]) - []].
test(unsure_annex_type_refers_at_the_size_rule) :-
    nis2_scope_entity_class_profile_for(unsure_annex_medium, Profile),
    findall(Result - Citations, scope_decision(Profile, Result, Citations), All),
    All == [needs_legal_review(open_textured(annex_i_type, cite(eu_dir_2022_2555_art_2_1)), [inputs_relied_on([annex_i_type - unsure, annex_ii_type - false, sole_provider_of_an_essential_service_in_a_member_state - false, disruption_could_significantly_impact_public_safety_security_or_health - false, disruption_could_induce_a_significant_systemic_risk - false, critical_by_specific_national_or_regional_importance - false])]) - []].
test(unsure_annex_type_refers_at_the_class_stage) :-
    nis2_scope_entity_class_profile_for(unsure_annex_class, Profile),
    findall(Class - Citations, entity_class(Profile, Class, Citations), All),
    All == [needs_legal_review(open_textured(annex_i_type, cite(eu_dir_2022_2555_art_3_1_a)), [inputs_relied_on([annex_i_type - unsure, annex_ii_type - false])]) - []].
test(unsure_annex_class_scope_is_still_in_scope) :-
    scope_of(unsure_annex_class, in_scope).

cp_test_names([baseline_yields_exactly_one_status, critical_entity_yields_exactly_one_status, the_verdict_carries_a_citation, out_of_scope_names_the_four_paragraphs, size_micro_at_ceiling, size_staff_ten_is_small, size_one_euro_over_micro_is_small, size_fifty_is_medium, size_forty_nine_at_ceiling_is_small, size_one_figure_over_is_still_small, size_both_over_is_medium, size_250_is_large, size_249_is_medium, size_both_financials_over_is_large, size_one_financial_at_ceiling_is_medium, size_large_by_staff_cites_art_2_1, scope_medium_in, scope_small_just_below_out, scope_one_figure_over_out, scope_both_over_in, scope_micro_without_annex_out, scope_sole_provider_without_annex_out, scope_other_public_administration_out, scope_dora_exemption_out, scope_citation_of_the_first_true_ground, scope_size_rule_cites_art_2_1, scope_exclusion_cites_art_2_10, art_2_9_disapplies_art_2_7_for_a_trust_provider, class_large_annex_i_essential, class_medium_annex_important, class_qualified_trust_essential, class_non_qualified_trust_important, class_tld_essential, class_dns_essential, class_medium_communications_essential, class_micro_communications_important, class_central_government_essential, class_regional_government_important, class_identified_essential, class_sole_provider_important, class_former_operator_essential, class_critical_essential, class_registrar_default_important, class_out_of_scope_follows_scope, class_exclusion_keeps_scope_citations, class_trust_provider_essential_before_critical, class_default_cites_art_3_2, empty_profile_scope_names_the_exclusion_keys, unsure_sole_provider_is_handed_to_the_user, unsure_annex_type_refers_at_the_size_rule, unsure_annex_type_refers_at_the_class_stage, unsure_annex_class_scope_is_still_in_scope]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
