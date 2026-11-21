% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_gdpr_representation_and_suspension, [mandated_representation/5, representation_without_mandate/5, court_contact_duty/3, court_suspension_option/3, court_declining_jurisdiction_option/4, decide_gdpr_representation_and_suspension/2, gdpr_representation_and_suspension_status/2, gdpr_representation_and_suspension_checklist/2, gdpr_representation_and_suspension_decision_resolvable/1, gdpr_representation_and_suspension_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_kernel, [gdpr_representation_and_suspension_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_citations, [implements/1]).

gdpr_representation_and_suspension_status_values([may_act_on_mandate, may_not_act_on_mandate, may_act_without_mandate, may_not_act_without_mandate, contact_duty_applies, contact_duty_does_not_apply, may_suspend_proceedings, suspension_not_available, may_decline_jurisdiction, declining_jurisdiction_not_available]).

action_atoms([lodge_complaint_under_article_77, exercise_rights_under_article_78, exercise_right_under_article_79, receive_compensation_under_article_82]).

action_scope(lodge_complaint_under_article_77, remedy, cite(eu_reg_2016_679_art_80_1)).
action_scope(exercise_rights_under_article_78, remedy, cite(eu_reg_2016_679_art_80_1)).
action_scope(exercise_right_under_article_79, remedy, cite(eu_reg_2016_679_art_80_1)).
action_scope(receive_compensation_under_article_82, compensation, cite(eu_reg_2016_679_art_80_1)).

mandated_conditions(remedy, cite(eu_reg_2016_679_art_80_1), [condition(body_is_not_for_profit, crisp, true), condition(body_properly_constituted_under_member_state_law, judgement, true), condition(body_statutory_objectives_in_public_interest, judgement, true), condition(body_active_in_protection_of_data_subjects_rights_and_freedoms, judgement, true), condition(data_subject_mandated_the_body, crisp, true)]).
mandated_conditions(compensation, cite(eu_reg_2016_679_art_80_1), [condition(body_is_not_for_profit, crisp, true), condition(body_properly_constituted_under_member_state_law, judgement, true), condition(body_statutory_objectives_in_public_interest, judgement, true), condition(body_active_in_protection_of_data_subjects_rights_and_freedoms, judgement, true), condition(data_subject_mandated_the_body, crisp, true), condition(member_state_law_provides_for_mandated_compensation_claims, outside_fact, true)]).

mandated_policy(remedy, refer_after_missing, cite(eu_reg_2016_679_art_80_1)).
mandated_policy(compensation, refer_first, cite(eu_reg_2016_679_art_80_1)).

without_mandate_conditions(cite(eu_reg_2016_679_art_80_2), [condition(body_is_not_for_profit, crisp, true), condition(body_properly_constituted_under_member_state_law, judgement, true), condition(body_statutory_objectives_in_public_interest, judgement, true), condition(body_active_in_protection_of_data_subjects_rights_and_freedoms, judgement, true), condition(member_state_law_provides_for_the_action_without_mandate, outside_fact, true), condition(body_considers_data_subject_rights_infringed_by_processing, crisp, true)]).

court_contact_conditions(cite(eu_reg_2016_679_art_81_1), [condition(court_is_competent_court, crisp, true), condition(court_has_information_on_proceedings_pending_in_another_member_state, crisp, true), condition(other_proceedings_concern_same_controller_or_processor, crisp, true), condition(other_proceedings_concern_same_subject_matter, judgement, true)]).

court_suspension_conditions(cite(eu_reg_2016_679_art_81_2), [condition(court_is_competent_court, crisp, true), condition(other_proceedings_pending_in_court_of_another_member_state, crisp, true), condition(other_proceedings_concern_same_controller_or_processor, crisp, true), condition(other_proceedings_concern_same_subject_matter, judgement, true), condition(court_is_court_first_seized, crisp, false)]).

court_declining_conditions(cite(eu_reg_2016_679_art_81_3), [condition(other_proceedings_pending_in_court_of_another_member_state, crisp, true), condition(other_proceedings_concern_same_controller_or_processor, crisp, true), condition(other_proceedings_concern_same_subject_matter, judgement, true), condition(court_is_court_first_seized, crisp, false), condition(other_proceedings_pending_at_first_instance, crisp, true), condition(party_applied_for_court_to_decline_jurisdiction, crisp, true), condition(court_first_seized_has_jurisdiction_over_the_actions, outside_fact, true), condition(law_of_court_first_seized_permits_consolidation, outside_fact, true)]).

outside_fact_row(member_state_law_provides_for_mandated_compensation_claims, cite(eu_reg_2016_679_art_80_1), cite(member_state_law_on_mandated_compensation_claims_statement)).
outside_fact_row(member_state_law_provides_for_the_action_without_mandate, cite(eu_reg_2016_679_art_80_2), cite(member_state_law_on_action_without_mandate_statement)).
outside_fact_row(court_first_seized_has_jurisdiction_over_the_actions, cite(eu_reg_2016_679_art_81_3), cite(court_first_seized_jurisdiction_statement)).
outside_fact_row(law_of_court_first_seized_permits_consolidation, cite(eu_reg_2016_679_art_81_3), cite(consolidation_under_law_of_court_first_seized_statement)).

article_80_problems(Profile, Action, Problems) :-
    gdpr_representation_and_suspension_input_problems(Profile, ProfileProblems),
    action_valid_t(Action, ActionIsValid),
    action_problems(ActionIsValid, ActionProblems),
    append(ProfileProblems, ActionProblems, Problems).

action_valid_t(Action, false) :-
    var(Action).
action_valid_t(Action, Truth) :-
    nonvar(Action),
    action_atoms(Actions),
    memberd_t(Action, Actions, Truth).

action_problems(true, []).
action_problems(false, [wrong_type(action)]).

mandated_representation(Profile, Action, Result, Basis, Citations) :-
    article_80_problems(Profile, Action, Problems),
    mandated_answer(Problems, Profile, Action, Result, Basis, Citations).

mandated_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), [], []).
mandated_answer([], Profile, Action, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_80_1),
    action_scope(Action, Scope, _),
    mandated_conditions(Scope, cite(CitationKey), Conditions),
    mandated_policy(Scope, Policy, _),
    evaluate(Policy, Conditions, answer_atoms(may_act_on_mandate, may_not_act_on_mandate, CitationKey), Profile, Result, Basis, Citations).

