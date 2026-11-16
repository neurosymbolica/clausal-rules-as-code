% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_request_exception, [decide_request_exception/2, request_exception_status/2, request_exception_checklist/2, request_exception_decision_resolvable/1, request_exception_status_values/1, request_decision/2, request_exception/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(library(reif), [memberd_t/3]).

request_exception_status_values([art17_3_a, art17_3_b, art17_3_c, art17_3_d, art17_3_e, art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction, none]).

in_scope_request_type(access).
in_scope_request_type(rectification).
in_scope_request_type(erasure).
in_scope_request_type(restriction).

out_of_scope_request_type(portability).
out_of_scope_request_type(objection).
out_of_scope_request_type(automated_decision).

contract_key_order([request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays]).

right_citation(access, cite(eu_reg_2016_679_art_15_1)).
right_citation(rectification, cite(eu_reg_2016_679_art_16)).
right_citation(erasure, cite(eu_reg_2016_679_art_17_1)).
right_citation(restriction, cite(eu_reg_2016_679_art_18_1)).

basis_citation(art15_1, cite(eu_reg_2016_679_art_15_1)).
basis_citation(art16_inaccurate_data, cite(eu_reg_2016_679_art_16)).
basis_citation(art16_incomplete_data, cite(eu_reg_2016_679_art_16)).
basis_citation(art17_1_a, cite(eu_reg_2016_679_art_17_1_a)).
basis_citation(art17_1_b, cite(eu_reg_2016_679_art_17_1_b)).
basis_citation(art17_1_c, cite(eu_reg_2016_679_art_17_1_c)).
basis_citation(art17_1_d, cite(eu_reg_2016_679_art_17_1_d)).
basis_citation(art17_1_e, cite(eu_reg_2016_679_art_17_1_e)).
basis_citation(art17_1_f, cite(eu_reg_2016_679_art_17_1_f)).
basis_citation(art18_1_a, cite(eu_reg_2016_679_art_18_1_a)).
basis_citation(art18_1_b, cite(eu_reg_2016_679_art_18_1_b)).
basis_citation(art18_1_c, cite(eu_reg_2016_679_art_18_1_c)).
basis_citation(art18_1_d, cite(eu_reg_2016_679_art_18_1_d)).

exception_citation(art17_3_a, cite(eu_reg_2016_679_art_17_3_a)).
exception_citation(art17_3_b, cite(eu_reg_2016_679_art_17_3_b)).
exception_citation(art17_3_c, cite(eu_reg_2016_679_art_17_3_c)).
exception_citation(art17_3_d, cite(eu_reg_2016_679_art_17_3_d)).
exception_citation(art17_3_e, cite(eu_reg_2016_679_art_17_3_e)).
exception_citation(art12_5_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)).
exception_citation(art12_2_unable_to_identify, cite(eu_reg_2016_679_art_12_2)).
exception_citation(art23_legislative_restriction, cite(eu_reg_2016_679_art_23_1)).

erasure_specific_exception(art17_3_a).
erasure_specific_exception(art17_3_b).
erasure_specific_exception(art17_3_c).
erasure_specific_exception(art17_3_d).
erasure_specific_exception(art17_3_e).

referral_row(identity_doubts_reasonable, any_request_type, reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)).
referral_row(request_manifestly_unfounded_or_excessive, any_request_type, request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)).
referral_row(rectification_incomplete_data, rectification, personal_data_incomplete_in_light_of_purposes, cite(eu_reg_2016_679_art_16)).
referral_row(erasure_no_longer_necessary, erasure, data_no_longer_necessary_for_purposes, cite(eu_reg_2016_679_art_17_1_a)).
referral_row(erasure_overriding_legitimate_grounds, erasure, overriding_legitimate_grounds_exist, cite(eu_reg_2016_679_art_17_1_c)).
referral_row(erasure_unlawful_processing, erasure, personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_17_1_d)).
referral_row(erasure_exception_freedom_of_expression, erasure, processing_necessary_for_freedom_of_expression_and_information, cite(eu_reg_2016_679_art_17_3_a)).
referral_row(erasure_exception_public_task, erasure, processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_17_3_b)).
referral_row(erasure_exception_public_health, erasure, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, cite(eu_reg_2016_679_art_17_3_c)).
referral_row(erasure_exception_archiving_research_statistics, erasure, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, cite(eu_reg_2016_679_art_17_3_d)).
referral_row(erasure_exception_impossible_or_seriously_impair, erasure, erasure_would_render_impossible_or_seriously_impair_processing_objectives, cite(eu_reg_2016_679_art_17_3_d)).
referral_row(erasure_exception_legal_claims, erasure, processing_necessary_for_legal_claims, cite(eu_reg_2016_679_art_17_3_e)).
referral_row(restriction_unlawful_processing, restriction, personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_18_1_b)).
referral_row(restriction_controller_no_longer_needs_data, restriction, controller_no_longer_needs_data_for_processing_purposes, cite(eu_reg_2016_679_art_18_1_c)).

