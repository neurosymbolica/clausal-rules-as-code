% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s1_international_transfers_swiss_fadp_s1_international_transfers, [decide_swiss_fadp_s1_international_transfers/2, swiss_fadp_s1_international_transfers_status/2, swiss_fadp_s1_international_transfers_checklist/2, swiss_fadp_s1_international_transfers_decision_resolvable/1, swiss_fadp_s1_international_transfers_status_values/1, swiss_disclosure_under_article_16/3, swiss_disclosure_abroad/3, swiss_information_of_commissioner_on_request/3, eu_transfer_under_articles_45_and_46/3, compare_swiss_eu_transfer_routes/5, outside_facts_supplied/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_kernel, [swiss_fadp_s1_international_transfers_input_problems/2, profile_key/3, key_state/3, inputs_relied_on_pairs/4]).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2]).

swiss_fadp_s1_international_transfers_status_values([permitted_by_adequacy_decision, permitted_by_safeguards, permitted_by_derogation, disclosure_abroad_not_permitted]).

safeguard_way(international_treaty, cite(ch_fadp_art_16_2_a), [international_treaty_ensures_suitable_protection]).
safeguard_way(contract_clauses, cite(ch_fadp_art_16_2_b), [contract_clauses_ensure_suitable_protection, contract_clauses_notified_to_commissioner_beforehand]).
safeguard_way(specific_guarantees, cite(ch_fadp_art_16_2_c), [specific_guarantees_ensure_suitable_protection, specific_guarantees_notified_to_commissioner_beforehand]).
safeguard_way(standard_clauses, cite(ch_fadp_art_16_2_d), [standard_clauses_ensure_suitable_protection, standard_clauses_approved_issued_or_recognised_by_commissioner]).
safeguard_way(binding_corporate_rules, cite(ch_fadp_art_16_2_e), [binding_corporate_rules_ensure_suitable_protection, binding_corporate_rules_approved_beforehand]).
safeguard_way(code_of_conduct, cite(ch_fadp_ord_art_12_1), [code_of_conduct_ensures_suitable_protection, code_of_conduct_submitted_to_commissioner_for_approval_beforehand, code_of_conduct_backed_by_binding_enforceable_commitment]).
safeguard_way(certification, cite(ch_fadp_ord_art_12_1), [certification_ensures_suitable_protection, certification_backed_by_binding_enforceable_commitment]).

derogation_way(explicit_consent, cite(ch_fadp_art_17_1_a), [data_subject_explicitly_consented]).
derogation_way(contract_with_data_subject, cite(ch_fadp_art_17_1_b_1), [disclosure_directly_connected_with_contract_with_data_subject]).
derogation_way(contract_in_interest_of_data_subject, cite(ch_fadp_art_17_1_b_2), [disclosure_directly_connected_with_contract_in_interest_of_data_subject]).
derogation_way(overriding_public_interest, cite(ch_fadp_art_17_1_c_1), [disclosure_necessary_for_overriding_public_interest]).
derogation_way(legal_claims, cite(ch_fadp_art_17_1_c_2), [disclosure_necessary_for_legal_claims_before_court_or_foreign_authority]).
derogation_way(life_or_physical_integrity, cite(ch_fadp_art_17_1_d), [disclosure_necessary_to_protect_life_or_physical_integrity_and_consent_not_obtainable]).
derogation_way(generally_accessible_data, cite(ch_fadp_art_17_1_e), [data_made_generally_accessible_and_processing_not_expressly_prohibited]).
derogation_way(statutory_register, cite(ch_fadp_art_17_1_f), [data_from_statutory_register_and_inspection_conditions_met]).

eu_safeguard_way(appropriate_safeguards, cite(eu_reg_2016_679_art_46_1), [appropriate_safeguards_provided, enforceable_rights_and_effective_remedies_available]).

listed_case(cite(ch_fadp_art_17_2), [disclosure_directly_connected_with_contract_in_interest_of_data_subject, disclosure_necessary_for_overriding_public_interest, disclosure_necessary_for_legal_claims_before_court_or_foreign_authority, disclosure_necessary_to_protect_life_or_physical_integrity_and_consent_not_obtainable]).

