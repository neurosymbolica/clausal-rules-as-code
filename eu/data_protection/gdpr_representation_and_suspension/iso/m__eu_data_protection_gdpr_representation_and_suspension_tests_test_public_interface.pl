% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_gdpr_representation_and_suspension, [decide_gdpr_representation_and_suspension/2, gdpr_representation_and_suspension_status/2, gdpr_representation_and_suspension_checklist/2, gdpr_representation_and_suspension_decision_resolvable/1, gdpr_representation_and_suspension_status_values/1, mandated_representation/5, court_declining_jurisdiction_option/4]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_fixtures, [gdpr_representation_and_suspension_subject/1, gdpr_representation_and_suspension_profile_for/2, gdpr_representation_and_suspension_assess/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_kernel, [gdpr_representation_and_suspension_input_problems/2]).

expected(mandated_complaint_qualified, mandated(lodge_complaint_under_article_77), may_act_on_mandate).
expected(mandated_complaint_not_mandated, mandated(lodge_complaint_under_article_77), may_not_act_on_mandate).
expected(mandated_complaint_mandate_missing, mandated(exercise_rights_under_article_78), indeterminate([data_subject_mandated_the_body])).
expected(mandated_complaint_public_interest_unsure, mandated(exercise_right_under_article_79), needs_legal_review(open_textured(body_statutory_objectives_in_public_interest, cite(eu_reg_2016_679_art_80_1)), [inputs_relied_on([body_properly_constituted_under_member_state_law - true, body_statutory_objectives_in_public_interest - unsure, body_active_in_protection_of_data_subjects_rights_and_freedoms - true])])).
expected(mandated_complaint_public_interest_false, mandated(exercise_right_under_article_79), may_not_act_on_mandate).
expected(mandated_compensation_law_attested, mandated(receive_compensation_under_article_82), may_act_on_mandate).
expected(mandated_compensation_law_refused, mandated(receive_compensation_under_article_82), may_not_act_on_mandate).
expected(mandated_compensation_law_absent, mandated(receive_compensation_under_article_82), needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_80_1), cite(member_state_law_on_mandated_compensation_claims_statement)), [resolution(cite(member_state_law_on_mandated_compensation_claims_statement), not_attempted), inputs_relied_on([member_state_law_provides_for_mandated_compensation_claims - absent])])).
expected(mandated_compensation_law_and_mandate_absent, mandated(receive_compensation_under_article_82), needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_80_1), cite(member_state_law_on_mandated_compensation_claims_statement)), [resolution(cite(member_state_law_on_mandated_compensation_claims_statement), not_attempted), inputs_relied_on([member_state_law_provides_for_mandated_compensation_claims - absent])])).
expected(without_mandate_complaint_provided, without_mandate(lodge_complaint_under_article_77), may_act_without_mandate).
expected(without_mandate_complaint_not_considered, without_mandate(lodge_complaint_under_article_77), may_not_act_without_mandate).
expected(without_mandate_complaint_law_refused, without_mandate(exercise_rights_under_article_78), may_not_act_without_mandate).
expected(without_mandate_complaint_law_absent, without_mandate(lodge_complaint_under_article_77), needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_80_2), cite(member_state_law_on_action_without_mandate_statement)), [resolution(cite(member_state_law_on_action_without_mandate_statement), not_attempted), inputs_relied_on([member_state_law_provides_for_the_action_without_mandate - absent])])).
expected(without_mandate_complaint_law_and_view_absent, without_mandate(exercise_right_under_article_79), indeterminate([body_considers_data_subject_rights_infringed_by_processing])).
expected(without_mandate_compensation_refused, without_mandate(receive_compensation_under_article_82), may_not_act_without_mandate).
expected(without_mandate_activity_unsure, without_mandate(exercise_rights_under_article_78), needs_legal_review(open_textured(body_active_in_protection_of_data_subjects_rights_and_freedoms, cite(eu_reg_2016_679_art_80_2)), [inputs_relied_on([body_properly_constituted_under_member_state_law - true, body_statutory_objectives_in_public_interest - true, body_active_in_protection_of_data_subjects_rights_and_freedoms - unsure])])).
expected(court_contact_related, contact, contact_duty_applies).
expected(court_contact_without_information, contact, contact_duty_does_not_apply).
expected(court_contact_information_missing, contact, indeterminate([court_has_information_on_proceedings_pending_in_another_member_state])).
expected(court_contact_subject_matter_unsure, contact, needs_legal_review(open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_1)), [inputs_relied_on([other_proceedings_concern_same_subject_matter - unsure])])).
expected(court_suspension_second_court, suspension, may_suspend_proceedings).
expected(court_suspension_court_first_seized, suspension, suspension_not_available).
expected(court_suspension_first_seized_missing, suspension, indeterminate([court_is_court_first_seized])).
expected(court_suspension_subject_matter_unsure, suspension, needs_legal_review(open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_2)), [inputs_relied_on([other_proceedings_concern_same_subject_matter - unsure])])).
expected(court_declining_consolidation_permitted, declining, may_decline_jurisdiction).
expected(court_declining_consolidation_refused, declining, declining_jurisdiction_not_available).
expected(court_declining_jurisdiction_absent, declining, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_81_3), cite(court_first_seized_jurisdiction_statement)), [resolution(cite(court_first_seized_jurisdiction_statement), not_attempted), inputs_relied_on([court_first_seized_has_jurisdiction_over_the_actions - absent])])).
expected(court_declining_consolidation_absent, declining, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_81_3), cite(consolidation_under_law_of_court_first_seized_statement)), [resolution(cite(consolidation_under_law_of_court_first_seized_statement), not_attempted), inputs_relied_on([law_of_court_first_seized_permits_consolidation - absent])])).
expected(court_declining_application_missing, declining, indeterminate([party_applied_for_court_to_decline_jurisdiction])).
expected(court_declining_not_first_instance, declining, declining_jurisdiction_not_available).
expected(court_declining_subject_matter_unsure, declining, needs_legal_review(open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_3)), [inputs_relied_on([other_proceedings_concern_same_subject_matter - unsure])])).
expected(court_declining_incompetent_court, declining, may_decline_jurisdiction).
expected(input_unsure_crisp_key, contact, input_problems([wrong_type(court_is_competent_court)])).
expected(input_duplicate_key, suspension, input_problems([duplicate_key(court_is_competent_court)])).
expected(input_unknown_action, mandated(appeal_to_the_moon), input_problems([wrong_type(action)])).
expected(input_bare_outside_fact, declining, input_problems([wrong_type(law_of_court_first_seized_permits_consolidation)])).
expected(input_unknown_key, contact, input_problems([unknown_key(body_is_for_profit)])).

