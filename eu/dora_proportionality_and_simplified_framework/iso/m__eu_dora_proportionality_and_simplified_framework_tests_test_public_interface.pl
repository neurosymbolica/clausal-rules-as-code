% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [decide_dora_proportionality_and_simplified_framework/2, dora_proportionality_and_simplified_framework_status/2, dora_proportionality_and_simplified_framework_checklist/2, dora_proportionality_and_simplified_framework_decision_resolvable/1, dora_proportionality_and_simplified_framework_status_values/1]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_fixtures, [dora_proportionality_and_simplified_framework_subject/1, dora_proportionality_and_simplified_framework_profile_for/2, dora_proportionality_and_simplified_framework_assess/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [simplified_framework_qualification/3, simplified_framework_duties_required/3, simplified_framework_duties_complete/3, simplified_framework_duties_outstanding/3]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_kernel, [dora_proportionality_and_simplified_framework_input_problems/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_queries, [dora_proportionality_and_simplified_framework_profile_keys/1, dora_proportionality_and_simplified_framework_what_if/4]).

duty_answer_citations([cite(eu_reg_2022_2554_art_4_1), cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_16_1_a), cite(eu_reg_2022_2554_art_16_1_b), cite(eu_reg_2022_2554_art_16_1_c), cite(eu_reg_2022_2554_art_16_1_d), cite(eu_reg_2022_2554_art_16_1_e), cite(eu_reg_2022_2554_art_16_1_f), cite(eu_reg_2022_2554_art_16_1_g), cite(eu_reg_2022_2554_art_16_1_h), cite(eu_reg_2022_2554_art_16_2)]).

same_citations(Citations, Expected) :-
    sort(Citations, SortedCitations),
    sort(Expected, SortedExpected),
    SortedCitations == SortedExpected.

subject_verdict(Subject, Status, Citations) :-
    dora_proportionality_and_simplified_framework_assess(Subject, dora_proportionality_and_simplified_framework_verdict(Status, Citations)).

subject_profile(Subject, Profile) :-
    dora_proportionality_and_simplified_framework_profile_for(Subject, Profile).

test(there_are_twenty_subjects) :-
    findall(Subject, dora_proportionality_and_simplified_framework_subject(Subject), Subjects),
    length(Subjects, 20).
test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, dora_proportionality_and_simplified_framework_subject(Subject), Subjects),
    findall(Subject - Verdict, (dora_proportionality_and_simplified_framework_subject(Subject), dora_proportionality_and_simplified_framework_assess(Subject, Verdict)), Verdicts),
    length(Subjects, Count),
    length(Verdicts, Count).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, dora_proportionality_and_simplified_framework_subject(Subject), Subjects),
    findall(Subject, (dora_proportionality_and_simplified_framework_subject(Subject), dora_proportionality_and_simplified_framework_profile_for(Subject, Profile), dora_proportionality_and_simplified_framework_checklist(Profile, [_|_])), WithItems),
    WithItems == Subjects.
test(every_subject_is_resolvable) :-
    findall(Subject, dora_proportionality_and_simplified_framework_subject(Subject), Subjects),
    findall(Subject, (dora_proportionality_and_simplified_framework_subject(Subject), dora_proportionality_and_simplified_framework_profile_for(Subject, Profile), dora_proportionality_and_simplified_framework_decision_resolvable(Profile)), Resolvable),
    Resolvable == Subjects.
test(the_status_values_name_the_final_answers) :-
    dora_proportionality_and_simplified_framework_status_values(Values),
    member(complete, Values),
    member(incomplete, Values),
    member(out_of_scope, Values).
test(the_profile_schema_has_seventeen_keys) :-
    dora_proportionality_and_simplified_framework_profile_keys(Keys),
    length(Keys, 17),
    Keys = [dora_entity_type|_].
test(the_provenance_term_carries_a_deciding_clause) :-
    Item = provenance(complete_unsure_step, [cite(eu_reg_2022_2554_art_16_1_a)]),
    Item = provenance(Clause, Citations),
    Clause == complete_unsure_step,
    Citations == [cite(eu_reg_2022_2554_art_16_1_a)].
test(the_provenance_term_may_carry_no_citations) :-
    Item = provenance(outstanding_unsure_step, []),
    Item = provenance(_, Citations),
    Citations == [].
test(all_duties_performed_is_complete) :-
    subject_verdict(exempted_payment_institution_all_duties_performed, complete, Citations),
    duty_answer_citations(Expected),
    same_citations(Citations, Expected).
test(framework_not_performed_is_incomplete) :-
    subject_verdict(exempted_payment_institution_framework_not_performed, incomplete, Citations),
    duty_answer_citations(Expected),
    same_citations(Citations, Expected).
