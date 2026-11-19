% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3, information_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2, information_duty_exemption_checklist/2, information_duty_exemption_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_subject/1, gdpr_information_duties_headline_verdict_profile_for/2, gdpr_information_duties_headline_verdict_assess/2]).

expected_headline(article_13_complete_on_obtaining_day, eligible, [cite(eu_reg_2016_679_art_13_1)]).
expected_headline(article_13_complete_one_day_after_obtaining, ineligible, [cite(eu_reg_2016_679_art_13_1)]).
expected_headline(article_13_requirement_item_missing, ineligible, [cite(eu_reg_2016_679_art_13_2_e)]).
expected_headline(article_13_automated_decision_unsure, needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])]), []).
expected_headline(article_13_automated_decision_item_missing, ineligible, [cite(eu_reg_2016_679_art_13_2_f)]).
expected_headline(article_13_further_processing_informed_day_before, eligible, [cite(eu_reg_2016_679_art_13_1), cite(eu_reg_2016_679_art_13_3)]).
expected_headline(article_13_further_processing_informed_same_day, ineligible, [cite(eu_reg_2016_679_art_13_3)]).
expected_headline(article_14_on_last_day_of_month, eligible, [cite(eu_reg_2016_679_art_14_1)]).
expected_headline(article_14_day_after_last_day_of_month, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_headline(article_14_month_end_shifted_past_weekend, eligible, [cite(eu_reg_2016_679_art_14_1)]).
expected_headline(article_14_day_after_shifted_month_end, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_headline(article_14_holiday_shifted_last_day, eligible, [cite(eu_reg_2016_679_art_14_1)]).
expected_headline(article_14_day_after_holiday_shifted_last_day, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_headline(article_14_first_communication_on_the_day, eligible, [cite(eu_reg_2016_679_art_14_1)]).
expected_headline(article_14_first_communication_day_after, ineligible, [cite(eu_reg_2016_679_art_14_3_b)]).
expected_headline(article_14_source_missing_law_attested_false, ineligible, [cite(eu_reg_2016_679_art_14_2_f)]).
expected_headline(article_14_source_missing_law_attested_true, eligible, [cite(eu_reg_2016_679_art_14_5_c)]).
expected_headline(article_14_effort_unsure_with_measures, needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])]), []).
expected_headline(article_14_effort_with_measures, eligible, [cite(eu_reg_2016_679_art_14_5_b)]).
expected_headline(article_14_only_the_route, indeterminate([items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, disclosure_to_another_recipient_envisaged, provision_impossible_or_disproportionate_effort, protective_measures_taken, further_processing_for_another_purpose_intended]), []).
expected_headline(route_not_supplied, indeterminate([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, further_processing_for_another_purpose_intended]), []).
expected_headline(input_problems_mix, input_problems([duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)]), []).
expected_headline(not_a_profile, input_problems([wrong_type(profile)]), []).

headline_answers(Subject, Answers) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    findall(Verdict - Citations, information_duty_verdict(Profile, Verdict, Citations), Answers).

resolves_as_expected(Subject) :-
    expected_headline(Subject, Verdict, Citations),
    headline_answers(Subject, Answers),
    Answers == [Verdict - Citations].

headline_is(Subject, Verdict) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    information_duty_verdict(Profile, Verdict, _).

exemption_answers(Subject, Answers) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    findall(Exemption, information_duty_exemption(Profile, Exemption), Answers).

has_checklist(Subject) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    information_duty_exemption_checklist(Profile, [_FirstItem|_OtherItems]).

final_verdict_is_cited(Subject) :-
    expected_headline(Subject, Verdict, Citations),
    final_citations(Verdict, Citations).

final_citations(eligible, [_|_]).
final_citations(ineligible, [_|_]).
final_citations(indeterminate(_), []).
final_citations(needs_legal_review(_, _), []).
final_citations(input_problems(_), []).

test(every_subject_resolves_to_its_expected_verdict_once) :-
    findall(Subject, gdpr_information_duties_headline_verdict_subject(Subject), Subjects),
    length(Subjects, 23),
    maplist(resolves_as_expected, Subjects).
test(every_subject_has_a_nonempty_checklist) :-
    findall(Subject, gdpr_information_duties_headline_verdict_subject(Subject), Subjects),
    maplist(has_checklist, Subjects).
test(final_verdicts_carry_citations_and_non_final_none) :-
    findall(Subject, gdpr_information_duties_headline_verdict_subject(Subject), Subjects),
    maplist(final_verdict_is_cited, Subjects).
