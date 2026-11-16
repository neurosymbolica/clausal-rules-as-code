% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_queries, [decide_prior_consultation/2, prior_consultation_duty/2, impact_assessment_outside_facts/2, gdpr_impact_assessment_prior_consultation_what_if/4, gdpr_impact_assessment_prior_consultation_compliance_check/3]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_kernel, [gdpr_impact_assessment_prior_consultation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_prior_consultation_duty, [decide_prior_consultation_duty/2, prior_consultation_duty_status/2, prior_consultation_duty_checklist/2, prior_consultation_duty_decision_resolvable/1, prior_consultation_duty_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_fixtures, [gdpr_impact_assessment_prior_consultation_subject/1, gdpr_impact_assessment_prior_consultation_profile_for/2, gdpr_impact_assessment_prior_consultation_assess/2]).

fixture_statuses(Subject, Statuses) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    findall(Status, prior_consultation_duty(Profile, Status), Statuses).

fixture_verdicts(Subject, Verdicts) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    findall(Verdict, decide_prior_consultation(Profile, Verdict), Verdicts).

fixture_status(Subject, Status) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    prior_consultation_duty(Profile, Status).

answers_exactly_once(Subject) :-
    findall(Verdict, gdpr_impact_assessment_prior_consultation_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1),
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    findall(Status, prior_consultation_duty(Profile, Status), Statuses),
    length(Statuses, 1),
    findall(OutsideFacts, impact_assessment_outside_facts(Profile, OutsideFacts), FactAnswers),
    length(FactAnswers, 1).

cited_item(item(_, _, cite(_))).

has_cited_checklist(Subject) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    prior_consultation_duty_checklist(Profile, [FirstItem|OtherItems]),
    maplist(cited_item, [FirstItem|OtherItems]).

test(every_fixture_answers_exactly_once) :-
    findall(Subject, gdpr_impact_assessment_prior_consultation_subject(Subject), Subjects),
    length(Subjects, 17),
    maplist(answers_exactly_once, Subjects).
test(every_fixture_has_a_non_empty_cited_checklist) :-
    findall(Subject, gdpr_impact_assessment_prior_consultation_subject(Subject), Subjects),
    maplist(has_cited_checklist, Subjects).
test(every_fixture_is_resolvable) :-
    findall(Subject, gdpr_impact_assessment_prior_consultation_subject(Subject), Subjects),
    maplist(gdpr_impact_assessment_prior_consultation_profile_for, Subjects, Profiles),
    maplist(prior_consultation_duty_decision_resolvable, Profiles).
test(the_status_values_are_the_two_final_atoms) :-
    prior_consultation_duty_status_values(StatusValues),
    StatusValues == [required, not_required].
test(residual_high_risk_no_measures_is_required) :-
    fixture_statuses(residual_high_risk_no_measures, Statuses),
    Statuses == [required].
test(residual_high_risk_no_measures_full_verdict) :-
    fixture_verdicts(residual_high_risk_no_measures, Verdicts),
    Verdicts == [prior_consultation_verdict(required, [art36_1_residual_high_risk], [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true])], [cite(eu_reg_2016_679_art_36_1)])].
test(measures_bring_risk_below_high_is_not_required) :-
    fixture_verdicts(measures_bring_risk_below_high, Verdicts),
    Verdicts == [prior_consultation_verdict(not_required, [art36_1_condition_not_met], [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true, measures_reduce_residual_risk_below_high - true])], [cite(eu_reg_2016_679_art_36_1)])].
test(residual_high_risk_measures_insufficient_is_required) :-
    fixture_verdicts(residual_high_risk_measures_insufficient, Verdicts),
    Verdicts == [prior_consultation_verdict(required, [art36_1_residual_high_risk], [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true, measures_reduce_residual_risk_below_high - false])], [cite(eu_reg_2016_679_art_36_1)])].
test(no_high_risk_indicated_is_not_required) :-
    fixture_statuses(no_high_risk_indicated, Statuses),
    Statuses == [not_required].
test(member_state_prior_authorisation_is_required_under_article_36_5) :-
    fixture_verdicts(member_state_prior_authorisation, Verdicts),
    Verdicts == [prior_consultation_verdict(required, [art36_5_member_state_prior_authorisation], [outside_fact(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none))), inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - false])], [cite(eu_reg_2016_679_art_36_5)])].
