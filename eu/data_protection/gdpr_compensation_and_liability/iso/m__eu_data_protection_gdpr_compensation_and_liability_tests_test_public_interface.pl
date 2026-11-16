% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, decide_gdpr_compensation_and_liability/2, gdpr_compensation_and_liability_status/2, gdpr_compensation_and_liability_checklist/2, gdpr_compensation_and_liability_decision_resolvable/1, gdpr_compensation_and_liability_status_values/1, provenance/2, attested/2, indeterminate/1, needs_legal_review/2, outside_fact/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_kernel, [gdpr_compensation_and_liability_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_queries, [gdpr_compensation_and_liability_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_subject/1, gdpr_compensation_and_liability_profile_for/2, gdpr_compensation_and_liability_assess/2]).

expected_status(controller_liable, liable_for_damage).
expected_status(controller_exempt, exempt_from_liability).
expected_status(controller_not_involved, not_liable_for_damage).
expected_status(controller_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])])).
expected_status(processor_liable_by_breach, liable_for_damage).
expected_status(processor_liable_by_instructions, liable_for_damage).
expected_status(processor_outside_both_false, not_liable_for_damage).
expected_status(damage_false_role_absent, right_not_established).
expected_status(infringement_false_outside_caller, right_not_established).
expected_status(causation_false, right_not_established).
expected_status(judgement_absent, indeterminate([damage_resulted_from_the_infringement])).
expected_status(role_absent, indeterminate([party_role])).
expected_status(controller_involvement_absent, indeterminate([involved_in_the_processing])).
expected_status(processor_keys_absent, indeterminate([processor_breached_obligations_directed_to_processors])).
expected_status(processor_second_key_absent, indeterminate([processor_acted_outside_or_contrary_to_lawful_instructions])).
expected_status(outside_caller_unsure, needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true])])).
expected_status(inside_statement_absent_with_unsure, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - unsure, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])])).
expected_status(inside_unsure, needs_legal_review(open_textured(damage_resulted_from_the_infringement, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - unsure])])).
expected_status(input_wrong_type_crisp_unsure, input_problems([wrong_type(involved_in_the_processing)])).
expected_status(input_duplicate_key, input_problems([duplicate_key(damage_suffered)])).
expected_status(input_unknown_key, input_problems([unknown_key(colour)])).
expected_status(input_not_attribute_list, input_problems([wrong_type(profile)])).
expected_status(input_unbound_value, input_problems([wrong_type(damage_suffered)])).

decidable_subject(controller_liable).
decidable_subject(controller_exempt).
decidable_subject(controller_not_involved).
decidable_subject(controller_statement_absent).
decidable_subject(processor_liable_by_breach).
decidable_subject(processor_liable_by_instructions).
decidable_subject(processor_outside_both_false).
decidable_subject(damage_false_role_absent).
decidable_subject(infringement_false_outside_caller).
decidable_subject(causation_false).
decidable_subject(judgement_absent).
decidable_subject(role_absent).
decidable_subject(controller_involvement_absent).
decidable_subject(processor_keys_absent).
decidable_subject(processor_second_key_absent).
decidable_subject(outside_caller_unsure).
decidable_subject(inside_statement_absent_with_unsure).
decidable_subject(inside_unsure).

near_miss(controller_liable, controller_exempt).
near_miss(controller_liable, controller_not_involved).
near_miss(controller_liable, controller_statement_absent).
near_miss(controller_liable, causation_false).
near_miss(controller_liable, inside_unsure).
near_miss(processor_liable_by_instructions, processor_outside_both_false).
near_miss(controller_not_involved, infringement_false_outside_caller).
near_miss(controller_not_involved, outside_caller_unsure).
near_miss(judgement_absent, damage_false_role_absent).

subject_has_expected_status(Subject) :-
    expected_status(Subject, Expected),
    findall(Status, gdpr_compensation_and_liability_assess(Subject, gdpr_compensation_and_liability_verdict(Status, _)), Statuses),
    Statuses == [Expected].

subject_has_cited_checklist(Subject) :-
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    gdpr_compensation_and_liability_checklist(Profile, [FirstItem|OtherItems]),
    maplist(cited_item, [FirstItem|OtherItems]).

cited_item(item(_, _, cite(Key))) :-
    atom(Key).