result_citations(swiss, permitted_by_adequacy_decision, [cite(ch_fadp_art_16_1), cite(ch_fadp_ord_art_8_1), cite(ch_fadp_ord_annex_1)]).
result_citations(swiss, permitted_by_safeguards, [cite(ch_fadp_art_16_2), cite(ch_fadp_art_16_2_a), cite(ch_fadp_art_16_2_b), cite(ch_fadp_art_16_2_c), cite(ch_fadp_art_16_2_d), cite(ch_fadp_art_16_2_e), cite(ch_fadp_art_16_3), cite(ch_fadp_ord_art_12_1), cite(ch_fadp_ord_art_12_2), cite(ch_fadp_ord_art_12_3)]).
result_citations(swiss, no_adequacy_decision_or_safeguards, [cite(ch_fadp_art_16_1), cite(ch_fadp_ord_art_8_1), cite(ch_fadp_ord_annex_1), cite(ch_fadp_art_16_2), cite(ch_fadp_art_16_2_a), cite(ch_fadp_art_16_2_b), cite(ch_fadp_art_16_2_c), cite(ch_fadp_art_16_2_d), cite(ch_fadp_art_16_2_e), cite(ch_fadp_art_16_3), cite(ch_fadp_ord_art_12_1), cite(ch_fadp_ord_art_12_2), cite(ch_fadp_ord_art_12_3)]).
result_citations(swiss, permitted_by_derogation, [cite(ch_fadp_art_17_1), cite(ch_fadp_art_17_1_a), cite(ch_fadp_art_17_1_b), cite(ch_fadp_art_17_1_b_1), cite(ch_fadp_art_17_1_b_2), cite(ch_fadp_art_17_1_c), cite(ch_fadp_art_17_1_c_1), cite(ch_fadp_art_17_1_c_2), cite(ch_fadp_art_17_1_d), cite(ch_fadp_art_17_1_e), cite(ch_fadp_art_17_1_f)]).
result_citations(swiss, disclosure_abroad_not_permitted, [cite(ch_fadp_art_16_1), cite(ch_fadp_ord_art_8_1), cite(ch_fadp_ord_annex_1), cite(ch_fadp_art_16_2), cite(ch_fadp_art_16_2_a), cite(ch_fadp_art_16_2_b), cite(ch_fadp_art_16_2_c), cite(ch_fadp_art_16_2_d), cite(ch_fadp_art_16_2_e), cite(ch_fadp_art_16_3), cite(ch_fadp_ord_art_12_1), cite(ch_fadp_ord_art_12_2), cite(ch_fadp_ord_art_12_3), cite(ch_fadp_art_17_1), cite(ch_fadp_art_17_1_a), cite(ch_fadp_art_17_1_b), cite(ch_fadp_art_17_1_b_1), cite(ch_fadp_art_17_1_b_2), cite(ch_fadp_art_17_1_c), cite(ch_fadp_art_17_1_c_1), cite(ch_fadp_art_17_1_c_2), cite(ch_fadp_art_17_1_d), cite(ch_fadp_art_17_1_e), cite(ch_fadp_art_17_1_f)]).
result_citations(swiss, information_of_commissioner_required, [cite(ch_fadp_art_17_1), cite(ch_fadp_art_17_2)]).
result_citations(swiss, information_of_commissioner_not_required, [cite(ch_fadp_art_17_1), cite(ch_fadp_art_17_2)]).
result_citations(eu, permitted_by_adequacy_decision, [cite(eu_reg_2016_679_art_45_1)]).
result_citations(eu, permitted_by_safeguards, [cite(eu_reg_2016_679_art_46_1)]).
result_citations(eu, no_adequacy_decision_or_safeguards, [cite(eu_reg_2016_679_art_45_1), cite(eu_reg_2016_679_art_46_1)]).

changed_by_citations([cite(ch_fadp_art_16_1), cite(ch_fadp_art_16_2), cite(eu_reg_2016_679_art_45_1), cite(eu_reg_2016_679_art_46_1)]).

outside_fact_row(federal_council_adequacy_listing_covers_disclosure, cite(ch_fadp_art_16_1), cite(federal_council_adequacy_listing_statement)).
outside_fact_row(standard_clauses_approved_issued_or_recognised_by_commissioner, cite(ch_fadp_art_16_2_d), cite(commissioner_standard_clauses_statement)).
outside_fact_row(binding_corporate_rules_approved_beforehand, cite(ch_fadp_art_16_2_e), cite(swiss_binding_corporate_rules_approval_statement)).
outside_fact_row(commission_adequacy_decision_covers_transfer, cite(eu_reg_2016_679_art_45_1), cite(commission_adequacy_decision_statement)).

open_textured_row(international_treaty_ensures_suitable_protection, cite(ch_fadp_art_16_2_a)).
open_textured_row(contract_clauses_ensure_suitable_protection, cite(ch_fadp_art_16_2_b)).
open_textured_row(specific_guarantees_ensure_suitable_protection, cite(ch_fadp_art_16_2_c)).
open_textured_row(standard_clauses_ensure_suitable_protection, cite(ch_fadp_art_16_2_d)).
open_textured_row(binding_corporate_rules_ensure_suitable_protection, cite(ch_fadp_art_16_2_e)).
open_textured_row(code_of_conduct_ensures_suitable_protection, cite(ch_fadp_ord_art_12_1)).
open_textured_row(code_of_conduct_backed_by_binding_enforceable_commitment, cite(ch_fadp_ord_art_12_3)).
open_textured_row(certification_ensures_suitable_protection, cite(ch_fadp_ord_art_12_1)).
open_textured_row(certification_backed_by_binding_enforceable_commitment, cite(ch_fadp_ord_art_12_3)).
open_textured_row(data_subject_explicitly_consented, cite(ch_fadp_art_17_1_a)).
open_textured_row(disclosure_directly_connected_with_contract_with_data_subject, cite(ch_fadp_art_17_1_b_1)).
open_textured_row(disclosure_directly_connected_with_contract_in_interest_of_data_subject, cite(ch_fadp_art_17_1_b_2)).
open_textured_row(disclosure_necessary_for_overriding_public_interest, cite(ch_fadp_art_17_1_c_1)).
open_textured_row(disclosure_necessary_for_legal_claims_before_court_or_foreign_authority, cite(ch_fadp_art_17_1_c_2)).
open_textured_row(disclosure_necessary_to_protect_life_or_physical_integrity_and_consent_not_obtainable, cite(ch_fadp_art_17_1_d)).
open_textured_row(data_made_generally_accessible_and_processing_not_expressly_prohibited, cite(ch_fadp_art_17_1_e)).
open_textured_row(data_from_statutory_register_and_inspection_conditions_met, cite(ch_fadp_art_17_1_f)).
open_textured_row(appropriate_safeguards_provided, cite(eu_reg_2016_679_art_46_1)).
open_textured_row(enforceable_rights_and_effective_remedies_available, cite(eu_reg_2016_679_art_46_1)).

