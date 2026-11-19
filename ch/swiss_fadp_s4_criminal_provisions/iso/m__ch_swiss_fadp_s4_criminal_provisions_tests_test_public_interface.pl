% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s4_criminal_provisions_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_swiss_fadp_s4_criminal_provisions, [decide_swiss_fadp_s4_criminal_provisions/2, swiss_fadp_s4_criminal_provisions_status/2, swiss_fadp_s4_criminal_provisions_checklist/2, swiss_fadp_s4_criminal_provisions_decision_resolvable/1, swiss_fadp_s4_criminal_provisions_status_values/1, swiss_offence_punishable/3, swiss_prosecution_complaint_condition/3, swiss_prosecution_limitation/5, swiss_business_ordered_to_pay_fine/3, eu_administrative_fine_ceiling/3, compare_swiss_eu_fine_provided/5, punishable_by_fine_under_article_60_1_a/0, punishable_by_fine_under_article_60_1_b_2/0, punishable_by_fine_under_article_61_c/0, provenance/2]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_fixtures, [swiss_fadp_s4_criminal_provisions_subject/1, swiss_fadp_s4_criminal_provisions_profile_for/2, swiss_fadp_s4_criminal_provisions_assess/2]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_kernel, [swiss_fadp_s4_criminal_provisions_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_queries, [swiss_fadp_s4_criminal_provisions_what_if/4, swiss_fadp_s4_criminal_provisions_business_threshold/1, swiss_prosecution_limitation_last_day/2]).

test(every_subject_assesses_exactly_once) :-
    findall(Subject, swiss_fadp_s4_criminal_provisions_subject(Subject), Subjects),
    length(Subjects, 22),
    findall(Subject - Verdict, (member(Subject, Subjects), swiss_fadp_s4_criminal_provisions_assess(Subject, Verdict)), Verdicts),
    length(Verdicts, 22).
test(final_statuses_are_in_the_status_values) :-
    swiss_fadp_s4_criminal_provisions_assess(punishable_article_63, swiss_fadp_s4_criminal_provisions_verdict(Status, _)),
    swiss_fadp_s4_criminal_provisions_status_values(StatusValues),
    member(Status, StatusValues).
test(article_63_is_punishable) :-
    swiss_fadp_s4_criminal_provisions_assess(punishable_article_63, swiss_fadp_s4_criminal_provisions_verdict(Status, Citations)),
    Status == punishable_by_fine_under_article_63,
    Citations == [cite(ch_fadp_art_63)].
test(article_63_private_person_false_is_not_punishable) :-
    swiss_fadp_s4_criminal_provisions_assess(private_person_false_article_63, swiss_fadp_s4_criminal_provisions_verdict(Status, Citations)),
    Status == not_punishable_under_examined_offence,
    Citations = [_|_].
test(article_62_2_after_training_is_punishable) :-
    swiss_fadp_s4_criminal_provisions_assess(punishable_article_62_2_after_training, swiss_fadp_s4_criminal_provisions_verdict(Status, Citations)),
    Status == punishable_by_fine_under_article_62_2,
    Citations == [cite(ch_fadp_art_62_1), cite(ch_fadp_art_62_2), cite(ch_fadp_art_62_3)].
test(article_62_2_not_wilful_is_not_punishable) :-
    swiss_fadp_s4_criminal_provisions_status_of(not_wilful_article_62_2, Status),
    Status == not_punishable_under_examined_offence.
test(article_61_a_is_punishable) :-
    swiss_fadp_s4_criminal_provisions_status_of(punishable_article_61_a, Status),
    Status == punishable_by_fine_under_article_61_a.
test(article_61_a_public_body_is_not_punishable) :-
    swiss_fadp_s4_criminal_provisions_status_of(public_body_article_61_a, Status),
    Status == not_punishable_under_examined_offence.
test(article_60_1_b_1_is_punishable) :-
    swiss_fadp_s4_criminal_provisions_assess(punishable_article_60_1_b_1, swiss_fadp_s4_criminal_provisions_verdict(Status, Citations)),
    Status == punishable_by_fine_under_article_60_1_b_1,
    Citations == [cite(ch_fadp_art_60_1), cite(ch_fadp_art_60_1_b), cite(ch_fadp_art_60_1_b_1)].
test(article_60_1_b_1_conduct_not_met_is_not_punishable) :-
    swiss_fadp_s4_criminal_provisions_status_of(conduct_not_met_article_60_1_b_1, Status),
    Status == not_punishable_under_examined_offence.
