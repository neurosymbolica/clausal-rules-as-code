% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_request_basis, [decide_data_subject_request/2, request_basis/2, decide_request_basis/2, request_basis_status/2, request_basis_checklist/2, request_basis_decision_resolvable/1, request_basis_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_kernel, [gdpr_data_subject_rights_access_rectification_restriction_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_citations, [implements/1]).

request_basis_status_values([art15_1, art16_inaccurate_data, art16_incomplete_data, art18_1_a, art18_1_b, art18_1_c, art18_1_d, none]).

key_order([identity_confirmed, personal_data_inaccurate, objection_under_art21_1_made, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, personal_data_unlawfully_processed, controller_no_longer_needs_data_for_processing_purposes]).

referral_citation(reasonable_doubts_about_identity, eu_reg_2016_679_art_12_6).
referral_citation(request_manifestly_unfounded_or_excessive, eu_reg_2016_679_art_12_5).
referral_citation(personal_data_incomplete_in_light_of_purposes, eu_reg_2016_679_art_16).
referral_citation(personal_data_unlawfully_processed, eu_reg_2016_679_art_18_1_b).
referral_citation(controller_no_longer_needs_data_for_processing_purposes, eu_reg_2016_679_art_18_1_c).

engagement_reads(access, []).
engagement_reads(rectification, [personal_data_incomplete_in_light_of_purposes]).
engagement_reads(restriction, [personal_data_unlawfully_processed, controller_no_longer_needs_data_for_processing_purposes]).

decide_data_subject_request(Profile, Verdict) :-
    gdpr_data_subject_rights_access_rectification_restriction_input_problems(Profile, Problems),
    decide_checked(Problems, Profile, Verdict).

decide_checked([Problem|Problems], _, gdpr_data_subject_request_verdict(input_problems([Problem|Problems]), none, none, [], [])).
decide_checked([], Profile, Verdict) :-
    key_value(Profile, request_type, Type),
    decide_by_type(Type, Profile, Verdict).

decide_by_type(absent, _, gdpr_data_subject_request_verdict(indeterminate([request_type]), none, none, [], [])).
decide_by_type(access, Profile, Verdict) :-
    decide_type(access, Profile, Verdict).
decide_by_type(rectification, Profile, Verdict) :-
    decide_type(rectification, Profile, Verdict).
decide_by_type(restriction, Profile, Verdict) :-
    decide_type(restriction, Profile, Verdict).
decide_by_type(erasure, _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).
decide_by_type(portability, _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).
decide_by_type(objection, _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).
decide_by_type(automated_decision, _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).

request_basis(Profile, Basis) :-
    gdpr_data_subject_rights_access_rectification_restriction_input_problems(Profile, Problems),
    basis_checked(Problems, Profile, Basis).

basis_checked([Problem|Problems], _, input_problems([Problem|Problems])).
basis_checked([], Profile, Basis) :-
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(_, Basis, _, _, _)).

decide_request_basis(Profile, request_basis_verdict(Basis, Citations)) :-
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(_, Basis, _, _, Citations)).

request_basis_status(Profile, Status) :-
    decide_request_basis(Profile, request_basis_verdict(Status, _Citations)).

request_basis_decision_resolvable(Profile) :-
    decide_data_subject_request(Profile, _Verdict).

decide_type(Type, Profile, Verdict) :-
    engagement(Type, Profile, Engagement, Basis),
    exception_status(art12_5_manifestly_unfounded_or_excessive, Profile, Unfounded),
    exception_status(art12_2_unable_to_identify, Profile, Unidentified),
    exception_status(art23_legislative_restriction, Profile, Restricted),
    first_exception(Unfounded, Unidentified, Restricted, Exception),
    suspension(Profile, Suspension),
    stage_engagement(Engagement, Basis, Exception, Suspension, context(Type, Profile), [Unfounded, Unidentified, Restricted], Verdict).

stage_engagement(unmet, _, _, _, context(Type, _), _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], Citations)) :-
    right_cites(Type, none, Citations).
