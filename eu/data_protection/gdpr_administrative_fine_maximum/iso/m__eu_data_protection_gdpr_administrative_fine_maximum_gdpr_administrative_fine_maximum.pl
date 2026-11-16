% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, decide_gdpr_administrative_fine_maximum/2, gdpr_administrative_fine_maximum_status/2, gdpr_administrative_fine_maximum_checklist/2, gdpr_administrative_fine_maximum_decision_resolvable/1, gdpr_administrative_fine_maximum_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_citations, [implements/1]).

tier_figures(lower_maximum_tier, 1000000000, 2, cite(eu_reg_2016_679_art_83_4)).
tier_figures(higher_maximum_tier, 2000000000, 4, cite(eu_reg_2016_679_art_83_5)).

provision_group(lower_maximum_tier, [cite(eu_reg_2016_679_art_83_4_a)], [article_8, article_11, article_25, article_26, article_27, article_28, article_29, article_30, article_31, article_32, article_33, article_34, article_35, article_36, article_37, article_38, article_39]).
provision_group(lower_maximum_tier, [cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_4_b)], [article_42, article_43]).
provision_group(lower_maximum_tier, [cite(eu_reg_2016_679_art_83_4_c)], [article_41_paragraph_4]).
provision_group(higher_maximum_tier, [cite(eu_reg_2016_679_art_83_5_a)], [article_5, article_6, article_7, article_9]).
provision_group(higher_maximum_tier, [cite(eu_reg_2016_679_art_83_5_b)], [article_12, article_13, article_14, article_15, article_16, article_17, article_18, article_19, article_20, article_21, article_22]).
provision_group(higher_maximum_tier, [cite(eu_reg_2016_679_art_83_5_c)], [article_44, article_45, article_46, article_47, article_48, article_49]).
provision_group(higher_maximum_tier, [cite(eu_reg_2016_679_art_83_5_d)], [member_state_law_adopted_under_chapter_ix]).
provision_group(higher_maximum_tier, [cite(eu_reg_2016_679_art_83_5_e)], [non_compliance_with_supervisory_authority_order, failure_to_provide_access_to_supervisory_authority]).

provision_row(Provision, Tier, PointCitations) :-
    provision_group(Tier, PointCitations, Provisions),
    member(Provision, Provisions).

tier_of(Provision, Tier) :-
    provision_row(Provision, Tier, _).

vocabulary_atoms(Vocabulary) :-
    findall(Provision, provision_row(Provision, _, _), Vocabulary).

gdpr_administrative_fine_maximum_status_values([fine_maximum, separate_fine_maxima, indeterminate, needs_legal_review, input_problems]).

administrative_fine_maximum(Profile, Verdict, Citations) :-
    gdpr_administrative_fine_maximum_input_problems(Profile, Problems),
    after_input_check(Problems, Profile, Verdict, Citations).

after_input_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
after_input_check([], Profile, Verdict, Citations) :-
    missing_needed_keys(Profile, Missing),
    after_missing_check(Missing, Profile, Verdict, Citations).

after_missing_check([Key|Keys], _, indeterminate([Key|Keys]), []).
after_missing_check([], Profile, Verdict, Citations) :-
    profile_get(Profile, infringed_provisions, Provisions),
    sort(Provisions, Distinct),
    all_listed_t(Distinct, Listed),
    after_listing_check(Listed, Profile, Provisions, Distinct, Verdict, Citations).

after_listing_check(false, _, Provisions, _, needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]), [inputs_relied_on([infringed_provisions - Provisions])]), []) :-
    implements(eu_reg_2016_679_art_83_4).
after_listing_check(true, Profile, _, Distinct, Verdict, Citations) :-
    implements(eu_reg_2016_679_art_4_18),
    implements(eu_reg_2016_679_art_4_19),
    implements(eu_reg_2016_679_art_83_7),
    length(Distinct, Count),
    judgement_mode(Count, Profile, Mode),
    profile_get(Profile, infringer_is_undertaking, Undertaking),
    after_mode_check(Undertaking, Mode, Profile, Distinct, Verdict, Citations).

after_mode_check(unsure, _, Profile, Distinct, needs_legal_review(open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2016_679_art_83_4),
    relied_on_pairs(Profile, Distinct, Pairs).
after_mode_check(Undertaking, open, Profile, Distinct, needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_83_3)), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2016_679_art_83_3),
    settled_judgement(Undertaking),
    unsure_art_83_3_key(Profile, Key),
    relied_on_pairs(Profile, Distinct, Pairs).
