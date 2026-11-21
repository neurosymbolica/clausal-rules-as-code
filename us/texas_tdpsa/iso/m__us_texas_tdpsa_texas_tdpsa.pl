% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_texas_tdpsa_texas_tdpsa, [applicability_status/4, response_deadline/4, extended_response_deadline/4, appeal_response_deadline/4, cure_period_last_day/4, attorney_general_action_status/5, civil_penalty_maximum/3, decide_texas_tdpsa/2, texas_tdpsa_status/2, texas_tdpsa_checklist/2, texas_tdpsa_decision_resolvable/1, texas_tdpsa_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__us_texas_tdpsa_kernel, [texas_tdpsa_input_problems/2]).
:- use_module(m__us_texas_tdpsa_citations, [implements/1]).

excluded_category(state_agency_or_political_subdivision, cite(us_tx_bc_541_002_b_1)).
excluded_category(financial_institution, cite(us_tx_bc_541_002_b_2)).
excluded_category(covered_entity_or_business_associate_under_hipaa, cite(us_tx_bc_541_002_b_3)).
excluded_category(nonprofit_organization, cite(us_tx_bc_541_002_b_4)).
excluded_category(institution_of_higher_education, cite(us_tx_bc_541_002_b_5)).
excluded_category(electric_utility_power_generation_company_or_retail_electric_provider, cite(us_tx_bc_541_002_b_6)).

applicability_citations([cite(us_tx_bc_541_002_a), cite(us_tx_bc_541_002_a_1), cite(us_tx_bc_541_002_a_2), cite(us_tx_bc_541_002_a_3), cite(us_tx_bc_541_002_b), cite(us_tx_bc_541_002_b_1), cite(us_tx_bc_541_002_b_2), cite(us_tx_bc_541_002_b_3), cite(us_tx_bc_541_002_b_4), cite(us_tx_bc_541_002_b_5), cite(us_tx_bc_541_002_b_6)]).

texas_tdpsa_status_values([in_scope, out_of_scope]).

key_reading(Profile, ProfileKey, Value) :-
    profile_get(Profile, ProfileKey, Value).
key_reading(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).

first_absent([], none).
first_absent([absent - ProfileKey|_], found(ProfileKey)).
first_absent([Value - _|RestPairs], Result) :-
    dif(Value, absent),
    first_absent(RestPairs, Result).

value_equals_t(Value, Wanted, true) :-
    Value == Wanted.
value_equals_t(Value, Wanted, false) :-
    Value \== Wanted.

truth_or(true, _, true).
truth_or(false, Truth, Truth).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

date_t(Term, false) :-
    var(Term).
date_t(Term, Truth) :-
    nonvar(Term),
    Term = date(YearNumber, MonthNumber, DayNumber),
    date_parts_t(YearNumber, MonthNumber, DayNumber, Truth).
date_t(Term, false) :-
    nonvar(Term),
    Term \= date(_, _, _).

date_parts_t(YearNumber, MonthNumber, DayNumber, Truth) :-
    integer_part_t(YearNumber, YearInteger),
    integer_part_t(MonthNumber, MonthInteger),
    integer_part_t(DayNumber, DayInteger),
    truth_and(YearInteger, MonthInteger, YearMonthIntegers),
    truth_and(YearMonthIntegers, DayInteger, AllIntegers),
    calendar_day_t(AllIntegers, YearNumber, MonthNumber, DayNumber, Truth).

integer_part_t(Part, false) :-
    var(Part).
integer_part_t(Part, true) :-
    integer(Part).
integer_part_t(Part, false) :-
    float(Part).
integer_part_t(Part, false) :-
    atom(Part).
integer_part_t(Part, false) :-
    compound(Part).

calendar_day_t(false, _, _, _, false).
calendar_day_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    range_t(YearNumber, 1, 9999, YearInRange),
    range_t(MonthNumber, 1, 12, MonthInRange),
    truth_and(YearInRange, MonthInRange, YearMonthInRange),
    day_in_month_t(YearMonthInRange, YearNumber, MonthNumber, DayNumber, Truth).

