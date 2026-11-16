% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_queries, [serious_incident_reporting_profile_keys/1, serious_incident_reporting_what_if/4, serious_incident_report_duty/4, serious_incident_report_timeliness/5, not_applicable_on_date/0, not_a_high_risk_ai_system/0, not_covered_placed_before_application_date/0, not_a_serious_incident/0, not_a_reportable_incident/0, report_in_time/0, report_after_time_limit/0, report_not_immediate/0, market_surveillance_authority_of_member_state_where_incident_occurred/0, national_competent_authority_chosen_by_member_state_where_incident_occurred/0, perform_necessary_investigations_without_delay/0, risk_assessment_of_the_incident/0, corrective_action/0, cooperate_with_competent_authorities/0, inform_authorities_before_altering_the_system/0, report_due/4, indeterminate/1, needs_legal_review/2, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, high_risk_classification/0, placed_before_chapter_iii_application_date/0, significant_change_in_design_since_that_date/0, intended_to_be_used_by_public_authorities/0, medical_device_or_safety_component_of_one/0, provider_subject_to_equivalent_union_reporting_obligations/0, harm_to_health/0, critical_infrastructure_disruption/0, fundamental_rights_obligations_infringed/0, serious_harm_to_property_or_environment/0, widespread_infringement/0, report_made_immediately/0, annex_iii_high_risk/0, annex_i_high_risk/0, not_high_risk/0, death_of_a_person/0, serious_harm_to_health_without_death/0, no_death_or_serious_harm_to_health/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2, serious_incident_reporting_root_key/2, calendar_date_t/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_citations, [referral_row/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [serious_incident_reporting_duty_ladder/4, serious_incident_reporting_timeliness_ladder/5]).

not_applicable_on_date.

not_a_high_risk_ai_system.

not_covered_placed_before_application_date.

not_a_serious_incident.

not_a_reportable_incident.

report_in_time.

report_after_time_limit.

report_not_immediate.

market_surveillance_authority_of_member_state_where_incident_occurred.

national_competent_authority_chosen_by_member_state_where_incident_occurred.

perform_necessary_investigations_without_delay.

risk_assessment_of_the_incident.

corrective_action.

cooperate_with_competent_authorities.

inform_authorities_before_altering_the_system.

provenance(_Clause, []).
provenance(_Clause, [FirstCitation|_OtherCitations]) :-
    nonvar(FirstCitation).

report_due(Recipient, Days, LastDay, FollowUp) :-
    member(Recipient, [market_surveillance_authority_of_member_state_where_incident_occurred, national_competent_authority_chosen_by_member_state_where_incident_occurred]),
    member(Days, [2, 10, 15]),
    calendar_date_t(LastDay, true),
    FollowUp = [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system].

indeterminate([MissingKey]) :-
    serious_incident_reporting_root_key(MissingKey, _).

needs_legal_review(open_textured(JudgementKey, Citation), [inputs_relied_on(Pairs)|Trailing]) :-
    referral_row(JudgementKey, Citation),
    is_list(Pairs),
    is_list(Trailing).

input_problems([Problem|Problems]) :-
    maplist(problem_term, [Problem|Problems]).

problem_term(unknown_key(ProblemKey)) :-
    unknown_key(ProblemKey).
problem_term(wrong_type(ProblemKey)) :-
    wrong_type(ProblemKey).
problem_term(duplicate_key(ProblemKey)) :-
    duplicate_key(ProblemKey).

unknown_key(ProblemKey) :-
    serious_incident_reporting_input_problems([attribute(ProblemKey, true)], [unknown_key(ProblemKey)]).

wrong_type(ProblemKey) :-
    serious_incident_reporting_root_key(ProblemKey, _).
wrong_type(profile).
wrong_type(awareness_date).
wrong_type(report_date).

duplicate_key(ProblemKey) :-
    serious_incident_reporting_root_key(ProblemKey, _).

high_risk_classification.

placed_before_chapter_iii_application_date.

significant_change_in_design_since_that_date.

intended_to_be_used_by_public_authorities.

medical_device_or_safety_component_of_one.

provider_subject_to_equivalent_union_reporting_obligations.

harm_to_health.

critical_infrastructure_disruption.

fundamental_rights_obligations_infringed.

serious_harm_to_property_or_environment.

widespread_infringement.

report_made_immediately.

annex_iii_high_risk.

annex_i_high_risk.

not_high_risk.

death_of_a_person.

serious_harm_to_health_without_death.

no_death_or_serious_harm_to_health.

unsure.

serious_incident_reporting_profile_keys([high_risk_classification, placed_before_chapter_iii_application_date, significant_change_in_design_since_that_date, intended_to_be_used_by_public_authorities, medical_device_or_safety_component_of_one, provider_subject_to_equivalent_union_reporting_obligations, harm_to_health, critical_infrastructure_disruption, fundamental_rights_obligations_infringed, serious_harm_to_property_or_environment, widespread_infringement, report_made_immediately]).

query_judgement_keys(duty, [significant_change_in_design_since_that_date, provider_subject_to_equivalent_union_reporting_obligations, widespread_infringement]).
query_judgement_keys(timeliness, [significant_change_in_design_since_that_date, provider_subject_to_equivalent_union_reporting_obligations, widespread_infringement, report_made_immediately]).

serious_incident_report_duty(Profile, AwarenessDate, Duty, Citations) :-
    serious_incident_reporting_input_problems(Profile, ProfileProblems),
    calendar_date_t(AwarenessDate, AwarenessIsDate),
    date_problems(AwarenessIsDate, awareness_date, AwarenessProblems),
    append(ProfileProblems, AwarenessProblems, Problems),
    duty_route(Problems, Profile, AwarenessDate, Duty, Citations).

duty_route([], Profile, AwarenessDate, Duty, Citations) :-
    query_judgement_keys(duty, ReadableKeys),
    unsure_rule(ReadableKeys, duty_run(AwarenessDate), Profile, Duty, Citations).
duty_route([Problem|Problems], _, _, input_problems([Problem|Problems]), []).

duty_run(AwarenessDate, Profile, Duty, Citations) :-
    serious_incident_reporting_duty_ladder(Profile, AwarenessDate, Duty, Citations).

serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Verdict, Citations) :-
    serious_incident_reporting_input_problems(Profile, ProfileProblems),
    calendar_date_t(AwarenessDate, AwarenessIsDate),
    date_problems(AwarenessIsDate, awareness_date, AwarenessProblems),
    calendar_date_t(ReportDate, ReportIsDate),
    date_problems(ReportIsDate, report_date, ReportProblems),
    append([ProfileProblems, AwarenessProblems, ReportProblems], Problems),
    timeliness_route(Problems, Profile, AwarenessDate, ReportDate, Verdict, Citations).

