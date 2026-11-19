% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_virginia_vcdpa_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_virginia_vcdpa_kernel, [virginia_vcdpa_input_problems/2]).
:- use_module(m__us_virginia_vcdpa_virginia_vcdpa, [applicability_status/3, response_deadline/4, extended_response_deadline/4, appeal_response_deadline/4, cure_period_last_day/4, attorney_general_action_status/5, civil_penalty_maximum/3, virginia_vcdpa_status/2]).
:- use_module(m__us_virginia_vcdpa_fixtures, [virginia_vcdpa_profile_for/2]).

test(in_scope_holds_with_the_verdict_bound) :-
    virginia_vcdpa_profile_for(large_virginia_controller, Profile),
    applicability_status(Profile, in_scope, [cite(us_va_code_59_1_576_a)]).
test(exempt_entity_holds_with_the_verdict_bound) :-
    virginia_vcdpa_profile_for(hospital_hipaa, Profile),
    applicability_status(Profile, exempt_entity, [cite(us_va_code_59_1_576_b)]).
test(out_of_scope_holds_with_the_verdict_bound) :-
    virginia_vcdpa_profile_for(no_business_link, Profile),
    applicability_status(Profile, out_of_scope, [cite(us_va_code_59_1_576_a)]).
test(the_status_projection_holds_bound) :-
    virginia_vcdpa_profile_for(mid_size_not_broker, Profile),
    virginia_vcdpa_status(Profile, out_of_scope).
test(needs_legal_review_holds_with_the_verdict_bound) :-
    virginia_vcdpa_profile_for(unsure_business_link, Profile),
    applicability_status(Profile, needs_legal_review(open_textured(conducts_business_in_or_targets_virginia, cite(us_va_code_59_1_576_a)), [inputs_relied_on([conducts_business_in_or_targets_virginia - unsure])]), []).
test(indeterminate_holds_with_the_verdict_bound) :-
    virginia_vcdpa_profile_for(empty_profile, Profile),
    applicability_status(Profile, indeterminate([entity_category]), []).
test(response_deadline_holds_with_the_date_bound) :-
    response_deadline([], date(2026, 1, 1), date(2026, 2, 15), _).
test(appeal_deadline_holds_with_the_date_bound) :-
    appeal_response_deadline([], date(2026, 1, 1), date(2026, 3, 2), [cite(us_va_code_59_1_577_c)]).
test(cure_last_day_holds_with_the_date_bound) :-
    cure_period_last_day([], date(2026, 1, 1), date(2026, 1, 31), [cite(us_va_code_59_1_584_b)]).
test(no_extension_holds_with_the_atom_bound) :-
    extended_response_deadline([attribute(extension_notice_given_within_initial_period, false)], date(2026, 1, 1), no_extension_available, [cite(us_va_code_59_1_577_b_1)]).
test(cure_period_running_holds_with_the_atom_bound) :-
    attorney_general_action_status([], date(2026, 1, 1), date(2026, 1, 15), cure_period_running, [cite(us_va_code_59_1_584_b)]).
test(the_penalty_holds_with_the_integer_bound) :-
    civil_penalty_maximum([attribute(violation_count, 2)], 15000, [cite(us_va_code_59_1_584_c)]).
test(a_single_attribute_outside_a_list_is_wrong_type) :-
    virginia_vcdpa_input_problems(attribute(consumer_count, 1), Problems),
    Problems == [wrong_type(profile)].
test(a_list_not_ending_in_the_empty_list_is_wrong_type) :-
    virginia_vcdpa_input_problems([attribute(consumer_count, 1)|tail], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_is_not_a_profile) :-
    virginia_vcdpa_input_problems(none, [wrong_type(profile)]).
test(a_non_attribute_element_spoils_the_list) :-
    virginia_vcdpa_input_problems([attribute(consumer_count, 1), consumer_count], [wrong_type(profile)]).
test(a_compound_value_is_wrong_type) :-
    virginia_vcdpa_input_problems([attribute(violation_count, count(1))], Problems),
    Problems == [wrong_type(violation_count)].
test(an_integer_key_is_unknown_as_given) :-
    virginia_vcdpa_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(a_float_count_is_wrong_type) :-
    virginia_vcdpa_input_problems([attribute(consumer_count, 100000.0)], [wrong_type(consumer_count)]).
test(a_negative_count_is_wrong_type) :-
    virginia_vcdpa_input_problems([attribute(violation_count, -1)], [wrong_type(violation_count)]).
test(unsure_is_not_a_crisp_value) :-
    virginia_vcdpa_input_problems([attribute(over_half_of_gross_revenue_from_sale, unsure)], [wrong_type(over_half_of_gross_revenue_from_sale)]).
