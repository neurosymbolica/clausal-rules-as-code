% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [decide_processor_contract/2, processor_contract_status/2, contract_missing_stipulations/2, contract_checklist/2, processor_contract_outside_facts/2, decide_processor_contract_status/2, processor_contract_status_status/2, processor_contract_status_checklist/2, processor_contract_status_decision_resolvable/1, processor_contract_status_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys_values/3, pairs_keys/2]).
:- use_module(library(reif), [(=)/3]).
:- use_module(library(reif), [if_/3, memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_kernel, [gdpr_processor_contract_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_citations, [implements/1]).

processor_contract_status_status_values([eligible, ineligible, not_applicable]).

limb(contract_binding_on_processor, cite(eu_reg_2016_679_art_28_3), judgement, always).
limb(contract_governed_by_union_or_member_state_law, cite(eu_reg_2016_679_art_28_3), crisp, always).
limb(contract_in_writing, cite(eu_reg_2016_679_art_28_9), crisp, always).
limb(contract_sets_out_categories_of_data_subjects, cite(eu_reg_2016_679_art_28_3), crisp, always).
limb(contract_sets_out_controller_obligations_and_rights, cite(eu_reg_2016_679_art_28_3), crisp, always).
limb(contract_sets_out_duration, cite(eu_reg_2016_679_art_28_3), crisp, always).
limb(contract_sets_out_nature_of_processing, cite(eu_reg_2016_679_art_28_3), crisp, always).
limb(contract_sets_out_purpose_of_processing, cite(eu_reg_2016_679_art_28_3), crisp, always).
limb(contract_sets_out_subject_matter, cite(eu_reg_2016_679_art_28_3), crisp, always).
limb(contract_sets_out_type_of_personal_data, cite(eu_reg_2016_679_art_28_3), crisp, always).
limb(controller_given_opportunity_to_object, cite(eu_reg_2016_679_art_28_2), crisp, general).
limb(processor_informed_controller_of_intended_changes, cite(eu_reg_2016_679_art_28_2), crisp, general).
limb(processor_provides_sufficient_guarantees, cite(eu_reg_2016_679_art_28_1), judgement, always).
limb(stipulates_assistance_with_articles_32_to_36_obligations, cite(eu_reg_2016_679_art_28_3_f), crisp, always).
limb(stipulates_assistance_with_data_subject_requests, cite(eu_reg_2016_679_art_28_3_e), crisp, always).
limb(stipulates_conditions_for_engaging_another_processor, cite(eu_reg_2016_679_art_28_3_d), crisp, always).
limb(stipulates_confidentiality_commitment, cite(eu_reg_2016_679_art_28_3_b), crisp, always).
limb(stipulates_deletion_or_return_of_personal_data, cite(eu_reg_2016_679_art_28_3_g), crisp, always).
limb(stipulates_information_and_audit_rights, cite(eu_reg_2016_679_art_28_3_h), crisp, always).
limb(stipulates_notice_of_infringing_instruction, cite(eu_reg_2016_679_art_28_3_second_subpara), crisp, always).
limb(stipulates_processing_only_on_documented_instructions, cite(eu_reg_2016_679_art_28_3_a), crisp, always).
limb(stipulates_security_measures, cite(eu_reg_2016_679_art_28_3_c), crisp, always).
limb(subprocessor_authorisation, cite(eu_reg_2016_679_art_28_2), enumerated, engaged).
limb(subprocessor_authorisation_given_before_engagement, cite(eu_reg_2016_679_art_28_2), crisp, authorised).
limb(subprocessor_contract_governed_by_union_or_member_state_law, cite(eu_reg_2016_679_art_28_4), crisp, engaged).
limb(subprocessor_contract_in_writing, cite(eu_reg_2016_679_art_28_9), crisp, engaged).
limb(subprocessor_engaged, cite(eu_reg_2016_679_art_28_2), engaged_flag, always).
limb(subprocessor_obligations_same, cite(eu_reg_2016_679_art_28_4), judgement, engaged).
limb(subprocessor_provides_sufficient_guarantees, cite(eu_reg_2016_679_art_28_4), judgement, engaged).

value_state(crisp, true, met).
value_state(crisp, false, unmet).
value_state(crisp, absent, open_by_absence).
value_state(judgement, true, met).
value_state(judgement, false, unmet).
value_state(judgement, unsure, open_by_judgement).
value_state(judgement, absent, open_by_absence).
value_state(enumerated, specific_written, met).
value_state(enumerated, general_written, met).
value_state(enumerated, none, unmet).
value_state(enumerated, absent, open_by_absence).
value_state(engaged_flag, true, met).
value_state(engaged_flag, false, met).
value_state(engaged_flag, absent, open_by_absence).

read_key(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).
read_key(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

condition_holds_t(always, _, _, true).
condition_holds_t(engaged, true, _, true).
condition_holds_t(engaged, false, _, false).
condition_holds_t(engaged, absent, _, false).
condition_holds_t(authorised, true, Authorisation, Holds) :-
    memberd_t(Authorisation, [specific_written, general_written], Holds).
condition_holds_t(authorised, false, _, false).
condition_holds_t(authorised, absent, _, false).
condition_holds_t(general, true, Authorisation, Holds) :-
    memberd_t(Authorisation, [general_written], Holds).
condition_holds_t(general, false, _, false).
condition_holds_t(general, absent, _, false).

checklist_items(Profile, Items) :-
    implements(eu_reg_2016_679_art_28_3),
    read_key(Profile, subprocessor_engaged, Engaged),
    read_key(Profile, subprocessor_authorisation, Authorisation),
    findall(Key, limb(Key, _, _, _), Keys),
    walk_limbs(Keys, Profile, Engaged, Authorisation, Items).

walk_limbs([], _, _, _, []).
walk_limbs([Key|Keys], Profile, Engaged, Authorisation, Items) :-
    limb(Key, Citation, Kind, Condition),
    condition_holds_t(Condition, Engaged, Authorisation, Holds),
    walk_limbs(Keys, Profile, Engaged, Authorisation, LaterItems),
    add_item(Holds, Key, Citation, Kind, Profile, LaterItems, Items).

add_item(false, _, _, _, _, Items, Items).
add_item(true, Key, Citation, Kind, Profile, Items, [checklist_item(Key, Citation, State)|Items]) :-
    read_key(Profile, Key, Value),
    value_state(Kind, Value, State).

select_state(_, [], []).
select_state(Wanted, [checklist_item(Key, Citation, State)|Items], Selected) :-
    select_state(Wanted, Items, LaterSelected),
    keep_item(State, Wanted, Key - Citation, LaterSelected, Selected).

keep_item(State, Wanted, Pair, Later, Selected) :-
    if_(State = Wanted, Selected = [Pair|Later], Selected = Later).

distinct_cites(Items, Citations) :-
    distinct_cites(Items, [], Citations).

distinct_cites([], Seen, Citations) :-
    reverse(Seen, Citations).
distinct_cites([checklist_item(_, Citation, _)|Items], Seen, Citations) :-
    memberd_t(Citation, Seen, Present),
    add_seen(Present, Citation, Seen, NewSeen),
    distinct_cites(Items, NewSeen, Citations).

add_seen(true, _, Seen, Seen).
add_seen(false, Citation, Seen, [Citation|Seen]).

pairs_for([], _, []).
pairs_for([standard_clauses_adopted|Keys], Profile, Pairs) :-
    read_key(Profile, standard_clauses_adopted, Value),
    pairs_for(Keys, Profile, LaterPairs),
    standard_pair(Value, LaterPairs, Pairs).
pairs_for([Key|Keys], Profile, Pairs) :-
    dif(Key, standard_clauses_adopted),
    read_key(Profile, Key, Value),
    pairs_for(Keys, Profile, LaterPairs),
    judgement_pair(Value, Key, LaterPairs, Pairs).

standard_pair(absent, Later, [standard_clauses_adopted - absent|Later]).
standard_pair(attested(_, _), Later, Later).

judgement_pair(absent, _, Later, Later).
judgement_pair(true, Key, Later, [Key - true|Later]).
judgement_pair(false, Key, Later, [Key - false|Later]).
judgement_pair(unsure, Key, Later, [Key - unsure|Later]).

engaged_pair_keys(true, [contract_binding_on_processor, processing_on_behalf_of_controller, processor_determines_purposes_and_means, processor_provides_sufficient_guarantees, standard_clauses_adopted, subprocessor_obligations_same, subprocessor_provides_sufficient_guarantees]).
engaged_pair_keys(false, [contract_binding_on_processor, processing_on_behalf_of_controller, processor_determines_purposes_and_means, processor_provides_sufficient_guarantees, standard_clauses_adopted]).
engaged_pair_keys(absent, [contract_binding_on_processor, processing_on_behalf_of_controller, processor_determines_purposes_and_means, processor_provides_sufficient_guarantees, standard_clauses_adopted]).

decide_processor_contract(Profile, Verdict) :-
    gdpr_processor_contract_input_problems(Profile, Problems),
    problems_verdict(Problems, Profile, Verdict).

problems_verdict([Problem|Problems], _, processor_contract_verdict(input_problems([Problem|Problems]), [], [])).
problems_verdict([], Profile, Verdict) :-
    read_key(Profile, processing_on_behalf_of_controller, OnBehalf),
    first_gate_verdict(OnBehalf, Profile, Verdict).

first_gate_verdict(false, _, processor_contract_verdict(not_applicable, [], [cite(eu_reg_2016_679_art_4_8)])) :-
    implements(eu_reg_2016_679_art_4_8).
first_gate_verdict(absent, _, processor_contract_verdict(indeterminate([processing_on_behalf_of_controller]), [], [])) :-
    implements(eu_reg_2016_679_art_4_8).
first_gate_verdict(unsure, Profile, processor_contract_verdict(needs_legal_review(open_textured(processing_on_behalf_of_controller, cite(eu_reg_2016_679_art_4_8)), [inputs_relied_on(Pairs)]), [], [])) :-
    implements(eu_reg_2016_679_art_4_8),
    pairs_for([processing_on_behalf_of_controller, standard_clauses_adopted], Profile, Pairs).
first_gate_verdict(true, Profile, Verdict) :-
    implements(eu_reg_2016_679_art_4_8),
    read_key(Profile, processor_determines_purposes_and_means, Determines),
    second_gate_verdict(Determines, Profile, Verdict).

second_gate_verdict(true, Profile, processor_contract_verdict(needs_legal_review(deferred_provision(cite(eu_reg_2016_679_art_28_10)), [inputs_relied_on(Pairs)]), [], [])) :-
    implements(eu_reg_2016_679_art_28_10),
    pairs_for([processing_on_behalf_of_controller, processor_determines_purposes_and_means, standard_clauses_adopted], Profile, Pairs).
second_gate_verdict(absent, _, processor_contract_verdict(indeterminate([processor_determines_purposes_and_means]), [], [])) :-
    implements(eu_reg_2016_679_art_28_10).
second_gate_verdict(unsure, Profile, processor_contract_verdict(needs_legal_review(open_textured(processor_determines_purposes_and_means, cite(eu_reg_2016_679_art_28_10)), [inputs_relied_on(Pairs)]), [], [])) :-
    implements(eu_reg_2016_679_art_28_10),
    pairs_for([processing_on_behalf_of_controller, processor_determines_purposes_and_means, standard_clauses_adopted], Profile, Pairs).
second_gate_verdict(false, Profile, Verdict) :-
    implements(eu_reg_2016_679_art_28_10),
    checklist_verdict(Profile, Verdict).

checklist_verdict(Profile, Verdict) :-
    implements(eu_reg_2016_679_art_28_3),
    checklist_items(Profile, Items),
    select_state(unmet, Items, Unmet),
    select_state(open_by_absence, Items, Absent),
    select_state(open_by_judgement, Items, Judgement),
    checklist_outcome(Unmet, Absent, Judgement, Items, Profile, Verdict).

checklist_outcome([Missing|Unmet], _, _, _, _, processor_contract_verdict(ineligible, Keys, Citations)) :-
    implements(eu_reg_2016_679_art_28_3),
    pairs_keys_values([Missing|Unmet], Keys, Citations).
checklist_outcome([], [Absent|Absents], _, _, _, processor_contract_verdict(indeterminate(Keys), [], [])) :-
    implements(eu_reg_2016_679_art_28_3),
    pairs_keys([Absent|Absents], Keys).
checklist_outcome([], [], [Key - Citation|_], _, Profile, processor_contract_verdict(needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), [], [])) :-
    implements(eu_reg_2016_679_art_28_3),
    read_key(Profile, subprocessor_engaged, Engaged),
    engaged_pair_keys(Engaged, PairKeys),
    pairs_for(PairKeys, Profile, Pairs).
checklist_outcome([], [], [], Items, _, processor_contract_verdict(eligible, [], Citations)) :-
    implements(eu_reg_2016_679_art_28_3),
    distinct_cites(Items, Citations).

processor_contract_status(Profile, Status) :-
    decide_processor_contract(Profile, processor_contract_verdict(Status, _, _)).

contract_missing_stipulations(Profile, Missing) :-
    decide_processor_contract(Profile, processor_contract_verdict(_, Missing, _)).

contract_checklist(Profile, Items) :-
    gdpr_processor_contract_input_problems(Profile, Problems),
    checklist_for(Problems, Profile, Items).

checklist_for([_|_], _, []).
checklist_for([], Profile, Items) :-
    checklist_items(Profile, Items).

processor_contract_outside_facts(Profile, Facts) :-
    gdpr_processor_contract_input_problems(Profile, Problems),
    outside_facts_for(Problems, Profile, Facts).

outside_facts_for([Problem|Problems], _, input_problems([Problem|Problems])).
outside_facts_for([], Profile, [outside_fact(standard_clauses_adopted, Value)]) :-
    read_key(Profile, standard_clauses_adopted, Value).

decide_processor_contract_status(Profile, Verdict) :-
    decide_processor_contract(Profile, Verdict).

processor_contract_status_status(Profile, Status) :-
    processor_contract_status(Profile, Status).

processor_contract_status_checklist(Profile, Items) :-
    contract_checklist(Profile, Items).

processor_contract_status_decision_resolvable(Profile) :-
    decide_processor_contract(Profile, _).
