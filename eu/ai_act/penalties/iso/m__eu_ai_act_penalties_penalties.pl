% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_penalties_penalties, [maximum_fine/4, general_purpose_ai_model_maximum_fine/4, decide_penalties/2, penalties_status/2, penalties_checklist/2, penalties_decision_resolvable/1, penalties_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_ai_act_penalties_kernel, [penalties_query_input_problems/3, penalties_date_relation/3, penalties_first_absent_key/3]).
:- use_module(m__eu_ai_act_penalties_citations, [implements/1]).

penalties_status_values([union_maximum_determined, no_union_maximum_determined, information_missing, legal_review_needed, input_rejected]).

penalties_pinned_version_start(date(2026, 7, 27), cite(eu_reg_2026_1744)).

penalties_deferred_prohibition_start(date(2026, 12, 2), cite(eu_reg_2024_1689_art_113_a)).

penalties_commission_fine_start(date(2026, 8, 2), cite(eu_reg_2024_1689_art_113)).

infringement_tier(prohibited_practice, article_99_3, [cite(eu_reg_2024_1689_art_99_3)]).
infringement_tier(prohibited_practice_under_article_5_1_ba_bb_1a_or_1b, article_99_3, [cite(eu_reg_2024_1689_art_99_3)]).
infringement_tier(provider_obligations_under_article_16, article_99_4, [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_a)]).
infringement_tier(authorised_representative_obligations_under_article_22, article_99_4, [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_b)]).
infringement_tier(importer_obligations_under_article_23, article_99_4, [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_c)]).
infringement_tier(distributor_obligations_under_article_24, article_99_4, [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_d)]).
infringement_tier(provider_and_operator_obligations_under_article_25_2_or_4, article_99_4, [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_da)]).
infringement_tier(deployer_obligations_under_article_26, article_99_4, [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_e)]).
infringement_tier(notified_body_requirements_and_obligations, article_99_4, [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_f)]).
infringement_tier(transparency_obligations_under_article_50, article_99_4, [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_g)]).
infringement_tier(incorrect_incomplete_or_misleading_information, article_99_5, [cite(eu_reg_2024_1689_art_99_5)]).
infringement_tier(other_infringement, no_tier, [cite(eu_reg_2024_1689_art_99_3), cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_5)]).

national_category(micro_small_or_medium_sized_enterprise).
national_category(small_mid_cap_enterprise).
national_category(other_undertaking).
national_category(not_an_undertaking).

undertaking_category(micro_small_or_medium_sized_enterprise).
undertaking_category(small_mid_cap_enterprise).
undertaking_category(other_undertaking).

commission_act(infringed_relevant_provisions, cite(eu_reg_2024_1689_art_101_1_a)).
commission_act(information_request_not_complied_with_or_incorrect_information, cite(eu_reg_2024_1689_art_101_1_b)).
commission_act(measure_under_article_93_not_complied_with, cite(eu_reg_2024_1689_art_101_1_c)).
commission_act(access_for_evaluation_under_article_92_not_given, cite(eu_reg_2024_1689_art_101_1_d)).

