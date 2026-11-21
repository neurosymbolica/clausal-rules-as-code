% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, decide_gdpr_art36_3_consultation_request/2, gdpr_art36_3_consultation_request_status/2, gdpr_art36_3_consultation_request_checklist/2, gdpr_art36_3_consultation_request_decision_resolvable/1, gdpr_art36_3_consultation_request_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_citations, [implements/1]).

gdpr_art36_3_consultation_request_status_values([consultation_request_complete, consultation_request_incomplete, not_governed_by_article_36_3]).

item_citation(respective_responsibilities, cite(eu_reg_2016_679_art_36_3_a)).
item_citation(purposes_and_means, cite(eu_reg_2016_679_art_36_3_b)).
item_citation(measures_and_safeguards, cite(eu_reg_2016_679_art_36_3_c)).
item_citation(data_protection_officer_contact_details, cite(eu_reg_2016_679_art_36_3_d)).
item_citation(data_protection_impact_assessment, cite(eu_reg_2016_679_art_36_3_e)).
item_citation(other_requested_information, cite(eu_reg_2016_679_art_36_3_f)).

consultation_request_citations([cite(eu_reg_2016_679_art_36_3), cite(eu_reg_2016_679_art_36_3_a), cite(eu_reg_2016_679_art_36_3_b), cite(eu_reg_2016_679_art_36_3_c), cite(eu_reg_2016_679_art_36_3_d), cite(eu_reg_2016_679_art_36_3_e), cite(eu_reg_2016_679_art_36_3_f)]).

crisp_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
crisp_state(Profile, ProfileKey, KeyValue) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, KeyValue).

outside_state(Profile, absent) :-
    profile_lacks(Profile, joint_controllers_or_processors_involved).
outside_state(Profile, attested(AttestedValue, Attestation)) :-
    profile_has(Profile, joint_controllers_or_processors_involved),
    profile_get(Profile, joint_controllers_or_processors_involved, attested(AttestedValue, Attestation)).

respective_responsibilities_state(true, _, satisfied) :-
    implements(eu_reg_2016_679_art_36_3_a).
respective_responsibilities_state(false, attested(false, _), satisfied) :-
    implements(eu_reg_2016_679_art_36_3_a).
respective_responsibilities_state(false, attested(true, _), missing) :-
    implements(eu_reg_2016_679_art_36_3_a).
respective_responsibilities_state(false, absent, referral) :-
    implements(eu_reg_2016_679_art_36_3_a).
respective_responsibilities_state(absent, attested(false, _), satisfied) :-
    implements(eu_reg_2016_679_art_36_3_a).
respective_responsibilities_state(absent, attested(true, _), named(respective_responsibilities_provided, deciding)) :-
    implements(eu_reg_2016_679_art_36_3_a).
respective_responsibilities_state(absent, absent, named(respective_responsibilities_provided, not_deciding)) :-
    implements(eu_reg_2016_679_art_36_3_a).

plain_item_state(true, _, satisfied) :-
    implements(eu_reg_2016_679_art_36_3).
plain_item_state(false, _, missing) :-
    implements(eu_reg_2016_679_art_36_3).
plain_item_state(absent, ProfileKey, named(ProfileKey, deciding)) :-
    implements(eu_reg_2016_679_art_36_3).

purposes_and_means_state(Provided, ItemState) :-
    implements(eu_reg_2016_679_art_36_3_b),
    plain_item_state(Provided, purposes_and_means_provided, ItemState).

measures_and_safeguards_state(Provided, ItemState) :-
    implements(eu_reg_2016_679_art_36_3_c),
    plain_item_state(Provided, measures_and_safeguards_provided, ItemState).

impact_assessment_state(Provided, ItemState) :-
    implements(eu_reg_2016_679_art_36_3_e),
    plain_item_state(Provided, impact_assessment_provided, ItemState).

applicable_item_state(_, true, _, _, satisfied) :-
    implements(eu_reg_2016_679_art_36_3).
applicable_item_state(true, false, _, _, missing) :-
    implements(eu_reg_2016_679_art_36_3).
applicable_item_state(false, false, _, _, satisfied) :-
    implements(eu_reg_2016_679_art_36_3).
