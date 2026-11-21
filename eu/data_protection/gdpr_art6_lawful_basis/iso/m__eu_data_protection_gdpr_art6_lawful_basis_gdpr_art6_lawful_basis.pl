% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, decide_gdpr_art6_lawful_basis/2, gdpr_art6_lawful_basis_status/2, gdpr_art6_lawful_basis_checklist/2, gdpr_art6_lawful_basis_decision_resolvable/1, gdpr_art6_lawful_basis_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2, gdpr_art6_lawful_basis_root_keys/1]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_citations, [implements/1, gdpr_art6_lawful_basis_outside_fact_entry/3, gdpr_art6_lawful_basis_referable/1]).

gdpr_art6_lawful_basis_status_values([eligible, ineligible]).

lawful_basis_way(way_a, consent, cite(eu_reg_2016_679_art_6_1_a)).
lawful_basis_way(way_b, contract, cite(eu_reg_2016_679_art_6_1_b)).
lawful_basis_way(way_c, legal_obligation, cite(eu_reg_2016_679_art_6_1_c)).
lawful_basis_way(way_d, vital_interests, cite(eu_reg_2016_679_art_6_1_d)).
lawful_basis_way(way_e, public_interest_task, cite(eu_reg_2016_679_art_6_1_e)).
lawful_basis_way(way_f, legitimate_interests, cite(eu_reg_2016_679_art_6_1_f)).

lawful_basis_way_order([way_a, way_b, way_c, way_d, way_e, way_f]).

way_holding_citations(way_a, [cite(eu_reg_2016_679_art_6_1_a)]).
way_holding_citations(way_b, [cite(eu_reg_2016_679_art_6_1_b)]).
way_holding_citations(way_c, [cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]).
way_holding_citations(way_d, [cite(eu_reg_2016_679_art_6_1_d)]).
way_holding_citations(way_e, [cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_3)]).
way_holding_citations(way_f, [cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).

failure_extra_citation(way_c, legal_obligation_laid_down_by_law, cite(eu_reg_2016_679_art_6_3)).
failure_extra_citation(way_e, public_interest_task_laid_down_by_law, cite(eu_reg_2016_679_art_6_3)).
failure_extra_citation(way_f, processing_by_public_authority_in_its_tasks, cite(eu_reg_2016_679_art_6_1_second_subpara)).

open_textured_citation(contract_necessary, cite(eu_reg_2016_679_art_6_1_b)).
open_textured_citation(legal_obligation_necessary, cite(eu_reg_2016_679_art_6_1_c)).
open_textured_citation(vital_interests_necessary, cite(eu_reg_2016_679_art_6_1_d)).
open_textured_citation(public_interest_task_necessary, cite(eu_reg_2016_679_art_6_1_e)).
open_textured_citation(legitimate_interests_pursued, cite(eu_reg_2016_679_art_6_1_f)).
open_textured_citation(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)).

compatibility_factor(link_between_purposes_taken_into_account, cite(eu_reg_2016_679_art_6_4_a)).
compatibility_factor(collection_context_taken_into_account, cite(eu_reg_2016_679_art_6_4_b)).
compatibility_factor(nature_of_data_taken_into_account, cite(eu_reg_2016_679_art_6_4_c)).
compatibility_factor(possible_consequences_taken_into_account, cite(eu_reg_2016_679_art_6_4_d)).
compatibility_factor(appropriate_safeguards_taken_into_account, cite(eu_reg_2016_679_art_6_4_e)).

way_requirements(way_a, [consent_given_and_conditions_met - attested_true]) :-
    implements(eu_reg_2016_679_art_6_1_a).
way_requirements(way_b, [contract_necessary - true]) :-
    implements(eu_reg_2016_679_art_6_1_b).
way_requirements(way_c, [legal_obligation_necessary - true, legal_obligation_laid_down_by_law - attested_true]) :-
    implements(eu_reg_2016_679_art_6_1_c),
    implements(eu_reg_2016_679_art_6_3).
