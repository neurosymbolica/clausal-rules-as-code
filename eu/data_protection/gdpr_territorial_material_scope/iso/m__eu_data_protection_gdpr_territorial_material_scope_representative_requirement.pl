% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_representative_requirement, [decide_representative_requirement/2, representative_requirement_status/2, representative_requirement_checklist/2, representative_requirement_decision_resolvable/1, representative_requirement_status_values/1, representative_requirement/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_kernel, [gdpr_territorial_material_scope_input_problems/2, scope_key_order/1, judgement_citation/2, reading/3, negated/2, all_status/2, either_status/3, limb_status/3, stage_statuses/4, limbs_absent_keys/3, absent_keys/3, ordered_members/3, checklist_status/2]).

representative_requirement_status_values([required, exempt_art27_2_a, exempt_art27_2_b, not_applicable, not_reached]).

exemption_keys([occasional_processing, special_or_criminal_data_on_large_scale, unlikely_to_result_in_risk]).

representative_citations(required, [cite(eu_reg_2016_679_art_27_1)]).
representative_citations(exempt_art27_2_a, [cite(eu_reg_2016_679_art_27_1), cite(eu_reg_2016_679_art_27_2_a)]).
representative_citations(exempt_art27_2_b, [cite(eu_reg_2016_679_art_27_1), cite(eu_reg_2016_679_art_27_2_b)]).
representative_citations(not_applicable, []).
representative_citations(not_reached, []).
representative_citations(indeterminate(_), [cite(eu_reg_2016_679_art_27_1), cite(eu_reg_2016_679_art_27_2_a), cite(eu_reg_2016_679_art_27_2_b)]).
representative_citations(needs_legal_review(open_textured(_, Citation), _), [Citation]).

representative_requirement(Profile, Representative) :-
    decide_representative_requirement(Profile, representative_requirement_verdict(Representative, _Citations)).

representative_requirement_status(Profile, Status) :-
    decide_representative_requirement(Profile, representative_requirement_verdict(Status, _Citations)).

decide_representative_requirement(Profile, Verdict) :-
    gdpr_territorial_material_scope_input_problems(Profile, Problems),
    decide_given(Problems, Profile, Verdict).

decide_given([_|_], _, representative_requirement_verdict(not_reached, [])).
decide_given([], Profile, representative_requirement_verdict(Representative, Citations)) :-
    stage_statuses(Profile, One, Two, Three),
    all_status([One, Two, Three], Combined),
    representative_for(Combined, Profile, Representative),
    representative_citations(Representative, Citations).

representative_for(unmet, _, not_applicable).
representative_for(absent, _, not_reached).
representative_for(fact, _, not_reached).
representative_for(judgement, _, not_reached).
representative_for(met, Profile, Representative) :-
    implements(eu_reg_2016_679_art_27_1),
    limb_status(Profile, l32a, Offering),
    limb_status(Profile, l32b, Monitoring),
    either_status(Offering, Monitoring, Limb),
    stage_four(Limb, Profile, Offering, Monitoring, Representative).

stage_four(unmet, _, _, _, not_applicable).
stage_four(met, Profile, _, _, Representative) :-
    implements(eu_reg_2016_679_art_27_2_a),
    exemption(Profile, Representative).
stage_four(absent, Profile, _, _, indeterminate(Keys)) :-
    implements(eu_reg_2016_679_art_27_1),
    limbs_absent_keys([l32a, l32b], Profile, Collected),
    scope_key_order(Order),
    ordered_members(Order, Collected, Keys).
stage_four(judgement, Profile, Offering, Monitoring, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2016_679_art_3_2_a),
    open_input(Offering, Monitoring, Input),
    judgement_citation(Input, Citation),
    open_pair(Offering, Profile, offering_goods_or_services_to_data_subjects_in_union, OfferingPairs),
    open_pair(Monitoring, Profile, monitoring_behaviour_of_data_subjects_in_union, MonitoringPairs),
    append(OfferingPairs, MonitoringPairs, Pairs).

open_input(judgement, _, offering_goods_or_services_to_data_subjects_in_union).
open_input(Offering, judgement, monitoring_behaviour_of_data_subjects_in_union) :-
    dif(Offering, judgement).

open_pair(judgement, Profile, Key, [Key - Value]) :-
    profile_get(Profile, Key, Value).
