% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_queries, [gdpr_compensation_and_liability_profile_keys/1, gdpr_compensation_and_liability_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, gdpr_compensation_and_liability_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_profile_for/2]).

allowed_citation(cite(eu_reg_2016_679_art_82_1)).
allowed_citation(cite(eu_reg_2016_679_art_82_2)).
allowed_citation(cite(eu_reg_2016_679_art_82_3)).

item_is_cited(item(_RequirementId, _Status, Citation)) :-
    allowed_citation(Citation).

test(profile_keys_are_the_contract_keys) :-
    gdpr_compensation_and_liability_profile_keys(ProfileKeys),
    ProfileKeys == [party_role, involved_in_the_processing, processor_breached_obligations_directed_to_processors, processor_acted_outside_or_contrary_to_lawful_instructions, damage_suffered, infringement_of_the_regulation_occurred, damage_resulted_from_the_infringement, not_in_any_way_responsible_for_the_event].
test(the_eligibility_query_gives_one_answer) :-
    gdpr_compensation_and_liability_profile_for(liable_controller, Profile),
    findall(Result, compensation_liability(Profile, Result, _Basis, _Citations), Results),
    Results == [liable_for_damage].
test(every_checklist_item_carries_a_vocabulary_citation) :-
    gdpr_compensation_and_liability_profile_for(referred_inside_unsure, Profile),
    gdpr_compensation_and_liability_checklist(Profile, Checklist),
    length(Checklist, 5),
    maplist(item_is_cited, Checklist).
test(the_checklist_names_the_unsure_judgement) :-
    gdpr_compensation_and_liability_profile_for(referred_inside_unsure, Profile),
    gdpr_compensation_and_liability_checklist(Profile, [FirstItem|_OtherItems]),
    FirstItem == item(damage_suffered, unknown([damage_suffered]), cite(eu_reg_2016_679_art_82_1)).
test(supplying_a_true_statement_exempts) :-
    gdpr_compensation_and_liability_profile_for(referred_statement_absent, Profile),
    gdpr_compensation_and_liability_what_if(Profile, not_in_any_way_responsible_for_the_event, attested(true, attestation(host, at, reason, none)), exempt_from_liability).
test(supplying_a_false_statement_makes_liable) :-
    gdpr_compensation_and_liability_profile_for(referred_statement_absent, Profile),
    gdpr_compensation_and_liability_what_if(Profile, not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, none)), liable_for_damage).
test(overriding_a_duplicated_key_removes_every_copy) :-
    gdpr_compensation_and_liability_profile_for(input_problem_duplicate_key, Profile),
    gdpr_compensation_and_liability_what_if(Profile, damage_suffered, true, liable_for_damage).
test(overriding_damage_to_false_is_right_not_established) :-
    gdpr_compensation_and_liability_profile_for(liable_controller, Profile),
    gdpr_compensation_and_liability_what_if(Profile, damage_suffered, false, right_not_established).
test(overriding_damage_to_unsure_refers_inside) :-
    gdpr_compensation_and_liability_profile_for(liable_controller, Profile),
    gdpr_compensation_and_liability_what_if(Profile, damage_suffered, unsure, needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true])])).
test(switching_the_role_to_processor_asks_for_the_processor_ground) :-
    gdpr_compensation_and_liability_profile_for(liable_controller, Profile),
    gdpr_compensation_and_liability_what_if(Profile, party_role, processor, indeterminate([processor_breached_obligations_directed_to_processors])).
test(the_unchanged_what_if_keeps_the_answer) :-
    gdpr_compensation_and_liability_profile_for(not_liable_processor, Profile),
    gdpr_compensation_and_liability_what_if(Profile, party_role, processor, not_liable_for_damage).
test(the_what_if_input_check_still_comes_first) :-
    gdpr_compensation_and_liability_profile_for(liable_controller, Profile),
    gdpr_compensation_and_liability_what_if(Profile, party_role, joint_controller, input_problems([wrong_type(party_role)])).

test(the_what_if_does_not_keep_the_old_answer, fail) :-
    gdpr_compensation_and_liability_profile_for(not_liable_processor, Profile),
    gdpr_compensation_and_liability_what_if(Profile, processor_breached_obligations_directed_to_processors, true, not_liable_for_damage).

cp_test_names([profile_keys_are_the_contract_keys, the_eligibility_query_gives_one_answer, every_checklist_item_carries_a_vocabulary_citation, the_checklist_names_the_unsure_judgement, supplying_a_true_statement_exempts, supplying_a_false_statement_makes_liable, overriding_a_duplicated_key_removes_every_copy, overriding_damage_to_false_is_right_not_established, overriding_damage_to_unsure_refers_inside, switching_the_role_to_processor_asks_for_the_processor_ground, the_unchanged_what_if_keeps_the_answer, the_what_if_input_check_still_comes_first]).
cp_test_fail_names([the_what_if_does_not_keep_the_old_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
