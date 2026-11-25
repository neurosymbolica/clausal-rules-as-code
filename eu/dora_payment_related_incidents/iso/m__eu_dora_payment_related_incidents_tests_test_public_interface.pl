% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_payment_related_incidents_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_payment_related_incidents_dora_payment_related_incidents, [decide_dora_payment_related_incidents/2, dora_payment_related_incidents_status/2, dora_payment_related_incidents_checklist/2, dora_payment_related_incidents_decision_resolvable/1, dora_payment_related_incidents_status_values/1, payment_related_incident_status/3, payment_related_incident_report_recipients/3]).
:- use_module(m__eu_dora_payment_related_incidents_fixtures, [dora_payment_related_incidents_subject/1, dora_payment_related_incidents_profile_for/2, dora_payment_related_incidents_assess/2]).
:- use_module(m__eu_dora_payment_related_incidents_kernel, [dora_payment_related_incidents_input_problems/2]).
:- use_module(m__eu_dora_payment_related_incidents_queries, [dora_payment_related_incidents_what_if/4]).

status_answers(Subject, Statuses) :-
    findall(Status, dora_payment_related_incidents_assess(Subject, dora_payment_related_incidents_verdict(Status, _Citations)), Statuses).

recipients_answers(Subject, Results) :-
    dora_payment_related_incidents_profile_for(Subject, Profile),
    findall(Result, payment_related_incident_report_recipients(Profile, Result, _Citations), Results).

status_citation_set(Subject, CitationSet) :-
    dora_payment_related_incidents_profile_for(Subject, Profile),
    payment_related_incident_status(Profile, _Status, Citations),
    clausal_msort(Citations, CitationSet).

one_status(Subject) :-
    status_answers(Subject, Statuses),
    length(Statuses, 1).

one_recipients_answer(Subject) :-
    recipients_answers(Subject, Results),
    length(Results, 1).

test(every_subject_has_exactly_one_status) :-
    findall(Subject, dora_payment_related_incidents_subject(Subject), Subjects),
    length(Subjects, 20),
    maplist(one_status, Subjects).
test(every_subject_has_exactly_one_recipients_answer) :-
    findall(Subject, dora_payment_related_incidents_subject(Subject), Subjects),
    maplist(one_recipients_answer, Subjects).
test(major_payment_institution_incident_is_reported) :-
    status_answers(major_payment_institution_incident, Statuses),
    Statuses == [chapter_requirements_and_article_19_reporting_apply].
test(major_payment_institution_incident_cites_all_five) :-
    status_citation_set(major_payment_institution_incident, CitationSet),
    clausal_msort([cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11), cite(eu_reg_2022_2554_art_18_3_a), cite(eu_reg_2022_2554_art_19_1)], Expected),
    CitationSet == Expected.
test(major_payment_institution_reports_to_the_relevant_authority) :-
    recipients_answers(major_payment_institution_incident, Results),
    Results == [recipients([relevant_competent_authority])].
test(non_major_payment_institution_incident_brings_only_the_chapter) :-
    status_answers(non_major_payment_institution_incident, Statuses),
    Statuses == [chapter_requirements_apply].
test(non_major_payment_institution_incident_cites_three) :-
    status_citation_set(non_major_payment_institution_incident, CitationSet),
    clausal_msort([cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11)], Expected),
    CitationSet == Expected.
test(non_major_payment_institution_incident_gives_no_list) :-
    recipients_answers(non_major_payment_institution_incident, Results),
    Results == [chapter_requirements_apply].
test(significant_credit_institution_reports_to_the_national_authority_and_csirt) :-
    recipients_answers(significant_credit_institution_major_incident, Results),
    Results == [recipients([national_competent_authority_designated_under_directive_2013_36, directive_2022_2555_competent_authority_or_csirt])].
test(non_significant_credit_institution_reports_to_the_relevant_authority_and_csirt) :-
    recipients_answers(non_significant_credit_institution_major_incident, Results),
    Results == [recipients([relevant_competent_authority, directive_2022_2555_competent_authority_or_csirt])].
test(significant_credit_institution_without_determination_reports_to_the_national_authority_alone) :-
    recipients_answers(significant_credit_institution_without_member_state_determination, Results),
    Results == [recipients([national_competent_authority_designated_under_directive_2013_36])].
