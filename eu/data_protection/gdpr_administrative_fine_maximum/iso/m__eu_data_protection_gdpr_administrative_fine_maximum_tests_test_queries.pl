% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_queries, [gdpr_administrative_fine_maximum_profile_keys/1, gdpr_administrative_fine_maximum_what_if/4, gdpr_administrative_fine_maximum_cap_in_euro_cents/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [gdpr_administrative_fine_maximum_status/2, gdpr_administrative_fine_maximum_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_administrative_fine_maximum_profile_keys(ProfileKeys),
    ProfileKeys == [infringed_provisions, infringer_is_undertaking, total_worldwide_annual_turnover_in_euros, infringements_concern_same_or_linked_processing_operations, infringements_intentional_or_negligent].
test(a_well_formed_fixture_has_no_input_problem) :-
    gdpr_administrative_fine_maximum_profile_for(combined_linked_and_intentional, Profile),
    gdpr_administrative_fine_maximum_input_problems(Profile, Problems),
    Problems == [].
test(the_negative_turnover_fixture_has_a_wrong_type) :-
    gdpr_administrative_fine_maximum_profile_for(negative_turnover_rejected, Profile),
    gdpr_administrative_fine_maximum_input_problems(Profile, Problems),
    Problems == [wrong_type(total_worldwide_annual_turnover_in_euros)].
test(status_of_the_unlisted_fixture_is_a_referral) :-
    gdpr_administrative_fine_maximum_profile_for(unlisted_provision, Profile),
    gdpr_administrative_fine_maximum_status(Profile, Status),
    Status == referred_for_legal_review.
test(what_if_settling_the_undertaking_gives_a_maximum) :-
    gdpr_administrative_fine_maximum_profile_for(unsure_undertaking_with_turnover, Profile),
    gdpr_administrative_fine_maximum_what_if(Profile, infringer_is_undertaking, true, NewStatus),
    NewStatus == fine_maximum_determined.
test(what_if_supplying_the_turnover_moves_to_a_referral) :-
    gdpr_administrative_fine_maximum_profile_for(missing_turnover_unsure_undertaking, Profile),
    gdpr_administrative_fine_maximum_what_if(Profile, total_worldwide_annual_turnover_in_euros, 100, NewStatus),
    NewStatus == referred_for_legal_review.
test(what_if_fault_true_turns_separate_into_combined) :-
    gdpr_administrative_fine_maximum_profile_for(separate_not_intentional_or_negligent, Profile),
    gdpr_administrative_fine_maximum_what_if(Profile, infringements_intentional_or_negligent, true, NewStatus),
    NewStatus == fine_maximum_determined.
test(what_if_a_listed_provision_lifts_the_referral) :-
    gdpr_administrative_fine_maximum_profile_for(unlisted_provision, Profile),
    gdpr_administrative_fine_maximum_what_if(Profile, infringed_provisions, [article_25], NewStatus),
    NewStatus == fine_maximum_determined.
test(what_if_a_malformed_value_is_rejected) :-
    gdpr_administrative_fine_maximum_profile_for(listed_neighbour_provision, Profile),
    gdpr_administrative_fine_maximum_what_if(Profile, infringer_is_undertaking, maybe, NewStatus),
    NewStatus == input_rejected.
test(what_if_answers_exactly_once) :-
    gdpr_administrative_fine_maximum_profile_for(linked_operations_unsure, Profile),
    findall(NewStatus, gdpr_administrative_fine_maximum_what_if(Profile, infringements_concern_same_or_linked_processing_operations, true, NewStatus), Statuses),
    Statuses == [fine_maximum_determined].
test(cap_at_the_lower_tie) :-
    gdpr_administrative_fine_maximum_profile_for(lower_tier_turnover_at_tie, Profile),
    gdpr_administrative_fine_maximum_cap_in_euro_cents(Profile, CapInEuroCents),
    CapInEuroCents =:= 1000000000.
test(cap_one_euro_above_the_higher_tie) :-
    gdpr_administrative_fine_maximum_profile_for(higher_tier_turnover_just_above_tie, Profile),
    gdpr_administrative_fine_maximum_cap_in_euro_cents(Profile, CapInEuroCents),
    CapInEuroCents =:= 2000000004.
test(cap_of_the_combined_fixture) :-
    gdpr_administrative_fine_maximum_profile_for(combined_linked_and_intentional, Profile),
    gdpr_administrative_fine_maximum_cap_in_euro_cents(Profile, CapInEuroCents),
    CapInEuroCents =:= 2000000000.
test(the_cap_answers_exactly_once) :-
    gdpr_administrative_fine_maximum_profile_for(supervisory_order_non_undertaking, Profile),
    findall(CapInEuroCents, gdpr_administrative_fine_maximum_cap_in_euro_cents(Profile, CapInEuroCents), Caps),
    length(Caps, 1).
test(checklist_of_the_combined_fixture_carries_citations) :-
    gdpr_administrative_fine_maximum_profile_for(combined_linked_and_intentional, Profile),
    gdpr_administrative_fine_maximum_checklist(Profile, ItemRows),
    ItemRows = [item(overall, Status, Citations), item(fine_maximum(MaximumTier, Basis, CapInEuroCents), met, ParagraphCitation)],
    Status == fine_maximum_determined,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a), cite(eu_reg_2016_679_art_83_3)],
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 2000000000,
    ParagraphCitation == cite(eu_reg_2016_679_art_83_5).
