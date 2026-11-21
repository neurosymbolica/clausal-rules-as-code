% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_colorado_cpa_colorado_cpa, [decide_colorado_cpa/2, colorado_cpa_status/2, colorado_cpa_checklist/2, colorado_cpa_decision_resolvable/1, colorado_cpa_status_values/1, applicability_status/3, minors_duties_applicability/3, response_deadline/4, extended_response_deadline/4, appeal_response_deadline/4, extended_appeal_response_deadline/4, cure_period_last_day/4, attorney_general_action_status/5, universal_opt_out_recognition_date/4, in_scope/0, biometric_only_scope/0, out_of_scope/0, exempt_entity/0, no_extension_available/0, cure_provision_not_in_force/0, cure_requirement_not_applicable/0, notice_not_yet_received/0, cure_period_running/0, action_may_be_brought/0, no_action_for_cured_violation/0, no_recognition_duty/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__us_colorado_cpa_kernel, [colorado_cpa_input_problems/2, query_problems/3, date_plus_days/3, date_plus_months_same_day/3, date_earlier/2, date_on_or_earlier/2, date_later_of/3]).
:- use_module(m__us_colorado_cpa_citations, [implements/1]).

exempt_category_row(financial_institution_or_affiliate_subject_to_glba, cite(us_co_crs_6_1_1304_2_q)).
exempt_category_row(air_carrier, cite(us_co_crs_6_1_1304_2_l)).
exempt_category_row(national_securities_association, cite(us_co_crs_6_1_1304_2_m)).

cure_provision_first_day(date(2025, 10, 1), cite(us_co_crs_6_1_1311_editors_note)).

cure_provision_last_day(date(2026, 12, 30), cite(us_co_crs_6_1_1311_1_d_ii)).

universal_opt_out_effective_day(date(2024, 7, 1), cite(us_co_ccr_904_3_rule_5_08_a)).

colorado_cpa_status_values([in_scope, biometric_only_scope, out_of_scope, exempt_entity]).

in_scope.

biometric_only_scope.

out_of_scope.

exempt_entity.

no_extension_available.

cure_provision_not_in_force.

cure_requirement_not_applicable.

notice_not_yet_received.

cure_period_running.

action_may_be_brought.

no_action_for_cured_violation.

no_recognition_duty.

key_reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_reading(Profile, Key, present(Value)) :-
    profile_get(Profile, Key, Value).

applicability_status(Profile, Result, Citations) :-
    query_problems(Profile, [], Problems),
    applicability_for_problems(Problems, Profile, Result, Citations).

applicability_for_problems([Problem|Problems], _, input_problems([Problem|Problems]), []).
applicability_for_problems([], Profile, Result, Citations) :-
    key_reading(Profile, entity_category, EntityReading),
    applicability_for_entity(EntityReading, Profile, Result, Citations).

applicability_for_entity(absent, _, indeterminate([entity_category]), []).
applicability_for_entity(present(Category), _, exempt_entity, [Citation]) :-
    implements(us_co_crs_6_1_1304_2),
    exempt_category_row(Category, Citation).
applicability_for_entity(present(none_of_the_exempt_categories), Profile, Result, Citations) :-
    implements(us_co_crs_6_1_1304_1),
    key_reading(Profile, colorado_link_for_general_duties, LinkReading),
    key_reading(Profile, consumer_count, CountReading),
    key_reading(Profile, revenue_or_discount_from_sale, RevenueReading),
    key_reading(Profile, processes_biometric_data, BiometricReading),
    threshold_status(CountReading, RevenueReading, ThresholdStatus),
    limb_one_status(LinkReading, ThresholdStatus, LimbStatus),
    applicability_for_limb(LimbStatus, BiometricReading, Result, Citations).

threshold_status(absent, _, needs(consumer_count)).
threshold_status(present(Count), _, met) :-
    implements(us_co_crs_6_1_1304_1_a_i_b),
    implements(us_co_crs_6_1_1303_6),
    implements(us_co_crs_6_1_1303_6_a),
    implements(us_co_crs_6_1_1303_6_b),
    Count #>= 100000.
threshold_status(present(Count), present(true), met) :-
    implements(us_co_crs_6_1_1304_1_a_i_b),
    implements(us_co_crs_6_1_1303_23_a),
    Count #>= 25000,
    Count #< 100000.
