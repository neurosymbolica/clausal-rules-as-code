% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, fine_maximum/3, separate_fine_maxima/1, infringement_maximum/4, indeterminate/1, needs_legal_review/2, not_governed_here/1, open_textured/2, inputs_relied_on/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, decide_gdpr_administrative_fine_maximum/2, gdpr_administrative_fine_maximum_status/2, gdpr_administrative_fine_maximum_checklist/2, gdpr_administrative_fine_maximum_decision_resolvable/1, gdpr_administrative_fine_maximum_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_citations, [implements/1]).

gdpr_administrative_fine_maximum_status_values([fine_maximum_determined, separate_fine_maxima_determined, required_input_missing, referred_for_legal_review, input_rejected]).

maximum_tier_paragraph(lower_maximum_tier, cite(eu_reg_2016_679_art_83_4)).
maximum_tier_paragraph(higher_maximum_tier, cite(eu_reg_2016_679_art_83_5)).

provision_tier_row(article_8, lower_maximum_tier, 1, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_11, lower_maximum_tier, 2, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_25, lower_maximum_tier, 3, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_26, lower_maximum_tier, 4, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_27, lower_maximum_tier, 5, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_28, lower_maximum_tier, 6, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_29, lower_maximum_tier, 7, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_30, lower_maximum_tier, 8, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_31, lower_maximum_tier, 9, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_32, lower_maximum_tier, 10, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_33, lower_maximum_tier, 11, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_34, lower_maximum_tier, 12, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_35, lower_maximum_tier, 13, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_36, lower_maximum_tier, 14, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_37, lower_maximum_tier, 15, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_38, lower_maximum_tier, 16, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_39, lower_maximum_tier, 17, [cite(eu_reg_2016_679_art_83_4_a)]).
provision_tier_row(article_42, lower_maximum_tier, 18, [cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_4_b)]).
provision_tier_row(article_43, lower_maximum_tier, 19, [cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_4_b)]).
provision_tier_row(article_41_paragraph_4, lower_maximum_tier, 20, [cite(eu_reg_2016_679_art_83_4_c)]).
provision_tier_row(article_5, higher_maximum_tier, 21, [cite(eu_reg_2016_679_art_83_5_a)]).
provision_tier_row(article_6, higher_maximum_tier, 22, [cite(eu_reg_2016_679_art_83_5_a)]).
provision_tier_row(article_7, higher_maximum_tier, 23, [cite(eu_reg_2016_679_art_83_5_a)]).
provision_tier_row(article_9, higher_maximum_tier, 24, [cite(eu_reg_2016_679_art_83_5_a)]).
provision_tier_row(article_12, higher_maximum_tier, 25, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_13, higher_maximum_tier, 26, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_14, higher_maximum_tier, 27, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_15, higher_maximum_tier, 28, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_16, higher_maximum_tier, 29, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_17, higher_maximum_tier, 30, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_18, higher_maximum_tier, 31, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_19, higher_maximum_tier, 32, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_20, higher_maximum_tier, 33, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_21, higher_maximum_tier, 34, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_22, higher_maximum_tier, 35, [cite(eu_reg_2016_679_art_83_5_b)]).
provision_tier_row(article_44, higher_maximum_tier, 36, [cite(eu_reg_2016_679_art_83_5_c)]).
provision_tier_row(article_45, higher_maximum_tier, 37, [cite(eu_reg_2016_679_art_83_5_c)]).
provision_tier_row(article_46, higher_maximum_tier, 38, [cite(eu_reg_2016_679_art_83_5_c)]).
provision_tier_row(article_47, higher_maximum_tier, 39, [cite(eu_reg_2016_679_art_83_5_c)]).
provision_tier_row(article_48, higher_maximum_tier, 40, [cite(eu_reg_2016_679_art_83_5_c)]).
provision_tier_row(article_49, higher_maximum_tier, 41, [cite(eu_reg_2016_679_art_83_5_c)]).
provision_tier_row(member_state_law_adopted_under_chapter_ix, higher_maximum_tier, 42, [cite(eu_reg_2016_679_art_83_5_d)]).
provision_tier_row(non_compliance_with_supervisory_authority_order, higher_maximum_tier, 43, [cite(eu_reg_2016_679_art_83_5_e)]).
provision_tier_row(failure_to_provide_access_to_supervisory_authority, higher_maximum_tier, 44, [cite(eu_reg_2016_679_art_83_5_e)]).

