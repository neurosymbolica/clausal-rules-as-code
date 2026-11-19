% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_virginia_vcdpa_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_virginia_vcdpa_kernel, [virginia_vcdpa_input_problems/2, query_problems/3, date_argument_problems/2, value_or_absent/3]).
:- use_module(m__us_virginia_vcdpa_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = virginia_vcdpa_verdict(in_scope, [cite(us_va_code_59_1_576_a)]),
    Verdict = virginia_vcdpa_verdict(Status, Citations),
    Status == in_scope,
    Citations == [cite(us_va_code_59_1_576_a)].
test(the_exempt_verdict_cites_subsection_b) :-
    Verdict = virginia_vcdpa_verdict(exempt_entity, [cite(us_va_code_59_1_576_b)]),
    Verdict = virginia_vcdpa_verdict(Status, [cite(Key)]),
    Status == exempt_entity,
    citation(Key, _).
test(the_applicability_atoms_are_distinct) :-
    dif(in_scope, out_of_scope),
    dif(in_scope, exempt_entity),
    dif(out_of_scope, exempt_entity).
test(the_action_status_atoms_are_distinct) :-
    dif(notice_not_yet_provided, cure_period_running),
    dif(notice_not_yet_provided, action_may_be_initiated),
    dif(notice_not_yet_provided, no_action_for_cured_violation),
    dif(cure_period_running, action_may_be_initiated),
    dif(cure_period_running, no_action_for_cured_violation),
    dif(action_may_be_initiated, no_action_for_cured_violation).
test(the_extension_atom_is_not_a_date) :-
    dif(no_extension_available, date(_, _, _)).
test(the_indeterminate_status_names_one_key) :-
    Answer = indeterminate([entity_category]),
    Answer = indeterminate(MissingKeys),
    MissingKeys == [entity_category].
test(the_indeterminate_compound_is_not_the_bare_atom) :-
    dif(indeterminate([entity_category]), indeterminate).
test(the_legal_review_status_destructures) :-
    Answer = needs_legal_review(open_textured(conducts_business_in_or_targets_virginia, cite(us_va_code_59_1_576_a)), [inputs_relied_on([conducts_business_in_or_targets_virginia - unsure])]),
    Answer = needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]),
    Input == conducts_business_in_or_targets_virginia,
    Pairs == [conducts_business_in_or_targets_virginia - unsure],
    citation(Key, _).
test(the_input_problems_status_destructures) :-
    Answer = input_problems([unknown_key(colour), wrong_type(received_date)]),
    Answer = input_problems(Problems),
    Problems == [unknown_key(colour), wrong_type(received_date)].
test(the_applicability_citation_is_recorded) :-
    citation(us_va_code_59_1_576_a, _Record).
test(every_answer_citation_is_recorded) :-
    implements(us_va_code_59_1_576_a),
    implements(us_va_code_59_1_576_b),
    implements(us_va_code_59_1_577_b_1),
    implements(us_va_code_59_1_577_b_2),
    implements(us_va_code_59_1_577_c),
    implements(us_va_code_59_1_584_b),
    implements(us_va_code_59_1_584_c).
test(the_citation_record_has_label_reference_and_verbatim) :-
    citation(us_va_code_59_1_584_c, Record),
    Record = [label - _, ref - _, verbatim - _].
test(an_empty_profile_has_exactly_one_clean_check) :-
    findall(Problems, virginia_vcdpa_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    virginia_vcdpa_input_problems([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, unsure), attribute(consumer_count, 100000)], Problems),
    Problems == [].
test(an_unknown_key_is_a_problem) :-
    virginia_vcdpa_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(a_clean_query_has_no_problem) :-
    findall(Problems, query_problems([], [notice_date - date(2026, 1, 1), reference_date - date(2026, 2, 1)], Problems), Answers),
    Answers == [[]].
test(a_false_day_is_a_date_problem) :-
    date_argument_problems([received_date - date(2026, 2, 29)], Problems),
    Problems == [wrong_type(received_date)].
test(a_real_day_is_no_date_problem) :-
    date_argument_problems([received_date - date(2026, 2, 28)], Problems),
    Problems == [].
test(a_present_key_is_read_once) :-
    findall(Value, value_or_absent([attribute(violation_count, 3)], violation_count, Value), Values),
    Values == [3].
test(an_absent_key_reads_as_absent) :-
    findall(Value, value_or_absent([], violation_count, Value), Values),
    Values == [absent].

test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(us_todo_primary_source, _).
test(a_shortened_citation_is_not_recorded, fail) :-
    implements(va_576_a).

cp_test_names([the_verdict_term_carries_status_and_citations, the_exempt_verdict_cites_subsection_b, the_applicability_atoms_are_distinct, the_action_status_atoms_are_distinct, the_extension_atom_is_not_a_date, the_indeterminate_status_names_one_key, the_indeterminate_compound_is_not_the_bare_atom, the_legal_review_status_destructures, the_input_problems_status_destructures, the_applicability_citation_is_recorded, every_answer_citation_is_recorded, the_citation_record_has_label_reference_and_verbatim, an_empty_profile_has_exactly_one_clean_check, a_well_formed_profile_has_no_problem, an_unknown_key_is_a_problem, a_clean_query_has_no_problem, a_false_day_is_a_date_problem, a_real_day_is_no_date_problem, a_present_key_is_read_once, an_absent_key_reads_as_absent]).
cp_test_fail_names([the_placeholder_citation_is_not_recorded, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
