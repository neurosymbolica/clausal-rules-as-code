% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_designation_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ctpp_designation_dora_ctpp_designation, [decide_dora_ctpp_designation/2, dora_ctpp_designation_status/2, ctpp_designation_criteria_status/3, ctpp_step_1_indicators/3, ctpp_lead_overseer/3, ctpp_designated_provider_duties/3]).
:- use_module(m__eu_dora_ctpp_designation_fixtures, [dora_ctpp_designation_profile_for/2]).

criteria_answers(Subject, Answers) :-
    dora_ctpp_designation_profile_for(Subject, Profile),
    findall(Result, ctpp_designation_criteria_status(Profile, Result, _), Answers).

indicator_answers(Subject, Answers) :-
    dora_ctpp_designation_profile_for(Subject, Profile),
    findall(Result, ctpp_step_1_indicators(Profile, Result, _), Answers).

lead_answers(Subject, Answers) :-
    dora_ctpp_designation_profile_for(Subject, Profile),
    findall(Result, ctpp_lead_overseer(Profile, Result, _), Answers).

duty_answers(Subject, Answers) :-
    dora_ctpp_designation_profile_for(Subject, Profile),
    findall(Result, ctpp_designated_provider_duties(Profile, Result, _), Answers).

test(the_baseline_profile_yields_exactly_one_status) :-
    dora_ctpp_designation_profile_for(fixture_step_1_fulfilled_exact_ten_percent, Profile),
    findall(Status, dora_ctpp_designation_status(Profile, Status), Statuses),
    Statuses == [step_1_sub_criteria_fulfilled].
test(the_verdict_carries_its_citations) :-
    dora_ctpp_designation_profile_for(fixture_step_1_fulfilled_exact_ten_percent, Profile),
    decide_dora_ctpp_designation(Profile, dora_ctpp_designation_verdict(step_1_sub_criteria_fulfilled, Citations)),
    clausal_msort(Citations, SortedCitations),
    clausal_msort([cite(eu_reg_2022_2554_art_31_1_a), cite(eu_reg_2022_2554_art_31_2), cite(eu_reg_2022_2554_art_31_3), cite(eu_reg_2024_1502_art_1_1), cite(eu_reg_2024_1502_art_1_2), cite(eu_reg_2024_1502_art_2_1), cite(eu_reg_2024_1502_art_2_4), cite(eu_reg_2024_1502_art_3_1), cite(eu_reg_2024_1502_art_3_2), cite(eu_reg_2024_1502_art_3_3), cite(eu_reg_2024_1502_art_5_1), cite(eu_reg_2024_1502_art_5_4)], ExpectedCitations),
    SortedCitations == ExpectedCitations.
test(the_not_fulfilled_answer_has_the_same_citations) :-
    dora_ctpp_designation_profile_for(fixture_impact_just_below_ten_percent, Profile),
    ctpp_designation_criteria_status(Profile, step_1_sub_criteria_not_fulfilled, Citations),
    dora_ctpp_designation_profile_for(fixture_step_1_fulfilled_exact_ten_percent, FulfilledProfile),
    ctpp_designation_criteria_status(FulfilledProfile, step_1_sub_criteria_fulfilled, FulfilledCitations),
    clausal_msort(Citations, SortedCitations),
    clausal_msort(FulfilledCitations, SortedCitations).
test(exact_ten_percent_is_fulfilled) :-
    criteria_answers(fixture_step_1_fulfilled_exact_ten_percent, Answers),
    Answers == [step_1_sub_criteria_fulfilled].
test(two_of_twenty_one_is_not_fulfilled) :-
    criteria_answers(fixture_impact_just_below_ten_percent, Answers),
    Answers == [step_1_sub_criteria_not_fulfilled].
test(a_financial_entity_is_excluded) :-
    criteria_answers(fixture_financial_entity_provider, Answers),
    Answers == [designation_not_applicable(financial_entity)].
