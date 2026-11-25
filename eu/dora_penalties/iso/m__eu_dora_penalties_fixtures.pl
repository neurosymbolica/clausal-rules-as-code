% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_penalties_fixtures, [dora_penalties_subject/1, dora_penalties_profile_for/2, dora_penalties_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_penalties_dora_penalties, [decide_dora_penalties/2]).

dora_penalties_subject(option_used).
dora_penalties_subject(option_not_used).
dora_penalties_subject(breach_not_criminally_penalised).
dora_penalties_subject(breach_criminal_choice_absent).
dora_penalties_subject(breach_key_absent).
dora_penalties_subject(fact_key_unsure).
dora_penalties_subject(duplicate_breach_key).
dora_penalties_subject(unknown_key_given).
dora_penalties_subject(judgement_unsure).
dora_penalties_subject(no_criminal_penalties_laid_down).

other_facts([attribute(member_state_laid_down_criminal_penalties_for_breaches, true), attribute(national_law_permits_requiring_data_traffic_records, true), attribute(measures_applied_to_legal_person, true), attribute(decision_imposes_art_50_2_c_measure, true)]).

settled_judgements([attribute(breach_materiality_gravity_duration_relevant, true), attribute(degree_of_responsibility_relevant, false), attribute(financial_strength_relevant, true), attribute(profits_gained_or_losses_avoided_relevant, false), attribute(third_party_losses_relevant, false), attribute(cooperation_with_authority_relevant, true), attribute(previous_breaches_relevant, true)]).

unsure_judgements([attribute(breach_materiality_gravity_duration_relevant, true), attribute(degree_of_responsibility_relevant, unsure), attribute(financial_strength_relevant, true), attribute(profits_gained_or_losses_avoided_relevant, false), attribute(third_party_losses_relevant, false), attribute(cooperation_with_authority_relevant, true), attribute(previous_breaches_relevant, true)]).

with_settled_rest(OptionFacts, Profile) :-
    other_facts(OtherFacts),
    settled_judgements(Judgements),
    append([OptionFacts, OtherFacts, Judgements], Profile).

dora_penalties_profile_for(option_used, Profile) :-
    with_settled_rest([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true)], Profile).
dora_penalties_profile_for(option_not_used, Profile) :-
    with_settled_rest([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, false)], Profile).
dora_penalties_profile_for(breach_not_criminally_penalised, Profile) :-
    with_settled_rest([attribute(breach_subject_to_criminal_penalties_under_national_law, false), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true)], Profile).
dora_penalties_profile_for(breach_criminal_choice_absent, Profile) :-
    with_settled_rest([attribute(breach_subject_to_criminal_penalties_under_national_law, true)], Profile).
dora_penalties_profile_for(breach_key_absent, Profile) :-
    with_settled_rest([attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true)], Profile).
dora_penalties_profile_for(fact_key_unsure, Profile) :-
    with_settled_rest([attribute(breach_subject_to_criminal_penalties_under_national_law, unsure), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true)], Profile).
dora_penalties_profile_for(duplicate_breach_key, Profile) :-
    with_settled_rest([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true), attribute(breach_subject_to_criminal_penalties_under_national_law, true)], Profile).
dora_penalties_profile_for(unknown_key_given, Profile) :-
    with_settled_rest([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true), attribute(colour, blue)], Profile).
dora_penalties_profile_for(judgement_unsure, Profile) :-
    other_facts(OtherFacts),
    unsure_judgements(Judgements),
    append([[attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, false)], OtherFacts, Judgements], Profile).
dora_penalties_profile_for(no_criminal_penalties_laid_down, Profile) :-
    settled_judgements(Judgements),
    append([[attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, false), attribute(member_state_laid_down_criminal_penalties_for_breaches, false), attribute(national_law_permits_requiring_data_traffic_records, false), attribute(measures_applied_to_legal_person, false), attribute(decision_imposes_art_50_2_c_measure, false)], Judgements], Profile).

dora_penalties_assess(Subject, Result) :-
    dora_penalties_profile_for(Subject, Profile),
    decide_dora_penalties(Profile, Result).