stage_engagement(met, Basis, Exception, Suspension, Context, Exceptions, Verdict) :-
    stage_exception(Exception, Basis, met, Suspension, Context, Exceptions, Verdict).
stage_engagement(open(Missing, Unsure), _, Exception, Suspension, Context, Exceptions, Verdict) :-
    stage_exception(Exception, none, open(Missing, Unsure), Suspension, Context, Exceptions, Verdict).

stage_exception(none, Basis, Engagement, Suspension, Context, Exceptions, Verdict) :-
    stage_suspension(Suspension, Basis, Engagement, Context, Exceptions, Verdict).
stage_exception(Exception, Basis, _, _, context(Type, _), _, gdpr_data_subject_request_verdict(need_not_comply, Basis, Exception, Conditions, Citations)) :-
    dif(Exception, none),
    exception_conditions(Exception, Conditions),
    exception_citations(Type, Basis, Exception, Citations).

stage_suspension(met, _, _, _, _, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
stage_suspension(Suspension, Basis, Engagement, context(Type, Profile), [Unfounded, Unidentified, Restricted], Verdict) :-
    dif(Suspension, met),
    engagement_reads(Type, EngagementReads),
    collect_limbs([limb(Engagement, EngagementReads), limb(Suspension, [reasonable_doubts_about_identity]), limb(Unfounded, [request_manifestly_unfounded_or_excessive]), limb(Unidentified, []), limb(Restricted, [])], RawMissing, RawUnsure, RawReads),
    key_order(Order),
    in_order(Order, RawMissing, Missing),
    in_order(Order, RawUnsure, Unsure),
    in_order(Order, RawReads, Reads),
    open_verdict(Missing, Unsure, Reads, Basis, context(Type, Profile), Verdict).

open_verdict([Key|Keys], _, _, _, _, gdpr_data_subject_request_verdict(indeterminate([Key|Keys]), none, none, [], [])).
open_verdict([], [Key|_], Reads, _, context(Type, Profile), gdpr_data_subject_request_verdict(needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on([request_type - Type|Pairs])]), none, none, [], [])) :-
    referral_citation(Key, Citation),
    pairs_present(Reads, Profile, Pairs).
open_verdict([], [], _, Basis, context(Type, _), gdpr_data_subject_request_verdict(must_comply, Basis, none, [], Citations)) :-
    right_cites(Type, Basis, Citations).

collect_limbs([], [], [], []).
collect_limbs([limb(Status, Reads)|Limbs], Missing, Unsure, ReadKeys) :-
    status_keys(Status, StatusMissing, StatusUnsure, StatusReads, Reads),
    collect_limbs(Limbs, LaterMissing, LaterUnsure, LaterReads),
    append(StatusMissing, LaterMissing, Missing),
    append(StatusUnsure, LaterUnsure, Unsure),
    append(StatusReads, LaterReads, ReadKeys).

status_keys(met, [], [], [], _).
status_keys(unmet, [], [], [], _).
status_keys(open(Missing, Unsure), Missing, Unsure, Reads, Reads).

in_order([], _, []).
in_order([Key|Keys], Collected, [Key|Ordered]) :-
    memberd_t(Key, Collected, true),
    in_order(Keys, Collected, Ordered).
in_order([Key|Keys], Collected, Ordered) :-
    memberd_t(Key, Collected, false),
    in_order(Keys, Collected, Ordered).

pairs_present([], _, []).
pairs_present([Key|Keys], Profile, [Key - Value|Pairs]) :-
    profile_get(Profile, Key, Value),
    pairs_present(Keys, Profile, Pairs).
pairs_present([Key|Keys], Profile, Pairs) :-
    profile_lacks(Profile, Key),
    pairs_present(Keys, Profile, Pairs).

