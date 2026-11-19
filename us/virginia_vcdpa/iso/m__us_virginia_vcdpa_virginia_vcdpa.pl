% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_virginia_vcdpa_virginia_vcdpa, [applicability_status/3, response_deadline/4, extended_response_deadline/4, appeal_response_deadline/4, cure_period_last_day/4, attorney_general_action_status/5, civil_penalty_maximum/3, in_scope/0, out_of_scope/0, exempt_entity/0, no_extension_available/0, notice_not_yet_provided/0, cure_period_running/0, action_may_be_initiated/0, no_action_for_cured_violation/0, decide_virginia_vcdpa/2, virginia_vcdpa_status/2, virginia_vcdpa_checklist/2, virginia_vcdpa_decision_resolvable/1, virginia_vcdpa_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(m__us_virginia_vcdpa_kernel, [query_problems/3, value_or_absent/3]).
:- use_module(m__us_virginia_vcdpa_citations, [implements/1]).

statutory_figure(general_consumer_threshold, cite(us_va_code_59_1_576_a)).
statutory_figure(sale_consumer_threshold, cite(us_va_code_59_1_576_a)).
statutory_figure(response_period_days, cite(us_va_code_59_1_577_b_1)).
statutory_figure(response_period_days, cite(us_va_code_59_1_577_b_2)).
statutory_figure(extension_period_days, cite(us_va_code_59_1_577_b_1)).
statutory_figure(appeal_period_days, cite(us_va_code_59_1_577_c)).
statutory_figure(cure_period_days, cite(us_va_code_59_1_584_b)).
statutory_figure(civil_penalty_per_violation_dollars, cite(us_va_code_59_1_584_c)).

exempt_category(public_body_of_the_commonwealth, cite(us_va_code_59_1_576_b)).
exempt_category(financial_institution_subject_to_glba, cite(us_va_code_59_1_576_b)).
exempt_category(hipaa_covered_entity_or_business_associate, cite(us_va_code_59_1_576_b)).
exempt_category(nonprofit_organization, cite(us_va_code_59_1_576_b)).
exempt_category(institution_of_higher_education, cite(us_va_code_59_1_576_b)).

virginia_vcdpa_status_values([in_scope, out_of_scope, exempt_entity]).

in_scope.

out_of_scope.

exempt_entity.

no_extension_available.

notice_not_yet_provided.

cure_period_running.

action_may_be_initiated.

no_action_for_cured_violation.

days_after(StartDate, PeriodDays, EndDate) :-
    timedelta(PeriodDays, 0, PeriodDelta),
    date_add(StartDate, PeriodDelta, EndDate).

applicability_status(Profile, input_problems([Problem|Problems]), []) :-
    query_problems(Profile, [], [Problem|Problems]).
applicability_status(Profile, Result, Citations) :-
    query_problems(Profile, [], []),
    value_or_absent(Profile, entity_category, Category),
    entity_route(Category, Profile, Result, Citations).

entity_route(absent, _, indeterminate([entity_category]), []) :-
    implements(us_va_code_59_1_576_b).
entity_route(Category, _, exempt_entity, [cite(us_va_code_59_1_576_b)]) :-
    implements(us_va_code_59_1_576_b),
    implements(us_va_code_59_1_575_nonprofit_organization),
    implements(us_va_code_59_1_575_institution_of_higher_education),
    exempt_category(Category, _).
entity_route(none_of_the_exempt_categories, Profile, Result, Citations) :-
    implements(us_va_code_59_1_576_a),
    implements(us_va_code_59_1_575_consumer),
    implements(us_va_code_59_1_575_personal_data),
    implements(us_va_code_59_1_575_sale_of_personal_data),
    value_or_absent(Profile, conducts_business_in_or_targets_virginia, BusinessLink),
    value_or_absent(Profile, consumer_count, ConsumerCount),
    value_or_absent(Profile, over_half_of_gross_revenue_from_sale, OverHalf),
    count_band(ConsumerCount, CountBand),
    threshold_status(CountBand, OverHalf, ThresholdStatus),
    business_route(BusinessLink, ThresholdStatus, Result, Citations).

count_band(absent, count_absent).
count_band(ConsumerCount, below_sale_threshold) :-
    implements(us_va_code_59_1_576_a),
    integer(ConsumerCount),
    ConsumerCount #< 25000.
count_band(ConsumerCount, sale_threshold_band) :-
    implements(us_va_code_59_1_576_a),
    integer(ConsumerCount),
    ConsumerCount #>= 25000,
    ConsumerCount #< 100000.
count_band(ConsumerCount, general_threshold_met) :-
    implements(us_va_code_59_1_576_a),
    integer(ConsumerCount),
    ConsumerCount #>= 100000.

threshold_status(count_absent, _, missing(consumer_count)) :-
    implements(us_va_code_59_1_576_a).
threshold_status(below_sale_threshold, _, unmet) :-
    implements(us_va_code_59_1_576_a).
threshold_status(sale_threshold_band, false, unmet) :-
    implements(us_va_code_59_1_576_a).
threshold_status(sale_threshold_band, true, met) :-
    implements(us_va_code_59_1_576_a).
threshold_status(sale_threshold_band, absent, missing(over_half_of_gross_revenue_from_sale)) :-
    implements(us_va_code_59_1_576_a).
threshold_status(general_threshold_met, _, met) :-
    implements(us_va_code_59_1_576_a).

business_route(false, _, out_of_scope, [cite(us_va_code_59_1_576_a)]) :-
    implements(us_va_code_59_1_576_a).
business_route(BusinessLink, unmet, out_of_scope, [cite(us_va_code_59_1_576_a)]) :-
    implements(us_va_code_59_1_576_a),
    dif(BusinessLink, false).
business_route(absent, ThresholdStatus, indeterminate([conducts_business_in_or_targets_virginia]), []) :-
    implements(us_va_code_59_1_576_a),
    dif(ThresholdStatus, unmet).
business_route(true, missing(MissingKey), indeterminate([MissingKey]), []) :-
    implements(us_va_code_59_1_576_a).
business_route(unsure, missing(MissingKey), indeterminate([MissingKey]), []) :-
    implements(us_va_code_59_1_576_a).
business_route(unsure, met, needs_legal_review(open_textured(conducts_business_in_or_targets_virginia, cite(us_va_code_59_1_576_a)), [inputs_relied_on([conducts_business_in_or_targets_virginia - unsure])]), []) :-
    implements(us_va_code_59_1_576_a).
business_route(true, met, in_scope, [cite(us_va_code_59_1_576_a)]) :-
    implements(us_va_code_59_1_576_a).

response_deadline(Profile, ReceivedDate, input_problems([Problem|Problems]), []) :-
    query_problems(Profile, [received_date - ReceivedDate], [Problem|Problems]).
response_deadline(Profile, ReceivedDate, DeadlineDate, [cite(us_va_code_59_1_577_b_1), cite(us_va_code_59_1_577_b_2)]) :-
    implements(us_va_code_59_1_577_b_2),
    query_problems(Profile, [received_date - ReceivedDate], []),
    response_period_last_day(ReceivedDate, DeadlineDate).

response_period_last_day(ReceivedDate, DeadlineDate) :-
    implements(us_va_code_59_1_577_b),
    implements(us_va_code_59_1_577_b_1),
    PeriodDays #= 45,
    days_after(ReceivedDate, PeriodDays, DeadlineDate).

extended_response_deadline(Profile, ReceivedDate, input_problems([Problem|Problems]), []) :-
    query_problems(Profile, [received_date - ReceivedDate], [Problem|Problems]).
extended_response_deadline(Profile, ReceivedDate, DeadlineDate, Citations) :-
    query_problems(Profile, [received_date - ReceivedDate], []),
    value_or_absent(Profile, extension_reasonably_necessary, Necessary),
    value_or_absent(Profile, extension_notice_given_within_initial_period, NoticeGiven),
    extension_route(Necessary, NoticeGiven, ReceivedDate, DeadlineDate, Citations).

extension_route(_, false, _, no_extension_available, [cite(us_va_code_59_1_577_b_1)]) :-
    implements(us_va_code_59_1_577_b_1).
extension_route(false, NoticeGiven, _, no_extension_available, [cite(us_va_code_59_1_577_b_1)]) :-
    implements(us_va_code_59_1_577_b_1),
    dif(NoticeGiven, false).
extension_route(absent, NoticeGiven, _, indeterminate([extension_reasonably_necessary]), []) :-
    implements(us_va_code_59_1_577_b_1),
    dif(NoticeGiven, false).
extension_route(true, absent, _, indeterminate([extension_notice_given_within_initial_period]), []) :-
    implements(us_va_code_59_1_577_b_1).
extension_route(unsure, absent, _, indeterminate([extension_notice_given_within_initial_period]), []) :-
    implements(us_va_code_59_1_577_b_1).
extension_route(unsure, true, _, needs_legal_review(open_textured(extension_reasonably_necessary, cite(us_va_code_59_1_577_b_1)), [inputs_relied_on([extension_reasonably_necessary - unsure])]), []) :-
    implements(us_va_code_59_1_577_b_1).
extension_route(true, true, ReceivedDate, DeadlineDate, [cite(us_va_code_59_1_577_b_1)]) :-
    implements(us_va_code_59_1_577_b_1),
    extended_period_last_day(ReceivedDate, DeadlineDate).

extended_period_last_day(ReceivedDate, DeadlineDate) :-
    implements(us_va_code_59_1_577_b_1),
    PeriodDays #= 45 + 45,
    days_after(ReceivedDate, PeriodDays, DeadlineDate).

appeal_response_deadline(Profile, AppealReceivedDate, input_problems([Problem|Problems]), []) :-
    query_problems(Profile, [appeal_received_date - AppealReceivedDate], [Problem|Problems]).
appeal_response_deadline(Profile, AppealReceivedDate, DeadlineDate, [cite(us_va_code_59_1_577_c)]) :-
    implements(us_va_code_59_1_577_c),
    query_problems(Profile, [appeal_received_date - AppealReceivedDate], []),
    appeal_period_last_day(AppealReceivedDate, DeadlineDate).

appeal_period_last_day(AppealReceivedDate, DeadlineDate) :-
    implements(us_va_code_59_1_577_c),
    PeriodDays #= 60,
    days_after(AppealReceivedDate, PeriodDays, DeadlineDate).

cure_period_last_day(Profile, NoticeDate, input_problems([Problem|Problems]), []) :-
    query_problems(Profile, [notice_date - NoticeDate], [Problem|Problems]).
cure_period_last_day(Profile, NoticeDate, LastDay, [cite(us_va_code_59_1_584_b)]) :-
    implements(us_va_code_59_1_584_b),
    query_problems(Profile, [notice_date - NoticeDate], []),
    cure_period_end(NoticeDate, LastDay).

cure_period_end(NoticeDate, LastDay) :-
    implements(us_va_code_59_1_584_b),
    PeriodDays #= 30,
    days_after(NoticeDate, PeriodDays, LastDay).

attorney_general_action_status(Profile, NoticeDate, ReferenceDate, input_problems([Problem|Problems]), []) :-
    query_problems(Profile, [notice_date - NoticeDate, reference_date - ReferenceDate], [Problem|Problems]).
attorney_general_action_status(Profile, NoticeDate, ReferenceDate, Result, Citations) :-
    query_problems(Profile, [notice_date - NoticeDate, reference_date - ReferenceDate], []),
    cure_period_end(NoticeDate, LastDay),
    period_position(NoticeDate, LastDay, ReferenceDate, Position),
    action_route(Position, Profile, Result, Citations).

period_position(NoticeDate, _, ReferenceDate, before_notice) :-
    implements(us_va_code_59_1_584_b),
    ReferenceDate @< NoticeDate.
period_position(NoticeDate, LastDay, ReferenceDate, within_cure_period) :-
    implements(us_va_code_59_1_584_b),
    ReferenceDate @>= NoticeDate,
    ReferenceDate @=< LastDay.
period_position(_, LastDay, ReferenceDate, after_cure_period) :-
    implements(us_va_code_59_1_584_b),
    ReferenceDate @> LastDay.

action_route(before_notice, _, notice_not_yet_provided, [cite(us_va_code_59_1_584_b)]) :-
    implements(us_va_code_59_1_584_b).
action_route(within_cure_period, _, cure_period_running, [cite(us_va_code_59_1_584_b)]) :-
    implements(us_va_code_59_1_584_b).
action_route(after_cure_period, Profile, Result, Citations) :-
    implements(us_va_code_59_1_584_c),
    value_or_absent(Profile, cured_with_express_written_statement, Cured),
    value_or_absent(Profile, continued_violation_or_statement_breached, Continued),
    after_cure_route(Cured, Continued, Result, Citations).

after_cure_route(false, _, action_may_be_initiated, [cite(us_va_code_59_1_584_b), cite(us_va_code_59_1_584_c)]) :-
    implements(us_va_code_59_1_584_c).
after_cure_route(Cured, true, action_may_be_initiated, [cite(us_va_code_59_1_584_b), cite(us_va_code_59_1_584_c)]) :-
    implements(us_va_code_59_1_584_c),
    dif(Cured, false).
after_cure_route(absent, Continued, indeterminate([cured_with_express_written_statement]), []) :-
    implements(us_va_code_59_1_584_b),
    dif(Continued, true).
after_cure_route(true, absent, indeterminate([continued_violation_or_statement_breached]), []) :-
    implements(us_va_code_59_1_584_c).
after_cure_route(true, false, no_action_for_cured_violation, [cite(us_va_code_59_1_584_b)]) :-
    implements(us_va_code_59_1_584_b).

civil_penalty_maximum(Profile, input_problems([Problem|Problems]), []) :-
    query_problems(Profile, [], [Problem|Problems]).
civil_penalty_maximum(Profile, Maximum, Citations) :-
    query_problems(Profile, [], []),
    value_or_absent(Profile, violation_count, ViolationCount),
    penalty_route(ViolationCount, Maximum, Citations).

penalty_route(absent, indeterminate([violation_count]), []) :-
    implements(us_va_code_59_1_584_c).
penalty_route(ViolationCount, MaximumDollars, [cite(us_va_code_59_1_584_c)]) :-
    implements(us_va_code_59_1_584_c),
    integer(ViolationCount),
    MaximumDollars #= ViolationCount * 7500.

decide_virginia_vcdpa(Profile, virginia_vcdpa_verdict(Status, Citations)) :-
    applicability_status(Profile, Status, Citations).

virginia_vcdpa_status(Profile, Status) :-
    decide_virginia_vcdpa(Profile, virginia_vcdpa_verdict(Status, _Citations)).

virginia_vcdpa_decision_resolvable(Profile) :-
    decide_virginia_vcdpa(Profile, _Verdict).

virginia_vcdpa_checklist(Profile, []) :-
    query_problems(Profile, [], [_|_]).
virginia_vcdpa_checklist(Profile, [ExemptionItem, BusinessItem, ThresholdItem]) :-
    query_problems(Profile, [], []),
    value_or_absent(Profile, entity_category, Category),
    value_or_absent(Profile, conducts_business_in_or_targets_virginia, BusinessLink),
    value_or_absent(Profile, consumer_count, ConsumerCount),
    value_or_absent(Profile, over_half_of_gross_revenue_from_sale, OverHalf),
    exemption_item(Category, ExemptionItem),
    business_item(BusinessLink, BusinessItem),
    count_band(ConsumerCount, CountBand),
    threshold_status(CountBand, OverHalf, ThresholdStatus),
    threshold_item(ThresholdStatus, ThresholdItem).

exemption_item(absent, item(not_an_exempt_person, unknown([entity_category]), cite(us_va_code_59_1_576_b))) :-
    implements(us_va_code_59_1_576_b).
exemption_item(Category, item(not_an_exempt_person, unmet(exempt_category(Category)), cite(us_va_code_59_1_576_b))) :-
    implements(us_va_code_59_1_576_b),
    exempt_category(Category, _).
exemption_item(none_of_the_exempt_categories, item(not_an_exempt_person, met, cite(us_va_code_59_1_576_b))) :-
    implements(us_va_code_59_1_576_b).

business_item(true, item(business_link_to_virginia, met, cite(us_va_code_59_1_576_a))) :-
    implements(us_va_code_59_1_576_a).
business_item(false, item(business_link_to_virginia, unmet(no_business_link), cite(us_va_code_59_1_576_a))) :-
    implements(us_va_code_59_1_576_a).
business_item(unsure, item(business_link_to_virginia, unknown([conducts_business_in_or_targets_virginia]), cite(us_va_code_59_1_576_a))) :-
    implements(us_va_code_59_1_576_a).
business_item(absent, item(business_link_to_virginia, unknown([conducts_business_in_or_targets_virginia]), cite(us_va_code_59_1_576_a))) :-
    implements(us_va_code_59_1_576_a).

threshold_item(met, item(consumer_threshold, met, cite(us_va_code_59_1_576_a))) :-
    implements(us_va_code_59_1_576_a).
threshold_item(unmet, item(consumer_threshold, unmet(below_consumer_threshold), cite(us_va_code_59_1_576_a))) :-
    implements(us_va_code_59_1_576_a).
threshold_item(missing(MissingKey), item(consumer_threshold, unknown([MissingKey]), cite(us_va_code_59_1_576_a))) :-
    implements(us_va_code_59_1_576_a).

test(an_exempt_category_decides_alone) :-
    findall(Result - Citations, applicability_status([attribute(entity_category, nonprofit_organization), attribute(consumer_count, 5)], Result, Citations), Answers),
    Answers == [exempt_entity - [cite(us_va_code_59_1_576_b)]].
test(entity_category_is_asked_first) :-
    findall(Result, applicability_status([], Result, []), Results),
    Results == [indeterminate([entity_category])].
test(exactly_one_hundred_thousand_is_in_scope) :-
    findall(Result - Citations, applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 100000)], Result, Citations), Answers),
    Answers == [in_scope - [cite(us_va_code_59_1_576_a)]].
