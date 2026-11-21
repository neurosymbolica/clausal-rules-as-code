% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_5_2_data_combination_order_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_5_2_data_combination_order_kernel, [dma_art_5_2_data_combination_order_input_problems/2]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems([], Problems), Solutions),
    Solutions == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Attested = attested(true, attestation(host, moment, commission_listing, none)),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Attested), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, unsure), attribute(end_user_consent_given, attested(false, attestation(host, moment, withdrawn, none))), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, attested(false, attestation(host, moment, no_basis, none))), attribute(consent_request_already_repeated_in_period, false)],
    findall(Problems, dma_art_5_2_data_combination_order_input_problems(Profile, Problems), Solutions),
    Solutions == [[]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems(profile, Problems), Solutions),
    Solutions == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems(_UnboundProfile, Problems), Solutions),
    Solutions == [[wrong_type(profile)]].
test(an_element_that_is_not_an_attribute_is_wrong_type_profile) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(practice_under_article_5_2, combining_personal_data), stray], Problems),
    Problems == [wrong_type(profile)].
test(a_practice_outside_its_atoms_is_wrong_type) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(practice_under_article_5_2, maybe)], Problems),
    Problems == [wrong_type(practice_under_article_5_2)].
test(a_practice_inside_its_atoms_is_not_wrong_type) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(practice_under_article_5_2, unsure)], Problems),
    Problems == [].
test(unsure_is_wrong_type_for_the_crisp_key) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(consent_request_already_repeated_in_period, unsure)], Problems),
    Problems == [wrong_type(consent_request_already_repeated_in_period)].
test(a_plain_boolean_outside_fact_is_wrong_type) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(end_user_consent_given, true)], Problems),
    Problems == [wrong_type(end_user_consent_given)].
test(an_unbound_attestation_argument_is_wrong_type) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(end_user_consent_given, attested(true, attestation(host, moment, _Reason, none)))], Problems),
    Problems == [wrong_type(end_user_consent_given)].
test(an_unbound_value_is_wrong_type) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(end_user_consent_given, _Value)], Problems),
    Problems == [wrong_type(end_user_consent_given)].
test(a_repeated_contract_key_is_duplicate_key_only) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(practice_under_article_5_2, combining_personal_data), attribute(practice_under_article_5_2, maybe)], Problems),
    Problems == [duplicate_key(practice_under_article_5_2)].
test(unknown_keys_come_last_once_each_in_profile_order) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(colour, red), attribute(practice_under_article_5_2, maybe), attribute(42, true), attribute(colour, blue)], Problems),
    Problems == [wrong_type(practice_under_article_5_2), unknown_key(colour), unknown_key(42)].
test(the_cross_reference_referral_builds_and_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Resolved), Attempt), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2022_1925_art_5_1,
    Target == commission_designation_decision,
    Resolved == Target,
    Attempt == not_attempted,
    Pairs == [designated_as_gatekeeper_for_core_platform_service - absent].
test(the_open_textured_referral_builds_and_destructures) :-
    Result = needs_legal_review(open_textured(end_user_presented_with_specific_choice, cite(eu_reg_2022_1925_art_5_2)), [inputs_relied_on([practice_under_article_5_2 - combining_personal_data, end_user_presented_with_specific_choice - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == end_user_presented_with_specific_choice,
    Citation == eu_reg_2022_1925_art_5_2,
    length(Pairs, 2).
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([practice_under_article_5_2]),
    Result = indeterminate([Missing]),
    Missing == practice_under_article_5_2.
test(the_basis_copies_the_attested_statement) :-
    Attested = attested(true, attestation(host, moment, commission_listing, none)),
    Basis = [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)],
    Basis = [outside_fact(Fact, attested(Truth, attestation(Author, Moment, Reason, Evidence)))],
    Fact == designated_as_gatekeeper_for_core_platform_service,
    Truth == true,
    Author == host,
    Moment == moment,
    Reason == commission_listing,
    Evidence == none.
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dma_art_5_2_data_combination_order_verdict(practice_prohibited, [cite(eu_reg_2022_1925_art_5_1), cite(eu_reg_2022_1925_art_5_2), cite(eu_reg_2022_1925_art_5_2_b)]),
    Verdict = dma_art_5_2_data_combination_order_verdict(Status, Citations),
    Status == practice_prohibited,
    length(Citations, 3).
test(the_application_atoms_are_distinct) :-
    dif(article_5_obligations_apply, article_5_obligations_do_not_apply).
test(the_practice_atoms_are_distinct) :-
    dif(practice_allowed_with_consent, practice_allowed_on_other_legal_basis),
    dif(practice_allowed_with_consent, practice_prohibited),
    dif(practice_allowed_with_consent, practice_outside_article_5_2),
    dif(practice_allowed_on_other_legal_basis, practice_prohibited),
    dif(practice_allowed_on_other_legal_basis, practice_outside_article_5_2),
    dif(practice_prohibited, practice_outside_article_5_2),
    dif(practice_prohibited, article_5_obligations_do_not_apply).
test(the_repetition_atoms_are_distinct) :-
    dif(repeated_request_permitted, repeated_request_not_permitted),
    dif(repeated_request_permitted, request_after_one_year_period),
    dif(repeated_request_not_permitted, request_after_one_year_period),
    dif(request_after_one_year_period, article_5_obligations_do_not_apply).
test(the_article_5_1_citation_is_recorded) :-
    citation(eu_reg_2022_1925_art_5_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(every_lexicon_key_resolves) :-
    citation(eu_reg_2022_1925_art_5_2, _),
    citation(eu_reg_2022_1925_art_5_2_a, _),
    citation(eu_reg_2022_1925_art_5_2_b, _),
    citation(eu_reg_2022_1925_art_5_2_c, _),
    citation(eu_reg_2022_1925_art_5_2_d, _),
    citation(eu_reg_2022_1925_art_2_32, _).
test(every_referral_target_resolves) :-
    citation(commission_designation_decision, _),
    citation(digital_markets_end_user_consent_statement, _),
    citation(digital_markets_article_6_1_c_d_e_basis_statement, _).
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2022_1925_art_5_2).

test(the_marker_fails_for_a_shortened_key, fail) :-
    implements(dma_art_5_2).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, an_element_that_is_not_an_attribute_is_wrong_type_profile, a_practice_outside_its_atoms_is_wrong_type, a_practice_inside_its_atoms_is_not_wrong_type, unsure_is_wrong_type_for_the_crisp_key, a_plain_boolean_outside_fact_is_wrong_type, an_unbound_attestation_argument_is_wrong_type, an_unbound_value_is_wrong_type, a_repeated_contract_key_is_duplicate_key_only, unknown_keys_come_last_once_each_in_profile_order, the_cross_reference_referral_builds_and_destructures, the_open_textured_referral_builds_and_destructures, the_indeterminate_status_names_one_key, the_basis_copies_the_attested_statement, the_verdict_term_carries_status_and_citations, the_application_atoms_are_distinct, the_practice_atoms_are_distinct, the_repetition_atoms_are_distinct, the_article_5_1_citation_is_recorded, every_lexicon_key_resolves, every_referral_target_resolves, the_marker_holds_for_a_recorded_key]).
cp_test_fail_names([the_marker_fails_for_a_shortened_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
