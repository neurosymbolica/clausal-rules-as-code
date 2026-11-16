% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_eprivacy_art_5_3_terminal_equipment, [terminal_equipment_storage_or_access_permitted/3, decide_eprivacy_art_5_3_terminal_equipment/2, eprivacy_art_5_3_terminal_equipment_status/2, eprivacy_art_5_3_terminal_equipment_checklist/2, eprivacy_art_5_3_terminal_equipment_decision_resolvable/1, eprivacy_art_5_3_terminal_equipment_status_values/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(clausal_lists, [msort/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_kernel, [eprivacy_art_5_3_terminal_equipment_input_problems/2, eprivacy_art_5_3_terminal_equipment_contract_keys/1]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_citations, [implements/1]).

input_problems(Problems) :-
    var(Problems),
    input_problems_default(Problems).
input_problems(Problems) :-
    nonvar(Problems),
    Problems = [_FirstProblem|_LaterProblems].

unknown_key(Key) :-
    var(Key),
    unknown_key_default(Key).
unknown_key(Key) :-
    nonvar(Key),
    eprivacy_art_5_3_terminal_equipment_contract_keys(ContractKeys),
    memberd_t(Key, ContractKeys, false).

wrong_type(profile).
wrong_type(Key) :-
    eprivacy_art_5_3_terminal_equipment_contract_keys(ContractKeys),
    member(Key, ContractKeys).

duplicate_key(Key) :-
    eprivacy_art_5_3_terminal_equipment_contract_keys(ContractKeys),
    member(Key, ContractKeys).

indeterminate(MissingKeys) :-
    var(MissingKeys),
    indeterminate_default(MissingKeys).
indeterminate(MissingKeys) :-
    nonvar(MissingKeys),
    MissingKeys = [_MissingKey].

needs_legal_review(open_textured(Key, cite(_CitationKey)), Context) :-
    var(Context),
    referral_context_default(Key, Context).
needs_legal_review(open_textured(_Key, cite(_CitationKey)), Context) :-
    nonvar(Context),
    Context = [inputs_relied_on(_Pairs)|_Provenance].

open_textured(_Key, cite(_CitationKey)).

inputs_relied_on(Pairs) :-
    var(Pairs),
    inputs_relied_on_default(Pairs).
inputs_relied_on(Pairs) :-
    nonvar(Pairs),
    eprivacy_art_5_3_terminal_equipment_contract_keys(ContractKeys),
    pairs_in_contract_order(Pairs, ContractKeys).

provenance(Clause, Citations) :-
    var(Citations),
    provenance_default(Clause, Citations).
provenance(_Clause, Citations) :-
    nonvar(Citations).

pairs_in_contract_order([], []).
pairs_in_contract_order([Key - Value|Pairs], [Key|ContractKeys]) :-
    judgement_value(Value),
    pairs_in_contract_order(Pairs, ContractKeys).
pairs_in_contract_order(Pairs, [_SkippedKey|ContractKeys]) :-
    pairs_in_contract_order(Pairs, ContractKeys).

judgement_value(true).
judgement_value(false).
judgement_value(unsure).

input_problems_default([wrong_type(profile)]).

unknown_key_default(not_a_key_of_the_contract).

indeterminate_default([storage_or_access_in_terminal_equipment]).

inputs_relied_on_default([storage_or_access_in_terminal_equipment - unsure]).

referral_context_default(Key, [inputs_relied_on([Key - unsure])]).

provenance_default(_Clause, [cite(eu_dir_2002_58_art_5_3)]).

eprivacy_art_5_3_terminal_equipment_status_values([permitted, not_permitted, not_applicable]).

art_5_3_way(transmission, [storage_or_access_solely_for_transmission], cite(eu_dir_2002_58_art_5_3_s2)).
art_5_3_way(strictly_necessary, [service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service], cite(eu_dir_2002_58_art_5_3_s2)).
art_5_3_way(consent, [user_consent_given, clear_and_comprehensive_information_provided], cite(eu_dir_2002_58_art_5_3_s1)).

referral_citation(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)).
referral_citation(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)).
referral_citation(service_explicitly_requested_by_user, cite(eu_dir_2002_58_art_5_3_s2)).
referral_citation(strictly_necessary_to_provide_requested_service, cite(eu_dir_2002_58_art_5_3_s2)).
referral_citation(user_consent_given, cite(eu_dir_2002_58_art_2_f)).
referral_citation(clear_and_comprehensive_information_provided, cite(eu_dir_2002_58_art_5_3_s1)).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

