% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_virginia_vcdpa_queries, [virginia_vcdpa_profile_keys/1, virginia_vcdpa_what_if/4, virginia_vcdpa_applicability_threshold/3, virginia_vcdpa_consumer_count_boundary/2, entity_category/0, conducts_business_in_or_targets_virginia/0, consumer_count/0, over_half_of_gross_revenue_from_sale/0, extension_reasonably_necessary/0, extension_notice_given_within_initial_period/0, cured_with_express_written_statement/0, continued_violation_or_statement_breached/0, violation_count/0, public_body_of_the_commonwealth/0, financial_institution_subject_to_glba/0, hipaa_covered_entity_or_business_associate/0, nonprofit_organization/0, institution_of_higher_education/0, none_of_the_exempt_categories/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [(=)/3]).
:- use_module(library(clpz)).
:- use_module(library(reif), [if_/3]).
:- use_module(m__us_virginia_vcdpa_kernel, [virginia_vcdpa_input_problems/2]).
:- use_module(m__us_virginia_vcdpa_virginia_vcdpa, [virginia_vcdpa_status/2, applicability_status/3, response_deadline/4, extended_response_deadline/4, appeal_response_deadline/4, cure_period_last_day/4, civil_penalty_maximum/3]).
:- use_module(m__us_virginia_vcdpa_citations, [implements/1]).

entity_category.

conducts_business_in_or_targets_virginia.

consumer_count.

over_half_of_gross_revenue_from_sale.

extension_reasonably_necessary.

extension_notice_given_within_initial_period.

cured_with_express_written_statement.

continued_violation_or_statement_breached.

violation_count.

public_body_of_the_commonwealth.

financial_institution_subject_to_glba.

hipaa_covered_entity_or_business_associate.

nonprofit_organization.

institution_of_higher_education.

none_of_the_exempt_categories.

unsure.

virginia_vcdpa_profile_keys([entity_category, conducts_business_in_or_targets_virginia, consumer_count, over_half_of_gross_revenue_from_sale, extension_reasonably_necessary, extension_notice_given_within_initial_period, cured_with_express_written_statement, continued_violation_or_statement_breached, violation_count]).

answer_shape(response_deadline/4, 'a date(Y, M, D) term of three bare integers (see INTERFACE - THE ANSWER SHAPES)', date_term).
answer_shape(extended_response_deadline/4, 'a date(Y, M, D) term of three bare integers (see INTERFACE - THE ANSWER SHAPES)', date_term).
answer_shape(appeal_response_deadline/4, 'a date(Y, M, D) term of three bare integers (see INTERFACE - THE ANSWER SHAPES)', date_term).
answer_shape(cure_period_last_day/4, 'a date(Y, M, D) term of three bare integers (see INTERFACE - THE ANSWER SHAPES)', date_term).
answer_shape(civil_penalty_maximum/3, 'a non-negative integer, whole US dollars (see INTERFACE - THE ANSWER SHAPES)', whole_dollars).

shaped_answer(date_term, date(Year, Month, Day)) :-
    integer(Year),
    integer(Month),
    integer(Day).
shaped_answer(whole_dollars, Dollars) :-
    integer(Dollars),
    Dollars #>= 0.

final_answer(response_deadline/4, Deadline) :-
    response_deadline([], date(2026, 1, 1), Deadline, _Citations).
final_answer(extended_response_deadline/4, Deadline) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), Deadline, _Citations).
final_answer(appeal_response_deadline/4, Deadline) :-
    appeal_response_deadline([], date(2026, 1, 1), Deadline, _Citations).
final_answer(cure_period_last_day/4, LastDay) :-
    cure_period_last_day([], date(2026, 1, 1), LastDay, _Citations).
final_answer(civil_penalty_maximum/3, Maximum) :-
    civil_penalty_maximum([attribute(violation_count, 2)], Maximum, _Citations).

answer_has_pinned_shape(Query) :-
    answer_shape(Query, _Description, Kind),
    final_answer(Query, Answer),
    shaped_answer(Kind, Answer).

virginia_vcdpa_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    virginia_vcdpa_status(Hypothesis, NewStatus).

attribute_override(Profile, Key, Value, [attribute(Key, Value)|OtherAttributes]) :-
    without_key(Profile, Key, OtherAttributes).

