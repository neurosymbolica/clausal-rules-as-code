% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [decide_request_exception/2, request_exception_status/2, request_exception_checklist/2, request_exception_decision_resolvable/1, request_exception_status_values/1, request_exception_full_verdict/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_citations, [implements/1]).

request_exception_status_values([art20_3_public_task, art20_4_rights_of_others, art21_1_compelling_legitimate_grounds, art21_1_legal_claims, art21_6_public_interest_task, art22_2_a, art22_2_b, art22_2_c, art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction, none]).

basis_row(portability, art20_1, cite(eu_reg_2016_679_art_20_1)).
basis_row(art21_1, art21_1, cite(eu_reg_2016_679_art_21_1)).
basis_row(art21_2, art21_2, cite(eu_reg_2016_679_art_21_2)).
basis_row(art21_6, art21_6, cite(eu_reg_2016_679_art_21_6)).
basis_row(automated_decision, art22_1, cite(eu_reg_2016_679_art_22_1)).

non_engaged_route(no_request_type).
non_engaged_route(no_ground).
non_engaged_route(outside_scope).

engagement_limbs(portability, [required_key(personal_data_provided_by_data_subject), required_key(processing_based_on_consent_or_contract), required_key(processing_carried_out_by_automated_means)]).
engagement_limbs(art21_1, [required_key(processing_based_on_art6_1_e_or_f), required_key(objection_grounds_relate_to_particular_situation)]).
engagement_limbs(art21_2, [required_key(processing_for_direct_marketing)]).
engagement_limbs(art21_6, [required_key(processing_for_research_or_statistics_pursuant_to_art89_1), required_key(objection_grounds_relate_to_particular_situation)]).
engagement_limbs(automated_decision, [required_key(decision_based_solely_on_automated_processing), required_key(decision_produces_legal_or_similarly_significant_effects)]).

route_exceptions(portability, [art20_3_public_task, art20_4_rights_of_others]).
route_exceptions(art21_1, [art21_1_compelling_legitimate_grounds, art21_1_legal_claims]).
route_exceptions(art21_2, []).
route_exceptions(art21_6, [art21_6_public_interest_task]).
route_exceptions(automated_decision, [art22_2_a, art22_2_b, art22_2_c]).

common_exceptions([art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction]).

exception_limbs(art20_3_public_task, [defeater_key(processing_necessary_for_public_task_or_official_authority)]).
exception_limbs(art20_4_rights_of_others, [defeater_key(transmission_would_adversely_affect_rights_and_freedoms_of_others)]).
exception_limbs(art21_1_compelling_legitimate_grounds, [defeater_key(controller_demonstrates_compelling_legitimate_grounds)]).
exception_limbs(art21_1_legal_claims, [defeater_key(processing_necessary_for_legal_claims)]).
exception_limbs(art21_6_public_interest_task, [defeater_key(processing_necessary_for_public_task_or_official_authority)]).
exception_limbs(art22_2_a, [defeater_key(decision_necessary_for_contract_with_data_subject), bar_free]).
exception_limbs(art22_2_b, [outside_key(decision_authorised_by_union_or_member_state_law), bar_free]).
exception_limbs(art22_2_c, [defeater_key(data_subject_gave_explicit_consent), bar_free]).
exception_limbs(art12_5_manifestly_unfounded_or_excessive, [defeater_key(request_manifestly_unfounded_or_excessive)]).
exception_limbs(art12_2_unable_to_identify, [defeater_key(controller_demonstrates_unable_to_identify_data_subject)]).
exception_limbs(art23_legislative_restriction, [outside_key(legislative_restriction_applies_to_the_right)]).

suspension_limbs([defeater_key(reasonable_doubts_about_identity), negated_key(identity_confirmed)]).

exception_citation(art20_3_public_task, cite(eu_reg_2016_679_art_20_3)).
exception_citation(art20_4_rights_of_others, cite(eu_reg_2016_679_art_20_4)).
exception_citation(art21_1_compelling_legitimate_grounds, cite(eu_reg_2016_679_art_21_1)).
exception_citation(art21_1_legal_claims, cite(eu_reg_2016_679_art_21_1)).
exception_citation(art21_6_public_interest_task, cite(eu_reg_2016_679_art_21_6)).
exception_citation(art22_2_a, cite(eu_reg_2016_679_art_22_2_a)).
exception_citation(art22_2_b, cite(eu_reg_2016_679_art_22_2_b)).
exception_citation(art22_2_c, cite(eu_reg_2016_679_art_22_2_c)).
exception_citation(art12_5_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)).
exception_citation(art12_2_unable_to_identify, cite(eu_reg_2016_679_art_12_2)).
exception_citation(art23_legislative_restriction, cite(eu_reg_2016_679_art_23_1)).

