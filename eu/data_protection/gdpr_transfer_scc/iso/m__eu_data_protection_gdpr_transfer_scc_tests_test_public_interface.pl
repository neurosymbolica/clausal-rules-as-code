% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_scc_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_gdpr_transfer_scc, [decide_gdpr_transfer_scc/2, gdpr_transfer_scc_status/2, gdpr_transfer_scc_checklist/2, gdpr_transfer_scc_decision_resolvable/1, gdpr_transfer_scc_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_fixtures, [gdpr_transfer_scc_subject/1, gdpr_transfer_scc_profile_for/2, gdpr_transfer_scc_assess/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_gdpr_transfer_scc, [standard_contractual_clauses_module/3, standard_contractual_clauses_availability/4, standard_contractual_clauses_safeguard/4, standard_contractual_clauses_appendix/3]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_kernel, [gdpr_transfer_scc_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_queries, [gdpr_transfer_scc_profile_keys/1, gdpr_transfer_scc_what_if/4, gdpr_transfer_scc_reliance_check/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_fixtures, [gdpr_transfer_scc_expected/2, gdpr_transfer_scc_near_miss/2]).

verdict_of(Subject, Status) :-
    gdpr_transfer_scc_assess(Subject, gdpr_transfer_scc_verdict(Status, _Citations)).

single_verdict(Subject, Status) :-
    findall(Found, verdict_of(Subject, Found), Statuses),
    Statuses == [Status].

subject_profile(Subject, Profile) :-
    gdpr_transfer_scc_profile_for(Subject, Profile).

test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject - Status, (gdpr_transfer_scc_subject(Subject), verdict_of(Subject, Status)), Answers),
    findall(Subject - Expected, (gdpr_transfer_scc_subject(Subject), gdpr_transfer_scc_expected(Subject, Expected)), ExpectedAnswers),
    Answers == ExpectedAnswers.
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, (gdpr_transfer_scc_subject(Subject), subject_profile(Subject, Profile), gdpr_transfer_scc_checklist(Profile, [_FirstItem|_OtherItems])), WithChecklist),
    findall(Subject, gdpr_transfer_scc_subject(Subject), AllSubjects),
    WithChecklist == AllSubjects.
test(every_subject_is_resolvable_once) :-
    findall(Subject, (gdpr_transfer_scc_subject(Subject), subject_profile(Subject, Profile), gdpr_transfer_scc_decision_resolvable(Profile)), Resolvable),
    findall(Subject, gdpr_transfer_scc_subject(Subject), AllSubjects),
    Resolvable == AllSubjects.
test(every_near_miss_control_gets_a_different_verdict) :-
    findall(Positive - Control, gdpr_transfer_scc_near_miss(Positive, Control), Pairs),
    length(Pairs, 10),
    findall(Positive - Control, (gdpr_transfer_scc_near_miss(Positive, Control), verdict_of(Positive, PositiveStatus), verdict_of(Control, ControlStatus), dif(PositiveStatus, ControlStatus)), DifferingPairs),
    DifferingPairs == Pairs.
test(final_verdicts_belong_to_the_status_vocabulary) :-
    gdpr_transfer_scc_status_values(StatusValues),
    verdict_of(module_two_all_met, ProvidedStatus),
    member(ProvidedStatus, StatusValues),
    verdict_of(module_two_documentation_missing, NotProvidedStatus),
    member(NotProvidedStatus, StatusValues).
test(module_two_all_met_provides_safeguards) :-
    single_verdict(module_two_all_met, appropriate_safeguards_provided).
test(module_two_all_met_carries_thirteen_citations) :-
    gdpr_transfer_scc_assess(module_two_all_met, gdpr_transfer_scc_verdict(appropriate_safeguards_provided, Citations)),
    length(Citations, 13),
    member(cite(eu_reg_2016_679_art_46_2_c), Citations),
    member(cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_d), Citations).
test(module_two_documentation_missing_does_not_provide) :-
    single_verdict(module_two_documentation_missing, appropriate_safeguards_not_provided).