open_pair(Status, _, _, []) :-
    dif(Status, judgement).

occasional_exemption_status(Profile, Status) :-
    implements(eu_reg_2016_679_art_27_2_a),
    reading(Profile, occasional_processing, Occasional),
    reading(Profile, special_or_criminal_data_on_large_scale, LargeScale),
    negated(LargeScale, NotLargeScale),
    reading(Profile, unlikely_to_result_in_risk, Unlikely),
    all_status([Occasional, NotLargeScale, Unlikely], Status).

public_authority_status(Profile, Status) :-
    implements(eu_reg_2016_679_art_27_2_b),
    reading(Profile, public_authority_or_body, Status).

exemption(Profile, Representative) :-
    occasional_exemption_status(Profile, Occasional),
    public_authority_status(Profile, Public),
    exemption_for(Occasional, Public, Profile, Representative).

exemption_for(met, _, _, exempt_art27_2_a).
exemption_for(Occasional, met, _, exempt_art27_2_b) :-
    dif(Occasional, met).
exemption_for(unmet, unmet, _, required).
exemption_for(absent, Public, Profile, indeterminate(Keys)) :-
    dif(Public, met),
    exemption_missing(absent, Public, Profile, Keys).
exemption_for(Occasional, absent, Profile, indeterminate(Keys)) :-
    dif(Occasional, met),
    dif(Occasional, absent),
    exemption_missing(Occasional, absent, Profile, Keys).
exemption_for(judgement, unmet, Profile, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)])) :-
    exemption_keys(Keys),
    first_unsure(Profile, Keys, Input),
    judgement_citation(Input, Citation),
    present_exemption_pairs(Profile, Keys, Pairs).

exemption_missing(Occasional, Public, Profile, Keys) :-
    occasional_absent(Occasional, Profile, OccasionalKeys),
    public_absent(Public, PublicKeys),
    append(PublicKeys, OccasionalKeys, Collected),
    scope_key_order(Order),
    ordered_members(Order, Collected, Keys).

occasional_absent(absent, Profile, Keys) :-
    exemption_keys(ExemptionKeys),
    absent_keys(Profile, ExemptionKeys, Keys).
occasional_absent(Status, _, []) :-
    dif(Status, absent).

public_absent(absent, [public_authority_or_body]).
public_absent(Status, []) :-
    dif(Status, absent).

first_unsure(Profile, [Key|Keys], Found) :-
    reading(Profile, Key, Status),
    first_unsure_step(Status, Key, Keys, Profile, Found).

first_unsure_step(judgement, Key, _, _, Key).
first_unsure_step(Status, _, Keys, Profile, Found) :-
    dif(Status, judgement),
    first_unsure(Profile, Keys, Found).

present_exemption_pairs(_, [], []).
present_exemption_pairs(Profile, [Key|Keys], Pairs) :-
    present_exemption_pair(Profile, Key, Mine),
    present_exemption_pairs(Profile, Keys, Rest),
    append(Mine, Rest, Pairs).

present_exemption_pair(Profile, Key, [Key - Value]) :-
    profile_get(Profile, Key, Value).
present_exemption_pair(Profile, Key, []) :-
    absent_keys(Profile, [Key], [Key]).

representative_requirement_checklist(Profile, Items) :-
    gdpr_territorial_material_scope_input_problems(Profile, Problems),
    checklist_given(Problems, Profile, Items).

checklist_given([_|_], _, [item(input_check, unknown, cite(eu_reg_2016_679_art_27_1))]).
checklist_given([], Profile, [item(art3_2_limb, LimbStatus, cite(eu_reg_2016_679_art_27_1)), item(exemption_art27_2_a, OccasionalStatus, cite(eu_reg_2016_679_art_27_2_a)), item(exemption_art27_2_b, PublicStatus, cite(eu_reg_2016_679_art_27_2_b))]) :-
    limb_status(Profile, l32a, Offering),
    limb_status(Profile, l32b, Monitoring),
    either_status(Offering, Monitoring, Limb),
    checklist_status(Limb, LimbStatus),
    occasional_exemption_status(Profile, Occasional),
    checklist_status(Occasional, OccasionalStatus),
    public_authority_status(Profile, Public),
    checklist_status(Public, PublicStatus).

representative_requirement_decision_resolvable(Profile) :-
    decide_representative_requirement(Profile, _Verdict).
