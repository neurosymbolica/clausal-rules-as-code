% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_virginia_vcdpa_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__us_virginia_vcdpa_virginia_vcdpa, [applicability_status/3, response_deadline/4, extended_response_deadline/4, attorney_general_action_status/5, civil_penalty_maximum/3, virginia_vcdpa_status_values/1]).

non_exempt(Attributes, [attribute(entity_category, none_of_the_exempt_categories)|Attributes]).

test(the_status_table_holds_the_three_atoms) :-
    virginia_vcdpa_status_values(StatusValues),
    clausal_msort(StatusValues, Sorted),
    Sorted == [exempt_entity, in_scope, out_of_scope].
test(an_exempt_category_is_exempt) :-
    applicability_status([attribute(entity_category, institution_of_higher_education), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 150000)], exempt_entity, _).
test(the_same_person_not_exempt_is_in_scope) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 150000)], Profile),
    applicability_status(Profile, in_scope, _).
test(exactly_one_hundred_thousand_is_in_scope) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 100000), attribute(over_half_of_gross_revenue_from_sale, false)], Profile),
    applicability_status(Profile, in_scope, _).
test(one_below_one_hundred_thousand_is_out_of_scope) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 99999), attribute(over_half_of_gross_revenue_from_sale, false)], Profile),
    applicability_status(Profile, out_of_scope, _).
test(exactly_twenty_five_thousand_with_revenue_is_in_scope) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 25000), attribute(over_half_of_gross_revenue_from_sale, true)], Profile),
    applicability_status(Profile, in_scope, _).
test(one_below_twenty_five_thousand_is_out_of_scope) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 24999), attribute(over_half_of_gross_revenue_from_sale, true)], Profile),
    applicability_status(Profile, out_of_scope, _).
test(the_middle_band_with_revenue_is_in_scope) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 30000), attribute(over_half_of_gross_revenue_from_sale, true)], Profile),
    applicability_status(Profile, in_scope, _).
test(the_middle_band_without_revenue_is_out_of_scope) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 30000), attribute(over_half_of_gross_revenue_from_sale, false)], Profile),
    applicability_status(Profile, out_of_scope, [cite(us_va_code_59_1_576_a)]).
test(no_business_link_is_out_of_scope) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, false), attribute(consumer_count, 150000)], Profile),
    applicability_status(Profile, out_of_scope, _).
test(an_absent_category_is_named) :-
    applicability_status([attribute(conducts_business_in_or_targets_virginia, true)], indeterminate([entity_category]), []).
test(an_absent_count_is_named) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true)], Profile),
    applicability_status(Profile, indeterminate([consumer_count]), []).
test(an_absent_business_link_is_named) :-
    non_exempt([attribute(consumer_count, 150000)], Profile),
    applicability_status(Profile, indeterminate([conducts_business_in_or_targets_virginia]), []).
test(an_absent_business_link_with_a_small_count_is_out_of_scope) :-
    non_exempt([attribute(consumer_count, 10)], Profile),
    applicability_status(Profile, out_of_scope, _).
test(an_unsure_business_link_goes_to_a_lawyer) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, unsure), attribute(consumer_count, 150000)], Profile),
    applicability_status(Profile, needs_legal_review(open_textured(conducts_business_in_or_targets_virginia, cite(us_va_code_59_1_576_a)), [inputs_relied_on([conducts_business_in_or_targets_virginia - unsure])]), []).
test(an_unsure_link_with_a_missing_count_names_the_count) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, unsure)], Profile),
    applicability_status(Profile, indeterminate([consumer_count]), []).
test(the_response_deadline_is_the_forty_fifth_day_after) :-
    findall(Deadline, response_deadline([], date(2026, 1, 1), Deadline, _), Deadlines),
    Deadlines = [date(2026, 2, 15)].
test(a_necessary_noticed_extension_gives_a_date) :-
    findall(Deadline, extended_response_deadline([attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), Deadline, _), Deadlines),
    Deadlines = [date(2026, 4, 1)].
test(late_notice_gives_no_extension) :-
    findall(Deadline, extended_response_deadline([attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, false)], date(2026, 1, 1), Deadline, _), Deadlines),
    Deadlines == [no_extension_available].
test(an_unnecessary_extension_is_not_available) :-
    findall(Deadline, extended_response_deadline([attribute(extension_reasonably_necessary, false)], date(2026, 1, 1), Deadline, _), Deadlines),
    Deadlines == [no_extension_available].
