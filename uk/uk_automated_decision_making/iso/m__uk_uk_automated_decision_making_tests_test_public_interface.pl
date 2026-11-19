% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_automated_decision_making_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_automated_decision_making_uk_automated_decision_making, [decide_uk_automated_decision_making/2, uk_automated_decision_making_status/2, uk_automated_decision_making_checklist/2, uk_automated_decision_making_decision_resolvable/1, uk_automated_decision_making_status_values/1, uk_significant_automated_decision/3, uk_automated_decision_restriction/3, uk_automated_decision_safeguards/3, eu_automated_decision/3, compare_uk_eu_automated_decision/5]).
:- use_module(m__uk_uk_automated_decision_making_fixtures, [uk_automated_decision_making_subject/1, uk_automated_decision_making_profile_for/2, uk_automated_decision_making_assess/2]).
:- use_module(m__uk_uk_automated_decision_making_kernel, [uk_automated_decision_making_input_problems/2]).

significance_citations([cite(uk_gdpr_art_22a_1), cite(uk_gdpr_art_22a_1_a), cite(uk_gdpr_art_22a_1_b), cite(uk_gdpr_art_22a_1_b_i), cite(uk_gdpr_art_22a_1_b_ii), cite(uk_gdpr_art_22a_2)]).

restriction_citations([cite(uk_gdpr_art_22b_1), cite(uk_gdpr_art_22b_2), cite(uk_gdpr_art_22b_3), cite(uk_gdpr_art_22b_3_a), cite(uk_gdpr_art_22b_3_a_i), cite(uk_gdpr_art_22b_3_a_ii), cite(uk_gdpr_art_22b_3_b), cite(uk_gdpr_art_22b_4)]).

safeguards_required_citations([cite(uk_gdpr_art_22c_1), cite(uk_gdpr_art_22c_1_a), cite(uk_gdpr_art_22c_1_b), cite(uk_gdpr_art_22c_2), cite(uk_gdpr_art_22c_2_a), cite(uk_gdpr_art_22c_2_b), cite(uk_gdpr_art_22c_2_c), cite(uk_gdpr_art_22c_2_d)]).

safeguards_not_required_citations([cite(uk_gdpr_art_22a_1), cite(uk_gdpr_art_22a_1_a), cite(uk_gdpr_art_22a_1_b), cite(uk_gdpr_art_22a_1_b_i), cite(uk_gdpr_art_22a_1_b_ii), cite(uk_gdpr_art_22a_2), cite(uk_gdpr_art_22c_1), cite(uk_gdpr_art_22c_1_a), cite(uk_gdpr_art_22c_1_b)]).

european_citations([cite(eu_reg_2016_679_art_22_1), cite(eu_reg_2016_679_art_22_2), cite(eu_reg_2016_679_art_22_2_a), cite(eu_reg_2016_679_art_22_2_b), cite(eu_reg_2016_679_art_22_2_c), cite(eu_reg_2016_679_art_22_4)]).

expect_significance(Subject, Expected) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Result, uk_significant_automated_decision(Profile, Result, _), Results),
    Results == [Expected].

expect_restriction(Subject, Expected) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Result, uk_automated_decision_restriction(Profile, Result, _), Results),
    Results == [Expected].

expect_safeguards(Subject, Expected) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Result, uk_automated_decision_safeguards(Profile, Result, _), Results),
    Results == [Expected].

expect_european(Subject, Expected) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Result, eu_automated_decision(Profile, Result, _), Results),
    Results == [Expected].

expect_comparison(Subject, UkResult, EuResult, Difference, ChangedBy) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Uk - Eu - Answer - Changed, compare_uk_eu_automated_decision(Profile, Uk, Eu, Answer, Changed), Answers),
    Answers == [UkResult - EuResult - Difference - ChangedBy].

test(ordinary_decision_is_significant) :-
    expect_significance(ordinary_decision_permitted_with_safeguards_in_place, significant_decision_based_solely_on_automated_processing).
test(human_involved_decision_is_not_significant) :-
    expect_significance(human_involved_decision, not_a_significant_decision_based_solely_on_automated_processing).
test(decision_without_effect_is_not_significant) :-
    expect_significance(decision_without_legal_or_similar_effect, not_a_significant_decision_based_solely_on_automated_processing).