point_citation_rank(cite(eu_reg_2016_679_art_83_4_a), 1).
point_citation_rank(cite(eu_reg_2016_679_art_83_4_b), 2).
point_citation_rank(cite(eu_reg_2016_679_art_83_4_c), 3).
point_citation_rank(cite(eu_reg_2016_679_art_83_5_a), 4).
point_citation_rank(cite(eu_reg_2016_679_art_83_5_b), 5).
point_citation_rank(cite(eu_reg_2016_679_art_83_5_c), 6).
point_citation_rank(cite(eu_reg_2016_679_art_83_5_d), 7).
point_citation_rank(cite(eu_reg_2016_679_art_83_5_e), 8).

open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)).
open_textured(infringements_concern_same_or_linked_processing_operations, cite(eu_reg_2016_679_art_83_3)).
open_textured(infringements_intentional_or_negligent, cite(eu_reg_2016_679_art_83_3)).

not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]).

contract_key(infringed_provisions).
contract_key(infringer_is_undertaking).
contract_key(total_worldwide_annual_turnover_in_euros).
contract_key(infringements_concern_same_or_linked_processing_operations).
contract_key(infringements_intentional_or_negligent).

basis_value(fixed_amount).
basis_value(percentage_of_turnover).
basis_value(fixed_amount_for_non_undertaking).

fine_maximum(MaximumTier, Basis, CapInEuroCents) :-
    maximum_tier_paragraph(MaximumTier, _),
    basis_value(Basis),
    integer(CapInEuroCents),
    CapInEuroCents #>= 0.

separate_fine_maxima([Maximum|Maxima]) :-
    maplist(infringement_maximum_term, [Maximum|Maxima]).

infringement_maximum_term(infringement_maximum(Provision, MaximumTier, Basis, CapInEuroCents)) :-
    infringement_maximum(Provision, MaximumTier, Basis, CapInEuroCents).

infringement_maximum(Provision, MaximumTier, Basis, CapInEuroCents) :-
    provision_tier_row(Provision, MaximumTier, _, _),
    basis_value(Basis),
    integer(CapInEuroCents),
    CapInEuroCents #>= 0.

indeterminate([ProfileKey|ProfileKeys]) :-
    maplist(contract_key, [ProfileKey|ProfileKeys]).

needs_legal_review(Reason, [inputs_relied_on(RelyPairs)]) :-
    review_reason(Reason),
    inputs_relied_on(RelyPairs).

review_reason(open_textured(JudgementKey, ReferralCitation)) :-
    open_textured(JudgementKey, ReferralCitation).
review_reason(not_governed_here(ReferralCitations)) :-
    not_governed_here(ReferralCitations).

inputs_relied_on(RelyPairs) :-
    clausal_is_list(RelyPairs).

input_problems([Problem|Problems]) :-
    maplist(problem_term, [Problem|Problems]).

problem_term(unknown_key(ProfileKey)) :-
    unknown_key(ProfileKey).
problem_term(wrong_type(ProfileKey)) :-
    wrong_type(ProfileKey).
problem_term(duplicate_key(ProfileKey)) :-
    duplicate_key(ProfileKey).

unknown_key(ProfileKey) :-
    ground(ProfileKey).

wrong_type(profile).
wrong_type(ProfileKey) :-
    contract_key(ProfileKey).

duplicate_key(ProfileKey) :-
    contract_key(ProfileKey).

profile_lookup(Profile, ProfileKey, Lookup) :-
    findall(Value, profile_get(Profile, ProfileKey, Value), Values),
    values_lookup(Values, Lookup).

values_lookup([], absent).
values_lookup([Value], present(Value)).

profile_reading(Profile, reading(ProvisionsLookup, UndertakingLookup, TurnoverLookup, OperationsLookup, FaultLookup)) :-
    profile_lookup(Profile, infringed_provisions, ProvisionsLookup),
    profile_lookup(Profile, infringer_is_undertaking, UndertakingLookup),
    profile_lookup(Profile, total_worldwide_annual_turnover_in_euros, TurnoverLookup),
    profile_lookup(Profile, infringements_concern_same_or_linked_processing_operations, OperationsLookup),
    profile_lookup(Profile, infringements_intentional_or_negligent, FaultLookup).