threshold_status(present(Count), present(false), failed) :-
    implements(us_co_crs_6_1_1304_1_a_i_b),
    implements(us_co_crs_6_1_1303_23_a),
    Count #>= 25000,
    Count #< 100000.
threshold_status(present(Count), absent, needs(revenue_or_discount_from_sale)) :-
    implements(us_co_crs_6_1_1304_1_a_i_b),
    Count #>= 25000,
    Count #< 100000.
threshold_status(present(Count), _, failed) :-
    implements(us_co_crs_6_1_1304_1_a_i_b),
    Count #< 25000.

limb_one_status(present(false), _, failed) :-
    implements(us_co_crs_6_1_1304_1_a_i_a).
limb_one_status(present(true), failed, failed) :-
    implements(us_co_crs_6_1_1304_1_a_i_b).
limb_one_status(present(unsure), failed, failed) :-
    implements(us_co_crs_6_1_1304_1_a_i_b).
limb_one_status(absent, failed, failed) :-
    implements(us_co_crs_6_1_1304_1_a_i_b).
limb_one_status(present(true), met, met) :-
    implements(us_co_crs_6_1_1304_1_a_i_a).
limb_one_status(present(true), needs(Key), missing(Key)).
limb_one_status(present(unsure), met, unsure).
limb_one_status(present(unsure), needs(Key), missing(Key)).
limb_one_status(absent, met, missing(colorado_link_for_general_duties)).
limb_one_status(absent, needs(_), missing(colorado_link_for_general_duties)).

applicability_for_limb(met, _, in_scope, [cite(us_co_crs_6_1_1304_1_a), cite(us_co_crs_6_1_1304_1_a_i_a), cite(us_co_crs_6_1_1304_1_a_i_b)]) :-
    implements(us_co_crs_6_1_1304_1_a).
applicability_for_limb(failed, present(false), out_of_scope, [cite(us_co_crs_6_1_1304_1_a), cite(us_co_crs_6_1_1304_1_a_i_a), cite(us_co_crs_6_1_1304_1_a_i_b), cite(us_co_crs_6_1_1304_1_a_ii)]) :-
    implements(us_co_crs_6_1_1304_1_a_ii).
applicability_for_limb(failed, present(true), biometric_only_scope, [cite(us_co_crs_6_1_1304_1_a), cite(us_co_crs_6_1_1304_1_a_i_a), cite(us_co_crs_6_1_1304_1_a_i_b), cite(us_co_crs_6_1_1304_1_a_ii)]) :-
    implements(us_co_crs_6_1_1304_1_a_ii),
    implements(us_co_crs_6_1_1303_2dot5),
    implements(us_co_crs_6_1_1303_2dot4_a).
applicability_for_limb(failed, absent, indeterminate([processes_biometric_data]), []).
applicability_for_limb(missing(Key), _, indeterminate([Key]), []).
applicability_for_limb(unsure, absent, indeterminate([processes_biometric_data]), []).
applicability_for_limb(unsure, present(_), needs_legal_review(open_textured(colorado_link_for_general_duties, cite(us_co_crs_6_1_1304_1_a_i_a)), [inputs_relied_on([colorado_link_for_general_duties - unsure])]), []) :-
    implements(us_co_crs_6_1_1304_1_a_i_a).

minors_duties_applicability(Profile, Result, Citations) :-
    query_problems(Profile, [], Problems),
    minors_for_problems(Problems, Profile, Result, Citations).

minors_for_problems([Problem|Problems], _, input_problems([Problem|Problems]), []).
minors_for_problems([], Profile, Result, Citations) :-
    key_reading(Profile, entity_category, EntityReading),
    minors_for_entity(EntityReading, Profile, Result, Citations).

minors_for_entity(absent, _, indeterminate([entity_category]), []).
minors_for_entity(present(Category), _, exempt_entity, [Citation]) :-
    implements(us_co_crs_6_1_1304_2),
    exempt_category_row(Category, Citation).
minors_for_entity(present(none_of_the_exempt_categories), Profile, Result, Citations) :-
    implements(us_co_crs_6_1_1304_1),
    key_reading(Profile, colorado_link_for_minors_duties, LinkReading),
    minors_for_link(LinkReading, Result, Citations).