timeliness_route([], Profile, AwarenessDate, ReportDate, Verdict, Citations) :-
    query_judgement_keys(timeliness, ReadableKeys),
    unsure_rule(ReadableKeys, timeliness_run(AwarenessDate, ReportDate), Profile, Verdict, Citations).
timeliness_route([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).

timeliness_run(AwarenessDate, ReportDate, Profile, Verdict, Citations) :-
    serious_incident_reporting_timeliness_ladder(Profile, AwarenessDate, ReportDate, Verdict, Citations).

date_problems(true, _, []).
date_problems(false, ArgumentName, [wrong_type(ArgumentName)]).

unsure_rule(ReadableKeys, LadderRun, Profile, Answer, Citations) :-
    unsure_keys(ReadableKeys, Profile, UnsureKeys),
    findall(run(Assignment, RunResult), (settings(UnsureKeys, Assignment), run_assignment(LadderRun, Profile, Assignment, RunResult)), RunList),
    run_results(RunList, ResultList),
    sort(ResultList, DistinctResults),
    results_missing_keys(DistinctResults, MissingKeys),
    present_judgement_pairs(ReadableKeys, Profile, Pairs),
    settle(DistinctResults, MissingKeys, RunList, UnsureKeys, Pairs, Answer, Citations).

settle([Answer - Citations], _, _, _, _, Answer, Citations).
settle([_, _|_], [MissingKey|MissingKeys], _, _, _, indeterminate([EarliestKey]), []) :-
    earliest_key([MissingKey|MissingKeys], EarliestKey).
settle([_, _|_], [], RunList, UnsureKeys, Pairs, needs_legal_review(open_textured(JudgementKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    turning_keys(UnsureKeys, RunList, TurningKeys),
    earliest_key(TurningKeys, JudgementKey),
    referral_row(JudgementKey, Citation).

unsure_keys([], _, []).
unsure_keys([ProfileKey|ProfileKeys], Profile, UnsureKeys) :-
    profile_lacks(Profile, ProfileKey),
    unsure_keys(ProfileKeys, Profile, UnsureKeys).
unsure_keys([ProfileKey|ProfileKeys], Profile, [ProfileKey|UnsureKeys]) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, GivenValue),
    GivenValue == unsure,
    unsure_keys(ProfileKeys, Profile, UnsureKeys).
unsure_keys([ProfileKey|ProfileKeys], Profile, UnsureKeys) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, GivenValue),
    GivenValue \== unsure,
    unsure_keys(ProfileKeys, Profile, UnsureKeys).

present_judgement_pairs([], _, []).
present_judgement_pairs([ProfileKey|ProfileKeys], Profile, Pairs) :-
    profile_lacks(Profile, ProfileKey),
    present_judgement_pairs(ProfileKeys, Profile, Pairs).
present_judgement_pairs([ProfileKey|ProfileKeys], Profile, [ProfileKey - GivenValue|Pairs]) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, GivenValue),
    present_judgement_pairs(ProfileKeys, Profile, Pairs).

settings([], []).
settings([ProfileKey|ProfileKeys], [ProfileKey - Setting|Assignment]) :-
    member(Setting, [true, false]),
    settings(ProfileKeys, Assignment).

run_assignment(LadderRun, Profile, Assignment, Answer - SortedCitations) :-
    foldl(set_attribute_value, Assignment, Profile, SetProfile),
    call(LadderRun, SetProfile, Answer, Citations),
    sort(Citations, SortedCitations).

run_results([], []).
run_results([run(_, RunResult)|RunList], [RunResult|ResultList]) :-
    run_results(RunList, ResultList).

results_missing_keys([], []).
results_missing_keys([Answer - _|DistinctResults], MissingKeys) :-
    answer_missing_keys(Answer, AnswerKeys),
    results_missing_keys(DistinctResults, LaterKeys),
    append(AnswerKeys, LaterKeys, MissingKeys).

answer_missing_keys(indeterminate([MissingKey]), [MissingKey]).
answer_missing_keys(Answer, []) :-
    functor(Answer, AnswerName, _),
    dif(AnswerName, indeterminate).

turning_keys(UnsureKeys, RunList, TurningKeys) :-
    findall(ProfileKey, (member(ProfileKey, UnsureKeys), key_turns(ProfileKey, RunList)), TurningKeys).

key_turns(ProfileKey, RunList) :-
    member(run(FirstAssignment, FirstResult), RunList),
    member(run(SecondAssignment, SecondResult), RunList),
    differing_keys(FirstAssignment, SecondAssignment, [ProfileKey]),
    FirstResult \== SecondResult.

differing_keys([], [], []).
differing_keys([ProfileKey - FirstSetting|FirstRemaining], [ProfileKey - SecondSetting|SecondRemaining], DifferingKeys) :-
    FirstSetting == SecondSetting,
    differing_keys(FirstRemaining, SecondRemaining, DifferingKeys).
differing_keys([ProfileKey - FirstSetting|FirstRemaining], [ProfileKey - SecondSetting|SecondRemaining], [ProfileKey|DifferingKeys]) :-
    FirstSetting \== SecondSetting,
    differing_keys(FirstRemaining, SecondRemaining, DifferingKeys).

earliest_key([ProfileKey|ProfileKeys], EarliestKey) :-
    serious_incident_reporting_root_key(ProfileKey, Position),
    earliest_key_from(ProfileKeys, ProfileKey, Position, EarliestKey).

earliest_key_from([], BestKey, _, BestKey).
earliest_key_from([ProfileKey|ProfileKeys], _, BestPosition, EarliestKey) :-
    serious_incident_reporting_root_key(ProfileKey, Position),
    Position #< BestPosition,
    earliest_key_from(ProfileKeys, ProfileKey, Position, EarliestKey).
earliest_key_from([ProfileKey|ProfileKeys], BestKey, BestPosition, EarliestKey) :-
    serious_incident_reporting_root_key(ProfileKey, Position),
    Position #>= BestPosition,
    earliest_key_from(ProfileKeys, BestKey, BestPosition, EarliestKey).

set_attribute_value(ProfileKey - NewValue, ProfileIn, ProfileOut) :-
    without_attribute(ProfileIn, ProfileKey, Remaining),
    append(Remaining, [attribute(ProfileKey, NewValue)], ProfileOut).

without_attribute([], _, []).
without_attribute([attribute(ElementKey, ElementValue)|Elements], ProfileKey, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== ProfileKey,
    without_attribute(Elements, ProfileKey, Remaining).
without_attribute([attribute(ElementKey, _)|Elements], ProfileKey, Remaining) :-
    ElementKey == ProfileKey,
    without_attribute(Elements, ProfileKey, Remaining).

serious_incident_reporting_what_if(duty_query(Profile, AwarenessDate), OverriddenKey, NewValue, NewStatus) :-
    set_attribute_value(OverriddenKey - NewValue, Profile, Hypothesis),
    serious_incident_report_duty(Hypothesis, AwarenessDate, NewStatus, _).
serious_incident_reporting_what_if(timeliness_query(Profile, AwarenessDate, ReportDate), OverriddenKey, NewValue, NewStatus) :-
    set_attribute_value(OverriddenKey - NewValue, Profile, Hypothesis),
    serious_incident_report_timeliness(Hypothesis, AwarenessDate, ReportDate, NewStatus, _).

test(no_unsure_judgement_gives_the_ladder_answer) :-
    serious_incident_report_duty([attribute(high_risk_classification, not_high_risk)], date(2028, 1, 10), not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_73_1)]).
