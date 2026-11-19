% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_procedural_regulation_input_problems([], Problems), Solutions),
    Solutions == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(complaint_lodged_by, article_80_1_body), attribute(lodging_person_name_and_contact_details_included, true), attribute(complaint_concerns_right_exercised_by_request, unsure), attribute(early_resolution_procedure_before, lead_authority), attribute(case_handled_under_article_56_2, attested(false, attestation(host, today, reason, none))), attribute(time_limit_set_by_this_regulation_or_article_65_6, attested(true, attestation(host, today, reason, url(address, retrieved))))],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Solutions),
    Solutions == [[]].
test(a_profile_that_is_not_a_list_is_wrong_type) :-
    findall(Problems, gdpr_procedural_regulation_input_problems(profile, Problems), Solutions),
    Solutions == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, gdpr_procedural_regulation_input_problems(_Unbound, Problems), Solutions),
    Solutions == [[wrong_type(profile)]].
test(a_list_with_a_non_attribute_element_is_wrong_type) :-
    findall(Problems, gdpr_procedural_regulation_input_problems([attribute(complaint_lodged_by, data_subject), stray], Problems), Solutions),
    Solutions == [[wrong_type(profile)]].
test(a_key_outside_the_contract_is_unknown_once) :-
    Profile = [attribute(colour, red), attribute(colour, blue)],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Solutions),
    Solutions == [[unknown_key(colour)]].
test(a_number_key_is_unknown_as_given) :-
    findall(Problems, gdpr_procedural_regulation_input_problems([attribute(42, true)], Problems), Solutions),
    Solutions == [[unknown_key(42)]].
test(contract_problems_come_before_unknown_keys) :-
    Profile = [attribute(colour, red), attribute(complaint_lodged_by, nobody)],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Solutions),
    Solutions == [[wrong_type(complaint_lodged_by), unknown_key(colour)]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    Profile = [attribute(complaint_concerns_chapter_iii_rights, unsure)],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Solutions),
    Solutions == [[wrong_type(complaint_concerns_chapter_iii_rights)]].
test(a_judgement_given_an_attested_term_is_wrong_type) :-
    Profile = [attribute(issues_addressable_without_additional_cooperation, attested(true, attestation(host, today, reason, none)))],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Solutions),
    Solutions == [[wrong_type(issues_addressable_without_additional_cooperation)]].
test(a_bare_outside_fact_is_wrong_type) :-
    Profile = [attribute(case_handled_under_article_56_2, true)],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Solutions),
    Solutions == [[wrong_type(case_handled_under_article_56_2)]].
test(an_attestation_with_an_unbound_argument_is_wrong_type) :-
    Profile = [attribute(national_law_requires_domestic_proceedings_after_time_limit, attested(true, attestation(_Host, today, reason, none)))],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Solutions),
    Solutions = [[Problem]],
    Problem == wrong_type(national_law_requires_domestic_proceedings_after_time_limit).
test(a_repeated_contract_key_is_duplicate_only) :-
    Profile = [attribute(draft_decision_time_limit_extended, true), attribute(draft_decision_time_limit_extended, maybe)],
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), Solutions),
    Solutions == [[duplicate_key(draft_decision_time_limit_extended)]].
test(a_well_formed_profile_is_reported_clean) :-
    gdpr_procedural_regulation_input_problems([attribute(simple_cooperation_procedure_applied, true)], []).
test(the_draft_decision_limit_destructures) :-
    Result = draft_decision_limit(15, extension(up_to, 12, months)),
    Result = draft_decision_limit(Months, extension(Ceiling, Length, Unit)),
    Months == 15,
    Ceiling == up_to,
    Length == 12,
    Unit == months.
test(the_time_limit_row_destructures) :-
    Limit = limit(4, weeks, within, receipt_of_summary_of_key_issues, extension(exactly, 2, weeks)),
    Limit = limit(Length, Unit, Relation, Event, Extension),
    Length == 4,
    Unit == weeks,
    Relation == within,
    Event == receipt_of_summary_of_key_issues,
    Extension == extension(exactly, 2, weeks).
