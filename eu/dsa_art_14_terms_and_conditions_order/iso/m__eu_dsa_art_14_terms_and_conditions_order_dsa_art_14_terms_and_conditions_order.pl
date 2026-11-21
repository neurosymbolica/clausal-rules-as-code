% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_14_terms_and_conditions_order_dsa_art_14_terms_and_conditions_order, [art_14_1_terms_and_conditions_content_status/4, art_14_2_significant_change_information_status/4, art_14_3_minors_explanation_status/4, art_14_4_restriction_enforcement_status/4, art_14_5_terms_and_conditions_summary_status/4, art_14_6_official_languages_status/4, decide_dsa_art_14_terms_and_conditions_order/2, dsa_art_14_terms_and_conditions_order_status/2, dsa_art_14_terms_and_conditions_order_checklist/2, dsa_art_14_terms_and_conditions_order_decision_resolvable/1, dsa_art_14_terms_and_conditions_order_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_kernel, [dsa_art_14_terms_and_conditions_order_input_problems/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_citations, [implements/1]).

paragraph_duty(art_14_1, cite(eu_reg_2022_2065_art_14_1)).
paragraph_duty(art_14_2, cite(eu_reg_2022_2065_art_14_2)).
paragraph_duty(art_14_3, cite(eu_reg_2022_2065_art_14_3)).
paragraph_duty(art_14_4, cite(eu_reg_2022_2065_art_14_4)).
paragraph_duty(art_14_5, cite(eu_reg_2022_2065_art_14_5)).
paragraph_duty(art_14_6, cite(eu_reg_2022_2065_art_14_6)).

paragraph_order([art_14_1, art_14_2, art_14_3, art_14_4, art_14_5, art_14_6]).

final_result(art_14_1, art_14_1_terms_and_conditions_compliant, met).
final_result(art_14_1, art_14_1_terms_and_conditions_not_compliant, unmet(art_14_1_terms_and_conditions_not_compliant)).
final_result(art_14_2, art_14_2_change_information_compliant, met).
final_result(art_14_2, art_14_2_change_information_not_compliant, unmet(art_14_2_change_information_not_compliant)).
final_result(art_14_2, art_14_2_change_information_not_required, met).
final_result(art_14_3, art_14_3_minors_explanation_compliant, met).
final_result(art_14_3, art_14_3_minors_explanation_not_compliant, unmet(art_14_3_minors_explanation_not_compliant)).
final_result(art_14_3, art_14_3_minors_explanation_not_required, met).
final_result(art_14_4, art_14_4_restriction_enforcement_compliant, met).
final_result(art_14_4, art_14_4_restriction_enforcement_not_compliant, unmet(art_14_4_restriction_enforcement_not_compliant)).
final_result(art_14_4, art_14_4_restriction_enforcement_not_required, met).
final_result(art_14_5, art_14_5_summary_compliant, met).
final_result(art_14_5, art_14_5_summary_not_compliant, unmet(art_14_5_summary_not_compliant)).
final_result(art_14_5, art_14_5_summary_not_required, met).
final_result(art_14_6, art_14_6_official_languages_compliant, met).
final_result(art_14_6, art_14_6_official_languages_not_compliant, unmet(art_14_6_official_languages_not_compliant)).
final_result(art_14_6, art_14_6_official_languages_not_required, met).

chapter_three_section(section_1, 11, 15, cite(eu_reg_2022_2065_chapter_3_section_1)).
chapter_three_section(section_3, 19, 28, cite(eu_reg_2022_2065_chapter_3_section_3)).

section_exclusion(section_3, micro_or_small_enterprise, cite(eu_reg_2022_2065_art_19_1)).

section_exclusion_derogation(section_3, designated_very_large_online_platform, cite(eu_reg_2022_2065_art_19_2)).

caller_premise(recipient_of_the_service, cite(eu_reg_2022_2065_art_3_b)).
caller_premise(intermediary_service, cite(eu_reg_2022_2065_art_3_g)).
caller_premise(online_platform, cite(eu_reg_2022_2065_art_3_i)).
caller_premise(online_search_engine, cite(eu_reg_2022_2065_art_3_j)).
caller_premise(content_moderation, cite(eu_reg_2022_2065_art_3_t)).
caller_premise(terms_and_conditions, cite(eu_reg_2022_2065_art_3_u)).

dsa_art_14_terms_and_conditions_order_status_values([dsa_art_14_terms_and_conditions_order_compliant, dsa_art_14_terms_and_conditions_order_indeterminate, dsa_art_14_terms_and_conditions_order_not_compliant]).

art_14_1_terms_and_conditions_content_status(Profile, Result, Basis, Citations) :-
    query_answer(art_14_1, Profile, Result, Basis, Citations).

art_14_2_significant_change_information_status(Profile, Result, Basis, Citations) :-
    query_answer(art_14_2, Profile, Result, Basis, Citations).

art_14_3_minors_explanation_status(Profile, Result, Basis, Citations) :-
    query_answer(art_14_3, Profile, Result, Basis, Citations).

art_14_4_restriction_enforcement_status(Profile, Result, Basis, Citations) :-
    query_answer(art_14_4, Profile, Result, Basis, Citations).

art_14_5_terms_and_conditions_summary_status(Profile, Result, Basis, Citations) :-
    query_answer(art_14_5, Profile, Result, Basis, Citations).

art_14_6_official_languages_status(Profile, Result, Basis, Citations) :-
    query_answer(art_14_6, Profile, Result, Basis, Citations).

query_answer(Paragraph, Profile, Result, Basis, Citations) :-
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems),
    checked_answer(Problems, Paragraph, Profile, Result, Basis, Citations).