met_item(item(_, met, cite(_))).

near_miss_differs(Positive - Control) :-
    gdpr_compensation_and_liability_assess(Positive, gdpr_compensation_and_liability_verdict(PositiveStatus, _)),
    gdpr_compensation_and_liability_assess(Control, gdpr_compensation_and_liability_verdict(ControlStatus, _)),
    dif(PositiveStatus, ControlStatus).

subject_resolvable(Subject) :-
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    gdpr_compensation_and_liability_decision_resolvable(Profile).

test(every_subject_has_an_expected_status_row) :-
    findall(Subject, gdpr_compensation_and_liability_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    msort(Subjects, SortedSubjects),
    msort(ExpectedSubjects, SortedExpectedSubjects),
    SortedSubjects == SortedExpectedSubjects.
test(every_subject_resolves_to_exactly_its_expected_status) :-
    findall(Subject, gdpr_compensation_and_liability_subject(Subject), Subjects),
    maplist(subject_has_expected_status, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, gdpr_compensation_and_liability_subject(Subject), Subjects),
    maplist(subject_resolvable, Subjects).
test(controller_liable_is_liable_for_damage) :-
    gdpr_compensation_and_liability_assess(controller_liable, gdpr_compensation_and_liability_verdict(liable_for_damage, Citations)),
    sort(Citations, [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
test(controller_liable_copies_the_attested_statement_into_its_basis) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    member(attribute(not_in_any_way_responsible_for_the_event, Attested), Profile),
    compensation_liability(Profile, liable_for_damage, Basis, _),
    Basis == [outside_fact(not_in_any_way_responsible_for_the_event, Attested)].
test(controller_exempt_is_exempt_from_liability) :-
    gdpr_compensation_and_liability_assess(controller_exempt, gdpr_compensation_and_liability_verdict(exempt_from_liability, Citations)),
    sort(Citations, [cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
test(controller_exempt_copies_the_attested_statement_into_its_basis) :-
    gdpr_compensation_and_liability_profile_for(controller_exempt, Profile),
    member(attribute(not_in_any_way_responsible_for_the_event, Attested), Profile),
    compensation_liability(Profile, exempt_from_liability, Basis, _),
    Basis == [outside_fact(not_in_any_way_responsible_for_the_event, Attested)].
test(controller_not_involved_is_not_liable_for_damage) :-
    compensation_liability_of(controller_not_involved, not_liable_for_damage, [], [cite(eu_reg_2016_679_art_82_2)]).
test(controller_statement_absent_refers_the_cross_reference) :-
    gdpr_compensation_and_liability_assess(controller_statement_absent, gdpr_compensation_and_liability_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), _), [])).
test(processor_liable_by_breach_is_liable_for_damage) :-
    gdpr_compensation_and_liability_assess(processor_liable_by_breach, gdpr_compensation_and_liability_verdict(liable_for_damage, _)).
test(processor_liable_by_instructions_is_liable_for_damage) :-
    gdpr_compensation_and_liability_assess(processor_liable_by_instructions, gdpr_compensation_and_liability_verdict(liable_for_damage, _)).
test(processor_outside_both_false_is_not_liable_for_damage) :-
    compensation_liability_of(processor_outside_both_false, not_liable_for_damage, [], [cite(eu_reg_2016_679_art_82_2)]).
test(damage_false_role_absent_is_right_not_established) :-
    compensation_liability_of(damage_false_role_absent, right_not_established, [], [cite(eu_reg_2016_679_art_82_1)]).
test(infringement_false_outside_caller_is_right_not_established) :-
    compensation_liability_of(infringement_false_outside_caller, right_not_established, [], [cite(eu_reg_2016_679_art_82_1)]).
test(causation_false_is_right_not_established) :-
    compensation_liability_of(causation_false, right_not_established, [], [cite(eu_reg_2016_679_art_82_1)]).
test(judgement_absent_names_the_absent_judgement) :-
    compensation_liability_of(judgement_absent, indeterminate([damage_resulted_from_the_infringement]), [], []).
test(role_absent_names_party_role) :-
    compensation_liability_of(role_absent, indeterminate([party_role]), [], []).
test(controller_involvement_absent_names_involvement) :-
    compensation_liability_of(controller_involvement_absent, indeterminate([involved_in_the_processing]), [], []).
test(processor_keys_absent_names_the_first_processor_key) :-
    compensation_liability_of(processor_keys_absent, indeterminate([processor_breached_obligations_directed_to_processors]), [], []).
test(processor_second_key_absent_names_the_second_processor_key) :-
    compensation_liability_of(processor_second_key_absent, indeterminate([processor_acted_outside_or_contrary_to_lawful_instructions]), [], []).
test(outside_caller_unsure_is_referred_on_the_unsure_judgement) :-
    gdpr_compensation_and_liability_assess(outside_caller_unsure, gdpr_compensation_and_liability_verdict(needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true])]), [])).
