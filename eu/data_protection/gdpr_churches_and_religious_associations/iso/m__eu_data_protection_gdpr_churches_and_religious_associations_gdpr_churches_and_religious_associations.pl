% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_churches_and_religious_associations_gdpr_churches_and_religious_associations, [church_rules_continuation/4, church_supervision/4, church_rules_may_continue_to_apply/0, church_rules_not_covered_by_article_91_1/0, article_91_2_not_engaged/0, subject_to_independent_supervisory_authority/0, specific_supervisory_authority_permitted/0, specific_supervisory_authority_not_permitted/0, decide_gdpr_churches_and_religious_associations/2, gdpr_churches_and_religious_associations_status/2, gdpr_churches_and_religious_associations_checklist/2, gdpr_churches_and_religious_associations_decision_resolvable/1, gdpr_churches_and_religious_associations_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_kernel, [gdpr_churches_and_religious_associations_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(library(reif), [memberd_t/3]).

church_rules_may_continue_to_apply.

church_rules_not_covered_by_article_91_1.

article_91_2_not_engaged.

subject_to_independent_supervisory_authority.

specific_supervisory_authority_permitted.

specific_supervisory_authority_not_permitted.

article_91_1_conditions([condition(body_is_church_or_religious_association_or_community, stated, cite(eu_reg_2016_679_art_91_1)), condition(rules_applied_in_a_member_state, stated, cite(eu_reg_2016_679_art_91_1)), condition(comprehensive_rules_relating_to_protection_with_regard_to_processing, stated, cite(eu_reg_2016_679_art_91_1)), condition(rules_applied_at_entry_into_force_of_the_regulation, outside_fact, cite(eu_reg_2016_679_art_91_1)), condition(rules_brought_into_line_with_the_regulation, stated, cite(eu_reg_2016_679_art_91_1))]).

gdpr_churches_and_religious_associations_status_values([church_rules_may_continue_to_apply, church_rules_not_covered_by_article_91_1, indeterminate, needs_legal_review, input_problems]).

key_state(stated, Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(stated, Profile, Key, Value) :-
    profile_get(Profile, Key, Value).
key_state(outside_fact, Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(outside_fact, Profile, Key, Value) :-
    profile_get(Profile, Key, attested(Value, _Attestation)).

first_with_state(_, [], none).
first_with_state(Wanted, [Key - Wanted|_], key(Key)).
first_with_state(Wanted, [_ - State|KeyStates], First) :-
    dif(State, Wanted),
    first_with_state(Wanted, KeyStates, First).

condition_states([], _, []).
condition_states([condition(Key, Kind, _Citation)|Conditions], Profile, [Key - State|KeyStates]) :-
    implements(eu_reg_2016_679_art_91_1),
    key_state(Kind, Profile, Key, State),
    condition_states(Conditions, Profile, KeyStates).

article_91_1_reading(Profile, reading(AnyFalse, FirstAbsent, EntryState, FirstUnsure)) :-
    implements(eu_reg_2016_679_art_91_1),
    article_91_1_conditions(Conditions),
    condition_states(Conditions, Profile, KeyStates),
    pairs_values(KeyStates, States),
    memberd_t(false, States, AnyFalse),
    KeyStates = [BodyKey - BodyState, MemberStateKey - MemberStateState, ComprehensiveKey - ComprehensiveState, _ - EntryState, BroughtKey - BroughtState],
    first_with_state(absent, [BodyKey - BodyState, MemberStateKey - MemberStateState, ComprehensiveKey - ComprehensiveState, BroughtKey - BroughtState], FirstAbsent),
    first_with_state(unsure, [ComprehensiveKey - ComprehensiveState, BroughtKey - BroughtState], FirstUnsure).

judgement_values(Profile, ComprehensiveValue, BroughtValue) :-
    profile_get(Profile, comprehensive_rules_relating_to_protection_with_regard_to_processing, ComprehensiveValue),
    profile_get(Profile, rules_brought_into_line_with_the_regulation, BroughtValue).

church_rules_continuation(Profile, Result, Basis, Citations) :-
    gdpr_churches_and_religious_associations_input_problems(Profile, Problems),
    continuation_after_check(Problems, Profile, Result, Basis, Citations).

continuation_after_check([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
continuation_after_check([], Profile, Result, Basis, Citations) :-
    article_91_1_reading(Profile, Reading),
    continuation_route(Reading, Profile, Result, Basis, Citations).

continuation_route(reading(true, _, _, _), _, church_rules_not_covered_by_article_91_1, [], [cite(eu_reg_2016_679_art_91_1)]) :-
    implements(eu_reg_2016_679_art_91_1).
continuation_route(reading(false, key(Key), _, _), _, indeterminate([Key]), [], []) :-
    implements(eu_reg_2016_679_art_91_1).
continuation_route(reading(false, none, absent, _), Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_91_1), cite(rules_applied_at_entry_into_force_statement)), [resolution(cite(rules_applied_at_entry_into_force_statement), not_attempted), inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - ComprehensiveValue, rules_applied_at_entry_into_force_of_the_regulation - absent, rules_brought_into_line_with_the_regulation - BroughtValue])]), [], []) :-
    implements(eu_reg_2016_679_art_91_1),
    judgement_values(Profile, ComprehensiveValue, BroughtValue).
continuation_route(reading(false, none, true, key(Key)), Profile, needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - ComprehensiveValue, rules_brought_into_line_with_the_regulation - BroughtValue])]), [], []) :-
    implements(eu_reg_2016_679_art_91_1),
    judgement_values(Profile, ComprehensiveValue, BroughtValue).
