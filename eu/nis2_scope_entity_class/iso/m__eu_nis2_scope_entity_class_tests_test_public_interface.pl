% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [decide_nis2_scope_entity_class/2, nis2_scope_entity_class_status/2, nis2_scope_entity_class_checklist/2, nis2_scope_entity_class_decision_resolvable/1, nis2_scope_entity_class_status_values/1, size_class/3, scope_decision/3, entity_class/3]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_subject/1, nis2_scope_entity_class_profile_for/2, nis2_scope_entity_class_assess/2]).
:- use_module(m__eu_nis2_scope_entity_class_queries, [nis2_scope_entity_class_what_if/4]).
:- use_module(m__eu_nis2_scope_entity_class_kernel, [nis2_scope_entity_class_input_problems/2]).

expect(Subject, ExpectedStatus, ExpectedClass) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    nis2_scope_entity_class_status(Profile, Status),
    Status == ExpectedStatus,
    entity_class(Profile, Class, _),
    Class == ExpectedClass,
    nis2_scope_entity_class_checklist(Profile, [_|_]).

expect_size(Subject, ExpectedSize) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    size_class(Profile, Size, [cite(eu_dir_2022_2555_art_2_1)]),
    Size == ExpectedSize.

all_cited([]).
all_cited([item(_, _, cite(_))|Items]) :-
    all_cited(Items).

test(the_public_interface_resolves_on_the_baseline_fixture) :-
    nis2_scope_entity_class_subject(Subject),
    nis2_scope_entity_class_assess(Subject, nis2_scope_entity_class_verdict(Status, _Citations)),
    nis2_scope_entity_class_status_values(StatusValues),
    member(Status, StatusValues).
test(baseline_is_resolvable) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    nis2_scope_entity_class_decision_resolvable(Profile).
test(empty_profile_is_indeterminate_not_resolvable_control) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    nis2_scope_entity_class_decision_resolvable(Profile).
test(checklist_items_all_carry_a_citation) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    nis2_scope_entity_class_checklist(Profile, Items),
    all_cited(Items).
test(checklist_names_the_deciding_ground) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    nis2_scope_entity_class_checklist(Profile, Items),
    member(item(g1, met, cite(eu_dir_2022_2555_art_2_3)), Items).
test(decide_returns_one_verdict_with_citations) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    findall(Verdict, decide_nis2_scope_entity_class(Profile, Verdict), Verdicts),
    Verdicts == [nis2_scope_entity_class_verdict(eligible, [cite(eu_dir_2022_2555_art_2_3)])].
test(baseline_out_of_scope) :-
    expect(baseline_out_of_scope, ineligible, out_of_scope).
test(critical_entity) :-
    expect(critical_entity, eligible, essential_entity).
test(domain_registrar_gets_the_important_default) :-
    expect(domain_registrar, eligible, important_entity).
test(micro_at_ceiling) :-
    expect(micro_at_ceiling, ineligible, out_of_scope).
test(small_staff_at_ten) :-
    expect(small_staff_at_ten, ineligible, out_of_scope).
test(small_one_euro_over_micro) :-
    expect(small_one_euro_over_micro, ineligible, out_of_scope).
test(medium_annex_at_staff_floor) :-
    expect(medium_annex_at_staff_floor, eligible, important_entity).
test(small_annex_just_below) :-
    expect(small_annex_just_below, ineligible, out_of_scope).
test(small_annex_one_figure_over) :-
    expect(small_annex_one_figure_over, ineligible, out_of_scope).
test(small_annex_one_euro_over_both) :-
    expect(small_annex_one_euro_over_both, eligible, important_entity).
test(large_annex_by_staff) :-
    expect(large_annex_by_staff, eligible, essential_entity).
test(medium_annex_staff_just_below_large) :-
    expect(medium_annex_staff_just_below_large, eligible, important_entity).
test(large_annex_by_financials) :-
    expect(large_annex_by_financials, eligible, essential_entity).
test(medium_annex_one_figure_at_ceiling) :-
    expect(medium_annex_one_figure_at_ceiling, eligible, important_entity).
test(annex_ii_large_is_only_important) :-
    expect(annex_ii_large, eligible, important_entity).
test(electronic_communications_micro) :-
    expect(electronic_communications_micro, eligible, important_entity).
test(electronic_communications_medium) :-
    expect(electronic_communications_medium, eligible, essential_entity).
test(electronic_communications_not_provider) :-
    expect(electronic_communications_not_provider, ineligible, out_of_scope).
test(qualified_trust_provider) :-
    expect(qualified_trust_provider, eligible, essential_entity).
test(non_qualified_trust_provider) :-
    expect(non_qualified_trust_provider, eligible, important_entity).