test(exactly_twenty_five_thousand_with_revenue_is_in_scope) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 25000), attribute(over_half_of_gross_revenue_from_sale, true)], in_scope, _).
test(middle_band_without_revenue_names_revenue) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 99999)], indeterminate([over_half_of_gross_revenue_from_sale]), []).
test(a_small_count_is_out_of_scope_even_when_unsure) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, unsure), attribute(consumer_count, 24999)], out_of_scope, [cite(us_va_code_59_1_576_a)]).
test(an_absent_count_is_named_not_the_revenue) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true)], indeterminate([consumer_count]), []).
test(an_absent_business_link_is_named_first) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories)], indeterminate([conducts_business_in_or_targets_virginia]), []).
test(an_unsure_business_link_goes_to_a_lawyer) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, unsure), attribute(consumer_count, 200000)], needs_legal_review(open_textured(conducts_business_in_or_targets_virginia, cite(us_va_code_59_1_576_a)), [inputs_relied_on([conducts_business_in_or_targets_virginia - unsure])]), []).
test(input_problems_come_first) :-
    applicability_status([attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(response_deadline_is_forty_five_days_later) :-
    findall(Deadline, response_deadline([], date(2026, 1, 1), Deadline, _), Deadlines),
    length(Deadlines, 1),
    response_deadline([], date(2026, 1, 1), date(2026, 2, 15), [cite(us_va_code_59_1_577_b_1), cite(us_va_code_59_1_577_b_2)]).
test(an_unreal_date_is_a_problem) :-
    response_deadline([], date(2026, 2, 30), input_problems([wrong_type(received_date)]), []).
test(extension_gives_ninety_days) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), date(2026, 4, 1), [cite(us_va_code_59_1_577_b_1)]).
test(late_notice_means_no_extension) :-
    extended_response_deadline([attribute(extension_notice_given_within_initial_period, false)], date(2026, 1, 1), no_extension_available, [cite(us_va_code_59_1_577_b_1)]).