applicable_item_state(absent, false, ApplyKey, _, named(ApplyKey, deciding)) :-
    implements(eu_reg_2016_679_art_36_3).
applicable_item_state(true, absent, _, ContentKey, named(ContentKey, deciding)) :-
    implements(eu_reg_2016_679_art_36_3).
applicable_item_state(false, absent, _, _, satisfied) :-
    implements(eu_reg_2016_679_art_36_3).
applicable_item_state(absent, absent, ApplyKey, _, named(ApplyKey, not_deciding)) :-
    implements(eu_reg_2016_679_art_36_3).

officer_contact_details_state(Designated, Provided, ItemState) :-
    implements(eu_reg_2016_679_art_36_3_d),
    applicable_item_state(Designated, Provided, data_protection_officer_designated, data_protection_officer_contact_details_provided, ItemState).

other_requested_information_state(Requested, Provided, ItemState) :-
    implements(eu_reg_2016_679_art_36_3_f),
    applicable_item_state(Requested, Provided, other_information_requested_by_supervisory_authority, requested_other_information_provided, ItemState).

item_states(Profile, [respective_responsibilities - ResponsibilitiesState, purposes_and_means - PurposesState, measures_and_safeguards - MeasuresState, data_protection_officer_contact_details - OfficerState, data_protection_impact_assessment - AssessmentState, other_requested_information - OtherState]) :-
    implements(eu_reg_2016_679_art_36_3),
    crisp_state(Profile, respective_responsibilities_provided, ResponsibilitiesProvided),
    outside_state(Profile, Involved),
    respective_responsibilities_state(ResponsibilitiesProvided, Involved, ResponsibilitiesState),
    crisp_state(Profile, purposes_and_means_provided, PurposesProvided),
    purposes_and_means_state(PurposesProvided, PurposesState),
    crisp_state(Profile, measures_and_safeguards_provided, MeasuresProvided),
    measures_and_safeguards_state(MeasuresProvided, MeasuresState),
    crisp_state(Profile, data_protection_officer_designated, OfficerDesignated),
    crisp_state(Profile, data_protection_officer_contact_details_provided, ContactProvided),
    officer_contact_details_state(OfficerDesignated, ContactProvided, OfficerState),
    crisp_state(Profile, impact_assessment_provided, AssessmentProvided),
    impact_assessment_state(AssessmentProvided, AssessmentState),
    crisp_state(Profile, other_information_requested_by_supervisory_authority, OtherRequested),
    crisp_state(Profile, requested_other_information_provided, OtherProvided),
    other_requested_information_state(OtherRequested, OtherProvided, OtherState).

outside_fact_basis(true, _, []).
outside_fact_basis(false, absent, []).
outside_fact_basis(false, attested(AttestedValue, Attestation), [outside_fact(joint_controllers_or_processors_involved, attested(AttestedValue, Attestation))]).
outside_fact_basis(absent, absent, []).
outside_fact_basis(absent, attested(AttestedValue, Attestation), [outside_fact(joint_controllers_or_processors_involved, attested(AttestedValue, Attestation))]).

request_basis(Profile, Basis) :-
    implements(eu_reg_2016_679_art_36_3_a),
    crisp_state(Profile, respective_responsibilities_provided, ResponsibilitiesProvided),
    outside_state(Profile, Involved),
    outside_fact_basis(ResponsibilitiesProvided, Involved, Basis).

state_weight(satisfied, other).
state_weight(missing, other).
state_weight(referral, other).
state_weight(named(ProfileKey, deciding), deciding(ProfileKey)).
state_weight(named(ProfileKey, not_deciding), waiting(ProfileKey)).

first_deciding([], none).
first_deciding([ItemState|RemainingStates], Found) :-
    state_weight(ItemState, Weight),
    first_deciding_from(Weight, RemainingStates, Found).

first_deciding_from(deciding(ProfileKey), _, key(ProfileKey)).
first_deciding_from(waiting(_), RemainingStates, Found) :-
    first_deciding(RemainingStates, Found).
first_deciding_from(other, RemainingStates, Found) :-
    first_deciding(RemainingStates, Found).

