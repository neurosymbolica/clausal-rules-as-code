% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_cra_administrative_fines, [administrative_fine_maximum/4, decide_cra_administrative_fines/2, cra_administrative_fines_status/2, cra_administrative_fines_checklist/2, cra_administrative_fines_decision_resolvable/1, cra_administrative_fines_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_cra_administrative_fines_kernel, [cra_administrative_fines_input_problems/2, cra_administrative_fines_calendar_day_t/2]).
:- use_module(m__eu_cra_administrative_fines_citations, [implements/1]).

application_date(date(2027, 12, 11), cite(eu_reg_2024_2847_art_71_2)).

provision_tier(annex_i_essential_cybersecurity_requirements, highest_maximum_tier, cite(eu_reg_2024_2847_art_64_2)).
provision_tier(article_13, highest_maximum_tier, cite(eu_reg_2024_2847_art_64_2)).
provision_tier(article_14, highest_maximum_tier, cite(eu_reg_2024_2847_art_64_2)).
provision_tier(article_18, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_19, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_20, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_21, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_22, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_23, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_28, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_30_paragraphs_1_to_4, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_31_paragraphs_1_to_4, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_32_paragraphs_1_to_3, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_33_paragraph_5, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_39, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_41, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_47, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_49, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(article_53, middle_maximum_tier, cite(eu_reg_2024_2847_art_64_3)).
provision_tier(incorrect_incomplete_or_misleading_information_in_reply_to_request, lowest_maximum_tier, cite(eu_reg_2024_2847_art_64_4)).

tier_maximum(highest_maximum_tier, 1500000000, 5, 2, cite(eu_reg_2024_2847_art_64_2)).
tier_maximum(middle_maximum_tier, 1000000000, 2, 1, cite(eu_reg_2024_2847_art_64_3)).
tier_maximum(lowest_maximum_tier, 500000000, 1, 1, cite(eu_reg_2024_2847_art_64_4)).

derogation_reach(highest_maximum_tier, steward_not_read, cite(eu_reg_2024_2847_art_64_10)).
derogation_reach(middle_maximum_tier, steward_read, cite(eu_reg_2024_2847_art_64_10)).
derogation_reach(lowest_maximum_tier, steward_read, cite(eu_reg_2024_2847_art_64_10)).

point_a_deadline_provision(article_14, cite(eu_reg_2024_2847_art_64_10_a)).

cra_administrative_fines_status_values([fine_maximum/3, fine_excluded/1, not_listed_in_article_64/0, not_yet_applicable/0, indeterminate/1, needs_legal_review/2, input_problems/1]).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, present(Value)) :-
    profile_get(Profile, Key, Value).

request_problems(Profile, InfringementDate, Problems) :-
    cra_administrative_fines_input_problems(Profile, ProfileProblems),
    cra_administrative_fines_calendar_day_t(InfringementDate, IsCalendarDay),
    argument_problems(IsCalendarDay, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems).

argument_problems(true, []).
argument_problems(false, [wrong_type(infringement_date)]).

administrative_fine_maximum(Profile, InfringementDate, Verdict, Citations) :-
    request_problems(Profile, InfringementDate, Problems),
    checked_answer(Problems, Profile, InfringementDate, Verdict, Citations).

checked_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
checked_answer([], Profile, InfringementDate, Verdict, Citations) :-
    dated_answer(Profile, InfringementDate, Verdict, Citations).

dated_answer(_, InfringementDate, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(ApplicationDate, cite(eu_reg_2024_2847_art_71_2)),
    InfringementDate @< ApplicationDate.
dated_answer(Profile, InfringementDate, Verdict, Citations) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(ApplicationDate, cite(eu_reg_2024_2847_art_71_2)),
    InfringementDate @>= ApplicationDate,
    key_state(Profile, infringed_provision, ProvisionState),
    provision_answer(ProvisionState, Profile, Verdict, Citations).

provision_answer(absent, _, indeterminate([infringed_provision]), []).
provision_answer(present(other_provision), _, not_listed_in_article_64, [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)]) :-
    implements(eu_reg_2024_2847_art_64_1).