provision_count_class(ProvisionList, CountClass) :-
    sort(ProvisionList, DistinctProvisions),
    length(DistinctProvisions, Count),
    count_class(Count, CountClass).

count_class(Count, single) :-
    Count #= 1.
count_class(Count, several) :-
    Count #>= 2.

administrative_fine_maximum(Profile, Verdict, Citations) :-
    implements(eu_reg_2016_679_art_83_7),
    gdpr_administrative_fine_maximum_input_problems(Profile, Problems),
    checked_answer(Problems, Profile, Verdict, Citations).

checked_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
checked_answer([], Profile, Verdict, Citations) :-
    profile_reading(Profile, Reading),
    missing_keys_of(Reading, MissingKeys),
    answer_after_missing_keys(MissingKeys, Reading, Verdict, Citations).

missing_keys_of(reading(ProvisionsLookup, UndertakingLookup, TurnoverLookup, OperationsLookup, FaultLookup), MissingKeys) :-
    absent_key_names(ProvisionsLookup, infringed_provisions, ProvisionsNames),
    absent_key_names(UndertakingLookup, infringer_is_undertaking, UndertakingNames),
    turnover_needed(UndertakingLookup, TurnoverNeeded),
    needed_absent_key_names(TurnoverNeeded, TurnoverLookup, total_worldwide_annual_turnover_in_euros, TurnoverNames),
    article_83_3_keys_needed(ProvisionsLookup, OperationsLookup, FaultLookup, ArticleKeysNeeded),
    needed_absent_key_names(ArticleKeysNeeded, OperationsLookup, infringements_concern_same_or_linked_processing_operations, OperationsNames),
    needed_absent_key_names(ArticleKeysNeeded, FaultLookup, infringements_intentional_or_negligent, FaultNames),
    append([ProvisionsNames, UndertakingNames, TurnoverNames, OperationsNames, FaultNames], MissingKeys).

absent_key_names(absent, ProfileKey, [ProfileKey]).
absent_key_names(present(_), _, []).

needed_absent_key_names(true, Lookup, ProfileKey, Names) :-
    absent_key_names(Lookup, ProfileKey, Names).
needed_absent_key_names(false, _, _, []).

turnover_needed(absent, true) :-
    implements(eu_reg_2016_679_art_83_4).
turnover_needed(present(UndertakingValue), Needed) :-
    implements(eu_reg_2016_679_art_83_4),
    turnover_needed_for_value(UndertakingValue, Needed).

turnover_needed_for_value(true, true).
turnover_needed_for_value(unsure, true).
turnover_needed_for_value(false, false).

article_83_3_keys_needed(absent, _, _, false).
article_83_3_keys_needed(present(ProvisionList), OperationsLookup, FaultLookup, Needed) :-
    provision_count_class(ProvisionList, CountClass),
    several_keys_needed(CountClass, OperationsLookup, FaultLookup, Needed).

several_keys_needed(single, _, _, false).
several_keys_needed(several, OperationsLookup, FaultLookup, Needed) :-
    implements(eu_reg_2016_679_art_83_3),
    false_key_t(OperationsLookup, OperationsFalse),
    false_key_t(FaultLookup, FaultFalse),
    neither_false(OperationsFalse, FaultFalse, Needed).

false_key_t(absent, false).
false_key_t(present(JudgementValue), Truth) :-
    judgement_false_t(JudgementValue, Truth).

judgement_false_t(false, true).
judgement_false_t(true, false).
judgement_false_t(unsure, false).

neither_false(false, false, true).
neither_false(true, _, false).
neither_false(false, true, false).

answer_after_missing_keys([MissingKey|MissingKeys], _, indeterminate([MissingKey|MissingKeys]), []).
answer_after_missing_keys([], reading(present(ProvisionList), UndertakingLookup, TurnoverLookup, OperationsLookup, FaultLookup), Verdict, Citations) :-
    sort(ProvisionList, DistinctProvisions),
    provision_vocabulary(Vocabulary),
    unlisted_provisions(DistinctProvisions, Vocabulary, Unlisted),
    answer_after_listing(Unlisted, ProvisionList, DistinctProvisions, reading(present(ProvisionList), UndertakingLookup, TurnoverLookup, OperationsLookup, FaultLookup), Verdict, Citations).