test(the_assess_wrapper_packages_the_headline) :-
    gdpr_information_duties_headline_verdict_assess(article_13_complete_on_obtaining_day, information_duty_verdict_result(eligible, [cite(eu_reg_2016_679_art_13_1)])).
test(article_13_on_the_obtaining_day_is_eligible) :-
    resolves_as_expected(article_13_complete_on_obtaining_day).
test(article_13_one_day_after_is_ineligible) :-
    resolves_as_expected(article_13_complete_one_day_after_obtaining).
test(article_13_requirement_item_missing_is_ineligible) :-
    resolves_as_expected(article_13_requirement_item_missing).
test(article_13_unsure_automated_decision_refers) :-
    resolves_as_expected(article_13_automated_decision_unsure).
test(article_13_automated_decision_item_missing_is_ineligible) :-
    resolves_as_expected(article_13_automated_decision_item_missing).
test(further_processing_informed_day_before_is_eligible) :-
    resolves_as_expected(article_13_further_processing_informed_day_before).
test(further_processing_informed_same_day_is_ineligible) :-
    resolves_as_expected(article_13_further_processing_informed_same_day).
test(article_14_on_the_shifted_last_day_is_eligible) :-
    resolves_as_expected(article_14_on_last_day_of_month).
test(article_14_day_after_the_last_day_is_ineligible) :-
    resolves_as_expected(article_14_day_after_last_day_of_month).
test(article_14_month_end_past_weekend_is_eligible) :-
    resolves_as_expected(article_14_month_end_shifted_past_weekend).
test(article_14_day_after_shifted_month_end_is_ineligible) :-
    resolves_as_expected(article_14_day_after_shifted_month_end).
test(article_14_attested_holiday_last_day_is_eligible) :-
    resolves_as_expected(article_14_holiday_shifted_last_day).
test(article_14_day_after_attested_holiday_last_day_is_ineligible) :-
    resolves_as_expected(article_14_day_after_holiday_shifted_last_day).
test(article_14_first_communication_on_the_day_is_eligible) :-
    resolves_as_expected(article_14_first_communication_on_the_day).
test(article_14_first_communication_day_after_is_ineligible) :-
    resolves_as_expected(article_14_first_communication_day_after).
test(law_attested_true_settles_an_unmet_base) :-
    resolves_as_expected(article_14_source_missing_law_attested_true).
test(law_attested_false_leaves_the_base_unmet) :-
    resolves_as_expected(article_14_source_missing_law_attested_false).
test(effort_with_measures_is_eligible) :-
    resolves_as_expected(article_14_effort_with_measures).
test(unsure_effort_with_measures_refers) :-
    resolves_as_expected(article_14_effort_unsure_with_measures).
test(the_route_alone_lists_every_absent_key) :-
    resolves_as_expected(article_14_only_the_route).
test(no_route_names_the_keys_of_both_routes) :-
    resolves_as_expected(route_not_supplied).
test(input_problems_come_first_on_the_headline) :-
    resolves_as_expected(input_problems_mix).
test(not_a_profile_is_an_input_problem_on_the_headline) :-
    resolves_as_expected(not_a_profile).
test(article_13_exemption_is_none) :-
    exemption_answers(article_13_complete_on_obtaining_day, Answers),
    Answers == [none],
    information_duty_exemption_status_values(StatusValues),
    member(none, StatusValues).
test(article_14_without_grounds_exemption_is_none) :-
    exemption_answers(article_14_on_last_day_of_month, Answers),
    Answers == [none].
test(law_attested_true_names_its_exemption) :-
    exemption_answers(article_14_source_missing_law_attested_true, Answers),
    Answers == [law_lays_down_obtaining_or_disclosure].
test(law_attested_false_names_no_exemption) :-
    exemption_answers(article_14_source_missing_law_attested_false, Answers),
    Answers == [none].
test(effort_with_measures_names_its_exemption) :-
    exemption_answers(article_14_effort_with_measures, Answers),
    Answers == [impossible_or_disproportionate_effort].
test(unsure_effort_with_measures_refers_on_the_exemption) :-
    exemption_answers(article_14_effort_unsure_with_measures, Answers),
    Answers == [needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])])].
test(the_route_alone_names_both_limb_b_keys) :-
    exemption_answers(article_14_only_the_route, Answers),
    Answers == [indeterminate([provision_impossible_or_disproportionate_effort, protective_measures_taken])].