way_requirements(way_d, [vital_interests_necessary - true]) :-
    implements(eu_reg_2016_679_art_6_1_d).
way_requirements(way_e, [public_interest_task_necessary - true, public_interest_task_laid_down_by_law - attested_true]) :-
    implements(eu_reg_2016_679_art_6_1_e),
    implements(eu_reg_2016_679_art_6_3).
way_requirements(way_f, [processing_by_public_authority_in_its_tasks - false, legitimate_interests_pursued - true, interests_overridden - false]) :-
    implements(eu_reg_2016_679_art_6_1_f),
    implements(eu_reg_2016_679_art_6_1_second_subpara).

needed_value_kind(true, caller_key).
needed_value_kind(false, caller_key).
needed_value_kind(attested_true, outside_fact).

key_reading(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_reading(Profile, ProfileKey, given(Value)) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, Value).

requirement_state(true, given(true), satisfied).
requirement_state(true, given(false), opposed).
requirement_state(true, given(unsure), unsure).
requirement_state(false, given(false), satisfied).
requirement_state(false, given(true), opposed).
requirement_state(false, given(unsure), unsure).
requirement_state(attested_true, given(attested(true, _)), satisfied).
requirement_state(attested_true, given(attested(false, _)), opposed).
requirement_state(_, absent, absent).

unresolved_state(absent).
unresolved_state(unsure).

ordered_by_root(Candidates, Ordered) :-
    gdpr_art6_lawful_basis_root_keys(RootKeys),
    findall(RootKey, (member(RootKey, RootKeys), memberd_t(RootKey, Candidates, true)), Ordered).

first_in_root_order(Candidates, FirstKey) :-
    gdpr_art6_lawful_basis_root_keys(RootKeys),
    first_listed(RootKeys, Candidates, FirstKey).

first_listed([RootKey|RootKeys], Candidates, FirstKey) :-
    memberd_t(RootKey, Candidates, Truth),
    first_listed_by(Truth, RootKey, RootKeys, Candidates, FirstKey).

first_listed_by(true, RootKey, _, _, RootKey).
first_listed_by(false, _, RootKeys, Candidates, FirstKey) :-
    first_listed(RootKeys, Candidates, FirstKey).

considered_ways(Profile, AllWays) :-
    implements(eu_reg_2016_679_art_6_1),
    key_reading(Profile, basis_claimed, absent),
    lawful_basis_way_order(AllWays).
considered_ways(Profile, [WayIdentifier]) :-
    implements(eu_reg_2016_679_art_6_1),
    key_reading(Profile, basis_claimed, given(ClaimedBasis)),
    lawful_basis_way(WayIdentifier, ClaimedBasis, _).

way_evaluation(Profile, WayIdentifier, WayIdentifier - WayStatus) :-
    implements(eu_reg_2016_679_art_6_1),
    way_requirements(WayIdentifier, Requirements),
    maplist(requirement_reading(Profile), Requirements, States),
    way_status_from_states(States, WayStatus).

requirement_reading(Profile, ProfileKey - NeededValue, state(ProfileKey, NeededValue, KeyState)) :-
    key_reading(Profile, ProfileKey, Reading),
    requirement_state(NeededValue, Reading, KeyState).

way_status_from_states(States, WayStatus) :-
    findall(ProfileKey, member(state(ProfileKey, _, opposed), States), OpposedKeys),
    findall(unresolved(ProfileKey, NeededValue, KeyState), (member(state(ProfileKey, NeededValue, KeyState), States), unresolved_state(KeyState)), Unresolved),
    status_from_keys(OpposedKeys, Unresolved, WayStatus).

status_from_keys([], [], holds).
status_from_keys([FirstKey|OtherKeys], _, fails([FirstKey|OtherKeys])).
status_from_keys([], [FirstUnresolved|OtherUnresolved], open([FirstUnresolved|OtherUnresolved])).

lawful_basis_status(Profile, input_problems([FirstProblem|OtherProblems]), [], []) :-
    gdpr_art6_lawful_basis_input_problems(Profile, [FirstProblem|OtherProblems]).
