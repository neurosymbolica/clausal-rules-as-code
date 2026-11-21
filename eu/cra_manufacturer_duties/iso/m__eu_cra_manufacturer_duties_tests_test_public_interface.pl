% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_cra_manufacturer_duties_cra_manufacturer_duties, [decide_cra_manufacturer_duties/2, cra_manufacturer_duties_status/2, cra_manufacturer_duties_checklist/2, cra_manufacturer_duties_decision_resolvable/1, cra_manufacturer_duties_status_values/1]).
:- use_module(m__eu_cra_manufacturer_duties_fixtures, [cra_manufacturer_duties_subject/1, cra_manufacturer_duties_profile_for/2, cra_manufacturer_duties_assess/2]).

expected(before_article_14_date, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
expected(article_14_window_opens, article_14_only, [cite(eu_reg_2024_2847_art_71_2)]).
expected(article_14_window_last_day, article_14_only, [cite(eu_reg_2024_2847_art_71_2)]).
expected(missing_placing_date, indeterminate([placing_on_market_date]), []).
expected(placed_on_application_day, subject_to_requirements, [cite(eu_reg_2024_2847_art_71_2)]).
expected(placed_day_before_application_unmodified, article_14_only, [cite(eu_reg_2024_2847_art_69_2), cite(eu_reg_2024_2847_art_69_3)]).
expected(legacy_product_modified, subject_to_requirements, [cite(eu_reg_2024_2847_art_69_2)]).
expected(legacy_product_unmodified, article_14_only, [cite(eu_reg_2024_2847_art_69_2), cite(eu_reg_2024_2847_art_69_3)]).
expected(legacy_product_unsure, needs_legal_review(open_textured(substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2)), [inputs_relied_on([substantially_modified_on_or_after_application_date - unsure])]), []).
expected(legacy_product_judgement_missing, indeterminate([substantially_modified_on_or_after_application_date]), []).
expected(unknown_key_in_profile, input_problems([unknown_key(colour)]), []).
expected(duplicate_and_unknown_keys, input_problems([duplicate_key(placing_on_market_date), unknown_key(colour)]), []).
expected(impossible_assessment_date, input_problems([wrong_type(assessment_date)]), []).
expected(support_floor_day_before_application, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
expected(support_floor_on_application_day, minimum_support_period(60), [cite(eu_reg_2024_2847_art_13_8)]).
expected(long_lived_router, minimum_support_period(60), [cite(eu_reg_2024_2847_art_13_8)]).
expected(use_time_at_floor, minimum_support_period(60), [cite(eu_reg_2024_2847_art_13_8)]).
expected(use_time_just_below_floor, minimum_support_period(59), [cite(eu_reg_2024_2847_art_13_8)]).
expected(use_time_zero, minimum_support_period(0), [cite(eu_reg_2024_2847_art_13_8)]).
expected(missing_use_time, indeterminate([expected_use_time_in_months]), []).
expected(negative_use_time, input_problems([wrong_type(expected_use_time_in_months)]), []).
expected(retention_day_before_application, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
expected(documentation_ten_years_wins, keep_until(date(2038, 2, 1)), [cite(eu_reg_2024_2847_art_13_13)]).
expected(documentation_equal_dates, keep_until(date(2038, 2, 1)), [cite(eu_reg_2024_2847_art_13_13)]).
expected(documentation_support_period_one_day_longer, keep_until(date(2038, 2, 2)), [cite(eu_reg_2024_2847_art_13_13)]).
expected(instructions_support_period_wins, keep_until(date(2040, 6, 30)), [cite(eu_reg_2024_2847_art_13_18)]).
expected(instructions_ten_years_wins, keep_until(date(2038, 2, 1)), [cite(eu_reg_2024_2847_art_13_18)]).
expected(leap_day_update, keep_until(date(2038, 2, 28)), [cite(eu_reg_2024_2847_art_13_9)]).
expected(day_after_leap_day_update, keep_until(date(2038, 3, 1)), [cite(eu_reg_2024_2847_art_13_9)]).
expected(update_on_last_day, keep_until(date(2041, 1, 1)), [cite(eu_reg_2024_2847_art_13_9)]).
expected(update_day_after_last_day, not_applicable_outside_support_period, [cite(eu_reg_2024_2847_art_13_9)]).
expected(retention_missing_start, indeterminate([placing_on_market_date]), []).
expected(retention_missing_end, indeterminate([support_period_end_date]), []).
expected(unknown_item, input_problems([wrong_type(item)]), []).

resolves_to(Subject, ExpectedVerdict, ExpectedCitations) :-
    findall(Verdict - Citations, cra_manufacturer_duties_assess(Subject, cra_manufacturer_duties_verdict(Verdict, Citations)), Answers),
    Answers = [OnlyVerdict - OnlyCitations],
    OnlyVerdict == ExpectedVerdict,
    clausal_msort(OnlyCitations, SortedCitations),
    clausal_msort(ExpectedCitations, SortedExpectedCitations),
    SortedCitations == SortedExpectedCitations.

all_resolve([]).
all_resolve([Subject|Subjects]) :-
    expected(Subject, ExpectedVerdict, ExpectedCitations),
    resolves_to(Subject, ExpectedVerdict, ExpectedCitations),
    all_resolve(Subjects).

all_statuses_agree(_, []).
all_statuses_agree(StatusValues, [Subject|Subjects]) :-
    cra_manufacturer_duties_profile_for(Subject, Question),
    expected(Subject, ExpectedVerdict, _),
    functor(ExpectedVerdict, ExpectedStatus, _),
    findall(Status, cra_manufacturer_duties_status(Question, Status), Statuses),
    Statuses == [ExpectedStatus],
    member(ExpectedStatus, StatusValues),
    all_statuses_agree(StatusValues, Subjects).

all_checklists_agree([]).
all_checklists_agree([Subject|Subjects]) :-
    cra_manufacturer_duties_profile_for(Subject, Question),
    expected(Subject, ExpectedVerdict, _),
    findall(ChecklistItems, cra_manufacturer_duties_checklist(Question, ChecklistItems), Checklists),
    Checklists = [OnlyChecklist],
    checklist_shape(ExpectedVerdict, OnlyChecklist),
    cra_manufacturer_duties_decision_resolvable(Question),
    all_checklists_agree(Subjects).

checklist_shape(input_problems(_), []).
checklist_shape(ExpectedVerdict, [FirstItem|OtherItems]) :-
    functor(ExpectedVerdict, ExpectedStatus, _),
    dif(ExpectedStatus, input_problems),
    all_cited([FirstItem|OtherItems]).

all_cited([]).
all_cited([item(_, _, cite(CitationKey))|ChecklistItems]) :-
    atom(CitationKey),
    all_cited(ChecklistItems).

test(every_subject_has_exactly_one_expected_row) :-
    findall(Subject, cra_manufacturer_duties_subject(Subject), Subjects),
    findall(Subject, expected(Subject, _, _), ExpectedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ExpectedSubjects, SortedExpectedSubjects),
    SortedSubjects == SortedExpectedSubjects,
    sort(Subjects, UniqueSubjects),
    length(Subjects, SubjectCount),
    length(UniqueSubjects, SubjectCount).
test(every_subject_resolves_to_its_expected_verdict_once) :-
    findall(Subject, cra_manufacturer_duties_subject(Subject), Subjects),
    Subjects = [_|_],
    all_resolve(Subjects).
test(every_subject_status_is_the_expected_status_atom) :-
    cra_manufacturer_duties_status_values(StatusValues),
    findall(Subject, cra_manufacturer_duties_subject(Subject), Subjects),
    all_statuses_agree(StatusValues, Subjects).
test(every_subject_checklist_is_cited_and_agrees) :-
    findall(Subject, cra_manufacturer_duties_subject(Subject), Subjects),
    all_checklists_agree(Subjects).
test(before_article_14_date_is_not_yet_applicable) :-
    resolves_to(before_article_14_date, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
test(article_14_window_opens_on_11_september_2026) :-
    resolves_to(article_14_window_opens, article_14_only, [cite(eu_reg_2024_2847_art_71_2)]).
test(article_14_window_last_day_ignores_a_new_product) :-
    resolves_to(article_14_window_last_day, article_14_only, [cite(eu_reg_2024_2847_art_71_2)]).
test(on_application_day_the_placing_date_is_asked) :-
    resolves_to(missing_placing_date, indeterminate([placing_on_market_date]), []).
test(placed_on_application_day_is_subject_to_requirements) :-
    resolves_to(placed_on_application_day, subject_to_requirements, [cite(eu_reg_2024_2847_art_71_2)]).
test(placed_day_before_application_unmodified_is_article_14_only) :-
    resolves_to(placed_day_before_application_unmodified, article_14_only, [cite(eu_reg_2024_2847_art_69_2), cite(eu_reg_2024_2847_art_69_3)]).
test(legacy_product_modified_is_subject_under_article_69_2) :-
    resolves_to(legacy_product_modified, subject_to_requirements, [cite(eu_reg_2024_2847_art_69_2)]).
test(legacy_product_unmodified_is_article_14_only) :-
    resolves_to(legacy_product_unmodified, article_14_only, [cite(eu_reg_2024_2847_art_69_2), cite(eu_reg_2024_2847_art_69_3)]).
test(legacy_product_unsure_goes_to_a_lawyer) :-
    resolves_to(legacy_product_unsure, needs_legal_review(open_textured(substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2)), [inputs_relied_on([substantially_modified_on_or_after_application_date - unsure])]), []).
test(legacy_product_judgement_missing_is_asked) :-
    resolves_to(legacy_product_judgement_missing, indeterminate([substantially_modified_on_or_after_application_date]), []).
test(an_unknown_key_is_refused) :-
    resolves_to(unknown_key_in_profile, input_problems([unknown_key(colour)]), []).
test(a_duplicate_key_comes_before_an_unknown_key) :-
    resolves_to(duplicate_and_unknown_keys, input_problems([duplicate_key(placing_on_market_date), unknown_key(colour)]), []).
test(an_impossible_assessment_date_is_refused) :-
    resolves_to(impossible_assessment_date, input_problems([wrong_type(assessment_date)]), []).
test(the_provenance_context_item_builds_and_destructures) :-
    ContextItem = provenance(substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2)),
    ContextItem = provenance(InputKey, Citation),
    InputKey == substantially_modified_on_or_after_application_date,
    Citation == cite(eu_reg_2024_2847_art_69_2).
test(the_provenance_constructor_has_arity_two) :-
    functor(provenance(substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2)), Name, Arity),
    Name == provenance,
    Arity == 2.
