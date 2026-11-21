% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_colorado_cpa_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_colorado_cpa_queries, [colorado_cpa_profile_keys/1, colorado_cpa_what_if/4, colorado_cpa_consumer_threshold/3, entity_category/0, none_of_the_exempt_categories/0, unsure/0]).
:- use_module(m__us_colorado_cpa_colorado_cpa, [colorado_cpa_status/2, colorado_cpa_checklist/2, applicability_status/3, response_deadline/4, universal_opt_out_recognition_date/4]).
:- use_module(m__us_colorado_cpa_fixtures, [colorado_cpa_profile_for/2]).

cited_item(item(_, _, [_|_])).

test(profile_keys_are_the_contract_keys) :-
    colorado_cpa_profile_keys(ProfileKeys),
    ProfileKeys == [entity_category, colorado_link_for_general_duties, consumer_count, revenue_or_discount_from_sale, processes_biometric_data, colorado_link_for_minors_duties, extension_reasonably_necessary, extension_notice_given_within_initial_period, appeal_extension_reasonably_necessary, appeal_extension_notice_given_within_initial_period, action_enforces_minors_duties, cure_deemed_possible, cured_within_cure_period, processes_for_targeted_advertising_or_sale].
test(root_export_atoms_are_callable) :-
    entity_category,
    none_of_the_exempt_categories,
    unsure.
test(status_determination_for_a_biometric_only_controller) :-
    colorado_cpa_profile_for(small_controller_with_biometric_data, Profile),
    colorado_cpa_status(Profile, biometric_only_scope).
test(status_determination_through_applicability_status) :-
    colorado_cpa_profile_for(registered_securities_association, Profile),
    applicability_status(Profile, exempt_entity, [cite(us_co_crs_6_1_1304_2_m)]).
test(threshold_with_sale_revenue) :-
    colorado_cpa_consumer_threshold(true, 25000, [cite(us_co_crs_6_1_1304_1_a_i_b)]).
test(threshold_without_sale_revenue) :-
    colorado_cpa_consumer_threshold(false, 100000, [cite(us_co_crs_6_1_1304_1_a_i_b)]).
test(threshold_has_one_answer_per_revenue_value) :-
    findall(Revenue - Minimum, colorado_cpa_consumer_threshold(Revenue, Minimum, _), Answers),
    Answers == [true - 25000, false - 100000].
test(every_checklist_item_carries_a_citation) :-
    colorado_cpa_profile_for(large_linked_controller, Profile),
    colorado_cpa_checklist(Profile, Checklist),
    length(Checklist, 4),
    maplist(cited_item, Checklist).
test(the_threshold_item_is_met_with_its_citation) :-
    colorado_cpa_profile_for(large_linked_controller, Profile),
    colorado_cpa_checklist(Profile, Checklist),
    member(item(consumer_threshold, met, [cite(us_co_crs_6_1_1304_1_a_i_b)]), Checklist).
test(an_exempt_controller_has_an_unmet_exemption_item) :-
    colorado_cpa_profile_for(glba_financial_institution, Profile),
    colorado_cpa_checklist(Profile, Checklist),
    member(item(exempt_category, unmet(exempt_entity(financial_institution_or_affiliate_subject_to_glba)), [cite(us_co_crs_6_1_1304_2_q)]), Checklist).
test(a_malformed_profile_has_one_input_item) :-
    colorado_cpa_checklist([attribute(foo, 1)], Checklist),
    Checklist == [item(input_check, unmet(input_problems([unknown_key(foo)])), [])].
test(deadline_forty_five_days_after_receipt) :-
    response_deadline([], date(2026, 6, 20), date(2026, 8, 4), [cite(us_co_crs_6_1_1306_2_a), cite(us_co_crs_6_1_1306_2_b)]).
test(calculation_six_months_after_listing) :-
    universal_opt_out_recognition_date([attribute(processes_for_targeted_advertising_or_sale, true)], date(2026, 8, 31), date(2027, 2, 28), _).
test(what_if_the_controller_were_an_air_carrier) :-
    colorado_cpa_profile_for(large_linked_controller, Profile),
    colorado_cpa_what_if(Profile, entity_category, air_carrier, exempt_entity).
test(what_if_the_count_were_one_below) :-
    colorado_cpa_profile_for(large_linked_controller, Profile),
    colorado_cpa_what_if(Profile, consumer_count, 99999, out_of_scope).

test(threshold_is_not_one_below, fail) :-
    colorado_cpa_consumer_threshold(false, 99999, _).
test(what_if_does_not_keep_the_old_status, fail) :-
    colorado_cpa_profile_for(large_linked_controller, Profile),
    colorado_cpa_what_if(Profile, consumer_count, 99999, in_scope).

cp_test_names([profile_keys_are_the_contract_keys, root_export_atoms_are_callable, status_determination_for_a_biometric_only_controller, status_determination_through_applicability_status, threshold_with_sale_revenue, threshold_without_sale_revenue, threshold_has_one_answer_per_revenue_value, every_checklist_item_carries_a_citation, the_threshold_item_is_met_with_its_citation, an_exempt_controller_has_an_unmet_exemption_item, a_malformed_profile_has_one_input_item, deadline_forty_five_days_after_receipt, calculation_six_months_after_listing, what_if_the_controller_were_an_air_carrier, what_if_the_count_were_one_below]).
cp_test_fail_names([threshold_is_not_one_below, what_if_does_not_keep_the_old_status]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
