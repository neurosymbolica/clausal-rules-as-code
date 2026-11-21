% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_cra_administrative_fines_cra_administrative_fines, [administrative_fine_maximum/4, decide_cra_administrative_fines/2, cra_administrative_fines_status/2, cra_administrative_fines_checklist/2, cra_administrative_fines_decision_resolvable/1, cra_administrative_fines_status_values/1]).
:- use_module(m__eu_cra_administrative_fines_fixtures, [cra_administrative_fines_subject/1, cra_administrative_fines_profile_for/2, cra_administrative_fines_assess/2]).

expected_answer(day_before_application_highest_tier, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
expected_answer(application_day_highest_tier, fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, 1500000000), [cite(eu_reg_2024_2847_art_64_2)]).
expected_answer(earlier_obligation_date_middle_tier, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
expected_answer(application_day_middle_tier, fine_maximum(middle_maximum_tier, fixed_amount_for_non_undertaking, 1000000000), [cite(eu_reg_2024_2847_art_64_3)]).
expected_answer(provision_absent, indeterminate([infringed_provision]), []).
expected_answer(unlisted_provision, not_listed_in_article_64, [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)]).
expected_answer(listed_provision_middle_tier, fine_maximum(middle_maximum_tier, fixed_amount_for_non_undertaking, 1000000000), [cite(eu_reg_2024_2847_art_64_3)]).
expected_answer(steward_middle_tier, fine_excluded(open_source_software_steward), [cite(eu_reg_2024_2847_art_64_10_b)]).
expected_answer(non_steward_middle_tier, fine_maximum(middle_maximum_tier, fixed_amount_for_non_undertaking, 1000000000), [cite(eu_reg_2024_2847_art_64_3)]).
expected_answer(steward_lowest_tier, fine_excluded(open_source_software_steward), [cite(eu_reg_2024_2847_art_64_10_b)]).
expected_answer(non_steward_lowest_tier, fine_maximum(lowest_maximum_tier, fixed_amount_for_non_undertaking, 500000000), [cite(eu_reg_2024_2847_art_64_4)]).
expected_answer(steward_highest_tier_not_read, fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, 1500000000), [cite(eu_reg_2024_2847_art_64_2)]).
expected_answer(steward_absent_middle_tier, indeterminate([offender_is_open_source_software_steward]), []).
expected_answer(steward_absent_highest_tier, fine_maximum(highest_maximum_tier, fixed_amount, 1500000000), [cite(eu_reg_2024_2847_art_64_2)]).
expected_answer(undertaking_absent_middle_tier, indeterminate([offender_is_undertaking]), []).
expected_answer(turnover_absent_undertaking, indeterminate([total_worldwide_annual_turnover_in_euros]), []).
expected_answer(turnover_absent_unsure_undertaking, indeterminate([total_worldwide_annual_turnover_in_euros]), []).
expected_answer(turnover_absent_non_undertaking, fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, 1500000000), [cite(eu_reg_2024_2847_art_64_2)]).
expected_answer(unsure_steward_referral, needs_legal_review(open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)), [inputs_relied_on([offender_is_open_source_software_steward - unsure, offender_is_undertaking - false])]), []).
expected_answer(unsure_steward_and_undertaking_referral, needs_legal_review(open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)), [inputs_relied_on([offender_is_open_source_software_steward - unsure, offender_is_undertaking - unsure])]), []).
expected_answer(unsure_undertaking_highest_tier, needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_2)), [inputs_relied_on([offender_is_undertaking - unsure])]), []).
expected_answer(unsure_undertaking_middle_tier, needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_3)), [inputs_relied_on([offender_is_open_source_software_steward - false, offender_is_undertaking - unsure])]), []).
expected_answer(unsure_undertaking_lowest_tier, needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_4)), [inputs_relied_on([offender_is_open_source_software_steward - false, offender_is_undertaking - unsure])]), []).
expected_answer(highest_tier_one_euro_below_tie, fine_maximum(highest_maximum_tier, fixed_amount, 1500000000), [cite(eu_reg_2024_2847_art_64_2)]).
expected_answer(highest_tier_tie, fine_maximum(highest_maximum_tier, fixed_amount, 1500000000), [cite(eu_reg_2024_2847_art_64_2)]).
expected_answer(highest_tier_one_euro_above_tie, fine_maximum(highest_maximum_tier, percentage_of_turnover, 1500000002), [cite(eu_reg_2024_2847_art_64_2)]).
expected_answer(highest_tier_two_euros_above_tie, fine_maximum(highest_maximum_tier, percentage_of_turnover, 1500000005), [cite(eu_reg_2024_2847_art_64_2)]).
expected_answer(middle_tier_tie, fine_maximum(middle_maximum_tier, fixed_amount, 1000000000), [cite(eu_reg_2024_2847_art_64_3)]).
expected_answer(middle_tier_one_euro_above_tie, fine_maximum(middle_maximum_tier, percentage_of_turnover, 1000000002), [cite(eu_reg_2024_2847_art_64_3)]).
expected_answer(lowest_tier_tie, fine_maximum(lowest_maximum_tier, fixed_amount, 500000000), [cite(eu_reg_2024_2847_art_64_4)]).
expected_answer(lowest_tier_one_euro_above_tie, fine_maximum(lowest_maximum_tier, percentage_of_turnover, 500000001), [cite(eu_reg_2024_2847_art_64_4)]).
expected_answer(leap_day_2028, not_listed_in_article_64, [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)]).
expected_answer(non_leap_day_2027, input_problems([wrong_type(infringement_date)]), []).
expected_answer(float_turnover, input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]), []).
expected_answer(negative_turnover, input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]), []).
expected_answer(duplicate_undertaking_key, input_problems([duplicate_key(offender_is_undertaking)]), []).
expected_answer(unknown_profile_key, input_problems([unknown_key(colour)]), []).
expected_answer(provision_outside_closed_list, input_problems([wrong_type(infringed_provision)]), []).
expected_answer(not_a_profile_nor_a_date, input_problems([wrong_type(profile), wrong_type(infringement_date)]), []).

