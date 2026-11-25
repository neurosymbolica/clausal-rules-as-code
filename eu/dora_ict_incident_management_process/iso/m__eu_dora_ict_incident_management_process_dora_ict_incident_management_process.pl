% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_dora_ict_incident_management_process, [ict_incident_management_process_duties_required/3, ict_incident_management_process_duties_complete/3, ict_incident_management_process_duties_outstanding/3, decide_dora_ict_incident_management_process/2, dora_ict_incident_management_process_status/2, dora_ict_incident_management_process_checklist/2, dora_ict_incident_management_process_decision_resolvable/1, dora_ict_incident_management_process_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_dora_ict_incident_management_process_kernel, [dora_ict_incident_management_process_input_problems/2]).
:- use_module(m__eu_dora_ict_incident_management_process_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

dora_ict_incident_management_process_status_values([complete, incomplete, indeterminate, needs_legal_review, input_problems]).

duty(incident_management_process, ict_related_incident_management_process_defined_established_and_implemented, 17, cite(eu_reg_2022_2554_art_17_1)).
duty(recording_of_incidents_and_significant_cyber_threats, all_ict_related_incidents_and_significant_cyber_threats_recorded, 17, cite(eu_reg_2022_2554_art_17_2)).
duty(monitoring_handling_and_follow_up_procedures, procedures_for_monitoring_handling_follow_up_and_root_causes_established, 17, cite(eu_reg_2022_2554_art_17_2)).
duty(early_warning_indicators, early_warning_indicators_put_in_place, 17, cite(eu_reg_2022_2554_art_17_3_a)).
duty(identification_and_classification_procedures, procedures_to_identify_track_log_categorise_and_classify_incidents_established, 17, cite(eu_reg_2022_2554_art_17_3_b)).
duty(incident_roles_and_responsibilities, roles_and_responsibilities_for_incident_types_and_scenarios_assigned, 17, cite(eu_reg_2022_2554_art_17_3_c)).
duty(communication_and_escalation_plans, communication_notification_escalation_and_counterpart_information_plans_set_out, 17, cite(eu_reg_2022_2554_art_17_3_d)).
duty(reporting_to_senior_management_and_management_body, major_incidents_reported_to_senior_management_and_management_body_informed, 17, cite(eu_reg_2022_2554_art_17_3_e)).
duty(incident_response_procedures, incident_response_procedures_established, 17, cite(eu_reg_2022_2554_art_17_3_f)).
duty(classification_of_significant_cyber_threats, cyber_threats_classified_as_significant_on_the_article_18_2_criteria, 18, cite(eu_reg_2022_2554_art_18_2)).

duty_order([incident_management_process, recording_of_incidents_and_significant_cyber_threats, monitoring_handling_and_follow_up_procedures, early_warning_indicators, identification_and_classification_procedures, incident_roles_and_responsibilities, communication_and_escalation_plans, reporting_to_senior_management_and_management_body, incident_response_procedures, classification_of_significant_cyber_threats]).

fixed_citations([cite(eu_reg_2022_2554_art_17_1), cite(eu_reg_2022_2554_art_17_2), cite(eu_reg_2022_2554_art_17_3), cite(eu_reg_2022_2554_art_18_2)]).

exemption(articles_five_to_fifteen_exemption, 5, 15, cite(eu_reg_2022_2554_art_16_1)).

duty_applicability(DutyName, applies) :-
    implements(eu_reg_2022_2554_art_16_1),
    implements(eu_reg_2022_2554_art_4_2),
    duty(DutyName, _, ArticleNumber, _),
    exemption(_, FirstArticle, _, _),
    ArticleNumber #< FirstArticle.
duty_applicability(DutyName, applies) :-
    implements(eu_reg_2022_2554_art_16_1),
    implements(eu_reg_2022_2554_art_4_2),
    duty(DutyName, _, ArticleNumber, _),
    exemption(_, _, LastArticle, _),
    ArticleNumber #> LastArticle.
duty_applicability(DutyName, exempt) :-
    implements(eu_reg_2022_2554_art_16_1),
    implements(eu_reg_2022_2554_art_4_2),
    duty(DutyName, _, ArticleNumber, _),
    exemption(_, FirstArticle, LastArticle, _),
    ArticleNumber #>= FirstArticle,
    ArticleNumber #=< LastArticle.

applying_duties([], []).
applying_duties([DutyName|Duties], Applying) :-
    duty_applicability(DutyName, Applicability),
    keep_applying(Applicability, DutyName, Applying, RemainingApplying),
    applying_duties(Duties, RemainingApplying).

keep_applying(applies, DutyName, [DutyName|RemainingApplying], RemainingApplying).
keep_applying(exempt, _, RemainingApplying, RemainingApplying).

key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_state(Profile, ProfileKey, JudgementValue) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, JudgementValue).

