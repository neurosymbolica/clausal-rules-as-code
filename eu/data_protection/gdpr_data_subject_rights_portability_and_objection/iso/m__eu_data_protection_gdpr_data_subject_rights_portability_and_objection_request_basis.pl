% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_request_basis, [decide_request_basis/2, request_basis_status/2, request_basis_checklist/2, request_basis_decision_resolvable/1, request_basis_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_kernel, [gdpr_data_subject_rights_portability_and_objection_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_citations, [implements/1]).

request_basis_status_values([art20_1, art21_1, art21_2, art21_6, none]).

cite_vocabulary([cite(eu_reg_2016_679_art_12_2), cite(eu_reg_2016_679_art_12_5), cite(eu_reg_2016_679_art_12_6), cite(eu_reg_2016_679_art_20_1), cite(eu_reg_2016_679_art_20_3), cite(eu_reg_2016_679_art_20_4), cite(eu_reg_2016_679_art_21_1), cite(eu_reg_2016_679_art_21_2), cite(eu_reg_2016_679_art_21_3), cite(eu_reg_2016_679_art_21_6), cite(eu_reg_2016_679_art_23_1)]).

contract_order([request_type, objection_ground_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_legal_claims, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds]).

right_cites(portability, [cite(eu_reg_2016_679_art_20_1)]).
right_cites(objection(art21_1), [cite(eu_reg_2016_679_art_21_1)]).
right_cites(objection(art21_2), [cite(eu_reg_2016_679_art_21_2), cite(eu_reg_2016_679_art_21_3)]).
right_cites(objection(art21_6), [cite(eu_reg_2016_679_art_21_6)]).

route_judgements(portability, []).
route_judgements(objection(art21_1), [objection_grounds_relate_to_particular_situation]).
route_judgements(objection(art21_2), []).
route_judgements(objection(art21_6), [objection_grounds_relate_to_particular_situation]).

exception_facts(art20_3_public_task, [], cite(eu_reg_2016_679_art_20_3), [processing_necessary_for_public_task_or_official_authority]).
exception_facts(art20_4_rights_of_others, [], cite(eu_reg_2016_679_art_20_4), [transmission_would_adversely_affect_rights_and_freedoms_of_others]).
exception_facts(art21_1_compelling_legitimate_grounds, [], cite(eu_reg_2016_679_art_21_1), [controller_demonstrates_compelling_legitimate_grounds]).
exception_facts(art21_1_legal_claims, [], cite(eu_reg_2016_679_art_21_1), [processing_necessary_for_legal_claims]).
exception_facts(art21_6_public_interest_task, [], cite(eu_reg_2016_679_art_21_6), [processing_necessary_for_public_task_or_official_authority]).
exception_facts(art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], cite(eu_reg_2016_679_art_12_5), [request_manifestly_unfounded_or_excessive]).
exception_facts(art12_2_unable_to_identify, [], cite(eu_reg_2016_679_art_12_2), []).
exception_facts(art23_legislative_restriction, [], cite(eu_reg_2016_679_art_23_1), []).

referral(any, reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)).
referral(any, request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)).
referral(portability, processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_20_3)).
referral(portability, transmission_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_20_4)).
referral(objection(art21_1), objection_grounds_relate_to_particular_situation, cite(eu_reg_2016_679_art_21_1)).
referral(objection(art21_1), controller_demonstrates_compelling_legitimate_grounds, cite(eu_reg_2016_679_art_21_1)).
referral(objection(art21_1), processing_necessary_for_legal_claims, cite(eu_reg_2016_679_art_21_1)).
referral(objection(art21_6), objection_grounds_relate_to_particular_situation, cite(eu_reg_2016_679_art_21_6)).
referral(objection(art21_6), processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_21_6)).

referral_cite(Route, Input, Cite) :-
    referral(Route, Input, Cite).
referral_cite(_, Input, Cite) :-
    referral(any, Input, Cite).

key_status(Profile, Key, met) :-
    profile_get(Profile, Key, true).
key_status(Profile, Key, unmet) :-
    profile_get(Profile, Key, false).
key_status(Profile, Key, open([], [Key])) :-
    profile_get(Profile, Key, unsure).
key_status(Profile, Key, open([Key], [])) :-
    profile_lacks(Profile, Key).