answer_matches(Subject) :-
    expected_answer(Subject, ExpectedVerdict, ExpectedCitations),
    findall(Verdict - Citations, cra_administrative_fines_assess(Subject, cra_administrative_fines_verdict(Verdict, Citations)), Answers),
    Answers = [ActualVerdict - ActualCitations],
    verdict_matches(ExpectedVerdict, ActualVerdict),
    clausal_msort(ExpectedCitations, SortedExpectedCitations),
    clausal_msort(ActualCitations, SortedActualCitations),
    SortedExpectedCitations == SortedActualCitations.

verdict_matches(fine_maximum(ExpectedTier, ExpectedBasis, ExpectedCapInEuroCents), fine_maximum(ActualTier, ActualBasis, ActualCapInEuroCents)) :-
    ExpectedTier == ActualTier,
    ExpectedBasis == ActualBasis,
    integer(ActualCapInEuroCents),
    ExpectedCapInEuroCents =:= ActualCapInEuroCents.
verdict_matches(ExpectedVerdict, ActualVerdict) :-
    functor(ExpectedVerdict, ExpectedName, ExpectedArity),
    dif(ExpectedName/ExpectedArity, fine_maximum/3),
    ExpectedVerdict == ActualVerdict.

query_answers(Profile, InfringementDate, Answers) :-
    findall(Verdict - Citations, administrative_fine_maximum(Profile, InfringementDate, Verdict, Citations), Answers).

scored_pairs([inputs_relied_on(Pairs)|_UnscoredItems], Pairs).

status_of(Subject, Status) :-
    cra_administrative_fines_profile_for(Subject, Request),
    cra_administrative_fines_status(Request, Status).

checklist_is_not_empty(Subject) :-
    cra_administrative_fines_profile_for(Subject, Request),
    cra_administrative_fines_checklist(Request, [_FirstItem|_OtherItems]).

subject_is_resolvable(Subject) :-
    cra_administrative_fines_profile_for(Subject, Request),
    cra_administrative_fines_decision_resolvable(Request).

status_in_vocabulary(Subject) :-
    status_of(Subject, Status),
    functor(Status, StatusName, StatusArity),
    cra_administrative_fines_status_values(StatusValues),
    member(StatusName/StatusArity, StatusValues).

all_subjects(Subjects) :-
    findall(Subject, cra_administrative_fines_subject(Subject), Subjects).

test(every_subject_has_an_expected_answer_and_back) :-
    all_subjects(Subjects),
    sort(Subjects, SortedSubjects),
    findall(Subject, expected_answer(Subject, _, _), ExpectedSubjects),
    sort(ExpectedSubjects, SortedExpectedSubjects),
    SortedSubjects == SortedExpectedSubjects.