key_reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_reading(Profile, Key, present(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

reading_is_t(absent, _, false).
reading_is_t(present(Value), Wanted, Truth) :-
    memberd_t(Value, [Wanted], Truth).

or_truth(true, _, true).
or_truth(false, Truth, Truth).

turnover_percent_eur_cents(TurnoverEur, Percent, PercentCents) :-
    PercentCents #= TurnoverEur * Percent.

bounded_maximum(higher, FixedCents, PercentCents, fine_maximum(FixedCents, fixed_amount)) :-
    FixedCents #>= PercentCents.
bounded_maximum(higher, FixedCents, PercentCents, fine_maximum(PercentCents, turnover_percentage)) :-
    FixedCents #< PercentCents.
bounded_maximum(lower, FixedCents, PercentCents, fine_maximum(FixedCents, fixed_amount)) :-
    FixedCents #=< PercentCents.
bounded_maximum(lower, FixedCents, PercentCents, fine_maximum(PercentCents, turnover_percentage)) :-
    FixedCents #> PercentCents.

maximum_fine(Profile, InfringementDate, Maximum, Citations) :-
    penalties_query_input_problems(Profile, InfringementDate, Problems),
    maximum_fine_checked(Problems, Profile, InfringementDate, Maximum, Citations).

maximum_fine_checked([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
maximum_fine_checked([], Profile, InfringementDate, Maximum, Citations) :-
    penalties_pinned_version_start(VersionStart, _),
    penalties_date_relation(InfringementDate, VersionStart, VersionRelation),
    maximum_fine_by_version(VersionRelation, Profile, InfringementDate, Maximum, Citations).

maximum_fine_by_version(before, _, _, earlier_version_applies, []) :-
    implements(eu_reg_2026_1744).
maximum_fine_by_version(on_or_after, Profile, InfringementDate, Maximum, Citations) :-
    implements(eu_reg_2024_1689_art_113_b),
    penalties_deferred_prohibition_start(DeferralEnd, _),
    penalties_date_relation(InfringementDate, DeferralEnd, DeferralRelation),
    key_reading(Profile, offender_category, OffenderReading),
    key_reading(Profile, infringement, InfringementReading),
    deferred_prohibition_t(DeferralRelation, InfringementReading, Deferred),
    deferral_route(Deferred, DeferralRelation, OffenderReading, InfringementReading, Profile, Maximum, Citations).

deferred_prohibition_t(before, present(Infringement), Truth) :-
    implements(eu_reg_2024_1689_art_113_a),
    memberd_t(Infringement, [prohibited_practice_under_article_5_1_ba_bb_1a_or_1b], Truth).
deferred_prohibition_t(before, absent, false) :-
    implements(eu_reg_2024_1689_art_113_a).
deferred_prohibition_t(on_or_after, _, false) :-
    implements(eu_reg_2024_1689_art_113_a).

deferral_route(true, _, _, _, _, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)]) :-
    implements(eu_reg_2024_1689_art_113_a).
deferral_route(false, DeferralRelation, OffenderReading, InfringementReading, Profile, Maximum, Citations) :-
    public_authority_t(OffenderReading, InfringementReading, DeferralRelation, PublicAuthority),
    public_authority_route(PublicAuthority, Profile, Maximum, Citations).

public_authority_t(present(Category), InfringementReading, DeferralRelation, Truth) :-
    implements(eu_reg_2024_1689_art_99_8),
    memberd_t(Category, [public_authority_or_body], IsPublicAuthority),
    public_authority_reach(IsPublicAuthority, InfringementReading, DeferralRelation, Truth).
public_authority_t(absent, _, _, false) :-
    implements(eu_reg_2024_1689_art_99_8).

public_authority_reach(false, _, _, false).
public_authority_reach(true, present(_), _, true).
public_authority_reach(true, absent, on_or_after, true).
public_authority_reach(true, absent, before, false).

public_authority_route(true, _, set_by_member_state_rules, [cite(eu_reg_2024_1689_art_99_8)]) :-
    implements(eu_reg_2024_1689_art_99_8).
public_authority_route(false, Profile, Maximum, Citations) :-
    penalties_first_absent_key(Profile, [offender_category, infringement], AbsentResult),
    presence_route(AbsentResult, Profile, Maximum, Citations).

presence_route(first_absent(MissingKey), _, indeterminate([MissingKey]), []).
presence_route(none_absent, Profile, Maximum, Citations) :-
    profile_get(Profile, offender_category, Category),
    profile_get(Profile, infringement, Infringement),
    category_route(Category, Infringement, Profile, Maximum, Citations).

category_route(union_institution_body_office_or_agency, Infringement, _, Maximum, Citations) :-
    implements(eu_reg_2024_1689_art_100_1),
    infringement_tier(Infringement, Tier, _),
    union_institution_maximum(Tier, Maximum, Citations).
category_route(Category, Infringement, Profile, Maximum, Citations) :-
    national_category(Category),
    infringement_tier(Infringement, Tier, TierCitations),
    national_route(Tier, Category, Profile, TierCitations, Maximum, Citations).

union_institution_maximum(article_99_3, fine_maximum(FixedCents, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_2)]) :-
    implements(eu_reg_2024_1689_art_100_2),
    FixedCents #= 150000000.
union_institution_maximum(Tier, fine_maximum(FixedCents, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_3)]) :-
    implements(eu_reg_2024_1689_art_100_3),
    member(Tier, [article_99_4, article_99_5, no_tier]),
    FixedCents #= 75000000.

