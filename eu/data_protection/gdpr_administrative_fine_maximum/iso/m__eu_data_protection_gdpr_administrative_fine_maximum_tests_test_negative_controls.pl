% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, gdpr_administrative_fine_maximum_status/2, gdpr_administrative_fine_maximum_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_profile_for/2]).

subject_status(Subject, Status) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    gdpr_administrative_fine_maximum_status(Profile, Status).

subject_verdict(Subject, Verdict) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    administrative_fine_maximum(Profile, Verdict, _).

table_status(StatusValues, Status) :-
    member(Status, StatusValues).

test(every_near_miss_status_is_a_table_atom) :-
    gdpr_administrative_fine_maximum_status_values(StatusValues),
    maplist(table_status(StatusValues), [fine_maximum_determined, separate_fine_maxima_determined, required_input_missing, referred_for_legal_review, input_rejected]).
test(negative_turnover_is_rejected) :-
    subject_status(negative_turnover_rejected, input_rejected).
test(zero_turnover_gets_the_higher_fixed_amount) :-
    subject_verdict(zero_turnover_accepted, fine_maximum(MaximumTier, Basis, CapInEuroCents)),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 2000000000.
test(missing_turnover_with_unsure_undertaking_is_indeterminate) :-
    subject_verdict(missing_turnover_unsure_undertaking, Verdict),
    Verdict == indeterminate([total_worldwide_annual_turnover_in_euros]).
test(an_undertaking_needs_the_turnover) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true)], Verdict, _),
    Verdict == indeterminate([total_worldwide_annual_turnover_in_euros]).
test(a_non_undertaking_without_turnover_gets_a_maximum) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, false)], fine_maximum_determined).
test(a_missing_key_is_named_before_a_referral) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_24])], Verdict, _),
    Verdict == indeterminate([infringer_is_undertaking, total_worldwide_annual_turnover_in_euros]).
test(an_unlisted_provision_is_not_governed_here) :-
    subject_verdict(unlisted_provision, Verdict),
    Verdict == needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]), [inputs_relied_on([infringed_provisions - [article_24]])]).
test(the_listed_neighbour_gets_the_lower_fixed_amount) :-
    subject_verdict(listed_neighbour_provision, fine_maximum(MaximumTier, Basis, CapInEuroCents)),
    MaximumTier == lower_maximum_tier,
    Basis == fixed_amount_for_non_undertaking,
    CapInEuroCents =:= 1000000000.
test(an_unsure_undertaking_refers) :-
    subject_verdict(unsure_undertaking_with_turnover, Verdict),
    Verdict == needs_legal_review(open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), [inputs_relied_on([infringer_is_undertaking - unsure])]).
test(a_settled_undertaking_gets_a_maximum) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 100)], fine_maximum_determined).
test(unsure_linked_operations_refer) :-
    subject_verdict(linked_operations_unsure, Verdict),
    Verdict == needs_legal_review(open_textured(infringements_concern_same_or_linked_processing_operations, cite(eu_reg_2016_679_art_83_3)), [inputs_relied_on([infringer_is_undertaking - true, infringements_concern_same_or_linked_processing_operations - unsure, infringements_intentional_or_negligent - true])]).
test(a_false_key_settles_separate_before_an_unsure_one) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_33, article_6]), attribute(infringer_is_undertaking, false), attribute(infringements_concern_same_or_linked_processing_operations, unsure), attribute(infringements_intentional_or_negligent, false)], separate_fine_maxima_determined).
test(combined_takes_the_gravest_tier_and_cites_article_83_3_last) :-
    gdpr_administrative_fine_maximum_profile_for(combined_linked_and_intentional, Profile),
    administrative_fine_maximum(Profile, fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a), cite(eu_reg_2016_679_art_83_3)].
test(fault_false_gives_separate_maxima) :-
    subject_status(separate_not_intentional_or_negligent, separate_fine_maxima_determined).
test(a_false_operations_key_alone_settles_separate) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_33, article_6]), attribute(infringer_is_undertaking, false), attribute(infringements_concern_same_or_linked_processing_operations, false)], separate_fine_maxima_determined).
test(the_lower_tie_keeps_the_fixed_amount) :-
    subject_verdict(lower_tier_turnover_at_tie, fine_maximum(_, fixed_amount, CapInEuroCents)),
    CapInEuroCents =:= 1000000000.
test(one_euro_above_the_lower_tie_is_percentage) :-
    subject_verdict(lower_tier_turnover_just_above_tie, fine_maximum(_, percentage_of_turnover, CapInEuroCents)),
    CapInEuroCents =:= 1000000002.
test(the_higher_tie_keeps_the_fixed_amount) :-
    subject_verdict(higher_tier_turnover_at_tie, fine_maximum(higher_maximum_tier, fixed_amount, CapInEuroCents)),
    CapInEuroCents =:= 2000000000.
