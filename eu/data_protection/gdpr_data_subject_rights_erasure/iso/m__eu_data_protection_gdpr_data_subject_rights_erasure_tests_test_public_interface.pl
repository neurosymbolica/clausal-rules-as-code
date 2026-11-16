% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_queries, [decide_data_subject_request/2, gdpr_data_subject_rights_erasure_what_if/4, gdpr_data_subject_rights_erasure_compliance_check/3, provenance/2, attested/2, attestation/4, url/2, document/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_kernel, [gdpr_data_subject_rights_erasure_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_request_basis, [request_basis_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_fixtures, [gdpr_data_subject_rights_erasure_subject/1, gdpr_data_subject_rights_erasure_profile_for/2, gdpr_data_subject_rights_erasure_assess/2]).

expected(must_comply_no_longer_necessary, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(request_type_absent, gdpr_data_subject_request_verdict(indeterminate([request_type]), none, none, [], [])).
expected(must_comply_consent_withdrawn, gdpr_data_subject_request_verdict(must_comply, art17_1_b, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_b)])).
expected(need_not_comply_other_legal_ground, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_17_1)])).
expected(must_comply_marketing_objection, gdpr_data_subject_request_verdict(must_comply, art17_1_c, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_c)])).
expected(need_not_comply_overriding_grounds, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_17_1)])).
expected(must_comply_erasure_law_attested, gdpr_data_subject_request_verdict(must_comply, art17_1_e, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_e)])).
expected(need_not_comply_no_ground, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_17_1)])).
expected(needs_legal_review_erasure_law_unattested, gdpr_data_subject_request_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)), [resolution(cite(union_or_member_state_law_requiring_erasure), not_attempted), inputs_relied_on([request_type - erasure, data_no_longer_necessary_for_purposes - false, personal_data_unlawfully_processed - false, erasure_required_by_union_or_member_state_law - absent])]), none, none, [], [])).
expected(must_comply_unlawful_processing, gdpr_data_subject_request_verdict(must_comply, art17_1_d, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_d)])).
expected(needs_legal_review_unlawful_processing_unsure, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_17_1_d)), [inputs_relied_on([request_type - erasure, data_no_longer_necessary_for_purposes - false, personal_data_unlawfully_processed - unsure])]), none, none, [], [])).
expected(need_not_comply_freedom_of_expression, gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art17_3_a, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_a)])).
expected(must_comply_freedom_of_expression_ruled_out, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(need_not_comply_public_task_with_basis_open, gdpr_data_subject_request_verdict(need_not_comply, none, art17_3_b, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_b)])).
expected(indeterminate_every_missing_key, gdpr_data_subject_request_verdict(indeterminate([consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed]), none, none, [], [])).
expected(need_not_comply_processing_required_by_law, gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art17_3_b, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_b)])).
expected(must_comply_processing_obligation_attested_false, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(need_not_comply_archiving_impairment, gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art17_3_d, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_d)])).
expected(must_comply_archiving_without_impairment, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(need_not_comply_legal_claims, gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art17_3_e, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_e)])).
expected(needs_legal_review_legal_claims_unsure, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(processing_necessary_for_legal_claims, cite(eu_reg_2016_679_art_17_3_e)), [inputs_relied_on([request_type - erasure, processing_necessary_for_legal_claims - unsure])]), none, none, [], [])).
expected(need_not_comply_manifestly_unfounded_with_fee, gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [cite(eu_reg_2016_679_art_12_5), cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(must_comply_request_not_manifestly_unfounded, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(need_not_comply_unable_to_identify, gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art12_2_unable_to_identify, [], [cite(eu_reg_2016_679_art_12_2), cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(must_comply_controller_able_to_identify, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(need_not_comply_legislative_restriction_attested, gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art23_legislative_restriction, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_23_1)])).
expected(must_comply_legislative_restriction_attested_false, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(suspended_identity_not_confirmed, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
expected(must_comply_identity_confirmed, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).
expected(indeterminate_identity_confirmed_absent, gdpr_data_subject_request_verdict(indeterminate([identity_confirmed]), none, none, [], [])).
expected(input_problems_duplicate_and_unknown, gdpr_data_subject_request_verdict(input_problems([duplicate_key(data_no_longer_necessary_for_purposes), unknown_key(colour)]), none, none, [], [])).
expected(input_problems_wrong_boolean_value, gdpr_data_subject_request_verdict(input_problems([wrong_type(consent_withdrawn)]), none, none, [], [])).
expected(must_comply_with_valid_boolean, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])).

resolves_to_expected(Subject) :-
    expected(Subject, ExpectedVerdict),
    findall(Verdict, gdpr_data_subject_rights_erasure_assess(Subject, Verdict), Verdicts),
    Verdicts == [ExpectedVerdict].

has_expected(Subject) :-
    expected(Subject, _).

answers_once(Subject) :-
    findall(Verdict, gdpr_data_subject_rights_erasure_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

has_non_empty_checklist(Subject) :-
    gdpr_data_subject_rights_erasure_profile_for(Subject, Profile),
    request_basis_checklist(Profile, [_|_]).

comply_of(Subject, Comply) :-
    gdpr_data_subject_rights_erasure_assess(Subject, gdpr_data_subject_request_verdict(Comply, _, _, _, _)).

test(every_fixture_subject_has_an_expected_verdict) :-
    findall(Subject, gdpr_data_subject_rights_erasure_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(has_expected, Subjects).
test(every_fixture_subject_answers_exactly_once) :-
    findall(Subject, gdpr_data_subject_rights_erasure_subject(Subject), Subjects),
    maplist(answers_once, Subjects).
test(every_fixture_subject_resolves_to_its_expected_verdict) :-
    findall(Subject, gdpr_data_subject_rights_erasure_subject(Subject), Subjects),
    maplist(resolves_to_expected, Subjects).
test(must_comply_no_longer_necessary) :-
    resolves_to_expected(must_comply_no_longer_necessary).
test(request_type_absent) :-
    resolves_to_expected(request_type_absent).
test(must_comply_consent_withdrawn) :-
    resolves_to_expected(must_comply_consent_withdrawn).
test(need_not_comply_other_legal_ground) :-
    resolves_to_expected(need_not_comply_other_legal_ground).
test(must_comply_marketing_objection) :-
    resolves_to_expected(must_comply_marketing_objection).
test(need_not_comply_overriding_grounds) :-
    resolves_to_expected(need_not_comply_overriding_grounds).
test(must_comply_erasure_law_attested) :-
    resolves_to_expected(must_comply_erasure_law_attested).
test(need_not_comply_no_ground) :-
    resolves_to_expected(need_not_comply_no_ground).
test(needs_legal_review_erasure_law_unattested) :-
    resolves_to_expected(needs_legal_review_erasure_law_unattested).
test(must_comply_unlawful_processing) :-
    resolves_to_expected(must_comply_unlawful_processing).
test(needs_legal_review_unlawful_processing_unsure) :-
    resolves_to_expected(needs_legal_review_unlawful_processing_unsure).
test(need_not_comply_freedom_of_expression) :-
    resolves_to_expected(need_not_comply_freedom_of_expression).
test(must_comply_freedom_of_expression_ruled_out) :-
    resolves_to_expected(must_comply_freedom_of_expression_ruled_out).
test(need_not_comply_public_task_with_basis_open) :-
    resolves_to_expected(need_not_comply_public_task_with_basis_open).
test(indeterminate_every_missing_key) :-
    resolves_to_expected(indeterminate_every_missing_key).
test(need_not_comply_processing_required_by_law) :-
    resolves_to_expected(need_not_comply_processing_required_by_law).
test(must_comply_processing_obligation_attested_false) :-
    resolves_to_expected(must_comply_processing_obligation_attested_false).
test(need_not_comply_archiving_impairment) :-
    resolves_to_expected(need_not_comply_archiving_impairment).
test(must_comply_archiving_without_impairment) :-
    resolves_to_expected(must_comply_archiving_without_impairment).
test(need_not_comply_legal_claims) :-
    resolves_to_expected(need_not_comply_legal_claims).
test(needs_legal_review_legal_claims_unsure) :-
    resolves_to_expected(needs_legal_review_legal_claims_unsure).
test(need_not_comply_manifestly_unfounded_with_fee) :-
    resolves_to_expected(need_not_comply_manifestly_unfounded_with_fee).
test(must_comply_request_not_manifestly_unfounded) :-
    resolves_to_expected(must_comply_request_not_manifestly_unfounded).
test(need_not_comply_unable_to_identify) :-
    resolves_to_expected(need_not_comply_unable_to_identify).
test(must_comply_controller_able_to_identify) :-
    resolves_to_expected(must_comply_controller_able_to_identify).
test(need_not_comply_legislative_restriction_attested) :-
    resolves_to_expected(need_not_comply_legislative_restriction_attested).
test(must_comply_legislative_restriction_attested_false) :-
    resolves_to_expected(must_comply_legislative_restriction_attested_false).
test(suspended_identity_not_confirmed) :-
    resolves_to_expected(suspended_identity_not_confirmed).
test(must_comply_identity_confirmed) :-
    resolves_to_expected(must_comply_identity_confirmed).
test(indeterminate_identity_confirmed_absent) :-
    resolves_to_expected(indeterminate_identity_confirmed_absent).
test(input_problems_duplicate_and_unknown) :-
    resolves_to_expected(input_problems_duplicate_and_unknown).
test(input_problems_wrong_boolean_value) :-
    resolves_to_expected(input_problems_wrong_boolean_value).
test(must_comply_with_valid_boolean) :-
    resolves_to_expected(must_comply_with_valid_boolean).
test(a_well_formed_profile_has_no_input_problem) :-
    gdpr_data_subject_rights_erasure_profile_for(must_comply_no_longer_necessary, Profile),
    gdpr_data_subject_rights_erasure_input_problems(Profile, []).
test(a_non_list_profile_is_a_wrong_type) :-
    findall(Problems, gdpr_data_subject_rights_erasure_input_problems(not_a_list, Problems), ProblemLists),
    ProblemLists == [[wrong_type(profile)]].
test(a_non_list_profile_answers_input_problems) :-
    findall(Verdict, decide_data_subject_request(not_a_list, Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(input_problems([wrong_type(profile)]), none, none, [], [])].
test(an_unread_key_does_not_change_the_answer) :-
    findall(Verdict, decide_data_subject_request([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(personal_data_inaccurate, true)], Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)])].
test(the_checklist_carries_a_cite_per_ground) :-
    gdpr_data_subject_rights_erasure_profile_for(must_comply_no_longer_necessary, Profile),
    request_basis_checklist(Profile, Items),
    length(Items, 6),
    member(item(art17_1_a, met, cite(eu_reg_2016_679_art_17_1_a)), Items).
test(every_erasure_fixture_has_a_non_empty_checklist) :-
    maplist(has_non_empty_checklist, [must_comply_no_longer_necessary, need_not_comply_no_ground, needs_legal_review_erasure_law_unattested, need_not_comply_freedom_of_expression, indeterminate_every_missing_key, suspended_identity_not_confirmed, need_not_comply_manifestly_unfounded_with_fee]).
test(what_if_freedom_of_expression_relieves) :-
    gdpr_data_subject_rights_erasure_profile_for(must_comply_no_longer_necessary, Profile),
    findall(Verdict, gdpr_data_subject_rights_erasure_what_if(Profile, processing_necessary_for_freedom_of_expression_and_information, true, Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art17_3_a, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_17_3), cite(eu_reg_2016_679_art_17_3_a)])].
test(refusal_is_permitted_when_relieved) :-
    gdpr_data_subject_rights_erasure_profile_for(need_not_comply_freedom_of_expression, Profile),
    findall(Verdict, gdpr_data_subject_rights_erasure_compliance_check(Profile, refuse_erasure, Verdict), Verdicts),
    Verdicts == [permitted].
test(refusal_is_forbidden_when_the_controller_must_comply) :-
    gdpr_data_subject_rights_erasure_profile_for(must_comply_no_longer_necessary, Profile),
    findall(Verdict, gdpr_data_subject_rights_erasure_compliance_check(Profile, refuse_erasure, Verdict), Verdicts),
    Verdicts == [forbidden].
test(a_fee_is_permitted_for_a_manifestly_unfounded_request) :-
    gdpr_data_subject_rights_erasure_profile_for(need_not_comply_manifestly_unfounded_with_fee, Profile),
    gdpr_data_subject_rights_erasure_compliance_check(Profile, charge_reasonable_fee, permitted).
test(a_fee_is_forbidden_under_another_relief) :-
    gdpr_data_subject_rights_erasure_profile_for(need_not_comply_freedom_of_expression, Profile),
    gdpr_data_subject_rights_erasure_compliance_check(Profile, charge_reasonable_fee, forbidden).
test(deferral_is_permitted_while_identity_is_unconfirmed) :-
    gdpr_data_subject_rights_erasure_profile_for(suspended_identity_not_confirmed, Profile),
    gdpr_data_subject_rights_erasure_compliance_check(Profile, defer_pending_identity, permitted).
test(an_open_verdict_is_not_yet_determined) :-
    gdpr_data_subject_rights_erasure_profile_for(indeterminate_identity_confirmed_absent, Profile),
    findall(Verdict, gdpr_data_subject_rights_erasure_compliance_check(Profile, refuse_erasure, Verdict), Verdicts),
    Verdicts == [not_yet_determined].
test(provenance_builds_from_a_clause_and_citations) :-
    provenance(step_iv, [cite(eu_reg_2016_679_art_17_1)]).
test(attested_builds_from_a_value_and_an_attestation) :-
    attested(true, attestation(by, at, reason, none)).
test(attestation_builds_from_four_ground_parts) :-
    attestation(by, at, reason, url('https://eur-lex.europa.eu', at)).
test(url_builds_from_an_address_and_a_time) :-
    url('https://eur-lex.europa.eu', retrieved_at).
test(document_builds_from_an_upload_and_a_hash) :-
    document(upload_identifier, content_hash).

test(a_ruled_out_freedom_of_expression_does_not_relieve, fail) :-
    comply_of(must_comply_freedom_of_expression_ruled_out, need_not_comply).
test(freedom_of_expression_does_not_leave_a_duty, fail) :-
    comply_of(need_not_comply_freedom_of_expression, must_comply).
test(an_other_legal_ground_defeats_point_b, fail) :-
    comply_of(need_not_comply_other_legal_ground, must_comply).
test(overriding_grounds_defeat_point_c, fail) :-
    comply_of(need_not_comply_overriding_grounds, must_comply).
test(an_erasure_law_attested_false_does_not_engage, fail) :-
    comply_of(need_not_comply_no_ground, must_comply).
test(an_unattested_erasure_law_is_not_final, fail) :-
    comply_of(needs_legal_review_erasure_law_unattested, need_not_comply).
test(an_unsure_unlawfulness_is_not_must_comply, fail) :-
    comply_of(needs_legal_review_unlawful_processing_unsure, must_comply).
test(a_public_task_ruled_out_leaves_the_missing_keys, fail) :-
    comply_of(indeterminate_every_missing_key, need_not_comply).
test(a_processing_obligation_attested_false_does_not_relieve, fail) :-
    comply_of(must_comply_processing_obligation_attested_false, need_not_comply).
test(archiving_without_impairment_does_not_relieve, fail) :-
    comply_of(must_comply_archiving_without_impairment, need_not_comply).
test(unsure_legal_claims_do_not_relieve, fail) :-
    comply_of(needs_legal_review_legal_claims_unsure, need_not_comply).
test(a_founded_request_does_not_relieve, fail) :-
    comply_of(must_comply_request_not_manifestly_unfounded, need_not_comply).
test(an_identifying_controller_is_not_relieved, fail) :-
    comply_of(must_comply_controller_able_to_identify, need_not_comply).
test(a_restriction_attested_false_does_not_relieve, fail) :-
    comply_of(must_comply_legislative_restriction_attested_false, need_not_comply).
test(a_confirmed_identity_does_not_suspend, fail) :-
    comply_of(must_comply_identity_confirmed, suspended(_)).
test(an_unconfirmed_identity_is_not_must_comply, fail) :-
    comply_of(suspended_identity_not_confirmed, must_comply).
test(an_absent_identity_confirmation_is_not_suspended, fail) :-
    comply_of(indeterminate_identity_confirmed_absent, suspended(_)).
test(a_valid_boolean_is_no_input_problem, fail) :-
    comply_of(must_comply_with_valid_boolean, input_problems(_)).
test(a_wrong_boolean_is_not_must_comply, fail) :-
    comply_of(input_problems_wrong_boolean_value, must_comply).
test(a_fee_is_not_permitted_under_another_relief, fail) :-
    gdpr_data_subject_rights_erasure_profile_for(need_not_comply_freedom_of_expression, Profile),
    gdpr_data_subject_rights_erasure_compliance_check(Profile, charge_reasonable_fee, permitted).
test(provenance_needs_a_citation_list, fail) :-
    provenance(step_iv, not_a_list).
test(attested_needs_a_compound_attestation, fail) :-
    attested(true, none).
test(attestation_needs_every_part, fail) :-
    attestation(by, _, reason, none).
test(url_needs_an_address, fail) :-
    url(_, retrieved_at).
test(document_needs_a_hash, fail) :-
    document(upload_identifier, _).

cp_test_names([every_fixture_subject_has_an_expected_verdict, every_fixture_subject_answers_exactly_once, every_fixture_subject_resolves_to_its_expected_verdict, must_comply_no_longer_necessary, request_type_absent, must_comply_consent_withdrawn, need_not_comply_other_legal_ground, must_comply_marketing_objection, need_not_comply_overriding_grounds, must_comply_erasure_law_attested, need_not_comply_no_ground, needs_legal_review_erasure_law_unattested, must_comply_unlawful_processing, needs_legal_review_unlawful_processing_unsure, need_not_comply_freedom_of_expression, must_comply_freedom_of_expression_ruled_out, need_not_comply_public_task_with_basis_open, indeterminate_every_missing_key, need_not_comply_processing_required_by_law, must_comply_processing_obligation_attested_false, need_not_comply_archiving_impairment, must_comply_archiving_without_impairment, need_not_comply_legal_claims, needs_legal_review_legal_claims_unsure, need_not_comply_manifestly_unfounded_with_fee, must_comply_request_not_manifestly_unfounded, need_not_comply_unable_to_identify, must_comply_controller_able_to_identify, need_not_comply_legislative_restriction_attested, must_comply_legislative_restriction_attested_false, suspended_identity_not_confirmed, must_comply_identity_confirmed, indeterminate_identity_confirmed_absent, input_problems_duplicate_and_unknown, input_problems_wrong_boolean_value, must_comply_with_valid_boolean, a_well_formed_profile_has_no_input_problem, a_non_list_profile_is_a_wrong_type, a_non_list_profile_answers_input_problems, an_unread_key_does_not_change_the_answer, the_checklist_carries_a_cite_per_ground, every_erasure_fixture_has_a_non_empty_checklist, what_if_freedom_of_expression_relieves, refusal_is_permitted_when_relieved, refusal_is_forbidden_when_the_controller_must_comply, a_fee_is_permitted_for_a_manifestly_unfounded_request, a_fee_is_forbidden_under_another_relief, deferral_is_permitted_while_identity_is_unconfirmed, an_open_verdict_is_not_yet_determined, provenance_builds_from_a_clause_and_citations, attested_builds_from_a_value_and_an_attestation, attestation_builds_from_four_ground_parts, url_builds_from_an_address_and_a_time, document_builds_from_an_upload_and_a_hash]).
cp_test_fail_names([a_ruled_out_freedom_of_expression_does_not_relieve, freedom_of_expression_does_not_leave_a_duty, an_other_legal_ground_defeats_point_b, overriding_grounds_defeat_point_c, an_erasure_law_attested_false_does_not_engage, an_unattested_erasure_law_is_not_final, an_unsure_unlawfulness_is_not_must_comply, a_public_task_ruled_out_leaves_the_missing_keys, a_processing_obligation_attested_false_does_not_relieve, archiving_without_impairment_does_not_relieve, unsure_legal_claims_do_not_relieve, a_founded_request_does_not_relieve, an_identifying_controller_is_not_relieved, a_restriction_attested_false_does_not_relieve, a_confirmed_identity_does_not_suspend, an_unconfirmed_identity_is_not_must_comply, an_absent_identity_confirmation_is_not_suspended, a_valid_boolean_is_no_input_problem, a_wrong_boolean_is_not_must_comply, a_fee_is_not_permitted_under_another_relief, provenance_needs_a_citation_list, attested_needs_a_compound_attestation, attestation_needs_every_part, url_needs_an_address, document_needs_a_hash]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