test(significant_credit_institution_status_is_reporting) :-
    status_answers(significant_credit_institution_without_member_state_determination, Statuses),
    Statuses == [chapter_requirements_and_article_19_reporting_apply].
test(institution_exempted_under_directive_2013_36_is_not_reached) :-
    status_answers(exempted_institution_under_directive_2013_36_major_incident, Statuses),
    Statuses == [not_an_article_23_entity].
test(institution_exempted_under_directive_2013_36_cites_article_23_only) :-
    status_citation_set(exempted_institution_under_directive_2013_36_major_incident, CitationSet),
    CitationSet == [cite(eu_reg_2022_2554_art_23)].
test(institution_exempted_under_directive_2013_36_gives_no_list) :-
    recipients_answers(exempted_institution_under_directive_2013_36_major_incident, Results),
    Results == [not_an_article_23_entity].
test(ict_third_party_service_provider_is_not_reached) :-
    status_answers(ict_third_party_service_provider_incident, Statuses),
    Statuses == [not_an_article_23_entity].
test(exempted_payment_institution_is_reached_and_reported) :-
    status_answers(exempted_payment_institution_incident, Statuses),
    Statuses == [chapter_requirements_and_article_19_reporting_apply].
test(not_payment_related_incident_decides_alone) :-
    status_answers(not_payment_related_electronic_money_incident, Statuses),
    Statuses == [not_a_payment_related_incident].
test(not_payment_related_incident_gives_no_list) :-
    recipients_answers(not_payment_related_electronic_money_incident, Results),
    Results == [not_a_payment_related_incident].
test(payment_related_electronic_money_incident_brings_the_chapter) :-
    status_answers(payment_related_electronic_money_incident, Statuses),
    Statuses == [chapter_requirements_apply].
test(unsure_payment_related_incident_is_referred) :-
    status_answers(unsure_payment_related_incident, Statuses),
    Statuses == [needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on([dora_entity_type - account_information_service_provider, incident_is_operational_or_security_payment_related - unsure, payment_related_incident_is_major - true])])].
test(unsure_payment_related_incident_referral_has_no_citations) :-
    dora_payment_related_incidents_profile_for(unsure_payment_related_incident, Profile),
    payment_related_incident_status(Profile, _Status, Citations),
    Citations == [].
test(unsure_payment_related_recipients_is_referred_with_present_pairs) :-
    recipients_answers(unsure_payment_related_incident, Results),
    Results == [needs_legal_review(open_textured(incident_is_operational_or_security_payment_related, cite(eu_reg_2022_2554_art_3_9)), [inputs_relied_on([dora_entity_type - account_information_service_provider, incident_is_operational_or_security_payment_related - unsure, payment_related_incident_is_major - true, member_state_requires_reports_to_directive_2022_2555_authorities - false])])].
test(settled_payment_related_incident_is_reported) :-
    status_answers(settled_payment_related_incident, Statuses),
    Statuses == [chapter_requirements_and_article_19_reporting_apply].
test(settled_payment_related_incident_reports_to_the_relevant_authority) :-
    recipients_answers(settled_payment_related_incident, Results),
    Results == [recipients([relevant_competent_authority])].
test(unsure_major_incident_is_referred) :-
    status_answers(unsure_major_incident, Statuses),
    Statuses == [needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on([dora_entity_type - exempted_electronic_money_institution, incident_is_operational_or_security_payment_related - true, payment_related_incident_is_major - unsure])])].
test(unsure_major_recipients_is_referred) :-
    recipients_answers(unsure_major_incident, Results),
    Results == [needs_legal_review(open_textured(payment_related_incident_is_major, cite(eu_reg_2022_2554_art_3_11)), [inputs_relied_on([dora_entity_type - exempted_electronic_money_institution, incident_is_operational_or_security_payment_related - true, payment_related_incident_is_major - unsure, member_state_requires_reports_to_directive_2022_2555_authorities - true])])].
test(settled_major_incident_reports_to_the_relevant_authority_and_csirt) :-
    recipients_answers(settled_major_incident, Results),
    Results == [recipients([relevant_competent_authority, directive_2022_2555_competent_authority_or_csirt])].
test(provenance_term_builds_and_destructures) :-
    Term = provenance(status_by_incident_s6, [cite(eu_reg_2022_2554_art_3_9)]),
    Term = provenance(Clause, ClauseCitations),
    Clause == status_by_incident_s6,
    ClauseCitations == [cite(eu_reg_2022_2554_art_3_9)].