outside_fact_row(erasure_required_by_union_or_member_state_law, cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)).
outside_fact_row(processing_required_by_union_or_member_state_law, cite(eu_reg_2016_679_art_17_3_b), cite(union_or_member_state_law_requiring_processing)).
outside_fact_row(legislative_restriction_applies_to_the_right, cite(eu_reg_2016_679_art_23_1), cite(union_or_member_state_law_restricting_the_right)).

profile_reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
profile_reading(Profile, Key, present(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

key_reading_value(required, absent, Key, v(open, [Key], [], [], [])).
key_reading_value(defeater, absent, _, v(unmet, [], [], [], [])).
key_reading_value(_, present(true), _, v(met, [], [], [], [])).
key_reading_value(_, present(false), _, v(unmet, [], [], [], [])).
key_reading_value(_, present(unsure), Key, v(open, [], [], [Key], [])).

outside_reading_value(enabling, absent, Key, v(open, [], [Key], [], [])).
outside_reading_value(blocking, absent, _, v(unmet, [], [], [], [])).
outside_reading_value(_, present(attested(true, _)), _, v(met, [], [], [], [])).
outside_reading_value(_, present(attested(false, _)), _, v(unmet, [], [], [], [])).

crisp_limb(Mode, Profile, Key, Value) :-
    profile_reading(Profile, Key, Reading),
    key_reading_value(Mode, Reading, Key, Value).

judgement_limb(Mode, Profile, Key, v(Status, Missing, Outside, Unsure, [Key])) :-
    profile_reading(Profile, Key, Reading),
    key_reading_value(Mode, Reading, Key, v(Status, Missing, Outside, Unsure, _)).

outside_limb(Direction, Profile, Key, Value) :-
    profile_reading(Profile, Key, Reading),
    outside_reading_value(Direction, Reading, Key, Value).

kleene_and(met, met, met).
kleene_and(met, unmet, unmet).
kleene_and(met, open, open).
kleene_and(unmet, met, unmet).
kleene_and(unmet, unmet, unmet).
kleene_and(unmet, open, unmet).
kleene_and(open, met, open).
kleene_and(open, unmet, unmet).
kleene_and(open, open, open).

kleene_or(met, met, met).
kleene_or(met, unmet, met).
kleene_or(met, open, met).
kleene_or(unmet, met, met).
kleene_or(unmet, unmet, unmet).
kleene_or(unmet, open, open).
kleene_or(open, met, met).
kleene_or(open, unmet, open).
kleene_or(open, open, open).

kleene_not(met, unmet).
kleene_not(unmet, met).
kleene_not(open, open).

connective_status(and, LeftStatus, RightStatus, Status) :-
    kleene_and(LeftStatus, RightStatus, Status).
connective_status(or, LeftStatus, RightStatus, Status) :-
    kleene_or(LeftStatus, RightStatus, Status).

connect(Connective, v(LeftStatus, LeftMissing, LeftOutside, LeftUnsure, LeftReads), v(RightStatus, RightMissing, RightOutside, RightUnsure, RightReads), v(Status, Missing, Outside, Unsure, Reads)) :-
    connective_status(Connective, LeftStatus, RightStatus, Status),
    append(LeftReads, RightReads, Reads),
    open_lists(Status, LeftMissing - RightMissing, LeftOutside - RightOutside, LeftUnsure - RightUnsure, Missing, Outside, Unsure).

open_lists(met, _, _, _, [], [], []).
open_lists(unmet, _, _, _, [], [], []).
open_lists(open, LeftMissing - RightMissing, LeftOutside - RightOutside, LeftUnsure - RightUnsure, Missing, Outside, Unsure) :-
    append(LeftMissing, RightMissing, Missing),
    append(LeftOutside, RightOutside, Outside),
    append(LeftUnsure, RightUnsure, Unsure).

and_values([], v(met, [], [], [], [])).
and_values([Value|Values], Combined) :-
    and_values(Values, RestValue),
    connect(and, Value, RestValue, Combined).

or_values([], v(unmet, [], [], [], [])).
or_values([Value|Values], Combined) :-
    or_values(Values, RestValue),
    connect(or, Value, RestValue, Combined).

negate(v(Status, Missing, Outside, Unsure, Reads), v(Negated, Missing, Outside, Unsure, Reads)) :-
    kleene_not(Status, Negated).

engagement_points(access, _, [art15_1 - v(met, [], [], [], [])]) :-
    implements(eu_reg_2016_679_art_15_1).
engagement_points(rectification, Profile, [art16_inaccurate_data - Inaccurate, art16_incomplete_data - Incomplete]) :-
    implements(eu_reg_2016_679_art_16),
    crisp_limb(required, Profile, personal_data_inaccurate, Inaccurate),
    judgement_limb(required, Profile, personal_data_incomplete_in_light_of_purposes, Incomplete).
engagement_points(erasure, Profile, [art17_1_a - PointA, art17_1_b - PointB, art17_1_c - PointC, art17_1_d - PointD, art17_1_e - PointE, art17_1_f - PointF]) :-
    implements(eu_reg_2016_679_art_17_1),
    erasure_point(Profile, art17_1_a, PointA),
    erasure_point(Profile, art17_1_b, PointB),
    erasure_point(Profile, art17_1_c, PointC),
    erasure_point(Profile, art17_1_d, PointD),
    erasure_point(Profile, art17_1_e, PointE),
    erasure_point(Profile, art17_1_f, PointF).
engagement_points(restriction, Profile, [art18_1_a - PointA, art18_1_b - PointB, art18_1_c - PointC, art18_1_d - PointD]) :-
    implements(eu_reg_2016_679_art_18_1),
    restriction_point(Profile, art18_1_a, PointA),
    restriction_point(Profile, art18_1_b, PointB),
    restriction_point(Profile, art18_1_c, PointC),
    restriction_point(Profile, art18_1_d, PointD).

erasure_point(Profile, art17_1_a, Value) :-
    implements(eu_reg_2016_679_art_17_1_a),
    judgement_limb(required, Profile, data_no_longer_necessary_for_purposes, Value).
erasure_point(Profile, art17_1_b, Value) :-
    implements(eu_reg_2016_679_art_17_1_b),
    crisp_limb(required, Profile, consent_is_the_basis_of_processing, ConsentBasis),
    crisp_limb(required, Profile, consent_withdrawn, Withdrawn),
    crisp_limb(required, Profile, other_legal_ground_for_processing_exists, OtherGround),
    negate(OtherGround, NoOtherGround),
    and_values([ConsentBasis, Withdrawn, NoOtherGround], Value).
erasure_point(Profile, art17_1_c, Value) :-
    implements(eu_reg_2016_679_art_17_1_c),
    crisp_limb(required, Profile, objection_under_art21_1_made, GeneralObjection),
    judgement_limb(required, Profile, overriding_legitimate_grounds_exist, Overriding),
    negate(Overriding, NoOverriding),
    and_values([GeneralObjection, NoOverriding], GeneralObjectionLimb),
    crisp_limb(required, Profile, objection_under_art21_2_made, MarketingObjection),
    or_values([GeneralObjectionLimb, MarketingObjection], Value).
erasure_point(Profile, art17_1_d, Value) :-
    implements(eu_reg_2016_679_art_17_1_d),
    judgement_limb(required, Profile, personal_data_unlawfully_processed, Value).
erasure_point(Profile, art17_1_e, Value) :-
    implements(eu_reg_2016_679_art_17_1_e),
    outside_limb(enabling, Profile, erasure_required_by_union_or_member_state_law, Value).
erasure_point(Profile, art17_1_f, Value) :-
    implements(eu_reg_2016_679_art_17_1_f),
    crisp_limb(required, Profile, collected_in_relation_to_information_society_services_offer, Value).

restriction_point(Profile, art18_1_a, Value) :-
    implements(eu_reg_2016_679_art_18_1_a),
    crisp_limb(required, Profile, accuracy_contested_by_data_subject, Value).
restriction_point(Profile, art18_1_b, Value) :-
    implements(eu_reg_2016_679_art_18_1_b),
    judgement_limb(required, Profile, personal_data_unlawfully_processed, Unlawful),
    crisp_limb(required, Profile, data_subject_opposes_erasure, Opposes),
    and_values([Unlawful, Opposes], Value).
restriction_point(Profile, art18_1_c, Value) :-
    implements(eu_reg_2016_679_art_18_1_c),
    judgement_limb(required, Profile, controller_no_longer_needs_data_for_processing_purposes, NoLongerNeeded),
    crisp_limb(required, Profile, data_required_by_data_subject_for_legal_claims, RequiredForClaims),
    and_values([NoLongerNeeded, RequiredForClaims], Value).
restriction_point(Profile, art18_1_d, Value) :-
    implements(eu_reg_2016_679_art_18_1_d),
    crisp_limb(required, Profile, objection_under_art21_1_made, Objection),
    crisp_limb(required, Profile, verification_of_overriding_grounds_pending, Pending),
    and_values([Objection, Pending], Value).

first_met_point([], none).
first_met_point([Basis - v(met, _, _, _, _)|_], Basis).
first_met_point([_ - v(unmet, _, _, _, _)|Points], Basis) :-
    first_met_point(Points, Basis).
first_met_point([_ - v(open, _, _, _, _)|Points], Basis) :-
    first_met_point(Points, Basis).

request_exceptions(Type, Profile, Exceptions) :-
    specific_exceptions(Type, Profile, Specific),
    common_exceptions(Profile, Common),
    append(Specific, Common, Exceptions).

specific_exceptions(access, _, []).
specific_exceptions(rectification, _, []).
specific_exceptions(restriction, _, []).
specific_exceptions(erasure, Profile, [art17_3_a - PointA, art17_3_b - PointB, art17_3_c - PointC, art17_3_d - PointD, art17_3_e - PointE]) :-
    implements(eu_reg_2016_679_art_17_3),
    erasure_exception(Profile, art17_3_a, PointA),
    erasure_exception(Profile, art17_3_b, PointB),
    erasure_exception(Profile, art17_3_c, PointC),
    erasure_exception(Profile, art17_3_d, PointD),
    erasure_exception(Profile, art17_3_e, PointE).

erasure_exception(Profile, art17_3_a, Value) :-
    implements(eu_reg_2016_679_art_17_3_a),
    judgement_limb(defeater, Profile, processing_necessary_for_freedom_of_expression_and_information, Value).
erasure_exception(Profile, art17_3_b, Value) :-
    implements(eu_reg_2016_679_art_17_3_b),
    outside_limb(blocking, Profile, processing_required_by_union_or_member_state_law, LegalObligation),
    judgement_limb(defeater, Profile, processing_necessary_for_public_task_or_official_authority, PublicTask),
    or_values([LegalObligation, PublicTask], Value).
erasure_exception(Profile, art17_3_c, Value) :-
    implements(eu_reg_2016_679_art_17_3_c),
    judgement_limb(defeater, Profile, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, Value).
erasure_exception(Profile, art17_3_d, Value) :-
    implements(eu_reg_2016_679_art_17_3_d),
    judgement_limb(defeater, Profile, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, Archiving),
    judgement_limb(defeater, Profile, erasure_would_render_impossible_or_seriously_impair_processing_objectives, Impairment),
    and_values([Archiving, Impairment], Value).
erasure_exception(Profile, art17_3_e, Value) :-
    implements(eu_reg_2016_679_art_17_3_e),
    judgement_limb(defeater, Profile, processing_necessary_for_legal_claims, Value).

common_exceptions(Profile, [art12_5_manifestly_unfounded_or_excessive - Manifest, art12_2_unable_to_identify - Unidentified, art23_legislative_restriction - Restricted]) :-
    common_exception(Profile, art12_5_manifestly_unfounded_or_excessive, Manifest),
    common_exception(Profile, art12_2_unable_to_identify, Unidentified),
    common_exception(Profile, art23_legislative_restriction, Restricted).

common_exception(Profile, art12_5_manifestly_unfounded_or_excessive, Value) :-
    implements(eu_reg_2016_679_art_12_5),
    judgement_limb(defeater, Profile, request_manifestly_unfounded_or_excessive, Value).
common_exception(Profile, art12_2_unable_to_identify, Value) :-
    implements(eu_reg_2016_679_art_12_2),
    crisp_limb(defeater, Profile, controller_demonstrates_unable_to_identify_data_subject, Value).
common_exception(Profile, art23_legislative_restriction, Value) :-
    implements(eu_reg_2016_679_art_23_1),
    outside_limb(blocking, Profile, legislative_restriction_applies_to_the_right, Value).

first_met_exception([], none_met).
first_met_exception([Exception - v(met, _, _, _, _)|_], met(Exception)).
first_met_exception([_ - v(unmet, _, _, _, _)|Exceptions], Choice) :-
    first_met_exception(Exceptions, Choice).
first_met_exception([_ - v(open, _, _, _, _)|Exceptions], Choice) :-
    first_met_exception(Exceptions, Choice).

identity_suspension(Profile, Value) :-
    implements(eu_reg_2016_679_art_12_6),
    judgement_limb(defeater, Profile, reasonable_doubts_about_identity, Doubts),
    crisp_limb(required, Profile, identity_confirmed, Confirmed),
    negate(Confirmed, NotConfirmed),
    and_values([Doubts, NotConfirmed], Value).

request_evaluation(Profile, Type, evaluation(Type, Engagement, Basis, Suspension, Exceptions)) :-
    engagement_points(Type, Profile, Points),
    pairs_values(Points, PointValues),
    or_values(PointValues, Engagement),
    first_met_point(Points, Basis),
    identity_suspension(Profile, Suspension),
    request_exceptions(Type, Profile, Exceptions).

out_of_scope_evaluation(Profile, Type, evaluation(Type, v(open, [], [], [], []), none, Suspension, Exceptions)) :-
    identity_suspension(Profile, Suspension),
    common_exceptions(Profile, Exceptions).

engaged_or_open(met).
engaged_or_open(open).

suspension_not_met(unmet).
suspension_not_met(open).

evaluation_stage(evaluation(_, v(unmet, _, _, _, _), _, _, _), not_engaged).
evaluation_stage(evaluation(_, Engagement, _, Suspension, Exceptions), Stage) :-
    Engagement = v(EngagementStatus, _, _, _, _),
    engaged_or_open(EngagementStatus),
    first_met_exception(Exceptions, Choice),
    choice_stage(Choice, Engagement, Suspension, Exceptions, Stage).

choice_stage(met(Exception), _, _, _, excepted(Exception)).
choice_stage(none_met, _, v(met, _, _, _, _), _, suspended).
choice_stage(none_met, Engagement, Suspension, Exceptions, Stage) :-
    Suspension = v(SuspensionStatus, _, _, _, _),
    suspension_not_met(SuspensionStatus),
    pairs_values(Exceptions, ExceptionValues),
    open_values([Engagement, Suspension|ExceptionValues], OpenValues),
    open_stage(OpenValues, Stage).

open_values([], []).
open_values([v(open, Missing, Outside, Unsure, Reads)|Values], [v(open, Missing, Outside, Unsure, Reads)|OpenValues]) :-
    open_values(Values, OpenValues).
open_values([v(met, _, _, _, _)|Values], OpenValues) :-
    open_values(Values, OpenValues).
open_values([v(unmet, _, _, _, _)|Values], OpenValues) :-
    open_values(Values, OpenValues).

open_stage([], must_comply).
open_stage([Value|Values], open([Value|Values])).

stage_verdict(not_engaged, evaluation(rectification, _, _, _, _), _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_16)])) :-
    implements(eu_reg_2016_679_art_16).