checked_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), [], []).
checked_answer([], Paragraph, Profile, Result, Basis, Citations) :-
    judged_answer(Paragraph, Profile, Result, Basis, Citations).

key_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).
key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

first_in_state(_, [], none).
first_in_state(Wanted, [Key - Wanted|_], key(Key)).
first_in_state(Wanted, [_ - State|KeyStates], Selection) :-
    dif(State, Wanted),
    first_in_state(Wanted, KeyStates, Selection).

first_missing(key(Key), _, key(Key)).
first_missing(none, Selection, Selection).

present_pairs([], []).
present_pairs([_ - absent|KeyStates], Pairs) :-
    present_pairs(KeyStates, Pairs).
present_pairs([Key - Value|KeyStates], [Key - Value|Pairs]) :-
    dif(Value, absent),
    present_pairs(KeyStates, Pairs).

open_answer(key(Key), _, _, _, indeterminate([Key]), [], []).
open_answer(none, Paragraph, UnsureStates, PairStates, needs_legal_review(open_textured(Key, cite(Paragraph)), [inputs_relied_on(Pairs)]), [], []) :-
    first_in_state(unsure, UnsureStates, key(Key)),
    present_pairs(PairStates, Pairs).

item_outcome(true, met).
item_outcome(false, failed).
item_outcome(unsure, open).
item_outcome(absent, open).

and_outcome(failed, _, failed).
and_outcome(met, Outcome, Outcome).
and_outcome(open, failed, failed).
and_outcome(open, met, open).
and_outcome(open, open, open).

items_outcome(KeyStates, Outcome) :-
    foldl(state_into_outcome, KeyStates, met, Outcome).

state_into_outcome(_ - State, Accumulated, Outcome) :-
    item_outcome(State, ItemOutcome),
    and_outcome(Accumulated, ItemOutcome, Outcome).

judged_answer(art_14_1, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_1),
    key_state(Profile, terms_and_conditions_include_information_on_restrictions_on_recipient_information, RestrictionsState),
    key_state(Profile, terms_and_conditions_include_information_on_content_moderation, ModerationState),
    key_state(Profile, terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, LanguageState),
    key_state(Profile, terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, AvailabilityState),
    key_state(Profile, provider_has_internal_complaint_handling_system, SystemState),
    key_state(Profile, terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system, RulesState),
    ItemStates = [terms_and_conditions_include_information_on_restrictions_on_recipient_information - RestrictionsState, terms_and_conditions_include_information_on_content_moderation - ModerationState, terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language - LanguageState, terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format - AvailabilityState],
    items_outcome(ItemStates, ItemsOutcome),
    complaint_rules_outcome(SystemState, RulesState, ComplaintOutcome),
    and_outcome(ItemsOutcome, ComplaintOutcome, Outcome),
    complaint_rules_review_states(SystemState, RulesState, RulesReviewStates),
    append(ItemStates, RulesReviewStates, ReviewStates),
    first_in_state(absent, ItemStates, ItemMissing),
    complaint_rules_missing(SystemState, RulesState, ComplaintMissing),
    first_missing(ItemMissing, ComplaintMissing, Missing),
    art_14_1_result(Outcome, Missing, ReviewStates, Result, Basis, Citations).
judged_answer(art_14_2, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_2),
    key_state(Profile, terms_and_conditions_changed, ChangedState),
    key_state(Profile, change_to_terms_and_conditions_is_significant, SignificanceState),
    key_state(Profile, recipients_informed_of_change_to_terms_and_conditions, InformedState),
    change_outcome(ChangedState, SignificanceState, InformedState, Outcome),
    AllStates = [terms_and_conditions_changed - ChangedState, change_to_terms_and_conditions_is_significant - SignificanceState, recipients_informed_of_change_to_terms_and_conditions - InformedState],
    JudgementStates = [change_to_terms_and_conditions_is_significant - SignificanceState],
    art_14_2_result(Outcome, AllStates, JudgementStates, Result, Basis, Citations).
judged_answer(art_14_3, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_3),
    key_state(Profile, service_primarily_directed_at_minors, DirectedState),
    key_state(Profile, service_predominantly_used_by_minors, UsedState),
    key_state(Profile, conditions_and_restrictions_explained_in_way_minors_can_understand, ExplainedState),
    minors_duty_applies(DirectedState, UsedState, Applies),
    minors_outcome(Applies, ExplainedState, Outcome),
    minors_review_states(Applies, DirectedState, UsedState, ExplainedState, MissingStates, UnsureStates),
    PairStates = [service_primarily_directed_at_minors - DirectedState, service_predominantly_used_by_minors - UsedState, conditions_and_restrictions_explained_in_way_minors_can_understand - ExplainedState],
    art_14_3_result(Outcome, MissingStates, UnsureStates, PairStates, Result, Basis, Citations).
judged_answer(art_14_4, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_4),
    key_state(Profile, provider_applies_or_enforces_restriction, EnforcesState),
    key_state(Profile, restriction_applied_in_diligent_objective_and_proportionate_manner, MannerState),
    key_state(Profile, restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties, RegardState),
    JudgementStates = [restriction_applied_in_diligent_objective_and_proportionate_manner - MannerState, restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties - RegardState],
    AllStates = [provider_applies_or_enforces_restriction - EnforcesState|JudgementStates],
    enforcement_outcome(EnforcesState, JudgementStates, Outcome),
    art_14_4_result(Outcome, AllStates, JudgementStates, Result, Basis, Citations).