lawful_basis_status(Profile, Result, Basis, Citations) :-
    gdpr_art6_lawful_basis_input_problems(Profile, []),
    considered_ways(Profile, Considered),
    maplist(way_evaluation(Profile), Considered, Evaluations),
    findall(WayIdentifier, member(WayIdentifier - holds, Evaluations), Holding),
    findall(WayIdentifier - OpposedKeys, member(WayIdentifier - fails(OpposedKeys), Evaluations), Failing),
    findall(WayIdentifier - Unresolved, member(WayIdentifier - open(Unresolved), Evaluations), OpenWays),
    decide_lawful_basis(Holding, Failing, OpenWays, Profile, Considered, Result, Basis, Citations).

decide_lawful_basis([FirstWay|OtherWays], _, _, Profile, _, eligible, Basis, Citations) :-
    implements(eu_reg_2016_679_art_6_1),
    eligible_citations([FirstWay|OtherWays], Citations),
    eligible_basis([FirstWay|OtherWays], Profile, Basis).
decide_lawful_basis([], Failing, [], Profile, _, ineligible, Basis, Citations) :-
    implements(eu_reg_2016_679_art_6_1),
    ineligible_citations(Failing, Citations),
    ineligible_basis(Failing, Profile, Basis).
decide_lawful_basis([], _, [FirstOpen|OtherOpen], Profile, Considered, Result, [], []) :-
    implements(eu_reg_2016_679_art_6_1),
    not_final_answer([FirstOpen|OtherOpen], Profile, Considered, Result).

eligible_citations(Holding, Citations) :-
    findall(Citation, (member(WayIdentifier, Holding), way_holding_citations(WayIdentifier, WayCitations), member(Citation, WayCitations)), HoldingCitations),
    sort([cite(eu_reg_2016_679_art_6_1)|HoldingCitations], Citations).

eligible_basis(Holding, Profile, Basis) :-
    findall(ProfileKey, (member(WayIdentifier, Holding), way_requirements(WayIdentifier, Requirements), member(ProfileKey - attested_true, Requirements)), OutsideKeys),
    ordered_by_root(OutsideKeys, OrderedKeys),
    findall(outside_fact(ProfileKey, Attested), (member(ProfileKey, OrderedKeys), key_reading(Profile, ProfileKey, given(Attested))), OutsideFacts),
    memberd_t(way_f, Holding, WayFHolds),
    child_flag(WayFHolds, Profile, ChildFlags),
    special_category_flag(Profile, SpecialFlags),
    append([OutsideFacts, ChildFlags, SpecialFlags], Basis).

child_flag(true, Profile, Flags) :-
    implements(eu_reg_2016_679_art_6_1_f),
    attested_true_flag(Profile, child_data_subject, Flags).
child_flag(false, _, []).

special_category_flag(Profile, Flags) :-
    implements(eu_reg_2016_679_art_9_1),
    attested_true_flag(Profile, special_category, Flags).

attested_true_flag(Profile, ProfileKey, [flagged(ProfileKey, attested(true, Attestation))]) :-
    key_reading(Profile, ProfileKey, given(attested(true, Attestation))).
attested_true_flag(Profile, ProfileKey, []) :-
    key_reading(Profile, ProfileKey, given(attested(false, _))).
attested_true_flag(Profile, ProfileKey, []) :-
    key_reading(Profile, ProfileKey, absent).

ineligible_citations(Failing, Citations) :-
    findall(Citation, (member(WayIdentifier - _, Failing), lawful_basis_way(WayIdentifier, _, Citation)), PointCitations),
    findall(Citation, (member(WayIdentifier - OpposedKeys, Failing), member(ProfileKey, OpposedKeys), failure_extra_citation(WayIdentifier, ProfileKey, Citation)), ExtraCitations),
    append(PointCitations, ExtraCitations, WayCitations),
    sort([cite(eu_reg_2016_679_art_6_1)|WayCitations], Citations).

