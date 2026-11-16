% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_citations, [citation/2, implements/1]).

recorded_citation(CitationKey) :-
    citation(CitationKey, _).

returned_citation_keys([eu_reg_2016_679_art_6_1, eu_reg_2016_679_art_6_1_a, eu_reg_2016_679_art_6_1_b, eu_reg_2016_679_art_6_1_c, eu_reg_2016_679_art_6_1_d, eu_reg_2016_679_art_6_1_e, eu_reg_2016_679_art_6_1_f, eu_reg_2016_679_art_6_1_second_subpara, eu_reg_2016_679_art_6_3, eu_reg_2016_679_art_6_4]).

test(the_lawful_basis_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_compatibility_atoms_are_distinct) :-
    dif(purpose_compatible, purpose_not_compatible),
    dif(purpose_compatible, compatibility_test_not_engaged),
    dif(purpose_not_compatible, compatibility_test_not_engaged).
test(the_five_result_atoms_are_pairwise_distinct) :-
    Atoms = [eligible, ineligible, purpose_compatible, purpose_not_compatible, compatibility_test_not_engaged],
    sort(Atoms, Sorted),
    length(Sorted, Count),
    Count == 5.
test(the_indeterminate_result_names_one_key) :-
    Result = indeterminate([contract_necessary]),
    Result = indeterminate([Missing]),
    Missing == contract_necessary.
test(the_absent_referral_builds_and_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), Context),
    Context = [resolution(cite(Resolved), Status), inputs_relied_on(Relied)],
    Citation == eu_reg_2016_679_art_6_1_a,
    Target == consent_basis_statement,
    Resolved == consent_basis_statement,
    Status == not_attempted,
    Relied == [consent_given_and_conditions_met - absent].
test(the_open_textured_referral_builds_and_destructures) :-
    Result = needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing - true, compatible_purpose - unsure])]),
    Result = needs_legal_review(open_textured(Judgement, cite(Citation)), [inputs_relied_on(Relied)]),
    Judgement == compatible_purpose,
    Citation == eu_reg_2016_679_art_6_4,
    Relied == [new_purpose_processing - true, compatible_purpose - unsure].
test(the_basis_items_copy_the_attested_term) :-
    Attested = attested(true, attestation(host, stamp, stated, none)),
    Basis = [outside_fact(consent_given_and_conditions_met, Attested), flagged(special_category, Attested)],
    Basis = [outside_fact(FactKey, Copied), flagged(FlagKey, Flagged)],
    FactKey == consent_given_and_conditions_met,
    FlagKey == special_category,
    Copied == Attested,
    Flagged == Attested.
test(the_input_problems_result_wraps_its_list) :-
    Result = input_problems([wrong_type(contract_necessary)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(contract_necessary)].
test(the_general_rule_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_6_1, _Record).
test(every_returned_citation_key_is_recorded) :-
    returned_citation_keys(CitationKeys),
    maplist(recorded_citation, CitationKeys).
test(the_special_category_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_9_1, _Record).
test(the_marker_accepts_a_recorded_key) :-
    implements(eu_reg_2016_679_art_6_1_f).
test(the_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_art6_lawful_basis_input_problems([], Problems), Solutions),
    Solutions == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(basis_claimed, consent), attribute(consent_given_and_conditions_met, attested(true, attestation(host, stamp, stated, none))), attribute(contract_necessary, unsure), attribute(processing_by_public_authority_in_its_tasks, false)],
    findall(Problems, gdpr_art6_lawful_basis_input_problems(Profile, Problems), Solutions),
    Solutions == [[]].
test(a_judgement_outside_its_type_is_wrong_type) :-
    findall(Problems, gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, maybe)], Problems), Solutions),
    Solutions == [[wrong_type(contract_necessary)]].
test(a_bare_outside_fact_is_wrong_type) :-
    findall(Problems, gdpr_art6_lawful_basis_input_problems([attribute(special_category, true)], Problems), Solutions),
    Solutions == [[wrong_type(special_category)]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    findall(Problems, gdpr_art6_lawful_basis_input_problems([attribute(new_purpose_processing, unsure)], Problems), Solutions),
    Solutions == [[wrong_type(new_purpose_processing)]].
test(a_repeated_key_is_a_duplicate) :-
    Profile = [attribute(contract_necessary, true), attribute(contract_necessary, false)],
    findall(Problems, gdpr_art6_lawful_basis_input_problems(Profile, Problems), Solutions),
    Solutions == [[duplicate_key(contract_necessary)]].
test(a_key_outside_the_contract_is_unknown) :-
    findall(Problems, gdpr_art6_lawful_basis_input_problems([attribute(favourite_colour, true)], Problems), Solutions),
    Solutions == [[unknown_key(favourite_colour)]].
test(a_term_that_is_not_a_list_is_not_a_profile) :-
    findall(Problems, gdpr_art6_lawful_basis_input_problems(not_a_list, Problems), Solutions),
    Solutions == [[wrong_type(profile)]].
test(an_unbound_profile_is_not_a_profile) :-
    findall(Problems, gdpr_art6_lawful_basis_input_problems(_Unbound, Problems), Solutions),
    Solutions == [[wrong_type(profile)]].

test(eligible_is_not_ineligible, fail) :-
    eligible = ineligible.
test(the_marker_refuses_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_6_1_g).
test(an_unrecorded_citation_does_not_resolve, fail) :-
    citation(eu_todo_primary_source, _Record).
test(a_bad_profile_is_not_problem_free, fail) :-
    gdpr_art6_lawful_basis_input_problems(not_a_list, []).

cp_test_names([the_lawful_basis_atoms_are_distinct, the_compatibility_atoms_are_distinct, the_five_result_atoms_are_pairwise_distinct, the_indeterminate_result_names_one_key, the_absent_referral_builds_and_destructures, the_open_textured_referral_builds_and_destructures, the_basis_items_copy_the_attested_term, the_input_problems_result_wraps_its_list, the_general_rule_citation_is_recorded, every_returned_citation_key_is_recorded, the_special_category_citation_is_recorded, the_marker_accepts_a_recorded_key, the_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_judgement_outside_its_type_is_wrong_type, a_bare_outside_fact_is_wrong_type, a_crisp_key_given_unsure_is_wrong_type, a_repeated_key_is_a_duplicate, a_key_outside_the_contract_is_unknown, a_term_that_is_not_a_list_is_not_a_profile, an_unbound_profile_is_not_a_profile]).
cp_test_fail_names([eligible_is_not_ineligible, the_marker_refuses_an_unrecorded_key, an_unrecorded_citation_does_not_resolve, a_bad_profile_is_not_problem_free]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