test(every_subject_resolves_once_to_its_expected_answer) :-
    all_subjects(Subjects),
    maplist(answer_matches, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    all_subjects(Subjects),
    maplist(checklist_is_not_empty, Subjects).
test(every_subject_is_resolvable) :-
    all_subjects(Subjects),
    maplist(subject_is_resolvable, Subjects).
test(every_status_is_in_the_verdict_vocabulary) :-
    all_subjects(Subjects),
    maplist(status_in_vocabulary, Subjects).
test(the_facade_decision_carries_the_citations) :-
    cra_administrative_fines_profile_for(steward_middle_tier, Request),
    decide_cra_administrative_fines(Request, cra_administrative_fines_verdict(fine_excluded(open_source_software_steward), [cite(eu_reg_2024_2847_art_64_10_b)])).
test(the_checklist_cites_the_date_of_application) :-
    cra_administrative_fines_profile_for(highest_tier_tie, Request),
    cra_administrative_fines_checklist(Request, Items),
    member(item(date_of_application, met, [cite(eu_reg_2024_2847_art_71_2)]), Items),
    member(item(tier_of_infringed_provision, value(highest_maximum_tier), [cite(eu_reg_2024_2847_art_64_2)]), Items).
test(checklist_and_resolvable_hold_on_the_baseline_fixture) :-
    cra_administrative_fines_profile_for(highest_tier_tie, Request),
    cra_administrative_fines_checklist(Request, [_FirstItem|_OtherItems]),
    cra_administrative_fines_decision_resolvable(Request).
test(the_public_interface_resolves_on_the_baseline_fixture) :-
    cra_administrative_fines_profile_for(highest_tier_tie, Request),
    findall(Verdict, decide_cra_administrative_fines(Request, Verdict), Verdicts),
    Verdicts = [cra_administrative_fines_verdict(fine_maximum(highest_maximum_tier, fixed_amount, CapInEuroCents), [cite(eu_reg_2024_2847_art_64_2)])],
    CapInEuroCents =:= 1500000000.
test(the_query_gives_not_yet_applicable_before_the_application_day) :-
    query_answers([attribute(infringed_provision, article_14)], date(2027, 12, 10), Answers),
    Answers == [not_yet_applicable - [cite(eu_reg_2024_2847_art_71_2)]].
test(the_query_gives_indeterminate_for_a_missing_provision) :-
    query_answers([], date(2028, 1, 1), Answers),
    Answers == [indeterminate([infringed_provision]) - []].
test(the_query_gives_not_listed_for_other_provision) :-
    query_answers([attribute(infringed_provision, other_provision)], date(2028, 1, 1), Answers),
    Answers = [not_listed_in_article_64 - Citations],
    clausal_msort(Citations, SortedCitations),
    SortedCitations == [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)].
test(the_query_gives_fine_excluded_for_a_steward_in_the_middle_tier) :-
    query_answers([attribute(infringed_provision, article_20), attribute(offender_is_open_source_software_steward, true)], date(2028, 1, 1), Answers),
    Answers == [fine_excluded(open_source_software_steward) - [cite(eu_reg_2024_2847_art_64_10_b)]].
test(the_query_gives_the_percentage_maximum) :-
    query_answers([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000)], date(2028, 1, 1), Answers),
    Answers = [fine_maximum(highest_maximum_tier, percentage_of_turnover, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_2)]],
    integer(CapInEuroCents),
    CapInEuroCents =:= 2500000000.
test(the_query_gives_the_fixed_maximum_at_a_tie) :-
    query_answers([attribute(infringed_provision, article_23), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)], date(2028, 1, 1), Answers),
    Answers = [fine_maximum(middle_maximum_tier, fixed_amount, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_3)]],
    CapInEuroCents =:= 1000000000.
test(the_query_gives_the_fixed_maximum_for_a_non_undertaking) :-
    query_answers([attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, false)], date(2028, 1, 1), Answers),
    Answers = [fine_maximum(lowest_maximum_tier, fixed_amount_for_non_undertaking, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_4)]],
    CapInEuroCents =:= 500000000.
test(the_query_refers_an_unsure_undertaking) :-
    query_answers([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 7)], date(2028, 1, 1), Answers),
    Answers == [needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_2)), [inputs_relied_on([offender_is_undertaking - unsure])]) - []].
test(the_query_reports_input_problems) :-
    query_answers([attribute(colour, red), attribute(offender_is_undertaking, maybe)], date(2027, 2, 29), Answers),
    Answers == [input_problems([wrong_type(offender_is_undertaking), unknown_key(colour), wrong_type(infringement_date)]) - []].
