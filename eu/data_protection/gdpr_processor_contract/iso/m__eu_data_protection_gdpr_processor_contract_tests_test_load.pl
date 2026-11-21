% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_kernel, [gdpr_processor_contract_input_problems/2, gdpr_processor_contract_key_order/1]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_citations, [citation/2, implements/1]).

test(the_key_order_loads_with_thirty_two_keys) :-
    gdpr_processor_contract_key_order(KeyOrder),
    length(KeyOrder, 32).
test(the_key_order_has_exactly_one_solution) :-
    findall(KeyOrder, gdpr_processor_contract_key_order(KeyOrder), KeyOrders),
    length(KeyOrders, 1).
test(the_key_order_starts_and_ends_alphabetically) :-
    gdpr_processor_contract_key_order([FirstKey|_]),
    FirstKey == contract_binding_on_processor,
    gdpr_processor_contract_key_order(KeyOrder),
    last(KeyOrder, LastKey),
    LastKey == subprocessor_provides_sufficient_guarantees.
test(the_outside_fact_has_its_root_exports_position) :-
    gdpr_processor_contract_key_order(KeyOrder),
    nth1(16, KeyOrder, Key),
    Key == standard_clauses_adopted.
test(a_well_formed_profile_has_no_input_problem) :-
    gdpr_processor_contract_input_problems([attribute(processing_on_behalf_of_controller, true), attribute(processor_determines_purposes_and_means, false), attribute(subprocessor_authorisation, general_written)], Problems),
    Problems == [].
test(the_input_check_has_exactly_one_answer) :-
    findall(Problems, gdpr_processor_contract_input_problems([attribute(contract_in_writing, maybe), attribute(stray_key, true)], Problems), Answers),
    Answers == [[wrong_type(contract_in_writing), unknown_key(stray_key)]].
test(a_non_list_profile_is_one_problem) :-
    gdpr_processor_contract_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(the_verdict_term_carries_status_missing_and_citations) :-
    Verdict = processor_contract_verdict(ineligible, [contract_in_writing], [cite(eu_reg_2016_679_art_28_9)]),
    Verdict = processor_contract_verdict(Status, Missing, Citations),
    Status == ineligible,
    Missing == [contract_in_writing],
    Citations == [cite(eu_reg_2016_679_art_28_9)].
test(the_not_applicable_verdict_cites_the_processor_definition) :-
    Verdict = processor_contract_verdict(not_applicable, [], [cite(eu_reg_2016_679_art_4_8)]),
    Verdict = processor_contract_verdict(not_applicable, Missing, [cite(CitationKey)]),
    Missing == [],
    citation(CitationKey, _Record).
