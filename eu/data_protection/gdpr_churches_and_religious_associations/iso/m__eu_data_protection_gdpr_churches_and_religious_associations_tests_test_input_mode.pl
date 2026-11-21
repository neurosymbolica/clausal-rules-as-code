% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_churches_and_religious_associations_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_gdpr_churches_and_religious_associations, [church_rules_continuation/4, church_supervision/4, gdpr_churches_and_religious_associations_status/2, gdpr_churches_and_religious_associations_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_kernel, [gdpr_churches_and_religious_associations_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_fixtures, [gdpr_churches_and_religious_associations_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    findall(Status, gdpr_churches_and_religious_associations_status(Profile, Status), [BaselineStatus]),
    gdpr_churches_and_religious_associations_status(Profile, BaselineStatus).
test(the_baseline_status_is_the_continuation_atom) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    gdpr_churches_and_religious_associations_status(Profile, church_rules_may_continue_to_apply).
test(bound_continuation_may_continue) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    church_rules_continuation(Profile, church_rules_may_continue_to_apply, Basis, [cite(eu_reg_2016_679_art_91_1)]),
    Basis = [outside_fact(rules_applied_at_entry_into_force_of_the_regulation, attested(true, _Attestation))].
test(bound_continuation_not_covered) :-
    gdpr_churches_and_religious_associations_profile_for(body_not_a_church, Profile),
    church_rules_continuation(Profile, church_rules_not_covered_by_article_91_1, [], [cite(eu_reg_2016_679_art_91_1)]).
test(bound_continuation_missing_key) :-
    gdpr_churches_and_religious_associations_profile_for(body_status_not_stated, Profile),
    church_rules_continuation(Profile, indeterminate([body_is_church_or_religious_association_or_community]), [], []).
test(bound_supervision_subject_to_independent_supervisory_authority) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    church_supervision(Profile, subject_to_independent_supervisory_authority, _, _).
test(bound_supervision_permitted) :-
    gdpr_churches_and_religious_associations_profile_for(specific_authority_fulfils_chapter_vi, Profile),
    church_supervision(Profile, specific_supervisory_authority_permitted, _, _).
test(bound_supervision_not_permitted) :-
    gdpr_churches_and_religious_associations_profile_for(specific_authority_fails_chapter_vi, Profile),
    church_supervision(Profile, specific_supervisory_authority_not_permitted, _, _).
test(bound_supervision_not_engaged) :-
    gdpr_churches_and_religious_associations_profile_for(rules_not_brought_into_line, Profile),
    church_supervision(Profile, article_91_2_not_engaged, [], _).
test(bound_supervision_citations_are_a_set) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    church_supervision(Profile, _, _, Citations),
    clausal_msort(Citations, [cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]).
test(an_unbound_profile_gets_a_profile_problem) :-
    church_rules_continuation(_Profile, Result, Basis, Citations),
    Result == input_problems([wrong_type(profile)]),
    Basis == [],
    Citations == [].
test(an_unbound_profile_gets_one_supervision_answer) :-
    findall(Result, church_supervision(_Profile, Result, _, _), Results),
    Results == [input_problems([wrong_type(profile)])].
test(the_input_check_yields_one_solution_for_an_unbound_profile) :-
    findall(Problems, gdpr_churches_and_religious_associations_input_problems(_Profile, Problems), AllProblems),
    length(AllProblems, 1).
test(a_partial_list_is_not_a_profile) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(rules_applied_in_a_member_state, true)|_Tail], Problems),
    Problems == [wrong_type(profile)].
test(a_list_with_an_unbound_element_is_not_a_profile) :-
    gdpr_churches_and_religious_associations_input_problems([_Element], Problems),
    Problems == [wrong_type(profile)].
test(a_list_with_a_foreign_element_is_not_a_profile) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(rules_applied_in_a_member_state, true), colour], Problems),
    Problems == [wrong_type(profile)].
test(a_numeric_key_is_unknown_as_given) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(an_unbound_key_is_unknown_as_given) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(Key, true)], Problems),
    Problems = [unknown_key(Reported)],
    Reported == Key.
