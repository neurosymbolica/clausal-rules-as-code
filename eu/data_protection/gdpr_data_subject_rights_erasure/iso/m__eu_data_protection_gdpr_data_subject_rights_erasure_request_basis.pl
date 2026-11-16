% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_request_basis, [decide_request_basis/2, request_basis_status/2, request_basis/2, request_basis_engagement/3, request_basis_judgement_keys/1, request_basis_checklist/2, request_basis_decision_resolvable/1, request_basis_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_kernel, [gdpr_data_subject_rights_erasure_input_problems/2, gdpr_data_subject_rights_erasure_request_type_route/2, gdpr_data_subject_rights_erasure_required_limb/3, gdpr_data_subject_rights_erasure_outside_fact_limb/4, gdpr_data_subject_rights_erasure_negated_limb/2, gdpr_data_subject_rights_erasure_conjunction/2, gdpr_data_subject_rights_erasure_disjunction/2, gdpr_data_subject_rights_erasure_first_met/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_citations, [implements/1, gdpr_data_subject_rights_erasure_citations_in_order/2]).

request_basis_status_values([art17_1_a, art17_1_b, art17_1_c, art17_1_d, art17_1_e, art17_1_f, none]).

erasure_ground(art17_1_a, cite(eu_reg_2016_679_art_17_1_a)).
erasure_ground(art17_1_b, cite(eu_reg_2016_679_art_17_1_b)).
erasure_ground(art17_1_c, cite(eu_reg_2016_679_art_17_1_c)).
erasure_ground(art17_1_d, cite(eu_reg_2016_679_art_17_1_d)).
erasure_ground(art17_1_e, cite(eu_reg_2016_679_art_17_1_e)).
erasure_ground(art17_1_f, cite(eu_reg_2016_679_art_17_1_f)).

erasure_ground_order([art17_1_a, art17_1_b, art17_1_c, art17_1_d, art17_1_e, art17_1_f]).

request_basis_judgement_keys([data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed]).

ground_limb(art17_1_a, Profile, PointLimb) :-
    implements(eu_reg_2016_679_art_17_1_a),
    gdpr_data_subject_rights_erasure_required_limb(Profile, data_no_longer_necessary_for_purposes, PointLimb).
ground_limb(art17_1_b, Profile, PointLimb) :-
    implements(eu_reg_2016_679_art_17_1_b),
    gdpr_data_subject_rights_erasure_required_limb(Profile, consent_is_the_basis_of_processing, ConsentBasisLimb),
    gdpr_data_subject_rights_erasure_required_limb(Profile, consent_withdrawn, WithdrawalLimb),
    gdpr_data_subject_rights_erasure_required_limb(Profile, other_legal_ground_for_processing_exists, OtherGroundLimb),
    gdpr_data_subject_rights_erasure_negated_limb(OtherGroundLimb, NoOtherGroundLimb),
    gdpr_data_subject_rights_erasure_conjunction([ConsentBasisLimb, WithdrawalLimb, NoOtherGroundLimb], PointLimb).
ground_limb(art17_1_c, Profile, PointLimb) :-
    implements(eu_reg_2016_679_art_17_1_c),
    gdpr_data_subject_rights_erasure_required_limb(Profile, objection_under_art21_1_made, GeneralObjectionLimb),
    gdpr_data_subject_rights_erasure_required_limb(Profile, overriding_legitimate_grounds_exist, OverridingLimb),
    gdpr_data_subject_rights_erasure_negated_limb(OverridingLimb, NoOverridingLimb),
    gdpr_data_subject_rights_erasure_conjunction([GeneralObjectionLimb, NoOverridingLimb], GeneralObjectionPointLimb),
    gdpr_data_subject_rights_erasure_required_limb(Profile, objection_under_art21_2_made, MarketingObjectionLimb),
    gdpr_data_subject_rights_erasure_disjunction([GeneralObjectionPointLimb, MarketingObjectionLimb], PointLimb).
ground_limb(art17_1_d, Profile, PointLimb) :-
    implements(eu_reg_2016_679_art_17_1_d),
    gdpr_data_subject_rights_erasure_required_limb(Profile, personal_data_unlawfully_processed, PointLimb).
ground_limb(art17_1_e, Profile, PointLimb) :-
    implements(eu_reg_2016_679_art_17_1_e),
    gdpr_data_subject_rights_erasure_outside_fact_limb(Profile, erasure_required_by_union_or_member_state_law, enabling, PointLimb).
ground_limb(art17_1_f, Profile, PointLimb) :-
    implements(eu_reg_2016_679_art_17_1_f),
    gdpr_data_subject_rights_erasure_required_limb(Profile, collected_in_relation_to_information_society_services_offer, PointLimb).

ground_rows([], _, []).
ground_rows([GroundIdentifier|GroundIdentifiers], Profile, [GroundIdentifier - PointLimb|GroundRows]) :-
    ground_limb(GroundIdentifier, Profile, PointLimb),
    ground_rows(GroundIdentifiers, Profile, GroundRows).

request_basis_engagement(Profile, EngagementLimb, Basis) :-
    implements(eu_reg_2016_679_art_17_1),
    erasure_ground_order(GroundIdentifiers),
    ground_rows(GroundIdentifiers, Profile, GroundRows),
    pairs_values(GroundRows, PointLimbs),
    gdpr_data_subject_rights_erasure_disjunction(PointLimbs, EngagementLimb),
    gdpr_data_subject_rights_erasure_first_met(GroundRows, Basis).

decide_request_basis(Profile, request_basis_verdict(input_problems([Problem|Problems]), none, [])) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, [Problem|Problems]).
decide_request_basis(Profile, request_basis_verdict(indeterminate([request_type]), none, [])) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, absent).
decide_request_basis(Profile, request_basis_verdict(outside_this_order(request_type), none, [])) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, outside_this_order(_)).
decide_request_basis(Profile, request_basis_verdict(engaged, Basis, Citations)) :-
    implements(eu_reg_2016_679_art_17_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, met, Basis),
    erasure_ground(Basis, cite(BasisKey)),
    gdpr_data_subject_rights_erasure_citations_in_order([eu_reg_2016_679_art_17_1, BasisKey], Citations).
