% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_queries, [gdpr_data_subject_rights_erasure_profile_keys/1, decide_data_subject_request/2, gdpr_data_subject_rights_erasure_what_if/4, gdpr_data_subject_rights_erasure_compliance_check/3, gdpr_data_subject_request_verdict/5, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, suspended/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, attested/2, attestation/4, url/2, document/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_kernel, [gdpr_data_subject_rights_erasure_input_problems/2, gdpr_data_subject_rights_erasure_request_type_route/2, gdpr_data_subject_rights_erasure_open_union/4, gdpr_data_subject_rights_erasure_present_pairs/3]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_citations, [implements/1, gdpr_data_subject_rights_erasure_citations_in_order/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_request_basis, [request_basis_engagement/3, request_basis_judgement_keys/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_request_exception, [request_exception_first_met/2, request_exception_suspension/2, request_exception_open_keys/4, request_exception_open_judgement_keys/2, request_exception_citations/2, request_exception_referral_citation/2]).

gdpr_data_subject_rights_erasure_profile_keys([request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays]).

basis_point_citations(none, []).
basis_point_citations(art17_1_a, [cite(eu_reg_2016_679_art_17_1_a)]).
basis_point_citations(art17_1_b, [cite(eu_reg_2016_679_art_17_1_b)]).
basis_point_citations(art17_1_c, [cite(eu_reg_2016_679_art_17_1_c)]).
basis_point_citations(art17_1_d, [cite(eu_reg_2016_679_art_17_1_d)]).
basis_point_citations(art17_1_e, [cite(eu_reg_2016_679_art_17_1_e)]).
basis_point_citations(art17_1_f, [cite(eu_reg_2016_679_art_17_1_f)]).

exception_conditions(art17_3_a, []).
exception_conditions(art17_3_b, []).
exception_conditions(art17_3_c, []).
exception_conditions(art17_3_d, []).
exception_conditions(art17_3_e, []).
exception_conditions(art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged]).
exception_conditions(art12_2_unable_to_identify, []).
exception_conditions(art23_legislative_restriction, []).

basis_referral_citation(data_no_longer_necessary_for_purposes, cite(eu_reg_2016_679_art_17_1_a)).
basis_referral_citation(overriding_legitimate_grounds_exist, cite(eu_reg_2016_679_art_17_1_c)).
basis_referral_citation(personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_17_1_d)).

outside_fact_referral(erasure_required_by_union_or_member_state_law, cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)).

judgement_referral_citation(JudgementKey, Citation) :-
    basis_referral_citation(JudgementKey, Citation).
judgement_referral_citation(JudgementKey, Citation) :-
    request_exception_referral_citation(JudgementKey, Citation).

engagement_not_unmet(met).
engagement_not_unmet(open(_, _, _)).

suspension_not_met(unmet).
suspension_not_met(open(_, _, _)).

citation_keys([], []).
citation_keys([cite(CitationKey)|Citations], [CitationKey|CitationKeys]) :-
    citation_keys(Citations, CitationKeys).

decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(input_problems([Problem|Problems]), none, none, [], [])) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, [Problem|Problems]).
decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(indeterminate([request_type]), none, none, [], [])) :-
    implements(eu_reg_2016_679_art_17_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, absent).
decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(needs_legal_review(outside_this_order(request_type), [inputs_relied_on([request_type - RequestType])]), none, none, [], [])) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, outside_this_order(RequestType)).
decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_17_1)])) :-
    implements(eu_reg_2016_679_art_17_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, unmet, _).
decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(need_not_comply, Basis, Exception, Conditions, Citations)) :-
    implements(eu_reg_2016_679_art_17_3),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, EngagementLimb, Basis),
    engagement_not_unmet(EngagementLimb),
    request_exception_first_met(Profile, Exception),
    dif(Exception, none),
    exception_conditions(Exception, Conditions),
    relief_citations(Basis, Exception, Citations).
decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])) :-
    implements(eu_reg_2016_679_art_12_6),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, EngagementLimb, _),
    engagement_not_unmet(EngagementLimb),
    request_exception_first_met(Profile, none),
    request_exception_suspension(Profile, met).
decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(indeterminate([MissingKey|MissingKeys]), none, none, [], [])) :-
    implements(eu_reg_2016_679_art_17_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, EngagementLimb, _),
    engagement_not_unmet(EngagementLimb),
    request_exception_first_met(Profile, none),
    request_exception_suspension(Profile, SuspensionLimb),
    suspension_not_met(SuspensionLimb),
    open_parts(Profile, EngagementLimb, [MissingKey|MissingKeys], _, _).
decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on(Pairs)]), none, none, [], [])) :-
    implements(eu_reg_2016_679_art_17_1_e),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, EngagementLimb, _),
    engagement_not_unmet(EngagementLimb),
    request_exception_first_met(Profile, none),
    request_exception_suspension(Profile, SuspensionLimb),
    suspension_not_met(SuspensionLimb),
    open_parts(Profile, EngagementLimb, [], _, [OutsideKey|_]),
    outside_fact_referral(OutsideKey, Citation, Target),
    relied_on_pairs(Profile, EngagementLimb, Pairs).
decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(UnsureKey, Citation), [inputs_relied_on(Pairs)]), none, none, [], [])) :-
    implements(eu_reg_2016_679_art_17_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, EngagementLimb, _),
    engagement_not_unmet(EngagementLimb),
    request_exception_first_met(Profile, none),
    request_exception_suspension(Profile, SuspensionLimb),
    suspension_not_met(SuspensionLimb),
    open_parts(Profile, EngagementLimb, [], [UnsureKey|_], []),
    judgement_referral_citation(UnsureKey, Citation),
    relied_on_pairs(Profile, EngagementLimb, Pairs).
decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(must_comply, Basis, none, [], Citations)) :-
    implements(eu_reg_2016_679_art_17_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, met, Basis),
    request_exception_first_met(Profile, none),
    request_exception_suspension(Profile, unmet),
    request_exception_open_keys(Profile, [], [], []),
    basis_point_citations(Basis, BasisCitations),
    citation_keys([cite(eu_reg_2016_679_art_17_1)|BasisCitations], CitationKeys),
    gdpr_data_subject_rights_erasure_citations_in_order(CitationKeys, Citations).

relief_citations(Basis, Exception, Citations) :-
    implements(eu_reg_2016_679_art_17_1),
    basis_point_citations(Basis, BasisCitations),
    request_exception_citations(Exception, ExceptionCitations),
    append([cite(eu_reg_2016_679_art_17_1)|BasisCitations], ExceptionCitations, AllCitations),
    citation_keys(AllCitations, CitationKeys),
    gdpr_data_subject_rights_erasure_citations_in_order(CitationKeys, Citations).

open_parts(Profile, EngagementLimb, AbsentKeys, UnsureKeys, OutsideKeys) :-
    request_exception_open_keys(Profile, ExceptionAbsentKeys, ExceptionUnsureKeys, ExceptionOutsideKeys),
    gdpr_data_subject_rights_erasure_open_union([EngagementLimb, open(ExceptionAbsentKeys, ExceptionUnsureKeys, ExceptionOutsideKeys)], AbsentKeys, UnsureKeys, OutsideKeys).

relied_on_pairs(Profile, EngagementLimb, Pairs) :-
    engagement_judgement_keys(EngagementLimb, EngagementKeys),
    request_exception_open_judgement_keys(Profile, ExceptionKeys),
    append([request_type|EngagementKeys], ExceptionKeys, RelyKeys),
    gdpr_data_subject_rights_erasure_present_pairs(Profile, RelyKeys, PresentPairs),
    enabling_fact_pairs(EngagementLimb, AbsentFactPairs),
    append(PresentPairs, AbsentFactPairs, Pairs).

engagement_judgement_keys(met, []).
engagement_judgement_keys(open(_, _, _), EngagementKeys) :-
    request_basis_judgement_keys(EngagementKeys).

enabling_fact_pairs(met, []).
enabling_fact_pairs(open(_, _, []), []).
enabling_fact_pairs(open(_, _, [OutsideKey|_]), [OutsideKey - absent]).

gdpr_data_subject_rights_erasure_what_if(Profile, _, _, Verdict) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, [wrong_type(profile)]),
    decide_data_subject_request(Profile, Verdict).
