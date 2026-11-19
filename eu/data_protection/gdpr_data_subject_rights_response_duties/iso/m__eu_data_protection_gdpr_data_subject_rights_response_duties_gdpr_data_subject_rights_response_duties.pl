% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [decide_gdpr_data_subject_rights_response_duties/2, gdpr_data_subject_rights_response_duties_status/2, gdpr_data_subject_rights_response_duties_checklist/2, gdpr_data_subject_rights_response_duties_decision_resolvable/1, gdpr_data_subject_rights_response_duties_status_values/1, request_response_deadline/2, response_duties/2, recipient_notification/2, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, suspended/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, attested/2, attestation/4, url/2, document/2, respond_with_action_taken/2, inform_of_extension_with_reasons/2, inform_of_reasons_and_remedies/2, communicate_to_each_recipient/1, inform_data_subject_of_recipients/1, recipient_notification_excused/1, recipient_notification_not_applicable/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [tfilter/3, (=)/3]).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(clpz)).
:- use_module(library(reif), [if_/3, memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_kernel, [gdpr_data_subject_rights_response_duties_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_citations, [implements/1]).

gdpr_data_subject_rights_response_duties_status_values([must_comply, need_not_comply, indeterminate, needs_legal_review, suspended, input_problems]).

period_months(first_period, Months, cite(eu_reg_2016_679_art_12_3)) :-
    implements(eu_reg_2016_679_art_12_3),
    Months #= 1.
period_months(extended_period, Months, cite(eu_reg_2016_679_art_12_3)) :-
    implements(eu_reg_2016_679_art_12_3),
    Months #= 3.

contract_keys([request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays]).

judgement_keys([extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort]).

simple_request_type(access).
simple_request_type(rectification).
simple_request_type(erasure).
simple_request_type(restriction).
simple_request_type(portability).
simple_request_type(automated_decision).

objection_ground(art21_1).
objection_ground(art21_2).
objection_ground(art21_6).

engagement_point(access, art15_1, always, cite(eu_reg_2016_679_art_15_1)).
engagement_point(rectification, art16_inaccurate_data, key(personal_data_inaccurate), cite(eu_reg_2016_679_art_16)).
engagement_point(rectification, art16_incomplete_data, key(personal_data_incomplete_in_light_of_purposes), cite(eu_reg_2016_679_art_16)).
engagement_point(erasure, art17_1_a, key(data_no_longer_necessary_for_purposes), cite(eu_reg_2016_679_art_17_1_a)).
engagement_point(erasure, art17_1_b, conjunction([key(consent_is_the_basis_of_processing), key(consent_withdrawn), negation(key(other_legal_ground_for_processing_exists))]), cite(eu_reg_2016_679_art_17_1_b)).
engagement_point(erasure, art17_1_c, disjunction([conjunction([key(objection_under_art21_1_made), negation(key(overriding_legitimate_grounds_exist))]), key(objection_under_art21_2_made)]), cite(eu_reg_2016_679_art_17_1_c)).
engagement_point(erasure, art17_1_d, key(personal_data_unlawfully_processed), cite(eu_reg_2016_679_art_17_1_d)).
engagement_point(erasure, art17_1_e, enabling(erasure_required_by_union_or_member_state_law), cite(eu_reg_2016_679_art_17_1_e)).
engagement_point(erasure, art17_1_f, key(collected_in_relation_to_information_society_services_offer), cite(eu_reg_2016_679_art_17_1_f)).
engagement_point(restriction, art18_1_a, key(accuracy_contested_by_data_subject), cite(eu_reg_2016_679_art_18_1_a)).
engagement_point(restriction, art18_1_b, conjunction([key(personal_data_unlawfully_processed), key(data_subject_opposes_erasure)]), cite(eu_reg_2016_679_art_18_1_b)).
engagement_point(restriction, art18_1_c, conjunction([key(controller_no_longer_needs_data_for_processing_purposes), key(data_required_by_data_subject_for_legal_claims)]), cite(eu_reg_2016_679_art_18_1_c)).
engagement_point(restriction, art18_1_d, conjunction([key(objection_under_art21_1_made), key(verification_of_overriding_grounds_pending)]), cite(eu_reg_2016_679_art_18_1_d)).
engagement_point(portability, art20_1, conjunction([key(personal_data_provided_by_data_subject), key(processing_based_on_consent_or_contract), key(processing_carried_out_by_automated_means)]), cite(eu_reg_2016_679_art_20_1)).
engagement_point(objection(art21_1), art21_1, conjunction([key(processing_based_on_art6_1_e_or_f), key(objection_grounds_relate_to_particular_situation)]), cite(eu_reg_2016_679_art_21_1)).
engagement_point(objection(art21_2), art21_2, key(processing_for_direct_marketing), cite(eu_reg_2016_679_art_21_2)).
engagement_point(objection(art21_6), art21_6, conjunction([key(processing_for_research_or_statistics_pursuant_to_art89_1), key(objection_grounds_relate_to_particular_situation)]), cite(eu_reg_2016_679_art_21_6)).
engagement_point(automated_decision, art22_1, conjunction([key(decision_based_solely_on_automated_processing), key(decision_produces_legal_or_similarly_significant_effects)]), cite(eu_reg_2016_679_art_22_1)).

tag_cite(access, cite(eu_reg_2016_679_art_15_1)).
tag_cite(rectification, cite(eu_reg_2016_679_art_16)).
tag_cite(erasure, cite(eu_reg_2016_679_art_17_1)).
tag_cite(restriction, cite(eu_reg_2016_679_art_18_1)).
tag_cite(portability, cite(eu_reg_2016_679_art_20_1)).
tag_cite(objection(art21_1), cite(eu_reg_2016_679_art_21_1)).
tag_cite(objection(art21_2), cite(eu_reg_2016_679_art_21_2)).
tag_cite(objection(art21_6), cite(eu_reg_2016_679_art_21_6)).
tag_cite(automated_decision, cite(eu_reg_2016_679_art_22_1)).

exception_row(erasure, art17_3_a, defeater(processing_necessary_for_freedom_of_expression_and_information), cite(eu_reg_2016_679_art_17_3_a)).
exception_row(erasure, art17_3_b, disjunction([blocking(processing_required_by_union_or_member_state_law), defeater(processing_necessary_for_public_task_or_official_authority)]), cite(eu_reg_2016_679_art_17_3_b)).
exception_row(erasure, art17_3_c, defeater(processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i), cite(eu_reg_2016_679_art_17_3_c)).
exception_row(erasure, art17_3_d, conjunction([defeater(processing_for_archiving_research_or_statistics_in_accordance_with_art89_1), defeater(erasure_would_render_impossible_or_seriously_impair_processing_objectives)]), cite(eu_reg_2016_679_art_17_3_d)).
exception_row(erasure, art17_3_e, defeater(processing_necessary_for_legal_claims), cite(eu_reg_2016_679_art_17_3_e)).
exception_row(portability, art20_3_public_task, defeater(processing_necessary_for_public_task_or_official_authority), cite(eu_reg_2016_679_art_20_3)).
exception_row(portability, art20_4_rights_of_others, defeater(transmission_would_adversely_affect_rights_and_freedoms_of_others), cite(eu_reg_2016_679_art_20_4)).
exception_row(objection(art21_1), art21_1_compelling_legitimate_grounds, defeater(controller_demonstrates_compelling_legitimate_grounds), cite(eu_reg_2016_679_art_21_1)).
exception_row(objection(art21_1), art21_1_legal_claims, defeater(processing_necessary_for_legal_claims), cite(eu_reg_2016_679_art_21_1)).
exception_row(objection(art21_6), art21_6_public_interest_task, defeater(processing_necessary_for_public_task_or_official_authority), cite(eu_reg_2016_679_art_21_6)).
exception_row(automated_decision, art22_2_a, conjunction([defeater(decision_necessary_for_contract_with_data_subject), negation(special_category_bar)]), cite(eu_reg_2016_679_art_22_2_a)).
exception_row(automated_decision, art22_2_b, conjunction([blocking(decision_authorised_by_union_or_member_state_law), negation(special_category_bar)]), cite(eu_reg_2016_679_art_22_2_b)).
exception_row(automated_decision, art22_2_c, conjunction([defeater(data_subject_gave_explicit_consent), negation(special_category_bar)]), cite(eu_reg_2016_679_art_22_2_c)).

common_exception_row(art12_5_manifestly_unfounded_or_excessive, defeater(request_manifestly_unfounded_or_excessive), cite(eu_reg_2016_679_art_12_5)).
common_exception_row(art12_2_unable_to_identify, defeater(controller_demonstrates_unable_to_identify_data_subject), cite(eu_reg_2016_679_art_12_2)).
common_exception_row(art23_legislative_restriction, blocking(legislative_restriction_applies_to_the_right), cite(eu_reg_2016_679_art_23_1)).

special_category_bar_row(conjunction([defeater(decision_based_on_special_categories), negation(key(special_category_condition_and_safeguards_met_for_decision))]), cite(eu_reg_2016_679_art_22_4)).

suspension_row(conjunction([defeater(reasonable_doubts_about_identity), negation(key(identity_confirmed))]), cite(eu_reg_2016_679_art_12_6)).

exception_conditions(art17_3_a, [], cite(eu_reg_2016_679_art_17_3_a)).
exception_conditions(art17_3_b, [], cite(eu_reg_2016_679_art_17_3_b)).
exception_conditions(art17_3_c, [], cite(eu_reg_2016_679_art_17_3_c)).
exception_conditions(art17_3_d, [], cite(eu_reg_2016_679_art_17_3_d)).
exception_conditions(art17_3_e, [], cite(eu_reg_2016_679_art_17_3_e)).
exception_conditions(art20_3_public_task, [], cite(eu_reg_2016_679_art_20_3)).
exception_conditions(art20_4_rights_of_others, [], cite(eu_reg_2016_679_art_20_4)).
exception_conditions(art21_1_compelling_legitimate_grounds, [], cite(eu_reg_2016_679_art_21_1)).
exception_conditions(art21_1_legal_claims, [], cite(eu_reg_2016_679_art_21_1)).
exception_conditions(art21_6_public_interest_task, [], cite(eu_reg_2016_679_art_21_6)).
exception_conditions(art22_2_a, [human_intervention, express_point_of_view, contest_decision], cite(eu_reg_2016_679_art_22_3)).
exception_conditions(art22_2_b, [], cite(eu_reg_2016_679_art_22_2_b)).
exception_conditions(art22_2_c, [human_intervention, express_point_of_view, contest_decision], cite(eu_reg_2016_679_art_22_3)).
exception_conditions(art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], cite(eu_reg_2016_679_art_12_5)).
exception_conditions(art12_2_unable_to_identify, [], cite(eu_reg_2016_679_art_12_2)).
exception_conditions(art23_legislative_restriction, [], cite(eu_reg_2016_679_art_23_1)).

referral_citation(_, reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)).
referral_citation(_, request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)).
referral_citation(rectification, personal_data_incomplete_in_light_of_purposes, cite(eu_reg_2016_679_art_16)).
referral_citation(erasure, data_no_longer_necessary_for_purposes, cite(eu_reg_2016_679_art_17_1_a)).
referral_citation(erasure, overriding_legitimate_grounds_exist, cite(eu_reg_2016_679_art_17_1_c)).
referral_citation(erasure, personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_17_1_d)).
referral_citation(erasure, processing_necessary_for_freedom_of_expression_and_information, cite(eu_reg_2016_679_art_17_3_a)).
referral_citation(erasure, processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_17_3_b)).
referral_citation(erasure, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, cite(eu_reg_2016_679_art_17_3_c)).
referral_citation(erasure, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, cite(eu_reg_2016_679_art_17_3_d)).
referral_citation(erasure, erasure_would_render_impossible_or_seriously_impair_processing_objectives, cite(eu_reg_2016_679_art_17_3_d)).
referral_citation(erasure, processing_necessary_for_legal_claims, cite(eu_reg_2016_679_art_17_3_e)).
referral_citation(restriction, personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_18_1_b)).
referral_citation(restriction, controller_no_longer_needs_data_for_processing_purposes, cite(eu_reg_2016_679_art_18_1_c)).
referral_citation(portability, processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_20_3)).
referral_citation(portability, transmission_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_20_4)).
referral_citation(objection(art21_1), objection_grounds_relate_to_particular_situation, cite(eu_reg_2016_679_art_21_1)).
referral_citation(objection(art21_1), controller_demonstrates_compelling_legitimate_grounds, cite(eu_reg_2016_679_art_21_1)).
referral_citation(objection(art21_1), processing_necessary_for_legal_claims, cite(eu_reg_2016_679_art_21_1)).
referral_citation(objection(art21_6), objection_grounds_relate_to_particular_situation, cite(eu_reg_2016_679_art_21_6)).
referral_citation(objection(art21_6), processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_21_6)).
referral_citation(automated_decision, decision_based_solely_on_automated_processing, cite(eu_reg_2016_679_art_22_1)).
referral_citation(automated_decision, decision_produces_legal_or_similarly_significant_effects, cite(eu_reg_2016_679_art_22_1)).
referral_citation(automated_decision, decision_necessary_for_contract_with_data_subject, cite(eu_reg_2016_679_art_22_2_a)).