provision_answer(present(Provision), Profile, Verdict, Citations) :-
    implements(eu_reg_2024_2847_art_64_10),
    provision_tier(Provision, Tier, _TierCitation),
    tier_terms(Tier, Terms),
    derogation_reach(Tier, Reach, cite(eu_reg_2024_2847_art_64_10)),
    steward_answer(Reach, Profile, Terms, Verdict, Citations).

tier_terms(highest_maximum_tier, terms(highest_maximum_tier, FixedEuroCents, Numerator, Denominator, eu_reg_2024_2847_art_64_2)) :-
    implements(eu_reg_2024_2847_art_64_2),
    tier_maximum(highest_maximum_tier, FixedEuroCents, Numerator, Denominator, cite(eu_reg_2024_2847_art_64_2)).
tier_terms(middle_maximum_tier, terms(middle_maximum_tier, FixedEuroCents, Numerator, Denominator, eu_reg_2024_2847_art_64_3)) :-
    implements(eu_reg_2024_2847_art_64_3),
    tier_maximum(middle_maximum_tier, FixedEuroCents, Numerator, Denominator, cite(eu_reg_2024_2847_art_64_3)).
tier_terms(lowest_maximum_tier, terms(lowest_maximum_tier, FixedEuroCents, Numerator, Denominator, eu_reg_2024_2847_art_64_4)) :-
    implements(eu_reg_2024_2847_art_64_4),
    tier_maximum(lowest_maximum_tier, FixedEuroCents, Numerator, Denominator, cite(eu_reg_2024_2847_art_64_4)).

steward_answer(steward_not_read, Profile, Terms, Verdict, Citations) :-
    implements(eu_reg_2024_2847_art_64_10),
    undertaking_answer(Profile, Terms, steward_not_read, Verdict, Citations).
steward_answer(steward_read, Profile, Terms, Verdict, Citations) :-
    implements(eu_reg_2024_2847_art_64_10_b),
    implements(eu_reg_2024_2847_art_3_14),
    implements(eu_reg_2024_2847_art_3_48),
    key_state(Profile, offender_is_open_source_software_steward, StewardState),
    steward_value_answer(StewardState, Profile, Terms, Verdict, Citations).

steward_value_answer(absent, _, _, indeterminate([offender_is_open_source_software_steward]), []).
steward_value_answer(present(true), _, _, fine_excluded(open_source_software_steward), [cite(eu_reg_2024_2847_art_64_10_b)]) :-
    implements(eu_reg_2024_2847_art_64_10_b).
steward_value_answer(present(false), Profile, Terms, Verdict, Citations) :-
    undertaking_answer(Profile, Terms, steward(false), Verdict, Citations).
steward_value_answer(present(unsure), Profile, Terms, Verdict, Citations) :-
    undertaking_answer(Profile, Terms, steward(unsure), Verdict, Citations).

undertaking_answer(Profile, Terms, Steward, Verdict, Citations) :-
    key_state(Profile, offender_is_undertaking, UndertakingState),
    undertaking_value_answer(UndertakingState, Profile, Terms, Steward, Verdict, Citations).

undertaking_value_answer(absent, _, _, _, indeterminate([offender_is_undertaking]), []).
undertaking_value_answer(present(false), _, Terms, Steward, Verdict, Citations) :-
    referral_or_final(Steward, false, turnover_not_read, Terms, Verdict, Citations).
undertaking_value_answer(present(true), Profile, Terms, Steward, Verdict, Citations) :-
    turnover_answer(Profile, Terms, Steward, true, Verdict, Citations).
undertaking_value_answer(present(unsure), Profile, Terms, Steward, Verdict, Citations) :-
    turnover_answer(Profile, Terms, Steward, unsure, Verdict, Citations).

turnover_answer(Profile, Terms, Steward, Undertaking, Verdict, Citations) :-
    key_state(Profile, total_worldwide_annual_turnover_in_euros, TurnoverState),
    turnover_value_answer(TurnoverState, Terms, Steward, Undertaking, Verdict, Citations).

turnover_value_answer(absent, _, _, _, indeterminate([total_worldwide_annual_turnover_in_euros]), []).
turnover_value_answer(present(TurnoverEuros), Terms, Steward, Undertaking, Verdict, Citations) :-
    referral_or_final(Steward, Undertaking, turnover(TurnoverEuros), Terms, Verdict, Citations).