test(an_unbound_awareness_date_is_wrong_type) :-
    findall(Duty - Citations, serious_incident_report_duty([], _AwarenessDate, Duty, Citations), Answers),
    Answers == [input_problems([wrong_type(awareness_date)]) - []].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    serious_incident_report_duty(not_a_list, date(2028, 1, 10), input_problems([wrong_type(profile)]), []).
test(earliest_key_follows_root_order) :-
    earliest_key([widespread_infringement, harm_to_health, report_made_immediately], harm_to_health).
test(differing_keys_names_the_one_difference) :-
    differing_keys([widespread_infringement - true, report_made_immediately - false], [widespread_infringement - true, report_made_immediately - true], [report_made_immediately]).
test(an_unsure_widespread_infringement_that_turns_the_limit_goes_to_a_lawyer) :-
    serious_incident_report_duty([attribute(high_risk_classification, annex_i_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(harm_to_health, serious_harm_to_health_without_death), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, unsure)], date(2028, 9, 1), needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([widespread_infringement - unsure])]), []).
test(the_duty_answers_exactly_once) :-
    findall(Duty, serious_incident_report_duty([attribute(high_risk_classification, annex_i_high_risk), attribute(widespread_infringement, unsure)], date(2028, 9, 1), Duty, _), Duties),
    length(Duties, 1).
