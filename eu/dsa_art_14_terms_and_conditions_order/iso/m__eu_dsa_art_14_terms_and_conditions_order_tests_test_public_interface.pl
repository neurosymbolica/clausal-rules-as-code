% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_14_terms_and_conditions_order_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_dsa_art_14_terms_and_conditions_order, [art_14_1_terms_and_conditions_content_status/4, art_14_2_significant_change_information_status/4, art_14_3_minors_explanation_status/4, art_14_4_restriction_enforcement_status/4, art_14_5_terms_and_conditions_summary_status/4, art_14_6_official_languages_status/4, decide_dsa_art_14_terms_and_conditions_order/2, dsa_art_14_terms_and_conditions_order_status/2, dsa_art_14_terms_and_conditions_order_checklist/2, dsa_art_14_terms_and_conditions_order_decision_resolvable/1, dsa_art_14_terms_and_conditions_order_status_values/1]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_kernel, [dsa_art_14_terms_and_conditions_order_input_problems/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_queries, [dsa_art_14_terms_and_conditions_order_what_if/4]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_fixtures, [dsa_art_14_terms_and_conditions_order_subject/1, dsa_art_14_terms_and_conditions_order_profile_for/2, dsa_art_14_terms_and_conditions_order_assess/2]).

designated_statement(attested(true, attestation(host_service, attestation_time, commission_designation_decision, none))).

not_designated_statement(attested(false, attestation(host_service, attestation_time, commission_designation_list, none))).

contract_queries([art_14_1_terms_and_conditions_content_status, art_14_2_significant_change_information_status, art_14_3_minors_explanation_status, art_14_4_restriction_enforcement_status, art_14_5_terms_and_conditions_summary_status, art_14_6_official_languages_status]).

answers(Query, Subject, Answers) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, call(Query, Profile, Result, Basis, Citations), Answers).

roll_ups(Subject, Statuses) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    findall(Status, dsa_art_14_terms_and_conditions_order_status(Profile, Status), Statuses).

expected_roll_up(fully_compliant_very_large_platform, dsa_art_14_terms_and_conditions_order_compliant).
expected_roll_up(todo_baseline_subject, dsa_art_14_terms_and_conditions_order_compliant).
expected_roll_up(very_large_platform_without_summary, dsa_art_14_terms_and_conditions_order_not_compliant).
expected_roll_up(small_hosting_service_no_complaint_system, dsa_art_14_terms_and_conditions_order_compliant).
expected_roll_up(complaint_system_without_rules, dsa_art_14_terms_and_conditions_order_not_compliant).
expected_roll_up(missing_content_moderation_information, dsa_art_14_terms_and_conditions_order_not_compliant).
expected_roll_up(significant_change_not_notified, dsa_art_14_terms_and_conditions_order_not_compliant).
expected_roll_up(insignificant_change_not_notified, dsa_art_14_terms_and_conditions_order_compliant).
expected_roll_up(minors_service_unclear_explanation, dsa_art_14_terms_and_conditions_order_not_compliant).
expected_roll_up(service_not_for_minors, dsa_art_14_terms_and_conditions_order_compliant).
expected_roll_up(disproportionate_enforcement, dsa_art_14_terms_and_conditions_order_not_compliant).
expected_roll_up(no_restriction_enforced, dsa_art_14_terms_and_conditions_order_compliant).
expected_roll_up(designation_absent_summary_unsure, dsa_art_14_terms_and_conditions_order_indeterminate).
expected_roll_up(designated_summary_unsure, dsa_art_14_terms_and_conditions_order_indeterminate).
expected_roll_up(designation_attested_false, dsa_art_14_terms_and_conditions_order_compliant).
expected_roll_up(designation_attested_true, dsa_art_14_terms_and_conditions_order_not_compliant).
expected_roll_up(unsure_language_judgement, dsa_art_14_terms_and_conditions_order_indeterminate).
expected_roll_up(malformed_duplicate_and_unknown_keys, dsa_art_14_terms_and_conditions_order_indeterminate).
expected_roll_up(well_formed_change_only, dsa_art_14_terms_and_conditions_order_indeterminate).
expected_roll_up(unbound_key, dsa_art_14_terms_and_conditions_order_indeterminate).
expected_roll_up(empty_profile, dsa_art_14_terms_and_conditions_order_indeterminate).