test(inside_statement_absent_with_unsure_refers_the_cross_reference_first) :-
    gdpr_compensation_and_liability_assess(inside_statement_absent_with_unsure, gdpr_compensation_and_liability_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - unsure, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])]), [])).
test(inside_unsure_is_referred_on_causation) :-
    gdpr_compensation_and_liability_assess(inside_unsure, gdpr_compensation_and_liability_verdict(needs_legal_review(open_textured(damage_resulted_from_the_infringement, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - unsure])]), [])).
test(input_wrong_type_crisp_unsure_is_an_input_problem) :-
    compensation_liability_of(input_wrong_type_crisp_unsure, input_problems([wrong_type(involved_in_the_processing)]), [], []).
test(input_duplicate_key_is_an_input_problem) :-
    compensation_liability_of(input_duplicate_key, input_problems([duplicate_key(damage_suffered)]), [], []).
test(input_unknown_key_is_an_input_problem) :-
    compensation_liability_of(input_unknown_key, input_problems([unknown_key(colour)]), [], []).
test(input_not_attribute_list_is_an_input_problem) :-
    compensation_liability_of(input_not_attribute_list, input_problems([wrong_type(profile)]), [], []).
test(input_unbound_value_is_an_input_problem) :-
    compensation_liability_of(input_unbound_value, input_problems([wrong_type(damage_suffered)]), [], []).
test(every_near_miss_control_gets_another_verdict) :-
    findall(Positive - Control, near_miss(Positive, Control), Pairs),
    length(Pairs, 9),
    maplist(near_miss_differs, Pairs).
test(every_decidable_subject_has_a_cited_checklist) :-
    findall(Subject, decidable_subject(Subject), Subjects),
    maplist(subject_has_cited_checklist, Subjects).
test(the_liable_subject_has_every_item_met) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    gdpr_compensation_and_liability_checklist(Profile, Items),
    length(Items, 5),
    maplist(met_item, Items).
test(the_exempt_subject_has_an_unmet_item) :-
    gdpr_compensation_and_liability_profile_for(controller_exempt, Profile),
    gdpr_compensation_and_liability_checklist(Profile, Items),
    member(item(_, unmet(_), cite(eu_reg_2016_679_art_82_3)), Items).
test(the_status_projection_gives_the_final_atom) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    gdpr_compensation_and_liability_status(Profile, liable_for_damage).
test(the_decision_gives_the_verdict_term) :-
    gdpr_compensation_and_liability_profile_for(controller_not_involved, Profile),
    decide_gdpr_compensation_and_liability(Profile, gdpr_compensation_and_liability_verdict(not_liable_for_damage, [cite(eu_reg_2016_679_art_82_2)])).
test(the_final_statuses_are_in_the_status_vocabulary) :-
    gdpr_compensation_and_liability_status_values(StatusValues),
    member(liable_for_damage, StatusValues),
    member(exempt_from_liability, StatusValues),
    member(not_liable_for_damage, StatusValues),
    member(right_not_established, StatusValues).
test(the_provenance_constructor_holds_for_a_source_and_detail) :-
    provenance(non_responsibility_statement, attested_by_host).
test(the_url_constructor_holds_for_an_address_and_retrieval_time) :-
    Evidence = url(evidence_address, retrieved_at),
    Evidence = url(Address, RetrievedAt),
    Address == evidence_address,
    RetrievedAt == retrieved_at.
test(the_document_constructor_holds_for_an_upload_and_hash) :-
    Evidence = document(upload_identifier, content_hash),
    Evidence = document(UploadIdentifier, ContentHash),
    UploadIdentifier == upload_identifier,
    ContentHash == content_hash.