provision_vocabulary(Vocabulary) :-
    findall(Provision, provision_tier_row(Provision, _, _, _), Vocabulary).

unlisted_provisions([], _, []).
unlisted_provisions([Provision|Provisions], Vocabulary, Unlisted) :-
    memberd_t(Provision, Vocabulary, IsListed),
    unlisted_provisions(Provisions, Vocabulary, RemainingUnlisted),
    add_unlisted(IsListed, Provision, RemainingUnlisted, Unlisted).

add_unlisted(true, _, Unlisted, Unlisted).
add_unlisted(false, Provision, Unlisted, [Provision|Unlisted]).

answer_after_listing([_|_], ProvisionList, _, _, needs_legal_review(not_governed_here(ReferralCitations), [inputs_relied_on([infringed_provisions - ProvisionList])]), []) :-
    implements(eu_reg_2016_679_art_83_4),
    implements(eu_reg_2016_679_art_83_5),
    implements(eu_reg_2016_679_art_83_6),
    not_governed_here(ReferralCitations).
answer_after_listing([], _, DistinctProvisions, reading(_, present(UndertakingValue), TurnoverLookup, OperationsLookup, FaultLookup), Verdict, Citations) :-
    article_83_3_mode(DistinctProvisions, OperationsLookup, FaultLookup, AnswerMode),
    relied_pairs(DistinctProvisions, UndertakingValue, OperationsLookup, FaultLookup, RelyPairs),
    undertaking_answer(UndertakingValue, AnswerMode, RelyPairs, DistinctProvisions, TurnoverLookup, Verdict, Citations).

article_83_3_mode(DistinctProvisions, OperationsLookup, FaultLookup, AnswerMode) :-
    provision_count_class(DistinctProvisions, CountClass),
    class_mode(CountClass, OperationsLookup, FaultLookup, AnswerMode).

class_mode(single, _, _, single).
class_mode(several, OperationsLookup, FaultLookup, AnswerMode) :-
    implements(eu_reg_2016_679_art_83_3),
    key_state(OperationsLookup, OperationsState),
    key_state(FaultLookup, FaultState),
    several_mode(OperationsState, FaultState, AnswerMode).

key_state(absent, absent).
key_state(present(JudgementValue), JudgementValue).

several_mode(false, _, separate).
several_mode(true, false, separate).
several_mode(unsure, false, separate).
several_mode(absent, false, separate).
several_mode(true, true, combined).
several_mode(unsure, true, open(infringements_concern_same_or_linked_processing_operations)).
several_mode(unsure, unsure, open(infringements_concern_same_or_linked_processing_operations)).
several_mode(true, unsure, open(infringements_intentional_or_negligent)).

relied_pairs(DistinctProvisions, UndertakingValue, OperationsLookup, FaultLookup, [infringer_is_undertaking - UndertakingValue|ArticlePairs]) :-
    provision_count_class(DistinctProvisions, CountClass),
    article_83_3_pairs(CountClass, OperationsLookup, FaultLookup, ArticlePairs).

article_83_3_pairs(single, _, _, []).
article_83_3_pairs(several, OperationsLookup, FaultLookup, ArticlePairs) :-
    present_pair(OperationsLookup, infringements_concern_same_or_linked_processing_operations, OperationsPairs),
    present_pair(FaultLookup, infringements_intentional_or_negligent, FaultPairs),
    append(OperationsPairs, FaultPairs, ArticlePairs).

present_pair(absent, _, []).
present_pair(present(JudgementValue), ProfileKey, [ProfileKey - JudgementValue]).

undertaking_answer(unsure, _, RelyPairs, _, _, needs_legal_review(open_textured(infringer_is_undertaking, ReferralCitation), [inputs_relied_on(RelyPairs)]), []) :-
    implements(eu_reg_2016_679_art_83_4),
    implements(eu_reg_2016_679_art_4_18),
    implements(eu_reg_2016_679_art_4_19),
    open_textured(infringer_is_undertaking, ReferralCitation).
