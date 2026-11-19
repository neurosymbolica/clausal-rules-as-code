% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5, decide_swiss_fadp_art24_breach_notification/2, swiss_fadp_art24_breach_notification_status/2, swiss_fadp_art24_breach_notification_checklist/2, swiss_fadp_art24_breach_notification_decision_resolvable/1, swiss_fadp_art24_breach_notification_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_citations, [implements/1]).

swiss_fadp_art24_breach_notification_status_values([authority_notification_required, authority_notification_not_required]).

answer_citations(controller_report, authority_notification_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]).
answer_citations(controller_report, authority_notification_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]).
answer_citations(processor_report, report_to_controller_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]).
answer_citations(processor_report, report_to_controller_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]).
answer_citations(data_subject_information, information_of_data_subject_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]).
answer_citations(data_subject_information, information_of_data_subject_may_be_restricted_deferred_or_omitted, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]).
answer_citations(data_subject_information, information_of_data_subject_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]).
answer_citations(eu_notification, authority_notification_not_required, [cite(eu_reg_2016_679_art_33_1)]).
answer_citations(eu_notification, authority_notification_required, [cite(eu_reg_2016_679_art_33_1)]).

referral_citation(controller_report, breach_of_data_security, cite(ch_fadp_art_5_h)).
referral_citation(controller_report, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, cite(ch_fadp_art_24_1)).
referral_citation(processor_report, breach_of_data_security, cite(ch_fadp_art_5_h)).
referral_citation(data_subject_information, breach_of_data_security, cite(ch_fadp_art_5_h)).
referral_citation(data_subject_information, information_necessary_for_protection_of_data_subject, cite(ch_fadp_art_24_4)).
referral_citation(data_subject_information, article_26_ground_or_statutory_secrecy_obligation_applies, cite(ch_fadp_art_24_5_a)).
referral_citation(data_subject_information, information_impossible_or_requires_disproportionate_effort, cite(ch_fadp_art_24_5_b)).
referral_citation(data_subject_information, information_ensured_comparably_by_public_announcement, cite(ch_fadp_art_24_5_c)).
referral_citation(eu_notification, personal_data_breach, cite(eu_reg_2016_679_art_33_1)).
referral_citation(eu_notification, breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)).

query_inputs(controller_report, [breach_of_data_security, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]).
query_inputs(processor_report, [breach_of_data_security]).
query_inputs(data_subject_information, [breach_of_data_security, information_necessary_for_protection_of_data_subject, commissioner_requested_information_of_data_subject, article_26_ground_or_statutory_secrecy_obligation_applies, information_impossible_or_requires_disproportionate_effort, information_ensured_comparably_by_public_announcement]).
query_inputs(eu_notification, [personal_data_breach, breach_unlikely_to_result_in_risk]).

checklist_row(controller_report_to_commissioner, controller_report, cite(ch_fadp_art_24_1)).
checklist_row(processor_report_to_controller, processor_report, cite(ch_fadp_art_24_3)).
checklist_row(information_of_data_subject, data_subject_information, cite(ch_fadp_art_24_4)).
checklist_row(eu_notification_to_supervisory_authority, eu_notification, cite(eu_reg_2016_679_art_33_1)).

key_state(Profile, InputKey, absent) :-
    profile_lacks(Profile, InputKey).
key_state(Profile, InputKey, State) :-
    profile_get(Profile, InputKey, State).

relied_pairs(_, [], []).
relied_pairs(Profile, [InputKey|InputKeys], Pairs) :-
    key_state(Profile, InputKey, State),
    relied_pairs(Profile, InputKeys, LaterPairs),
    relied_pair(State, InputKey, LaterPairs, Pairs).

relied_pair(absent, _, Pairs, Pairs).
relied_pair(State, InputKey, LaterPairs, [InputKey - State|LaterPairs]) :-
    dif(State, absent).

route_answer(Query, final(Answer), _, Answer, Citations) :-
    answer_citations(Query, Answer, Citations).