key_value(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_value(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).

required_status(Profile, Key, Status) :-
    key_value(Profile, Key, Value),
    required_value(Value, Key, Status).

required_value(absent, Key, open([Key], [])).
required_value(true, _, met).
required_value(false, _, unmet).
required_value(unsure, Key, open([], [Key])).

negated_value(absent, Key, open([Key], [])).
negated_value(true, _, unmet).
negated_value(false, _, met).
negated_value(unsure, Key, open([], [Key])).

defeater_value(absent, _, unmet).
defeater_value(true, _, met).
defeater_value(false, _, unmet).
defeater_value(unsure, Key, open([], [Key])).

outside_value(absent, unmet).
outside_value(attested(true, _), met).
outside_value(attested(false, _), unmet).

and2(unmet, _, unmet).
and2(met, Status, Status).
and2(open(_, _), unmet, unmet).
and2(open(Missing, Unsure), met, open(Missing, Unsure)).
and2(open(MissingOne, UnsureOne), open(MissingTwo, UnsureTwo), open(Missing, Unsure)) :-
    append(MissingOne, MissingTwo, Missing),
    append(UnsureOne, UnsureTwo, Unsure).

or_basis(met, BasisOne, _, _, met, BasisOne).
or_basis(unmet, _, Status, BasisTwo, Status, BasisTwo).
or_basis(open(_, _), _, met, BasisTwo, met, BasisTwo).
or_basis(open(Missing, Unsure), _, unmet, _, open(Missing, Unsure), none).
or_basis(open(MissingOne, UnsureOne), _, open(MissingTwo, UnsureTwo), _, open(Missing, Unsure), none) :-
    append(MissingOne, MissingTwo, Missing),
    append(UnsureOne, UnsureTwo, Unsure).

engagement(access, _, met, art15_1) :-
    implements(eu_reg_2016_679_art_15_1).
engagement(rectification, Profile, Status, Basis) :-
    implements(eu_reg_2016_679_art_16),
    required_status(Profile, personal_data_inaccurate, Inaccurate),
    required_status(Profile, personal_data_incomplete_in_light_of_purposes, Incomplete),
    or_basis(Inaccurate, art16_inaccurate_data, Incomplete, art16_incomplete_data, Status, Basis).
engagement(restriction, Profile, Status, Basis) :-
    implements(eu_reg_2016_679_art_18_1),
    required_status(Profile, accuracy_contested_by_data_subject, PointA),
    required_status(Profile, personal_data_unlawfully_processed, Unlawful),
    required_status(Profile, data_subject_opposes_erasure, Opposes),
    and2(Unlawful, Opposes, PointB),
    required_status(Profile, controller_no_longer_needs_data_for_processing_purposes, NoLongerNeeds),
    required_status(Profile, data_required_by_data_subject_for_legal_claims, RequiredForClaims),
    and2(NoLongerNeeds, RequiredForClaims, PointC),
    required_status(Profile, objection_under_art21_1_made, Objection),
    required_status(Profile, verification_of_overriding_grounds_pending, Pending),
    and2(Objection, Pending, PointD),
    or_basis(PointC, art18_1_c, PointD, art18_1_d, PointCD, BasisCD),
    or_basis(PointB, art18_1_b, PointCD, BasisCD, PointBCD, BasisBCD),
    or_basis(PointA, art18_1_a, PointBCD, BasisBCD, Status, Basis).

exception_status(art12_5_manifestly_unfounded_or_excessive, Profile, Status) :-
    implements(eu_reg_2016_679_art_12_5),
    key_value(Profile, request_manifestly_unfounded_or_excessive, Value),
    defeater_value(Value, request_manifestly_unfounded_or_excessive, Status).
exception_status(art12_2_unable_to_identify, Profile, Status) :-
    implements(eu_reg_2016_679_art_12_2),
    key_value(Profile, controller_demonstrates_unable_to_identify_data_subject, Value),
    defeater_value(Value, controller_demonstrates_unable_to_identify_data_subject, Status).
exception_status(art23_legislative_restriction, Profile, Status) :-
    implements(eu_reg_2016_679_art_23_1),
    key_value(Profile, legislative_restriction_applies_to_the_right, Value),
    outside_value(Value, Status).

suspension(Profile, Status) :-
    implements(eu_reg_2016_679_art_12_6),
    key_value(Profile, reasonable_doubts_about_identity, Doubts),
    defeater_value(Doubts, reasonable_doubts_about_identity, DoubtsStatus),
    key_value(Profile, identity_confirmed, Confirmed),
    negated_value(Confirmed, identity_confirmed, NotConfirmedStatus),
    and2(DoubtsStatus, NotConfirmedStatus, Status).

first_exception(met, _, _, art12_5_manifestly_unfounded_or_excessive).
first_exception(Unfounded, met, _, art12_2_unable_to_identify) :-
    dif(Unfounded, met).
first_exception(Unfounded, Unidentified, met, art23_legislative_restriction) :-
    dif(Unfounded, met),
    dif(Unidentified, met).
first_exception(Unfounded, Unidentified, Restricted, none) :-
    dif(Unfounded, met),
    dif(Unidentified, met),
    dif(Restricted, met).

exception_conditions(art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged]) :-
    implements(eu_reg_2016_679_art_12_5).
