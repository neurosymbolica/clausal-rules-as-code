% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [pdpl_applies/3, pdpl_in_force/3, uae_pdpl_scope_and_exclusions_status/2, uae_pdpl_scope_and_exclusions_status_values/1]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_kernel, [uae_pdpl_scope_and_exclusions_input_problems/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_fixtures, [uae_pdpl_scope_and_exclusions_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    findall(Status, uae_pdpl_scope_and_exclusions_status(Profile, Status), [BaselineStatus]),
    uae_pdpl_scope_and_exclusions_status(Profile, BaselineStatus).
test(applies_bound_with_its_citations) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    pdpl_applies(Profile, applies, [cite(uae_pdpl_art_1_personal_data), cite(uae_pdpl_art_1_processing), cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_1_a), cite(uae_pdpl_art_2_1_b), cite(uae_pdpl_art_2_1_c), cite(uae_pdpl_art_2_2), cite(uae_pdpl_art_31)]).
test(not_in_force_bound_with_its_citation) :-
    uae_pdpl_scope_and_exclusions_profile_for(not_in_force_on_day_before_commencement, Profile),
    pdpl_applies(Profile, not_in_force, [cite(uae_pdpl_art_31)]).
test(does_not_apply_bound_for_an_exclusion) :-
    uae_pdpl_scope_and_exclusions_profile_for(personal_purposes_excluded, Profile),
    pdpl_applies(Profile, does_not_apply, [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)]).
test(does_not_apply_bound_for_no_way) :-
    uae_pdpl_scope_and_exclusions_profile_for(no_way_of_scope_met, Profile),
    pdpl_applies(Profile, does_not_apply, [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)]).
test(indeterminate_bound_with_empty_citations) :-
    uae_pdpl_scope_and_exclusions_profile_for(processing_judgement_missing, Profile),
    pdpl_applies(Profile, indeterminate([activity_is_processing_of_personal_data]), []).
test(referral_bound_by_its_reason) :-
    uae_pdpl_scope_and_exclusions_profile_for(free_zone_judgement_unsure, Profile),
    pdpl_applies(Profile, needs_legal_review(open_textured(free_zone_company_or_establishment_with_own_data_protection_legislation, cite(uae_pdpl_art_2_2_g)), [inputs_relied_on(_)]), []).
test(in_force_bound) :-
    pdpl_in_force([attribute(processing_date, date(2030, 6, 15))], in_force, [cite(uae_pdpl_art_31)]).
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, uae_pdpl_scope_and_exclusions_input_problems([attribute(processing_date, date(2022, 1, 2))|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_element_is_not_an_attribute_list) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(processing_date, date(2022, 1, 2)), foo], [wrong_type(profile)]).
test(a_list_with_an_unbound_element_is_not_an_attribute_list) :-
    uae_pdpl_scope_and_exclusions_input_problems([_], [wrong_type(profile)]).
test(a_number_key_is_unknown) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_compound_key_is_unknown) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(colour(red), true)], [unknown_key(colour(red))]).
test(an_unbound_key_is_unknown_as_given) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(UnboundKey, true)], Problems),
    Problems == [unknown_key(UnboundKey)].
test(two_unbound_keys_are_two_unknown_keys) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(FirstKey, true), attribute(SecondKey, false)], Problems),
    Problems == [unknown_key(FirstKey), unknown_key(SecondKey)].
test(the_same_unbound_key_twice_is_one_unknown_key) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(SameKey, true), attribute(SameKey, false)], Problems),
    Problems == [unknown_key(SameKey)].