test(an_unbound_value_is_wrong_type) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(rules_brought_into_line_with_the_regulation, _Value)], Problems),
    Problems == [wrong_type(rules_brought_into_line_with_the_regulation)].
test(an_attestation_with_url_evidence_is_well_formed) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(rules_applied_at_entry_into_force_of_the_regulation, attested(true, attestation(host, moment, reason, url('https://example.org/statement', moment))))], Problems),
    Problems == [].
test(an_attested_unsure_is_wrong_type) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(rules_applied_at_entry_into_force_of_the_regulation, attested(unsure, attestation(host, moment, reason, none)))], Problems),
    Problems == [wrong_type(rules_applied_at_entry_into_force_of_the_regulation)].
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(specific_authority_fulfils_chapter_vi_conditions, true)], Problems),
    Problems == [wrong_type(specific_authority_fulfils_chapter_vi_conditions)].
test(problems_come_in_contract_order_then_unknown_keys) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(colour, red), attribute(supervisory_authority_is_specific, maybe), attribute(body_is_church_or_religious_association_or_community, unsure), attribute(colour, blue)], Problems),
    Problems == [wrong_type(body_is_church_or_religious_association_or_community), wrong_type(supervisory_authority_is_specific), unknown_key(colour)].
test(a_duplicate_key_with_equal_values_is_named_once) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(rules_applied_in_a_member_state, true), attribute(rules_applied_in_a_member_state, true)], Problems),
    Problems == [duplicate_key(rules_applied_in_a_member_state)].
test(an_absent_key_is_not_a_problem) :-
    gdpr_churches_and_religious_associations_input_problems([attribute(supervisory_authority_is_specific, true)], Problems),
    Problems == [].

test(every_other_bound_status_is_rejected, fail) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    findall(Status, gdpr_churches_and_religious_associations_status(Profile, Status), [BaselineStatus]),
    gdpr_churches_and_religious_associations_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    gdpr_churches_and_religious_associations_status(Profile, Other).
test(bound_continuation_not_covered_is_rejected_when_the_rules_hold, fail) :-
    gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile),
    church_rules_continuation(Profile, church_rules_not_covered_by_article_91_1, _, _).
test(bound_continuation_another_missing_key_is_rejected, fail) :-
    gdpr_churches_and_religious_associations_profile_for(body_status_not_stated, Profile),
    church_rules_continuation(Profile, indeterminate([rules_applied_in_a_member_state]), _, _).
test(bound_supervision_not_permitted_is_rejected_for_a_fulfilling_authority, fail) :-
    gdpr_churches_and_religious_associations_profile_for(specific_authority_fulfils_chapter_vi, Profile),
    church_supervision(Profile, specific_supervisory_authority_not_permitted, _, _).

cp_test_names([status_holds_with_the_verdict_bound, the_baseline_status_is_the_continuation_atom, bound_continuation_may_continue, bound_continuation_not_covered, bound_continuation_missing_key, bound_supervision_subject_to_independent_supervisory_authority, bound_supervision_permitted, bound_supervision_not_permitted, bound_supervision_not_engaged, bound_supervision_citations_are_a_set, an_unbound_profile_gets_a_profile_problem, an_unbound_profile_gets_one_supervision_answer, the_input_check_yields_one_solution_for_an_unbound_profile, a_partial_list_is_not_a_profile, a_list_with_an_unbound_element_is_not_a_profile, a_list_with_a_foreign_element_is_not_a_profile, a_numeric_key_is_unknown_as_given, an_unbound_key_is_unknown_as_given, an_unbound_value_is_wrong_type, an_attestation_with_url_evidence_is_well_formed, an_attested_unsure_is_wrong_type, a_bare_outside_fact_is_wrong_type, problems_come_in_contract_order_then_unknown_keys, a_duplicate_key_with_equal_values_is_named_once, an_absent_key_is_not_a_problem]).
cp_test_fail_names([every_other_bound_status_is_rejected, bound_continuation_not_covered_is_rejected_when_the_rules_hold, bound_continuation_another_missing_key_is_rejected, bound_supervision_not_permitted_is_rejected_for_a_fulfilling_authority]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