test(tld_registry) :-
    expect(tld_registry, eligible, essential_entity).
test(dns_provider) :-
    expect(dns_provider, eligible, essential_entity).
test(sole_provider) :-
    expect(sole_provider, eligible, important_entity).
test(sole_provider_without_annex_type) :-
    expect(sole_provider_without_annex_type, ineligible, out_of_scope).
test(safety_disruption) :-
    expect(safety_disruption, eligible, important_entity).
test(systemic_risk) :-
    expect(systemic_risk, eligible, important_entity).
test(national_importance) :-
    expect(national_importance, eligible, important_entity).
test(central_government) :-
    expect(central_government, eligible, essential_entity).
test(regional_government) :-
    expect(regional_government, eligible, important_entity).
test(other_public_administration) :-
    expect(other_public_administration, ineligible, out_of_scope).
test(national_security_exclusion) :-
    expect(national_security_exclusion, ineligible, out_of_scope).
test(national_security_trust_provider) :-
    expect(national_security_trust_provider, eligible, essential_entity).
test(dora_exemption) :-
    expect(dora_exemption, ineligible, out_of_scope).
test(identified_essential) :-
    expect(identified_essential, eligible, essential_entity).
test(former_operator_essential) :-
    expect(former_operator_essential, eligible, essential_entity).
test(empty_profile_names_missing_keys) :-
    expect(empty_profile, indeterminate([trust_service_provider_status, public_administration_in_national_security_defence_or_law_enforcement, exempted_from_dora_scope_by_member_state]), indeterminate([trust_service_provider_status, public_administration_in_national_security_defence_or_law_enforcement, exempted_from_dora_scope_by_member_state])).
test(unsure_sole_provider_goes_to_legal_review) :-
    Review = needs_legal_review(open_textured(sole_provider_of_an_essential_service_in_a_member_state, cite(eu_dir_2022_2555_art_2_2_b)), [inputs_relied_on([annex_i_type - false, annex_ii_type - true, sole_provider_of_an_essential_service_in_a_member_state - unsure, disruption_could_significantly_impact_public_safety_security_or_health - false, disruption_could_induce_a_significant_systemic_risk - false, critical_by_specific_national_or_regional_importance - false])]),
    expect(unsure_sole_provider, Review, Review).
test(unsure_annex_medium_goes_to_legal_review) :-
    Review = needs_legal_review(open_textured(annex_i_type, cite(eu_dir_2022_2555_art_2_1)), [inputs_relied_on([annex_i_type - unsure, annex_ii_type - false, sole_provider_of_an_essential_service_in_a_member_state - false, disruption_could_significantly_impact_public_safety_security_or_health - false, disruption_could_induce_a_significant_systemic_risk - false, critical_by_specific_national_or_regional_importance - false])]),
    expect(unsure_annex_medium, Review, Review).
test(unsure_annex_class_goes_to_legal_review_at_the_class_stage) :-
    ClassReview = needs_legal_review(open_textured(annex_i_type, cite(eu_dir_2022_2555_art_3_1_a)), [inputs_relied_on([annex_i_type - unsure, annex_ii_type - false])]),
    expect(unsure_annex_class, eligible, ClassReview).
test(unknown_key_is_an_input_problem) :-
    expect(unknown_key_profile, input_problems([unknown_key(bogus)]), input_problems([unknown_key(bogus)])).
test(duplicate_key_is_an_input_problem) :-
    expect(duplicate_key_profile, input_problems([duplicate_key(staff_headcount)]), input_problems([duplicate_key(staff_headcount)])).
test(input_check_gives_empty_list_for_a_good_profile) :-
    nis2_scope_entity_class_profile_for(large_annex_by_staff, Profile),
    nis2_scope_entity_class_input_problems(Profile, Problems),
    Problems == [].
test(input_check_names_the_unknown_key) :-
    nis2_scope_entity_class_profile_for(unknown_key_profile, Profile),
    nis2_scope_entity_class_input_problems(Profile, Problems),
    Problems == [unknown_key(bogus)].
test(size_baseline_is_micro) :-
    expect_size(baseline_out_of_scope, microenterprise).
test(size_micro_at_ceiling) :-
    expect_size(micro_at_ceiling, microenterprise).
test(size_staff_at_ten_is_small) :-
    expect_size(small_staff_at_ten, small_enterprise).
test(size_one_euro_over_micro_is_small) :-
    expect_size(small_one_euro_over_micro, small_enterprise).
test(size_small_at_ceiling) :-
    expect_size(small_annex_just_below, small_enterprise).
