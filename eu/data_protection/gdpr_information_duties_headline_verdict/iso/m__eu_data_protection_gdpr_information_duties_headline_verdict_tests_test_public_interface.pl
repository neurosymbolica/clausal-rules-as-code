% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3, information_outside_facts/2, information_duty_verdict_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_queries, [gdpr_information_duties_headline_verdict_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_subject/1, gdpr_information_duties_headline_verdict_profile_for/2, gdpr_information_duties_headline_verdict_assess/2]).

test(art13_on_time_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_13_1)]).
test(art13_one_day_late_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_1)]).
test(art13_missing_item_is_ineligible_with_its_cite) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_missing_statutory_item, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_2_e)]).
test(art13_unsure_automated_decision_is_referred) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_unsure_automated_decision, Profile),
    information_duty_verdict(Profile, needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])]), []).
test(art13_automated_decision_false_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_automated_decision_false, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art13_further_processing_prior_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_further_processing_prior, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_13_1), cite(eu_reg_2016_679_art_13_3)]).
test(art13_further_processing_same_day_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_further_processing_same_day, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_3)]).
test(art14_on_time_at_boundary_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_on_time_at_boundary, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_one_day_late_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_one_day_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_communication_limb_on_time_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_communication_limb_on_time, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(art14_communication_limb_late_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_communication_limb_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_b)]).
test(art14_month_end_on_time_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_month_end_on_time, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art14_month_end_late_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_month_end_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_holiday_shift_on_time_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_holiday_shift_on_time, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art14_holiday_absent_is_late) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_holiday_absent_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_effort_exemption_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_exemption, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_5_b)]),
    information_duty_exemption(Profile, impossible_or_disproportionate_effort).
test(art14_effort_without_measures_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_without_measures, Profile),
    information_duty_verdict(Profile, ineligible, [_|_]),
    information_duty_exemption(Profile, none).
test(art14_effort_unsure_is_referred) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_unsure, Profile),
    information_duty_verdict(Profile, needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])]), []).
test(art14_law_exemption_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_law_exemption, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_5_c)]),
    information_duty_exemption(Profile, law_lays_down_obtaining_or_disclosure).
test(art14_law_attested_false_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_law_attested_false, Profile),
    information_duty_verdict(Profile, ineligible, [_|_]),
    information_duty_exemption(Profile, none).
test(art14_secrecy_exemption_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_secrecy_exemption, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_5_d)]),
    information_duty_exemption(Profile, professional_secrecy_obligation).
test(art13_has_no_exemption) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_exemption(Profile, none).
test(empty_profile_names_the_absent_keys) :-
    gdpr_information_duties_headline_verdict_profile_for(empty_profile, Profile),
    information_duty_verdict(Profile, indeterminate([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, obtaining_date, provision_date, further_processing_for_another_purpose_intended]), []).
test(unknown_key_is_reported) :-
    gdpr_information_duties_headline_verdict_profile_for(input_unknown_key, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, [unknown_key(no_such_key)]),
    information_duty_verdict(Profile, input_problems([unknown_key(no_such_key)]), []).
test(wrong_type_is_reported) :-
    gdpr_information_duties_headline_verdict_profile_for(input_wrong_type, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, [wrong_type(items_provided)]),
    information_duty_verdict(Profile, input_problems([wrong_type(items_provided)]), []).
test(duplicate_key_is_reported) :-
    gdpr_information_duties_headline_verdict_profile_for(input_duplicate_key, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, [duplicate_key(personal_data_collected_from_data_subject)]).
test(not_a_profile_is_reported) :-
    gdpr_information_duties_headline_verdict_profile_for(input_not_a_profile, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, [wrong_type(profile)]),
    information_duty_exemption(Profile, input_problems([wrong_type(profile)])).
test(a_clean_profile_has_no_problem) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, []).
test(outside_facts_report_attested_and_absent) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_holiday_shift_on_time, Profile),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, attested([date(2027, 2, 1)], attestation(host, none, fixture_reason, none)))]).
test(outside_facts_input_problem) :-
    gdpr_information_duties_headline_verdict_profile_for(input_not_a_profile, Profile),
    information_outside_facts(Profile, input_problems([wrong_type(profile)])).
test(url_evidence_is_accepted_and_copied) :-
    Evidence = url('https://eur-lex.europa.eu/eli/reg/2016/679/oj', retrieved_2026_11_07),
    Evidence = url(Address, RetrievedAt),
    Address == 'https://eur-lex.europa.eu/eli/reg/2016/679/oj',
    RetrievedAt == retrieved_2026_11_07,
    Profile = [attribute(personal_data_collected_from_data_subject, true), attribute(public_holidays, attested([], attestation(host, at_time, holiday_notice, url('https://eur-lex.europa.eu/eli/reg/2016/679/oj', retrieved_2026_11_07))))],
    gdpr_information_duties_headline_verdict_input_problems(Profile, []),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, attested([], attestation(host, at_time, holiday_notice, url('https://eur-lex.europa.eu/eli/reg/2016/679/oj', retrieved_2026_11_07))))]).