test(importer_subject_to_gdpr_does_not_provide) :-
    single_verdict(importer_subject_to_gdpr, appropriate_safeguards_not_provided).
test(decision_attested_false_does_not_provide) :-
    single_verdict(decision_in_force_attested_false, appropriate_safeguards_not_provided).
test(decision_absent_is_referred_as_unresolved_cross_reference) :-
    single_verdict(decision_in_force_absent, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2021_914_art_1), cite(standard_contractual_clauses_decision_in_force_statement)), [resolution(cite(standard_contractual_clauses_decision_in_force_statement), not_attempted), inputs_relied_on([standard_contractual_clauses_decision_in_force - absent])])).
test(decision_absent_referral_has_no_basis_or_citations) :-
    subject_profile(decision_in_force_absent, Profile),
    standard_contractual_clauses_safeguard(Profile, needs_legal_review(_Reason, _Context), [], []).
test(wrong_module_selected_does_not_provide) :-
    single_verdict(module_selected_wrong, appropriate_safeguards_not_provided).
test(absent_module_selected_is_named_alone) :-
    single_verdict(module_selected_absent, indeterminate([module_selected])).
test(unsure_decisive_added_clauses_go_to_a_lawyer) :-
    single_verdict(added_clauses_unsure_decisive, needs_legal_review(open_textured(added_clauses_contradict_clauses, cite(eu_dec_2021_914_annex_cl_2_a)), [inputs_relied_on([added_clauses_contradict_clauses - unsure])])).
test(unsure_added_clauses_settled_by_modification) :-
    single_verdict(added_clauses_unsure_settled_elsewhere, appropriate_safeguards_not_provided).
test(bare_boolean_outside_fact_is_an_input_problem) :-
    single_verdict(bare_boolean_outside_fact, input_problems([wrong_type(standard_contractual_clauses_decision_in_force)])).
test(appendix_subjects_keep_the_safeguard) :-
    single_verdict(module_two_list_of_parties_incomplete, appropriate_safeguards_provided),
    single_verdict(annex_ii_unsure, appropriate_safeguards_provided),
    single_verdict(module_three_specific_authorisation_without_sub_processor_list, appropriate_safeguards_provided),
    single_verdict(module_three_general_authorisation_without_sub_processor_list, appropriate_safeguards_provided).
test(module_four_without_combination_provides_without_clause_14) :-
    single_verdict(module_four_no_combination, appropriate_safeguards_provided),
    subject_profile(module_four_no_combination, Profile),
    standard_contractual_clauses_safeguard(Profile, appropriate_safeguards_provided, Basis, _Citations),
    length(Basis, 3).
test(module_four_with_combination_undocumented_does_not_provide) :-
    single_verdict(module_four_with_combination_undocumented, appropriate_safeguards_not_provided).
test(duplicate_and_unknown_keys_are_input_problems) :-
    single_verdict(duplicate_and_unknown_keys, input_problems([duplicate_key(exporter_role), unknown_key(colour)])).
test(unbound_profile_is_an_input_problem) :-
    single_verdict(unbound_profile, input_problems([wrong_type(profile)])).
test(good_profile_safeguard_basis_holds_four_outside_facts_in_order) :-
    subject_profile(module_two_all_met, Profile),
    standard_contractual_clauses_safeguard(Profile, appropriate_safeguards_provided, Basis, _Citations),
    Basis = [outside_fact(standard_contractual_clauses_decision_in_force, _), outside_fact(exporter_processing_subject_to_gdpr, _), outside_fact(importer_processing_subject_to_gdpr, _), outside_fact(no_reason_to_believe_local_laws_prevent_compliance, _)].
test(controller_to_processor_is_module_two_once) :-
    subject_profile(module_two_all_met, Profile),
    findall(Result - Citations, standard_contractual_clauses_module(Profile, Result, Citations), Answers),
    Answers == [module_two - [cite(eu_dec_2021_914_art_1), cite(eu_dec_2021_914_annex_i)]].
test(processor_to_processor_is_module_three) :-
    subject_profile(module_three_general_authorisation_without_sub_processor_list, Profile),
    standard_contractual_clauses_module(Profile, module_three, _Citations).
