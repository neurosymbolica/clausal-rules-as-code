% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_queries, [serious_incident_report_duty/4, serious_incident_report_timeliness/5]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_subject/1, serious_incident_reporting_assess/2]).

subject_set(SubjectSet) :-
    findall(Subject, serious_incident_reporting_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

answer_count(Subject, AnswerCount) :-
    findall(Verdict, serious_incident_reporting_assess(Subject, Verdict), Verdicts),
    length(Verdicts, AnswerCount).

at_least_one_answer(Subject) :-
    answer_count(Subject, AnswerCount),
    AnswerCount #>= 1.

exactly_one_answer(Subject) :-
    answer_count(Subject, 1).

citation_vocabulary([eu_reg_2024_1689_art_3_49, eu_reg_2024_1689_art_3_49_c, eu_reg_2024_1689_art_3_61, eu_reg_2024_1689_art_73_1, eu_reg_2024_1689_art_73_2, eu_reg_2024_1689_art_73_3, eu_reg_2024_1689_art_73_4, eu_reg_2024_1689_art_73_6, eu_reg_2024_1689_art_73_9, eu_reg_2024_1689_art_73_10, eu_reg_2024_1689_art_111_2, eu_reg_2024_1689_art_113_c, eu_reg_2024_1689_art_113_c_i, eu_reg_2024_1689_art_113_c_ii]).

follow_up_list([perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).

answer_kind(report_due(_, _, _, _), final).
answer_kind(indeterminate(_), not_final).
answer_kind(needs_legal_review(_, _), not_final).
answer_kind(input_problems(_), not_final).
answer_kind(Status, final) :-
    atom(Status).

known_citation(cite(CitationKey)) :-
    citation_vocabulary(Vocabulary),
    member(CitationKey, Vocabulary).

citations_fit(not_final, []).
citations_fit(final, [FirstCitation|OtherCitations]) :-
    maplist(known_citation, [FirstCitation|OtherCitations]),
    sort([FirstCitation|OtherCitations], CitationSet),
    length([FirstCitation|OtherCitations], CitationCount),
    length(CitationSet, CitationCount).

status_shape_fits(report_due(Recipient, PeriodDays, date(Year, Month, Day), FollowUpDuties)) :-
    member(Recipient, [market_surveillance_authority_of_member_state_where_incident_occurred, national_competent_authority_chosen_by_member_state_where_incident_occurred]),
    member(PeriodDays, [2, 10, 15]),
    integer(Year),
    integer(Month),
    integer(Day),
    follow_up_list(ExpectedDuties),
    FollowUpDuties == ExpectedDuties.
status_shape_fits(indeterminate([MissingKey])) :-
    atom(MissingKey).
status_shape_fits(needs_legal_review(open_textured(JudgementKey, cite(CitationKey)), [inputs_relied_on(Pairs)])) :-
    atom(JudgementKey),
    known_citation(cite(CitationKey)),
    is_list(Pairs).
status_shape_fits(input_problems([_|_])).
status_shape_fits(Status) :-
    atom(Status),
    member(Status, [not_applicable_on_date, not_a_high_risk_ai_system, not_covered_placed_before_application_date, not_a_serious_incident, not_a_reportable_incident, report_in_time, report_after_time_limit, report_not_immediate]).

subject_answer_is_well_formed(Subject) :-
    serious_incident_reporting_assess(Subject, serious_incident_reporting_verdict(Status, Citations)),
    answer_kind(Status, AnswerKind),
    citations_fit(AnswerKind, Citations),
    status_shape_fits(Status).

death_profile([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, death_of_a_person), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).

last_day_is_ten_days_later(AwarenessDate) :-
    death_profile(Profile),
    serious_incident_report_duty(Profile, AwarenessDate, report_due(_, 10, LastDay, _), _),
    days_between(LastDay, AwarenessDate, 10).

one_input_check_answer(Term) :-
    findall(Problems, serious_incident_reporting_input_problems(Term, Problems), AllProblems),
    length(AllProblems, 1).

one_duty_answer(AwarenessDate) :-
    death_profile(Profile),
    findall(Duty, serious_incident_report_duty(Profile, AwarenessDate, Duty, _), Duties),
    length(Duties, 1).

one_timeliness_answer(ReportDate) :-
    death_profile(BaseProfile),
    append(BaseProfile, [attribute(report_made_immediately, true)], Profile),
    findall(Verdict, serious_incident_report_timeliness(Profile, date(2028, 1, 1), ReportDate, Verdict, _), Verdicts),
    length(Verdicts, 1).

test(the_subject_set_is_not_empty) :-
    subject_set([_|_]).
test(totality_every_subject_answers) :-
    subject_set(SubjectSet),
    maplist(at_least_one_answer, SubjectSet).
test(determinism_every_subject_answers_exactly_once) :-
    subject_set(SubjectSet),
    maplist(exactly_one_answer, SubjectSet).
test(every_answer_has_a_contract_shape_and_fitting_citations) :-
    subject_set(SubjectSet),
    maplist(subject_answer_is_well_formed, SubjectSet).
test(the_last_day_is_awareness_plus_the_period) :-
    maplist(last_day_is_ten_days_later, [date(2027, 12, 2), date(2028, 2, 19), date(2028, 2, 29), date(2028, 12, 25), date(2029, 2, 20)]).
test(the_duty_answers_once_on_and_around_every_boundary) :-
    maplist(one_duty_answer, [date(2027, 12, 1), date(2027, 12, 2), date(2028, 8, 1), date(2028, 8, 2), date(2030, 8, 1), date(2030, 8, 2), date(2027, 2, 29), not_a_date]).
test(the_timeliness_answers_once_around_the_last_day) :-
    maplist(one_timeliness_answer, [date(2027, 12, 31), date(2028, 1, 10), date(2028, 1, 11), date(2028, 1, 12), date(2028, 2, 30)]).
test(the_input_check_answers_once_for_every_term) :-
    maplist(one_input_check_answer, [_Unbound, not_a_list, 42, [], [foo], [_Element], [attribute(high_risk_classification, annex_iii_high_risk)|_Tail], [attribute(harm_to_health, _Value)], [attribute(colour, red), attribute(colour, blue)], [attribute(harm_to_health, death_of_a_person), attribute(harm_to_health, death_of_a_person)]]).

cp_test_names([the_subject_set_is_not_empty, totality_every_subject_answers, determinism_every_subject_answers_exactly_once, every_answer_has_a_contract_shape_and_fitting_citations, the_last_day_is_awareness_plus_the_period, the_duty_answers_once_on_and_around_every_boundary, the_timeliness_answers_once_around_the_last_day, the_input_check_answers_once_for_every_term]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
