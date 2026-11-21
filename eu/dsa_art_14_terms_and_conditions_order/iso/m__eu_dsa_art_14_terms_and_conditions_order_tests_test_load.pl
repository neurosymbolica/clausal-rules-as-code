% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_14_terms_and_conditions_order_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_kernel, [dsa_art_14_terms_and_conditions_order_input_problems/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_citations, [citation/2, implements/1]).

test(the_input_check_accepts_an_empty_profile) :-
    dsa_art_14_terms_and_conditions_order_input_problems([], Problems),
    Problems == [].
test(the_input_check_accepts_a_well_formed_profile) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(terms_and_conditions_include_information_on_restrictions_on_recipient_information, true), attribute(provider_has_internal_complaint_handling_system, false), attribute(service_predominantly_used_by_minors, unsure), attribute(designated_as_very_large_online_platform_or_search_engine, attested(false, attestation(host, at_time, no_commission_decision, none)))], Problems),
    Problems == [].
test(the_input_check_names_a_wrong_type_then_an_unknown_key) :-
    dsa_art_14_terms_and_conditions_order_input_problems([attribute(stray_key, true), attribute(terms_and_conditions_changed, unsure)], Problems),
    Problems == [wrong_type(terms_and_conditions_changed), unknown_key(stray_key)].
test(the_input_check_rejects_a_term_that_is_not_an_attribute_list) :-
    dsa_art_14_terms_and_conditions_order_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(the_input_check_has_exactly_one_answer) :-
    findall(Problems, dsa_art_14_terms_and_conditions_order_input_problems([attribute(service_primarily_directed_at_minors, true)], Problems), Answers),
    Answers == [[]].
test(the_final_answer_shape_builds_and_destructures) :-
    Answer = answer(art_14_6_official_languages_compliant, [outside_fact(designated_as_very_large_online_platform_or_search_engine, attested(true, attestation(host, at_time, commission_decision, none)))], [cite(eu_reg_2022_2065_art_14_6)]),
    Answer = answer(Result, [outside_fact(Key, attested(Value, _))], [cite(Paragraph)]),
    Result == art_14_6_official_languages_compliant,
    Key == designated_as_very_large_online_platform_or_search_engine,
    Value == true,
    Paragraph == eu_reg_2022_2065_art_14_6.
test(the_indeterminate_status_names_one_bare_key) :-
    Status = indeterminate([provider_applies_or_enforces_restriction]),
    Status = indeterminate([MissingKey]),
    MissingKey == provider_applies_or_enforces_restriction.
test(the_open_textured_referral_builds_and_destructures) :-
    Status = needs_legal_review(open_textured(change_to_terms_and_conditions_is_significant, cite(eu_reg_2022_2065_art_14_2)), [inputs_relied_on([change_to_terms_and_conditions_is_significant - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(Paragraph)), [inputs_relied_on(Pairs)]),
    Input == change_to_terms_and_conditions_is_significant,
    Paragraph == eu_reg_2022_2065_art_14_2,
    Pairs == [change_to_terms_and_conditions_is_significant - unsure].
test(the_cross_reference_referral_builds_and_destructures) :-
    Status = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_6), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform_or_search_engine - absent])]),
    Status = needs_legal_review(cross_reference_unresolved(cite(Paragraph), cite(Target)), [resolution(cite(Target), Resolution), inputs_relied_on(Pairs)]),
    Paragraph == eu_reg_2022_2065_art_14_6,
    Target == commission_vlop_or_vlose_designation_decision,
    Resolution == not_attempted,
    Pairs == [designated_as_very_large_online_platform_or_search_engine - absent].
test(the_input_problems_status_carries_the_problem_list) :-
    Status = input_problems([duplicate_key(terms_and_conditions_changed), unknown_key(stray_key)]),
    Status = input_problems(Problems),
    Problems == [duplicate_key(terms_and_conditions_changed), unknown_key(stray_key)].
test(the_art_14_1_verdict_atoms_are_distinct) :-
    dif(art_14_1_terms_and_conditions_compliant, art_14_1_terms_and_conditions_not_compliant).
test(the_art_14_2_verdict_atoms_are_distinct) :-
    dif(art_14_2_change_information_compliant, art_14_2_change_information_not_compliant),
    dif(art_14_2_change_information_compliant, art_14_2_change_information_not_required),
    dif(art_14_2_change_information_not_compliant, art_14_2_change_information_not_required).