referral_or_final(steward(unsure), Undertaking, _, _, needs_legal_review(open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2024_2847_art_64_10_b),
    relied_pairs(steward(unsure), Undertaking, Pairs).
referral_or_final(Steward, unsure, _, terms(_, _, _, _, TierKey), needs_legal_review(open_textured(offender_is_undertaking, cite(TierKey)), [inputs_relied_on(Pairs)]), []) :-
    steward_settled(Steward),
    relied_pairs(Steward, unsure, Pairs).
referral_or_final(Steward, false, turnover_not_read, terms(Tier, FixedEuroCents, _, _, TierKey), fine_maximum(Tier, fixed_amount_for_non_undertaking, FixedEuroCents), [cite(TierKey)]) :-
    steward_settled(Steward).
referral_or_final(Steward, true, turnover(TurnoverEuros), terms(Tier, FixedEuroCents, Numerator, Denominator, TierKey), fine_maximum(Tier, percentage_of_turnover, PercentageEuroCents), [cite(TierKey)]) :-
    steward_settled(Steward),
    PercentageEuroCents #= TurnoverEuros * Numerator // Denominator,
    PercentageEuroCents #> FixedEuroCents.
referral_or_final(Steward, true, turnover(TurnoverEuros), terms(Tier, FixedEuroCents, Numerator, Denominator, TierKey), fine_maximum(Tier, fixed_amount, FixedEuroCents), [cite(TierKey)]) :-
    steward_settled(Steward),
    PercentageEuroCents #= TurnoverEuros * Numerator // Denominator,
    PercentageEuroCents #=< FixedEuroCents.

steward_settled(steward_not_read).
steward_settled(steward(false)).

relied_pairs(steward_not_read, Undertaking, [offender_is_undertaking - Undertaking]).
relied_pairs(steward(Steward), Undertaking, [offender_is_open_source_software_steward - Steward, offender_is_undertaking - Undertaking]).

decide_cra_administrative_fines(infringement(Profile, InfringementDate), cra_administrative_fines_verdict(Verdict, Citations)) :-
    administrative_fine_maximum(Profile, InfringementDate, Verdict, Citations).

cra_administrative_fines_status(Request, Status) :-
    decide_cra_administrative_fines(Request, cra_administrative_fines_verdict(Status, _Citations)).

cra_administrative_fines_decision_resolvable(Request) :-
    decide_cra_administrative_fines(Request, _Verdict).

cra_administrative_fines_checklist(infringement(Profile, InfringementDate), Items) :-
    request_problems(Profile, InfringementDate, Problems),
    checklist_for(Problems, Profile, InfringementDate, Items).

checklist_for([Problem|Problems], _, _, [item(well_formed_input, unmet(input_problems([Problem|Problems])), [])]).
checklist_for([], Profile, InfringementDate, [item(well_formed_input, met, []), DateItem, ProvisionItem, StewardItem, MaximumItem]) :-
    date_item(InfringementDate, DateItem),
    key_state(Profile, infringed_provision, ProvisionState),
    provision_item(ProvisionState, ProvisionItem),
    steward_item(ProvisionState, Profile, StewardItem),
    administrative_fine_maximum(Profile, InfringementDate, Verdict, Citations),
    MaximumItem = item(administrative_fine_maximum, value(Verdict), Citations).

date_item(InfringementDate, item(date_of_application, met, [cite(eu_reg_2024_2847_art_71_2)])) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(ApplicationDate, cite(eu_reg_2024_2847_art_71_2)),
    InfringementDate @>= ApplicationDate.
date_item(InfringementDate, item(date_of_application, unmet(not_yet_applicable), [cite(eu_reg_2024_2847_art_71_2)])) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(ApplicationDate, cite(eu_reg_2024_2847_art_71_2)),
    InfringementDate @< ApplicationDate.

provision_item(absent, item(tier_of_infringed_provision, absent([infringed_provision]), [])).
provision_item(present(other_provision), item(tier_of_infringed_provision, unmet(not_listed_in_article_64), [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)])) :-
    implements(eu_reg_2024_2847_art_64_1).
provision_item(present(Provision), item(tier_of_infringed_provision, value(Tier), [TierCitation])) :-
    implements(eu_reg_2024_2847_art_64_10),
    provision_tier(Provision, Tier, TierCitation).

