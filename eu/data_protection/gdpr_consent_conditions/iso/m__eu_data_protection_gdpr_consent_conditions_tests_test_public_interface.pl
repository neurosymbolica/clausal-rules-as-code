% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [decide_gdpr_consent_conditions/2, gdpr_consent_conditions_status/2, gdpr_consent_conditions_checklist/2, gdpr_consent_conditions_decision_resolvable/1, gdpr_consent_conditions_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_subject/1, gdpr_consent_conditions_profile_for/2, gdpr_consent_conditions_assess/2]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [consent_conditions_status/4, consent_declaration_effect/3, consent_assessment_factors/2, identification_obligation/4, identification_information_duty/4, identification_rights_effect/4]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_kernel, [gdpr_consent_conditions_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_queries, [gdpr_consent_conditions_what_if/4, gdpr_consent_conditions_eligibility/2, gdpr_consent_conditions_obligations/2, gdpr_consent_conditions_compliance/3]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_expected/3]).

query_answer(consent_conditions_status, Profile, Status) :-
    consent_conditions_status(Profile, Status, _, _).
query_answer(consent_declaration_effect, Profile, Status) :-
    consent_declaration_effect(Profile, Status, _).
query_answer(consent_assessment_factors, Profile, Factors) :-
    consent_assessment_factors(Profile, Factors).
query_answer(identification_obligation, Profile, Status) :-
    identification_obligation(Profile, Status, _, _).
query_answer(identification_information_duty, Profile, Status) :-
    identification_information_duty(Profile, Status, _, _).
query_answer(identification_rights_effect, Profile, Status) :-
    identification_rights_effect(Profile, Status, _, _).

query_names([consent_conditions_status, consent_declaration_effect, consent_assessment_factors, identification_obligation, identification_information_duty, identification_rights_effect]).

subject_answer(Subject, Answer) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    gdpr_consent_conditions_expected(Subject, Query, _),
    findall(Found, query_answer(Query, Profile, Found), Answers),
    Answers == [Answer].

subject_resolves_to_expected(Subject) :-
    gdpr_consent_conditions_expected(Subject, _, Expected),
    subject_answer(Subject, Expected).

subject_queries_yield_one_solution(Subject) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    query_names(Queries),
    maplist(query_yields_one_solution(Profile), Queries).

query_yields_one_solution(Profile, Query) :-
    findall(Found, query_answer(Query, Profile, Found), Answers),
    length(Answers, 1).

subject_checklist_is_not_empty(Subject) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    gdpr_consent_conditions_checklist(Profile, [_|_]).

subject_decision_is_resolvable(Subject) :-
    gdpr_consent_conditions_profile_for(Subject, Profile),
    gdpr_consent_conditions_decision_resolvable(Profile).

all_subjects(Subjects) :-
    findall(Subject, gdpr_consent_conditions_subject(Subject), Subjects).

cite_in_vocabulary(cite(Key)) :-
    member(Key, [eu_reg_2016_679_art_7_1, eu_reg_2016_679_art_7_2, eu_reg_2016_679_art_7_3, eu_reg_2016_679_art_7_4, eu_reg_2016_679_art_11_1, eu_reg_2016_679_art_11_2]).

yes_statement(attested(true, attestation(by, at, reason, none))).

no_statement(attested(false, attestation(by, at, reason, none))).

test(every_subject_has_an_expectation) :-
    all_subjects(Subjects),
    length(Subjects, 25),
    maplist(subject_resolves_to_expected, Subjects).