test(size_small_one_figure_over_stays_small) :-
    expect_size(small_annex_one_figure_over, small_enterprise).
test(size_one_euro_over_both_small_ceilings_is_medium) :-
    expect_size(small_annex_one_euro_over_both, medium_sized_enterprise).
test(size_staff_fifty_is_medium) :-
    expect_size(medium_annex_at_staff_floor, medium_sized_enterprise).
test(size_staff_249_is_medium) :-
    expect_size(medium_annex_staff_just_below_large, medium_sized_enterprise).
test(size_staff_250_is_large) :-
    expect_size(large_annex_by_staff, large_enterprise).
test(size_both_financial_ceilings_exceeded_is_large) :-
    expect_size(large_annex_by_financials, large_enterprise).
test(size_one_financial_ceiling_met_is_medium) :-
    expect_size(medium_annex_one_figure_at_ceiling, medium_sized_enterprise).
test(size_without_headcount_is_indeterminate) :-
    size_class([], Size, Citations),
    Size == indeterminate([staff_headcount]),
    Citations == [].
test(scope_positive_cites_the_deciding_ground) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    scope_decision(Profile, Result, Citations),
    Result == in_scope,
    Citations == [cite(eu_dir_2022_2555_art_2_3)].
test(scope_negative_cites_the_four_paragraphs) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    scope_decision(Profile, Result, Citations),
    Result == out_of_scope,
    Citations == [cite(eu_dir_2022_2555_art_2_1), cite(eu_dir_2022_2555_art_2_2), cite(eu_dir_2022_2555_art_2_3), cite(eu_dir_2022_2555_art_2_4)].
test(national_security_exclusion_cites_art_2_7_and_2_9) :-
    nis2_scope_entity_class_profile_for(national_security_exclusion, Profile),
    scope_decision(Profile, Result, Citations),
    Result == out_of_scope,
    Citations == [cite(eu_dir_2022_2555_art_2_7), cite(eu_dir_2022_2555_art_2_9)].
test(dora_exemption_cites_art_2_10) :-
    nis2_scope_entity_class_profile_for(dora_exemption, Profile),
    scope_decision(Profile, Result, Citations),
    Result == out_of_scope,
    Citations == [cite(eu_dir_2022_2555_art_2_10)].
test(class_cites_the_essential_ground) :-
    nis2_scope_entity_class_profile_for(large_annex_by_staff, Profile),
    entity_class(Profile, Class, Citations),
    Class == essential_entity,
    Citations == [cite(eu_dir_2022_2555_art_3_1_a)].
test(class_cites_the_important_residual) :-
    nis2_scope_entity_class_profile_for(medium_annex_staff_just_below_large, Profile),
    entity_class(Profile, Class, Citations),
    Class == important_entity,
    Citations == [cite(eu_dir_2022_2555_art_3_2)].
test(whatif_critical_entity_flipped_off_is_ineligible) :-
    nis2_scope_entity_class_profile_for(critical_entity, Profile),
    nis2_scope_entity_class_what_if(Profile, critical_entity_under_directive_2022_2557, false, ineligible).
test(whatif_critical_entity_flipped_on_from_baseline_is_eligible) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    nis2_scope_entity_class_what_if(Profile, critical_entity_under_directive_2022_2557, true, eligible).
test(whatif_domain_registrar_flipped_off_is_ineligible) :-
    nis2_scope_entity_class_profile_for(domain_registrar, Profile),
    nis2_scope_entity_class_what_if(Profile, domain_name_registration_service_entity, false, ineligible).
test(whatif_tld_registry_flipped_off_is_ineligible) :-
    nis2_scope_entity_class_profile_for(tld_registry, Profile),
    nis2_scope_entity_class_what_if(Profile, tld_name_registry, false, ineligible).
test(whatif_dns_provider_flipped_off_is_ineligible) :-
    nis2_scope_entity_class_profile_for(dns_provider, Profile),
    nis2_scope_entity_class_what_if(Profile, dns_service_provider, false, ineligible).
test(whatif_trust_provider_made_not_a_provider_is_ineligible) :-
    nis2_scope_entity_class_profile_for(qualified_trust_provider, Profile),
    nis2_scope_entity_class_what_if(Profile, trust_service_provider_status, not_a_trust_service_provider, ineligible).
test(whatif_central_government_made_not_public_administration_is_ineligible) :-
    nis2_scope_entity_class_profile_for(central_government, Profile),
    nis2_scope_entity_class_what_if(Profile, public_administration_kind, not_public_administration, ineligible).
test(whatif_sole_provider_flipped_off_is_ineligible) :-
    nis2_scope_entity_class_profile_for(sole_provider, Profile),
    nis2_scope_entity_class_what_if(Profile, sole_provider_of_an_essential_service_in_a_member_state, false, ineligible).
