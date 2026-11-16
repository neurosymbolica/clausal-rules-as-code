% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order_queries, [dma_art_3_gatekeeper_order_profile_keys/1, dma_art_3_gatekeeper_order_what_if/4, dma_art_3_gatekeeper_order_eligibility/3, impact_threshold_met/0, impact_threshold_not_met/0, gateway_threshold_met/0, gateway_threshold_not_met/0, entrenchment_threshold_met/0, entrenchment_threshold_not_met/0, gatekeeper_presumed/0, gatekeeper_not_presumed/0, requirements_presumed_met/0, requirements_met/0, requirements_not_met/0, designated_gatekeeper/0, not_designated_gatekeeper/0, indeterminate/1, needs_legal_review/2, provenance/2, outside_fact/2, attested/2, url/2, document/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_kernel, [dma_art_3_gatekeeper_order_input_problems/2, dma_art_3_gatekeeper_order_contract_key/2]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_citations, [citation/2, implements/1]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_dma_art_3_gatekeeper_order, [designation_requirements_status/4, dma_art_3_gatekeeper_order_status/2, dma_art_3_gatekeeper_order_checklist/2]).

dma_art_3_gatekeeper_order_profile_keys([market_capitalisation_eur_most_recent_financial_year, member_states_where_core_platform_service_provided, union_turnover_eur_most_recent_financial_year, union_turnover_eur_second_most_recent_financial_year, union_turnover_eur_third_most_recent_financial_year, monthly_active_end_users_most_recent_financial_year, monthly_active_end_users_second_most_recent_financial_year, monthly_active_end_users_third_most_recent_financial_year, yearly_active_business_users_most_recent_financial_year, yearly_active_business_users_second_most_recent_financial_year, yearly_active_business_users_third_most_recent_financial_year, rebuttal_arguments_presented, rebuttal_accepted_by_commission, significant_impact_on_internal_market, core_platform_service_is_important_gateway, entrenched_and_durable_position, designated_as_gatekeeper_for_core_platform_service]).

impact_threshold_met.

impact_threshold_not_met.

gateway_threshold_met.

gateway_threshold_not_met.

entrenchment_threshold_met.

entrenchment_threshold_not_met.

gatekeeper_presumed.

gatekeeper_not_presumed.

requirements_presumed_met.

requirements_met.

requirements_not_met.

designated_gatekeeper.

not_designated_gatekeeper.

indeterminate([ProfileKey]) :-
    dma_art_3_gatekeeper_order_contract_key(ProfileKey, _Type).

needs_legal_review(open_textured(ProfileKey, cite(Citation)), [inputs_relied_on(Pairs)]) :-
    dma_art_3_gatekeeper_order_contract_key(ProfileKey, judgement),
    citation(Citation, _CitationRecord),
    relied_pairs(Pairs).
needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on(Pairs)]) :-
    citation(Citation, _CitationRecord),
    citation(Target, _TargetRecord),
    relied_pairs(Pairs).
needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on(Pairs), provenance(Source, Detail)]) :-
    citation(Citation, _CitationRecord),
    citation(Target, _TargetRecord),
    relied_pairs(Pairs),
    provenance(Source, Detail).

relied_pairs(Pairs) :-
    is_list(Pairs),
    maplist(relied_pair, Pairs).

relied_pair(ProfileKey - PairValue) :-
    dma_art_3_gatekeeper_order_contract_key(ProfileKey, _Type),
    ground(PairValue).

provenance(Source, Detail) :-
    atom(Source),
    ground(Detail).

outside_fact(FactKey, attested(AttestedValue, attestation(StatedBy, StatedAt, Reason, Evidence))) :-
    dma_art_3_gatekeeper_order_contract_key(FactKey, outside_fact),
    attested(AttestedValue, attestation(StatedBy, StatedAt, Reason, Evidence)).

attested(AttestedValue, attestation(StatedBy, StatedAt, Reason, Evidence)) :-
    boolean_value(AttestedValue),
    ground(attestation(StatedBy, StatedAt, Reason, Evidence)).

boolean_value(true).
boolean_value(false).

url(Address, RetrievedAt) :-
    atom(Address),
    ground(RetrievedAt).

document(UploadIdentifier, Digest) :-
    atomic(UploadIdentifier),
    atomic(Digest).

input_problems([Problem|Problems]) :-
    maplist(problem_term, [Problem|Problems]).

problem_term(unknown_key(ProfileKey)) :-
    unknown_key(ProfileKey).
problem_term(wrong_type(ProfileKey)) :-
    wrong_type(ProfileKey).
problem_term(duplicate_key(ProfileKey)) :-
    duplicate_key(ProfileKey).

unknown_key(ProfileKey) :-
    ground(ProfileKey),
    findall(ContractKey, dma_art_3_gatekeeper_order_contract_key(ContractKey, _Type), ContractKeys),
    memberd_t(ProfileKey, ContractKeys, false).

wrong_type(profile).
wrong_type(ProfileKey) :-
    dma_art_3_gatekeeper_order_contract_key(ProfileKey, _Type).

duplicate_key(ProfileKey) :-
    dma_art_3_gatekeeper_order_contract_key(ProfileKey, _Type).

dma_art_3_gatekeeper_order_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_without_key(Profile, OverriddenKey, Remainder),
    dma_art_3_gatekeeper_order_status([attribute(OverriddenKey, NewValue)|Remainder], NewStatus).