test(every_query_yields_exactly_one_solution_on_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_queries_yield_one_solution, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    all_subjects(Subjects),
    maplist(subject_checklist_is_not_empty, Subjects).
test(every_subject_decision_is_resolvable) :-
    all_subjects(Subjects),
    maplist(subject_decision_is_resolvable, Subjects).
test(all_conditions_met_is_conditions_met) :-
    subject_answer(consent_all_conditions_met, conditions_met).
test(demonstration_not_shown_is_conditions_not_met) :-
    subject_answer(consent_demonstration_not_shown, conditions_not_met).
test(demonstration_not_shown_cites_article_7_1_with_its_basis) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    no_statement(No),
    consent_conditions_status(Profile, conditions_not_met, [outside_fact(consent_demonstrable, No)], [cite(eu_reg_2016_679_art_7_1)]).
test(declaration_request_clear_is_conditions_met_citing_four_limbs) :-
    gdpr_consent_conditions_profile_for(consent_declaration_request_clear, Profile),
    consent_conditions_status(Profile, conditions_met, Basis, Citations),
    length(Basis, 4),
    Citations == [cite(eu_reg_2016_679_art_7_1), cite(eu_reg_2016_679_art_7_2), cite(eu_reg_2016_679_art_7_3), cite(eu_reg_2016_679_art_7_4)].
test(declaration_request_unclear_is_conditions_not_met) :-
    gdpr_consent_conditions_profile_for(consent_declaration_request_unclear, Profile),
    no_statement(No),
    consent_conditions_status(Profile, conditions_not_met, [outside_fact(request_clearly_distinguishable_and_intelligible, No)], [cite(eu_reg_2016_679_art_7_2)]).
test(withdrawal_not_informed_fails_article_7_3_with_empty_basis) :-
    gdpr_consent_conditions_profile_for(consent_withdrawal_not_informed, Profile),
    consent_conditions_status(Profile, conditions_not_met, [], [cite(eu_reg_2016_679_art_7_3)]).
test(withdrawal_harder_fails_article_7_3) :-
    gdpr_consent_conditions_profile_for(consent_withdrawal_harder_than_giving, Profile),
    no_statement(No),
    consent_conditions_status(Profile, conditions_not_met, [outside_fact(withdrawal_as_easy_as_giving_consent, No)], [cite(eu_reg_2016_679_art_7_3)]).
test(not_freely_given_fails_article_7_4) :-
    gdpr_consent_conditions_profile_for(consent_not_freely_given, Profile),
    no_statement(No),
    consent_conditions_status(Profile, conditions_not_met, [outside_fact(consent_freely_given, No)], [cite(eu_reg_2016_679_art_7_4)]).
test(processing_not_based_on_consent_is_not_applicable) :-
    subject_answer(processing_not_based_on_consent, not_applicable).
test(absent_scope_is_indeterminate) :-
    subject_answer(consent_scope_absent, indeterminate([processing_based_on_consent])).
test(both_absent_crisp_keys_are_named) :-
    subject_answer(consent_crisp_keys_absent, indeterminate([consent_in_declaration_with_other_matters, informed_of_withdrawal_right_before_consent])).
test(an_absent_demonstration_statement_refers) :-
    subject_answer(consent_demonstration_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_7_1), cite(consent_demonstration_statement)), [resolution(cite(consent_demonstration_statement), not_attempted), inputs_relied_on([consent_demonstrable - absent])])).
test(a_referral_has_empty_basis_and_citations) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_statement_absent, Profile),
    consent_conditions_status(Profile, needs_legal_review(_, _), [], []).
test(an_unknown_key_gives_input_problems) :-
    subject_answer(consent_unknown_key_profile, input_problems([unknown_key(colour)])).
test(a_provenance_item_may_follow_the_referral_context) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_statement_absent, Profile),
    consent_conditions_status(Profile, needs_legal_review(_, Context), [], []),
    append(Context, [provenance(consent_demonstration_clause, [cite(eu_reg_2016_679_art_7_1)])], Extended),
    Extended = [resolution(cite(consent_demonstration_statement), not_attempted), inputs_relied_on([consent_demonstrable - absent]), provenance(Clause, Citations)],
    Clause == consent_demonstration_clause,
    Citations == [cite(eu_reg_2016_679_art_7_1)].
test(the_referral_context_holds_two_items) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_statement_absent, Profile),
    consent_conditions_status(Profile, needs_legal_review(_, Context), [], []),
    length(Context, 2).
test(a_duplicated_key_is_a_duplicate_key_problem) :-
    gdpr_consent_conditions_input_problems([attribute(processing_based_on_consent, true), attribute(processing_based_on_consent, true)], Problems),
    Problems == [duplicate_key(processing_based_on_consent)].
test(a_duplicated_key_with_a_bad_value_is_never_also_wrong_type) :-
    gdpr_consent_conditions_input_problems([attribute(consent_demonstrable, true), attribute(consent_demonstrable, unsure)], Problems),
    Problems == [duplicate_key(consent_demonstrable)].