representation_without_mandate(Profile, Action, Result, Basis, Citations) :-
    article_80_problems(Profile, Action, Problems),
    without_mandate_answer(Problems, Profile, Action, Result, Basis, Citations).

without_mandate_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), [], []).
without_mandate_answer([], Profile, Action, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_80_2),
    action_scope(Action, Scope, _),
    without_mandate_scope_answer(Scope, Profile, Result, Basis, Citations).

without_mandate_scope_answer(compensation, _, may_not_act_without_mandate, [], [cite(eu_reg_2016_679_art_80_2)]) :-
    implements(eu_reg_2016_679_art_80_2).
without_mandate_scope_answer(remedy, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_80_2),
    without_mandate_conditions(cite(CitationKey), Conditions),
    evaluate(refer_after_missing, Conditions, answer_atoms(may_act_without_mandate, may_not_act_without_mandate, CitationKey), Profile, Result, Basis, Citations).

court_contact_duty(Profile, Result, Citations) :-
    gdpr_representation_and_suspension_input_problems(Profile, Problems),
    court_contact_answer(Problems, Profile, Result, Citations).

court_contact_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
court_contact_answer([], Profile, Result, Citations) :-
    implements(eu_reg_2016_679_art_81_1),
    court_contact_conditions(cite(CitationKey), Conditions),
    evaluate(refer_after_missing, Conditions, answer_atoms(contact_duty_applies, contact_duty_does_not_apply, CitationKey), Profile, Result, _NoBasis, Citations).

court_suspension_option(Profile, Result, Citations) :-
    gdpr_representation_and_suspension_input_problems(Profile, Problems),
    court_suspension_answer(Problems, Profile, Result, Citations).

court_suspension_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
court_suspension_answer([], Profile, Result, Citations) :-
    implements(eu_reg_2016_679_art_81_2),
    court_suspension_conditions(cite(CitationKey), Conditions),
    evaluate(refer_after_missing, Conditions, answer_atoms(may_suspend_proceedings, suspension_not_available, CitationKey), Profile, Result, _NoBasis, Citations).

court_declining_jurisdiction_option(Profile, Result, Basis, Citations) :-
    gdpr_representation_and_suspension_input_problems(Profile, Problems),
    court_declining_answer(Problems, Profile, Result, Basis, Citations).