national_route(no_tier, _, _, TierCitations, no_union_maximum, TierCitations) :-
    implements(eu_reg_2024_1689_art_99_1).
national_route(Tier, Category, Profile, TierCitations, Maximum, Citations) :-
    member(Tier, [article_99_3, article_99_4, article_99_5]),
    tier_maximum(Tier, Category, Profile, TierCitations, Maximum, Citations).

tier_maximum(article_99_3, not_an_undertaking, _, TierCitations, fine_maximum(FixedCents, fixed_amount), TierCitations) :-
    implements(eu_reg_2024_1689_art_99_3),
    FixedCents #= 3500000000.
tier_maximum(article_99_3, Category, Profile, TierCitations, Maximum, Citations) :-
    implements(eu_reg_2024_1689_art_99_3),
    undertaking_category(Category),
    FixedCents #= 3500000000,
    Percent #= 7,
    undertaking_maximum(Profile, Category, article_99_3, FixedCents, Percent, TierCitations, Maximum, Citations).
tier_maximum(article_99_4, not_an_undertaking, _, TierCitations, fine_maximum(FixedCents, fixed_amount), TierCitations) :-
    implements(eu_reg_2024_1689_art_99_4),
    FixedCents #= 1500000000.
tier_maximum(article_99_4, Category, Profile, TierCitations, Maximum, Citations) :-
    implements(eu_reg_2024_1689_art_99_4),
    undertaking_category(Category),
    FixedCents #= 1500000000,
    Percent #= 3,
    undertaking_maximum(Profile, Category, article_99_4, FixedCents, Percent, TierCitations, Maximum, Citations).
tier_maximum(article_99_5, not_an_undertaking, _, TierCitations, fine_maximum(FixedCents, fixed_amount), TierCitations) :-
    implements(eu_reg_2024_1689_art_99_5),
    FixedCents #= 750000000.
tier_maximum(article_99_5, Category, Profile, TierCitations, Maximum, Citations) :-
    implements(eu_reg_2024_1689_art_99_5),
    undertaking_category(Category),
    FixedCents #= 750000000,
    Percent #= 1,
    undertaking_maximum(Profile, Category, article_99_5, FixedCents, Percent, TierCitations, Maximum, Citations).

undertaking_maximum(Profile, Category, Tier, FixedCents, Percent, TierCitations, Maximum, Citations) :-
    key_reading(Profile, worldwide_annual_turnover_eur, TurnoverReading),
    turnover_maximum(TurnoverReading, Category, Tier, FixedCents, Percent, TierCitations, Maximum, Citations).

turnover_maximum(absent, _, _, _, _, _, indeterminate([worldwide_annual_turnover_eur]), []).
turnover_maximum(present(TurnoverEur), Category, Tier, FixedCents, Percent, TierCitations, Maximum, Citations) :-
    comparison_rule(Category, Tier, Rule, ReliefCitations),
    turnover_percent_eur_cents(TurnoverEur, Percent, PercentCents),
    bounded_maximum(Rule, FixedCents, PercentCents, Maximum),
    append(TierCitations, ReliefCitations, Citations).

comparison_rule(other_undertaking, article_99_3, higher, []) :-
    implements(eu_reg_2024_1689_art_99_3).
comparison_rule(other_undertaking, article_99_4, higher, []) :-
    implements(eu_reg_2024_1689_art_99_4).
comparison_rule(other_undertaking, article_99_5, higher, []) :-
    implements(eu_reg_2024_1689_art_99_5).
comparison_rule(micro_small_or_medium_sized_enterprise, Tier, lower, [cite(eu_reg_2024_1689_art_99_6)]) :-
    implements(eu_reg_2024_1689_art_99_6),
    member(Tier, [article_99_3, article_99_4, article_99_5]).
comparison_rule(small_mid_cap_enterprise, article_99_3, higher, []) :-
    implements(eu_reg_2024_1689_art_99_3).
comparison_rule(small_mid_cap_enterprise, Tier, lower, [cite(eu_reg_2024_1689_art_99_6a)]) :-
    implements(eu_reg_2024_1689_art_99_6a),
    member(Tier, [article_99_4, article_99_5]).

general_purpose_ai_model_maximum_fine(Profile, InfringementDate, Maximum, Citations) :-
    penalties_query_input_problems(Profile, InfringementDate, Problems),
    model_fine_checked(Problems, Profile, InfringementDate, Maximum, Citations).