test(a_duplicated_key_gives_input_problems_in_every_query) :-
    Profile = [attribute(additional_identifying_information_provided, true), attribute(additional_identifying_information_provided, false)],
    consent_conditions_status(Profile, input_problems([duplicate_key(additional_identifying_information_provided)]), [], []),
    consent_declaration_effect(Profile, input_problems([duplicate_key(additional_identifying_information_provided)]), []),
    consent_assessment_factors(Profile, input_problems([duplicate_key(additional_identifying_information_provided)])),
    identification_obligation(Profile, input_problems([duplicate_key(additional_identifying_information_provided)]), [], []),
    identification_information_duty(Profile, input_problems([duplicate_key(additional_identifying_information_provided)]), [], []),
    identification_rights_effect(Profile, input_problems([duplicate_key(additional_identifying_information_provided)]), [], []).
test(url_evidence_is_accepted_and_copied_into_the_basis) :-
    Attested = attested(true, attestation(host_reviewer, host_moment, purposes_reviewed, url(record_location, retrieval_moment))),
    gdpr_consent_conditions_input_problems([attribute(purposes_do_not_require_identification, Attested)], []),
    identification_obligation([attribute(purposes_do_not_require_identification, Attested)], not_obliged_to_acquire_identifying_information, Basis, [cite(eu_reg_2016_679_art_11_1)]),
    Basis == [outside_fact(purposes_do_not_require_identification, attested(true, attestation(host_reviewer, host_moment, purposes_reviewed, url(record_location, retrieval_moment))))].
test(url_evidence_attested_false_is_not_engaged) :-
    identification_obligation([attribute(purposes_do_not_require_identification, attested(false, attestation(host_reviewer, host_moment, purposes_reviewed, url(record_location, retrieval_moment))))], art11_1_not_engaged, [outside_fact(purposes_do_not_require_identification, attested(false, attestation(host_reviewer, host_moment, purposes_reviewed, url(record_location, retrieval_moment))))], [cite(eu_reg_2016_679_art_11_1)]).
test(document_evidence_is_accepted_and_copied_into_the_basis) :-
    Attested = attested(true, attestation(host_reviewer, host_moment, informing_reviewed, document(upload_identifier_one, checksum_value))),
    yes_statement(Yes),
    Profile = [attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(informing_data_subject_possible, Attested)],
    gdpr_consent_conditions_input_problems(Profile, []),
    identification_information_duty(Profile, must_inform_data_subject, Basis, [cite(eu_reg_2016_679_art_11_2)]),
    Basis == [outside_fact(purposes_do_not_require_identification, Yes), outside_fact(able_to_demonstrate_not_in_position_to_identify, Yes), outside_fact(informing_data_subject_possible, attested(true, attestation(host_reviewer, host_moment, informing_reviewed, document(upload_identifier_one, checksum_value))))].
test(document_evidence_attested_false_need_not_inform) :-
    yes_statement(Yes),
    identification_information_duty([attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(informing_data_subject_possible, attested(false, attestation(host_reviewer, host_moment, informing_reviewed, document(upload_identifier_one, checksum_value))))], need_not_inform_data_subject, _, [cite(eu_reg_2016_679_art_11_2)]).
test(an_infringing_part_is_not_binding) :-
    gdpr_consent_conditions_profile_for(declaration_part_infringing, Profile),
    consent_declaration_effect(Profile, part_not_binding, [cite(eu_reg_2016_679_art_7_2)]).
test(no_infringing_part_is_no_part_infringing) :-
    subject_answer(declaration_no_part_infringing, no_part_infringing).
test(no_declaration_with_other_matters_is_not_applicable) :-
    subject_answer(declaration_without_other_matters, not_applicable).
test(the_factor_is_reported) :-
    subject_answer(contract_conditional_on_unneeded_consent_factor, [factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))]).
test(a_false_factor_reports_nothing) :-
    subject_answer(contract_not_conditional_on_unneeded_consent, []).