outside_fact_row(erasure_required_by_union_or_member_state_law, cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)).
outside_fact_row(processing_required_by_union_or_member_state_law, cite(eu_reg_2016_679_art_17_3_b), cite(union_or_member_state_law_requiring_processing)).
outside_fact_row(decision_authorised_by_union_or_member_state_law, cite(eu_reg_2016_679_art_22_2_b), cite(union_or_member_state_law_authorising_automated_decision)).
outside_fact_row(legislative_restriction_applies_to_the_right, cite(eu_reg_2016_679_art_23_1), cite(union_or_member_state_law_restricting_the_right)).
outside_fact_row(public_holidays, cite(eu_reg_1971_1182_art_3), cite(public_holidays_applicable_to_the_period)).

key_value(Profile, AttributeKey, Value) :-
    profile_has(Profile, AttributeKey),
    profile_get(Profile, AttributeKey, Value).
key_value(Profile, AttributeKey, absent) :-
    profile_lacks(Profile, AttributeKey).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_differ(true, true, false).
truth_differ(true, false, true).
truth_differ(false, true, true).
truth_differ(false, false, false).

order_keys(KeyList, Ordered) :-
    contract_keys(AllKeys),
    tfilter(listed_key_t(KeyList), AllKeys, Ordered).

listed_key_t(KeyList, AttributeKey, Truth) :-
    memberd_t(AttributeKey, KeyList, Truth).

key_pair(Profile, AttributeKey, AttributeKey - Value) :-
    key_value(Profile, AttributeKey, Value).

presence_truth(absent, false).
presence_truth(Given, true) :-
    dif(Given, absent).

present_judgement_t(Profile, AttributeKey, Truth) :-
    judgement_keys(JudgementKeys),
    memberd_t(AttributeKey, JudgementKeys, IsJudgement),
    key_value(Profile, AttributeKey, Given),
    presence_truth(Given, IsPresent),
    truth_and(IsJudgement, IsPresent, Truth).

profile_state(Profile, State) :-
    gdpr_data_subject_rights_response_duties_input_problems(Profile, Problems),
    problems_state(Problems, Profile, State).

problems_state([Problem|Problems], _, problems([Problem|Problems])).
problems_state([], Profile, State) :-
    key_value(Profile, request_type, RequestType),
    request_type_state(RequestType, Profile, State).

request_type_state(absent, _, missing(request_type)).
request_type_state(objection, Profile, State) :-
    key_value(Profile, objection_ground_claimed, Ground),
    ground_state(Ground, State).
request_type_state(RequestType, _, tag(RequestType)) :-
    simple_request_type(RequestType).

ground_state(absent, missing(objection_ground_claimed)).
ground_state(Ground, tag(objection(Ground))) :-
    objection_ground(Ground).

tag_base_keys(objection(_), [request_type, objection_ground_claimed]).
tag_base_keys(RequestTag, [request_type]) :-
    simple_request_type(RequestTag).

tag_request_type(objection(_), objection).
tag_request_type(RequestTag, RequestTag) :-
    simple_request_type(RequestTag).

tag_ground(objection(Ground), Ground).

evaluate(_, always, met).
evaluate(Profile, key(AttributeKey), Value) :-
    key_value(Profile, AttributeKey, Given),
    required_status(Given, AttributeKey, Value).
evaluate(Profile, defeater(AttributeKey), Value) :-
    key_value(Profile, AttributeKey, Given),
    defeater_status(Given, AttributeKey, Value).
evaluate(Profile, blocking(AttributeKey), Value) :-
    key_value(Profile, AttributeKey, Given),
    blocking_status(Given, Value).
evaluate(Profile, enabling(AttributeKey), Value) :-
    key_value(Profile, AttributeKey, Given),
    enabling_status(Given, AttributeKey, Value).
evaluate(Profile, negation(Inner), Value) :-
    evaluate(Profile, Inner, InnerValue),
    negate(InnerValue, Value).
evaluate(Profile, conjunction(Parts), Value) :-
    maplist(evaluate(Profile), Parts, PartValues),
    conjunction_fold(PartValues, Value).
evaluate(Profile, disjunction(Parts), Value) :-
    maplist(evaluate(Profile), Parts, PartValues),
    disjunction_fold(PartValues, Value).
evaluate(Profile, special_category_bar, Value) :-
    special_category_bar_row(Expression, _),
    evaluate(Profile, Expression, Value).