minors_for_link(present(false), out_of_scope, [cite(us_co_crs_6_1_1304_1_b)]) :-
    implements(us_co_crs_6_1_1304_1_b).
minors_for_link(absent, indeterminate([colorado_link_for_minors_duties]), []).
minors_for_link(present(unsure), needs_legal_review(open_textured(colorado_link_for_minors_duties, cite(us_co_crs_6_1_1304_1_b)), [inputs_relied_on([colorado_link_for_minors_duties - unsure])]), []) :-
    implements(us_co_crs_6_1_1304_1_b).
minors_for_link(present(true), in_scope, [cite(us_co_crs_6_1_1304_1_b)]) :-
    implements(us_co_crs_6_1_1304_1_b).

response_deadline(Profile, Received, Deadline, Citations) :-
    query_problems(Profile, [received_date - Received], Problems),
    response_for_problems(Problems, Received, Deadline, Citations).

response_for_problems([Problem|Problems], _, input_problems([Problem|Problems]), []).
response_for_problems([], Received, Deadline, [cite(us_co_crs_6_1_1306_2_a), cite(us_co_crs_6_1_1306_2_b)]) :-
    implements(us_co_crs_6_1_1306_2_a),
    implements(us_co_crs_6_1_1306_2_b),
    PeriodDays #= 45,
    date_plus_days(Received, PeriodDays, Deadline).

extension_outcome(_, present(false), _, _, unavailable).
extension_outcome(present(false), present(true), _, _, unavailable).
extension_outcome(present(false), absent, _, _, unavailable).
extension_outcome(absent, present(true), NecessityKey, _, missing(NecessityKey)).
extension_outcome(absent, absent, NecessityKey, _, missing(NecessityKey)).
extension_outcome(present(unsure), absent, _, NoticeKey, missing(NoticeKey)).
extension_outcome(present(true), absent, _, NoticeKey, missing(NoticeKey)).
extension_outcome(present(unsure), present(true), _, _, unsure).
extension_outcome(present(true), present(true), _, _, available).

extended_response_deadline(Profile, Received, Deadline, Citations) :-
    query_problems(Profile, [received_date - Received], Problems),
    extended_response_for_problems(Problems, Profile, Received, Deadline, Citations).

