% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, decide_gdpr_administrative_fine_maximum/2, gdpr_administrative_fine_maximum_status/2, gdpr_administrative_fine_maximum_checklist/2, gdpr_administrative_fine_maximum_decision_resolvable/1, gdpr_administrative_fine_maximum_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_subject/1, gdpr_administrative_fine_maximum_profile_for/2, gdpr_administrative_fine_maximum_assess/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_queries, [gdpr_administrative_fine_maximum_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).

expect(Subject, Verdict, Citations) :-
    findall(Result, gdpr_administrative_fine_maximum_assess(Subject, Result), Results),
    Results == [gdpr_administrative_fine_maximum_verdict(Verdict, Citations)].

test(lower_percentage_basis) :-
    expect(lower_percentage_basis, fine_maximum(lower_maximum_tier, percentage_of_turnover, 2000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)]).
test(lower_tie_is_the_fixed_amount) :-
    expect(lower_tie_at_fixed, fine_maximum(lower_maximum_tier, fixed_amount, 1000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)]).
test(lower_one_euro_above_the_tie_is_percentage) :-
    expect(lower_one_euro_above_tie, fine_maximum(lower_maximum_tier, percentage_of_turnover, 1000000002), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)]).
test(lower_one_euro_below_the_tie_is_fixed) :-
    expect(lower_one_euro_below_tie, fine_maximum(lower_maximum_tier, fixed_amount, 1000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)]).
test(higher_fixed_basis) :-
    expect(higher_fixed_basis, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a)]).
test(higher_tie_is_the_fixed_amount) :-
    expect(higher_tie_at_fixed, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a)]).
test(higher_one_euro_above_the_tie_is_percentage) :-
    expect(higher_one_euro_above_tie, fine_maximum(higher_maximum_tier, percentage_of_turnover, 2000000004), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a)]).
test(lower_non_undertaking) :-
    expect(lower_non_undertaking, fine_maximum(lower_maximum_tier, fixed_amount_for_non_undertaking, 1000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)]).
test(higher_non_undertaking_ignores_turnover) :-
    expect(higher_non_undertaking_ignores_turnover, fine_maximum(higher_maximum_tier, fixed_amount_for_non_undertaking, 2000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a)]).
test(certification_body_cites_both_points) :-
    expect(certification_body_article_42, fine_maximum(lower_maximum_tier, fixed_amount, 1000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_4_b)]).
test(monitoring_body) :-
    expect(monitoring_body_article_41_paragraph_4, fine_maximum(lower_maximum_tier, fixed_amount_for_non_undertaking, 1000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_c)]).
test(member_state_law) :-
    expect(member_state_law_chapter_ix, fine_maximum(higher_maximum_tier, fixed_amount_for_non_undertaking, 2000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_d)]).
test(order_non_compliance_cites_paragraph_six) :-
    expect(order_non_compliance, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6), cite(eu_reg_2016_679_art_83_5_e)]).
test(access_failure_does_not_cite_paragraph_six) :-
    expect(access_failure, fine_maximum(higher_maximum_tier, fixed_amount_for_non_undertaking, 2000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_e)]).
test(a_provision_named_twice_is_one_infringement) :-
    expect(provision_named_twice, fine_maximum(higher_maximum_tier, fixed_amount_for_non_undertaking, 2000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a)]).
test(combined_takes_the_gravest_tier) :-
    expect(combined_gravest_is_higher, fine_maximum(higher_maximum_tier, percentage_of_turnover, 4000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a), cite(eu_reg_2016_679_art_83_3)]).
test(combined_all_lower_stays_lower) :-
    expect(combined_all_lower, fine_maximum(lower_maximum_tier, percentage_of_turnover, 2000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_3)]).
test(separate_when_not_linked) :-
    expect(separate_not_linked, separate_fine_maxima([infringement_maximum(article_32, lower_maximum_tier, percentage_of_turnover, 2000000000), infringement_maximum(article_5, higher_maximum_tier, percentage_of_turnover, 4000000000)]), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_5_a)]).
test(separate_when_not_negligent) :-
    expect(separate_not_negligent, separate_fine_maxima([infringement_maximum(article_32, lower_maximum_tier, percentage_of_turnover, 2000000000), infringement_maximum(article_5, higher_maximum_tier, percentage_of_turnover, 4000000000)]), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_5_a)]).