key_state_pair(Profile, Key, Key - State) :-
    key_state(Profile, Key, State).

relied_pairs(Profile, Pairs) :-
    eprivacy_art_5_3_terminal_equipment_contract_keys(ContractKeys),
    findall(Key - Value, (member(Key, ContractKeys), profile_has(Profile, Key), profile_get(Profile, Key, Value)), Pairs).

truth_conjunction(true, Truth, Truth).
truth_conjunction(false, _, false).

state_true_t(true, true).
state_true_t(false, false).
state_true_t(unsure, false).
state_true_t(absent, false).

all_true_t([], true).
all_true_t([State|States], Truth) :-
    state_true_t(State, StateTrue),
    all_true_t(States, RestTrue),
    truth_conjunction(StateTrue, RestTrue, Truth).

way_assessment(Profile, WayId, Status, KeyStates) :-
    implements(eu_dir_2002_58_art_5_3),
    art_5_3_way(WayId, WayKeys, _WayCitation),
    maplist(key_state_pair(Profile), WayKeys, KeyStates),
    pairs_values(KeyStates, States),
    way_status(States, Status).

way_status(States, Status) :-
    implements(eu_dir_2002_58_art_5_3),
    memberd_t(false, States, HasFalse),
    way_status_given_false(HasFalse, States, Status).

way_status_given_false(true, _, failed) :-
    implements(eu_dir_2002_58_art_5_3).
way_status_given_false(false, States, Status) :-
    implements(eu_dir_2002_58_art_5_3),
    all_true_t(States, AllTrue),
    unfailed_way_status(AllTrue, Status).

unfailed_way_status(true, met) :-
    implements(eu_dir_2002_58_art_5_3).
unfailed_way_status(false, open) :-
    implements(eu_dir_2002_58_art_5_3).

ways_settlement(Profile, Settlement) :-
    implements(eu_dir_2002_58_art_5_3),
    findall(Status, (art_5_3_way(WayId, _, _), way_assessment(Profile, WayId, Status, _)), Statuses),
    memberd_t(met, Statuses, HasMet),
    settlement_given_met(HasMet, Statuses, Settlement).

settlement_given_met(true, _, some_met) :-
    implements(eu_dir_2002_58_art_5_3).
settlement_given_met(false, Statuses, Settlement) :-
    implements(eu_dir_2002_58_art_5_3),
    memberd_t(open, Statuses, HasOpen),
    settlement_given_open(HasOpen, Settlement).

settlement_given_open(true, unsettled) :-
    implements(eu_dir_2002_58_art_5_3).
settlement_given_open(false, all_failed) :-
    implements(eu_dir_2002_58_art_5_3).

first_absent_key([Key - absent|_], Key).
first_absent_key([_ - State|KeyStates], Key) :-
    dif(State, absent),
    first_absent_key(KeyStates, Key).

unresolved_count(KeyStates, UnresolvedCount) :-
    findall(Key, (member(Key - State, KeyStates), dif(State, true)), UnresolvedKeys),
    length(UnresolvedKeys, UnresolvedCount).

missing_key_candidates(Profile, Candidates) :-
    implements(eu_dir_2002_58_art_5_3),
    eprivacy_art_5_3_terminal_equipment_contract_keys(ContractKeys),
    findall(UnresolvedCount - KeyIndex - Key, (art_5_3_way(WayId, _, _), way_assessment(Profile, WayId, open, KeyStates), first_absent_key(KeyStates, Key), unresolved_count(KeyStates, UnresolvedCount), nth0(KeyIndex, ContractKeys, Key)), Candidates).

first_unsure_open_key(Profile, Key) :-
    implements(eu_dir_2002_58_art_5_3),
    eprivacy_art_5_3_terminal_equipment_contract_keys(ContractKeys),
    findall(KeyIndex - UnsureKey, (art_5_3_way(WayId, _, _), way_assessment(Profile, WayId, open, KeyStates), member(UnsureKey - unsure, KeyStates), nth0(KeyIndex, ContractKeys, UnsureKey)), Candidates),
    msort(Candidates, [_ - Key|_]).

decide_eprivacy_art_5_3_terminal_equipment(Profile, Verdict) :-
    implements(eu_dir_2002_58_art_5),
    eprivacy_art_5_3_terminal_equipment_input_problems(Profile, Problems),
    decide_given_problems(Problems, Profile, Verdict).