required_status(true, _, met).
required_status(false, _, unmet).
required_status(unsure, AttributeKey, open([], [AttributeKey], [])).
required_status(absent, AttributeKey, open([AttributeKey], [], [])).

defeater_status(true, _, met).
defeater_status(false, _, unmet).
defeater_status(unsure, AttributeKey, open([], [AttributeKey], [])).
defeater_status(absent, _, unmet).

blocking_status(absent, unmet).
blocking_status(attested(true, _), met).
blocking_status(attested(false, _), unmet).

enabling_status(absent, AttributeKey, open([], [], [AttributeKey])).
enabling_status(attested(true, _), _, met).
enabling_status(attested(false, _), _, unmet).

negate(met, unmet).
negate(unmet, met).
negate(open(Absent, Unsure, Facts), open(Absent, Unsure, Facts)).

conjunction_fold([], met).
conjunction_fold([Value|Values], Result) :-
    conjunction_fold(Values, Remaining),
    and_combine(Value, Remaining, Result).

disjunction_fold([], unmet).
disjunction_fold([Value|Values], Result) :-
    disjunction_fold(Values, Remaining),
    or_combine(Value, Remaining, Result).

and_combine(met, Value, Value).
and_combine(unmet, _, unmet).
and_combine(open(Absent, Unsure, Facts), met, open(Absent, Unsure, Facts)).
and_combine(open(_, _, _), unmet, unmet).
and_combine(open(FirstAbsent, FirstUnsure, FirstFacts), open(SecondAbsent, SecondUnsure, SecondFacts), open(Absent, Unsure, Facts)) :-
    append(FirstAbsent, SecondAbsent, Absent),
    append(FirstUnsure, SecondUnsure, Unsure),
    append(FirstFacts, SecondFacts, Facts).

or_combine(met, _, met).
or_combine(unmet, Value, Value).
or_combine(open(_, _, _), met, met).
or_combine(open(Absent, Unsure, Facts), unmet, open(Absent, Unsure, Facts)).
or_combine(open(FirstAbsent, FirstUnsure, FirstFacts), open(SecondAbsent, SecondUnsure, SecondFacts), open(Absent, Unsure, Facts)) :-
    append(FirstAbsent, SecondAbsent, Absent),
    append(FirstUnsure, SecondUnsure, Unsure),
    append(FirstFacts, SecondFacts, Facts).

value_class(met, met).
value_class(unmet, unmet).
value_class(open(_, _, _), open).

value_absent_keys(met, []).
value_absent_keys(unmet, []).
value_absent_keys(open(Absent, _, _), Absent).

value_unsure_keys(met, []).
value_unsure_keys(unmet, []).
value_unsure_keys(open(_, Unsure, _), Unsure).

value_open_keys(Value, KeyList) :-
    value_absent_keys(Value, Absent),
    value_unsure_keys(Value, Unsure),
    append(Absent, Unsure, KeyList).

reachable(met, [met]).
reachable(unmet, [unmet]).
reachable(open(_, _, _), [met, unmet]).

expression_keys(always, []).
expression_keys(key(AttributeKey), [AttributeKey]).
expression_keys(defeater(AttributeKey), [AttributeKey]).
expression_keys(blocking(_), []).
expression_keys(enabling(_), []).
expression_keys(negation(Inner), KeyList) :-
    expression_keys(Inner, KeyList).
expression_keys(conjunction(Parts), KeyList) :-
    maplist(expression_keys, Parts, KeyLists),
    append(KeyLists, KeyList).
expression_keys(disjunction(Parts), KeyList) :-
    maplist(expression_keys, Parts, KeyLists),
    append(KeyLists, KeyList).
expression_keys(special_category_bar, KeyList) :-
    special_category_bar_row(Expression, _),
    expression_keys(Expression, KeyList).

decide_request(Profile, Verdict) :-
    profile_state(Profile, State),
    state_verdict(State, Profile, Verdict).

state_verdict(problems(Problems), _, gdpr_data_subject_request_verdict(input_problems(Problems), none, none, [], [])).
state_verdict(missing(AttributeKey), _, gdpr_data_subject_request_verdict(indeterminate([AttributeKey]), none, none, [], [])).
state_verdict(tag(RequestTag), Profile, Verdict) :-
    limbs_decision(RequestTag, Profile, Verdict).

limbs_decision(RequestTag, Profile, gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, [])) :-
    tag_evaluation(Profile, RequestTag, Evaluation),
    evaluation_route(Evaluation, Route),
    route_verdict(Route, RequestTag, Profile, Evaluation, Comply, Basis, Exception, Conditions).

tag_evaluation(Profile, RequestTag, evaluation(PointValues, EngagementValue, ExceptionValues, SuspensionValue)) :-
    implements(eu_reg_2016_679_art_12_2),
    findall(Basis - Expression, engagement_point(RequestTag, Basis, Expression, _), Points),
    maplist(point_evaluation(Profile), Points, PointValues),
    maplist(point_value_only, PointValues, Values),
    disjunction_fold(Values, EngagementValue),
    tag_exceptions(RequestTag, Exceptions),
    maplist(exception_evaluation(Profile), Exceptions, ExceptionValues),
    suspension_row(SuspensionExpression, _),
    evaluate(Profile, SuspensionExpression, SuspensionValue).

point_evaluation(Profile, Basis - Expression, evaluated_point(Basis, Value)) :-
    evaluate(Profile, Expression, Value).

point_value_only(evaluated_point(_, Value), Value).

exception_evaluation(Profile, ExceptionName - Expression, evaluated_exception(ExceptionName, Value, Expression)) :-
    evaluate(Profile, Expression, Value).

tag_exceptions(RequestTag, Exceptions) :-
    findall(ExceptionName - Expression, exception_row(RequestTag, ExceptionName, Expression, _), Specific),
    findall(ExceptionName - Expression, common_exception_row(ExceptionName, Expression, _), Common),
    append(Specific, Common, Exceptions).

engagement_expression(RequestTag, disjunction(Expressions)) :-
    findall(Expression, engagement_point(RequestTag, _, Expression, _), Expressions).

evaluation_route(evaluation(_, EngagementValue, ExceptionValues, SuspensionValue), Route) :-
    value_class(EngagementValue, EngagementClass),
    first_met_exception(ExceptionValues, Exception),
    value_class(SuspensionValue, SuspensionClass),
    findall(Value, member(evaluated_exception(_, Value, _), ExceptionValues), Values),
    maplist(value_absent_keys, [EngagementValue|Values], AbsentLists),
    append(AbsentLists, Absences),
    maplist(value_class, [EngagementValue, SuspensionValue|Values], Classes),
    memberd_t(open, Classes, OpenFlag),
    route_of(EngagementClass, Exception, SuspensionClass, Absences, OpenFlag, Route).

engaged_class(met).
engaged_class(open).

route_of(unmet, _, _, _, _, not_engaged).
route_of(EngagementClass, Exception, _, _, _, relieved(Exception)) :-
    engaged_class(EngagementClass),
    dif(Exception, none).
route_of(EngagementClass, none, met, [], _, suspended_route) :-
    engaged_class(EngagementClass).
route_of(EngagementClass, none, met, [_|_], _, open_route) :-
    engaged_class(EngagementClass).
route_of(EngagementClass, none, open, _, _, open_route) :-
    engaged_class(EngagementClass).
route_of(EngagementClass, none, unmet, _, true, open_route) :-
    engaged_class(EngagementClass).
route_of(met, none, unmet, _, false, comply_route).

route_verdict(not_engaged, _, _, _, need_not_comply, none, none, []) :-
    implements(eu_reg_2016_679_art_12_4).
route_verdict(relieved(Exception), _, _, evaluation(PointValues, _, _, _), need_not_comply, Basis, Exception, Conditions) :-
    implements(eu_reg_2016_679_art_12_4),
    first_met_basis(PointValues, Basis),
    exception_conditions(Exception, Conditions, _).
route_verdict(suspended_route, _, _, _, suspended(art12_6_identity_not_confirmed), none, none, []) :-
    implements(eu_reg_2016_679_art_12_6).
route_verdict(open_route, RequestTag, Profile, Evaluation, Comply, none, none, []) :-
    open_comply(RequestTag, Profile, Evaluation, Comply).
route_verdict(comply_route, _, _, evaluation(PointValues, _, _, _), must_comply, Basis, none, []) :-
    implements(eu_reg_2016_679_art_12_3),
    first_met_basis(PointValues, Basis).

first_met_exception([], none).
first_met_exception([evaluated_exception(ExceptionName, met, _)|_], ExceptionName).
first_met_exception([evaluated_exception(_, unmet, _)|Remaining], ExceptionName) :-
    first_met_exception(Remaining, ExceptionName).
first_met_exception([evaluated_exception(_, open(_, _, _), _)|Remaining], ExceptionName) :-
    first_met_exception(Remaining, ExceptionName).