stage_verdict(not_engaged, evaluation(erasure, _, _, _, _), _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_17_1)])) :-
    implements(eu_reg_2016_679_art_17_1).
stage_verdict(not_engaged, evaluation(restriction, _, _, _, _), _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_18_1)])) :-
    implements(eu_reg_2016_679_art_18_1).
stage_verdict(excepted(Exception), evaluation(_, _, Basis, _, _), _, gdpr_data_subject_request_verdict(need_not_comply, Basis, Exception, [], [Citation])) :-
    implements(eu_reg_2016_679_art_17_3),
    erasure_specific_exception(Exception),
    exception_citation(Exception, Citation).
stage_verdict(excepted(art12_5_manifestly_unfounded_or_excessive), evaluation(_, _, Basis, _, _), _, gdpr_data_subject_request_verdict(need_not_comply, Basis, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [cite(eu_reg_2016_679_art_12_5), cite(eu_reg_2016_679_art_12_5_a)])) :-
    implements(eu_reg_2016_679_art_12_5_b),
    implements(eu_reg_2016_679_art_12_5_a).
stage_verdict(excepted(art12_2_unable_to_identify), evaluation(_, _, Basis, _, _), _, gdpr_data_subject_request_verdict(need_not_comply, Basis, art12_2_unable_to_identify, [], [cite(eu_reg_2016_679_art_12_2)])) :-
    implements(eu_reg_2016_679_art_12_2).