reads_position(article_16, Position) :-
    between(1, 15, Position).
reads_position(abroad, Position) :-
    between(1, 23, Position).
reads_position(information, Position) :-
    between(1, 15, Position).
reads_position(information, Position) :-
    between(18, 21, Position).
reads_position(information, 24).
reads_position(eu, Position) :-
    between(25, 27, Position).
reads_position(compare, Position) :-
    between(1, 15, Position).
reads_position(compare, Position) :-
    between(25, 27, Position).

query_read_keys(Query, ReadKeys) :-
    findall(Key, (between(1, 27, Position), reads_position(Query, Position), profile_key(Position, Key, _)), ReadKeys).

state_class(true, true).
state_class(false, false).
state_class(open_absent, open).
state_class(open_unsure, open).

key_class(Profile, Key, Class) :-
    key_state(Profile, Key, State),
    state_class(State, Class).

conjunction_step(true, Accumulated, Accumulated).
conjunction_step(false, _, false).
conjunction_step(open, true, open).
conjunction_step(open, false, false).
conjunction_step(open, open, open).

disjunction_step(true, _, true).
disjunction_step(false, Accumulated, Accumulated).
disjunction_step(open, true, true).
disjunction_step(open, false, open).
disjunction_step(open, open, open).

negated_class(true, false).
negated_class(false, true).
negated_class(open, open).

can_be_true(true).
can_be_true(open).

can_be_false(false).
can_be_false(open).

way_class(Profile, WayKeys, Class) :-
    maplist(key_class(Profile), WayKeys, Classes),
    foldl(conjunction_step, Classes, true, Class).

way_part(Profile, WayKeys, part(Class, WayKeys)) :-
    way_class(Profile, WayKeys, Class).

part_class(part(Class, _), Class).

stage_class(Parts, Class) :-
    maplist(part_class, Parts, Classes),
    foldl(disjunction_step, Classes, false, Class).

parts_conjunction(Parts, Class) :-
    maplist(part_class, Parts, Classes),
    foldl(conjunction_step, Classes, true, Class).

safeguard_parts(Profile, Parts) :-
    implements(ch_fadp_art_16_2),
    findall(WayKeys, safeguard_way(_, _, WayKeys), Ways),
    maplist(way_part(Profile), Ways, Parts).

derogation_parts(Profile, Parts) :-
    implements(ch_fadp_art_17_1),
    findall(WayKeys, derogation_way(_, _, WayKeys), Ways),
    maplist(way_part(Profile), Ways, Parts).

eu_parts(Profile, Parts) :-
    implements(eu_reg_2016_679_art_46_1),
    findall(WayKeys, eu_safeguard_way(_, _, WayKeys), Ways),
    maplist(way_part(Profile), Ways, Parts).

finding_class(Profile, Class) :-
    implements(ch_fadp_art_16_1),
    key_class(Profile, federal_council_adequacy_listing_covers_disclosure, Class).

commission_class(Profile, Class) :-
    implements(eu_reg_2016_679_art_45_1),
    key_class(Profile, commission_adequacy_decision_covers_transfer, Class).

open_keys(Profile, WayKeys, OpenKeys) :-
    findall(Key, (member(Key, WayKeys), key_class(Profile, Key, open)), OpenKeys).

asked_kind(judgement).
asked_kind(crisp).

absent_asked_key(Profile, Key, Position) :-
    key_state(Profile, Key, open_absent),
    profile_key(Position, Key, Kind),
    asked_kind(Kind).

first_key([], none).
first_key([_ - Key|_], key(Key)).

pick_missing([_ - Key|_], _, key(Key)).
pick_missing([], [_ - Key|_], key(Key)).
pick_missing([], [], none).

stage_missing(Profile, Stage, Missing) :-
    findall(Position - Key, (member(part(open, WayKeys), Stage), open_keys(Profile, WayKeys, [Key]), absent_asked_key(Profile, Key, Position)), FoundSingles),
    sort(FoundSingles, Singles),
    findall(Position - Key, (member(part(open, WayKeys), Stage), member(Key, WayKeys), absent_asked_key(Profile, Key, Position)), FoundAbsent),
    sort(FoundAbsent, Absent),
    pick_missing(Singles, Absent, Missing).