test(a_referral_context_without_provenance_is_well_formed) :-
    dora_payment_related_incidents_profile_for(unsure_payment_related_incident, Profile),
    payment_related_incident_status(Profile, needs_legal_review(_Reason, [inputs_relied_on(_Pairs)]), Citations),
    Citations == [].
test(missing_entity_type_is_the_gate) :-
    status_answers(missing_entity_type, Statuses),
    Statuses == [indeterminate([dora_entity_type])].
test(missing_entity_type_gate_in_recipients) :-
    recipients_answers(missing_entity_type, Results),
    Results == [indeterminate([dora_entity_type])].
test(missing_incident_judgement_is_named) :-
    status_answers(missing_incident_judgement, Statuses),
    Statuses == [indeterminate([incident_is_operational_or_security_payment_related])].
test(missing_major_is_named_before_the_unsure_incident_is_referred) :-
    status_answers(missing_major_with_unsure_incident, Statuses),
    Statuses == [indeterminate([payment_related_incident_is_major])].
test(missing_significance_is_named_for_a_credit_institution) :-
    recipients_answers(missing_significance, Results),
    Results == [indeterminate([credit_institution_classified_as_significant])].
test(missing_significance_does_not_change_the_status) :-
    status_answers(missing_significance, Statuses),
    Statuses == [chapter_requirements_and_article_19_reporting_apply].
test(malformed_entity_type_is_refused) :-
    status_answers(malformed_entity_type, Statuses),
    Statuses == [input_problems([wrong_type(dora_entity_type)])].
test(unknown_key_is_refused) :-
    recipients_answers(unknown_key_profile, Results),
    Results == [input_problems([unknown_key(colour)])].
