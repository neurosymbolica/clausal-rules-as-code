% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_kernel, [gdpr_common_definitions_roles_and_establishments_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_citations, [citation/2, implements/1]).

test(the_definition_answer_carries_status_ground_and_citations) :-
    Answer = definition_answer(met, determines_purposes_and_means, [cite(eu_reg_2016_679_art_4_7)]),
    Answer = definition_answer(Status, Ground, Citations),
    Status == met,
    Ground == determines_purposes_and_means,
    Citations == [cite(eu_reg_2016_679_art_4_7)].
test(an_indeterminate_answer_lists_its_missing_keys) :-
    Answer = definition_answer(indeterminate([central_administration_in_union]), none, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)]),
    Answer = definition_answer(indeterminate(MissingKeys), Ground, Citations),
    MissingKeys == [central_administration_in_union],
    Ground == none,
    Citations == [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_a)].
test(an_open_textured_referral_destructures) :-
    Answer = definition_answer(needs_legal_review(open_textured(party_processes_on_behalf_of_controller, cite(eu_reg_2016_679_art_4_8)), [inputs_relied_on([party_processes_on_behalf_of_controller - unsure])]), none, [cite(eu_reg_2016_679_art_4_8)]),
    Answer = definition_answer(needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]), Ground, _),
    Input == party_processes_on_behalf_of_controller,
    Citation == cite(eu_reg_2016_679_art_4_8),
    Pairs == [party_processes_on_behalf_of_controller - unsure],
    Ground == none.
test(a_cross_reference_referral_destructures) :-
    Answer = definition_answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)), [resolution(cite(union_or_member_state_law_providing_for_controller), not_attempted), inputs_relied_on([party_determines_purposes_and_means - false, purposes_and_means_determined_by_law - true])]), none, [cite(eu_reg_2016_679_art_4_7), cite(union_or_member_state_law_providing_for_controller)]),
    Answer = definition_answer(needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, Resolution), inputs_relied_on(_)]), _, _),
    Citation == cite(eu_reg_2016_679_art_4_7),
    Target == cite(union_or_member_state_law_providing_for_controller),
    Resolution == not_attempted.
test(an_outside_fact_item_destructures) :-
    Item = outside_fact(party_provided_for_as_controller_by_law, attested(true, attestation(host, now, reason, none))),
    Item = outside_fact(Key, attested(Value, attestation(_, _, _, Evidence))),
    Key == party_provided_for_as_controller_by_law,
    Value == true,
    Evidence == none.
test(the_final_statuses_are_distinct) :-
    dif(met, not_met).
test(the_main_establishment_grounds_are_distinct) :-
    dif(central_administration, establishment_taking_decisions),
    dif(establishment_taking_decisions, establishment_of_main_processing_activities),
    dif(not_established_in_more_than_one_member_state, no_main_establishment_identified),
    dif(central_administration, none).
test(the_lettered_grounds_are_distinct) :-
    dif(point_a, point_b),
    dif(point_b, point_c),
    dif(point_a, point_c).
test(the_controller_grounds_are_distinct) :-
    dif(determines_purposes_and_means, provided_for_by_law).
test(a_met_answer_matches_itself) :-
    definition_answer(met, none, []) = definition_answer(met, none, []).
test(the_controller_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_4_7, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_main_establishment_citations_are_recorded) :-
    citation(eu_reg_2016_679_art_4_16, _),
    citation(eu_reg_2016_679_art_4_16_a, _),
    citation(eu_reg_2016_679_art_4_16_b, _).
test(the_outside_fact_target_is_recorded) :-
    citation(union_or_member_state_law_providing_for_controller, _).
test(a_recorded_key_implements) :-
    implements(eu_reg_2016_679_art_4_24).
test(an_empty_profile_has_no_problem) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(party_role, processor), attribute(established_in_more_than_one_member_state, true)], []).
test(a_stray_key_is_an_unknown_key) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(stray, true)], [unknown_key(stray)]).
test(a_non_list_profile_is_wrong_type) :-
    gdpr_common_definitions_roles_and_establishments_input_problems(profile, [wrong_type(profile)]).

test(a_met_answer_is_not_a_not_met_answer, fail) :-
    definition_answer(met, none, []) = definition_answer(not_met, none, []).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _).
test(a_stray_key_is_not_problem_free, fail) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(stray, true)], []).

cp_test_names([the_definition_answer_carries_status_ground_and_citations, an_indeterminate_answer_lists_its_missing_keys, an_open_textured_referral_destructures, a_cross_reference_referral_destructures, an_outside_fact_item_destructures, the_final_statuses_are_distinct, the_main_establishment_grounds_are_distinct, the_lettered_grounds_are_distinct, the_controller_grounds_are_distinct, a_met_answer_matches_itself, the_controller_citation_is_recorded, the_main_establishment_citations_are_recorded, the_outside_fact_target_is_recorded, a_recorded_key_implements, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_stray_key_is_an_unknown_key, a_non_list_profile_is_wrong_type]).
cp_test_fail_names([a_met_answer_is_not_a_not_met_answer, the_placeholder_citation_is_gone, a_stray_key_is_not_problem_free]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