roll_up_matches(Subject - ExpectedStatus) :-
    roll_ups(Subject, Statuses),
    Statuses == [ExpectedStatus].

one_answer_per_query(Subject) :-
    contract_queries(Queries),
    maplist(one_answer(Subject), Queries).

one_answer(Subject, Query) :-
    answers(Query, Subject, Answers),
    length(Answers, 1).

cited_six_item_checklist(Subject) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    dsa_art_14_terms_and_conditions_order_checklist(Profile, Items),
    length(Items, 6),
    maplist(cited_item, Items).

cited_item(item(_, _, cite(_))).

test(every_subject_has_an_expected_roll_up) :-
    findall(Subject, dsa_art_14_terms_and_conditions_order_subject(Subject), Subjects),
    findall(Subject, expected_roll_up(Subject, _), ExpectedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_roll_up) :-
    findall(Subject - Status, expected_roll_up(Subject, Status), Expectations),
    maplist(roll_up_matches, Expectations).
test(every_query_gives_exactly_one_answer_on_every_subject) :-
    findall(Subject, dsa_art_14_terms_and_conditions_order_subject(Subject), Subjects),
    maplist(one_answer_per_query, Subjects).
test(every_subject_has_a_six_item_checklist_cited_per_item) :-
    findall(Subject, dsa_art_14_terms_and_conditions_order_subject(Subject), Subjects),
    maplist(cited_six_item_checklist, Subjects).
test(the_roll_up_label_is_in_the_status_vocabulary) :-
    dsa_art_14_terms_and_conditions_order_assess(fully_compliant_very_large_platform, dsa_art_14_terms_and_conditions_order_verdict(Status, _)),
    dsa_art_14_terms_and_conditions_order_status_values(StatusValues),
    member(Status, StatusValues).
test(the_verdict_cites_the_six_paragraphs) :-
    findall(Verdict, dsa_art_14_terms_and_conditions_order_assess(fully_compliant_very_large_platform, Verdict), Verdicts),
    Verdicts == [dsa_art_14_terms_and_conditions_order_verdict(dsa_art_14_terms_and_conditions_order_compliant, [cite(eu_reg_2022_2065_art_14_1), cite(eu_reg_2022_2065_art_14_2), cite(eu_reg_2022_2065_art_14_3), cite(eu_reg_2022_2065_art_14_4), cite(eu_reg_2022_2065_art_14_5), cite(eu_reg_2022_2065_art_14_6)])].
test(the_decision_resolves_on_a_malformed_profile) :-
    dsa_art_14_terms_and_conditions_order_profile_for(malformed_duplicate_and_unknown_keys, Profile),
    dsa_art_14_terms_and_conditions_order_decision_resolvable(Profile).
test(the_checklist_names_the_breach_with_its_citation) :-
    dsa_art_14_terms_and_conditions_order_profile_for(very_large_platform_without_summary, Profile),
    dsa_art_14_terms_and_conditions_order_checklist(Profile, Items),
    member(item(art_14_5, unmet(art_14_5_summary_not_compliant), cite(eu_reg_2022_2065_art_14_5)), Items).
test(fully_compliant_very_large_platform_meets_all_six_duties) :-
    designated_statement(Statement),
    answers(art_14_1_terms_and_conditions_content_status, fully_compliant_very_large_platform, FirstAnswers),
    FirstAnswers == [art_14_1_terms_and_conditions_compliant - [] - [cite(eu_reg_2022_2065_art_14_1)]],
    answers(art_14_2_significant_change_information_status, fully_compliant_very_large_platform, SecondAnswers),
    SecondAnswers == [art_14_2_change_information_compliant - [] - [cite(eu_reg_2022_2065_art_14_2)]],
    answers(art_14_3_minors_explanation_status, fully_compliant_very_large_platform, ThirdAnswers),
    ThirdAnswers == [art_14_3_minors_explanation_compliant - [] - [cite(eu_reg_2022_2065_art_14_3)]],
    answers(art_14_4_restriction_enforcement_status, fully_compliant_very_large_platform, FourthAnswers),
    FourthAnswers == [art_14_4_restriction_enforcement_compliant - [] - [cite(eu_reg_2022_2065_art_14_4)]],
    answers(art_14_5_terms_and_conditions_summary_status, fully_compliant_very_large_platform, FifthAnswers),
    FifthAnswers == [art_14_5_summary_compliant - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_5)]],
    answers(art_14_6_official_languages_status, fully_compliant_very_large_platform, SixthAnswers),
    SixthAnswers == [art_14_6_official_languages_compliant - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_6)]].