test(an_unsure_judgement_that_does_not_matter_is_settled) :-
    serious_incident_report_duty([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, no_death_or_serious_harm_to_health), attribute(critical_infrastructure_disruption, true), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, unsure)], date(2028, 1, 10), report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 2, date(2028, 1, 12), _), [_|_]).
test(the_timeliness_answers_exactly_once) :-
    findall(Verdict, serious_incident_report_timeliness([attribute(high_risk_classification, not_high_risk)], date(2028, 1, 10), date(2028, 1, 11), Verdict, _), Verdicts),
    Verdicts == [not_a_high_risk_ai_system].
test(the_provenance_marker_answers_once_with_ground_citations) :-
    findall(Citations, provenance(limit_route, Citations), AllCitations),
    AllCitations == [[]].
test(the_provenance_marker_accepts_given_citations) :-
    findall(limit_route, provenance(limit_route, [cite(eu_reg_2024_1689_art_73_3)]), Markers),
    length(Markers, 1).
test(the_report_due_constructor_recognises_a_contract_term) :-
    report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 1, 11), [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).
test(the_indeterminate_constructor_names_a_contract_key) :-
    indeterminate([harm_to_health]).
test(the_input_problems_constructor_recognises_problem_terms) :-
    input_problems([wrong_type(awareness_date), duplicate_key(harm_to_health), unknown_key(colour)]).
test(the_needs_legal_review_constructor_recognises_a_referral) :-
    needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([widespread_infringement - unsure])]).

test(the_report_due_constructor_refuses_another_period, fail) :-
    report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 11, date(2028, 1, 12), [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).