test(processor_to_controller_is_module_four) :-
    subject_profile(module_four_no_combination, Profile),
    standard_contractual_clauses_module(Profile, module_four, _Citations).
test(controller_to_controller_is_module_one) :-
    standard_contractual_clauses_module([attribute(exporter_role, controller), attribute(importer_role, controller)], module_one, _Citations).
test(missing_importer_role_is_named) :-
    standard_contractual_clauses_module([attribute(exporter_role, controller)], indeterminate([importer_role]), []).
test(good_facts_make_the_clauses_available_once) :-
    subject_profile(module_two_all_met, Profile),
    findall(Result, standard_contractual_clauses_availability(Profile, Result, _Basis, _Citations), Results),
    Results == [clauses_available].
test(available_basis_holds_three_outside_facts) :-
    subject_profile(module_two_all_met, Profile),
    standard_contractual_clauses_availability(Profile, clauses_available, Basis, [cite(eu_dec_2021_914_art_1)]),
    Basis = [outside_fact(standard_contractual_clauses_decision_in_force, attested(true, _)), outside_fact(exporter_processing_subject_to_gdpr, attested(true, _)), outside_fact(importer_processing_subject_to_gdpr, attested(false, _))].
test(importer_subject_makes_the_clauses_not_available) :-
    subject_profile(importer_subject_to_gdpr, Profile),
    standard_contractual_clauses_availability(Profile, clauses_not_available, _Basis, [cite(eu_dec_2021_914_art_1)]).
test(decision_absent_availability_is_referred) :-
    subject_profile(decision_in_force_absent, Profile),
    standard_contractual_clauses_availability(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2021_914_art_1), cite(standard_contractual_clauses_decision_in_force_statement)), [resolution(cite(standard_contractual_clauses_decision_in_force_statement), not_attempted), inputs_relied_on([standard_contractual_clauses_decision_in_force - absent])]), [], []).
test(url_evidence_is_accepted_by_the_input_check) :-
    Attested = attested(true, attestation(host_service, received_at, reason, url(source_address, retrieved_at))),
    findall(Problems, gdpr_transfer_scc_input_problems([attribute(standard_contractual_clauses_decision_in_force, Attested)], Problems), Answers),
    Answers == [[]].
test(url_evidence_is_copied_into_the_basis_as_supplied) :-
    Attested = attested(true, attestation(host_service, received_at, reason, url(source_address, retrieved_at))),
    findall(Result - Basis, standard_contractual_clauses_availability([attribute(importer_processing_subject_to_gdpr, Attested)], Result, Basis, _Citations), Answers),
    Answers == [clauses_not_available - [outside_fact(importer_processing_subject_to_gdpr, attested(true, attestation(host_service, received_at, reason, url(source_address, retrieved_at))))]].
test(url_evidence_with_an_unbound_argument_is_wrong_type) :-
    findall(Problems, gdpr_transfer_scc_input_problems([attribute(standard_contractual_clauses_decision_in_force, attested(true, attestation(host_service, received_at, reason, url(_UnboundAddress, retrieved_at))))], Problems), Answers),
    Answers == [[wrong_type(standard_contractual_clauses_decision_in_force)]].
test(document_evidence_is_accepted_by_the_input_check) :-
    Attested = attested(false, attestation(host_service, received_at, reason, document(upload_identifier, sha_digest))),
    findall(Problems, gdpr_transfer_scc_input_problems([attribute(importer_processing_subject_to_gdpr, Attested)], Problems), Answers),
    Answers == [[]].
test(document_evidence_is_copied_into_the_basis_as_supplied) :-
    Attested = attested(false, attestation(host_service, received_at, reason, document(upload_identifier, sha_digest))),
    findall(Result - Basis, standard_contractual_clauses_availability([attribute(standard_contractual_clauses_decision_in_force, Attested)], Result, Basis, _Citations), Answers),
    Answers == [clauses_not_available - [outside_fact(standard_contractual_clauses_decision_in_force, attested(false, attestation(host_service, received_at, reason, document(upload_identifier, sha_digest))))]].