near_miss(mandated_complaint_qualified, mandated_complaint_not_mandated).
near_miss(mandated_compensation_law_attested, mandated_compensation_law_refused).
near_miss(without_mandate_complaint_provided, without_mandate_complaint_not_considered).
near_miss(without_mandate_complaint_provided, without_mandate_compensation_refused).
near_miss(court_contact_related, court_contact_without_information).
near_miss(court_suspension_second_court, court_suspension_court_first_seized).
near_miss(court_declining_consolidation_permitted, court_declining_consolidation_refused).
near_miss(court_declining_incompetent_court, court_declining_not_first_instance).

opposite_verdict(may_act_on_mandate, may_not_act_on_mandate).
opposite_verdict(may_act_without_mandate, may_not_act_without_mandate).
opposite_verdict(contact_duty_applies, contact_duty_does_not_apply).
opposite_verdict(may_suspend_proceedings, suspension_not_available).
opposite_verdict(may_decline_jurisdiction, declining_jurisdiction_not_available).

opposite_pair(Positive - Control) :-
    opposite_verdict(Positive, Control).

request_of(mandated(Action), Profile, mandated_representation(Profile, Action)).
request_of(without_mandate(Action), Profile, representation_without_mandate(Profile, Action)).
request_of(contact, Profile, court_contact_duty(Profile)).
request_of(suspension, Profile, court_suspension_option(Profile)).
request_of(declining, Profile, court_declining_jurisdiction_option(Profile)).

subject_request(Subject, Request) :-
    expected(Subject, Query, _),
    gdpr_representation_and_suspension_profile_for(Subject, Profile),
    request_of(Query, Profile, Request).

subject_result(Subject, Result) :-
    gdpr_representation_and_suspension_assess(Subject, gdpr_representation_and_suspension_verdict(Result, _Basis, _Citations)).

cite_term(cite(CitationKey)) :-
    atom(CitationKey).

listed_in(Values, Result) :-
    member(Result, Values).

attested_true_term(attested(true, attestation(host_service, attestation_moment, caller_statement, none))).

attested_false_term(attested(false, attestation(host_service, attestation_moment, caller_statement, none))).

test(every_registered_subject_has_an_expectation) :-
    findall(Subject, gdpr_representation_and_suspension_subject(Subject), Registered),
    findall(ExpectedSubject, expected(ExpectedSubject, _, _), Expected),
    clausal_msort(Registered, SortedRegistered),
    clausal_msort(Expected, SortedExpected),
    SortedRegistered == SortedExpected.