route_answer(_, missing(InputKey), _, indeterminate([InputKey]), []).
route_answer(Query, review(InputKey), Profile, needs_legal_review(open_textured(InputKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    referral_citation(Query, InputKey, Citation),
    query_inputs(Query, InputKeys),
    relied_pairs(Profile, InputKeys, Pairs).

first_absent([], none).
first_absent([InputKey - absent|_], found(InputKey)).
first_absent([_ - State|KeyStates], Found) :-
    dif(State, absent),
    first_absent(KeyStates, Found).

first_unsure([InputKey - unsure|_], InputKey).
first_unsure([_ - State|KeyStates], InputKey) :-
    dif(State, unsure),
    first_unsure(KeyStates, InputKey).

pending_route(KeyStates, Route) :-
    first_absent(KeyStates, Found),
    pending_from(Found, KeyStates, Route).

pending_from(found(InputKey), _, missing(InputKey)).
pending_from(none, KeyStates, review(InputKey)) :-
    first_unsure(KeyStates, InputKey).

swiss_controller_report_to_commissioner(Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    controller_answer(Problems, Profile, Result, Citations).

controller_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
controller_answer([], Profile, Result, Citations) :-
    key_state(Profile, breach_of_data_security, BreachState),
    key_state(Profile, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, RiskState),
    controller_route(BreachState, RiskState, Route),
    route_answer(controller_report, Route, Profile, Result, Citations).

controller_route(false, _, final(authority_notification_not_required)) :-
    implements(ch_fadp_art_5_h).
controller_route(BreachState, false, final(authority_notification_not_required)) :-
    implements(ch_fadp_art_24_1),
    member(BreachState, [true, absent, unsure]).
controller_route(true, true, final(authority_notification_required)) :-
    implements(ch_fadp_art_24_1).
controller_route(absent, RiskState, missing(breach_of_data_security)) :-
    implements(ch_fadp_art_5_h),
    member(RiskState, [true, absent, unsure]).
controller_route(BreachState, absent, missing(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights)) :-
    implements(ch_fadp_art_24_1),
    member(BreachState, [true, unsure]).
controller_route(unsure, RiskState, review(breach_of_data_security)) :-
    implements(ch_fadp_art_5_h),
    member(RiskState, [true, unsure]).
controller_route(true, unsure, review(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights)) :-
    implements(ch_fadp_art_24_1).

swiss_processor_report_to_controller(Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    processor_answer(Problems, Profile, Result, Citations).

processor_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
processor_answer([], Profile, Result, Citations) :-
    key_state(Profile, breach_of_data_security, BreachState),
    processor_route(BreachState, Route),
    route_answer(processor_report, Route, Profile, Result, Citations).

processor_route(false, final(report_to_controller_not_required)) :-
    implements(ch_fadp_art_24_3).
processor_route(true, final(report_to_controller_required)) :-
    implements(ch_fadp_art_24_3).
processor_route(absent, missing(breach_of_data_security)) :-
    implements(ch_fadp_art_5_h).
processor_route(unsure, review(breach_of_data_security)) :-
    implements(ch_fadp_art_5_h).

swiss_information_of_data_subject(Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    information_answer(Problems, Profile, Result, Citations).

information_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
information_answer([], Profile, Result, Citations) :-
    key_state(Profile, breach_of_data_security, BreachState),
    key_state(Profile, information_necessary_for_protection_of_data_subject, NecessaryState),
    key_state(Profile, commissioner_requested_information_of_data_subject, RequestState),
    key_state(Profile, article_26_ground_or_statutory_secrecy_obligation_applies, SecrecyState),
    key_state(Profile, information_impossible_or_requires_disproportionate_effort, EffortState),
    key_state(Profile, information_ensured_comparably_by_public_announcement, AnnouncementState),
    information_ground(NecessaryState, RequestState, Ground),
    information_exception([SecrecyState, EffortState, AnnouncementState], Exception),
    information_route(BreachState, Ground, Exception, [breach_of_data_security - BreachState], [information_necessary_for_protection_of_data_subject - NecessaryState, commissioner_requested_information_of_data_subject - RequestState], [article_26_ground_or_statutory_secrecy_obligation_applies - SecrecyState, information_impossible_or_requires_disproportionate_effort - EffortState, information_ensured_comparably_by_public_announcement - AnnouncementState], Route),
    route_answer(data_subject_information, Route, Profile, Result, Citations).

information_ground(true, _, met) :-
    implements(ch_fadp_art_24_4).
information_ground(NecessaryState, true, met) :-
    implements(ch_fadp_art_24_4),
    member(NecessaryState, [false, absent, unsure]).
information_ground(false, false, failed) :-
    implements(ch_fadp_art_24_4).
information_ground(NecessaryState, RequestState, open) :-
    implements(ch_fadp_art_24_4),
    member(NecessaryState, [absent, unsure]),
    member(RequestState, [false, absent]).
information_ground(false, absent, open) :-
    implements(ch_fadp_art_24_4).

information_exception(ExceptionStates, Exception) :-
    implements(ch_fadp_art_24_5),
    memberd_t(true, ExceptionStates, HasTrue),
    exception_from_truth(HasTrue, ExceptionStates, Exception).

exception_from_truth(true, _, held).
exception_from_truth(false, ExceptionStates, Exception) :-
    memberd_t(absent, ExceptionStates, HasAbsent),
    memberd_t(unsure, ExceptionStates, HasUnsure),
    unsettled_exception(HasAbsent, HasUnsure, Exception).

unsettled_exception(false, false, all_failed).
unsettled_exception(true, _, open).
unsettled_exception(false, true, open).

information_route(false, _, _, _, _, _, final(information_of_data_subject_not_required)) :-
    implements(ch_fadp_art_5_h).
information_route(BreachState, failed, _, _, _, _, final(information_of_data_subject_not_required)) :-
    implements(ch_fadp_art_24_4),
    member(BreachState, [true, absent, unsure]).
information_route(true, met, held, _, _, _, final(information_of_data_subject_may_be_restricted_deferred_or_omitted)) :-
    implements(ch_fadp_art_24_5).
information_route(true, met, all_failed, _, _, _, final(information_of_data_subject_required)) :-
    implements(ch_fadp_art_24_4).
information_route(BreachState, Ground, Exception, BreachPairs, GroundPairs, ExceptionPairs, Route) :-
    implements(ch_fadp_art_24_4),
    member(BreachState, [absent, unsure]),
    member(Ground, [met, open]),
    information_pending(Ground, Exception, BreachPairs, GroundPairs, ExceptionPairs, Route).
information_route(true, open, Exception, BreachPairs, GroundPairs, ExceptionPairs, Route) :-
    implements(ch_fadp_art_24_4),
    information_pending(open, Exception, BreachPairs, GroundPairs, ExceptionPairs, Route).
information_route(true, met, open, BreachPairs, GroundPairs, ExceptionPairs, Route) :-
    implements(ch_fadp_art_24_5),
    information_pending(met, open, BreachPairs, GroundPairs, ExceptionPairs, Route).

information_pending(Ground, Exception, BreachPairs, GroundPairs, ExceptionPairs, Route) :-
    ground_part(Ground, GroundPairs, NeededGroundPairs),
    exception_part(Exception, ExceptionPairs, NeededExceptionPairs),
    append([BreachPairs, NeededGroundPairs, NeededExceptionPairs], KeyStates),
    pending_route(KeyStates, Route).

ground_part(met, _, []).
ground_part(open, GroundPairs, GroundPairs).

exception_part(held, _, []).
exception_part(open, ExceptionPairs, ExceptionPairs).
exception_part(all_failed, ExceptionPairs, ExceptionPairs).

eu_controller_notification_to_supervisory_authority(Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    eu_answer(Problems, Profile, Result, Citations).

eu_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
eu_answer([], Profile, Result, Citations) :-
    key_state(Profile, personal_data_breach, BreachState),
    key_state(Profile, breach_unlikely_to_result_in_risk, UnlikelyState),
    eu_route(BreachState, UnlikelyState, Route),
    route_answer(eu_notification, Route, Profile, Result, Citations).

eu_route(false, _, final(authority_notification_not_required)) :-
    implements(eu_reg_2016_679_art_33_1).
eu_route(BreachState, true, final(authority_notification_not_required)) :-
    implements(eu_reg_2016_679_art_33_1),
    member(BreachState, [true, absent, unsure]).
eu_route(true, false, final(authority_notification_required)) :-
    implements(eu_reg_2016_679_art_33_1).
eu_route(absent, UnlikelyState, missing(personal_data_breach)) :-
    implements(eu_reg_2016_679_art_33_1),
    member(UnlikelyState, [false, absent, unsure]).
eu_route(BreachState, absent, missing(breach_unlikely_to_result_in_risk)) :-
    implements(eu_reg_2016_679_art_33_1),
    member(BreachState, [true, unsure]).
eu_route(unsure, UnlikelyState, review(personal_data_breach)) :-
    implements(eu_reg_2016_679_art_33_1),
    member(UnlikelyState, [false, unsure]).
eu_route(true, unsure, review(breach_unlikely_to_result_in_risk)) :-
    implements(eu_reg_2016_679_art_33_1).

compare_swiss_eu_authority_notification(Profile, SwissResult, EuResult, Difference, ChangedBy) :-
    swiss_controller_report_to_commissioner(Profile, SwissResult, _SwissCitations),
    eu_controller_notification_to_supervisory_authority(Profile, EuResult, _EuCitations),
    comparison_difference(SwissResult, EuResult, Difference, ChangedBy).

comparison_difference(SwissResult, _, not_comparable, []) :-
    compound(SwissResult).
comparison_difference(SwissResult, EuResult, not_comparable, []) :-
    atom(SwissResult),
    compound(EuResult).
comparison_difference(SwissResult, EuResult, same, []) :-
    implements(ch_fadp_art_24_1),
    atom(SwissResult),
    atom(EuResult),
    SwissResult == EuResult.
comparison_difference(SwissResult, EuResult, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1),
    atom(SwissResult),
    atom(EuResult),
    SwissResult \== EuResult.

decide_swiss_fadp_art24_breach_notification(Profile, swiss_fadp_art24_breach_notification_verdict(Status, Citations)) :-
    swiss_controller_report_to_commissioner(Profile, Status, Citations).

swiss_fadp_art24_breach_notification_status(Profile, Status) :-
    decide_swiss_fadp_art24_breach_notification(Profile, swiss_fadp_art24_breach_notification_verdict(Status, _Citations)).

swiss_fadp_art24_breach_notification_checklist(Profile, Items) :-
    findall(RowId, checklist_row(RowId, _, _), RowIds),
    checklist_items(RowIds, Profile, Items).

checklist_items([], _, []).
checklist_items([RowId|RowIds], Profile, [item(RowId, Result, Citation)|Items]) :-
    checklist_row(RowId, Query, Citation),
    query_result(Query, Profile, Result),
    checklist_items(RowIds, Profile, Items).

query_result(controller_report, Profile, Result) :-
    swiss_controller_report_to_commissioner(Profile, Result, _Citations).
query_result(processor_report, Profile, Result) :-
    swiss_processor_report_to_controller(Profile, Result, _Citations).
query_result(data_subject_information, Profile, Result) :-
    swiss_information_of_data_subject(Profile, Result, _Citations).
query_result(eu_notification, Profile, Result) :-
    eu_controller_notification_to_supervisory_authority(Profile, Result, _Citations).

swiss_fadp_art24_breach_notification_decision_resolvable(Profile) :-
    decide_swiss_fadp_art24_breach_notification(Profile, _Verdict).

test(controller_must_report_a_likely_high_risk_breach) :-
    findall(Result - Citations, swiss_controller_report_to_commissioner([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true)], Result, Citations), Answers),
    Answers == [authority_notification_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]].
test(controller_need_not_report_without_high_risk) :-
    findall(Result, swiss_controller_report_to_commissioner([attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false)], Result, _), Answers),
    Answers == [authority_notification_not_required].
test(controller_names_missing_key_before_unsure) :-
    findall(Result, swiss_controller_report_to_commissioner([attribute(breach_of_data_security, unsure)], Result, _), Answers),
    Answers == [indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])].
test(controller_refers_first_unsure_key) :-
    findall(Result - Citations, swiss_controller_report_to_commissioner([attribute(breach_of_data_security, unsure), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, unsure)], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - unsure])]) - []].