stages_missing(_, [], none).
stages_missing(Profile, [Stage|Stages], Missing) :-
    stage_missing(Profile, Stage, StageMissing),
    next_missing(StageMissing, Profile, Stages, Missing).

next_missing(key(Key), _, _, key(Key)).
next_missing(none, Profile, Stages, Missing) :-
    stages_missing(Profile, Stages, Missing).

first_absent_outside_fact(Profile, Stages, Result) :-
    findall(Position - Key, (member(Stage, Stages), member(part(open, WayKeys), Stage), member(Key, WayKeys), key_state(Profile, Key, open_absent), profile_key(Position, Key, outside_fact)), Found),
    sort(Found, Sorted),
    first_key(Sorted, Result).

first_unsure_judgement(Profile, Stages, Result) :-
    findall(Position - Key, (member(Stage, Stages), member(part(open, WayKeys), Stage), member(Key, WayKeys), key_state(Profile, Key, open_unsure), profile_key(Position, Key, judgement)), Found),
    sort(Found, Sorted),
    first_key(Sorted, Result).

open_answer(Profile, Query, refer(Key), _, _, Result) :-
    cross_referral(Profile, Query, Key, Result).
open_answer(Profile, Query, none, Stages, MiddleRefer, Result) :-
    stages_missing(Profile, Stages, Missing),
    after_missing(Missing, Profile, Query, Stages, MiddleRefer, Result).

after_missing(key(Key), _, _, _, _, indeterminate([Key])).
after_missing(none, Profile, Query, _, refer(Key), Result) :-
    cross_referral(Profile, Query, Key, Result).
after_missing(none, Profile, Query, Stages, none, Result) :-
    first_absent_outside_fact(Profile, Stages, OutsideFact),
    after_outside_fact(OutsideFact, Profile, Query, Stages, Result).

after_outside_fact(key(Key), Profile, Query, _, Result) :-
    cross_referral(Profile, Query, Key, Result).
after_outside_fact(none, Profile, Query, Stages, Result) :-
    first_unsure_judgement(Profile, Stages, key(Key)),
    open_textured_referral(Profile, Query, Key, Result).

cross_referral(Profile, Query, Key, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on(Pairs)])) :-
    outside_fact_row(Key, Citation, Target),
    query_read_keys(Query, ReadKeys),
    inputs_relied_on_pairs(Profile, ReadKeys, Key, Pairs).