test(none_of_the_listed_types_is_no_provider) :-
    criteria_answers(fixture_not_a_provider, Answers),
    Answers == [not_an_ict_third_party_service_provider].
test(point_ii_excludes) :-
    criteria_answers(fixture_tfeu_oversight_excluded, Answers),
    Answers == [designation_not_applicable(article_127_2_tfeu_oversight_framework)].
test(point_iii_excludes) :-
    criteria_answers(fixture_intra_group_excluded, Answers),
    Answers == [designation_not_applicable(ict_intra_group_service_provider)].
test(point_iv_excludes) :-
    criteria_answers(fixture_single_member_state_excluded, Answers),
    Answers == [designation_not_applicable(single_member_state_provider)].
test(one_fact_of_point_iv_does_not_exclude) :-
    criteria_answers(fixture_point_iv_one_fact_only, Answers),
    Answers == [step_1_sub_criteria_fulfilled].
test(shares_in_two_categories_do_not_fulfil) :-
    criteria_answers(fixture_step_1_fails_impact_split_categories, Answers),
    Answers == [step_1_sub_criteria_not_fulfilled].
test(an_o_sii_score_of_3000_does_not_fulfil) :-
    criteria_answers(fixture_o_sii_score_exactly_3000, Answers),
    Answers == [step_1_sub_criteria_not_fulfilled].
test(an_o_sii_score_of_3001_fulfils) :-
    criteria_answers(fixture_o_sii_score_3001, Answers),
    Answers == [step_1_sub_criteria_fulfilled].
test(two_o_siis_do_not_fulfil) :-
    criteria_answers(fixture_two_o_siis, Answers),
    Answers == [step_1_sub_criteria_not_fulfilled].
test(three_o_siis_fulfil) :-
    criteria_answers(fixture_three_o_siis, Answers),
    Answers == [step_1_sub_criteria_fulfilled].
test(two_other_systemic_entities_do_not_fulfil) :-
    criteria_answers(fixture_two_other_systemic_entities, Answers),
    Answers == [step_1_sub_criteria_not_fulfilled].
test(three_other_systemic_entities_fulfil) :-
    criteria_answers(fixture_three_other_systemic_entities, Answers),
    Answers == [step_1_sub_criteria_fulfilled].
test(one_of_eleven_does_not_fulfil_substitutability) :-
    criteria_answers(fixture_substitutability_just_below, Answers),
    Answers == [step_1_sub_criteria_not_fulfilled].
test(a_migration_share_of_ten_percent_fulfils) :-
    criteria_answers(fixture_migration_share_exactly_ten_percent, Answers),
    Answers == [step_1_sub_criteria_fulfilled].
test(pooled_payment_institutions_fulfil) :-
    criteria_answers(fixture_pooled_payment_institutions, Answers),
    Answers == [step_1_sub_criteria_fulfilled].
test(pooled_payment_institutions_below_do_not_fulfil) :-
    criteria_answers(fixture_pooled_payment_institutions_below, Answers),
    Answers == [step_1_sub_criteria_not_fulfilled].
test(a_synonym_alone_fulfils) :-
    criteria_answers(fixture_synonym_alone, Answers),
    Answers == [step_1_sub_criteria_fulfilled].
test(a_missing_type_is_asked) :-
    criteria_answers(fixture_missing_type, Answers),
    Answers == [indeterminate([dora_entity_type])].
test(missing_point_iv_facts_ask_the_first) :-
    criteria_answers(fixture_missing_point_iv, Answers),
    Answers == [indeterminate([provider_provides_ict_services_solely_in_one_member_state])].
test(missing_substitutability_is_asked) :-
    criteria_answers(fixture_missing_substitutability, Answers),
    Answers == [indeterminate([substitutability_figures])].
test(a_float_and_a_duplicate_are_input_problems_in_contract_order) :-
    criteria_answers(fixture_input_problems_float_and_duplicate, Answers),
    Answers == [input_problems([wrong_type(g_sii_served_count), duplicate_key(provider_is_part_of_a_group)])].