court_declining_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
court_declining_answer([], Profile, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_81_3),
    court_declining_conditions(cite(CitationKey), Conditions),
    evaluate(refer_after_missing, Conditions, answer_atoms(may_decline_jurisdiction, declining_jurisdiction_not_available, CitationKey), Profile, Result, Basis, Citations).

evaluate(Policy, Conditions, AnswerAtoms, Profile, Result, Basis, Citations) :-
    condition_statuses(Conditions, Profile, Statuses),
    outcome(Policy, Statuses, Outcome),
    render(Outcome, AnswerAtoms, Profile, Conditions, Result, Basis, Citations).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, value(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

condition_statuses([], _, []).
condition_statuses([condition(Key, ConditionKind, Wanted)|Conditions], Profile, [Key - Status|Statuses]) :-
    key_state(Profile, Key, KeyState),
    condition_status(ConditionKind, Wanted, KeyState, Status),
    condition_statuses(Conditions, Profile, Statuses).

opposite(true, false).
opposite(false, true).

condition_status(crisp, _, absent, missing).
condition_status(crisp, Wanted, value(Wanted), ok).
condition_status(crisp, Wanted, value(Opposite), fail) :-
    opposite(Wanted, Opposite).
condition_status(judgement, _, absent, missing).
condition_status(judgement, _, value(unsure), unsure).
condition_status(judgement, Wanted, value(Wanted), ok).
condition_status(judgement, Wanted, value(Opposite), fail) :-
    opposite(Wanted, Opposite).
condition_status(outside_fact, _, absent, referral).
condition_status(outside_fact, Wanted, value(attested(Wanted, _)), ok).
condition_status(outside_fact, Wanted, value(attested(Opposite, _)), fail) :-
    opposite(Wanted, Opposite).

first_with([], _, none).
first_with([Key - Category|_], Category, found(Key)).
first_with([_ - OtherCategory|Statuses], Category, Found) :-
    dif(OtherCategory, Category),
    first_with(Statuses, Category, Found).

outcome(refer_after_missing, Statuses, Outcome) :-
    first_with(Statuses, fail, Failed),
    first_with(Statuses, missing, Missing),
    first_with(Statuses, referral, Referral),
    first_with(Statuses, unsure, Unsure),
    status_ladder(Failed, Missing, Referral, Unsure, Outcome).
outcome(refer_first, Statuses, Outcome) :-
    first_with(Statuses, fail, Failed),
    first_with(Statuses, missing, Missing),
    first_with(Statuses, referral, Referral),
    first_with(Statuses, unsure, Unsure),
    status_ladder_refer_first(Failed, Referral, Missing, Unsure, Outcome).

status_ladder(found(_), _, _, _, negative).
status_ladder(none, found(Key), _, _, missing(Key)).
status_ladder(none, none, found(Key), _, referral(Key)).
status_ladder(none, none, none, found(Key), unsure(Key)).
status_ladder(none, none, none, none, positive).

status_ladder_refer_first(found(_), _, _, _, negative).
status_ladder_refer_first(none, found(Key), _, _, referral(Key)).
status_ladder_refer_first(none, none, found(Key), _, missing(Key)).
status_ladder_refer_first(none, none, none, found(Key), unsure(Key)).
status_ladder_refer_first(none, none, none, none, positive).

render(positive, answer_atoms(Positive, _, CitationKey), Profile, Conditions, Positive, Basis, [cite(CitationKey)]) :-
    present_basis(Conditions, Profile, Basis).
render(negative, answer_atoms(_, Negative, CitationKey), Profile, Conditions, Negative, Basis, [cite(CitationKey)]) :-
    present_basis(Conditions, Profile, Basis).
render(missing(Key), _, _, _, indeterminate([Key]), [], []).
render(referral(Key), _, _, _, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([Key - absent])]), [], []) :-
    outside_fact_row(Key, Citation, Target).
render(unsure(Key), answer_atoms(_, _, CitationKey), Profile, Conditions, needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]), [], []) :-
    judgement_pairs(Conditions, Profile, Pairs).

present_basis([], _, []).
present_basis([condition(Key, ConditionKind, _)|Conditions], Profile, Basis) :-
    key_state(Profile, Key, KeyState),
    present_basis(Conditions, Profile, LaterBasis),
    basis_entry(ConditionKind, KeyState, Key, LaterBasis, Basis).

