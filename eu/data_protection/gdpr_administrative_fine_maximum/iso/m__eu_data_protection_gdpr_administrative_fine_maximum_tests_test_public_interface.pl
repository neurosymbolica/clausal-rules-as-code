% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, decide_gdpr_administrative_fine_maximum/2, gdpr_administrative_fine_maximum_status/2, gdpr_administrative_fine_maximum_checklist/2, gdpr_administrative_fine_maximum_decision_resolvable/1, gdpr_administrative_fine_maximum_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_subject/1, gdpr_administrative_fine_maximum_profile_for/2, gdpr_administrative_fine_maximum_assess/2]).

expected_status(lower_tier_turnover_at_tie, fine_maximum_determined).
expected_status(lower_tier_turnover_just_above_tie, fine_maximum_determined).
expected_status(higher_tier_turnover_at_tie, fine_maximum_determined).
expected_status(higher_tier_turnover_just_above_tie, fine_maximum_determined).
expected_status(non_undertaking_certification_body, fine_maximum_determined).
expected_status(undertaking_with_zero_turnover, fine_maximum_determined).
expected_status(supervisory_order_non_undertaking, fine_maximum_determined).
expected_status(combined_linked_and_intentional, fine_maximum_determined).
expected_status(separate_not_intentional_or_negligent, separate_fine_maxima_determined).
expected_status(linked_operations_unsure, referred_for_legal_review).
expected_status(missing_turnover_unsure_undertaking, required_input_missing).
expected_status(unsure_undertaking_with_turnover, referred_for_legal_review).
expected_status(unlisted_provision, referred_for_legal_review).
expected_status(listed_neighbour_provision, fine_maximum_determined).
expected_status(negative_turnover_rejected, input_rejected).
expected_status(zero_turnover_accepted, fine_maximum_determined).

subject_answer(Subject, Verdict, Citations) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    administrative_fine_maximum(Profile, Verdict, Citations).

subject_answers_once(Subject) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    findall(Verdict - Citations, administrative_fine_maximum(Profile, Verdict, Citations), Answers),
    length(Answers, 1).

subject_checklist_is_non_empty(Subject) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    gdpr_administrative_fine_maximum_checklist(Profile, [_|_]).

test(every_subject_resolves_to_its_expected_status_exactly_once) :-
    findall(Subject - Status, (gdpr_administrative_fine_maximum_subject(Subject), gdpr_administrative_fine_maximum_assess(Subject, gdpr_administrative_fine_maximum_verdict(Status, _))), Resolved),
    findall(Subject - Status, expected_status(Subject, Status), Expected),
    clausal_msort(Resolved, SortedResolved),
    clausal_msort(Expected, SortedExpected),
    SortedResolved == SortedExpected.
test(every_subject_answers_the_contract_exactly_once) :-
    findall(Subject, gdpr_administrative_fine_maximum_subject(Subject), Subjects),
    maplist(subject_answers_once, Subjects).
test(every_status_is_in_the_vocabulary) :-
    gdpr_administrative_fine_maximum_status_values(StatusValues),
    findall(Status, expected_status(_, Status), Statuses),
    sort(Statuses, DistinctStatuses),
    sort(StatusValues, DistinctStatusValues),
    DistinctStatuses == DistinctStatusValues.
test(every_subject_has_a_non_empty_checklist_and_is_resolvable) :-
    findall(Subject, gdpr_administrative_fine_maximum_subject(Subject), Subjects),
    maplist(subject_checklist_is_non_empty, Subjects),
    gdpr_administrative_fine_maximum_profile_for(lower_tier_turnover_at_tie, Profile),
    gdpr_administrative_fine_maximum_decision_resolvable(Profile).
test(checklist_rows_of_a_final_answer_carry_a_citation) :-
    gdpr_administrative_fine_maximum_profile_for(separate_not_intentional_or_negligent, Profile),
    gdpr_administrative_fine_maximum_checklist(Profile, [item(overall, Status, _)|ItemRows]),
    Status == separate_fine_maxima_determined,
    ItemRows = [item(_, met, cite(FirstCitationKey)), item(_, met, cite(SecondCitationKey))],
    FirstCitationKey == eu_reg_2016_679_art_83_4,
    SecondCitationKey == eu_reg_2016_679_art_83_5.
test(lower_tier_at_tie_keeps_the_fixed_amount) :-
    subject_answer(lower_tier_turnover_at_tie, fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == lower_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 1000000000,
    Citations == [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)].