test(identification_not_required_relieves_the_obligation) :-
    gdpr_consent_conditions_profile_for(identification_not_required, Profile),
    yes_statement(Yes),
    identification_obligation(Profile, not_obliged_to_acquire_identifying_information, [outside_fact(purposes_do_not_require_identification, Yes)], [cite(eu_reg_2016_679_art_11_1)]).
test(identification_required_is_not_engaged) :-
    subject_answer(identification_required, art11_1_not_engaged).
test(informing_possible_must_inform) :-
    subject_answer(informing_data_subject_is_possible, must_inform_data_subject).
test(informing_possible_basis_holds_three_facts) :-
    gdpr_consent_conditions_profile_for(informing_data_subject_is_possible, Profile),
    identification_information_duty(Profile, must_inform_data_subject, Basis, [cite(eu_reg_2016_679_art_11_2)]),
    length(Basis, 3).
test(informing_impossible_need_not_inform) :-
    subject_answer(informing_data_subject_is_impossible, need_not_inform_data_subject).
test(inability_not_demonstrated_is_not_engaged) :-
    gdpr_consent_conditions_profile_for(inability_to_identify_not_demonstrated, Profile),
    no_statement(No),
    identification_information_duty(Profile, art11_2_not_engaged, [outside_fact(able_to_demonstrate_not_in_position_to_identify, No)], [cite(eu_reg_2016_679_art_11_2)]).
test(identifying_information_provided_restores_articles_15_to_20) :-
    subject_answer(identifying_information_provided, articles_15_to_20_apply).
test(no_identifying_information_disapplies_articles_15_to_20) :-
    subject_answer(identifying_information_not_provided, articles_15_to_20_do_not_apply).
test(the_missing_crisp_key_is_named_before_the_referral) :-
    subject_answer(rights_engagement_open_information_key_absent, indeterminate([additional_identifying_information_provided])).
test(the_information_duty_refers_on_the_absent_purposes_statement) :-
    gdpr_consent_conditions_profile_for(rights_engagement_open_information_key_absent, Profile),
    identification_information_duty(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_11_1), cite(identification_not_required_statement)), [resolution(cite(identification_not_required_statement), not_attempted), inputs_relied_on([purposes_do_not_require_identification - absent])]), [], []).
test(the_facade_verdict_carries_cited_status) :-
    gdpr_consent_conditions_assess(consent_all_conditions_met, gdpr_consent_conditions_verdict(conditions_met, Citations)),
    Citations = [_|_],
    maplist(cite_in_vocabulary, Citations).
test(the_facade_near_miss_verdict_is_conditions_not_met) :-
    gdpr_consent_conditions_assess(consent_demonstration_not_shown, gdpr_consent_conditions_verdict(conditions_not_met, [cite(eu_reg_2016_679_art_7_1)])).
test(the_facade_status_projects_the_verdict) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    decide_gdpr_consent_conditions(Profile, gdpr_consent_conditions_verdict(conditions_met, _)),
    gdpr_consent_conditions_status(Profile, conditions_met),
    gdpr_consent_conditions_status_values(StatusValues),
    member(conditions_met, StatusValues).
test(the_checklist_of_a_met_subject_is_cited) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    gdpr_consent_conditions_checklist(Profile, Items),
    Items == [item(scope, met, cite(eu_reg_2016_679_art_7_1)), item(demonstration, met, cite(eu_reg_2016_679_art_7_1)), item(request_presentation, inapplicable, cite(eu_reg_2016_679_art_7_2)), item(withdrawal, met, cite(eu_reg_2016_679_art_7_3)), item(freely_given, met, cite(eu_reg_2016_679_art_7_4))].
test(the_input_check_reports_an_unknown_key) :-
    gdpr_consent_conditions_profile_for(consent_unknown_key_profile, Profile),
    gdpr_consent_conditions_input_problems(Profile, [unknown_key(colour)]).
test(the_input_check_passes_a_fixture) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    gdpr_consent_conditions_input_problems(Profile, []).
test(eligibility_of_met_conditions_is_eligible) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    gdpr_consent_conditions_eligibility(Profile, assessment(consent, eligible, [_|_])).
test(eligibility_of_a_near_miss_is_ineligible) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    gdpr_consent_conditions_eligibility(Profile, assessment(consent, ineligible, [_|_])).
test(eligibility_with_absent_keys_is_undecided) :-
    gdpr_consent_conditions_profile_for(consent_crisp_keys_absent, Profile),
    gdpr_consent_conditions_eligibility(Profile, assessment(consent, undecided, [_|_])).
