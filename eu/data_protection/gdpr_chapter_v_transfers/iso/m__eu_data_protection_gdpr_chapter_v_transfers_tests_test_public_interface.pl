% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_transfers_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer, [decide_transfer/2, transfer_status/2, transfer_permitted/2, transfer_verdict/3, transfer_checklist/2, transfer_requirement/4, transfer_requirement_ids/1, transfer_outside_facts/2, transfer_decision_resolvable/1, transfer_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_transfer_basis, [transfer_basis/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_kernel, [gdpr_chapter_v_transfers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_queries, [gdpr_chapter_v_transfers_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_fixtures, [gdpr_chapter_v_transfers_subject/1, gdpr_chapter_v_transfers_profile_for/2, gdpr_chapter_v_transfers_assess/2]).

expected(adequacy_attested_true, eligible, art45_adequacy).
expected(adequacy_attested_true_with_unsure_safeguard, eligible, art45_adequacy).
expected(adequacy_attested_false_alone, indeterminate([safeguard_in_place]), none).
expected(safeguard_after_adequacy_refused, eligible, art46_safeguards).
expected(safeguard_without_adequacy_fact, eligible, art46_safeguards).
expected(no_safeguard_and_no_claim, ineligible, none).
expected(binding_corporate_rules_over_refused_safeguard, eligible, art46_safeguards).
expected(binding_corporate_rules_refused, ineligible, none).
expected(binding_corporate_rules_alone, eligible, art46_safeguards).
expected(empty_profile, indeterminate([safeguard_in_place]), none).
expected(refused_safeguard_without_adequacy_fact, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_45), cite(eu_reg_2016_679_art_45_3)), [resolution(cite(eu_reg_2016_679_art_45_3), not_attempted), inputs_relied_on([derogation_claimed - art49_1_b, adequacy_decision_in_force - absent, safeguard_in_place - false])]), none).
expected(explicit_consent_derogation, eligible, art49_derogation).
expected(explicit_consent_under_public_powers, ineligible, none).
expected(explicit_consent_not_stated, indeterminate([explicit_consent_obtained]), none).
expected(contract_derogation, eligible, art49_derogation).
expected(contract_derogation_under_public_powers, ineligible, none).
expected(public_interest_unsure, needs_legal_review(open_textured(important_public_interest, cite(eu_reg_2016_679_art_49_1_d)), [inputs_relied_on([derogation_claimed - art49_1_d, important_public_interest - unsure])]), none).
expected(public_interest_under_public_powers, eligible, art49_derogation).
expected(public_interest_refused, ineligible, none).
expected(public_register_derogation, eligible, art49_derogation).
expected(public_register_refused_requester, ineligible, none).
expected(public_register_not_public, ineligible, none).
expected(second_subparagraph_after_public_interest, ineligible, none).
expected(second_subparagraph_with_unsure_contract, needs_legal_review(open_textured(contract_necessity, cite(eu_reg_2016_679_art_49_1_b)), [inputs_relied_on([derogation_claimed - art49_1_second_subpara, contract_necessity - unsure, data_subject_interest_contract_necessity - false, important_public_interest - false, legal_claims_necessity - false, vital_interests_necessity - false, legitimate_interests_derogation - true])]), none).
expected(second_subparagraph_derogation, eligible, art49_derogation).
expected(second_subparagraph_under_public_powers, ineligible, none).
expected(second_subparagraph_consent_not_stated, indeterminate([explicit_consent_obtained]), none).
expected(unsure_safeguard_contract_not_stated, indeterminate([contract_necessity]), none).
expected(unsure_safeguard_contract_stated, needs_legal_review(open_textured(safeguard_in_place, cite(eu_reg_2016_679_art_46)), [inputs_relied_on([derogation_claimed - art49_1_b, safeguard_in_place - unsure])]), none).
expected(recorded_facts_with_safeguard, eligible, art46_safeguards).
expected(safeguard_given_wrong_atom, input_problems([wrong_type(safeguard_in_place)]), none).
expected(duplicate_safeguard_and_unknown_key, input_problems([duplicate_key(safeguard_in_place), unknown_key(foo)]), none).
expected(profile_not_a_list, input_problems([wrong_type(profile)]), none).
expected(binding_corporate_rules_bare_atom, input_problems([wrong_type(binding_corporate_rules_approved)]), none).
expected(adequacy_attested_unsure, input_problems([wrong_type(adequacy_decision_in_force)]), none).

