% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_verdict_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_kernel, [gdpr_child_consent_age_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_citations, [citation/2, implements/1]).

test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_child_consent_verdict(eligible, art8_not_engaged, not_applicable, [cite(eu_reg_2016_679_art_8_1)]),
    Verdict = gdpr_child_consent_verdict(Status, Ground, Verification, Citations),
    Status == eligible,
    Ground == art8_not_engaged,
    Verification == not_applicable,
    Citations == [cite(eu_reg_2016_679_art_8_1)].
test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_grounds_are_distinct) :-
    dif(child_at_least_16, child_at_least_national_age).
test(a_real_citation_record_resolves) :-
    citation(eu_reg_2016_679_art_8_1, _Record).
test(implements_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_8_2).
test(an_empty_profile_has_no_problem) :-
    gdpr_child_consent_age_verdict_input_problems([], []).
test(an_unknown_key_is_named) :-
    gdpr_child_consent_age_verdict_input_problems([attribute(favourite_colour, blue)], [unknown_key(favourite_colour)]).
test(a_bad_age_is_named) :-
    gdpr_child_consent_age_verdict_input_problems([attribute(child_age_years, -1)], [wrong_type(child_age_years)]).
test(a_good_attested_national_age_has_no_problem) :-
    gdpr_child_consent_age_verdict_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(austria, 14, national_provision(act, article)), attestation(host, stamp, reason, none)))], []).

cp_test_names([the_verdict_term_builds_and_destructures, the_verdict_atoms_are_distinct, the_grounds_are_distinct, a_real_citation_record_resolves, implements_succeeds_for_a_recorded_key, an_empty_profile_has_no_problem, an_unknown_key_is_named, a_bad_age_is_named, a_good_attested_national_age_has_no_problem]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