first_met_basis([], none).
first_met_basis([evaluated_point(Basis, met)|_], Basis).
first_met_basis([evaluated_point(_, unmet)|Remaining], Basis) :-
    first_met_basis(Remaining, Basis).
first_met_basis([evaluated_point(_, open(_, _, _))|Remaining], Basis) :-
    first_met_basis(Remaining, Basis).

open_comply(RequestTag, Profile, Evaluation, Comply) :-
    open_contributions(RequestTag, Profile, Evaluation, contribution(Absent, Unsure, Facts, Judgements)),
    order_keys(Absent, OrderedAbsent),
    order_keys(Unsure, OrderedUnsure),
    order_keys(Facts, OrderedFacts),
    pairs_for(RequestTag, Profile, Facts, Judgements, Pairs),
    open_status(OrderedAbsent, OrderedFacts, OrderedUnsure, RequestTag, Pairs, Comply).

open_status([AttributeKey|KeyList], _, _, _, _, indeterminate([AttributeKey|KeyList])).
open_status([], [Fact|_], _, _, Pairs, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on(Pairs)])) :-
    outside_fact_row(Fact, Citation, Target).
open_status([], [], [Input|_], RequestTag, Pairs, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)])) :-
    referral_citation(RequestTag, Input, Citation).

open_contributions(RequestTag, Profile, evaluation(_, EngagementValue, ExceptionValues, SuspensionValue), contribution(Absent, Unsure, Facts, Judgements)) :-
    engagement_expression(RequestTag, EngagementExpression),
    suspension_row(SuspensionExpression, _),
    findall(Value - Expression, member(evaluated_exception(_, Value, Expression), ExceptionValues), ExceptionLimbs),
    maplist(limb_contribution(Profile), [EngagementValue - EngagementExpression, SuspensionValue - SuspensionExpression|ExceptionLimbs], Contributions),
    maplist(contribution_parts, Contributions, AbsentLists, UnsureLists, FactLists, JudgementLists),
    append(AbsentLists, Absent),
    append(UnsureLists, Unsure),
    append(FactLists, Facts),
    append(JudgementLists, Judgements).

limb_contribution(_, met - _, contribution([], [], [], [])).
limb_contribution(_, unmet - _, contribution([], [], [], [])).
limb_contribution(Profile, open(Absent, Unsure, Facts) - Expression, contribution(Absent, Unsure, Facts, Judgements)) :-
    expression_keys(Expression, KeyList),
    tfilter(present_judgement_t(Profile), KeyList, Judgements).

contribution_parts(contribution(Absent, Unsure, Facts, Judgements), Absent, Unsure, Facts, Judgements).

pairs_for(RequestTag, Profile, Facts, Judgements, Pairs) :-
    tag_base_keys(RequestTag, BaseKeys),
    append([BaseKeys, Judgements, Facts], Carried),
    order_keys(Carried, Ordered),
    maplist(key_pair(Profile), Ordered, Pairs).

decision_pairs(RequestTag, Profile, Pairs) :-
    tag_evaluation(Profile, RequestTag, Evaluation),
    open_contributions(RequestTag, Profile, Evaluation, contribution(_, _, Facts, Judgements)),
    pairs_for(RequestTag, Profile, Facts, Judgements, Pairs).

response_deadline(date(YearNumber, MonthNumber, DayNumber), Period, Deadline) :-
    implements(eu_reg_1971_1182_art_3_1),
    period_months(Period, Months, _),
    month_period_end(YearNumber, MonthNumber, DayNumber, Months, LastDay),
    weekend_shift(LastDay, Deadline).

month_period_end(YearNumber, MonthNumber, DayNumber, Months, date(EndYear, EndMonth, EndDay)) :-
    implements(eu_reg_1971_1182_art_3_2_c),
    MonthIndex #= YearNumber * 12 + MonthNumber - 1 + Months,
    EndYear #= MonthIndex // 12,
    EndMonth #= MonthIndex mod 12 + 1,
    month_length(EndYear, EndMonth, MonthDays),
    EndDay #= min(DayNumber, MonthDays).

month_length(_, 1, 31).
month_length(YearNumber, 2, Length) :-
    leap_year_t(YearNumber, IsLeapYear),
    february_length(IsLeapYear, Length).
month_length(_, 3, 31).
month_length(_, 4, 30).
month_length(_, 5, 31).
month_length(_, 6, 30).
month_length(_, 7, 31).
month_length(_, 8, 31).
month_length(_, 9, 30).
month_length(_, 10, 31).
month_length(_, 11, 30).
month_length(_, 12, 31).

february_length(true, 29).
february_length(false, 28).

leap_year_t(YearNumber, IsLeapYear) :-
    implements(eu_reg_1971_1182_art_3_2_c),
    FourYearRemainder is YearNumber mod 4,
    CenturyRemainder is YearNumber mod 100,
    FourCenturyRemainder is YearNumber mod 400,
    gregorian_leap_t(FourYearRemainder, CenturyRemainder, FourCenturyRemainder, IsLeapYear).

gregorian_leap_t(_, _, 0, true).
gregorian_leap_t(0, CenturyRemainder, _, true) :-
    CenturyRemainder =\= 0.
gregorian_leap_t(_, 0, FourCenturyRemainder, false) :-
    FourCenturyRemainder =\= 0.
gregorian_leap_t(FourYearRemainder, _, _, false) :-
    FourYearRemainder =\= 0.

day_of_week(date(YearNumber, MonthNumber, DayNumber), Weekday) :-
    implements(eu_reg_1971_1182_art_3_4),
    month_weekday_offset(MonthNumber, Offset),
    january_february_shift(MonthNumber, Shift),
    ShiftedYear #= YearNumber - Shift,
    Weekday #= (ShiftedYear + ShiftedYear // 4 - ShiftedYear // 100 + ShiftedYear // 400 + Offset + DayNumber) mod 7.

month_weekday_offset(1, 0).
month_weekday_offset(2, 3).
month_weekday_offset(3, 2).
month_weekday_offset(4, 5).
month_weekday_offset(5, 0).
month_weekday_offset(6, 3).
month_weekday_offset(7, 5).
month_weekday_offset(8, 1).
month_weekday_offset(9, 4).
month_weekday_offset(10, 6).
month_weekday_offset(11, 2).
month_weekday_offset(12, 4).

january_february_shift(MonthNumber, 1) :-
    MonthNumber #< 3.
january_february_shift(MonthNumber, 0) :-
    MonthNumber #>= 3.

weekend_shift(Date, Deadline) :-
    implements(eu_reg_1971_1182_art_3_4),
    day_of_week(Date, Weekday),
    weekend_extra_days(Weekday, ExtraDays),
    add_days(Date, ExtraDays, Deadline).

weekend_extra_days(0, 1).
weekend_extra_days(1, 0).
weekend_extra_days(2, 0).
weekend_extra_days(3, 0).
weekend_extra_days(4, 0).
weekend_extra_days(5, 0).
weekend_extra_days(6, 2).

add_days(Date, 0, Date).
add_days(Date, Count, Result) :-
    Count #> 0,
    next_day(Date, Next),
    Remaining #= Count - 1,
    add_days(Next, Remaining, Result).

next_day(date(YearNumber, MonthNumber, DayNumber), date(YearNumber, MonthNumber, NextDayNumber)) :-
    month_length(YearNumber, MonthNumber, MonthDays),
    DayNumber #< MonthDays,
    NextDayNumber #= DayNumber + 1.
next_day(date(YearNumber, MonthNumber, DayNumber), date(YearNumber, NextMonth, 1)) :-
    month_length(YearNumber, MonthNumber, MonthDays),
    DayNumber #= MonthDays,
    MonthNumber #< 12,
    NextMonth #= MonthNumber + 1.
next_day(date(YearNumber, 12, 31), date(NextYear, 1, 1)) :-
    NextYear #= YearNumber + 1.

holiday_shift(Date, Holidays, Result) :-
    implements(eu_reg_1971_1182_art_3_4),
    memberd_t(Date, Holidays, IsHoliday),
    holiday_step(IsHoliday, Date, Holidays, Result).

holiday_step(false, Date, _, Date).
holiday_step(true, Date, Holidays, Result) :-
    next_working_day(Date, Holidays, Result).

next_working_day(Date, Holidays, Result) :-
    implements(eu_reg_1971_1182_art_2_2),
    next_day(Date, Next),
    working_day_t(Next, Holidays, IsWorkingDay),
    working_step(IsWorkingDay, Next, Holidays, Result).

working_step(true, Date, _, Date).
working_step(false, Date, Holidays, Result) :-
    next_working_day(Date, Holidays, Result).

working_day_t(Date, Holidays, Truth) :-
    implements(eu_reg_1971_1182_art_2_2),
    day_of_week(Date, Weekday),
    weekday_truth(Weekday, IsWeekday),
    memberd_t(Date, Holidays, IsHoliday),
    working_truth(IsWeekday, IsHoliday, Truth).