test(very_large_platform_without_summary_is_not_compliant_with_the_statement_as_basis) :-
    designated_statement(Statement),
    answers(art_14_5_terms_and_conditions_summary_status, very_large_platform_without_summary, Answers),
    Answers == [art_14_5_summary_not_compliant - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_5)]].
test(small_hosting_service_complies_with_14_1_and_owes_nothing_else) :-
    not_designated_statement(Statement),
    answers(art_14_1_terms_and_conditions_content_status, small_hosting_service_no_complaint_system, FirstAnswers),
    FirstAnswers == [art_14_1_terms_and_conditions_compliant - [] - [cite(eu_reg_2022_2065_art_14_1)]],
    answers(art_14_2_significant_change_information_status, small_hosting_service_no_complaint_system, SecondAnswers),
    SecondAnswers == [art_14_2_change_information_not_required - [] - [cite(eu_reg_2022_2065_art_14_2)]],
    answers(art_14_3_minors_explanation_status, small_hosting_service_no_complaint_system, ThirdAnswers),
    ThirdAnswers == [art_14_3_minors_explanation_not_required - [] - [cite(eu_reg_2022_2065_art_14_3)]],
    answers(art_14_4_restriction_enforcement_status, small_hosting_service_no_complaint_system, FourthAnswers),
    FourthAnswers == [art_14_4_restriction_enforcement_not_required - [] - [cite(eu_reg_2022_2065_art_14_4)]],
    answers(art_14_5_terms_and_conditions_summary_status, small_hosting_service_no_complaint_system, FifthAnswers),
    FifthAnswers == [art_14_5_summary_not_required - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_5)]],
    answers(art_14_6_official_languages_status, small_hosting_service_no_complaint_system, SixthAnswers),
    SixthAnswers == [art_14_6_official_languages_not_required - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_6)]].
test(complaint_system_without_rules_is_not_compliant) :-
    answers(art_14_1_terms_and_conditions_content_status, complaint_system_without_rules, Answers),
    Answers == [art_14_1_terms_and_conditions_not_compliant - [] - [cite(eu_reg_2022_2065_art_14_1)]].
test(missing_content_moderation_information_is_not_compliant) :-
    answers(art_14_1_terms_and_conditions_content_status, missing_content_moderation_information, Answers),
    Answers == [art_14_1_terms_and_conditions_not_compliant - [] - [cite(eu_reg_2022_2065_art_14_1)]].
test(significant_change_not_notified_is_not_compliant) :-
    answers(art_14_2_significant_change_information_status, significant_change_not_notified, Answers),
    Answers == [art_14_2_change_information_not_compliant - [] - [cite(eu_reg_2022_2065_art_14_2)]].
test(insignificant_change_not_notified_is_not_required) :-
    answers(art_14_2_significant_change_information_status, insignificant_change_not_notified, Answers),
    Answers == [art_14_2_change_information_not_required - [] - [cite(eu_reg_2022_2065_art_14_2)]].
test(minors_service_unclear_explanation_is_not_compliant) :-
    answers(art_14_3_minors_explanation_status, minors_service_unclear_explanation, Answers),
    Answers == [art_14_3_minors_explanation_not_compliant - [] - [cite(eu_reg_2022_2065_art_14_3)]].
test(service_not_for_minors_is_not_required) :-
    answers(art_14_3_minors_explanation_status, service_not_for_minors, Answers),
    Answers == [art_14_3_minors_explanation_not_required - [] - [cite(eu_reg_2022_2065_art_14_3)]].
test(disproportionate_enforcement_is_not_compliant) :-
    answers(art_14_4_restriction_enforcement_status, disproportionate_enforcement, Answers),
    Answers == [art_14_4_restriction_enforcement_not_compliant - [] - [cite(eu_reg_2022_2065_art_14_4)]].
test(no_restriction_enforced_is_not_required) :-
    answers(art_14_4_restriction_enforcement_status, no_restriction_enforced, Answers),
    Answers == [art_14_4_restriction_enforcement_not_required - [] - [cite(eu_reg_2022_2065_art_14_4)]].