continuation_route(reading(false, none, true, none), Profile, church_rules_may_continue_to_apply, [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Attested)], [cite(eu_reg_2016_679_art_91_1)]) :-
    implements(eu_reg_2016_679_art_91_1),
    profile_get(Profile, rules_applied_at_entry_into_force_of_the_regulation, Attested).

chapter_state(true, Profile, ChapterState) :-
    implements(eu_reg_2016_679_art_91_2),
    key_state(outside_fact, Profile, specific_authority_fulfils_chapter_vi_conditions, ChapterState).
chapter_state(false, _, not_read) :-
    implements(eu_reg_2016_679_art_91_2).
chapter_state(absent, _, not_read) :-
    implements(eu_reg_2016_679_art_91_2).

supervision_reading(Profile, supervision(AnyFalse, FirstAbsent, SpecificState, EntryState, ChapterState, FirstUnsure)) :-
    implements(eu_reg_2016_679_art_91_2),
    article_91_1_reading(Profile, reading(AnyFalse, FirstAbsent, EntryState, FirstUnsure)),
    key_state(stated, Profile, supervisory_authority_is_specific, SpecificState),
    chapter_state(SpecificState, Profile, ChapterState).

church_supervision(Profile, Result, Basis, Citations) :-
    gdpr_churches_and_religious_associations_input_problems(Profile, Problems),
    supervision_after_check(Problems, Profile, Result, Basis, Citations).

supervision_after_check([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
supervision_after_check([], Profile, Result, Basis, Citations) :-
    supervision_reading(Profile, Reading),
    supervision_route(Reading, Profile, Result, Basis, Citations).

supervision_route(supervision(true, _, _, _, _, _), _, article_91_2_not_engaged, [], [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]) :-
    implements(eu_reg_2016_679_art_91_2).
supervision_route(supervision(false, key(Key), _, _, _, _), _, indeterminate([Key]), [], []) :-
    implements(eu_reg_2016_679_art_91_1).
supervision_route(supervision(false, none, absent, _, _, _), _, indeterminate([supervisory_authority_is_specific]), [], []) :-
    implements(eu_reg_2016_679_art_91_2).
supervision_route(supervision(false, none, SpecificState, absent, _, _), Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_91_1), cite(rules_applied_at_entry_into_force_statement)), [resolution(cite(rules_applied_at_entry_into_force_statement), not_attempted), inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - ComprehensiveValue, rules_applied_at_entry_into_force_of_the_regulation - absent, rules_brought_into_line_with_the_regulation - BroughtValue])]), [], []) :-
    implements(eu_reg_2016_679_art_91_1),
    dif(SpecificState, absent),
    judgement_values(Profile, ComprehensiveValue, BroughtValue).