weekday_truth(0, false).
weekday_truth(1, true).
weekday_truth(2, true).
weekday_truth(3, true).
weekday_truth(4, true).
weekday_truth(5, true).
weekday_truth(6, false).

working_truth(true, false, true).
working_truth(true, true, false).
working_truth(false, _, false).

attested_holidays(Profile, Holidays) :-
    key_value(Profile, public_holidays, Given),
    holiday_list(Given, Holidays).

holiday_list(absent, []).
holiday_list(attested(Holidays, _), Holidays).

period_deadline(Receipt, Period, Profile, Deadline) :-
    implements(eu_reg_1971_1182_art_3_4),
    response_deadline(Receipt, Period, WeekendAdjusted),
    attested_holidays(Profile, Holidays),
    holiday_shift(WeekendAdjusted, Holidays, Deadline).

applicable_response_period(Profile, Result) :-
    implements(eu_reg_2016_679_art_12_3),
    key_value(Profile, extension_claimed, Claimed),
    claimed_period(Claimed, Profile, Result).

claimed_period(absent, _, period(first_period)).
claimed_period(false, _, period(first_period)).
claimed_period(true, Profile, Result) :-
    key_value(Profile, extension_necessary_for_complexity_and_number, Necessary),
    necessity_period(Necessary, Result).

necessity_period(absent, status(indeterminate([extension_necessary_for_complexity_and_number]))).
necessity_period(true, period(extended_period)).
necessity_period(false, period(first_period)).
necessity_period(unsure, status(needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])]))).

relation_answer(_, suspension, _, suspended(art12_6_identity_not_confirmed)).
relation_answer(deadline, relief, Profile, Answer) :-
    implements(eu_reg_2016_679_art_12_4),
    key_value(Profile, request_received_on, Receipt),
    refusal_deadline(Receipt, Profile, Answer).
relation_answer(deadline, compliance(_), Profile, Answer) :-
    implements(eu_reg_2016_679_art_12_3),
    own_missing_keys(deadline, Profile, Missing),
    compliance_deadline(Missing, Profile, Answer).
relation_answer(duties, relief, _, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]) :-
    implements(eu_reg_2016_679_art_12_4).
relation_answer(duties, compliance(_), Profile, Answer) :-
    implements(eu_reg_2016_679_art_12_3),
    own_missing_keys(duties, Profile, Missing),
    compliance_duties(Missing, Profile, Answer).
relation_answer(recipients, relief, _, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]) :-
    implements(eu_reg_2016_679_art_19).
relation_answer(recipients, compliance(RequestTag), Profile, Answer) :-
    implements(eu_reg_2016_679_art_19),
    notifying_tag_t(RequestTag, Notifying),
    notification_duties(Notifying, Profile, Answer).

refusal_deadline(absent, _, indeterminate([request_received_on])).
refusal_deadline(Receipt, Profile, Deadline) :-
    dif(Receipt, absent),
    period_deadline(Receipt, first_period, Profile, Deadline).

compliance_deadline([], Profile, Answer) :-
    applicable_response_period(Profile, PeriodResult),
    key_value(Profile, request_received_on, Receipt),
    period_result_deadline(PeriodResult, Receipt, Profile, Answer).
compliance_deadline([AttributeKey|KeyList], _, indeterminate([AttributeKey|KeyList])).

period_result_deadline(period(Period), Receipt, Profile, Deadline) :-
    period_deadline(Receipt, Period, Profile, Deadline).
period_result_deadline(status(Status), _, _, Status).

compliance_duties([], Profile, Duties) :-
    applicable_response_period(Profile, PeriodResult),
    period_duties(PeriodResult, Duties).
compliance_duties([AttributeKey|KeyList], _, indeterminate([AttributeKey|KeyList])).

period_duties(period(first_period), [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]) :-
    implements(eu_reg_2016_679_art_12_3).
period_duties(period(extended_period), [inform_of_extension_with_reasons(first_period, cite(eu_reg_2016_679_art_12_3)), respond_with_action_taken(extended_period, cite(eu_reg_2016_679_art_12_3))]) :-
    implements(eu_reg_2016_679_art_12_3).
period_duties(status(Status), Status).

notifying_tag_t(rectification, true).
notifying_tag_t(erasure, true).
notifying_tag_t(restriction, true).
notifying_tag_t(access, false).
notifying_tag_t(portability, false).
notifying_tag_t(automated_decision, false).
notifying_tag_t(objection(_), false).

notifying_request_type_t(rectification, true).
notifying_request_type_t(erasure, true).
notifying_request_type_t(restriction, true).
notifying_request_type_t(access, false).
notifying_request_type_t(portability, false).
notifying_request_type_t(objection, false).
notifying_request_type_t(automated_decision, false).
notifying_request_type_t(absent, false).

notification_duties(false, _, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).
notification_duties(true, Profile, Answer) :-
    key_value(Profile, personal_data_disclosed_to_recipients, Disclosed),
    disclosure_duties(Disclosed, Profile, Answer).

disclosure_duties(absent, _, indeterminate([personal_data_disclosed_to_recipients])).
disclosure_duties(false, _, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).
disclosure_duties(true, Profile, Answer) :-
    key_value(Profile, recipient_notification_impossible_or_disproportionate_effort, Effort),
    effort_duties(Effort, Profile, Answer).

effort_duties(absent, _, indeterminate([recipient_notification_impossible_or_disproportionate_effort])).
effort_duties(true, _, [recipient_notification_excused(cite(eu_reg_2016_679_art_19))]).
effort_duties(unsure, _, needs_legal_review(open_textured(recipient_notification_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_19)), [inputs_relied_on([recipient_notification_impossible_or_disproportionate_effort - unsure])])).
effort_duties(false, Profile, Answer) :-
    key_value(Profile, data_subject_asks_who_the_recipients_are, Asks),
    recipients_duties(Asks, Answer).

recipients_duties(true, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19)), inform_data_subject_of_recipients(cite(eu_reg_2016_679_art_19))]).
recipients_duties(false, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19))]).
recipients_duties(absent, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19))]).

own_missing_keys(deadline, Profile, Missing) :-
    key_value(Profile, request_received_on, Receipt),
    receipt_missing(Receipt, ReceiptMissing),
    extension_missing(Profile, ExtensionMissing),
    append(ReceiptMissing, ExtensionMissing, Missing).
own_missing_keys(duties, Profile, Missing) :-
    extension_missing(Profile, Missing).
own_missing_keys(recipients, Profile, Missing) :-
    key_value(Profile, request_type, RequestType),
    notifying_request_type_t(RequestType, Notifying),
    notifying_missing(Notifying, Profile, Missing).

receipt_missing(absent, [request_received_on]).
receipt_missing(Receipt, []) :-
    dif(Receipt, absent).

extension_missing(Profile, Missing) :-
    key_value(Profile, extension_claimed, Claimed),
    claimed_missing(Claimed, Profile, Missing).

claimed_missing(true, Profile, Missing) :-
    key_value(Profile, extension_necessary_for_complexity_and_number, Necessary),
    necessity_missing(Necessary, Missing).
claimed_missing(false, _, []).
claimed_missing(absent, _, []).

necessity_missing(absent, [extension_necessary_for_complexity_and_number]).
necessity_missing(Necessary, []) :-
    dif(Necessary, absent).

notifying_missing(false, _, []).
notifying_missing(true, Profile, Missing) :-
    key_value(Profile, personal_data_disclosed_to_recipients, Disclosed),
    disclosed_missing(Disclosed, Profile, Missing).

disclosed_missing(absent, _, [personal_data_disclosed_to_recipients]).
disclosed_missing(false, _, []).
disclosed_missing(true, Profile, Missing) :-
    key_value(Profile, recipient_notification_impossible_or_disproportionate_effort, Effort),
    effort_missing(Effort, Missing).

effort_missing(absent, [recipient_notification_impossible_or_disproportionate_effort]).
effort_missing(Effort, []) :-
    dif(Effort, absent).

request_response_deadline(Profile, Deadline) :-
    relation_query(deadline, Profile, Deadline).

response_duties(Profile, Duties) :-
    relation_query(duties, Profile, Duties).

recipient_notification(Profile, Duties) :-
    relation_query(recipients, Profile, Duties).

relation_query(Relation, Profile, Answer) :-
    decide_request(Profile, gdpr_data_subject_request_verdict(Comply, _, _, _, _)),
    relation_after(Comply, Relation, Profile, Answer).

relation_after(input_problems(Problems), _, _, input_problems(Problems)).
relation_after(need_not_comply, Relation, Profile, Answer) :-
    relation_answer(Relation, relief, Profile, Answer).
relation_after(must_comply, Relation, Profile, Answer) :-
    completion_tags(Profile, [RequestTag]),
    relation_answer(Relation, compliance(RequestTag), Profile, Answer).