defeater_status(Profile, Key, met) :-
    profile_get(Profile, Key, true).
defeater_status(Profile, Key, unmet) :-
    profile_get(Profile, Key, false).
defeater_status(Profile, Key, open([], [Key])) :-
    profile_get(Profile, Key, unsure).
defeater_status(Profile, Key, unmet) :-
    profile_lacks(Profile, Key).

negated_key_status(Profile, Key, unmet) :-
    profile_get(Profile, Key, true).
negated_key_status(Profile, Key, met) :-
    profile_get(Profile, Key, false).
negated_key_status(Profile, Key, open([Key], [])) :-
    profile_lacks(Profile, Key).

outside_status(Profile, Key, met) :-
    profile_get(Profile, Key, attested(true, _)).
outside_status(Profile, Key, unmet) :-
    profile_get(Profile, Key, attested(false, _)).
outside_status(Profile, Key, unmet) :-
    profile_lacks(Profile, Key).

both_status(unmet, _, unmet).
both_status(met, Second, Second).
both_status(open(_, _), unmet, unmet).
both_status(open(FirstAbsents, FirstUnsures), met, open(FirstAbsents, FirstUnsures)).
both_status(open(FirstAbsents, FirstUnsures), open(SecondAbsents, SecondUnsures), open(Absents, Unsures)) :-
    append(FirstAbsents, SecondAbsents, Absents),
    append(FirstUnsures, SecondUnsures, Unsures).

route_of(Profile, missing([request_type])) :-
    profile_lacks(Profile, request_type).
route_of(Profile, portability) :-
    profile_get(Profile, request_type, portability).
route_of(Profile, missing([objection_ground_claimed])) :-
    profile_get(Profile, request_type, objection),
    profile_lacks(Profile, objection_ground_claimed).
route_of(Profile, objection(Ground)) :-
    profile_get(Profile, request_type, objection),
    profile_get(Profile, objection_ground_claimed, Ground).

engagement(portability, Profile, art20_1, Status) :-
    implements(eu_reg_2016_679_art_20_1),
    key_status(Profile, personal_data_provided_by_data_subject, ProvidedStatus),
    key_status(Profile, processing_based_on_consent_or_contract, BasisStatus),
    key_status(Profile, processing_carried_out_by_automated_means, AutomatedStatus),
    both_status(ProvidedStatus, BasisStatus, FirstTwoStatus),
    both_status(FirstTwoStatus, AutomatedStatus, Status).
engagement(objection(art21_1), Profile, art21_1, Status) :-
    implements(eu_reg_2016_679_art_21_1),
    key_status(Profile, processing_based_on_art6_1_e_or_f, BasisStatus),
    key_status(Profile, objection_grounds_relate_to_particular_situation, SituationStatus),
    both_status(BasisStatus, SituationStatus, Status).
engagement(objection(art21_2), Profile, art21_2, Status) :-
    implements(eu_reg_2016_679_art_21_2),
    implements(eu_reg_2016_679_art_21_3),
    key_status(Profile, processing_for_direct_marketing, Status).
engagement(objection(art21_6), Profile, art21_6, Status) :-
    implements(eu_reg_2016_679_art_21_6),
    key_status(Profile, processing_for_research_or_statistics_pursuant_to_art89_1, PurposeStatus),
    key_status(Profile, objection_grounds_relate_to_particular_situation, SituationStatus),
    both_status(PurposeStatus, SituationStatus, Status).

specific_exceptions(portability, Profile, [art20_3_public_task - PublicTaskStatus, art20_4_rights_of_others - OthersStatus]) :-
    implements(eu_reg_2016_679_art_20_3),
    implements(eu_reg_2016_679_art_20_4),
    defeater_status(Profile, processing_necessary_for_public_task_or_official_authority, PublicTaskStatus),
    defeater_status(Profile, transmission_would_adversely_affect_rights_and_freedoms_of_others, OthersStatus).
specific_exceptions(objection(art21_1), Profile, [art21_1_compelling_legitimate_grounds - CompellingStatus, art21_1_legal_claims - LegalClaimsStatus]) :-
    implements(eu_reg_2016_679_art_21_1),
    defeater_status(Profile, controller_demonstrates_compelling_legitimate_grounds, CompellingStatus),
    defeater_status(Profile, processing_necessary_for_legal_claims, LegalClaimsStatus).
