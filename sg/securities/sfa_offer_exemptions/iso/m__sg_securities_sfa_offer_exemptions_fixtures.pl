% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_fixtures, [sfa_offer_exemptions_subject/1, sfa_offer_exemptions_profile_for/2, sfa_offer_exemptions_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__sg_securities_sfa_offer_exemptions_sfa_offer_exemptions, [decide_sfa_offer_exemptions/2]).

sfa_offer_exemptions_subject(s274_institutional_positive).
sfa_offer_exemptions_subject(s274_institutional_near_miss).
sfa_offer_exemptions_subject(s275_1_relevant_positive).
sfa_offer_exemptions_subject(s275_1_relevant_near_miss).
sfa_offer_exemptions_subject(s275_1a_principal_at_minimum).
sfa_offer_exemptions_subject(s275_1a_principal_below_minimum).
sfa_offer_exemptions_subject(s272a_small_at_amount_limit).
sfa_offer_exemptions_subject(s272a_small_over_amount_limit).
sfa_offer_exemptions_subject(s272b_placement_at_person_limit).
sfa_offer_exemptions_subject(s272b_placement_over_person_limit).
sfa_offer_exemptions_subject(s274_and_s275_combined).
sfa_offer_exemptions_subject(indeterminate_missing_prospectus_state).
sfa_offer_exemptions_subject(indeterminate_zero_offerees).

sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 1, relevant_person_offerees - 0, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none]).
sfa_offer_exemptions_profile_for(s274_institutional_near_miss, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 1000000, advertisement - true, non_permitted_selling_expenses - false, prospectus_state - none]).
sfa_offer_exemptions_profile_for(s275_1_relevant_positive, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 2, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none]).
sfa_offer_exemptions_profile_for(s275_1_relevant_near_miss, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 2, other_offerees - 0, amount_raised_cents - 1000000, advertisement - true, non_permitted_selling_expenses - false, prospectus_state - none]).
sfa_offer_exemptions_profile_for(s275_1a_principal_at_minimum, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, acquires_as_principal - true, minimum_consideration_per_transaction_cents - 20000000, prior_private_placement_offerees - [prior(date(2025, 6, 16), 50)]]).
sfa_offer_exemptions_profile_for(s275_1a_principal_below_minimum, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, acquires_as_principal - true, minimum_consideration_per_transaction_cents - 19999999, prior_private_placement_offerees - [prior(date(2025, 6, 16), 50)]]).
sfa_offer_exemptions_profile_for(s272a_small_at_amount_limit, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 500000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, personal_offer - true, statement_and_resale_notification_given - true, prior_private_placement_offerees - [prior(date(2025, 6, 16), 50)]]).
sfa_offer_exemptions_profile_for(s272a_small_over_amount_limit, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 1, amount_raised_cents - 500000001, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none, personal_offer - true, statement_and_resale_notification_given - true, prior_private_placement_offerees - [prior(date(2025, 6, 16), 50)]]).
sfa_offer_exemptions_profile_for(s272b_placement_at_person_limit, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 50, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none]).
sfa_offer_exemptions_profile_for(s272b_placement_over_person_limit, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 51, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none]).
sfa_offer_exemptions_profile_for(s274_and_s275_combined, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 1, relevant_person_offerees - 2, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none]).
sfa_offer_exemptions_profile_for(indeterminate_missing_prospectus_state, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 1, relevant_person_offerees - 0, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false]).
sfa_offer_exemptions_profile_for(indeterminate_zero_offerees, Profile) :-
    dict_pairs(Profile, [offer_date - date(2026, 6, 15), institutional_offerees - 0, relevant_person_offerees - 0, other_offerees - 0, amount_raised_cents - 1000000, advertisement - false, non_permitted_selling_expenses - false, prospectus_state - none]).

sfa_offer_exemptions_assess(Subject, Result) :-
    sfa_offer_exemptions_profile_for(Subject, Profile),
    decide_sfa_offer_exemptions(Profile, Result).