test(no_route_names_the_route_key_on_the_exemption) :-
    exemption_answers(route_not_supplied, Answers),
    Answers == [indeterminate([personal_data_collected_from_data_subject])].
test(input_problems_come_first_on_the_exemption) :-
    exemption_answers(input_problems_mix, Answers),
    Answers == [input_problems([duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)])].
test(not_a_profile_on_the_exemption) :-
    exemption_answers(not_a_profile, Answers),
    Answers == [input_problems([wrong_type(profile)])].
test(outside_facts_report_the_attested_holidays) :-
    gdpr_information_duties_headline_verdict_profile_for(article_14_holiday_shifted_last_day, Profile),
    findall(Facts, information_outside_facts(Profile, Facts), Answers),
    Answers == [[outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, attested([date(2027, 2, 1)], attestation(by, at, reason, none)))]].
test(outside_facts_report_the_attested_law) :-
    gdpr_information_duties_headline_verdict_profile_for(article_14_source_missing_law_attested_true, Profile),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, attested(true, attestation(by, at, reason, none))), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, absent)]).
test(outside_facts_absent_on_an_empty_profile) :-
    gdpr_information_duties_headline_verdict_profile_for(route_not_supplied, Profile),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, absent)]).
test(outside_facts_with_input_problems) :-
    gdpr_information_duties_headline_verdict_profile_for(input_problems_mix, Profile),
    information_outside_facts(Profile, input_problems([duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)])).
test(outside_facts_of_not_a_profile) :-
    information_outside_facts(foo, input_problems([wrong_type(profile)])).
test(url_evidence_is_copied_into_the_outside_facts) :-
    Evidence = url('https://eur-lex.europa.eu/example', date(2026, 11, 5)),
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(professional_secrecy_obligation_by_law, attested(true, attestation(host, at, statute, Evidence)))],
    gdpr_information_duties_headline_verdict_input_problems(Profile, []),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, attested(true, attestation(host, at, statute, url('https://eur-lex.europa.eu/example', date(2026, 11, 5))))), outside_fact(public_holidays, absent)]).
test(url_evidence_does_not_change_the_exemption) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(professional_secrecy_obligation_by_law, attested(true, attestation(host, at, statute, url('https://eur-lex.europa.eu/example', date(2026, 11, 5)))))], professional_secrecy_obligation).
test(document_evidence_is_copied_into_the_outside_facts) :-
    Profile = [attribute(public_holidays, attested([date(2026, 12, 25)], attestation(host, at, notice, document(upload_one, sha_value))))],
    gdpr_information_duties_headline_verdict_input_problems(Profile, []),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, attested([date(2026, 12, 25)], attestation(host, at, notice, document(upload_one, sha_value))))]).
test(document_evidence_with_false_law_is_none) :-
    information_duty_exemption([attribute(personal_data_collected_from_data_subject, false), attribute(provision_impossible_or_disproportionate_effort, false), attribute(obtaining_or_disclosure_laid_down_by_law, attested(false, attestation(host, at, statute, document(upload_two, sha_value))))], none).
test(a_referral_context_may_carry_provenance_after_the_pairs) :-
    Context = [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure, provenance(stage_three, [cite(eu_reg_2016_679_art_14_5_b)])])],
    Context = [inputs_relied_on([Key - Value, provenance(Clause, Citations)])],
    Key == provision_impossible_or_disproportionate_effort,
    Value == unsure,
    Clause == stage_three,
    Citations == [cite(eu_reg_2016_679_art_14_5_b)].
test(the_referral_pairs_hold_the_unsure_judgement) :-
    headline_is(article_14_effort_unsure_with_measures, needs_legal_review(_, [inputs_relied_on(Pairs)])),
    member(provision_impossible_or_disproportionate_effort - unsure, Pairs).
test(a_fixture_profile_has_no_problem) :-
    gdpr_information_duties_headline_verdict_profile_for(article_14_holiday_shifted_last_day, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, []).
test(the_mixed_profile_has_its_problems) :-
    gdpr_information_duties_headline_verdict_profile_for(input_problems_mix, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, [duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)]).
test(not_a_profile_is_wrong_type_profile) :-
    gdpr_information_duties_headline_verdict_input_problems(foo, [wrong_type(profile)]).

test(article_13_one_day_after_is_not_eligible, fail) :-
    headline_is(article_13_complete_one_day_after_obtaining, eligible).
test(article_13_on_the_obtaining_day_is_not_ineligible, fail) :-
    headline_is(article_13_complete_on_obtaining_day, ineligible).