test(the_directive_2013_36_atom_is_an_input_problem) :-
    criteria_answers(fixture_directive_2013_36_type, Answers),
    Answers == [input_problems([wrong_type(dora_entity_type)])].
test(the_baseline_indicators_in_order) :-
    indicator_answers(fixture_step_1_fulfilled_exact_ten_percent, Answers),
    Answers == [step_1_indicators([sub_criteria_1_1_and_1_2([credit_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_1([credit_institution])])].
test(pooled_categories_are_named_by_the_main_atom) :-
    indicator_answers(fixture_pooled_payment_institutions, Answers),
    Answers == [step_1_indicators([sub_criteria_1_1_and_1_2([payment_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_1([credit_institution])])].
test(a_synonym_alone_is_named_by_the_synonym) :-
    indicator_answers(fixture_synonym_alone, Answers),
    Answers == [step_1_indicators([sub_criteria_1_1_and_1_2([exempted_payment_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_1([credit_institution])])].
test(the_migration_share_is_sub_criterion_4_2) :-
    indicator_answers(fixture_migration_share_exactly_ten_percent, Answers),
    Answers == [step_1_indicators([sub_criteria_1_1_and_1_2([credit_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_2([credit_institution])])].
test(the_indicators_ignore_the_exclusions) :-
    indicator_answers(fixture_financial_entity_provider, Answers),
    Answers == [step_1_indicators([sub_criteria_1_1_and_1_2([credit_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_1([credit_institution])])].
test(categories_follow_the_shared_type_set) :-
    findall(Result, ctpp_step_1_indicators([attribute(systemic_impact_figures, [category_share_figures(trading_venue, 1, 1, 1, 1), category_share_figures(credit_institution, 5, 10, 5, 10)]), attribute(g_sii_served_count, 0), attribute(o_sii_scores_of_o_siis_served, []), attribute(systemic_infrastructure_entities_served_count, 0), attribute(systemic_other_entities_served_count, 0), attribute(substitutability_figures, [])], Result, _), Results),
    Results == [step_1_indicators([sub_criteria_1_1_and_1_2([credit_institution, trading_venue])])].
test(no_indicator_gives_an_empty_list) :-
    findall(Result, ctpp_step_1_indicators([attribute(systemic_impact_figures, []), attribute(g_sii_served_count, 0), attribute(o_sii_scores_of_o_siis_served, []), attribute(systemic_infrastructure_entities_served_count, 0), attribute(systemic_other_entities_served_count, 0), attribute(substitutability_figures, [])], Result, _), Results),
    Results == [step_1_indicators([])].
test(the_indicators_ask_for_missing_substitutability) :-
    indicator_answers(fixture_missing_substitutability, Answers),
    Answers == [indeterminate([substitutability_figures])].
test(the_indicators_cite_fourteen_provisions) :-
    dora_ctpp_designation_profile_for(fixture_step_1_fulfilled_exact_ten_percent, Profile),
    ctpp_step_1_indicators(Profile, step_1_indicators(_), Citations),
    length(Citations, 14).
test(eiopa_one_euro_ahead_is_lead_overseer) :-
    lead_answers(fixture_lead_overseer_eiopa, Answers),
    Answers == [lead_overseer(eiopa)].
test(equal_largest_sums_are_tied_in_order) :-
    lead_answers(fixture_lead_overseer_tied_eba_eiopa, Answers),
    Answers == [lead_overseer_tied([eba, eiopa])].
test(three_equal_sums_are_all_tied) :-
    findall(Result, ctpp_lead_overseer([attribute(total_assets_of_users_within_esma_responsibility, 7), attribute(total_assets_of_users_within_eiopa_responsibility, 7), attribute(total_assets_of_users_within_eba_responsibility, 7)], Result, _), Results),
    Results == [lead_overseer_tied([eba, eiopa, esma])].
test(esma_largest_is_lead_overseer) :-
    findall(Result - Citations, ctpp_lead_overseer([attribute(total_assets_of_users_within_eba_responsibility, 1), attribute(total_assets_of_users_within_eiopa_responsibility, 2), attribute(total_assets_of_users_within_esma_responsibility, 3)], Result, Citations), Answers),
    Answers == [lead_overseer(esma) - [cite(eu_reg_2022_2554_art_31_1_b)]].
test(a_missing_eba_sum_is_asked_first) :-
    findall(Result - Citations, ctpp_lead_overseer([attribute(total_assets_of_users_within_eiopa_responsibility, 2)], Result, Citations), Answers),
    Answers == [indeterminate([total_assets_of_users_within_eba_responsibility]) - []].
test(all_three_duties_in_order) :-
    duty_answers(fixture_duties_group_third_country, Answers),
    Answers == [required([designate_coordination_point, notify_financial_entities_of_designation, notify_lead_overseer_of_subsidiary_management_changes])].
test(all_three_duties_cite_their_paragraphs) :-
    dora_ctpp_designation_profile_for(fixture_duties_group_third_country, Profile),
    ctpp_designated_provider_duties(Profile, required(_), Citations),
    clausal_msort(Citations, SortedCitations),
    clausal_msort([cite(eu_reg_2022_2554_art_31_4), cite(eu_reg_2022_2554_art_31_5), cite(eu_reg_2022_2554_art_31_13)], ExpectedCitations),
    SortedCitations == ExpectedCitations.
test(the_notification_alone) :-
    duty_answers(fixture_duties_notification_only, Answers),
    Answers == [required([notify_financial_entities_of_designation])].
test(a_provider_not_designated) :-
    duty_answers(fixture_not_designated, Answers),
    Answers == [not_designated_as_critical].
test(the_third_country_is_asked_last) :-
    findall(Result, ctpp_designated_provider_duties([attribute(provider_designated_as_critical, true), attribute(provider_is_part_of_a_group, false)], Result, _), Results),
    Results == [indeterminate([provider_established_in_third_country])].

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_its_citations, the_not_fulfilled_answer_has_the_same_citations, exact_ten_percent_is_fulfilled, two_of_twenty_one_is_not_fulfilled, a_financial_entity_is_excluded, none_of_the_listed_types_is_no_provider, point_ii_excludes, point_iii_excludes, point_iv_excludes, one_fact_of_point_iv_does_not_exclude, shares_in_two_categories_do_not_fulfil, an_o_sii_score_of_3000_does_not_fulfil, an_o_sii_score_of_3001_fulfils, two_o_siis_do_not_fulfil, three_o_siis_fulfil, two_other_systemic_entities_do_not_fulfil, three_other_systemic_entities_fulfil, one_of_eleven_does_not_fulfil_substitutability, a_migration_share_of_ten_percent_fulfils, pooled_payment_institutions_fulfil, pooled_payment_institutions_below_do_not_fulfil, a_synonym_alone_fulfils, a_missing_type_is_asked, missing_point_iv_facts_ask_the_first, missing_substitutability_is_asked, a_float_and_a_duplicate_are_input_problems_in_contract_order, the_directive_2013_36_atom_is_an_input_problem, the_baseline_indicators_in_order, pooled_categories_are_named_by_the_main_atom, a_synonym_alone_is_named_by_the_synonym, the_migration_share_is_sub_criterion_4_2, the_indicators_ignore_the_exclusions, categories_follow_the_shared_type_set, no_indicator_gives_an_empty_list, the_indicators_ask_for_missing_substitutability, the_indicators_cite_fourteen_provisions, eiopa_one_euro_ahead_is_lead_overseer, equal_largest_sums_are_tied_in_order, three_equal_sums_are_all_tied, esma_largest_is_lead_overseer, a_missing_eba_sum_is_asked_first, all_three_duties_in_order, all_three_duties_cite_their_paragraphs, the_notification_alone, a_provider_not_designated, the_third_country_is_asked_last]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
