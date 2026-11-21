% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_state_aid_gber_general_conditions_gber_general_conditions, [decide_gber_general_conditions/2, gber_general_conditions_status/2, gber_general_conditions_checklist/2, gber_general_conditions_decision_resolvable/1, gber_general_conditions_status_values/1, gber_scope/3, gber_notification_threshold/4, gber_transparency/3, gber_incentive_effect/5, gber_cumulation/7, gber_chapter_i_conditions/10]).
:- use_module(m__eu_state_aid_gber_general_conditions_fixtures, [gber_general_conditions_subject/1, gber_general_conditions_profile_for/2, gber_general_conditions_assess/2]).
:- use_module(m__eu_state_aid_gber_general_conditions_queries, [gber_general_conditions_what_if/4]).
:- use_module(m__eu_state_aid_gber_general_conditions_kernel, [gber_general_conditions_input_problems/2]).

expected_status(compliant_sme_grant, tested_chapter_i_conditions_met).
expected_status(same_day_application, chapter_i_conditions_not_met).
expected_status(application_day_before_start, tested_chapter_i_conditions_met).
expected_status(threshold_at_figure, tested_chapter_i_conditions_met).
expected_status(threshold_one_cent_over, chapter_i_conditions_not_met).
expected_status(other_category_row, chapter_i_conditions_partly_untested).
expected_status(de_minimis_at_intensity, tested_chapter_i_conditions_met).
expected_status(de_minimis_one_cent_over, chapter_i_conditions_not_met).
expected_status(difficulty_unsure, needs_legal_review(open_textured(undertaking_in_difficulty, cite(eu_reg_651_2014_art_1_4_c)), [inputs_relied_on([undertaking_in_difficulty - unsure, difficulty_exception_applies - false, difficulty_2020_2021_derogation - false])])).
expected_status(difficulty_without_exception, chapter_i_conditions_not_met).
expected_status(difficulty_with_derogation, tested_chapter_i_conditions_met).
expected_status(recovery_order_outstanding, chapter_i_conditions_not_met).
expected_status(transparent_loan, tested_chapter_i_conditions_met).
expected_status(non_transparent_other_form, chapter_i_conditions_not_met).
expected_status(ad_hoc_large_enterprise_verified, tested_chapter_i_conditions_met).
expected_status(ad_hoc_large_enterprise_unverified, chapter_i_conditions_not_met).
expected_status(doubled_industrial_research, tested_chapter_i_conditions_met).
expected_status(undoubled_industrial_research, chapter_i_conditions_not_met).
expected_status(doubled_research_at_twice_figure, tested_chapter_i_conditions_met).
expected_status(doubled_research_one_cent_over_twice, chapter_i_conditions_not_met).
expected_status(not_an_enterprise_size, input_problems([wrong_type(size_class)])).
expected_status(large_enterprise_scheme_aid, tested_chapter_i_conditions_met).
expected_status(empty_profile, indeterminate([scheme_excluded_by_article_1_2_a_or_b])).

status_citations(tested_chapter_i_conditions_met, [cite(eu_reg_651_2014_art_3_t1)]).
status_citations(chapter_i_conditions_partly_untested, [cite(eu_reg_651_2014_art_3_t1)]).
status_citations(chapter_i_conditions_not_met, [cite(eu_reg_651_2014_art_3_t1), cite(eu_reg_651_2014_art_1_2), cite(eu_reg_651_2014_art_1_3), cite(eu_reg_651_2014_art_1_4), cite(eu_reg_651_2014_art_1_5), cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_5_1), cite(eu_reg_651_2014_art_6_1), cite(eu_reg_651_2014_art_8_3), cite(eu_reg_651_2014_art_8_5)]).
status_citations(needs_legal_review(_, _), []).
status_citations(indeterminate(_), []).
status_citations(input_problems(_), []).

subject_has_expected_status(Subject) :-
    expected_status(Subject, Expected),
    gber_general_conditions_assess(Subject, gber_general_conditions_verdict(Status, _Citations)),
    Status == Expected.

subject_citations_match_status(Subject) :-
    gber_general_conditions_assess(Subject, gber_general_conditions_verdict(Status, Citations)),
    status_citations(Status, ExpectedCitations),
    clausal_msort(Citations, SortedCitations),
    clausal_msort(ExpectedCitations, SortedExpected),
    SortedCitations == SortedExpected.