stage_verdict(excepted(art23_legislative_restriction), evaluation(_, _, Basis, _, _), _, gdpr_data_subject_request_verdict(need_not_comply, Basis, art23_legislative_restriction, [], [cite(eu_reg_2016_679_art_23_1)])) :-
    implements(eu_reg_2016_679_art_23_1).
stage_verdict(suspended, _, _, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])) :-
    implements(eu_reg_2016_679_art_12_6).
stage_verdict(open(OpenValues), evaluation(Type, _, _, _, _), Profile, Verdict) :-
    open_summary(OpenValues, Missing, Outside, Unsure, Reads),
    open_verdict(Missing, Outside, Unsure, Reads, Type, Profile, Verdict).
stage_verdict(must_comply, evaluation(access, _, Basis, _, _), _, gdpr_data_subject_request_verdict(must_comply, Basis, none, [], [Citation])) :-
    implements(eu_reg_2016_679_art_15_1),
    basis_citation(Basis, Citation).
stage_verdict(must_comply, evaluation(rectification, _, Basis, _, _), _, gdpr_data_subject_request_verdict(must_comply, Basis, none, [], [Citation])) :-
    implements(eu_reg_2016_679_art_16),
    basis_citation(Basis, Citation).
stage_verdict(must_comply, evaluation(erasure, _, Basis, _, _), _, gdpr_data_subject_request_verdict(must_comply, Basis, none, [], [Citation])) :-
    implements(eu_reg_2016_679_art_17_1),
    basis_citation(Basis, Citation).