test(similarly_significant_effect_alone_is_significant) :-
    expect_significance(decision_with_similarly_significant_effect_only, significant_decision_based_solely_on_automated_processing).
test(significance_citations_are_the_article_22a_list) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_significant_automated_decision(Profile, _, Citations),
    significance_citations(Expected),
    Citations == Expected.
test(missing_effect_keys_name_the_legal_effect_key) :-
    uk_automated_decision_making_profile_for(partial_profile_missing_effect_keys, Profile),
    findall(Result - Citations, uk_significant_automated_decision(Profile, Result, Citations), Answers),
    Answers == [indeterminate([decision_produces_a_legal_effect_for_the_data_subject]) - []].
test(missing_effect_keys_leave_the_comparison_the_same) :-
    expect_comparison(partial_profile_missing_effect_keys, indeterminate([decision_produces_a_legal_effect_for_the_data_subject]), indeterminate([decision_produces_a_legal_effect_for_the_data_subject]), same, []).
test(supplied_legal_effect_settles_significance) :-
    expect_significance(partial_profile_with_legal_effect, significant_decision_based_solely_on_automated_processing).
test(supplied_legal_effect_settles_the_restriction) :-
    expect_restriction(partial_profile_with_legal_effect, decision_permitted).
test(unsure_human_involvement_is_referred) :-
    uk_automated_decision_making_profile_for(unsure_human_involvement_referred, Profile),
    findall(Result - Citations, uk_significant_automated_decision(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(meaningful_human_involvement_in_the_decision, cite(uk_gdpr_art_22a_1_a)), [inputs_relied_on([meaningful_human_involvement_in_the_decision - unsure, decision_produces_a_legal_effect_for_the_data_subject - true, decision_has_a_similarly_significant_effect_for_the_data_subject - false])]) - []].
test(unsure_human_involvement_without_effect_is_settled) :-
    expect_significance(unsure_human_involvement_without_effect, not_a_significant_decision_based_solely_on_automated_processing).
test(ordinary_decision_is_permitted) :-
    expect_restriction(ordinary_decision_permitted_with_safeguards_in_place, decision_permitted).
test(recognised_legitimate_interest_is_prohibited) :-
    expect_restriction(recognised_legitimate_interest_prohibited, decision_prohibited).
test(human_involved_decision_engages_no_restriction) :-
    expect_restriction(human_involved_decision, restrictions_not_engaged).
test(decision_without_effect_engages_no_restriction) :-
    expect_restriction(decision_without_legal_or_similar_effect, restrictions_not_engaged).
test(special_category_without_condition_is_prohibited) :-
    expect_restriction(special_category_without_condition_prohibited, decision_prohibited).
test(special_category_with_explicit_consent_is_permitted) :-
    expect_restriction(special_category_with_explicit_consent_permitted, decision_permitted).
test(special_category_with_contract_and_point_g_is_permitted) :-
    expect_restriction(special_category_contract_and_point_g_permitted, decision_permitted).
test(special_category_with_contract_without_point_g_is_prohibited) :-
    expect_restriction(special_category_contract_without_point_g_prohibited, decision_prohibited).
test(no_european_exception_is_still_permitted_in_the_uk) :-
    expect_restriction(decision_without_european_exception, decision_permitted).
test(permitted_and_prohibited_share_the_article_22b_citations) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, PermittedProfile),
    uk_automated_decision_restriction(PermittedProfile, decision_permitted, PermittedCitations),
    uk_automated_decision_making_profile_for(recognised_legitimate_interest_prohibited, ProhibitedProfile),
    uk_automated_decision_restriction(ProhibitedProfile, decision_prohibited, ProhibitedCitations),
    restriction_citations(Expected),
    PermittedCitations == Expected,
    ProhibitedCitations == Expected.
test(not_engaged_cites_article_22a) :-
    uk_automated_decision_making_profile_for(human_involved_decision, Profile),
    uk_automated_decision_restriction(Profile, restrictions_not_engaged, Citations),
    significance_citations(Expected),
    Citations == Expected.
test(ordinary_decision_has_safeguards_in_place) :-
    expect_safeguards(ordinary_decision_permitted_with_safeguards_in_place, required_safeguards_in_place).
