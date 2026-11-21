% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_gber_general_conditions_kernel, [gber_general_conditions_input_problems/2, gber_general_conditions_key_order/1, argument_problems/2]).
:- use_module(m__eu_state_aid_gber_general_conditions_citations, [citation/2, implements/1, citation_vocabulary/1, chapter_i_met_citations/1, chapter_i_not_met_citations/1, threshold_row_citation/2]).

test(the_joined_verdict_atoms_are_distinct) :-
    dif(tested_chapter_i_conditions_met, chapter_i_conditions_not_met),
    dif(tested_chapter_i_conditions_met, chapter_i_conditions_partly_untested),
    dif(chapter_i_conditions_not_met, chapter_i_conditions_partly_untested).
test(the_scope_atoms_are_distinct) :-
    dif(within_scope, excluded_from_scope).
test(the_threshold_atoms_are_distinct) :-
    dif(within_threshold, threshold_exceeded),
    dif(within_threshold, threshold_not_formalised),
    dif(threshold_exceeded, threshold_not_formalised).
test(the_transparency_atoms_are_distinct) :-
    dif(transparent_aid, not_transparent_aid).
test(the_incentive_atoms_are_distinct) :-
    dif(incentive_effect, no_incentive_effect).
test(the_cumulation_atoms_are_distinct) :-
    dif(cumulation_allowed, cumulation_not_allowed),
    dif(cumulation_allowed, cumulation_not_formalised),
    dif(cumulation_not_allowed, cumulation_not_formalised).
test(the_verdict_term_carries_status_and_citations) :-
    chapter_i_met_citations(MetCitations),
    Verdict = gber_general_conditions_verdict(tested_chapter_i_conditions_met, MetCitations),
    Verdict = gber_general_conditions_verdict(Status, Citations),
    Status == tested_chapter_i_conditions_met,
    Citations == [cite(eu_reg_651_2014_art_3_t1)].
test(the_not_met_verdict_carries_its_fixed_list) :-
    chapter_i_not_met_citations(NotMetCitations),
    Verdict = gber_general_conditions_verdict(chapter_i_conditions_not_met, NotMetCitations),
    Verdict = gber_general_conditions_verdict(Status, Citations),
    Status == chapter_i_conditions_not_met,
    length(Citations, 10).
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([identifiable_eligible_costs]),
    Result = indeterminate([MissingKey]),
    MissingKey == identifiable_eligible_costs.
test(the_referral_status_destructures) :-
    Result = needs_legal_review(open_textured(transparent_under_article_5_1, cite(eu_reg_651_2014_art_5_1)), [inputs_relied_on([transparent_under_article_5_1 - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == transparent_under_article_5_1,
    Citation == eu_reg_651_2014_art_5_1,
    Pairs == [transparent_under_article_5_1 - unsure].
test(the_article_3_citation_is_recorded) :-
    citation(eu_reg_651_2014_art_3_t1, _Record).
test(the_article_3_key_is_returnable) :-
    citation_vocabulary(eu_reg_651_2014_art_3_t1),
    implements(eu_reg_651_2014_art_3_t1).
test(the_training_row_is_recorded) :-
    threshold_row_citation(training, cite(Key)),
    Key == eu_reg_651_2014_art_4_1_n,
    citation(Key, _Record).
test(an_empty_profile_has_no_problem) :-
    gber_general_conditions_input_problems([], []).
test(a_term_that_is_not_a_list_is_the_wrong_type) :-
    gber_general_conditions_input_problems(not_a_profile, [wrong_type(profile)]).
test(a_good_profile_has_no_problem) :-
    gber_general_conditions_input_problems([attribute(aid_form, grant), attribute(transparent_under_article_5_1, unsure)], []).
test(the_key_order_has_twenty_six_keys) :-
    gber_general_conditions_key_order(Keys),
    length(Keys, 26).
test(a_real_date_is_a_work_start_date) :-
    argument_problems([work_start_date - date(2024, 3, 1)], []).

test(the_indeterminate_status_is_not_a_referral, fail) :-
    indeterminate([aid_form]) = needs_legal_review(_, _).
test(an_invented_key_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).
test(a_good_profile_has_no_problem_list, fail) :-
    gber_general_conditions_input_problems([attribute(aid_form, grant)], [_|_]).

cp_test_names([the_joined_verdict_atoms_are_distinct, the_scope_atoms_are_distinct, the_threshold_atoms_are_distinct, the_transparency_atoms_are_distinct, the_incentive_atoms_are_distinct, the_cumulation_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_not_met_verdict_carries_its_fixed_list, the_indeterminate_status_names_one_key, the_referral_status_destructures, the_article_3_citation_is_recorded, the_article_3_key_is_returnable, the_training_row_is_recorded, an_empty_profile_has_no_problem, a_term_that_is_not_a_list_is_the_wrong_type, a_good_profile_has_no_problem, the_key_order_has_twenty_six_keys, a_real_date_is_a_work_start_date]).
cp_test_fail_names([the_indeterminate_status_is_not_a_referral, an_invented_key_is_not_recorded, a_good_profile_has_no_problem_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