profile_without_key(Term, _, Term) :-
    var(Term).
profile_without_key(Term, _, []) :-
    Term == [].
profile_without_key(Term, _, Term) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].
profile_without_key(Term, OverriddenKey, Remainder) :-
    nonvar(Term),
    Term = [Element|Elements],
    element_key_match(Element, OverriddenKey, Matches),
    profile_without_key(Elements, OverriddenKey, LaterElements),
    keep_element(Matches, Element, LaterElements, Remainder).

element_key_match(Element, _, false) :-
    var(Element).
element_key_match(Element, OverriddenKey, true) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey.
element_key_match(Element, OverriddenKey, false) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey.
element_key_match(Element, _, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

keep_element(true, _, LaterElements, LaterElements).
keep_element(false, Element, LaterElements, [Element|LaterElements]).

dma_art_3_gatekeeper_order_eligibility(Profile, Eligibility, Checklist) :-
    designation_requirements_status(Profile, Status, _Basis, _Citations),
    status_eligibility(Status, Eligibility),
    dma_art_3_gatekeeper_order_checklist(Profile, Checklist).

status_eligibility(requirements_presumed_met, eligible) :-
    implements(eu_reg_2022_1925_art_3_2).
status_eligibility(requirements_met, eligible) :-
    implements(eu_reg_2022_1925_art_3_1).
status_eligibility(requirements_not_met, ineligible) :-
    implements(eu_reg_2022_1925_art_3_1).
status_eligibility(indeterminate(_), undetermined).
status_eligibility(needs_legal_review(_, _), undetermined).
status_eligibility(input_problems(_), undetermined).

presumed_profile([attribute(market_capitalisation_eur_most_recent_financial_year, 80000000000), attribute(member_states_where_core_platform_service_provided, 5), attribute(union_turnover_eur_most_recent_financial_year, 8000000000), attribute(union_turnover_eur_second_most_recent_financial_year, 8000000000), attribute(union_turnover_eur_third_most_recent_financial_year, 8000000000), attribute(monthly_active_end_users_most_recent_financial_year, 50000000), attribute(monthly_active_end_users_second_most_recent_financial_year, 50000000), attribute(monthly_active_end_users_third_most_recent_financial_year, 50000000), attribute(yearly_active_business_users_most_recent_financial_year, 20000), attribute(yearly_active_business_users_second_most_recent_financial_year, 20000), attribute(yearly_active_business_users_third_most_recent_financial_year, 20000), attribute(rebuttal_arguments_presented, false)]).

below_thresholds_profile([attribute(member_states_where_core_platform_service_provided, 1), attribute(significant_impact_on_internal_market, true), attribute(core_platform_service_is_important_gateway, true), attribute(entrenched_and_durable_position, false)]).

test(presumed_profile_is_eligible) :-
    presumed_profile(Profile),
    findall(Eligibility, dma_art_3_gatekeeper_order_eligibility(Profile, Eligibility, _), Answers),
    Answers == [eligible].
test(false_judgement_below_thresholds_is_ineligible) :-
    below_thresholds_profile(Profile),
    findall(Eligibility, dma_art_3_gatekeeper_order_eligibility(Profile, Eligibility, _), Answers),
    Answers == [ineligible].
test(empty_profile_is_undetermined) :-
    findall(Eligibility, dma_art_3_gatekeeper_order_eligibility([], Eligibility, _), Answers),
    Answers == [undetermined].
test(eligibility_checklist_items_are_cited) :-
    presumed_profile(Profile),
    dma_art_3_gatekeeper_order_eligibility(Profile, eligible, Checklist),
    length(Checklist, 7),
    member(item(presumption, met, cite(eu_reg_2022_1925_art_3_2)), Checklist).
test(what_if_turns_the_false_judgement_true) :-
    below_thresholds_profile(Profile),
    findall(Status, dma_art_3_gatekeeper_order_what_if(Profile, entrenched_and_durable_position, true, Status), Answers),
    Answers == [requirements_met].
test(what_if_replaces_and_never_duplicates) :-
    below_thresholds_profile(Profile),
    profile_without_key(Profile, entrenched_and_durable_position, Remainder),
    dma_art_3_gatekeeper_order_input_problems([attribute(entrenched_and_durable_position, true)|Remainder], []).
test(what_if_on_a_non_list_reports_the_profile) :-
    findall(Status, dma_art_3_gatekeeper_order_what_if(nothing, entrenched_and_durable_position, true, Status), Answers),
    Answers == [input_problems([wrong_type(profile)])].
test(profile_keys_are_seventeen) :-
    dma_art_3_gatekeeper_order_profile_keys(Keys),
    length(Keys, 17).
test(result_vocabulary_is_served) :-
    impact_threshold_met,
    gatekeeper_presumed,
    requirements_met,
    designated_gatekeeper,
    indeterminate([rebuttal_arguments_presented]),
    attested(true, attestation(host, at, reason, none)).

test(presumed_profile_is_not_ineligible, fail) :-
    presumed_profile(Profile),
    dma_art_3_gatekeeper_order_eligibility(Profile, ineligible, _).
test(a_non_contract_key_is_not_indeterminate, fail) :-
    indeterminate([colour]).
