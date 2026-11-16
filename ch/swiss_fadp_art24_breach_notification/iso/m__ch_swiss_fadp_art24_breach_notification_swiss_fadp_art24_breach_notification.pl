% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [decide_swiss_fadp_art24_breach_notification/2, swiss_fadp_art24_breach_notification_status/2, swiss_fadp_art24_breach_notification_checklist/2, swiss_fadp_art24_breach_notification_decision_resolvable/1, swiss_fadp_art24_breach_notification_status_values/1, swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2, swiss_fadp_art24_breach_notification_key_state/3, swiss_fadp_art24_breach_notification_pairs/3]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_citations, [implements/1]).

swiss_fadp_art24_breach_notification_status_values([authority_notification_required, authority_notification_not_required, report_to_controller_required, report_to_controller_not_required, information_of_data_subject_required, information_of_data_subject_not_required, information_of_data_subject_may_be_restricted_deferred_or_omitted]).

article_24_5_exception_keys([article_26_ground_or_statutory_secrecy_obligation_applies, information_impossible_or_requires_disproportionate_effort, information_ensured_comparably_by_public_announcement]).

query_inputs(swiss_controller_report_to_commissioner, [breach_of_data_security, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]).
query_inputs(swiss_processor_report_to_controller, [breach_of_data_security]).
query_inputs(swiss_information_of_data_subject, [breach_of_data_security, information_necessary_for_protection_of_data_subject, commissioner_requested_information_of_data_subject, article_26_ground_or_statutory_secrecy_obligation_applies, information_impossible_or_requires_disproportionate_effort, information_ensured_comparably_by_public_announcement]).
query_inputs(eu_controller_notification_to_supervisory_authority, [personal_data_breach, breach_unlikely_to_result_in_risk]).

referral_row(swiss_report_breach_of_data_security, swiss_controller_report_to_commissioner, breach_of_data_security, cite(ch_fadp_art_5_h)).
referral_row(swiss_report_breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, swiss_controller_report_to_commissioner, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, cite(ch_fadp_art_24_1)).
referral_row(swiss_processor_breach_of_data_security, swiss_processor_report_to_controller, breach_of_data_security, cite(ch_fadp_art_5_h)).
referral_row(swiss_information_breach_of_data_security, swiss_information_of_data_subject, breach_of_data_security, cite(ch_fadp_art_5_h)).
referral_row(swiss_information_information_necessary_for_protection_of_data_subject, swiss_information_of_data_subject, information_necessary_for_protection_of_data_subject, cite(ch_fadp_art_24_4)).
referral_row(swiss_information_article_26_ground_or_statutory_secrecy_obligation_applies, swiss_information_of_data_subject, article_26_ground_or_statutory_secrecy_obligation_applies, cite(ch_fadp_art_24_5_a)).
referral_row(swiss_information_information_impossible_or_requires_disproportionate_effort, swiss_information_of_data_subject, information_impossible_or_requires_disproportionate_effort, cite(ch_fadp_art_24_5_b)).
referral_row(swiss_information_information_ensured_comparably_by_public_announcement, swiss_information_of_data_subject, information_ensured_comparably_by_public_announcement, cite(ch_fadp_art_24_5_c)).
referral_row(eu_notification_personal_data_breach, eu_controller_notification_to_supervisory_authority, personal_data_breach, cite(eu_reg_2016_679_art_33_1)).
referral_row(eu_notification_breach_unlikely_to_result_in_risk, eu_controller_notification_to_supervisory_authority, breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)).

first_in_state(_, [], _, none).
first_in_state(Profile, [InputKey|_], State, found(InputKey)) :-
    swiss_fadp_art24_breach_notification_key_state(Profile, InputKey, State).
first_in_state(Profile, [InputKey|LaterKeys], State, Found) :-
    swiss_fadp_art24_breach_notification_key_state(Profile, InputKey, OtherState),
    dif(OtherState, State),
    first_in_state(Profile, LaterKeys, State, Found).

open_answer(Profile, Query, CandidateKeys, Result) :-
    first_in_state(Profile, CandidateKeys, absent, AbsentFound),
    open_answer_for(AbsentFound, Profile, Query, CandidateKeys, Result).

open_answer_for(found(MissingKey), _, _, _, indeterminate([MissingKey])).
open_answer_for(none, Profile, Query, CandidateKeys, needs_legal_review(open_textured(UnsureKey, Citation), [inputs_relied_on(Pairs)])) :-
    first_in_state(Profile, CandidateKeys, unsure, found(UnsureKey)),
    referral_row(_, Query, UnsureKey, Citation),
    query_inputs(Query, InputKeys),
    swiss_fadp_art24_breach_notification_pairs(Profile, InputKeys, Pairs).