test(document_evidence_with_an_unbound_argument_is_wrong_type) :-
    findall(Problems, gdpr_transfer_scc_input_problems([attribute(exporter_processing_subject_to_gdpr, attested(true, attestation(host_service, received_at, reason, document(upload_identifier, _UnboundDigest))))], Problems), Answers),
    Answers == [[wrong_type(exporter_processing_subject_to_gdpr)]].
test(module_two_all_met_appendix_is_complete_once) :-
    subject_profile(module_two_all_met, Profile),
    findall(Result, standard_contractual_clauses_appendix(Profile, Result, _Citations), Results),
    Results == [appendix_complete].
test(module_two_appendix_carries_eight_citations) :-
    subject_profile(module_two_all_met, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, Citations),
    length(Citations, 8).
test(incomplete_list_of_parties_makes_appendix_incomplete) :-
    subject_profile(module_two_list_of_parties_incomplete, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_incomplete, _Citations).
test(option_one_without_annex_iii_is_incomplete) :-
    subject_profile(module_three_specific_authorisation_without_sub_processor_list, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_incomplete, _Citations).
test(option_two_without_annex_iii_is_complete) :-
    subject_profile(module_three_general_authorisation_without_sub_processor_list, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, _Citations).
test(module_four_appendix_needs_only_annex_i_a_and_b) :-
    subject_profile(module_four_no_combination, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, _Citations).
test(unsure_annex_ii_goes_to_a_lawyer) :-
    subject_profile(annex_ii_unsure, Profile),
    findall(Result, standard_contractual_clauses_appendix(Profile, Result, _Citations), Results),
    Results == [needs_legal_review(open_textured(annex_ii_measures_described_in_specific_terms, cite(eu_dec_2021_914_annex_ii)), [inputs_relied_on([annex_ii_measures_described_in_specific_terms - unsure])])].
test(well_formed_fixture_has_no_input_problems) :-
    subject_profile(module_two_all_met, Profile),
    findall(Problems, gdpr_transfer_scc_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(duplicate_and_unknown_keys_are_listed_in_order) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    gdpr_transfer_scc_input_problems(Profile, [duplicate_key(exporter_role), unknown_key(colour)]).
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, gdpr_transfer_scc_input_problems(_UnboundProfile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_empty_profile_has_no_problems) :-
    gdpr_transfer_scc_input_problems([], []).
test(all_met_checklist_has_nine_cited_met_items) :-
    subject_profile(module_two_all_met, Profile),
    gdpr_transfer_scc_checklist(Profile, Items),
    length(Items, 9),
    findall(Identifier, member(item(Identifier, met, cite(_Key)), Items), MetIdentifiers),
    length(MetIdentifiers, 9).
test(undocumented_assessment_is_an_unmet_cited_item) :-
    subject_profile(module_two_documentation_missing, Profile),
    gdpr_transfer_scc_checklist(Profile, Items),
    member(item(clause_14_assessment_documented, unmet(local_laws_assessment_documented), cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_d)), Items).
test(module_four_without_combination_marks_clause_14_inapplicable) :-
    subject_profile(module_four_no_combination, Profile),
    gdpr_transfer_scc_checklist(Profile, Items),
    member(item(clause_14_warranty_given, inapplicable, cite(eu_dec_2021_914_annex_cl_14_m1m2m3m4_a)), Items).
test(all_met_may_rely_on_clauses) :-
    subject_profile(module_two_all_met, Profile),
    findall(Verdict, gdpr_transfer_scc_reliance_check(Profile, Verdict), Verdicts),
    Verdicts == [may_rely_on_clauses].
test(undocumented_may_not_rely_on_clauses) :-
    subject_profile(module_two_documentation_missing, Profile),
    gdpr_transfer_scc_reliance_check(Profile, may_not_rely_on_clauses).
test(missing_module_passes_through_the_reliance_check) :-
    subject_profile(module_selected_absent, Profile),
    gdpr_transfer_scc_reliance_check(Profile, indeterminate([module_selected])).
