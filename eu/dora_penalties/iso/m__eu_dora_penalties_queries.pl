% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_penalties_queries, [dora_penalties_profile_keys/1, dora_penalties_what_if/4, required/0, not_required_criminal_penalties/0, supervisory/0, penalty/0, extension/0, access_to_documents_and_data/0, on_site_inspections_and_investigations/0, require_corrective_and_remedial_measures/0, cease_and_desist_order/0, cessation_of_practice_or_conduct/0, measures_to_ensure_continued_compliance/0, require_data_traffic_records/0, public_notice/0, management_body_and_responsible_individuals/0, intent_or_negligence/0, materiality_gravity_and_duration/0, degree_of_responsibility/0, financial_strength/0, profits_gained_or_losses_avoided/0, losses_for_third_parties/0, cooperation_with_competent_authority/0, previous_breaches/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_dora_penalties_kernel, [dora_penalties_input_problems/2]).
:- use_module(m__eu_dora_penalties_dora_penalties, [dora_penalties_status/2]).

dora_penalties_profile_keys([breach_subject_to_criminal_penalties_under_national_law, member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, member_state_laid_down_criminal_penalties_for_breaches, national_law_permits_requiring_data_traffic_records, measures_applied_to_legal_person, decision_imposes_art_50_2_c_measure, breach_materiality_gravity_duration_relevant, degree_of_responsibility_relevant, financial_strength_relevant, profits_gained_or_losses_avoided_relevant, third_party_losses_relevant, cooperation_with_authority_relevant, previous_breaches_relevant]).

required.

not_required_criminal_penalties.

supervisory.

penalty.

extension.

access_to_documents_and_data.

on_site_inspections_and_investigations.

require_corrective_and_remedial_measures.

cease_and_desist_order.

cessation_of_practice_or_conduct.

measures_to_ensure_continued_compliance.

require_data_traffic_records.

public_notice.

management_body_and_responsible_individuals.

intent_or_negligence.

materiality_gravity_and_duration.

degree_of_responsibility.

financial_strength.

profits_gained_or_losses_avoided.

losses_for_third_parties.

cooperation_with_competent_authority.

previous_breaches.

dora_penalties_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    clausal_is_list(Profile),
    replace_attribute(Profile, OverriddenKey, NewValue, Kept, Found),
    with_override(Found, Kept, OverriddenKey, NewValue, Hypothesis),
    dora_penalties_status(Hypothesis, NewStatus).

replace_attribute([], _, _, [], none).
replace_attribute([Element|Elements], AttributeKey, Value, [Element|NewElements], Found) :-
    var(Element),
    replace_attribute(Elements, AttributeKey, Value, NewElements, Found).
replace_attribute([Element|Elements], AttributeKey, Value, [Element|NewElements], Found) :-
    nonvar(Element),
    Element \= attribute(_, _),
    replace_attribute(Elements, AttributeKey, Value, NewElements, Found).
replace_attribute([Element|Elements], AttributeKey, Value, [attribute(AttributeKey, Value)|NewElements], found) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == AttributeKey,
    drop_attribute(Elements, AttributeKey, NewElements).
replace_attribute([Element|Elements], AttributeKey, Value, [Element|NewElements], Found) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== AttributeKey,
    replace_attribute(Elements, AttributeKey, Value, NewElements, Found).

drop_attribute([], _, []).
drop_attribute([Element|Elements], AttributeKey, [Element|Kept]) :-
    var(Element),
    drop_attribute(Elements, AttributeKey, Kept).
drop_attribute([Element|Elements], AttributeKey, [Element|Kept]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    drop_attribute(Elements, AttributeKey, Kept).
drop_attribute([Element|Elements], AttributeKey, Kept) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == AttributeKey,
    drop_attribute(Elements, AttributeKey, Kept).
drop_attribute([Element|Elements], AttributeKey, [Element|Kept]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== AttributeKey,
    drop_attribute(Elements, AttributeKey, Kept).

with_override(found, Kept, _, _, Kept).
with_override(none, Kept, AttributeKey, Value, Hypothesis) :-
    append(Kept, [attribute(AttributeKey, Value)], Hypothesis).