test(an_unscored_provenance_item_leaves_the_scored_context_unchanged) :-
    administrative_fine_maximum([attribute(infringed_provision, article_47), attribute(offender_is_open_source_software_steward, unsure), attribute(offender_is_undertaking, false)], date(2028, 1, 1), needs_legal_review(Reason, Context), []),
    Reason == open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)),
    scored_pairs(Context, Pairs),
    ExtendedContext = [inputs_relied_on(Pairs), provenance(referral_or_final, [cite(eu_reg_2024_2847_art_64_10_b)])],
    scored_pairs(ExtendedContext, ExtendedPairs),
    ExtendedPairs == Pairs,
    Pairs == [offender_is_open_source_software_steward - unsure, offender_is_undertaking - false].
test(the_day_before_application_is_not_yet_applicable) :-
    answer_matches(day_before_application_highest_tier).
test(the_application_day_gives_the_maximum) :-
    answer_matches(application_day_highest_tier).
test(an_earlier_obligation_date_is_not_yet_applicable) :-
    answer_matches(earlier_obligation_date_middle_tier).
test(the_middle_tier_on_the_application_day) :-
    answer_matches(application_day_middle_tier).
test(a_missing_provision_is_asked_for) :-
    answer_matches(provision_absent).
test(an_unlisted_provision_is_not_listed) :-
    answer_matches(unlisted_provision).
test(a_listed_provision_gets_a_maximum) :-
    answer_matches(listed_provision_middle_tier).
test(a_steward_in_the_middle_tier_is_excluded) :-
    answer_matches(steward_middle_tier).
test(a_non_steward_in_the_middle_tier_gets_the_maximum) :-
    answer_matches(non_steward_middle_tier).
test(a_steward_in_the_lowest_tier_is_excluded) :-
    answer_matches(steward_lowest_tier).
test(a_non_steward_in_the_lowest_tier_gets_the_maximum) :-
    answer_matches(non_steward_lowest_tier).
test(a_steward_in_the_highest_tier_is_not_read) :-
    answer_matches(steward_highest_tier_not_read).
test(a_missing_steward_judgement_is_asked_for_in_the_middle_tier) :-
    answer_matches(steward_absent_middle_tier).
test(a_missing_steward_judgement_is_not_asked_for_in_the_highest_tier) :-
    answer_matches(steward_absent_highest_tier).
test(a_missing_undertaking_judgement_is_asked_for) :-
    answer_matches(undertaking_absent_middle_tier).
test(an_undertaking_without_turnover_is_asked_for_it) :-
    answer_matches(turnover_absent_undertaking).
test(an_unsure_undertaking_without_turnover_names_the_turnover) :-
    answer_matches(turnover_absent_unsure_undertaking).
test(a_non_undertaking_needs_no_turnover) :-
    answer_matches(turnover_absent_non_undertaking).
test(an_unsure_steward_refers) :-
    answer_matches(unsure_steward_referral).
test(an_unsure_steward_refers_before_an_unsure_undertaking) :-
    answer_matches(unsure_steward_and_undertaking_referral).
test(an_unsure_undertaking_in_the_highest_tier_refers_to_paragraph_2) :-
    answer_matches(unsure_undertaking_highest_tier).
test(an_unsure_undertaking_in_the_middle_tier_refers_to_paragraph_3) :-
    answer_matches(unsure_undertaking_middle_tier).
test(an_unsure_undertaking_in_the_lowest_tier_refers_to_paragraph_4) :-
    answer_matches(unsure_undertaking_lowest_tier).
test(one_euro_below_the_highest_tie_names_the_fixed_amount) :-
    answer_matches(highest_tier_one_euro_below_tie).
test(the_highest_tie_names_the_fixed_amount) :-
    answer_matches(highest_tier_tie).
test(one_euro_above_the_highest_tie_drops_the_half_cent) :-
    answer_matches(highest_tier_one_euro_above_tie).
test(two_euros_above_the_highest_tie_gives_the_percentage) :-
    answer_matches(highest_tier_two_euros_above_tie).
test(the_middle_tie_names_the_fixed_amount) :-
    answer_matches(middle_tier_tie).
test(one_euro_above_the_middle_tie_gives_the_percentage) :-
    answer_matches(middle_tier_one_euro_above_tie).
test(the_lowest_tie_names_the_fixed_amount) :-
    answer_matches(lowest_tier_tie).
test(one_euro_above_the_lowest_tie_gives_the_percentage) :-
    answer_matches(lowest_tier_one_euro_above_tie).
