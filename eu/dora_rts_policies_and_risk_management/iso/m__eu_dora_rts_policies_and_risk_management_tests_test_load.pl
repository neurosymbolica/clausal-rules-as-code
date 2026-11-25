% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_policies_and_risk_management_kernel, [dora_rts_policies_and_risk_management_input_problems/2]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_citations, [citation/2, implements/1]).

test(the_complete_query_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, simplified_framework_entity),
    dif(incomplete, simplified_framework_entity).
test(the_outstanding_query_atoms_are_distinct) :-
    dif(none_outstanding, simplified_framework_entity),
    dif(none_outstanding, complete).
test(the_problem_constructors_are_distinct) :-
    dif(duplicate_key(profile), wrong_type(profile)),
    dif(wrong_type(profile), unknown_key(profile)),
    dif(duplicate_key(profile), unknown_key(profile)).
test(the_judgement_value_unsure_is_not_a_boolean) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_rts_policies_and_risk_management_verdict(complete, [cite(eu_reg_2024_1774_art_1)]),
    Verdict = dora_rts_policies_and_risk_management_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2024_1774_art_1)].
test(the_required_term_has_arity_one) :-
    Result = required([risk_profile_and_complexity_consideration, embedding_of_security_policies]),
    functor(Result, required, 1),
    Result = required(Duties),
    Duties == [risk_profile_and_complexity_consideration, embedding_of_security_policies].
test(the_outstanding_term_has_arity_one) :-
    Result = outstanding([assessment_of_corrective_actions]),
    functor(Result, outstanding, 1),
    Result = outstanding(Duties),
    Duties == [assessment_of_corrective_actions].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate(MissingKeys),
    length(MissingKeys, 1),
    MissingKeys == [financial_entity_is_article_16_1_entity].
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(size_risk_profile_and_complexity_taken_into_account, cite(eu_reg_2024_1774_art_1)), [inputs_relied_on([financial_entity_is_article_16_1_entity - false, size_risk_profile_and_complexity_taken_into_account - unsure])]),
    Result = needs_legal_review(Reason, Context),
    Reason = open_textured(Key, cite(CitationKey)),
    Key == size_risk_profile_and_complexity_taken_into_account,
    CitationKey == eu_reg_2024_1774_art_1,
    Context = [inputs_relied_on(Pairs)],
    Pairs == [financial_entity_is_article_16_1_entity - false, size_risk_profile_and_complexity_taken_into_account - unsure].
test(the_input_problems_term_destructures) :-
    Result = input_problems([wrong_type(profile)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(profile)].
test(the_gate_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(the_article_one_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(a_second_run_citation_is_recorded) :-
    implements(eu_reg_2024_1774_art_3_c_run2).
test(the_empty_profile_has_no_problem) :-
    dora_rts_policies_and_risk_management_input_problems([], []).
test(the_gate_alone_has_no_problem) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(financial_entity_is_article_16_1_entity, true)], []).
test(the_input_check_gives_one_answer) :-
    findall(Problems, dora_rts_policies_and_risk_management_input_problems([attribute(financial_entity_is_article_16_1_entity, true)], Problems), Answers),
    Answers == [[]].
test(an_unknown_key_is_named) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(a_non_attribute_element_is_wrong_type_profile) :-
    dora_rts_policies_and_risk_management_input_problems([colour], [wrong_type(profile)]).

test(a_shortened_citation_is_not_recorded, fail) :-
    citation(art_3_c_run2, _).
test(an_unknown_key_is_not_accepted, fail) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(colour, red)], []).

cp_test_names([the_complete_query_atoms_are_distinct, the_outstanding_query_atoms_are_distinct, the_problem_constructors_are_distinct, the_judgement_value_unsure_is_not_a_boolean, the_verdict_term_carries_status_and_citations, the_required_term_has_arity_one, the_outstanding_term_has_arity_one, the_indeterminate_term_names_one_key, the_referral_term_destructures, the_input_problems_term_destructures, the_gate_citation_is_recorded, the_article_one_citation_is_recorded, a_second_run_citation_is_recorded, the_empty_profile_has_no_problem, the_gate_alone_has_no_problem, the_input_check_gives_one_answer, an_unknown_key_is_named, a_non_attribute_element_is_wrong_type_profile]).
cp_test_fail_names([a_shortened_citation_is_not_recorded, an_unknown_key_is_not_accepted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
