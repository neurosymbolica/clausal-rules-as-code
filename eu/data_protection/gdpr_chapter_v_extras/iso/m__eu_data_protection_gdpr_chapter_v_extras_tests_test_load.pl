% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true), attribute(data_subject_informed_of_transfer, false), attribute(third_country_judgment_or_decision_requires_transfer, attested(false, attestation(by, at, reason, none))), attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, url(address, retrieved))))],
    findall(Problems, gdpr_chapter_v_extras_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems(not_a_list, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems(_Unbound, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_element_is_wrong_type_profile) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(party_role, controller), pair(a, b)], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_bare_boolean_outside_fact_is_wrong_type) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(transfer_is_onward_transfer, true)], Problems), Answers),
    Answers == [[wrong_type(transfer_is_onward_transfer)]].
test(an_attestation_with_an_unbound_argument_is_wrong_type) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(onward_transfer_has_chapter_v_basis, attested(true, attestation(by, _At, reason, none)))], Problems), Answers),
    Answers == [[wrong_type(onward_transfer_has_chapter_v_basis)]].
test(a_party_role_outside_the_enumeration_is_wrong_type) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(party_role, recipient)], Problems), Answers),
    Answers == [[wrong_type(party_role)]].
test(a_repeated_contract_key_is_one_duplicate_key) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(party_role, controller), attribute(party_role, wrong)], Problems), Answers),
    Answers == [[duplicate_key(party_role)]].
test(contract_problems_come_before_unknown_keys) :-
    Profile = [attribute(colour, blue), attribute(assessment_documented_in_records, yes), attribute(colour, red), attribute(42, any)],
    findall(Problems, gdpr_chapter_v_extras_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(assessment_documented_in_records), unknown_key(colour), unknown_key(42)]].
test(the_duty_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_49_1_second_subpara, _Record).
test(the_documentation_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_49_6, _Record).
test(the_article_48_and_article_44_citations_are_recorded) :-
    citation(eu_reg_2016_679_art_48, _RecordFortyEight),
    citation(eu_reg_2016_679_art_44, _RecordFortyFour).
test(a_referral_target_is_recorded) :-
    citation(second_subparagraph_transfer_statement, _Record).
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_49_6).
test(the_duty_verdict_atoms_are_distinct) :-
    dif(no_second_subparagraph_transfer, not_a_processor_duty),
    dif(no_second_subparagraph_transfer, duty_met),
    dif(no_second_subparagraph_transfer, duty_not_met),
    dif(not_a_processor_duty, duty_met),
    dif(not_a_processor_duty, duty_not_met),
    dif(duty_met, duty_not_met).
test(the_article_48_verdict_atoms_are_distinct) :-
    dif(article_48_not_engaged, not_barred_by_article_48),
    dif(article_48_not_engaged, not_recognisable_or_enforceable),
    dif(not_barred_by_article_48, not_recognisable_or_enforceable).
test(the_onward_verdict_atoms_are_distinct) :-
    dif(not_an_onward_transfer, onward_transfer_may_take_place),
    dif(not_an_onward_transfer, onward_transfer_may_not_take_place),
    dif(onward_transfer_may_take_place, onward_transfer_may_not_take_place).
test(the_basis_item_builds_and_destructures) :-
    Attested = attested(true, attestation(by, at, reason, none)),
    Item = outside_fact(transfer_relies_on_article_49_1_second_subparagraph, Attested),
    Item = outside_fact(Key, attested(Value, attestation(_By, _At, _Reason, Evidence))),
    Key == transfer_relies_on_article_49_1_second_subparagraph,
    Value == true,
    Evidence == none.
test(the_absent_referral_builds_and_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_48), cite(foreign_judgment_requires_transfer_statement)), [resolution(cite(foreign_judgment_requires_transfer_statement), not_attempted), inputs_relied_on([third_country_judgment_or_decision_requires_transfer - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Status), inputs_relied_on([Key - Absence])]),
    Citation == eu_reg_2016_679_art_48,
    Target == foreign_judgment_requires_transfer_statement,
    Status == not_attempted,
    Key == third_country_judgment_or_decision_requires_transfer,
    Absence == absent,
    citation(Citation, _CitationRecord),
    citation(Target, _TargetRecord).
test(the_status_compounds_build_and_destructure) :-
    Missing = indeterminate([party_role]),
    Missing = indeterminate([MissingKey]),
    MissingKey == party_role,
    Refusal = input_problems([wrong_type(profile), wrong_type(duty)]),
    Refusal = input_problems([FirstProblem, SecondProblem]),
    FirstProblem == wrong_type(profile),
    SecondProblem == wrong_type(duty).
test(the_status_compounds_are_distinct_constructors) :-
    dif(indeterminate(_), needs_legal_review(_, _)),
    dif(indeterminate(_), input_problems(_)),
    dif(needs_legal_review(_, _), input_problems(_)).

test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_49_7).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, a_list_with_a_foreign_element_is_wrong_type_profile, a_bare_boolean_outside_fact_is_wrong_type, an_attestation_with_an_unbound_argument_is_wrong_type, a_party_role_outside_the_enumeration_is_wrong_type, a_repeated_contract_key_is_one_duplicate_key, contract_problems_come_before_unknown_keys, the_duty_citation_is_recorded, the_documentation_citation_is_recorded, the_article_48_and_article_44_citations_are_recorded, a_referral_target_is_recorded, the_marker_holds_for_a_recorded_key, the_duty_verdict_atoms_are_distinct, the_article_48_verdict_atoms_are_distinct, the_onward_verdict_atoms_are_distinct, the_basis_item_builds_and_destructures, the_absent_referral_builds_and_destructures, the_status_compounds_build_and_destructure, the_status_compounds_are_distinct_constructors]).
cp_test_fail_names([the_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