test(designation_absent_summary_unsure_is_referred_on_for_the_summary) :-
    answers(art_14_5_terms_and_conditions_summary_status, designation_absent_summary_unsure, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_5), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on([concise_clear_machine_readable_summary_of_terms_and_conditions_provided - unsure, designated_as_very_large_online_platform_or_search_engine - absent])]) - [] - []].
test(designation_absent_summary_unsure_is_referred_on_for_the_languages) :-
    answers(art_14_6_official_languages_status, designation_absent_summary_unsure, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_6), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform_or_search_engine - absent])]) - [] - []].
test(designated_summary_unsure_goes_to_a_lawyer) :-
    answers(art_14_5_terms_and_conditions_summary_status, designated_summary_unsure, Answers),
    Answers == [needs_legal_review(open_textured(concise_clear_machine_readable_summary_of_terms_and_conditions_provided, cite(eu_reg_2022_2065_art_14_5)), [inputs_relied_on([concise_clear_machine_readable_summary_of_terms_and_conditions_provided - unsure])]) - [] - []].
test(designated_summary_unsure_publishes_in_every_language) :-
    designated_statement(Statement),
    answers(art_14_6_official_languages_status, designated_summary_unsure, Answers),
    Answers == [art_14_6_official_languages_compliant - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_6)]].
test(designation_attested_false_is_not_required_for_both) :-
    not_designated_statement(Statement),
    answers(art_14_5_terms_and_conditions_summary_status, designation_attested_false, SummaryAnswers),
    SummaryAnswers == [art_14_5_summary_not_required - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_5)]],
    answers(art_14_6_official_languages_status, designation_attested_false, LanguageAnswers),
    LanguageAnswers == [art_14_6_official_languages_not_required - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_6)]].
test(designation_attested_true_is_not_compliant_for_both) :-
    designated_statement(Statement),
    answers(art_14_5_terms_and_conditions_summary_status, designation_attested_true, SummaryAnswers),
    SummaryAnswers == [art_14_5_summary_not_compliant - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_5)]],
    answers(art_14_6_official_languages_status, designation_attested_true, LanguageAnswers),
    LanguageAnswers == [art_14_6_official_languages_not_compliant - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_6)]].
test(what_if_the_designation_is_stated_false_the_breaches_lift) :-
    dsa_art_14_terms_and_conditions_order_profile_for(designation_attested_true, Profile),
    not_designated_statement(Statement),
    findall(NewStatus, dsa_art_14_terms_and_conditions_order_what_if(Profile, designated_as_very_large_online_platform_or_search_engine, Statement, NewStatus), Statuses),
    Statuses == [dsa_art_14_terms_and_conditions_order_compliant].
test(what_if_the_summary_is_withdrawn_the_platform_breaches) :-
    dsa_art_14_terms_and_conditions_order_profile_for(fully_compliant_very_large_platform, Profile),
    dsa_art_14_terms_and_conditions_order_what_if(Profile, concise_clear_machine_readable_summary_of_terms_and_conditions_provided, false, dsa_art_14_terms_and_conditions_order_not_compliant).
test(url_evidence_is_copied_into_the_basis) :-
    Statement = attested(true, attestation(host_service, attestation_time, commission_designation_decision, url(designation_list_address, retrieval_time))),
    Profile = [attribute(terms_and_conditions_published_in_official_languages_of_all_member_states_of_service, true), attribute(designated_as_very_large_online_platform_or_search_engine, Statement)],
    findall(Result - Basis - Citations, art_14_6_official_languages_status(Profile, Result, Basis, Citations), Answers),
    Answers == [art_14_6_official_languages_compliant - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_6)]].
test(url_evidence_with_an_unbound_part_is_wrong_type) :-
    Profile = [attribute(designated_as_very_large_online_platform_or_search_engine, attested(true, attestation(host_service, attestation_time, commission_designation_decision, url(_UnboundAddress, retrieval_time))))],
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems),
    Problems == [wrong_type(designated_as_very_large_online_platform_or_search_engine)].
test(document_evidence_is_copied_into_the_basis) :-
    Statement = attested(false, attestation(host_service, attestation_time, commission_designation_list, document(upload_identifier, document_digest))),
    Profile = [attribute(designated_as_very_large_online_platform_or_search_engine, Statement)],
    findall(Result - Basis - Citations, art_14_5_terms_and_conditions_summary_status(Profile, Result, Basis, Citations), Answers),
    Answers == [art_14_5_summary_not_required - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_5)]].