test(unsure_need_with_absent_notice_names_the_notice) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, unsure)], date(2026, 1, 1), indeterminate([extension_notice_given_within_initial_period]), []).
test(appeal_deadline_is_sixty_days_later) :-
    appeal_response_deadline([], date(2026, 1, 1), date(2026, 3, 2), [cite(us_va_code_59_1_577_c)]).
test(cure_period_ends_thirty_days_later) :-
    cure_period_last_day([], date(2026, 1, 1), date(2026, 1, 31), [cite(us_va_code_59_1_584_b)]).
test(the_last_day_of_the_cure_period_is_running) :-
    attorney_general_action_status([], date(2026, 1, 1), date(2026, 1, 31), cure_period_running, [cite(us_va_code_59_1_584_b)]).
test(before_the_notice_no_notice_is_provided) :-
    attorney_general_action_status([], date(2026, 1, 10), date(2026, 1, 9), notice_not_yet_provided, _).
test(after_the_cure_period_an_uncured_violation_allows_action) :-
    findall(Result, attorney_general_action_status([attribute(cured_with_express_written_statement, false)], date(2026, 1, 1), date(2026, 2, 1), Result, _), Results),
    Results == [action_may_be_initiated].
test(after_the_cure_period_a_cured_violation_bars_action) :-
    attorney_general_action_status([attribute(cured_with_express_written_statement, true), attribute(continued_violation_or_statement_breached, false)], date(2026, 1, 1), date(2026, 2, 1), no_action_for_cured_violation, [cite(us_va_code_59_1_584_b)]).
test(after_the_cure_period_absent_facts_name_the_cure) :-
    attorney_general_action_status([], date(2026, 1, 1), date(2026, 2, 1), indeterminate([cured_with_express_written_statement]), []).
test(penalty_is_seven_thousand_five_hundred_each) :-
    civil_penalty_maximum([attribute(violation_count, 3)], Maximum, [cite(us_va_code_59_1_584_c)]),
    Maximum =:= 22500.
test(zero_violations_give_zero) :-
    civil_penalty_maximum([attribute(violation_count, 0)], Maximum, _),
    Maximum =:= 0.
test(penalty_needs_the_count) :-
    civil_penalty_maximum([], indeterminate([violation_count]), []).
test(checklist_has_three_rows) :-
    virginia_vcdpa_checklist([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 100000)], Items),
    length(Items, 3).

test(middle_band_without_revenue_is_not_in_scope, fail) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(consumer_count, 99999)], in_scope, _).
test(late_notice_gives_no_date, fail) :-
    extended_response_deadline([attribute(extension_notice_given_within_initial_period, false)], date(2026, 1, 1), date(2026, 4, 1), _).