open_textured_referral(Profile, Query, Key, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    open_textured_row(Key, Citation),
    query_read_keys(Query, ReadKeys),
    inputs_relied_on_pairs(Profile, ReadKeys, none, Pairs).

finding_middle_refer(open, refer(federal_council_adequacy_listing_covers_disclosure)).
finding_middle_refer(false, none).
finding_middle_refer(true, none).

live_if_open(open, Parts, [Parts]).
live_if_open(true, _, []).
live_if_open(false, _, []).

derogation_live(open, false, Parts, [Parts]).
derogation_live(open, open, Parts, [Parts]).
derogation_live(open, true, _, []).
derogation_live(true, _, _, []).
derogation_live(false, _, _, []).

swiss_disclosure_under_article_16(Profile, Result, Citations) :-
    swiss_fadp_s1_international_transfers_input_problems(Profile, Problems),
    article_16_answer(Problems, Profile, Result, Citations).

article_16_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
article_16_answer([], Profile, Result, Citations) :-
    finding_class(Profile, FindingClass),
    safeguard_parts(Profile, SafeguardParts),
    stage_class(SafeguardParts, SafeguardClass),
    article_16_route(FindingClass, SafeguardClass, Profile, SafeguardParts, Result, Citations).

article_16_route(true, _, _, _, permitted_by_adequacy_decision, Citations) :-
    implements(ch_fadp_art_16_1),
    result_citations(swiss, permitted_by_adequacy_decision, Citations).
article_16_route(false, true, _, _, permitted_by_safeguards, Citations) :-
    implements(ch_fadp_art_16_2),
    result_citations(swiss, permitted_by_safeguards, Citations).
article_16_route(false, false, _, _, no_adequacy_decision_or_safeguards, Citations) :-
    implements(ch_fadp_art_16_2),
    result_citations(swiss, no_adequacy_decision_or_safeguards, Citations).
article_16_route(open, SafeguardClass, Profile, SafeguardParts, Result, []) :-
    article_16_open(open, SafeguardClass, Profile, SafeguardParts, Result).
article_16_route(false, open, Profile, SafeguardParts, Result, []) :-
    article_16_open(false, open, Profile, SafeguardParts, Result).

article_16_open(FindingClass, SafeguardClass, Profile, SafeguardParts, Result) :-
    live_if_open(SafeguardClass, SafeguardParts, Stages),
    finding_middle_refer(FindingClass, MiddleRefer),
    open_answer(Profile, article_16, none, Stages, MiddleRefer, Result).

swiss_disclosure_abroad(Profile, Result, Citations) :-
    swiss_fadp_s1_international_transfers_input_problems(Profile, Problems),
    abroad_answer(Problems, Profile, Result, Citations).

abroad_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
abroad_answer([], Profile, Result, Citations) :-
    finding_class(Profile, FindingClass),
    safeguard_parts(Profile, SafeguardParts),
    stage_class(SafeguardParts, SafeguardClass),
    derogation_parts(Profile, DerogationParts),
    stage_class(DerogationParts, DerogationClass),
    abroad_route(FindingClass, SafeguardClass, DerogationClass, Profile, SafeguardParts, DerogationParts, Result, Citations).

abroad_route(true, _, _, _, _, _, permitted_by_adequacy_decision, Citations) :-
    implements(ch_fadp_art_16_1),
    result_citations(swiss, permitted_by_adequacy_decision, Citations).
abroad_route(false, true, _, _, _, _, permitted_by_safeguards, Citations) :-
    implements(ch_fadp_art_16_2),
    result_citations(swiss, permitted_by_safeguards, Citations).
abroad_route(false, false, true, _, _, _, permitted_by_derogation, Citations) :-
    implements(ch_fadp_art_17_1),
    result_citations(swiss, permitted_by_derogation, Citations).
abroad_route(false, false, false, _, _, _, disclosure_abroad_not_permitted, Citations) :-
    implements(ch_fadp_art_17_1),
    result_citations(swiss, disclosure_abroad_not_permitted, Citations).
abroad_route(open, SafeguardClass, DerogationClass, Profile, SafeguardParts, DerogationParts, Result, []) :-
    abroad_open(open, SafeguardClass, DerogationClass, Profile, SafeguardParts, DerogationParts, Result).
abroad_route(false, open, DerogationClass, Profile, SafeguardParts, DerogationParts, Result, []) :-
    abroad_open(false, open, DerogationClass, Profile, SafeguardParts, DerogationParts, Result).
abroad_route(false, false, open, Profile, SafeguardParts, DerogationParts, Result, []) :-
    abroad_open(false, false, open, Profile, SafeguardParts, DerogationParts, Result).

abroad_open(FindingClass, SafeguardClass, DerogationClass, Profile, SafeguardParts, DerogationParts, Result) :-
    live_if_open(SafeguardClass, SafeguardParts, SafeguardStages),
    derogation_live(DerogationClass, SafeguardClass, DerogationParts, DerogationStages),
    append(SafeguardStages, DerogationStages, Stages),
    finding_middle_refer(FindingClass, MiddleRefer),
    open_answer(Profile, abroad, none, Stages, MiddleRefer, Result).

swiss_information_of_commissioner_on_request(Profile, Result, Citations) :-
    swiss_fadp_s1_international_transfers_input_problems(Profile, Problems),
    information_answer(Problems, Profile, Result, Citations).

information_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
information_answer([], Profile, Result, Citations) :-
    information_parts(Profile, Parts),
    parts_conjunction(Parts, Class),
    information_route(Class, Profile, Parts, Result, Citations).

information_parts(Profile, Parts) :-
    implements(ch_fadp_art_17_2),
    key_class(Profile, commissioner_requested_information_on_disclosure, RequestClass),
    key_class(Profile, federal_council_adequacy_listing_covers_disclosure, FindingClass),
    negated_class(FindingClass, NoFindingClass),
    findall(WayKeys, safeguard_way(_, _, WayKeys), Ways),
    maplist(not_held_part(Profile), Ways, NotHeldParts),
    listed_case(_, ListedKeys),
    maplist(key_class(Profile), ListedKeys, ListedClasses),
    foldl(disjunction_step, ListedClasses, false, ListedClass),
    append([[part(RequestClass, [commissioner_requested_information_on_disclosure]), part(NoFindingClass, [federal_council_adequacy_listing_covers_disclosure])], NotHeldParts, [part(ListedClass, ListedKeys)]], Parts).

not_held_part(Profile, WayKeys, part(NegatedClass, WayKeys)) :-
    way_class(Profile, WayKeys, Class),
    negated_class(Class, NegatedClass).

information_route(true, _, _, information_of_commissioner_required, Citations) :-
    implements(ch_fadp_art_17_2),
    result_citations(swiss, information_of_commissioner_required, Citations).
information_route(false, _, _, information_of_commissioner_not_required, Citations) :-
    implements(ch_fadp_art_17_2),
    result_citations(swiss, information_of_commissioner_not_required, Citations).
information_route(open, Profile, Parts, Result, []) :-
    open_answer(Profile, information, none, [Parts], none, Result).

eu_transfer_under_articles_45_and_46(Profile, Result, Citations) :-
    swiss_fadp_s1_international_transfers_input_problems(Profile, Problems),
    eu_answer(Problems, Profile, Result, Citations).

eu_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
eu_answer([], Profile, Result, Citations) :-
    commission_class(Profile, CommissionClass),
    eu_parts(Profile, EuParts),
    stage_class(EuParts, EuClass),
    eu_route(CommissionClass, EuClass, Profile, EuParts, Result, Citations).

eu_route(true, _, _, _, permitted_by_adequacy_decision, Citations) :-
    implements(eu_reg_2016_679_art_45_1),
    result_citations(eu, permitted_by_adequacy_decision, Citations).
eu_route(false, true, _, _, permitted_by_safeguards, Citations) :-
    implements(eu_reg_2016_679_art_46_1),
    result_citations(eu, permitted_by_safeguards, Citations).
eu_route(false, false, _, _, no_adequacy_decision_or_safeguards, Citations) :-
    implements(eu_reg_2016_679_art_46_1),
    result_citations(eu, no_adequacy_decision_or_safeguards, Citations).
eu_route(open, _, Profile, _, Result, []) :-
    open_answer(Profile, eu, refer(commission_adequacy_decision_covers_transfer), [], none, Result).
eu_route(false, open, Profile, EuParts, Result, []) :-
    open_answer(Profile, eu, none, [EuParts], none, Result).

compare_swiss_eu_transfer_routes(Profile, SwissResult, EuResult, Difference, ChangedBy) :-
    swiss_fadp_s1_international_transfers_input_problems(Profile, Problems),
    compare_answer(Problems, Profile, SwissResult, EuResult, Difference, ChangedBy).

compare_answer([Problem|Problems], _, input_problems([Problem|Problems]), input_problems([Problem|Problems]), input_problems([Problem|Problems]), []).
compare_answer([], Profile, SwissResult, EuResult, Difference, ChangedBy) :-
    article_16_answer([], Profile, SwissResult, _),
    eu_answer([], Profile, EuResult, _),
    compare_difference(Profile, Difference),
    changed_by(Difference, ChangedBy).

route_can_be(AdequacyClass, _, permitted_by_adequacy_decision) :-
    can_be_true(AdequacyClass).
route_can_be(AdequacyClass, SafeguardClass, permitted_by_safeguards) :-
    can_be_false(AdequacyClass),
    can_be_true(SafeguardClass).
route_can_be(AdequacyClass, SafeguardClass, no_adequacy_decision_or_safeguards) :-
    can_be_false(AdequacyClass),
    can_be_false(SafeguardClass).

possible_routes(AdequacyClass, SafeguardClass, Routes) :-
    findall(Route, route_can_be(AdequacyClass, SafeguardClass, Route), FoundRoutes),
    sort(FoundRoutes, Routes).

compare_difference(Profile, Difference) :-
    implements(ch_fadp_art_16_1),
    finding_class(Profile, FindingClass),
    safeguard_parts(Profile, SafeguardParts),
    stage_class(SafeguardParts, SafeguardClass),
    commission_class(Profile, CommissionClass),
    eu_parts(Profile, EuParts),
    stage_class(EuParts, EuClass),
    possible_routes(FindingClass, SafeguardClass, SwissRoutes),
    possible_routes(CommissionClass, EuClass, EuRoutes),
    findall(Route, (member(Route, SwissRoutes), member(Route, EuRoutes)), Common),
    append(SwissRoutes, EuRoutes, AllRoutes),
    sort(AllRoutes, UnionRoutes),
    length(UnionRoutes, UnionCount),
    settled_class(Common, UnionCount, Class),
    difference_from_class(Class, Profile, FindingClass, SafeguardClass, SafeguardParts, CommissionClass, EuClass, EuParts, Difference).

settled_class([], _, differs).
settled_class([_|_], UnionCount, same) :-
    UnionCount =:= 1.
settled_class([_|_], UnionCount, open) :-
    UnionCount > 1.

difference_from_class(same, _, _, _, _, _, _, _, same).
difference_from_class(differs, _, _, _, _, _, _, _, differs).
difference_from_class(open, Profile, FindingClass, SafeguardClass, SafeguardParts, CommissionClass, EuClass, EuParts, Difference) :-
    commission_first_refer(CommissionClass, FirstRefer),
    side_live(CommissionClass, FindingClass, SafeguardClass, SafeguardParts, SwissStages),
    side_live(CommissionClass, FindingClass, EuClass, EuParts, EuStages),
    append(SwissStages, EuStages, Stages),
    finding_middle_refer(FindingClass, MiddleRefer),
    open_answer(Profile, compare, FirstRefer, Stages, MiddleRefer, Difference).

commission_first_refer(open, refer(commission_adequacy_decision_covers_transfer)).
commission_first_refer(true, none).
commission_first_refer(false, none).

side_live(false, false, open, Parts, [Parts]).
side_live(false, open, open, Parts, [Parts]).
side_live(CommissionClass, FindingClass, StageClass, _, []) :-
    side_dead(CommissionClass, FindingClass, StageClass).

side_dead(true, _, _).
side_dead(open, _, _).
side_dead(false, true, _).
side_dead(false, false, true).
side_dead(false, false, false).
side_dead(false, open, true).
side_dead(false, open, false).

changed_by(differs, Citations) :-
    changed_by_citations(Citations).
changed_by(same, []).
changed_by(indeterminate(_), []).
changed_by(needs_legal_review(_, _), []).

outside_facts_supplied(Profile, Facts) :-
    swiss_fadp_s1_international_transfers_input_problems(Profile, Problems),
    outside_facts_answer(Problems, Profile, Facts).

outside_facts_answer([Problem|Problems], _, input_problems([Problem|Problems])).
outside_facts_answer([], Profile, Facts) :-
    findall(outside_fact(Key, Value), (profile_key(_, Key, outside_fact), profile_has(Profile, Key), profile_get(Profile, Key, Value)), Facts).

decide_swiss_fadp_s1_international_transfers(Profile, swiss_fadp_s1_international_transfers_verdict(Status, Citations)) :-
    swiss_disclosure_abroad(Profile, Status, Citations).

swiss_fadp_s1_international_transfers_status(Profile, Status) :-
    decide_swiss_fadp_s1_international_transfers(Profile, swiss_fadp_s1_international_transfers_verdict(Status, _Citations)).

swiss_fadp_s1_international_transfers_checklist(Profile, Items) :-
    swiss_fadp_s1_international_transfers_input_problems(Profile, Problems),
    checklist_answer(Problems, Profile, Items).

checklist_answer([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(ch_fadp_art_16_1))]).
checklist_answer([], Profile, Items) :-
    finding_class(Profile, FindingClass),
    open_keys(Profile, [federal_council_adequacy_listing_covers_disclosure], FindingOpenKeys),
    class_status(FindingClass, FindingOpenKeys, FindingStatus),
    findall(item(Identifier, Status, Citation), (safeguard_way(Identifier, Citation, WayKeys), way_item_status(Profile, WayKeys, Status)), SafeguardItems),
    findall(item(Identifier, Status, Citation), (derogation_way(Identifier, Citation, WayKeys), way_item_status(Profile, WayKeys, Status)), DerogationItems),
    append([[item(federal_council_finding, FindingStatus, cite(ch_fadp_art_16_1))], SafeguardItems, DerogationItems], Items).