basis_entry(outside_fact, value(Attested), Key, LaterBasis, [outside_fact(Key, Attested)|LaterBasis]).
basis_entry(outside_fact, absent, _, LaterBasis, LaterBasis).
basis_entry(crisp, _, _, LaterBasis, LaterBasis).
basis_entry(judgement, _, _, LaterBasis, LaterBasis).

judgement_pairs([], _, []).
judgement_pairs([condition(Key, ConditionKind, _)|Conditions], Profile, Pairs) :-
    key_state(Profile, Key, KeyState),
    judgement_pairs(Conditions, Profile, LaterPairs),
    pair_entry(ConditionKind, KeyState, Key, LaterPairs, Pairs).

pair_entry(judgement, value(Value), Key, LaterPairs, [Key - Value|LaterPairs]).
pair_entry(judgement, absent, _, LaterPairs, LaterPairs).
pair_entry(crisp, _, _, LaterPairs, LaterPairs).
pair_entry(outside_fact, _, _, LaterPairs, LaterPairs).

decide_gdpr_representation_and_suspension(mandated_representation(Profile, Action), gdpr_representation_and_suspension_verdict(Result, Basis, Citations)) :-
    mandated_representation(Profile, Action, Result, Basis, Citations).
decide_gdpr_representation_and_suspension(representation_without_mandate(Profile, Action), gdpr_representation_and_suspension_verdict(Result, Basis, Citations)) :-
    representation_without_mandate(Profile, Action, Result, Basis, Citations).
decide_gdpr_representation_and_suspension(court_contact_duty(Profile), gdpr_representation_and_suspension_verdict(Result, [], Citations)) :-
    court_contact_duty(Profile, Result, Citations).
decide_gdpr_representation_and_suspension(court_suspension_option(Profile), gdpr_representation_and_suspension_verdict(Result, [], Citations)) :-
    court_suspension_option(Profile, Result, Citations).
decide_gdpr_representation_and_suspension(court_declining_jurisdiction_option(Profile), gdpr_representation_and_suspension_verdict(Result, Basis, Citations)) :-
    court_declining_jurisdiction_option(Profile, Result, Basis, Citations).

gdpr_representation_and_suspension_status(Request, Result) :-
    decide_gdpr_representation_and_suspension(Request, gdpr_representation_and_suspension_verdict(Result, _Basis, _Citations)).

gdpr_representation_and_suspension_decision_resolvable(Request) :-
    decide_gdpr_representation_and_suspension(Request, _Verdict).

request_citation(mandated_representation(_, _), cite(eu_reg_2016_679_art_80_1)).
request_citation(representation_without_mandate(_, _), cite(eu_reg_2016_679_art_80_2)).
request_citation(court_contact_duty(_), cite(eu_reg_2016_679_art_81_1)).
request_citation(court_suspension_option(_), cite(eu_reg_2016_679_art_81_2)).
request_citation(court_declining_jurisdiction_option(_), cite(eu_reg_2016_679_art_81_3)).

request_problems(mandated_representation(Profile, Action), Problems) :-
    article_80_problems(Profile, Action, Problems).
request_problems(representation_without_mandate(Profile, Action), Problems) :-
    article_80_problems(Profile, Action, Problems).
request_problems(court_contact_duty(Profile), Problems) :-
    gdpr_representation_and_suspension_input_problems(Profile, Problems).
request_problems(court_suspension_option(Profile), Problems) :-
    gdpr_representation_and_suspension_input_problems(Profile, Problems).
request_problems(court_declining_jurisdiction_option(Profile), Problems) :-
    gdpr_representation_and_suspension_input_problems(Profile, Problems).

gdpr_representation_and_suspension_checklist(Request, Items) :-
    request_problems(Request, Problems),
    request_citation(Request, Citation),
    checklist_for(Problems, Request, Citation, Items).

checklist_for([Problem|Problems], _, Citation, [item(input_check, unmet(input_problems([Problem|Problems])), Citation)]).
checklist_for([], Request, Citation, Items) :-
    request_items(Request, Citation, Items).

request_items(mandated_representation(Profile, Action), Citation, Items) :-
    implements(eu_reg_2016_679_art_80_1),
    action_scope(Action, Scope, _),
    mandated_conditions(Scope, _, Conditions),
    condition_items(Conditions, Profile, Citation, Items).
request_items(representation_without_mandate(Profile, Action), Citation, Items) :-
    implements(eu_reg_2016_679_art_80_2),
    action_scope(Action, Scope, _),
    without_mandate_items(Scope, Profile, Citation, Items).
