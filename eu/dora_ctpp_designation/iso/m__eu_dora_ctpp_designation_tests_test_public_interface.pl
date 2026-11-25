% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_designation_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ctpp_designation_dora_ctpp_designation, [decide_dora_ctpp_designation/2, dora_ctpp_designation_status/2, dora_ctpp_designation_checklist/2, dora_ctpp_designation_decision_resolvable/1, dora_ctpp_designation_status_values/1, ctpp_designation_criteria_status/3, ctpp_step_1_indicators/3, ctpp_lead_overseer/3, ctpp_designated_provider_duties/3]).
:- use_module(m__eu_dora_ctpp_designation_fixtures, [dora_ctpp_designation_subject/1, dora_ctpp_designation_profile_for/2, dora_ctpp_designation_assess/2]).
:- use_module(m__eu_dora_ctpp_designation_kernel, [dora_ctpp_designation_input_problems/2]).
:- use_module(m__eu_dora_ctpp_designation_queries, [dora_ctpp_designation_what_if/4]).

expected_criteria_status(fixture_step_1_fulfilled_exact_ten_percent, step_1_sub_criteria_fulfilled).
expected_criteria_status(fixture_impact_just_below_ten_percent, step_1_sub_criteria_not_fulfilled).
expected_criteria_status(fixture_financial_entity_provider, designation_not_applicable(financial_entity)).
expected_criteria_status(fixture_not_a_provider, not_an_ict_third_party_service_provider).
expected_criteria_status(fixture_tfeu_oversight_excluded, designation_not_applicable(article_127_2_tfeu_oversight_framework)).
expected_criteria_status(fixture_intra_group_excluded, designation_not_applicable(ict_intra_group_service_provider)).
expected_criteria_status(fixture_single_member_state_excluded, designation_not_applicable(single_member_state_provider)).
expected_criteria_status(fixture_point_iv_one_fact_only, step_1_sub_criteria_fulfilled).
expected_criteria_status(fixture_step_1_fails_impact_split_categories, step_1_sub_criteria_not_fulfilled).
expected_criteria_status(fixture_o_sii_score_exactly_3000, step_1_sub_criteria_not_fulfilled).
expected_criteria_status(fixture_o_sii_score_3001, step_1_sub_criteria_fulfilled).
expected_criteria_status(fixture_two_o_siis, step_1_sub_criteria_not_fulfilled).
expected_criteria_status(fixture_three_o_siis, step_1_sub_criteria_fulfilled).
expected_criteria_status(fixture_two_other_systemic_entities, step_1_sub_criteria_not_fulfilled).
expected_criteria_status(fixture_three_other_systemic_entities, step_1_sub_criteria_fulfilled).
expected_criteria_status(fixture_substitutability_just_below, step_1_sub_criteria_not_fulfilled).
expected_criteria_status(fixture_migration_share_exactly_ten_percent, step_1_sub_criteria_fulfilled).
expected_criteria_status(fixture_pooled_payment_institutions, step_1_sub_criteria_fulfilled).
expected_criteria_status(fixture_pooled_payment_institutions_below, step_1_sub_criteria_not_fulfilled).
expected_criteria_status(fixture_synonym_alone, step_1_sub_criteria_fulfilled).
expected_criteria_status(fixture_missing_type, indeterminate([dora_entity_type])).
expected_criteria_status(fixture_missing_point_iv, indeterminate([provider_provides_ict_services_solely_in_one_member_state])).
expected_criteria_status(fixture_missing_substitutability, indeterminate([substitutability_figures])).
expected_criteria_status(fixture_lead_overseer_eiopa, indeterminate([dora_entity_type])).
expected_criteria_status(fixture_lead_overseer_tied_eba_eiopa, indeterminate([dora_entity_type])).
expected_criteria_status(fixture_duties_group_third_country, indeterminate([dora_entity_type])).
expected_criteria_status(fixture_duties_notification_only, indeterminate([dora_entity_type])).
expected_criteria_status(fixture_not_designated, indeterminate([dora_entity_type])).
expected_criteria_status(fixture_input_problems_float_and_duplicate, input_problems([wrong_type(g_sii_served_count), duplicate_key(provider_is_part_of_a_group)])).
expected_criteria_status(fixture_directive_2013_36_type, input_problems([wrong_type(dora_entity_type)])).
expected_criteria_status(fixture_unbound_key, input_problems([unknown_key(_)])).