judged_answer(art_14_5, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_5),
    key_state(Profile, designated_as_very_large_online_platform_or_search_engine, Designation),
    key_state(Profile, concise_clear_machine_readable_summary_of_terms_and_conditions_provided, SummaryState),
    designation_class(Designation, DesignationClass),
    art_14_5_result(DesignationClass, Designation, SummaryState, Result, Basis, Citations).
judged_answer(art_14_6, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_6),
    key_state(Profile, designated_as_very_large_online_platform_or_search_engine, Designation),
    key_state(Profile, terms_and_conditions_published_in_official_languages_of_all_member_states_of_service, LanguagesState),
    designation_class(Designation, DesignationClass),
    art_14_6_result(DesignationClass, Designation, LanguagesState, Result, Basis, Citations).

complaint_rules_outcome(false, _, met) :-
    implements(eu_reg_2022_2065_art_14_1).
complaint_rules_outcome(true, RulesState, Outcome) :-
    implements(eu_reg_2022_2065_art_14_1),
    item_outcome(RulesState, Outcome).
complaint_rules_outcome(absent, true, met) :-
    implements(eu_reg_2022_2065_art_14_1).
complaint_rules_outcome(absent, RulesState, open) :-
    implements(eu_reg_2022_2065_art_14_1),
    dif(RulesState, true).

complaint_rules_review_states(false, _, []).
complaint_rules_review_states(true, RulesState, [terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system - RulesState]).
complaint_rules_review_states(absent, RulesState, [terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system - RulesState]).

complaint_rules_missing(absent, true, none) :-
    implements(eu_reg_2022_2065_art_14_1).
complaint_rules_missing(absent, RulesState, key(provider_has_internal_complaint_handling_system)) :-
    implements(eu_reg_2022_2065_art_14_1),
    dif(RulesState, true).
complaint_rules_missing(true, absent, key(terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system)) :-
    implements(eu_reg_2022_2065_art_14_1).
complaint_rules_missing(true, RulesState, none) :-
    implements(eu_reg_2022_2065_art_14_1),
    dif(RulesState, absent).
complaint_rules_missing(false, _, none) :-
    implements(eu_reg_2022_2065_art_14_1).

art_14_1_result(failed, _, _, art_14_1_terms_and_conditions_not_compliant, [], [cite(eu_reg_2022_2065_art_14_1)]) :-
    implements(eu_reg_2022_2065_art_14_1).
art_14_1_result(met, _, _, art_14_1_terms_and_conditions_compliant, [], [cite(eu_reg_2022_2065_art_14_1)]) :-
    implements(eu_reg_2022_2065_art_14_1).
art_14_1_result(open, Missing, ReviewStates, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_1),
    open_answer(Missing, eu_reg_2022_2065_art_14_1, ReviewStates, ReviewStates, Result, Basis, Citations).

change_outcome(false, _, _, not_required) :-
    implements(eu_reg_2022_2065_art_14_2).
change_outcome(true, false, _, not_required) :-
    implements(eu_reg_2022_2065_art_14_2).
change_outcome(true, true, true, compliant) :-
    implements(eu_reg_2022_2065_art_14_2).
change_outcome(true, true, false, not_compliant) :-
    implements(eu_reg_2022_2065_art_14_2).
change_outcome(true, true, absent, open) :-
    implements(eu_reg_2022_2065_art_14_2).
change_outcome(true, unsure, _, open) :-
    implements(eu_reg_2022_2065_art_14_2).
change_outcome(true, absent, _, open) :-
    implements(eu_reg_2022_2065_art_14_2).
change_outcome(absent, false, _, not_required) :-
    implements(eu_reg_2022_2065_art_14_2).
change_outcome(absent, SignificanceState, _, open) :-
    implements(eu_reg_2022_2065_art_14_2),
    dif(SignificanceState, false).

art_14_2_result(not_required, _, _, art_14_2_change_information_not_required, [], [cite(eu_reg_2022_2065_art_14_2)]) :-
    implements(eu_reg_2022_2065_art_14_2).
art_14_2_result(compliant, _, _, art_14_2_change_information_compliant, [], [cite(eu_reg_2022_2065_art_14_2)]) :-
    implements(eu_reg_2022_2065_art_14_2).
art_14_2_result(not_compliant, _, _, art_14_2_change_information_not_compliant, [], [cite(eu_reg_2022_2065_art_14_2)]) :-
    implements(eu_reg_2022_2065_art_14_2).
art_14_2_result(open, AllStates, JudgementStates, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_2),
    first_in_state(absent, AllStates, Missing),
    open_answer(Missing, eu_reg_2022_2065_art_14_2, JudgementStates, JudgementStates, Result, Basis, Citations).

minors_duty_applies(true, _, applies) :-
    implements(eu_reg_2022_2065_art_14_3).
minors_duty_applies(DirectedState, true, applies) :-
    implements(eu_reg_2022_2065_art_14_3),
    dif(DirectedState, true).
minors_duty_applies(false, false, excluded) :-
    implements(eu_reg_2022_2065_art_14_3).
minors_duty_applies(false, unsure, open) :-
    implements(eu_reg_2022_2065_art_14_3).