test(member_state_law_does_not_require_authorisation_is_not_required) :-
    fixture_verdicts(member_state_law_does_not_require_authorisation, Verdicts),
    Verdicts == [prior_consultation_verdict(not_required, [art36_1_condition_not_met], [outside_fact(member_state_requires_prior_authorisation, attested(false, attestation(by, at, reason, none))), inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - false])], [cite(eu_reg_2016_679_art_36_1)])].
test(both_ways_met_gives_the_article_36_1_basis) :-
    fixture_verdicts(both_ways_met, Verdicts),
    Verdicts == [prior_consultation_verdict(required, [art36_1_residual_high_risk], [outside_fact(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none))), inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true])], [cite(eu_reg_2016_679_art_36_1)])].
test(no_assessment_public_interest_unmet_refers_not_governed_here) :-
    fixture_verdicts(no_assessment_public_interest_unmet, Verdicts),
    Verdicts == [prior_consultation_verdict(needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_36_1)]), [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true])]), [], [], [])].
test(no_assessment_member_state_authorisation_is_required) :-
    fixture_verdicts(no_assessment_member_state_authorisation, Verdicts),
    Verdicts == [prior_consultation_verdict(required, [art36_5_member_state_prior_authorisation], [outside_fact(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none))), inputs_relied_on([])], [cite(eu_reg_2016_679_art_36_5)])].
test(no_assessment_member_state_fact_absent_is_an_unresolved_cross_reference) :-
    fixture_verdicts(no_assessment_member_state_fact_absent, Verdicts),
    Verdicts == [prior_consultation_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_5), cite(member_state_law_requiring_prior_consultation_and_authorisation)), [resolution(cite(member_state_law_requiring_prior_consultation_and_authorisation), not_attempted), inputs_relied_on([member_state_requires_prior_authorisation - absent])]), [], [], [])].
test(assessment_status_absent_no_way_open_is_not_required) :-
    fixture_verdicts(assessment_status_absent_no_way_open, Verdicts),
    Verdicts == [prior_consultation_verdict(not_required, [art36_1_condition_not_met], [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - false])], [cite(eu_reg_2016_679_art_36_1)])].
test(assessment_status_absent_way_open_names_the_assessment_missing) :-
    fixture_statuses(assessment_status_absent_way_open, Statuses),
    Statuses == [indeterminate([impact_assessment_carried_out])].
test(two_keys_missing_names_both_keys) :-
    fixture_verdicts(two_keys_missing, Verdicts),
    Verdicts == [prior_consultation_verdict(indeterminate([measures_reduce_residual_risk_below_high, mitigating_measures_taken]), [], [], [])].
test(an_empty_profile_names_every_missing_key) :-
    findall(Status, prior_consultation_duty([], Status), Statuses),
    Statuses == [indeterminate([assessment_indicates_high_risk_absent_mitigation, impact_assessment_carried_out, measures_reduce_residual_risk_below_high, mitigating_measures_taken, processing_for_public_interest_task])].
test(residual_risk_unsure_is_open_textured) :-
    fixture_verdicts(residual_risk_unsure, Verdicts),
    Verdicts == [prior_consultation_verdict(needs_legal_review(open_textured(measures_reduce_residual_risk_below_high, cite(eu_reg_2016_679_art_36_1)), [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true, measures_reduce_residual_risk_below_high - unsure])]), [], [], [])].
test(high_risk_unsure_is_open_textured) :-
    fixture_verdicts(high_risk_unsure, Verdicts),
    Verdicts == [prior_consultation_verdict(needs_legal_review(open_textured(assessment_indicates_high_risk_absent_mitigation, cite(eu_reg_2016_679_art_36_1)), [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - unsure])]), [], [], [])].
test(duplicate_and_unknown_keys_are_input_problems) :-
    fixture_verdicts(duplicate_and_unknown_keys, Verdicts),
    Verdicts == [prior_consultation_verdict(input_problems([duplicate_key(impact_assessment_carried_out), wrong_type(mitigating_measures_taken), unknown_key(stray_flag)]), [], [], [])].
test(duplicate_and_unknown_keys_get_the_problems_from_every_relation) :-
    gdpr_impact_assessment_prior_consultation_profile_for(duplicate_and_unknown_keys, Profile),
    gdpr_impact_assessment_prior_consultation_input_problems(Profile, Problems),
    Problems == [duplicate_key(impact_assessment_carried_out), wrong_type(mitigating_measures_taken), unknown_key(stray_flag)],
    prior_consultation_duty(Profile, input_problems(Problems)),
    impact_assessment_outside_facts(Profile, input_problems(Problems)).