test(the_legal_review_context_holds_the_inputs_relied_on) :-
    cra_manufacturer_duties_assess(legacy_product_unsure, cra_manufacturer_duties_verdict(needs_legal_review(_, Context), _)),
    Context == [inputs_relied_on([substantially_modified_on_or_after_application_date - unsure])].
test(the_floor_is_not_yet_applicable_the_day_before_application) :-
    resolves_to(support_floor_day_before_application, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
test(the_floor_applies_on_application_day) :-
    resolves_to(support_floor_on_application_day, minimum_support_period(60), [cite(eu_reg_2024_2847_art_13_8)]).
test(a_long_lived_router_gets_sixty_months) :-
    resolves_to(long_lived_router, minimum_support_period(60), [cite(eu_reg_2024_2847_art_13_8)]).
test(sixty_months_of_use_gives_sixty) :-
    resolves_to(use_time_at_floor, minimum_support_period(60), [cite(eu_reg_2024_2847_art_13_8)]).
test(fifty_nine_months_of_use_gives_fifty_nine) :-
    resolves_to(use_time_just_below_floor, minimum_support_period(59), [cite(eu_reg_2024_2847_art_13_8)]).
test(zero_months_of_use_gives_zero) :-
    resolves_to(use_time_zero, minimum_support_period(0), [cite(eu_reg_2024_2847_art_13_8)]).
test(the_months_are_a_bare_integer) :-
    cra_manufacturer_duties_assess(use_time_just_below_floor, cra_manufacturer_duties_verdict(minimum_support_period(Months), _)),
    integer(Months),
    Months =:= 59.
test(a_missing_use_time_is_asked) :-
    resolves_to(missing_use_time, indeterminate([expected_use_time_in_months]), []).
test(a_negative_use_time_is_refused) :-
    resolves_to(negative_use_time, input_problems([wrong_type(expected_use_time_in_months)]), []).
test(retention_is_not_yet_applicable_the_day_before_application) :-
    resolves_to(retention_day_before_application, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
test(documentation_ten_years_after_placing_wins) :-
    resolves_to(documentation_ten_years_wins, keep_until(date(2038, 2, 1)), [cite(eu_reg_2024_2847_art_13_13)]).
test(documentation_equal_dates_give_that_date) :-
    resolves_to(documentation_equal_dates, keep_until(date(2038, 2, 1)), [cite(eu_reg_2024_2847_art_13_13)]).
test(documentation_support_period_one_day_longer_wins) :-
    resolves_to(documentation_support_period_one_day_longer, keep_until(date(2038, 2, 2)), [cite(eu_reg_2024_2847_art_13_13)]).
test(instructions_support_period_wins) :-
    resolves_to(instructions_support_period_wins, keep_until(date(2040, 6, 30)), [cite(eu_reg_2024_2847_art_13_18)]).
test(instructions_ten_years_wins) :-
    resolves_to(instructions_ten_years_wins, keep_until(date(2038, 2, 1)), [cite(eu_reg_2024_2847_art_13_18)]).
test(a_leap_day_update_is_kept_to_28_february) :-
    resolves_to(leap_day_update, keep_until(date(2038, 2, 28)), [cite(eu_reg_2024_2847_art_13_9)]).
test(an_update_on_1_march_is_kept_to_1_march) :-
    resolves_to(day_after_leap_day_update, keep_until(date(2038, 3, 1)), [cite(eu_reg_2024_2847_art_13_9)]).
test(an_update_on_the_last_day_is_covered) :-
    resolves_to(update_on_last_day, keep_until(date(2041, 1, 1)), [cite(eu_reg_2024_2847_art_13_9)]).
test(an_update_the_day_after_the_last_day_is_outside) :-
    resolves_to(update_day_after_last_day, not_applicable_outside_support_period, [cite(eu_reg_2024_2847_art_13_9)]).
test(a_missing_start_date_is_asked_first) :-
    resolves_to(retention_missing_start, indeterminate([placing_on_market_date]), []).
test(a_missing_support_period_end_is_asked) :-
    resolves_to(retention_missing_end, indeterminate([support_period_end_date]), []).
test(an_unknown_item_is_refused) :-
    resolves_to(unknown_item, input_problems([wrong_type(item)]), []).
test(the_legacy_unmodified_checklist_cites_each_ground) :-
    cra_manufacturer_duties_profile_for(legacy_product_unmodified, Question),
    cra_manufacturer_duties_checklist(Question, ChecklistItems),
    ChecklistItems == [item(article_14_applies_at_assessment_date, met, cite(eu_reg_2024_2847_art_71_2)), item(regulation_applies_at_assessment_date, met, cite(eu_reg_2024_2847_art_71_2)), item(placed_on_market_on_or_after_application_date, unmet(placed_before_application_date), cite(eu_reg_2024_2847_art_69_2)), item(substantially_modified_on_or_after_application_date, unmet(not_substantially_modified), cite(eu_reg_2024_2847_art_69_2))].
test(the_leap_day_update_checklist_cites_article_13_9) :-
    cra_manufacturer_duties_profile_for(leap_day_update, Question),
    cra_manufacturer_duties_checklist(Question, ChecklistItems),
    ChecklistItems == [item(regulation_applies_at_assessment_date, met, cite(eu_reg_2024_2847_art_71_2)), item(security_update, met, cite(eu_reg_2024_2847_art_13_9))].
test(the_short_use_time_checklist_marks_the_floor_unmet) :-
    cra_manufacturer_duties_profile_for(use_time_just_below_floor, Question),
    cra_manufacturer_duties_checklist(Question, ChecklistItems),
    ChecklistItems == [item(regulation_applies_at_assessment_date, met, cite(eu_reg_2024_2847_art_71_2)), item(expected_use_time_at_least_five_years, unmet(expected_use_time_below_five_years), cite(eu_reg_2024_2847_art_13_8))].
test(an_unbound_profile_and_date_give_one_answer) :-
    findall(Verdict - Citations, decide_cra_manufacturer_duties(requirements_applicability(_, _), cra_manufacturer_duties_verdict(Verdict, Citations)), Answers),
    Answers == [input_problems([wrong_type(profile), wrong_type(assessment_date)]) - []].
test(a_partial_profile_gives_one_answer) :-
    findall(Verdict, decide_cra_manufacturer_duties(support_period_minimum([attribute(colour, red)|_], date(2028, 3, 1)), cra_manufacturer_duties_verdict(Verdict, _)), Verdicts),
    Verdicts == [input_problems([wrong_type(profile)])].
test(an_unbound_item_gives_one_answer) :-
    findall(Verdict, decide_cra_manufacturer_duties(retention_end_date([], date(2028, 3, 1), _), cra_manufacturer_duties_verdict(Verdict, _)), Verdicts),
    Verdicts == [input_problems([wrong_type(item)])].
test(an_unbound_value_gives_one_answer) :-
    findall(Verdict, decide_cra_manufacturer_duties(support_period_minimum([attribute(expected_use_time_in_months, _)], date(2028, 3, 1)), cra_manufacturer_duties_verdict(Verdict, _)), Verdicts),
    Verdicts == [input_problems([wrong_type(expected_use_time_in_months)])].
test(a_problem_question_has_an_empty_checklist) :-
    cra_manufacturer_duties_checklist(support_period_minimum(nonsense, date(2028, 3, 1)), ChecklistItems),
    ChecklistItems == [].

test(before_article_14_date_is_not_article_14_only, fail) :-
    cra_manufacturer_duties_assess(before_article_14_date, cra_manufacturer_duties_verdict(article_14_only, _)).
test(article_14_window_opening_day_is_not_not_yet_applicable, fail) :-
    cra_manufacturer_duties_assess(article_14_window_opens, cra_manufacturer_duties_verdict(not_yet_applicable, _)).
test(article_14_window_last_day_is_not_subject, fail) :-
    cra_manufacturer_duties_assess(article_14_window_last_day, cra_manufacturer_duties_verdict(subject_to_requirements, _)).
test(placed_day_before_application_unmodified_is_not_subject, fail) :-
    cra_manufacturer_duties_assess(placed_day_before_application_unmodified, cra_manufacturer_duties_verdict(subject_to_requirements, _)).
test(legacy_product_unmodified_is_not_subject, fail) :-
    cra_manufacturer_duties_assess(legacy_product_unmodified, cra_manufacturer_duties_verdict(subject_to_requirements, _)).
test(the_legal_review_context_holds_no_provenance_item, fail) :-
    cra_manufacturer_duties_assess(legacy_product_unsure, cra_manufacturer_duties_verdict(needs_legal_review(_, Context), _)),
    member(provenance(_, _), Context).
test(the_floor_on_application_day_is_not_not_yet_applicable, fail) :-
    cra_manufacturer_duties_assess(support_floor_on_application_day, cra_manufacturer_duties_verdict(not_yet_applicable, _)).
test(fifty_nine_months_of_use_does_not_give_sixty, fail) :-
    cra_manufacturer_duties_assess(use_time_just_below_floor, cra_manufacturer_duties_verdict(minimum_support_period(60), _)).
test(documentation_one_day_longer_is_not_the_ten_year_date, fail) :-
    cra_manufacturer_duties_assess(documentation_support_period_one_day_longer, cra_manufacturer_duties_verdict(keep_until(date(2038, 2, 1)), _)).
test(a_leap_day_update_is_not_kept_to_1_march, fail) :-
    cra_manufacturer_duties_assess(leap_day_update, cra_manufacturer_duties_verdict(keep_until(date(2038, 3, 1)), _)).
test(an_update_the_day_after_the_last_day_gets_no_date, fail) :-
    cra_manufacturer_duties_assess(update_day_after_last_day, cra_manufacturer_duties_verdict(keep_until(_), _)).
test(an_update_on_the_last_day_is_not_outside, fail) :-
    cra_manufacturer_duties_assess(update_on_last_day, cra_manufacturer_duties_verdict(not_applicable_outside_support_period, _)).

cp_test_names([every_subject_has_exactly_one_expected_row, every_subject_resolves_to_its_expected_verdict_once, every_subject_status_is_the_expected_status_atom, every_subject_checklist_is_cited_and_agrees, before_article_14_date_is_not_yet_applicable, article_14_window_opens_on_11_september_2026, article_14_window_last_day_ignores_a_new_product, on_application_day_the_placing_date_is_asked, placed_on_application_day_is_subject_to_requirements, placed_day_before_application_unmodified_is_article_14_only, legacy_product_modified_is_subject_under_article_69_2, legacy_product_unmodified_is_article_14_only, legacy_product_unsure_goes_to_a_lawyer, legacy_product_judgement_missing_is_asked, an_unknown_key_is_refused, a_duplicate_key_comes_before_an_unknown_key, an_impossible_assessment_date_is_refused, the_provenance_context_item_builds_and_destructures, the_provenance_constructor_has_arity_two, the_legal_review_context_holds_the_inputs_relied_on, the_floor_is_not_yet_applicable_the_day_before_application, the_floor_applies_on_application_day, a_long_lived_router_gets_sixty_months, sixty_months_of_use_gives_sixty, fifty_nine_months_of_use_gives_fifty_nine, zero_months_of_use_gives_zero, the_months_are_a_bare_integer, a_missing_use_time_is_asked, a_negative_use_time_is_refused, retention_is_not_yet_applicable_the_day_before_application, documentation_ten_years_after_placing_wins, documentation_equal_dates_give_that_date, documentation_support_period_one_day_longer_wins, instructions_support_period_wins, instructions_ten_years_wins, a_leap_day_update_is_kept_to_28_february, an_update_on_1_march_is_kept_to_1_march, an_update_on_the_last_day_is_covered, an_update_the_day_after_the_last_day_is_outside, a_missing_start_date_is_asked_first, a_missing_support_period_end_is_asked, an_unknown_item_is_refused, the_legacy_unmodified_checklist_cites_each_ground, the_leap_day_update_checklist_cites_article_13_9, the_short_use_time_checklist_marks_the_floor_unmet, an_unbound_profile_and_date_give_one_answer, a_partial_profile_gives_one_answer, an_unbound_item_gives_one_answer, an_unbound_value_gives_one_answer, a_problem_question_has_an_empty_checklist]).
cp_test_fail_names([before_article_14_date_is_not_article_14_only, article_14_window_opening_day_is_not_not_yet_applicable, article_14_window_last_day_is_not_subject, placed_day_before_application_unmodified_is_not_subject, legacy_product_unmodified_is_not_subject, the_legal_review_context_holds_no_provenance_item, the_floor_on_application_day_is_not_not_yet_applicable, fifty_nine_months_of_use_does_not_give_sixty, documentation_one_day_longer_is_not_the_ten_year_date, a_leap_day_update_is_not_kept_to_1_march, an_update_the_day_after_the_last_day_gets_no_date, an_update_on_the_last_day_is_not_outside]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