minors_duty_applies(false, absent, open) :-
    implements(eu_reg_2022_2065_art_14_3).
minors_duty_applies(unsure, UsedState, open) :-
    implements(eu_reg_2022_2065_art_14_3),
    dif(UsedState, true).
minors_duty_applies(absent, UsedState, open) :-
    implements(eu_reg_2022_2065_art_14_3),
    dif(UsedState, true).

minors_outcome(excluded, _, not_required) :-
    implements(eu_reg_2022_2065_art_14_3).
minors_outcome(applies, true, compliant) :-
    implements(eu_reg_2022_2065_art_14_3).
minors_outcome(applies, false, not_compliant) :-
    implements(eu_reg_2022_2065_art_14_3).
minors_outcome(applies, unsure, open) :-
    implements(eu_reg_2022_2065_art_14_3).
minors_outcome(applies, absent, open) :-
    implements(eu_reg_2022_2065_art_14_3).
minors_outcome(open, _, open) :-
    implements(eu_reg_2022_2065_art_14_3).

minors_review_states(open, DirectedState, UsedState, ExplainedState, MissingStates, UnsureStates) :-
    MissingStates = [service_primarily_directed_at_minors - DirectedState, service_predominantly_used_by_minors - UsedState, conditions_and_restrictions_explained_in_way_minors_can_understand - ExplainedState],
    UnsureStates = [service_primarily_directed_at_minors - DirectedState, service_predominantly_used_by_minors - UsedState].
minors_review_states(applies, _, _, ExplainedState, MissingStates, UnsureStates) :-
    MissingStates = [conditions_and_restrictions_explained_in_way_minors_can_understand - ExplainedState],
    UnsureStates = [conditions_and_restrictions_explained_in_way_minors_can_understand - ExplainedState].
minors_review_states(excluded, _, _, _, [], []).

art_14_3_result(not_required, _, _, _, art_14_3_minors_explanation_not_required, [], [cite(eu_reg_2022_2065_art_14_3)]) :-
    implements(eu_reg_2022_2065_art_14_3).
art_14_3_result(compliant, _, _, _, art_14_3_minors_explanation_compliant, [], [cite(eu_reg_2022_2065_art_14_3)]) :-
    implements(eu_reg_2022_2065_art_14_3).
art_14_3_result(not_compliant, _, _, _, art_14_3_minors_explanation_not_compliant, [], [cite(eu_reg_2022_2065_art_14_3)]) :-
    implements(eu_reg_2022_2065_art_14_3).
art_14_3_result(open, MissingStates, UnsureStates, PairStates, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_3),
    first_in_state(absent, MissingStates, Missing),
    open_answer(Missing, eu_reg_2022_2065_art_14_3, UnsureStates, PairStates, Result, Basis, Citations).

enforcement_outcome(false, _, not_required) :-
    implements(eu_reg_2022_2065_art_14_4).
enforcement_outcome(true, JudgementStates, Outcome) :-
    implements(eu_reg_2022_2065_art_14_4),
    items_outcome(JudgementStates, PartsOutcome),
    enforcement_parts_outcome(PartsOutcome, Outcome).
enforcement_outcome(absent, _, open) :-
    implements(eu_reg_2022_2065_art_14_4).

enforcement_parts_outcome(failed, not_compliant).
enforcement_parts_outcome(met, compliant).
enforcement_parts_outcome(open, open).

art_14_4_result(not_required, _, _, art_14_4_restriction_enforcement_not_required, [], [cite(eu_reg_2022_2065_art_14_4)]) :-
    implements(eu_reg_2022_2065_art_14_4).
art_14_4_result(compliant, _, _, art_14_4_restriction_enforcement_compliant, [], [cite(eu_reg_2022_2065_art_14_4)]) :-
    implements(eu_reg_2022_2065_art_14_4).
art_14_4_result(not_compliant, _, _, art_14_4_restriction_enforcement_not_compliant, [], [cite(eu_reg_2022_2065_art_14_4)]) :-
    implements(eu_reg_2022_2065_art_14_4).
art_14_4_result(open, AllStates, JudgementStates, Result, Basis, Citations) :-
    implements(eu_reg_2022_2065_art_14_4),
    first_in_state(absent, AllStates, Missing),
    open_answer(Missing, eu_reg_2022_2065_art_14_4, JudgementStates, JudgementStates, Result, Basis, Citations).

designation_class(absent, absent).
designation_class(attested(true, _), designated) :-
    implements(commission_vlop_or_vlose_designation_decision).
designation_class(attested(false, _), not_designated) :-
    implements(commission_vlop_or_vlose_designation_decision).

art_14_5_result(not_designated, Designation, _, art_14_5_summary_not_required, [outside_fact(designated_as_very_large_online_platform_or_search_engine, Designation)], [cite(eu_reg_2022_2065_art_14_5)]) :-
    implements(eu_reg_2022_2065_art_14_5).
art_14_5_result(designated, Designation, true, art_14_5_summary_compliant, [outside_fact(designated_as_very_large_online_platform_or_search_engine, Designation)], [cite(eu_reg_2022_2065_art_14_5)]) :-
    implements(eu_reg_2022_2065_art_14_5).
art_14_5_result(designated, Designation, false, art_14_5_summary_not_compliant, [outside_fact(designated_as_very_large_online_platform_or_search_engine, Designation)], [cite(eu_reg_2022_2065_art_14_5)]) :-
    implements(eu_reg_2022_2065_art_14_5).