test(a_well_formed_fixture_has_no_input_problem) :-
    gdpr_impact_assessment_prior_consultation_profile_for(criteria_and_item_keys_ignored, Profile),
    gdpr_impact_assessment_prior_consultation_input_problems(Profile, []).
test(a_term_that_is_not_a_profile_is_wrong_type_profile) :-
    findall(Verdict, decide_prior_consultation(not_a_profile, Verdict), Verdicts),
    Verdicts == [prior_consultation_verdict(input_problems([wrong_type(profile)]), [], [], [])].
test(criteria_and_item_keys_change_no_verdict) :-
    gdpr_impact_assessment_prior_consultation_assess(criteria_and_item_keys_ignored, IgnoredVerdict),
    gdpr_impact_assessment_prior_consultation_assess(residual_high_risk_no_measures, BaseVerdict),
    IgnoredVerdict == BaseVerdict.
test(route_approvals_with_an_approval_change_no_verdict) :-
    gdpr_impact_assessment_prior_consultation_profile_for(residual_high_risk_no_measures, BaseProfile),
    append(BaseProfile, [attribute(route_approvals, approvals(viewer(account), [approval(route_profiling_with_legal_effects, '710c9afd08677bc4582523143a02ce5dad02d58e7d3255be19b48aceb3b35a55', rejected, at, reason)]))], Profile),
    gdpr_impact_assessment_prior_consultation_input_problems(Profile, []),
    decide_prior_consultation(Profile, Verdict),
    decide_prior_consultation(BaseProfile, BaseVerdict),
    Verdict == BaseVerdict.
test(an_approval_with_an_unknown_status_is_wrong_type) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(route_approvals, approvals(viewer(account), [approval(route_profiling_with_legal_effects, '710c9afd08677bc4582523143a02ce5dad02d58e7d3255be19b48aceb3b35a55', pending, at, reason)]))], [wrong_type(route_approvals)]).
test(the_facade_aliases_agree_with_the_order_relations) :-
    gdpr_impact_assessment_prior_consultation_profile_for(member_state_prior_authorisation, Profile),
    decide_prior_consultation(Profile, Verdict),
    decide_prior_consultation_duty(Profile, AliasVerdict),
    Verdict == AliasVerdict,
    prior_consultation_duty(Profile, Status),
    prior_consultation_duty_status(Profile, AliasStatus),
    Status == AliasStatus.
test(the_outside_facts_are_given_as_attested_or_absent) :-
    gdpr_impact_assessment_prior_consultation_profile_for(criteria_and_item_keys_ignored, Profile),
    findall(OutsideFacts, impact_assessment_outside_facts(Profile, OutsideFacts), Answers),
    Answers == [[outside_fact(legal_basis_with_general_impact_assessment, absent), outside_fact(member_state_requires_assessment_despite_general_one, absent), outside_fact(member_state_requires_prior_authorisation, absent), outside_fact(national_list_exempts_assessment, absent), outside_fact(national_list_requires_assessment, attested(true, attestation(by, at, reason, none)))]].
test(the_member_state_fact_is_read_as_given) :-
    gdpr_impact_assessment_prior_consultation_profile_for(member_state_prior_authorisation, Profile),
    impact_assessment_outside_facts(Profile, OutsideFacts),
    member(outside_fact(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none))), OutsideFacts).
test(url_evidence_is_copied_into_the_context) :-
    Attested = attested(true, attestation(by, at, reason, url('https://example.org/member-state-law', retrieved_at))),
    findall(Verdict, decide_prior_consultation([attribute(impact_assessment_carried_out, false), attribute(processing_for_public_interest_task, true), attribute(member_state_requires_prior_authorisation, Attested)], Verdict), Verdicts),
    Verdicts == [prior_consultation_verdict(required, [art36_5_member_state_prior_authorisation], [outside_fact(member_state_requires_prior_authorisation, Attested), inputs_relied_on([])], [cite(eu_reg_2016_679_art_36_5)])].
test(document_evidence_is_copied_into_the_outside_facts) :-
    Attested = attested(false, attestation(by, at, reason, document(upload_identifier, '710c9afd08677bc4582523143a02ce5dad02d58e7d3255be19b48aceb3b35a55'))),
    impact_assessment_outside_facts([attribute(member_state_requires_prior_authorisation, Attested)], OutsideFacts),
    member(outside_fact(member_state_requires_prior_authorisation, Attested), OutsideFacts).
test(the_checklist_cites_the_met_article_36_1_way) :-
    gdpr_impact_assessment_prior_consultation_profile_for(residual_high_risk_no_measures, Profile),
    prior_consultation_duty_checklist(Profile, Items),
    length(Items, 7),
    member(item(art36_1_residual_high_risk, met, cite(eu_reg_2016_679_art_36_1)), Items).