test(framework_unsure_is_referred_to_a_lawyer) :-
    subject_verdict(exempted_payment_institution_framework_unsure, needs_legal_review(open_textured(simplified_framework_in_place_and_maintained, cite(eu_reg_2022_2554_art_16_1_a)), [inputs_relied_on(Pairs)]), Citations),
    Citations == [],
    length(Pairs, 13),
    Pairs = [dora_entity_type - exempted_payment_institution, authority_requested_framework_review_report - false, simplified_framework_in_place_and_maintained - unsure|_].
test(exempted_electronic_money_institution_is_complete) :-
    subject_verdict(exempted_electronic_money_institution_all_duties_performed, complete, _).
test(small_investment_firm_is_complete) :-
    subject_verdict(small_investment_firm_all_duties_performed, complete, _).
test(investment_firm_not_small_is_not_an_article_16_1_entity) :-
    subject_verdict(investment_firm_not_small, not_article_16_1_entity, Citations),
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(fifteen_members_is_out_of_scope) :-
    subject_verdict(occupational_retirement_fifteen_members, out_of_scope, Citations),
    Citations == [cite(eu_reg_2022_2554_art_2_3_c)].
test(sixteen_members_is_complete) :-
    subject_verdict(occupational_retirement_sixteen_members, complete, _).
test(ninety_nine_members_is_complete) :-
    subject_verdict(occupational_retirement_ninety_nine_members, complete, _).
test(one_hundred_members_is_not_an_article_16_1_entity) :-
    subject_verdict(occupational_retirement_one_hundred_members, not_article_16_1_entity, Citations),
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(directive_institution_not_excluded_is_complete) :-
    subject_verdict(directive_institution_not_excluded_by_member_state, complete, _).
test(directive_institution_excluded_is_out_of_scope) :-
    subject_verdict(directive_institution_excluded_by_member_state, out_of_scope, Citations),
    Citations == [cite(eu_reg_2022_2554_art_2_4)].
test(third_party_service_provider_is_not_a_financial_entity) :-
    subject_verdict(third_party_service_provider, not_a_financial_entity, Citations),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_2_2)]).
test(unlisted_entity_type_is_out_of_scope) :-
    subject_verdict(unlisted_entity_type, out_of_scope, Citations),
    Citations == [cite(eu_reg_2022_2554_art_2_1)].
test(credit_institution_is_not_an_article_16_1_entity) :-
    subject_verdict(credit_institution_subject, not_article_16_1_entity, Citations),
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(requested_report_submitted_is_complete) :-
    subject_verdict(requested_report_submitted, complete, _).
test(requested_report_not_submitted_is_incomplete) :-
    subject_verdict(requested_report_not_submitted, incomplete, _).
test(entity_type_not_given_is_indeterminate) :-
    subject_verdict(entity_type_not_given, indeterminate([dora_entity_type]), Citations),
    Citations == [].
test(entity_type_misspelt_is_an_input_problem) :-
    subject_verdict(entity_type_misspelt, input_problems([wrong_type(dora_entity_type)]), Citations),
    Citations == [].
test(entity_type_given_twice_is_a_duplicate_only) :-
    subject_verdict(entity_type_given_twice, input_problems([duplicate_key(dora_entity_type)]), []).
test(the_status_agrees_with_the_verdict) :-
    subject_profile(requested_report_not_submitted, Profile),
    dora_proportionality_and_simplified_framework_status(Profile, incomplete),
    decide_dora_proportionality_and_simplified_framework(Profile, dora_proportionality_and_simplified_framework_verdict(incomplete, _)).
test(sixteen_members_qualifies) :-
    subject_profile(occupational_retirement_sixteen_members, Profile),
    simplified_framework_qualification(Profile, article_16_1_entity, Citations),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_53)]).
test(ninety_nine_members_qualifies) :-
    subject_profile(occupational_retirement_ninety_nine_members, Profile),
    simplified_framework_qualification(Profile, article_16_1_entity, _).
test(one_hundred_members_does_not_qualify) :-
    subject_profile(occupational_retirement_one_hundred_members, Profile),
    simplified_framework_qualification(Profile, not_article_16_1_entity, _).
test(a_small_investment_firm_qualifies_with_its_definition) :-
    subject_profile(small_investment_firm_all_duties_performed, Profile),
    simplified_framework_qualification(Profile, article_16_1_entity, Citations),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_34)]).
test(an_exempted_electronic_money_institution_qualifies) :-
    subject_profile(exempted_electronic_money_institution_all_duties_performed, Profile),
    simplified_framework_qualification(Profile, article_16_1_entity, Citations),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_39)]).
test(a_directive_institution_not_excluded_qualifies) :-
    subject_profile(directive_institution_not_excluded_by_member_state, Profile),
    simplified_framework_qualification(Profile, article_16_1_entity, Citations),
    same_citations(Citations, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_32)]).