test(an_attestation_with_url_evidence_is_attested) :-
    attested(true, attestation(host_operator, recorded_at, reason_given, url(evidence_address, retrieved_at))).
test(an_attestation_with_document_evidence_is_attested) :-
    attested(false, attestation(host_operator, recorded_at, reason_given, document(upload_identifier, content_hash))).
test(document_evidence_is_copied_into_the_basis) :-
    gdpr_compensation_and_liability_profile_for(processor_liable_by_breach, Profile),
    compensation_liability(Profile, liable_for_damage, Basis, _),
    Basis == [outside_fact(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, document(upload_identifier, content_hash))))].
test(url_evidence_is_copied_into_the_basis) :-
    gdpr_compensation_and_liability_profile_for(controller_exempt, Profile),
    compensation_liability(Profile, exempt_from_liability, Basis, _),
    Basis == [outside_fact(not_in_any_way_responsible_for_the_event, attested(true, attestation(host_operator, recorded_at, reason_given, url(evidence_address, retrieved_at))))].
test(the_indeterminate_constructor_holds_for_one_key) :-
    indeterminate([damage_suffered]).
test(the_needs_legal_review_constructor_holds_for_a_referral) :-
    needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true])]).
test(the_needs_legal_review_constructor_holds_for_a_cross_reference) :-
    needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])]).
test(the_outside_fact_constructor_holds_for_an_attested_statement) :-
    outside_fact(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none))).
test(the_input_problems_constructor_holds_for_a_problem_list) :-
    input_problems([unknown_key(colour)]).
test(the_unknown_key_constructor_holds_for_an_atom_key) :-
    unknown_key(colour).
test(the_unknown_key_constructor_holds_for_a_number_key) :-
    unknown_key(42).
test(the_wrong_type_constructor_holds_for_a_key) :-
    wrong_type(party_role).
test(the_wrong_type_constructor_holds_for_the_profile) :-
    wrong_type(profile).
test(the_duplicate_key_constructor_holds_for_a_key) :-
    duplicate_key(damage_suffered).