decide_request_basis(Profile, request_basis_verdict(not_engaged, none, [cite(eu_reg_2016_679_art_17_1)])) :-
    implements(eu_reg_2016_679_art_17_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, unmet, _).
decide_request_basis(Profile, request_basis_verdict(open_by_absence([MissingKey|MissingKeys]), none, [])) :-
    implements(eu_reg_2016_679_art_17_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, open([MissingKey|MissingKeys], _, _), _).
decide_request_basis(Profile, request_basis_verdict(open_by_outside_fact([OutsideKey|OutsideKeys]), none, [])) :-
    implements(eu_reg_2016_679_art_17_1_e),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, open([], _, [OutsideKey|OutsideKeys]), _).
decide_request_basis(Profile, request_basis_verdict(open_by_judgement([UnsureKey|UnsureKeys]), none, [])) :-
    implements(eu_reg_2016_679_art_17_1),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    request_basis_engagement(Profile, open([], [UnsureKey|UnsureKeys], []), _).

request_basis_status(Profile, Status) :-
    decide_request_basis(Profile, request_basis_verdict(Status, _, _)).

request_basis(Profile, Basis) :-
    decide_request_basis(Profile, request_basis_verdict(_, Basis, _)).

request_basis_decision_resolvable(Profile) :-
    decide_request_basis(Profile, _).

request_basis_checklist(Profile, Items) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, in_order),
    erasure_ground_order(GroundIdentifiers),
    checklist_items(GroundIdentifiers, Profile, Items).
request_basis_checklist(Profile, []) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, [_|_]).
request_basis_checklist(Profile, []) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, absent).
request_basis_checklist(Profile, []) :-
    gdpr_data_subject_rights_erasure_input_problems(Profile, []),
    gdpr_data_subject_rights_erasure_request_type_route(Profile, outside_this_order(_)).

checklist_items([], _, []).
checklist_items([GroundIdentifier|GroundIdentifiers], Profile, [item(GroundIdentifier, ItemStatus, Citation)|Items]) :-
    erasure_ground(GroundIdentifier, Citation),
    ground_limb(GroundIdentifier, Profile, PointLimb),
    limb_item_status(PointLimb, ItemStatus),
    checklist_items(GroundIdentifiers, Profile, Items).

limb_item_status(met, met).
limb_item_status(unmet, unmet(ground_not_met)).
limb_item_status(open(AbsentKeys, UnsureKeys, OutsideKeys), unknown(OpenKeys)) :-
    append(AbsentKeys, UnsureKeys, FirstKeys),
    append(FirstKeys, OutsideKeys, OpenKeys).

example_profile(every_ground_ruled_out, [attribute(request_type, erasure), attribute(consent_is_the_basis_of_processing, false), attribute(objection_under_art21_1_made, false), attribute(objection_under_art21_2_made, false), attribute(collected_in_relation_to_information_society_services_offer, false), attribute(data_no_longer_necessary_for_purposes, false), attribute(personal_data_unlawfully_processed, false), attribute(erasure_required_by_union_or_member_state_law, attested(false, attestation(by, at, reason, none)))]).
example_profile(legal_obligation_not_attested, [attribute(request_type, erasure), attribute(consent_is_the_basis_of_processing, false), attribute(objection_under_art21_1_made, false), attribute(objection_under_art21_2_made, false), attribute(collected_in_relation_to_information_society_services_offer, false), attribute(data_no_longer_necessary_for_purposes, false), attribute(personal_data_unlawfully_processed, false)]).
example_profile(unlawfulness_unsure, [attribute(request_type, erasure), attribute(consent_is_the_basis_of_processing, false), attribute(objection_under_art21_1_made, false), attribute(objection_under_art21_2_made, false), attribute(collected_in_relation_to_information_society_services_offer, false), attribute(data_no_longer_necessary_for_purposes, false), attribute(personal_data_unlawfully_processed, unsure), attribute(erasure_required_by_union_or_member_state_law, attested(false, attestation(by, at, reason, none)))]).
example_profile(marketing_objection, [attribute(request_type, erasure), attribute(consent_is_the_basis_of_processing, false), attribute(objection_under_art21_1_made, false), attribute(objection_under_art21_2_made, true), attribute(data_no_longer_necessary_for_purposes, false)]).
example_profile(consent_withdrawn_without_other_ground, [attribute(request_type, erasure), attribute(consent_is_the_basis_of_processing, true), attribute(consent_withdrawn, true), attribute(other_legal_ground_for_processing_exists, false), attribute(data_no_longer_necessary_for_purposes, false)]).

