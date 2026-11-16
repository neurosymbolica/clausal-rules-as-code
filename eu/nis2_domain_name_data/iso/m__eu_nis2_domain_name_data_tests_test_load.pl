% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).
:- use_module(m__eu_nis2_domain_name_data_citations, [citation/2, implements/1]).

test(the_empty_profile_has_no_input_problem) :-
    nis2_domain_name_data_input_problems([], Problems),
    Problems == [].
test(a_non_list_profile_is_a_wrong_type) :-
    nis2_domain_name_data_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(the_publication_verdict_atoms_are_distinct) :-
    dif(must_publish_without_undue_delay, no_publication_duty).
test(the_access_verdict_atoms_are_distinct) :-
    dif(must_provide_access, no_duty_to_provide_access).
test(the_timeliness_atoms_are_distinct) :-
    dif(on_time, late(hour_limit)),
    dif(late(hour_limit), late(without_undue_delay)).
test(the_duty_term_builds_and_destructures) :-
    Duty = duty(reply_to_access_requests_within_72_hours, cite(eu_dir_2022_2555_art_28_5)),
    Duty = duty(Name, Citation),
    Name == reply_to_access_requests_within_72_hours,
    Citation == cite(eu_dir_2022_2555_art_28_5).
test(the_referral_term_builds_and_destructures) :-
    Result = needs_legal_review(open_textured(registration_data_is_personal_data, cite(eu_dir_2022_2555_art_28_4)), [inputs_relied_on([registration_data_is_personal_data - unsure])]),
    Result = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == registration_data_is_personal_data,
    Citation == cite(eu_dir_2022_2555_art_28_4),
    Pairs == [registration_data_is_personal_data - unsure].
test(the_indeterminate_term_names_missing_keys) :-
    Result = indeterminate([provider_type]),
    Result = indeterminate(MissingKeys),
    MissingKeys == [provider_type].
test(a_real_citation_record_resolves) :-
    citation(eu_dir_2022_2555_art_28_5, _Record).
test(the_implements_marker_succeeds_for_a_recorded_key) :-
    implements(eu_dir_2022_2555_art_28_4).

test(the_implements_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_dir_2022_2555_art_28_99).

cp_test_names([the_empty_profile_has_no_input_problem, a_non_list_profile_is_a_wrong_type, the_publication_verdict_atoms_are_distinct, the_access_verdict_atoms_are_distinct, the_timeliness_atoms_are_distinct, the_duty_term_builds_and_destructures, the_referral_term_builds_and_destructures, the_indeterminate_term_names_missing_keys, a_real_citation_record_resolves, the_implements_marker_succeeds_for_a_recorded_key]).
cp_test_fail_names([the_implements_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