gdpr_data_subject_rights_erasure_what_if(Profile, OverriddenKey, NewValue, Verdict) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, Problems),
    dif(Problems, [wrong_type(profile)]),
    replace_entry(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_data_subject_request(Hypothesis, Verdict).

replace_entry([], Key, Value, [attribute(Key, Value)]).
replace_entry([attribute(EntryKey, EntryValue)|Entries], Key, Value, [attribute(EntryKey, EntryValue)|Replaced]) :-
    EntryKey \== Key,
    replace_entry(Entries, Key, Value, Replaced).
replace_entry([attribute(EntryKey, _)|Entries], Key, Value, [attribute(Key, Value)|Remaining]) :-
    EntryKey == Key,
    drop_key(Entries, Key, Remaining).

drop_key([], _, []).
drop_key([attribute(EntryKey, EntryValue)|Entries], Key, [attribute(EntryKey, EntryValue)|Remaining]) :-
    EntryKey \== Key,
    drop_key(Entries, Key, Remaining).
drop_key([attribute(EntryKey, _)|Entries], Key, Remaining) :-
    EntryKey == Key,
    drop_key(Entries, Key, Remaining).

gdpr_data_subject_rights_erasure_compliance_check(Profile, Action, Verdict) :-
    implements(eu_reg_2016_679_art_17_1),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(Comply, _, _, Conditions, _)),
    comply_class(Comply, ComplyClass),
    action_permission(Action, ComplyClass, Conditions, Verdict).

comply_class(must_comply, final_comply).
comply_class(need_not_comply, final_relief).
comply_class(suspended(_), suspended).
comply_class(indeterminate(_), open).
comply_class(needs_legal_review(_, _), open).
comply_class(input_problems(_), open).

action_permission(refuse_erasure, final_relief, _, permitted).
action_permission(refuse_erasure, final_comply, _, forbidden).
action_permission(refuse_erasure, suspended, _, not_yet_determined).
action_permission(refuse_erasure, open, _, not_yet_determined).
action_permission(charge_reasonable_fee, final_relief, [reasonable_fee_may_be_charged], permitted).
action_permission(charge_reasonable_fee, final_relief, [], forbidden).
action_permission(charge_reasonable_fee, final_comply, _, forbidden).
action_permission(charge_reasonable_fee, suspended, _, not_yet_determined).
action_permission(charge_reasonable_fee, open, _, not_yet_determined).
action_permission(defer_pending_identity, suspended, _, permitted).
action_permission(defer_pending_identity, final_relief, _, forbidden).
action_permission(defer_pending_identity, final_comply, _, forbidden).
action_permission(defer_pending_identity, open, _, not_yet_determined).
action_permission(Action, _, _, not_yet_determined) :-
    dif(Action, refuse_erasure),
    dif(Action, charge_reasonable_fee),
    dif(Action, defer_pending_identity).

gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations) :-
    nonvar(Comply),
    atom(Basis),
    atom(Exception),
    is_list(Conditions),
    is_list(Citations).

indeterminate(MissingKeys) :-
    is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    is_list(Context).

open_textured(Input, Citation) :-
    atom(Input),
    compound(Citation).

cross_reference_unresolved(Citation, Target) :-
    compound(Citation),
    compound(Target).

resolution(Target, ResolutionStatus) :-
    compound(Target),
    atom(ResolutionStatus).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(DecidingClause, Citations) :-
    nonvar(DecidingClause),
    is_list(Citations).

suspended(art12_6_identity_not_confirmed).

input_problems(Problems) :-
    is_list(Problems).

unknown_key(ProfileKey) :-
    atom(ProfileKey).

wrong_type(ProfileKey) :-
    atom(ProfileKey).

duplicate_key(ProfileKey) :-
    atom(ProfileKey).

attested(AttestedValue, Attestation) :-
    nonvar(AttestedValue),
    compound(Attestation).

attestation(AttestedBy, AttestedAt, AttestationReason, Evidence) :-
    nonvar(AttestedBy),
    nonvar(AttestedAt),
    nonvar(AttestationReason),
    nonvar(Evidence).

url(Address, RetrievedAt) :-
    nonvar(Address),
    nonvar(RetrievedAt).

document(UploadIdentifier, ContentHash) :-
    nonvar(UploadIdentifier),
    nonvar(ContentHash).