test(eligibility_yields_one_solution) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    findall(Assessment, gdpr_consent_conditions_eligibility(Profile, Assessment), Assessments),
    length(Assessments, 1).
test(obligations_of_consent_without_declaration) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    gdpr_consent_conditions_obligations(Profile, Obligations),
    Obligations == [obligation(demonstrate_consent, cite(eu_reg_2016_679_art_7_1)), obligation(inform_of_withdrawal_right_before_consent, cite(eu_reg_2016_679_art_7_3)), obligation(make_withdrawal_as_easy_as_giving_consent, cite(eu_reg_2016_679_art_7_3))].
test(obligations_of_consent_in_a_declaration_add_article_7_2) :-
    gdpr_consent_conditions_profile_for(consent_declaration_request_clear, Profile),
    gdpr_consent_conditions_obligations(Profile, Obligations),
    member(obligation(present_consent_request_distinguishably, cite(eu_reg_2016_679_art_7_2)), Obligations),
    length(Obligations, 4).
test(obligation_to_inform_when_possible) :-
    gdpr_consent_conditions_profile_for(informing_data_subject_is_possible, Profile),
    gdpr_consent_conditions_obligations(Profile, [obligation(inform_data_subject_not_in_position_to_identify, cite(eu_reg_2016_679_art_11_2))]).
test(no_obligation_to_inform_when_impossible) :-
    gdpr_consent_conditions_profile_for(informing_data_subject_is_impossible, Profile),
    gdpr_consent_conditions_obligations(Profile, []).
test(obligations_report_input_problems) :-
    gdpr_consent_conditions_profile_for(consent_unknown_key_profile, Profile),
    gdpr_consent_conditions_obligations(Profile, input_problems([unknown_key(colour)])).
test(relying_on_met_consent_is_compliant) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, compliant).
test(relying_on_unmet_consent_is_non_compliant) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, non_compliant).
test(relying_with_absent_keys_is_undecided) :-
    gdpr_consent_conditions_profile_for(consent_crisp_keys_absent, Profile),
    gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, undecided).
test(enforcing_an_infringing_part_is_non_compliant) :-
    gdpr_consent_conditions_profile_for(declaration_part_infringing, Profile),
    gdpr_consent_conditions_compliance(Profile, enforce_infringing_declaration_part, non_compliant).
test(enforcing_without_an_infringing_part_is_compliant) :-
    gdpr_consent_conditions_profile_for(declaration_no_part_infringing, Profile),
    gdpr_consent_conditions_compliance(Profile, enforce_infringing_declaration_part, compliant).
test(declining_when_articles_15_to_20_do_not_apply_is_compliant) :-
    gdpr_consent_conditions_profile_for(identifying_information_not_provided, Profile),
    gdpr_consent_conditions_compliance(Profile, decline_request_under_articles_15_to_20, compliant).
test(declining_when_articles_15_to_20_apply_is_non_compliant) :-
    gdpr_consent_conditions_profile_for(identifying_information_provided, Profile),
    gdpr_consent_conditions_compliance(Profile, decline_request_under_articles_15_to_20, non_compliant).
test(compliance_yields_one_solution) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    findall(Verdict, gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, Verdict), Verdicts),
    Verdicts == [compliant].
test(what_if_consent_not_freely_given_flips_the_status) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    no_statement(No),
    gdpr_consent_conditions_what_if(Profile, consent_freely_given, No, conditions_not_met).
test(what_if_the_near_miss_is_repaired_flips_back) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    yes_statement(Yes),
    gdpr_consent_conditions_what_if(Profile, consent_demonstrable, Yes, conditions_met).
test(what_if_yields_one_solution) :-
    gdpr_consent_conditions_profile_for(consent_all_conditions_met, Profile),
    findall(Status, gdpr_consent_conditions_what_if(Profile, processing_based_on_consent, false, Status), Statuses),
    Statuses == [not_applicable].

test(all_conditions_met_is_not_conditions_not_met, fail) :-
    subject_answer(consent_all_conditions_met, conditions_not_met).