test(lower_tier_just_above_tie_takes_the_percentage) :-
    subject_answer(lower_tier_turnover_just_above_tie, fine_maximum(MaximumTier, Basis, CapInEuroCents), _),
    MaximumTier == lower_maximum_tier,
    Basis == percentage_of_turnover,
    CapInEuroCents =:= 1000000002.
test(higher_tier_at_tie_keeps_the_fixed_amount) :-
    subject_answer(higher_tier_turnover_at_tie, fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_b)].
test(higher_tier_just_above_tie_takes_the_percentage) :-
    subject_answer(higher_tier_turnover_just_above_tie, fine_maximum(MaximumTier, Basis, CapInEuroCents), _),
    MaximumTier == higher_maximum_tier,
    Basis == percentage_of_turnover,
    CapInEuroCents =:= 2000000004.
test(non_undertaking_gets_the_fixed_amount_alone) :-
    subject_answer(non_undertaking_certification_body, fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == lower_maximum_tier,
    Basis == fixed_amount_for_non_undertaking,
    CapInEuroCents =:= 1000000000,
    Citations == [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_4_b)].
test(undertaking_with_zero_turnover_gets_fixed_amount) :-
    subject_answer(undertaking_with_zero_turnover, fine_maximum(MaximumTier, Basis, CapInEuroCents), _),
    MaximumTier == lower_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 1000000000.
test(supervisory_order_cites_article_83_6_after_83_5) :-
    subject_answer(supervisory_order_non_undertaking, fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount_for_non_undertaking,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6), cite(eu_reg_2016_679_art_83_5_e)].
test(combined_takes_the_gravest_tier_and_cites_article_83_3_last) :-
    subject_answer(combined_linked_and_intentional, fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a), cite(eu_reg_2016_679_art_83_3)].
test(separate_gives_each_maximum_never_summed) :-
    subject_answer(separate_not_intentional_or_negligent, separate_fine_maxima([infringement_maximum(FirstProvision, FirstTier, FirstBasis, FirstCapInEuroCents), infringement_maximum(SecondProvision, SecondTier, SecondBasis, SecondCapInEuroCents)]), Citations),
    FirstProvision == article_33,
    FirstTier == lower_maximum_tier,
    FirstBasis == fixed_amount,
    FirstCapInEuroCents =:= 1000000000,
    SecondProvision == article_6,
    SecondTier == higher_maximum_tier,
    SecondBasis == fixed_amount,
    SecondCapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_5_a)].
test(unsure_linked_operations_refers_with_three_pairs) :-
    subject_answer(linked_operations_unsure, Verdict, Citations),
    Verdict == needs_legal_review(open_textured(infringements_concern_same_or_linked_processing_operations, cite(eu_reg_2016_679_art_83_3)), [inputs_relied_on([infringer_is_undertaking - true, infringements_concern_same_or_linked_processing_operations - unsure, infringements_intentional_or_negligent - true])]),
    Citations == [].
test(unsure_undertaking_without_turnover_names_the_turnover) :-
    subject_answer(missing_turnover_unsure_undertaking, Verdict, Citations),
    Verdict == indeterminate([total_worldwide_annual_turnover_in_euros]),
    Citations == [].
test(unsure_undertaking_with_turnover_refers) :-
    subject_answer(unsure_undertaking_with_turnover, Verdict, Citations),
    Verdict == needs_legal_review(open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), [inputs_relied_on([infringer_is_undertaking - unsure])]),
    Citations == [].
test(empty_profile_names_the_three_needed_keys) :-
    administrative_fine_maximum([], Verdict, Citations),
    Verdict == indeterminate([infringed_provisions, infringer_is_undertaking, total_worldwide_annual_turnover_in_euros]),
    Citations == [].
test(unlisted_provision_is_not_governed_here) :-
    subject_answer(unlisted_provision, Verdict, Citations),
    Verdict == needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]), [inputs_relied_on([infringed_provisions - [article_24]])]),
    Citations == [].
test(listed_neighbour_provision_gets_a_maximum) :-
    subject_answer(listed_neighbour_provision, fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == lower_maximum_tier,
    Basis == fixed_amount_for_non_undertaking,
    CapInEuroCents =:= 1000000000,
    Citations == [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)].
test(negative_turnover_is_rejected) :-
    subject_answer(negative_turnover_rejected, Verdict, Citations),
    Verdict == input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]),
    Citations == [].