test(the_qualification_has_exactly_one_answer) :-
    subject_profile(occupational_retirement_sixteen_members, Profile),
    findall(Result - Citations, simplified_framework_qualification(Profile, Result, Citations), Answers),
    length(Answers, 1).
test(a_requested_report_gives_twelve_duties) :-
    subject_profile(requested_report_submitted, Profile),
    simplified_framework_duties_required(Profile, required(Duties), Citations),
    length(Duties, 12),
    Duties = [simplified_ict_risk_management_framework|_],
    last(Duties, review_report_to_authority),
    duty_answer_citations(Expected),
    same_citations(Citations, Expected).
test(no_request_gives_eleven_duties) :-
    subject_profile(exempted_payment_institution_all_duties_performed, Profile),
    simplified_framework_duties_required(Profile, required(Duties), _),
    length(Duties, 11),
    last(Duties, continuous_improvement).
test(required_passes_on_out_of_scope) :-
    subject_profile(occupational_retirement_fifteen_members, Profile),
    simplified_framework_duties_required(Profile, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_c)]).
test(the_compliance_check_matches_the_facade) :-
    subject_profile(exempted_payment_institution_framework_not_performed, Profile),
    simplified_framework_duties_complete(Profile, incomplete, _).
test(the_compliance_check_has_exactly_one_answer) :-
    subject_profile(requested_report_submitted, Profile),
    findall(Result, simplified_framework_duties_complete(Profile, Result, _), Answers),
    Answers == [complete].
test(the_unperformed_framework_is_outstanding) :-
    subject_profile(exempted_payment_institution_framework_not_performed, Profile),
    simplified_framework_duties_outstanding(Profile, outstanding(Duties), Citations),
    Duties == [simplified_ict_risk_management_framework],
    same_citations(Citations, [cite(eu_reg_2022_2554_art_4_1), cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_16_1_a)]).
test(the_unsent_report_is_outstanding) :-
    subject_profile(requested_report_not_submitted, Profile),
    simplified_framework_duties_outstanding(Profile, outstanding(Duties), Citations),
    Duties == [review_report_to_authority],
    same_citations(Citations, [cite(eu_reg_2022_2554_art_4_1), cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_16_2)]).
test(all_duties_performed_is_none_outstanding) :-
    subject_profile(exempted_payment_institution_all_duties_performed, Profile),
    simplified_framework_duties_outstanding(Profile, none_outstanding, Citations),
    duty_answer_citations(Expected),
    same_citations(Citations, Expected).
test(outstanding_passes_on_not_a_financial_entity) :-
    subject_profile(third_party_service_provider, Profile),
    simplified_framework_duties_outstanding(Profile, not_a_financial_entity, _).
test(the_checklist_cites_every_duty) :-
    subject_profile(exempted_payment_institution_all_duties_performed, Profile),
    dora_proportionality_and_simplified_framework_checklist(Profile, Items),
    length(Items, 13),
    Items = [item(qualification, article_16_1_entity, _)|_],
    findall(Citation, member(item(_, _, cite(Citation)), Items), Citations),
    length(Citations, 12),
    member(item(review_report_to_authority, inapplicable, cite(eu_reg_2022_2554_art_16_2)), Items).
test(the_checklist_marks_the_unperformed_duty) :-
    subject_profile(exempted_payment_institution_framework_not_performed, Profile),
    dora_proportionality_and_simplified_framework_checklist(Profile, Items),
    member(item(simplified_ict_risk_management_framework, unmet(_), cite(eu_reg_2022_2554_art_16_1_a)), Items).
test(a_well_formed_fixture_has_no_problem) :-
    subject_profile(exempted_payment_institution_all_duties_performed, Profile),
    dora_proportionality_and_simplified_framework_input_problems(Profile, []).
test(a_misspelt_type_is_wrong_type) :-
    subject_profile(entity_type_misspelt, Profile),
    dora_proportionality_and_simplified_framework_input_problems(Profile, [wrong_type(dora_entity_type)]).
test(an_unknown_key_is_named) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(stray_key, true)], [unknown_key(stray_key)]).
test(submitting_the_report_completes_the_duties) :-
    subject_profile(requested_report_not_submitted, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, simplified_framework_review_report_submitted, true, complete).
test(performing_the_framework_completes_the_duties) :-
    subject_profile(exempted_payment_institution_framework_not_performed, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, simplified_framework_in_place_and_maintained, true, complete).
test(one_more_member_brings_the_institution_into_article_16) :-
    subject_profile(occupational_retirement_fifteen_members, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, iorp_pension_scheme_members_total, 16, complete).
test(a_float_member_count_is_refused_by_the_what_if) :-
    subject_profile(occupational_retirement_fifteen_members, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, iorp_pension_scheme_members_total, 16.0, input_problems([wrong_type(iorp_pension_scheme_members_total)])).

