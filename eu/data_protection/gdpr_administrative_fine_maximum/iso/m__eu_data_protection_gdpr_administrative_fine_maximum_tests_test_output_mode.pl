% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, decide_gdpr_administrative_fine_maximum/2, gdpr_administrative_fine_maximum_status/2, gdpr_administrative_fine_maximum_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_subject/1, gdpr_administrative_fine_maximum_profile_for/2]).

subject_verdict(Subject, Verdict, Citations) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    administrative_fine_maximum(Profile, Verdict, Citations).

subject_statuses(Subject, Subject - Statuses) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    findall(Status, gdpr_administrative_fine_maximum_status(Profile, Status), Statuses).

one_table_status(StatusValues, _ - [Status]) :-
    member(Status, StatusValues).

test(every_subject_yields_exactly_one_status_from_the_table) :-
    findall(Subject, gdpr_administrative_fine_maximum_subject(Subject), Subjects),
    maplist(subject_statuses, Subjects, SubjectStatuses),
    SubjectStatuses = [_|_],
    gdpr_administrative_fine_maximum_status_values(StatusValues),
    maplist(one_table_status(StatusValues), SubjectStatuses).
test(lower_tier_at_the_tie_reads_out_the_fixed_amount) :-
    subject_verdict(lower_tier_turnover_at_tie, Verdict, Citations),
    Verdict = fine_maximum(MaximumTier, Basis, CapInEuroCents),
    MaximumTier == lower_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 1000000000,
    Citations == [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)].
test(lower_tier_one_euro_above_the_tie_reads_out_the_percentage) :-
    subject_verdict(lower_tier_turnover_just_above_tie, Verdict, _),
    Verdict = fine_maximum(MaximumTier, Basis, CapInEuroCents),
    MaximumTier == lower_maximum_tier,
    Basis == percentage_of_turnover,
    CapInEuroCents =:= 1000000002.
test(higher_tier_at_the_tie_reads_out_the_fixed_amount) :-
    subject_verdict(higher_tier_turnover_at_tie, Verdict, Citations),
    Verdict = fine_maximum(MaximumTier, Basis, CapInEuroCents),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_b)].
test(higher_tier_one_euro_above_the_tie_reads_out_the_percentage) :-
    subject_verdict(higher_tier_turnover_just_above_tie, Verdict, _),
    Verdict = fine_maximum(MaximumTier, Basis, CapInEuroCents),
    MaximumTier == higher_maximum_tier,
    Basis == percentage_of_turnover,
    CapInEuroCents =:= 2000000004.
test(non_undertaking_certification_body_cites_both_points) :-
    subject_verdict(non_undertaking_certification_body, Verdict, Citations),
    Verdict = fine_maximum(MaximumTier, Basis, CapInEuroCents),
    MaximumTier == lower_maximum_tier,
    Basis == fixed_amount_for_non_undertaking,
    CapInEuroCents =:= 1000000000,
    Citations == [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_4_b)].
test(undertaking_with_zero_turnover_reads_out_the_fixed_amount) :-
    subject_verdict(undertaking_with_zero_turnover, Verdict, _),
    Verdict = fine_maximum(MaximumTier, Basis, CapInEuroCents),
    MaximumTier == lower_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 1000000000.
test(supervisory_order_cites_paragraph_6_after_paragraph_5) :-
    subject_verdict(supervisory_order_non_undertaking, Verdict, Citations),
    Verdict = fine_maximum(MaximumTier, Basis, CapInEuroCents),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount_for_non_undertaking,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6), cite(eu_reg_2016_679_art_83_5_e)].
test(combined_reads_out_the_gravest_tier) :-
    subject_verdict(combined_linked_and_intentional, Verdict, Citations),
    Verdict = fine_maximum(MaximumTier, Basis, CapInEuroCents),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a), cite(eu_reg_2016_679_art_83_3)].
test(separate_reads_out_each_maximum_in_vocabulary_order) :-
    subject_verdict(separate_not_intentional_or_negligent, Verdict, Citations),
    Verdict = separate_fine_maxima([infringement_maximum(FirstProvision, FirstTier, FirstBasis, FirstCapInEuroCents), infringement_maximum(SecondProvision, SecondTier, SecondBasis, SecondCapInEuroCents)]),
    FirstProvision == article_33,
    FirstTier == lower_maximum_tier,
    FirstBasis == fixed_amount,
    FirstCapInEuroCents =:= 1000000000,
    SecondProvision == article_6,
    SecondTier == higher_maximum_tier,
    SecondBasis == fixed_amount,
    SecondCapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_5_a)].
test(linked_unsure_reads_out_the_referral_and_its_pairs) :-
    subject_verdict(linked_operations_unsure, Verdict, Citations),
    Verdict == needs_legal_review(open_textured(infringements_concern_same_or_linked_processing_operations, cite(eu_reg_2016_679_art_83_3)), [inputs_relied_on([infringer_is_undertaking - true, infringements_concern_same_or_linked_processing_operations - unsure, infringements_intentional_or_negligent - true])]),
    Citations == [].
test(unsure_undertaking_reads_out_the_referral) :-
    subject_verdict(unsure_undertaking_with_turnover, Verdict, Citations),
    Verdict == needs_legal_review(open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), [inputs_relied_on([infringer_is_undertaking - unsure])]),
    Citations == [].
test(an_empty_profile_reads_out_every_needed_key) :-
    administrative_fine_maximum([], Verdict, Citations),
    Verdict == indeterminate([infringed_provisions, infringer_is_undertaking, total_worldwide_annual_turnover_in_euros]),
    Citations == [].
test(a_final_verdict_carries_a_citation) :-
    gdpr_administrative_fine_maximum_profile_for(listed_neighbour_provision, Profile),
    decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(fine_maximum_determined, [_FirstCitation|_OtherCitations])).
test(a_referral_carries_no_citation) :-
    gdpr_administrative_fine_maximum_profile_for(unlisted_provision, Profile),
    decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(referred_for_legal_review, Citations)),
    Citations == [].

cp_test_names([every_subject_yields_exactly_one_status_from_the_table, lower_tier_at_the_tie_reads_out_the_fixed_amount, lower_tier_one_euro_above_the_tie_reads_out_the_percentage, higher_tier_at_the_tie_reads_out_the_fixed_amount, higher_tier_one_euro_above_the_tie_reads_out_the_percentage, non_undertaking_certification_body_cites_both_points, undertaking_with_zero_turnover_reads_out_the_fixed_amount, supervisory_order_cites_paragraph_6_after_paragraph_5, combined_reads_out_the_gravest_tier, separate_reads_out_each_maximum_in_vocabulary_order, linked_unsure_reads_out_the_referral_and_its_pairs, unsure_undertaking_reads_out_the_referral, an_empty_profile_reads_out_every_needed_key, a_final_verdict_carries_a_citation, a_referral_carries_no_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