model_fine_checked([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
model_fine_checked([], Profile, InfringementDate, Maximum, Citations) :-
    penalties_commission_fine_start(CommissionStart, _),
    penalties_date_relation(InfringementDate, CommissionStart, CommissionRelation),
    model_fine_by_date(CommissionRelation, Profile, Maximum, Citations).

model_fine_by_date(before, _, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_b)]) :-
    implements(eu_reg_2024_1689_art_113_b).
model_fine_by_date(on_or_after, Profile, Maximum, Citations) :-
    implements(eu_reg_2024_1689_art_101_1),
    key_reading(Profile, offender_is_general_purpose_ai_model_provider, ProviderReading),
    key_reading(Profile, general_purpose_ai_model_infringement, ActReading),
    key_reading(Profile, provider_acted_intentionally_or_negligently, FaultReading),
    reading_is_t(ProviderReading, false, NotProvider),
    reading_is_t(ActReading, none_of_article_101_1, NoAct),
    reading_is_t(FaultReading, false, NoFault),
    or_truth(NotProvider, NoAct, NoProviderOrAct),
    or_truth(NoProviderOrAct, NoFault, NoFine),
    commission_route(NoFine, Profile, FaultReading, ActReading, Maximum, Citations).

commission_route(true, _, _, _, no_commission_fine, [cite(eu_reg_2024_1689_art_101_1)]) :-
    implements(eu_reg_2024_1689_art_101_1).
commission_route(false, Profile, FaultReading, ActReading, Maximum, Citations) :-
    penalties_first_absent_key(Profile, [offender_is_general_purpose_ai_model_provider, general_purpose_ai_model_infringement, provider_acted_intentionally_or_negligently, worldwide_annual_turnover_eur], AbsentResult),
    commission_presence_route(AbsentResult, Profile, FaultReading, ActReading, Maximum, Citations).

commission_presence_route(first_absent(MissingKey), _, _, _, indeterminate([MissingKey]), []).
commission_presence_route(none_absent, Profile, FaultReading, ActReading, Maximum, Citations) :-
    commission_fault_route(FaultReading, ActReading, Profile, Maximum, Citations).

commission_fault_route(present(unsure), _, _, needs_legal_review(open_textured(provider_acted_intentionally_or_negligently, cite(eu_reg_2024_1689_art_101_1)), [inputs_relied_on([provider_acted_intentionally_or_negligently - unsure])]), []) :-
    implements(eu_reg_2024_1689_art_101_1).
commission_fault_route(present(true), present(Act), Profile, Maximum, [cite(eu_reg_2024_1689_art_101_1), ActCitation]) :-
    implements(eu_reg_2024_1689_art_101_1),
    commission_act(Act, ActCitation),
    profile_get(Profile, worldwide_annual_turnover_eur, TurnoverEur),
    FixedCents #= 1500000000,
    Percent #= 3,
    turnover_percent_eur_cents(TurnoverEur, Percent, PercentCents),
    bounded_maximum(higher, FixedCents, PercentCents, Maximum).

decide_penalties(maximum_fine(Profile, InfringementDate), penalties_verdict(Status, Maximum, Citations)) :-
    maximum_fine(Profile, InfringementDate, Maximum, Citations),
    maximum_statuses(Maximum, Status, _, _).
decide_penalties(general_purpose_ai_model_maximum_fine(Profile, InfringementDate), penalties_verdict(Status, Maximum, Citations)) :-
    general_purpose_ai_model_maximum_fine(Profile, InfringementDate, Maximum, Citations),
    maximum_statuses(Maximum, Status, _, _).

maximum_statuses(fine_maximum(_, _), union_maximum_determined, met, met).
maximum_statuses(Maximum, no_union_maximum_determined, met, met) :-
    member(Maximum, [no_union_maximum, set_by_member_state_rules, not_applicable_on_date, earlier_version_applies, no_commission_fine]).
maximum_statuses(indeterminate(MissingKeys), information_missing, met, unknown(MissingKeys)).
maximum_statuses(needs_legal_review(open_textured(ReviewKey, _), _), legal_review_needed, met, unknown([ReviewKey])).
maximum_statuses(input_problems(Problems), input_rejected, unmet(input_problems(Problems)), unmet(input_rejected)).