specific_exceptions(objection(art21_2), _, []).
specific_exceptions(objection(art21_6), Profile, [art21_6_public_interest_task - PublicTaskStatus]) :-
    implements(eu_reg_2016_679_art_21_6),
    defeater_status(Profile, processing_necessary_for_public_task_or_official_authority, PublicTaskStatus).

common_exceptions(Profile, [art12_5_manifestly_unfounded_or_excessive - ExcessiveStatus, art12_2_unable_to_identify - UnableStatus, art23_legislative_restriction - RestrictionStatus]) :-
    implements(eu_reg_2016_679_art_12_5),
    implements(eu_reg_2016_679_art_12_2),
    implements(eu_reg_2016_679_art_23_1),
    defeater_status(Profile, request_manifestly_unfounded_or_excessive, ExcessiveStatus),
    defeater_status(Profile, controller_demonstrates_unable_to_identify_data_subject, UnableStatus),
    outside_status(Profile, legislative_restriction_applies_to_the_right, RestrictionStatus).

route_exceptions(Route, Profile, Exceptions) :-
    specific_exceptions(Route, Profile, Specific),
    common_exceptions(Profile, Common),
    append(Specific, Common, Exceptions).

suspension(Profile, Status) :-
    implements(eu_reg_2016_679_art_12_6),
    defeater_status(Profile, reasonable_doubts_about_identity, DoubtsStatus),
    negated_key_status(Profile, identity_confirmed, UnconfirmedStatus),
    both_status(DoubtsStatus, UnconfirmedStatus, Status).

first_met_exception([], none_met).
first_met_exception([Name - Status|Rest], Found) :-
    first_met_step(Status, Name, Rest, Found).

first_met_step(met, Name, _, found(Name)).
first_met_step(unmet, _, Rest, Found) :-
    first_met_exception(Rest, Found).
first_met_step(open(_, _), _, Rest, Found) :-
    first_met_exception(Rest, Found).

phase(unmet, _, _, engagement_unmet).
phase(met, found(Name), _, exception(Name)).
phase(open(_, _), found(Name), _, exception(Name)).
phase(met, none_met, met, suspended).
phase(open(_, _), none_met, met, suspended).
phase(met, none_met, unmet, residual).
phase(met, none_met, open(_, _), residual).
phase(open(_, _), none_met, unmet, residual).
phase(open(_, _), none_met, open(_, _), residual).

decide_request_basis(Profile, Verdict) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems(Profile, Problems),
    assemble_request(Problems, Profile, Verdict).

assemble_request([Problem|Problems], _, gdpr_data_subject_request_verdict(input_problems([Problem|Problems]), none, none, [], [])).
assemble_request([], Profile, Verdict) :-
    route_of(Profile, Route),
    decide_route(Route, Profile, Verdict).

decide_route(missing(Keys), _, gdpr_data_subject_request_verdict(indeterminate(Keys), none, none, [], [])).
decide_route(portability, Profile, Verdict) :-
    decide_engaged(portability, Profile, Verdict).
decide_route(objection(Ground), Profile, Verdict) :-
    decide_engaged(objection(Ground), Profile, Verdict).

decide_engaged(Route, Profile, Verdict) :-
    engagement(Route, Profile, Basis, EngagementStatus),
    route_exceptions(Route, Profile, Exceptions),
    suspension(Profile, SuspensionStatus),
    first_met_exception(Exceptions, Found),
    phase(EngagementStatus, Found, SuspensionStatus, Phase),
    verdict_for(Phase, context(Route, Profile, Basis, EngagementStatus, SuspensionStatus, Exceptions), Verdict).

verdict_for(engagement_unmet, context(Route, _, _, _, _, _), gdpr_data_subject_request_verdict(need_not_comply, none, none, [], Citations)) :-
    right_cites(Route, RightCites),
    ordered_cites(RightCites, Citations).
verdict_for(exception(Exception), context(Route, _, Basis, EngagementStatus, _, _), gdpr_data_subject_request_verdict(need_not_comply, GivenBasis, Exception, Conditions, Citations)) :-
    exception_facts(Exception, Conditions, ExceptionCite, _),
    basis_given(EngagementStatus, Basis, GivenBasis),
    right_cites(Route, RightCites),
    ordered_cites([ExceptionCite|RightCites], Citations).