test(missing_contesting_safeguard_is_not_in_place) :-
    expect_safeguards(ordinary_decision_missing_contesting_safeguard, required_safeguards_not_in_place).
test(decision_without_personal_data_needs_no_safeguards) :-
    expect_safeguards(ordinary_decision_without_personal_data, safeguards_not_required).
test(human_involved_decision_needs_no_safeguards) :-
    expect_safeguards(human_involved_decision, safeguards_not_required).
test(prohibited_decision_still_needs_safeguards) :-
    expect_safeguards(recognised_legitimate_interest_prohibited, required_safeguards_in_place).
test(safeguard_citations_are_fixed_per_result) :-
    uk_automated_decision_making_profile_for(ordinary_decision_missing_contesting_safeguard, RequiredProfile),
    uk_automated_decision_safeguards(RequiredProfile, _, RequiredCitations),
    safeguards_required_citations(ExpectedRequired),
    RequiredCitations == ExpectedRequired,
    uk_automated_decision_making_profile_for(ordinary_decision_without_personal_data, NotRequiredProfile),
    uk_automated_decision_safeguards(NotRequiredProfile, _, NotRequiredCitations),
    safeguards_not_required_citations(ExpectedNotRequired),
    NotRequiredCitations == ExpectedNotRequired.
test(european_contract_exception_permits) :-
    expect_european(ordinary_decision_permitted_with_safeguards_in_place, decision_permitted).
test(european_without_exception_prohibits) :-
    expect_european(decision_without_european_exception, decision_prohibited).
test(european_human_involved_is_not_engaged) :-
    uk_automated_decision_making_profile_for(human_involved_decision, Profile),
    findall(Result - Citations, eu_automated_decision(Profile, Result, Citations), Answers),
    Answers == [restrictions_not_engaged - [cite(eu_reg_2016_679_art_22_1)]].
test(european_special_category_without_paragraph_4_prohibits) :-
    expect_european(special_category_with_explicit_consent_permitted, decision_prohibited).
test(european_special_category_with_paragraph_4_permits) :-
    expect_european(special_category_contract_and_point_g_permitted, decision_permitted).
test(european_citations_are_the_article_22_list) :-
    uk_automated_decision_making_profile_for(decision_without_european_exception, Profile),
    eu_automated_decision(Profile, _, Citations),
    european_citations(Expected),
    Citations == Expected.
test(ordinary_decision_is_the_same_in_both_laws) :-
    expect_comparison(ordinary_decision_permitted_with_safeguards_in_place, decision_permitted, decision_permitted, same, []).
test(human_involved_decision_is_the_same_in_both_laws) :-
    expect_comparison(human_involved_decision, restrictions_not_engaged, restrictions_not_engaged, same, []).
test(recognised_legitimate_interest_differs) :-
    restriction_citations(Expected),
    expect_comparison(recognised_legitimate_interest_prohibited, decision_prohibited, decision_permitted, differs, Expected).
test(uk_permits_what_eu_prohibits_without_exception) :-
    restriction_citations(Expected),
    expect_comparison(decision_without_european_exception, decision_permitted, decision_prohibited, differs, Expected).
test(special_category_without_condition_is_the_same) :-
    expect_comparison(special_category_without_condition_prohibited, decision_prohibited, decision_prohibited, same, []).
test(special_category_explicit_consent_differs) :-
    restriction_citations(Expected),
    expect_comparison(special_category_with_explicit_consent_permitted, decision_permitted, decision_prohibited, differs, Expected).
test(special_category_contract_and_point_g_is_the_same) :-
    expect_comparison(special_category_contract_and_point_g_permitted, decision_permitted, decision_permitted, same, []).
test(special_category_without_uk_point_g_differs) :-
    restriction_citations(Expected),
    expect_comparison(special_category_contract_without_point_g_prohibited, decision_prohibited, decision_permitted, differs, Expected).
test(well_formed_fixture_has_no_input_problem) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    findall(Problems, uk_automated_decision_making_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(badly_formed_profile_lists_its_problems) :-
    uk_automated_decision_making_profile_for(badly_formed_profile, Profile),
    findall(Problems, uk_automated_decision_making_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(meaningful_human_involvement_in_the_decision), unknown_key(colour)]].