request_items(court_contact_duty(Profile), Citation, Items) :-
    implements(eu_reg_2016_679_art_81_1),
    court_contact_conditions(_, Conditions),
    condition_items(Conditions, Profile, Citation, Items).
request_items(court_suspension_option(Profile), Citation, Items) :-
    implements(eu_reg_2016_679_art_81_2),
    court_suspension_conditions(_, Conditions),
    condition_items(Conditions, Profile, Citation, Items).
request_items(court_declining_jurisdiction_option(Profile), Citation, Items) :-
    implements(eu_reg_2016_679_art_81_3),
    court_declining_conditions(_, Conditions),
    condition_items(Conditions, Profile, Citation, Items).

without_mandate_items(compensation, _, Citation, [item(action_named_in_article_80_2, unmet(receive_compensation_under_article_82), Citation)]) :-
    implements(eu_reg_2016_679_art_80_2).
without_mandate_items(remedy, Profile, Citation, Items) :-
    implements(eu_reg_2016_679_art_80_2),
    without_mandate_conditions(_, Conditions),
    condition_items(Conditions, Profile, Citation, Items).

condition_items([], _, _, []).
condition_items([condition(Key, ConditionKind, Wanted)|Conditions], Profile, Citation, [item(Key, ItemStatus, Citation)|Items]) :-
    key_state(Profile, Key, KeyState),
    condition_status(ConditionKind, Wanted, KeyState, Status),
    item_status(Status, Key, ItemStatus),
    condition_items(Conditions, Profile, Citation, Items).

item_status(ok, _, met).
item_status(fail, Key, unmet(Key)).
item_status(missing, Key, unknown([Key])).
item_status(referral, Key, unknown([Key])).
item_status(unsure, Key, unknown([Key])).

example_profile(qualified_body_mandated, [attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, true), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, true), attribute(data_subject_mandated_the_body, true)]).
example_profile(qualified_body_considering, [attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, true), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, true), attribute(body_considers_data_subject_rights_infringed_by_processing, true)]).
example_profile(court_with_related_proceedings, [attribute(court_is_competent_court, true), attribute(court_has_information_on_proceedings_pending_in_another_member_state, true), attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true), attribute(court_is_court_first_seized, false), attribute(other_proceedings_pending_at_first_instance, true), attribute(party_applied_for_court_to_decline_jurisdiction, true)]).

attested_true(attested(true, attestation(host, moment, reason, none))).

attested_false(attested(false, attestation(host, moment, reason, none))).

test(a_mandated_qualified_body_may_lodge_a_complaint) :-
    example_profile(qualified_body_mandated, Profile),
    findall(Result - Basis - Citations, mandated_representation(Profile, lodge_complaint_under_article_77, Result, Basis, Citations), Answers),
    Answers == [may_act_on_mandate - [] - [cite(eu_reg_2016_679_art_80_1)]].
test(no_mandate_means_no_action_on_mandate) :-
    mandated_representation([attribute(data_subject_mandated_the_body, false)], exercise_right_under_article_79, may_not_act_on_mandate, [], [cite(eu_reg_2016_679_art_80_1)]).
test(compensation_needs_attested_member_state_law) :-
    example_profile(qualified_body_mandated, BodyProfile),
    attested_true(Attested),
    append(BodyProfile, [attribute(member_state_law_provides_for_mandated_compensation_claims, Attested)], Profile),
    findall(Result - Basis, mandated_representation(Profile, receive_compensation_under_article_82, Result, Basis, _), Answers),
    Answers == [may_act_on_mandate - [outside_fact(member_state_law_provides_for_mandated_compensation_claims, Attested)]].
test(compensation_attested_false_settles_and_shows_basis) :-
    attested_false(Attested),
    mandated_representation([attribute(member_state_law_provides_for_mandated_compensation_claims, Attested)], receive_compensation_under_article_82, Result, Basis, Citations),
    Result == may_not_act_on_mandate,
    Basis == [outside_fact(member_state_law_provides_for_mandated_compensation_claims, Attested)],
    Citations == [cite(eu_reg_2016_679_art_80_1)].