test(demonstration_not_shown_is_not_conditions_met, fail) :-
    subject_answer(consent_demonstration_not_shown, conditions_met).
test(declaration_request_unclear_is_not_conditions_met, fail) :-
    subject_answer(consent_declaration_request_unclear, conditions_met).
test(withdrawal_not_informed_is_not_conditions_met, fail) :-
    subject_answer(consent_withdrawal_not_informed, conditions_met).
test(withdrawal_harder_is_not_conditions_met, fail) :-
    subject_answer(consent_withdrawal_harder_than_giving, conditions_met).
test(not_freely_given_is_not_conditions_met, fail) :-
    subject_answer(consent_not_freely_given, conditions_met).
test(processing_not_based_on_consent_is_not_conditions_met, fail) :-
    subject_answer(processing_not_based_on_consent, conditions_met).
test(absent_crisp_keys_are_not_conditions_met, fail) :-
    subject_answer(consent_crisp_keys_absent, conditions_met).
test(an_unknown_key_is_not_conditions_met, fail) :-
    subject_answer(consent_unknown_key_profile, conditions_met).
test(the_referral_context_holds_no_provenance_item, fail) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_statement_absent, Profile),
    consent_conditions_status(Profile, needs_legal_review(_, Context), [], []),
    member(provenance(_, _), Context).
test(a_duplicated_key_is_not_wrong_type, fail) :-
    gdpr_consent_conditions_input_problems([attribute(consent_demonstrable, true), attribute(consent_demonstrable, unsure)], [wrong_type(consent_demonstrable)]).
test(url_evidence_attested_false_is_not_relieved, fail) :-
    identification_obligation([attribute(purposes_do_not_require_identification, attested(false, attestation(host_reviewer, host_moment, purposes_reviewed, url(record_location, retrieval_moment))))], not_obliged_to_acquire_identifying_information, _, _).
test(document_evidence_attested_false_is_not_must_inform, fail) :-
    yes_statement(Yes),
    identification_information_duty([attribute(purposes_do_not_require_identification, Yes), attribute(able_to_demonstrate_not_in_position_to_identify, Yes), attribute(informing_data_subject_possible, attested(false, attestation(host_reviewer, host_moment, informing_reviewed, document(upload_identifier_one, checksum_value))))], must_inform_data_subject, _, _).
test(an_infringing_part_is_not_no_part_infringing, fail) :-
    subject_answer(declaration_part_infringing, no_part_infringing).
test(no_infringing_part_is_not_part_not_binding, fail) :-
    subject_answer(declaration_no_part_infringing, part_not_binding).
test(no_declaration_with_other_matters_is_not_part_not_binding, fail) :-
    subject_answer(declaration_without_other_matters, part_not_binding).
test(a_false_factor_does_not_report_the_factor, fail) :-
    subject_answer(contract_not_conditional_on_unneeded_consent, [factor(_, _)]).
test(identification_required_is_not_relieved, fail) :-
    subject_answer(identification_required, not_obliged_to_acquire_identifying_information).
test(informing_impossible_is_not_must_inform, fail) :-
    subject_answer(informing_data_subject_is_impossible, must_inform_data_subject).
test(inability_not_demonstrated_is_not_must_inform, fail) :-
    subject_answer(inability_to_identify_not_demonstrated, must_inform_data_subject).
test(identifying_information_provided_is_not_disapplied, fail) :-
    subject_answer(identifying_information_provided, articles_15_to_20_do_not_apply).
test(no_identifying_information_is_not_applying, fail) :-
    subject_answer(identifying_information_not_provided, articles_15_to_20_apply).
test(eligibility_of_a_near_miss_is_not_eligible, fail) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    gdpr_consent_conditions_eligibility(Profile, assessment(consent, eligible, _)).
test(relying_on_unmet_consent_is_not_compliant, fail) :-
    gdpr_consent_conditions_profile_for(consent_demonstration_not_shown, Profile),
    gdpr_consent_conditions_compliance(Profile, rely_on_consent_for_processing, compliant).

