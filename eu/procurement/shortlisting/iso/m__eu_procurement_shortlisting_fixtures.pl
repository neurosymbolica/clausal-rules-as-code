:- module(m__eu_procurement_shortlisting_fixtures, [shortlisting_subject/1, shortlisting_profile_for/2, shortlisting_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__eu_procurement_shortlisting_shortlisting, [decide_shortlisting/2]).

shortlisting_subject("restricted_all_clear").
shortlisting_subject("restricted_below_statutory").
shortlisting_subject("restricted_at_continuation_boundary").
shortlisting_subject("restricted_continuation").
shortlisting_subject("restricted_max_at_min").
shortlisting_subject("restricted_max_below_min").
shortlisting_subject("open_procedure").
shortlisting_subject("restricted_defect_criteria").
shortlisting_subject("cpwn_all_clear").
shortlisting_subject("cpwn_continuation").

shortlisting_profile_for("restricted_all_clear", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, objective_and_non_discriminatory_criteria_indicated - true, minimum_number_indicated - true, declared_minimum_candidates - 5, declared_maximum_candidates - 8, qualified_candidates - 10, invited_candidates - 5, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).
shortlisting_profile_for("restricted_below_statutory", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, objective_and_non_discriminatory_criteria_indicated - true, minimum_number_indicated - true, declared_minimum_candidates - 4, declared_maximum_candidates - 8, qualified_candidates - 10, invited_candidates - 5, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).
shortlisting_profile_for("restricted_at_continuation_boundary", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, objective_and_non_discriminatory_criteria_indicated - true, minimum_number_indicated - true, declared_minimum_candidates - 5, declared_maximum_candidates - 0, qualified_candidates - 5, invited_candidates - 5, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).
shortlisting_profile_for("restricted_continuation", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, objective_and_non_discriminatory_criteria_indicated - true, minimum_number_indicated - true, declared_minimum_candidates - 5, declared_maximum_candidates - 0, qualified_candidates - 4, invited_candidates - 4, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).
shortlisting_profile_for("restricted_max_at_min", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, objective_and_non_discriminatory_criteria_indicated - true, minimum_number_indicated - true, declared_minimum_candidates - 5, declared_maximum_candidates - 5, qualified_candidates - 10, invited_candidates - 5, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).
shortlisting_profile_for("restricted_max_below_min", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, objective_and_non_discriminatory_criteria_indicated - true, minimum_number_indicated - true, declared_minimum_candidates - 5, declared_maximum_candidates - 4, qualified_candidates - 10, invited_candidates - 5, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).
shortlisting_profile_for("open_procedure", Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, objective_and_non_discriminatory_criteria_indicated - true, minimum_number_indicated - true, declared_minimum_candidates - 0, declared_maximum_candidates - 0, qualified_candidates - 10, invited_candidates - 10, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).
shortlisting_profile_for("restricted_defect_criteria", Profile) :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, objective_and_non_discriminatory_criteria_indicated - false, minimum_number_indicated - true, declared_minimum_candidates - 5, declared_maximum_candidates - 8, qualified_candidates - 10, invited_candidates - 5, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).
shortlisting_profile_for("cpwn_all_clear", Profile) :-
    dict_pairs(Profile, [procedure_type_key - competitive_procedure_with_negotiation, objective_and_non_discriminatory_criteria_indicated - true, minimum_number_indicated - true, declared_minimum_candidates - 3, declared_maximum_candidates - 6, qualified_candidates - 8, invited_candidates - 3, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).
shortlisting_profile_for("cpwn_continuation", Profile) :-
    dict_pairs(Profile, [procedure_type_key - competitive_procedure_with_negotiation, objective_and_non_discriminatory_criteria_indicated - true, minimum_number_indicated - true, declared_minimum_candidates - 3, declared_maximum_candidates - 0, qualified_candidates - 2, invited_candidates - 2, number_invited_sufficient_for_genuine_competition - true, invited_include_non_requesting_economic_operators - false, invited_include_candidates_without_required_capabilities - false]).

shortlisting_assess(Subject, Result) :-
    shortlisting_profile_for(Subject, Profile),
    decide_shortlisting(Profile, Result).