test(input_problems_pass_through_the_reliance_check) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    gdpr_transfer_scc_reliance_check(Profile, input_problems([duplicate_key(exporter_role), unknown_key(colour)])).
test(documenting_the_assessment_flips_to_provided) :-
    subject_profile(module_two_documentation_missing, Profile),
    findall(Status, gdpr_transfer_scc_what_if(Profile, local_laws_assessment_documented, true, Status), Statuses),
    Statuses == [appropriate_safeguards_provided].
test(modifying_the_clauses_flips_to_not_provided) :-
    subject_profile(module_two_all_met, Profile),
    gdpr_transfer_scc_what_if(Profile, clauses_modified, true, appropriate_safeguards_not_provided).
test(supplying_the_absent_module_settles_the_answer) :-
    subject_profile(module_selected_absent, Profile),
    gdpr_transfer_scc_what_if(Profile, module_selected, module_two, appropriate_safeguards_provided).
test(the_facade_status_is_unchanged_without_override) :-
    subject_profile(module_selected_absent, Profile),
    gdpr_transfer_scc_status(Profile, indeterminate([module_selected])).
test(profile_keys_are_the_eighteen_contract_keys) :-
    gdpr_transfer_scc_profile_keys(Keys),
    length(Keys, 18),
    Keys = [standard_contractual_clauses_decision_in_force|_RemainingKeys].
test(facade_decide_matches_the_safeguard_query) :-
    subject_profile(module_two_all_met, Profile),
    decide_gdpr_transfer_scc(Profile, gdpr_transfer_scc_verdict(Status, Citations)),
    standard_contractual_clauses_safeguard(Profile, Status, _Basis, Citations).

test(module_two_all_met_is_not_refused, fail) :-
    verdict_of(module_two_all_met, appropriate_safeguards_not_provided).
test(module_two_documentation_missing_is_not_provided, fail) :-
    verdict_of(module_two_documentation_missing, appropriate_safeguards_provided).
test(importer_subject_to_gdpr_is_not_provided, fail) :-
    verdict_of(importer_subject_to_gdpr, appropriate_safeguards_provided).
test(decision_attested_false_is_not_provided, fail) :-
    verdict_of(decision_in_force_attested_false, appropriate_safeguards_provided).
test(decision_absent_gets_no_final_answer, fail) :-
    verdict_of(decision_in_force_absent, appropriate_safeguards_provided).
test(wrong_module_selected_is_not_provided, fail) :-
    verdict_of(module_selected_wrong, appropriate_safeguards_provided).
test(absent_module_selected_is_not_provided, fail) :-
    verdict_of(module_selected_absent, appropriate_safeguards_provided).
test(unsure_decisive_added_clauses_are_not_settled, fail) :-
    verdict_of(added_clauses_unsure_decisive, appropriate_safeguards_not_provided).
test(unsure_added_clauses_settled_by_modification_is_not_referred, fail) :-
    verdict_of(added_clauses_unsure_settled_elsewhere, needs_legal_review(_Reason, _Context)).
test(bare_boolean_outside_fact_is_not_provided, fail) :-
    verdict_of(bare_boolean_outside_fact, appropriate_safeguards_provided).
test(module_four_without_combination_is_not_refused, fail) :-
    verdict_of(module_four_no_combination, appropriate_safeguards_not_provided).
test(module_four_with_combination_undocumented_is_not_provided, fail) :-
    verdict_of(module_four_with_combination_undocumented, appropriate_safeguards_provided).
test(processor_to_controller_is_not_module_two, fail) :-
    subject_profile(module_four_no_combination, Profile),
    standard_contractual_clauses_module(Profile, module_two, _Citations).
test(importer_subject_does_not_make_them_available, fail) :-
    subject_profile(importer_subject_to_gdpr, Profile),
    standard_contractual_clauses_availability(Profile, clauses_available, _Basis, _Citations).
test(incomplete_list_of_parties_is_not_complete, fail) :-
    subject_profile(module_two_list_of_parties_incomplete, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, _Citations).