decide_given_problems([Problem|Problems], _, eprivacy_art_5_3_terminal_equipment_verdict(input_problems([Problem|Problems]), [])).
decide_given_problems([], Profile, Verdict) :-
    key_state(Profile, storage_or_access_in_terminal_equipment, ScopeState),
    decide_scope(ScopeState, Profile, Verdict).

decide_scope(absent, _, eprivacy_art_5_3_terminal_equipment_verdict(indeterminate([storage_or_access_in_terminal_equipment]), [])) :-
    implements(eu_dir_2002_58_art_5_3_s1),
    implements(eu_dir_2002_58_art_2_a).
decide_scope(false, _, eprivacy_art_5_3_terminal_equipment_verdict(not_applicable, [cite(eu_dir_2002_58_art_5_3)])) :-
    implements(eu_dir_2002_58_art_5_3_s1),
    implements(eu_dir_2002_58_art_2_a).
decide_scope(true, Profile, Verdict) :-
    implements(eu_dir_2002_58_art_5_3_s1),
    implements(eu_dir_2002_58_art_2_a),
    ways_settlement(Profile, Settlement),
    decide_ways(true, Settlement, Profile, Verdict).
decide_scope(unsure, Profile, Verdict) :-
    implements(eu_dir_2002_58_art_5_3_s1),
    implements(eu_dir_2002_58_art_2_a),
    ways_settlement(Profile, Settlement),
    decide_ways(unsure, Settlement, Profile, Verdict).

decide_ways(true, some_met, _, eprivacy_art_5_3_terminal_equipment_verdict(permitted, [cite(eu_dir_2002_58_art_5_3)])) :-
    implements(eu_dir_2002_58_art_5_3).
decide_ways(true, all_failed, _, eprivacy_art_5_3_terminal_equipment_verdict(not_permitted, [cite(eu_dir_2002_58_art_5_3)])) :-
    implements(eu_dir_2002_58_art_5_3).
decide_ways(unsure, some_met, Profile, eprivacy_art_5_3_terminal_equipment_verdict(needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on(Pairs)]), [])) :-
    implements(eu_dir_2002_58_art_5_3_s1),
    relied_pairs(Profile, Pairs).
decide_ways(unsure, all_failed, Profile, eprivacy_art_5_3_terminal_equipment_verdict(needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on(Pairs)]), [])) :-
    implements(eu_dir_2002_58_art_5_3_s1),
    relied_pairs(Profile, Pairs).
decide_ways(ScopeState, unsettled, Profile, Verdict) :-
    implements(eu_dir_2002_58_art_5_3),
    missing_key_candidates(Profile, Candidates),
    decide_open(Candidates, ScopeState, Profile, Verdict).

decide_open([Candidate|Candidates], _, _, eprivacy_art_5_3_terminal_equipment_verdict(indeterminate([Key]), [])) :-
    implements(eu_dir_2002_58_art_5_3),
    msort([Candidate|Candidates], [_ - _ - Key|_]).
decide_open([], unsure, Profile, eprivacy_art_5_3_terminal_equipment_verdict(needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on(Pairs)]), [])) :-
    implements(eu_dir_2002_58_art_5_3_s1),
    relied_pairs(Profile, Pairs).
decide_open([], true, Profile, eprivacy_art_5_3_terminal_equipment_verdict(needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), [])) :-
    implements(eu_dir_2002_58_art_5_3),
    first_unsure_open_key(Profile, Key),
    referral_citation(Key, Citation),
    relied_pairs(Profile, Pairs).

terminal_equipment_storage_or_access_permitted(Profile, Result, Citations) :-
    decide_eprivacy_art_5_3_terminal_equipment(Profile, eprivacy_art_5_3_terminal_equipment_verdict(Result, Citations)).

eprivacy_art_5_3_terminal_equipment_status(Profile, Status) :-
    decide_eprivacy_art_5_3_terminal_equipment(Profile, eprivacy_art_5_3_terminal_equipment_verdict(Status, _Citations)).

eprivacy_art_5_3_terminal_equipment_checklist(Profile, Items) :-
    eprivacy_art_5_3_terminal_equipment_input_problems(Profile, Problems),
    checklist_given_problems(Problems, Profile, Items).

checklist_given_problems([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_dir_2002_58_art_5_3))]).
checklist_given_problems([], Profile, [ScopeItem|WayItems]) :-
    key_state(Profile, storage_or_access_in_terminal_equipment, ScopeState),
    scope_item(ScopeState, ScopeItem),
    findall(WayItem, (art_5_3_way(WayId, _, _), way_item(Profile, WayId, WayItem)), WayItems).