test(every_subject_resolves_to_its_expected_result_exactly_once) :-
    findall(Subject - Result, (expected(Subject, _, _), subject_result(Subject, Result)), Actual),
    findall(WantedSubject - WantedResult, expected(WantedSubject, _, WantedResult), Wanted),
    Actual == Wanted.
test(every_subject_is_resolvable) :-
    findall(Subject, (subject_request(Subject, Request), gdpr_representation_and_suspension_decision_resolvable(Request)), Resolved),
    findall(ExpectedSubject, expected(ExpectedSubject, _, _), Expected),
    Resolved == Expected.
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, (subject_request(Subject, Request), gdpr_representation_and_suspension_checklist(Request, [_|_])), WithChecklist),
    findall(ExpectedSubject, expected(ExpectedSubject, _, _), Expected),
    WithChecklist == Expected.
test(every_checklist_item_carries_a_cite) :-
    findall(Citation, (subject_request(_, Request), gdpr_representation_and_suspension_checklist(Request, Items), member(item(_, _, Citation), Items)), Citations),
    Citations = [_|_],
    maplist(cite_term, Citations).
test(every_final_result_is_a_status_value) :-
    gdpr_representation_and_suspension_status_values(Values),
    findall(Result, (expected(_, _, Result), atom(Result)), Finals),
    Finals = [_|_],
    maplist(listed_in(Values), Finals).
test(near_miss_controls_get_the_opposite_verdict) :-
    findall(Positive - Control, (near_miss(PositiveSubject, ControlSubject), subject_result(PositiveSubject, Positive), subject_result(ControlSubject, Control)), Pairs),
    length(Pairs, 8),
    maplist(opposite_pair, Pairs).
test(a_mandated_qualified_body_may_lodge_a_complaint) :-
    gdpr_representation_and_suspension_assess(mandated_complaint_qualified, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)),
    Result == may_act_on_mandate,
    Basis == [],
    Citations == [cite(eu_reg_2016_679_art_80_1)].
test(a_body_without_a_mandate_may_not_act) :-
    subject_result(mandated_complaint_not_mandated, may_not_act_on_mandate).
test(an_attested_compensation_statement_is_shown_with_the_answer) :-
    attested_true_term(AttestedTrue),
    gdpr_representation_and_suspension_assess(mandated_compensation_law_attested, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)),
    Result == may_act_on_mandate,
    Basis == [outside_fact(member_state_law_provides_for_mandated_compensation_claims, AttestedTrue)],
    Citations == [cite(eu_reg_2016_679_art_80_1)].
test(a_refused_compensation_statement_settles_and_is_shown) :-
    attested_false_term(AttestedFalse),
    gdpr_representation_and_suspension_assess(mandated_compensation_law_refused, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)),
    Result == may_not_act_on_mandate,
    Basis == [outside_fact(member_state_law_provides_for_mandated_compensation_claims, AttestedFalse)],
    Citations == [cite(eu_reg_2016_679_art_80_1)].
test(d204_refers_compensation_first_where_a_complaint_names_the_missing_key) :-
    gdpr_representation_and_suspension_profile_for(mandated_complaint_mandate_missing, ComplaintProfile),
    gdpr_representation_and_suspension_profile_for(mandated_compensation_law_and_mandate_absent, CompensationProfile),
    ComplaintProfile == CompensationProfile,
    subject_result(mandated_complaint_mandate_missing, ComplaintResult),
    subject_result(mandated_compensation_law_and_mandate_absent, CompensationResult),
    ComplaintResult == indeterminate([data_subject_mandated_the_body]),
    CompensationResult = needs_legal_review(cross_reference_unresolved(_, _), _).
test(d296_names_the_missing_view_before_referring_the_law) :-
    subject_result(without_mandate_complaint_law_and_view_absent, MissingResult),
    subject_result(without_mandate_complaint_law_absent, ReferralResult),
    MissingResult == indeterminate([body_considers_data_subject_rights_infringed_by_processing]),
    ReferralResult = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_80_2), _), _).
test(a_referral_has_no_basis_and_no_citation) :-
    gdpr_representation_and_suspension_assess(without_mandate_complaint_law_absent, gdpr_representation_and_suspension_verdict(_Result, Basis, Citations)),
    Basis == [],
    Citations == [].