way_item_status(Profile, WayKeys, Status) :-
    way_class(Profile, WayKeys, Class),
    open_keys(Profile, WayKeys, OpenKeys),
    class_status(Class, OpenKeys, Status).

class_status(true, _, met).
class_status(false, _, unmet(key_false)).
class_status(open, OpenKeys, unknown(OpenKeys)).

swiss_fadp_s1_international_transfers_decision_resolvable(Profile) :-
    decide_swiss_fadp_s1_international_transfers(Profile, _Verdict).

failed_safeguard_attributes([attribute(federal_council_adequacy_listing_covers_disclosure, attested(false, attestation(by, at, reason, none))), attribute(international_treaty_ensures_suitable_protection, false), attribute(contract_clauses_ensure_suitable_protection, false), attribute(specific_guarantees_ensure_suitable_protection, false), attribute(standard_clauses_ensure_suitable_protection, false), attribute(binding_corporate_rules_ensure_suitable_protection, false), attribute(code_of_conduct_ensures_suitable_protection, false), attribute(certification_ensures_suitable_protection, false)]).

test(a_finding_permits_under_article_16) :-
    swiss_disclosure_under_article_16([attribute(federal_council_adequacy_listing_covers_disclosure, attested(true, attestation(by, at, reason, none)))], Result, Citations),
    Result == permitted_by_adequacy_decision,
    Citations == [cite(ch_fadp_art_16_1), cite(ch_fadp_ord_art_8_1), cite(ch_fadp_ord_annex_1)].