supervision_route(supervision(false, none, true, true, absent, _), Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_91_2), cite(chapter_vi_conditions_statement)), [resolution(cite(chapter_vi_conditions_statement), not_attempted), inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - ComprehensiveValue, rules_brought_into_line_with_the_regulation - BroughtValue, specific_authority_fulfils_chapter_vi_conditions - absent])]), [], []) :-
    implements(eu_reg_2016_679_art_91_2),
    judgement_values(Profile, ComprehensiveValue, BroughtValue).
supervision_route(supervision(false, none, false, true, not_read, key(Key)), Profile, needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - ComprehensiveValue, rules_brought_into_line_with_the_regulation - BroughtValue])]), [], []) :-
    implements(eu_reg_2016_679_art_91_1),
    judgement_values(Profile, ComprehensiveValue, BroughtValue).
supervision_route(supervision(false, none, true, true, ChapterState, key(Key)), Profile, needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - ComprehensiveValue, rules_brought_into_line_with_the_regulation - BroughtValue])]), [], []) :-
    implements(eu_reg_2016_679_art_91_1),
    dif(ChapterState, absent),
    judgement_values(Profile, ComprehensiveValue, BroughtValue).
supervision_route(supervision(false, none, false, true, not_read, none), Profile, subject_to_independent_supervisory_authority, [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Attested)], [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]) :-
    implements(eu_reg_2016_679_art_91_2),
    profile_get(Profile, rules_applied_at_entry_into_force_of_the_regulation, Attested).
supervision_route(supervision(false, none, true, true, true, none), Profile, specific_supervisory_authority_permitted, [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, EntryAttested), outside_fact(specific_authority_fulfils_chapter_vi_conditions, ChapterAttested)], [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]) :-
    implements(eu_reg_2016_679_art_91_2),
    profile_get(Profile, rules_applied_at_entry_into_force_of_the_regulation, EntryAttested),
    profile_get(Profile, specific_authority_fulfils_chapter_vi_conditions, ChapterAttested).
supervision_route(supervision(false, none, true, true, false, none), Profile, specific_supervisory_authority_not_permitted, [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, EntryAttested), outside_fact(specific_authority_fulfils_chapter_vi_conditions, ChapterAttested)], [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]) :-
    implements(eu_reg_2016_679_art_91_2),
    profile_get(Profile, rules_applied_at_entry_into_force_of_the_regulation, EntryAttested),
    profile_get(Profile, specific_authority_fulfils_chapter_vi_conditions, ChapterAttested).

decide_gdpr_churches_and_religious_associations(Profile, gdpr_churches_and_religious_associations_verdict(Status, Citations)) :-
    church_rules_continuation(Profile, Status, _Basis, Citations).

gdpr_churches_and_religious_associations_status(Profile, Status) :-
    decide_gdpr_churches_and_religious_associations(Profile, gdpr_churches_and_religious_associations_verdict(Status, _Citations)).

state_status(true, _, met).
state_status(false, Key, unmet(Key)).
state_status(absent, Key, unknown([Key])).
state_status(unsure, Key, unknown([Key])).

checklist_items([], _, []).
checklist_items([condition(Key, Kind, Citation)|Conditions], Profile, [item(Key, Status, Citation)|Items]) :-
    implements(eu_reg_2016_679_art_91_1),
    key_state(Kind, Profile, Key, State),
    state_status(State, Key, Status),
    checklist_items(Conditions, Profile, Items).

gdpr_churches_and_religious_associations_checklist(Profile, Items) :-
    gdpr_churches_and_religious_associations_input_problems(Profile, []),
    article_91_1_conditions(Conditions),
    checklist_items(Conditions, Profile, Items).

gdpr_churches_and_religious_associations_decision_resolvable(Profile) :-
    decide_gdpr_churches_and_religious_associations(Profile, _Verdict).

sample_attested(Value, attested(Value, attestation(host, moment, reason, none))).

conditions_profile(Comprehensive, Brought, Profile) :-
    sample_attested(true, EntryAttested),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, Comprehensive), attribute(rules_applied_at_entry_into_force_of_the_regulation, EntryAttested), attribute(rules_brought_into_line_with_the_regulation, Brought)].

