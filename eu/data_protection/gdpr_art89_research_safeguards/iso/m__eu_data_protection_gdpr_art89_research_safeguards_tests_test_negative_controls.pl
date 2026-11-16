% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_safeguards_status, [safeguards_status_status/2, safeguards_status_status_values/1, unmet_requirements/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_fixtures, [gdpr_art89_research_safeguards_profile_for/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_queries, [gdpr_art89_research_safeguards_what_if/4]).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    safeguards_status_status_values(StatusValues),
    member(not_in_accordance, StatusValues).
test(measures_unmet_is_not_in_accordance) :-
    gdpr_art89_research_safeguards_profile_for(no_measures, Profile),
    safeguards_status_status(Profile, not_in_accordance).
test(restoring_measures_flips_to_in_accordance) :-
    gdpr_art89_research_safeguards_profile_for(no_measures, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, technical_organisational_measures_in_place, true, in_accordance).
test(minimisation_unmet_is_not_in_accordance) :-
    gdpr_art89_research_safeguards_profile_for(no_minimisation, Profile),
    unmet_requirements(Profile, [minimisation]).
test(restoring_minimisation_flips_to_in_accordance) :-
    gdpr_art89_research_safeguards_profile_for(no_minimisation, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, minimisation_measures_in_place, true, in_accordance).
test(identifiable_and_sufficient_is_unmet) :-
    gdpr_art89_research_safeguards_profile_for(identifiable_and_sufficient, Profile),
    unmet_requirements(Profile, [identification]).
test(identifiable_but_not_sufficient_is_in_accordance) :-
    gdpr_art89_research_safeguards_profile_for(identifiable_not_sufficient, Profile),
    safeguards_status_status(Profile, in_accordance).
test(non_identifiable_data_ignores_the_sufficiency_judgement) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, non_identifying_processing_sufficient, unsure, in_accordance).
test(non_identifiable_data_ignores_a_true_sufficiency_judgement) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, non_identifying_processing_sufficient, true, in_accordance).
test(inappropriate_safeguards_is_unmet) :-
    gdpr_art89_research_safeguards_profile_for(inappropriate_safeguards, Profile),
    unmet_requirements(Profile, [appropriateness]).
test(absent_purpose_is_indeterminate) :-
    gdpr_art89_research_safeguards_profile_for(purpose_absent, Profile),
    safeguards_status_status(Profile, indeterminate([purpose])).
test(other_purpose_is_not_applicable) :-
    gdpr_art89_research_safeguards_profile_for(other_purpose_case, Profile),
    safeguards_status_status(Profile, not_applicable).
test(naming_a_research_purpose_applies_the_article) :-
    gdpr_art89_research_safeguards_profile_for(other_purpose_case, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, purpose, scientific_research, not_in_accordance).
test(absent_measures_key_is_indeterminate) :-
    gdpr_art89_research_safeguards_profile_for(measures_key_absent, Profile),
    safeguards_status_status(Profile, indeterminate([technical_organisational_measures_in_place])).
test(supplying_the_absent_key_flips_to_in_accordance) :-
    gdpr_art89_research_safeguards_profile_for(measures_key_absent, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, technical_organisational_measures_in_place, true, in_accordance).
test(unmet_dominates_absence) :-
    gdpr_art89_research_safeguards_profile_for(unmet_dominates_absence, Profile),
    safeguards_status_status(Profile, not_in_accordance).
test(unsure_sufficiency_needs_legal_review) :-
    gdpr_art89_research_safeguards_profile_for(sufficiency_unsure, Profile),
    safeguards_status_status(Profile, needs_legal_review(open_textured(non_identifying_processing_sufficient, cite(eu_reg_2016_679_art_89_1)), _)).
test(deciding_sufficiency_true_flips_to_unmet) :-
    gdpr_art89_research_safeguards_profile_for(sufficiency_unsure, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, non_identifying_processing_sufficient, true, not_in_accordance).