test(all_duties_performed_is_not_incomplete, fail) :-
    subject_verdict(exempted_payment_institution_all_duties_performed, incomplete, _).
test(framework_not_performed_is_not_complete, fail) :-
    subject_verdict(exempted_payment_institution_framework_not_performed, complete, _).
test(framework_unsure_is_not_complete, fail) :-
    subject_verdict(exempted_payment_institution_framework_unsure, complete, _).
test(investment_firm_not_small_is_not_complete, fail) :-
    subject_verdict(investment_firm_not_small, complete, _).
test(fifteen_members_is_not_complete, fail) :-
    subject_verdict(occupational_retirement_fifteen_members, complete, _).
test(one_hundred_members_is_not_complete, fail) :-
    subject_verdict(occupational_retirement_one_hundred_members, complete, _).
test(directive_institution_excluded_is_not_complete, fail) :-
    subject_verdict(directive_institution_excluded_by_member_state, complete, _).
test(third_party_service_provider_is_not_out_of_article_16_1_only, fail) :-
    subject_verdict(third_party_service_provider, not_article_16_1_entity, _).
test(unlisted_entity_type_is_not_an_article_16_1_answer, fail) :-
    subject_verdict(unlisted_entity_type, not_article_16_1_entity, _).
test(credit_institution_is_not_complete, fail) :-
    subject_verdict(credit_institution_subject, complete, _).
test(requested_report_not_submitted_is_not_complete, fail) :-
    subject_verdict(requested_report_not_submitted, complete, _).
test(fifteen_members_does_not_qualify, fail) :-
    subject_profile(occupational_retirement_fifteen_members, Profile),
    simplified_framework_qualification(Profile, article_16_1_entity, _).
test(all_duties_performed_has_nothing_outstanding, fail) :-
    subject_profile(exempted_payment_institution_all_duties_performed, Profile),
    simplified_framework_duties_outstanding(Profile, outstanding(_), _).

cp_test_names([there_are_twenty_subjects, every_subject_has_exactly_one_verdict, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, the_status_values_name_the_final_answers, the_profile_schema_has_seventeen_keys, the_provenance_term_carries_a_deciding_clause, the_provenance_term_may_carry_no_citations, all_duties_performed_is_complete, framework_not_performed_is_incomplete, framework_unsure_is_referred_to_a_lawyer, exempted_electronic_money_institution_is_complete, small_investment_firm_is_complete, investment_firm_not_small_is_not_an_article_16_1_entity, fifteen_members_is_out_of_scope, sixteen_members_is_complete, ninety_nine_members_is_complete, one_hundred_members_is_not_an_article_16_1_entity, directive_institution_not_excluded_is_complete, directive_institution_excluded_is_out_of_scope, third_party_service_provider_is_not_a_financial_entity, unlisted_entity_type_is_out_of_scope, credit_institution_is_not_an_article_16_1_entity, requested_report_submitted_is_complete, requested_report_not_submitted_is_incomplete, entity_type_not_given_is_indeterminate, entity_type_misspelt_is_an_input_problem, entity_type_given_twice_is_a_duplicate_only, the_status_agrees_with_the_verdict, sixteen_members_qualifies, ninety_nine_members_qualifies, one_hundred_members_does_not_qualify, a_small_investment_firm_qualifies_with_its_definition, an_exempted_electronic_money_institution_qualifies, a_directive_institution_not_excluded_qualifies, the_qualification_has_exactly_one_answer, a_requested_report_gives_twelve_duties, no_request_gives_eleven_duties, required_passes_on_out_of_scope, the_compliance_check_matches_the_facade, the_compliance_check_has_exactly_one_answer, the_unperformed_framework_is_outstanding, the_unsent_report_is_outstanding, all_duties_performed_is_none_outstanding, outstanding_passes_on_not_a_financial_entity, the_checklist_cites_every_duty, the_checklist_marks_the_unperformed_duty, a_well_formed_fixture_has_no_problem, a_misspelt_type_is_wrong_type, an_unknown_key_is_named, submitting_the_report_completes_the_duties, performing_the_framework_completes_the_duties, one_more_member_brings_the_institution_into_article_16, a_float_member_count_is_refused_by_the_what_if]).
cp_test_fail_names([all_duties_performed_is_not_incomplete, framework_not_performed_is_not_complete, framework_unsure_is_not_complete, investment_firm_not_small_is_not_complete, fifteen_members_is_not_complete, one_hundred_members_is_not_complete, directive_institution_excluded_is_not_complete, third_party_service_provider_is_not_out_of_article_16_1_only, unlisted_entity_type_is_not_an_article_16_1_answer, credit_institution_is_not_complete, requested_report_not_submitted_is_not_complete, fifteen_members_does_not_qualify, all_duties_performed_has_nothing_outstanding]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