ineligible_basis(Failing, Profile, Basis) :-
    findall(ProfileKey, (member(_ - OpposedKeys, Failing), member(ProfileKey, OpposedKeys)), AllOpposedKeys),
    ordered_by_root(AllOpposedKeys, OrderedKeys),
    findall(outside_fact(ProfileKey, attested(false, Attestation)), (member(ProfileKey, OrderedKeys), key_reading(Profile, ProfileKey, given(attested(false, Attestation)))), Basis).

not_final_answer(OpenWays, Profile, Considered, Result) :-
    findall(unresolved(ProfileKey, NeededValue), member(_ - [unresolved(ProfileKey, NeededValue, absent)], OpenWays), OneStep),
    findall(ProfileKey, (member(unresolved(ProfileKey, NeededValue), OneStep), needed_value_kind(NeededValue, caller_key)), OneStepCallerKeys),
    findall(ProfileKey, (member(unresolved(ProfileKey, NeededValue), OneStep), needed_value_kind(NeededValue, outside_fact)), OneStepOutsideKeys),
    findall(ProfileKey, (member(_ - Unresolved, OpenWays), member(unresolved(ProfileKey, NeededValue, absent), Unresolved), needed_value_kind(NeededValue, caller_key)), AbsentCallerKeys),
    findall(ProfileKey, (member(_ - Unresolved, OpenWays), member(unresolved(ProfileKey, NeededValue, absent), Unresolved), needed_value_kind(NeededValue, outside_fact)), AbsentOutsideKeys),
    findall(ProfileKey, (member(_ - Unresolved, OpenWays), member(unresolved(ProfileKey, _, unsure), Unresolved)), UnsureKeys),
    not_final_step(OneStepCallerKeys, OneStepOutsideKeys, AbsentCallerKeys, AbsentOutsideKeys, UnsureKeys, Profile, Considered, Result).

not_final_step([FirstKey|OtherKeys], _, _, _, _, _, _, indeterminate([NamedKey])) :-
    implements(eu_reg_2016_679_art_6_1),
    first_in_root_order([FirstKey|OtherKeys], NamedKey).
not_final_step([], [FirstKey|OtherKeys], _, _, _, _, _, Result) :-
    implements(eu_reg_2016_679_art_6_1),
    first_in_root_order([FirstKey|OtherKeys], ReferredKey),
    absent_referral(ReferredKey, Result).
not_final_step([], [], [FirstKey|OtherKeys], _, _, _, _, indeterminate([NamedKey])) :-
    implements(eu_reg_2016_679_art_6_1),
    first_in_root_order([FirstKey|OtherKeys], NamedKey).
not_final_step([], [], [], [FirstKey|OtherKeys], _, _, _, Result) :-
    implements(eu_reg_2016_679_art_6_1),
    first_in_root_order([FirstKey|OtherKeys], ReferredKey),
    absent_referral(ReferredKey, Result).