test(document_evidence_with_an_unbound_part_is_wrong_type) :-
    Profile = [attribute(designated_as_very_large_online_platform_or_search_engine, attested(false, attestation(host_service, attestation_time, commission_designation_list, document(upload_identifier, _UnboundDigest))))],
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems),
    Problems == [wrong_type(designated_as_very_large_online_platform_or_search_engine)].
test(provenance_reason_is_accepted_and_copied_into_the_basis) :-
    Statement = attested(true, attestation(host_service, attestation_time, provenance(commission_designation_decision, designation_list), none)),
    Profile = [attribute(concise_clear_machine_readable_summary_of_terms_and_conditions_provided, true), attribute(designated_as_very_large_online_platform_or_search_engine, Statement)],
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems),
    Problems == [],
    findall(Result - Basis - Citations, art_14_5_terms_and_conditions_summary_status(Profile, Result, Basis, Citations), Answers),
    Answers == [art_14_5_summary_compliant - [outside_fact(designated_as_very_large_online_platform_or_search_engine, Statement)] - [cite(eu_reg_2022_2065_art_14_5)]].
test(provenance_reason_with_an_unbound_part_is_wrong_type) :-
    Profile = [attribute(designated_as_very_large_online_platform_or_search_engine, attested(true, attestation(host_service, attestation_time, provenance(commission_designation_decision, _UnboundSource), none)))],
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems),
    Problems == [wrong_type(designated_as_very_large_online_platform_or_search_engine)].
test(unsure_language_judgement_goes_to_a_lawyer) :-
    answers(art_14_1_terms_and_conditions_content_status, unsure_language_judgement, Answers),
    Answers == [needs_legal_review(open_textured(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, cite(eu_reg_2022_2065_art_14_1)), [inputs_relied_on([terms_and_conditions_include_information_on_restrictions_on_recipient_information - true, terms_and_conditions_include_information_on_content_moderation - true, terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language - unsure, terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format - true])]) - [] - []].
test(malformed_profile_lists_its_problems_in_order) :-
    dsa_art_14_terms_and_conditions_order_profile_for(malformed_duplicate_and_unknown_keys, Profile),
    findall(Problems, dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(terms_and_conditions_changed), unknown_key(stray_key)]].
test(malformed_profile_gives_input_problems_to_every_query) :-
    contract_queries(Queries),
    maplist(input_problems_answer(malformed_duplicate_and_unknown_keys), Queries).
test(well_formed_change_only_has_no_problem_and_names_significance) :-
    dsa_art_14_terms_and_conditions_order_profile_for(well_formed_change_only, Profile),
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems),
    Problems == [],
    answers(art_14_2_significant_change_information_status, well_formed_change_only, Answers),
    Answers == [indeterminate([change_to_terms_and_conditions_is_significant]) - [] - []].
test(unbound_key_is_reported_as_given) :-
    dsa_art_14_terms_and_conditions_order_profile_for(unbound_key, Profile),
    Profile = [attribute(GivenKey, _)],
    art_14_2_significant_change_information_status(Profile, Result, Basis, Citations),
    Result = input_problems([unknown_key(NamedKey)]),
    NamedKey == GivenKey,
    Basis == [],
    Citations == [].
test(empty_profile_names_one_missing_key_per_query) :-
    answers(art_14_1_terms_and_conditions_content_status, empty_profile, FirstAnswers),
    FirstAnswers == [indeterminate([terms_and_conditions_include_information_on_restrictions_on_recipient_information]) - [] - []],
    answers(art_14_2_significant_change_information_status, empty_profile, SecondAnswers),
    SecondAnswers == [indeterminate([terms_and_conditions_changed]) - [] - []],
    answers(art_14_3_minors_explanation_status, empty_profile, ThirdAnswers),
    ThirdAnswers == [indeterminate([service_primarily_directed_at_minors]) - [] - []],
    answers(art_14_4_restriction_enforcement_status, empty_profile, FourthAnswers),
    FourthAnswers == [indeterminate([provider_applies_or_enforces_restriction]) - [] - []],
    answers(art_14_5_terms_and_conditions_summary_status, empty_profile, FifthAnswers),
    FifthAnswers == [indeterminate([concise_clear_machine_readable_summary_of_terms_and_conditions_provided]) - [] - []],
    answers(art_14_6_official_languages_status, empty_profile, SixthAnswers),
    SixthAnswers == [indeterminate([terms_and_conditions_published_in_official_languages_of_all_member_states_of_service]) - [] - []].