extended_response_for_problems([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
extended_response_for_problems([], Profile, Received, Deadline, Citations) :-
    implements(us_co_crs_6_1_1306_2_a),
    key_reading(Profile, extension_reasonably_necessary, NecessityReading),
    key_reading(Profile, extension_notice_given_within_initial_period, NoticeReading),
    extension_outcome(NecessityReading, NoticeReading, extension_reasonably_necessary, extension_notice_given_within_initial_period, Outcome),
    extended_response_answer(Outcome, Received, Deadline, Citations).

extended_response_answer(unavailable, _, no_extension_available, [cite(us_co_crs_6_1_1306_2_a)]) :-
    implements(us_co_crs_6_1_1306_2_a).
extended_response_answer(missing(Key), _, indeterminate([Key]), []).
extended_response_answer(unsure, _, needs_legal_review(open_textured(extension_reasonably_necessary, cite(us_co_crs_6_1_1306_2_a)), [inputs_relied_on([extension_reasonably_necessary - unsure])]), []) :-
    implements(us_co_crs_6_1_1306_2_a).
extended_response_answer(available, Received, Deadline, [cite(us_co_crs_6_1_1306_2_a)]) :-
    implements(us_co_crs_6_1_1306_2_a),
    TotalDays #= 45 + 45,
    date_plus_days(Received, TotalDays, Deadline).

appeal_response_deadline(Profile, AppealReceived, Deadline, Citations) :-
    query_problems(Profile, [appeal_received_date - AppealReceived], Problems),
    appeal_for_problems(Problems, AppealReceived, Deadline, Citations).

appeal_for_problems([Problem|Problems], _, input_problems([Problem|Problems]), []).
appeal_for_problems([], AppealReceived, Deadline, [cite(us_co_crs_6_1_1306_3_b)]) :-
    implements(us_co_crs_6_1_1306_3_b),
    PeriodDays #= 45,
    date_plus_days(AppealReceived, PeriodDays, Deadline).

extended_appeal_response_deadline(Profile, AppealReceived, Deadline, Citations) :-
    query_problems(Profile, [appeal_received_date - AppealReceived], Problems),
    extended_appeal_for_problems(Problems, Profile, AppealReceived, Deadline, Citations).

extended_appeal_for_problems([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
extended_appeal_for_problems([], Profile, AppealReceived, Deadline, Citations) :-
    implements(us_co_crs_6_1_1306_3_b),
    key_reading(Profile, appeal_extension_reasonably_necessary, NecessityReading),
    key_reading(Profile, appeal_extension_notice_given_within_initial_period, NoticeReading),
    extension_outcome(NecessityReading, NoticeReading, appeal_extension_reasonably_necessary, appeal_extension_notice_given_within_initial_period, Outcome),
    extended_appeal_answer(Outcome, AppealReceived, Deadline, Citations).

extended_appeal_answer(unavailable, _, no_extension_available, [cite(us_co_crs_6_1_1306_3_b)]) :-
    implements(us_co_crs_6_1_1306_3_b).
extended_appeal_answer(missing(Key), _, indeterminate([Key]), []).
extended_appeal_answer(unsure, _, needs_legal_review(open_textured(appeal_extension_reasonably_necessary, cite(us_co_crs_6_1_1306_3_b)), [inputs_relied_on([appeal_extension_reasonably_necessary - unsure])]), []) :-
    implements(us_co_crs_6_1_1306_3_b).
extended_appeal_answer(available, AppealReceived, Deadline, [cite(us_co_crs_6_1_1306_3_b)]) :-
    implements(us_co_crs_6_1_1306_3_b),
    TotalDays #= 45 + 60,
    date_plus_days(AppealReceived, TotalDays, Deadline).

day_in_force_status(Day, before_start) :-
    implements(us_co_crs_6_1_1311_editors_note),
    cure_provision_first_day(FirstDay, _),
    date_earlier(Day, FirstDay).
day_in_force_status(Day, in_force) :-
    implements(us_co_crs_6_1_1311_1_d_ii),
    cure_provision_first_day(FirstDay, _),
    cure_provision_last_day(LastDay, _),
    date_on_or_earlier(FirstDay, Day),
    date_on_or_earlier(Day, LastDay).
day_in_force_status(Day, after_end) :-
    implements(us_co_crs_6_1_1311_1_d_ii),
    cure_provision_last_day(LastDay, _),
    date_earlier(LastDay, Day).

cure_period_end(NoticeReceived, LastDay) :-
    implements(us_co_crs_6_1_1311_1_d_ii),
    PeriodDays #= 60,
    date_plus_days(NoticeReceived, PeriodDays, LastDay).

cure_period_last_day(Profile, NoticeReceived, LastDay, Citations) :-
    query_problems(Profile, [notice_received_date - NoticeReceived], Problems),
    cure_last_day_for_problems(Problems, NoticeReceived, LastDay, Citations).

cure_last_day_for_problems([Problem|Problems], _, input_problems([Problem|Problems]), []).
cure_last_day_for_problems([], NoticeReceived, LastDay, Citations) :-
    day_in_force_status(NoticeReceived, NoticeStatus),
    cure_last_day_answer(NoticeStatus, NoticeReceived, LastDay, Citations).

cure_last_day_answer(before_start, _, cure_provision_not_in_force, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
cure_last_day_answer(after_end, _, cure_provision_not_in_force, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
cure_last_day_answer(in_force, NoticeReceived, LastDay, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii),
    cure_period_end(NoticeReceived, LastDay).

attorney_general_action_status(Profile, NoticeReceived, ReferenceDate, Result, Citations) :-
    query_problems(Profile, [notice_received_date - NoticeReceived, reference_date - ReferenceDate], Problems),
    action_for_problems(Problems, Profile, NoticeReceived, ReferenceDate, Result, Citations).

action_for_problems([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).
action_for_problems([], Profile, NoticeReceived, ReferenceDate, Result, Citations) :-
    day_in_force_status(ReferenceDate, ReferenceStatus),
    action_for_reference(ReferenceStatus, Profile, NoticeReceived, ReferenceDate, Result, Citations).

action_for_reference(before_start, _, _, _, cure_provision_not_in_force, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
action_for_reference(after_end, _, _, _, cure_provision_not_in_force, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
action_for_reference(in_force, Profile, NoticeReceived, ReferenceDate, Result, Citations) :-
    implements(us_co_crs_6_1_1311_1_d_ii),
    key_reading(Profile, action_enforces_minors_duties, EnforcesReading),
    key_reading(Profile, cure_deemed_possible, PossibleReading),
    action_for_keys(EnforcesReading, PossibleReading, Profile, NoticeReceived, ReferenceDate, Result, Citations).

action_for_keys(present(false), _, _, _, _, cure_requirement_not_applicable, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
action_for_keys(present(true), present(false), _, _, _, cure_requirement_not_applicable, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
action_for_keys(absent, present(false), _, _, _, cure_requirement_not_applicable, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
action_for_keys(absent, present(true), _, _, _, indeterminate([action_enforces_minors_duties]), []).
action_for_keys(absent, absent, _, _, _, indeterminate([action_enforces_minors_duties]), []).
action_for_keys(present(true), absent, _, _, _, indeterminate([cure_deemed_possible]), []).
action_for_keys(present(true), present(true), Profile, NoticeReceived, ReferenceDate, Result, Citations) :-
    implements(us_co_crs_6_1_1311_1_d_ii),
    day_in_force_status(NoticeReceived, NoticeStatus),
    notice_counts(NoticeStatus, NoticeCounts),
    cure_phase(NoticeCounts, NoticeReceived, ReferenceDate, Phase),
    action_for_phase(Phase, Profile, Result, Citations).

notice_counts(before_start, false) :-
    implements(us_co_crs_6_1_1311_editors_note).
notice_counts(in_force, true).
notice_counts(after_end, true).

cure_phase(false, _, _, not_yet_received).
cure_phase(true, NoticeReceived, ReferenceDate, not_yet_received) :-
    implements(us_co_crs_6_1_1311_1_d_ii),
    date_earlier(ReferenceDate, NoticeReceived).
cure_phase(true, NoticeReceived, ReferenceDate, running) :-
    implements(us_co_crs_6_1_1311_1_d_ii),
    cure_period_end(NoticeReceived, LastDay),
    date_on_or_earlier(NoticeReceived, ReferenceDate),
    date_on_or_earlier(ReferenceDate, LastDay).
cure_phase(true, NoticeReceived, ReferenceDate, after_period) :-
    implements(us_co_crs_6_1_1311_1_d_ii),
    cure_period_end(NoticeReceived, LastDay),
    date_earlier(LastDay, ReferenceDate).

action_for_phase(not_yet_received, _, notice_not_yet_received, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
action_for_phase(running, _, cure_period_running, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
action_for_phase(after_period, Profile, Result, Citations) :-
    key_reading(Profile, cured_within_cure_period, CuredReading),
    action_for_cure(CuredReading, Result, Citations).

action_for_cure(present(false), action_may_be_brought, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).
action_for_cure(absent, indeterminate([cured_within_cure_period]), []).
action_for_cure(present(true), no_action_for_cured_violation, [cite(us_co_crs_6_1_1311_1_d_ii)]) :-
    implements(us_co_crs_6_1_1311_1_d_ii).

universal_opt_out_recognition_date(Profile, ListAddedDate, FirstDay, Citations) :-
    query_problems(Profile, [list_added_date - ListAddedDate], Problems),
    recognition_for_problems(Problems, Profile, ListAddedDate, FirstDay, Citations).

recognition_for_problems([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
recognition_for_problems([], Profile, ListAddedDate, FirstDay, Citations) :-
    key_reading(Profile, processes_for_targeted_advertising_or_sale, ProcessingReading),
    recognition_for_processing(ProcessingReading, ListAddedDate, FirstDay, Citations).

recognition_for_processing(present(false), _, no_recognition_duty, [cite(us_co_crs_6_1_1306_1_a_iv_b)]) :-
    implements(us_co_crs_6_1_1306_1_a_iv_b).
recognition_for_processing(absent, _, indeterminate([processes_for_targeted_advertising_or_sale]), []).
recognition_for_processing(present(true), ListAddedDate, FirstDay, [cite(us_co_crs_6_1_1306_1_a_iv_b), cite(us_co_ccr_904_3_rule_5_08_a), cite(us_co_ccr_904_3_rule_5_08_a_3), cite(us_co_ccr_904_3_rule_5_07_f)]) :-
    implements(us_co_ccr_904_3_rule_5_08_a_3),
    implements(us_co_ccr_904_3_rule_5_07_f),
    implements(us_co_ccr_904_3_rule_5_07_a),
    implements(us_co_ccr_904_3_rule_5_08_a),
    universal_opt_out_effective_day(EffectiveDay, _),
    NoticeMonths #= 6,
    date_plus_months_same_day(ListAddedDate, NoticeMonths, NoticeEnd),
    date_later_of(EffectiveDay, NoticeEnd, FirstDay).

decide_colorado_cpa(Profile, colorado_cpa_verdict(Status, Citations)) :-
    applicability_status(Profile, Status, Citations).

colorado_cpa_status(Profile, Status) :-
    decide_colorado_cpa(Profile, colorado_cpa_verdict(Status, _Citations)).

colorado_cpa_decision_resolvable(Profile) :-
    decide_colorado_cpa(Profile, _Verdict).

colorado_cpa_checklist(Profile, Checklist) :-
    colorado_cpa_input_problems(Profile, Problems),
    checklist_for_problems(Problems, Profile, Checklist).

checklist_for_problems([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), [])]).
checklist_for_problems([], Profile, [ExemptionItem, LinkItem, ThresholdItem, BiometricItem]) :-
    key_reading(Profile, entity_category, EntityReading),
    key_reading(Profile, colorado_link_for_general_duties, LinkReading),
    key_reading(Profile, consumer_count, CountReading),
    key_reading(Profile, revenue_or_discount_from_sale, RevenueReading),
    key_reading(Profile, processes_biometric_data, BiometricReading),
    threshold_status(CountReading, RevenueReading, ThresholdStatus),
    exemption_item(EntityReading, ExemptionItem),
    link_item(LinkReading, LinkItem),
    threshold_item(ThresholdStatus, ThresholdItem),
    biometric_item(BiometricReading, BiometricItem).

exemption_item(absent, item(exempt_category, unknown([entity_category]), [cite(us_co_crs_6_1_1304_2_q), cite(us_co_crs_6_1_1304_2_l), cite(us_co_crs_6_1_1304_2_m)])).
exemption_item(present(none_of_the_exempt_categories), item(exempt_category, met, [cite(us_co_crs_6_1_1304_2_q), cite(us_co_crs_6_1_1304_2_l), cite(us_co_crs_6_1_1304_2_m)])) :-
    implements(us_co_crs_6_1_1304_2).
exemption_item(present(Category), item(exempt_category, unmet(exempt_entity(Category)), [Citation])) :-
    implements(us_co_crs_6_1_1304_2),
    exempt_category_row(Category, Citation).

link_item(present(true), item(colorado_link_for_general_duties, met, [cite(us_co_crs_6_1_1304_1_a_i_a)])) :-
    implements(us_co_crs_6_1_1304_1_a_i_a).
link_item(present(false), item(colorado_link_for_general_duties, unmet(no_colorado_link), [cite(us_co_crs_6_1_1304_1_a_i_a)])) :-
    implements(us_co_crs_6_1_1304_1_a_i_a).
link_item(present(unsure), item(colorado_link_for_general_duties, unknown([colorado_link_for_general_duties]), [cite(us_co_crs_6_1_1304_1_a_i_a)])).
link_item(absent, item(colorado_link_for_general_duties, unknown([colorado_link_for_general_duties]), [cite(us_co_crs_6_1_1304_1_a_i_a)])).

threshold_item(met, item(consumer_threshold, met, [cite(us_co_crs_6_1_1304_1_a_i_b)])).
threshold_item(failed, item(consumer_threshold, unmet(below_consumer_threshold), [cite(us_co_crs_6_1_1304_1_a_i_b)])).
threshold_item(needs(Key), item(consumer_threshold, unknown([Key]), [cite(us_co_crs_6_1_1304_1_a_i_b)])).

biometric_item(present(true), item(biometric_data, met, [cite(us_co_crs_6_1_1304_1_a_ii)])) :-
    implements(us_co_crs_6_1_1304_1_a_ii).
biometric_item(present(false), item(biometric_data, unmet(no_biometric_data), [cite(us_co_crs_6_1_1304_1_a_ii)])) :-
    implements(us_co_crs_6_1_1304_1_a_ii).
biometric_item(absent, item(biometric_data, unknown([processes_biometric_data]), [cite(us_co_crs_6_1_1304_1_a_ii)])).

test(a_large_linked_controller_is_in_scope) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 100000)], Result, Citations),
    Result == in_scope,
    Citations == [cite(us_co_crs_6_1_1304_1_a), cite(us_co_crs_6_1_1304_1_a_i_a), cite(us_co_crs_6_1_1304_1_a_i_b)].
test(exactly_twenty_five_thousand_with_sale_revenue_is_in_scope) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 25000), attribute(revenue_or_discount_from_sale, true)], in_scope, _).
test(twenty_five_thousand_without_sale_revenue_and_no_biometric_data_is_out_of_scope) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 25000), attribute(revenue_or_discount_from_sale, false), attribute(processes_biometric_data, false)], out_of_scope, _).
test(a_small_controller_with_biometric_data_is_biometric_only) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(consumer_count, 24999), attribute(processes_biometric_data, true)], biometric_only_scope, _).
test(the_missing_entity_category_is_named_first) :-
    applicability_status([], indeterminate([entity_category]), []).
test(the_missing_link_is_named_before_the_count) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories)], indeterminate([colorado_link_for_general_duties]), []).
test(the_revenue_key_is_named_for_a_middle_count) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 50000)], indeterminate([revenue_or_discount_from_sale]), []).
test(a_failed_limb_names_only_the_biometric_key) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, false)], indeterminate([processes_biometric_data]), []).
test(an_unsure_link_with_biometric_data_absent_names_it) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, unsure), attribute(consumer_count, 200000)], indeterminate([processes_biometric_data]), []).
test(an_unsure_link_goes_to_a_lawyer) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, unsure), attribute(consumer_count, 200000), attribute(processes_biometric_data, false)], Result, []),
    Result == needs_legal_review(open_textured(colorado_link_for_general_duties, cite(us_co_crs_6_1_1304_1_a_i_a)), [inputs_relied_on([colorado_link_for_general_duties - unsure])]).
