% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_citations, [citation/2, implements/1]).

test(the_admissibility_citation_is_recorded) :-
    citation(eu_reg_2025_2518_art_4_1, _Record).
test(the_admissibility_record_has_label_reference_and_verbatim) :-
    citation(eu_reg_2025_2518_art_4_1, [label - _Label, ref - _Reference, verbatim - _Verbatim]).
test(the_late_step_citation_is_recorded) :-
    citation(eu_reg_2025_2518_art_14, _Record).
test(the_application_day_citation_is_recorded) :-
    citation(eu_reg_2025_2518_art_37_2, _Record).
test(the_three_referral_targets_are_recorded) :-
    citation(article_56_2_local_case_statement, _FirstRecord),
    citation(national_domestic_proceedings_statement, _SecondRecord),
    citation(time_limit_source_statement, _ThirdRecord).
test(a_referral_target_record_omits_the_verbatim) :-
    citation(time_limit_source_statement, [label - _Label, ref - _Reference]).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2025_2518_art_12_6).
test(the_admissibility_atoms_are_distinct) :-
    dif(admissible, inadmissible).
test(the_prior_request_atoms_are_distinct) :-
    dif(prior_request_not_required, prior_request_made),
    dif(prior_request_not_required, prior_request_not_made),
    dif(prior_request_made, prior_request_not_made).
test(the_early_resolution_atoms_are_distinct) :-
    Atoms = [early_resolution_not_available, complaint_not_devoid_of_purpose, early_resolution_objected, resolution_established_by_receiving_authority, draft_decision_establishing_resolution],
    sort(Atoms, Sorted),
    length(Sorted, Count),
    Count == 5.
test(the_simple_procedure_atoms_are_distinct) :-
    Atoms = [chapter_iii_not_applicable, simple_procedure_not_available, simple_procedure_excluded_by_objection, simple_procedure_available],
    sort(Atoms, Sorted),
    length(Sorted, Count),
    Count == 4.
test(the_late_step_and_temporal_atoms_are_distinct) :-
    dif(legality_and_validity_not_affected, not_governed_by_article_14),
    dif(part_applies, part_does_not_apply).
test(the_basis_atoms_are_distinct) :-
    dif(suspended_until_board_binding_decision, extension_not_permitted).
test(the_draft_decision_limit_destructures) :-
    Result = draft_decision_limit(15, extension(up_to, 12, months)),
    Result = draft_decision_limit(Months, extension(Kind, Ceiling, Unit)),
    Months == 15,
    Kind == up_to,
    Ceiling == 12,
    Unit == months.
test(the_time_limit_row_destructures) :-
    Limit = limit(4, weeks, within, receipt_of_summary_of_key_issues, extension(exactly, 2, weeks)),
    Limit = limit(Number, Unit, Relation, Event, Extension),
    Number == 4,
    Unit == weeks,
    Relation == within,
    Event == receipt_of_summary_of_key_issues,
    Extension == extension(exactly, 2, weeks).
