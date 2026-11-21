% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_cra_manufacturer_duties, [requirements_applicability/4, support_period_minimum/4, retention_end_date/5, decide_cra_manufacturer_duties/2, cra_manufacturer_duties_status/2, cra_manufacturer_duties_checklist/2, cra_manufacturer_duties_decision_resolvable/1, cra_manufacturer_duties_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_cra_manufacturer_duties_kernel, [cra_manufacturer_duties_input_problems/2, date_earlier/2, date_not_earlier/2, date_later_of/3]).
:- use_module(m__eu_cra_manufacturer_duties_citations, [implements/1]).

application_date(article_14, date(2026, 9, 11), cite(eu_reg_2024_2847_art_71_2)).
application_date(regulation, date(2027, 12, 11), cite(eu_reg_2024_2847_art_71_2)).

support_period_floor(60, cite(eu_reg_2024_2847_art_13_8)).

availability_period(technical_documentation_and_declaration_of_conformity, placing_on_market_date, 10, cite(eu_reg_2024_2847_art_13_13)).
availability_period(information_and_instructions_to_the_user, placing_on_market_date, 10, cite(eu_reg_2024_2847_art_13_18)).
availability_period(security_update, security_update_issue_date, 10, cite(eu_reg_2024_2847_art_13_9)).

referral(product_may_be_substantially_modified_on_or_after_application_date, open_textured, substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2), [substantially_modified_on_or_after_application_date]).

cra_manufacturer_duties_status_values([subject_to_requirements, article_14_only, not_yet_applicable, minimum_support_period, keep_until, not_applicable_outside_support_period, indeterminate, needs_legal_review, input_problems]).

query_problems(Profile, AssessmentDate, Problems) :-
    cra_manufacturer_duties_input_problems(Profile, ProfileProblems),
    assessment_date_problems(AssessmentDate, DateProblems),
    append(ProfileProblems, DateProblems, Problems).

retention_problems(Profile, AssessmentDate, RetentionItem, Problems) :-
    query_problems(Profile, AssessmentDate, QueryProblems),
    item_problems(RetentionItem, ItemProblems),
    append(QueryProblems, ItemProblems, Problems).

assessment_date_problems(AssessmentDate, Problems) :-
    cra_manufacturer_duties_input_problems([attribute(placing_on_market_date, AssessmentDate)], ProbeProblems),
    argument_problems(ProbeProblems, assessment_date, Problems).

argument_problems([], _, []).
argument_problems([_|_], Argument, [wrong_type(Argument)]).

item_problems(RetentionItem, [wrong_type(item)]) :-
    var(RetentionItem).
item_problems(RetentionItem, Problems) :-
    nonvar(RetentionItem),
    memberd_t(RetentionItem, [technical_documentation_and_declaration_of_conformity, information_and_instructions_to_the_user, security_update], IsKnownItem),
    known_item_problems(IsKnownItem, Problems).

known_item_problems(true, []).
known_item_problems(false, [wrong_type(item)]).

requirements_applicability(Profile, AssessmentDate, Verdict, Citations) :-
    query_problems(Profile, AssessmentDate, Problems),
    applicability_answer(Problems, Profile, AssessmentDate, Verdict, Citations).

applicability_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
applicability_answer([], Profile, AssessmentDate, Verdict, Citations) :-
    applicability_route(Profile, AssessmentDate, Verdict, Citations).

applicability_route(_, AssessmentDate, not_yet_applicable, [Citation]) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(article_14, Article14Date, Citation),
    date_earlier(AssessmentDate, Article14Date).
applicability_route(_, AssessmentDate, article_14_only, [Citation]) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(article_14, Article14Date, Citation),
    application_date(regulation, RegulationDate, _),
    date_not_earlier(AssessmentDate, Article14Date),
    date_earlier(AssessmentDate, RegulationDate).
applicability_route(Profile, AssessmentDate, Verdict, Citations) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(regulation, RegulationDate, _),
    date_not_earlier(AssessmentDate, RegulationDate),
    placing_route(Profile, Verdict, Citations).

placing_route(Profile, indeterminate([placing_on_market_date]), []) :-
    profile_lacks(Profile, placing_on_market_date).