not_final_step([], [], [], [], [FirstKey|OtherKeys], Profile, Considered, needs_legal_review(open_textured(UnsureKey, Citation), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2016_679_art_6_1),
    first_in_root_order([FirstKey|OtherKeys], UnsureKey),
    open_textured_citation(UnsureKey, Citation),
    referral_pairs(Profile, Considered, Pairs).

absent_referral(ReferredKey, needs_legal_review(cross_reference_unresolved(Citation, cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([ReferredKey - absent])])) :-
    implements(eu_reg_2016_679_art_6_1),
    gdpr_art6_lawful_basis_referable(ReferredKey),
    gdpr_art6_lawful_basis_outside_fact_entry(ReferredKey, Citation, Target).

referral_pairs(Profile, Considered, Pairs) :-
    findall(ProfileKey, (member(WayIdentifier, Considered), way_requirements(WayIdentifier, Requirements), member(ProfileKey - _, Requirements)), WayKeys),
    memberd_t(way_f, Considered, WayFConsidered),
    child_pair_keys(WayFConsidered, ChildKeys),
    append([[basis_claimed], WayKeys, ChildKeys], RelevantKeys),
    ordered_by_root(RelevantKeys, OrderedKeys),
    findall(ProfileKey - Value, (member(ProfileKey, OrderedKeys), key_reading(Profile, ProfileKey, given(Value))), Pairs).

child_pair_keys(true, [child_data_subject]).
child_pair_keys(false, []).

purpose_compatibility(Profile, input_problems([FirstProblem|OtherProblems]), [], []) :-
    gdpr_art6_lawful_basis_input_problems(Profile, [FirstProblem|OtherProblems]).
purpose_compatibility(Profile, Result, Basis, Citations) :-
    gdpr_art6_lawful_basis_input_problems(Profile, []),
    key_reading(Profile, new_purpose_processing, Reading),
    compatibility_from_new_purpose(Reading, Profile, Result, Basis, Citations).

compatibility_from_new_purpose(absent, _, indeterminate([new_purpose_processing]), [], []) :-
    implements(eu_reg_2016_679_art_6_4).
compatibility_from_new_purpose(given(false), _, compatibility_test_not_engaged, [], [cite(eu_reg_2016_679_art_6_4)]) :-
    implements(eu_reg_2016_679_art_6_4).
compatibility_from_new_purpose(given(true), Profile, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_6_4),
    factors_not_taken_into_account(Profile, FalseFactors),
    compatibility_after_factors(FalseFactors, Profile, Result, Basis, Citations).

factors_not_taken_into_account(Profile, FalseFactors) :-
    implements(eu_reg_2016_679_art_6_4),
    findall(FactorKey, (compatibility_factor(FactorKey, _), key_reading(Profile, FactorKey, given(false))), FalseFactors).

compatibility_after_factors([_|_], _, compatibility_not_ascertained, [], [cite(eu_reg_2016_679_art_6_4), cite(eu_reg_2016_679_art_6_4_a), cite(eu_reg_2016_679_art_6_4_b), cite(eu_reg_2016_679_art_6_4_c), cite(eu_reg_2016_679_art_6_4_d), cite(eu_reg_2016_679_art_6_4_e)]) :-
    implements(eu_reg_2016_679_art_6_4).
compatibility_after_factors([], Profile, Result, Basis, Citations) :-
    implements(eu_reg_2016_679_art_6_4),
    key_reading(Profile, compatible_purpose, Reading),
    compatibility_judgement(Reading, Result, Basis, Citations).

compatibility_judgement(given(true), purpose_compatible, [], [cite(eu_reg_2016_679_art_6_4)]) :-
    implements(eu_reg_2016_679_art_6_4).
compatibility_judgement(given(false), purpose_not_compatible, [], [cite(eu_reg_2016_679_art_6_4)]) :-
    implements(eu_reg_2016_679_art_6_4).
compatibility_judgement(absent, indeterminate([compatible_purpose]), [], []) :-
    implements(eu_reg_2016_679_art_6_4).
compatibility_judgement(given(unsure), needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing - true, compatible_purpose - unsure])]), [], []) :-
    implements(eu_reg_2016_679_art_6_4).

decide_gdpr_art6_lawful_basis(Profile, gdpr_art6_lawful_basis_verdict(Status, Citations)) :-
    lawful_basis_status(Profile, Status, _, Citations).

gdpr_art6_lawful_basis_status(Profile, Status) :-
    decide_gdpr_art6_lawful_basis(Profile, gdpr_art6_lawful_basis_verdict(Status, _)).

gdpr_art6_lawful_basis_checklist(Profile, [item(overall, input_problems([FirstProblem|OtherProblems]), cite(eu_reg_2016_679_art_6_1))]) :-
    gdpr_art6_lawful_basis_input_problems(Profile, [FirstProblem|OtherProblems]).
gdpr_art6_lawful_basis_checklist(Profile, Items) :-
    gdpr_art6_lawful_basis_input_problems(Profile, []),
    considered_ways(Profile, Considered),
    maplist(way_evaluation(Profile), Considered, Evaluations),
    maplist(checklist_item, Evaluations, Items).