art_14_5_result(designated, _, absent, indeterminate([concise_clear_machine_readable_summary_of_terms_and_conditions_provided]), [], []) :-
    implements(eu_reg_2022_2065_art_14_5).
art_14_5_result(absent, _, absent, indeterminate([concise_clear_machine_readable_summary_of_terms_and_conditions_provided]), [], []) :-
    implements(eu_reg_2022_2065_art_14_5).
art_14_5_result(absent, _, SummaryState, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_5), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on([concise_clear_machine_readable_summary_of_terms_and_conditions_provided - SummaryState, designated_as_very_large_online_platform_or_search_engine - absent])]), [], []) :-
    implements(eu_reg_2022_2065_art_14_5),
    dif(SummaryState, absent).
art_14_5_result(designated, _, unsure, needs_legal_review(open_textured(concise_clear_machine_readable_summary_of_terms_and_conditions_provided, cite(eu_reg_2022_2065_art_14_5)), [inputs_relied_on([concise_clear_machine_readable_summary_of_terms_and_conditions_provided - unsure])]), [], []) :-
    implements(eu_reg_2022_2065_art_14_5).

art_14_6_result(not_designated, Designation, _, art_14_6_official_languages_not_required, [outside_fact(designated_as_very_large_online_platform_or_search_engine, Designation)], [cite(eu_reg_2022_2065_art_14_6)]) :-
    implements(eu_reg_2022_2065_art_14_6).
art_14_6_result(designated, Designation, true, art_14_6_official_languages_compliant, [outside_fact(designated_as_very_large_online_platform_or_search_engine, Designation)], [cite(eu_reg_2022_2065_art_14_6)]) :-
    implements(eu_reg_2022_2065_art_14_6).
art_14_6_result(designated, Designation, false, art_14_6_official_languages_not_compliant, [outside_fact(designated_as_very_large_online_platform_or_search_engine, Designation)], [cite(eu_reg_2022_2065_art_14_6)]) :-
    implements(eu_reg_2022_2065_art_14_6).
art_14_6_result(designated, _, absent, indeterminate([terms_and_conditions_published_in_official_languages_of_all_member_states_of_service]), [], []) :-
    implements(eu_reg_2022_2065_art_14_6).
art_14_6_result(absent, _, absent, indeterminate([terms_and_conditions_published_in_official_languages_of_all_member_states_of_service]), [], []) :-
    implements(eu_reg_2022_2065_art_14_6).
art_14_6_result(absent, _, LanguagesState, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_6), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform_or_search_engine - absent])]), [], []) :-
    implements(eu_reg_2022_2065_art_14_6),
    dif(LanguagesState, absent).

dsa_art_14_terms_and_conditions_order_checklist(Profile, Items) :-
    paragraph_order(Paragraphs),
    maplist(paragraph_item(Profile), Paragraphs, Items).

paragraph_item(Profile, Paragraph, item(Paragraph, Status, Citation)) :-
    paragraph_duty(Paragraph, Citation),
    query_answer(Paragraph, Profile, Result, _, _),
    item_status(Paragraph, Result, Status).

item_status(Paragraph, Result, Status) :-
    atom(Result),
    final_result(Paragraph, Result, Status).
item_status(_, indeterminate(MissingKeys), unknown(MissingKeys)).
item_status(_, needs_legal_review(open_textured(Key, _), _), unknown([Key])).
item_status(_, needs_legal_review(cross_reference_unresolved(_, _), _), unknown([designated_as_very_large_online_platform_or_search_engine])).
item_status(_, input_problems(Problems), unknown(Problems)).

decide_dsa_art_14_terms_and_conditions_order(Profile, dsa_art_14_terms_and_conditions_order_verdict(Status, Citations)) :-
    dsa_art_14_terms_and_conditions_order_checklist(Profile, Items),
    foldl(item_into_roll_up, Items, met, RollUp),
    roll_up_status(RollUp, Status),
    findall(Citation, member(item(_, _, Citation), Items), Citations).

item_into_roll_up(item(_, Status, _), Accumulated, RollUp) :-
    item_class(Status, Class),
    worse_class(Accumulated, Class, RollUp).

item_class(met, met).
item_class(unmet(_), unmet).
item_class(unknown(_), unknown).

worse_class(unmet, _, unmet).
worse_class(unknown, unmet, unmet).
worse_class(unknown, unknown, unknown).
worse_class(unknown, met, unknown).
worse_class(met, Class, Class).

roll_up_status(met, dsa_art_14_terms_and_conditions_order_compliant).
roll_up_status(unknown, dsa_art_14_terms_and_conditions_order_indeterminate).
roll_up_status(unmet, dsa_art_14_terms_and_conditions_order_not_compliant).

dsa_art_14_terms_and_conditions_order_status(Profile, Status) :-
    decide_dsa_art_14_terms_and_conditions_order(Profile, dsa_art_14_terms_and_conditions_order_verdict(Status, _)).

dsa_art_14_terms_and_conditions_order_decision_resolvable(Profile) :-
    decide_dsa_art_14_terms_and_conditions_order(Profile, _).

test(article_14_sits_in_section_1) :-
    chapter_three_section(section_1, FirstArticle, LastArticle, cite(eu_reg_2022_2065_chapter_3_section_1)),
    between(FirstArticle, LastArticle, 14).
test(the_art_19_exclusion_reaches_only_section_3) :-
    findall(Section, section_exclusion(Section, _, _), Sections),
    Sections == [section_3].