day_in_month_t(false, _, _, _, false).
day_in_month_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    month_last_day(YearNumber, MonthNumber, LastDayNumber),
    range_t(DayNumber, 1, LastDayNumber, Truth).

range_t(Number, Lowest, Highest, true) :-
    Number >= Lowest,
    Number =< Highest.
range_t(Number, Lowest, _, false) :-
    Number < Lowest.
range_t(Number, Lowest, Highest, false) :-
    Number >= Lowest,
    Number > Highest.

date_problems(Argument, Name, Problems) :-
    date_t(Argument, IsDate),
    date_problem_list(IsDate, Name, Problems).

date_problem_list(true, _, []).
date_problem_list(false, Name, [wrong_type(Name)]).

add_calendar_days(StartDate, PeriodDays, EndDate) :-
    timedelta(PeriodDays, 0, Period),
    date_add(StartDate, Period, EndDate).

response_last_day(ReceivedDate, LastDay) :-
    implements(us_tx_bc_541_052_b),
    PeriodDays #= 45,
    add_calendar_days(ReceivedDate, PeriodDays, LastDay).

extended_last_day(ReceivedDate, LastDay) :-
    implements(us_tx_bc_541_052_b),
    PeriodDays #= 45 + 45,
    add_calendar_days(ReceivedDate, PeriodDays, LastDay).

appeal_last_day(AppealReceivedDate, LastDay) :-
    implements(us_tx_bc_541_053_c),
    PeriodDays #= 60,
    add_calendar_days(AppealReceivedDate, PeriodDays, LastDay).

cure_last_day(NoticeDate, LastDay) :-
    implements(us_tx_bc_541_154_1),
    PeriodDays #= 30,
    add_calendar_days(NoticeDate, PeriodDays, LastDay).

applicability_status(Profile, Result, Basis, Citations) :-
    texas_tdpsa_input_problems(Profile, Problems),
    applicability_after_check(Problems, Profile, Result, Basis, Citations).