test(an_air_carrier_is_exempt_once) :-
    findall(Result - Citations, applicability_status([attribute(entity_category, air_carrier)], Result, Citations), Answers),
    Answers == [exempt_entity - [cite(us_co_crs_6_1_1304_2_l)]].
test(a_malformed_profile_gives_its_problems) :-
    applicability_status([attribute(foo, 1)], input_problems([unknown_key(foo)]), []).
test(minors_sections_apply_with_the_link) :-
    minors_duties_applicability([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_minors_duties, true)], in_scope, [cite(us_co_crs_6_1_1304_1_b)]).
test(minors_unsure_link_goes_to_a_lawyer) :-
    minors_duties_applicability([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_minors_duties, unsure)], needs_legal_review(open_textured(colorado_link_for_minors_duties, cite(us_co_crs_6_1_1304_1_b)), [inputs_relied_on([colorado_link_for_minors_duties - unsure])]), []).
test(minors_exempt_financial_institution) :-
    minors_duties_applicability([attribute(entity_category, financial_institution_or_affiliate_subject_to_glba)], exempt_entity, [cite(us_co_crs_6_1_1304_2_q)]).
test(response_deadline_is_forty_five_days_later) :-
    response_deadline([], date(2026, 1, 1), date(2026, 2, 15), [cite(us_co_crs_6_1_1306_2_a), cite(us_co_crs_6_1_1306_2_b)]).