relation_after(indeterminate(KeyList), Relation, Profile, Answer) :-
    non_final_answer(indeterminate(KeyList), Relation, Profile, Answer).
relation_after(needs_legal_review(Reason, Context), Relation, Profile, Answer) :-
    non_final_answer(needs_legal_review(Reason, Context), Relation, Profile, Answer).
relation_after(suspended(Reason), Relation, Profile, Answer) :-
    non_final_answer(suspended(Reason), Relation, Profile, Answer).

completion_tags(Profile, RequestTags) :-
    profile_state(Profile, State),
    state_tags(State, RequestTags).

state_tags(missing(request_type), [access, rectification, erasure, restriction, portability, objection(art21_1), objection(art21_2), objection(art21_6), automated_decision]).
state_tags(missing(objection_ground_claimed), [objection(art21_1), objection(art21_2), objection(art21_6)]).
state_tags(tag(RequestTag), [RequestTag]).

tag_limbs(Profile, RequestTag, limbs_of(RequestTag, limbs(EngagementValue, SpecificValue, CommonValue, SuspensionValue))) :-
    engagement_expression(RequestTag, EngagementExpression),
    evaluate(Profile, EngagementExpression, EngagementValue),
    specific_exception_total(RequestTag, SpecificExpression),
    evaluate(Profile, SpecificExpression, SpecificValue),
    common_exception_total(CommonExpression),
    evaluate(Profile, CommonExpression, CommonValue),
    suspension_row(SuspensionExpression, _),
    evaluate(Profile, SuspensionExpression, SuspensionValue).

specific_exception_total(automated_decision, conjunction([disjunction([defeater(decision_necessary_for_contract_with_data_subject), blocking(decision_authorised_by_union_or_member_state_law), defeater(data_subject_gave_explicit_consent)]), negation(special_category_bar)])) :-
    implements(eu_reg_2016_679_art_22_2).
specific_exception_total(RequestTag, disjunction(Expressions)) :-
    separable_exception_tag(RequestTag),
    findall(Expression, exception_row(RequestTag, _, Expression, _), Expressions).

separable_exception_tag(access).
separable_exception_tag(rectification).
separable_exception_tag(erasure) :-
    implements(eu_reg_2016_679_art_17_3).
separable_exception_tag(restriction).
separable_exception_tag(portability).
separable_exception_tag(objection(art21_1)).
separable_exception_tag(objection(art21_2)) :-
    implements(eu_reg_2016_679_art_21_3).
separable_exception_tag(objection(art21_6)).

common_exception_total(disjunction(Expressions)) :-
    findall(Expression, common_exception_row(_, Expression, _), Expressions).

limb_entries(limbs(EngagementValue, SpecificValue, CommonValue, SuspensionValue), [engagement - EngagementValue, specific_exceptions - SpecificValue, common_exceptions - CommonValue, identity_suspension - SuspensionValue]).

outcome_of(_, unmet, _, _, _, relief).
outcome_of(_, met, met, _, _, relief).
outcome_of(_, met, unmet, met, _, relief).
outcome_of(_, met, unmet, unmet, met, suspension).
outcome_of(RequestTag, met, unmet, unmet, unmet, compliance(RequestTag)).

completion_outcomes(TagLimbs, Outcomes) :-
    findall(Outcome, completion_outcome(TagLimbs, Outcome), Found),
    sort(Found, Outcomes).

completion_outcome(TagLimbs, Outcome) :-
    member(limbs_of(RequestTag, limbs(EngagementValue, SpecificValue, CommonValue, SuspensionValue)), TagLimbs),
    reachable(EngagementValue, EngagementChoices),
    member(Engagement, EngagementChoices),
    reachable(SpecificValue, SpecificChoices),
    member(Specific, SpecificChoices),
    reachable(CommonValue, CommonChoices),
    member(Common, CommonChoices),
    reachable(SuspensionValue, SuspensionChoices),
    member(Suspension, SuspensionChoices),
    outcome_of(RequestTag, Engagement, Specific, Common, Suspension, Outcome).

non_final_answer(Comply, Relation, Profile, Answer) :-
    completion_tags(Profile, RequestTags),
    maplist(tag_limbs(Profile), RequestTags, TagLimbs),
    completion_outcomes(TagLimbs, Outcomes),
    findall(Candidate, outcome_answer(Relation, Profile, Outcomes, Candidate), Candidates),
    sort(Candidates, Answers),
    answers_choice(Answers, Comply, Relation, Profile, TagLimbs, Outcomes, Answer).

outcome_answer(Relation, Profile, Outcomes, Answer) :-
    member(Outcome, Outcomes),
    relation_answer(Relation, Outcome, Profile, Answer).

answers_choice([Answer], _, _, _, _, _, Answer).
answers_choice([_, _|_], Comply, Relation, Profile, TagLimbs, Outcomes, Answer) :-
    second_rule(Comply, Relation, Profile, TagLimbs, Outcomes, Answer).

second_rule(suspended(Reason), deadline, Profile, _, Outcomes, Answer) :-
    key_value(Profile, request_received_on, Receipt),
    suspended_deadline(Receipt, Outcomes, Reason, Answer).
second_rule(suspended(Reason), duties, _, _, _, suspended(Reason)).
second_rule(suspended(Reason), recipients, _, _, _, suspended(Reason)).
second_rule(needs_legal_review(Reason, Context), Relation, Profile, _, _, Answer) :-
    own_missing_keys(Relation, Profile, Missing),
    review_or_missing(Missing, Reason, Context, Answer).
second_rule(indeterminate(KeyList), Relation, Profile, TagLimbs, Outcomes, Answer) :-
    tfilter(key_pivotal_t(Relation, Profile, TagLimbs), KeyList, PivotalKeys),
    decision_alternative(PivotalKeys, Relation, Profile, TagLimbs, ChosenKeys),
    own_missing_keys(Relation, Profile, OwnMissing),
    append(ChosenKeys, OwnMissing, Combined),
    order_keys(Combined, Ordered),
    indeterminate_outcome(Ordered, Relation, Profile, TagLimbs, Outcomes, KeyList, Answer).

suspended_deadline(absent, Outcomes, Reason, Answer) :-
    memberd_t(relief, Outcomes, HasRelief),
    suspended_receipt(HasRelief, Reason, Answer).
suspended_deadline(Receipt, _, Reason, suspended(Reason)) :-
    dif(Receipt, absent).

suspended_receipt(true, _, indeterminate([request_received_on])).
suspended_receipt(false, Reason, suspended(Reason)).

review_or_missing([], Reason, Context, needs_legal_review(Reason, Context)).
review_or_missing([AttributeKey|KeyList], _, _, indeterminate([AttributeKey|KeyList])).

decision_alternative([AttributeKey|KeyList], _, _, _, [AttributeKey|KeyList]).
decision_alternative([], Relation, Profile, TagLimbs, ChosenKeys) :-
    key_value(Profile, request_type, RequestType),
    alternative_limbs(RequestType, AllowedLimbs),
    findall(AttributeKey, alternative_key(TagLimbs, AllowedLimbs, AttributeKey), Candidates),
    tfilter(key_pivotal_t(Relation, Profile, TagLimbs), Candidates, ChosenKeys).

alternative_limbs(absent, [common_exceptions, identity_suspension]).
alternative_limbs(RequestType, [engagement, specific_exceptions, common_exceptions, identity_suspension]) :-
    dif(RequestType, absent).

alternative_key(TagLimbs, AllowedLimbs, AttributeKey) :-
    member(limbs_of(_, Limbs), TagLimbs),
    limb_entries(Limbs, Entries),
    member(Limb - Value, Entries),
    member(Limb, AllowedLimbs),
    value_absent_keys(Value, Absent),
    member(AttributeKey, Absent).

indeterminate_outcome([AttributeKey|KeyList], _, _, _, _, _, indeterminate([AttributeKey|KeyList])).
indeterminate_outcome([], _, _, _, [suspension], _, suspended(art12_6_identity_not_confirmed)).
indeterminate_outcome([], Relation, Profile, TagLimbs, Outcomes, KeyList, Answer) :-
    dif(Outcomes, [suspension]),
    findall(AttributeKey, unsure_candidate(TagLimbs, AttributeKey), Candidates),
    tfilter(key_pivotal_t(Relation, Profile, TagLimbs), Candidates, Pivotal),
    order_keys(Pivotal, Ordered),
    unsure_review(Ordered, Profile, TagLimbs, KeyList, Answer).

unsure_candidate(TagLimbs, AttributeKey) :-
    member(limbs_of(_, Limbs), TagLimbs),
    limb_entries(Limbs, Entries),
    member(_ - Value, Entries),
    value_unsure_keys(Value, Unsure),
    member(AttributeKey, Unsure).

unsure_review([], _, _, KeyList, indeterminate(KeyList)).
unsure_review([Input|_], Profile, TagLimbs, _, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)])) :-
    findall(Cite, input_citation(TagLimbs, Input, Cite), Cites),
    sort(Cites, [Citation|_]),
    review_pairs(TagLimbs, Profile, Input, Pairs).