checklist_item(WayIdentifier - holds, item(WayIdentifier, met, Citation)) :-
    lawful_basis_way(WayIdentifier, _, Citation).
checklist_item(WayIdentifier - fails(OpposedKeys), item(WayIdentifier, unmet(failing_keys(OpposedKeys)), Citation)) :-
    lawful_basis_way(WayIdentifier, _, Citation).
checklist_item(WayIdentifier - open(Unresolved), item(WayIdentifier, unknown(UnresolvedKeys), Citation)) :-
    lawful_basis_way(WayIdentifier, _, Citation),
    findall(ProfileKey, member(unresolved(ProfileKey, _, _), Unresolved), UnresolvedKeys).

gdpr_art6_lawful_basis_decision_resolvable(Profile) :-
    decide_gdpr_art6_lawful_basis(Profile, _).

test(empty_profile_names_contract_necessary_first) :-
    lawful_basis_status([], Result, Basis, Citations),
    Result == indeterminate([contract_necessary]),
    Basis == [],
    Citations == [].
test(empty_profile_gives_exactly_one_solution) :-
    findall(Result, lawful_basis_status([], Result, _, _), Results),
    length(Results, 1).
test(contract_necessary_true_is_eligible) :-
    lawful_basis_status([attribute(contract_necessary, true)], eligible, Basis, Citations),
    Basis == [],
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)].
test(claimed_consent_absent_is_referred) :-
    gdpr_art6_lawful_basis_outside_fact_entry(consent_given_and_conditions_met, Citation, Target),
    Citation == cite(eu_reg_2016_679_art_6_1_a),
    Target == consent_basis_statement,
    lawful_basis_status([attribute(basis_claimed, consent)], Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(Citation, cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])]).
test(claimed_legal_obligation_without_law_statement_is_referred) :-
    gdpr_art6_lawful_basis_outside_fact_entry(legal_obligation_laid_down_by_law, Citation, Target),
    Citation == cite(eu_reg_2016_679_art_6_3),
    Target == legal_obligation_law_statement,
    lawful_basis_status([attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true)], Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(Citation, cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([legal_obligation_laid_down_by_law - absent])]).
test(legal_obligation_with_law_statement_is_eligible) :-
    lawful_basis_status([attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true), attribute(legal_obligation_laid_down_by_law, attested(true, attestation(host, stated_at, law_named, none)))], eligible, Basis, Citations),
    Basis == [outside_fact(legal_obligation_laid_down_by_law, attested(true, attestation(host, stated_at, law_named, none)))],
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)].
test(public_authority_cannot_rely_on_legitimate_interests) :-
    lawful_basis_status([attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, true)], ineligible, Basis, Citations),
    Basis == [],
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)].
test(unsure_balance_goes_to_a_lawyer_with_the_child_pair) :-
    lawful_basis_status([attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, unsure), attribute(child_data_subject, attested(true, attestation(host, stated_at, age_given, none)))], Result, [], []),
    Result == needs_legal_review(open_textured(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)), [inputs_relied_on([basis_claimed - legitimate_interests, processing_by_public_authority_in_its_tasks - false, legitimate_interests_pursued - true, interests_overridden - unsure, child_data_subject - attested(true, attestation(host, stated_at, age_given, none))])]).
test(legitimate_interests_holding_flags_the_child) :-
    lawful_basis_status([attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false), attribute(child_data_subject, attested(true, attestation(host, stated_at, age_given, none)))], eligible, Basis, _),
    Basis == [flagged(child_data_subject, attested(true, attestation(host, stated_at, age_given, none)))].