test(duplicated_key_is_one_problem) :-
    uk_automated_decision_making_profile_for(duplicated_key_profile, Profile),
    uk_automated_decision_making_input_problems(Profile, Problems),
    Problems == [duplicate_key(meaningful_human_involvement_in_the_decision)].
test(badly_formed_profile_answers_input_problems_everywhere) :-
    uk_automated_decision_making_profile_for(badly_formed_profile, Profile),
    Expected = input_problems([wrong_type(meaningful_human_involvement_in_the_decision), unknown_key(colour)]),
    uk_significant_automated_decision(Profile, SignificanceResult, SignificanceCitations),
    SignificanceResult == Expected,
    SignificanceCitations == [],
    uk_automated_decision_restriction(Profile, RestrictionResult, RestrictionCitations),
    RestrictionResult == Expected,
    RestrictionCitations == [],
    uk_automated_decision_safeguards(Profile, SafeguardsResult, SafeguardsCitations),
    SafeguardsResult == Expected,
    SafeguardsCitations == [],
    eu_automated_decision(Profile, EuropeanResult, EuropeanCitations),
    EuropeanResult == Expected,
    EuropeanCitations == [],
    expect_comparison(badly_formed_profile, Expected, Expected, Expected, []).
test(a_list_of_non_attributes_is_not_a_profile) :-
    uk_automated_decision_making_input_problems([colour], Problems),
    Problems == [wrong_type(profile)].
test(facade_verdict_is_the_restriction_answer) :-
    uk_automated_decision_making_assess(ordinary_decision_permitted_with_safeguards_in_place, uk_automated_decision_making_verdict(Status, Citations)),
    Status == decision_permitted,
    restriction_citations(Expected),
    Citations == Expected.
test(facade_status_of_the_near_miss_is_prohibited) :-
    uk_automated_decision_making_profile_for(recognised_legitimate_interest_prohibited, Profile),
    findall(Status, uk_automated_decision_making_status(Profile, Status), Statuses),
    Statuses == [decision_prohibited].
test(facade_verdict_resolves_through_decide) :-
    uk_automated_decision_making_profile_for(human_involved_decision, Profile),
    decide_uk_automated_decision_making(Profile, uk_automated_decision_making_verdict(restrictions_not_engaged, _)).
test(final_fixture_statuses_are_in_the_vocabulary) :-
    uk_automated_decision_making_status_values(StatusValues),
    StatusValues == [restrictions_not_engaged, decision_permitted, decision_prohibited],
    findall(Subject, (uk_automated_decision_making_subject(Subject), uk_automated_decision_making_assess(Subject, uk_automated_decision_making_verdict(Status, _)), member(Status, StatusValues)), Subjects),
    Subjects = [_, _, _, _, _, _, _, _, _, _, _, _|_].
test(checklist_carries_a_citation_per_item) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_making_decision_resolvable(Profile),
    uk_automated_decision_making_checklist(Profile, Items),
    Items = [_|_],
    member(item(article_22a_significant_decision, significant_decision_based_solely_on_automated_processing, cite(uk_gdpr_art_22a_1)), Items),
    member(item(article_22b_restriction, decision_permitted, cite(uk_gdpr_art_22b_1)), Items),
    member(item(article_22c_safeguards, required_safeguards_in_place, cite(uk_gdpr_art_22c_1)), Items),
    member(item(eu_article_22_restriction, decision_permitted, cite(eu_reg_2016_679_art_22_1)), Items).
test(checklist_of_the_near_miss_shows_the_missing_safeguard) :-
    uk_automated_decision_making_profile_for(ordinary_decision_missing_contesting_safeguard, Profile),
    uk_automated_decision_making_checklist(Profile, Items),
    member(item(article_22c_safeguards, required_safeguards_not_in_place, cite(uk_gdpr_art_22c_1)), Items).