exception_conditions(art12_2_unable_to_identify, []).
exception_conditions(art23_legislative_restriction, []).

right_cites(access, _, [cite(eu_reg_2016_679_art_15_1)]).
right_cites(rectification, _, [cite(eu_reg_2016_679_art_16)]).
right_cites(restriction, none, [cite(eu_reg_2016_679_art_18_1)]).
right_cites(restriction, art18_1_a, [cite(eu_reg_2016_679_art_18_1), cite(eu_reg_2016_679_art_18_1_a)]).
right_cites(restriction, art18_1_b, [cite(eu_reg_2016_679_art_18_1), cite(eu_reg_2016_679_art_18_1_b)]).
right_cites(restriction, art18_1_c, [cite(eu_reg_2016_679_art_18_1), cite(eu_reg_2016_679_art_18_1_c)]).
right_cites(restriction, art18_1_d, [cite(eu_reg_2016_679_art_18_1), cite(eu_reg_2016_679_art_18_1_d)]).

exception_bounds(art12_5_manifestly_unfounded_or_excessive, [cite(eu_reg_2016_679_art_12_5)], []).
exception_bounds(art12_2_unable_to_identify, [cite(eu_reg_2016_679_art_12_2)], []).
exception_bounds(art23_legislative_restriction, [], [cite(eu_reg_2016_679_art_23_1)]).

exception_citations(Type, Basis, Exception, Citations) :-
    right_cites(Type, Basis, Right),
    exception_bounds(Exception, Before, After),
    append(Before, Right, Partial),
    append(Partial, After, Citations).

request_basis_checklist(Profile, Items) :-
    gdpr_data_subject_rights_access_rectification_restriction_input_problems(Profile, []),
    key_value(Profile, request_type, Type),
    checklist_for(Type, Profile, Items).

checklist_for(Type, Profile, [item(right_engaged, EngagementItem, RightCite), item(art12_5_manifestly_unfounded_or_excessive, UnfoundedItem, cite(eu_reg_2016_679_art_12_5)), item(art12_2_unable_to_identify, UnidentifiedItem, cite(eu_reg_2016_679_art_12_2)), item(art23_legislative_restriction, RestrictedItem, cite(eu_reg_2016_679_art_23_1)), item(art12_6_identity_not_confirmed, SuspensionItem, cite(eu_reg_2016_679_art_12_6))]) :-
    memberd_t(Type, [access, rectification, restriction], true),
    engagement(Type, Profile, Engagement, _),
    exception_status(art12_5_manifestly_unfounded_or_excessive, Profile, Unfounded),
    exception_status(art12_2_unable_to_identify, Profile, Unidentified),
    exception_status(art23_legislative_restriction, Profile, Restricted),
    suspension(Profile, Suspension),
    right_cites(Type, none, [RightCite|_]),
    item_status(Engagement, EngagementItem),
    item_status(Unfounded, UnfoundedItem),
    item_status(Unidentified, UnidentifiedItem),
    item_status(Restricted, RestrictedItem),
    item_status(Suspension, SuspensionItem).

item_status(met, met).
item_status(unmet, unmet).
item_status(open(Missing, Unsure), unknown(Keys)) :-
    append(Missing, Unsure, Keys).