test(a_false_date_gives_a_date_problem) :-
    response_deadline([], date(2027, 2, 29), input_problems([wrong_type(received_date)]), []).
test(extended_response_deadline_is_ninety_days_later) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), date(2026, 4, 1), [cite(us_co_crs_6_1_1306_2_a)]).
test(a_late_notice_gives_no_extension) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, unsure), attribute(extension_notice_given_within_initial_period, false)], date(2026, 1, 1), no_extension_available, [cite(us_co_crs_6_1_1306_2_a)]).
test(an_unsure_necessity_with_notice_absent_names_the_notice) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, unsure)], date(2026, 1, 1), indeterminate([extension_notice_given_within_initial_period]), []).
test(appeal_deadline_is_forty_five_days_later) :-
    appeal_response_deadline([], date(2026, 3, 1), date(2026, 4, 15), [cite(us_co_crs_6_1_1306_3_b)]).
test(extended_appeal_deadline_is_one_hundred_and_five_days_later) :-
    extended_appeal_response_deadline([attribute(appeal_extension_reasonably_necessary, true), attribute(appeal_extension_notice_given_within_initial_period, true)], date(2026, 3, 1), date(2026, 6, 14), [cite(us_co_crs_6_1_1306_3_b)]).
test(cure_period_ends_sixty_days_later_past_the_repeal) :-
    cure_period_last_day([], date(2026, 12, 30), date(2027, 2, 28), [cite(us_co_crs_6_1_1311_1_d_ii)]).