stage_verdict(must_comply, evaluation(restriction, _, Basis, _, _), _, gdpr_data_subject_request_verdict(must_comply, Basis, none, [], [Citation])) :-
    implements(eu_reg_2016_679_art_18_1),
    basis_citation(Basis, Citation).

open_verdict([MissingKey|MissingKeys], _, _, _, _, _, gdpr_data_subject_request_verdict(indeterminate([MissingKey|MissingKeys]), none, none, [], [])).
open_verdict([], [OutsideKey|OutsideKeys], _, Reads, Type, Profile, gdpr_data_subject_request_verdict(needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on(Pairs)]), none, none, [], [])) :-
    implements(eu_reg_2016_679_art_17_1_e),
    outside_fact_row(OutsideKey, Citation, Target),
    relied_pairs(Type, Reads, [OutsideKey|OutsideKeys], Profile, Pairs).
open_verdict([], [], [Input|_], Reads, Type, Profile, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]), none, none, [], [])) :-
    referral_citation(Type, Input, Citation),
    relied_pairs(Type, Reads, [], Profile, Pairs).
open_verdict([], [], [], Reads, Type, Profile, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(request_type, cite(eu_reg_2016_679_art_12_6)), [inputs_relied_on(Pairs)]), none, none, [], [])) :-
    implements(eu_reg_2016_679_art_12_6),
    out_of_scope_request_type(Type),
    relied_pairs(Type, Reads, [], Profile, Pairs).