swiss_controller_report_to_commissioner(Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    controller_report_answer(Problems, Profile, Result, Citations).

controller_report_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
controller_report_answer([], Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_key_state(Profile, breach_of_data_security, BreachState),
    swiss_fadp_art24_breach_notification_key_state(Profile, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, RiskState),
    controller_report_route(BreachState, RiskState, Profile, Result, Citations).

controller_report_route(false, _, _, authority_notification_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]) :-
    implements(ch_fadp_art_5_h).
controller_report_route(BreachState, false, _, authority_notification_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]) :-
    implements(ch_fadp_art_24_1),
    dif(BreachState, false).
controller_report_route(true, true, _, authority_notification_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]) :-
    implements(ch_fadp_art_24_1).
controller_report_route(BreachState, RiskState, Profile, Result, []) :-
    implements(ch_fadp_art_24_1),
    controller_report_open(BreachState, RiskState),
    query_inputs(swiss_controller_report_to_commissioner, CandidateKeys),
    open_answer(Profile, swiss_controller_report_to_commissioner, CandidateKeys, Result).

controller_report_open(absent, RiskState) :-
    implements(ch_fadp_art_24_1),
    dif(RiskState, false).
controller_report_open(unsure, RiskState) :-
    implements(ch_fadp_art_24_1),
    dif(RiskState, false).
controller_report_open(true, RiskState) :-
    implements(ch_fadp_art_24_1),
    dif(RiskState, false),
    dif(RiskState, true).

swiss_processor_report_to_controller(Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    processor_report_answer(Problems, Profile, Result, Citations).

processor_report_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
processor_report_answer([], Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_key_state(Profile, breach_of_data_security, BreachState),
    processor_report_route(BreachState, Profile, Result, Citations).

processor_report_route(false, _, report_to_controller_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]) :-
    implements(ch_fadp_art_24_3).
processor_report_route(true, _, report_to_controller_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]) :-
    implements(ch_fadp_art_24_3).
processor_report_route(BreachState, Profile, Result, []) :-
    implements(ch_fadp_art_5_h),
    processor_report_open(BreachState),
    query_inputs(swiss_processor_report_to_controller, CandidateKeys),
    open_answer(Profile, swiss_processor_report_to_controller, CandidateKeys, Result).

processor_report_open(absent).
processor_report_open(unsure).

swiss_information_of_data_subject(Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    information_answer(Problems, Profile, Result, Citations).

information_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
information_answer([], Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_key_state(Profile, breach_of_data_security, BreachState),
    ground_of_article_24_4(Profile, GroundStatus),
    exception_of_article_24_5(Profile, ExceptionStatus),
    information_route(BreachState, GroundStatus, ExceptionStatus, Profile, Result, Citations).

ground_of_article_24_4(Profile, GroundStatus) :-
    implements(ch_fadp_art_24_4),
    swiss_fadp_art24_breach_notification_key_state(Profile, information_necessary_for_protection_of_data_subject, NecessityState),
    swiss_fadp_art24_breach_notification_key_state(Profile, commissioner_requested_information_of_data_subject, RequestState),
    ground_from_states(NecessityState, RequestState, GroundStatus).

ground_from_states(true, _, met) :-
    implements(ch_fadp_art_24_4).
ground_from_states(NecessityState, true, met) :-
    implements(ch_fadp_art_24_4),
    dif(NecessityState, true).
ground_from_states(false, false, failed) :-
    implements(ch_fadp_art_24_4).
ground_from_states(absent, RequestState, open) :-
    implements(ch_fadp_art_24_4),
    dif(RequestState, true).
ground_from_states(unsure, RequestState, open) :-
    implements(ch_fadp_art_24_4),
    dif(RequestState, true).
ground_from_states(false, absent, open) :-
    implements(ch_fadp_art_24_4).

exception_of_article_24_5(Profile, ExceptionStatus) :-
    implements(ch_fadp_art_24_5),
    article_24_5_exception_keys(ExceptionKeys),
    maplist(swiss_fadp_art24_breach_notification_key_state(Profile), ExceptionKeys, ExceptionStates),
    exception_from_states(ExceptionStates, ExceptionStatus).

exception_from_states(ExceptionStates, held) :-
    implements(ch_fadp_art_24_5),
    memberd_t(true, ExceptionStates, true).
exception_from_states(ExceptionStates, all_failed) :-
    implements(ch_fadp_art_24_5),
    memberd_t(true, ExceptionStates, false),
    sort(ExceptionStates, [false]).
exception_from_states(ExceptionStates, open) :-
    implements(ch_fadp_art_24_5),
    memberd_t(true, ExceptionStates, false),
    sort(ExceptionStates, SortedStates),
    dif(SortedStates, [false]).

information_route(false, _, _, _, information_of_data_subject_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]) :-
    implements(ch_fadp_art_5_h).
information_route(BreachState, failed, _, _, information_of_data_subject_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]) :-
    implements(ch_fadp_art_24_4),
    dif(BreachState, false).