test(a_notice_before_the_start_is_outside_the_provision) :-
    cure_period_last_day([], date(2025, 9, 30), cure_provision_not_in_force, [cite(us_co_crs_6_1_1311_1_d_ii)]).
test(a_notice_on_the_repeal_day_is_outside_the_provision) :-
    cure_period_last_day([], date(2026, 12, 31), cure_provision_not_in_force, _).
test(the_sixtieth_day_is_still_running) :-
    attorney_general_action_status([attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, true)], date(2026, 3, 1), date(2026, 4, 30), cure_period_running, [cite(us_co_crs_6_1_1311_1_d_ii)]).
test(after_the_sixty_days_an_uncured_violation_may_be_sued) :-
    attorney_general_action_status([attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, true), attribute(cured_within_cure_period, false)], date(2026, 3, 1), date(2026, 5, 1), action_may_be_brought, _).
test(after_the_sixty_days_the_cure_is_asked_for) :-
    attorney_general_action_status([attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, true)], date(2026, 3, 1), date(2026, 5, 1), indeterminate([cured_within_cure_period]), []).
test(a_day_before_receipt_is_notice_not_yet_received) :-
    attorney_general_action_status([attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, true)], date(2026, 3, 1), date(2026, 2, 28), notice_not_yet_received, _).