steward_item(absent, _, item(open_source_software_steward_derogation, absent([infringed_provision]), [cite(eu_reg_2024_2847_art_64_10_b)])).
steward_item(present(other_provision), _, item(open_source_software_steward_derogation, inapplicable, [cite(eu_reg_2024_2847_art_64_10_b)])).
steward_item(present(Provision), Profile, Item) :-
    implements(eu_reg_2024_2847_art_64_10),
    provision_tier(Provision, Tier, _TierCitation),
    derogation_reach(Tier, Reach, cite(eu_reg_2024_2847_art_64_10)),
    steward_reach_item(Reach, Profile, Item).

steward_reach_item(steward_not_read, _, item(open_source_software_steward_derogation, inapplicable, [cite(eu_reg_2024_2847_art_64_10_b)])).
steward_reach_item(steward_read, Profile, Item) :-
    implements(eu_reg_2024_2847_art_64_10_b),
    key_state(Profile, offender_is_open_source_software_steward, StewardState),
    steward_state_item(StewardState, Item).

steward_state_item(absent, item(open_source_software_steward_derogation, absent([offender_is_open_source_software_steward]), [cite(eu_reg_2024_2847_art_64_10_b)])).
steward_state_item(present(true), item(open_source_software_steward_derogation, unmet(fine_excluded(open_source_software_steward)), [cite(eu_reg_2024_2847_art_64_10_b)])).
steward_state_item(present(false), item(open_source_software_steward_derogation, met, [cite(eu_reg_2024_2847_art_64_10_b)])).
steward_state_item(present(unsure), item(open_source_software_steward_derogation, unknown([offender_is_open_source_software_steward]), [cite(eu_reg_2024_2847_art_64_10_b)])).

test(the_day_before_application_is_not_yet_applicable) :-
    findall(Verdict - Citations, administrative_fine_maximum([attribute(infringed_provision, article_14)], date(2027, 12, 10), Verdict, Citations), Answers),
    Answers == [not_yet_applicable - [cite(eu_reg_2024_2847_art_71_2)]].
test(an_earlier_obligation_date_is_still_not_yet_applicable) :-
    administrative_fine_maximum([attribute(infringed_provision, article_39)], date(2026, 7, 1), not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
test(the_application_day_itself_reads_the_provision) :-
    findall(Verdict - Citations, administrative_fine_maximum([], date(2027, 12, 11), Verdict, Citations), Answers),
    Answers == [indeterminate([infringed_provision]) - []].
test(an_unlisted_provision_is_not_listed) :-
    findall(Verdict - Citations, administrative_fine_maximum([attribute(infringed_provision, other_provision), attribute(offender_is_undertaking, true)], date(2028, 1, 1), Verdict, Citations), Answers),
    Answers == [not_listed_in_article_64 - [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)]].
test(a_steward_in_the_middle_tier_is_excluded) :-
    findall(Verdict - Citations, administrative_fine_maximum([attribute(infringed_provision, article_28), attribute(offender_is_open_source_software_steward, true)], date(2028, 1, 1), Verdict, Citations), Answers),
    Answers == [fine_excluded(open_source_software_steward) - [cite(eu_reg_2024_2847_art_64_10_b)]].
test(a_steward_in_the_lowest_tier_is_excluded) :-
    administrative_fine_maximum([attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, true)], date(2028, 1, 1), fine_excluded(open_source_software_steward), _).
test(a_steward_in_the_highest_tier_is_not_read) :-
    findall(Verdict - Citations, administrative_fine_maximum([attribute(infringed_provision, article_13), attribute(offender_is_open_source_software_steward, true), attribute(offender_is_undertaking, false)], date(2028, 1, 1), Verdict, Citations), Answers),
    Answers = [fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, CapEuroCents) - [cite(eu_reg_2024_2847_art_64_2)]],
    CapEuroCents =:= 1500000000.