undertaking_answer(true, AnswerMode, RelyPairs, DistinctProvisions, present(TurnoverEuros), Verdict, Citations) :-
    implements(eu_reg_2016_679_art_83_4),
    implements(eu_reg_2016_679_art_4_18),
    implements(eu_reg_2016_679_art_4_19),
    mode_answer(AnswerMode, RelyPairs, DistinctProvisions, undertaking(TurnoverEuros), Verdict, Citations).
undertaking_answer(false, AnswerMode, RelyPairs, DistinctProvisions, _, Verdict, Citations) :-
    implements(eu_reg_2016_679_art_83_4),
    implements(eu_reg_2016_679_art_4_18),
    implements(eu_reg_2016_679_art_4_19),
    mode_answer(AnswerMode, RelyPairs, DistinctProvisions, non_undertaking, Verdict, Citations).

mode_answer(open(JudgementKey), RelyPairs, _, _, needs_legal_review(open_textured(JudgementKey, ReferralCitation), [inputs_relied_on(RelyPairs)]), []) :-
    implements(eu_reg_2016_679_art_83_3),
    open_textured(JudgementKey, ReferralCitation).
mode_answer(single, _, DistinctProvisions, Capacity, fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations) :-
    implements(eu_reg_2016_679_art_83_4),
    implements(eu_reg_2016_679_art_83_5),
    gravest_tier(DistinctProvisions, MaximumTier),
    tier_cap(MaximumTier, Capacity, Basis, CapInEuroCents),
    deciding_tier_citations(MaximumTier, DistinctProvisions, Citations).
mode_answer(combined, _, DistinctProvisions, Capacity, fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations) :-
    implements(eu_reg_2016_679_art_83_3),
    gravest_tier(DistinctProvisions, MaximumTier),
    tier_cap(MaximumTier, Capacity, Basis, CapInEuroCents),
    deciding_tier_citations(MaximumTier, DistinctProvisions, TierCitations),
    append(TierCitations, [cite(eu_reg_2016_679_art_83_3)], Citations).
mode_answer(separate, _, DistinctProvisions, Capacity, separate_fine_maxima(Maxima), Citations) :-
    implements(eu_reg_2016_679_art_83_3),
    vocabulary_ordered(DistinctProvisions, OrderedProvisions),
    maplist(separate_maximum(Capacity), OrderedProvisions, Maxima),
    separate_citations(DistinctProvisions, Citations).

gravest_tier(DistinctProvisions, MaximumTier) :-
    implements(eu_reg_2016_679_art_83_4),
    implements(eu_reg_2016_679_art_83_5),
    findall(ProvisionTier, (member(Provision, DistinctProvisions), provision_tier_row(Provision, ProvisionTier, _, _)), ProvisionTiers),
    memberd_t(higher_maximum_tier, ProvisionTiers, HasHigher),
    tier_of_higher_presence(HasHigher, MaximumTier).

tier_of_higher_presence(true, higher_maximum_tier).
tier_of_higher_presence(false, lower_maximum_tier).

tier_amounts(lower_maximum_tier, FixedCents, TurnoverPercentage) :-
    implements(eu_reg_2016_679_art_83_4),
    FixedCents #= 1000000000,
    TurnoverPercentage #= 2.
tier_amounts(higher_maximum_tier, FixedCents, TurnoverPercentage) :-
    implements(eu_reg_2016_679_art_83_5),
    FixedCents #= 2000000000,
    TurnoverPercentage #= 4.

tier_cap(MaximumTier, non_undertaking, fixed_amount_for_non_undertaking, FixedCents) :-
    implements(eu_reg_2016_679_art_83_4),
    implements(eu_reg_2016_679_art_83_5),
    tier_amounts(MaximumTier, FixedCents, _).
tier_cap(MaximumTier, undertaking(TurnoverEuros), Basis, CapInEuroCents) :-
    implements(eu_reg_2016_679_art_83_4),
    implements(eu_reg_2016_679_art_83_5),
    tier_amounts(MaximumTier, FixedCents, TurnoverPercentage),
    PercentageCents #= TurnoverEuros * TurnoverPercentage,
    whichever_is_higher(FixedCents, PercentageCents, Basis, CapInEuroCents).

whichever_is_higher(FixedCents, PercentageCents, percentage_of_turnover, PercentageCents) :-
    implements(eu_reg_2016_679_art_83_4),
    PercentageCents #> FixedCents.