test(article_60_1_a_is_punishable) :-
    punishable_by_fine_under_article_60_1_a,
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50000, Profile),
    swiss_offence_punishable(Profile, Result, Citations),
    Result == punishable_by_fine_under_article_60_1_a,
    Citations == [cite(ch_fadp_art_60_1), cite(ch_fadp_art_60_1_a)].
test(article_60_1_a_not_wilful_is_not_punishable) :-
    punishable_by_fine_under_article_60_1_a,
    swiss_offence_punishable([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, false), attribute(examined_offence, article_60_1_a), attribute(offender_is_private_person, true)], Result, _),
    Result == not_punishable_under_examined_offence.
test(article_60_1_b_2_is_punishable) :-
    punishable_by_fine_under_article_60_1_b_2,
    swiss_offence_punishable([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, true), attribute(examined_offence, article_60_1_b_2), attribute(offender_is_private_person, true)], Result, Citations),
    Result == punishable_by_fine_under_article_60_1_b_2,
    Citations == [cite(ch_fadp_art_60_1), cite(ch_fadp_art_60_1_b), cite(ch_fadp_art_60_1_b_2)].
test(article_60_1_b_2_public_body_is_not_punishable) :-
    punishable_by_fine_under_article_60_1_b_2,
    swiss_offence_punishable([attribute(conduct_meets_offence_description, true), attribute(acted_wilfully, true), attribute(examined_offence, article_60_1_b_2), attribute(offender_is_private_person, false)], Result, _),
    Result == not_punishable_under_examined_offence.
test(article_61_c_is_punishable) :-
    punishable_by_fine_under_article_61_c,
    swiss_fadp_s4_criminal_provisions_profile_for(complaint_filed_article_61_c, Profile),
    swiss_offence_punishable(Profile, Result, Citations),
    Result == punishable_by_fine_under_article_61_c,
    Citations == [cite(ch_fadp_art_61), cite(ch_fadp_art_61_c)].
test(article_61_c_conduct_not_met_is_not_punishable) :-
    punishable_by_fine_under_article_61_c,
    swiss_offence_punishable([attribute(conduct_meets_offence_description, false), attribute(acted_wilfully, true), attribute(examined_offence, article_61_c), attribute(offender_is_private_person, true)], Result, _),
    Result == not_punishable_under_examined_offence.
test(provenance_constructor_holds_for_bound_parts) :-
    provenance(fixtures, single_key_control).
test(empty_profile_asks_for_conduct) :-
    swiss_fadp_s4_criminal_provisions_assess(empty_profile, swiss_fadp_s4_criminal_provisions_verdict(Status, Citations)),
    Status == indeterminate([conduct_meets_offence_description]),
    Citations == [].
test(unsure_conduct_goes_to_review) :-
    swiss_fadp_s4_criminal_provisions_assess(unsure_conduct_article_61_b, swiss_fadp_s4_criminal_provisions_verdict(Status, Citations)),
    Status == needs_legal_review(open_textured(conduct_meets_offence_description, cite(ch_fadp_art_61_b)), [inputs_relied_on([conduct_meets_offence_description - unsure, acted_wilfully - true, examined_offence - article_61_b, offender_is_private_person - true])]),
    Citations == [].
test(conduct_met_control_is_punishable) :-
    swiss_fadp_s4_criminal_provisions_status_of(conduct_met_article_61_b, Status),
    Status == punishable_by_fine_under_article_61_b.
test(duplicate_key_is_an_input_problem) :-
    swiss_fadp_s4_criminal_provisions_assess(malformed_duplicate_key, swiss_fadp_s4_criminal_provisions_verdict(Status, Citations)),
    Status == input_problems([duplicate_key(acted_wilfully)]),
    Citations == [].
test(single_key_control_has_no_input_problem) :-
    swiss_fadp_s4_criminal_provisions_profile_for(single_key_control, Profile),
    swiss_fadp_s4_criminal_provisions_input_problems(Profile, Problems),
    Problems == [],
    swiss_fadp_s4_criminal_provisions_status(Profile, Status),
    Status == indeterminate([conduct_meets_offence_description]).
test(input_check_names_the_duplicate_bare) :-
    swiss_fadp_s4_criminal_provisions_profile_for(malformed_duplicate_key, Profile),
    swiss_fadp_s4_criminal_provisions_input_problems(Profile, Problems),
    Problems == [duplicate_key(acted_wilfully)].
