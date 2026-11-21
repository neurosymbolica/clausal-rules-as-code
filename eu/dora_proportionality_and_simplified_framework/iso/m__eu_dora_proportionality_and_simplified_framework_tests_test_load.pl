% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_kernel, [dora_proportionality_and_simplified_framework_input_problems/2, contract_key_order/1]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_citations, [citation/2, implements/1]).

test(the_contract_has_seventeen_keys) :-
    contract_key_order(Keys),
    length(Keys, 17).
test(the_contract_starts_with_the_entity_type) :-
    contract_key_order([dora_entity_type|_]).
test(the_contract_ends_with_the_review_report_key) :-
    contract_key_order(Keys),
    last(Keys, simplified_framework_review_report_submitted).
test(an_empty_profile_has_no_problem) :-
    dora_proportionality_and_simplified_framework_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, exempted_payment_institution), attribute(authority_requested_framework_review_report, false), attribute(ict_systems_continuously_monitored, unsure)], []).
test(an_unknown_key_is_named) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(stray_key, true)], [unknown_key(stray_key)]).
test(a_non_list_profile_is_wrong_type) :-
    dora_proportionality_and_simplified_framework_input_problems(not_a_list, [wrong_type(profile)]).
test(the_input_check_yields_one_answer) :-
    findall(Problems, dora_proportionality_and_simplified_framework_input_problems([attribute(iorp_pension_scheme_members_total, 50)], Problems), Answers),
    Answers == [[]].
test(the_required_term_carries_its_duties) :-
    Result = required([simplified_ict_risk_management_framework, continuous_monitoring_of_ict_systems]),
    Result = required(Duties),
    Duties == [simplified_ict_risk_management_framework, continuous_monitoring_of_ict_systems].
test(the_outstanding_term_carries_its_duties) :-
    Result = outstanding([review_report_to_authority]),
    Result = outstanding([Duty]),
    Duty == review_report_to_authority.
test(the_indeterminate_term_carries_one_key) :-
    Result = indeterminate([dora_entity_type]),
    Result = indeterminate(MissingKeys),
    MissingKeys == [dora_entity_type].
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(ict_systems_continuously_monitored, cite(eu_reg_2022_2554_art_16_1_b)), [inputs_relied_on([dora_entity_type - exempted_payment_institution, ict_systems_continuously_monitored - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == ict_systems_continuously_monitored,
    CitationKey == eu_reg_2022_2554_art_16_1_b,
    Pairs == [dora_entity_type - exempted_payment_institution, ict_systems_continuously_monitored - unsure].
test(the_input_problems_term_destructures) :-
    Result = input_problems([duplicate_key(dora_entity_type), wrong_type(iorp_pension_scheme_members_total), unknown_key(stray_key)]),
    Result = input_problems([duplicate_key(First), wrong_type(Second), unknown_key(Third)]),
    First == dora_entity_type,
    Second == iorp_pension_scheme_members_total,
    Third == stray_key.
test(the_facade_verdict_term_carries_status_and_citations) :-
    Verdict = dora_proportionality_and_simplified_framework_verdict(complete, [cite(eu_reg_2022_2554_art_4_1)]),
    Verdict = dora_proportionality_and_simplified_framework_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2022_2554_art_4_1)].
test(the_qualification_atoms_are_distinct) :-
    dif(article_16_1_entity, not_article_16_1_entity),
    dif(article_16_1_entity, out_of_scope),
    dif(article_16_1_entity, not_a_financial_entity),
    dif(not_article_16_1_entity, out_of_scope),
    dif(not_article_16_1_entity, not_a_financial_entity),
    dif(out_of_scope, not_a_financial_entity).
test(the_duty_answer_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, none_outstanding),
    dif(incomplete, none_outstanding).
test(the_twelve_duty_atoms_are_distinct) :-
    Duties = [simplified_ict_risk_management_framework, continuous_monitoring_of_ict_systems, ict_risk_impact_minimisation, detection_and_handling, key_third_party_dependencies, continuity_of_critical_or_important_functions, regular_testing, operational_conclusions_implemented, awareness_and_training_programmes, framework_documentation_and_review, continuous_improvement, review_report_to_authority],
    sort(Duties, Sorted),
    length(Sorted, 12).
test(the_article_16_1_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_proportionality_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_4_1, _Record).
test(the_review_citation_implements) :-
    implements(eu_reg_2022_2554_art_16_2).

test(a_well_formed_profile_is_not_refused, fail) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, exempted_payment_institution)], [_|_]).
test(complete_is_not_incomplete, fail) :-
    complete = incomplete.
test(an_unrecorded_key_does_not_resolve, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_contract_has_seventeen_keys, the_contract_starts_with_the_entity_type, the_contract_ends_with_the_review_report_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_unknown_key_is_named, a_non_list_profile_is_wrong_type, the_input_check_yields_one_answer, the_required_term_carries_its_duties, the_outstanding_term_carries_its_duties, the_indeterminate_term_carries_one_key, the_referral_term_destructures, the_input_problems_term_destructures, the_facade_verdict_term_carries_status_and_citations, the_qualification_atoms_are_distinct, the_duty_answer_atoms_are_distinct, the_twelve_duty_atoms_are_distinct, the_article_16_1_citation_is_recorded, the_proportionality_citation_is_recorded, the_review_citation_implements]).
cp_test_fail_names([a_well_formed_profile_is_not_refused, complete_is_not_incomplete, an_unrecorded_key_does_not_resolve]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
