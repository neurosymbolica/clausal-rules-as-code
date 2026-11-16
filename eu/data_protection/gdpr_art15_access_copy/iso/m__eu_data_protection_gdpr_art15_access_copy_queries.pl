% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art15_access_copy_queries, [gdpr_art15_access_copy_profile_keys/1, gdpr_art15_access_copy_what_if/4, gdpr_art15_access_copy_compliance/4, gdpr_art15_access_copy_deadline/3, confirmation_of_processing/0, access_to_personal_data/0, purposes_of_processing/0, categories_of_personal_data/0, recipients_or_categories_of_recipients/0, storage_period_or_criteria/0, rights_to_rectification_erasure_restriction_and_objection/0, right_to_lodge_complaint/0, source_of_personal_data/0, automated_decision_making_information/0, transfer_safeguards_information/0, copy_of_personal_data/0, no_item_missing/0, no_personal_data_to_copy/0, full_copy/0, copy_limited_by_rights_and_freedoms_of_others/0, no_fee_under_article_15_3/0, reasonable_fee_permitted/0, no_electronic_request/0, other_form_requested/0, commonly_used_electronic_form/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_kernel, [gdpr_art15_access_copy_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_gdpr_art15_access_copy, [gdpr_art15_access_copy_status/2, access_answer_items/4, copy_scope/3, copy_fee/3, information_form/3]).

gdpr_art15_access_copy_profile_keys([items_provided, personal_data_concerning_data_subject_processed, disclosure_to_recipients_made_or_envisaged, some_personal_data_not_collected_from_data_subject, source_information_available, automated_decision_making_referred_to_in_article_22, transfer_to_third_country_or_international_organisation, transfer_subject_to_article_46_safeguards, copy_would_adversely_affect_rights_and_freedoms_of_others, further_copy_requested, request_made_by_electronic_means, other_form_requested_by_data_subject]).

gdpr_art15_access_copy_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_art15_access_copy_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Rest]) :-
    dif(ElementKey, Key),
    override_attribute(Elements, Key, Value, Rest).
override_attribute([attribute(Key, _)|Elements], Key, Value, Rest) :-
    override_attribute(Elements, Key, Value, Rest).

item_citation(confirmation_of_processing, cite(eu_reg_2016_679_art_15_1)).
item_citation(access_to_personal_data, cite(eu_reg_2016_679_art_15_1)).
item_citation(purposes_of_processing, cite(eu_reg_2016_679_art_15_1_a)).
item_citation(categories_of_personal_data, cite(eu_reg_2016_679_art_15_1_b)).
item_citation(recipients_or_categories_of_recipients, cite(eu_reg_2016_679_art_15_1_c)).
item_citation(storage_period_or_criteria, cite(eu_reg_2016_679_art_15_1_d)).
item_citation(rights_to_rectification_erasure_restriction_and_objection, cite(eu_reg_2016_679_art_15_1_e)).
item_citation(right_to_lodge_complaint, cite(eu_reg_2016_679_art_15_1_f)).
item_citation(source_of_personal_data, cite(eu_reg_2016_679_art_15_1_g)).
item_citation(automated_decision_making_information, cite(eu_reg_2016_679_art_15_1_h)).
item_citation(transfer_safeguards_information, cite(eu_reg_2016_679_art_15_2)).
item_citation(copy_of_personal_data, cite(eu_reg_2016_679_art_15_3)).

action_outcome(provide_full_copy, full_copy, action_permitted).
action_outcome(provide_full_copy, copy_limited_by_rights_and_freedoms_of_others, action_not_permitted).
action_outcome(provide_full_copy, no_personal_data_to_copy, action_not_applicable).
action_outcome(provide_limited_copy, copy_limited_by_rights_and_freedoms_of_others, action_permitted).
action_outcome(provide_limited_copy, full_copy, action_not_permitted).
action_outcome(provide_limited_copy, no_personal_data_to_copy, action_not_applicable).
action_outcome(charge_fee_for_copy, reasonable_fee_permitted, action_permitted).
action_outcome(charge_fee_for_copy, no_fee_under_article_15_3, action_not_permitted_under_article_15).
action_outcome(charge_fee_for_copy, no_personal_data_to_copy, action_not_applicable).
action_outcome(provide_answer_in_other_form, commonly_used_electronic_form, action_not_permitted).
action_outcome(provide_answer_in_other_form, other_form_requested, action_permitted).
action_outcome(provide_answer_in_other_form, no_electronic_request, action_permitted).

action_query_result(provide_full_copy, Profile, Result, Citations) :-
    copy_scope(Profile, Result, Citations).
action_query_result(provide_limited_copy, Profile, Result, Citations) :-
    copy_scope(Profile, Result, Citations).
action_query_result(charge_fee_for_copy, Profile, Result, Citations) :-
    copy_fee(Profile, Result, Citations).
action_query_result(provide_answer_in_other_form, Profile, Result, Citations) :-
    information_form(Profile, Result, Citations).