test(article_5_is_in_the_higher_tier) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, false)], fine_maximum_determined),
    administrative_fine_maximum([attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, false)], fine_maximum(higher_maximum_tier, _, _), _).
test(a_non_undertaking_gets_the_non_undertaking_basis) :-
    subject_verdict(non_undertaking_certification_body, fine_maximum(_, fixed_amount_for_non_undertaking, _)).
test(an_undertaking_with_zero_turnover_gets_the_fixed_amount) :-
    subject_verdict(undertaking_with_zero_turnover, fine_maximum(_, fixed_amount, CapInEuroCents)),
    CapInEuroCents =:= 1000000000.

test(zero_turnover_is_not_rejected, fail) :-
    subject_status(zero_turnover_accepted, input_rejected).
test(given_turnover_is_not_indeterminate, fail) :-
    subject_status(unsure_undertaking_with_turnover, required_input_missing).
test(a_non_undertaking_needs_no_turnover, fail) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, false)], required_input_missing).
test(the_listed_neighbour_is_not_referred, fail) :-
    subject_status(listed_neighbour_provision, referred_for_legal_review).
test(a_settled_undertaking_does_not_refer, fail) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 100)], referred_for_legal_review).
test(linked_operations_true_do_not_refer, fail) :-
    subject_status(combined_linked_and_intentional, referred_for_legal_review).
test(fault_false_is_not_combined, fail) :-
    subject_status(separate_not_intentional_or_negligent, fine_maximum_determined).
test(both_keys_true_is_not_separate, fail) :-
    subject_status(combined_linked_and_intentional, separate_fine_maxima_determined).
test(separate_never_cites_article_83_3, fail) :-
    gdpr_administrative_fine_maximum_profile_for(separate_not_intentional_or_negligent, Profile),
    administrative_fine_maximum(Profile, separate_fine_maxima(_), Citations),
    member(cite(eu_reg_2016_679_art_83_3), Citations).
test(the_lower_tie_is_not_percentage, fail) :-
    subject_verdict(lower_tier_turnover_at_tie, fine_maximum(_, percentage_of_turnover, _)).
test(one_euro_above_the_lower_tie_is_not_fixed, fail) :-
    subject_verdict(lower_tier_turnover_just_above_tie, fine_maximum(_, fixed_amount, _)).
test(the_higher_tie_is_not_percentage, fail) :-
    subject_verdict(higher_tier_turnover_at_tie, fine_maximum(_, percentage_of_turnover, _)).
test(article_25_is_not_in_the_higher_tier, fail) :-
    subject_verdict(listed_neighbour_provision, fine_maximum(higher_maximum_tier, _, _)).
test(an_undertaking_with_zero_turnover_is_not_a_non_undertaking, fail) :-
    subject_verdict(undertaking_with_zero_turnover, fine_maximum(_, fixed_amount_for_non_undertaking, _)).

cp_test_names([every_near_miss_status_is_a_table_atom, negative_turnover_is_rejected, zero_turnover_gets_the_higher_fixed_amount, missing_turnover_with_unsure_undertaking_is_indeterminate, an_undertaking_needs_the_turnover, a_non_undertaking_without_turnover_gets_a_maximum, a_missing_key_is_named_before_a_referral, an_unlisted_provision_is_not_governed_here, the_listed_neighbour_gets_the_lower_fixed_amount, an_unsure_undertaking_refers, a_settled_undertaking_gets_a_maximum, unsure_linked_operations_refer, a_false_key_settles_separate_before_an_unsure_one, combined_takes_the_gravest_tier_and_cites_article_83_3_last, fault_false_gives_separate_maxima, a_false_operations_key_alone_settles_separate, the_lower_tie_keeps_the_fixed_amount, one_euro_above_the_lower_tie_is_percentage, the_higher_tie_keeps_the_fixed_amount, article_5_is_in_the_higher_tier, a_non_undertaking_gets_the_non_undertaking_basis, an_undertaking_with_zero_turnover_gets_the_fixed_amount]).
cp_test_fail_names([zero_turnover_is_not_rejected, given_turnover_is_not_indeterminate, a_non_undertaking_needs_no_turnover, the_listed_neighbour_is_not_referred, a_settled_undertaking_does_not_refer, linked_operations_true_do_not_refer, fault_false_is_not_combined, both_keys_true_is_not_separate, separate_never_cites_article_83_3, the_lower_tie_is_not_percentage, one_euro_above_the_lower_tie_is_not_fixed, the_higher_tie_is_not_percentage, article_25_is_not_in_the_higher_tier, an_undertaking_with_zero_turnover_is_not_a_non_undertaking]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
