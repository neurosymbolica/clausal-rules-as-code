% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_churches_and_religious_associations_queries, [gdpr_churches_and_religious_associations_profile_keys/1, gdpr_churches_and_religious_associations_what_if/4, gdpr_churches_and_religious_associations_eligibility/2, body_is_church_or_religious_association_or_community/0, rules_applied_in_a_member_state/0, comprehensive_rules_relating_to_protection_with_regard_to_processing/0, rules_applied_at_entry_into_force_of_the_regulation/0, rules_brought_into_line_with_the_regulation/0, supervisory_authority_is_specific/0, specific_authority_fulfils_chapter_vi_conditions/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_kernel, [gdpr_churches_and_religious_associations_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_gdpr_churches_and_religious_associations, [gdpr_churches_and_religious_associations_status/2, gdpr_churches_and_religious_associations_checklist/2, church_rules_continuation/4]).

gdpr_churches_and_religious_associations_profile_keys([body_is_church_or_religious_association_or_community, rules_applied_in_a_member_state, comprehensive_rules_relating_to_protection_with_regard_to_processing, rules_applied_at_entry_into_force_of_the_regulation, rules_brought_into_line_with_the_regulation, supervisory_authority_is_specific, specific_authority_fulfils_chapter_vi_conditions]).

body_is_church_or_religious_association_or_community.

rules_applied_in_a_member_state.

comprehensive_rules_relating_to_protection_with_regard_to_processing.

rules_applied_at_entry_into_force_of_the_regulation.

rules_brought_into_line_with_the_regulation.

supervisory_authority_is_specific.

specific_authority_fulfils_chapter_vi_conditions.

unsure.

gdpr_churches_and_religious_associations_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_churches_and_religious_associations_status(Hypothesis, NewStatus).

override_attribute(Profile, Key, Value, Hypothesis) :-
    remove_attribute(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], Hypothesis).

remove_attribute([], _, []).
remove_attribute([attribute(ElementKey, _)|Elements], Key, Kept) :-
    ElementKey == Key,
    remove_attribute(Elements, Key, Kept).
remove_attribute([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Kept]) :-
    ElementKey \== Key,
    remove_attribute(Elements, Key, Kept).

gdpr_churches_and_religious_associations_eligibility(Profile, assessment(Profile, Label, Checklist)) :-
    church_rules_continuation(Profile, Result, _Basis, _Citations),
    result_label(Result, Label),
    gdpr_churches_and_religious_associations_input_problems(Profile, Problems),
    eligibility_checklist(Problems, Profile, Checklist).

result_label(church_rules_may_continue_to_apply, eligible).
result_label(church_rules_not_covered_by_article_91_1, ineligible).
result_label(indeterminate(_), indeterminate).
result_label(needs_legal_review(_, _), indeterminate).
result_label(input_problems(_), indeterminate).

eligibility_checklist([], Profile, Items) :-
    gdpr_churches_and_religious_associations_checklist(Profile, Items).
eligibility_checklist([_|_], _, []).

test(an_empty_profile_is_indeterminate_with_five_cited_items) :-
    gdpr_churches_and_religious_associations_eligibility([], assessment(_, Label, Items)),
    Label == indeterminate,
    length(Items, 5).
test(a_false_body_is_ineligible) :-
    gdpr_churches_and_religious_associations_eligibility([attribute(body_is_church_or_religious_association_or_community, false)], assessment(_, Label, _)),
    Label == ineligible.
test(a_malformed_profile_is_indeterminate_with_no_checklist) :-
    gdpr_churches_and_religious_associations_eligibility([attribute(rules_applied_in_a_member_state, unsure)], assessment(_, Label, Items)),
    Label == indeterminate,
    Items == [].
test(the_profile_key_schema_has_seven_keys) :-
    gdpr_churches_and_religious_associations_profile_keys(Keys),
    length(Keys, 7).
test(the_override_replaces_the_key_once) :-
    override_attribute([attribute(rules_applied_in_a_member_state, true)], rules_applied_in_a_member_state, false, Hypothesis),
    Hypothesis == [attribute(rules_applied_in_a_member_state, false)].
test(what_if_a_false_body_on_an_empty_profile) :-
    gdpr_churches_and_religious_associations_what_if([], body_is_church_or_religious_association_or_community, false, Status),
    Status == church_rules_not_covered_by_article_91_1.
test(the_root_atoms_are_served) :-
    unsure,
    body_is_church_or_religious_association_or_community,
    specific_authority_fulfils_chapter_vi_conditions.

test(a_false_body_is_not_eligible, fail) :-
    gdpr_churches_and_religious_associations_eligibility([attribute(body_is_church_or_religious_association_or_community, false)], assessment(_, eligible, _)).