test(unsure_is_a_judgement_value) :-
    virginia_vcdpa_input_problems([attribute(extension_reasonably_necessary, unsure)], []).
test(an_unlisted_judgement_value_is_wrong_type) :-
    virginia_vcdpa_input_problems([attribute(conducts_business_in_or_targets_virginia, yes)], [wrong_type(conducts_business_in_or_targets_virginia)]).
test(an_unlisted_category_is_wrong_type) :-
    virginia_vcdpa_input_problems([attribute(entity_category, charity)], [wrong_type(entity_category)]).
test(a_repeated_key_with_equal_values_is_a_duplicate_only) :-
    virginia_vcdpa_input_problems([attribute(entity_category, nonprofit_organization), attribute(entity_category, nonprofit_organization)], Problems),
    Problems == [duplicate_key(entity_category)].
test(a_repeated_unknown_key_is_named_once) :-
    virginia_vcdpa_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(an_absent_key_is_no_problem) :-
    virginia_vcdpa_input_problems([attribute(violation_count, 0)], []).
test(a_query_answers_input_problems_first) :-
    findall(Result - Citations, applicability_status([attribute(colour, red)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(a_key_the_query_does_not_read_is_still_checked) :-
    findall(Deadline - Citations, response_deadline([attribute(violation_count, -1)], date(2026, 1, 1), Deadline, Citations), Answers),
    Answers == [input_problems([wrong_type(violation_count)]) - []].
test(an_unreal_day_is_a_date_problem) :-
    response_deadline([], date(2026, 2, 29), input_problems([wrong_type(received_date)]), []).
test(a_year_after_2100_is_a_date_problem) :-
    appeal_response_deadline([], date(2101, 1, 1), input_problems([wrong_type(appeal_received_date)]), []).
test(a_date_with_an_atom_day_is_a_date_problem) :-
    cure_period_last_day([], date(2026, 1, x), input_problems([wrong_type(notice_date)]), []).
test(date_problems_follow_signature_order) :-
    attorney_general_action_status([], date(2026, 13, 1), date(1999, 1, 1), input_problems([wrong_type(notice_date), wrong_type(reference_date)]), []).
test(date_problems_follow_profile_problems) :-
    extended_response_deadline([attribute(colour, red)], nothing, input_problems([unknown_key(colour), wrong_type(received_date)]), []).
test(a_malformed_profile_gets_no_penalty_figure) :-
    findall(Maximum, civil_penalty_maximum([attribute(violation_count, 1.5)], Maximum, _), Maximums),
    Maximums == [input_problems([wrong_type(violation_count)])].

test(an_in_scope_profile_rejects_out_of_scope_bound, fail) :-
    virginia_vcdpa_profile_for(large_virginia_controller, Profile),
    applicability_status(Profile, out_of_scope, _).
test(an_exempt_profile_rejects_in_scope_bound, fail) :-
    virginia_vcdpa_profile_for(hospital_hipaa, Profile),
    applicability_status(Profile, in_scope, _).

cp_test_names([in_scope_holds_with_the_verdict_bound, exempt_entity_holds_with_the_verdict_bound, out_of_scope_holds_with_the_verdict_bound, the_status_projection_holds_bound, needs_legal_review_holds_with_the_verdict_bound, indeterminate_holds_with_the_verdict_bound, response_deadline_holds_with_the_date_bound, appeal_deadline_holds_with_the_date_bound, cure_last_day_holds_with_the_date_bound, no_extension_holds_with_the_atom_bound, cure_period_running_holds_with_the_atom_bound, the_penalty_holds_with_the_integer_bound, a_single_attribute_outside_a_list_is_wrong_type, a_list_not_ending_in_the_empty_list_is_wrong_type, an_atom_is_not_a_profile, a_non_attribute_element_spoils_the_list, a_compound_value_is_wrong_type, an_integer_key_is_unknown_as_given, a_float_count_is_wrong_type, a_negative_count_is_wrong_type, unsure_is_not_a_crisp_value, unsure_is_a_judgement_value, an_unlisted_judgement_value_is_wrong_type, an_unlisted_category_is_wrong_type, a_repeated_key_with_equal_values_is_a_duplicate_only, a_repeated_unknown_key_is_named_once, an_absent_key_is_no_problem, a_query_answers_input_problems_first, a_key_the_query_does_not_read_is_still_checked, an_unreal_day_is_a_date_problem, a_year_after_2100_is_a_date_problem, a_date_with_an_atom_day_is_a_date_problem, date_problems_follow_signature_order, date_problems_follow_profile_problems, a_malformed_profile_gets_no_penalty_figure]).
cp_test_fail_names([an_in_scope_profile_rejects_out_of_scope_bound, an_exempt_profile_rejects_in_scope_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
