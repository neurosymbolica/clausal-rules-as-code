% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_14_terms_and_conditions_order_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_dsa_art_14_terms_and_conditions_order, [art_14_1_terms_and_conditions_content_status/4, art_14_2_significant_change_information_status/4, art_14_3_minors_explanation_status/4, art_14_4_restriction_enforcement_status/4, art_14_5_terms_and_conditions_summary_status/4, art_14_6_official_languages_status/4, decide_dsa_art_14_terms_and_conditions_order/2, dsa_art_14_terms_and_conditions_order_status/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_fixtures, [dsa_art_14_terms_and_conditions_order_profile_for/2]).

query_answer(art_14_1, Profile, Result, Basis, Citations) :-
    art_14_1_terms_and_conditions_content_status(Profile, Result, Basis, Citations).
query_answer(art_14_2, Profile, Result, Basis, Citations) :-
    art_14_2_significant_change_information_status(Profile, Result, Basis, Citations).
query_answer(art_14_3, Profile, Result, Basis, Citations) :-
    art_14_3_minors_explanation_status(Profile, Result, Basis, Citations).
query_answer(art_14_4, Profile, Result, Basis, Citations) :-
    art_14_4_restriction_enforcement_status(Profile, Result, Basis, Citations).
query_answer(art_14_5, Profile, Result, Basis, Citations) :-
    art_14_5_terms_and_conditions_summary_status(Profile, Result, Basis, Citations).
query_answer(art_14_6, Profile, Result, Basis, Citations) :-
    art_14_6_official_languages_status(Profile, Result, Basis, Citations).

answers(Paragraph, Subject, Answers) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, query_answer(Paragraph, Profile, Result, Basis, Citations), Answers).

test(empty_profile_art_14_1_names_the_first_item) :-
    answers(art_14_1, empty_profile, Answers),
    Answers == [indeterminate([terms_and_conditions_include_information_on_restrictions_on_recipient_information]) - [] - []].
test(empty_profile_art_14_2_names_the_change) :-
    answers(art_14_2, empty_profile, Answers),
    Answers == [indeterminate([terms_and_conditions_changed]) - [] - []].
test(empty_profile_art_14_3_names_the_first_condition) :-
    answers(art_14_3, empty_profile, Answers),
    Answers == [indeterminate([service_primarily_directed_at_minors]) - [] - []].
test(empty_profile_art_14_4_names_the_enforcement) :-
    answers(art_14_4, empty_profile, Answers),
    Answers == [indeterminate([provider_applies_or_enforces_restriction]) - [] - []].
test(empty_profile_art_14_5_names_the_summary_before_the_designation) :-
    answers(art_14_5, empty_profile, Answers),
    Answers == [indeterminate([concise_clear_machine_readable_summary_of_terms_and_conditions_provided]) - [] - []].
test(empty_profile_art_14_6_names_the_languages_before_the_designation) :-
    answers(art_14_6, empty_profile, Answers),
    Answers == [indeterminate([terms_and_conditions_published_in_official_languages_of_all_member_states_of_service]) - [] - []].
test(change_only_names_the_significance) :-
    answers(art_14_2, well_formed_change_only, Answers),
    Answers == [indeterminate([change_to_terms_and_conditions_is_significant]) - [] - []].
test(unsure_language_goes_to_a_lawyer_with_the_four_items) :-
    answers(art_14_1, unsure_language_judgement, Answers),
    Answers == [needs_legal_review(open_textured(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, cite(eu_reg_2022_2065_art_14_1)), [inputs_relied_on([terms_and_conditions_include_information_on_restrictions_on_recipient_information - true, terms_and_conditions_include_information_on_content_moderation - true, terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language - unsure, terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format - true])]) - [] - []].
test(absent_designation_refers_the_summary_question) :-
    answers(art_14_5, designation_absent_summary_unsure, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_5), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on([concise_clear_machine_readable_summary_of_terms_and_conditions_provided - unsure, designated_as_very_large_online_platform_or_search_engine - absent])]) - [] - []].
test(absent_designation_refers_the_languages_question) :-
    answers(art_14_6, designation_absent_summary_unsure, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_6), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform_or_search_engine - absent])]) - [] - []].
test(designated_unsure_summary_goes_to_a_lawyer) :-
    answers(art_14_5, designated_summary_unsure, Answers),
    Answers == [needs_legal_review(open_textured(concise_clear_machine_readable_summary_of_terms_and_conditions_provided, cite(eu_reg_2022_2065_art_14_5)), [inputs_relied_on([concise_clear_machine_readable_summary_of_terms_and_conditions_provided - unsure])]) - [] - []].
test(designated_without_languages_is_not_compliant_with_its_basis) :-
    answers(art_14_6, designation_attested_true, Answers),
    Answers == [art_14_6_official_languages_not_compliant - [outside_fact(designated_as_very_large_online_platform_or_search_engine, attested(true, attestation(host_service, attestation_time, commission_designation_decision, none)))] - [cite(eu_reg_2022_2065_art_14_6)]].
test(the_baseline_profile_yields_exactly_one_status) :-
    dsa_art_14_terms_and_conditions_order_profile_for(todo_baseline_subject, Profile),
    findall(Status, dsa_art_14_terms_and_conditions_order_status(Profile, Status), Statuses),
    Statuses == [dsa_art_14_terms_and_conditions_order_compliant].
test(the_verdict_carries_the_six_paragraph_citations) :-
    dsa_art_14_terms_and_conditions_order_profile_for(todo_baseline_subject, Profile),
    findall(Verdict, decide_dsa_art_14_terms_and_conditions_order(Profile, Verdict), Verdicts),
    Verdicts == [dsa_art_14_terms_and_conditions_order_verdict(dsa_art_14_terms_and_conditions_order_compliant, [cite(eu_reg_2022_2065_art_14_1), cite(eu_reg_2022_2065_art_14_2), cite(eu_reg_2022_2065_art_14_3), cite(eu_reg_2022_2065_art_14_4), cite(eu_reg_2022_2065_art_14_5), cite(eu_reg_2022_2065_art_14_6)])].

cp_test_names([empty_profile_art_14_1_names_the_first_item, empty_profile_art_14_2_names_the_change, empty_profile_art_14_3_names_the_first_condition, empty_profile_art_14_4_names_the_enforcement, empty_profile_art_14_5_names_the_summary_before_the_designation, empty_profile_art_14_6_names_the_languages_before_the_designation, change_only_names_the_significance, unsure_language_goes_to_a_lawyer_with_the_four_items, absent_designation_refers_the_summary_question, absent_designation_refers_the_languages_question, designated_unsure_summary_goes_to_a_lawyer, designated_without_languages_is_not_compliant_with_its_basis, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_the_six_paragraph_citations]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