near_miss_pair(fixture_step_1_fulfilled_exact_ten_percent, fixture_impact_just_below_ten_percent).
near_miss_pair(fixture_o_sii_score_3001, fixture_o_sii_score_exactly_3000).
near_miss_pair(fixture_three_o_siis, fixture_two_o_siis).
near_miss_pair(fixture_three_other_systemic_entities, fixture_two_other_systemic_entities).
near_miss_pair(fixture_migration_share_exactly_ten_percent, fixture_substitutability_just_below).
near_miss_pair(fixture_pooled_payment_institutions, fixture_pooled_payment_institutions_below).
near_miss_pair(fixture_point_iv_one_fact_only, fixture_single_member_state_excluded).
near_miss_pair(fixture_step_1_fulfilled_exact_ten_percent, fixture_financial_entity_provider).
near_miss_pair(fixture_step_1_fulfilled_exact_ten_percent, fixture_missing_substitutability).

step_1_citations([cite(eu_reg_2022_2554_art_31_1_a), cite(eu_reg_2022_2554_art_31_2), cite(eu_reg_2022_2554_art_31_3), cite(eu_reg_2024_1502_art_1_1), cite(eu_reg_2024_1502_art_1_2), cite(eu_reg_2024_1502_art_2_1), cite(eu_reg_2024_1502_art_2_4), cite(eu_reg_2024_1502_art_3_1), cite(eu_reg_2024_1502_art_3_2), cite(eu_reg_2024_1502_art_3_3), cite(eu_reg_2024_1502_art_5_1), cite(eu_reg_2024_1502_art_5_4)]).

criteria_status(Subject, Status) :-
    findall(FoundStatus, dora_ctpp_designation_assess(Subject, dora_ctpp_designation_verdict(FoundStatus, _)), Statuses),
    Statuses = [Status].

subject_matches_expected(Subject - Expected) :-
    criteria_status(Subject, Status),
    subsumes_term(Expected, Status),
    subsumes_term(Status, Expected).

subject_has_expected_row(Subject) :-
    expected_criteria_status(Subject, _).

pair_differs(Positive - Control) :-
    criteria_status(Positive, PositiveStatus),
    criteria_status(Control, ControlStatus),
    PositiveStatus \== ControlStatus.

same_citations(Citations, ExpectedCitations) :-
    clausal_msort(Citations, SortedCitations),
    clausal_msort(ExpectedCitations, SortedCitations).

citation_term(cite(CitationKey)) :-
    atom(CitationKey).

subject_profile(Subject, Profile) :-
    dora_ctpp_designation_profile_for(Subject, Profile).

checklist_is_non_empty(Subject) :-
    subject_profile(Subject, Profile),
    dora_ctpp_designation_checklist(Profile, [_FirstItem|_OtherItems]).

every_query_answers_once(Subject) :-
    subject_profile(Subject, Profile),
    findall(Result - Citations, ctpp_designation_criteria_status(Profile, Result, Citations), CriteriaAnswers),
    length(CriteriaAnswers, 1),
    findall(Result - Citations, ctpp_step_1_indicators(Profile, Result, Citations), IndicatorAnswers),
    length(IndicatorAnswers, 1),
    findall(Result - Citations, ctpp_lead_overseer(Profile, Result, Citations), OverseerAnswers),
    length(OverseerAnswers, 1),
    findall(Result - Citations, ctpp_designated_provider_duties(Profile, Result, Citations), DutyAnswers),
    length(DutyAnswers, 1),
    findall(Problems, dora_ctpp_designation_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1).

final_status_named(Status) :-
    dora_ctpp_designation_status_values(StatusValues),
    functor(Status, StatusName, _),
    member(StatusName, StatusValues).

indicators_of(Subject, Result) :-
    subject_profile(Subject, Profile),
    ctpp_step_1_indicators(Profile, Result, _).

test(every_subject_has_an_expected_status) :-
    findall(Subject, dora_ctpp_designation_subject(Subject), Subjects),
    length(Subjects, 31),
    maplist(subject_has_expected_row, Subjects).
test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject - Expected, expected_criteria_status(Subject, Expected), Rows),
    maplist(subject_matches_expected, Rows).