test(compensation_refers_first_under_d204) :-
    mandated_representation([attribute(body_is_not_for_profit, true)], receive_compensation_under_article_82, Result, Basis, Citations),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_80_1), cite(member_state_law_on_mandated_compensation_claims_statement)), [resolution(cite(member_state_law_on_mandated_compensation_claims_statement), not_attempted), inputs_relied_on([member_state_law_provides_for_mandated_compensation_claims - absent])]),
    Basis == [],
    Citations == [].
test(a_complaint_names_the_first_missing_key) :-
    mandated_representation([attribute(body_is_not_for_profit, true)], lodge_complaint_under_article_77, indeterminate([body_properly_constituted_under_member_state_law]), [], []).
test(an_unsure_judgement_goes_to_a_lawyer) :-
    mandated_representation([attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, unsure), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, true), attribute(data_subject_mandated_the_body, true)], exercise_rights_under_article_78, Result, [], []),
    Result == needs_legal_review(open_textured(body_statutory_objectives_in_public_interest, cite(eu_reg_2016_679_art_80_1)), [inputs_relied_on([body_properly_constituted_under_member_state_law - true, body_statutory_objectives_in_public_interest - unsure, body_active_in_protection_of_data_subjects_rights_and_freedoms - true])]).
test(an_unknown_action_is_an_input_problem) :-
    mandated_representation([], appeal_to_the_moon, input_problems([wrong_type(action)]), [], []).
test(an_unbound_action_is_an_input_problem) :-
    findall(Result, representation_without_mandate([], _Action, Result, _, _), Results),
    Results == [input_problems([wrong_type(action)])].
test(a_bad_profile_comes_before_a_bad_action) :-
    mandated_representation(not_a_profile, appeal_to_the_moon, input_problems([wrong_type(profile), wrong_type(action)]), [], []).
test(no_compensation_without_a_mandate) :-
    example_profile(qualified_body_considering, Profile),
    findall(Result - Basis - Citations, representation_without_mandate(Profile, receive_compensation_under_article_82, Result, Basis, Citations), Answers),
    Answers == [may_not_act_without_mandate - [] - [cite(eu_reg_2016_679_art_80_2)]].
test(without_mandate_names_the_missing_view_before_referring) :-
    example_profile(qualified_body_mandated, Profile),
    representation_without_mandate(Profile, lodge_complaint_under_article_77, indeterminate([body_considers_data_subject_rights_infringed_by_processing]), [], []).
test(without_mandate_refers_an_absent_member_state_law) :-
    example_profile(qualified_body_considering, Profile),
    representation_without_mandate(Profile, exercise_rights_under_article_78, Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_80_2), cite(member_state_law_on_action_without_mandate_statement)), [resolution(cite(member_state_law_on_action_without_mandate_statement), not_attempted), inputs_relied_on([member_state_law_provides_for_the_action_without_mandate - absent])]).
test(without_mandate_refers_absent_law_before_an_unsure_judgement) :-
    representation_without_mandate([attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, true), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, unsure), attribute(body_considers_data_subject_rights_infringed_by_processing, true)], exercise_right_under_article_79, needs_legal_review(cross_reference_unresolved(_, _), _), [], []).
test(without_mandate_may_act_with_attested_law) :-
    example_profile(qualified_body_considering, BodyProfile),
    attested_true(Attested),
    append(BodyProfile, [attribute(member_state_law_provides_for_the_action_without_mandate, Attested)], Profile),
    representation_without_mandate(Profile, lodge_complaint_under_article_77, may_act_without_mandate, [outside_fact(member_state_law_provides_for_the_action_without_mandate, Attested)], [cite(eu_reg_2016_679_art_80_2)]).
test(the_contact_duty_applies_once) :-
    example_profile(court_with_related_proceedings, Profile),
    findall(Result - Citations, court_contact_duty(Profile, Result, Citations), Answers),
    Answers == [contact_duty_applies - [cite(eu_reg_2016_679_art_81_1)]].
test(an_incompetent_court_has_no_contact_duty) :-
    court_contact_duty([attribute(court_is_competent_court, false)], contact_duty_does_not_apply, [cite(eu_reg_2016_679_art_81_1)]).
test(the_contact_duty_asks_for_the_information) :-
    court_contact_duty([attribute(court_is_competent_court, true)], indeterminate([court_has_information_on_proceedings_pending_in_another_member_state]), []).
test(an_unread_key_does_not_change_the_contact_duty) :-
    example_profile(court_with_related_proceedings, CourtProfile),
    append(CourtProfile, [attribute(body_is_not_for_profit, false)], Profile),
    court_contact_duty(Profile, contact_duty_applies, _).
