% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_lawful_processing_and_consent_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_uae_pdpl_lawful_processing_and_consent, [pdpl_processing_lawful_basis/3, pdpl_consent_valid/3, pdpl_processing_controls/3, uae_pdpl_lawful_processing_and_consent_status/2, uae_pdpl_lawful_processing_and_consent_status_values/1]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_kernel, [uae_pdpl_lawful_processing_and_consent_input_problems/2]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_fixtures, [uae_pdpl_lawful_processing_and_consent_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    uae_pdpl_lawful_processing_and_consent_status(Profile, allowed_with_consent).
test(allowed_with_consent_bound_with_its_citations) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    pdpl_processing_lawful_basis(Profile, allowed_with_consent, [cite(uae_pdpl_art_4), cite(uae_pdpl_art_1_consent), cite(uae_pdpl_art_6_1), cite(uae_pdpl_art_6_1_a), cite(uae_pdpl_art_6_1_b), cite(uae_pdpl_art_6_1_c), cite(uae_pdpl_art_6_2)]).
test(allowed_without_consent_bound_with_its_citations) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_refused_case_public_interest, Profile),
    pdpl_processing_lawful_basis(Profile, allowed_without_consent(public_interest), [cite(uae_pdpl_art_4), cite(uae_pdpl_art_4_1)]).
test(not_allowed_bound_with_its_citations) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_given, Profile),
    pdpl_processing_lawful_basis(Profile, not_allowed, [cite(uae_pdpl_art_4), cite(uae_pdpl_art_4_1), cite(uae_pdpl_art_4_2), cite(uae_pdpl_art_4_3), cite(uae_pdpl_art_4_4), cite(uae_pdpl_art_4_5), cite(uae_pdpl_art_4_6), cite(uae_pdpl_art_4_7), cite(uae_pdpl_art_4_8), cite(uae_pdpl_art_4_9), cite(uae_pdpl_art_4_10)]).
test(not_in_force_bound_for_every_query) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(day_before_commencement, Profile),
    pdpl_processing_lawful_basis(Profile, not_in_force, [cite(uae_pdpl_art_31)]),
    pdpl_consent_valid(Profile, not_in_force, [cite(uae_pdpl_art_31)]),
    pdpl_processing_controls(Profile, not_in_force, [cite(uae_pdpl_art_31)]).
test(valid_bound_with_its_citations) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    pdpl_consent_valid(Profile, valid, [cite(uae_pdpl_art_1_consent), cite(uae_pdpl_art_6_1), cite(uae_pdpl_art_6_1_a), cite(uae_pdpl_art_6_1_b), cite(uae_pdpl_art_6_1_c), cite(uae_pdpl_art_6_2)]).
test(not_valid_withdrawn_bound) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_withdrawn, Profile),
    pdpl_consent_valid(Profile, not_valid(consent_withdrawn), [cite(uae_pdpl_art_6_2)]).
test(not_valid_not_given_bound) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_given, Profile),
    pdpl_consent_valid(Profile, not_valid(consent_not_given), [cite(uae_pdpl_art_1_consent), cite(uae_pdpl_art_6_1)]).
test(fails_control_security_bound) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(control_fails_security, Profile),
    pdpl_processing_controls(Profile, fails_control(control_6_kept_securely), [cite(uae_pdpl_art_5), cite(uae_pdpl_art_5_6)]).
test(meets_listed_controls_bound) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    pdpl_processing_controls(Profile, meets_listed_controls, [cite(uae_pdpl_art_5), cite(uae_pdpl_art_5_1), cite(uae_pdpl_art_5_2), cite(uae_pdpl_art_5_3), cite(uae_pdpl_art_5_4), cite(uae_pdpl_art_5_5), cite(uae_pdpl_art_5_6), cite(uae_pdpl_art_5_7)]).
test(indeterminate_date_bound_with_no_citations) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(processing_date_unstated, Profile),
    pdpl_processing_lawful_basis(Profile, indeterminate([processing_date]), []).
test(input_problems_bound_for_year_zero) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(year_zero, Profile),
    pdpl_consent_valid(Profile, input_problems([wrong_type(processing_date)]), []).
test(an_unbound_profile_is_wrong_type) :-
    findall(Result - Citations, pdpl_processing_lawful_basis(_, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(an_atom_is_not_a_profile) :-
    pdpl_processing_controls(not_a_profile, input_problems([wrong_type(profile)]), []).
test(a_partial_list_is_not_a_profile) :-
    pdpl_consent_valid([attribute(consent_given, true)|_], input_problems([wrong_type(profile)]), []).
test(an_unknown_key_with_an_unbound_value_is_only_unknown) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(colour, _)], Problems),
    Problems == [unknown_key(colour)].
test(an_unbound_contract_value_is_wrong_type) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(kept_securely, _)], Problems),
    Problems == [wrong_type(kept_securely)].
test(a_number_key_is_unknown_as_given) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(problems_follow_contract_order_then_unknown_keys) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(zebra, 1), attribute(kept_securely, maybe), attribute(consent_given, true), attribute(consent_given, true), attribute(processing_date, date(2023, 13, 1))], Problems),
    Problems == [wrong_type(processing_date), duplicate_key(consent_given), wrong_type(kept_securely), unknown_key(zebra)].
test(a_string_date_is_wrong_type) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, '2023-06-01')], Problems),
    Problems == [wrong_type(processing_date)].
test(a_well_formed_profile_has_no_problems) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    uae_pdpl_lawful_processing_and_consent_input_problems(Profile, []).

test(every_other_bound_status_is_rejected, fail) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    uae_pdpl_lawful_processing_and_consent_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, allowed_with_consent),
    uae_pdpl_lawful_processing_and_consent_status(Profile, Other).
test(allowed_without_consent_with_a_wrong_item_citation_is_rejected, fail) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_refused_case_public_interest, Profile),
    pdpl_processing_lawful_basis(Profile, allowed_without_consent(public_interest), [cite(uae_pdpl_art_4), cite(uae_pdpl_art_4_2)]).
test(indeterminate_never_has_citations, fail) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(processing_date_unstated, Profile),
    pdpl_processing_lawful_basis(Profile, indeterminate([processing_date]), [_|_]).

cp_test_names([status_holds_with_the_verdict_bound, allowed_with_consent_bound_with_its_citations, allowed_without_consent_bound_with_its_citations, not_allowed_bound_with_its_citations, not_in_force_bound_for_every_query, valid_bound_with_its_citations, not_valid_withdrawn_bound, not_valid_not_given_bound, fails_control_security_bound, meets_listed_controls_bound, indeterminate_date_bound_with_no_citations, input_problems_bound_for_year_zero, an_unbound_profile_is_wrong_type, an_atom_is_not_a_profile, a_partial_list_is_not_a_profile, an_unknown_key_with_an_unbound_value_is_only_unknown, an_unbound_contract_value_is_wrong_type, a_number_key_is_unknown_as_given, problems_follow_contract_order_then_unknown_keys, a_string_date_is_wrong_type, a_well_formed_profile_has_no_problems]).
cp_test_fail_names([every_other_bound_status_is_rejected, allowed_without_consent_with_a_wrong_item_citation_is_rejected, indeterminate_never_has_citations]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
