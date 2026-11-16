% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_kernel, [gdpr_child_consent_age_fields_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_citations, [citation/2, implements/1]).

test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_verification_atoms_are_distinct) :-
    dif(efforts_reasonable, efforts_not_reasonable).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = child_consent_status_verdict(eligible, [cite(eu_reg_2016_679_art_8_1)]),
    Verdict = child_consent_status_verdict(Status, Citations),
    Status == eligible,
    Citations == [cite(eu_reg_2016_679_art_8_1)].
test(the_referral_term_builds_and_destructures) :-
    Status = needs_legal_review(open_textured(information_society_service, cite(eu_reg_2016_679_art_4_25)), [inputs_relied_on([])]),
    Status = needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]),
    Input == information_society_service,
    Citation == cite(eu_reg_2016_679_art_4_25),
    Pairs == [].
test(a_real_citation_record_resolves) :-
    citation(eu_reg_2016_679_art_8_1, _Record).
test(implements_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_8_1_second_subpara).
test(an_empty_profile_has_no_problem) :-
    gdpr_child_consent_age_fields_input_problems([], []).
test(a_negative_age_is_a_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(child_age_years, -1)], [wrong_type(child_age_years)]).
test(a_well_formed_age_is_no_problem) :-
    gdpr_child_consent_age_fields_input_problems([attribute(child_age_years, 13)], []).
test(an_unknown_key_is_named) :-
    gdpr_child_consent_age_fields_input_problems([attribute(favourite_colour, blue)], [unknown_key(favourite_colour)]).
test(a_duplicate_key_is_named) :-
    gdpr_child_consent_age_fields_input_problems([attribute(child_age_years, 1), attribute(child_age_years, 2)], [duplicate_key(child_age_years)]).
test(a_non_list_profile_is_a_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems(not_a_profile, [wrong_type(profile)]).
test(an_attested_national_age_in_shape_is_no_problem) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(germany, 16, national_act(some_act, article_one)), attestation(decision_layer, date(2026, 11, 9), user_declared, none)))], []).
test(an_attested_age_below_13_is_a_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(germany, 12, national_act(some_act, article_one)), attestation(decision_layer, date(2026, 11, 9), user_declared, none)))], [wrong_type(member_state_digital_consent_age)]).
test(a_fetched_value_is_a_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_digital_consent_age, fetched(national_digital_consent_age(germany, 16, some_act), source(some_url, some_time, some_hash)))], [wrong_type(member_state_digital_consent_age)]).

test(a_misspelt_key_is_not_implemented, fail) :-
    implements(eu_reg_2016_679_art_8_one).

cp_test_names([the_verdict_atoms_are_distinct, the_verification_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_referral_term_builds_and_destructures, a_real_citation_record_resolves, implements_succeeds_for_a_recorded_key, an_empty_profile_has_no_problem, a_negative_age_is_a_wrong_type, a_well_formed_age_is_no_problem, an_unknown_key_is_named, a_duplicate_key_is_named, a_non_list_profile_is_a_wrong_type, an_attested_national_age_in_shape_is_no_problem, an_attested_age_below_13_is_a_wrong_type, a_fetched_value_is_a_wrong_type]).
cp_test_fail_names([a_misspelt_key_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
