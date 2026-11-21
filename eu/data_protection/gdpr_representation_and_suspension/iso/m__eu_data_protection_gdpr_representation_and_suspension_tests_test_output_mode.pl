% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_gdpr_representation_and_suspension, [decide_gdpr_representation_and_suspension/2, gdpr_representation_and_suspension_status/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_fixtures, [gdpr_representation_and_suspension_subject/1, gdpr_representation_and_suspension_profile_for/2, gdpr_representation_and_suspension_assess/2]).

attested_true_term(attested(true, attestation(host_service, attestation_moment, caller_statement, none))).

attested_false_term(attested(false, attestation(host_service, attestation_moment, caller_statement, none))).

referral_row(member_state_law_provides_for_mandated_compensation_claims, eu_reg_2016_679_art_80_1, member_state_law_on_mandated_compensation_claims_statement).
referral_row(member_state_law_provides_for_the_action_without_mandate, eu_reg_2016_679_art_80_2, member_state_law_on_action_without_mandate_statement).
referral_row(court_first_seized_has_jurisdiction_over_the_actions, eu_reg_2016_679_art_81_3, court_first_seized_jurisdiction_statement).
referral_row(law_of_court_first_seized_permits_consolidation, eu_reg_2016_679_art_81_3, consolidation_under_law_of_court_first_seized_statement).

absent_referral(Key, needs_legal_review(cross_reference_unresolved(cite(CitationKey), cite(TargetKey)), [resolution(cite(TargetKey), not_attempted), inputs_relied_on([Key - absent])])) :-
    referral_row(Key, CitationKey, TargetKey).

verdict(Result, Basis, Citations, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)).

expected_verdict(mandated_complaint_qualified, Verdict) :-
    verdict(may_act_on_mandate, [], [cite(eu_reg_2016_679_art_80_1)], Verdict).
expected_verdict(mandated_complaint_not_mandated, Verdict) :-
    verdict(may_not_act_on_mandate, [], [cite(eu_reg_2016_679_art_80_1)], Verdict).
expected_verdict(mandated_complaint_mandate_missing, Verdict) :-
    verdict(indeterminate([data_subject_mandated_the_body]), [], [], Verdict).
expected_verdict(mandated_complaint_public_interest_unsure, Verdict) :-
    verdict(needs_legal_review(open_textured(body_statutory_objectives_in_public_interest, cite(eu_reg_2016_679_art_80_1)), [inputs_relied_on([body_properly_constituted_under_member_state_law - true, body_statutory_objectives_in_public_interest - unsure, body_active_in_protection_of_data_subjects_rights_and_freedoms - true])]), [], [], Verdict).
expected_verdict(mandated_complaint_public_interest_false, Verdict) :-
    verdict(may_not_act_on_mandate, [], [cite(eu_reg_2016_679_art_80_1)], Verdict).
expected_verdict(mandated_compensation_law_attested, Verdict) :-
    attested_true_term(AttestedTrue),
    verdict(may_act_on_mandate, [outside_fact(member_state_law_provides_for_mandated_compensation_claims, AttestedTrue)], [cite(eu_reg_2016_679_art_80_1)], Verdict).
expected_verdict(mandated_compensation_law_refused, Verdict) :-
    attested_false_term(AttestedFalse),
    verdict(may_not_act_on_mandate, [outside_fact(member_state_law_provides_for_mandated_compensation_claims, AttestedFalse)], [cite(eu_reg_2016_679_art_80_1)], Verdict).
expected_verdict(mandated_compensation_law_absent, Verdict) :-
    absent_referral(member_state_law_provides_for_mandated_compensation_claims, Referral),
    verdict(Referral, [], [], Verdict).
expected_verdict(mandated_compensation_law_and_mandate_absent, Verdict) :-
    absent_referral(member_state_law_provides_for_mandated_compensation_claims, Referral),
    verdict(Referral, [], [], Verdict).
expected_verdict(without_mandate_complaint_provided, Verdict) :-
    attested_true_term(AttestedTrue),
    verdict(may_act_without_mandate, [outside_fact(member_state_law_provides_for_the_action_without_mandate, AttestedTrue)], [cite(eu_reg_2016_679_art_80_2)], Verdict).