test(a_missing_steward_judgement_is_asked_for_in_the_middle_tier) :-
    findall(Verdict, administrative_fine_maximum([attribute(infringed_provision, article_18), attribute(offender_is_undertaking, true)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts == [indeterminate([offender_is_open_source_software_steward])].
test(point_a_names_a_provision_of_the_highest_tier) :-
    point_a_deadline_provision(Provision, cite(eu_reg_2024_2847_art_64_10_a)),
    provision_tier(Provision, highest_maximum_tier, _),
    derogation_reach(highest_maximum_tier, steward_not_read, _).
test(a_missing_undertaking_judgement_is_asked_for) :-
    findall(Verdict, administrative_fine_maximum([attribute(infringed_provision, article_18), attribute(offender_is_open_source_software_steward, false)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts == [indeterminate([offender_is_undertaking])].
test(an_undertaking_without_turnover_is_asked_for_it) :-
    findall(Verdict, administrative_fine_maximum([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts == [indeterminate([total_worldwide_annual_turnover_in_euros])].
test(an_unsure_undertaking_without_turnover_names_the_turnover) :-
    findall(Verdict, administrative_fine_maximum([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, unsure)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts == [indeterminate([total_worldwide_annual_turnover_in_euros])].
test(an_unsure_steward_with_missing_undertaking_names_the_undertaking) :-
    findall(Verdict, administrative_fine_maximum([attribute(infringed_provision, article_53), attribute(offender_is_open_source_software_steward, unsure)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts == [indeterminate([offender_is_undertaking])].
test(an_unsure_steward_refers_before_an_unsure_undertaking) :-
    findall(Verdict - Citations, administrative_fine_maximum([attribute(infringed_provision, article_47), attribute(offender_is_open_source_software_steward, unsure), attribute(offender_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 100)], date(2028, 1, 1), Verdict, Citations), Answers),
    Answers == [needs_legal_review(open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)), [inputs_relied_on([offender_is_open_source_software_steward - unsure, offender_is_undertaking - unsure])]) - []].
test(an_unsure_steward_with_a_non_undertaking_still_refers) :-
    administrative_fine_maximum([attribute(infringed_provision, article_47), attribute(offender_is_open_source_software_steward, unsure), attribute(offender_is_undertaking, false)], date(2028, 1, 1), needs_legal_review(open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)), [inputs_relied_on([offender_is_open_source_software_steward - unsure, offender_is_undertaking - false])]), []).
test(an_unsure_undertaking_in_the_highest_tier_refers_to_paragraph_2) :-
    findall(Verdict - Citations, administrative_fine_maximum([attribute(infringed_provision, annex_i_essential_cybersecurity_requirements), attribute(offender_is_open_source_software_steward, unsure), attribute(offender_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 5)], date(2028, 1, 1), Verdict, Citations), Answers),
    Answers == [needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_2)), [inputs_relied_on([offender_is_undertaking - unsure])]) - []].
test(an_unsure_undertaking_in_the_lowest_tier_refers_to_paragraph_4) :-
    administrative_fine_maximum([attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 0)], date(2028, 1, 1), needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_4)), [inputs_relied_on([offender_is_open_source_software_steward - false, offender_is_undertaking - unsure])]), []).
test(a_large_turnover_in_the_highest_tier_gives_the_percentage) :-
    findall(Verdict - Citations, administrative_fine_maximum([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000)], date(2028, 1, 1), Verdict, Citations), Answers),
    Answers = [fine_maximum(highest_maximum_tier, percentage_of_turnover, CapEuroCents) - [cite(eu_reg_2024_2847_art_64_2)]],
    CapEuroCents =:= 2500000000.
test(an_odd_turnover_drops_the_half_cent) :-
    administrative_fine_maximum([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000001)], date(2028, 1, 1), fine_maximum(highest_maximum_tier, percentage_of_turnover, CapEuroCents), _),
    CapEuroCents =:= 1500000002.
test(a_tie_in_the_highest_tier_names_the_fixed_amount) :-
    findall(Verdict, administrative_fine_maximum([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000000)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts = [fine_maximum(highest_maximum_tier, fixed_amount, CapEuroCents)],
    CapEuroCents =:= 1500000000.
test(a_tie_in_the_middle_tier_names_the_fixed_amount) :-
    administrative_fine_maximum([attribute(infringed_provision, article_21), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)], date(2028, 1, 1), fine_maximum(middle_maximum_tier, fixed_amount, CapEuroCents), [cite(eu_reg_2024_2847_art_64_3)]),
    CapEuroCents =:= 1000000000.
test(one_euro_above_the_middle_tie_gives_the_percentage) :-
    administrative_fine_maximum([attribute(infringed_provision, article_21), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000001)], date(2028, 1, 1), fine_maximum(middle_maximum_tier, percentage_of_turnover, CapEuroCents), _),
    CapEuroCents =:= 1000000002.
test(the_lowest_tier_percentage_is_one_cent_per_euro) :-
    administrative_fine_maximum([attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000001)], date(2028, 1, 1), fine_maximum(lowest_maximum_tier, percentage_of_turnover, CapEuroCents), [cite(eu_reg_2024_2847_art_64_4)]),
    CapEuroCents =:= 500000001.