first_named([], none).
first_named([ItemState|RemainingStates], Found) :-
    state_weight(ItemState, Weight),
    first_named_from(Weight, RemainingStates, Found).

first_named_from(deciding(ProfileKey), _, key(ProfileKey)).
first_named_from(waiting(ProfileKey), _, key(ProfileKey)).
first_named_from(other, RemainingStates, Found) :-
    first_named(RemainingStates, Found).

status_outcome(States, Outcome) :-
    implements(eu_reg_2016_679_art_36_3),
    memberd_t(missing, States, HasMissing),
    status_after_missing(HasMissing, States, Outcome).

status_after_missing(true, _, incomplete).
status_after_missing(false, States, Outcome) :-
    first_deciding(States, Deciding),
    status_after_deciding(Deciding, States, Outcome).

status_after_deciding(key(ProfileKey), _, ask(ProfileKey)).
status_after_deciding(none, States, Outcome) :-
    first_named(States, Named),
    status_after_named(Named, States, Outcome).

status_after_named(key(ProfileKey), _, ask(ProfileKey)).
status_after_named(none, States, Outcome) :-
    memberd_t(referral, States, HasReferral),
    referral_outcome(HasReferral, complete, Outcome).

referral_outcome(true, _, refer).
referral_outcome(false, Settled, Settled).

items_outcome(Pairs, Outcome) :-
    implements(eu_reg_2016_679_art_36_3),
    pairs_values(Pairs, States),
    first_named(States, Named),
    items_after_named(Named, Pairs, States, Outcome).

items_after_named(key(ProfileKey), _, _, ask(ProfileKey)).
items_after_named(none, Pairs, States, Outcome) :-
    findall(ItemName, member(ItemName - missing, Pairs), MissingItems),
    memberd_t(referral, States, HasReferral),
    referral_outcome(HasReferral, listed(MissingItems), Outcome).

status_answer(incomplete, Basis, consultation_request_incomplete, Basis, Citations) :-
    consultation_request_citations(Citations).
status_answer(complete, Basis, consultation_request_complete, Basis, Citations) :-
    consultation_request_citations(Citations).
status_answer(ask(ProfileKey), _, indeterminate([ProfileKey]), [], []).
status_answer(refer, _, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])]), [], []).

items_answer(listed(MissingItems), Basis, MissingItems, Basis, Citations) :-
    consultation_request_citations(Citations).
items_answer(ask(ProfileKey), _, indeterminate([ProfileKey]), [], []).
items_answer(refer, _, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])]), [], []).

consultation_request_status(Profile, Result, Basis, Citations) :-
    gdpr_art36_3_consultation_request_input_problems(Profile, Problems),
    status_for_problems(Problems, Profile, Result, Basis, Citations).

