% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2, serious_incident_reporting_root_key/2, serious_incident_reporting_key_type/2, calendar_date_t/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_citations, [citation/2, implements/1, citation_vocabulary/1, referral_row/2]).

test(the_report_due_term_carries_its_four_fields) :-
    FollowUp = [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system],
    Duty = report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 15, date(2028, 1, 16), FollowUp),
    Duty = report_due(Recipient, Days, LastDay, Duties),
    Recipient == market_surveillance_authority_of_member_state_where_incident_occurred,
    Days == 15,
    LastDay == date(2028, 1, 16),
    length(Duties, 5).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = serious_incident_reporting_verdict(not_a_serious_incident, [cite(eu_reg_2024_1689_art_3_49)]),
    Verdict = serious_incident_reporting_verdict(Status, Citations),
    Status == not_a_serious_incident,
    Citations == [cite(eu_reg_2024_1689_art_3_49)].
test(the_needs_legal_review_term_destructures) :-
    Review = needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([widespread_infringement - unsure])]),
    Review = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == widespread_infringement,
    CitationKey == eu_reg_2024_1689_art_3_61,
    Pairs == [widespread_infringement - unsure].
test(the_indeterminate_term_names_one_key) :-
    Status = indeterminate([high_risk_classification]),
    Status = indeterminate([Key]),
    Key == high_risk_classification.
test(the_duty_atoms_are_distinct) :-
    dif(not_applicable_on_date, not_a_high_risk_ai_system),
    dif(not_a_high_risk_ai_system, not_covered_placed_before_application_date),
    dif(not_covered_placed_before_application_date, not_a_serious_incident),
    dif(not_a_serious_incident, not_a_reportable_incident),
    dif(not_applicable_on_date, not_a_reportable_incident).
test(the_timeliness_atoms_are_distinct) :-
    dif(report_in_time, report_after_time_limit),
    dif(report_after_time_limit, report_not_immediate),
    dif(report_in_time, report_not_immediate).
test(the_recipient_atoms_are_distinct) :-
    dif(market_surveillance_authority_of_member_state_where_incident_occurred, national_competent_authority_chosen_by_member_state_where_incident_occurred).
test(the_reporting_duty_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_73_1, _Record).
test(the_reporting_duty_citation_carries_label_ref_verbatim) :-
    citation(eu_reg_2024_1689_art_73_1, [label - _Label, ref - _Reference, verbatim - _Verbatim]).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2024_1689_art_73_2).
test(the_vocabulary_holds_fourteen_keys) :-
    citation_vocabulary(Keys),
    length(Keys, 14),
    member(eu_reg_2024_1689_art_113_c_ii, Keys).
test(every_vocabulary_key_is_recorded) :-
    citation_vocabulary(Keys),
    maplist(implements, Keys).
test(the_widespread_infringement_referral_row) :-
    referral_row(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)).
test(there_are_four_referral_rows) :-
    findall(Key, referral_row(Key, _), Keys),
    length(Keys, 4).
test(there_are_twelve_root_keys) :-
    findall(Key, serious_incident_reporting_root_key(Key, _), Keys),
    length(Keys, 12).
test(the_first_root_key_is_the_classification) :-
    serious_incident_reporting_root_key(high_risk_classification, 0).
test(the_last_root_key_is_report_made_immediately) :-
    serious_incident_reporting_root_key(report_made_immediately, 11).
test(widespread_infringement_is_a_judgement) :-
    serious_incident_reporting_key_type(widespread_infringement, judgement).
test(critical_infrastructure_disruption_is_crisp) :-
    serious_incident_reporting_key_type(critical_infrastructure_disruption, boolean).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, serious_incident_reporting_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(high_risk_classification, annex_iii_high_risk), attribute(widespread_infringement, unsure), attribute(critical_infrastructure_disruption, false)],
    findall(Problems, serious_incident_reporting_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    Profile = [attribute(critical_infrastructure_disruption, unsure)],
    findall(Problems, serious_incident_reporting_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(critical_infrastructure_disruption)]].
test(a_repeated_key_is_a_duplicate_key) :-
    Profile = [attribute(harm_to_health, death_of_a_person), attribute(harm_to_health, banana)],
    findall(Problems, serious_incident_reporting_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(harm_to_health)]].
test(a_key_outside_the_contract_is_unknown) :-
    Profile = [attribute(colour, red), attribute(colour, blue)],
    findall(Problems, serious_incident_reporting_input_problems(Profile, Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(contract_problems_come_before_unknown_keys) :-
    Profile = [attribute(colour, red), attribute(high_risk_classification, maybe)],
    findall(Problems, serious_incident_reporting_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(high_risk_classification), unknown_key(colour)]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, serious_incident_reporting_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, serious_incident_reporting_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_stray_element_is_wrong_type_profile) :-
    findall(Problems, serious_incident_reporting_input_problems([attribute(harm_to_health, death_of_a_person), stray], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_real_day_is_a_calendar_date) :-
    calendar_date_t(date(2027, 12, 2), true).
test(a_leap_day_is_a_calendar_date) :-
    calendar_date_t(date(2028, 2, 29), true).
test(a_non_leap_february_twenty_ninth_is_not_a_calendar_date) :-
    calendar_date_t(date(2027, 2, 29), false).
test(a_month_thirteen_is_not_a_calendar_date) :-
    calendar_date_t(date(2027, 13, 1), false).
test(an_unbound_date_is_not_a_calendar_date) :-
    calendar_date_t(_, false).
test(a_non_date_term_is_not_a_calendar_date) :-
    calendar_date_t('2027-12-02', false).
test(the_date_check_answers_once) :-
    findall(Truth, calendar_date_t(date(2028, 8, 2), Truth), Truths),
    Truths == [true].

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2024_1689_art_73_99).
test(critical_infrastructure_disruption_is_not_a_judgement, fail) :-
    serious_incident_reporting_key_type(critical_infrastructure_disruption, judgement).
test(a_non_leap_february_twenty_ninth_is_not_true, fail) :-
    calendar_date_t(date(2027, 2, 29), true).

cp_test_names([the_report_due_term_carries_its_four_fields, the_verdict_term_carries_status_and_citations, the_needs_legal_review_term_destructures, the_indeterminate_term_names_one_key, the_duty_atoms_are_distinct, the_timeliness_atoms_are_distinct, the_recipient_atoms_are_distinct, the_reporting_duty_citation_is_recorded, the_reporting_duty_citation_carries_label_ref_verbatim, a_recorded_key_is_implemented, the_vocabulary_holds_fourteen_keys, every_vocabulary_key_is_recorded, the_widespread_infringement_referral_row, there_are_four_referral_rows, there_are_twelve_root_keys, the_first_root_key_is_the_classification, the_last_root_key_is_report_made_immediately, widespread_infringement_is_a_judgement, critical_infrastructure_disruption_is_crisp, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, a_repeated_key_is_a_duplicate_key, a_key_outside_the_contract_is_unknown, contract_problems_come_before_unknown_keys, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, a_list_with_a_stray_element_is_wrong_type_profile, a_real_day_is_a_calendar_date, a_leap_day_is_a_calendar_date, a_non_leap_february_twenty_ninth_is_not_a_calendar_date, a_month_thirteen_is_not_a_calendar_date, an_unbound_date_is_not_a_calendar_date, a_non_date_term_is_not_a_calendar_date, the_date_check_answers_once]).
cp_test_fail_names([an_unrecorded_key_is_not_implemented, critical_infrastructure_disruption_is_not_a_judgement, a_non_leap_february_twenty_ninth_is_not_true]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