expected_verdict(without_mandate_complaint_not_considered, Verdict) :-
    attested_true_term(AttestedTrue),
    verdict(may_not_act_without_mandate, [outside_fact(member_state_law_provides_for_the_action_without_mandate, AttestedTrue)], [cite(eu_reg_2016_679_art_80_2)], Verdict).
expected_verdict(without_mandate_complaint_law_refused, Verdict) :-
    attested_false_term(AttestedFalse),
    verdict(may_not_act_without_mandate, [outside_fact(member_state_law_provides_for_the_action_without_mandate, AttestedFalse)], [cite(eu_reg_2016_679_art_80_2)], Verdict).
expected_verdict(without_mandate_complaint_law_absent, Verdict) :-
    absent_referral(member_state_law_provides_for_the_action_without_mandate, Referral),
    verdict(Referral, [], [], Verdict).
expected_verdict(without_mandate_complaint_law_and_view_absent, Verdict) :-
    verdict(indeterminate([body_considers_data_subject_rights_infringed_by_processing]), [], [], Verdict).
expected_verdict(without_mandate_compensation_refused, Verdict) :-
    verdict(may_not_act_without_mandate, [], [cite(eu_reg_2016_679_art_80_2)], Verdict).
expected_verdict(without_mandate_activity_unsure, Verdict) :-
    verdict(needs_legal_review(open_textured(body_active_in_protection_of_data_subjects_rights_and_freedoms, cite(eu_reg_2016_679_art_80_2)), [inputs_relied_on([body_properly_constituted_under_member_state_law - true, body_statutory_objectives_in_public_interest - true, body_active_in_protection_of_data_subjects_rights_and_freedoms - unsure])]), [], [], Verdict).
expected_verdict(court_contact_related, Verdict) :-
    verdict(contact_duty_applies, [], [cite(eu_reg_2016_679_art_81_1)], Verdict).
expected_verdict(court_contact_without_information, Verdict) :-
    verdict(contact_duty_does_not_apply, [], [cite(eu_reg_2016_679_art_81_1)], Verdict).
expected_verdict(court_contact_information_missing, Verdict) :-
    verdict(indeterminate([court_has_information_on_proceedings_pending_in_another_member_state]), [], [], Verdict).
expected_verdict(court_contact_subject_matter_unsure, Verdict) :-
    verdict(needs_legal_review(open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_1)), [inputs_relied_on([other_proceedings_concern_same_subject_matter - unsure])]), [], [], Verdict).
expected_verdict(court_suspension_second_court, Verdict) :-
    verdict(may_suspend_proceedings, [], [cite(eu_reg_2016_679_art_81_2)], Verdict).
expected_verdict(court_suspension_court_first_seized, Verdict) :-
    verdict(suspension_not_available, [], [cite(eu_reg_2016_679_art_81_2)], Verdict).
expected_verdict(court_suspension_first_seized_missing, Verdict) :-
    verdict(indeterminate([court_is_court_first_seized]), [], [], Verdict).
expected_verdict(court_suspension_subject_matter_unsure, Verdict) :-
    verdict(needs_legal_review(open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_2)), [inputs_relied_on([other_proceedings_concern_same_subject_matter - unsure])]), [], [], Verdict).
expected_verdict(court_declining_consolidation_permitted, Verdict) :-
    attested_true_term(AttestedTrue),
    verdict(may_decline_jurisdiction, [outside_fact(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), outside_fact(law_of_court_first_seized_permits_consolidation, AttestedTrue)], [cite(eu_reg_2016_679_art_81_3)], Verdict).
expected_verdict(court_declining_consolidation_refused, Verdict) :-
    attested_true_term(AttestedTrue),
    attested_false_term(AttestedFalse),
    verdict(declining_jurisdiction_not_available, [outside_fact(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), outside_fact(law_of_court_first_seized_permits_consolidation, AttestedFalse)], [cite(eu_reg_2016_679_art_81_3)], Verdict).
expected_verdict(court_declining_jurisdiction_absent, Verdict) :-
    absent_referral(court_first_seized_has_jurisdiction_over_the_actions, Referral),
    verdict(Referral, [], [], Verdict).