whichever_is_higher(FixedCents, PercentageCents, fixed_amount, FixedCents) :-
    implements(eu_reg_2016_679_art_83_4),
    PercentageCents #=< FixedCents.

separate_maximum(Capacity, Provision, infringement_maximum(Provision, MaximumTier, Basis, CapInEuroCents)) :-
    implements(eu_reg_2016_679_art_83_4),
    provision_tier_row(Provision, MaximumTier, _, _),
    tier_cap(MaximumTier, Capacity, Basis, CapInEuroCents).

vocabulary_ordered(Provisions, OrderedProvisions) :-
    findall(VocabularyRank - Provision, (member(Provision, Provisions), provision_tier_row(Provision, _, VocabularyRank, _)), RankedProvisions),
    sort(RankedProvisions, SortedProvisions),
    pairs_values(SortedProvisions, OrderedProvisions).

deciding_tier_citations(MaximumTier, DistinctProvisions, Citations) :-
    tier_paragraph_citations(MaximumTier, DistinctProvisions, ParagraphCitations),
    findall(Provision, (member(Provision, DistinctProvisions), provision_tier_row(Provision, MaximumTier, _, _)), TierProvisions),
    point_citations(TierProvisions, PointCitations),
    append(ParagraphCitations, PointCitations, Citations).

tier_paragraph_citations(lower_maximum_tier, _, [cite(eu_reg_2016_679_art_83_4)]).
tier_paragraph_citations(higher_maximum_tier, DistinctProvisions, [cite(eu_reg_2016_679_art_83_5)|OrderCitations]) :-
    memberd_t(non_compliance_with_supervisory_authority_order, DistinctProvisions, HasOrder),
    order_paragraph_citations(HasOrder, OrderCitations).

order_paragraph_citations(true, [cite(eu_reg_2016_679_art_83_6)]).
order_paragraph_citations(false, []).

separate_citations(DistinctProvisions, Citations) :-
    findall(ProvisionTier, (member(Provision, DistinctProvisions), provision_tier_row(Provision, ProvisionTier, _, _)), ProvisionTiers),
    memberd_t(lower_maximum_tier, ProvisionTiers, HasLower),
    memberd_t(higher_maximum_tier, ProvisionTiers, HasHigher),
    lower_paragraph_citations(HasLower, LowerCitations),
    higher_paragraph_citations(HasHigher, DistinctProvisions, HigherCitations),
    point_citations(DistinctProvisions, PointCitations),
    append([LowerCitations, HigherCitations, PointCitations], Citations).

lower_paragraph_citations(true, [cite(eu_reg_2016_679_art_83_4)]).
lower_paragraph_citations(false, []).

higher_paragraph_citations(true, DistinctProvisions, HigherCitations) :-
    tier_paragraph_citations(higher_maximum_tier, DistinctProvisions, HigherCitations).
higher_paragraph_citations(false, _, []).

point_citations(Provisions, PointCitations) :-
    findall(PointRank - PointCitation, (member(Provision, Provisions), provision_tier_row(Provision, _, _, ProvisionCitations), member(PointCitation, ProvisionCitations), point_citation_rank(PointCitation, PointRank)), RankedCitations),
    sort(RankedCitations, SortedCitations),
    pairs_values(SortedCitations, PointCitations).

decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(fine_maximum_determined, Citations)) :-
    administrative_fine_maximum(Profile, fine_maximum(_, _, _), Citations).
decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(separate_fine_maxima_determined, Citations)) :-
    administrative_fine_maximum(Profile, separate_fine_maxima(_), Citations).
decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(required_input_missing, Citations)) :-
    administrative_fine_maximum(Profile, indeterminate(_), Citations).
decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(referred_for_legal_review, Citations)) :-
    administrative_fine_maximum(Profile, needs_legal_review(_, _), Citations).
decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(input_rejected, Citations)) :-
    administrative_fine_maximum(Profile, input_problems(_), Citations).

gdpr_administrative_fine_maximum_status(Profile, Status) :-
    decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(Status, _)).

gdpr_administrative_fine_maximum_checklist(Profile, [item(overall, Status, Citations)|ItemRows]) :-
    decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(Status, Citations)),
    administrative_fine_maximum(Profile, Verdict, _),
    verdict_rows(Verdict, ItemRows).