test(input_check_on_a_non_list_profile) :-
    swiss_fadp_s4_criminal_provisions_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(article_61_c_complaint_filed) :-
    swiss_fadp_s4_criminal_provisions_profile_for(complaint_filed_article_61_c, Profile),
    swiss_prosecution_complaint_condition(Profile, Result, Citations),
    Result == complaint_offence_complaint_filed,
    Citations == [cite(ch_fadp_art_60_1), cite(ch_fadp_art_61), cite(ch_fadp_art_62_1), cite(ch_fadp_art_62_2)].
test(article_61_c_complaint_missing) :-
    swiss_fadp_s4_criminal_provisions_profile_for(complaint_missing_article_61_c, Profile),
    swiss_prosecution_complaint_condition(Profile, Result, Citations),
    Result == indeterminate([criminal_complaint_filed]),
    Citations == [].
test(article_60_2_is_ex_officio) :-
    swiss_fadp_s4_criminal_provisions_profile_for(ex_officio_article_60_2, Profile),
    swiss_prosecution_complaint_condition(Profile, Result, Citations),
    Result == prosecuted_ex_officio,
    Citations == [cite(ch_fadp_art_60_2), cite(ch_fadp_art_63)],
    swiss_fadp_s4_criminal_provisions_status(Profile, Status),
    Status == punishable_by_fine_under_article_60_2.
test(article_62_2_carries_the_complaint_requirement) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_62_2_after_training, Profile),
    swiss_prosecution_complaint_condition(Profile, Result, _),
    Result == complaint_offence_complaint_filed.
test(limitation_on_the_anniversary_is_not_expired) :-
    swiss_prosecution_limitation([], date(2020, 3, 15), date(2025, 3, 15), Result, Citations),
    Result == five_year_limitation_period_not_expired,
    Citations == [cite(ch_fadp_art_66)].
test(limitation_the_day_after_is_expired) :-
    swiss_prosecution_limitation([], date(2020, 3, 15), date(2025, 3, 16), Result, Citations),
    Result == five_year_limitation_period_expired,
    Citations == [cite(ch_fadp_art_66)].
test(limitation_leap_day_clamps_to_28_february) :-
    swiss_prosecution_limitation([], date(2024, 2, 29), date(2029, 2, 28), NotExpired, _),
    NotExpired == five_year_limitation_period_not_expired,
    swiss_prosecution_limitation([], date(2024, 2, 29), date(2029, 3, 1), Expired, _),
    Expired == five_year_limitation_period_expired.
test(limitation_assessment_before_offence_is_not_expired) :-
    swiss_prosecution_limitation([], date(2020, 3, 15), date(2019, 1, 1), Result, _),
    Result == five_year_limitation_period_not_expired.
test(limitation_bad_offence_date_after_profile_problems) :-
    swiss_prosecution_limitation([attribute(colour, blue)], date(2023, 2, 29), date(2025, 1, 1), Result, Citations),
    Result == input_problems([unknown_key(colour), wrong_type(offence_date)]),
    Citations == [].
test(limitation_last_day_is_derived) :-
    swiss_prosecution_limitation_last_day(date(2020, 2, 29), LastDay),
    LastDay == date(2025, 2, 28).
test(business_at_50000_may_be_ordered_to_pay) :-
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50000, Profile),
    swiss_business_ordered_to_pay_fine(Profile, Result, Citations),
    Result == business_may_be_ordered_to_pay_fine,
    Citations == [cite(ch_fadp_art_64_2)].
test(business_at_50001_is_not_available) :-
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50001, Profile),
    swiss_business_ordered_to_pay_fine(Profile, Result, Citations),
    Result == business_substitution_not_available,
    Citations == [cite(ch_fadp_art_64_2)].
test(business_threshold_is_exposed) :-
    swiss_fadp_s4_criminal_provisions_business_threshold(threshold(Axis, MaximumFrancs, Citation)),
    Axis == fine_in_consideration_in_francs,
    MaximumFrancs =:= 50000,
    Citation == cite(ch_fadp_art_64_2).
test(eu_established_83_5_has_upper_ceiling) :-
    swiss_fadp_s4_criminal_provisions_profile_for(eu_listed_83_5_established, Profile),
    eu_administrative_fine_ceiling(Profile, Result, Citations),
    Result == fine_up_to_20_million_euro_or_4_percent_of_turnover,
    Citations = [_|_].
