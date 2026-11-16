% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_queries, [gdpr_art89_research_safeguards_profile_keys/1, gdpr_art89_research_safeguards_what_if/4, gdpr_art89_research_safeguards_justification/2, gdpr_art89_research_safeguards_compliance_check/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_safeguards_status, [safeguards_status/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_fixtures, [gdpr_art89_research_safeguards_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_art89_research_safeguards_profile_keys(ProfileKeys),
    ProfileKeys == [identifiable_data_processed, minimisation_measures_in_place, non_identifying_processing_sufficient, purpose, safeguards_appropriate, technical_organisational_measures_in_place].
test(status_determination_yields_one_answer) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    findall(Status, safeguards_status(Profile, Status), Statuses),
    Statuses == [in_accordance].
test(what_if_yields_one_answer) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    findall(Status, gdpr_art89_research_safeguards_what_if(Profile, technical_organisational_measures_in_place, false, Status), Statuses),
    Statuses == [not_in_accordance].
test(what_if_adds_an_absent_key) :-
    gdpr_art89_research_safeguards_profile_for(measures_key_absent, Profile),
    findall(Status, gdpr_art89_research_safeguards_what_if(Profile, technical_organisational_measures_in_place, true, Status), Statuses),
    Statuses == [in_accordance].
test(what_if_does_not_change_the_original) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, safeguards_appropriate, false, not_in_accordance),
    safeguards_status(Profile, in_accordance).
test(what_if_to_a_malformed_value_is_an_input_problem) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    gdpr_art89_research_safeguards_what_if(Profile, purpose, bogus, input_problems([wrong_type(purpose)])).
test(justification_carries_a_citation_per_item) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    findall(Items, gdpr_art89_research_safeguards_justification(Profile, Items), ItemLists),
    ItemLists == [[item(measures, met, cite(eu_reg_2016_679_art_89_1)), item(minimisation, met, cite(eu_reg_2016_679_art_89_1)), item(identification, met, cite(eu_reg_2016_679_art_89_1)), item(appropriateness, met, cite(eu_reg_2016_679_art_89_1))]].
test(justification_shows_the_unmet_item) :-
    gdpr_art89_research_safeguards_profile_for(no_measures, Profile),
    gdpr_art89_research_safeguards_justification(Profile, [item(measures, unmet, cite(eu_reg_2016_679_art_89_1))|_]).
test(justification_shows_the_judgement_item) :-
    gdpr_art89_research_safeguards_profile_for(appropriateness_unsure, Profile),
    gdpr_art89_research_safeguards_justification(Profile, [_, _, _, item(appropriateness, judgement(safeguards_appropriate), cite(eu_reg_2016_679_art_89_1))]).
test(justification_of_an_input_problem) :-
    gdpr_art89_research_safeguards_profile_for(unknown_key_given, Profile),
    findall(Items, gdpr_art89_research_safeguards_justification(Profile, Items), ItemLists),
    ItemLists == [[item(input_check, input_problems([unknown_key(extra_note)]), cite(eu_reg_2016_679_art_89_1))]].
test(compliance_permitted) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    findall(Result, gdpr_art89_research_safeguards_compliance_check(Profile, Result), Results),
    Results == [permitted].
test(compliance_prohibited) :-
    gdpr_art89_research_safeguards_profile_for(no_measures, Profile),
    findall(Result, gdpr_art89_research_safeguards_compliance_check(Profile, Result), Results),
    Results == [prohibited].
test(compliance_not_applicable_purpose_is_permitted) :-
    gdpr_art89_research_safeguards_profile_for(other_purpose_case, Profile),
    findall(Result, gdpr_art89_research_safeguards_compliance_check(Profile, Result), Results),
    Results == [permitted].
test(compliance_undetermined_when_indeterminate) :-
    gdpr_art89_research_safeguards_profile_for(purpose_absent, Profile),
    findall(Result, gdpr_art89_research_safeguards_compliance_check(Profile, Result), Results),
    Results == [undetermined].
test(compliance_undetermined_when_a_judgement_is_open) :-
    gdpr_art89_research_safeguards_profile_for(sufficiency_unsure, Profile),
    findall(Result, gdpr_art89_research_safeguards_compliance_check(Profile, Result), Results),
    Results == [undetermined].
test(compliance_undetermined_on_input_problems) :-
    gdpr_art89_research_safeguards_profile_for(unknown_key_given, Profile),
    findall(Result, gdpr_art89_research_safeguards_compliance_check(Profile, Result), Results),
    Results == [undetermined].

test(compliance_permitted_is_not_prohibited, fail) :-
    gdpr_art89_research_safeguards_profile_for(compliant_research, Profile),
    gdpr_art89_research_safeguards_compliance_check(Profile, prohibited).

cp_test_names([profile_keys_are_the_contract_keys, status_determination_yields_one_answer, what_if_yields_one_answer, what_if_adds_an_absent_key, what_if_does_not_change_the_original, what_if_to_a_malformed_value_is_an_input_problem, justification_carries_a_citation_per_item, justification_shows_the_unmet_item, justification_shows_the_judgement_item, justification_of_an_input_problem, compliance_permitted, compliance_prohibited, compliance_not_applicable_purpose_is_permitted, compliance_undetermined_when_indeterminate, compliance_undetermined_when_a_judgement_is_open, compliance_undetermined_on_input_problems]).
cp_test_fail_names([compliance_permitted_is_not_prohibited]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