after_mode_check(Undertaking, Mode, Profile, Distinct, Verdict, Citations) :-
    settled_judgement(Undertaking),
    final_mode(Mode),
    final_answer(Mode, Undertaking, Profile, Distinct, Verdict, Citations).

settled_judgement(true).
settled_judgement(false).

final_mode(single).
final_mode(combined).
final_mode(separate).

unsure_art_83_3_key(Profile, infringements_concern_same_or_linked_processing_operations) :-
    profile_get(Profile, infringements_concern_same_or_linked_processing_operations, unsure).
unsure_art_83_3_key(Profile, infringements_intentional_or_negligent) :-
    profile_get(Profile, infringements_concern_same_or_linked_processing_operations, true),
    profile_get(Profile, infringements_intentional_or_negligent, unsure).

relied_on_pairs(Profile, Distinct, Pairs) :-
    length(Distinct, Count),
    relied_pairs(Count, Profile, Pairs).

relied_pairs(1, Profile, [infringer_is_undertaking - Undertaking]) :-
    profile_get(Profile, infringer_is_undertaking, Undertaking).
relied_pairs(Count, Profile, [infringer_is_undertaking - Undertaking, infringements_concern_same_or_linked_processing_operations - Linked, infringements_intentional_or_negligent - Culpable]) :-
    Count >= 2,
    profile_get(Profile, infringer_is_undertaking, Undertaking),
    profile_get(Profile, infringements_concern_same_or_linked_processing_operations, Linked),
    profile_get(Profile, infringements_intentional_or_negligent, Culpable).

judgement_mode(1, _, single).
judgement_mode(Count, Profile, Mode) :-
    Count >= 2,
    profile_get(Profile, infringements_concern_same_or_linked_processing_operations, Linked),
    profile_get(Profile, infringements_intentional_or_negligent, Culpable),
    pair_mode(Linked, Culpable, Mode).

pair_mode(true, true, combined) :-
    implements(eu_reg_2016_679_art_83_3).
pair_mode(true, false, separate) :-
    implements(eu_reg_2016_679_art_83_3).
pair_mode(false, true, separate) :-
    implements(eu_reg_2016_679_art_83_3).
pair_mode(false, false, separate) :-
    implements(eu_reg_2016_679_art_83_3).
pair_mode(false, unsure, separate) :-
    implements(eu_reg_2016_679_art_83_3).
pair_mode(unsure, false, separate) :-
    implements(eu_reg_2016_679_art_83_3).
pair_mode(true, unsure, open) :-
    implements(eu_reg_2016_679_art_83_3).
pair_mode(unsure, true, open) :-
    implements(eu_reg_2016_679_art_83_3).
pair_mode(unsure, unsure, open) :-
    implements(eu_reg_2016_679_art_83_3).

final_answer(single, Undertaking, Profile, Distinct, fine_maximum(Tier, Basis, CapInEuroCents), Citations) :-
    tier_answer(Undertaking, Profile, Distinct, Tier, Basis, CapInEuroCents),
    deciding_citations(Tier, Distinct, Citations).
final_answer(combined, Undertaking, Profile, Distinct, fine_maximum(Tier, Basis, CapInEuroCents), Citations) :-
    implements(eu_reg_2016_679_art_83_3),
    tier_answer(Undertaking, Profile, Distinct, Tier, Basis, CapInEuroCents),
    deciding_citations(Tier, Distinct, DecidingCitations),
    append(DecidingCitations, [cite(eu_reg_2016_679_art_83_3)], Citations).
final_answer(separate, Undertaking, Profile, Distinct, separate_fine_maxima(Maxima), Citations) :-
    implements(eu_reg_2016_679_art_83_3),
    turnover_value(Profile, Undertaking, Turnover),
    vocabulary_ordered(Distinct, Ordered),
    maplist(member_maximum(Undertaking, Turnover), Ordered, Maxima),
    separate_citations(Distinct, Citations).

tier_answer(Undertaking, Profile, Distinct, Tier, Basis, CapInEuroCents) :-
    maplist(tier_of, Distinct, Tiers),
    memberd_t(higher_maximum_tier, Tiers, HasHigher),
    deciding_tier(HasHigher, Tier),
    turnover_value(Profile, Undertaking, Turnover),
    cap_of(Undertaking, Tier, Turnover, Basis, CapInEuroCents).