test(notified_contract_clauses_permit_on_safeguards) :-
    swiss_disclosure_under_article_16([attribute(federal_council_adequacy_listing_covers_disclosure, attested(false, attestation(by, at, reason, none))), attribute(contract_clauses_ensure_suitable_protection, true), attribute(contract_clauses_notified_to_commissioner_beforehand, true)], permitted_by_safeguards, _).
test(an_empty_profile_names_the_treaty_first) :-
    findall(Result - Citations, swiss_disclosure_under_article_16([], Result, Citations), Answers),
    Answers == [indeterminate([international_treaty_ensures_suitable_protection]) - []].
test(an_absent_standard_clauses_approval_is_referred) :-
    failed_safeguard_attributes([Finding, Treaty, Contract, Guarantees, _, Rules, Code, Certification]),
    swiss_disclosure_under_article_16([Finding, Treaty, Contract, Guarantees, attribute(standard_clauses_ensure_suitable_protection, true), Rules, Code, Certification], Result, []),
    Result = needs_legal_review(cross_reference_unresolved(cite(ch_fadp_art_16_2_d), cite(commissioner_standard_clauses_statement)), _).
test(a_derogation_permits_when_article_16_fails) :-
    failed_safeguard_attributes(Attributes),
    swiss_disclosure_abroad([attribute(data_subject_explicitly_consented, true)|Attributes], permitted_by_derogation, Citations),
    length(Citations, 11).