test(a_non_undertaking_gets_the_fixed_amount_without_turnover) :-
    findall(Verdict, administrative_fine_maximum([attribute(infringed_provision, article_33_paragraph_5), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, false)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts = [fine_maximum(middle_maximum_tier, fixed_amount_for_non_undertaking, CapEuroCents)],
    CapEuroCents =:= 1000000000.
test(a_bad_profile_and_a_bad_date_are_both_named) :-
    findall(Verdict - Citations, administrative_fine_maximum(colour, tomorrow, Verdict, Citations), Answers),
    Answers == [input_problems([wrong_type(profile), wrong_type(infringement_date)]) - []].
test(a_non_leap_day_is_a_wrong_date) :-
    administrative_fine_maximum([], date(2027, 2, 29), input_problems([wrong_type(infringement_date)]), []).
test(a_float_turnover_is_wrong_type_before_the_date) :-
    FloatTurnover is float(1),
    administrative_fine_maximum([attribute(total_worldwide_annual_turnover_in_euros, FloatTurnover)], date(2020, 1, 1), input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]), []).
test(the_facade_wraps_the_query) :-
    decide_cra_administrative_fines(infringement([attribute(infringed_provision, other_provision)], date(2028, 1, 1)), cra_administrative_fines_verdict(not_listed_in_article_64, _)).
test(the_status_projection_gives_one_status) :-
    findall(Status, cra_administrative_fines_status(infringement([attribute(infringed_provision, article_28), attribute(offender_is_open_source_software_steward, true)], date(2028, 1, 1)), Status), Statuses),
    Statuses == [fine_excluded(open_source_software_steward)].
test(the_checklist_carries_a_citation_per_ground) :-
    findall(Items, cra_administrative_fines_checklist(infringement([attribute(infringed_provision, article_28), attribute(offender_is_open_source_software_steward, true)], date(2028, 1, 1)), Items), AllItems),
    AllItems == [[item(well_formed_input, met, []), item(date_of_application, met, [cite(eu_reg_2024_2847_art_71_2)]), item(tier_of_infringed_provision, value(middle_maximum_tier), [cite(eu_reg_2024_2847_art_64_3)]), item(open_source_software_steward_derogation, unmet(fine_excluded(open_source_software_steward)), [cite(eu_reg_2024_2847_art_64_10_b)]), item(administrative_fine_maximum, value(fine_excluded(open_source_software_steward)), [cite(eu_reg_2024_2847_art_64_10_b)])]].
test(the_checklist_of_a_bad_request_names_the_problems) :-
    cra_administrative_fines_checklist(infringement([], date(2027, 2, 29)), [item(well_formed_input, unmet(input_problems([wrong_type(infringement_date)])), [])]).
test(every_listed_provision_has_one_tier) :-
    findall(Provision, provision_tier(Provision, _, _), Provisions),
    length(Provisions, 20),
    sort(Provisions, DistinctProvisions),
    length(DistinctProvisions, 20).

test(the_application_day_is_not_not_yet_applicable, fail) :-
    administrative_fine_maximum([], date(2027, 12, 11), not_yet_applicable, _).
test(a_steward_in_the_highest_tier_is_not_excluded, fail) :-
    administrative_fine_maximum([attribute(infringed_provision, article_13), attribute(offender_is_open_source_software_steward, true), attribute(offender_is_undertaking, false)], date(2028, 1, 1), fine_excluded(_), _).
test(a_float_turnover_gets_no_final_answer, fail) :-
    FloatTurnover is float(1),
    administrative_fine_maximum([attribute(total_worldwide_annual_turnover_in_euros, FloatTurnover)], date(2020, 1, 1), not_yet_applicable, _).