test(deciding_sufficiency_false_flips_to_in_accordance) :-
    gdpr_art89_research_safeguards_profile_for(sufficiency_unsure, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, non_identifying_processing_sufficient, false, in_accordance).
test(unsure_appropriateness_needs_legal_review) :-
    gdpr_art89_research_safeguards_profile_for(appropriateness_unsure, Profile),
    safeguards_status_status(Profile, needs_legal_review(open_textured(safeguards_appropriate, cite(eu_reg_2016_679_art_89_1)), _)).
test(deciding_appropriateness_true_flips_to_in_accordance) :-
    gdpr_art89_research_safeguards_profile_for(appropriateness_unsure, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, safeguards_appropriate, true, in_accordance).
test(unknown_key_is_an_input_problem) :-
    gdpr_art89_research_safeguards_profile_for(unknown_key_given, Profile),
    safeguards_status_status(Profile, input_problems([unknown_key(extra_note)])).

test(measures_met_is_not_not_in_accordance, fail) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    safeguards_status_status(Profile, not_in_accordance).
test(minimisation_met_leaves_no_unmet_list, fail) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    unmet_requirements(Profile, [minimisation]).
test(not_sufficient_is_not_unmet, fail) :-
    gdpr_art89_research_safeguards_profile_for(identifiable_not_sufficient, Profile),
    unmet_requirements(Profile, [identification]).
test(appropriate_safeguards_is_not_unmet, fail) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    unmet_requirements(Profile, [appropriateness]).
test(present_purpose_is_not_indeterminate, fail) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    safeguards_status_status(Profile, indeterminate(_)).
test(a_named_purpose_is_not_not_applicable, fail) :-
    gdpr_art89_research_safeguards_profile_for(no_measures, Profile),
    safeguards_status_status(Profile, not_applicable).
test(a_complete_profile_is_not_indeterminate, fail) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    safeguards_status_status(Profile, indeterminate(_)).
test(unmet_dominating_absence_is_not_indeterminate, fail) :-
    gdpr_art89_research_safeguards_profile_for(unmet_dominates_absence, Profile),
    safeguards_status_status(Profile, indeterminate(_)).
test(a_decided_profile_needs_no_legal_review, fail) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    safeguards_status_status(Profile, needs_legal_review(_, _)).
test(a_clean_profile_has_no_input_problems, fail) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    safeguards_status_status(Profile, input_problems(_)).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, measures_unmet_is_not_in_accordance, restoring_measures_flips_to_in_accordance, minimisation_unmet_is_not_in_accordance, restoring_minimisation_flips_to_in_accordance, identifiable_and_sufficient_is_unmet, identifiable_but_not_sufficient_is_in_accordance, non_identifiable_data_ignores_the_sufficiency_judgement, non_identifiable_data_ignores_a_true_sufficiency_judgement, inappropriate_safeguards_is_unmet, absent_purpose_is_indeterminate, other_purpose_is_not_applicable, naming_a_research_purpose_applies_the_article, absent_measures_key_is_indeterminate, supplying_the_absent_key_flips_to_in_accordance, unmet_dominates_absence, unsure_sufficiency_needs_legal_review, deciding_sufficiency_true_flips_to_unmet, deciding_sufficiency_false_flips_to_in_accordance, unsure_appropriateness_needs_legal_review, deciding_appropriateness_true_flips_to_in_accordance, unknown_key_is_an_input_problem]).
cp_test_fail_names([measures_met_is_not_not_in_accordance, minimisation_met_leaves_no_unmet_list, not_sufficient_is_not_unmet, appropriate_safeguards_is_not_unmet, present_purpose_is_not_indeterminate, a_named_purpose_is_not_not_applicable, a_complete_profile_is_not_indeterminate, unmet_dominating_absence_is_not_indeterminate, a_decided_profile_needs_no_legal_review, a_clean_profile_has_no_input_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