test(the_court_first_seized_may_not_suspend) :-
    court_suspension_option([attribute(court_is_court_first_seized, true)], suspension_not_available, [cite(eu_reg_2016_679_art_81_2)]).
test(another_court_may_suspend) :-
    example_profile(court_with_related_proceedings, Profile),
    court_suspension_option(Profile, may_suspend_proceedings, [cite(eu_reg_2016_679_art_81_2)]).
test(an_unsure_subject_matter_goes_to_a_lawyer_on_suspension) :-
    court_suspension_option([attribute(court_is_competent_court, true), attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, unsure), attribute(court_is_court_first_seized, false)], Result, []),
    Result == needs_legal_review(open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_2)), [inputs_relied_on([other_proceedings_concern_same_subject_matter - unsure])]).
test(a_court_may_decline_jurisdiction) :-
    example_profile(court_with_related_proceedings, CourtProfile),
    attested_true(Attested),
    append(CourtProfile, [attribute(court_first_seized_has_jurisdiction_over_the_actions, Attested), attribute(law_of_court_first_seized_permits_consolidation, Attested)], Profile),
    findall(Result - Basis - Citations, court_declining_jurisdiction_option(Profile, Result, Basis, Citations), Answers),
    Answers == [may_decline_jurisdiction - [outside_fact(court_first_seized_has_jurisdiction_over_the_actions, Attested), outside_fact(law_of_court_first_seized_permits_consolidation, Attested)] - [cite(eu_reg_2016_679_art_81_3)]].
test(declining_names_a_missing_application_before_referring) :-
    court_declining_jurisdiction_option([attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true), attribute(court_is_court_first_seized, false), attribute(other_proceedings_pending_at_first_instance, true)], indeterminate([party_applied_for_court_to_decline_jurisdiction]), [], []).
test(declining_refers_the_jurisdiction_of_the_court_first_seized) :-
    example_profile(court_with_related_proceedings, Profile),
    court_declining_jurisdiction_option(Profile, Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_81_3), cite(court_first_seized_jurisdiction_statement)), [resolution(cite(court_first_seized_jurisdiction_statement), not_attempted), inputs_relied_on([court_first_seized_has_jurisdiction_over_the_actions - absent])]).
test(declining_without_consolidation_is_not_available) :-
    attested_false(Attested),
    court_declining_jurisdiction_option([attribute(law_of_court_first_seized_permits_consolidation, Attested)], declining_jurisdiction_not_available, [outside_fact(law_of_court_first_seized_permits_consolidation, Attested)], [cite(eu_reg_2016_679_art_81_3)]).
test(a_wrong_profile_is_an_input_problem) :-
    court_suspension_option(not_a_profile, input_problems([wrong_type(profile)]), []).
test(the_checklist_cites_every_item) :-
    gdpr_representation_and_suspension_checklist(court_contact_duty([attribute(court_is_competent_court, false)]), Items),
    Items == [item(court_is_competent_court, unmet(court_is_competent_court), cite(eu_reg_2016_679_art_81_1)), item(court_has_information_on_proceedings_pending_in_another_member_state, unknown([court_has_information_on_proceedings_pending_in_another_member_state]), cite(eu_reg_2016_679_art_81_1)), item(other_proceedings_concern_same_controller_or_processor, unknown([other_proceedings_concern_same_controller_or_processor]), cite(eu_reg_2016_679_art_81_1)), item(other_proceedings_concern_same_subject_matter, unknown([other_proceedings_concern_same_subject_matter]), cite(eu_reg_2016_679_art_81_1))].
test(the_verdict_projects_its_status) :-
    example_profile(qualified_body_mandated, Profile),
    gdpr_representation_and_suspension_status(mandated_representation(Profile, lodge_complaint_under_article_77), may_act_on_mandate).
test(the_verdict_is_resolvable) :-
    gdpr_representation_and_suspension_decision_resolvable(court_suspension_option([])).

test(a_mandated_qualified_body_is_not_refused, fail) :-
    example_profile(qualified_body_mandated, Profile),
    mandated_representation(Profile, lodge_complaint_under_article_77, may_not_act_on_mandate, _, _).
test(an_incompetent_court_does_not_have_the_duty, fail) :-
    court_contact_duty([attribute(court_is_competent_court, false)], contact_duty_applies, _).