test(input_check_through_the_facade) :-
    findall(Problems, dora_payment_related_incidents_input_problems(not_a_list, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_good_fixture_has_no_input_problem) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    dora_payment_related_incidents_input_problems(Profile, Problems),
    Problems == [].
test(checklist_is_cited_and_non_empty_for_a_reported_incident) :-
    dora_payment_related_incidents_profile_for(major_payment_institution_incident, Profile),
    dora_payment_related_incidents_checklist(Profile, [FirstItem|OtherItems]),
    member(item(article_23_entity, met, cite(eu_reg_2022_2554_art_23)), [FirstItem|OtherItems]),
    member(item(major_incident, met, cite(eu_reg_2022_2554_art_3_11)), [FirstItem|OtherItems]).
test(checklist_marks_the_entity_unmet_for_a_type_not_reached) :-
    dora_payment_related_incidents_profile_for(exempted_institution_under_directive_2013_36_major_incident, Profile),
    dora_payment_related_incidents_checklist(Profile, Items),
    member(item(article_23_entity, unmet(not_an_article_23_entity), cite(eu_reg_2022_2554_art_23)), Items).
test(checklist_marks_an_unsure_judgement_unknown) :-
    dora_payment_related_incidents_profile_for(unsure_major_incident, Profile),
    dora_payment_related_incidents_checklist(Profile, Items),
    member(item(major_incident, unknown([payment_related_incident_is_major]), cite(eu_reg_2022_2554_art_3_11)), Items).
test(status_projection_and_resolvable_agree) :-
    dora_payment_related_incidents_profile_for(non_major_payment_institution_incident, Profile),
    dora_payment_related_incidents_decision_resolvable(Profile),
    dora_payment_related_incidents_status(Profile, Status),
    Status == chapter_requirements_apply.
test(final_statuses_are_in_the_vocabulary) :-
    dora_payment_related_incidents_status_values(StatusValues),
    dora_payment_related_incidents_assess(major_payment_institution_incident, dora_payment_related_incidents_verdict(Status, _Citations)),
    member(Status, StatusValues).
test(decide_carries_the_status) :-
    dora_payment_related_incidents_profile_for(not_payment_related_electronic_money_incident, Profile),
    decide_dora_payment_related_incidents(Profile, dora_payment_related_incidents_verdict(not_a_payment_related_incident, _Citations)).
test(what_if_major_flips_the_near_miss_to_reporting) :-
    dora_payment_related_incidents_profile_for(non_major_payment_institution_incident, Profile),
    findall(Status, dora_payment_related_incidents_what_if(Profile, payment_related_incident_is_major, true, Status), Statuses),
    Statuses == [chapter_requirements_and_article_19_reporting_apply].

test(non_major_payment_institution_incident_is_not_reported, fail) :-
    dora_payment_related_incidents_assess(non_major_payment_institution_incident, dora_payment_related_incidents_verdict(chapter_requirements_and_article_19_reporting_apply, _Citations)).
test(non_significant_credit_institution_does_not_report_to_the_national_authority, fail) :-
    dora_payment_related_incidents_profile_for(non_significant_credit_institution_major_incident, Profile),
    payment_related_incident_report_recipients(Profile, recipients([national_competent_authority_designated_under_directive_2013_36|_Others]), _Citations).
test(institution_exempted_under_directive_2013_36_is_not_reported, fail) :-
    dora_payment_related_incidents_assess(exempted_institution_under_directive_2013_36_major_incident, dora_payment_related_incidents_verdict(chapter_requirements_and_article_19_reporting_apply, _Citations)).
test(exempted_payment_institution_is_not_outside_article_23, fail) :-
    dora_payment_related_incidents_assess(exempted_payment_institution_incident, dora_payment_related_incidents_verdict(not_an_article_23_entity, _Citations)).
test(payment_related_electronic_money_incident_is_payment_related, fail) :-
    dora_payment_related_incidents_assess(payment_related_electronic_money_incident, dora_payment_related_incidents_verdict(not_a_payment_related_incident, _Citations)).
test(a_referral_context_carries_no_provenance_item, fail) :-
    dora_payment_related_incidents_profile_for(unsure_payment_related_incident, Profile),
    payment_related_incident_status(Profile, needs_legal_review(_Reason, [inputs_relied_on(_Pairs), provenance(_Clause, _ClauseCitations)]), _Citations).

cp_test_names([every_subject_has_exactly_one_status, every_subject_has_exactly_one_recipients_answer, major_payment_institution_incident_is_reported, major_payment_institution_incident_cites_all_five, major_payment_institution_reports_to_the_relevant_authority, non_major_payment_institution_incident_brings_only_the_chapter, non_major_payment_institution_incident_cites_three, non_major_payment_institution_incident_gives_no_list, significant_credit_institution_reports_to_the_national_authority_and_csirt, non_significant_credit_institution_reports_to_the_relevant_authority_and_csirt, significant_credit_institution_without_determination_reports_to_the_national_authority_alone, significant_credit_institution_status_is_reporting, institution_exempted_under_directive_2013_36_is_not_reached, institution_exempted_under_directive_2013_36_cites_article_23_only, institution_exempted_under_directive_2013_36_gives_no_list, ict_third_party_service_provider_is_not_reached, exempted_payment_institution_is_reached_and_reported, not_payment_related_incident_decides_alone, not_payment_related_incident_gives_no_list, payment_related_electronic_money_incident_brings_the_chapter, unsure_payment_related_incident_is_referred, unsure_payment_related_incident_referral_has_no_citations, unsure_payment_related_recipients_is_referred_with_present_pairs, settled_payment_related_incident_is_reported, settled_payment_related_incident_reports_to_the_relevant_authority, unsure_major_incident_is_referred, unsure_major_recipients_is_referred, settled_major_incident_reports_to_the_relevant_authority_and_csirt, provenance_term_builds_and_destructures, a_referral_context_without_provenance_is_well_formed, missing_entity_type_is_the_gate, missing_entity_type_gate_in_recipients, missing_incident_judgement_is_named, missing_major_is_named_before_the_unsure_incident_is_referred, missing_significance_is_named_for_a_credit_institution, missing_significance_does_not_change_the_status, malformed_entity_type_is_refused, unknown_key_is_refused, input_check_through_the_facade, a_good_fixture_has_no_input_problem, checklist_is_cited_and_non_empty_for_a_reported_incident, checklist_marks_the_entity_unmet_for_a_type_not_reached, checklist_marks_an_unsure_judgement_unknown, status_projection_and_resolvable_agree, final_statuses_are_in_the_vocabulary, decide_carries_the_status, what_if_major_flips_the_near_miss_to_reporting]).
cp_test_fail_names([non_major_payment_institution_incident_is_not_reported, non_significant_credit_institution_does_not_report_to_the_national_authority, institution_exempted_under_directive_2013_36_is_not_reported, exempted_payment_institution_is_not_outside_article_23, payment_related_electronic_money_incident_is_payment_related, a_referral_context_carries_no_provenance_item]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