applicability_after_check([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
applicability_after_check([], Profile, Result, Basis, Citations) :-
    key_reading(Profile, entity_category, Entity),
    key_reading(Profile, processes_or_sells_personal_data, Processes),
    key_reading(Profile, conducts_business_in_texas_or_serves_texas_residents, Conducts),
    key_reading(Profile, small_business_as_defined_by_sba, Attestation),
    small_business_state(Attestation, SmallState),
    exclusion_t(Entity, Processes, Conducts, Excluded),
    first_absent([Entity - entity_category, Processes - processes_or_sells_personal_data, Conducts - conducts_business_in_texas_or_serves_texas_residents], FirstAbsent),
    applicability_answer(SmallState, Excluded, FirstAbsent, Conducts, Attestation, Result, Basis, Citations).

small_business_state(absent, absent).
small_business_state(attested(true, _), small) :-
    implements(us_tx_bc_541_002_a_3).
small_business_state(attested(false, _), not_small) :-
    implements(us_tx_bc_541_002_a_3).

exclusion_t(Entity, Processes, Conducts, Excluded) :-
    implements(us_tx_bc_541_002_b),
    entity_excluded_t(Entity, EntityExcluded),
    condition_failed_t(Processes, ProcessesFailed),
    condition_failed_t(Conducts, ConductsFailed),
    truth_or(EntityExcluded, ProcessesFailed, FirstExcluded),
    truth_or(FirstExcluded, ConductsFailed, Excluded).

entity_excluded_t(absent, false).
entity_excluded_t(none_of_the_excluded_categories, false) :-
    implements(us_tx_bc_541_002_b).
entity_excluded_t(Category, true) :-
    implements(us_tx_bc_541_002_b),
    excluded_category(Category, _).

condition_failed_t(false, true) :-
    implements(us_tx_bc_541_002_a).
condition_failed_t(true, false) :-
    implements(us_tx_bc_541_002_a).
condition_failed_t(unsure, false).
condition_failed_t(absent, false).

applicability_answer(small, _, _, _, Attestation, out_of_scope, [outside_fact(small_business_as_defined_by_sba, Attestation)], Citations) :-
    implements(us_tx_bc_541_002_a_3),
    applicability_citations(Citations).
applicability_answer(SmallState, true, _, _, _, out_of_scope, [], Citations) :-
    implements(us_tx_bc_541_002_b),
    dif(SmallState, small),
    applicability_citations(Citations).
applicability_answer(SmallState, false, found(MissingKey), _, _, indeterminate([MissingKey]), [], []) :-
    implements(us_tx_bc_541_002_a),
    dif(SmallState, small).
applicability_answer(absent, false, none, _, _, needs_legal_review(cross_reference_unresolved(cite(us_tx_bc_541_002_a_3), cite(sba_small_business_size_determination)), [resolution(cite(sba_small_business_size_determination), not_attempted), inputs_relied_on([small_business_as_defined_by_sba - absent])]), [], []) :-
    implements(us_tx_bc_541_002_a_3).
applicability_answer(not_small, false, none, unsure, _, needs_legal_review(open_textured(conducts_business_in_texas_or_serves_texas_residents, cite(us_tx_bc_541_002_a_1)), [inputs_relied_on([conducts_business_in_texas_or_serves_texas_residents - unsure])]), [], []) :-
    implements(us_tx_bc_541_002_a_1).
applicability_answer(not_small, false, none, true, Attestation, in_scope, [outside_fact(small_business_as_defined_by_sba, Attestation)], Citations) :-
    implements(us_tx_bc_541_002_a),
    applicability_citations(Citations).

response_deadline(Profile, ReceivedDate, Result, Citations) :-
    texas_tdpsa_input_problems(Profile, ProfileProblems),
    date_problems(ReceivedDate, received_date, DateProblems),
    append(ProfileProblems, DateProblems, Problems),
    response_after_check(Problems, ReceivedDate, Result, Citations).

response_after_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
response_after_check([], ReceivedDate, LastDay, [cite(us_tx_bc_541_052_b), cite(us_tx_bc_541_052_c)]) :-
    implements(us_tx_bc_541_052_c),
    response_last_day(ReceivedDate, LastDay).

extended_response_deadline(Profile, ReceivedDate, Result, Citations) :-
    texas_tdpsa_input_problems(Profile, ProfileProblems),
    date_problems(ReceivedDate, received_date, DateProblems),
    append(ProfileProblems, DateProblems, Problems),
    extension_after_check(Problems, Profile, ReceivedDate, Result, Citations).

extension_after_check([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
extension_after_check([], Profile, ReceivedDate, Result, Citations) :-
    key_reading(Profile, extension_reasonably_necessary, Necessity),
    key_reading(Profile, extension_notice_given_within_initial_period, Notice),
    extension_blocked_t(Necessity, Notice, Blocked),
    first_absent([Necessity - extension_reasonably_necessary, Notice - extension_notice_given_within_initial_period], FirstAbsent),
    extension_answer(Blocked, FirstAbsent, Necessity, ReceivedDate, Result, Citations).

extension_blocked_t(Necessity, Notice, Blocked) :-
    implements(us_tx_bc_541_052_b),
    value_equals_t(Necessity, false, NecessityFalse),
    value_equals_t(Notice, false, NoticeFalse),
    truth_or(NecessityFalse, NoticeFalse, Blocked).

extension_answer(true, _, _, _, no_extension_available, [cite(us_tx_bc_541_052_b)]) :-
    implements(us_tx_bc_541_052_b).
extension_answer(false, found(MissingKey), _, _, indeterminate([MissingKey]), []) :-
    implements(us_tx_bc_541_052_b).
extension_answer(false, none, unsure, _, needs_legal_review(open_textured(extension_reasonably_necessary, cite(us_tx_bc_541_052_b)), [inputs_relied_on([extension_reasonably_necessary - unsure])]), []) :-
    implements(us_tx_bc_541_052_b).
extension_answer(false, none, true, ReceivedDate, LastDay, [cite(us_tx_bc_541_052_b)]) :-
    implements(us_tx_bc_541_052_b),
    extended_last_day(ReceivedDate, LastDay).

appeal_response_deadline(Profile, AppealReceivedDate, Result, Citations) :-
    texas_tdpsa_input_problems(Profile, ProfileProblems),
    date_problems(AppealReceivedDate, appeal_received_date, DateProblems),
    append(ProfileProblems, DateProblems, Problems),
    appeal_after_check(Problems, AppealReceivedDate, Result, Citations).

appeal_after_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
appeal_after_check([], AppealReceivedDate, LastDay, [cite(us_tx_bc_541_053_c)]) :-
    implements(us_tx_bc_541_053_c),
    appeal_last_day(AppealReceivedDate, LastDay).

cure_period_last_day(Profile, NoticeDate, Result, Citations) :-
    texas_tdpsa_input_problems(Profile, ProfileProblems),
    date_problems(NoticeDate, notice_date, DateProblems),
    append(ProfileProblems, DateProblems, Problems),
    cure_after_check(Problems, NoticeDate, Result, Citations).

cure_after_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
cure_after_check([], NoticeDate, LastDay, [cite(us_tx_bc_541_154), cite(us_tx_bc_541_154_1)]) :-
    implements(us_tx_bc_541_154),
    cure_last_day(NoticeDate, LastDay).

attorney_general_action_status(Profile, NoticeDate, ReferenceDate, Result, Citations) :-
    texas_tdpsa_input_problems(Profile, ProfileProblems),
    action_date_problems(NoticeDate, ReferenceDate, DateProblems),
    append(ProfileProblems, DateProblems, Problems),
    action_after_check(Problems, Profile, NoticeDate, ReferenceDate, Result, Citations).

action_date_problems(NoticeDate, ReferenceDate, Problems) :-
    date_t(NoticeDate, NoticeIsDate),
    date_t(ReferenceDate, ReferenceIsDate),
    action_date_problem_list(NoticeIsDate, ReferenceIsDate, NoticeDate, ReferenceDate, Problems).

action_date_problem_list(false, false, _, _, [wrong_type(notice_date), wrong_type(reference_date)]).
action_date_problem_list(false, true, _, _, [wrong_type(notice_date)]).
action_date_problem_list(true, false, _, _, [wrong_type(reference_date)]).
action_date_problem_list(true, true, NoticeDate, ReferenceDate, Problems) :-
    days_between(ReferenceDate, NoticeDate, OffsetDays),
    reference_order_problems(OffsetDays, Problems).

reference_order_problems(OffsetDays, [wrong_type(reference_date)]) :-
    implements(us_tx_bc_541_154),
    OffsetDays #< 0.
reference_order_problems(OffsetDays, []) :-
    implements(us_tx_bc_541_154),
    OffsetDays #>= 0.

action_after_check([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).
action_after_check([], Profile, NoticeDate, ReferenceDate, Result, Citations) :-
    cure_last_day(NoticeDate, LastDay),
    days_between(ReferenceDate, LastDay, ElapsedDays),
    cure_period_phase(ElapsedDays, Phase),
    action_answer(Phase, Profile, Result, Citations).

cure_period_phase(ElapsedDays, running) :-
    implements(us_tx_bc_541_154_1),
    ElapsedDays #< 1.
cure_period_phase(ElapsedDays, passed) :-
    implements(us_tx_bc_541_154_1),
    ElapsedDays #> 0.

action_answer(running, _, cure_period_running, [cite(us_tx_bc_541_154)]) :-
    implements(us_tx_bc_541_154).
action_answer(passed, Profile, Result, Citations) :-
    implements(us_tx_bc_541_154),
    key_reading(Profile, cured_within_cure_period, Cured),
    key_reading(Profile, written_statement_provided, Statement),
    key_reading(Profile, written_statement_breached, Breached),
    bar_lifted_t(Cured, Statement, Breached, Lifted),
    first_absent([Cured - cured_within_cure_period, Statement - written_statement_provided, Breached - written_statement_breached], FirstAbsent),
    cure_answer(Lifted, FirstAbsent, Result, Citations).

bar_lifted_t(Cured, Statement, Breached, Lifted) :-
    implements(us_tx_bc_541_154_2),
    value_equals_t(Cured, false, CureMissing),
    value_equals_t(Statement, false, StatementMissing),
    value_equals_t(Breached, true, StatementBreached),
    truth_or(CureMissing, StatementMissing, FirstLifted),
    truth_or(FirstLifted, StatementBreached, Lifted).

cure_answer(true, _, action_may_be_brought, [cite(us_tx_bc_541_154), cite(us_tx_bc_541_154_1), cite(us_tx_bc_541_154_2), cite(us_tx_bc_541_154_2_a), cite(us_tx_bc_541_154_2_b), cite(us_tx_bc_541_154_2_c), cite(us_tx_bc_541_154_2_d), cite(us_tx_bc_541_155_a)]) :-
    implements(us_tx_bc_541_155_a).
cure_answer(false, found(MissingKey), indeterminate([MissingKey]), []) :-
    implements(us_tx_bc_541_154).
cure_answer(false, none, no_action_for_cured_violation, [cite(us_tx_bc_541_154), cite(us_tx_bc_541_154_1), cite(us_tx_bc_541_154_2), cite(us_tx_bc_541_154_2_a), cite(us_tx_bc_541_154_2_b), cite(us_tx_bc_541_154_2_c), cite(us_tx_bc_541_154_2_d)]) :-
    implements(us_tx_bc_541_154_2).

civil_penalty_maximum(Profile, Result, Citations) :-
    texas_tdpsa_input_problems(Profile, Problems),
    penalty_after_check(Problems, Profile, Result, Citations).

penalty_after_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
penalty_after_check([], Profile, Result, Citations) :-
    key_reading(Profile, violation_after_cure_period_or_statement_breach, Violation),
    key_reading(Profile, violation_count, ViolationCount),
    penalty_answer(Violation, ViolationCount, Result, Citations).

penalty_answer(false, _, no_civil_penalty, [cite(us_tx_bc_541_155_a)]) :-
    implements(us_tx_bc_541_155_a).
penalty_answer(absent, _, indeterminate([violation_after_cure_period_or_statement_breach]), []) :-
    implements(us_tx_bc_541_155_a).
penalty_answer(true, absent, indeterminate([violation_count]), []) :-
    implements(us_tx_bc_541_155_a).
penalty_answer(true, ViolationCount, MaximumDollars, [cite(us_tx_bc_541_155_a)]) :-
    implements(us_tx_bc_541_155_a),
    integer(ViolationCount),
    MaximumDollars #= 7500 * ViolationCount.

decide_texas_tdpsa(Profile, texas_tdpsa_verdict(Status, Citations)) :-
    applicability_status(Profile, Status, _, Citations).

texas_tdpsa_status(Profile, Status) :-
    decide_texas_tdpsa(Profile, texas_tdpsa_verdict(Status, _)).

texas_tdpsa_decision_resolvable(Profile) :-
    decide_texas_tdpsa(Profile, _).

texas_tdpsa_checklist(Profile, Checklist) :-
    texas_tdpsa_input_problems(Profile, Problems),
    checklist_after_check(Problems, Profile, Checklist).

checklist_after_check([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(us_tx_bc_541_002_a))]).
checklist_after_check([], Profile, [EntityItem, ProcessesItem, ConductsItem, SmallItem]) :-
    key_reading(Profile, entity_category, Entity),
    key_reading(Profile, processes_or_sells_personal_data, Processes),
    key_reading(Profile, conducts_business_in_texas_or_serves_texas_residents, Conducts),
    key_reading(Profile, small_business_as_defined_by_sba, Attestation),
    entity_item(Entity, EntityItem),
    condition_item(Processes, processes_or_sells_personal_data, cite(us_tx_bc_541_002_a_2), ProcessesItem),
    condition_item(Conducts, conducts_business_in_texas_or_serves_texas_residents, cite(us_tx_bc_541_002_a_1), ConductsItem),
    small_business_item(Attestation, SmallItem).

entity_item(none_of_the_excluded_categories, item(not_an_excluded_kind_of_person, met, cite(us_tx_bc_541_002_b))) :-
    implements(us_tx_bc_541_002_b).
entity_item(absent, item(not_an_excluded_kind_of_person, unknown([entity_category]), cite(us_tx_bc_541_002_b))).
entity_item(Category, item(not_an_excluded_kind_of_person, unmet(excluded_category(Category)), Citation)) :-
    implements(us_tx_bc_541_002_b),
    excluded_category(Category, Citation).

condition_item(true, ProfileKey, Citation, item(ProfileKey, met, Citation)) :-
    implements(us_tx_bc_541_002_a).
condition_item(false, ProfileKey, Citation, item(ProfileKey, unmet(condition_not_met), Citation)) :-
    implements(us_tx_bc_541_002_a).
condition_item(unsure, ProfileKey, Citation, item(ProfileKey, unknown([ProfileKey]), Citation)).
condition_item(absent, ProfileKey, Citation, item(ProfileKey, unknown([ProfileKey]), Citation)).

small_business_item(absent, item(not_a_small_business, unknown([small_business_as_defined_by_sba]), cite(us_tx_bc_541_002_a_3))).
small_business_item(attested(false, _), item(not_a_small_business, met, cite(us_tx_bc_541_002_a_3))) :-
    implements(us_tx_bc_541_002_a_3).
small_business_item(attested(true, _), item(not_a_small_business, unmet(small_business), cite(us_tx_bc_541_002_a_3))) :-
    implements(us_tx_bc_541_002_a_3).

test_attested(Value, attested(Value, attestation(host_user, host_time, size_review, none))).

test_scope_profile(Conducts, Attestation, [attribute(entity_category, none_of_the_excluded_categories), attribute(processes_or_sells_personal_data, true), attribute(conducts_business_in_texas_or_serves_texas_residents, Conducts), attribute(small_business_as_defined_by_sba, Attestation)]).

test(in_scope_with_its_basis_once) :-
    test_attested(false, Attested),
    test_scope_profile(true, Attested, Profile),
    findall(Result - Basis, applicability_status(Profile, Result, Basis, _), Answers),
    Answers == [in_scope - [outside_fact(small_business_as_defined_by_sba, Attested)]].
test(in_scope_carries_eleven_citations) :-
    test_attested(false, Attested),
    test_scope_profile(true, Attested, Profile),
    applicability_status(Profile, in_scope, _, Citations),
    length(Citations, 11).
test(attested_small_business_is_out_of_scope_with_basis) :-
    test_attested(true, Attested),
    findall(Result - Basis, applicability_status([attribute(entity_category, nonprofit_organization), attribute(small_business_as_defined_by_sba, Attested)], Result, Basis, _), Answers),
    Answers == [out_of_scope - [outside_fact(small_business_as_defined_by_sba, Attested)]].
test(nonprofit_is_out_of_scope_without_basis) :-
    findall(Result - Basis, applicability_status([attribute(entity_category, nonprofit_organization)], Result, Basis, _), Answers),
    Answers == [out_of_scope - []].
test(empty_profile_names_entity_category) :-
    findall(Result, applicability_status([], Result, _, _), Answers),
    Answers == [indeterminate([entity_category])].
test(absent_attestation_is_referred) :-
    findall(Result, applicability_status([attribute(entity_category, none_of_the_excluded_categories), attribute(processes_or_sells_personal_data, true), attribute(conducts_business_in_texas_or_serves_texas_residents, unsure)], Result, _, _), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(us_tx_bc_541_002_a_3), cite(sba_small_business_size_determination)), [resolution(cite(sba_small_business_size_determination), not_attempted), inputs_relied_on([small_business_as_defined_by_sba - absent])])].
test(unsure_business_goes_to_a_lawyer) :-
    test_attested(false, Attested),
    test_scope_profile(unsure, Attested, Profile),
    findall(Result, applicability_status(Profile, Result, _, _), Answers),
    Answers == [needs_legal_review(open_textured(conducts_business_in_texas_or_serves_texas_residents, cite(us_tx_bc_541_002_a_1)), [inputs_relied_on([conducts_business_in_texas_or_serves_texas_residents - unsure])])].
test(not_a_list_is_an_input_problem) :-
    findall(Result - Basis - Citations, applicability_status(not_a_profile, Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - [] - []].
test(response_deadline_is_forty_five_days_later) :-
    findall(Result, response_deadline([], date(2026, 1, 1), Result, _), [date(2026, 2, 15)]).
test(response_deadline_in_a_leap_year) :-
    response_deadline([], date(2024, 2, 29), date(2024, 4, 14), _).
test(response_deadline_refuses_february_29_of_2026) :-
    findall(Result, response_deadline([], date(2026, 2, 29), Result, _), Answers),
    Answers == [input_problems([wrong_type(received_date)])].
test(response_deadline_refuses_month_thirteen) :-
    response_deadline([], date(2026, 13, 1), input_problems([wrong_type(received_date)]), []).
test(response_deadline_refuses_an_unbound_date) :-
    response_deadline([], _, input_problems([wrong_type(received_date)]), []).
test(extended_deadline_is_ninety_days_later) :-
    findall(Result, extended_response_deadline([attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), Result, _), [date(2026, 4, 1)]).
test(late_notice_gives_no_extension) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, unsure), attribute(extension_notice_given_within_initial_period, false)], date(2026, 1, 1), no_extension_available, [cite(us_tx_bc_541_052_b)]).
test(missing_notice_named_while_necessity_unsure) :-
    findall(Result, extended_response_deadline([attribute(extension_reasonably_necessary, unsure)], date(2026, 1, 1), Result, _), Answers),
    Answers == [indeterminate([extension_notice_given_within_initial_period])].