referral_citation(reasonable_doubts_about_identity, _, cite(eu_reg_2016_679_art_12_6)).
referral_citation(request_manifestly_unfounded_or_excessive, _, cite(eu_reg_2016_679_art_12_5)).
referral_citation(processing_necessary_for_public_task_or_official_authority, portability, cite(eu_reg_2016_679_art_20_3)).
referral_citation(processing_necessary_for_public_task_or_official_authority, art21_6, cite(eu_reg_2016_679_art_21_6)).
referral_citation(processing_necessary_for_legal_claims, _, cite(eu_reg_2016_679_art_21_1)).
referral_citation(transmission_would_adversely_affect_rights_and_freedoms_of_others, _, cite(eu_reg_2016_679_art_20_4)).
referral_citation(objection_grounds_relate_to_particular_situation, art21_1, cite(eu_reg_2016_679_art_21_1)).
referral_citation(objection_grounds_relate_to_particular_situation, art21_6, cite(eu_reg_2016_679_art_21_6)).
referral_citation(controller_demonstrates_compelling_legitimate_grounds, _, cite(eu_reg_2016_679_art_21_1)).
referral_citation(decision_based_solely_on_automated_processing, _, cite(eu_reg_2016_679_art_22_1)).
referral_citation(decision_produces_legal_or_similarly_significant_effects, _, cite(eu_reg_2016_679_art_22_1)).
referral_citation(decision_necessary_for_contract_with_data_subject, _, cite(eu_reg_2016_679_art_22_2_a)).

missing_key_order([identity_confirmed, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, special_category_condition_and_safeguards_met_for_decision, objection_grounds_relate_to_particular_situation, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects]).

judgement_key_order([reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_legal_claims, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject]).

key_state(Profile, Key, met) :-
    profile_get(Profile, Key, true).
key_state(Profile, Key, unmet) :-
    profile_get(Profile, Key, false).
key_state(Profile, Key, open([], [Key])) :-
    profile_get(Profile, Key, unsure).
key_state(Profile, Key, open([Key], [])) :-
    profile_lacks(Profile, Key).

defeater_state(Profile, Key, met) :-
    profile_get(Profile, Key, true).
defeater_state(Profile, Key, unmet) :-
    profile_get(Profile, Key, false).
defeater_state(Profile, Key, open([], [Key])) :-
    profile_get(Profile, Key, unsure).
defeater_state(Profile, Key, unmet) :-
    profile_lacks(Profile, Key).

outside_state(Profile, Key, met) :-
    profile_get(Profile, Key, attested(true, _)).
outside_state(Profile, Key, unmet) :-
    profile_get(Profile, Key, attested(false, _)).
outside_state(Profile, Key, unmet) :-
    profile_lacks(Profile, Key).

negate_state(met, unmet).
negate_state(unmet, met).
negate_state(open(AbsentKeys, UnsureKeys), open(AbsentKeys, UnsureKeys)).

and_two(unmet, _, unmet).
and_two(met, State, State).
and_two(open(_, _), unmet, unmet).
and_two(open(AbsentKeys, UnsureKeys), met, open(AbsentKeys, UnsureKeys)).
and_two(open(FirstAbsent, FirstUnsure), open(SecondAbsent, SecondUnsure), open(AbsentKeys, UnsureKeys)) :-
    append(FirstAbsent, SecondAbsent, AbsentKeys),
    append(FirstUnsure, SecondUnsure, UnsureKeys).

and_list([], met).
and_list([State|States], Result) :-
    and_list(States, RestResult),
    and_two(State, RestResult, Result).

limb_state(Profile, required_key(Key), State) :-
    key_state(Profile, Key, State).
limb_state(Profile, negated_key(Key), State) :-
    key_state(Profile, Key, KeyState),
    negate_state(KeyState, State).
limb_state(Profile, defeater_key(Key), State) :-
    defeater_state(Profile, Key, State).
limb_state(Profile, outside_key(Key), State) :-
    outside_state(Profile, Key, State).
limb_state(Profile, bar_free, State) :-
    implements(eu_reg_2016_679_art_22_4),
    limb_state(Profile, defeater_key(decision_based_on_special_categories), SpecialState),
    limb_state(Profile, negated_key(special_category_condition_and_safeguards_met_for_decision), SafeguardState),
    and_two(SpecialState, SafeguardState, BarState),
    negate_state(BarState, State).