test(the_absent_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_14), cite(time_limit_source_statement)), [resolution(cite(time_limit_source_statement), not_attempted), inputs_relied_on([time_limit_set_by_this_regulation_or_article_65_6 - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Status), inputs_relied_on([Key - Value])]),
    Citation == eu_reg_2025_2518_art_14,
    Target == time_limit_source_statement,
    Status == not_attempted,
    Key == time_limit_set_by_this_regulation_or_article_65_6,
    Value == absent,
    citation(Citation, _CitationRecord),
    citation(Target, _TargetRecord).
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(extension_justified_by_exceptional_complexity, cite(eu_reg_2025_2518_art_12_3)), [inputs_relied_on([extension_justified_by_exceptional_complexity - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == extension_justified_by_exceptional_complexity,
    Pairs == [extension_justified_by_exceptional_complexity - unsure],
    citation(Citation, _Record).
test(the_outside_fact_basis_item_copies_the_attested_term) :-
    Attested = attested(true, attestation(host, today, reason, document(upload, digest))),
    Basis = [outside_fact(case_handled_under_article_56_2, Attested)],
    Basis = [outside_fact(Key, Copied)],
    Key == case_handled_under_article_56_2,
    Copied == Attested.
test(the_missing_key_status_names_one_key) :-
    Result = indeterminate([complaint_concerns_chapter_iii_rights]),
    Result = indeterminate([Key]),
    Key == complaint_concerns_chapter_iii_rights.
test(the_admissibility_atoms_are_distinct) :-
    dif(admissible, inadmissible).
test(the_early_resolution_atoms_are_distinct) :-
    dif(resolution_established_by_receiving_authority, draft_decision_establishing_resolution),
    dif(early_resolution_objected, complaint_not_devoid_of_purpose),
    dif(early_resolution_not_available, early_resolution_objected).
test(the_simple_procedure_atoms_are_distinct) :-
    dif(simple_procedure_available, simple_procedure_not_available),
    dif(simple_procedure_excluded_by_objection, chapter_iii_not_applicable).
test(the_late_step_and_temporal_atoms_are_distinct) :-
    dif(legality_and_validity_not_affected, not_governed_by_article_14),
    dif(part_applies, part_does_not_apply).
test(the_prior_request_atoms_are_distinct) :-
    dif(prior_request_made, prior_request_not_made),
    dif(prior_request_not_required, prior_request_made).
test(the_admissibility_citation_is_recorded) :-
    citation(eu_reg_2025_2518_art_4_1, Record),
    member(label - _Label, Record).
test(the_late_step_citation_is_implemented) :-
    implements(eu_reg_2025_2518_art_14).
test(the_application_day_citation_is_recorded) :-
    citation(eu_reg_2025_2518_art_37_2, _Record).
test(the_full_key_for_the_same_provision_is_implemented) :-
    implements(eu_reg_2025_2518_art_12_6).

test(a_well_formed_profile_is_not_reported_with_problems, fail) :-
    gdpr_procedural_regulation_input_problems([attribute(simple_cooperation_procedure_applied, true)], [_|_]).
test(an_unrecorded_shortened_key_is_not_implemented, fail) :-
    implements(art_14).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_profile_that_is_not_a_list_is_wrong_type, an_unbound_profile_is_wrong_type, a_list_with_a_non_attribute_element_is_wrong_type, a_key_outside_the_contract_is_unknown_once, a_number_key_is_unknown_as_given, contract_problems_come_before_unknown_keys, a_crisp_key_given_unsure_is_wrong_type, a_judgement_given_an_attested_term_is_wrong_type, a_bare_outside_fact_is_wrong_type, an_attestation_with_an_unbound_argument_is_wrong_type, a_repeated_contract_key_is_duplicate_only, a_well_formed_profile_is_reported_clean, the_draft_decision_limit_destructures, the_time_limit_row_destructures, the_absent_referral_destructures, the_open_textured_referral_destructures, the_outside_fact_basis_item_copies_the_attested_term, the_missing_key_status_names_one_key, the_admissibility_atoms_are_distinct, the_early_resolution_atoms_are_distinct, the_simple_procedure_atoms_are_distinct, the_late_step_and_temporal_atoms_are_distinct, the_prior_request_atoms_are_distinct, the_admissibility_citation_is_recorded, the_late_step_citation_is_implemented, the_application_day_citation_is_recorded, the_full_key_for_the_same_provision_is_implemented]).
cp_test_fail_names([a_well_formed_profile_is_not_reported_with_problems, an_unrecorded_shortened_key_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