deciding_tier(true, higher_maximum_tier).
deciding_tier(false, lower_maximum_tier).

member_maximum(Undertaking, Turnover, Provision, infringement_maximum(Provision, Tier, Basis, CapInEuroCents)) :-
    tier_of(Provision, Tier),
    cap_of(Undertaking, Tier, Turnover, Basis, CapInEuroCents).

turnover_value(_, false, not_read).
turnover_value(Profile, true, Turnover) :-
    profile_get(Profile, total_worldwide_annual_turnover_in_euros, Turnover).

cap_of(false, lower_maximum_tier, _, fixed_amount_for_non_undertaking, FixedCents) :-
    implements(eu_reg_2016_679_art_83_4),
    tier_figures(lower_maximum_tier, FixedCents, _, _).
cap_of(true, lower_maximum_tier, Turnover, percentage_of_turnover, PercentageCents) :-
    implements(eu_reg_2016_679_art_83_4),
    tier_figures(lower_maximum_tier, FixedCents, Rate, _),
    PercentageCents #= Turnover * Rate,
    PercentageCents #> FixedCents.
cap_of(true, lower_maximum_tier, Turnover, fixed_amount, FixedCents) :-
    implements(eu_reg_2016_679_art_83_4),
    tier_figures(lower_maximum_tier, FixedCents, Rate, _),
    PercentageCents #= Turnover * Rate,
    PercentageCents #=< FixedCents.
cap_of(false, higher_maximum_tier, _, fixed_amount_for_non_undertaking, FixedCents) :-
    implements(eu_reg_2016_679_art_83_5),
    tier_figures(higher_maximum_tier, FixedCents, _, _).
cap_of(true, higher_maximum_tier, Turnover, percentage_of_turnover, PercentageCents) :-
    implements(eu_reg_2016_679_art_83_5),
    tier_figures(higher_maximum_tier, FixedCents, Rate, _),
    PercentageCents #= Turnover * Rate,
    PercentageCents #> FixedCents.
cap_of(true, higher_maximum_tier, Turnover, fixed_amount, FixedCents) :-
    implements(eu_reg_2016_679_art_83_5),
    tier_figures(higher_maximum_tier, FixedCents, Rate, _),
    PercentageCents #= Turnover * Rate,
    PercentageCents #=< FixedCents.

deciding_citations(Tier, Distinct, Citations) :-
    paragraph_citations(Tier, Distinct, Paragraphs),
    members_in_tier(Distinct, Tier, Members),
    point_citations(Members, Points),
    append(Paragraphs, Points, Citations).

paragraph_citations(lower_maximum_tier, _, [cite(eu_reg_2016_679_art_83_4)]) :-
    implements(eu_reg_2016_679_art_83_4).
paragraph_citations(higher_maximum_tier, Distinct, [cite(eu_reg_2016_679_art_83_5)|OrderCitations]) :-
    implements(eu_reg_2016_679_art_83_5),
    memberd_t(non_compliance_with_supervisory_authority_order, Distinct, HasOrder),
    order_citations(HasOrder, OrderCitations).

order_citations(true, [cite(eu_reg_2016_679_art_83_6)]) :-
    implements(eu_reg_2016_679_art_83_6).
order_citations(false, []).

members_in_tier(Distinct, Tier, Members) :-
    findall(Provision, (member(Provision, Distinct), tier_of(Provision, Tier)), Members).

point_citations(Members, Points) :-
    findall(Citation, (member(Provision, Members), provision_row(Provision, _, PointCitations), member(Citation, PointCitations)), Raw),
    sort(Raw, Points).

separate_citations(Distinct, Citations) :-
    maplist(tier_of, Distinct, Tiers),
    memberd_t(lower_maximum_tier, Tiers, HasLower),
    memberd_t(higher_maximum_tier, Tiers, HasHigher),
    lower_paragraphs(HasLower, LowerParagraphs),
    higher_paragraphs(HasHigher, Distinct, HigherParagraphs),
    point_citations(Distinct, Points),
    append([LowerParagraphs, HigherParagraphs, Points], Citations).

lower_paragraphs(true, Paragraphs) :-
    paragraph_citations(lower_maximum_tier, [], Paragraphs).
lower_paragraphs(false, []).

higher_paragraphs(true, Distinct, Paragraphs) :-
    paragraph_citations(higher_maximum_tier, Distinct, Paragraphs).