test(a_body_acting_without_mandate_shows_the_attested_law) :-
    attested_true_term(AttestedTrue),
    gdpr_representation_and_suspension_assess(without_mandate_complaint_not_considered, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)),
    Result == may_not_act_without_mandate,
    Basis == [outside_fact(member_state_law_provides_for_the_action_without_mandate, AttestedTrue)],
    Citations == [cite(eu_reg_2016_679_art_80_2)].
test(no_compensation_without_a_mandate_reads_no_key) :-
    gdpr_representation_and_suspension_assess(without_mandate_compensation_refused, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)),
    Result == may_not_act_without_mandate,
    Basis == [],
    Citations == [cite(eu_reg_2016_679_art_80_2)].
test(the_contact_duty_applies) :-
    gdpr_representation_and_suspension_assess(court_contact_related, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)),
    Result == contact_duty_applies,
    Basis == [],
    Citations == [cite(eu_reg_2016_679_art_81_1)].
test(the_court_first_seized_may_not_suspend) :-
    subject_result(court_suspension_court_first_seized, suspension_not_available).
test(declining_shows_both_attested_statements) :-
    attested_true_term(AttestedTrue),
    gdpr_representation_and_suspension_assess(court_declining_consolidation_permitted, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)),
    Result == may_decline_jurisdiction,
    Basis == [outside_fact(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), outside_fact(law_of_court_first_seized_permits_consolidation, AttestedTrue)],
    Citations == [cite(eu_reg_2016_679_art_81_3)].
test(competence_is_not_read_for_declining) :-
    subject_result(court_declining_incompetent_court, may_decline_jurisdiction).
test(an_input_problem_has_no_basis_and_no_citation) :-
    gdpr_representation_and_suspension_assess(input_unknown_action, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)),
    Result == input_problems([wrong_type(action)]),
    Basis == [],
    Citations == [].
test(the_status_is_the_verdict_result) :-
    gdpr_representation_and_suspension_profile_for(court_suspension_second_court, Profile),
    findall(Result, gdpr_representation_and_suspension_status(court_suspension_option(Profile), Result), Results),
    Results == [may_suspend_proceedings].
test(decide_gives_one_verdict) :-
    gdpr_representation_and_suspension_profile_for(court_declining_jurisdiction_absent, Profile),
    findall(Verdict, decide_gdpr_representation_and_suspension(court_declining_jurisdiction_option(Profile), Verdict), Verdicts),
    length(Verdicts, 1).
test(the_checklist_marks_the_failing_item_with_its_cite) :-
    subject_request(court_contact_without_information, Request),
    gdpr_representation_and_suspension_checklist(Request, Items),
    member(item(court_has_information_on_proceedings_pending_in_another_member_state, unmet(court_has_information_on_proceedings_pending_in_another_member_state), cite(eu_reg_2016_679_art_81_1)), Items).
test(url_evidence_is_accepted_by_the_input_check) :-
    Attested = attested(true, attestation(host_service, attestation_moment, caller_statement, url(source_address, retrieval_moment))),
    findall(Problems, gdpr_representation_and_suspension_input_problems([attribute(court_first_seized_has_jurisdiction_over_the_actions, Attested)], Problems), Answers),
    Answers == [[]].
test(url_evidence_with_an_unbound_argument_is_a_wrong_type) :-
    Attested = attested(true, attestation(host_service, attestation_moment, caller_statement, url(_UnboundAddress, retrieval_moment))),
    findall(Problems, gdpr_representation_and_suspension_input_problems([attribute(court_first_seized_has_jurisdiction_over_the_actions, Attested)], Problems), Answers),
    Answers == [[wrong_type(court_first_seized_has_jurisdiction_over_the_actions)]].
test(document_evidence_is_accepted_by_the_input_check) :-
    Attested = attested(false, attestation(host_service, attestation_moment, caller_statement, document(upload_identifier, sha256_digest))),
    findall(Problems, gdpr_representation_and_suspension_input_problems([attribute(law_of_court_first_seized_permits_consolidation, Attested)], Problems), Answers),
    Answers == [[]].
test(document_evidence_with_an_unbound_argument_is_a_wrong_type) :-
    Attested = attested(false, attestation(host_service, attestation_moment, caller_statement, document(upload_identifier, _UnboundDigest))),
    findall(Problems, gdpr_representation_and_suspension_input_problems([attribute(law_of_court_first_seized_permits_consolidation, Attested)], Problems), Answers),
    Answers == [[wrong_type(law_of_court_first_seized_permits_consolidation)]].