test(an_unknown_key_with_an_unbound_value_is_only_unknown) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(colour, _)], [unknown_key(colour)]).
test(an_unknown_key_repeated_is_named_once) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(a_number_for_a_crisp_key_is_wrong_type) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(controller_or_processor_resides_in_state, 1)], [wrong_type(controller_or_processor_resides_in_state)]).
test(a_judgement_given_maybe_is_wrong_type) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(activity_is_processing_of_personal_data, maybe)], [wrong_type(activity_is_processing_of_personal_data)]).
test(a_month_thirteen_is_wrong_type) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(processing_date, date(2022, 13, 1))], [wrong_type(processing_date)]).
test(a_non_integer_day_is_wrong_type) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(processing_date, date(2022, 1, first))], [wrong_type(processing_date)]).
test(the_year_two_thousand_leap_day_is_a_date) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(processing_date, date(2000, 2, 29))], []).
test(the_year_nineteen_hundred_leap_day_is_wrong_type) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(processing_date, date(1900, 2, 29))], [wrong_type(processing_date)]).
test(a_duplicate_comes_before_a_wrong_type_in_contract_order) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(data_subject_inside_state, 7), attribute(processing_date, date(2022, 1, 2)), attribute(processing_date, date(2022, 1, 3))], [duplicate_key(processing_date), wrong_type(data_subject_inside_state)]).
test(the_queries_answer_a_malformed_profile_once) :-
    findall(CountedResult - CountedCitations, pdpl_applies([attribute(CountedKey, true)], CountedResult, CountedCitations), CountedAnswers),
    length(CountedAnswers, 1),
    CountedAnswers = [input_problems([unknown_key(CopiedKey)]) - []],
    var(CopiedKey),
    dif(CountedKey, alpha),
    pdpl_applies([attribute(UnboundKey, true)], Result, Citations),
    Result == input_problems([unknown_key(UnboundKey)]),
    Citations == [],
    findall(InForceResult - InForceCitations, pdpl_in_force(_, InForceResult, InForceCitations), InForceAnswers),
    InForceAnswers == [input_problems([wrong_type(profile)]) - []].
test(an_unread_key_problem_still_stops_in_force) :-
    pdpl_in_force([attribute(processing_date, date(2023, 1, 1)), attribute(data_subject_inside_state, unsure)], input_problems([wrong_type(data_subject_inside_state)]), []).

test(every_other_bound_status_is_rejected, fail) :-
    uae_pdpl_scope_and_exclusions_profile_for(applies_on_commencement_day, Profile),
    findall(Status, uae_pdpl_scope_and_exclusions_status(Profile, Status), [BaselineStatus]),
    uae_pdpl_scope_and_exclusions_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    uae_pdpl_scope_and_exclusions_status(Profile, Other).
test(in_force_bound_wrongly_is_rejected, fail) :-
    pdpl_in_force([attribute(processing_date, date(2021, 12, 31))], in_force, _).

cp_test_names([status_holds_with_the_verdict_bound, applies_bound_with_its_citations, not_in_force_bound_with_its_citation, does_not_apply_bound_for_an_exclusion, does_not_apply_bound_for_no_way, indeterminate_bound_with_empty_citations, referral_bound_by_its_reason, in_force_bound, a_partial_list_is_not_an_attribute_list, a_list_with_a_foreign_element_is_not_an_attribute_list, a_list_with_an_unbound_element_is_not_an_attribute_list, a_number_key_is_unknown, a_compound_key_is_unknown, an_unbound_key_is_unknown_as_given, two_unbound_keys_are_two_unknown_keys, the_same_unbound_key_twice_is_one_unknown_key, an_unknown_key_with_an_unbound_value_is_only_unknown, an_unknown_key_repeated_is_named_once, a_number_for_a_crisp_key_is_wrong_type, a_judgement_given_maybe_is_wrong_type, a_month_thirteen_is_wrong_type, a_non_integer_day_is_wrong_type, the_year_two_thousand_leap_day_is_a_date, the_year_nineteen_hundred_leap_day_is_wrong_type, a_duplicate_comes_before_a_wrong_type_in_contract_order, the_queries_answer_a_malformed_profile_once, an_unread_key_problem_still_stops_in_force]).
cp_test_fail_names([every_other_bound_status_is_rejected, in_force_bound_wrongly_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