test(the_art_19_derogation_is_recorded_for_section_3) :-
    section_exclusion_derogation(section_3, designated_very_large_online_platform, cite(eu_reg_2022_2065_art_19_2)).
test(the_six_caller_premises_are_recorded) :-
    findall(Term, caller_premise(Term, _), Terms),
    length(Terms, 6).
test(art_14_1_compliant_without_a_complaint_system) :-
    findall(Result - Basis - Citations, art_14_1_terms_and_conditions_content_status([attribute(terms_and_conditions_include_information_on_restrictions_on_recipient_information, true), attribute(terms_and_conditions_include_information_on_content_moderation, true), attribute(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, true), attribute(terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, true), attribute(provider_has_internal_complaint_handling_system, false)], Result, Basis, Citations), Answers),
    Answers == [art_14_1_terms_and_conditions_compliant - [] - [cite(eu_reg_2022_2065_art_14_1)]].
test(art_14_1_one_false_item_settles_alone) :-
    findall(Result - Basis - Citations, art_14_1_terms_and_conditions_content_status([attribute(terms_and_conditions_include_information_on_content_moderation, false)], Result, Basis, Citations), Answers),
    Answers == [art_14_1_terms_and_conditions_not_compliant - [] - [cite(eu_reg_2022_2065_art_14_1)]].
test(art_14_1_missing_complaint_rules_fail_item_five) :-
    art_14_1_terms_and_conditions_content_status([attribute(terms_and_conditions_include_information_on_restrictions_on_recipient_information, true), attribute(terms_and_conditions_include_information_on_content_moderation, true), attribute(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, true), attribute(terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, true), attribute(provider_has_internal_complaint_handling_system, true), attribute(terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system, false)], art_14_1_terms_and_conditions_not_compliant, [], [cite(eu_reg_2022_2065_art_14_1)]).
test(art_14_1_empty_profile_names_the_first_item) :-
    findall(Result - Basis - Citations, art_14_1_terms_and_conditions_content_status([], Result, Basis, Citations), Answers),
    Answers == [indeterminate([terms_and_conditions_include_information_on_restrictions_on_recipient_information]) - [] - []].
test(art_14_1_absent_system_is_named_after_the_items) :-
    art_14_1_terms_and_conditions_content_status([attribute(terms_and_conditions_include_information_on_restrictions_on_recipient_information, true), attribute(terms_and_conditions_include_information_on_content_moderation, true), attribute(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, true), attribute(terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, true)], Result, _, _),
    Result == indeterminate([provider_has_internal_complaint_handling_system]).
test(art_14_1_absent_rules_are_named_when_the_system_exists) :-
    art_14_1_terms_and_conditions_content_status([attribute(terms_and_conditions_include_information_on_restrictions_on_recipient_information, true), attribute(terms_and_conditions_include_information_on_content_moderation, true), attribute(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, true), attribute(terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, true), attribute(provider_has_internal_complaint_handling_system, true)], Result, _, _),
    Result == indeterminate([terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system]).
test(art_14_1_missing_item_before_unsure_item) :-
    art_14_1_terms_and_conditions_content_status([attribute(terms_and_conditions_include_information_on_restrictions_on_recipient_information, unsure)], Result, _, _),
    Result == indeterminate([terms_and_conditions_include_information_on_content_moderation]).