test(document_evidence_is_accepted_and_copied) :-
    Evidence = document(upload_one, sha_one),
    Evidence = document(UploadIdentifier, Digest),
    UploadIdentifier == upload_one,
    Digest == sha_one,
    Profile = [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_or_disclosure_laid_down_by_law, attested(true, attestation(host, at_time, statute, document(upload_one, sha_one))))],
    gdpr_information_duties_headline_verdict_input_problems(Profile, []),
    information_duty_exemption(Profile, law_lays_down_obtaining_or_disclosure),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, attested(true, attestation(host, at_time, statute, document(upload_one, sha_one)))), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, absent)]).
test(provenance_marks_the_deciding_clause) :-
    Context = [inputs_relied_on([]), provenance(art14_5_b, [cite(eu_reg_2016_679_art_14_5_b)])],
    Context = [inputs_relied_on(Pairs), provenance(Clause, Citations)],
    Pairs == [],
    Clause == art14_5_b,
    Citations == [cite(eu_reg_2016_679_art_14_5_b)].
test(provenance_is_optional_in_the_context) :-
    Context = [inputs_relied_on([])],
    Context = [inputs_relied_on(_Pairs)],
    Context \= [_, provenance(_, _)].
test(checklist_is_non_empty) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_verdict_checklist(Profile, [_FirstItem|_OtherItems]).
test(assess_wrapper_gives_the_verdict) :-
    gdpr_information_duties_headline_verdict_assess(art14_one_day_late, verdict(ineligible, [cite(eu_reg_2016_679_art_14_3_a)])).
test(what_if_late_provision_flips_to_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, provision_date, date(2026, 3, 3), ineligible).
test(what_if_same_value_keeps_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, provision_date, date(2026, 3, 2), eligible).
test(each_answer_is_yielded_once) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_on_time_at_boundary, Profile),
    findall(Verdict - Citations, information_duty_verdict(Profile, Verdict, Citations), Answers),
    Answers == [eligible - [cite(eu_reg_2016_679_art_14_1)]].
test(every_subject_resolves) :-
    gdpr_information_duties_headline_verdict_subject(Subject),
    gdpr_information_duties_headline_verdict_assess(Subject, verdict(_Status, _Citations)).

test(art13_one_day_late_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art14_one_day_late_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_one_day_late, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art14_effort_without_measures_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_without_measures, Profile),
    information_duty_verdict(Profile, eligible, _).
test(url_evidence_is_not_a_document, fail) :-
    url(Address, _RetrievedAt) = document(upload_one, sha_one),
    Address == upload_one.
test(what_if_late_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, provision_date, date(2026, 3, 3), eligible).

cp_test_names([art13_on_time_is_eligible, art13_one_day_late_is_ineligible, art13_missing_item_is_ineligible_with_its_cite, art13_unsure_automated_decision_is_referred, art13_automated_decision_false_is_eligible, art13_further_processing_prior_is_eligible, art13_further_processing_same_day_is_ineligible, art14_on_time_at_boundary_is_eligible, art14_one_day_late_is_ineligible, art14_communication_limb_on_time_is_eligible, art14_communication_limb_late_is_ineligible, art14_month_end_on_time_is_eligible, art14_month_end_late_is_ineligible, art14_holiday_shift_on_time_is_eligible, art14_holiday_absent_is_late, art14_effort_exemption_is_eligible, art14_effort_without_measures_is_ineligible, art14_effort_unsure_is_referred, art14_law_exemption_is_eligible, art14_law_attested_false_is_ineligible, art14_secrecy_exemption_is_eligible, art13_has_no_exemption, empty_profile_names_the_absent_keys, unknown_key_is_reported, wrong_type_is_reported, duplicate_key_is_reported, not_a_profile_is_reported, a_clean_profile_has_no_problem, outside_facts_report_attested_and_absent, outside_facts_input_problem, url_evidence_is_accepted_and_copied, document_evidence_is_accepted_and_copied, provenance_marks_the_deciding_clause, provenance_is_optional_in_the_context, checklist_is_non_empty, assess_wrapper_gives_the_verdict, what_if_late_provision_flips_to_ineligible, what_if_same_value_keeps_eligible, each_answer_is_yielded_once, every_subject_resolves]).
cp_test_fail_names([art13_one_day_late_is_not_eligible, art14_one_day_late_is_not_eligible, art14_effort_without_measures_is_not_eligible, url_evidence_is_not_a_document, what_if_late_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