verdict_rows(fine_maximum(MaximumTier, Basis, CapInEuroCents), [item(fine_maximum(MaximumTier, Basis, CapInEuroCents), met, ParagraphCitation)]) :-
    maximum_tier_paragraph(MaximumTier, ParagraphCitation).
verdict_rows(separate_fine_maxima(Maxima), ItemRows) :-
    maplist(maximum_row, Maxima, ItemRows).
verdict_rows(indeterminate(MissingKeys), [item(required_inputs, unknown(MissingKeys), cite(eu_reg_2016_679_art_83_4))]).
verdict_rows(needs_legal_review(open_textured(JudgementKey, ReferralCitation), _), [item(JudgementKey, unknown([JudgementKey]), ReferralCitation)]).
verdict_rows(needs_legal_review(not_governed_here(_), _), [item(infringed_provisions, unmet(not_governed_here), cite(eu_reg_2016_679_art_83_4))]).
verdict_rows(input_problems(_), []).

maximum_row(infringement_maximum(Provision, MaximumTier, Basis, CapInEuroCents), item(infringement_maximum(Provision, MaximumTier, Basis, CapInEuroCents), met, ParagraphCitation)) :-
    maximum_tier_paragraph(MaximumTier, ParagraphCitation).

gdpr_administrative_fine_maximum_decision_resolvable(Profile) :-
    decide_gdpr_administrative_fine_maximum(Profile, _).

test(lower_tier_turnover_above_fixed_amount_gives_percentage) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_32]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000)], fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == lower_maximum_tier,
    Basis == percentage_of_turnover,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)].
test(higher_tier_turnover_below_fixed_amount_gives_fixed_amount) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 400000000)], fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a)].
test(a_tie_keeps_the_fixed_amount) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_8]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)], fine_maximum(MaximumTier, Basis, CapInEuroCents), _),
    MaximumTier == lower_maximum_tier,
    Basis == fixed_amount,
    CapInEuroCents =:= 1000000000.
test(non_undertaking_gets_the_fixed_amount_and_turnover_is_not_needed) :-
    administrative_fine_maximum([attribute(infringed_provisions, [non_compliance_with_supervisory_authority_order]), attribute(infringer_is_undertaking, false)], fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount_for_non_undertaking,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6), cite(eu_reg_2016_679_art_83_5_e)].
test(one_provision_named_twice_is_single_and_reads_no_article_83_3_key) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_5, article_5]), attribute(infringer_is_undertaking, false), attribute(infringements_concern_same_or_linked_processing_operations, unsure)], fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == higher_maximum_tier,
    Basis == fixed_amount_for_non_undertaking,
    CapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a)].
test(combined_takes_the_gravest_tier_and_cites_article_83_3_last) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_32, article_5]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000), attribute(infringements_concern_same_or_linked_processing_operations, true), attribute(infringements_intentional_or_negligent, true)], fine_maximum(MaximumTier, Basis, CapInEuroCents), Citations),
    MaximumTier == higher_maximum_tier,
    Basis == percentage_of_turnover,
    CapInEuroCents =:= 4000000000,
    Citations == [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a), cite(eu_reg_2016_679_art_83_3)].
test(separate_gives_each_maximum_in_vocabulary_order) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_17, article_42, article_17]), attribute(infringer_is_undertaking, false), attribute(infringements_concern_same_or_linked_processing_operations, false)], separate_fine_maxima([infringement_maximum(FirstProvision, FirstTier, FirstBasis, FirstCapInEuroCents), infringement_maximum(SecondProvision, SecondTier, SecondBasis, SecondCapInEuroCents)]), Citations),
    FirstProvision == article_42,
    FirstTier == lower_maximum_tier,
    FirstBasis == fixed_amount_for_non_undertaking,
    FirstCapInEuroCents =:= 1000000000,
    SecondProvision == article_17,
    SecondTier == higher_maximum_tier,
    SecondBasis == fixed_amount_for_non_undertaking,
    SecondCapInEuroCents =:= 2000000000,
    Citations == [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_4_b), cite(eu_reg_2016_679_art_83_5_b)].
