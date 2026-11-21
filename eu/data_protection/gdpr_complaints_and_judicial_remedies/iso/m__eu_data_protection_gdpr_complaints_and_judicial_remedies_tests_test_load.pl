% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_citations, [citation/2, implements/1]).

test(the_kernel_input_check_loads_and_accepts_an_empty_profile) :-
    gdpr_complaints_and_judicial_remedies_input_problems([], Problems),
    Problems == [].
test(the_kernel_input_check_refuses_a_non_attribute_list) :-
    gdpr_complaints_and_judicial_remedies_input_problems(not_a_list, Problems),
    Problems == [wrong_type(profile)].
test(the_kernel_input_check_names_an_unknown_key) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(the_complaint_right_atoms_are_distinct) :-
    dif(complaint_right_exists, no_complaint_right).
test(the_decision_remedy_atoms_are_distinct) :-
    dif(decision_remedy_right_exists, no_decision_remedy_right).
test(the_inaction_remedy_atoms_are_distinct) :-
    dif(inaction_remedy_right_exists, no_inaction_remedy_right).
test(the_judicial_remedy_atoms_are_distinct) :-
    dif(judicial_remedy_right_exists, no_judicial_remedy_right).
test(the_forum_atoms_are_distinct) :-
    dif(forum_establishment_state_only, forum_establishment_or_habitual_residence_state).
test(the_ten_result_atoms_are_ten) :-
    Atoms = [complaint_right_exists, no_complaint_right, decision_remedy_right_exists, no_decision_remedy_right, inaction_remedy_right_exists, no_inaction_remedy_right, judicial_remedy_right_exists, no_judicial_remedy_right, forum_establishment_state_only, forum_establishment_or_habitual_residence_state],
    sort(Atoms, Distinct),
    length(Distinct, Count),
    Count == 10.
test(the_verdict_term_carries_answer_and_citations) :-
    Verdict = gdpr_complaints_and_judicial_remedies_verdict(answer(complaint_right, complaint_right_exists), [cite(eu_reg_2016_679_art_77_1)]),
    Verdict = gdpr_complaints_and_judicial_remedies_verdict(answer(Query, Result), Citations),
    Query == complaint_right,
    Result == complaint_right_exists,
    Citations == [cite(eu_reg_2016_679_art_77_1)].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([is_data_subject]),
    Result = indeterminate([Key]),
    Key == is_data_subject.
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])]),
    Result = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == decision_is_legally_binding,
    Citation == eu_reg_2016_679_art_78_1,
    Pairs == [decision_is_legally_binding - unsure, decision_concerns_the_caller - true].
test(the_cross_reference_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Status), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_78_2,
    Target == competence_statement,
    Status == not_attempted,
    Pairs == [authority_competent_under_articles_55_and_56 - absent].
test(the_outside_fact_basis_destructures) :-
    Basis = [outside_fact(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, reason, none)))],
    Basis = [outside_fact(Key, attested(Value, attestation(By, At, Reason, Evidence)))],
    Key == authority_competent_under_articles_55_and_56,
    Value == true,
    By == host,
    At == at,
    Reason == reason,
    Evidence == none.
test(the_input_problems_term_destructures) :-
    Result = input_problems([duplicate_key(is_data_subject), wrong_type(decision_concerns_the_caller), unknown_key(colour)]),
    Result = input_problems([duplicate_key(First), wrong_type(Second), unknown_key(Third)]),
    First == is_data_subject,
    Second == decision_concerns_the_caller,
    Third == colour.
test(the_art_77_1_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_77_1, _Record).
test(every_canonical_citation_is_recorded) :-
    implements(eu_reg_2016_679_art_77_1),
    implements(eu_reg_2016_679_art_78_1),
    implements(eu_reg_2016_679_art_78_2),
    implements(eu_reg_2016_679_art_79_1),
    implements(eu_reg_2016_679_art_79_2).
test(the_cross_reference_target_is_recorded) :-
    citation(competence_statement, _Record).

test(a_well_formed_profile_has_no_problem_list, fail) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(is_data_subject, true)], [_|_]).
test(a_non_final_result_is_not_a_final_atom, fail) :-
    indeterminate([is_data_subject]) = complaint_right_exists.
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(gdpr_art_77_1, _Record).

cp_test_names([the_kernel_input_check_loads_and_accepts_an_empty_profile, the_kernel_input_check_refuses_a_non_attribute_list, the_kernel_input_check_names_an_unknown_key, the_complaint_right_atoms_are_distinct, the_decision_remedy_atoms_are_distinct, the_inaction_remedy_atoms_are_distinct, the_judicial_remedy_atoms_are_distinct, the_forum_atoms_are_distinct, the_ten_result_atoms_are_ten, the_verdict_term_carries_answer_and_citations, the_indeterminate_term_names_one_key, the_open_textured_referral_destructures, the_cross_reference_referral_destructures, the_outside_fact_basis_destructures, the_input_problems_term_destructures, the_art_77_1_citation_is_recorded, every_canonical_citation_is_recorded, the_cross_reference_target_is_recorded]).
cp_test_fail_names([a_well_formed_profile_has_no_problem_list, a_non_final_result_is_not_a_final_atom, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