test(unsure_necessity_goes_to_a_lawyer) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, unsure), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), needs_legal_review(open_textured(extension_reasonably_necessary, cite(us_tx_bc_541_052_b)), [inputs_relied_on([extension_reasonably_necessary - unsure])]), []).
test(appeal_deadline_is_sixty_days_later) :-
    findall(Result, appeal_response_deadline([], date(2026, 1, 1), Result, _), [date(2026, 3, 2)]).
test(cure_period_ends_thirty_days_after_notice) :-
    findall(Result, cure_period_last_day([], date(2026, 3, 1), Result, _), [date(2026, 3, 31)]).
test(cure_period_running_on_its_last_day) :-
    findall(Result, attorney_general_action_status([], date(2026, 3, 1), date(2026, 3, 31), Result, _), Answers),
    Answers == [cure_period_running].
test(after_cure_period_a_missing_key_is_named) :-
    findall(Result, attorney_general_action_status([], date(2026, 3, 1), date(2026, 4, 1), Result, _), Answers),
    Answers == [indeterminate([cured_within_cure_period])].
test(uncured_violation_allows_the_action) :-
    attorney_general_action_status([attribute(cured_within_cure_period, false)], date(2026, 3, 1), date(2026, 4, 1), action_may_be_brought, Citations),
    length(Citations, 8).