test(processor_reports_every_breach) :-
    findall(Result, swiss_processor_report_to_controller([attribute(breach_of_data_security, true)], Result, _), Answers),
    Answers == [report_to_controller_required].
test(processor_missing_breach_is_indeterminate) :-
    findall(Result, swiss_processor_report_to_controller([], Result, _), Answers),
    Answers == [indeterminate([breach_of_data_security])].
test(information_may_be_omitted_on_request_with_exception) :-
    findall(Result - Citations, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(commissioner_requested_information_of_data_subject, true), attribute(information_impossible_or_requires_disproportionate_effort, true)], Result, Citations), Answers),
    Answers == [information_of_data_subject_may_be_restricted_deferred_or_omitted - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(information_required_when_exceptions_fail) :-
    findall(Result, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(information_necessary_for_protection_of_data_subject, true), attribute(article_26_ground_or_statutory_secrecy_obligation_applies, false), attribute(information_impossible_or_requires_disproportionate_effort, false), attribute(information_ensured_comparably_by_public_announcement, false)], Result, _), Answers),
    Answers == [information_of_data_subject_required].
test(information_names_missing_request) :-
    findall(Result, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(information_necessary_for_protection_of_data_subject, false)], Result, _), Answers),
    Answers == [indeterminate([commissioner_requested_information_of_data_subject])].