test(all_conditions_hold_the_rules_may_continue) :-
    conditions_profile(true, true, Profile),
    sample_attested(true, EntryAttested),
    church_rules_continuation(Profile, Result, Basis, Citations),
    Result == church_rules_may_continue_to_apply,
    Basis == [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, EntryAttested)],
    Citations == [cite(eu_reg_2016_679_art_91_1)].
test(continuation_yields_one_solution) :-
    conditions_profile(true, true, Profile),
    findall(Result - Basis - Citations, church_rules_continuation(Profile, Result, Basis, Citations), Answers),
    length(Answers, 1).
test(a_false_body_settles_whatever_is_absent) :-
    church_rules_continuation([attribute(body_is_church_or_religious_association_or_community, false), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, unsure)], Result, Basis, Citations),
    Result == church_rules_not_covered_by_article_91_1,
    Basis == [],
    Citations == [cite(eu_reg_2016_679_art_91_1)].
test(an_attested_false_entry_settles_with_empty_basis) :-
    sample_attested(false, EntryAttested),
    church_rules_continuation([attribute(rules_applied_at_entry_into_force_of_the_regulation, EntryAttested)], Result, Basis, _),
    Result == church_rules_not_covered_by_article_91_1,
    Basis == [].
test(the_first_absent_stated_key_is_named) :-
    church_rules_continuation([attribute(body_is_church_or_religious_association_or_community, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, unsure)], Result, Basis, Citations),
    Result == indeterminate([rules_applied_in_a_member_state]),
    Basis == [],
    Citations == [].
test(an_absent_entry_statement_is_referred) :-
    church_rules_continuation([attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, unsure), attribute(rules_brought_into_line_with_the_regulation, true)], Result, _, _),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_91_1), cite(rules_applied_at_entry_into_force_statement)), [resolution(cite(rules_applied_at_entry_into_force_statement), not_attempted), inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - unsure, rules_applied_at_entry_into_force_of_the_regulation - absent, rules_brought_into_line_with_the_regulation - true])]).
test(an_unsure_bringing_into_line_is_open_textured) :-
    conditions_profile(true, unsure, Profile),
    church_rules_continuation(Profile, Result, Basis, Citations),
    Result == needs_legal_review(open_textured(rules_brought_into_line_with_the_regulation, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - true, rules_brought_into_line_with_the_regulation - unsure])]),
    Basis == [],
    Citations == [].
test(the_first_unsure_judgement_is_referred) :-
    conditions_profile(unsure, unsure, Profile),
    church_rules_continuation(Profile, needs_legal_review(open_textured(Key, _), _), _, _),
    Key == comprehensive_rules_relating_to_protection_with_regard_to_processing.
test(supervision_keys_do_not_change_continuation) :-
    conditions_profile(true, true, Profile),
    church_rules_continuation([attribute(supervisory_authority_is_specific, true)|Profile], Result, _, _),
    Result == church_rules_may_continue_to_apply.
test(a_malformed_profile_gets_its_problems) :-
    church_rules_continuation([attribute(rules_applied_in_a_member_state, unsure)], Result, Basis, Citations),
    Result == input_problems([wrong_type(rules_applied_in_a_member_state)]),
    Basis == [],
    Citations == [].
test(an_authority_not_specific_is_subject_to_supervision) :-
    conditions_profile(true, true, Profile),
    sample_attested(true, EntryAttested),
    church_supervision([attribute(supervisory_authority_is_specific, false)|Profile], Result, Basis, Citations),
    Result == subject_to_independent_supervisory_authority,
    Basis == [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, EntryAttested)],
    clausal_msort(Citations, [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]).
test(chapter_vi_is_not_read_for_an_authority_not_specific) :-
    conditions_profile(true, true, Profile),
    sample_attested(false, ChapterAttested),
    church_supervision([attribute(supervisory_authority_is_specific, false), attribute(specific_authority_fulfils_chapter_vi_conditions, ChapterAttested)|Profile], Result, _, _),
    Result == subject_to_independent_supervisory_authority.