test(whatif_safety_disruption_flipped_off_is_ineligible) :-
    nis2_scope_entity_class_profile_for(safety_disruption, Profile),
    nis2_scope_entity_class_what_if(Profile, disruption_could_significantly_impact_public_safety_security_or_health, false, ineligible).
test(whatif_dora_exemption_lifted_is_eligible) :-
    nis2_scope_entity_class_profile_for(dora_exemption, Profile),
    nis2_scope_entity_class_what_if(Profile, exempted_from_dora_scope_by_member_state, false, eligible).
test(whatif_one_euro_under_both_small_ceilings_is_ineligible) :-
    nis2_scope_entity_class_profile_for(small_annex_one_euro_over_both, Profile),
    nis2_scope_entity_class_what_if(Profile, annual_balance_sheet_total_eur, 10000000, ineligible).

test(empty_profile_is_not_resolvable, fail) :-
    nis2_scope_entity_class_profile_for(empty_profile, Profile),
    nis2_scope_entity_class_decision_resolvable(Profile).
test(near_miss_small_annex_is_not_eligible, fail) :-
    nis2_scope_entity_class_profile_for(small_annex_just_below, Profile),
    nis2_scope_entity_class_status(Profile, eligible).
test(near_miss_medium_annex_is_not_ineligible, fail) :-
    nis2_scope_entity_class_profile_for(small_annex_one_euro_over_both, Profile),
    nis2_scope_entity_class_status(Profile, ineligible).

cp_test_names([the_public_interface_resolves_on_the_baseline_fixture, baseline_is_resolvable, empty_profile_is_indeterminate_not_resolvable_control, checklist_items_all_carry_a_citation, checklist_names_the_deciding_ground, decide_returns_one_verdict_with_citations, baseline_out_of_scope, critical_entity, domain_registrar_gets_the_important_default, micro_at_ceiling, small_staff_at_ten, small_one_euro_over_micro, medium_annex_at_staff_floor, small_annex_just_below, small_annex_one_figure_over, small_annex_one_euro_over_both, large_annex_by_staff, medium_annex_staff_just_below_large, large_annex_by_financials, medium_annex_one_figure_at_ceiling, annex_ii_large_is_only_important, electronic_communications_micro, electronic_communications_medium, electronic_communications_not_provider, qualified_trust_provider, non_qualified_trust_provider, tld_registry, dns_provider, sole_provider, sole_provider_without_annex_type, safety_disruption, systemic_risk, national_importance, central_government, regional_government, other_public_administration, national_security_exclusion, national_security_trust_provider, dora_exemption, identified_essential, former_operator_essential, empty_profile_names_missing_keys, unsure_sole_provider_goes_to_legal_review, unsure_annex_medium_goes_to_legal_review, unsure_annex_class_goes_to_legal_review_at_the_class_stage, unknown_key_is_an_input_problem, duplicate_key_is_an_input_problem, input_check_gives_empty_list_for_a_good_profile, input_check_names_the_unknown_key, size_baseline_is_micro, size_micro_at_ceiling, size_staff_at_ten_is_small, size_one_euro_over_micro_is_small, size_small_at_ceiling, size_small_one_figure_over_stays_small, size_one_euro_over_both_small_ceilings_is_medium, size_staff_fifty_is_medium, size_staff_249_is_medium, size_staff_250_is_large, size_both_financial_ceilings_exceeded_is_large, size_one_financial_ceiling_met_is_medium, size_without_headcount_is_indeterminate, scope_positive_cites_the_deciding_ground, scope_negative_cites_the_four_paragraphs, national_security_exclusion_cites_art_2_7_and_2_9, dora_exemption_cites_art_2_10, class_cites_the_essential_ground, class_cites_the_important_residual, whatif_critical_entity_flipped_off_is_ineligible, whatif_critical_entity_flipped_on_from_baseline_is_eligible, whatif_domain_registrar_flipped_off_is_ineligible, whatif_tld_registry_flipped_off_is_ineligible, whatif_dns_provider_flipped_off_is_ineligible, whatif_trust_provider_made_not_a_provider_is_ineligible, whatif_central_government_made_not_public_administration_is_ineligible, whatif_sole_provider_flipped_off_is_ineligible, whatif_safety_disruption_flipped_off_is_ineligible, whatif_dora_exemption_lifted_is_eligible, whatif_one_euro_under_both_small_ceilings_is_ineligible]).
cp_test_fail_names([empty_profile_is_not_resolvable, near_miss_small_annex_is_not_eligible, near_miss_medium_annex_is_not_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