test(an_empty_profile_has_no_input_problem) :-
    gdpr_compensation_and_liability_input_problems([], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, gdpr_compensation_and_liability_input_problems(_UnboundProfile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, gdpr_compensation_and_liability_input_problems([attribute(damage_suffered, true)|_Rest], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_number_key_is_an_unknown_key) :-
    gdpr_compensation_and_liability_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_well_formed_fixture_has_no_input_problem) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    gdpr_compensation_and_liability_input_problems(Profile, []).
test(what_if_the_statement_is_attested_true_the_controller_is_exempt) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    gdpr_compensation_and_liability_what_if(Profile, not_in_any_way_responsible_for_the_event, attested(true, attestation(host_operator, recorded_at, reason_given, none)), exempt_from_liability).
test(what_if_the_controller_is_not_involved_it_is_not_liable) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    gdpr_compensation_and_liability_what_if(Profile, involved_in_the_processing, false, not_liable_for_damage).

test(controller_liable_is_not_exempt, fail) :-
    gdpr_compensation_and_liability_assess(controller_liable, gdpr_compensation_and_liability_verdict(exempt_from_liability, _)).
test(controller_exempt_is_not_liable_for_damage, fail) :-
    gdpr_compensation_and_liability_assess(controller_exempt, gdpr_compensation_and_liability_verdict(liable_for_damage, _)).
test(controller_not_involved_is_not_liable, fail) :-
    gdpr_compensation_and_liability_assess(controller_not_involved, gdpr_compensation_and_liability_verdict(liable_for_damage, _)).
test(controller_statement_absent_never_names_the_outside_fact_as_missing, fail) :-
    gdpr_compensation_and_liability_assess(controller_statement_absent, gdpr_compensation_and_liability_verdict(indeterminate(_), _)).
test(processor_liable_by_breach_does_not_need_the_second_key, fail) :-
    gdpr_compensation_and_liability_assess(processor_liable_by_breach, gdpr_compensation_and_liability_verdict(indeterminate(_), _)).
test(processor_liable_by_instructions_is_not_outside, fail) :-
    gdpr_compensation_and_liability_assess(processor_liable_by_instructions, gdpr_compensation_and_liability_verdict(not_liable_for_damage, _)).
test(processor_outside_both_false_is_not_liable, fail) :-
    gdpr_compensation_and_liability_assess(processor_outside_both_false, gdpr_compensation_and_liability_verdict(liable_for_damage, _)).
test(damage_false_role_absent_names_no_missing_key, fail) :-
    gdpr_compensation_and_liability_assess(damage_false_role_absent, gdpr_compensation_and_liability_verdict(indeterminate(_), _)).
test(infringement_false_outside_caller_is_not_answered_not_liable, fail) :-
    gdpr_compensation_and_liability_assess(infringement_false_outside_caller, gdpr_compensation_and_liability_verdict(not_liable_for_damage, _)).
test(causation_false_is_not_liable_for_damage, fail) :-
    gdpr_compensation_and_liability_assess(causation_false, gdpr_compensation_and_liability_verdict(liable_for_damage, _)).
test(judgement_absent_is_not_right_not_established, fail) :-
    gdpr_compensation_and_liability_assess(judgement_absent, gdpr_compensation_and_liability_verdict(right_not_established, _)).
test(processor_keys_absent_never_names_the_controller_key, fail) :-
    gdpr_compensation_and_liability_assess(processor_keys_absent, gdpr_compensation_and_liability_verdict(indeterminate([involved_in_the_processing]), _)).
test(outside_caller_unsure_does_not_read_the_statement, fail) :-
    gdpr_compensation_and_liability_assess(outside_caller_unsure, gdpr_compensation_and_liability_verdict(needs_legal_review(cross_reference_unresolved(_, _), _), _)).
test(inside_statement_absent_with_unsure_is_not_open_textured, fail) :-
    gdpr_compensation_and_liability_assess(inside_statement_absent_with_unsure, gdpr_compensation_and_liability_verdict(needs_legal_review(open_textured(_, _), _), _)).
test(inside_unsure_gives_no_final_answer, fail) :-
    gdpr_compensation_and_liability_assess(inside_unsure, gdpr_compensation_and_liability_verdict(liable_for_damage, _)).
test(input_duplicate_key_is_never_also_wrong_type, fail) :-
    gdpr_compensation_and_liability_assess(input_duplicate_key, gdpr_compensation_and_liability_verdict(input_problems([wrong_type(damage_suffered)]), _)).
test(an_input_problem_gives_no_final_answer, fail) :-
    gdpr_compensation_and_liability_assess(input_unknown_key, gdpr_compensation_and_liability_verdict(liable_for_damage, _)).
test(the_exempt_subject_does_not_have_every_item_met, fail) :-
    gdpr_compensation_and_liability_profile_for(controller_exempt, Profile),
    gdpr_compensation_and_liability_checklist(Profile, Items),
    maplist(met_item, Items).
test(a_malformed_profile_has_no_checklist, fail) :-
    gdpr_compensation_and_liability_profile_for(input_unknown_key, Profile),
    gdpr_compensation_and_liability_checklist(Profile, _).
test(an_unsure_attested_value_is_not_attested, fail) :-
    attested(unsure, attestation(host_operator, recorded_at, reason_given, document(upload_identifier, content_hash))).
test(the_indeterminate_constructor_refuses_an_empty_list, fail) :-
    indeterminate([]).
test(the_needs_legal_review_constructor_refuses_a_bare_reason, fail) :-
    needs_legal_review(no_reason_given, []).
test(the_outside_fact_constructor_refuses_a_bare_value, fail) :-
    outside_fact(not_in_any_way_responsible_for_the_event, true).
test(the_input_problems_constructor_refuses_an_empty_list, fail) :-
    input_problems([]).
test(the_wrong_type_constructor_refuses_a_number, fail) :-
    wrong_type(42).
test(the_duplicate_key_constructor_refuses_a_compound, fail) :-
    duplicate_key(colour(red)).
test(what_if_the_controller_is_not_involved_it_is_not_still_liable, fail) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    gdpr_compensation_and_liability_what_if(Profile, involved_in_the_processing, false, liable_for_damage).

compensation_liability_of(Subject, Result, Basis, Citations) :-
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    findall(Found - FoundBasis - FoundCitations, compensation_liability(Profile, Found, FoundBasis, FoundCitations), Answers),
    Answers == [Result - Basis - Citations].

cp_test_names([every_subject_has_an_expected_status_row, every_subject_resolves_to_exactly_its_expected_status, every_subject_is_resolvable, controller_liable_is_liable_for_damage, controller_liable_copies_the_attested_statement_into_its_basis, controller_exempt_is_exempt_from_liability, controller_exempt_copies_the_attested_statement_into_its_basis, controller_not_involved_is_not_liable_for_damage, controller_statement_absent_refers_the_cross_reference, processor_liable_by_breach_is_liable_for_damage, processor_liable_by_instructions_is_liable_for_damage, processor_outside_both_false_is_not_liable_for_damage, damage_false_role_absent_is_right_not_established, infringement_false_outside_caller_is_right_not_established, causation_false_is_right_not_established, judgement_absent_names_the_absent_judgement, role_absent_names_party_role, controller_involvement_absent_names_involvement, processor_keys_absent_names_the_first_processor_key, processor_second_key_absent_names_the_second_processor_key, outside_caller_unsure_is_referred_on_the_unsure_judgement, inside_statement_absent_with_unsure_refers_the_cross_reference_first, inside_unsure_is_referred_on_causation, input_wrong_type_crisp_unsure_is_an_input_problem, input_duplicate_key_is_an_input_problem, input_unknown_key_is_an_input_problem, input_not_attribute_list_is_an_input_problem, input_unbound_value_is_an_input_problem, every_near_miss_control_gets_another_verdict, every_decidable_subject_has_a_cited_checklist, the_liable_subject_has_every_item_met, the_exempt_subject_has_an_unmet_item, the_status_projection_gives_the_final_atom, the_decision_gives_the_verdict_term, the_final_statuses_are_in_the_status_vocabulary, the_provenance_constructor_holds_for_a_source_and_detail, the_url_constructor_holds_for_an_address_and_retrieval_time, the_document_constructor_holds_for_an_upload_and_hash, an_attestation_with_url_evidence_is_attested, an_attestation_with_document_evidence_is_attested, document_evidence_is_copied_into_the_basis, url_evidence_is_copied_into_the_basis, the_indeterminate_constructor_holds_for_one_key, the_needs_legal_review_constructor_holds_for_a_referral, the_needs_legal_review_constructor_holds_for_a_cross_reference, the_outside_fact_constructor_holds_for_an_attested_statement, the_input_problems_constructor_holds_for_a_problem_list, the_unknown_key_constructor_holds_for_an_atom_key, the_unknown_key_constructor_holds_for_a_number_key, the_wrong_type_constructor_holds_for_a_key, the_wrong_type_constructor_holds_for_the_profile, the_duplicate_key_constructor_holds_for_a_key, an_empty_profile_has_no_input_problem, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_number_key_is_an_unknown_key, a_well_formed_fixture_has_no_input_problem, what_if_the_statement_is_attested_true_the_controller_is_exempt, what_if_the_controller_is_not_involved_it_is_not_liable]).
cp_test_fail_names([controller_liable_is_not_exempt, controller_exempt_is_not_liable_for_damage, controller_not_involved_is_not_liable, controller_statement_absent_never_names_the_outside_fact_as_missing, processor_liable_by_breach_does_not_need_the_second_key, processor_liable_by_instructions_is_not_outside, processor_outside_both_false_is_not_liable, damage_false_role_absent_names_no_missing_key, infringement_false_outside_caller_is_not_answered_not_liable, causation_false_is_not_liable_for_damage, judgement_absent_is_not_right_not_established, processor_keys_absent_never_names_the_controller_key, outside_caller_unsure_does_not_read_the_statement, inside_statement_absent_with_unsure_is_not_open_textured, inside_unsure_gives_no_final_answer, input_duplicate_key_is_never_also_wrong_type, an_input_problem_gives_no_final_answer, the_exempt_subject_does_not_have_every_item_met, a_malformed_profile_has_no_checklist, an_unsure_attested_value_is_not_attested, the_indeterminate_constructor_refuses_an_empty_list, the_needs_legal_review_constructor_refuses_a_bare_reason, the_outside_fact_constructor_refuses_a_bare_value, the_input_problems_constructor_refuses_an_empty_list, the_wrong_type_constructor_refuses_a_number, the_duplicate_key_constructor_refuses_a_compound, what_if_the_controller_is_not_involved_it_is_not_still_liable]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