information_route(true, met, held, _, information_of_data_subject_may_be_restricted_deferred_or_omitted, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]) :-
    implements(ch_fadp_art_24_5).
information_route(true, met, all_failed, _, information_of_data_subject_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]) :-
    implements(ch_fadp_art_24_4).
information_route(BreachState, GroundStatus, ExceptionStatus, Profile, Result, []) :-
    implements(ch_fadp_art_24_4),
    information_open(BreachState, GroundStatus, ExceptionStatus),
    information_candidate_keys(GroundStatus, ExceptionStatus, CandidateKeys),
    open_answer(Profile, swiss_information_of_data_subject, CandidateKeys, Result).

information_open(absent, GroundStatus, _) :-
    implements(ch_fadp_art_24_4),
    dif(GroundStatus, failed).
information_open(unsure, GroundStatus, _) :-
    implements(ch_fadp_art_24_4),
    dif(GroundStatus, failed).
information_open(true, open, _) :-
    implements(ch_fadp_art_24_4).
information_open(true, met, open) :-
    implements(ch_fadp_art_24_5).

information_candidate_keys(GroundStatus, ExceptionStatus, CandidateKeys) :-
    ground_candidate_keys(GroundStatus, GroundKeys),
    exception_candidate_keys(ExceptionStatus, ExceptionKeys),
    append([breach_of_data_security|GroundKeys], ExceptionKeys, CandidateKeys).

ground_candidate_keys(met, []).
ground_candidate_keys(GroundStatus, [information_necessary_for_protection_of_data_subject, commissioner_requested_information_of_data_subject]) :-
    dif(GroundStatus, met).

exception_candidate_keys(held, []).
exception_candidate_keys(ExceptionStatus, ExceptionKeys) :-
    dif(ExceptionStatus, held),
    article_24_5_exception_keys(ExceptionKeys).