status_passthrough(indeterminate(Keys), indeterminate(Keys)).
status_passthrough(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
status_passthrough(input_problems(Problems), input_problems(Problems)).

gdpr_art15_access_copy_compliance(Profile, omit_item(Item), Outcome, Citations) :-
    item_citation(Item, Citation),
    access_answer_items(Profile, Result, _Basis, _ItemCitations),
    omit_outcome(Result, Item, Citation, Outcome, Citations).
gdpr_art15_access_copy_compliance(Profile, refuse_copy, Outcome, Citations) :-
    refuse_copy_outcome(Profile, Outcome, Citations).
gdpr_art15_access_copy_compliance(Profile, Action, Outcome, Citations) :-
    action_query_result(Action, Profile, Result, QueryCitations),
    action_outcome_of(Result, Action, QueryCitations, Outcome, Citations).

omit_outcome([First|Remaining], Item, Citation, Outcome, [Citation]) :-
    implements(eu_reg_2016_679_art_15_1),
    memberd_t(Item, [First|Remaining], Owed),
    omit_by_owed(Owed, Outcome).
omit_outcome(Status, _, _, Outcome, []) :-
    status_passthrough(Status, Outcome).

omit_by_owed(true, action_not_permitted).
omit_by_owed(false, action_permitted).

action_outcome_of(Result, Action, Citations, Outcome, Citations) :-
    implements(eu_reg_2016_679_art_15_3),
    atom(Result),
    action_outcome(Action, Result, Outcome).
action_outcome_of(Status, _, _, Outcome, []) :-
    status_passthrough(Status, Outcome).

refuse_copy_outcome(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_art15_access_copy_input_problems(Profile, [Problem|Problems]).
refuse_copy_outcome(Profile, Outcome, Citations) :-
    gdpr_art15_access_copy_input_problems(Profile, []),
    processing_state(Profile, State),
    refuse_by_processing(State, Outcome, Citations).

processing_state(Profile, absent) :-
    profile_lacks(Profile, personal_data_concerning_data_subject_processed).
processing_state(Profile, value(Value)) :-
    profile_has(Profile, personal_data_concerning_data_subject_processed),
    profile_get(Profile, personal_data_concerning_data_subject_processed, Value).

refuse_by_processing(absent, indeterminate([personal_data_concerning_data_subject_processed]), []).
refuse_by_processing(value(true), action_not_permitted, [cite(eu_reg_2016_679_art_15_3)]) :-
    implements(eu_reg_2016_679_art_15_3).
refuse_by_processing(value(false), action_not_applicable, [cite(eu_reg_2016_679_art_15_3)]) :-
    implements(eu_reg_2016_679_art_15_3).

gdpr_art15_access_copy_deadline(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_art15_access_copy_input_problems(Profile, [Problem|Problems]).
gdpr_art15_access_copy_deadline(Profile, deadline_decided_by_sibling_order(gdpr_data_subject_rights_response_period), []) :-
    gdpr_art15_access_copy_input_problems(Profile, []).

confirmation_of_processing.

access_to_personal_data.

purposes_of_processing.

categories_of_personal_data.

recipients_or_categories_of_recipients.

storage_period_or_criteria.

rights_to_rectification_erasure_restriction_and_objection.

right_to_lodge_complaint.

source_of_personal_data.

automated_decision_making_information.

transfer_safeguards_information.

copy_of_personal_data.

no_item_missing.

no_personal_data_to_copy.

full_copy.

copy_limited_by_rights_and_freedoms_of_others.

no_fee_under_article_15_3.

reasonable_fee_permitted.

no_electronic_request.

other_form_requested.

commonly_used_electronic_form.

test(omitting_the_copy_when_no_data_is_processed_is_permitted) :-
    gdpr_art15_access_copy_compliance([attribute(personal_data_concerning_data_subject_processed, false)], omit_item(copy_of_personal_data), action_permitted, [cite(eu_reg_2016_679_art_15_3)]).
test(omitting_the_confirmation_is_not_permitted) :-
    gdpr_art15_access_copy_compliance([attribute(personal_data_concerning_data_subject_processed, false)], omit_item(confirmation_of_processing), action_not_permitted, [cite(eu_reg_2016_679_art_15_1)]).
test(refusing_a_copy_of_processed_data_is_not_permitted) :-
    gdpr_art15_access_copy_compliance([attribute(personal_data_concerning_data_subject_processed, true)], refuse_copy, action_not_permitted, [cite(eu_reg_2016_679_art_15_3)]).
test(the_override_replaces_the_key_once) :-
    override_attribute([attribute(items_provided, []), attribute(further_copy_requested, true)], items_provided, [confirmation_of_processing], Hypothesis),
    Hypothesis == [attribute(further_copy_requested, true), attribute(items_provided, [confirmation_of_processing])].
test(deadline_names_the_sibling_order) :-
    gdpr_art15_access_copy_deadline([], deadline_decided_by_sibling_order(gdpr_data_subject_rights_response_period), []).

test(refusing_a_copy_of_processed_data_is_not_permitted_only, fail) :-
    gdpr_art15_access_copy_compliance([attribute(personal_data_concerning_data_subject_processed, true)], refuse_copy, action_permitted, _).