test(art_14_1_unsure_item_goes_to_a_lawyer_without_the_rules_pair) :-
    findall(Result - Basis - Citations, art_14_1_terms_and_conditions_content_status([attribute(terms_and_conditions_include_information_on_restrictions_on_recipient_information, unsure), attribute(terms_and_conditions_include_information_on_content_moderation, true), attribute(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, true), attribute(terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, true), attribute(provider_has_internal_complaint_handling_system, false), attribute(terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system, false)], Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(open_textured(terms_and_conditions_include_information_on_restrictions_on_recipient_information, cite(eu_reg_2022_2065_art_14_1)), [inputs_relied_on([terms_and_conditions_include_information_on_restrictions_on_recipient_information - unsure, terms_and_conditions_include_information_on_content_moderation - true, terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language - true, terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format - true])]) - [] - []].
test(art_14_2_no_change_is_not_required) :-
    findall(Result - Basis - Citations, art_14_2_significant_change_information_status([attribute(terms_and_conditions_changed, false)], Result, Basis, Citations), Answers),
    Answers == [art_14_2_change_information_not_required - [] - [cite(eu_reg_2022_2065_art_14_2)]].
test(art_14_2_insignificant_change_with_absent_change_key_is_not_required) :-
    art_14_2_significant_change_information_status([attribute(change_to_terms_and_conditions_is_significant, false)], art_14_2_change_information_not_required, [], [cite(eu_reg_2022_2065_art_14_2)]).
test(art_14_2_informed_significant_change_is_compliant) :-
    art_14_2_significant_change_information_status([attribute(terms_and_conditions_changed, true), attribute(change_to_terms_and_conditions_is_significant, true), attribute(recipients_informed_of_change_to_terms_and_conditions, true)], art_14_2_change_information_compliant, [], [cite(eu_reg_2022_2065_art_14_2)]).
test(art_14_2_uninformed_significant_change_is_not_compliant) :-
    art_14_2_significant_change_information_status([attribute(terms_and_conditions_changed, true), attribute(change_to_terms_and_conditions_is_significant, true), attribute(recipients_informed_of_change_to_terms_and_conditions, false)], art_14_2_change_information_not_compliant, [], [cite(eu_reg_2022_2065_art_14_2)]).
test(art_14_2_absent_information_named_even_with_unsure_significance) :-
    art_14_2_significant_change_information_status([attribute(terms_and_conditions_changed, true), attribute(change_to_terms_and_conditions_is_significant, unsure)], Result, [], []),
    Result == indeterminate([recipients_informed_of_change_to_terms_and_conditions]).
test(art_14_2_unsure_significance_goes_to_a_lawyer) :-
    findall(Result, art_14_2_significant_change_information_status([attribute(terms_and_conditions_changed, true), attribute(change_to_terms_and_conditions_is_significant, unsure), attribute(recipients_informed_of_change_to_terms_and_conditions, false)], Result, _, _), Results),
    Results == [needs_legal_review(open_textured(change_to_terms_and_conditions_is_significant, cite(eu_reg_2022_2065_art_14_2)), [inputs_relied_on([change_to_terms_and_conditions_is_significant - unsure])])].
test(art_14_3_neither_condition_is_not_required) :-
    art_14_3_minors_explanation_status([attribute(service_primarily_directed_at_minors, false), attribute(service_predominantly_used_by_minors, false)], art_14_3_minors_explanation_not_required, [], [cite(eu_reg_2022_2065_art_14_3)]).
test(art_14_3_one_condition_suffices) :-
    art_14_3_minors_explanation_status([attribute(service_predominantly_used_by_minors, true), attribute(conditions_and_restrictions_explained_in_way_minors_can_understand, false)], art_14_3_minors_explanation_not_compliant, [], [cite(eu_reg_2022_2065_art_14_3)]).
test(art_14_3_condition_named_before_explanation) :-
    art_14_3_minors_explanation_status([], Result, [], []),
    Result == indeterminate([service_primarily_directed_at_minors]).
test(art_14_3_explanation_named_when_conditions_are_present) :-
    art_14_3_minors_explanation_status([attribute(service_primarily_directed_at_minors, false), attribute(service_predominantly_used_by_minors, unsure)], Result, [], []),
    Result == indeterminate([conditions_and_restrictions_explained_in_way_minors_can_understand]).
test(art_14_3_unsure_use_goes_to_a_lawyer) :-
    findall(Result, art_14_3_minors_explanation_status([attribute(service_primarily_directed_at_minors, false), attribute(service_predominantly_used_by_minors, unsure), attribute(conditions_and_restrictions_explained_in_way_minors_can_understand, true)], Result, _, _), Results),
    Results == [needs_legal_review(open_textured(service_predominantly_used_by_minors, cite(eu_reg_2022_2065_art_14_3)), [inputs_relied_on([service_primarily_directed_at_minors - false, service_predominantly_used_by_minors - unsure, conditions_and_restrictions_explained_in_way_minors_can_understand - true])])].
test(art_14_4_no_enforcement_is_not_required) :-
    art_14_4_restriction_enforcement_status([attribute(provider_applies_or_enforces_restriction, false)], art_14_4_restriction_enforcement_not_required, [], [cite(eu_reg_2022_2065_art_14_4)]).
test(art_14_4_false_regard_is_not_compliant) :-
    art_14_4_restriction_enforcement_status([attribute(provider_applies_or_enforces_restriction, true), attribute(restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties, false)], art_14_4_restriction_enforcement_not_compliant, [], [cite(eu_reg_2022_2065_art_14_4)]).
test(art_14_4_absent_enforcement_key_named_first) :-
    art_14_4_restriction_enforcement_status([attribute(restriction_applied_in_diligent_objective_and_proportionate_manner, false)], Result, [], []),
    Result == indeterminate([provider_applies_or_enforces_restriction]).
test(art_14_4_unsure_regard_goes_to_a_lawyer) :-
    art_14_4_restriction_enforcement_status([attribute(provider_applies_or_enforces_restriction, true), attribute(restriction_applied_in_diligent_objective_and_proportionate_manner, true), attribute(restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties, unsure)], Result, [], []),
    Result == needs_legal_review(open_textured(restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties, cite(eu_reg_2022_2065_art_14_4)), [inputs_relied_on([restriction_applied_in_diligent_objective_and_proportionate_manner - true, restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties - unsure])]).
test(art_14_5_not_designated_carries_the_statement_as_basis) :-
    Designation = attested(false, attestation(host, at_time, commission_list, none)),
    findall(Result - Basis - Citations, art_14_5_terms_and_conditions_summary_status([attribute(designated_as_very_large_online_platform_or_search_engine, Designation)], Result, Basis, Citations), Answers),
    Answers == [art_14_5_summary_not_required - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Designation)] - [cite(eu_reg_2022_2065_art_14_5)]].
test(art_14_5_designated_without_summary_is_not_compliant) :-
    Designation = attested(true, attestation(host, at_time, commission_decision, none)),
    art_14_5_terms_and_conditions_summary_status([attribute(concise_clear_machine_readable_summary_of_terms_and_conditions_provided, false), attribute(designated_as_very_large_online_platform_or_search_engine, Designation)], art_14_5_summary_not_compliant, [outside_fact(designated_as_very_large_online_platform_or_search_engine, Designation)], [cite(eu_reg_2022_2065_art_14_5)]).