test(breached_statement_allows_the_action) :-
    attorney_general_action_status([attribute(cured_within_cure_period, true), attribute(written_statement_provided, true), attribute(written_statement_breached, true)], date(2026, 3, 1), date(2026, 5, 1), action_may_be_brought, _).
test(cured_violation_bars_the_action) :-
    findall(Result, attorney_general_action_status([attribute(cured_within_cure_period, true), attribute(written_statement_provided, true), attribute(written_statement_breached, false)], date(2026, 3, 1), date(2026, 4, 1), Result, _), Answers),
    Answers == [no_action_for_cured_violation].
test(reference_before_notice_is_an_input_problem) :-
    findall(Result - Citations, attorney_general_action_status([], date(2026, 3, 1), date(2026, 2, 28), Result, Citations), Answers),
    Answers == [input_problems([wrong_type(reference_date)]) - []].
test(both_bad_dates_are_named_in_order) :-
    attorney_general_action_status([], bad, date(2026, 2, 30), input_problems([wrong_type(notice_date), wrong_type(reference_date)]), []).
test(no_ground_gives_no_civil_penalty) :-
    civil_penalty_maximum([attribute(violation_after_cure_period_or_statement_breach, false)], no_civil_penalty, [cite(us_tx_bc_541_155_a)]).
