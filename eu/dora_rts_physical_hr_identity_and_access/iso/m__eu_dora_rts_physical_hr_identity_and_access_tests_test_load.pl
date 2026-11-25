% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_physical_hr_identity_and_access_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_kernel, [dora_rts_physical_hr_identity_and_access_input_problems/2]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_citations, [citation/2, implements/1]).

test(the_access_control_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_21, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_gate_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(the_physical_security_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_18_1, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2024_1774_art_20_2).
test(the_complete_query_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, simplified_framework_entity),
    dif(incomplete, simplified_framework_entity).
test(the_outstanding_query_atoms_are_distinct) :-
    dif(none_outstanding, simplified_framework_entity),
    dif(none_outstanding, complete).
test(the_judgement_values_are_distinct) :-
    dif(true, false),
    dif(true, unsure),
    dif(false, unsure).
test(the_required_term_carries_its_duties) :-
    Result = required([physical_and_environmental_security_policy, access_control_policy]),
    Result = required(Duties),
    Duties == [physical_and_environmental_security_policy, access_control_policy].
test(the_outstanding_term_carries_its_duties) :-
    Result = outstanding([segregation_of_duties]),
    Result = outstanding(Duties),
    Duties == [segregation_of_duties].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate([MissingKey]),
    MissingKey == financial_entity_is_article_16_1_entity.
test(the_review_term_carries_reason_and_context) :-
    Result = needs_legal_review(open_textured(access_control_policy_contains_segregation_of_duties, cite(eu_reg_2024_1774_art_21_b)), [inputs_relied_on([access_control_policy_contains_segregation_of_duties - unsure])]),
    Result = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == access_control_policy_contains_segregation_of_duties,
    Citation == cite(eu_reg_2024_1774_art_21_b),
    Pairs == [access_control_policy_contains_segregation_of_duties - unsure].
test(the_review_citation_is_a_recorded_key) :-
    Reason = open_textured(access_control_policy_contains_segregation_of_duties, cite(eu_reg_2024_1774_art_21_b)),
    Reason = open_textured(_, cite(CitationKey)),
    citation(CitationKey, _Record).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_rts_physical_hr_identity_and_access_verdict(complete, [cite(eu_reg_2024_1774_art_18_1)]),
    Verdict = dora_rts_physical_hr_identity_and_access_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2024_1774_art_18_1)].
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dora_rts_physical_hr_identity_and_access_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(access_control_policy_developed_documented_and_implemented, true)], []).
test(a_non_list_profile_is_wrong_type) :-
    dora_rts_physical_hr_identity_and_access_input_problems(profile, [wrong_type(profile)]).
test(an_unknown_key_is_named) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(entity_size, small)], [unknown_key(entity_size)]).

test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).
test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2024_1774_art_22).
test(a_status_compound_is_not_a_bare_atom, fail) :-
    indeterminate([financial_entity_is_article_16_1_entity]) = indeterminate.
test(an_unknown_key_is_not_clean, fail) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(entity_size, small)], []).

cp_test_names([the_access_control_citation_is_recorded, the_gate_citation_is_recorded, the_physical_security_citation_is_recorded, a_recorded_key_is_implemented, the_complete_query_atoms_are_distinct, the_outstanding_query_atoms_are_distinct, the_judgement_values_are_distinct, the_required_term_carries_its_duties, the_outstanding_term_carries_its_duties, the_indeterminate_term_names_one_key, the_review_term_carries_reason_and_context, the_review_citation_is_a_recorded_key, the_verdict_term_carries_status_and_citations, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_non_list_profile_is_wrong_type, an_unknown_key_is_named]).
cp_test_fail_names([the_placeholder_citation_is_gone, an_unrecorded_key_is_not_implemented, a_status_compound_is_not_a_bare_atom, an_unknown_key_is_not_clean]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