test(information_not_required_when_ground_fails) :-
    findall(Result, swiss_information_of_data_subject([attribute(information_necessary_for_protection_of_data_subject, false), attribute(commissioner_requested_information_of_data_subject, false)], Result, _), Answers),
    Answers == [information_of_data_subject_not_required].
test(information_refers_unsure_exception) :-
    findall(Result, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(information_necessary_for_protection_of_data_subject, true), attribute(article_26_ground_or_statutory_secrecy_obligation_applies, false), attribute(information_impossible_or_requires_disproportionate_effort, unsure), attribute(information_ensured_comparably_by_public_announcement, false)], Result, _), Answers),
    Answers == [needs_legal_review(open_textured(information_impossible_or_requires_disproportionate_effort, cite(ch_fadp_art_24_5_b)), [inputs_relied_on([breach_of_data_security - true, information_necessary_for_protection_of_data_subject - true, article_26_ground_or_statutory_secrecy_obligation_applies - false, information_impossible_or_requires_disproportionate_effort - unsure, information_ensured_comparably_by_public_announcement - false])])].
test(eu_notification_required_unless_risk_unlikely) :-
    findall(Result - Citations, eu_controller_notification_to_supervisory_authority([attribute(personal_data_breach, true), attribute(breach_unlikely_to_result_in_risk, false)], Result, Citations), Answers),
    Answers == [authority_notification_required - [cite(eu_reg_2016_679_art_33_1)]].
