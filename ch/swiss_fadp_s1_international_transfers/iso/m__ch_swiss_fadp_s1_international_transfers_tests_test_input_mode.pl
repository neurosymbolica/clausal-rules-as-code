% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s1_international_transfers_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_swiss_fadp_s1_international_transfers, [swiss_fadp_s1_international_transfers_status/2, swiss_disclosure_under_article_16/3, swiss_disclosure_abroad/3, swiss_information_of_commissioner_on_request/3, eu_transfer_under_articles_45_and_46/3, compare_swiss_eu_transfer_routes/5, outside_facts_supplied/2]).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_kernel, [swiss_fadp_s1_international_transfers_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_fixtures, [swiss_fadp_s1_international_transfers_profile_for/2]).

test(adequacy_holds_with_the_verdict_bound) :-
    swiss_fadp_s1_international_transfers_profile_for(adequacy_finding_covers_disclosure, Profile),
    swiss_fadp_s1_international_transfers_status(Profile, permitted_by_adequacy_decision).
test(safeguards_hold_with_the_verdict_bound) :-
    swiss_fadp_s1_international_transfers_profile_for(code_of_conduct_backed, Profile),
    swiss_disclosure_abroad(Profile, permitted_by_safeguards, _).
test(derogation_holds_with_the_verdict_bound) :-
    swiss_fadp_s1_international_transfers_profile_for(statutory_register_data, Profile),
    swiss_disclosure_abroad(Profile, permitted_by_derogation, _).
test(no_route_holds_with_the_verdict_bound) :-
    swiss_fadp_s1_international_transfers_profile_for(nothing_permits_disclosure, Profile),
    swiss_disclosure_abroad(Profile, disclosure_abroad_not_permitted, _).
test(article_16_citations_hold_when_bound) :-
    swiss_fadp_s1_international_transfers_profile_for(adequacy_finding_covers_disclosure, Profile),
    swiss_disclosure_under_article_16(Profile, permitted_by_adequacy_decision, [cite(ch_fadp_art_16_1), cite(ch_fadp_ord_art_8_1), cite(ch_fadp_ord_annex_1)]).
test(article_16_no_route_holds_when_bound) :-
    swiss_fadp_s1_international_transfers_profile_for(explicit_consent_given, Profile),
    swiss_disclosure_under_article_16(Profile, no_adequacy_decision_or_safeguards, _).
test(the_duty_holds_with_the_verdict_bound) :-
    swiss_fadp_s1_international_transfers_profile_for(commissioner_must_be_informed, Profile),
    swiss_information_of_commissioner_on_request(Profile, information_of_commissioner_required, [cite(ch_fadp_art_17_1), cite(ch_fadp_art_17_2)]).
test(the_eu_safeguards_hold_with_the_verdict_bound) :-
    swiss_fadp_s1_international_transfers_profile_for(eu_safeguards_with_remedies, Profile),
    eu_transfer_under_articles_45_and_46(Profile, permitted_by_safeguards, [cite(eu_reg_2016_679_art_46_1)]).
test(the_comparison_holds_with_every_answer_bound) :-
    swiss_fadp_s1_international_transfers_profile_for(swiss_and_eu_safeguards, Profile),
    compare_swiss_eu_transfer_routes(Profile, permitted_by_safeguards, permitted_by_safeguards, same, []).
test(an_unknown_key_is_refused_by_every_query) :-
    swiss_fadp_s1_international_transfers_profile_for(unknown_destination_key, Profile),
    swiss_disclosure_under_article_16(Profile, input_problems([unknown_key(destination_country)]), []),
    swiss_disclosure_abroad(Profile, input_problems([unknown_key(destination_country)]), []),
    swiss_information_of_commissioner_on_request(Profile, input_problems([unknown_key(destination_country)]), []),
    eu_transfer_under_articles_45_and_46(Profile, input_problems([unknown_key(destination_country)]), []),
    compare_swiss_eu_transfer_routes(Profile, input_problems([unknown_key(destination_country)]), input_problems([unknown_key(destination_country)]), input_problems([unknown_key(destination_country)]), []),
    outside_facts_supplied(Profile, input_problems([unknown_key(destination_country)])).
test(an_unsure_crisp_fact_is_wrong_type) :-
    swiss_fadp_s1_international_transfers_profile_for(unsure_crisp_fact, Profile),
    swiss_information_of_commissioner_on_request(Profile, input_problems([wrong_type(commissioner_requested_information_on_disclosure)]), []).
test(a_repeated_key_is_a_duplicate_even_where_unread) :-
    swiss_fadp_s1_international_transfers_profile_for(repeated_consent_key, Profile),
    eu_transfer_under_articles_45_and_46(Profile, input_problems([duplicate_key(data_subject_explicitly_consented)]), []).
test(a_bare_outside_fact_value_is_wrong_type) :-
    swiss_fadp_s1_international_transfers_profile_for(bare_outside_fact_value, Profile),
    outside_facts_supplied(Profile, input_problems([wrong_type(federal_council_adequacy_listing_covers_disclosure)])).