test(the_art_14_3_verdict_atoms_are_distinct) :-
    dif(art_14_3_minors_explanation_compliant, art_14_3_minors_explanation_not_compliant),
    dif(art_14_3_minors_explanation_compliant, art_14_3_minors_explanation_not_required),
    dif(art_14_3_minors_explanation_not_compliant, art_14_3_minors_explanation_not_required).
test(the_art_14_4_verdict_atoms_are_distinct) :-
    dif(art_14_4_restriction_enforcement_compliant, art_14_4_restriction_enforcement_not_compliant),
    dif(art_14_4_restriction_enforcement_compliant, art_14_4_restriction_enforcement_not_required),
    dif(art_14_4_restriction_enforcement_not_compliant, art_14_4_restriction_enforcement_not_required).
test(the_art_14_5_verdict_atoms_are_distinct) :-
    dif(art_14_5_summary_compliant, art_14_5_summary_not_compliant),
    dif(art_14_5_summary_compliant, art_14_5_summary_not_required),
    dif(art_14_5_summary_not_compliant, art_14_5_summary_not_required).
test(the_art_14_6_verdict_atoms_are_distinct) :-
    dif(art_14_6_official_languages_compliant, art_14_6_official_languages_not_compliant),
    dif(art_14_6_official_languages_compliant, art_14_6_official_languages_not_required),
    dif(art_14_6_official_languages_not_compliant, art_14_6_official_languages_not_required).
test(the_seventeen_result_atoms_are_all_different) :-
    Atoms = [art_14_1_terms_and_conditions_compliant, art_14_1_terms_and_conditions_not_compliant, art_14_2_change_information_compliant, art_14_2_change_information_not_compliant, art_14_2_change_information_not_required, art_14_3_minors_explanation_compliant, art_14_3_minors_explanation_not_compliant, art_14_3_minors_explanation_not_required, art_14_4_restriction_enforcement_compliant, art_14_4_restriction_enforcement_not_compliant, art_14_4_restriction_enforcement_not_required, art_14_5_summary_compliant, art_14_5_summary_not_compliant, art_14_5_summary_not_required, art_14_6_official_languages_compliant, art_14_6_official_languages_not_compliant, art_14_6_official_languages_not_required],
    sort(Atoms, Sorted),
    length(Sorted, 17).
test(the_art_14_1_citation_is_recorded) :-
    citation(eu_reg_2022_2065_art_14_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(every_answer_paragraph_is_recorded) :-
    citation(eu_reg_2022_2065_art_14_1, _),
    citation(eu_reg_2022_2065_art_14_2, _),
    citation(eu_reg_2022_2065_art_14_3, _),
    citation(eu_reg_2022_2065_art_14_4, _),
    citation(eu_reg_2022_2065_art_14_5, _),
    citation(eu_reg_2022_2065_art_14_6, _).
test(the_referral_target_is_recorded) :-
    citation(commission_vlop_or_vlose_designation_decision, _).
test(the_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2022_2065_art_14_4).

test(the_marker_fails_for_a_shortened_key, fail) :-
    implements(art_14_4).
test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _).

cp_test_names([the_input_check_accepts_an_empty_profile, the_input_check_accepts_a_well_formed_profile, the_input_check_names_a_wrong_type_then_an_unknown_key, the_input_check_rejects_a_term_that_is_not_an_attribute_list, the_input_check_has_exactly_one_answer, the_final_answer_shape_builds_and_destructures, the_indeterminate_status_names_one_bare_key, the_open_textured_referral_builds_and_destructures, the_cross_reference_referral_builds_and_destructures, the_input_problems_status_carries_the_problem_list, the_art_14_1_verdict_atoms_are_distinct, the_art_14_2_verdict_atoms_are_distinct, the_art_14_3_verdict_atoms_are_distinct, the_art_14_4_verdict_atoms_are_distinct, the_art_14_5_verdict_atoms_are_distinct, the_art_14_6_verdict_atoms_are_distinct, the_seventeen_result_atoms_are_all_different, the_art_14_1_citation_is_recorded, every_answer_paragraph_is_recorded, the_referral_target_is_recorded, the_marker_succeeds_for_a_recorded_key]).
cp_test_fail_names([the_marker_fails_for_a_shortened_key, the_placeholder_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