test(eu_unlikely_risk_is_not_required_positive) :-
    eu_controller_notification_to_supervisory_authority([attribute(breach_unlikely_to_result_in_risk, true)], authority_notification_not_required, _).
test(comparison_differs_on_thresholds) :-
    findall(Swiss - Union - Difference - Changed, compare_swiss_eu_authority_notification([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false), attribute(personal_data_breach, true), attribute(breach_unlikely_to_result_in_risk, false)], Swiss, Union, Difference, Changed), Answers),
    Answers == [authority_notification_not_required - authority_notification_required - differs - [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]].
test(comparison_not_comparable_when_side_open) :-
    findall(Difference - Changed, compare_swiss_eu_authority_notification([attribute(breach_of_data_security, false)], _, _, Difference, Changed), Answers),
    Answers == [not_comparable - []].
test(input_problems_come_first) :-
    findall(Result - Citations, swiss_controller_report_to_commissioner([attribute(unexpected_key, true)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(unexpected_key)]) - []].
test(checklist_carries_a_citation_per_row) :-
    swiss_fadp_art24_breach_notification_checklist([attribute(breach_of_data_security, false)], Items),
    length(Items, 4),
    member(item(processor_report_to_controller, report_to_controller_not_required, cite(ch_fadp_art_24_3)), Items).

test(controller_without_high_risk_is_not_required, fail) :-
    swiss_controller_report_to_commissioner([attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false)], authority_notification_required, _).
test(eu_unlikely_risk_is_not_required, fail) :-
    eu_controller_notification_to_supervisory_authority([attribute(breach_unlikely_to_result_in_risk, true)], authority_notification_required, _).
