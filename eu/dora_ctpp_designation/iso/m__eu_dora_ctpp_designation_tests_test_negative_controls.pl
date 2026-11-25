% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_designation_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ctpp_designation_dora_ctpp_designation, [ctpp_designation_criteria_status/3, ctpp_step_1_indicators/3, ctpp_lead_overseer/3, ctpp_designated_provider_duties/3, dora_ctpp_designation_status/2, dora_ctpp_designation_status_values/1]).
:- use_module(m__eu_dora_ctpp_designation_fixtures, [dora_ctpp_designation_profile_for/2]).

criteria_of(Subject, Result) :-
    dora_ctpp_designation_profile_for(Subject, Profile),
    ctpp_designation_criteria_status(Profile, Result, _).

indicators_of(Subject, Result) :-
    dora_ctpp_designation_profile_for(Subject, Profile),
    ctpp_step_1_indicators(Profile, Result, _).

lead_of(Subject, Result) :-
    dora_ctpp_designation_profile_for(Subject, Profile),
    ctpp_lead_overseer(Profile, Result, _).

duties_of(Subject, Result) :-
    dora_ctpp_designation_profile_for(Subject, Profile),
    ctpp_designated_provider_duties(Profile, Result, _).

test(the_status_table_has_a_near_miss_atom) :-
    dora_ctpp_designation_status_values(StatusValues),
    StatusValues = [_, _|_].
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_ctpp_designation_profile_for(fixture_step_1_fulfilled_exact_ten_percent, Profile),
    findall(Status, dora_ctpp_designation_status(Profile, Status), [_]).
test(impact_at_ten_percent_fulfils) :-
    criteria_of(fixture_step_1_fulfilled_exact_ten_percent, step_1_sub_criteria_fulfilled).
test(impact_just_below_is_not_fulfilled) :-
    criteria_of(fixture_impact_just_below_ten_percent, step_1_sub_criteria_not_fulfilled).
test(split_categories_are_not_fulfilled) :-
    criteria_of(fixture_step_1_fails_impact_split_categories, step_1_sub_criteria_not_fulfilled).
test(o_sii_score_3001_fulfils) :-
    criteria_of(fixture_o_sii_score_3001, step_1_sub_criteria_fulfilled).
test(o_sii_score_3000_is_not_fulfilled) :-
    criteria_of(fixture_o_sii_score_exactly_3000, step_1_sub_criteria_not_fulfilled).
test(three_o_siis_fulfil) :-
    criteria_of(fixture_three_o_siis, step_1_sub_criteria_fulfilled).
test(two_o_siis_are_not_fulfilled) :-
    criteria_of(fixture_two_o_siis, step_1_sub_criteria_not_fulfilled).
test(three_other_systemic_entities_fulfil) :-
    criteria_of(fixture_three_other_systemic_entities, step_1_sub_criteria_fulfilled).
test(two_other_systemic_entities_are_not_fulfilled) :-
    criteria_of(fixture_two_other_systemic_entities, step_1_sub_criteria_not_fulfilled).
test(migration_share_at_ten_percent_fulfils) :-
    criteria_of(fixture_migration_share_exactly_ten_percent, step_1_sub_criteria_fulfilled).
test(substitutability_just_below_is_not_fulfilled) :-
    criteria_of(fixture_substitutability_just_below, step_1_sub_criteria_not_fulfilled).
test(pooled_two_of_twenty_fulfils) :-
    criteria_of(fixture_pooled_payment_institutions, step_1_sub_criteria_fulfilled).
test(pooled_one_of_twelve_is_not_fulfilled) :-
    criteria_of(fixture_pooled_payment_institutions_below, step_1_sub_criteria_not_fulfilled).
test(a_synonym_alone_is_named_by_the_synonym) :-
    indicators_of(fixture_synonym_alone, step_1_indicators([sub_criteria_1_1_and_1_2([exempted_payment_institution])|_])).