test(every_near_miss_control_gets_a_different_verdict) :-
    findall(Positive - Control, near_miss_pair(Positive, Control), Pairs),
    maplist(pair_differs, Pairs).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, dora_ctpp_designation_subject(Subject), Subjects),
    maplist(checklist_is_non_empty, Subjects).
test(every_query_answers_each_subject_exactly_once) :-
    findall(Subject, dora_ctpp_designation_subject(Subject), Subjects),
    maplist(every_query_answers_once, Subjects).
test(exact_ten_percent_fulfils_step_1_with_its_twelve_citations) :-
    dora_ctpp_designation_assess(fixture_step_1_fulfilled_exact_ten_percent, dora_ctpp_designation_verdict(Status, Citations)),
    Status == step_1_sub_criteria_fulfilled,
    step_1_citations(ExpectedCitations),
    same_citations(Citations, ExpectedCitations),
    final_status_named(Status).
test(just_below_ten_percent_is_not_fulfilled_with_the_same_citations) :-
    dora_ctpp_designation_assess(fixture_impact_just_below_ten_percent, dora_ctpp_designation_verdict(Status, Citations)),
    Status == step_1_sub_criteria_not_fulfilled,
    step_1_citations(ExpectedCitations),
    same_citations(Citations, ExpectedCitations).
test(a_financial_entity_is_excluded_by_point_i) :-
    subject_profile(fixture_financial_entity_provider, Profile),
    ctpp_designation_criteria_status(Profile, Result, Citations),
    Result == designation_not_applicable(financial_entity),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_31_8), cite(eu_reg_2022_2554_art_31_8_i)]),
    final_status_named(Result).
test(an_undertaking_of_none_of_the_types_is_no_provider) :-
    subject_profile(fixture_not_a_provider, Profile),
    ctpp_designation_criteria_status(Profile, Result, Citations),
    Result == not_an_ict_third_party_service_provider,
    Citations == [cite(eu_reg_2022_2554_art_31_1_a)].
test(an_article_127_2_framework_excludes) :-
    subject_profile(fixture_tfeu_oversight_excluded, Profile),
    ctpp_designation_criteria_status(Profile, Result, Citations),
    Result == designation_not_applicable(article_127_2_tfeu_oversight_framework),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_31_8), cite(eu_reg_2022_2554_art_31_8_ii)]).
test(an_intra_group_provider_is_excluded) :-
    subject_profile(fixture_intra_group_excluded, Profile),
    ctpp_designation_criteria_status(Profile, Result, Citations),
    Result == designation_not_applicable(ict_intra_group_service_provider),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_31_8), cite(eu_reg_2022_2554_art_31_8_iii)]).
test(a_single_member_state_provider_is_excluded) :-
    subject_profile(fixture_single_member_state_excluded, Profile),
    ctpp_designation_criteria_status(Profile, Result, Citations),
    Result == designation_not_applicable(single_member_state_provider),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_31_8), cite(eu_reg_2022_2554_art_31_8_iv)]).
test(one_fact_of_point_iv_leaves_step_1_fulfilled) :-
    dora_ctpp_designation_status(fixture_point_iv_profile_unused, _) ; true.
test(an_o_sii_score_of_3001_counts) :-
    criteria_status(fixture_o_sii_score_3001, Status),
    Status == step_1_sub_criteria_fulfilled.
test(missing_keys_are_named_one_at_a_time) :-
    subject_profile(fixture_missing_point_iv, PointProfile),
    ctpp_designation_criteria_status(PointProfile, PointResult, PointCitations),
    PointResult == indeterminate([provider_provides_ict_services_solely_in_one_member_state]),
    PointCitations == [],
    subject_profile(fixture_missing_substitutability, FigureProfile),
    ctpp_designation_criteria_status(FigureProfile, FigureResult, []),
    FigureResult == indeterminate([substitutability_figures]).
test(an_unbound_key_is_reported_as_that_variable) :-
    criteria_status(fixture_unbound_key, Status),
    Status = input_problems([unknown_key(ReportedKey)]),
    var(ReportedKey).