test(an_empty_profile_names_the_first_three_keys) :-
    administrative_fine_maximum([], Verdict, Citations),
    Verdict == indeterminate([infringed_provisions, infringer_is_undertaking, total_worldwide_annual_turnover_in_euros]),
    Citations == [].
test(unsure_undertaking_without_turnover_names_the_turnover) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_24]), attribute(infringer_is_undertaking, unsure)], Verdict, Citations),
    Verdict == indeterminate([total_worldwide_annual_turnover_in_euros]),
    Citations == [].
test(several_provisions_name_both_article_83_3_keys) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_5, article_6]), attribute(infringer_is_undertaking, false)], Verdict, _),
    Verdict == indeterminate([infringements_concern_same_or_linked_processing_operations, infringements_intentional_or_negligent]).
test(an_unlisted_provision_is_not_governed_here) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_24, article_24]), attribute(infringer_is_undertaking, false)], Verdict, Citations),
    Verdict == needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]), [inputs_relied_on([infringed_provisions - [article_24, article_24]])]),
    Citations == [].
test(an_unsure_article_83_3_key_refers) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_5, article_6]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 0), attribute(infringements_concern_same_or_linked_processing_operations, unsure), attribute(infringements_intentional_or_negligent, true)], Verdict, Citations),
    Verdict == needs_legal_review(open_textured(infringements_concern_same_or_linked_processing_operations, cite(eu_reg_2016_679_art_83_3)), [inputs_relied_on([infringer_is_undertaking - true, infringements_concern_same_or_linked_processing_operations - unsure, infringements_intentional_or_negligent - true])]),
    Citations == [].
test(an_unsure_undertaking_refers_even_in_separate_mode) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_5, article_6]), attribute(infringer_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 100), attribute(infringements_concern_same_or_linked_processing_operations, false)], Verdict, _),
    Verdict == needs_legal_review(open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), [inputs_relied_on([infringer_is_undertaking - unsure, infringements_concern_same_or_linked_processing_operations - false])]).
test(input_problems_come_first_in_contract_order) :-
    administrative_fine_maximum([attribute(colour, red), attribute(infringer_is_undertaking, maybe), attribute(colour, blue)], Verdict, Citations),
    Verdict == input_problems([wrong_type(infringer_is_undertaking), unknown_key(colour)]),
    Citations == [].
test(a_repeated_key_is_a_duplicate_key) :-
    administrative_fine_maximum([attribute(infringer_is_undertaking, true), attribute(infringer_is_undertaking, true)], Verdict, _),
    Verdict == input_problems([duplicate_key(infringer_is_undertaking)]).
test(a_non_list_profile_is_wrong_type) :-
    administrative_fine_maximum(profile_text, Verdict, Citations),
    Verdict == input_problems([wrong_type(profile)]),
    Citations == [].
test(every_query_answers_exactly_once) :-
    findall(Verdict - Citations, administrative_fine_maximum([attribute(infringed_provisions, [article_42, article_43, article_5]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 7000000000), attribute(infringements_concern_same_or_linked_processing_operations, true), attribute(infringements_intentional_or_negligent, false)], Verdict, Citations), Answers),
    length(Answers, 1).
test(facade_status_projects_the_verdict) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_8]), attribute(infringer_is_undertaking, false)], Status),
    Status == fine_maximum_determined.
test(checklist_rows_carry_citations) :-
    gdpr_administrative_fine_maximum_checklist([attribute(infringed_provisions, [article_8]), attribute(infringer_is_undertaking, false)], ItemRows),
    member(item(fine_maximum(lower_maximum_tier, fixed_amount_for_non_undertaking, _), met, cite(eu_reg_2016_679_art_83_4)), ItemRows).

test(a_tie_is_not_percentage, fail) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_8]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 500000000)], fine_maximum(_, percentage_of_turnover, _), _).
test(separate_never_cites_article_83_3, fail) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_17, article_42]), attribute(infringer_is_undertaking, false), attribute(infringements_intentional_or_negligent, false)], separate_fine_maxima(_), Citations),
    member(cite(eu_reg_2016_679_art_83_3), Citations).
test(facade_status_is_not_missing_for_a_complete_profile, fail) :-
    gdpr_administrative_fine_maximum_status([attribute(infringed_provisions, [article_8]), attribute(infringer_is_undertaking, false)], required_input_missing).