test(checklist_of_the_separate_fixture_has_one_row_per_infringement) :-
    gdpr_administrative_fine_maximum_profile_for(separate_not_intentional_or_negligent, Profile),
    gdpr_administrative_fine_maximum_checklist(Profile, ItemRows),
    ItemRows = [item(overall, separate_fine_maxima_determined, _), item(infringement_maximum(article_33, lower_maximum_tier, fixed_amount, FirstCapInEuroCents), met, cite(eu_reg_2016_679_art_83_4)), item(infringement_maximum(article_6, higher_maximum_tier, fixed_amount, SecondCapInEuroCents), met, cite(eu_reg_2016_679_art_83_5))],
    FirstCapInEuroCents =:= 1000000000,
    SecondCapInEuroCents =:= 2000000000.
test(checklist_of_a_referral_names_the_open_judgement) :-
    gdpr_administrative_fine_maximum_profile_for(linked_operations_unsure, Profile),
    gdpr_administrative_fine_maximum_checklist(Profile, ItemRows),
    member(item(infringements_concern_same_or_linked_processing_operations, unknown([infringements_concern_same_or_linked_processing_operations]), cite(eu_reg_2016_679_art_83_3)), ItemRows).

test(a_referral_has_no_cap, fail) :-
    gdpr_administrative_fine_maximum_profile_for(linked_operations_unsure, Profile),
    gdpr_administrative_fine_maximum_cap_in_euro_cents(Profile, _).
test(separate_maxima_have_no_single_cap, fail) :-
    gdpr_administrative_fine_maximum_profile_for(separate_not_intentional_or_negligent, Profile),
    gdpr_administrative_fine_maximum_cap_in_euro_cents(Profile, _).

cp_test_names([profile_keys_are_the_contract_keys, a_well_formed_fixture_has_no_input_problem, the_negative_turnover_fixture_has_a_wrong_type, status_of_the_unlisted_fixture_is_a_referral, what_if_settling_the_undertaking_gives_a_maximum, what_if_supplying_the_turnover_moves_to_a_referral, what_if_fault_true_turns_separate_into_combined, what_if_a_listed_provision_lifts_the_referral, what_if_a_malformed_value_is_rejected, what_if_answers_exactly_once, cap_at_the_lower_tie, cap_one_euro_above_the_higher_tie, cap_of_the_combined_fixture, the_cap_answers_exactly_once, checklist_of_the_combined_fixture_carries_citations, checklist_of_the_separate_fixture_has_one_row_per_infringement, checklist_of_a_referral_names_the_open_judgement]).
cp_test_fail_names([a_referral_has_no_cap, separate_maxima_have_no_single_cap]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