test(a_term_that_is_not_a_list_is_refused) :-
    swiss_fadp_s1_international_transfers_profile_for(profile_not_attribute_list, Profile),
    compare_swiss_eu_transfer_routes(Profile, input_problems([wrong_type(profile)]), input_problems([wrong_type(profile)]), input_problems([wrong_type(profile)]), []).
test(an_unbound_profile_is_refused) :-
    findall(Problems, swiss_fadp_s1_international_transfers_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_refused) :-
    findall(Problems, swiss_fadp_s1_international_transfers_input_problems([attribute(data_subject_explicitly_consented, true)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_element_is_refused) :-
    findall(Problems, swiss_fadp_s1_international_transfers_input_problems([_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_element_that_is_not_an_attribute_is_refused_alone) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(stray_key, true), pair(data_subject_explicitly_consented, true)], Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, swiss_fadp_s1_international_transfers_input_problems([attribute(appropriate_safeguards_provided, _)], Problems), Answers),
    Answers == [[wrong_type(appropriate_safeguards_provided)]].
test(a_number_key_is_an_unknown_key) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(a_judgement_outside_its_values_is_wrong_type) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(data_subject_explicitly_consented, maybe)], Problems),
    Problems == [wrong_type(data_subject_explicitly_consented)].
test(an_unsure_attested_value_is_wrong_type) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(commission_adequacy_decision_covers_transfer, attested(unsure, attestation(by, at, reason, none)))], Problems),
    Problems == [wrong_type(commission_adequacy_decision_covers_transfer)].
test(a_short_attestation_is_wrong_type) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(binding_corporate_rules_approved_beforehand, attested(true, attestation(by, at)))], Problems),
    Problems == [wrong_type(binding_corporate_rules_approved_beforehand)].
test(a_duplicate_is_never_also_wrong_type) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(appropriate_safeguards_provided, true), attribute(appropriate_safeguards_provided, banana)], Problems),
    Problems == [duplicate_key(appropriate_safeguards_provided)].
test(unknown_keys_are_named_once_in_first_occurrence_order) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(zeta, 1), attribute(alpha, 2), attribute(zeta, 3)], Problems),
    Problems == [unknown_key(zeta), unknown_key(alpha)].
test(an_absent_key_is_not_a_problem) :-
    swiss_fadp_s1_international_transfers_input_problems([], Problems),
    Problems == [].

test(adequacy_rejects_the_safeguards_verdict, fail) :-
    swiss_fadp_s1_international_transfers_profile_for(adequacy_finding_covers_disclosure, Profile),
    swiss_fadp_s1_international_transfers_status(Profile, permitted_by_safeguards).
test(safeguards_reject_the_derogation_verdict, fail) :-
    swiss_fadp_s1_international_transfers_profile_for(code_of_conduct_backed, Profile),
    swiss_disclosure_abroad(Profile, permitted_by_derogation, _).
test(no_route_rejects_the_derogation_verdict, fail) :-
    swiss_fadp_s1_international_transfers_profile_for(nothing_permits_disclosure, Profile),
    swiss_disclosure_abroad(Profile, permitted_by_derogation, _).
test(the_duty_rejects_not_required, fail) :-
    swiss_fadp_s1_international_transfers_profile_for(commissioner_must_be_informed, Profile),
    swiss_information_of_commissioner_on_request(Profile, information_of_commissioner_not_required, _).

cp_test_names([adequacy_holds_with_the_verdict_bound, safeguards_hold_with_the_verdict_bound, derogation_holds_with_the_verdict_bound, no_route_holds_with_the_verdict_bound, article_16_citations_hold_when_bound, article_16_no_route_holds_when_bound, the_duty_holds_with_the_verdict_bound, the_eu_safeguards_hold_with_the_verdict_bound, the_comparison_holds_with_every_answer_bound, an_unknown_key_is_refused_by_every_query, an_unsure_crisp_fact_is_wrong_type, a_repeated_key_is_a_duplicate_even_where_unread, a_bare_outside_fact_value_is_wrong_type, a_term_that_is_not_a_list_is_refused, an_unbound_profile_is_refused, a_partial_list_is_refused, an_unbound_element_is_refused, an_element_that_is_not_an_attribute_is_refused_alone, an_unbound_value_is_wrong_type, a_number_key_is_an_unknown_key, a_judgement_outside_its_values_is_wrong_type, an_unsure_attested_value_is_wrong_type, a_short_attestation_is_wrong_type, a_duplicate_is_never_also_wrong_type, unknown_keys_are_named_once_in_first_occurrence_order, an_absent_key_is_not_a_problem]).
cp_test_fail_names([adequacy_rejects_the_safeguards_verdict, safeguards_reject_the_derogation_verdict, no_route_rejects_the_derogation_verdict, the_duty_rejects_not_required]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