test(input_problems_come_in_contract_order_with_no_citations) :-
    subject_profile(fixture_input_problems_float_and_duplicate, Profile),
    dora_ctpp_designation_input_problems(Profile, Problems),
    Problems == [wrong_type(g_sii_served_count), duplicate_key(provider_is_part_of_a_group)],
    ctpp_designated_provider_duties(Profile, Result, Citations),
    Result == input_problems(Problems),
    Citations == [].
test(a_well_formed_fixture_has_no_input_problem) :-
    subject_profile(fixture_step_1_fulfilled_exact_ten_percent, Profile),
    dora_ctpp_designation_input_problems(Profile, Problems),
    Problems == [].
test(the_status_and_resolvable_facade_agree) :-
    subject_profile(fixture_pooled_payment_institutions, Profile),
    dora_ctpp_designation_decision_resolvable(Profile),
    dora_ctpp_designation_status(Profile, Status),
    decide_dora_ctpp_designation(Profile, dora_ctpp_designation_verdict(Status, _)),
    Status == step_1_sub_criteria_fulfilled.
test(the_checklist_items_carry_citations) :-
    subject_profile(fixture_step_1_fulfilled_exact_ten_percent, Profile),
    dora_ctpp_designation_checklist(Profile, Items),
    length(Items, 7),
    findall(Citation, member(item(_, _, Citation), Items), Citations),
    length(Citations, 7),
    maplist(citation_term, Citations).