test(a_pooled_category_is_named_by_the_main_atom) :-
    indicators_of(fixture_pooled_payment_institutions, step_1_indicators([sub_criteria_1_1_and_1_2([payment_institution])|_])).
test(both_facts_of_point_iv_exclude) :-
    criteria_of(fixture_single_member_state_excluded, designation_not_applicable(single_member_state_provider)).
test(one_fact_of_point_iv_leaves_step_1) :-
    criteria_of(fixture_point_iv_one_fact_only, step_1_sub_criteria_fulfilled).
test(a_financial_entity_is_excluded) :-
    criteria_of(fixture_financial_entity_provider, designation_not_applicable(financial_entity)).
test(none_of_the_listed_types_is_no_provider) :-
    criteria_of(fixture_not_a_provider, not_an_ict_third_party_service_provider).
test(an_article_127_2_framework_excludes) :-
    criteria_of(fixture_tfeu_oversight_excluded, designation_not_applicable(article_127_2_tfeu_oversight_framework)).
test(an_intra_group_provider_is_excluded) :-
    criteria_of(fixture_intra_group_excluded, designation_not_applicable(ict_intra_group_service_provider)).
test(a_missing_type_is_indeterminate) :-
    criteria_of(fixture_missing_type, indeterminate([dora_entity_type])).
test(the_directive_2013_36_type_is_an_input_problem) :-
    criteria_of(fixture_directive_2013_36_type, input_problems([wrong_type(dora_entity_type)])).
test(eiopa_one_euro_ahead_is_lead_overseer) :-
    lead_of(fixture_lead_overseer_eiopa, lead_overseer(eiopa)).
test(a_tie_is_reported_as_tied) :-
    lead_of(fixture_lead_overseer_tied_eba_eiopa, lead_overseer_tied([eba, eiopa])).
test(a_designated_provider_must_notify) :-
    duties_of(fixture_duties_notification_only, required([notify_financial_entities_of_designation])).
test(a_provider_not_designated_is_reported) :-
    duties_of(fixture_not_designated, not_designated_as_critical).
test(a_group_member_designates_a_coordination_point) :-
    duties_of(fixture_duties_group_third_country, required([designate_coordination_point|_])).

test(the_baseline_profile_yields_no_other_table_status, fail) :-
    dora_ctpp_designation_profile_for(fixture_step_1_fulfilled_exact_ten_percent, Profile),
    findall(Status, dora_ctpp_designation_status(Profile, Status), [BaselineStatus]),
    dora_ctpp_designation_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_ctpp_designation_status(Profile, Other).
test(impact_just_below_does_not_fulfil, fail) :-
    criteria_of(fixture_impact_just_below_ten_percent, step_1_sub_criteria_fulfilled).
test(split_categories_do_not_fulfil, fail) :-
    criteria_of(fixture_step_1_fails_impact_split_categories, step_1_sub_criteria_fulfilled).
test(o_sii_score_3000_does_not_fulfil, fail) :-
    criteria_of(fixture_o_sii_score_exactly_3000, step_1_sub_criteria_fulfilled).
test(two_o_siis_do_not_fulfil, fail) :-
    criteria_of(fixture_two_o_siis, step_1_sub_criteria_fulfilled).
test(two_other_systemic_entities_do_not_fulfil, fail) :-
    criteria_of(fixture_two_other_systemic_entities, step_1_sub_criteria_fulfilled).
test(substitutability_just_below_does_not_fulfil, fail) :-
    criteria_of(fixture_substitutability_just_below, step_1_sub_criteria_fulfilled).
test(pooled_one_of_twelve_does_not_fulfil, fail) :-
    criteria_of(fixture_pooled_payment_institutions_below, step_1_sub_criteria_fulfilled).
test(a_synonym_alone_is_not_named_by_the_main_atom, fail) :-
    indicators_of(fixture_synonym_alone, step_1_indicators([sub_criteria_1_1_and_1_2([payment_institution])|_])).