scope_item(true, item(scope, met, cite(eu_dir_2002_58_art_5_3_s1))) :-
    implements(eu_dir_2002_58_art_5_3_s1).
scope_item(false, item(scope, unmet(outside_scope), cite(eu_dir_2002_58_art_5_3_s1))) :-
    implements(eu_dir_2002_58_art_5_3_s1).
scope_item(unsure, item(scope, unknown([storage_or_access_in_terminal_equipment]), cite(eu_dir_2002_58_art_5_3_s1))) :-
    implements(eu_dir_2002_58_art_5_3_s1).
scope_item(absent, item(scope, unknown([storage_or_access_in_terminal_equipment]), cite(eu_dir_2002_58_art_5_3_s1))) :-
    implements(eu_dir_2002_58_art_5_3_s1).

way_item(Profile, WayId, item(WayId, ItemStatus, WayCitation)) :-
    implements(eu_dir_2002_58_art_5_3),
    art_5_3_way(WayId, _, WayCitation),
    way_assessment(Profile, WayId, Status, KeyStates),
    way_item_status(Status, KeyStates, ItemStatus).

way_item_status(met, _, met).
way_item_status(failed, _, unmet(way_failed)).
way_item_status(open, KeyStates, unknown(UnresolvedKeys)) :-
    findall(Key, (member(Key - State, KeyStates), dif(State, true)), UnresolvedKeys).

eprivacy_art_5_3_terminal_equipment_decision_resolvable(Profile) :-
    decide_eprivacy_art_5_3_terminal_equipment(Profile, _Verdict).

test(empty_profile_asks_for_the_scope) :-
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted([], Result, Citations), Answers),
    Answers == [indeterminate([storage_or_access_in_terminal_equipment]) - []].
test(scope_false_is_not_applicable) :-
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, false)], Result, Citations), Answers),
    Answers == [not_applicable - [cite(eu_dir_2002_58_art_5_3)]].
test(transmission_way_permits) :-
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, true)], Result, Citations), Answers),
    Answers == [permitted - [cite(eu_dir_2002_58_art_5_3)]].
test(consent_way_permits_whatever_else_is_unsure) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, unsure), attribute(user_consent_given, true), attribute(clear_and_comprehensive_information_provided, true)], permitted, [cite(eu_dir_2002_58_art_5_3)]).
test(three_failed_ways_are_not_permitted) :-
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(strictly_necessary_to_provide_requested_service, false), attribute(clear_and_comprehensive_information_provided, false)], Result, Citations), Answers),
    Answers == [not_permitted - [cite(eu_dir_2002_58_art_5_3)]].
test(consent_without_information_does_not_permit) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(service_explicitly_requested_by_user, false), attribute(user_consent_given, true), attribute(clear_and_comprehensive_information_provided, false)], not_permitted, _).
test(scope_unsure_with_a_met_way_refers_on_the_scope) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, unsure), attribute(user_consent_given, true), attribute(clear_and_comprehensive_information_provided, true)], Result, Citations),
    Result == needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - unsure, user_consent_given - true, clear_and_comprehensive_information_provided - true])]),
    Citations == [].
test(scope_true_alone_asks_for_transmission) :-
    findall(Result, terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true)], Result, _), Results),
    Results == [indeterminate([storage_or_access_solely_for_transmission])].
test(fewest_unresolved_way_first) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(service_explicitly_requested_by_user, true)], Result, []),
    Result == indeterminate([strictly_necessary_to_provide_requested_service]).
test(missing_key_named_beside_an_unsure_judgement) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, unsure), attribute(storage_or_access_solely_for_transmission, unsure), attribute(service_explicitly_requested_by_user, true), attribute(user_consent_given, false)], Result, []),
    Result == indeterminate([strictly_necessary_to_provide_requested_service]).
test(tie_broken_by_contract_order) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(service_explicitly_requested_by_user, true), attribute(user_consent_given, true)], Result, []),
    Result == indeterminate([strictly_necessary_to_provide_requested_service]).
