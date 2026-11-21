% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_kernel, [gdpr_representation_and_suspension_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_result_basis_and_citations) :-
    Verdict = gdpr_representation_and_suspension_verdict(may_act_on_mandate, [], [cite(eu_reg_2016_679_art_80_1)]),
    Verdict = gdpr_representation_and_suspension_verdict(Result, Basis, Citations),
    Result == may_act_on_mandate,
    Basis == [],
    Citations == [cite(eu_reg_2016_679_art_80_1)].
test(the_basis_item_carries_the_attested_term_as_supplied) :-
    Attested = attested(true, attestation(by, at, reason, none)),
    Item = outside_fact(court_first_seized_has_jurisdiction_over_the_actions, Attested),
    Item = outside_fact(Key, attested(Value, attestation(_, _, _, Evidence))),
    Key == court_first_seized_has_jurisdiction_over_the_actions,
    Value == true,
    Evidence == none.
test(the_indeterminate_status_names_one_key) :-
    Status = indeterminate([body_is_not_for_profit]),
    Status = indeterminate([MissingKey]),
    MissingKey == body_is_not_for_profit.
test(the_absent_referral_destructures) :-
    Status = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_81_3), cite(court_first_seized_jurisdiction_statement)), [resolution(cite(court_first_seized_jurisdiction_statement), not_attempted), inputs_relied_on([court_first_seized_has_jurisdiction_over_the_actions - absent])]),
    Status = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Resolution), inputs_relied_on([Key - Value])]),
    Citation == eu_reg_2016_679_art_81_3,
    Target == court_first_seized_jurisdiction_statement,
    Resolution == not_attempted,
    Key == court_first_seized_has_jurisdiction_over_the_actions,
    Value == absent.
test(the_open_textured_referral_destructures) :-
    Status = needs_legal_review(open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_2)), [inputs_relied_on([other_proceedings_concern_same_subject_matter - unsure])]),
    Status = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == other_proceedings_concern_same_subject_matter,
    Citation == eu_reg_2016_679_art_81_2,
    Pairs == [other_proceedings_concern_same_subject_matter - unsure].
test(the_article_80_1_atoms_are_distinct) :-
    dif(may_act_on_mandate, may_not_act_on_mandate).
test(the_article_80_2_atoms_are_distinct) :-
    dif(may_act_without_mandate, may_not_act_without_mandate).
test(the_article_81_1_atoms_are_distinct) :-
    dif(contact_duty_applies, contact_duty_does_not_apply).
test(the_article_81_2_atoms_are_distinct) :-
    dif(may_suspend_proceedings, suspension_not_available).
test(the_article_81_3_atoms_are_distinct) :-
    dif(may_decline_jurisdiction, declining_jurisdiction_not_available).
test(the_ten_result_atoms_are_ten) :-
    sort([may_act_on_mandate, may_not_act_on_mandate, may_act_without_mandate, may_not_act_without_mandate, contact_duty_applies, contact_duty_does_not_apply, may_suspend_proceedings, suspension_not_available, may_decline_jurisdiction, declining_jurisdiction_not_available], Atoms),
    length(Atoms, 10).
test(the_four_action_atoms_are_four) :-
    sort([lodge_complaint_under_article_77, exercise_rights_under_article_78, exercise_right_under_article_79, receive_compensation_under_article_82], Actions),
    length(Actions, 4).
test(the_article_80_1_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_80_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(every_query_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_80_1, _),
    citation(eu_reg_2016_679_art_80_2, _),
    citation(eu_reg_2016_679_art_81_1, _),
    citation(eu_reg_2016_679_art_81_2, _),
    citation(eu_reg_2016_679_art_81_3, _).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_81_3).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_representation_and_suspension_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    findall(Problems, gdpr_representation_and_suspension_input_problems([attribute(body_is_not_for_profit, unsure)], Problems), Answers),
    Answers == [[wrong_type(body_is_not_for_profit)]].
test(a_judgement_key_given_unsure_has_no_problem) :-
    gdpr_representation_and_suspension_input_problems([attribute(other_proceedings_concern_same_subject_matter, unsure)], []).
test(an_attested_outside_fact_has_no_problem) :-
    gdpr_representation_and_suspension_input_problems([attribute(court_first_seized_has_jurisdiction_over_the_actions, attested(true, attestation(by, at, reason, none)))], []).
test(a_bare_outside_fact_is_a_wrong_type) :-
    gdpr_representation_and_suspension_input_problems([attribute(court_first_seized_has_jurisdiction_over_the_actions, true)], [wrong_type(court_first_seized_has_jurisdiction_over_the_actions)]).
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_representation_and_suspension_input_problems([attribute(favourite_colour, true)], [unknown_key(favourite_colour)]).
test(a_repeated_key_is_a_duplicate) :-
    gdpr_representation_and_suspension_input_problems([attribute(court_is_competent_court, true), attribute(court_is_competent_court, unsure)], [duplicate_key(court_is_competent_court)]).
test(a_term_that_is_not_a_list_is_a_wrong_type_profile) :-
    findall(Problems, gdpr_representation_and_suspension_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].

test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _).
test(an_empty_profile_has_no_wrong_type_problem, fail) :-
    gdpr_representation_and_suspension_input_problems([], [wrong_type(profile)]).

cp_test_names([the_verdict_term_carries_result_basis_and_citations, the_basis_item_carries_the_attested_term_as_supplied, the_indeterminate_status_names_one_key, the_absent_referral_destructures, the_open_textured_referral_destructures, the_article_80_1_atoms_are_distinct, the_article_80_2_atoms_are_distinct, the_article_81_1_atoms_are_distinct, the_article_81_2_atoms_are_distinct, the_article_81_3_atoms_are_distinct, the_ten_result_atoms_are_ten, the_four_action_atoms_are_four, the_article_80_1_citation_is_recorded, every_query_citation_is_recorded, a_recorded_key_is_implemented, an_empty_profile_has_no_problem, a_crisp_key_given_unsure_is_a_wrong_type, a_judgement_key_given_unsure_has_no_problem, an_attested_outside_fact_has_no_problem, a_bare_outside_fact_is_a_wrong_type, a_key_outside_the_contract_is_unknown, a_repeated_key_is_a_duplicate, a_term_that_is_not_a_list_is_a_wrong_type_profile]).
cp_test_fail_names([the_placeholder_citation_is_not_recorded, an_empty_profile_has_no_wrong_type_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