test(a_false_key_settles_separate_without_the_other) :-
    expect(separate_one_unsure_one_false, separate_fine_maxima([infringement_maximum(article_32, lower_maximum_tier, percentage_of_turnover, 2000000000), infringement_maximum(article_5, higher_maximum_tier, percentage_of_turnover, 4000000000)]), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_5_a)]).
test(unsure_undertaking_refers) :-
    expect(unsure_undertaking, needs_legal_review(open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), [inputs_relied_on([infringer_is_undertaking - unsure])]), []).
test(unsure_first_art_83_3_key_refers) :-
    expect(unsure_first_art_83_3_key, needs_legal_review(open_textured(infringements_concern_same_or_linked_processing_operations, cite(eu_reg_2016_679_art_83_3)), [inputs_relied_on([infringer_is_undertaking - true, infringements_concern_same_or_linked_processing_operations - unsure, infringements_intentional_or_negligent - true])]), []).
test(unsure_second_art_83_3_key_refers) :-
    expect(unsure_second_art_83_3_key, needs_legal_review(open_textured(infringements_intentional_or_negligent, cite(eu_reg_2016_679_art_83_3)), [inputs_relied_on([infringer_is_undertaking - true, infringements_concern_same_or_linked_processing_operations - true, infringements_intentional_or_negligent - unsure])]), []).
test(unsure_undertaking_refers_even_in_separate_mode) :-
    expect(unsure_undertaking_in_separate_mode, needs_legal_review(open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), [inputs_relied_on([infringer_is_undertaking - unsure, infringements_concern_same_or_linked_processing_operations - false, infringements_intentional_or_negligent - true])]), []).
test(missing_turnover) :-
    expect(missing_turnover, indeterminate([total_worldwide_annual_turnover_in_euros]), []).
test(missing_art_83_3_keys_in_order) :-
    expect(missing_art_83_3_keys, indeterminate([infringements_concern_same_or_linked_processing_operations, infringements_intentional_or_negligent]), []).
test(missing_provisions_never_names_the_art_83_3_keys) :-
    expect(missing_provisions, indeterminate([infringed_provisions]), []).
test(missing_everything) :-
    expect(missing_everything, indeterminate([infringed_provisions, infringer_is_undertaking, total_worldwide_annual_turnover_in_euros]), []).
test(unlisted_provision_is_not_governed_here) :-
    expect(unlisted_provision, needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]), [inputs_relied_on([infringed_provisions - [article_24]])]), []).
test(unlisted_context_keeps_the_list_as_given) :-
    expect(unlisted_with_duplicates, needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]), [inputs_relied_on([infringed_provisions - [article_5, article_24, article_24]])]), []).
test(negative_turnover_is_a_problem) :-
    expect(input_negative_turnover, input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]), []).
test(unknown_key_is_a_problem) :-
    expect(input_unknown_key, input_problems([unknown_key(surprise_key)]), []).
test(duplicate_key_is_a_problem) :-
    expect(input_duplicate_key, input_problems([duplicate_key(infringer_is_undertaking)]), []).
test(an_unread_key_is_still_checked) :-
    expect(input_wrong_judgement_unread, input_problems([wrong_type(infringements_intentional_or_negligent)]), []).
test(a_good_profile_has_no_input_problem) :-
    gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, Profile),
    gdpr_administrative_fine_maximum_input_problems(Profile, []).
test(status_of_a_final_answer) :-
    gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, Profile),
    gdpr_administrative_fine_maximum_status(Profile, fine_maximum).
test(status_of_a_referral) :-
    gdpr_administrative_fine_maximum_profile_for(unsure_undertaking, Profile),
    gdpr_administrative_fine_maximum_status(Profile, needs_legal_review).
test(status_is_in_the_status_table) :-
    gdpr_administrative_fine_maximum_profile_for(separate_not_linked, Profile),
    gdpr_administrative_fine_maximum_status(Profile, Status),
    gdpr_administrative_fine_maximum_status_values(StatusValues),
    member(Status, StatusValues).
test(checklist_carries_a_citation_per_item) :-
    gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, Profile),
    findall(Items, gdpr_administrative_fine_maximum_checklist(Profile, Items), Answers),
    Answers == [[item(eu_reg_2016_679_art_83_4, met, cite(eu_reg_2016_679_art_83_4)), item(eu_reg_2016_679_art_83_4_a, met, cite(eu_reg_2016_679_art_83_4_a))]].
