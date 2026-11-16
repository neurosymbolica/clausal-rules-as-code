% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_citations, [citation/2, implements/1]).

test(the_final_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_requirement_atoms_are_distinct) :-
    dif(without_undue_delay, reasons_for_delay).
test(the_content_result_atoms_are_distinct) :-
    dif(all_requirements_met, requirements_not_met),
    dif(all_requirements_met, information_to_follow_in_phases),
    dif(requirements_not_met, information_to_follow_in_phases).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = breach_notification_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)]),
    Verdict = breach_notification_verdict(Status, Citations),
    Status == eligible,
    Citations == [cite(eu_reg_2016_679_art_33_1)].
test(the_final_compound_destructures) :-
    Verdict = notification_requirement_not_met(without_undue_delay),
    Verdict = notification_requirement_not_met(Requirement),
    Requirement == without_undue_delay.
test(the_indeterminate_status_destructures) :-
    Status = indeterminate([breach_unlikely_to_result_in_risk, supervisory_authority_decision_on_communication]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [breach_unlikely_to_result_in_risk, supervisory_authority_decision_on_communication].
test(the_referral_status_destructures) :-
    Status = needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])]),
    Status = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == breach_unlikely_to_result_in_risk,
    Citation == cite(eu_reg_2016_679_art_33_1),
    Pairs == [breach_unlikely_to_result_in_risk - unsure].
test(the_obligation_list_destructures) :-
    Obligation = [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))],
    Obligation = [FirstDuty, SecondDuty],
    FirstDuty = notify_supervisory_authority(FirstCitation),
    SecondDuty = document_breach(SecondCitation),
    FirstCitation == cite(eu_reg_2016_679_art_33_1),
    SecondCitation == cite(eu_reg_2016_679_art_33_5).
test(the_period_end_term_destructures) :-
    PeriodEnd = period_end(date(2025, 11, 3), 11),
    PeriodEnd = period_end(date(Year, Month, Day), EndHour),
    Year == 2025,
    Month == 11,
    Day == 3,
    EndHour == 11.
test(the_primary_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_33_1, _Record).
test(the_primary_citation_is_implemented) :-
    implements(eu_reg_2016_679_art_33_1).
test(every_answer_citation_of_the_vocabulary_is_recorded) :-
    Keys = [eu_reg_2016_679_art_33_1, eu_reg_2016_679_art_33_2, eu_reg_2016_679_art_33_3_a, eu_reg_2016_679_art_33_3_d, eu_reg_2016_679_art_33_4, eu_reg_2016_679_art_33_5, eu_reg_2016_679_art_34_1, eu_reg_2016_679_art_34_2, eu_reg_2016_679_art_34_3_a, eu_reg_2016_679_art_34_3_b, eu_reg_2016_679_art_34_3_c, eu_reg_2016_679_art_34_4],
    findall(Key, (member(Key, Keys), citation(Key, _)), Found),
    Found == Keys.
test(every_marker_citation_of_the_vocabulary_is_recorded) :-
    Keys = [eu_reg_2016_679_art_33_3, eu_reg_2016_679_art_33_3_b, eu_reg_2016_679_art_33_3_c, eu_reg_2016_679_art_34_3, eu_reg_1971_1182_art_3_1, eu_reg_1971_1182_art_3_2, eu_reg_1971_1182_art_3_2_a, eu_reg_1971_1182_art_3_3, eu_reg_1971_1182_art_3_4],
    findall(Key, (member(Key, Keys), citation(Key, _)), Found),
    Found == Keys.
test(the_input_check_loads_and_accepts_an_empty_profile) :-
    gdpr_arts33_34_breach_notification_input_problems([], []).
test(the_input_check_refuses_a_non_list) :-
    gdpr_arts33_34_breach_notification_input_problems(profile, [wrong_type(profile)]).
test(the_input_check_names_an_unknown_key) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(colour, red)], [unknown_key(colour)]).

test(an_invented_citation_is_not_recorded, fail) :-
    citation(eu_reg_2016_679_art_33, _Record).
test(the_input_check_accepts_a_well_formed_profile_is_not_refused, fail) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller)], [_|_]).

cp_test_names([the_final_verdict_atoms_are_distinct, the_requirement_atoms_are_distinct, the_content_result_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_final_compound_destructures, the_indeterminate_status_destructures, the_referral_status_destructures, the_obligation_list_destructures, the_period_end_term_destructures, the_primary_citation_is_recorded, the_primary_citation_is_implemented, every_answer_citation_of_the_vocabulary_is_recorded, every_marker_citation_of_the_vocabulary_is_recorded, the_input_check_loads_and_accepts_an_empty_profile, the_input_check_refuses_a_non_list, the_input_check_names_an_unknown_key]).
cp_test_fail_names([an_invented_citation_is_not_recorded, the_input_check_accepts_a_well_formed_profile_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