test(art_14_5_missing_summary_named_before_absent_designation) :-
    art_14_5_terms_and_conditions_summary_status([], Result, [], []),
    Result == indeterminate([concise_clear_machine_readable_summary_of_terms_and_conditions_provided]).
test(art_14_5_absent_designation_referred_before_unsure_summary) :-
    art_14_5_terms_and_conditions_summary_status([attribute(concise_clear_machine_readable_summary_of_terms_and_conditions_provided, unsure)], Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_5), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on([concise_clear_machine_readable_summary_of_terms_and_conditions_provided - unsure, designated_as_very_large_online_platform_or_search_engine - absent])]).
test(art_14_5_designated_unsure_summary_goes_to_a_lawyer) :-
    art_14_5_terms_and_conditions_summary_status([attribute(concise_clear_machine_readable_summary_of_terms_and_conditions_provided, unsure), attribute(designated_as_very_large_online_platform_or_search_engine, attested(true, attestation(host, at_time, commission_decision, none)))], Result, [], []),
    Result == needs_legal_review(open_textured(concise_clear_machine_readable_summary_of_terms_and_conditions_provided, cite(eu_reg_2022_2065_art_14_5)), [inputs_relied_on([concise_clear_machine_readable_summary_of_terms_and_conditions_provided - unsure])]).
test(art_14_6_designated_and_published_is_compliant) :-
    Designation = attested(true, attestation(host, at_time, commission_decision, url(source_address, retrieved_time))),
    art_14_6_official_languages_status([attribute(terms_and_conditions_published_in_official_languages_of_all_member_states_of_service, true), attribute(designated_as_very_large_online_platform_or_search_engine, Designation)], art_14_6_official_languages_compliant, [outside_fact(designated_as_very_large_online_platform_or_search_engine, Designation)], [cite(eu_reg_2022_2065_art_14_6)]).
test(art_14_6_absent_designation_is_referred_on) :-
    findall(Result - Basis - Citations, art_14_6_official_languages_status([attribute(terms_and_conditions_published_in_official_languages_of_all_member_states_of_service, false)], Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_6), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform_or_search_engine - absent])]) - [] - []].
test(input_problems_come_first_for_every_query) :-
    findall(Result - Basis - Citations, art_14_5_terms_and_conditions_summary_status([attribute(stray_key, true), attribute(designated_as_very_large_online_platform_or_search_engine, attested(false, attestation(host, at_time, commission_list, none)))], Result, Basis, Citations), Answers),
    Answers == [input_problems([unknown_key(stray_key)]) - [] - []].
test(an_unbound_key_is_reported_as_given) :-
    art_14_2_significant_change_information_status([attribute(Key, true)], Result, [], []),
    Result = input_problems([unknown_key(Named)]),
    Named == Key.
test(facade_roll_up_is_compliant_when_every_duty_is_met_or_not_required) :-
    decide_dsa_art_14_terms_and_conditions_order([attribute(terms_and_conditions_include_information_on_restrictions_on_recipient_information, true), attribute(terms_and_conditions_include_information_on_content_moderation, true), attribute(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, true), attribute(terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format, true), attribute(provider_has_internal_complaint_handling_system, false), attribute(terms_and_conditions_changed, false), attribute(service_primarily_directed_at_minors, false), attribute(service_predominantly_used_by_minors, false), attribute(provider_applies_or_enforces_restriction, false), attribute(designated_as_very_large_online_platform_or_search_engine, attested(false, attestation(host, at_time, commission_list, none)))], Verdict),
    Verdict == dsa_art_14_terms_and_conditions_order_verdict(dsa_art_14_terms_and_conditions_order_compliant, [cite(eu_reg_2022_2065_art_14_1), cite(eu_reg_2022_2065_art_14_2), cite(eu_reg_2022_2065_art_14_3), cite(eu_reg_2022_2065_art_14_4), cite(eu_reg_2022_2065_art_14_5), cite(eu_reg_2022_2065_art_14_6)]).
test(facade_empty_profile_is_indeterminate) :-
    findall(Status, dsa_art_14_terms_and_conditions_order_status([], Status), Statuses),
    Statuses == [dsa_art_14_terms_and_conditions_order_indeterminate].
test(facade_one_breach_is_not_compliant) :-
    dsa_art_14_terms_and_conditions_order_status([attribute(terms_and_conditions_include_information_on_content_moderation, false)], dsa_art_14_terms_and_conditions_order_not_compliant).
test(checklist_items_carry_their_paragraph_citation) :-
    dsa_art_14_terms_and_conditions_order_checklist([], Items),
    member(item(art_14_4, unknown([provider_applies_or_enforces_restriction]), cite(eu_reg_2022_2065_art_14_4)), Items).

test(article_14_is_outside_section_3, fail) :-
    chapter_three_section(section_3, FirstArticle, LastArticle, _),
    between(FirstArticle, LastArticle, 14).
test(the_art_19_exclusion_does_not_reach_section_1, fail) :-
    section_exclusion(section_1, _, _).
test(art_14_1_one_false_item_is_not_compliant_not_compliant, fail) :-
    art_14_1_terms_and_conditions_content_status([attribute(terms_and_conditions_include_information_on_content_moderation, false)], art_14_1_terms_and_conditions_compliant, _, _).
test(facade_one_breach_is_not_indeterminate, fail) :-
    dsa_art_14_terms_and_conditions_order_status([attribute(terms_and_conditions_include_information_on_content_moderation, false)], dsa_art_14_terms_and_conditions_order_indeterminate).