input_citation(TagLimbs, Input, Cite) :-
    member(limbs_of(RequestTag, _), TagLimbs),
    referral_citation(RequestTag, Input, Cite).

review_pairs([limbs_of(RequestTag, _)], Profile, _, Pairs) :-
    decision_pairs(RequestTag, Profile, Pairs).
review_pairs([_, _|_], Profile, Input, [Input - Value]) :-
    key_value(Profile, Input, Value).

key_pivotal_t(Relation, Profile, TagLimbs, AttributeKey, Truth) :-
    if_(AttributeKey = request_type, request_type_pivot_t(Relation, Profile, TagLimbs, Truth), if_(AttributeKey = objection_ground_claimed, ground_pivot_t(Relation, Profile, TagLimbs, Truth), limb_key_pivot_t(Relation, Profile, TagLimbs, AttributeKey, Truth))).

limb_key_pivot_t(Relation, Profile, TagLimbs, AttributeKey, Truth) :-
    findall(Distinct, limb_key_pivot(Relation, Profile, TagLimbs, AttributeKey, Distinct), Distincts),
    memberd_t(true, Distincts, Truth).

limb_key_pivot(Relation, Profile, TagLimbs, AttributeKey, Distinct) :-
    member(limbs_of(RequestTag, Limbs), TagLimbs),
    limb_entries(Limbs, Entries),
    member(Limb - Value, Entries),
    value_open_keys(Value, OpenKeys),
    member(AttributeKey, OpenKeys),
    limb_pivot_value(Limb, Relation, Profile, RequestTag, Limbs, Distinct).

limb_pivot_value(engagement, Relation, Profile, RequestTag, limbs(_, SpecificValue, CommonValue, SuspensionValue), Distinct) :-
    reachable(SpecificValue, SpecificChoices),
    member(Specific, SpecificChoices),
    reachable(CommonValue, CommonChoices),
    member(Common, CommonChoices),
    reachable(SuspensionValue, SuspensionChoices),
    member(Suspension, SuspensionChoices),
    outcome_of(RequestTag, met, Specific, Common, Suspension, Outcome),
    distinguishable_t(Relation, Profile, relief, Outcome, Distinct).
limb_pivot_value(specific_exceptions, Relation, Profile, RequestTag, limbs(EngagementValue, _, CommonValue, SuspensionValue), Distinct) :-
    reachable(EngagementValue, EngagementChoices),
    member(met, EngagementChoices),
    reachable(CommonValue, CommonChoices),
    member(unmet, CommonChoices),
    reachable(SuspensionValue, SuspensionChoices),
    member(Suspension, SuspensionChoices),
    outcome_of(RequestTag, met, unmet, unmet, Suspension, Outcome),
    distinguishable_t(Relation, Profile, relief, Outcome, Distinct).
limb_pivot_value(common_exceptions, Relation, Profile, RequestTag, limbs(EngagementValue, SpecificValue, _, SuspensionValue), Distinct) :-
    reachable(EngagementValue, EngagementChoices),
    member(met, EngagementChoices),
    reachable(SpecificValue, SpecificChoices),
    member(unmet, SpecificChoices),
    reachable(SuspensionValue, SuspensionChoices),
    member(Suspension, SuspensionChoices),
    outcome_of(RequestTag, met, unmet, unmet, Suspension, Outcome),
    distinguishable_t(Relation, Profile, relief, Outcome, Distinct).
limb_pivot_value(identity_suspension, _, _, _, limbs(EngagementValue, SpecificValue, CommonValue, _), true) :-
    reachable(EngagementValue, EngagementChoices),
    member(met, EngagementChoices),
    reachable(SpecificValue, SpecificChoices),
    member(unmet, SpecificChoices),
    reachable(CommonValue, CommonChoices),
    member(unmet, CommonChoices).

request_type_pivot_t(Relation, Profile, TagLimbs, Truth) :-
    findall(Distinct, request_type_pair(Relation, Profile, TagLimbs, Distinct), Distincts),
    memberd_t(true, Distincts, Truth).

request_type_pair(Relation, Profile, TagLimbs, Distinct) :-
    member(limbs_of(FirstTag, FirstLimbs), TagLimbs),
    member(limbs_of(SecondTag, SecondLimbs), TagLimbs),
    tag_request_type(FirstTag, FirstType),
    tag_request_type(SecondTag, SecondType),
    dif(FirstType, SecondType),
    paired_outcomes(FirstTag, FirstLimbs, SecondTag, SecondLimbs, FirstOutcome, SecondOutcome),
    distinguishable_t(Relation, Profile, FirstOutcome, SecondOutcome, Distinct).

ground_pivot_t(Relation, Profile, TagLimbs, Truth) :-
    findall(Distinct, ground_pair(Relation, Profile, TagLimbs, Distinct), Distincts),
    memberd_t(true, Distincts, Truth).

ground_pair(Relation, Profile, TagLimbs, Distinct) :-
    member(limbs_of(FirstTag, FirstLimbs), TagLimbs),
    member(limbs_of(SecondTag, SecondLimbs), TagLimbs),
    tag_ground(FirstTag, FirstGround),
    tag_ground(SecondTag, SecondGround),
    dif(FirstGround, SecondGround),
    paired_outcomes(FirstTag, FirstLimbs, SecondTag, SecondLimbs, FirstOutcome, SecondOutcome),
    distinguishable_t(Relation, Profile, FirstOutcome, SecondOutcome, Distinct).

paired_outcomes(FirstTag, limbs(FirstEngagementValue, FirstSpecificValue, CommonValue, SuspensionValue), SecondTag, limbs(SecondEngagementValue, SecondSpecificValue, _, _), FirstOutcome, SecondOutcome) :-
    reachable(CommonValue, CommonChoices),
    member(Common, CommonChoices),
    reachable(SuspensionValue, SuspensionChoices),
    member(Suspension, SuspensionChoices),
    reachable(FirstEngagementValue, FirstEngagementChoices),
    member(FirstEngagement, FirstEngagementChoices),
    reachable(FirstSpecificValue, FirstSpecificChoices),
    member(FirstSpecific, FirstSpecificChoices),
    reachable(SecondEngagementValue, SecondEngagementChoices),
    member(SecondEngagement, SecondEngagementChoices),
    reachable(SecondSpecificValue, SecondSpecificChoices),
    member(SecondSpecific, SecondSpecificChoices),
    outcome_of(FirstTag, FirstEngagement, FirstSpecific, Common, Suspension, FirstOutcome),
    outcome_of(SecondTag, SecondEngagement, SecondSpecific, Common, Suspension, SecondOutcome).

distinguishable_t(_, _, suspension, suspension, false).
distinguishable_t(_, _, suspension, relief, true).
distinguishable_t(_, _, relief, suspension, true).
distinguishable_t(_, _, suspension, compliance(_), true).
distinguishable_t(_, _, compliance(_), suspension, true).
distinguishable_t(_, _, relief, relief, false).
distinguishable_t(Relation, Profile, relief, compliance(RequestTag), Truth) :-
    relief_compliance_t(Relation, Profile, RequestTag, Truth).
distinguishable_t(Relation, Profile, compliance(RequestTag), relief, Truth) :-
    relief_compliance_t(Relation, Profile, RequestTag, Truth).
distinguishable_t(Relation, Profile, compliance(FirstTag), compliance(SecondTag), Truth) :-
    compliance_pair_t(Relation, Profile, FirstTag, SecondTag, Truth).

relief_compliance_t(deadline, Profile, _, Truth) :-
    extension_reachable_t(Profile, Truth).
relief_compliance_t(duties, _, _, true).
relief_compliance_t(recipients, Profile, RequestTag, Truth) :-
    notifying_tag_t(RequestTag, Notifying),
    disclosure_open_t(Profile, Disclosable),
    truth_and(Notifying, Disclosable, Truth).

compliance_pair_t(deadline, _, _, _, false).
compliance_pair_t(duties, _, _, _, false).
compliance_pair_t(recipients, Profile, FirstTag, SecondTag, Truth) :-
    notifying_tag_t(FirstTag, FirstNotifying),
    notifying_tag_t(SecondTag, SecondNotifying),
    truth_differ(FirstNotifying, SecondNotifying, Differ),
    disclosure_open_t(Profile, Disclosable),
    truth_and(Differ, Disclosable, Truth).

extension_reachable_t(Profile, Truth) :-
    key_value(Profile, extension_claimed, Claimed),
    claimed_reachable_t(Claimed, Profile, Truth).

claimed_reachable_t(true, Profile, Truth) :-
    key_value(Profile, extension_necessary_for_complexity_and_number, Necessary),
    necessity_reachable_t(Necessary, Truth).
claimed_reachable_t(false, _, false).
claimed_reachable_t(absent, _, false).