subject_answers_once(Subject) :-
    gber_general_conditions_profile_for(Subject, Case),
    findall(Verdict, decide_gber_general_conditions(Case, Verdict), Verdicts),
    length(Verdicts, 1).

subject_checklist_has_five_items(Subject) :-
    gber_general_conditions_profile_for(Subject, Case),
    gber_general_conditions_checklist(Case, Items),
    length(Items, 5).

subject_is_resolvable(Subject) :-
    gber_general_conditions_profile_for(Subject, Case),
    gber_general_conditions_decision_resolvable(Case).

subject_has_expected_entry(Subject) :-
    expected_status(Subject, _).

subject_parts(Subject, Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints) :-
    gber_general_conditions_profile_for(Subject, gber_case(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints)).

same_citation_set(Citations, Expected) :-
    clausal_msort(Citations, SortedCitations),
    clausal_msort(Expected, SortedExpected),
    SortedCitations == SortedExpected.

test(every_subject_has_an_expected_status) :-
    findall(Subject, gber_general_conditions_subject(Subject), Subjects),
    length(Subjects, 23),
    maplist(subject_has_expected_entry, Subjects).
test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject, gber_general_conditions_subject(Subject), Subjects),
    maplist(subject_has_expected_status, Subjects).
test(every_subject_carries_the_citations_of_its_status) :-
    findall(Subject, gber_general_conditions_subject(Subject), Subjects),
    maplist(subject_citations_match_status, Subjects).
test(every_subject_answers_once) :-
    findall(Subject, gber_general_conditions_subject(Subject), Subjects),
    maplist(subject_answers_once, Subjects).
test(every_subject_has_a_five_item_checklist) :-
    findall(Subject, gber_general_conditions_subject(Subject), Subjects),
    maplist(subject_checklist_has_five_items, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, gber_general_conditions_subject(Subject), Subjects),
    maplist(subject_is_resolvable, Subjects).
test(the_compliant_grant_meets_the_tested_conditions) :-
    gber_general_conditions_assess(compliant_sme_grant, gber_general_conditions_verdict(tested_chapter_i_conditions_met, [cite(eu_reg_651_2014_art_3_t1)])).
test(the_status_projects_the_joined_answer) :-
    gber_general_conditions_profile_for(other_category_row, Case),
    gber_general_conditions_status(Case, chapter_i_conditions_partly_untested).
test(the_met_status_is_in_the_vocabulary) :-
    gber_general_conditions_profile_for(compliant_sme_grant, Case),
    gber_general_conditions_status(Case, Status),
    gber_general_conditions_status_values(StatusValues),
    member(Status, StatusValues).
test(the_joined_query_answers_directly) :-
    subject_parts(compliant_sme_grant, Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints),
    gber_chapter_i_conditions(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, tested_chapter_i_conditions_met, [cite(eu_reg_651_2014_art_3_t1)]).