referral_citation(_, Input, Citation) :-
    referral_row(_, any_request_type, Input, Citation).
referral_citation(Type, Input, Citation) :-
    referral_row(_, Type, Input, Citation).

open_summary(OpenValues, Missing, Outside, Unsure, Reads) :-
    findall(MissingKey, (member(v(_, MissingKeys, _, _, _), OpenValues), member(MissingKey, MissingKeys)), MissingFound),
    findall(OutsideKey, (member(v(_, _, OutsideKeys, _, _), OpenValues), member(OutsideKey, OutsideKeys)), OutsideFound),
    findall(UnsureKey, (member(v(_, _, _, UnsureKeys, _), OpenValues), member(UnsureKey, UnsureKeys)), UnsureFound),
    findall(ReadKey, (member(v(_, _, _, _, ReadKeys), OpenValues), member(ReadKey, ReadKeys)), ReadsFound),
    contract_order(MissingFound, Missing),
    contract_order(OutsideFound, Outside),
    contract_order(UnsureFound, Unsure),
    contract_order(ReadsFound, Reads).

contract_order(Keys, Ordered) :-
    contract_key_order(Order),
    findall(Key, (member(Key, Order), memberd_t(Key, Keys, true)), Ordered).

relied_pairs(Type, Reads, Outside, Profile, [request_type - Type|Pairs]) :-
    present_pairs(Reads, Profile, JudgementPairs),
    absent_pairs(Outside, AbsentPairs),
    append(JudgementPairs, AbsentPairs, Pairs).

present_pairs([], _, []).
present_pairs([Key|Keys], Profile, Pairs) :-
    profile_reading(Profile, Key, Reading),
    reading_pairs(Reading, Key, KeyPairs),
    present_pairs(Keys, Profile, LaterPairs),
    append(KeyPairs, LaterPairs, Pairs).

reading_pairs(absent, _, []).
reading_pairs(present(Value), Key, [Key - Value]).

absent_pairs([], []).
absent_pairs([Key|Keys], [Key - absent|Pairs]) :-
    absent_pairs(Keys, Pairs).

decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(input_problems([Problem|Problems]), none, none, [], [])) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems(Profile, [Problem|Problems]).
decide_data_subject_request(Profile, Verdict) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems(Profile, []),
    profile_reading(Profile, request_type, Reading),
    request_type_verdict(Reading, Profile, Verdict).