test(a_necessary_extension_without_notice_names_the_notice) :-
    findall(Deadline, extended_response_deadline([attribute(extension_reasonably_necessary, true)], date(2026, 1, 1), Deadline, _), Deadlines),
    Deadlines == [indeterminate([extension_notice_given_within_initial_period])].
test(an_unsure_need_with_notice_goes_to_a_lawyer) :-
    findall(Deadline, extended_response_deadline([attribute(extension_reasonably_necessary, unsure), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), Deadline, _), Deadlines),
    Deadlines == [needs_legal_review(open_textured(extension_reasonably_necessary, cite(us_va_code_59_1_577_b_1)), [inputs_relied_on([extension_reasonably_necessary - unsure])])].
test(the_day_before_the_notice_has_no_notice) :-
    attorney_general_action_status([], date(2026, 1, 10), date(2026, 1, 9), notice_not_yet_provided, [cite(us_va_code_59_1_584_b)]).
test(the_day_of_the_notice_runs_the_cure_period) :-
    attorney_general_action_status([], date(2026, 1, 10), date(2026, 1, 10), cure_period_running, _).
test(the_last_cure_day_is_running) :-
    attorney_general_action_status([attribute(cured_with_express_written_statement, false)], date(2026, 1, 1), date(2026, 1, 31), cure_period_running, _).
test(the_day_after_the_cure_period_allows_action) :-
    attorney_general_action_status([attribute(cured_with_express_written_statement, false)], date(2026, 1, 1), date(2026, 2, 1), action_may_be_initiated, _).
test(a_cured_violation_bars_action) :-
    attorney_general_action_status([attribute(cured_with_express_written_statement, true), attribute(continued_violation_or_statement_breached, false)], date(2026, 1, 1), date(2026, 3, 1), no_action_for_cured_violation, [cite(us_va_code_59_1_584_b)]).
test(a_breached_statement_allows_action) :-
    attorney_general_action_status([attribute(cured_with_express_written_statement, true), attribute(continued_violation_or_statement_breached, true)], date(2026, 1, 1), date(2026, 3, 1), action_may_be_initiated, _).
test(absent_cure_facts_name_the_cure) :-
    attorney_general_action_status([], date(2026, 1, 1), date(2026, 3, 1), indeterminate([cured_with_express_written_statement]), []).
test(a_continued_violation_decides_with_the_cure_absent) :-
    attorney_general_action_status([attribute(continued_violation_or_statement_breached, true)], date(2026, 1, 1), date(2026, 3, 1), action_may_be_initiated, _).
test(an_absent_count_names_the_count) :-
    findall(Maximum, civil_penalty_maximum([], Maximum, _), Maximums),
    Maximums == [indeterminate([violation_count])].
test(a_present_count_gives_a_figure) :-
    findall(Maximum, civil_penalty_maximum([attribute(violation_count, 1)], Maximum, _), Maximums),
    Maximums = [Maximum],
    Maximum =:= 7500.
test(a_repeated_key_is_an_input_problem) :-
    applicability_status([attribute(consumer_count, 5), attribute(consumer_count, 5)], input_problems([duplicate_key(consumer_count)]), []).
test(a_single_key_gets_its_answer) :-
    applicability_status([attribute(consumer_count, 5)], indeterminate([entity_category]), []).

test(the_same_person_not_exempt_is_not_exempt, fail) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 150000)], Profile),
    applicability_status(Profile, exempt_entity, _).
test(one_below_one_hundred_thousand_is_not_in_scope, fail) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 99999), attribute(over_half_of_gross_revenue_from_sale, false)], Profile),
    applicability_status(Profile, in_scope, _).
test(one_below_twenty_five_thousand_is_not_in_scope, fail) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 24999), attribute(over_half_of_gross_revenue_from_sale, true)], Profile),
    applicability_status(Profile, in_scope, _).
test(the_middle_band_without_revenue_is_not_in_scope, fail) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 30000), attribute(over_half_of_gross_revenue_from_sale, false)], Profile),
    applicability_status(Profile, in_scope, _).
test(no_business_link_is_not_in_scope, fail) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, false), attribute(consumer_count, 150000)], Profile),
    applicability_status(Profile, in_scope, _).
test(a_present_category_is_not_named, fail) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true)], Profile),
    applicability_status(Profile, indeterminate([entity_category]), _).
test(a_present_count_is_not_named, fail) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 150000)], Profile),
    applicability_status(Profile, indeterminate([consumer_count]), _).
