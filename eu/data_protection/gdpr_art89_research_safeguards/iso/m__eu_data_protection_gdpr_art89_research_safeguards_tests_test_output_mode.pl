% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_safeguards_status, [decide_safeguards_status/2, safeguards_status_status/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_fixtures, [gdpr_art89_research_safeguards_profile_for/2, gdpr_art89_research_safeguards_assess/2]).

test(compliant_research_yields_exactly_one_status) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    findall(Status, safeguards_status_status(Profile, Status), Statuses),
    Statuses == [in_accordance].
test(the_verdict_carries_a_citation) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    decide_safeguards_status(Profile, safeguards_status_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(compliant_research_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(compliant_research, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(in_accordance, [], [cite(eu_reg_2016_679_art_89_1)])].
test(no_measures_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(no_measures, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(not_in_accordance, [measures], [cite(eu_reg_2016_679_art_89_1)])].
test(no_minimisation_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(no_minimisation, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(not_in_accordance, [minimisation], [cite(eu_reg_2016_679_art_89_1)])].
test(identifiable_and_sufficient_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(identifiable_and_sufficient, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(not_in_accordance, [identification], [cite(eu_reg_2016_679_art_89_1)])].
test(identifiable_not_sufficient_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(identifiable_not_sufficient, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(in_accordance, [], [cite(eu_reg_2016_679_art_89_1)])].
test(inappropriate_safeguards_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(inappropriate_safeguards, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(not_in_accordance, [appropriateness], [cite(eu_reg_2016_679_art_89_1)])].
test(two_unmet_requirements_in_fixed_order) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(measures_and_minimisation_unmet, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(not_in_accordance, [measures, minimisation], [cite(eu_reg_2016_679_art_89_1)])].
test(purpose_absent_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(purpose_absent, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(indeterminate([purpose]), [], [])].
test(other_purpose_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(other_purpose_case, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(not_applicable, [], [])].
test(measures_key_absent_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(measures_key_absent, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(indeterminate([technical_organisational_measures_in_place]), [], [])].
test(identification_keys_absent_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(identification_keys_absent, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(indeterminate([identifiable_data_processed, non_identifying_processing_sufficient]), [], [])].
test(sufficiency_unsure_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(sufficiency_unsure, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(needs_legal_review(open_textured(non_identifying_processing_sufficient, cite(eu_reg_2016_679_art_89_1)), [inputs_relied_on([identifiable_data_processed - true, non_identifying_processing_sufficient - unsure])]), [], [])].
test(appropriateness_unsure_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(appropriateness_unsure, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(needs_legal_review(open_textured(safeguards_appropriate, cite(eu_reg_2016_679_art_89_1)), [inputs_relied_on([safeguards_appropriate - unsure])]), [], [])].
test(unknown_key_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(unknown_key_given, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(input_problems([unknown_key(extra_note)]), [], [])].
test(unmet_dominates_absence_verdict) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(unmet_dominates_absence, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(not_in_accordance, [measures], [cite(eu_reg_2016_679_art_89_1)])].
test(first_unsure_judgement_in_root_order_is_the_input) :-
    findall(Verdict, gdpr_art89_research_safeguards_assess(both_judgements_unsure, Verdict), Verdicts),
    Verdicts == [gdpr_art89_verdict(needs_legal_review(open_textured(non_identifying_processing_sufficient, cite(eu_reg_2016_679_art_89_1)), [inputs_relied_on([identifiable_data_processed - true, non_identifying_processing_sufficient - unsure])]), [], [])].

cp_test_names([compliant_research_yields_exactly_one_status, the_verdict_carries_a_citation, compliant_research_verdict, no_measures_verdict, no_minimisation_verdict, identifiable_and_sufficient_verdict, identifiable_not_sufficient_verdict, inappropriate_safeguards_verdict, two_unmet_requirements_in_fixed_order, purpose_absent_verdict, other_purpose_verdict, measures_key_absent_verdict, identification_keys_absent_verdict, sufficiency_unsure_verdict, appropriateness_unsure_verdict, unknown_key_verdict, unmet_dominates_absence_verdict, first_unsure_judgement_in_root_order_is_the_input]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