request_type_verdict(absent, _, gdpr_data_subject_request_verdict(indeterminate([request_type]), none, none, [], [])).
request_type_verdict(present(Type), Profile, Verdict) :-
    in_scope_request_type(Type),
    request_evaluation(Profile, Type, Evaluation),
    evaluation_stage(Evaluation, Stage),
    stage_verdict(Stage, Evaluation, Profile, Verdict).
request_type_verdict(present(Type), Profile, Verdict) :-
    out_of_scope_request_type(Type),
    out_of_scope_evaluation(Profile, Type, Evaluation),
    evaluation_stage(Evaluation, Stage),
    stage_verdict(Stage, Evaluation, Profile, Verdict).

request_decision(Profile, Comply) :-
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(Comply, _, _, _, _)).

request_exception(Profile, Exception) :-
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(_, _, Exception, _, _)).

decide_request_exception(Profile, request_exception_verdict(Comply, Citations)) :-
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(Comply, _, _, _, Citations)).

request_exception_status(Profile, Status) :-
    decide_request_exception(Profile, request_exception_verdict(Status, _Citations)).

request_exception_checklist(Profile, [EngagementItem, SuspensionItem|ExceptionItems]) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems(Profile, []),
    profile_reading(Profile, request_type, present(Type)),
    in_scope_request_type(Type),
    request_evaluation(Profile, Type, evaluation(Type, Engagement, _, Suspension, Exceptions)),
    right_citation(Type, RightCitation),
    limb_item(right_engaged, Engagement, RightCitation, EngagementItem),
    limb_item(identity_suspension, Suspension, cite(eu_reg_2016_679_art_12_6), SuspensionItem),
    exception_items(Exceptions, ExceptionItems).

limb_item(Identifier, v(met, _, _, _, _), Citation, item(Identifier, met, Citation)).
limb_item(Identifier, v(unmet, _, _, _, _), Citation, item(Identifier, unmet(Identifier), Citation)).
limb_item(Identifier, v(open, Missing, Outside, Unsure, _), Citation, item(Identifier, unknown(Keys), Citation)) :-
    append(Missing, Outside, MissingAndOutside),
    append(MissingAndOutside, Unsure, OpenKeys),
    contract_order(OpenKeys, Keys).

exception_items([], []).
exception_items([Exception - Value|Exceptions], [Item|Items]) :-
    exception_citation(Exception, Citation),
    limb_item(Exception, Value, Citation, Item),
    exception_items(Exceptions, Items).

request_exception_decision_resolvable(Profile) :-
    decide_request_exception(Profile, _Verdict).

test(access_alone_must_comply_once) :-
    findall(Comply, request_decision([attribute(request_type, access)], Comply), Answers),
    Answers == [must_comply].
test(access_alone_has_no_exception) :-
    findall(Exception, request_exception([attribute(request_type, access)], Exception), Answers),
    Answers == [none].
test(manifestly_excessive_access_gives_the_fee_condition) :-
    decide_data_subject_request([attribute(request_type, access), attribute(request_manifestly_unfounded_or_excessive, true)], gdpr_data_subject_request_verdict(need_not_comply, art15_1, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], _)).
test(manifestly_excessive_access_exception_once) :-
    findall(Exception, request_exception([attribute(request_type, access), attribute(request_manifestly_unfounded_or_excessive, true)], Exception), Answers),
    Answers == [art12_5_manifestly_unfounded_or_excessive].
test(rectification_not_engaged) :-
    findall(Comply, request_decision([attribute(request_type, rectification), attribute(personal_data_inaccurate, false), attribute(personal_data_incomplete_in_light_of_purposes, false)], Comply), Answers),
    Answers == [need_not_comply].
test(rectification_inaccurate_must_comply) :-
    decide_data_subject_request([attribute(request_type, rectification), attribute(personal_data_inaccurate, true)], gdpr_data_subject_request_verdict(must_comply, art16_inaccurate_data, none, [], _)).
test(bare_erasure_lists_every_missing_key) :-
    request_decision([attribute(request_type, erasure)], indeterminate([consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed])).
test(erasure_freedom_of_expression_exception) :-
    decide_data_subject_request([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(processing_necessary_for_freedom_of_expression_and_information, true)], gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art17_3_a, [], _)).
test(erasure_without_exception_must_comply) :-
    findall(Comply, request_decision([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true)], Comply), Answers),
    Answers == [must_comply].