test(one_fact_of_point_iv_does_not_exclude, fail) :-
    criteria_of(fixture_point_iv_one_fact_only, designation_not_applicable(single_member_state_provider)).
test(an_ict_provider_is_not_excluded_as_a_financial_entity, fail) :-
    criteria_of(fixture_step_1_fulfilled_exact_ten_percent, designation_not_applicable(financial_entity)).
test(an_ict_provider_is_a_provider, fail) :-
    criteria_of(fixture_step_1_fulfilled_exact_ten_percent, not_an_ict_third_party_service_provider).
test(no_article_127_2_framework_does_not_exclude, fail) :-
    criteria_of(fixture_step_1_fulfilled_exact_ten_percent, designation_not_applicable(article_127_2_tfeu_oversight_framework)).
test(a_provider_outside_the_group_is_not_excluded, fail) :-
    criteria_of(fixture_step_1_fulfilled_exact_ten_percent, designation_not_applicable(ict_intra_group_service_provider)).
test(a_stated_type_is_not_indeterminate, fail) :-
    criteria_of(fixture_step_1_fulfilled_exact_ten_percent, indeterminate(_)).
test(a_well_formed_profile_has_no_input_problem, fail) :-
    criteria_of(fixture_step_1_fulfilled_exact_ten_percent, input_problems(_)).
test(a_tie_appoints_no_single_overseer, fail) :-
    lead_of(fixture_lead_overseer_tied_eba_eiopa, lead_overseer(_)).
test(a_provider_not_designated_has_no_duty, fail) :-
    duties_of(fixture_not_designated, required(_)).
test(a_provider_outside_a_group_designates_none, fail) :-
    duties_of(fixture_duties_notification_only, required([designate_coordination_point|_])).

cp_test_names([the_status_table_has_a_near_miss_atom, the_baseline_profile_yields_exactly_one_status, impact_at_ten_percent_fulfils, impact_just_below_is_not_fulfilled, split_categories_are_not_fulfilled, o_sii_score_3001_fulfils, o_sii_score_3000_is_not_fulfilled, three_o_siis_fulfil, two_o_siis_are_not_fulfilled, three_other_systemic_entities_fulfil, two_other_systemic_entities_are_not_fulfilled, migration_share_at_ten_percent_fulfils, substitutability_just_below_is_not_fulfilled, pooled_two_of_twenty_fulfils, pooled_one_of_twelve_is_not_fulfilled, a_synonym_alone_is_named_by_the_synonym, a_pooled_category_is_named_by_the_main_atom, both_facts_of_point_iv_exclude, one_fact_of_point_iv_leaves_step_1, a_financial_entity_is_excluded, none_of_the_listed_types_is_no_provider, an_article_127_2_framework_excludes, an_intra_group_provider_is_excluded, a_missing_type_is_indeterminate, the_directive_2013_36_type_is_an_input_problem, eiopa_one_euro_ahead_is_lead_overseer, a_tie_is_reported_as_tied, a_designated_provider_must_notify, a_provider_not_designated_is_reported, a_group_member_designates_a_coordination_point]).
cp_test_fail_names([the_baseline_profile_yields_no_other_table_status, impact_just_below_does_not_fulfil, split_categories_do_not_fulfil, o_sii_score_3000_does_not_fulfil, two_o_siis_do_not_fulfil, two_other_systemic_entities_do_not_fulfil, substitutability_just_below_does_not_fulfil, pooled_one_of_twelve_does_not_fulfil, a_synonym_alone_is_not_named_by_the_main_atom, one_fact_of_point_iv_does_not_exclude, an_ict_provider_is_not_excluded_as_a_financial_entity, an_ict_provider_is_a_provider, no_article_127_2_framework_does_not_exclude, a_provider_outside_the_group_is_not_excluded, a_stated_type_is_not_indeterminate, a_well_formed_profile_has_no_input_problem, a_tie_appoints_no_single_overseer, a_provider_not_designated_has_no_duty, a_provider_outside_a_group_designates_none]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