test(revenue_is_not_asked_at_one_hundred_thousand, fail) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 100000)], Profile),
    applicability_status(Profile, indeterminate([over_half_of_gross_revenue_from_sale]), _).
test(a_settled_business_link_does_not_go_to_a_lawyer, fail) :-
    non_exempt([attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 150000)], Profile),
    applicability_status(Profile, needs_legal_review(_, _), _).
test(the_response_deadline_is_not_a_day_earlier, fail) :-
    findall(Deadline, response_deadline([], date(2026, 1, 1), Deadline, _), Deadlines),
    Deadlines = [date(2026, 2, 14)].
test(timely_notice_is_not_no_extension, fail) :-
    findall(Deadline, extended_response_deadline([attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), Deadline, _), Deadlines),
    Deadlines == [no_extension_available].
test(an_unsure_need_without_notice_does_not_go_to_a_lawyer, fail) :-
    findall(Deadline, extended_response_deadline([attribute(extension_reasonably_necessary, unsure)], date(2026, 1, 1), Deadline, _), Deadlines),
    Deadlines = [needs_legal_review(_, _)].
test(the_day_of_the_notice_is_not_before_it, fail) :-
    attorney_general_action_status([], date(2026, 1, 10), date(2026, 1, 10), notice_not_yet_provided, _).
test(the_day_after_the_cure_period_is_not_running, fail) :-
    attorney_general_action_status([attribute(cured_with_express_written_statement, false)], date(2026, 1, 1), date(2026, 2, 1), cure_period_running, _).
test(a_breached_statement_does_not_bar_action, fail) :-
    attorney_general_action_status([attribute(cured_with_express_written_statement, true), attribute(continued_violation_or_statement_breached, true)], date(2026, 1, 1), date(2026, 3, 1), no_action_for_cured_violation, _).
test(a_present_count_is_not_indeterminate, fail) :-
    findall(Maximum, civil_penalty_maximum([attribute(violation_count, 1)], Maximum, _), Maximums),
    Maximums = [indeterminate(_)].
test(a_single_key_is_no_input_problem, fail) :-
    applicability_status([attribute(consumer_count, 5)], input_problems(_), _).

cp_test_names([the_status_table_holds_the_three_atoms, an_exempt_category_is_exempt, the_same_person_not_exempt_is_in_scope, exactly_one_hundred_thousand_is_in_scope, one_below_one_hundred_thousand_is_out_of_scope, exactly_twenty_five_thousand_with_revenue_is_in_scope, one_below_twenty_five_thousand_is_out_of_scope, the_middle_band_with_revenue_is_in_scope, the_middle_band_without_revenue_is_out_of_scope, no_business_link_is_out_of_scope, an_absent_category_is_named, an_absent_count_is_named, an_absent_business_link_is_named, an_absent_business_link_with_a_small_count_is_out_of_scope, an_unsure_business_link_goes_to_a_lawyer, an_unsure_link_with_a_missing_count_names_the_count, the_response_deadline_is_the_forty_fifth_day_after, a_necessary_noticed_extension_gives_a_date, late_notice_gives_no_extension, an_unnecessary_extension_is_not_available, a_necessary_extension_without_notice_names_the_notice, an_unsure_need_with_notice_goes_to_a_lawyer, the_day_before_the_notice_has_no_notice, the_day_of_the_notice_runs_the_cure_period, the_last_cure_day_is_running, the_day_after_the_cure_period_allows_action, a_cured_violation_bars_action, a_breached_statement_allows_action, absent_cure_facts_name_the_cure, a_continued_violation_decides_with_the_cure_absent, an_absent_count_names_the_count, a_present_count_gives_a_figure, a_repeated_key_is_an_input_problem, a_single_key_gets_its_answer]).
cp_test_fail_names([the_same_person_not_exempt_is_not_exempt, one_below_one_hundred_thousand_is_not_in_scope, one_below_twenty_five_thousand_is_not_in_scope, the_middle_band_without_revenue_is_not_in_scope, no_business_link_is_not_in_scope, a_present_category_is_not_named, a_present_count_is_not_named, revenue_is_not_asked_at_one_hundred_thousand, a_settled_business_link_does_not_go_to_a_lawyer, the_response_deadline_is_not_a_day_earlier, timely_notice_is_not_no_extension, an_unsure_need_without_notice_does_not_go_to_a_lawyer, the_day_of_the_notice_is_not_before_it, the_day_after_the_cure_period_is_not_running, a_breached_statement_does_not_bar_action, a_present_count_is_not_indeterminate, a_single_key_is_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