test(erasure_waiting_on_an_unattested_law_refers) :-
    findall(Comply, request_decision([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, false), attribute(consent_is_the_basis_of_processing, false), attribute(consent_withdrawn, false), attribute(other_legal_ground_for_processing_exists, false), attribute(objection_under_art21_1_made, false), attribute(objection_under_art21_2_made, false), attribute(personal_data_unlawfully_processed, false), attribute(collected_in_relation_to_information_society_services_offer, false)], Comply), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)), [resolution(cite(union_or_member_state_law_requiring_erasure), not_attempted), inputs_relied_on([request_type - erasure, data_no_longer_necessary_for_purposes - false, personal_data_unlawfully_processed - false, erasure_required_by_union_or_member_state_law - absent])])].
test(erasure_attested_law_false_not_engaged) :-
    request_decision([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, false), attribute(consent_is_the_basis_of_processing, false), attribute(consent_withdrawn, false), attribute(other_legal_ground_for_processing_exists, false), attribute(objection_under_art21_1_made, false), attribute(objection_under_art21_2_made, false), attribute(personal_data_unlawfully_processed, false), attribute(collected_in_relation_to_information_society_services_offer, false), attribute(erasure_required_by_union_or_member_state_law, attested(false, attestation(by, at, reason, none)))], need_not_comply).
test(unconfirmed_identity_suspends) :-
    findall(Comply, request_decision([attribute(request_type, access), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)], Comply), Answers),
    Answers == [suspended(art12_6_identity_not_confirmed)].
test(doubts_without_confirmation_key_are_missing) :-
    request_decision([attribute(request_type, access), attribute(reasonable_doubts_about_identity, true)], indeterminate([identity_confirmed])).
test(unsure_doubts_go_to_a_lawyer) :-
    request_decision([attribute(request_type, access), attribute(reasonable_doubts_about_identity, unsure), attribute(identity_confirmed, false)], needs_legal_review(open_textured(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)), [inputs_relied_on([request_type - access, reasonable_doubts_about_identity - unsure])])).
test(restriction_unsure_unlawfulness_cites_art18) :-
    request_decision([attribute(request_type, restriction), attribute(accuracy_contested_by_data_subject, false), attribute(personal_data_unlawfully_processed, unsure), attribute(data_subject_opposes_erasure, true), attribute(controller_no_longer_needs_data_for_processing_purposes, false), attribute(objection_under_art21_1_made, false)], needs_legal_review(open_textured(personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_18_1_b)), [inputs_relied_on([request_type - restriction, personal_data_unlawfully_processed - unsure, controller_no_longer_needs_data_for_processing_purposes - false])])).
test(an_unknown_key_is_an_input_problem) :-
    findall(Comply, request_decision([attribute(request_type, access), attribute(colour, blue)], Comply), Answers),
    Answers == [input_problems([unknown_key(colour)])].
test(an_input_problem_has_no_exception) :-
    request_exception([attribute(request_type, access), attribute(colour, blue)], none).
test(absent_request_type_is_indeterminate) :-
    request_decision([], indeterminate([request_type])).
test(an_out_of_scope_type_gets_one_non_final_answer) :-
    findall(Comply, request_decision([attribute(request_type, objection)], Comply), Answers),
    Answers == [needs_legal_review(open_textured(request_type, cite(eu_reg_2016_679_art_12_6)), [inputs_relied_on([request_type - objection])])].
test(an_out_of_scope_type_has_no_exception) :-
    findall(Exception, request_exception([attribute(request_type, portability)], Exception), Answers),
    Answers == [none].
test(an_out_of_scope_type_with_a_common_exception_is_relieved_once) :-
    findall(Exception, request_exception([attribute(request_type, portability), attribute(controller_demonstrates_unable_to_identify_data_subject, true)], Exception), Answers),
    Answers == [art12_2_unable_to_identify].
test(an_out_of_scope_type_names_only_absent_keys) :-
    request_decision([attribute(request_type, objection), attribute(reasonable_doubts_about_identity, true)], indeterminate([identity_confirmed])).
test(an_attested_legislative_restriction_relieves) :-
    request_exception([attribute(request_type, access), attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(by, at, reason, none)))], art23_legislative_restriction).
test(the_checklist_cites_each_row) :-
    request_exception_checklist([attribute(request_type, access)], [item(right_engaged, met, cite(eu_reg_2016_679_art_15_1)), item(identity_suspension, unmet(identity_suspension), cite(eu_reg_2016_679_art_12_6))|_]).

test(access_alone_is_not_need_not_comply, fail) :-
    request_decision([attribute(request_type, access)], need_not_comply).
test(an_out_of_scope_type_never_names_request_type_missing, fail) :-
    request_decision([attribute(request_type, objection)], indeterminate(_)).
test(an_out_of_scope_type_is_not_must_comply, fail) :-
    request_decision([attribute(request_type, automated_decision)], must_comply).