near_miss_pair(adequacy_attested_true, adequacy_attested_false_alone).
near_miss_pair(safeguard_after_adequacy_refused, no_safeguard_and_no_claim).
near_miss_pair(binding_corporate_rules_over_refused_safeguard, binding_corporate_rules_refused).
near_miss_pair(explicit_consent_derogation, explicit_consent_under_public_powers).
near_miss_pair(explicit_consent_derogation, explicit_consent_not_stated).
near_miss_pair(contract_derogation, contract_derogation_under_public_powers).
near_miss_pair(public_interest_under_public_powers, public_interest_refused).
near_miss_pair(public_interest_under_public_powers, public_interest_unsure).
near_miss_pair(public_register_derogation, public_register_refused_requester).
near_miss_pair(second_subparagraph_derogation, second_subparagraph_with_unsure_contract).
near_miss_pair(second_subparagraph_derogation, second_subparagraph_under_public_powers).
near_miss_pair(second_subparagraph_derogation, second_subparagraph_consent_not_stated).
near_miss_pair(safeguard_without_adequacy_fact, refused_safeguard_without_adequacy_fact).

subject_matches_expectation(Subject) :-
    expected(Subject, ExpectedVerdict, ExpectedBasis),
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    Verdicts == [ExpectedVerdict],
    findall(Basis, transfer_basis(Profile, Basis), Bases),
    Bases == [ExpectedBasis],
    findall(Result, gdpr_chapter_v_transfers_assess(Subject, Result), Results),
    Results == [ExpectedVerdict].

exactly_one_answer_everywhere(Subject) :-
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    length(Verdicts, 1),
    findall(Status, transfer_status(Profile, Status), Statuses),
    length(Statuses, 1),
    findall(Permitted, transfer_permitted(Profile, Permitted), PermittedAnswers),
    length(PermittedAnswers, 1),
    findall(Basis, transfer_basis(Profile, Basis), Bases),
    length(Bases, 1),
    findall(Verdict - Basis, transfer_verdict(Profile, Verdict, Basis), VerdictPairs),
    length(VerdictPairs, 1),
    findall(Items, transfer_checklist(Profile, Items), Checklists),
    length(Checklists, 1),
    findall(Requirement, transfer_requirement(Profile, Requirement, _, _), Requirements),
    length(Requirements, 1),
    findall(Facts, transfer_outside_facts(Profile, Facts), OutsideFacts),
    length(OutsideFacts, 1),
    findall(Problems, gdpr_chapter_v_transfers_input_problems(Profile, Problems), ProblemLists),
    length(ProblemLists, 1).

eligible_subject_has_its_basis_checklist(Subject) :-
    expected(Subject, eligible, Basis),
    gdpr_chapter_v_transfers_profile_for(Subject, Profile),
    transfer_checklist(Profile, [Basis]),
    transfer_permitted(Profile, true),
    transfer_status_values(StatusValues),
    member(eligible, StatusValues).

control_differs(Positive - Control) :-
    gdpr_chapter_v_transfers_profile_for(Positive, PositiveProfile),
    decide_transfer(PositiveProfile, eligible),
    gdpr_chapter_v_transfers_profile_for(Control, ControlProfile),
    decide_transfer(ControlProfile, ControlVerdict),
    dif(ControlVerdict, eligible),
    transfer_checklist(ControlProfile, []).

provenance_items(Context, ProvenanceItems) :-
    findall(Item, (member(Item, Context), Item = provenance(_, _)), ProvenanceItems).

test(every_subject_has_an_expectation) :-
    findall(Subject, gdpr_chapter_v_transfers_subject(Subject), Subjects),
    findall(Subject, expected(Subject, _, _), ExpectedSubjects),
    msort(Subjects, SortedSubjects),
    msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_verdict_and_basis) :-
    findall(Subject, gdpr_chapter_v_transfers_subject(Subject), Subjects),
    maplist(subject_matches_expectation, Subjects).
test(every_query_answers_exactly_once_per_subject) :-
    findall(Subject, gdpr_chapter_v_transfers_subject(Subject), Subjects),
    maplist(exactly_one_answer_everywhere, Subjects).