test(the_leap_day_of_2028_is_a_date) :-
    answer_matches(leap_day_2028).
test(the_twenty_ninth_of_february_2027_is_not_a_date) :-
    answer_matches(non_leap_day_2027).
test(a_float_turnover_is_wrong_type) :-
    answer_matches(float_turnover).
test(a_negative_turnover_is_wrong_type) :-
    answer_matches(negative_turnover).
test(a_duplicate_key_is_named_once_and_not_wrong_type) :-
    answer_matches(duplicate_undertaking_key).
test(an_unknown_key_is_named) :-
    answer_matches(unknown_profile_key).
test(a_provision_outside_the_closed_list_is_wrong_type) :-
    answer_matches(provision_outside_closed_list).
test(a_bad_profile_and_a_bad_date_are_both_named) :-
    answer_matches(not_a_profile_nor_a_date).

test(the_query_gives_no_not_yet_applicable_on_the_application_day, fail) :-
    administrative_fine_maximum([attribute(infringed_provision, article_14)], date(2027, 12, 11), not_yet_applicable, _).
test(the_query_gives_no_fine_excluded_in_the_highest_tier, fail) :-
    administrative_fine_maximum([attribute(infringed_provision, article_14), attribute(offender_is_open_source_software_steward, true), attribute(offender_is_undertaking, false)], date(2028, 1, 1), fine_excluded(_), _).
test(the_query_gives_no_final_answer_with_input_problems, fail) :-
    administrative_fine_maximum([attribute(colour, red)], date(2028, 1, 1), not_listed_in_article_64, _).
test(a_provenance_item_is_never_the_scored_item, fail) :-
    scored_pairs([provenance(referral_or_final, [])], _Pairs).
test(the_application_day_is_not_not_yet_applicable, fail) :-
    status_of(application_day_highest_tier, not_yet_applicable).
test(the_middle_tier_on_the_application_day_is_not_not_yet_applicable, fail) :-
    status_of(application_day_middle_tier, not_yet_applicable).
test(a_missing_provision_gets_no_maximum, fail) :-
    status_of(provision_absent, fine_maximum(_, _, _)).
test(an_unlisted_provision_gets_no_maximum, fail) :-
    status_of(unlisted_provision, fine_maximum(_, _, _)).
test(a_listed_provision_is_not_unlisted, fail) :-
    status_of(listed_provision_middle_tier, not_listed_in_article_64).
test(a_non_steward_in_the_middle_tier_is_not_excluded, fail) :-
    status_of(non_steward_middle_tier, fine_excluded(_)).
test(a_non_steward_in_the_lowest_tier_is_not_excluded, fail) :-
    status_of(non_steward_lowest_tier, fine_excluded(_)).
test(a_steward_in_the_highest_tier_is_not_excluded, fail) :-
    status_of(steward_highest_tier_not_read, fine_excluded(_)).
test(the_highest_tier_never_asks_for_the_steward, fail) :-
    status_of(steward_absent_highest_tier, indeterminate(_)).
test(an_unsure_undertaking_without_turnover_is_not_referred, fail) :-
    status_of(turnover_absent_unsure_undertaking, needs_legal_review(_, _)).
test(a_non_undertaking_is_not_asked_for_turnover, fail) :-
    status_of(turnover_absent_non_undertaking, indeterminate(_)).
test(an_unsure_steward_gets_no_maximum, fail) :-
    status_of(unsure_steward_referral, fine_maximum(_, _, _)).
test(the_highest_tie_is_not_the_percentage, fail) :-
    status_of(highest_tier_tie, fine_maximum(_, percentage_of_turnover, _)).
test(one_euro_above_the_highest_tie_is_not_the_fixed_amount, fail) :-
    status_of(highest_tier_one_euro_above_tie, fine_maximum(_, fixed_amount, _)).
test(the_middle_tie_is_not_the_percentage, fail) :-
    status_of(middle_tier_tie, fine_maximum(_, percentage_of_turnover, _)).
test(one_euro_above_the_lowest_tie_is_not_the_fixed_amount, fail) :-
    status_of(lowest_tier_one_euro_above_tie, fine_maximum(_, fixed_amount, _)).
test(the_leap_day_of_2028_is_no_input_problem, fail) :-
    status_of(leap_day_2028, input_problems(_)).
test(the_twenty_ninth_of_february_2027_is_not_answered, fail) :-
    status_of(non_leap_day_2027, not_listed_in_article_64).