placing_route(Profile, subject_to_requirements, [Citation]) :-
    implements(eu_reg_2024_2847_art_71_2),
    implements(eu_reg_2024_2847_art_3_21),
    profile_has(Profile, placing_on_market_date),
    profile_get(Profile, placing_on_market_date, PlacingDate),
    application_date(regulation, RegulationDate, Citation),
    date_not_earlier(PlacingDate, RegulationDate).
placing_route(Profile, Verdict, Citations) :-
    implements(eu_reg_2024_2847_art_69_2),
    implements(eu_reg_2024_2847_art_3_21),
    profile_has(Profile, placing_on_market_date),
    profile_get(Profile, placing_on_market_date, PlacingDate),
    application_date(regulation, RegulationDate, _),
    date_earlier(PlacingDate, RegulationDate),
    modification_route(Profile, Verdict, Citations).

modification_route(Profile, indeterminate([substantially_modified_on_or_after_application_date]), []) :-
    profile_lacks(Profile, substantially_modified_on_or_after_application_date).
modification_route(Profile, subject_to_requirements, [cite(eu_reg_2024_2847_art_69_2)]) :-
    implements(eu_reg_2024_2847_art_69_2),
    implements(eu_reg_2024_2847_art_3_30),
    profile_has(Profile, substantially_modified_on_or_after_application_date),
    profile_get(Profile, substantially_modified_on_or_after_application_date, true).
modification_route(Profile, article_14_only, [cite(eu_reg_2024_2847_art_69_2), cite(eu_reg_2024_2847_art_69_3)]) :-
    implements(eu_reg_2024_2847_art_69_3),
    implements(eu_reg_2024_2847_art_3_30),
    profile_has(Profile, substantially_modified_on_or_after_application_date),
    profile_get(Profile, substantially_modified_on_or_after_application_date, false).