test(open_derogations_name_consent_first) :-
    failed_safeguard_attributes(Attributes),
    swiss_disclosure_abroad(Attributes, indeterminate([data_subject_explicitly_consented]), []).
test(the_commissioner_must_be_informed) :-
    failed_safeguard_attributes(Attributes),
    swiss_information_of_commissioner_on_request([attribute(commissioner_requested_information_on_disclosure, true), attribute(disclosure_necessary_for_legal_claims_before_court_or_foreign_authority, true)|Attributes], information_of_commissioner_required, [cite(ch_fadp_art_17_1), cite(ch_fadp_art_17_2)]).
test(no_request_means_no_duty) :-
    findall(Result, swiss_information_of_commissioner_on_request([attribute(commissioner_requested_information_on_disclosure, false)], Result, _), Results),
    Results == [information_of_commissioner_not_required].
test(the_eu_limb_refers_first_on_the_commission_decision) :-
    eu_transfer_under_articles_45_and_46([], Result, []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_45_1), cite(commission_adequacy_decision_statement)), [resolution(cite(commission_adequacy_decision_statement), not_attempted), inputs_relied_on([commission_adequacy_decision_covers_transfer - absent])]).
test(an_unsure_eu_remedy_is_open_textured) :-
    eu_transfer_under_articles_45_and_46([attribute(commission_adequacy_decision_covers_transfer, attested(false, attestation(by, at, reason, none))), attribute(appropriate_safeguards_provided, true), attribute(enforceable_rights_and_effective_remedies_available, unsure)], Result, []),
    Result == needs_legal_review(open_textured(enforceable_rights_and_effective_remedies_available, cite(eu_reg_2016_679_art_46_1)), [inputs_relied_on([appropriate_safeguards_provided - true, enforceable_rights_and_effective_remedies_available - unsure])]).
test(two_adequacy_findings_are_the_same_route) :-
    compare_swiss_eu_transfer_routes([attribute(federal_council_adequacy_listing_covers_disclosure, attested(true, attestation(by, at, reason, none))), attribute(commission_adequacy_decision_covers_transfer, attested(true, attestation(by, at, reason, none)))], permitted_by_adequacy_decision, permitted_by_adequacy_decision, same, []).
test(a_swiss_finding_against_no_eu_route_differs) :-
    compare_swiss_eu_transfer_routes([attribute(federal_council_adequacy_listing_covers_disclosure, attested(true, attestation(by, at, reason, none))), attribute(commission_adequacy_decision_covers_transfer, attested(false, attestation(by, at, reason, none))), attribute(appropriate_safeguards_provided, false)], permitted_by_adequacy_decision, no_adequacy_decision_or_safeguards, differs, ChangedBy),
    ChangedBy == [cite(ch_fadp_art_16_1), cite(ch_fadp_art_16_2), cite(eu_reg_2016_679_art_45_1), cite(eu_reg_2016_679_art_46_1)].
test(an_open_comparison_refers_on_the_commission_decision) :-
    findall(Difference, compare_swiss_eu_transfer_routes([], _, _, Difference, _), Differences),
    Differences == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_45_1), cite(commission_adequacy_decision_statement)), [resolution(cite(commission_adequacy_decision_statement), not_attempted), inputs_relied_on([commission_adequacy_decision_covers_transfer - absent])])].
test(an_unknown_key_is_an_input_problem) :-
    swiss_disclosure_under_article_16([attribute(stray_key, true)], input_problems([unknown_key(stray_key)]), []).
test(outside_facts_are_listed_back) :-
    outside_facts_supplied([attribute(commission_adequacy_decision_covers_transfer, attested(true, attestation(by, at, reason, none))), attribute(data_subject_explicitly_consented, true)], Facts),
    Facts == [outside_fact(commission_adequacy_decision_covers_transfer, attested(true, attestation(by, at, reason, none)))].
test(every_query_answers_once_on_an_empty_profile) :-
    findall(Result, swiss_disclosure_abroad([], Result, _), AbroadAnswers),
    length(AbroadAnswers, 1),
    findall(Result, swiss_information_of_commissioner_on_request([], Result, _), InformationAnswers),
    InformationAnswers == [indeterminate([international_treaty_ensures_suitable_protection])],
    findall(Facts, outside_facts_supplied([], Facts), FactAnswers),
    FactAnswers == [[]].
test(the_checklist_has_one_row_per_ground) :-
    swiss_fadp_s1_international_transfers_checklist([], Items),
    length(Items, 16),
    Items = [item(federal_council_finding, unknown([federal_council_adequacy_listing_covers_disclosure]), cite(ch_fadp_art_16_1))|_].

test(notified_contract_clauses_are_not_no_route, fail) :-
    swiss_disclosure_under_article_16([attribute(federal_council_adequacy_listing_covers_disclosure, attested(false, attestation(by, at, reason, none))), attribute(contract_clauses_ensure_suitable_protection, true), attribute(contract_clauses_notified_to_commissioner_beforehand, true)], no_adequacy_decision_or_safeguards, _).