test(the_checklist_cites_the_met_article_36_5_way) :-
    gdpr_impact_assessment_prior_consultation_profile_for(member_state_prior_authorisation, Profile),
    prior_consultation_duty_checklist(Profile, Items),
    member(item(art36_5_member_state_prior_authorisation, met, cite(eu_reg_2016_679_art_36_5)), Items).
test(what_if_the_assessment_was_carried_out_is_required) :-
    gdpr_impact_assessment_prior_consultation_profile_for(assessment_status_absent_way_open, Profile),
    findall(Verdict, gdpr_impact_assessment_prior_consultation_what_if(Profile, impact_assessment_carried_out, true, Verdict), Verdicts),
    Verdicts == [prior_consultation_verdict(required, [art36_1_residual_high_risk], [inputs_relied_on([assessment_indicates_high_risk_absent_mitigation - true])], [cite(eu_reg_2016_679_art_36_1)])].
test(what_if_no_assessment_was_carried_out_refers) :-
    gdpr_impact_assessment_prior_consultation_profile_for(assessment_status_absent_way_open, Profile),
    gdpr_impact_assessment_prior_consultation_what_if(Profile, impact_assessment_carried_out, false, prior_consultation_verdict(needs_legal_review(not_governed_here(_), _), [], [], [])).
test(what_if_with_an_unknown_key_is_an_input_problem) :-
    gdpr_impact_assessment_prior_consultation_profile_for(assessment_status_absent_way_open, Profile),
    gdpr_impact_assessment_prior_consultation_what_if(Profile, stray_key, true, prior_consultation_verdict(input_problems([unknown_key(stray_key)]), [], [], [])).
test(required_consultation_prohibits_processing_without_it) :-
    gdpr_impact_assessment_prior_consultation_profile_for(residual_high_risk_no_measures, Profile),
    findall(Verdict, gdpr_impact_assessment_prior_consultation_compliance_check(Profile, begin_processing_without_prior_consultation, Verdict), Verdicts),
    Verdicts == [prohibited].
test(required_consultation_permits_processing_after_it) :-
    gdpr_impact_assessment_prior_consultation_profile_for(residual_high_risk_no_measures, Profile),
    gdpr_impact_assessment_prior_consultation_compliance_check(Profile, begin_processing_after_prior_consultation, permitted).
test(member_state_law_requires_authorisation_not_only_consultation) :-
    gdpr_impact_assessment_prior_consultation_profile_for(member_state_prior_authorisation, Profile),
    gdpr_impact_assessment_prior_consultation_compliance_check(Profile, begin_processing_after_prior_consultation, prohibited),
    gdpr_impact_assessment_prior_consultation_compliance_check(Profile, begin_processing_after_prior_authorisation, permitted).
test(no_duty_permits_processing_without_consultation) :-
    gdpr_impact_assessment_prior_consultation_profile_for(measures_bring_risk_below_high, Profile),
    gdpr_impact_assessment_prior_consultation_compliance_check(Profile, begin_processing_without_prior_consultation, permitted).
test(an_open_answer_infers_no_permission) :-
    gdpr_impact_assessment_prior_consultation_profile_for(two_keys_missing, Profile),
    gdpr_impact_assessment_prior_consultation_compliance_check(Profile, begin_processing_without_prior_consultation, not_decided(indeterminate([measures_reduce_residual_risk_below_high, mitigating_measures_taken]))).

test(residual_high_risk_no_measures_is_not_not_required, fail) :-
    fixture_status(residual_high_risk_no_measures, not_required).
test(measures_bring_risk_below_high_is_not_required_status, fail) :-
    fixture_status(measures_bring_risk_below_high, required).
test(no_high_risk_indicated_is_not_required_status, fail) :-
    fixture_status(no_high_risk_indicated, required).
test(member_state_law_does_not_require_authorisation_is_not_required_status, fail) :-
    fixture_status(member_state_law_does_not_require_authorisation, required).
test(both_ways_met_does_not_give_the_article_36_5_basis, fail) :-
    gdpr_impact_assessment_prior_consultation_assess(both_ways_met, prior_consultation_verdict(_, [art36_5_member_state_prior_authorisation], _, _)).
test(no_assessment_public_interest_unmet_is_not_required_status, fail) :-
    fixture_status(no_assessment_public_interest_unmet, required).