necessity_reachable_t(true, true).
necessity_reachable_t(unsure, true).
necessity_reachable_t(absent, true).
necessity_reachable_t(false, false).

disclosure_open_t(Profile, Truth) :-
    key_value(Profile, personal_data_disclosed_to_recipients, Disclosed),
    disclosure_reachable_t(Disclosed, Truth).

disclosure_reachable_t(absent, true).
disclosure_reachable_t(true, true).
disclosure_reachable_t(false, false).

decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_rights_response_duties_verdict(Comply, Citations)) :-
    decide_request(Profile, gdpr_data_subject_request_verdict(Comply, Basis, Exception, _, _)),
    verdict_citations(Basis, Exception, Citations).

verdict_citations(Basis, Exception, Citations) :-
    findall(CitationKey, engagement_point(_, Basis, _, cite(CitationKey)), BasisKeys),
    findall(CitationKey, exception_citation_key(Exception, CitationKey), ExceptionKeys),
    append(BasisKeys, ExceptionKeys, AllKeys),
    sort(AllKeys, Citations).

exception_citation_key(Exception, CitationKey) :-
    exception_row(_, Exception, _, cite(CitationKey)).
exception_citation_key(Exception, CitationKey) :-
    common_exception_row(Exception, _, cite(CitationKey)).

gdpr_data_subject_rights_response_duties_status(Profile, Status) :-
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_rights_response_duties_verdict(Comply, _)),
    functor(Comply, Status, _).

gdpr_data_subject_rights_response_duties_decision_resolvable(Profile) :-
    decide_gdpr_data_subject_rights_response_duties(Profile, _).

gdpr_data_subject_rights_response_duties_checklist(Profile, Items) :-
    profile_state(Profile, State),
    state_checklist(State, Profile, Items).

state_checklist(problems(Problems), _, [item(input_check, unmet(input_problems(Problems)), cite(eu_reg_2016_679_art_12_2))]).
state_checklist(missing(AttributeKey), _, [item(AttributeKey, unknown([AttributeKey]), cite(eu_reg_2016_679_art_12_2))]).
state_checklist(tag(RequestTag), Profile, Items) :-
    tag_evaluation(Profile, RequestTag, evaluation(_, EngagementValue, ExceptionValues, SuspensionValue)),
    tag_cite(RequestTag, EngagementCite),
    item_status(EngagementValue, engagement, EngagementStatus),
    maplist(exception_item(RequestTag), ExceptionValues, ExceptionItems),
    item_status(SuspensionValue, art12_6_identity_not_confirmed, SuspensionStatus),
    append([[item(engagement, EngagementStatus, EngagementCite)], ExceptionItems, [item(identity_suspension, SuspensionStatus, cite(eu_reg_2016_679_art_12_6))]], Items).

exception_item(RequestTag, evaluated_exception(ExceptionName, Value, _), item(ExceptionName, Status, Citation)) :-
    item_status(Value, ExceptionName, Status),
    exception_cite(RequestTag, ExceptionName, Citation).

exception_cite(RequestTag, ExceptionName, Citation) :-
    exception_row(RequestTag, ExceptionName, _, Citation).
exception_cite(_, ExceptionName, Citation) :-
    common_exception_row(ExceptionName, _, Citation).

item_status(met, _, met).
item_status(unmet, Reason, unmet(Reason)).
item_status(open(Absent, Unsure, Facts), _, unknown(KeyList)) :-
    append([Absent, Unsure, Facts], KeyList).

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(Input, Citation) :-
    atom(Input),
    compound(Citation).

cross_reference_unresolved(Citation, Target) :-
    compound(Citation),
    compound(Target).

resolution(Target, Status) :-
    compound(Target),
    atom(Status).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Clause, Citations) :-
    nonvar(Clause),
    clausal_is_list(Citations).

suspended(Reason) :-
    atom(Reason).

input_problems(Problems) :-
    clausal_is_list(Problems).

unknown_key(AttributeKey) :-
    nonvar(AttributeKey).

wrong_type(AttributeKey) :-
    atom(AttributeKey).

duplicate_key(AttributeKey) :-
    atom(AttributeKey).

attested(Value, Attestation) :-
    nonvar(Value),
    compound(Attestation).

attestation(Attester, AttestedAt, Reason, Evidence) :-
    nonvar(Attester),
    nonvar(AttestedAt),
    nonvar(Reason),
    nonvar(Evidence).

url(Location, RetrievedAt) :-
    nonvar(Location),
    nonvar(RetrievedAt).

document(UploadIdentifier, Checksum) :-
    nonvar(UploadIdentifier),
    nonvar(Checksum).

respond_with_action_taken(Period, Citation) :-
    atom(Period),
    compound(Citation).

inform_of_extension_with_reasons(Period, Citation) :-
    atom(Period),
    compound(Citation).

inform_of_reasons_and_remedies(Period, Citation) :-
    atom(Period),
    compound(Citation).

communicate_to_each_recipient(Citation) :-
    compound(Citation).

inform_data_subject_of_recipients(Citation) :-
    compound(Citation).

recipient_notification_excused(Citation) :-
    compound(Citation).

recipient_notification_not_applicable(Citation) :-
    compound(Citation).

test(first_period_moves_from_sunday_to_monday) :-
    response_deadline(date(2026, 10, 29), first_period, date(2026, 11, 30)).
test(short_month_end_on_saturday_moves_to_monday) :-
    response_deadline(date(2026, 1, 31), first_period, date(2026, 3, 2)).
test(leap_year_february_end) :-
    response_deadline(date(2028, 1, 31), first_period, date(2028, 2, 29)).
test(year_carry_and_sunday_shift) :-
    response_deadline(date(2026, 12, 31), first_period, date(2027, 2, 1)).
test(extended_period_counts_three_months_from_receipt) :-
    response_deadline(date(2026, 1, 31), extended_period, date(2026, 4, 30)).
test(extended_period_sunday_shift) :-
    response_deadline(date(2026, 11, 30), extended_period, date(2027, 3, 1)).
test(attested_public_holiday_moves_the_deadline) :-
    request_response_deadline([attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(public_holidays, attested([date(2026, 11, 30)], attestation(by, at, reason, none)))], Deadline),
    Deadline == date(2026, 12, 1).
test(access_request_owes_the_response_within_the_first_period) :-
    findall(Duties, response_duties([attribute(request_type, access)], Duties), AllDuties),
    AllDuties == [[respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]].
test(access_request_needs_no_recipient_notification) :-
    recipient_notification([attribute(request_type, access)], Duties),
    Duties == [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))].
test(rectification_with_known_recipients) :-
    recipient_notification([attribute(request_type, rectification), attribute(personal_data_inaccurate, true), attribute(personal_data_disclosed_to_recipients, true), attribute(recipient_notification_impossible_or_disproportionate_effort, false), attribute(data_subject_asks_who_the_recipients_are, true)], Duties),
    Duties == [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19)), inform_data_subject_of_recipients(cite(eu_reg_2016_679_art_19))].
test(erasure_exception_for_legal_claims_refuses) :-
    response_duties([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(processing_necessary_for_legal_claims, true)], Duties),
    Duties == [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))].
test(erasure_exception_is_need_not_comply) :-
    decide_gdpr_data_subject_rights_response_duties([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(processing_necessary_for_legal_claims, true)], gdpr_data_subject_rights_response_duties_verdict(need_not_comply, _)).
test(unconfirmed_identity_suspends) :-
    response_duties([attribute(request_type, access), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)], Duties),
    Duties == suspended(art12_6_identity_not_confirmed).
test(missing_rectification_grounds_are_named) :-
    response_duties([attribute(request_type, rectification)], Duties),
    Duties == indeterminate([personal_data_inaccurate, personal_data_incomplete_in_light_of_purposes]).
test(manifestly_excessive_without_request_type_still_refuses) :-
    response_duties([attribute(request_manifestly_unfounded_or_excessive, true)], Duties),
    Duties == [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))].
test(wrong_request_type_is_an_input_problem) :-
    response_duties([attribute(request_type, banana)], Duties),
    Duties == input_problems([wrong_type(request_type)]).
test(one_solution_per_query) :-
    findall(Deadline, request_response_deadline([attribute(request_type, erasure)], Deadline), Deadlines),
    length(Deadlines, 1).
test(direct_marketing_objection_has_no_exception) :-
    response_duties([attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true), attribute(processing_necessary_for_legal_claims, true)], Duties),
    Duties == [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))].

test(extended_period_is_not_the_step_by_step_date, fail) :-
    response_deadline(date(2026, 1, 31), extended_period, date(2026, 4, 28)).
test(erasure_exception_is_not_must_comply, fail) :-
    decide_gdpr_data_subject_rights_response_duties([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(processing_necessary_for_legal_claims, true)], gdpr_data_subject_rights_response_duties_verdict(must_comply, _)).