test(every_query_has_exactly_one_answer_for_every_subject) :-
    findall(Subject, uk_automated_decision_making_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(one_answer_each, Subjects).

test(human_involved_decision_is_not_significant_solely_automated, fail) :-
    uk_automated_decision_making_profile_for(human_involved_decision, Profile),
    uk_significant_automated_decision(Profile, significant_decision_based_solely_on_automated_processing, _).
test(ordinary_decision_is_not_prohibited, fail) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_restriction(Profile, decision_prohibited, _).
test(missing_contesting_safeguard_is_not_in_place_as_complete, fail) :-
    uk_automated_decision_making_profile_for(ordinary_decision_missing_contesting_safeguard, Profile),
    uk_automated_decision_safeguards(Profile, required_safeguards_in_place, _).
test(european_without_exception_is_not_permitted, fail) :-
    uk_automated_decision_making_profile_for(decision_without_european_exception, Profile),
    eu_automated_decision(Profile, decision_permitted, _).
test(same_case_does_not_differ, fail) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    compare_uk_eu_automated_decision(Profile, _, _, differs, _).

one_answer_each(Subject) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Problems, uk_automated_decision_making_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1),
    findall(Result - Citations, uk_significant_automated_decision(Profile, Result, Citations), SignificanceAnswers),
    length(SignificanceAnswers, 1),
    findall(Result - Citations, uk_automated_decision_restriction(Profile, Result, Citations), RestrictionAnswers),
    length(RestrictionAnswers, 1),
    findall(Result - Citations, uk_automated_decision_safeguards(Profile, Result, Citations), SafeguardsAnswers),
    length(SafeguardsAnswers, 1),
    findall(Result - Citations, eu_automated_decision(Profile, Result, Citations), EuropeanAnswers),
    length(EuropeanAnswers, 1),
    findall(Uk - Eu - Difference - ChangedBy, compare_uk_eu_automated_decision(Profile, Uk, Eu, Difference, ChangedBy), ComparisonAnswers),
    length(ComparisonAnswers, 1),
    uk_automated_decision_making_checklist(Profile, [_|_]).

cp_test_names([ordinary_decision_is_significant, human_involved_decision_is_not_significant, decision_without_effect_is_not_significant, similarly_significant_effect_alone_is_significant, significance_citations_are_the_article_22a_list, missing_effect_keys_name_the_legal_effect_key, missing_effect_keys_leave_the_comparison_the_same, supplied_legal_effect_settles_significance, supplied_legal_effect_settles_the_restriction, unsure_human_involvement_is_referred, unsure_human_involvement_without_effect_is_settled, ordinary_decision_is_permitted, recognised_legitimate_interest_is_prohibited, human_involved_decision_engages_no_restriction, decision_without_effect_engages_no_restriction, special_category_without_condition_is_prohibited, special_category_with_explicit_consent_is_permitted, special_category_with_contract_and_point_g_is_permitted, special_category_with_contract_without_point_g_is_prohibited, no_european_exception_is_still_permitted_in_the_uk, permitted_and_prohibited_share_the_article_22b_citations, not_engaged_cites_article_22a, ordinary_decision_has_safeguards_in_place, missing_contesting_safeguard_is_not_in_place, decision_without_personal_data_needs_no_safeguards, human_involved_decision_needs_no_safeguards, prohibited_decision_still_needs_safeguards, safeguard_citations_are_fixed_per_result, european_contract_exception_permits, european_without_exception_prohibits, european_human_involved_is_not_engaged, european_special_category_without_paragraph_4_prohibits, european_special_category_with_paragraph_4_permits, european_citations_are_the_article_22_list, ordinary_decision_is_the_same_in_both_laws, human_involved_decision_is_the_same_in_both_laws, recognised_legitimate_interest_differs, uk_permits_what_eu_prohibits_without_exception, special_category_without_condition_is_the_same, special_category_explicit_consent_differs, special_category_contract_and_point_g_is_the_same, special_category_without_uk_point_g_differs, well_formed_fixture_has_no_input_problem, badly_formed_profile_lists_its_problems, duplicated_key_is_one_problem, badly_formed_profile_answers_input_problems_everywhere, a_list_of_non_attributes_is_not_a_profile, facade_verdict_is_the_restriction_answer, facade_status_of_the_near_miss_is_prohibited, facade_verdict_resolves_through_decide, final_fixture_statuses_are_in_the_vocabulary, checklist_carries_a_citation_per_item, checklist_of_the_near_miss_shows_the_missing_safeguard, every_query_has_exactly_one_answer_for_every_subject]).
cp_test_fail_names([human_involved_decision_is_not_significant_solely_automated, ordinary_decision_is_not_prohibited, missing_contesting_safeguard_is_not_in_place_as_complete, european_without_exception_is_not_permitted, same_case_does_not_differ]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