duty_rows(Profile, Rows) :-
    duty_order(Duties),
    applying_duties(Duties, Applying),
    rows_for(Applying, Profile, Rows).

rows_for([], _, []).
rows_for([DutyName|Duties], Profile, [row(DutyName, ProfileKey, Citation, State)|RemainingRows]) :-
    implements(eu_reg_2022_2554_art_18_1),
    duty(DutyName, ProfileKey, _, Citation),
    key_state(Profile, ProfileKey, State),
    rows_for(Duties, Profile, RemainingRows).

first_with_state([], _, none).
first_with_state([row(DutyName, ProfileKey, Citation, RowState)|_], State, found(row(DutyName, ProfileKey, Citation, RowState))) :-
    RowState == State.
first_with_state([row(_, _, _, RowState)|RemainingRows], State, Found) :-
    RowState \== State,
    first_with_state(RemainingRows, State, Found).

present_pairs([], []).
present_pairs([row(_, _, _, absent)|RemainingRows], Pairs) :-
    present_pairs(RemainingRows, Pairs).
present_pairs([row(_, ProfileKey, _, State)|RemainingRows], [ProfileKey - State|Pairs]) :-
    State \== absent,
    present_pairs(RemainingRows, Pairs).

failing_duties([], [], []).
failing_duties([row(DutyName, _, Citation, false)|RemainingRows], [DutyName|Duties], [Citation|Citations]) :-
    implements(eu_reg_2022_2554_art_17_1),
    failing_duties(RemainingRows, Duties, Citations).
failing_duties([row(_, _, _, State)|RemainingRows], Duties, Citations) :-
    implements(eu_reg_2022_2554_art_17_1),
    State \== false,
    failing_duties(RemainingRows, Duties, Citations).

ict_incident_management_process_duties_required(Profile, input_problems([Problem|Problems]), []) :-
    dora_ict_incident_management_process_input_problems(Profile, [Problem|Problems]).
ict_incident_management_process_duties_required(Profile, required(Applying), Citations) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_order(Duties),
    applying_duties(Duties, Applying),
    fixed_citations(Citations).

ict_incident_management_process_duties_complete(Profile, input_problems([Problem|Problems]), []) :-
    dora_ict_incident_management_process_input_problems(Profile, [Problem|Problems]).
ict_incident_management_process_duties_complete(Profile, incomplete, Citations) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_rows(Profile, Rows),
    first_with_state(Rows, false, found(_)),
    fixed_citations(Citations).
ict_incident_management_process_duties_complete(Profile, indeterminate([ProfileKey]), []) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_rows(Profile, Rows),
    first_with_state(Rows, false, none),
    first_with_state(Rows, absent, found(row(_, ProfileKey, _, _))).
