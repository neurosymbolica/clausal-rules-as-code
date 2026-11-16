% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_28_minors_order_kernel, [dsa_art_28_minors_order_input_problems/2]).
:- use_module(m__eu_dsa_art_28_minors_order_citations, [citation/2, implements/1]).

test(the_section_3_atoms_are_distinct) :-
    dif(section_3_applies, section_3_not_applicable).
test(the_obligation_atoms_are_distinct) :-
    dif(art_28_1_obligation_applies, art_28_1_obligation_not_applicable).
test(the_compliance_atoms_are_distinct) :-
    dif(art_28_1_measures_compliant, art_28_1_measures_not_compliant),
    dif(art_28_1_measures_compliant, art_28_1_measures_not_required),
    dif(art_28_1_measures_not_compliant, art_28_1_measures_not_required).
test(the_advertising_atoms_are_distinct) :-
    dif(art_28_2_presentation_prohibited, art_28_2_presentation_not_prohibited).
test(the_indeterminate_term_carries_one_key) :-
    Result = indeterminate([platform_accessible_to_minors]),
    Result = indeterminate([Key]),
    Key == platform_accessible_to_minors.
test(the_cross_reference_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform - absent])]),
    Result = needs_legal_review(Reason, Context),
    Reason = cross_reference_unresolved(cite(Citation), cite(Target)),
    Context = [resolution(cite(Target), Status), inputs_relied_on(Pairs)],
    Citation == eu_reg_2022_2065_art_19_2,
    Target == commission_vlop_designation_decision,
    Status == not_attempted,
    Pairs == [designated_as_very_large_online_platform - absent].
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on([PairKey - PairValue])]),
    Key == platform_accessible_to_minors,
    Citation == eu_reg_2022_2065_art_28_1,
    PairKey == platform_accessible_to_minors,
    PairValue == unsure.
test(the_basis_term_carries_the_statement_as_supplied) :-
    Attested = attested(false, attestation(host, timestamp, statement, none)),
    Basis = [outside_fact(designated_as_very_large_online_platform, Attested)],
    Basis = [outside_fact(Key, attested(Value, attestation(_, _, _, Evidence)))],
    Key == designated_as_very_large_online_platform,
    Value == false,
    Evidence == none.
test(the_art_19_records_resolve) :-
    citation(eu_reg_2022_2065_art_19_1, _),
    citation(eu_reg_2022_2065_art_19_2, _).
test(the_art_28_records_resolve) :-
    citation(eu_reg_2022_2065_art_28_1, _),
    citation(eu_reg_2022_2065_art_28_2, _).
test(the_designation_target_resolves) :-
    implements(commission_vlop_designation_decision).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2022_2065_art_28_2).
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(platform_accessible_to_minors, true), attribute(provider_qualifies_as_micro_or_small_enterprise, true), attribute(designated_as_very_large_online_platform, attested(false, attestation(host, timestamp, statement, none)))],
    findall(Problems, dsa_art_28_minors_order_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dsa_art_28_minors_order_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    findall(Problems, dsa_art_28_minors_order_input_problems([attribute(advertisements_presented_to_recipient_on_interface, unsure)], Problems), Answers),
    Answers == [[wrong_type(advertisements_presented_to_recipient_on_interface)]].
test(a_judgement_given_unsure_is_well_formed) :-
    findall(Problems, dsa_art_28_minors_order_input_problems([attribute(advertisements_based_on_profiling_of_recipient, unsure)], Problems), Answers),
    Answers == [[]].
test(a_plain_designation_is_wrong_type) :-
    findall(Problems, dsa_art_28_minors_order_input_problems([attribute(designated_as_very_large_online_platform, true)], Problems), Answers),
    Answers == [[wrong_type(designated_as_very_large_online_platform)]].
test(a_key_outside_the_contract_is_unknown) :-
    findall(Problems, dsa_art_28_minors_order_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(a_repeated_key_is_duplicate) :-
    findall(Problems, dsa_art_28_minors_order_input_problems([attribute(platform_accessible_to_minors, true), attribute(platform_accessible_to_minors, true)], Problems), Answers),
    Answers == [[duplicate_key(platform_accessible_to_minors)]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, dsa_art_28_minors_order_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(the_same_well_formed_profile_has_no_problem) :-
    dsa_art_28_minors_order_input_problems([attribute(platform_accessible_to_minors, false)], []).

test(a_shortened_key_is_not_implemented, fail) :-
    implements(dsa_art_28_2).
test(a_well_formed_profile_is_not_reported, fail) :-
    dsa_art_28_minors_order_input_problems([attribute(platform_accessible_to_minors, false)], [_|_]).

cp_test_names([the_section_3_atoms_are_distinct, the_obligation_atoms_are_distinct, the_compliance_atoms_are_distinct, the_advertising_atoms_are_distinct, the_indeterminate_term_carries_one_key, the_cross_reference_referral_destructures, the_open_textured_referral_destructures, the_basis_term_carries_the_statement_as_supplied, the_art_19_records_resolve, the_art_28_records_resolve, the_designation_target_resolves, a_recorded_key_is_implemented, a_well_formed_profile_has_no_problem, an_empty_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, a_judgement_given_unsure_is_well_formed, a_plain_designation_is_wrong_type, a_key_outside_the_contract_is_unknown, a_repeated_key_is_duplicate, a_term_that_is_not_a_list_is_wrong_type_profile, the_same_well_formed_profile_has_no_problem]).
cp_test_fail_names([a_shortened_key_is_not_implemented, a_well_formed_profile_is_not_reported]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