test(checklist_of_a_referral_is_not_empty) :-
    gdpr_administrative_fine_maximum_profile_for(unsure_undertaking, Profile),
    findall(Items, gdpr_administrative_fine_maximum_checklist(Profile, Items), Answers),
    Answers == [[item(overall, unknown([infringer_is_undertaking]), cite(eu_reg_2016_679_art_83_4))]].
test(decision_is_resolvable) :-
    gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, Profile),
    gdpr_administrative_fine_maximum_decision_resolvable(Profile).
test(what_if_a_lower_turnover_flips_the_basis) :-
    gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, Profile),
    findall(Verdict, gdpr_administrative_fine_maximum_what_if(Profile, total_worldwide_annual_turnover_in_euros, 500000000, Verdict), Verdicts),
    Verdicts == [fine_maximum(lower_maximum_tier, fixed_amount, 1000000000)].
test(what_if_not_an_undertaking_drops_the_percentage) :-
    gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, Profile),
    findall(Verdict, gdpr_administrative_fine_maximum_what_if(Profile, infringer_is_undertaking, false, Verdict), Verdicts),
    Verdicts == [fine_maximum(lower_maximum_tier, fixed_amount_for_non_undertaking, 1000000000)].
test(the_calculation_predicate_answers_directly) :-
    gdpr_administrative_fine_maximum_profile_for(higher_fixed_basis, Profile),
    findall(Verdict - Citations, administrative_fine_maximum(Profile, Verdict, Citations), Answers),
    Answers == [fine_maximum(higher_maximum_tier, fixed_amount, 2000000000) - [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a)]].
test(decide_wraps_the_verdict) :-
    gdpr_administrative_fine_maximum_profile_for(higher_fixed_basis, Profile),
    decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(fine_maximum(higher_maximum_tier, fixed_amount, 2000000000), _)).
test(every_subject_resolves_exactly_once) :-
    findall(Subject, gdpr_administrative_fine_maximum_subject(Subject), Subjects),
    Subjects = [_|_],
    findall(Count, (member(Subject, Subjects), findall(Result, gdpr_administrative_fine_maximum_assess(Subject, Result), Results), length(Results, Count)), Counts),
    sort(Counts, [1]).

test(the_tie_is_not_percentage, fail) :-
    gdpr_administrative_fine_maximum_assess(lower_tie_at_fixed, gdpr_administrative_fine_maximum_verdict(fine_maximum(_, percentage_of_turnover, _), _)).

cp_test_names([lower_percentage_basis, lower_tie_is_the_fixed_amount, lower_one_euro_above_the_tie_is_percentage, lower_one_euro_below_the_tie_is_fixed, higher_fixed_basis, higher_tie_is_the_fixed_amount, higher_one_euro_above_the_tie_is_percentage, lower_non_undertaking, higher_non_undertaking_ignores_turnover, certification_body_cites_both_points, monitoring_body, member_state_law, order_non_compliance_cites_paragraph_six, access_failure_does_not_cite_paragraph_six, a_provision_named_twice_is_one_infringement, combined_takes_the_gravest_tier, combined_all_lower_stays_lower, separate_when_not_linked, separate_when_not_negligent, a_false_key_settles_separate_without_the_other, unsure_undertaking_refers, unsure_first_art_83_3_key_refers, unsure_second_art_83_3_key_refers, unsure_undertaking_refers_even_in_separate_mode, missing_turnover, missing_art_83_3_keys_in_order, missing_provisions_never_names_the_art_83_3_keys, missing_everything, unlisted_provision_is_not_governed_here, unlisted_context_keeps_the_list_as_given, negative_turnover_is_a_problem, unknown_key_is_a_problem, duplicate_key_is_a_problem, an_unread_key_is_still_checked, a_good_profile_has_no_input_problem, status_of_a_final_answer, status_of_a_referral, status_is_in_the_status_table, checklist_carries_a_citation_per_item, checklist_of_a_referral_is_not_empty, decision_is_resolvable, what_if_a_lower_turnover_flips_the_basis, what_if_not_an_undertaking_drops_the_percentage, the_calculation_predicate_answers_directly, decide_wraps_the_verdict, every_subject_resolves_exactly_once]).
cp_test_fail_names([the_tie_is_not_percentage]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