higher_paragraphs(false, _, []).

all_listed_t([], true).
all_listed_t([Provision|Provisions], Listed) :-
    vocabulary_atoms(Vocabulary),
    memberd_t(Provision, Vocabulary, InVocabulary),
    all_listed_t(Provisions, RestListed),
    both_true(InVocabulary, RestListed, Listed).

both_true(true, Truth, Truth).
both_true(false, _, false).

vocabulary_ordered(Distinct, Ordered) :-
    findall(Provision, (provision_row(Provision, _, _), member(Provision, Distinct)), Ordered).

missing_needed_keys(Profile, Missing) :-
    multiple_provisions_t(Profile, Multiple),
    turnover_needed_t(Profile, TurnoverNeeded),
    missing_entry(Profile, infringed_provisions, true, ProvisionsMissing),
    missing_entry(Profile, infringer_is_undertaking, true, UndertakingMissing),
    missing_entry(Profile, total_worldwide_annual_turnover_in_euros, TurnoverNeeded, TurnoverMissing),
    missing_entry(Profile, infringements_concern_same_or_linked_processing_operations, Multiple, LinkedMissing),
    missing_entry(Profile, infringements_intentional_or_negligent, Multiple, CulpableMissing),
    append([ProvisionsMissing, UndertakingMissing, TurnoverMissing, LinkedMissing, CulpableMissing], Missing).

missing_entry(_, _, false, []).
missing_entry(Profile, Key, true, [Key]) :-
    profile_lacks(Profile, Key).
missing_entry(Profile, Key, true, []) :-
    profile_has(Profile, Key).

multiple_provisions_t(Profile, true) :-
    profile_has(Profile, infringed_provisions),
    profile_get(Profile, infringed_provisions, Provisions),
    sort(Provisions, Distinct),
    length(Distinct, Count),
    Count >= 2.
multiple_provisions_t(Profile, false) :-
    profile_has(Profile, infringed_provisions),
    profile_get(Profile, infringed_provisions, Provisions),
    sort(Provisions, Distinct),
    length(Distinct, Count),
    Count < 2.
multiple_provisions_t(Profile, false) :-
    profile_lacks(Profile, infringed_provisions).

turnover_needed_t(Profile, true) :-
    profile_lacks(Profile, infringer_is_undertaking).
turnover_needed_t(Profile, false) :-
    profile_get(Profile, infringer_is_undertaking, false).
turnover_needed_t(Profile, true) :-
    profile_get(Profile, infringer_is_undertaking, true).
turnover_needed_t(Profile, true) :-
    profile_get(Profile, infringer_is_undertaking, unsure).

decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(Verdict, Citations)) :-
    administrative_fine_maximum(Profile, Verdict, Citations).

gdpr_administrative_fine_maximum_status(Profile, Status) :-
    administrative_fine_maximum(Profile, Verdict, _),
    verdict_status(Verdict, Status).

verdict_status(fine_maximum(_, _, _), fine_maximum).
verdict_status(separate_fine_maxima(_), separate_fine_maxima).
verdict_status(indeterminate(_), indeterminate).
verdict_status(needs_legal_review(_, _), needs_legal_review).
verdict_status(input_problems(_), input_problems).

gdpr_administrative_fine_maximum_checklist(Profile, Items) :-
    administrative_fine_maximum(Profile, Verdict, Citations),
    checklist_items(Verdict, Citations, Items).

checklist_items(fine_maximum(_, _, _), Citations, Items) :-
    maplist(citation_item, Citations, Items).
checklist_items(separate_fine_maxima(_), Citations, Items) :-
    maplist(citation_item, Citations, Items).
checklist_items(indeterminate(Keys), _, [item(overall, unknown(Keys), cite(eu_reg_2016_679_art_83_4))]).
checklist_items(needs_legal_review(open_textured(Key, Citation), _), _, [item(overall, unknown([Key]), Citation)]).
checklist_items(needs_legal_review(not_governed_here(_), _), _, [item(overall, unmet(not_governed_here), cite(eu_reg_2016_679_art_83_4))]).
checklist_items(input_problems(Problems), _, [item(overall, unmet(Problems), cite(eu_reg_2016_679_art_83_4))]).

citation_item(cite(Key), item(Key, met, cite(Key))).

gdpr_administrative_fine_maximum_decision_resolvable(Profile) :-
    administrative_fine_maximum(Profile, _, _).