test(eu_unsure_infringement_goes_to_review) :-
    swiss_fadp_s4_criminal_provisions_profile_for(eu_listed_83_5_unsure_infringement, Profile),
    eu_administrative_fine_ceiling(Profile, Result, Citations),
    Result == needs_legal_review(open_textured(eu_infringement_established, cite(eu_reg_2016_679_art_83_5)), [inputs_relied_on([eu_infringement_established - unsure, eu_infringed_obligation_listed_in - listed_in_article_83_5_or_83_6])]),
    Citations == [].
test(comparison_same_when_both_fine) :-
    swiss_fadp_s4_criminal_provisions_profile_for(wilful_and_eu_ceiling, Profile),
    compare_swiss_eu_fine_provided(Profile, SwissResult, EuResult, Difference, ChangedBy),
    SwissResult == punishable_by_fine_under_article_62_1,
    EuResult == fine_up_to_10_million_euro_or_2_percent_of_turnover,
    Difference == same,
    ChangedBy == [].
test(comparison_differs_without_intent) :-
    swiss_fadp_s4_criminal_provisions_profile_for(not_wilful_but_eu_ceiling, Profile),
    compare_swiss_eu_fine_provided(Profile, SwissResult, EuResult, Difference, ChangedBy),
    SwissResult == not_punishable_under_examined_offence,
    EuResult == fine_up_to_20_million_euro_or_4_percent_of_turnover,
    Difference == differs,
    ChangedBy == [cite(ch_fadp_art_60_1), cite(ch_fadp_art_60_2), cite(ch_fadp_art_61), cite(ch_fadp_art_62_1), cite(ch_fadp_art_62_2), cite(ch_fadp_art_63), cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)].
test(comparison_refers_unsure_swiss_judgement_with_fixed_citation) :-
    swiss_fadp_s4_criminal_provisions_profile_for(unsure_conduct_article_61_b, Profile),
    compare_swiss_eu_fine_provided(Profile, _, EuResult, Difference, ChangedBy),
    EuResult == no_administrative_fine_under_article_83_4_to_83_6,
    Difference == needs_legal_review(open_textured(conduct_meets_offence_description, cite(ch_fadp_art_60_to_63)), [inputs_relied_on([conduct_meets_offence_description - unsure, acted_wilfully - true, examined_offence - article_61_b, offender_is_private_person - true, eu_infringement_established - false])]),
    ChangedBy == [].
test(comparison_conduct_met_control_differs) :-
    swiss_fadp_s4_criminal_provisions_profile_for(conduct_met_article_61_b, Profile),
    compare_swiss_eu_fine_provided(Profile, SwissResult, _, Difference, _),
    SwissResult == punishable_by_fine_under_article_61_b,
    Difference == differs.
test(comparison_with_input_problems) :-
    swiss_fadp_s4_criminal_provisions_profile_for(malformed_duplicate_key, Profile),
    compare_swiss_eu_fine_provided(Profile, SwissResult, EuResult, Difference, ChangedBy),
    SwissResult == input_problems([duplicate_key(acted_wilfully)]),
    EuResult == input_problems([duplicate_key(acted_wilfully)]),
    Difference == input_problems([duplicate_key(acted_wilfully)]),
    ChangedBy == [].
test(checklist_carries_a_citation_per_item) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_63, Profile),
    swiss_fadp_s4_criminal_provisions_checklist(Profile, Items),
    Items == [item(offence_description, met, cite(ch_fadp_art_63)), item(wilful_conduct, met, cite(ch_fadp_art_63)), item(private_person, met, cite(ch_fadp_art_63))].
test(checklist_marks_private_person_inapplicable_for_article_62) :-
    swiss_fadp_s4_criminal_provisions_profile_for(punishable_article_62_2_after_training, Profile),
    swiss_fadp_s4_criminal_provisions_checklist(Profile, Items),
    member(item(private_person, inapplicable, cite(ch_fadp_art_62_2)), Items).
test(checklist_non_empty_and_resolvable_on_every_subject) :-
    findall(Subject, swiss_fadp_s4_criminal_provisions_subject(Subject), Subjects),
    findall(Subject, (member(Subject, Subjects), swiss_fadp_s4_criminal_provisions_profile_for(Subject, Profile), swiss_fadp_s4_criminal_provisions_decision_resolvable(Profile), swiss_fadp_s4_criminal_provisions_checklist(Profile, [_|_])), Checked),
    Checked == Subjects.