test(every_eligible_subject_has_a_non_empty_checklist) :-
    findall(Subject, expected(Subject, eligible, _), Subjects),
    Subjects = [_|_],
    maplist(eligible_subject_has_its_basis_checklist, Subjects).
test(every_near_miss_control_gets_another_verdict) :-
    findall(Positive - Control, near_miss_pair(Positive, Control), Pairs),
    Pairs = [_|_],
    maplist(control_differs, Pairs).
test(every_subject_is_resolvable) :-
    findall(Subject, gdpr_chapter_v_transfers_subject(Subject), Subjects),
    findall(Profile, (member(Subject, Subjects), gdpr_chapter_v_transfers_profile_for(Subject, Profile)), Profiles),
    maplist(transfer_decision_resolvable, Profiles).
test(adequacy_attested_true_is_eligible_on_article_45) :-
    subject_matches_expectation(adequacy_attested_true).
test(adequacy_wins_over_an_unsure_safeguard) :-
    subject_matches_expectation(adequacy_attested_true_with_unsure_safeguard).
test(adequacy_refused_alone_names_the_safeguard) :-
    subject_matches_expectation(adequacy_attested_false_alone).
test(safeguard_after_adequacy_refused_is_eligible_on_article_46) :-
    subject_matches_expectation(safeguard_after_adequacy_refused).
test(safeguard_without_adequacy_fact_is_eligible_on_article_46) :-
    subject_matches_expectation(safeguard_without_adequacy_fact).
test(no_safeguard_and_no_claim_is_ineligible_at_stage_three) :-
    gdpr_chapter_v_transfers_profile_for(no_safeguard_and_no_claim, Profile),
    findall(Requirement - Verdict - Basis, transfer_requirement(Profile, Requirement, Verdict, Basis), Answers),
    Answers == [art49_derogation - ineligible - none],
    transfer_permitted(Profile, false).
test(approved_binding_corporate_rules_beat_a_refused_safeguard) :-
    subject_matches_expectation(binding_corporate_rules_over_refused_safeguard).
test(refused_binding_corporate_rules_change_nothing) :-
    subject_matches_expectation(binding_corporate_rules_refused).
test(binding_corporate_rules_alone_are_eligible_on_article_46) :-
    subject_matches_expectation(binding_corporate_rules_alone).
test(an_empty_profile_is_indeterminate_on_the_safeguard) :-
    subject_matches_expectation(empty_profile),
    gdpr_chapter_v_transfers_profile_for(empty_profile, Profile),
    transfer_permitted(Profile, indeterminate([safeguard_in_place])).
test(a_refused_safeguard_without_the_adequacy_fact_refers_on_article_45_3) :-
    subject_matches_expectation(refused_safeguard_without_adequacy_fact).
test(explicit_consent_is_eligible_on_article_49) :-
    subject_matches_expectation(explicit_consent_derogation).
test(public_powers_defeat_explicit_consent) :-
    subject_matches_expectation(explicit_consent_under_public_powers).
test(explicit_consent_not_stated_is_indeterminate) :-
    subject_matches_expectation(explicit_consent_not_stated).
test(contract_necessity_is_eligible_on_article_49) :-
    subject_matches_expectation(contract_derogation).
test(public_powers_defeat_contract_necessity) :-
    subject_matches_expectation(contract_derogation_under_public_powers).
test(an_unsure_public_interest_refers_on_point_d) :-
    subject_matches_expectation(public_interest_unsure).
test(public_powers_do_not_defeat_point_d) :-
    subject_matches_expectation(public_interest_under_public_powers).
test(a_refused_public_interest_is_ineligible) :-
    subject_matches_expectation(public_interest_refused).
test(a_public_register_transfer_is_eligible) :-
    subject_matches_expectation(public_register_derogation).
test(a_refused_requester_condition_is_ineligible) :-
    subject_matches_expectation(public_register_refused_requester).
test(a_register_not_public_by_law_is_ineligible) :-
    subject_matches_expectation(public_register_not_public).
test(a_met_point_makes_the_second_subparagraph_ineligible) :-
    subject_matches_expectation(second_subparagraph_after_public_interest).