penalties_status(Request, Status) :-
    decide_penalties(Request, penalties_verdict(Status, _, _)).

penalties_checklist(Request, [item(input_check, InputStatus, []), item(maximum, MaximumStatus, Citations)]) :-
    decide_penalties(Request, penalties_verdict(_, Maximum, Citations)),
    maximum_statuses(Maximum, _, InputStatus, MaximumStatus).

penalties_decision_resolvable(Request) :-
    decide_penalties(Request, _).

test(an_undertaking_prohibition_takes_the_higher_turnover_amount) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice), attribute(worldwide_annual_turnover_eur, 1000000000)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [fine_maximum(7000000000, turnover_percentage) - [cite(eu_reg_2024_1689_art_99_3)]].
test(an_sme_takes_the_lower_amount) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, micro_small_or_medium_sized_enterprise), attribute(infringement, provider_obligations_under_article_16), attribute(worldwide_annual_turnover_eur, 100000000)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [fine_maximum(300000000, turnover_percentage) - [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_a), cite(eu_reg_2024_1689_art_99_6)]].
test(an_smc_prohibition_keeps_the_higher_amount) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, small_mid_cap_enterprise), attribute(infringement, prohibited_practice), attribute(worldwide_annual_turnover_eur, 100000000)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [fine_maximum(3500000000, fixed_amount) - [cite(eu_reg_2024_1689_art_99_3)]].
test(an_smc_information_breach_takes_the_lower_amount) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, small_mid_cap_enterprise), attribute(infringement, incorrect_incomplete_or_misleading_information), attribute(worldwide_annual_turnover_eur, 100000000)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [fine_maximum(100000000, turnover_percentage) - [cite(eu_reg_2024_1689_art_99_5), cite(eu_reg_2024_1689_art_99_6a)]].
test(equal_amounts_give_the_fixed_amount_basis) :-
    findall(Maximum, maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, incorrect_incomplete_or_misleading_information), attribute(worldwide_annual_turnover_eur, 750000000)], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [fine_maximum(750000000, fixed_amount)].
test(an_offender_not_an_undertaking_takes_the_fixed_amount) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, not_an_undertaking), attribute(infringement, deployer_obligations_under_article_26)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [fine_maximum(1500000000, fixed_amount) - [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_e)]].
test(an_absent_turnover_is_indeterminate) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, deployer_obligations_under_article_26)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [indeterminate([worldwide_annual_turnover_eur]) - []].
test(an_empty_profile_names_the_first_key) :-
    findall(Maximum, maximum_fine([], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [indeterminate([offender_category])].
test(other_infringement_has_no_union_maximum) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, other_infringement)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [no_union_maximum - [cite(eu_reg_2024_1689_art_99_3), cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_5)]].
test(a_date_before_the_pinned_version_is_the_earlier_version) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, other_undertaking)], date(2026, 7, 26), Maximum, Citations), Answers),
    Answers == [earlier_version_applies - []].
test(a_deferred_prohibition_before_december_is_not_applicable) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, public_authority_or_body), attribute(infringement, prohibited_practice_under_article_5_1_ba_bb_1a_or_1b)], date(2026, 11, 1), Maximum, Citations), Answers),
    Answers == [not_applicable_on_date - [cite(eu_reg_2024_1689_art_113_a)]].
test(a_deferred_prohibition_from_december_is_for_member_state_rules) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, public_authority_or_body), attribute(infringement, prohibited_practice_under_article_5_1_ba_bb_1a_or_1b)], date(2026, 12, 2), Maximum, Citations), Answers),
    Answers == [set_by_member_state_rules - [cite(eu_reg_2024_1689_art_99_8)]].
test(a_public_authority_without_infringement_before_december_is_indeterminate) :-
    findall(Maximum, maximum_fine([attribute(offender_category, public_authority_or_body)], date(2026, 11, 1), Maximum, _), Answers),
    Answers == [indeterminate([infringement])].
test(a_public_authority_without_infringement_from_december_is_for_member_state_rules) :-
    findall(Maximum, maximum_fine([attribute(offender_category, public_authority_or_body)], date(2026, 12, 2), Maximum, _), Answers),
    Answers == [set_by_member_state_rules].