virginia_vcdpa_applicability_threshold(general_threshold, MinimumConsumerCount, cite(us_va_code_59_1_576_a)) :-
    implements(us_va_code_59_1_576_a),
    SearchCeiling #= 1000000,
    consumer_count_flip([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(over_half_of_gross_revenue_from_sale, false)], 0, SearchCeiling, MinimumConsumerCount).
virginia_vcdpa_applicability_threshold(sale_of_personal_data_threshold, MinimumConsumerCount, cite(us_va_code_59_1_576_a)) :-
    implements(us_va_code_59_1_576_a),
    SearchCeiling #= 1000000,
    consumer_count_flip([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(over_half_of_gross_revenue_from_sale, true)], 0, SearchCeiling, MinimumConsumerCount).

virginia_vcdpa_consumer_count_boundary(Profile, input_problems([Problem|Problems])) :-
    virginia_vcdpa_input_problems(Profile, [Problem|Problems]).
virginia_vcdpa_consumer_count_boundary(Profile, Boundary) :-
    implements(us_va_code_59_1_576_a),
    virginia_vcdpa_input_problems(Profile, []),
    SearchCeiling #= 1000000,
    consumer_count_flip(Profile, 0, SearchCeiling, Boundary).

consumer_count_flip(Profile, Low, High, Boundary) :-
    count_status(Profile, Low, LowStatus),
    count_status(Profile, High, HighStatus),
    flip_result(LowStatus, HighStatus, Profile, Low, High, Boundary).

flip_result(Status, Status, _, _, _, no_flip_in_range).
flip_result(LowStatus, HighStatus, Profile, Low, High, Boundary) :-
    dif(LowStatus, HighStatus),
    bisect_count(Profile, LowStatus, Low, High, Boundary).

bisect_count(_, _, Low, High, High) :-
    High #= Low + 1.
bisect_count(Profile, LowStatus, Low, High, Boundary) :-
    High #> Low + 1,
    Middle #= (Low + High) // 2,
    count_status(Profile, Middle, MiddleStatus),
    if_(MiddleStatus = LowStatus, bisect_count(Profile, LowStatus, Middle, High, Boundary), bisect_count(Profile, LowStatus, Low, Middle, Boundary)).

count_status(Profile, ConsumerCount, Status) :-
    without_key(Profile, consumer_count, OtherAttributes),
    applicability_status([attribute(consumer_count, ConsumerCount)|OtherAttributes], Status, _Citations).

without_key([], _, []).
without_key([attribute(ElementKey, _)|Elements], Key, Rest) :-
    ElementKey == Key,
    without_key(Elements, Key, Rest).
without_key([attribute(ElementKey, Value)|Elements], Key, [attribute(ElementKey, Value)|Rest]) :-
    ElementKey \== Key,
    without_key(Elements, Key, Rest).

test(the_general_threshold_is_derived) :-
    findall(Minimum, virginia_vcdpa_applicability_threshold(general_threshold, Minimum, _), Minimums),
    Minimums = [Found],
    Found =:= 100000.
test(the_sale_threshold_is_derived) :-
    virginia_vcdpa_applicability_threshold(sale_of_personal_data_threshold, Minimum, cite(us_va_code_59_1_576_a)),
    Minimum =:= 25000.
test(an_exempt_profile_never_flips) :-
    virginia_vcdpa_consumer_count_boundary([attribute(entity_category, nonprofit_organization)], no_flip_in_range).
test(a_malformed_profile_has_no_boundary) :-
    virginia_vcdpa_consumer_count_boundary([attribute(colour, red)], input_problems([unknown_key(colour)])).
test(the_override_replaces_the_key) :-
    attribute_override([attribute(consumer_count, 5), attribute(violation_count, 1)], consumer_count, 7, Hypothesis),
    Hypothesis == [attribute(consumer_count, 7), attribute(violation_count, 1)].
test(the_root_atoms_are_callable) :-
    entity_category,
    unsure,
    none_of_the_exempt_categories.
test(every_date_and_figure_answer_has_its_pinned_shape) :-
    findall(Query, answer_shape(Query, _, _), Queries),
    length(Queries, 5),
    maplist(answer_has_pinned_shape, Queries).

test(an_indeterminate_answer_is_not_a_date_term, fail) :-
    shaped_answer(date_term, indeterminate([violation_count])).
