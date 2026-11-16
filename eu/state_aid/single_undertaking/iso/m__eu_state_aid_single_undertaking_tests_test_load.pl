% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_single_undertaking_kernel, [single_undertaking_input_problems/2]).
:- use_module(m__eu_state_aid_single_undertaking_citations, [citation/2, implements/1]).

test(the_lead_in_citation_is_recorded) :-
    citation(eu_reg_2023_2831_art_2_2, _Record).
test(the_closing_sentence_citation_is_recorded) :-
    citation(eu_reg_2023_2831_art_2_t1, _Record).
test(every_point_citation_is_implemented) :-
    implements(eu_reg_2023_2831_art_2_2_a),
    implements(eu_reg_2023_2831_art_2_2_b),
    implements(eu_reg_2023_2831_art_2_2_c),
    implements(eu_reg_2023_2831_art_2_2_d).
test(the_lead_in_record_has_label_reference_and_verbatim) :-
    citation(eu_reg_2023_2831_art_2_2, RecordPairs),
    RecordPairs = [label - _, ref - _, verbatim - _].
test(the_direct_relationship_atoms_are_distinct) :-
    dif(directly_related, not_directly_related).
test(the_single_undertaking_atoms_are_distinct) :-
    dif(single_undertaking, not_single_undertaking),
    dif(single_undertaking, members_settled),
    dif(not_single_undertaking, members_settled).
test(the_limb_atoms_are_distinct) :-
    sort([point_a, point_b, point_c, point_d], SortedLimbs),
    length(SortedLimbs, 4).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = single_undertaking_verdict(single_undertaking, [cite(eu_reg_2023_2831_art_2_2)]),
    Verdict = single_undertaking_verdict(Status, Citations),
    Status == single_undertaking,
    Citations == [cite(eu_reg_2023_2831_art_2_2)].
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([relationships_complete]),
    Result = indeterminate([MissingKey]),
    MissingKey == relationships_complete.
test(the_referral_status_destructures) :-
    Result = needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_2023_2831_art_2_2_c)), [inputs_relied_on([dominant_influence_by_contract_or_articles - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(RelyPairs)]),
    Input == dominant_influence_by_contract_or_articles,
    citation(CitationKey, _Record),
    RelyPairs == [dominant_influence_by_contract_or_articles - unsure].
test(the_relationship_term_destructures) :-
    Relation = relationship(alpha, beta, point_b, unsure),
    Relation = relationship(Holder, Held, Point, Certainty),
    Holder == alpha,
    Held == beta,
    Point == point_b,
    Certainty == unsure.
test(an_empty_profile_has_no_problem) :-
    findall(Problems, single_undertaking_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_an_attribute_list_is_wrong_type) :-
    single_undertaking_input_problems(stray, Problems),
    Problems == [wrong_type(profile)].
test(an_input_problem_wraps_in_the_status_compound) :-
    single_undertaking_input_problems([attribute(colour, red)], Problems),
    Result = input_problems(Problems),
    Result == input_problems([unknown_key(colour)]).

test(an_invented_citation_is_not_implemented, fail) :-
    implements(eu_reg_2023_2831_art_2_2_e).

cp_test_names([the_lead_in_citation_is_recorded, the_closing_sentence_citation_is_recorded, every_point_citation_is_implemented, the_lead_in_record_has_label_reference_and_verbatim, the_direct_relationship_atoms_are_distinct, the_single_undertaking_atoms_are_distinct, the_limb_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_status_names_one_key, the_referral_status_destructures, the_relationship_term_destructures, an_empty_profile_has_no_problem, a_term_that_is_not_an_attribute_list_is_wrong_type, an_input_problem_wraps_in_the_status_compound]).
cp_test_fail_names([an_invented_citation_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