test(option_one_without_annex_iii_is_not_complete, fail) :-
    subject_profile(module_three_specific_authorisation_without_sub_processor_list, Profile),
    standard_contractual_clauses_appendix(Profile, appendix_complete, _Citations).
test(undocumented_may_not_rely_is_not_allowed, fail) :-
    subject_profile(module_two_documentation_missing, Profile),
    gdpr_transfer_scc_reliance_check(Profile, may_rely_on_clauses).

cp_test_names([every_subject_resolves_to_its_expected_status, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable_once, every_near_miss_control_gets_a_different_verdict, final_verdicts_belong_to_the_status_vocabulary, module_two_all_met_provides_safeguards, module_two_all_met_carries_thirteen_citations, module_two_documentation_missing_does_not_provide, importer_subject_to_gdpr_does_not_provide, decision_attested_false_does_not_provide, decision_absent_is_referred_as_unresolved_cross_reference, decision_absent_referral_has_no_basis_or_citations, wrong_module_selected_does_not_provide, absent_module_selected_is_named_alone, unsure_decisive_added_clauses_go_to_a_lawyer, unsure_added_clauses_settled_by_modification, bare_boolean_outside_fact_is_an_input_problem, appendix_subjects_keep_the_safeguard, module_four_without_combination_provides_without_clause_14, module_four_with_combination_undocumented_does_not_provide, duplicate_and_unknown_keys_are_input_problems, unbound_profile_is_an_input_problem, good_profile_safeguard_basis_holds_four_outside_facts_in_order, controller_to_processor_is_module_two_once, processor_to_processor_is_module_three, processor_to_controller_is_module_four, controller_to_controller_is_module_one, missing_importer_role_is_named, good_facts_make_the_clauses_available_once, available_basis_holds_three_outside_facts, importer_subject_makes_the_clauses_not_available, decision_absent_availability_is_referred, url_evidence_is_accepted_by_the_input_check, url_evidence_is_copied_into_the_basis_as_supplied, url_evidence_with_an_unbound_argument_is_wrong_type, document_evidence_is_accepted_by_the_input_check, document_evidence_is_copied_into_the_basis_as_supplied, document_evidence_with_an_unbound_argument_is_wrong_type, module_two_all_met_appendix_is_complete_once, module_two_appendix_carries_eight_citations, incomplete_list_of_parties_makes_appendix_incomplete, option_one_without_annex_iii_is_incomplete, option_two_without_annex_iii_is_complete, module_four_appendix_needs_only_annex_i_a_and_b, unsure_annex_ii_goes_to_a_lawyer, well_formed_fixture_has_no_input_problems, duplicate_and_unknown_keys_are_listed_in_order, an_unbound_profile_is_wrong_type, an_empty_profile_has_no_problems, all_met_checklist_has_nine_cited_met_items, undocumented_assessment_is_an_unmet_cited_item, module_four_without_combination_marks_clause_14_inapplicable, all_met_may_rely_on_clauses, undocumented_may_not_rely_on_clauses, missing_module_passes_through_the_reliance_check, input_problems_pass_through_the_reliance_check, documenting_the_assessment_flips_to_provided, modifying_the_clauses_flips_to_not_provided, supplying_the_absent_module_settles_the_answer, the_facade_status_is_unchanged_without_override, profile_keys_are_the_eighteen_contract_keys, facade_decide_matches_the_safeguard_query]).
cp_test_fail_names([module_two_all_met_is_not_refused, module_two_documentation_missing_is_not_provided, importer_subject_to_gdpr_is_not_provided, decision_attested_false_is_not_provided, decision_absent_gets_no_final_answer, wrong_module_selected_is_not_provided, absent_module_selected_is_not_provided, unsure_decisive_added_clauses_are_not_settled, unsure_added_clauses_settled_by_modification_is_not_referred, bare_boolean_outside_fact_is_not_provided, module_four_without_combination_is_not_refused, module_four_with_combination_undocumented_is_not_provided, processor_to_controller_is_not_module_two, importer_subject_does_not_make_them_available, incomplete_list_of_parties_is_not_complete, option_one_without_annex_iii_is_not_complete, undocumented_may_not_rely_is_not_allowed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