ict_incident_management_process_duties_complete(Profile, needs_legal_review(open_textured(ProfileKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_rows(Profile, Rows),
    first_with_state(Rows, false, none),
    first_with_state(Rows, absent, none),
    first_with_state(Rows, unsure, found(row(_, ProfileKey, Citation, _))),
    present_pairs(Rows, Pairs).
ict_incident_management_process_duties_complete(Profile, complete, Citations) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_rows(Profile, Rows),
    first_with_state(Rows, false, none),
    first_with_state(Rows, absent, none),
    first_with_state(Rows, unsure, none),
    fixed_citations(Citations).

ict_incident_management_process_duties_outstanding(Profile, input_problems([Problem|Problems]), []) :-
    dora_ict_incident_management_process_input_problems(Profile, [Problem|Problems]).
ict_incident_management_process_duties_outstanding(Profile, indeterminate([ProfileKey]), []) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_rows(Profile, Rows),
    first_with_state(Rows, absent, found(row(_, ProfileKey, _, _))).
ict_incident_management_process_duties_outstanding(Profile, needs_legal_review(open_textured(ProfileKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_rows(Profile, Rows),
    first_with_state(Rows, absent, none),
    first_with_state(Rows, unsure, found(row(_, ProfileKey, Citation, _))),
    present_pairs(Rows, Pairs).
ict_incident_management_process_duties_outstanding(Profile, none_outstanding, Citations) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_rows(Profile, Rows),
    first_with_state(Rows, absent, none),
    first_with_state(Rows, unsure, none),
    failing_duties(Rows, [], _),
    fixed_citations(Citations).
ict_incident_management_process_duties_outstanding(Profile, outstanding([DutyName|Duties]), Citations) :-
    implements(eu_reg_2022_2554_art_17_1),
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_rows(Profile, Rows),
    first_with_state(Rows, absent, none),
    first_with_state(Rows, unsure, none),
    failing_duties(Rows, [DutyName|Duties], DutyCitations),
    sort(DutyCitations, Citations).

decide_dora_ict_incident_management_process(Profile, dora_ict_incident_management_process_verdict(Status, Citations)) :-
    ict_incident_management_process_duties_complete(Profile, Result, Citations),
    functor(Result, Status, _).

dora_ict_incident_management_process_status(Profile, Status) :-
    decide_dora_ict_incident_management_process(Profile, dora_ict_incident_management_process_verdict(Status, _Citations)).

dora_ict_incident_management_process_checklist(Profile, [item(input_check, input_problems([Problem|Problems]), [])]) :-
    dora_ict_incident_management_process_input_problems(Profile, [Problem|Problems]).
dora_ict_incident_management_process_checklist(Profile, Items) :-
    dora_ict_incident_management_process_input_problems(Profile, []),
    duty_rows(Profile, Rows),
    maplist(row_item, Rows, Items).

row_item(row(DutyName, _, Citation, true), item(DutyName, met, Citation)).
row_item(row(DutyName, _, Citation, false), item(DutyName, unmet(not_performed), Citation)).
row_item(row(DutyName, ProfileKey, Citation, absent), item(DutyName, unknown([ProfileKey]), Citation)).
row_item(row(DutyName, ProfileKey, Citation, unsure), item(DutyName, needs_legal_review(open_textured(ProfileKey, Citation)), Citation)).

dora_ict_incident_management_process_decision_resolvable(Profile) :-
    decide_dora_ict_incident_management_process(Profile, _Verdict).

profile_from_values(Values, Profile) :-
    duty_order(Duties),
    maplist(duty_key, Duties, ProfileKeys),
    pair_values(ProfileKeys, Values, Profile).

duty_key(DutyName, ProfileKey) :-
    duty(DutyName, ProfileKey, _, _).

pair_values([], [], []).
pair_values([_ProfileKey|ProfileKeys], [absent|Values], Profile) :-
    pair_values(ProfileKeys, Values, Profile).
pair_values([ProfileKey|ProfileKeys], [JudgementValue|Values], [attribute(ProfileKey, JudgementValue)|Profile]) :-
    dif(JudgementValue, absent),
    pair_values(ProfileKeys, Values, Profile).

test(every_duty_applies) :-
    duty_order(Duties),
    applying_duties(Duties, Applying),
    Applying == Duties.
test(required_lists_all_ten_duties_once) :-
    findall(Result - Citations, ict_incident_management_process_duties_required([], Result, Citations), Answers),
    duty_order(Duties),
    fixed_citations(Fixed),
    Answers == [required(Duties) - Fixed].
test(required_refuses_a_badly_typed_profile) :-
    ict_incident_management_process_duties_required([attribute(early_warning_indicators_put_in_place, yes)], input_problems([wrong_type(early_warning_indicators_put_in_place)]), []).
test(required_refuses_a_non_list_profile) :-
    ict_incident_management_process_duties_required(not_a_list, input_problems([wrong_type(profile)]), []).
test(all_true_is_complete) :-
    profile_from_values([true, true, true, true, true, true, true, true, true, true], Profile),
    findall(Result - Citations, ict_incident_management_process_duties_complete(Profile, Result, Citations), Answers),
    fixed_citations(Fixed),
    Answers == [complete - Fixed].
test(a_false_duty_decides_before_absent_keys) :-
    profile_from_values([absent, absent, absent, absent, absent, false, absent, absent, absent, absent], Profile),
    findall(Result, ict_incident_management_process_duties_complete(Profile, Result, _), Results),
    Results == [incomplete].
test(a_false_duty_decides_before_an_unsure_key) :-
    profile_from_values([unsure, true, true, true, true, true, true, true, true, false], Profile),
    ict_incident_management_process_duties_complete(Profile, incomplete, Citations),
    fixed_citations(Citations).
test(complete_names_the_first_absent_key) :-
    profile_from_values([true, true, absent, true, absent, true, true, true, true, true], Profile),
    findall(Result - Citations, ict_incident_management_process_duties_complete(Profile, Result, Citations), Answers),
    Answers == [indeterminate([procedures_for_monitoring_handling_follow_up_and_root_causes_established]) - []].
test(an_absent_key_is_named_before_an_unsure_key) :-
    profile_from_values([unsure, true, true, true, absent, true, true, true, true, true], Profile),
    ict_incident_management_process_duties_complete(Profile, indeterminate([procedures_to_identify_track_log_categorise_and_classify_incidents_established]), []).
test(complete_refers_the_first_unsure_key) :-
    profile_from_values([true, true, true, unsure, true, true, unsure, true, true, true], Profile),
    findall(Result, ict_incident_management_process_duties_complete(Profile, Result, _), Results),
    Results = [needs_legal_review(open_textured(early_warning_indicators_put_in_place, cite(eu_reg_2022_2554_art_17_3_a)), [inputs_relied_on(Pairs)])],
    length(Pairs, 10),
    Pairs = [ict_related_incident_management_process_defined_established_and_implemented - true|_].
test(outstanding_lists_failing_duties_with_their_citations_once) :-
    profile_from_values([true, false, false, true, true, true, true, true, true, false], Profile),
    findall(Result - Citations, ict_incident_management_process_duties_outstanding(Profile, Result, Citations), Answers),
    Answers = [outstanding(Duties) - Citations],
    Duties == [recording_of_incidents_and_significant_cyber_threats, monitoring_handling_and_follow_up_procedures, classification_of_significant_cyber_threats],
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_17_2), cite(eu_reg_2022_2554_art_18_2)].
test(outstanding_waits_for_an_absent_key_even_with_a_false_key) :-
    profile_from_values([false, true, true, true, true, true, true, true, true, absent], Profile),
    findall(Result, ict_incident_management_process_duties_outstanding(Profile, Result, _), Results),
    Results == [indeterminate([cyber_threats_classified_as_significant_on_the_article_18_2_criteria])].
test(outstanding_refers_an_unsure_key) :-
    profile_from_values([true, true, true, true, true, true, true, true, unsure, false], Profile),
    ict_incident_management_process_duties_outstanding(Profile, needs_legal_review(open_textured(incident_response_procedures_established, cite(eu_reg_2022_2554_art_17_3_f)), [inputs_relied_on(_)]), []).
test(all_true_has_none_outstanding) :-
    profile_from_values([true, true, true, true, true, true, true, true, true, true], Profile),
    findall(Result - Citations, ict_incident_management_process_duties_outstanding(Profile, Result, Citations), Answers),
    fixed_citations(Fixed),
    Answers == [none_outstanding - Fixed].
test(outstanding_refuses_an_unknown_key) :-
    ict_incident_management_process_duties_outstanding([attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(the_facade_status_is_the_complete_functor) :-
    profile_from_values([true, absent, true, true, true, true, true, true, true, true], Profile),
    dora_ict_incident_management_process_status(Profile, indeterminate).
test(the_checklist_cites_every_item) :-
    profile_from_values([true, false, absent, unsure, true, true, true, true, true, true], Profile),
    dora_ict_incident_management_process_checklist(Profile, Items),
    length(Items, 10),
    Items = [item(incident_management_process, met, cite(eu_reg_2022_2554_art_17_1)), item(recording_of_incidents_and_significant_cyber_threats, unmet(not_performed), cite(eu_reg_2022_2554_art_17_2))|_].

test(no_duty_is_exempt, fail) :-
    duty_applicability(_, exempt).
test(all_true_is_not_incomplete, fail) :-
    profile_from_values([true, true, true, true, true, true, true, true, true, true], Profile),
    ict_incident_management_process_duties_complete(Profile, incomplete, _).
test(outstanding_with_an_absent_key_is_not_outstanding, fail) :-
    profile_from_values([false, true, true, true, true, true, true, true, true, absent], Profile),
    ict_incident_management_process_duties_outstanding(Profile, outstanding(_), _).