modification_route(Profile, needs_legal_review(open_textured(InputKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2024_2847_art_69_2),
    referral(product_may_be_substantially_modified_on_or_after_application_date, open_textured, InputKey, Citation, InputKeys),
    profile_has(Profile, InputKey),
    profile_get(Profile, InputKey, unsure),
    relied_pairs(Profile, InputKeys, Pairs).

relied_pairs(_, [], []).
relied_pairs(Profile, [InputKey|InputKeys], [InputKey - Value|Pairs]) :-
    profile_get(Profile, InputKey, Value),
    relied_pairs(Profile, InputKeys, Pairs).

support_period_minimum(Profile, AssessmentDate, Verdict, Citations) :-
    query_problems(Profile, AssessmentDate, Problems),
    support_answer(Problems, Profile, AssessmentDate, Verdict, Citations).

support_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
support_answer([], Profile, AssessmentDate, Verdict, Citations) :-
    support_route(Profile, AssessmentDate, Verdict, Citations).

support_route(_, AssessmentDate, not_yet_applicable, [Citation]) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(regulation, RegulationDate, Citation),
    date_earlier(AssessmentDate, RegulationDate).
support_route(Profile, AssessmentDate, Verdict, Citations) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(regulation, RegulationDate, _),
    date_not_earlier(AssessmentDate, RegulationDate),
    floor_route(Profile, Verdict, Citations).

floor_route(Profile, indeterminate([expected_use_time_in_months]), []) :-
    profile_lacks(Profile, expected_use_time_in_months).
floor_route(Profile, minimum_support_period(FloorMonths), [Citation]) :-
    implements(eu_reg_2024_2847_art_13_8),
    implements(eu_reg_2024_2847_art_3_20),
    profile_has(Profile, expected_use_time_in_months),
    profile_get(Profile, expected_use_time_in_months, ExpectedMonths),
    support_period_floor(FloorMonths, Citation),
    ExpectedMonths #>= FloorMonths.
floor_route(Profile, minimum_support_period(ExpectedMonths), [Citation]) :-
    implements(eu_reg_2024_2847_art_13_8),
    implements(eu_reg_2024_2847_art_3_20),
    profile_has(Profile, expected_use_time_in_months),
    profile_get(Profile, expected_use_time_in_months, ExpectedMonths),
    support_period_floor(FloorMonths, Citation),
    ExpectedMonths #< FloorMonths.

retention_end_date(Profile, AssessmentDate, RetentionItem, Verdict, Citations) :-
    retention_problems(Profile, AssessmentDate, RetentionItem, Problems),
    retention_answer(Problems, Profile, AssessmentDate, RetentionItem, Verdict, Citations).

retention_answer([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).
retention_answer([], Profile, AssessmentDate, RetentionItem, Verdict, Citations) :-
    retention_route(Profile, AssessmentDate, RetentionItem, Verdict, Citations).

retention_route(_, AssessmentDate, _, not_yet_applicable, [Citation]) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(regulation, RegulationDate, Citation),
    date_earlier(AssessmentDate, RegulationDate).
retention_route(Profile, AssessmentDate, RetentionItem, Verdict, Citations) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(regulation, RegulationDate, _),
    date_not_earlier(AssessmentDate, RegulationDate),
    availability_route(Profile, RetentionItem, Verdict, Citations).

availability_route(Profile, RetentionItem, indeterminate([StartKey]), []) :-
    availability_period(RetentionItem, StartKey, _, _),
    profile_lacks(Profile, StartKey).
availability_route(Profile, RetentionItem, indeterminate([support_period_end_date]), []) :-
    availability_period(RetentionItem, StartKey, _, _),
    profile_has(Profile, StartKey),
    profile_lacks(Profile, support_period_end_date).
availability_route(Profile, RetentionItem, Verdict, Citations) :-
    availability_period(RetentionItem, StartKey, PeriodYears, Citation),
    profile_has(Profile, StartKey),
    profile_has(Profile, support_period_end_date),
    profile_get(Profile, StartKey, StartDate),
    profile_get(Profile, support_period_end_date, SupportEndDate),
    coverage_route(RetentionItem, StartDate, SupportEndDate, PeriodYears, Citation, Verdict, Citations).

coverage_route(security_update, IssueDate, SupportEndDate, _, Citation, not_applicable_outside_support_period, [Citation]) :-
    implements(eu_reg_2024_2847_art_13_9),
    date_earlier(SupportEndDate, IssueDate).
coverage_route(security_update, IssueDate, SupportEndDate, PeriodYears, Citation, keep_until(KeepDate), [Citation]) :-
    implements(eu_reg_2024_2847_art_13_9),
    date_not_earlier(SupportEndDate, IssueDate),
    availability_end(IssueDate, PeriodYears, SupportEndDate, KeepDate).
coverage_route(RetentionItem, PlacingDate, SupportEndDate, PeriodYears, Citation, keep_until(KeepDate), [Citation]) :-
    implements(eu_reg_2024_2847_art_13_13),
    implements(eu_reg_2024_2847_art_13_18),
    dif(RetentionItem, security_update),
    availability_end(PlacingDate, PeriodYears, SupportEndDate, KeepDate).

availability_end(StartDate, PeriodYears, SupportEndDate, KeepDate) :-
    implements(eu_reg_2024_2847_art_13_13),
    implements(eu_reg_2024_2847_art_13_18),
    implements(eu_reg_2024_2847_art_13_9),
    implements(eu_reg_2024_2847_art_13_19),
    years_after(StartDate, PeriodYears, AnniversaryDate),
    date_later_of(AnniversaryDate, SupportEndDate, KeepDate).

years_after(date(StartYear, StartMonth, DayNumber), PeriodYears, date(LaterYear, StartMonth, DayNumber)) :-
    implements(eu_reg_2024_2847_art_13_13),
    StartMonth #< 2,
    LaterYear #= StartYear + PeriodYears.
years_after(date(StartYear, StartMonth, DayNumber), PeriodYears, date(LaterYear, StartMonth, DayNumber)) :-
    implements(eu_reg_2024_2847_art_13_13),
    StartMonth #> 2,
    LaterYear #= StartYear + PeriodYears.
years_after(date(StartYear, 2, DayNumber), PeriodYears, date(LaterYear, 2, DayNumber)) :-
    implements(eu_reg_2024_2847_art_13_13),
    DayNumber #< 29,
    LaterYear #= StartYear + PeriodYears.
years_after(date(StartYear, 2, 29), PeriodYears, date(LaterYear, 2, 28)) :-
    implements(eu_reg_2024_2847_art_13_13),
    LaterYear #= StartYear + PeriodYears.

decide_cra_manufacturer_duties(requirements_applicability(Profile, AssessmentDate), cra_manufacturer_duties_verdict(Verdict, Citations)) :-
    requirements_applicability(Profile, AssessmentDate, Verdict, Citations).
decide_cra_manufacturer_duties(support_period_minimum(Profile, AssessmentDate), cra_manufacturer_duties_verdict(Verdict, Citations)) :-
    support_period_minimum(Profile, AssessmentDate, Verdict, Citations).
decide_cra_manufacturer_duties(retention_end_date(Profile, AssessmentDate, RetentionItem), cra_manufacturer_duties_verdict(Verdict, Citations)) :-
    retention_end_date(Profile, AssessmentDate, RetentionItem, Verdict, Citations).

cra_manufacturer_duties_status(Request, Status) :-
    decide_cra_manufacturer_duties(Request, cra_manufacturer_duties_verdict(Verdict, _)),
    functor(Verdict, Status, _).

cra_manufacturer_duties_decision_resolvable(Request) :-
    decide_cra_manufacturer_duties(Request, _).

cra_manufacturer_duties_checklist(Request, Items) :-
    request_problems(Request, Problems),
    request_checklist(Problems, Request, Items).

request_problems(requirements_applicability(Profile, AssessmentDate), Problems) :-
    query_problems(Profile, AssessmentDate, Problems).
request_problems(support_period_minimum(Profile, AssessmentDate), Problems) :-
    query_problems(Profile, AssessmentDate, Problems).
request_problems(retention_end_date(Profile, AssessmentDate, RetentionItem), Problems) :-
    retention_problems(Profile, AssessmentDate, RetentionItem, Problems).

request_checklist([_|_], _, []).
request_checklist([], requirements_applicability(Profile, AssessmentDate), [Article14Row, RegulationRow, item(placed_on_market_on_or_after_application_date, PlacingStatus, cite(eu_reg_2024_2847_art_69_2)), item(substantially_modified_on_or_after_application_date, ModificationStatus, cite(eu_reg_2024_2847_art_69_2))]) :-
    date_gate_item(article_14_applies_at_assessment_date, article_14, AssessmentDate, Article14Row),
    date_gate_item(regulation_applies_at_assessment_date, regulation, AssessmentDate, RegulationRow),
    placing_status(Profile, PlacingStatus),
    modification_status(Profile, ModificationStatus).
request_checklist([], support_period_minimum(Profile, AssessmentDate), [RegulationRow, item(expected_use_time_at_least_five_years, FloorStatus, Citation)]) :-
    date_gate_item(regulation_applies_at_assessment_date, regulation, AssessmentDate, RegulationRow),
    support_period_floor(_, Citation),
    floor_status(Profile, FloorStatus).
request_checklist([], retention_end_date(Profile, AssessmentDate, RetentionItem), [RegulationRow, item(RetentionItem, AvailabilityStatus, Citation)]) :-
    date_gate_item(regulation_applies_at_assessment_date, regulation, AssessmentDate, RegulationRow),
    availability_period(RetentionItem, _, _, Citation),
    availability_route(Profile, RetentionItem, Verdict, _),
    availability_row_status(Verdict, AvailabilityStatus).

date_gate_item(RowName, Which, AssessmentDate, item(RowName, Status, Citation)) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_date(Which, GateDate, Citation),
    date_gate_status(AssessmentDate, GateDate, Status).

date_gate_status(AssessmentDate, GateDate, met) :-
    date_not_earlier(AssessmentDate, GateDate).
date_gate_status(AssessmentDate, GateDate, unmet(before_application_date)) :-
    date_earlier(AssessmentDate, GateDate).

placing_status(Profile, unknown([placing_on_market_date])) :-
    profile_lacks(Profile, placing_on_market_date).
placing_status(Profile, met) :-
    implements(eu_reg_2024_2847_art_3_21),
    profile_has(Profile, placing_on_market_date),
    profile_get(Profile, placing_on_market_date, PlacingDate),
    application_date(regulation, RegulationDate, _),
    date_not_earlier(PlacingDate, RegulationDate).
placing_status(Profile, unmet(placed_before_application_date)) :-
    implements(eu_reg_2024_2847_art_3_21),
    profile_has(Profile, placing_on_market_date),
    profile_get(Profile, placing_on_market_date, PlacingDate),
    application_date(regulation, RegulationDate, _),
    date_earlier(PlacingDate, RegulationDate).

modification_status(Profile, unknown([substantially_modified_on_or_after_application_date])) :-
    profile_lacks(Profile, substantially_modified_on_or_after_application_date).
modification_status(Profile, met) :-
    implements(eu_reg_2024_2847_art_3_30),
    profile_has(Profile, substantially_modified_on_or_after_application_date),
    profile_get(Profile, substantially_modified_on_or_after_application_date, true).
modification_status(Profile, unmet(not_substantially_modified)) :-
    implements(eu_reg_2024_2847_art_3_30),
    profile_has(Profile, substantially_modified_on_or_after_application_date),
    profile_get(Profile, substantially_modified_on_or_after_application_date, false).
modification_status(Profile, unknown([substantially_modified_on_or_after_application_date])) :-
    profile_has(Profile, substantially_modified_on_or_after_application_date),
    profile_get(Profile, substantially_modified_on_or_after_application_date, unsure).

floor_status(Profile, unknown([expected_use_time_in_months])) :-
    profile_lacks(Profile, expected_use_time_in_months).
floor_status(Profile, met) :-
    implements(eu_reg_2024_2847_art_13_8),
    profile_has(Profile, expected_use_time_in_months),
    profile_get(Profile, expected_use_time_in_months, ExpectedMonths),
    support_period_floor(FloorMonths, _),
    ExpectedMonths #>= FloorMonths.
floor_status(Profile, unmet(expected_use_time_below_five_years)) :-
    implements(eu_reg_2024_2847_art_13_8),
    profile_has(Profile, expected_use_time_in_months),
    profile_get(Profile, expected_use_time_in_months, ExpectedMonths),
    support_period_floor(FloorMonths, _),
    ExpectedMonths #< FloorMonths.

availability_row_status(keep_until(_), met).
availability_row_status(not_applicable_outside_support_period, unmet(issued_after_support_period)).
availability_row_status(indeterminate(MissingKeys), unknown(MissingKeys)).

test(before_article_14_nothing_applies) :-
    findall(Verdict - Citations, requirements_applicability([], date(2026, 9, 10), Verdict, Citations), Answers),
    Answers == [not_yet_applicable - [cite(eu_reg_2024_2847_art_71_2)]].
test(the_window_opens_with_article_14) :-
    findall(Verdict - Citations, requirements_applicability([], date(2026, 9, 11), Verdict, Citations), Answers),
    Answers == [article_14_only - [cite(eu_reg_2024_2847_art_71_2)]].
test(the_window_ignores_the_profile) :-
    findall(Verdict, requirements_applicability([attribute(placing_on_market_date, date(2028, 1, 1))], date(2027, 12, 10), Verdict, _), Verdicts),
    Verdicts == [article_14_only].
test(from_application_the_placing_date_is_asked) :-
    findall(Verdict - Citations, requirements_applicability([attribute(substantially_modified_on_or_after_application_date, true)], date(2027, 12, 11), Verdict, Citations), Answers),
    Answers == [indeterminate([placing_on_market_date]) - []].
test(placed_on_application_day_is_subject) :-
    findall(Verdict - Citations, requirements_applicability([attribute(placing_on_market_date, date(2027, 12, 11))], date(2028, 3, 1), Verdict, Citations), Answers),
    Answers == [subject_to_requirements - [cite(eu_reg_2024_2847_art_71_2)]].
test(placed_before_and_modified_is_subject) :-
    findall(Verdict - Citations, requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 1)), attribute(substantially_modified_on_or_after_application_date, true)], date(2028, 3, 1), Verdict, Citations), Answers),
    Answers == [subject_to_requirements - [cite(eu_reg_2024_2847_art_69_2)]].