test(the_absent_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_6_5), cite(article_56_2_local_case_statement)), [resolution(cite(article_56_2_local_case_statement), not_attempted), inputs_relied_on([case_handled_under_article_56_2 - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Status), inputs_relied_on([Key - Value])]),
    Citation == eu_reg_2025_2518_art_6_5,
    Target == article_56_2_local_case_statement,
    Status == not_attempted,
    Key == case_handled_under_article_56_2,
    Value == absent,
    citation(Citation, _CitationRecord),
    citation(Target, _TargetRecord).
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(extension_justified_by_exceptional_complexity, cite(eu_reg_2025_2518_art_12_3)), [inputs_relied_on([extension_justified_by_exceptional_complexity - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == extension_justified_by_exceptional_complexity,
    Pairs == [extension_justified_by_exceptional_complexity - unsure],
    citation(Citation, _Record).
test(the_outside_fact_basis_item_destructures) :-
    Attested = attested(true, attestation(host_user, host_time, stated_reason, none)),
    Basis = [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, Attested)],
    Basis = [outside_fact(Key, attested(Value, attestation(_By, _At, _Reason, Evidence)))],
    Key == time_limit_set_by_this_regulation_or_article_65_6,
    Value == true,
    Evidence == none.
test(the_indeterminate_status_holds_one_key) :-
    Result = indeterminate([complaint_lodged_by]),
    Result = indeterminate([Key]),
    Key == complaint_lodged_by.
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_procedural_regulation_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(complaint_lodged_by, article_80_1_body), attribute(lodging_person_name_and_contact_details_included, true), attribute(issues_addressable_without_additional_cooperation, unsure), attribute(case_handled_under_article_56_2, attested(false, attestation(host_user, host_time, stated_reason, url(address, retrieved_time))))],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    findall(Problems, gdpr_procedural_regulation_input_problems([attribute(lodging_person_name_and_contact_details_included, unsure)], Problems), Answers),
    Answers == [[wrong_type(lodging_person_name_and_contact_details_included)]].
test(a_bare_outside_fact_is_wrong_type) :-
    findall(Problems, gdpr_procedural_regulation_input_problems([attribute(case_handled_under_article_56_2, true)], Problems), Answers),
    Answers == [[wrong_type(case_handled_under_article_56_2)]].
test(a_judgement_given_an_attested_term_is_wrong_type) :-
    Profile = [attribute(extension_justified_by_exceptional_complexity, attested(true, attestation(host_user, host_time, stated_reason, none)))],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(extension_justified_by_exceptional_complexity)]].
test(a_repeated_key_is_a_duplicate_only) :-
    Profile = [attribute(simple_cooperation_procedure_applied, true), attribute(simple_cooperation_procedure_applied, robot)],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(simple_cooperation_procedure_applied)]].
test(contract_problems_come_before_unknown_keys) :-
    Profile = [attribute(colour, red), attribute(complaint_lodged_by, robot), attribute(colour, blue)],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(complaint_lodged_by), unknown_key(colour)]].
test(a_term_that_is_not_a_list_is_not_a_profile) :-
    findall(Problems, gdpr_procedural_regulation_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_stray_element_is_not_a_profile) :-
    findall(Problems, gdpr_procedural_regulation_input_problems([attribute(complaint_lodged_by, data_subject), stray], Problems), Answers),
    Answers == [[wrong_type(profile)]].

test(the_provenance_marker_fails_for_the_placeholder_key, fail) :-
    implements(eu_todo_primary_source).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).
test(a_well_formed_profile_is_not_wrong_type, fail) :-
    gdpr_procedural_regulation_input_problems([attribute(complaint_lodged_by, data_subject)], [wrong_type(complaint_lodged_by)]).

cp_test_names([the_admissibility_citation_is_recorded, the_admissibility_record_has_label_reference_and_verbatim, the_late_step_citation_is_recorded, the_application_day_citation_is_recorded, the_three_referral_targets_are_recorded, a_referral_target_record_omits_the_verbatim, the_provenance_marker_holds_for_a_recorded_key, the_admissibility_atoms_are_distinct, the_prior_request_atoms_are_distinct, the_early_resolution_atoms_are_distinct, the_simple_procedure_atoms_are_distinct, the_late_step_and_temporal_atoms_are_distinct, the_basis_atoms_are_distinct, the_draft_decision_limit_destructures, the_time_limit_row_destructures, the_absent_referral_destructures, the_open_textured_referral_destructures, the_outside_fact_basis_item_destructures, the_indeterminate_status_holds_one_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, a_bare_outside_fact_is_wrong_type, a_judgement_given_an_attested_term_is_wrong_type, a_repeated_key_is_a_duplicate_only, contract_problems_come_before_unknown_keys, a_term_that_is_not_a_list_is_not_a_profile, a_list_with_a_stray_element_is_not_a_profile]).
cp_test_fail_names([the_provenance_marker_fails_for_the_placeholder_key, the_placeholder_citation_is_gone, a_well_formed_profile_is_not_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