eu_controller_notification_to_supervisory_authority(Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    eu_notification_answer(Problems, Profile, Result, Citations).

eu_notification_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
eu_notification_answer([], Profile, Result, Citations) :-
    swiss_fadp_art24_breach_notification_key_state(Profile, personal_data_breach, BreachState),
    swiss_fadp_art24_breach_notification_key_state(Profile, breach_unlikely_to_result_in_risk, UnlikelyState),
    eu_notification_route(BreachState, UnlikelyState, Profile, Result, Citations).

eu_notification_route(false, _, _, authority_notification_not_required, [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
eu_notification_route(BreachState, true, _, authority_notification_not_required, [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1),
    dif(BreachState, false).
eu_notification_route(true, false, _, authority_notification_required, [cite(eu_reg_2016_679_art_33_1)]) :-
    implements(eu_reg_2016_679_art_33_1).
eu_notification_route(BreachState, UnlikelyState, Profile, Result, []) :-
    implements(eu_reg_2016_679_art_33_1),
    eu_notification_open(BreachState, UnlikelyState),
    query_inputs(eu_controller_notification_to_supervisory_authority, CandidateKeys),
    open_answer(Profile, eu_controller_notification_to_supervisory_authority, CandidateKeys, Result).

eu_notification_open(absent, UnlikelyState) :-
    implements(eu_reg_2016_679_art_33_1),
    dif(UnlikelyState, true).
eu_notification_open(unsure, UnlikelyState) :-
    implements(eu_reg_2016_679_art_33_1),
    dif(UnlikelyState, true).
eu_notification_open(true, UnlikelyState) :-
    implements(eu_reg_2016_679_art_33_1),
    dif(UnlikelyState, true),
    dif(UnlikelyState, false).

compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy) :-
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    comparison_answer(Problems, Profile, SwissResult, EuropeanResult, Difference, ChangedBy).

comparison_answer([Problem|Problems], _, input_problems([Problem|Problems]), input_problems([Problem|Problems]), not_comparable, []).
comparison_answer([], Profile, SwissResult, EuropeanResult, Difference, ChangedBy) :-
    swiss_controller_report_to_commissioner(Profile, SwissResult, _),
    eu_controller_notification_to_supervisory_authority(Profile, EuropeanResult, _),
    answer_kind(SwissResult, SwissKind),
    answer_kind(EuropeanResult, EuropeanKind),
    difference_by_kind(SwissKind, EuropeanKind, SwissResult, EuropeanResult, Difference, ChangedBy).

answer_kind(authority_notification_required, final).
answer_kind(authority_notification_not_required, final).
answer_kind(Answer, open) :-
    compound(Answer).

difference_by_kind(final, final, SwissResult, EuropeanResult, Difference, ChangedBy) :-
    final_difference(SwissResult, EuropeanResult, Difference, ChangedBy).
difference_by_kind(open, _, _, _, not_comparable, []).
difference_by_kind(final, open, _, _, not_comparable, []).

final_difference(Answer, Answer, same, []).
final_difference(SwissResult, EuropeanResult, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]) :-
    implements(ch_fadp_art_24_1),
    implements(eu_reg_2016_679_art_33_1),
    dif(SwissResult, EuropeanResult).

decide_swiss_fadp_art24_breach_notification(Profile, swiss_fadp_art24_breach_notification_verdict(Status, Citations)) :-
    swiss_controller_report_to_commissioner(Profile, Status, Citations).

swiss_fadp_art24_breach_notification_status(Profile, Status) :-
    decide_swiss_fadp_art24_breach_notification(Profile, swiss_fadp_art24_breach_notification_verdict(Status, _Citations)).

obligation_ids([controller_report_to_commissioner, processor_report_to_controller, information_of_data_subject, eu_notification_to_supervisory_authority]).

obligation_provisions(controller_report_to_commissioner, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]).
obligation_provisions(processor_report_to_controller, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]).
obligation_provisions(information_of_data_subject, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]).
obligation_provisions(eu_notification_to_supervisory_authority, [cite(eu_reg_2016_679_art_33_1)]).

obligation_answer(controller_report_to_commissioner, Profile, Result, Citations) :-
    swiss_controller_report_to_commissioner(Profile, Result, Citations).
obligation_answer(processor_report_to_controller, Profile, Result, Citations) :-
    swiss_processor_report_to_controller(Profile, Result, Citations).
obligation_answer(information_of_data_subject, Profile, Result, Citations) :-
    swiss_information_of_data_subject(Profile, Result, Citations).
obligation_answer(eu_notification_to_supervisory_authority, Profile, Result, Citations) :-
    eu_controller_notification_to_supervisory_authority(Profile, Result, Citations).

obligation_item(Profile, ObligationId, item(ObligationId, Result, Citations)) :-
    obligation_answer(ObligationId, Profile, Result, AnswerCitations),
    obligation_provisions(ObligationId, Provisions),
    item_citations(AnswerCitations, Provisions, Citations).

item_citations([], Provisions, Provisions).
item_citations([Citation|Citations], _, [Citation|Citations]).

swiss_fadp_art24_breach_notification_checklist(Profile, Items) :-
    obligation_ids(ObligationIds),
    maplist(obligation_item(Profile), ObligationIds, Items).

swiss_fadp_art24_breach_notification_decision_resolvable(Profile) :-
    decide_swiss_fadp_art24_breach_notification(Profile, _Verdict).

test(controller_report_required) :-
    findall(Result - Citations, swiss_controller_report_to_commissioner([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true)], Result, Citations), Answers),
    Answers == [authority_notification_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]].
test(controller_report_not_required_when_no_breach_and_risk_absent) :-
    findall(Result - Citations, swiss_controller_report_to_commissioner([attribute(breach_of_data_security, false)], Result, Citations), Answers),
    Answers == [authority_notification_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]].
test(controller_report_not_required_when_risk_false_and_breach_unsure) :-
    findall(Result, swiss_controller_report_to_commissioner([attribute(breach_of_data_security, unsure), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false)], Result, _), Results),
    Results == [authority_notification_not_required].
test(controller_report_names_missing_risk_although_breach_unsure) :-
    findall(Result - Citations, swiss_controller_report_to_commissioner([attribute(breach_of_data_security, unsure)], Result, Citations), Answers),
    Answers == [indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]) - []].