test(an_unsure_point_keeps_the_second_subparagraph_open) :-
    subject_matches_expectation(second_subparagraph_with_unsure_contract).
test(the_second_subparagraph_is_eligible_when_no_point_is_met) :-
    subject_matches_expectation(second_subparagraph_derogation).
test(public_powers_defeat_the_second_subparagraph) :-
    subject_matches_expectation(second_subparagraph_under_public_powers).
test(an_absent_point_key_keeps_the_second_subparagraph_indeterminate) :-
    subject_matches_expectation(second_subparagraph_consent_not_stated).
test(an_unsure_safeguard_names_the_missing_claim_key_first) :-
    subject_matches_expectation(unsure_safeguard_contract_not_stated),
    gdpr_chapter_v_transfers_profile_for(unsure_safeguard_contract_not_stated, Profile),
    findall(Requirement, transfer_requirement(Profile, Requirement, _, _), Requirements),
    Requirements == [art46_safeguards].
test(an_unsure_safeguard_refers_on_article_46_when_the_claim_is_complete) :-
    subject_matches_expectation(unsure_safeguard_contract_stated).
test(a_cross_reference_context_carries_no_provenance_item) :-
    gdpr_chapter_v_transfers_profile_for(refused_safeguard_without_adequacy_fact, Profile),
    decide_transfer(Profile, needs_legal_review(_, Context)),
    length(Context, 2),
    provenance_items(Context, ProvenanceItems),
    ProvenanceItems == [].
test(an_open_textured_context_carries_no_provenance_item) :-
    gdpr_chapter_v_transfers_profile_for(public_interest_unsure, Profile),
    decide_transfer(Profile, needs_legal_review(_, Context)),
    length(Context, 1),
    provenance_items(Context, ProvenanceItems),
    ProvenanceItems == [].
test(recorded_facts_change_no_verdict_and_are_listed_in_root_order) :-
    subject_matches_expectation(recorded_facts_with_safeguard),
    gdpr_chapter_v_transfers_profile_for(recorded_facts_with_safeguard, Profile),
    findall(Facts, transfer_outside_facts(Profile, Facts), Answers),
    Answers == [[outside_fact(adequacy_decision_in_force, attested(false, attestation(fixture_host, fixture_time, fixture_reason, none))), outside_fact(transfer_is_onward_transfer, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), outside_fact(third_country_judgment_or_decision_requires_transfer, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), outside_fact(international_agreement_basis_for_judgment_or_decision, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none)))]].
test(an_absent_adequacy_fact_is_recorded_as_absent) :-
    gdpr_chapter_v_transfers_profile_for(safeguard_without_adequacy_fact, Profile),
    findall(Facts, transfer_outside_facts(Profile, Facts), Answers),
    Answers == [[outside_fact(adequacy_decision_in_force, absent)]].
test(a_document_evidence_is_accepted_and_copied_as_given) :-
    Adequacy = attested(true, attestation(fixture_host, fixture_time, fixture_reason, document(upload_one, sha256_digest))),
    Profile = [attribute(adequacy_decision_in_force, Adequacy)],
    findall(Problems, gdpr_chapter_v_transfers_input_problems(Profile, Problems), ProblemLists),
    ProblemLists == [[]],
    findall(Facts, transfer_outside_facts(Profile, Facts), Answers),
    Answers == [[outside_fact(adequacy_decision_in_force, Adequacy)]],
    findall(Verdict - Basis, transfer_verdict(Profile, Verdict, Basis), Verdicts),
    Verdicts == [eligible - art45_adequacy].
test(a_document_evidence_on_a_refused_decision_names_the_safeguard) :-
    Adequacy = attested(false, attestation(fixture_host, fixture_time, fixture_reason, document(upload_one, sha256_digest))),
    findall(Verdict, decide_transfer([attribute(adequacy_decision_in_force, Adequacy)], Verdict), Verdicts),
    Verdicts == [indeterminate([safeguard_in_place])].
test(a_url_evidence_is_accepted_and_copied_as_given) :-
    Approval = attested(true, attestation(fixture_host, fixture_time, fixture_reason, url(fixture_url, fixture_retrieved_at))),
    Profile = [attribute(binding_corporate_rules_approved, Approval)],
    findall(Facts, transfer_outside_facts(Profile, Facts), Answers),
    Answers == [[outside_fact(adequacy_decision_in_force, absent), outside_fact(binding_corporate_rules_approved, Approval)]],
    findall(Verdict, decide_transfer(Profile, Verdict), Verdicts),
    Verdicts == [eligible].
