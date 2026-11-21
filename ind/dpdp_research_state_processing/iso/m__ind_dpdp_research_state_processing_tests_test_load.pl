% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_research_state_processing_kernel, [dpdp_research_state_processing_input_problems/2, dpdp_research_state_processing_key_state/3, dpdp_research_state_processing_day_before/3, dpdp_research_state_processing_referral/3]).
:- use_module(m__ind_dpdp_research_state_processing_citations, [citation/2, implements/1, citation_vocabulary/1]).

test(the_research_exemption_atoms_are_distinct) :-
    dif(exempt_from_act, not_exempt),
    dif(exempt_from_act, not_in_force),
    dif(not_exempt, not_in_force).
test(the_state_standards_atoms_are_distinct) :-
    dif(follows_second_schedule, does_not_follow_second_schedule),
    dif(follows_second_schedule, not_applicable),
    dif(follows_second_schedule, not_in_force),
    dif(does_not_follow_second_schedule, not_applicable),
    dif(does_not_follow_second_schedule, not_in_force),
    dif(not_applicable, not_in_force).
test(the_disapplied_provisions_atoms_are_distinct) :-
    dif(sections_8_7_12_2_and_12_3_do_not_apply, sections_8_7_and_12_3_do_not_apply),
    dif(sections_8_7_12_2_and_12_3_do_not_apply, not_applicable),
    dif(sections_8_7_12_2_and_12_3_do_not_apply, not_in_force),
    dif(sections_8_7_and_12_3_do_not_apply, not_applicable),
    dif(sections_8_7_and_12_3_do_not_apply, not_in_force).
test(the_input_problem_constructors_are_distinct) :-
    dif(unknown_key(lawful_manner), wrong_type(lawful_manner)),
    dif(wrong_type(lawful_manner), duplicate_key(lawful_manner)),
    dif(unknown_key(lawful_manner), duplicate_key(lawful_manner)).
test(the_verdict_term_carries_determinations_and_citations) :-
    Verdict = dpdp_research_state_processing_verdict(determinations(exempt_from_act, not_applicable, not_in_force), [cite(in_dpdp_act_2023_s_17_2)]),
    Verdict = dpdp_research_state_processing_verdict(determinations(ResearchResult, StandardsResult, DisappliedResult), Citations),
    ResearchResult == exempt_from_act,
    StandardsResult == not_applicable,
    DisappliedResult == not_in_force,
    Citations == [cite(in_dpdp_act_2023_s_17_2)].
test(the_indeterminate_status_names_one_key) :-
    Status = indeterminate([reference_date]),
    Status = indeterminate([MissingKey]),
    MissingKey == reference_date.
test(the_input_problems_status_carries_its_list) :-
    Status = input_problems([wrong_type(lawful_manner)]),
    Status = input_problems(Problems),
    Problems == [wrong_type(lawful_manner)].
test(the_referral_builds_and_destructures) :-
    dpdp_research_state_processing_referral(processing_by_state_or_instrumentality, in_dpdp_act_2023_s_17_4, Result),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == processing_by_state_or_instrumentality,
    CitationKey == in_dpdp_act_2023_s_17_4,
    Pairs == [processing_by_state_or_instrumentality - unsure].
test(a_well_formed_profile_has_no_problem) :-
    dpdp_research_state_processing_input_problems([attribute(section_17_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13))], []).
test(year_zero_is_wrong_type) :-
    dpdp_research_state_processing_input_problems([attribute(reference_date, date(0, 1, 1))], [wrong_type(reference_date)]).
test(the_input_check_gives_one_answer) :-
    findall(Problems, dpdp_research_state_processing_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(an_absent_key_reads_absent) :-
    dpdp_research_state_processing_key_state([], reference_date, absent).
test(the_day_before_rules_start_is_before) :-
    dpdp_research_state_processing_day_before(date(2027, 5, 12), date(2027, 5, 13), before).
test(the_research_exemption_citation_is_recorded) :-
    citation(in_dpdp_act_2023_s_17_2_b, _Record).
test(the_disapplication_citation_is_implemented) :-
    implements(in_dpdp_act_2023_s_17_4).
test(the_vocabulary_holds_the_rule_5_key) :-
    citation_vocabulary(Keys),
    member(in_dpdp_rules_2025_r_5_1, Keys).

test(the_day_rules_start_is_not_before_itself, fail) :-
    dpdp_research_state_processing_day_before(date(2027, 5, 13), date(2027, 5, 13), before).
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(s_17_2_b, _Record).

cp_test_names([the_research_exemption_atoms_are_distinct, the_state_standards_atoms_are_distinct, the_disapplied_provisions_atoms_are_distinct, the_input_problem_constructors_are_distinct, the_verdict_term_carries_determinations_and_citations, the_indeterminate_status_names_one_key, the_input_problems_status_carries_its_list, the_referral_builds_and_destructures, a_well_formed_profile_has_no_problem, year_zero_is_wrong_type, the_input_check_gives_one_answer, an_absent_key_reads_absent, the_day_before_rules_start_is_before, the_research_exemption_citation_is_recorded, the_disapplication_citation_is_implemented, the_vocabulary_holds_the_rule_5_key]).
cp_test_fail_names([the_day_rules_start_is_not_before_itself, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