test(very_large_platform_without_summary_is_not_summary_compliant, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(very_large_platform_without_summary, Profile),
    art_14_5_terms_and_conditions_summary_status(Profile, art_14_5_summary_compliant, _, _).
test(complaint_system_without_rules_is_not_compliant_not_compliant, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(complaint_system_without_rules, Profile),
    art_14_1_terms_and_conditions_content_status(Profile, art_14_1_terms_and_conditions_compliant, _, _).
test(significant_change_not_notified_is_not_change_compliant, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(significant_change_not_notified, Profile),
    art_14_2_significant_change_information_status(Profile, art_14_2_change_information_compliant, _, _).
test(minors_service_unclear_explanation_is_not_minors_compliant, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(minors_service_unclear_explanation, Profile),
    art_14_3_minors_explanation_status(Profile, art_14_3_minors_explanation_compliant, _, _).
test(disproportionate_enforcement_is_not_enforcement_compliant, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(disproportionate_enforcement, Profile),
    art_14_4_restriction_enforcement_status(Profile, art_14_4_restriction_enforcement_compliant, _, _).
test(designation_attested_true_is_not_summary_not_required, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(designation_attested_true, Profile),
    art_14_5_terms_and_conditions_summary_status(Profile, art_14_5_summary_not_required, _, _).
test(unsure_language_judgement_is_not_compliant_yet, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(unsure_language_judgement, Profile),
    art_14_1_terms_and_conditions_content_status(Profile, art_14_1_terms_and_conditions_compliant, _, _).

input_problems_answer(Subject, Query) :-
    answers(Query, Subject, Answers),
    Answers == [input_problems([duplicate_key(terms_and_conditions_changed), unknown_key(stray_key)]) - [] - []].

cp_test_names([every_subject_has_an_expected_roll_up, every_subject_resolves_to_its_expected_roll_up, every_query_gives_exactly_one_answer_on_every_subject, every_subject_has_a_six_item_checklist_cited_per_item, the_roll_up_label_is_in_the_status_vocabulary, the_verdict_cites_the_six_paragraphs, the_decision_resolves_on_a_malformed_profile, the_checklist_names_the_breach_with_its_citation, fully_compliant_very_large_platform_meets_all_six_duties, very_large_platform_without_summary_is_not_compliant_with_the_statement_as_basis, small_hosting_service_complies_with_14_1_and_owes_nothing_else, complaint_system_without_rules_is_not_compliant, missing_content_moderation_information_is_not_compliant, significant_change_not_notified_is_not_compliant, insignificant_change_not_notified_is_not_required, minors_service_unclear_explanation_is_not_compliant, service_not_for_minors_is_not_required, disproportionate_enforcement_is_not_compliant, no_restriction_enforced_is_not_required, designation_absent_summary_unsure_is_referred_on_for_the_summary, designation_absent_summary_unsure_is_referred_on_for_the_languages, designated_summary_unsure_goes_to_a_lawyer, designated_summary_unsure_publishes_in_every_language, designation_attested_false_is_not_required_for_both, designation_attested_true_is_not_compliant_for_both, what_if_the_designation_is_stated_false_the_breaches_lift, what_if_the_summary_is_withdrawn_the_platform_breaches, url_evidence_is_copied_into_the_basis, url_evidence_with_an_unbound_part_is_wrong_type, document_evidence_is_copied_into_the_basis, document_evidence_with_an_unbound_part_is_wrong_type, provenance_reason_is_accepted_and_copied_into_the_basis, provenance_reason_with_an_unbound_part_is_wrong_type, unsure_language_judgement_goes_to_a_lawyer, malformed_profile_lists_its_problems_in_order, malformed_profile_gives_input_problems_to_every_query, well_formed_change_only_has_no_problem_and_names_significance, unbound_key_is_reported_as_given, empty_profile_names_one_missing_key_per_query]).
cp_test_fail_names([very_large_platform_without_summary_is_not_summary_compliant, complaint_system_without_rules_is_not_compliant_not_compliant, significant_change_not_notified_is_not_change_compliant, minors_service_unclear_explanation_is_not_minors_compliant, disproportionate_enforcement_is_not_enforcement_compliant, designation_attested_true_is_not_summary_not_required, unsure_language_judgement_is_not_compliant_yet]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