test(a_specific_authority_fulfilling_chapter_vi_is_permitted) :-
    conditions_profile(true, true, Profile),
    sample_attested(true, Attested),
    church_supervision([attribute(supervisory_authority_is_specific, true), attribute(specific_authority_fulfils_chapter_vi_conditions, Attested)|Profile], Result, Basis, _),
    Result == specific_supervisory_authority_permitted,
    Basis == [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Attested), outside_fact(specific_authority_fulfils_chapter_vi_conditions, Attested)].
test(a_specific_authority_not_fulfilling_chapter_vi_is_not_permitted) :-
    conditions_profile(true, true, Profile),
    sample_attested(false, ChapterAttested),
    church_supervision([attribute(supervisory_authority_is_specific, true), attribute(specific_authority_fulfils_chapter_vi_conditions, ChapterAttested)|Profile], Result, _, _),
    Result == specific_supervisory_authority_not_permitted.
test(supervision_yields_one_solution) :-
    conditions_profile(unsure, true, Profile),
    findall(Result, church_supervision([attribute(supervisory_authority_is_specific, true)|Profile], Result, _, _), Results),
    length(Results, 1).
test(a_false_condition_does_not_engage_article_91_2) :-
    church_supervision([attribute(rules_applied_in_a_member_state, false)], Result, Basis, Citations),
    Result == article_91_2_not_engaged,
    Basis == [],
    clausal_msort(Citations, [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]).
test(specificity_is_asked_before_the_entry_statement_is_referred) :-
    church_supervision([attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_brought_into_line_with_the_regulation, true)], Result, _, _),
    Result == indeterminate([supervisory_authority_is_specific]).
test(an_absent_entry_statement_is_referred_in_supervision) :-
    church_supervision([attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, true)], Result, _, _),
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_91_1), cite(rules_applied_at_entry_into_force_statement)), _).
test(an_absent_chapter_vi_statement_is_referred_before_an_unsure_judgement) :-
    conditions_profile(unsure, true, Profile),
    church_supervision([attribute(supervisory_authority_is_specific, true)|Profile], Result, Basis, Citations),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_91_2), cite(chapter_vi_conditions_statement)), [resolution(cite(chapter_vi_conditions_statement), not_attempted), inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - unsure, rules_brought_into_line_with_the_regulation - true, specific_authority_fulfils_chapter_vi_conditions - absent])]),
    Basis == [],
    Citations == [].
test(an_unsure_judgement_is_referred_for_an_authority_not_specific) :-
    conditions_profile(true, unsure, Profile),
    church_supervision([attribute(supervisory_authority_is_specific, false)|Profile], Result, _, _),
    Result == needs_legal_review(open_textured(rules_brought_into_line_with_the_regulation, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on([comprehensive_rules_relating_to_protection_with_regard_to_processing - true, rules_brought_into_line_with_the_regulation - unsure])]).
test(the_checklist_cites_every_condition) :-
    conditions_profile(true, unsure, Profile),
    gdpr_churches_and_religious_associations_checklist(Profile, Items),
    length(Items, 5),
    member(item(rules_brought_into_line_with_the_regulation, unknown([rules_brought_into_line_with_the_regulation]), cite(eu_reg_2016_679_art_91_1)), Items),
    member(item(body_is_church_or_religious_association_or_community, met, cite(eu_reg_2016_679_art_91_1)), Items).
test(the_facade_projects_the_continuation_status) :-
    conditions_profile(true, true, Profile),
    gdpr_churches_and_religious_associations_status(Profile, Status),
    Status == church_rules_may_continue_to_apply.

test(all_conditions_hold_is_not_cut, fail) :-
    conditions_profile(true, true, Profile),
    church_rules_continuation(Profile, church_rules_not_covered_by_article_91_1, _, _).
test(not_fulfilling_chapter_vi_is_not_permitted_answer_only, fail) :-
    conditions_profile(true, true, Profile),
    sample_attested(false, ChapterAttested),
    church_supervision([attribute(supervisory_authority_is_specific, true), attribute(specific_authority_fulfils_chapter_vi_conditions, ChapterAttested)|Profile], specific_supervisory_authority_permitted, _, _).