test(article_13_requirement_item_missing_is_not_eligible, fail) :-
    headline_is(article_13_requirement_item_missing, eligible).
test(article_13_unsure_automated_decision_is_not_ineligible, fail) :-
    headline_is(article_13_automated_decision_unsure, ineligible).
test(further_processing_informed_same_day_is_not_eligible, fail) :-
    headline_is(article_13_further_processing_informed_same_day, eligible).
test(article_14_day_after_the_last_day_is_not_eligible, fail) :-
    headline_is(article_14_day_after_last_day_of_month, eligible).
test(article_14_day_after_shifted_month_end_is_not_eligible, fail) :-
    headline_is(article_14_day_after_shifted_month_end, eligible).
test(article_14_day_after_attested_holiday_last_day_is_not_eligible, fail) :-
    headline_is(article_14_day_after_holiday_shifted_last_day, eligible).
test(article_14_first_communication_day_after_is_not_eligible, fail) :-
    headline_is(article_14_first_communication_day_after, eligible).
test(law_attested_false_is_not_eligible, fail) :-
    headline_is(article_14_source_missing_law_attested_false, eligible).
test(unsure_effort_with_measures_is_not_eligible, fail) :-
    headline_is(article_14_effort_unsure_with_measures, eligible).
test(input_problems_are_not_eligible, fail) :-
    headline_is(input_problems_mix, eligible).
test(the_mixed_profile_is_not_clean, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(input_problems_mix, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, []).

cp_test_names([every_subject_resolves_to_its_expected_verdict_once, every_subject_has_a_nonempty_checklist, final_verdicts_carry_citations_and_non_final_none, the_assess_wrapper_packages_the_headline, article_13_on_the_obtaining_day_is_eligible, article_13_one_day_after_is_ineligible, article_13_requirement_item_missing_is_ineligible, article_13_unsure_automated_decision_refers, article_13_automated_decision_item_missing_is_ineligible, further_processing_informed_day_before_is_eligible, further_processing_informed_same_day_is_ineligible, article_14_on_the_shifted_last_day_is_eligible, article_14_day_after_the_last_day_is_ineligible, article_14_month_end_past_weekend_is_eligible, article_14_day_after_shifted_month_end_is_ineligible, article_14_attested_holiday_last_day_is_eligible, article_14_day_after_attested_holiday_last_day_is_ineligible, article_14_first_communication_on_the_day_is_eligible, article_14_first_communication_day_after_is_ineligible, law_attested_true_settles_an_unmet_base, law_attested_false_leaves_the_base_unmet, effort_with_measures_is_eligible, unsure_effort_with_measures_refers, the_route_alone_lists_every_absent_key, no_route_names_the_keys_of_both_routes, input_problems_come_first_on_the_headline, not_a_profile_is_an_input_problem_on_the_headline, article_13_exemption_is_none, article_14_without_grounds_exemption_is_none, law_attested_true_names_its_exemption, law_attested_false_names_no_exemption, effort_with_measures_names_its_exemption, unsure_effort_with_measures_refers_on_the_exemption, the_route_alone_names_both_limb_b_keys, no_route_names_the_route_key_on_the_exemption, input_problems_come_first_on_the_exemption, not_a_profile_on_the_exemption, outside_facts_report_the_attested_holidays, outside_facts_report_the_attested_law, outside_facts_absent_on_an_empty_profile, outside_facts_with_input_problems, outside_facts_of_not_a_profile, url_evidence_is_copied_into_the_outside_facts, url_evidence_does_not_change_the_exemption, document_evidence_is_copied_into_the_outside_facts, document_evidence_with_false_law_is_none, a_referral_context_may_carry_provenance_after_the_pairs, the_referral_pairs_hold_the_unsure_judgement, a_fixture_profile_has_no_problem, the_mixed_profile_has_its_problems, not_a_profile_is_wrong_type_profile]).
cp_test_fail_names([article_13_one_day_after_is_not_eligible, article_13_on_the_obtaining_day_is_not_ineligible, article_13_requirement_item_missing_is_not_eligible, article_13_unsure_automated_decision_is_not_ineligible, further_processing_informed_same_day_is_not_eligible, article_14_day_after_the_last_day_is_not_eligible, article_14_day_after_shifted_month_end_is_not_eligible, article_14_day_after_attested_holiday_last_day_is_not_eligible, article_14_first_communication_day_after_is_not_eligible, law_attested_false_is_not_eligible, unsure_effort_with_measures_is_not_eligible, input_problems_are_not_eligible, the_mixed_profile_is_not_clean]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