test(the_repeal_day_is_outside_the_provision) :-
    attorney_general_action_status([], date(2026, 3, 1), date(2026, 12, 31), cure_provision_not_in_force, _).
test(no_cure_possible_needs_no_notice) :-
    attorney_general_action_status([attribute(cure_deemed_possible, false)], date(2026, 3, 1), date(2026, 4, 1), cure_requirement_not_applicable, _).
test(the_action_status_has_one_answer) :-
    findall(Result, attorney_general_action_status([attribute(action_enforces_minors_duties, true), attribute(cure_deemed_possible, true), attribute(cured_within_cure_period, true)], date(2026, 3, 1), date(2026, 6, 1), Result, _), Results),
    Results == [no_action_for_cured_violation].
test(recognition_runs_six_months_after_listing) :-
    universal_opt_out_recognition_date([attribute(processes_for_targeted_advertising_or_sale, true)], date(2024, 3, 15), date(2024, 9, 15), _).
test(recognition_never_before_the_effective_day) :-
    universal_opt_out_recognition_date([attribute(processes_for_targeted_advertising_or_sale, true)], date(2023, 11, 1), date(2024, 7, 1), _).
test(recognition_clamps_to_the_end_of_february) :-
    universal_opt_out_recognition_date([attribute(processes_for_targeted_advertising_or_sale, true)], date(2026, 8, 31), date(2027, 2, 28), _).
test(no_targeted_advertising_means_no_recognition_duty) :-
    universal_opt_out_recognition_date([attribute(processes_for_targeted_advertising_or_sale, false)], date(2026, 1, 1), no_recognition_duty, [cite(us_co_crs_6_1_1306_1_a_iv_b)]).
test(the_checklist_has_one_row_per_ground) :-
    colorado_cpa_checklist([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 10)], Checklist),
    length(Checklist, 4).
test(the_facade_status_projects_the_verdict) :-
    colorado_cpa_status([attribute(entity_category, national_securities_association)], exempt_entity).

test(a_small_controller_with_biometric_data_is_not_in_scope, fail) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(consumer_count, 24999), attribute(processes_biometric_data, true)], in_scope, _).
test(an_air_carrier_is_not_in_scope, fail) :-
    applicability_status([attribute(entity_category, air_carrier)], in_scope, _).
test(no_targeted_advertising_gives_no_date, fail) :-
    universal_opt_out_recognition_date([attribute(processes_for_targeted_advertising_or_sale, false)], date(2026, 1, 1), date(_, _, _), _).