test(missing_ground_is_named_before_the_count) :-
    findall(Result, civil_penalty_maximum([], Result, _), Answers),
    Answers == [indeterminate([violation_after_cure_period_or_statement_breach])].
test(missing_count_is_named) :-
    civil_penalty_maximum([attribute(violation_after_cure_period_or_statement_breach, true)], indeterminate([violation_count]), []).
test(three_violations_cap_at_22500_dollars) :-
    findall(Result, civil_penalty_maximum([attribute(violation_after_cure_period_or_statement_breach, true), attribute(violation_count, 3)], Result, _), Answers),
    Answers == [22500].
test(zero_violations_cap_at_zero) :-
    civil_penalty_maximum([attribute(violation_after_cure_period_or_statement_breach, true), attribute(violation_count, 0)], 0, [cite(us_tx_bc_541_155_a)]).
test(unknown_key_is_an_input_problem) :-
    civil_penalty_maximum([attribute(colour, blue)], input_problems([unknown_key(colour)]), []).
test(checklist_carries_four_cited_rows) :-
    test_attested(false, Attested),
    test_scope_profile(true, Attested, Profile),
    texas_tdpsa_checklist(Profile, Checklist),
    Checklist == [item(not_an_excluded_kind_of_person, met, cite(us_tx_bc_541_002_b)), item(processes_or_sells_personal_data, met, cite(us_tx_bc_541_002_a_2)), item(conducts_business_in_texas_or_serves_texas_residents, met, cite(us_tx_bc_541_002_a_1)), item(not_a_small_business, met, cite(us_tx_bc_541_002_a_3))].
test(facade_status_projects_applicability) :-
    findall(Status, texas_tdpsa_status([attribute(entity_category, financial_institution)], Status), Statuses),
    Statuses == [out_of_scope].

test(in_scope_is_not_out_of_scope, fail) :-
    test_attested(false, Attested),
    test_scope_profile(true, Attested, Profile),
    applicability_status(Profile, out_of_scope, _, _).
test(late_notice_gives_no_date, fail) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, false)], date(2026, 1, 1), date(_, _, _), _).
test(cured_violation_does_not_allow_the_action, fail) :-
    attorney_general_action_status([attribute(cured_within_cure_period, true), attribute(written_statement_provided, true), attribute(written_statement_breached, false)], date(2026, 3, 1), date(2026, 4, 1), action_may_be_brought, _).