status_for_problems([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
status_for_problems([], Profile, Result, Basis, Citations) :-
    crisp_state(Profile, consultation_under_article_36_1, Consulting),
    status_for_consultation(Consulting, Profile, Result, Basis, Citations).

status_for_consultation(absent, _, indeterminate([consultation_under_article_36_1]), [], []).
status_for_consultation(false, _, not_governed_by_article_36_3, [], [cite(eu_reg_2016_679_art_36_3)]) :-
    implements(eu_reg_2016_679_art_36_1),
    implements(eu_reg_2016_679_art_36_5).
status_for_consultation(true, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_36_3),
    item_states(Profile, Pairs),
    pairs_values(Pairs, States),
    status_outcome(States, Outcome),
    request_basis(Profile, RequestBasis),
    status_answer(Outcome, RequestBasis, Result, Basis, Citations).

missing_consultation_request_items(Profile, Items, Basis, Citations) :-
    gdpr_art36_3_consultation_request_input_problems(Profile, Problems),
    items_for_problems(Problems, Profile, Items, Basis, Citations).

items_for_problems([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
items_for_problems([], Profile, Items, Basis, Citations) :-
    crisp_state(Profile, consultation_under_article_36_1, Consulting),
    items_for_consultation(Consulting, Profile, Items, Basis, Citations).

items_for_consultation(absent, _, indeterminate([consultation_under_article_36_1]), [], []).
items_for_consultation(false, _, not_governed_by_article_36_3, [], [cite(eu_reg_2016_679_art_36_3)]) :-
    implements(eu_reg_2016_679_art_36_1),
    implements(eu_reg_2016_679_art_36_5).
items_for_consultation(true, Profile, Items, Basis, Citations) :-
    implements(eu_reg_2016_679_art_36_3),
    item_states(Profile, Pairs),
    items_outcome(Pairs, Outcome),
    request_basis(Profile, RequestBasis),
    items_answer(Outcome, RequestBasis, Items, Basis, Citations).

decide_gdpr_art36_3_consultation_request(Profile, gdpr_art36_3_consultation_request_verdict(Result, Citations)) :-
    consultation_request_status(Profile, Result, _Basis, Citations).

gdpr_art36_3_consultation_request_status(Profile, Result) :-
    decide_gdpr_art36_3_consultation_request(Profile, gdpr_art36_3_consultation_request_verdict(Result, _Citations)).

gdpr_art36_3_consultation_request_checklist(Profile, Items) :-
    gdpr_art36_3_consultation_request_input_problems(Profile, Problems),
    checklist_for_problems(Problems, Profile, Items).

checklist_for_problems([_|_], Profile, [item(overall, Result, Citations)]) :-
    consultation_request_status(Profile, Result, _Basis, Citations).
checklist_for_problems([], Profile, Items) :-
    crisp_state(Profile, consultation_under_article_36_1, Consulting),
    checklist_for_consultation(Consulting, Profile, Items).

checklist_for_consultation(true, Profile, Items) :-
    item_states(Profile, Pairs),
    maplist(checklist_row, Pairs, Items).
checklist_for_consultation(false, Profile, [item(overall, Result, Citations)]) :-
    consultation_request_status(Profile, Result, _Basis, Citations).
checklist_for_consultation(absent, Profile, [item(overall, Result, Citations)]) :-
    consultation_request_status(Profile, Result, _Basis, Citations).

checklist_row(ItemName - ItemState, item(ItemName, ItemState, Citation)) :-
    item_citation(ItemName, Citation).

gdpr_art36_3_consultation_request_decision_resolvable(Profile) :-
    gdpr_art36_3_consultation_request_status(Profile, Result),
    gdpr_art36_3_consultation_request_status_values(FinalResults),
    member(Result, FinalResults).

complete_profile([attribute(consultation_under_article_36_1, true), attribute(respective_responsibilities_provided, true), attribute(purposes_and_means_provided, true), attribute(measures_and_safeguards_provided, true), attribute(data_protection_officer_designated, false), attribute(impact_assessment_provided, true), attribute(other_information_requested_by_supervisory_authority, false)]).

test(a_complete_request_is_complete) :-
    complete_profile(Profile),
    findall(Result - Basis, consultation_request_status(Profile, Result, Basis, _), Answers),
    Answers == [consultation_request_complete - []].
test(a_complete_request_misses_no_item) :-
    complete_profile(Profile),
    findall(Items, missing_consultation_request_items(Profile, Items, _, _), Answers),
    Answers == [[]].
test(a_complete_request_carries_seven_citations) :-
    complete_profile(Profile),
    consultation_request_status(Profile, _, _, Citations),
    length(Citations, 7).
test(an_absent_consultation_key_is_named) :-
    consultation_request_status([], Result, Basis, Citations),
    Result == indeterminate([consultation_under_article_36_1]),
    Basis == [],
    Citations == [].
test(another_footing_is_not_governed) :-
    findall(Result - Citations, consultation_request_status([attribute(consultation_under_article_36_1, false), attribute(purposes_and_means_provided, false)], Result, _, Citations), Answers),
    Answers == [not_governed_by_article_36_3 - [cite(eu_reg_2016_679_art_36_3)]].
test(another_footing_is_not_governed_for_items) :-
    missing_consultation_request_items([attribute(consultation_under_article_36_1, false)], Items, [], _),
    Items == not_governed_by_article_36_3.
test(a_missing_item_decides_before_an_absent_key) :-
    consultation_request_status([attribute(consultation_under_article_36_1, true), attribute(purposes_and_means_provided, false)], Result, _, _),
    Result == consultation_request_incomplete.
test(the_items_query_names_the_first_key_even_with_a_missing_item) :-
    missing_consultation_request_items([attribute(consultation_under_article_36_1, true), attribute(purposes_and_means_provided, false)], Items, _, _),
    Items == indeterminate([respective_responsibilities_provided]).
test(a_deciding_key_comes_before_a_waiting_key) :-
    consultation_request_status([attribute(consultation_under_article_36_1, true), attribute(purposes_and_means_provided, true), attribute(measures_and_safeguards_provided, true)], Result, _, _),
    Result == indeterminate([impact_assessment_provided]).
test(a_waiting_key_is_named_when_no_deciding_key_is_absent) :-
    consultation_request_status([attribute(consultation_under_article_36_1, true), attribute(purposes_and_means_provided, true), attribute(measures_and_safeguards_provided, true), attribute(impact_assessment_provided, true)], Result, _, _),
    Result == indeterminate([respective_responsibilities_provided]).
test(a_designation_with_contact_details_false_is_deciding) :-
    consultation_request_status([attribute(consultation_under_article_36_1, true), attribute(purposes_and_means_provided, true), attribute(measures_and_safeguards_provided, true), attribute(impact_assessment_provided, true), attribute(data_protection_officer_contact_details_provided, false)], Result, _, _),
    Result == indeterminate([data_protection_officer_designated]).
test(an_absent_roles_statement_is_referred) :-
    complete_profile(Complete),
    select(attribute(respective_responsibilities_provided, true), Complete, Others),
    findall(Result - Basis - Citations, consultation_request_status([attribute(respective_responsibilities_provided, false)|Others], Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])]) - [] - []].
test(an_attested_joint_controller_without_responsibilities_is_missing) :-
    complete_profile(Complete),
    select(attribute(respective_responsibilities_provided, true), Complete, Others),
    Attested = attested(true, attestation(host, moment, reason, none)),
    Profile = [attribute(respective_responsibilities_provided, false), attribute(joint_controllers_or_processors_involved, Attested)|Others],
    consultation_request_status(Profile, Result, Basis, _),
    Result == consultation_request_incomplete,
    Basis == [outside_fact(joint_controllers_or_processors_involved, Attested)],
    missing_consultation_request_items(Profile, Items, _, _),
    Items == [respective_responsibilities].
test(an_unread_outside_fact_is_not_copied) :-
    complete_profile(Complete),
    consultation_request_status([attribute(joint_controllers_or_processors_involved, attested(true, attestation(host, moment, reason, none)))|Complete], Result, Basis, _),
    Result == consultation_request_complete,
    Basis == [].
test(several_missing_items_are_listed_in_order) :-
    missing_consultation_request_items([attribute(consultation_under_article_36_1, true), attribute(respective_responsibilities_provided, true), attribute(purposes_and_means_provided, false), attribute(measures_and_safeguards_provided, true), attribute(data_protection_officer_designated, true), attribute(data_protection_officer_contact_details_provided, false), attribute(impact_assessment_provided, true), attribute(other_information_requested_by_supervisory_authority, true), attribute(requested_other_information_provided, false)], Items, _, _),
    Items == [purposes_and_means, data_protection_officer_contact_details, other_requested_information].
test(an_input_problem_comes_first) :-
    consultation_request_status([attribute(consultation_under_article_36_1, unsure)], Result, Basis, Citations),
    Result == input_problems([wrong_type(consultation_under_article_36_1)]),
    Basis == [],
    Citations == [].
test(the_checklist_carries_a_cite_per_point) :-
    complete_profile(Profile),
    gdpr_art36_3_consultation_request_checklist(Profile, Items),
    length(Items, 6),
    member(item(data_protection_impact_assessment, satisfied, cite(eu_reg_2016_679_art_36_3_e)), Items).
test(a_complete_request_is_resolvable) :-
    complete_profile(Profile),
    gdpr_art36_3_consultation_request_decision_resolvable(Profile).

test(a_complete_request_is_not_incomplete, fail) :-
    complete_profile(Profile),
    consultation_request_status(Profile, consultation_request_incomplete, _, _).
test(an_input_problem_is_not_a_verdict, fail) :-
    consultation_request_status([attribute(consultation_under_article_36_1, unsure)], consultation_request_complete, _, _).