cp_test_names([every_subject_has_an_expectation, every_query_yields_exactly_one_solution_on_every_subject, every_subject_has_a_non_empty_checklist, every_subject_decision_is_resolvable, all_conditions_met_is_conditions_met, demonstration_not_shown_is_conditions_not_met, demonstration_not_shown_cites_article_7_1_with_its_basis, declaration_request_clear_is_conditions_met_citing_four_limbs, declaration_request_unclear_is_conditions_not_met, withdrawal_not_informed_fails_article_7_3_with_empty_basis, withdrawal_harder_fails_article_7_3, not_freely_given_fails_article_7_4, processing_not_based_on_consent_is_not_applicable, absent_scope_is_indeterminate, both_absent_crisp_keys_are_named, an_absent_demonstration_statement_refers, a_referral_has_empty_basis_and_citations, an_unknown_key_gives_input_problems, a_provenance_item_may_follow_the_referral_context, the_referral_context_holds_two_items, a_duplicated_key_is_a_duplicate_key_problem, a_duplicated_key_with_a_bad_value_is_never_also_wrong_type, a_duplicated_key_gives_input_problems_in_every_query, url_evidence_is_accepted_and_copied_into_the_basis, url_evidence_attested_false_is_not_engaged, document_evidence_is_accepted_and_copied_into_the_basis, document_evidence_attested_false_need_not_inform, an_infringing_part_is_not_binding, no_infringing_part_is_no_part_infringing, no_declaration_with_other_matters_is_not_applicable, the_factor_is_reported, a_false_factor_reports_nothing, identification_not_required_relieves_the_obligation, identification_required_is_not_engaged, informing_possible_must_inform, informing_possible_basis_holds_three_facts, informing_impossible_need_not_inform, inability_not_demonstrated_is_not_engaged, identifying_information_provided_restores_articles_15_to_20, no_identifying_information_disapplies_articles_15_to_20, the_missing_crisp_key_is_named_before_the_referral, the_information_duty_refers_on_the_absent_purposes_statement, the_facade_verdict_carries_cited_status, the_facade_near_miss_verdict_is_conditions_not_met, the_facade_status_projects_the_verdict, the_checklist_of_a_met_subject_is_cited, the_input_check_reports_an_unknown_key, the_input_check_passes_a_fixture, eligibility_of_met_conditions_is_eligible, eligibility_of_a_near_miss_is_ineligible, eligibility_with_absent_keys_is_undecided, eligibility_yields_one_solution, obligations_of_consent_without_declaration, obligations_of_consent_in_a_declaration_add_article_7_2, obligation_to_inform_when_possible, no_obligation_to_inform_when_impossible, obligations_report_input_problems, relying_on_met_consent_is_compliant, relying_on_unmet_consent_is_non_compliant, relying_with_absent_keys_is_undecided, enforcing_an_infringing_part_is_non_compliant, enforcing_without_an_infringing_part_is_compliant, declining_when_articles_15_to_20_do_not_apply_is_compliant, declining_when_articles_15_to_20_apply_is_non_compliant, compliance_yields_one_solution, what_if_consent_not_freely_given_flips_the_status, what_if_the_near_miss_is_repaired_flips_back, what_if_yields_one_solution]).
cp_test_fail_names([all_conditions_met_is_not_conditions_not_met, demonstration_not_shown_is_not_conditions_met, declaration_request_unclear_is_not_conditions_met, withdrawal_not_informed_is_not_conditions_met, withdrawal_harder_is_not_conditions_met, not_freely_given_is_not_conditions_met, processing_not_based_on_consent_is_not_conditions_met, absent_crisp_keys_are_not_conditions_met, an_unknown_key_is_not_conditions_met, the_referral_context_holds_no_provenance_item, a_duplicated_key_is_not_wrong_type, url_evidence_attested_false_is_not_relieved, document_evidence_attested_false_is_not_must_inform, an_infringing_part_is_not_no_part_infringing, no_infringing_part_is_not_part_not_binding, no_declaration_with_other_matters_is_not_part_not_binding, a_false_factor_does_not_report_the_factor, identification_required_is_not_relieved, informing_impossible_is_not_must_inform, inability_not_demonstrated_is_not_must_inform, identifying_information_provided_is_not_disapplied, no_identifying_information_is_not_applying, eligibility_of_a_near_miss_is_not_eligible, relying_on_unmet_consent_is_not_compliant]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