verdict_for(suspended, _, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])) :-
    implements(eu_reg_2016_679_art_12_6).
verdict_for(residual, Context, Verdict) :-
    Context = context(_, _, _, EngagementStatus, SuspensionStatus, Exceptions),
    pairs_values(Exceptions, ExceptionStatuses),
    collect_open([EngagementStatus, SuspensionStatus|ExceptionStatuses], Absents, Unsures),
    residual_verdict(Absents, Unsures, Context, Verdict).

basis_given(met, Basis, Basis).
basis_given(open(_, _), _, none).

residual_verdict([Key|Keys], _, _, gdpr_data_subject_request_verdict(indeterminate(Missing), none, none, [], [])) :-
    ordered_keys([Key|Keys], Missing).
residual_verdict([], [Key|Keys], Context, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(First, Cite), [inputs_relied_on(Pairs)]), none, none, [], [])) :-
    Context = context(Route, _, _, _, _, _),
    ordered_keys([Key|Keys], [First|_]),
    referral_cite(Route, First, Cite),
    relied_pairs(Context, Pairs).
residual_verdict([], [], context(Route, _, Basis, _, _, _), gdpr_data_subject_request_verdict(must_comply, Basis, none, [], Citations)) :-
    right_cites(Route, RightCites),
    ordered_cites(RightCites, Citations).

collect_open([], [], []).
collect_open([Status|Statuses], Absents, Unsures) :-
    open_parts(Status, FirstAbsents, FirstUnsures),
    collect_open(Statuses, RestAbsents, RestUnsures),
    append(FirstAbsents, RestAbsents, Absents),
    append(FirstUnsures, RestUnsures, Unsures).

open_parts(met, [], []).
open_parts(unmet, [], []).
open_parts(open(Absents, Unsures), Absents, Unsures).

relied_pairs(context(Route, Profile, _, EngagementStatus, SuspensionStatus, Exceptions), Pairs) :-
    route_judgements(Route, RouteKeys),
    exception_limbs(Exceptions, ExceptionLimbs),
    open_limb_keys([EngagementStatus - RouteKeys, SuspensionStatus - [reasonable_doubts_about_identity]|ExceptionLimbs], OpenKeys),
    ordered_keys(OpenKeys, OrderedKeys),
    present_pairs(OrderedKeys, Profile, JudgementPairs),
    head_pairs(Route, HeadPairs),
    append(HeadPairs, JudgementPairs, Pairs).

head_pairs(portability, [request_type - portability]).
head_pairs(objection(Ground), [request_type - objection, objection_ground_claimed - Ground]).

exception_limbs([], []).
exception_limbs([Name - Status|Rest], [Status - Keys|Limbs]) :-
    exception_facts(Name, _, _, Keys),
    exception_limbs(Rest, Limbs).

open_limb_keys([], []).
open_limb_keys([Status - Keys|Limbs], AllKeys) :-
    limb_keys_used(Status, Keys, UsedKeys),
    open_limb_keys(Limbs, RestKeys),
    append(UsedKeys, RestKeys, AllKeys).

limb_keys_used(met, _, []).
limb_keys_used(unmet, _, []).
limb_keys_used(open(_, _), Keys, Keys).

present_pairs([], _, []).
present_pairs([Key|Keys], Profile, Pairs) :-
    present_pairs(Keys, Profile, RestPairs),
    pair_step(Profile, Key, RestPairs, Pairs).

pair_step(Profile, Key, RestPairs, [Key - Value|RestPairs]) :-
    profile_get(Profile, Key, Value).
pair_step(Profile, Key, RestPairs, RestPairs) :-
    profile_lacks(Profile, Key).

ordered_keys(Keys, Ordered) :-
    maplist(rank_pair, Keys, Pairs),
    sort(Pairs, SortedPairs),
    pairs_values(SortedPairs, Ordered).

rank_pair(Key, Rank - Key) :-
    contract_order(Order),
    nth0(Rank, Order, Key).

