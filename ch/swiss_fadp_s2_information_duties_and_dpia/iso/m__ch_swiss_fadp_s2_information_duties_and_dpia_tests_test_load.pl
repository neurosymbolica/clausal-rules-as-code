% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s2_information_duties_and_dpia_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_kernel, [swiss_fadp_s2_information_duties_and_dpia_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = swiss_fadp_s2_information_duties_and_dpia_verdict(information_required, [cite(ch_fadp_art_19_1)]),
    Verdict = swiss_fadp_s2_information_duties_and_dpia_verdict(Status, Citations),
    Status == information_required,
    Citations == [cite(ch_fadp_art_19_1)].
test(the_indeterminate_compound_holds_one_bare_key) :-
    Status = indeterminate([data_subject_already_has_information]),
    Status = indeterminate([Key]),
    Key == data_subject_already_has_information.
test(the_referral_compound_destructures) :-
    Status = needs_legal_review(open_textured(data_subject_already_has_information, cite(ch_fadp_art_20_1_a)), [inputs_relied_on([data_subject_already_has_information - unsure])]),
    Status = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == data_subject_already_has_information,
    Citation == ch_fadp_art_20_1_a,
    Pairs == [data_subject_already_has_information - unsure].
test(the_information_duty_atoms_are_distinct) :-
    dif(information_required, information_not_required),
    dif(information_required, information_may_be_restricted_deferred_or_omitted),
    dif(information_not_required, information_may_be_restricted_deferred_or_omitted).
test(the_impact_assessment_atoms_are_distinct) :-
    dif(impact_assessment_required, impact_assessment_not_required),
    dif(impact_assessment_required, impact_assessment_may_be_omitted),
    dif(impact_assessment_not_required, impact_assessment_may_be_omitted).
test(the_other_answer_atoms_are_distinct) :-
    dif(information_item_required, information_item_not_required),
    dif(automated_decision_information_required, automated_decision_information_not_required),
    dif(view_and_review_rights_apply, view_and_review_rights_do_not_apply),
    dif(decision_marking_required, decision_marking_not_required),
    dif(same, differs).
test(the_duty_to_inform_citation_is_recorded) :-
    citation(ch_fadp_art_19_1, _Record).
test(the_eu_impact_assessment_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_35_10, _Record).
test(implements_succeeds_for_a_recorded_key) :-
    implements(ch_fadp_art_22_1).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, swiss_fadp_s2_information_duties_and_dpia_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(controller_is_federal_body, false), attribute(data_subject_already_has_information, unsure)], []).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(controller_is_federal_body, unsure)], [wrong_type(controller_is_federal_body)]).
test(a_key_outside_the_contract_is_unknown) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(not_a_contract_key, true)], [unknown_key(not_a_contract_key)]).
test(a_repeated_key_is_a_duplicate) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(controller_is_federal_body, true), attribute(controller_is_federal_body, false)], [duplicate_key(controller_is_federal_body)]).
test(a_term_that_is_not_an_attribute_list_is_wrong_type) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(not_a_profile, [wrong_type(profile)]).

test(implements_fails_for_an_unrecorded_key, fail) :-
    implements(ch_todo_primary_source).
test(a_bad_profile_is_not_problem_free, fail) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(not_a_profile, []).

cp_test_names([the_verdict_term_carries_status_and_citations, the_indeterminate_compound_holds_one_bare_key, the_referral_compound_destructures, the_information_duty_atoms_are_distinct, the_impact_assessment_atoms_are_distinct, the_other_answer_atoms_are_distinct, the_duty_to_inform_citation_is_recorded, the_eu_impact_assessment_citation_is_recorded, implements_succeeds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, a_key_outside_the_contract_is_unknown, a_repeated_key_is_a_duplicate, a_term_that_is_not_an_attribute_list_is_wrong_type]).
cp_test_fail_names([implements_fails_for_an_unrecorded_key, a_bad_profile_is_not_problem_free]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