test(consent_eligible_copies_statement_and_flags_special_category) :-
    lawful_basis_status([attribute(consent_given_and_conditions_met, attested(true, attestation(host, stated_at, consent_package, none))), attribute(special_category, attested(true, attestation(host, stated_at, health_data, none)))], eligible, Basis, Citations),
    Basis == [outside_fact(consent_given_and_conditions_met, attested(true, attestation(host, stated_at, consent_package, none))), flagged(special_category, attested(true, attestation(host, stated_at, health_data, none)))],
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a)].
test(every_way_failing_is_ineligible) :-
    lawful_basis_status([attribute(consent_given_and_conditions_met, attested(false, attestation(host, stated_at, no_consent, none))), attribute(contract_necessary, false), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, false), attribute(legitimate_interests_pursued, false)], ineligible, Basis, Citations),
    Basis == [outside_fact(consent_given_and_conditions_met, attested(false, attestation(host, stated_at, no_consent, none)))],
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a), cite(eu_reg_2016_679_art_6_1_b), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_1_d), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_1_f)].
test(one_step_outside_fact_is_referred_before_unsure) :-
    gdpr_art6_lawful_basis_outside_fact_entry(consent_given_and_conditions_met, Citation, Target),
    lawful_basis_status([attribute(contract_necessary, unsure), attribute(legal_obligation_necessary, true), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, false), attribute(legitimate_interests_pursued, false)], Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(Citation, cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])]).
test(only_unsure_contract_left_goes_to_a_lawyer) :-
    lawful_basis_status([attribute(consent_given_and_conditions_met, attested(false, attestation(host, stated_at, no_consent, none))), attribute(contract_necessary, unsure), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, false), attribute(legitimate_interests_pursued, false)], Result, [], []),
    Result == needs_legal_review(open_textured(contract_necessary, cite(eu_reg_2016_679_art_6_1_b)), [inputs_relied_on([consent_given_and_conditions_met - attested(false, attestation(host, stated_at, no_consent, none)), contract_necessary - unsure, legal_obligation_necessary - false, vital_interests_necessary - false, public_interest_task_necessary - false, legitimate_interests_pursued - false])]).
test(unknown_key_gives_input_problems) :-
    lawful_basis_status([attribute(colour, blue)], Result, [], []),
    Result == input_problems([unknown_key(colour)]).
test(purpose_new_purpose_absent_is_named) :-
    purpose_compatibility([], indeterminate([new_purpose_processing]), [], []).
test(purpose_test_not_engaged) :-
    purpose_compatibility([attribute(new_purpose_processing, false)], compatibility_test_not_engaged, [], [cite(eu_reg_2016_679_art_6_4)]).
test(purpose_compatible_with_absent_factors) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(compatible_purpose, true)], purpose_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
test(purpose_not_compatible) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(compatible_purpose, false)], purpose_not_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
test(purpose_factor_left_out_is_not_ascertained) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(compatible_purpose, true), attribute(nature_of_data_taken_into_account, false)], compatibility_not_ascertained, [], Citations),
    length(Citations, 6).
test(purpose_compatible_judgement_absent_is_named) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(link_between_purposes_taken_into_account, true)], indeterminate([compatible_purpose]), [], []).
test(purpose_unsure_goes_to_a_lawyer) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(compatible_purpose, unsure)], Result, [], []),
    Result == needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing - true, compatible_purpose - unsure])]).
test(purpose_gives_exactly_one_solution) :-
    findall(Result, purpose_compatibility([attribute(new_purpose_processing, true)], Result, _, _), Results),
    length(Results, 1).
test(checklist_for_claimed_contract) :-
    gdpr_art6_lawful_basis_checklist([attribute(basis_claimed, contract), attribute(contract_necessary, true)], Items),
    Items == [item(way_b, met, cite(eu_reg_2016_679_art_6_1_b))].
test(facade_projects_the_status) :-
    gdpr_art6_lawful_basis_status([attribute(vital_interests_necessary, true)], eligible).

test(contract_necessary_true_is_not_ineligible, fail) :-
    lawful_basis_status([attribute(contract_necessary, true)], ineligible, _, _).
test(public_authority_is_not_eligible_on_legitimate_interests, fail) :-
    lawful_basis_status([attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, true)], eligible, _, _).
test(purpose_factor_left_out_is_not_compatible_answer, fail) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(compatible_purpose, true), attribute(nature_of_data_taken_into_account, false)], purpose_compatible, _, _).