test(controller_report_names_first_missing_key) :-
    findall(Result, swiss_controller_report_to_commissioner([], Result, _), Results),
    Results == [indeterminate([breach_of_data_security])].
test(controller_report_refers_unsure_breach) :-
    findall(Result, swiss_controller_report_to_commissioner([attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true), attribute(breach_of_data_security, unsure)], Result, _), Results),
    Results == [needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - true])])].
test(controller_report_refers_unsure_risk) :-
    findall(Result, swiss_controller_report_to_commissioner([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, unsure)], Result, _), Results),
    Results == [needs_legal_review(open_textured(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, cite(ch_fadp_art_24_1)), [inputs_relied_on([breach_of_data_security - true, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - unsure])])].
test(processor_report_required_without_risk_threshold) :-
    findall(Result - Citations, swiss_processor_report_to_controller([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false)], Result, Citations), Answers),
    Answers == [report_to_controller_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]].
test(processor_report_not_required) :-
    findall(Result, swiss_processor_report_to_controller([attribute(breach_of_data_security, false)], Result, _), Results),
    Results == [report_to_controller_not_required].
test(processor_report_missing_breach) :-
    findall(Result, swiss_processor_report_to_controller([attribute(personal_data_breach, true)], Result, _), Results),
    Results == [indeterminate([breach_of_data_security])].
test(processor_report_unsure_breach) :-
    findall(Result, swiss_processor_report_to_controller([attribute(breach_of_data_security, unsure)], Result, _), Results),
    Results == [needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure])])].
test(information_may_be_restricted_on_commissioner_request) :-
    findall(Result - Citations, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(commissioner_requested_information_of_data_subject, true), attribute(article_26_ground_or_statutory_secrecy_obligation_applies, true)], Result, Citations), Answers),
    Answers == [information_of_data_subject_may_be_restricted_deferred_or_omitted - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(information_required_when_all_exceptions_fail) :-
    findall(Result - Citations, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(information_necessary_for_protection_of_data_subject, true), attribute(article_26_ground_or_statutory_secrecy_obligation_applies, false), attribute(information_impossible_or_requires_disproportionate_effort, false), attribute(information_ensured_comparably_by_public_announcement, false)], Result, Citations), Answers),
    Answers == [information_of_data_subject_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(information_not_required_when_ground_fails_and_breach_absent) :-
    findall(Result - Citations, swiss_information_of_data_subject([attribute(information_necessary_for_protection_of_data_subject, false), attribute(commissioner_requested_information_of_data_subject, false)], Result, Citations), Answers),
    Answers == [information_of_data_subject_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]].
test(information_does_not_read_high_risk) :-
    findall(Result, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false), attribute(information_necessary_for_protection_of_data_subject, true), attribute(information_ensured_comparably_by_public_announcement, true)], Result, _), Results),
    Results == [information_of_data_subject_may_be_restricted_deferred_or_omitted].
test(information_names_missing_request_although_necessity_unsure) :-
    findall(Result, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(information_necessary_for_protection_of_data_subject, unsure)], Result, _), Results),
    Results == [indeterminate([commissioner_requested_information_of_data_subject])].
test(information_names_missing_exception_when_ground_met) :-
    findall(Result, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(information_necessary_for_protection_of_data_subject, true), attribute(article_26_ground_or_statutory_secrecy_obligation_applies, false)], Result, _), Results),
    Results == [indeterminate([information_impossible_or_requires_disproportionate_effort])].
test(information_refers_unsure_necessity) :-
    findall(Result, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(information_necessary_for_protection_of_data_subject, unsure), attribute(commissioner_requested_information_of_data_subject, false), attribute(article_26_ground_or_statutory_secrecy_obligation_applies, false), attribute(information_impossible_or_requires_disproportionate_effort, false), attribute(information_ensured_comparably_by_public_announcement, false)], Result, _), Results),
    Results == [needs_legal_review(open_textured(information_necessary_for_protection_of_data_subject, cite(ch_fadp_art_24_4)), [inputs_relied_on([breach_of_data_security - true, information_necessary_for_protection_of_data_subject - unsure, commissioner_requested_information_of_data_subject - false, article_26_ground_or_statutory_secrecy_obligation_applies - false, information_impossible_or_requires_disproportionate_effort - false, information_ensured_comparably_by_public_announcement - false])])].