limbs_state(Profile, Limbs, State) :-
    maplist(limb_state(Profile), Limbs, States),
    and_list(States, State).

limb_keys(required_key(Key), [Key]).
limb_keys(negated_key(Key), [Key]).
limb_keys(defeater_key(Key), [Key]).
limb_keys(outside_key(Key), [Key]).
limb_keys(bar_free, []).

limbs_keys([], []).
limbs_keys([Limb|Limbs], Keys) :-
    limb_keys(Limb, OwnKeys),
    limbs_keys(Limbs, RestKeys),
    append(OwnKeys, RestKeys, Keys).

engagement_state(Profile, portability, State) :-
    implements(eu_reg_2016_679_art_20_1),
    engagement_limbs(portability, Limbs),
    limbs_state(Profile, Limbs, State).
engagement_state(Profile, art21_1, State) :-
    implements(eu_reg_2016_679_art_21_1),
    engagement_limbs(art21_1, Limbs),
    limbs_state(Profile, Limbs, State).
engagement_state(Profile, art21_2, State) :-
    implements(eu_reg_2016_679_art_21_2),
    implements(eu_reg_2016_679_art_21_3),
    engagement_limbs(art21_2, Limbs),
    limbs_state(Profile, Limbs, State).
engagement_state(Profile, art21_6, State) :-
    implements(eu_reg_2016_679_art_21_6),
    engagement_limbs(art21_6, Limbs),
    limbs_state(Profile, Limbs, State).
engagement_state(Profile, automated_decision, State) :-
    implements(eu_reg_2016_679_art_22_1),
    engagement_limbs(automated_decision, Limbs),
    limbs_state(Profile, Limbs, State).

exception_state(Profile, art20_3_public_task, State) :-
    implements(eu_reg_2016_679_art_20_3),
    exception_limbs(art20_3_public_task, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art20_4_rights_of_others, State) :-
    implements(eu_reg_2016_679_art_20_4),
    exception_limbs(art20_4_rights_of_others, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art21_1_compelling_legitimate_grounds, State) :-
    implements(eu_reg_2016_679_art_21_1),
    exception_limbs(art21_1_compelling_legitimate_grounds, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art21_1_legal_claims, State) :-
    implements(eu_reg_2016_679_art_21_1),
    exception_limbs(art21_1_legal_claims, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art21_6_public_interest_task, State) :-
    implements(eu_reg_2016_679_art_21_6),
    exception_limbs(art21_6_public_interest_task, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art22_2_a, State) :-
    implements(eu_reg_2016_679_art_22_2_a),
    exception_limbs(art22_2_a, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art22_2_b, State) :-
    implements(eu_reg_2016_679_art_22_2_b),
    exception_limbs(art22_2_b, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art22_2_c, State) :-
    implements(eu_reg_2016_679_art_22_2_c),
    exception_limbs(art22_2_c, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art12_5_manifestly_unfounded_or_excessive, State) :-
    implements(eu_reg_2016_679_art_12_5),
    exception_limbs(art12_5_manifestly_unfounded_or_excessive, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art12_2_unable_to_identify, State) :-
    implements(eu_reg_2016_679_art_12_2),
    exception_limbs(art12_2_unable_to_identify, Limbs),
    limbs_state(Profile, Limbs, State).
exception_state(Profile, art23_legislative_restriction, State) :-
    implements(eu_reg_2016_679_art_23_1),
    exception_limbs(art23_legislative_restriction, Limbs),
    limbs_state(Profile, Limbs, State).

suspension_state(Profile, State) :-
    implements(eu_reg_2016_679_art_12_6),
    suspension_limbs(Limbs),
    limbs_state(Profile, Limbs, State).

exception_conditions(art22_2_a, [human_intervention, express_point_of_view, contest_decision]) :-
    implements(eu_reg_2016_679_art_22_3).
exception_conditions(art22_2_c, [human_intervention, express_point_of_view, contest_decision]) :-
    implements(eu_reg_2016_679_art_22_3).
exception_conditions(art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged]) :-
    implements(eu_reg_2016_679_art_12_5).
exception_conditions(art20_3_public_task, []).
exception_conditions(art20_4_rights_of_others, []).
exception_conditions(art21_1_compelling_legitimate_grounds, []).
exception_conditions(art21_1_legal_claims, []).
exception_conditions(art21_6_public_interest_task, []).
exception_conditions(art22_2_b, []).
exception_conditions(art12_2_unable_to_identify, []).
exception_conditions(art23_legislative_restriction, []).