ordered_cites(Wanted, Ordered) :-
    cite_vocabulary(Vocabulary),
    keep_wanted(Vocabulary, Wanted, Ordered).

keep_wanted([], _, []).
keep_wanted([Cite|Rest], Wanted, Ordered) :-
    memberd_t(Cite, Wanted, IsWanted),
    keep_step(IsWanted, Cite, Remaining, Ordered),
    keep_wanted(Rest, Wanted, Remaining).

keep_step(true, Cite, Remaining, [Cite|Remaining]).
keep_step(false, _, Remaining, Remaining).

request_basis_status(Profile, Basis) :-
    decide_request_basis(Profile, gdpr_data_subject_request_verdict(_, Basis, _, _, _)).

request_basis_checklist(Profile, Items) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems(Profile, []),
    route_of(Profile, Route),
    checklist_for(Route, Profile, Items).

checklist_for(missing(_), _, []).
checklist_for(portability, Profile, Items) :-
    engaged_checklist(portability, Profile, Items).
checklist_for(objection(Ground), Profile, Items) :-
    engaged_checklist(objection(Ground), Profile, Items).

engaged_checklist(Route, Profile, [item(engagement, EngagementItem, Primary), item(identity_suspension, SuspensionItem, cite(eu_reg_2016_679_art_12_6))|ExceptionItems]) :-
    engagement(Route, Profile, _, EngagementStatus),
    suspension(Profile, SuspensionStatus),
    route_exceptions(Route, Profile, Exceptions),
    right_cites(Route, [Primary|_]),
    status_item(EngagementStatus, EngagementItem),
    status_item(SuspensionStatus, SuspensionItem),
    exception_items(Exceptions, ExceptionItems).

exception_items([], []).
exception_items([Name - Status|Rest], [item(Name, ItemStatus, Cite)|Items]) :-
    exception_facts(Name, _, Cite, _),
    status_item(Status, ItemStatus),
    exception_items(Rest, Items).

status_item(met, met).
status_item(unmet, unmet).
status_item(open(Absents, Unsures), unknown(Keys)) :-
    append(Absents, Unsures, Both),
    ordered_keys(Both, Keys).

request_basis_decision_resolvable(Profile) :-
    decide_request_basis(Profile, _Verdict).

test(portability_engaged_and_unrelieved_must_comply) :-
    decide_request_basis([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [cite(eu_reg_2016_679_art_20_1)]).
test(portability_public_task_relieves) :-
    decide_request_basis([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(processing_necessary_for_public_task_or_official_authority, true)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(need_not_comply, art20_1, art20_3_public_task, [], [cite(eu_reg_2016_679_art_20_1), cite(eu_reg_2016_679_art_20_3)]).
test(portability_not_engaged_cites_the_article_only) :-
    decide_request_basis([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, false)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_20_1)]).
test(missing_request_type_is_indeterminate) :-
    decide_request_basis([], Verdict),
    Verdict == gdpr_data_subject_request_verdict(indeterminate([request_type]), none, none, [], []).
test(missing_engagement_key_is_named) :-
    decide_request_basis([attribute(request_type, portability), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(indeterminate([personal_data_provided_by_data_subject]), none, none, [], []).
test(direct_marketing_excessive_request_carries_the_fee_condition) :-
    decide_request_basis([attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true), attribute(request_manifestly_unfounded_or_excessive, true)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(need_not_comply, art21_2, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [cite(eu_reg_2016_679_art_12_5), cite(eu_reg_2016_679_art_21_2), cite(eu_reg_2016_679_art_21_3)]).
test(unconfirmed_identity_suspends) :-
    decide_request_basis([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], []).
test(unsure_public_task_refers) :-
    decide_request_basis([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(processing_necessary_for_public_task_or_official_authority, unsure)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(needs_legal_review(open_textured(processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_20_3)), [inputs_relied_on([request_type - portability, processing_necessary_for_public_task_or_official_authority - unsure])]), none, none, [], []).
test(unknown_key_is_an_input_problem) :-
    decide_request_basis([attribute(no_such_key, true)], Verdict),
    Verdict == gdpr_data_subject_request_verdict(input_problems([unknown_key(no_such_key)]), none, none, [], []).
test(basis_projection_of_a_must_comply) :-
    request_basis_status([attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true)], art21_2).