test(unsure_transmission_refers_with_pairs_in_contract_order) :-
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted([attribute(user_consent_given, false), attribute(service_explicitly_requested_by_user, false), attribute(storage_or_access_solely_for_transmission, unsure), attribute(storage_or_access_in_terminal_equipment, true)], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)), [inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - unsure, service_explicitly_requested_by_user - false, user_consent_given - false])]) - []].
test(unsure_consent_refers_to_article_2_f) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(service_explicitly_requested_by_user, false), attribute(user_consent_given, unsure), attribute(clear_and_comprehensive_information_provided, true)], needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_2_f)), _), []).
test(scope_unsure_with_open_ways_complete_refers_on_the_scope) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, unsure), attribute(storage_or_access_solely_for_transmission, unsure), attribute(service_explicitly_requested_by_user, false), attribute(user_consent_given, false)], needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), _), []).
test(input_problems_come_first) :-
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(foo, 1)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(foo)]) - []].
test(not_an_attribute_list_is_refused) :-
    terminal_equipment_storage_or_access_permitted(not_a_list, input_problems([wrong_type(profile)]), []).
test(checklist_rows_for_a_permitted_profile) :-
    eprivacy_art_5_3_terminal_equipment_checklist([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, true)], Items),
    Items == [item(scope, met, cite(eu_dir_2002_58_art_5_3_s1)), item(transmission, met, cite(eu_dir_2002_58_art_5_3_s2)), item(strictly_necessary, unknown([service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service]), cite(eu_dir_2002_58_art_5_3_s2)), item(consent, unknown([user_consent_given, clear_and_comprehensive_information_provided]), cite(eu_dir_2002_58_art_5_3_s1))].
test(status_projection) :-
    eprivacy_art_5_3_terminal_equipment_status([attribute(storage_or_access_in_terminal_equipment, false)], not_applicable).
test(provenance_constructor_with_free_citations_is_ground) :-
    findall(Citations, provenance(art_5_3_referral, Citations), Answers),
    Answers == [[cite(eu_dir_2002_58_art_5_3)]].
test(referral_constructor_with_free_context_is_ground) :-
    findall(Context, needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), Context), Answers),
    Answers == [[inputs_relied_on([storage_or_access_in_terminal_equipment - unsure])]].
test(referral_constructor_accepts_provenance_after_the_pairs) :-
    findall(true, needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - unsure]), provenance(art_5_3_referral, [cite(eu_dir_2002_58_art_5_3_s1)])]), Answers),
    Answers == [true].
test(input_problems_constructor_with_a_free_list_is_ground) :-
    findall(Problems, input_problems(Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(indeterminate_constructor_with_a_free_list_is_ground) :-
    findall(MissingKeys, indeterminate(MissingKeys), Answers),
    Answers == [[storage_or_access_in_terminal_equipment]].
test(unknown_key_constructor_with_a_free_key_is_ground) :-
    findall(Key, unknown_key(Key), Answers),
    Answers == [not_a_key_of_the_contract].
test(unknown_key_constructor_accepts_a_key_outside_the_contract) :-
    unknown_key(zzz).
test(wrong_type_constructor_with_a_free_key_is_ground) :-
    findall(Key, wrong_type(Key), Answers),
    Answers == [profile, storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission, service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service, user_consent_given, clear_and_comprehensive_information_provided].
test(duplicate_key_constructor_with_a_free_key_is_ground) :-
    findall(Key, duplicate_key(Key), Answers),
    Answers == [storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission, service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service, user_consent_given, clear_and_comprehensive_information_provided].
test(duplicate_key_constructor_accepts_a_contract_key) :-
    duplicate_key(user_consent_given).
test(wrong_type_constructor_accepts_the_profile) :-
    wrong_type(profile).
test(inputs_relied_on_constructor_with_free_pairs_is_ground) :-
    findall(Pairs, inputs_relied_on(Pairs), Answers),
    Answers == [[storage_or_access_in_terminal_equipment - unsure]].
test(inputs_relied_on_accepts_pairs_in_contract_order) :-
    findall(true, inputs_relied_on([storage_or_access_in_terminal_equipment - unsure, user_consent_given - true]), Answers),
    Answers == [true].

test(transmission_way_is_not_not_permitted, fail) :-
    terminal_equipment_storage_or_access_permitted([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, true)], not_permitted, _).
test(input_problems_constructor_rejects_an_empty_list, fail) :-
    input_problems([]).
test(indeterminate_constructor_rejects_two_keys, fail) :-
    indeterminate([storage_or_access_in_terminal_equipment, user_consent_given]).
test(unknown_key_constructor_rejects_a_contract_key, fail) :-
    unknown_key(user_consent_given).
test(inputs_relied_on_rejects_pairs_out_of_order, fail) :-
    inputs_relied_on([user_consent_given - true, storage_or_access_in_terminal_equipment - unsure]).