test(a_float_turnover_gets_no_maximum, fail) :-
    status_of(float_turnover, fine_maximum(_, _, _)).

cp_test_names([every_subject_has_an_expected_answer_and_back, every_subject_resolves_once_to_its_expected_answer, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, every_status_is_in_the_verdict_vocabulary, the_facade_decision_carries_the_citations, the_checklist_cites_the_date_of_application, checklist_and_resolvable_hold_on_the_baseline_fixture, the_public_interface_resolves_on_the_baseline_fixture, the_query_gives_not_yet_applicable_before_the_application_day, the_query_gives_indeterminate_for_a_missing_provision, the_query_gives_not_listed_for_other_provision, the_query_gives_fine_excluded_for_a_steward_in_the_middle_tier, the_query_gives_the_percentage_maximum, the_query_gives_the_fixed_maximum_at_a_tie, the_query_gives_the_fixed_maximum_for_a_non_undertaking, the_query_refers_an_unsure_undertaking, the_query_reports_input_problems, an_unscored_provenance_item_leaves_the_scored_context_unchanged, the_day_before_application_is_not_yet_applicable, the_application_day_gives_the_maximum, an_earlier_obligation_date_is_not_yet_applicable, the_middle_tier_on_the_application_day, a_missing_provision_is_asked_for, an_unlisted_provision_is_not_listed, a_listed_provision_gets_a_maximum, a_steward_in_the_middle_tier_is_excluded, a_non_steward_in_the_middle_tier_gets_the_maximum, a_steward_in_the_lowest_tier_is_excluded, a_non_steward_in_the_lowest_tier_gets_the_maximum, a_steward_in_the_highest_tier_is_not_read, a_missing_steward_judgement_is_asked_for_in_the_middle_tier, a_missing_steward_judgement_is_not_asked_for_in_the_highest_tier, a_missing_undertaking_judgement_is_asked_for, an_undertaking_without_turnover_is_asked_for_it, an_unsure_undertaking_without_turnover_names_the_turnover, a_non_undertaking_needs_no_turnover, an_unsure_steward_refers, an_unsure_steward_refers_before_an_unsure_undertaking, an_unsure_undertaking_in_the_highest_tier_refers_to_paragraph_2, an_unsure_undertaking_in_the_middle_tier_refers_to_paragraph_3, an_unsure_undertaking_in_the_lowest_tier_refers_to_paragraph_4, one_euro_below_the_highest_tie_names_the_fixed_amount, the_highest_tie_names_the_fixed_amount, one_euro_above_the_highest_tie_drops_the_half_cent, two_euros_above_the_highest_tie_gives_the_percentage, the_middle_tie_names_the_fixed_amount, one_euro_above_the_middle_tie_gives_the_percentage, the_lowest_tie_names_the_fixed_amount, one_euro_above_the_lowest_tie_gives_the_percentage, the_leap_day_of_2028_is_a_date, the_twenty_ninth_of_february_2027_is_not_a_date, a_float_turnover_is_wrong_type, a_negative_turnover_is_wrong_type, a_duplicate_key_is_named_once_and_not_wrong_type, an_unknown_key_is_named, a_provision_outside_the_closed_list_is_wrong_type, a_bad_profile_and_a_bad_date_are_both_named]).
cp_test_fail_names([the_query_gives_no_not_yet_applicable_on_the_application_day, the_query_gives_no_fine_excluded_in_the_highest_tier, the_query_gives_no_final_answer_with_input_problems, a_provenance_item_is_never_the_scored_item, the_application_day_is_not_not_yet_applicable, the_middle_tier_on_the_application_day_is_not_not_yet_applicable, a_missing_provision_gets_no_maximum, an_unlisted_provision_gets_no_maximum, a_listed_provision_is_not_unlisted, a_non_steward_in_the_middle_tier_is_not_excluded, a_non_steward_in_the_lowest_tier_is_not_excluded, a_steward_in_the_highest_tier_is_not_excluded, the_highest_tier_never_asks_for_the_steward, an_unsure_undertaking_without_turnover_is_not_referred, a_non_undertaking_is_not_asked_for_turnover, an_unsure_steward_gets_no_maximum, the_highest_tie_is_not_the_percentage, one_euro_above_the_highest_tie_is_not_the_fixed_amount, the_middle_tie_is_not_the_percentage, one_euro_above_the_lowest_tie_is_not_the_fixed_amount, the_leap_day_of_2028_is_no_input_problem, the_twenty_ninth_of_february_2027_is_not_answered, a_float_turnover_gets_no_maximum]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