test(a_wrong_atom_is_a_wrong_type_everywhere) :-
    subject_matches_expectation(safeguard_given_wrong_atom),
    gdpr_chapter_v_transfers_profile_for(safeguard_given_wrong_atom, Profile),
    findall(Requirement - Verdict - Basis, transfer_requirement(Profile, Requirement, Verdict, Basis), Answers),
    Answers == [none - input_problems([wrong_type(safeguard_in_place)]) - none],
    transfer_checklist(Profile, []),
    transfer_permitted(Profile, input_problems([wrong_type(safeguard_in_place)])),
    transfer_outside_facts(Profile, input_problems([wrong_type(safeguard_in_place)])).
test(a_duplicate_key_comes_before_an_unknown_key) :-
    subject_matches_expectation(duplicate_safeguard_and_unknown_key).
test(a_term_that_is_not_a_list_is_a_wrong_profile) :-
    subject_matches_expectation(profile_not_a_list).
test(a_bare_atom_outside_fact_is_a_wrong_type) :-
    subject_matches_expectation(binding_corporate_rules_bare_atom).
test(an_unsure_attested_value_is_a_wrong_type) :-
    subject_matches_expectation(adequacy_attested_unsure).
test(the_input_check_answers_once_for_an_unbound_profile) :-
    findall(Problems, gdpr_chapter_v_transfers_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(the_input_check_answers_once_for_a_partial_list) :-
    findall(Problems, gdpr_chapter_v_transfers_input_problems([attribute(safeguard_in_place, true)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_value_is_a_wrong_type) :-
    findall(Problems, gdpr_chapter_v_transfers_input_problems([attribute(safeguard_in_place, _)], Problems), Answers),
    Answers == [[wrong_type(safeguard_in_place)]].
test(the_requirement_ids_are_in_cascade_order) :-
    findall(Ids, transfer_requirement_ids(Ids), Answers),
    Answers == [[art45_adequacy, art46_safeguards, art49_derogation]].
test(the_verdict_pairs_the_status_and_the_basis) :-
    gdpr_chapter_v_transfers_profile_for(explicit_consent_derogation, Profile),
    findall(Verdict - Basis, transfer_verdict(Profile, Verdict, Basis), Answers),
    Answers == [eligible - art49_derogation].
test(what_if_supplying_the_safeguard_makes_the_transfer_eligible) :-
    gdpr_chapter_v_transfers_profile_for(adequacy_attested_false_alone, Profile),
    findall(Status, gdpr_chapter_v_transfers_what_if(Profile, safeguard_in_place, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_an_unread_key_keeps_the_adequacy_verdict) :-
    gdpr_chapter_v_transfers_profile_for(adequacy_attested_true, Profile),
    gdpr_chapter_v_transfers_what_if(Profile, explicit_consent_obtained, false, eligible),
    gdpr_chapter_v_transfers_what_if(Profile, public_authority_public_powers, true, eligible),
    gdpr_chapter_v_transfers_what_if(Profile, safeguard_in_place, false, eligible).
test(what_if_a_recorded_fact_changes_no_verdict) :-
    gdpr_chapter_v_transfers_profile_for(recorded_facts_with_safeguard, Profile),
    gdpr_chapter_v_transfers_what_if(Profile, transfer_is_onward_transfer, attested(false, attestation(fixture_host, fixture_time, fixture_reason, none)), eligible).
test(what_if_public_powers_defeat_the_consent_route) :-
    gdpr_chapter_v_transfers_profile_for(explicit_consent_derogation, Profile),
    findall(Status, gdpr_chapter_v_transfers_what_if(Profile, public_authority_public_powers, true, Status), Statuses),
    Statuses == [ineligible].

test(adequacy_attested_true_is_not_ineligible, fail) :-
    gdpr_chapter_v_transfers_assess(adequacy_attested_true, ineligible).
test(adequacy_refused_alone_is_not_eligible, fail) :-
    gdpr_chapter_v_transfers_assess(adequacy_attested_false_alone, eligible).
test(a_refused_safeguard_without_the_adequacy_fact_is_not_eligible, fail) :-
    gdpr_chapter_v_transfers_assess(refused_safeguard_without_adequacy_fact, eligible).
test(a_referral_context_is_not_a_provenance_only_list, fail) :-
    gdpr_chapter_v_transfers_profile_for(public_interest_unsure, Profile),
    decide_transfer(Profile, needs_legal_review(_, [provenance(_, _)])).
test(a_document_evidence_on_a_refused_decision_is_not_eligible, fail) :-
    Adequacy = attested(false, attestation(fixture_host, fixture_time, fixture_reason, document(upload_one, sha256_digest))),
    decide_transfer([attribute(adequacy_decision_in_force, Adequacy)], eligible).

cp_test_names([every_subject_has_an_expectation, every_subject_resolves_to_its_expected_verdict_and_basis, every_query_answers_exactly_once_per_subject, every_eligible_subject_has_a_non_empty_checklist, every_near_miss_control_gets_another_verdict, every_subject_is_resolvable, adequacy_attested_true_is_eligible_on_article_45, adequacy_wins_over_an_unsure_safeguard, adequacy_refused_alone_names_the_safeguard, safeguard_after_adequacy_refused_is_eligible_on_article_46, safeguard_without_adequacy_fact_is_eligible_on_article_46, no_safeguard_and_no_claim_is_ineligible_at_stage_three, approved_binding_corporate_rules_beat_a_refused_safeguard, refused_binding_corporate_rules_change_nothing, binding_corporate_rules_alone_are_eligible_on_article_46, an_empty_profile_is_indeterminate_on_the_safeguard, a_refused_safeguard_without_the_adequacy_fact_refers_on_article_45_3, explicit_consent_is_eligible_on_article_49, public_powers_defeat_explicit_consent, explicit_consent_not_stated_is_indeterminate, contract_necessity_is_eligible_on_article_49, public_powers_defeat_contract_necessity, an_unsure_public_interest_refers_on_point_d, public_powers_do_not_defeat_point_d, a_refused_public_interest_is_ineligible, a_public_register_transfer_is_eligible, a_refused_requester_condition_is_ineligible, a_register_not_public_by_law_is_ineligible, a_met_point_makes_the_second_subparagraph_ineligible, an_unsure_point_keeps_the_second_subparagraph_open, the_second_subparagraph_is_eligible_when_no_point_is_met, public_powers_defeat_the_second_subparagraph, an_absent_point_key_keeps_the_second_subparagraph_indeterminate, an_unsure_safeguard_names_the_missing_claim_key_first, an_unsure_safeguard_refers_on_article_46_when_the_claim_is_complete, a_cross_reference_context_carries_no_provenance_item, an_open_textured_context_carries_no_provenance_item, recorded_facts_change_no_verdict_and_are_listed_in_root_order, an_absent_adequacy_fact_is_recorded_as_absent, a_document_evidence_is_accepted_and_copied_as_given, a_document_evidence_on_a_refused_decision_names_the_safeguard, a_url_evidence_is_accepted_and_copied_as_given, a_wrong_atom_is_a_wrong_type_everywhere, a_duplicate_key_comes_before_an_unknown_key, a_term_that_is_not_a_list_is_a_wrong_profile, a_bare_atom_outside_fact_is_a_wrong_type, an_unsure_attested_value_is_a_wrong_type, the_input_check_answers_once_for_an_unbound_profile, the_input_check_answers_once_for_a_partial_list, an_unbound_value_is_a_wrong_type, the_requirement_ids_are_in_cascade_order, the_verdict_pairs_the_status_and_the_basis, what_if_supplying_the_safeguard_makes_the_transfer_eligible, what_if_an_unread_key_keeps_the_adequacy_verdict, what_if_a_recorded_fact_changes_no_verdict, what_if_public_powers_defeat_the_consent_route]).
cp_test_fail_names([adequacy_attested_true_is_not_ineligible, adequacy_refused_alone_is_not_eligible, a_refused_safeguard_without_the_adequacy_fact_is_not_eligible, a_referral_context_is_not_a_provenance_only_list, a_document_evidence_on_a_refused_decision_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