test(no_assessment_public_interest_unmet_is_not_not_required, fail) :-
    fixture_status(no_assessment_public_interest_unmet, not_required).
test(no_assessment_member_state_fact_absent_is_not_required_status, fail) :-
    fixture_status(no_assessment_member_state_fact_absent, required).
test(assessment_status_absent_no_way_open_names_nothing_missing, fail) :-
    fixture_status(assessment_status_absent_no_way_open, indeterminate(_)).
test(assessment_status_absent_way_open_is_not_not_required, fail) :-
    fixture_status(assessment_status_absent_way_open, not_required).
test(high_risk_unsure_is_not_required_status, fail) :-
    fixture_status(high_risk_unsure, required).
test(no_provenance_item_is_declared_in_the_pairs, fail) :-
    fixture_verdicts(residual_high_risk_no_measures, [prior_consultation_verdict(_, _, Context, _)]),
    member(inputs_relied_on(Pairs), Context),
    member(provenance(_, _), Pairs).
test(no_duty_does_not_prohibit_processing_without_consultation, fail) :-
    gdpr_impact_assessment_prior_consultation_profile_for(measures_bring_risk_below_high, Profile),
    gdpr_impact_assessment_prior_consultation_compliance_check(Profile, begin_processing_without_prior_consultation, prohibited).
test(an_open_answer_is_not_permitted, fail) :-
    gdpr_impact_assessment_prior_consultation_profile_for(two_keys_missing, Profile),
    gdpr_impact_assessment_prior_consultation_compliance_check(Profile, begin_processing_without_prior_consultation, permitted).

cp_test_names([every_fixture_answers_exactly_once, every_fixture_has_a_non_empty_cited_checklist, every_fixture_is_resolvable, the_status_values_are_the_two_final_atoms, residual_high_risk_no_measures_is_required, residual_high_risk_no_measures_full_verdict, measures_bring_risk_below_high_is_not_required, residual_high_risk_measures_insufficient_is_required, no_high_risk_indicated_is_not_required, member_state_prior_authorisation_is_required_under_article_36_5, member_state_law_does_not_require_authorisation_is_not_required, both_ways_met_gives_the_article_36_1_basis, no_assessment_public_interest_unmet_refers_not_governed_here, no_assessment_member_state_authorisation_is_required, no_assessment_member_state_fact_absent_is_an_unresolved_cross_reference, assessment_status_absent_no_way_open_is_not_required, assessment_status_absent_way_open_names_the_assessment_missing, two_keys_missing_names_both_keys, an_empty_profile_names_every_missing_key, residual_risk_unsure_is_open_textured, high_risk_unsure_is_open_textured, duplicate_and_unknown_keys_are_input_problems, duplicate_and_unknown_keys_get_the_problems_from_every_relation, a_well_formed_fixture_has_no_input_problem, a_term_that_is_not_a_profile_is_wrong_type_profile, criteria_and_item_keys_change_no_verdict, route_approvals_with_an_approval_change_no_verdict, an_approval_with_an_unknown_status_is_wrong_type, the_facade_aliases_agree_with_the_order_relations, the_outside_facts_are_given_as_attested_or_absent, the_member_state_fact_is_read_as_given, url_evidence_is_copied_into_the_context, document_evidence_is_copied_into_the_outside_facts, the_checklist_cites_the_met_article_36_1_way, the_checklist_cites_the_met_article_36_5_way, what_if_the_assessment_was_carried_out_is_required, what_if_no_assessment_was_carried_out_refers, what_if_with_an_unknown_key_is_an_input_problem, required_consultation_prohibits_processing_without_it, required_consultation_permits_processing_after_it, member_state_law_requires_authorisation_not_only_consultation, no_duty_permits_processing_without_consultation, an_open_answer_infers_no_permission]).
cp_test_fail_names([residual_high_risk_no_measures_is_not_not_required, measures_bring_risk_below_high_is_not_required_status, no_high_risk_indicated_is_not_required_status, member_state_law_does_not_require_authorisation_is_not_required_status, both_ways_met_does_not_give_the_article_36_5_basis, no_assessment_public_interest_unmet_is_not_required_status, no_assessment_public_interest_unmet_is_not_not_required, no_assessment_member_state_fact_absent_is_not_required_status, assessment_status_absent_no_way_open_names_nothing_missing, assessment_status_absent_way_open_is_not_not_required, high_risk_unsure_is_not_required_status, no_provenance_item_is_declared_in_the_pairs, no_duty_does_not_prohibit_processing_without_consultation, an_open_answer_is_not_permitted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