test(the_indeterminate_status_is_a_compound) :-
    Status = indeterminate([processing_on_behalf_of_controller]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [processing_on_behalf_of_controller].
test(the_referral_term_destructures) :-
    Status = needs_legal_review(open_textured(processing_on_behalf_of_controller, cite(eu_reg_2016_679_art_4_8)), [inputs_relied_on([processing_on_behalf_of_controller - unsure, standard_clauses_adopted - absent])]),
    Status = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == processing_on_behalf_of_controller,
    CitationKey == eu_reg_2016_679_art_4_8,
    Pairs == [processing_on_behalf_of_controller - unsure, standard_clauses_adopted - absent].
test(the_deferred_provision_term_destructures) :-
    Reason = deferred_provision(cite(eu_reg_2016_679_art_28_10)),
    Reason = deferred_provision(cite(CitationKey)),
    implements(CitationKey).
test(the_checklist_item_destructures) :-
    Item = checklist_item(stipulates_security_measures, cite(eu_reg_2016_679_art_28_3_c), unmet),
    Item = checklist_item(Key, cite(CitationKey), State),
    Key == stipulates_security_measures,
    CitationKey == eu_reg_2016_679_art_28_3_c,
    State == unmet.
test(the_outside_fact_item_destructures) :-
    Item = outside_fact(standard_clauses_adopted, attested(true, attestation(host, moment, reason, document(upload, digest)))),
    Item = outside_fact(Key, attested(Value, attestation(_, _, _, Evidence))),
    Key == standard_clauses_adopted,
    Value == true,
    Evidence = document(_, _).
test(the_input_problems_status_destructures) :-
    Verdict = processor_contract_verdict(input_problems([duplicate_key(contract_in_writing), unknown_key(stray_key)]), [], []),
    Verdict = processor_contract_verdict(input_problems(Problems), Missing, Citations),
    Problems == [duplicate_key(contract_in_writing), unknown_key(stray_key)],
    Missing == [],
    Citations == [].
test(the_bare_statuses_are_distinct) :-
    dif(eligible, ineligible),
    dif(eligible, not_applicable),
    dif(ineligible, not_applicable).
test(the_checklist_states_are_distinct) :-
    dif(met, unmet),
    dif(met, open_by_absence),
    dif(met, open_by_judgement),
    dif(unmet, open_by_absence),
    dif(unmet, open_by_judgement),
    dif(open_by_absence, open_by_judgement).
test(the_input_problem_kinds_are_distinct) :-
    dif(unknown_key(stray_key), wrong_type(stray_key)),
    dif(wrong_type(stray_key), duplicate_key(stray_key)),
    dif(unknown_key(stray_key), duplicate_key(stray_key)).
test(the_authorisation_kinds_are_distinct) :-
    dif(specific_written, general_written),
    dif(specific_written, none),
    dif(general_written, none).
test(the_referral_reasons_are_distinct) :-
    dif(open_textured(processing_on_behalf_of_controller, cite(eu_reg_2016_679_art_4_8)), deferred_provision(cite(eu_reg_2016_679_art_28_10))).
test(the_processor_definition_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_4_8, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_sufficient_guarantees_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_28_1, _Record).
test(the_second_subparagraph_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_28_3_second_subpara, _Record).
test(every_emitted_citation_key_is_recorded) :-
    implements(eu_reg_2016_679_art_4_8),
    implements(eu_reg_2016_679_art_28_1),
    implements(eu_reg_2016_679_art_28_2),
    implements(eu_reg_2016_679_art_28_3),
    implements(eu_reg_2016_679_art_28_3_a),
    implements(eu_reg_2016_679_art_28_3_b),
    implements(eu_reg_2016_679_art_28_3_c),
    implements(eu_reg_2016_679_art_28_3_d),
    implements(eu_reg_2016_679_art_28_3_e),
    implements(eu_reg_2016_679_art_28_3_f),
    implements(eu_reg_2016_679_art_28_3_g),
    implements(eu_reg_2016_679_art_28_3_h),
    implements(eu_reg_2016_679_art_28_3_second_subpara),
    implements(eu_reg_2016_679_art_28_4),
    implements(eu_reg_2016_679_art_28_6),
    implements(eu_reg_2016_679_art_28_7),
    implements(eu_reg_2016_679_art_28_9),
    implements(eu_reg_2016_679_art_28_10).

test(a_well_formed_profile_is_not_reported_as_wrong_type, fail) :-
    gdpr_processor_contract_input_problems([attribute(processing_on_behalf_of_controller, true)], [wrong_type(_)|_]).
test(the_compound_indeterminate_is_not_the_bare_atom, fail) :-
    indeterminate([processing_on_behalf_of_controller]) == indeterminate.
test(an_invented_short_citation_key_is_not_recorded, fail) :-
    citation(art_28_3, _Record).

cp_test_names([the_key_order_loads_with_thirty_two_keys, the_key_order_has_exactly_one_solution, the_key_order_starts_and_ends_alphabetically, the_outside_fact_has_its_root_exports_position, a_well_formed_profile_has_no_input_problem, the_input_check_has_exactly_one_answer, a_non_list_profile_is_one_problem, the_verdict_term_carries_status_missing_and_citations, the_not_applicable_verdict_cites_the_processor_definition, the_indeterminate_status_is_a_compound, the_referral_term_destructures, the_deferred_provision_term_destructures, the_checklist_item_destructures, the_outside_fact_item_destructures, the_input_problems_status_destructures, the_bare_statuses_are_distinct, the_checklist_states_are_distinct, the_input_problem_kinds_are_distinct, the_authorisation_kinds_are_distinct, the_referral_reasons_are_distinct, the_processor_definition_citation_is_recorded, the_sufficient_guarantees_citation_is_recorded, the_second_subparagraph_citation_is_recorded, every_emitted_citation_key_is_recorded]).
cp_test_fail_names([a_well_formed_profile_is_not_reported_as_wrong_type, the_compound_indeterminate_is_not_the_bare_atom, an_invented_short_citation_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