outside_scope_type(access).
outside_scope_type(rectification).
outside_scope_type(erasure).
outside_scope_type(restriction).

route(Profile, no_request_type) :-
    profile_lacks(Profile, request_type).
route(Profile, portability) :-
    profile_get(Profile, request_type, portability).
route(Profile, automated_decision) :-
    profile_get(Profile, request_type, automated_decision).
route(Profile, Route) :-
    profile_get(Profile, request_type, objection),
    objection_route(Profile, Route).
route(Profile, outside_scope) :-
    profile_get(Profile, request_type, RequestType),
    outside_scope_type(RequestType).

objection_route(Profile, no_ground) :-
    profile_lacks(Profile, objection_ground_claimed).
objection_route(Profile, art21_1) :-
    profile_get(Profile, objection_ground_claimed, art21_1).
objection_route(Profile, art21_2) :-
    profile_get(Profile, objection_ground_claimed, art21_2).
objection_route(Profile, art21_6) :-
    profile_get(Profile, objection_ground_claimed, art21_6).

lead_pairs(portability, [request_type - portability]).
lead_pairs(automated_decision, [request_type - automated_decision]).
lead_pairs(art21_1, [request_type - objection, objection_ground_claimed - art21_1]).
lead_pairs(art21_2, [request_type - objection, objection_ground_claimed - art21_2]).
lead_pairs(art21_6, [request_type - objection, objection_ground_claimed - art21_6]).

request_exception_full_verdict(Profile, Verdict) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, Problems),
    dispatch_problems(Problems, Profile, Verdict).

dispatch_problems([Problem|Problems], _, gdpr_data_subject_request_verdict(input_problems([Problem|Problems]), none, none, [], [])).
dispatch_problems([], Profile, Verdict) :-
    route(Profile, Route),
    decide_route(Route, Profile, Verdict).

decide_route(no_request_type, _, gdpr_data_subject_request_verdict(indeterminate([request_type]), none, none, [], [])).
decide_route(no_ground, _, gdpr_data_subject_request_verdict(indeterminate([objection_ground_claimed]), none, none, [], [])).
decide_route(outside_scope, _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).
decide_route(Route, Profile, Verdict) :-
    basis_row(Route, Basis, _),
    engagement_state(Profile, Route, EngagementState),
    engagement_limbs(Route, EngagementLimbs),
    exception_ids(Route, ExceptionIds),
    exception_entries(Profile, ExceptionIds, ExceptionEntries),
    suspension_state(Profile, SuspensionState),
    suspension_limbs(SuspensionLimbs),
    first_met(ExceptionEntries, Found),
    step_engagement(EngagementState, Found, SuspensionState, assembly(Route, Basis, [entry(engagement, EngagementLimbs, EngagementState), entry(suspension, SuspensionLimbs, SuspensionState)|ExceptionEntries], Profile), Verdict).

exception_ids(Route, ExceptionIds) :-
    route_exceptions(Route, Specific),
    common_exceptions(Common),
    append(Specific, Common, ExceptionIds).

exception_entries(_, [], []).
exception_entries(Profile, [ExceptionId|ExceptionIds], [entry(ExceptionId, Limbs, State)|Rest]) :-
    exception_state(Profile, ExceptionId, State),
    exception_limbs(ExceptionId, Limbs),
    exception_entries(Profile, ExceptionIds, Rest).

first_met([], none_met).
first_met([entry(ExceptionId, _, met)|_], found(ExceptionId)).
first_met([entry(_, _, unmet)|Rest], Result) :-
    first_met(Rest, Result).
first_met([entry(_, _, open(_, _))|Rest], Result) :-
    first_met(Rest, Result).

step_engagement(unmet, _, _, _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).
step_engagement(met, Found, SuspensionState, Assembly, Verdict) :-
    step_exception(Found, met, SuspensionState, Assembly, Verdict).
step_engagement(open(AbsentKeys, UnsureKeys), Found, SuspensionState, Assembly, Verdict) :-
    step_exception(Found, open(AbsentKeys, UnsureKeys), SuspensionState, Assembly, Verdict).