expected_verdict(court_declining_consolidation_absent, Verdict) :-
    absent_referral(law_of_court_first_seized_permits_consolidation, Referral),
    verdict(Referral, [], [], Verdict).
expected_verdict(court_declining_application_missing, Verdict) :-
    verdict(indeterminate([party_applied_for_court_to_decline_jurisdiction]), [], [], Verdict).
expected_verdict(court_declining_not_first_instance, Verdict) :-
    attested_true_term(AttestedTrue),
    verdict(declining_jurisdiction_not_available, [outside_fact(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), outside_fact(law_of_court_first_seized_permits_consolidation, AttestedTrue)], [cite(eu_reg_2016_679_art_81_3)], Verdict).
expected_verdict(court_declining_subject_matter_unsure, Verdict) :-
    verdict(needs_legal_review(open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_3)), [inputs_relied_on([other_proceedings_concern_same_subject_matter - unsure])]), [], [], Verdict).
expected_verdict(court_declining_incompetent_court, Verdict) :-
    attested_true_term(AttestedTrue),
    verdict(may_decline_jurisdiction, [outside_fact(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), outside_fact(law_of_court_first_seized_permits_consolidation, AttestedTrue)], [cite(eu_reg_2016_679_art_81_3)], Verdict).
expected_verdict(input_unsure_crisp_key, Verdict) :-
    verdict(input_problems([wrong_type(court_is_competent_court)]), [], [], Verdict).
expected_verdict(input_duplicate_key, Verdict) :-
    verdict(input_problems([duplicate_key(court_is_competent_court)]), [], [], Verdict).
expected_verdict(input_unknown_action, Verdict) :-
    verdict(input_problems([wrong_type(action)]), [], [], Verdict).
expected_verdict(input_bare_outside_fact, Verdict) :-
    verdict(input_problems([wrong_type(law_of_court_first_seized_permits_consolidation)]), [], [], Verdict).
expected_verdict(input_unknown_key, Verdict) :-
    verdict(input_problems([unknown_key(body_is_for_profit)]), [], [], Verdict).

yields_expected_once(Subject) :-
    expected_verdict(Subject, Expected),
    findall(Verdict, gdpr_representation_and_suspension_assess(Subject, Verdict), Verdicts),
    Verdicts == [Expected].

test(the_expected_table_covers_every_subject) :-
    findall(Subject, gdpr_representation_and_suspension_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, expected_verdict(Subject, _), ExpectedSubjects),
    sort(ExpectedSubjects, SubjectSet).
test(every_subject_yields_exactly_its_expected_verdict) :-
    findall(Subject, gdpr_representation_and_suspension_subject(Subject), Subjects),
    maplist(yields_expected_once, Subjects).
test(the_d204_compensation_limb_refers_first) :-
    yields_expected_once(mandated_compensation_law_and_mandate_absent).
test(the_d296_complaint_limb_names_the_missing_key_first) :-
    yields_expected_once(mandated_complaint_mandate_missing).
test(the_basis_lists_both_outside_facts_in_order) :-
    yields_expected_once(court_declining_consolidation_refused).
test(the_court_queries_read_out_an_empty_basis) :-
    gdpr_representation_and_suspension_profile_for(court_contact_related, Profile),
    findall(Verdict, decide_gdpr_representation_and_suspension(court_contact_duty(Profile), Verdict), Verdicts),
    Verdicts == [gdpr_representation_and_suspension_verdict(contact_duty_applies, [], [cite(eu_reg_2016_679_art_81_1)])].
test(the_status_is_read_out_once) :-
    gdpr_representation_and_suspension_profile_for(court_declining_jurisdiction_absent, Profile),
    findall(Status, gdpr_representation_and_suspension_status(court_declining_jurisdiction_option(Profile), Status), Statuses),
    absent_referral(court_first_seized_has_jurisdiction_over_the_actions, Referral),
    Statuses == [Referral].

cp_test_names([the_expected_table_covers_every_subject, every_subject_yields_exactly_its_expected_verdict, the_d204_compensation_limb_refers_first, the_d296_complaint_limb_names_the_missing_key_first, the_basis_lists_both_outside_facts_in_order, the_court_queries_read_out_an_empty_basis, the_status_is_read_out_once]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