test(no_longer_necessary_engages_point_a) :-
    findall(Verdict, decide_request_basis([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true)], Verdict), Verdicts),
    Verdicts == [request_basis_verdict(engaged, art17_1_a, [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])].
test(consent_withdrawn_engages_point_b) :-
    example_profile(consent_withdrawn_without_other_ground, Profile),
    findall(Basis, request_basis(Profile, Basis), Bases),
    Bases == [art17_1_b].
test(marketing_objection_engages_point_c) :-
    example_profile(marketing_objection, Profile),
    findall(Verdict, decide_request_basis(Profile, Verdict), Verdicts),
    Verdicts == [request_basis_verdict(engaged, art17_1_c, [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_c)])].
test(every_ground_ruled_out_is_not_engaged) :-
    example_profile(every_ground_ruled_out, Profile),
    findall(Verdict, decide_request_basis(Profile, Verdict), Verdicts),
    Verdicts == [request_basis_verdict(not_engaged, none, [cite(eu_reg_2016_679_art_17_1)])].
test(a_bare_erasure_request_names_every_missing_key) :-
    findall(Status, request_basis_status([attribute(request_type, erasure)], Status), Statuses),
    Statuses == [open_by_absence([consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed])].
test(an_absent_legal_obligation_is_open_by_outside_fact) :-
    example_profile(legal_obligation_not_attested, Profile),
    findall(Status, request_basis_status(Profile, Status), Statuses),
    Statuses == [open_by_outside_fact([erasure_required_by_union_or_member_state_law])].
test(an_unsure_unlawfulness_is_open_by_judgement) :-
    example_profile(unlawfulness_unsure, Profile),
    findall(Status, request_basis_status(Profile, Status), Statuses),
    Statuses == [open_by_judgement([personal_data_unlawfully_processed])].
test(an_attested_legal_obligation_engages_point_e) :-
    request_basis([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, false), attribute(consent_is_the_basis_of_processing, false), attribute(erasure_required_by_union_or_member_state_law, attested(true, attestation(by, at, reason, none)))], art17_1_e).
test(an_access_request_is_outside_this_order) :-
    findall(Verdict, decide_request_basis([attribute(request_type, access)], Verdict), Verdicts),
    Verdicts == [request_basis_verdict(outside_this_order(request_type), none, [])].
test(an_absent_request_type_is_indeterminate) :-
    findall(Verdict, decide_request_basis([], Verdict), Verdicts),
    Verdicts == [request_basis_verdict(indeterminate([request_type]), none, [])].
test(an_unsure_crisp_flag_is_an_input_problem) :-
    findall(Status, request_basis_status([attribute(request_type, erasure), attribute(consent_withdrawn, unsure)], Status), Statuses),
    Statuses == [input_problems([wrong_type(consent_withdrawn)])].
test(the_checklist_carries_a_cite_per_ground) :-
    example_profile(marketing_objection, Profile),
    request_basis_checklist(Profile, Items),
    length(Items, 6),
    member(item(art17_1_c, met, cite(eu_reg_2016_679_art_17_1_c)), Items),
    member(item(art17_1_a, unmet(ground_not_met), cite(eu_reg_2016_679_art_17_1_a)), Items).
test(the_checklist_of_an_outside_type_is_empty) :-
    findall(Items, request_basis_checklist([attribute(request_type, access)], Items), Checklists),
    Checklists == [[]].

test(no_longer_necessary_is_not_open, fail) :-
    decide_request_basis([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true)], request_basis_verdict(open_by_absence(_), _, _)).
test(an_other_legal_ground_defeats_point_b, fail) :-
    decide_request_basis([attribute(request_type, erasure), attribute(consent_is_the_basis_of_processing, true), attribute(consent_withdrawn, true), attribute(other_legal_ground_for_processing_exists, true), attribute(data_no_longer_necessary_for_purposes, false)], request_basis_verdict(engaged, art17_1_b, _)).
test(every_ground_ruled_out_is_not_engaged_positively, fail) :-
    example_profile(every_ground_ruled_out, Profile),
    decide_request_basis(Profile, request_basis_verdict(engaged, _, _)).
test(an_absent_legal_obligation_is_not_unmet, fail) :-
    example_profile(legal_obligation_not_attested, Profile),
    request_basis_status(Profile, not_engaged).