step_exception(found(ExceptionId), EngagementState, _, assembly(Route, Basis, _, _), gdpr_data_subject_request_verdict(need_not_comply, BasisOut, ExceptionId, Conditions, Citations)) :-
    basis_when(EngagementState, Basis, BasisOut),
    exception_conditions(ExceptionId, Conditions),
    exception_citation(ExceptionId, cite(ExceptionKey)),
    basis_citation_keys(BasisOut, Route, BasisKeys),
    append(BasisKeys, [ExceptionKey], Citations).
step_exception(none_met, _, SuspensionState, Assembly, Verdict) :-
    step_suspension(SuspensionState, Assembly, Verdict).

basis_when(met, Basis, Basis).
basis_when(open(_, _), _, none).

basis_citation_keys(none, _, []).
basis_citation_keys(Basis, Route, [Key]) :-
    basis_row(Route, Basis, cite(Key)).

step_suspension(met, _, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
step_suspension(unmet, Assembly, Verdict) :-
    step_open(Assembly, Verdict).
step_suspension(open(_, _), Assembly, Verdict) :-
    step_open(Assembly, Verdict).

step_open(assembly(Route, Basis, Entries, Profile), Verdict) :-
    collect_open(Entries, AbsentKeys, UnsureKeys, ReadKeys),
    missing_key_order(MissingOrder),
    judgement_key_order(JudgementOrder),
    keys_in_order(MissingOrder, AbsentKeys, SortedAbsent),
    keys_in_order(JudgementOrder, UnsureKeys, SortedUnsure),
    keys_in_order(JudgementOrder, ReadKeys, SortedRead),
    finish(SortedAbsent, SortedUnsure, Route, Basis, SortedRead, Profile, Verdict).

collect_open([], [], [], []).
collect_open([entry(_, _, met)|Entries], AbsentKeys, UnsureKeys, ReadKeys) :-
    collect_open(Entries, AbsentKeys, UnsureKeys, ReadKeys).
collect_open([entry(_, _, unmet)|Entries], AbsentKeys, UnsureKeys, ReadKeys) :-
    collect_open(Entries, AbsentKeys, UnsureKeys, ReadKeys).
collect_open([entry(_, Limbs, open(OwnAbsent, OwnUnsure))|Entries], AbsentKeys, UnsureKeys, ReadKeys) :-
    collect_open(Entries, RestAbsent, RestUnsure, RestRead),
    limbs_keys(Limbs, OwnRead),
    append(OwnAbsent, RestAbsent, AbsentKeys),
    append(OwnUnsure, RestUnsure, UnsureKeys),
    append(OwnRead, RestRead, ReadKeys).

keys_in_order([], _, []).
keys_in_order([Key|Keys], Wanted, Sorted) :-
    memberd_t(Key, Wanted, Truth),
    keys_in_order(Keys, Wanted, Rest),
    keep_key(Truth, Key, Rest, Sorted).

keep_key(true, Key, Rest, [Key|Rest]).
keep_key(false, _, Rest, Rest).

finish([Key|Keys], _, _, _, _, _, gdpr_data_subject_request_verdict(indeterminate([Key|Keys]), none, none, [], [])).
finish([], [Key|_], Route, _, ReadKeys, Profile, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), none, none, [], [])) :-
    referral_citation(Key, Route, Citation),
    lead_pairs(Route, LeadPairs),
    judgement_pairs(Profile, ReadKeys, JudgementPairs),
    append(LeadPairs, JudgementPairs, Pairs).
finish([], [], Route, Basis, _, _, gdpr_data_subject_request_verdict(must_comply, Basis, none, [], Citations)) :-
    basis_citation_keys(Basis, Route, Citations).

judgement_pairs(_, [], []).
judgement_pairs(Profile, [Key|Keys], [Key - Value|Pairs]) :-
    profile_get(Profile, Key, Value),
    judgement_pairs(Profile, Keys, Pairs).
judgement_pairs(Profile, [Key|Keys], Pairs) :-
    profile_lacks(Profile, Key),
    judgement_pairs(Profile, Keys, Pairs).

decide_request_exception(Profile, request_exception_verdict(Exception, Citations)) :-
    request_exception_full_verdict(Profile, gdpr_data_subject_request_verdict(_, _, Exception, _, Keys)),
    maplist(cite_term, Keys, Citations).

cite_term(Key, cite(Key)).

request_exception_status(Profile, Status) :-
    decide_request_exception(Profile, request_exception_verdict(Status, _Citations)).

request_exception_decision_resolvable(Profile) :-
    decide_request_exception(Profile, _Verdict).

request_exception_checklist(Profile, Items) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, Problems),
    checklist_for(Problems, Profile, Items).