test(what_if_private_person_true_flips_the_near_miss) :-
    swiss_fadp_s4_criminal_provisions_profile_for(private_person_false_article_63, Profile),
    swiss_fadp_s4_criminal_provisions_what_if(Profile, offender_is_private_person, true, Status),
    Status == punishable_by_fine_under_article_63.
test(each_contract_query_has_one_solution) :-
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50000, Profile),
    findall(Result, swiss_offence_punishable(Profile, Result, _), Punishable),
    length(Punishable, 1),
    findall(Result, swiss_prosecution_complaint_condition(Profile, Result, _), Complaint),
    length(Complaint, 1),
    findall(Result, swiss_prosecution_limitation(Profile, date(2020, 1, 1), date(2026, 1, 1), Result, _), Limitation),
    length(Limitation, 1),
    findall(Result, swiss_business_ordered_to_pay_fine(Profile, Result, _), Business),
    length(Business, 1),
    findall(Result, eu_administrative_fine_ceiling(Profile, Result, _), Ceiling),
    length(Ceiling, 1),
    findall(Difference, compare_swiss_eu_fine_provided(Profile, _, _, Difference, _), Comparison),
    length(Comparison, 1).

test(article_63_private_person_false_is_not_punishable_by_fine, fail) :-
    swiss_fadp_s4_criminal_provisions_assess(private_person_false_article_63, swiss_fadp_s4_criminal_provisions_verdict(punishable_by_fine_under_article_63, _)).
test(provenance_constructor_rejects_unbound_source, fail) :-
    provenance(_, single_key_control).
test(business_at_50001_may_not_be_ordered_to_pay, fail) :-
    swiss_fadp_s4_criminal_provisions_profile_for(business_boundary_50001, Profile),
    swiss_business_ordered_to_pay_fine(Profile, business_may_be_ordered_to_pay_fine, _).

swiss_fadp_s4_criminal_provisions_status_of(Subject, Status) :-
    swiss_fadp_s4_criminal_provisions_profile_for(Subject, Profile),
    swiss_fadp_s4_criminal_provisions_status(Profile, Status).

cp_test_names([every_subject_assesses_exactly_once, final_statuses_are_in_the_status_values, article_63_is_punishable, article_63_private_person_false_is_not_punishable, article_62_2_after_training_is_punishable, article_62_2_not_wilful_is_not_punishable, article_61_a_is_punishable, article_61_a_public_body_is_not_punishable, article_60_1_b_1_is_punishable, article_60_1_b_1_conduct_not_met_is_not_punishable, article_60_1_a_is_punishable, article_60_1_a_not_wilful_is_not_punishable, article_60_1_b_2_is_punishable, article_60_1_b_2_public_body_is_not_punishable, article_61_c_is_punishable, article_61_c_conduct_not_met_is_not_punishable, provenance_constructor_holds_for_bound_parts, empty_profile_asks_for_conduct, unsure_conduct_goes_to_review, conduct_met_control_is_punishable, duplicate_key_is_an_input_problem, single_key_control_has_no_input_problem, input_check_names_the_duplicate_bare, input_check_on_a_non_list_profile, article_61_c_complaint_filed, article_61_c_complaint_missing, article_60_2_is_ex_officio, article_62_2_carries_the_complaint_requirement, limitation_on_the_anniversary_is_not_expired, limitation_the_day_after_is_expired, limitation_leap_day_clamps_to_28_february, limitation_assessment_before_offence_is_not_expired, limitation_bad_offence_date_after_profile_problems, limitation_last_day_is_derived, business_at_50000_may_be_ordered_to_pay, business_at_50001_is_not_available, business_threshold_is_exposed, eu_established_83_5_has_upper_ceiling, eu_unsure_infringement_goes_to_review, comparison_same_when_both_fine, comparison_differs_without_intent, comparison_refers_unsure_swiss_judgement_with_fixed_citation, comparison_conduct_met_control_differs, comparison_with_input_problems, checklist_carries_a_citation_per_item, checklist_marks_private_person_inapplicable_for_article_62, checklist_non_empty_and_resolvable_on_every_subject, what_if_private_person_true_flips_the_near_miss, each_contract_query_has_one_solution]).
cp_test_fail_names([article_63_private_person_false_is_not_punishable_by_fine, provenance_constructor_rejects_unbound_source, business_at_50001_may_not_be_ordered_to_pay]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