test(indicators_of_the_boundary_provider) :-
    indicators_of(fixture_step_1_fulfilled_exact_ten_percent, Result),
    Result == step_1_indicators([sub_criteria_1_1_and_1_2([credit_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_1([credit_institution])]).
test(pooled_categories_are_named_by_the_main_atom) :-
    indicators_of(fixture_pooled_payment_institutions, Result),
    Result == step_1_indicators([sub_criteria_1_1_and_1_2([payment_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_1([credit_institution])]).
test(pooling_below_ten_percent_drops_the_category) :-
    indicators_of(fixture_pooled_payment_institutions_below, Result),
    Result == step_1_indicators([sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_1([credit_institution])]).
test(a_synonym_alone_is_named_by_the_synonym) :-
    indicators_of(fixture_synonym_alone, Result),
    Result == step_1_indicators([sub_criteria_1_1_and_1_2([exempted_payment_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_1([credit_institution])]).
test(the_migration_share_alone_gives_sub_criterion_4_2) :-
    indicators_of(fixture_migration_share_exactly_ten_percent, Result),
    Result == step_1_indicators([sub_criteria_1_1_and_1_2([credit_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_2([credit_institution])]).
test(indicators_carry_fourteen_citations) :-
    subject_profile(fixture_financial_entity_provider, Profile),
    ctpp_step_1_indicators(Profile, step_1_indicators(_), Citations),
    length(Citations, 14).
test(an_empty_profile_asks_for_the_impact_figures) :-
    subject_profile(fixture_missing_type, Profile),
    ctpp_step_1_indicators(Profile, Result, Citations),
    Result == indeterminate([systemic_impact_figures]),
    Citations == [].
test(the_largest_sum_appoints_eiopa) :-
    subject_profile(fixture_lead_overseer_eiopa, Profile),
    ctpp_lead_overseer(Profile, Result, Citations),
    Result == lead_overseer(eiopa),
    Citations == [cite(eu_reg_2022_2554_art_31_1_b)].
test(equal_largest_sums_are_tied) :-
    subject_profile(fixture_lead_overseer_tied_eba_eiopa, Profile),
    ctpp_lead_overseer(Profile, Result, Citations),
    Result == lead_overseer_tied([eba, eiopa]),
    Citations == [cite(eu_reg_2022_2554_art_31_1_b)].
test(a_profile_without_sums_asks_for_the_eba_sum) :-
    subject_profile(fixture_missing_type, Profile),
    ctpp_lead_overseer(Profile, Result, []),
    Result == indeterminate([total_assets_of_users_within_eba_responsibility]).
test(a_designated_group_provider_in_a_third_country_has_three_duties) :-
    subject_profile(fixture_duties_group_third_country, Profile),
    ctpp_designated_provider_duties(Profile, Result, Citations),
    Result == required([designate_coordination_point, notify_financial_entities_of_designation, notify_lead_overseer_of_subsidiary_management_changes]),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_31_4), cite(eu_reg_2022_2554_art_31_5), cite(eu_reg_2022_2554_art_31_13)]).
test(a_designated_provider_always_notifies_its_financial_entities) :-
    subject_profile(fixture_duties_notification_only, Profile),
    ctpp_designated_provider_duties(Profile, Result, Citations),
    Result == required([notify_financial_entities_of_designation]),
    Citations == [cite(eu_reg_2022_2554_art_31_5)].
test(a_provider_not_designated_has_no_duties) :-
    subject_profile(fixture_not_designated, Profile),
    ctpp_designated_provider_duties(Profile, Result, Citations),
    Result == not_designated_as_critical,
    Citations == [cite(eu_reg_2022_2554_art_31_1_a)].
test(raising_the_o_sii_score_by_one_flips_the_verdict) :-
    subject_profile(fixture_o_sii_score_exactly_3000, Profile),
    dora_ctpp_designation_what_if(Profile, o_sii_scores_of_o_siis_served, [3001], Status),
    Status == step_1_sub_criteria_fulfilled.
test(lowering_the_other_systemic_count_by_one_flips_the_verdict) :-
    subject_profile(fixture_three_other_systemic_entities, Profile),
    dora_ctpp_designation_what_if(Profile, systemic_other_entities_served_count, 2, Status),
    Status == step_1_sub_criteria_not_fulfilled.

test(just_below_ten_percent_is_not_fulfilled, fail) :-
    dora_ctpp_designation_assess(fixture_impact_just_below_ten_percent, dora_ctpp_designation_verdict(step_1_sub_criteria_fulfilled, _)).
test(one_fact_of_point_iv_does_not_exclude, fail) :-
    dora_ctpp_designation_assess(fixture_point_iv_one_fact_only, dora_ctpp_designation_verdict(designation_not_applicable(_), _)).
test(an_o_sii_score_of_exactly_3000_does_not_count, fail) :-
    dora_ctpp_designation_assess(fixture_o_sii_score_exactly_3000, dora_ctpp_designation_verdict(step_1_sub_criteria_fulfilled, _)).
test(a_tie_names_no_single_overseer, fail) :-
    subject_profile(fixture_lead_overseer_tied_eba_eiopa, Profile),
    ctpp_lead_overseer(Profile, lead_overseer(_), _).
test(a_provider_not_designated_is_not_required, fail) :-
    subject_profile(fixture_not_designated, Profile),
    ctpp_designated_provider_duties(Profile, required(_), _).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status, every_near_miss_control_gets_a_different_verdict, every_subject_has_a_non_empty_checklist, every_query_answers_each_subject_exactly_once, exact_ten_percent_fulfils_step_1_with_its_twelve_citations, just_below_ten_percent_is_not_fulfilled_with_the_same_citations, a_financial_entity_is_excluded_by_point_i, an_undertaking_of_none_of_the_types_is_no_provider, an_article_127_2_framework_excludes, an_intra_group_provider_is_excluded, a_single_member_state_provider_is_excluded, one_fact_of_point_iv_leaves_step_1_fulfilled, an_o_sii_score_of_3001_counts, missing_keys_are_named_one_at_a_time, an_unbound_key_is_reported_as_that_variable, input_problems_come_in_contract_order_with_no_citations, a_well_formed_fixture_has_no_input_problem, the_status_and_resolvable_facade_agree, the_checklist_items_carry_citations, indicators_of_the_boundary_provider, pooled_categories_are_named_by_the_main_atom, pooling_below_ten_percent_drops_the_category, a_synonym_alone_is_named_by_the_synonym, the_migration_share_alone_gives_sub_criterion_4_2, indicators_carry_fourteen_citations, an_empty_profile_asks_for_the_impact_figures, the_largest_sum_appoints_eiopa, equal_largest_sums_are_tied, a_profile_without_sums_asks_for_the_eba_sum, a_designated_group_provider_in_a_third_country_has_three_duties, a_designated_provider_always_notifies_its_financial_entities, a_provider_not_designated_has_no_duties, raising_the_o_sii_score_by_one_flips_the_verdict, lowering_the_other_systemic_count_by_one_flips_the_verdict]).
cp_test_fail_names([just_below_ten_percent_is_not_fulfilled, one_fact_of_point_iv_does_not_exclude, an_o_sii_score_of_exactly_3000_does_not_count, a_tie_names_no_single_overseer, a_provider_not_designated_is_not_required]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