checklist_for([_|_], _, []).
checklist_for([], Profile, Items) :-
    route(Profile, Route),
    route_items(Route, Profile, Items).

route_items(Route, _, []) :-
    non_engaged_route(Route).
route_items(Route, Profile, [EngagementItem, SuspensionItem|ExceptionItems]) :-
    basis_row(Route, _, EngagementCitation),
    engagement_state(Profile, Route, EngagementState),
    suspension_state(Profile, SuspensionState),
    exception_ids(Route, ExceptionIds),
    exception_entries(Profile, ExceptionIds, Entries),
    state_item(engagement, EngagementCitation, EngagementState, EngagementItem),
    state_item(suspension, cite(eu_reg_2016_679_art_12_6), SuspensionState, SuspensionItem),
    entry_items(Entries, ExceptionItems).

entry_items([], []).
entry_items([entry(ExceptionId, _, State)|Entries], [Item|Items]) :-
    exception_citation(ExceptionId, Citation),
    state_item(ExceptionId, Citation, State, Item),
    entry_items(Entries, Items).

state_item(ItemId, Citation, met, item(ItemId, met, Citation)).
state_item(ItemId, Citation, unmet, item(ItemId, unmet(not_satisfied), Citation)).
state_item(ItemId, Citation, open([Key|Keys], _), item(ItemId, unknown([Key|Keys]), Citation)).
state_item(ItemId, Citation, open([], UnsureKeys), item(ItemId, unknown(UnsureKeys), Citation)).

test(portability_engaged_must_comply) :-
    request_exception_full_verdict([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)], gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [eu_reg_2016_679_art_20_1])).
test(portability_public_task_exception) :-
    request_exception_full_verdict([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(processing_necessary_for_public_task_or_official_authority, true)], gdpr_data_subject_request_verdict(need_not_comply, art20_1, art20_3_public_task, [], [eu_reg_2016_679_art_20_1, eu_reg_2016_679_art_20_3])).
test(portability_exception_projection) :-
    request_exception_status([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(processing_necessary_for_public_task_or_official_authority, true)], art20_3_public_task).
test(portability_not_engaged) :-
    request_exception_full_verdict([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, false)], gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).
test(manifestly_excessive_carries_fee_condition) :-
    request_exception_full_verdict([attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true), attribute(request_manifestly_unfounded_or_excessive, true)], gdpr_data_subject_request_verdict(need_not_comply, art21_2, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [eu_reg_2016_679_art_21_2, eu_reg_2016_679_art_12_5])).
test(direct_marketing_objection_is_absolute) :-
    request_exception_full_verdict([attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true)], gdpr_data_subject_request_verdict(must_comply, art21_2, none, [], [eu_reg_2016_679_art_21_2])).
test(automated_decision_missing_keys) :-
    request_exception_full_verdict([attribute(request_type, automated_decision)], gdpr_data_subject_request_verdict(indeterminate([decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects]), none, none, [], [])).
test(unsure_judgement_is_referred) :-
    request_exception_full_verdict([attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, unsure)], gdpr_data_subject_request_verdict(needs_legal_review(open_textured(objection_grounds_relate_to_particular_situation, cite(eu_reg_2016_679_art_21_1)), [inputs_relied_on([request_type - objection, objection_ground_claimed - art21_1, objection_grounds_relate_to_particular_situation - unsure])]), none, none, [], [])).
test(unconfirmed_identity_suspends) :-
    request_exception_full_verdict([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)], gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
test(unknown_key_is_an_input_problem) :-
    request_exception_full_verdict([attribute(not_a_contract_key, true)], gdpr_data_subject_request_verdict(input_problems([unknown_key(not_a_contract_key)]), none, none, [], [])).
test(consent_exception_carries_safeguards) :-
    request_exception_full_verdict([attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true), attribute(data_subject_gave_explicit_consent, true)], gdpr_data_subject_request_verdict(need_not_comply, art22_1, art22_2_c, [human_intervention, express_point_of_view, contest_decision], [eu_reg_2016_679_art_22_1, eu_reg_2016_679_art_22_2_c])).
test(special_category_bar_removes_consent_exception) :-
    request_exception_full_verdict([attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true), attribute(data_subject_gave_explicit_consent, true), attribute(decision_based_on_special_categories, true), attribute(special_category_condition_and_safeguards_met_for_decision, false)], gdpr_data_subject_request_verdict(must_comply, art22_1, none, [], [eu_reg_2016_679_art_22_1])).