test(a_same_day_application_is_not_met) :-
    gber_general_conditions_assess(same_day_application, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(an_application_the_day_before_is_met) :-
    gber_general_conditions_assess(application_day_before_start, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(a_same_day_application_has_no_incentive_effect) :-
    subject_parts(same_day_application, Profile, _, ApplicationDate, WorkStartDate, _, _, _, _),
    gber_incentive_effect(Profile, ApplicationDate, WorkStartDate, no_incentive_effect, Citations),
    length(Citations, 9).
test(an_application_the_day_before_has_an_incentive_effect) :-
    subject_parts(application_day_before_start, Profile, _, ApplicationDate, WorkStartDate, _, _, _, _),
    gber_incentive_effect(Profile, ApplicationDate, WorkStartDate, incentive_effect, _).
test(verified_ad_hoc_aid_to_a_large_enterprise_is_met) :-
    gber_general_conditions_assess(ad_hoc_large_enterprise_verified, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(unverified_ad_hoc_aid_to_a_large_enterprise_is_not_met) :-
    gber_general_conditions_assess(ad_hoc_large_enterprise_unverified, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(the_figure_itself_is_within_the_threshold) :-
    subject_parts(threshold_at_figure, Profile, ProjectAidCents, _, _, _, _, _, _),
    gber_notification_threshold(Profile, ProjectAidCents, within_threshold, Citations),
    same_citation_set(Citations, [cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_c), cite(eu_reg_651_2014_art_8_1)]).
test(one_cent_over_the_figure_exceeds_the_threshold) :-
    subject_parts(threshold_one_cent_over, Profile, ProjectAidCents, _, _, _, _, _, _),
    gber_notification_threshold(Profile, ProjectAidCents, threshold_exceeded, Citations),
    same_citation_set(Citations, [cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_c), cite(eu_reg_651_2014_art_8_1)]).
test(the_threshold_at_the_figure_is_met) :-
    gber_general_conditions_assess(threshold_at_figure, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(the_threshold_one_cent_over_is_not_met) :-
    gber_general_conditions_assess(threshold_one_cent_over, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(a_doubled_research_project_cites_point_iv) :-
    subject_parts(doubled_industrial_research, Profile, ProjectAidCents, _, _, _, _, _, _),
    gber_notification_threshold(Profile, ProjectAidCents, within_threshold, Citations),
    same_citation_set(Citations, [cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_i_ii), cite(eu_reg_651_2014_art_8_1), cite(eu_reg_651_2014_art_4_1_i), cite(eu_reg_651_2014_art_4_1_i_iv)]).
test(an_undoubled_research_project_over_the_figure_exceeds) :-
    subject_parts(undoubled_industrial_research, Profile, ProjectAidCents, _, _, _, _, _, _),
    gber_notification_threshold(Profile, ProjectAidCents, threshold_exceeded, _).
test(an_undoubled_research_project_is_not_met) :-
    gber_general_conditions_assess(undoubled_industrial_research, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(twice_the_figure_is_within_when_doubled) :-
    gber_general_conditions_assess(doubled_research_at_twice_figure, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(one_cent_over_twice_the_figure_is_exceeded) :-
    subject_parts(doubled_research_one_cent_over_twice, Profile, ProjectAidCents, _, _, _, _, _, _),
    gber_notification_threshold(Profile, ProjectAidCents, threshold_exceeded, _).
test(another_category_is_not_formalised) :-
    subject_parts(other_category_row, Profile, ProjectAidCents, _, _, _, _, _, _),
    gber_notification_threshold(Profile, ProjectAidCents, threshold_not_formalised, []).
test(another_category_is_partly_untested) :-
    gber_general_conditions_assess(other_category_row, gber_general_conditions_verdict(chapter_i_conditions_partly_untested, [cite(eu_reg_651_2014_art_3_t1)])).
test(a_total_at_the_intensity_is_allowed) :-
    subject_parts(de_minimis_at_intensity, Profile, _, _, _, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints),
    gber_cumulation(Profile, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, cumulation_allowed, Citations),
    same_citation_set(Citations, [cite(eu_reg_651_2014_art_8_3), cite(eu_reg_651_2014_art_8_3_a), cite(eu_reg_651_2014_art_8_3_b), cite(eu_reg_651_2014_art_8_5)]).
test(de_minimis_one_cent_over_is_not_allowed) :-
    subject_parts(de_minimis_one_cent_over, Profile, _, _, _, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints),
    gber_cumulation(Profile, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, cumulation_not_allowed, [cite(eu_reg_651_2014_art_8_5)]).
test(de_minimis_at_the_intensity_is_met) :-
    gber_general_conditions_assess(de_minimis_at_intensity, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(de_minimis_one_cent_over_is_not_met) :-
    gber_general_conditions_assess(de_minimis_one_cent_over, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(a_loan_meeting_its_condition_is_transparent) :-
    subject_parts(transparent_loan, Profile, _, _, _, _, _, _, _),
    gber_transparency(Profile, transparent_aid, Citations),
    length(Citations, 10).
test(another_form_with_every_way_ruled_out_is_not_transparent) :-
    subject_parts(non_transparent_other_form, Profile, _, _, _, _, _, _, _),
    gber_transparency(Profile, not_transparent_aid, _).
test(non_transparent_aid_is_not_met) :-
    gber_general_conditions_assess(non_transparent_other_form, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(the_base_profile_is_within_scope) :-
    subject_parts(compliant_sme_grant, Profile, _, _, _, _, _, _, _),
    gber_scope(Profile, within_scope, Citations),
    length(Citations, 23).
test(an_undertaking_in_difficulty_without_exception_is_excluded) :-
    subject_parts(difficulty_without_exception, Profile, _, _, _, _, _, _, _),
    gber_scope(Profile, excluded_from_scope, _).
test(the_2020_2021_derogation_keeps_the_aid_within_scope) :-
    subject_parts(difficulty_with_derogation, Profile, _, _, _, _, _, _, _),
    gber_scope(Profile, within_scope, _).
test(an_unsure_difficulty_goes_to_a_lawyer) :-
    subject_parts(difficulty_unsure, Profile, _, _, _, _, _, _, _),
    gber_scope(Profile, needs_legal_review(open_textured(undertaking_in_difficulty, cite(eu_reg_651_2014_art_1_4_c)), [inputs_relied_on([undertaking_in_difficulty - unsure, difficulty_exception_applies - false, difficulty_2020_2021_derogation - false])]), []).
test(an_outstanding_recovery_order_is_not_met) :-
    gber_general_conditions_assess(recovery_order_outstanding, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(an_empty_profile_asks_for_the_first_scope_key) :-
    gber_general_conditions_assess(empty_profile, gber_general_conditions_verdict(indeterminate([scheme_excluded_by_article_1_2_a_or_b]), [])).
test(a_provenance_term_may_follow_the_pairs) :-
    subject_parts(difficulty_unsure, Profile, _, _, _, _, _, _, _),
    gber_scope(Profile, needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(Pairs)]), []),
    append([inputs_relied_on(Pairs)], [provenance(gber_scope_step_4, [cite(CitationKey)])], Context),
    Context = [inputs_relied_on(ReadPairs), provenance(Clause, ProvenanceCitations)],
    InputKey == undertaking_in_difficulty,
    ReadPairs == [undertaking_in_difficulty - unsure, difficulty_exception_applies - false, difficulty_2020_2021_derogation - false],
    Clause == gber_scope_step_4,
    ProvenanceCitations == [cite(eu_reg_651_2014_art_1_4_c)].
test(not_an_enterprise_is_a_wrong_size_class) :-
    subject_parts(not_an_enterprise_size, Profile, _, _, _, _, _, _, _),
    gber_general_conditions_input_problems(Profile, [wrong_type(size_class)]).
test(a_large_enterprise_is_a_size_class) :-
    subject_parts(large_enterprise_scheme_aid, Profile, _, _, _, _, _, _, _),
    gber_general_conditions_input_problems(Profile, []).
test(every_query_reports_the_wrong_size_class) :-
    subject_parts(not_an_enterprise_size, Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints),
    gber_scope(Profile, input_problems([wrong_type(size_class)]), []),
    gber_notification_threshold(Profile, ProjectAidCents, input_problems([wrong_type(size_class)]), []),
    gber_transparency(Profile, input_problems([wrong_type(size_class)]), []),
    gber_incentive_effect(Profile, ApplicationDate, WorkStartDate, input_problems([wrong_type(size_class)]), []),
    gber_cumulation(Profile, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, input_problems([wrong_type(size_class)]), []).
test(a_duplicate_key_is_named_once) :-
    gber_general_conditions_input_problems([attribute(aid_form, grant), attribute(aid_form, loan)], [duplicate_key(aid_form)]).
test(an_unknown_key_is_named) :-
    gber_general_conditions_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(a_non_list_profile_is_a_wrong_profile) :-
    gber_general_conditions_input_problems(not_a_list, [wrong_type(profile)]).
test(a_bad_argument_follows_the_profile_problems) :-
    gber_notification_threshold([], -1, input_problems([wrong_type(project_aid_cents)]), []).
test(what_if_a_recovery_order_turns_the_compliant_case_against) :-
    gber_general_conditions_profile_for(compliant_sme_grant, Case),
    gber_general_conditions_what_if(Case, recovery_order_exclusion_applies, true, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(what_if_the_same_value_keeps_the_compliant_case_met) :-
    gber_general_conditions_profile_for(compliant_sme_grant, Case),
    gber_general_conditions_what_if(Case, recovery_order_exclusion_applies, false, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(what_if_the_verification_is_made_the_ad_hoc_case_is_met) :-
    gber_general_conditions_profile_for(ad_hoc_large_enterprise_unverified, Case),
    gber_general_conditions_what_if(Case, large_enterprise_verification_done, true, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).

test(the_compliant_grant_is_not_unmet, fail) :-
    gber_general_conditions_assess(compliant_sme_grant, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(a_same_day_application_is_never_met, fail) :-
    gber_general_conditions_assess(same_day_application, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(unverified_ad_hoc_aid_to_a_large_enterprise_is_never_met, fail) :-
    gber_general_conditions_assess(ad_hoc_large_enterprise_unverified, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(one_cent_over_the_figure_is_not_within, fail) :-
    subject_parts(threshold_one_cent_over, Profile, ProjectAidCents, _, _, _, _, _, _),
    gber_notification_threshold(Profile, ProjectAidCents, within_threshold, _).
test(one_cent_over_twice_the_figure_is_never_met, fail) :-
    gber_general_conditions_assess(doubled_research_one_cent_over_twice, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(another_category_is_never_fully_met, fail) :-
    gber_general_conditions_assess(other_category_row, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
test(de_minimis_one_cent_over_is_never_allowed, fail) :-
    subject_parts(de_minimis_one_cent_over, Profile, _, _, _, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints),
    gber_cumulation(Profile, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, cumulation_allowed, _).
test(another_form_is_never_transparent, fail) :-
    subject_parts(non_transparent_other_form, Profile, _, _, _, _, _, _, _),
    gber_transparency(Profile, transparent_aid, _).
test(an_undertaking_in_difficulty_without_exception_is_never_within, fail) :-
    subject_parts(difficulty_without_exception, Profile, _, _, _, _, _, _, _),
    gber_scope(Profile, within_scope, _).
test(the_order_itself_adds_no_provenance_term, fail) :-
    subject_parts(difficulty_unsure, Profile, _, _, _, _, _, _, _),
    gber_scope(Profile, needs_legal_review(_, [_, provenance(_, _)]), _).
test(a_large_enterprise_has_no_input_problem, fail) :-
    subject_parts(large_enterprise_scheme_aid, Profile, _, _, _, _, _, _, _),
    gber_general_conditions_input_problems(Profile, [_|_]).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status, every_subject_carries_the_citations_of_its_status, every_subject_answers_once, every_subject_has_a_five_item_checklist, every_subject_is_resolvable, the_compliant_grant_meets_the_tested_conditions, the_status_projects_the_joined_answer, the_met_status_is_in_the_vocabulary, the_joined_query_answers_directly, a_same_day_application_is_not_met, an_application_the_day_before_is_met, a_same_day_application_has_no_incentive_effect, an_application_the_day_before_has_an_incentive_effect, verified_ad_hoc_aid_to_a_large_enterprise_is_met, unverified_ad_hoc_aid_to_a_large_enterprise_is_not_met, the_figure_itself_is_within_the_threshold, one_cent_over_the_figure_exceeds_the_threshold, the_threshold_at_the_figure_is_met, the_threshold_one_cent_over_is_not_met, a_doubled_research_project_cites_point_iv, an_undoubled_research_project_over_the_figure_exceeds, an_undoubled_research_project_is_not_met, twice_the_figure_is_within_when_doubled, one_cent_over_twice_the_figure_is_exceeded, another_category_is_not_formalised, another_category_is_partly_untested, a_total_at_the_intensity_is_allowed, de_minimis_one_cent_over_is_not_allowed, de_minimis_at_the_intensity_is_met, de_minimis_one_cent_over_is_not_met, a_loan_meeting_its_condition_is_transparent, another_form_with_every_way_ruled_out_is_not_transparent, non_transparent_aid_is_not_met, the_base_profile_is_within_scope, an_undertaking_in_difficulty_without_exception_is_excluded, the_2020_2021_derogation_keeps_the_aid_within_scope, an_unsure_difficulty_goes_to_a_lawyer, an_outstanding_recovery_order_is_not_met, an_empty_profile_asks_for_the_first_scope_key, a_provenance_term_may_follow_the_pairs, not_an_enterprise_is_a_wrong_size_class, a_large_enterprise_is_a_size_class, every_query_reports_the_wrong_size_class, a_duplicate_key_is_named_once, an_unknown_key_is_named, a_non_list_profile_is_a_wrong_profile, a_bad_argument_follows_the_profile_problems, what_if_a_recovery_order_turns_the_compliant_case_against, what_if_the_same_value_keeps_the_compliant_case_met, what_if_the_verification_is_made_the_ad_hoc_case_is_met]).
cp_test_fail_names([the_compliant_grant_is_not_unmet, a_same_day_application_is_never_met, unverified_ad_hoc_aid_to_a_large_enterprise_is_never_met, one_cent_over_the_figure_is_not_within, one_cent_over_twice_the_figure_is_never_met, another_category_is_never_fully_met, de_minimis_one_cent_over_is_never_allowed, another_form_is_never_transparent, an_undertaking_in_difficulty_without_exception_is_never_within, the_order_itself_adds_no_provenance_term, a_large_enterprise_has_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