test(negative_turnover_problems_from_the_input_check) :-
    gdpr_administrative_fine_maximum_profile_for(negative_turnover_rejected, Profile),
    gdpr_administrative_fine_maximum_input_problems(Profile, Problems),
    Problems == [wrong_type(total_worldwide_annual_turnover_in_euros)].
test(zero_turnover_is_accepted) :-
    gdpr_administrative_fine_maximum_profile_for(zero_turnover_accepted, Profile),
    gdpr_administrative_fine_maximum_input_problems(Profile, Problems),
    Problems == [],
    administrative_fine_maximum(Profile, fine_maximum(MaximumTier, Basis, CapInEuroCents), _),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 2000000000.
test(a_non_list_profile_is_rejected_through_the_facade) :-
    decide_gdpr_administrative_fine_maximum(profile_text, Verdict),
    Verdict == gdpr_administrative_fine_maximum_verdict(input_rejected, []).

test(lower_tier_at_tie_is_not_percentage, fail) :-
    subject_answer(lower_tier_turnover_at_tie, fine_maximum(_, percentage_of_turnover, _), _).
test(lower_tier_just_above_tie_is_not_fixed, fail) :-
    subject_answer(lower_tier_turnover_just_above_tie, fine_maximum(_, fixed_amount, _), _).
test(higher_tier_just_above_tie_is_not_fixed, fail) :-
    subject_answer(higher_tier_turnover_just_above_tie, fine_maximum(_, fixed_amount, _), _).
test(undertaking_is_not_treated_as_non_undertaking, fail) :-
    subject_answer(undertaking_with_zero_turnover, fine_maximum(_, fixed_amount_for_non_undertaking, _), _).
test(combined_is_not_separate, fail) :-
    subject_answer(combined_linked_and_intentional, separate_fine_maxima(_), _).
test(separate_is_not_a_single_fine_maximum, fail) :-
    subject_answer(separate_not_intentional_or_negligent, fine_maximum(_, _, _), _).
test(unsure_linked_operations_gives_no_maximum, fail) :-
    subject_answer(linked_operations_unsure, fine_maximum(_, _, _), _).
test(unsure_undertaking_with_turnover_is_not_missing, fail) :-
    gdpr_administrative_fine_maximum_assess(unsure_undertaking_with_turnover, gdpr_administrative_fine_maximum_verdict(required_input_missing, _)).
test(listed_neighbour_provision_is_not_referred, fail) :-
    subject_answer(listed_neighbour_provision, needs_legal_review(_, _), _).
test(zero_turnover_is_not_rejected, fail) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 0)], input_rejected).

cp_test_names([every_subject_resolves_to_its_expected_status_exactly_once, every_subject_answers_the_contract_exactly_once, every_status_is_in_the_vocabulary, every_subject_has_a_non_empty_checklist_and_is_resolvable, checklist_rows_of_a_final_answer_carry_a_citation, lower_tier_at_tie_keeps_the_fixed_amount, lower_tier_just_above_tie_takes_the_percentage, higher_tier_at_tie_keeps_the_fixed_amount, higher_tier_just_above_tie_takes_the_percentage, non_undertaking_gets_the_fixed_amount_alone, undertaking_with_zero_turnover_gets_fixed_amount, supervisory_order_cites_article_83_6_after_83_5, combined_takes_the_gravest_tier_and_cites_article_83_3_last, separate_gives_each_maximum_never_summed, unsure_linked_operations_refers_with_three_pairs, unsure_undertaking_without_turnover_names_the_turnover, unsure_undertaking_with_turnover_refers, empty_profile_names_the_three_needed_keys, unlisted_provision_is_not_governed_here, listed_neighbour_provision_gets_a_maximum, negative_turnover_is_rejected, negative_turnover_problems_from_the_input_check, zero_turnover_is_accepted, a_non_list_profile_is_rejected_through_the_facade]).
cp_test_fail_names([lower_tier_at_tie_is_not_percentage, lower_tier_just_above_tie_is_not_fixed, higher_tier_just_above_tie_is_not_fixed, undertaking_is_not_treated_as_non_undertaking, combined_is_not_separate, separate_is_not_a_single_fine_maximum, unsure_linked_operations_gives_no_maximum, unsure_undertaking_with_turnover_is_not_missing, listed_neighbour_provision_is_not_referred, zero_turnover_is_not_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