test(placed_before_and_not_modified_is_article_14_only) :-
    findall(Verdict - Citations, requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 1)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1), Verdict, Citations), Answers),
    Answers == [article_14_only - [cite(eu_reg_2024_2847_art_69_2), cite(eu_reg_2024_2847_art_69_3)]].
test(placed_before_and_modification_absent_is_asked) :-
    findall(Verdict, requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 1))], date(2028, 3, 1), Verdict, _), Verdicts),
    Verdicts == [indeterminate([substantially_modified_on_or_after_application_date])].
test(an_unsure_modification_goes_to_a_lawyer) :-
    findall(Verdict - Citations, requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 1)), attribute(substantially_modified_on_or_after_application_date, unsure)], date(2028, 3, 1), Verdict, Citations), Answers),
    Answers == [needs_legal_review(open_textured(substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2)), [inputs_relied_on([substantially_modified_on_or_after_application_date - unsure])]) - []].
test(an_unknown_key_is_an_input_problem) :-
    findall(Verdict - Citations, requirements_applicability([attribute(colour, red)], date(2028, 3, 1), Verdict, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(an_impossible_assessment_date_is_wrong_type) :-
    findall(Verdict, requirements_applicability([], date(2027, 2, 30), Verdict, _), Verdicts),
    Verdicts == [input_problems([wrong_type(assessment_date)])].
test(an_unbound_assessment_date_follows_the_profile_problem) :-
    findall(Verdict, requirements_applicability(nonsense, _, Verdict, _), Verdicts),
    Verdicts == [input_problems([wrong_type(profile), wrong_type(assessment_date)])].
test(the_floor_is_not_yet_applicable_before_application) :-
    findall(Verdict - Citations, support_period_minimum([attribute(expected_use_time_in_months, 72)], date(2027, 12, 10), Verdict, Citations), Answers),
    Answers == [not_yet_applicable - [cite(eu_reg_2024_2847_art_71_2)]].
test(a_long_use_time_gives_sixty_months) :-
    findall(Verdict - Citations, support_period_minimum([attribute(expected_use_time_in_months, 72)], date(2027, 12, 11), Verdict, Citations), Answers),
    Answers == [minimum_support_period(60) - [cite(eu_reg_2024_2847_art_13_8)]].
test(exactly_sixty_months_gives_sixty) :-
    findall(Verdict, support_period_minimum([attribute(expected_use_time_in_months, 60)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts == [minimum_support_period(60)].
test(a_short_use_time_gives_the_use_time) :-
    findall(Verdict, support_period_minimum([attribute(expected_use_time_in_months, 36)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts == [minimum_support_period(36)].
test(an_absent_use_time_is_asked) :-
    findall(Verdict - Citations, support_period_minimum([], date(2028, 1, 1), Verdict, Citations), Answers),
    Answers == [indeterminate([expected_use_time_in_months]) - []].
test(a_fraction_use_time_is_wrong_type) :-
    findall(Verdict, support_period_minimum([attribute(expected_use_time_in_months, 73/2)], date(2028, 1, 1), Verdict, _), Verdicts),
    Verdicts == [input_problems([wrong_type(expected_use_time_in_months)])].
test(documentation_is_kept_ten_years_after_placing) :-
    findall(Verdict - Citations, retention_end_date([attribute(placing_on_market_date, date(2028, 1, 10)), attribute(support_period_end_date, date(2033, 1, 31))], date(2028, 2, 1), technical_documentation_and_declaration_of_conformity, Verdict, Citations), Answers),
    Answers == [keep_until(date(2038, 1, 10)) - [cite(eu_reg_2024_2847_art_13_13)]].
test(a_longer_support_period_wins) :-
    findall(Verdict - Citations, retention_end_date([attribute(placing_on_market_date, date(2028, 1, 10)), attribute(support_period_end_date, date(2040, 6, 30))], date(2028, 2, 1), information_and_instructions_to_the_user, Verdict, Citations), Answers),
    Answers == [keep_until(date(2040, 6, 30)) - [cite(eu_reg_2024_2847_art_13_18)]].
test(a_leap_day_moves_to_the_twenty_eighth) :-
    findall(Verdict, retention_end_date([attribute(placing_on_market_date, date(2028, 2, 29)), attribute(support_period_end_date, date(2030, 2, 28))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity, Verdict, _), Verdicts),
    Verdicts == [keep_until(date(2038, 2, 28))].
test(an_update_on_the_last_day_is_covered) :-
    findall(Verdict - Citations, retention_end_date([attribute(security_update_issue_date, date(2032, 5, 31)), attribute(support_period_end_date, date(2032, 5, 31))], date(2032, 6, 1), security_update, Verdict, Citations), Answers),
    Answers == [keep_until(date(2042, 5, 31)) - [cite(eu_reg_2024_2847_art_13_9)]].
test(an_update_after_the_support_period_is_outside) :-
    findall(Verdict - Citations, retention_end_date([attribute(security_update_issue_date, date(2032, 6, 1)), attribute(support_period_end_date, date(2032, 5, 31))], date(2032, 6, 2), security_update, Verdict, Citations), Answers),
    Answers == [not_applicable_outside_support_period - [cite(eu_reg_2024_2847_art_13_9)]].
test(the_start_key_is_asked_first) :-
    findall(Verdict, retention_end_date([], date(2028, 1, 1), security_update, Verdict, _), Verdicts),
    Verdicts == [indeterminate([security_update_issue_date])].
test(the_support_period_end_is_asked_next) :-
    findall(Verdict, retention_end_date([attribute(placing_on_market_date, date(2028, 1, 10))], date(2028, 2, 1), technical_documentation_and_declaration_of_conformity, Verdict, _), Verdicts),
    Verdicts == [indeterminate([support_period_end_date])].
test(retention_is_not_yet_applicable_before_application) :-
    findall(Verdict - Citations, retention_end_date([], date(2027, 1, 1), security_update, Verdict, Citations), Answers),
    Answers == [not_yet_applicable - [cite(eu_reg_2024_2847_art_71_2)]].
test(an_unknown_item_is_wrong_type) :-
    findall(Verdict, retention_end_date([], date(2028, 1, 1), manual, Verdict, _), Verdicts),
    Verdicts == [input_problems([wrong_type(item)])].
test(an_unbound_item_follows_the_date_problem) :-
    findall(Verdict, retention_end_date([], date(2027, 13, 1), _, Verdict, _), Verdicts),
    Verdicts == [input_problems([wrong_type(assessment_date), wrong_type(item)])].
test(the_status_is_the_verdict_name) :-
    findall(Status, cra_manufacturer_duties_status(support_period_minimum([attribute(expected_use_time_in_months, 72)], date(2028, 1, 1)), Status), Statuses),
    Statuses == [minimum_support_period].
test(the_checklist_cites_each_ground) :-
    findall(Items, cra_manufacturer_duties_checklist(requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 1)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1)), Items), Checklists),
    Checklists == [[item(article_14_applies_at_assessment_date, met, cite(eu_reg_2024_2847_art_71_2)), item(regulation_applies_at_assessment_date, met, cite(eu_reg_2024_2847_art_71_2)), item(placed_on_market_on_or_after_application_date, unmet(placed_before_application_date), cite(eu_reg_2024_2847_art_69_2)), item(substantially_modified_on_or_after_application_date, unmet(not_substantially_modified), cite(eu_reg_2024_2847_art_69_2))]].
test(a_request_with_problems_has_an_empty_checklist) :-
    cra_manufacturer_duties_checklist(support_period_minimum(nonsense, date(2028, 1, 1)), Items),
    Items == [].

test(the_window_is_not_subject_to_requirements, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2028, 1, 1))], date(2027, 12, 10), subject_to_requirements, _).
test(placed_before_and_not_modified_is_not_subject, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 1)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1), subject_to_requirements, _).
test(a_short_use_time_does_not_give_sixty, fail) :-
    support_period_minimum([attribute(expected_use_time_in_months, 36)], date(2028, 1, 1), minimum_support_period(60), _).
test(an_update_after_the_support_period_gets_no_date, fail) :-
    retention_end_date([attribute(security_update_issue_date, date(2032, 6, 1)), attribute(support_period_end_date, date(2032, 5, 31))], date(2032, 6, 2), security_update, keep_until(_), _).