test(url_and_document_evidence_are_copied_into_the_declining_basis) :-
    JurisdictionAttested = attested(true, attestation(host_service, attestation_moment, caller_statement, url(source_address, retrieval_moment))),
    ConsolidationAttested = attested(false, attestation(host_service, attestation_moment, caller_statement, document(upload_identifier, sha256_digest))),
    findall(Result - Basis - Citations, court_declining_jurisdiction_option([attribute(court_first_seized_has_jurisdiction_over_the_actions, JurisdictionAttested), attribute(law_of_court_first_seized_permits_consolidation, ConsolidationAttested)], Result, Basis, Citations), Answers),
    Answers == [declining_jurisdiction_not_available - [outside_fact(court_first_seized_has_jurisdiction_over_the_actions, JurisdictionAttested), outside_fact(law_of_court_first_seized_permits_consolidation, ConsolidationAttested)] - [cite(eu_reg_2016_679_art_81_3)]].
test(document_evidence_is_copied_into_the_compensation_basis) :-
    Attested = attested(true, attestation(host_service, attestation_moment, caller_statement, document(upload_identifier, sha256_digest))),
    findall(Result - Basis - Citations, mandated_representation([attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, true), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, true), attribute(data_subject_mandated_the_body, true), attribute(member_state_law_provides_for_mandated_compensation_claims, Attested)], receive_compensation_under_article_82, Result, Basis, Citations), Answers),
    Answers == [may_act_on_mandate - [outside_fact(member_state_law_provides_for_mandated_compensation_claims, Attested)] - [cite(eu_reg_2016_679_art_80_1)]].

test(a_mandated_qualified_body_is_not_refused, fail) :-
    subject_result(mandated_complaint_qualified, may_not_act_on_mandate).
test(a_body_without_a_mandate_is_not_allowed, fail) :-
    subject_result(mandated_complaint_not_mandated, may_act_on_mandate).
test(no_compensation_without_a_mandate_is_never_allowed, fail) :-
    subject_result(without_mandate_compensation_refused, may_act_without_mandate).
test(a_court_without_information_has_no_contact_duty, fail) :-
    subject_result(court_contact_without_information, contact_duty_applies).
test(the_court_first_seized_is_not_given_the_option, fail) :-
    subject_result(court_suspension_court_first_seized, may_suspend_proceedings).
test(declining_without_consolidation_is_not_available, fail) :-
    subject_result(court_declining_consolidation_refused, may_decline_jurisdiction).
test(url_evidence_with_an_unbound_argument_gets_no_final_answer, fail) :-
    Attested = attested(true, attestation(host_service, attestation_moment, caller_statement, url(_UnboundAddress, retrieval_moment))),
    court_declining_jurisdiction_option([attribute(court_first_seized_has_jurisdiction_over_the_actions, Attested)], declining_jurisdiction_not_available, _, _).

cp_test_names([every_registered_subject_has_an_expectation, every_subject_resolves_to_its_expected_result_exactly_once, every_subject_is_resolvable, every_subject_has_a_non_empty_checklist, every_checklist_item_carries_a_cite, every_final_result_is_a_status_value, near_miss_controls_get_the_opposite_verdict, a_mandated_qualified_body_may_lodge_a_complaint, a_body_without_a_mandate_may_not_act, an_attested_compensation_statement_is_shown_with_the_answer, a_refused_compensation_statement_settles_and_is_shown, d204_refers_compensation_first_where_a_complaint_names_the_missing_key, d296_names_the_missing_view_before_referring_the_law, a_referral_has_no_basis_and_no_citation, a_body_acting_without_mandate_shows_the_attested_law, no_compensation_without_a_mandate_reads_no_key, the_contact_duty_applies, the_court_first_seized_may_not_suspend, declining_shows_both_attested_statements, competence_is_not_read_for_declining, an_input_problem_has_no_basis_and_no_citation, the_status_is_the_verdict_result, decide_gives_one_verdict, the_checklist_marks_the_failing_item_with_its_cite, url_evidence_is_accepted_by_the_input_check, url_evidence_with_an_unbound_argument_is_a_wrong_type, document_evidence_is_accepted_by_the_input_check, document_evidence_with_an_unbound_argument_is_a_wrong_type, url_and_document_evidence_are_copied_into_the_declining_basis, document_evidence_is_copied_into_the_compensation_basis]).
cp_test_fail_names([a_mandated_qualified_body_is_not_refused, a_body_without_a_mandate_is_not_allowed, no_compensation_without_a_mandate_is_never_allowed, a_court_without_information_has_no_contact_duty, the_court_first_seized_is_not_given_the_option, declining_without_consolidation_is_not_available, url_evidence_with_an_unbound_argument_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
