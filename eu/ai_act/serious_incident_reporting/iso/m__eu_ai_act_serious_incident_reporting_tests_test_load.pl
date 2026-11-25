% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = serious_incident_reporting_verdict(not_a_serious_incident, [cite(eu_reg_2024_1689_art_3_49)]),
    Verdict = serious_incident_reporting_verdict(Status, Citations),
    Status == not_a_serious_incident,
    Citations == [cite(eu_reg_2024_1689_art_3_49)].
test(the_report_due_term_builds_and_destructures) :-
    Duty = report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 15, date(2028, 1, 16), [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]),
    Duty = report_due(Recipient, Days, LastDay, FollowUp),
    Recipient == market_surveillance_authority_of_member_state_where_incident_occurred,
    Days == 15,
    LastDay == date(2028, 1, 16),
    length(FollowUp, 5).
test(the_follow_up_list_keeps_its_order) :-
    FollowUp = [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system],
    FollowUp = [First|_],
    last(FollowUp, Last),
    First == perform_necessary_investigations_without_delay,
    Last == inform_authorities_before_altering_the_system.
test(the_status_compounds_build_and_destructure) :-
    Missing = indeterminate([high_risk_classification]),
    Missing = indeterminate([MissingKey]),
    MissingKey == high_risk_classification,
    Review = needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([widespread_infringement - unsure])]),
    Review = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == widespread_infringement,
    CitationKey == eu_reg_2024_1689_art_3_61,
    Pairs == [widespread_infringement - unsure],
    Problems = input_problems([wrong_type(awareness_date)]),
    Problems = input_problems([Problem]),
    Problem == wrong_type(awareness_date).
test(the_duty_atoms_are_distinct) :-
    dif(not_applicable_on_date, not_a_high_risk_ai_system),
    dif(not_applicable_on_date, not_covered_placed_before_application_date),
    dif(not_applicable_on_date, not_a_serious_incident),
    dif(not_applicable_on_date, not_a_reportable_incident),
    dif(not_a_high_risk_ai_system, not_covered_placed_before_application_date),
    dif(not_a_high_risk_ai_system, not_a_serious_incident),
    dif(not_a_high_risk_ai_system, not_a_reportable_incident),
    dif(not_covered_placed_before_application_date, not_a_serious_incident),
    dif(not_covered_placed_before_application_date, not_a_reportable_incident),
    dif(not_a_serious_incident, not_a_reportable_incident).
test(the_timeliness_atoms_are_distinct) :-
    dif(report_in_time, report_after_time_limit),
    dif(report_in_time, report_not_immediate),
    dif(report_after_time_limit, report_not_immediate).
test(the_recipient_atoms_are_distinct) :-
    dif(market_surveillance_authority_of_member_state_where_incident_occurred, national_competent_authority_chosen_by_member_state_where_incident_occurred),
    dif(market_surveillance_authority_of_member_state_where_incident_occurred, ai_office),
    dif(national_competent_authority_chosen_by_member_state_where_incident_occurred, ai_office).
test(the_reporting_duty_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_73_1, Record),
    member(ref - Reference, Record),
    Reference == '02024R1689-20260727#parag_073.001'.
test(the_time_limit_citations_are_recorded) :-
    citation(eu_reg_2024_1689_art_73_2, _),
    citation(eu_reg_2024_1689_art_73_3, _),
    citation(eu_reg_2024_1689_art_73_4, _).
test(the_ai_office_citation_is_implemented) :-
    implements(eu_reg_2024_1689_art_75_1a).
test(an_empty_profile_loads_without_problem) :-
    serious_incident_reporting_input_problems([], []).
test(a_well_typed_profile_loads_without_problem) :-
    serious_incident_reporting_input_problems([attribute(high_risk_classification, annex_iii_high_risk), attribute(harm_to_health, death_of_a_person), attribute(report_made_immediately, unsure)], []).
test(a_misspelt_enumeration_value_is_wrong_type) :-
    serious_incident_reporting_input_problems([attribute(high_risk_classification, annex_iii)], [wrong_type(high_risk_classification)]).

test(a_shortened_citation_is_not_recorded, fail) :-
    citation(art_73_1, _).
test(a_misspelt_enumeration_value_is_not_accepted, fail) :-
    serious_incident_reporting_input_problems([attribute(high_risk_classification, annex_iii)], []).

cp_test_names([the_verdict_term_carries_status_and_citations, the_report_due_term_builds_and_destructures, the_follow_up_list_keeps_its_order, the_status_compounds_build_and_destructure, the_duty_atoms_are_distinct, the_timeliness_atoms_are_distinct, the_recipient_atoms_are_distinct, the_reporting_duty_citation_is_recorded, the_time_limit_citations_are_recorded, the_ai_office_citation_is_implemented, an_empty_profile_loads_without_problem, a_well_typed_profile_loads_without_problem, a_misspelt_enumeration_value_is_wrong_type]).
cp_test_fail_names([a_shortened_citation_is_not_recorded, a_misspelt_enumeration_value_is_not_accepted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