test(information_refers_unsure_announcement) :-
    findall(Result, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(commissioner_requested_information_of_data_subject, true), attribute(article_26_ground_or_statutory_secrecy_obligation_applies, false), attribute(information_impossible_or_requires_disproportionate_effort, false), attribute(information_ensured_comparably_by_public_announcement, unsure)], Result, _), Results),
    Results == [needs_legal_review(open_textured(information_ensured_comparably_by_public_announcement, cite(ch_fadp_art_24_5_c)), [inputs_relied_on([breach_of_data_security - true, commissioner_requested_information_of_data_subject - true, article_26_ground_or_statutory_secrecy_obligation_applies - false, information_impossible_or_requires_disproportionate_effort - false, information_ensured_comparably_by_public_announcement - unsure])])].
test(eu_notification_required) :-
    findall(Result - Citations, eu_controller_notification_to_supervisory_authority([attribute(personal_data_breach, true), attribute(breach_unlikely_to_result_in_risk, false)], Result, Citations), Answers),
    Answers == [authority_notification_required - [cite(eu_reg_2016_679_art_33_1)]].
test(eu_notification_not_required_when_unlikely_and_breach_absent) :-
    findall(Result, eu_controller_notification_to_supervisory_authority([attribute(breach_unlikely_to_result_in_risk, true)], Result, _), Results),
    Results == [authority_notification_not_required].
test(eu_notification_names_missing_risk) :-
    findall(Result, eu_controller_notification_to_supervisory_authority([attribute(personal_data_breach, unsure)], Result, _), Results),
    Results == [indeterminate([breach_unlikely_to_result_in_risk])].
test(eu_notification_refers_unsure_risk) :-
    findall(Result, eu_controller_notification_to_supervisory_authority([attribute(personal_data_breach, true), attribute(breach_unlikely_to_result_in_risk, unsure)], Result, _), Results),
    Results == [needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([personal_data_breach - true, breach_unlikely_to_result_in_risk - unsure])])].
test(comparison_differs) :-
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false), attribute(personal_data_breach, true), attribute(breach_unlikely_to_result_in_risk, false)], SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(authority_notification_not_required, authority_notification_required, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)])].
test(comparison_same) :-
    findall(Difference - ChangedBy, compare_swiss_eu_authority_notification([attribute(breach_of_data_security, false), attribute(personal_data_breach, false)], _, _, Difference, ChangedBy), Answers),
    Answers == [same - []].
test(comparison_not_comparable_keeps_each_side) :-
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification([attribute(breach_of_data_security, true), attribute(personal_data_breach, false)], SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), authority_notification_not_required, not_comparable, [])].
test(input_problem_crisp_key_unsure) :-
    findall(Result - Citations, swiss_controller_report_to_commissioner([attribute(commissioner_requested_information_of_data_subject, unsure)], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(commissioner_requested_information_of_data_subject)]) - []].
test(input_problem_unknown_key_in_comparison) :-
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification([attribute(colour, red)], SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(input_problems([unknown_key(colour)]), input_problems([unknown_key(colour)]), not_comparable, [])].
test(input_problem_duplicate_key) :-
    findall(Result, swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(breach_of_data_security, true)], Result, _), Results),
    Results == [input_problems([duplicate_key(breach_of_data_security)])].
test(input_problem_not_an_attribute_list) :-
    findall(Result, swiss_processor_report_to_controller(nothing, Result, _), Results),
    Results == [input_problems([wrong_type(profile)])].
test(checklist_carries_provenance_per_item) :-
    swiss_fadp_art24_breach_notification_checklist([attribute(breach_of_data_security, true)], Items),
    Items = [item(controller_report_to_commissioner, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]), item(processor_report_to_controller, report_to_controller_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]), item(information_of_data_subject, indeterminate([information_necessary_for_protection_of_data_subject]), [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]), item(eu_notification_to_supervisory_authority, indeterminate([personal_data_breach]), [cite(eu_reg_2016_679_art_33_1)])].
test(headline_status_is_the_controller_report) :-
    findall(Status, swiss_fadp_art24_breach_notification_status([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true)], Status), Statuses),
    Statuses == [authority_notification_required].

test(controller_report_no_breach_is_not_required_only, fail) :-
    swiss_controller_report_to_commissioner([attribute(breach_of_data_security, false)], authority_notification_required, _).
test(information_with_exception_is_not_required, fail) :-
    swiss_information_of_data_subject([attribute(breach_of_data_security, true), attribute(commissioner_requested_information_of_data_subject, true), attribute(article_26_ground_or_statutory_secrecy_obligation_applies, true)], information_of_data_subject_required, _).