test(a_union_institution_prohibition_is_capped_by_article_100_2) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, union_institution_body_office_or_agency), attribute(infringement, prohibited_practice)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [fine_maximum(150000000, fixed_amount) - [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_2)]].
test(a_union_institution_other_infringement_is_capped_by_article_100_3) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, union_institution_body_office_or_agency), attribute(infringement, other_infringement)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [fine_maximum(75000000, fixed_amount) - [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_3)]].
test(input_problems_come_first) :-
    findall(Maximum - Citations, maximum_fine([attribute(colour, red)], date(2026, 13, 1), Maximum, Citations), Answers),
    Answers == [input_problems([unknown_key(colour), wrong_type(infringement_date)]) - []].
test(a_model_fine_before_august_is_not_applicable) :-
    findall(Maximum - Citations, general_purpose_ai_model_maximum_fine([], date(2026, 7, 1), Maximum, Citations), Answers),
    Answers == [not_applicable_on_date - [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_b)]].
test(a_non_provider_has_no_commission_fine) :-
    findall(Maximum - Citations, general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, false), attribute(provider_acted_intentionally_or_negligently, unsure)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [no_commission_fine - [cite(eu_reg_2024_1689_art_101_1)]].
test(a_missing_act_is_named_before_an_unsure_judgement) :-
    findall(Maximum, general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true), attribute(provider_acted_intentionally_or_negligently, unsure)], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [indeterminate([general_purpose_ai_model_infringement])].
test(an_unsure_judgement_goes_to_review) :-
    findall(Maximum - Citations, general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true), attribute(general_purpose_ai_model_infringement, infringed_relevant_provisions), attribute(provider_acted_intentionally_or_negligently, unsure), attribute(worldwide_annual_turnover_eur, 1000000000)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [needs_legal_review(open_textured(provider_acted_intentionally_or_negligently, cite(eu_reg_2024_1689_art_101_1)), [inputs_relied_on([provider_acted_intentionally_or_negligently - unsure])]) - []].
test(a_model_fine_takes_the_higher_amount) :-
    findall(Maximum - Citations, general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true), attribute(general_purpose_ai_model_infringement, infringed_relevant_provisions), attribute(provider_acted_intentionally_or_negligently, true), attribute(worldwide_annual_turnover_eur, 1000000000)], date(2026, 9, 1), Maximum, Citations), Answers),
    Answers == [fine_maximum(3000000000, turnover_percentage) - [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_a)]].
test(a_small_model_provider_takes_the_fixed_amount) :-
    findall(Maximum, general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true), attribute(general_purpose_ai_model_infringement, measure_under_article_93_not_complied_with), attribute(provider_acted_intentionally_or_negligently, true), attribute(worldwide_annual_turnover_eur, 1000)], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [fine_maximum(1500000000, fixed_amount)].
test(the_verdict_status_of_a_determined_maximum) :-
    penalties_status(maximum_fine([attribute(offender_category, not_an_undertaking), attribute(infringement, prohibited_practice)], date(2026, 9, 1)), union_maximum_determined).
test(the_checklist_names_the_missing_key) :-
    penalties_checklist(maximum_fine([], date(2026, 9, 1)), Items),
    Items == [item(input_check, met, []), item(maximum, unknown([offender_category]), [])].
test(a_rejected_input_is_resolvable_as_rejected) :-
    penalties_status(general_purpose_ai_model_maximum_fine(not_a_profile, date(2026, 9, 1)), input_rejected).

test(an_undertaking_prohibition_is_not_the_fixed_amount, fail) :-
    maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice), attribute(worldwide_annual_turnover_eur, 1000000000)], date(2026, 9, 1), fine_maximum(3500000000, fixed_amount), _).
test(an_smc_prohibition_is_not_the_lower_amount, fail) :-
    maximum_fine([attribute(offender_category, small_mid_cap_enterprise), attribute(infringement, prohibited_practice), attribute(worldwide_annual_turnover_eur, 100000000)], date(2026, 9, 1), fine_maximum(700000000, turnover_percentage), _).
test(the_pinned_version_start_is_not_earlier, fail) :-
    maximum_fine([], date(2026, 7, 27), earlier_version_applies, _).
test(a_model_fine_on_the_second_of_august_applies, fail) :-
    general_purpose_ai_model_maximum_fine([], date(2026, 8, 2), not_applicable_on_date, _).
