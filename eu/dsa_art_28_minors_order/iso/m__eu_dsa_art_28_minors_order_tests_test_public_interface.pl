% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_28_minors_order_dsa_art_28_minors_order, [section_3_application_status/4, art_28_1_obligation_status/4, art_28_1_compliance_status/4, art_28_2_advertising_status/4, decide_dsa_art_28_minors_order/2, dsa_art_28_minors_order_status/2, dsa_art_28_minors_order_checklist/2, dsa_art_28_minors_order_decision_resolvable/1, dsa_art_28_minors_order_status_values/1]).
:- use_module(m__eu_dsa_art_28_minors_order_fixtures, [dsa_art_28_minors_order_subject/1, dsa_art_28_minors_order_profile_for/2, dsa_art_28_minors_order_assess/2]).

status_once(Subject, Expected) :-
    findall(Status, dsa_art_28_minors_order_assess(Subject, dsa_art_28_minors_order_verdict(Status, _)), Statuses),
    Statuses == [Expected].

results_once(Subject, Expected) :-
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    findall(Results, checklist_results(Profile, Results), AllResults),
    AllResults == [Expected].

checklist_results(Profile, Results) :-
    dsa_art_28_minors_order_checklist(Profile, Items),
    maplist(item_result, Items, Results).

item_result(item(_, Result, _), Result).

overall_citations([cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1), cite(eu_reg_2022_2065_art_28_2)]).

section_citations([cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]).

obligation_citations([cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).

advertising_citations([cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)]).

section_answers(Subject, Answers) :-
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, section_3_application_status(Profile, Result, Basis, Citations), Answers).

obligation_answers(Subject, Answers) :-
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, art_28_1_obligation_status(Profile, Result, Basis, Citations), Answers).

compliance_answers(Subject, Answers) :-
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, art_28_1_compliance_status(Profile, Result, Basis, Citations), Answers).

advertising_answers(Subject, Answers) :-
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, art_28_2_advertising_status(Profile, Result, Basis, Citations), Answers).

test(checklist_and_resolvable_hold_on_the_baseline_fixture) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    dsa_art_28_minors_order_decision_resolvable(Profile),
    dsa_art_28_minors_order_checklist(Profile, [_, _, _, _]).
test(the_public_interface_resolves_on_the_baseline_fixture) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_adequate, Profile),
    findall(Verdict, decide_dsa_art_28_minors_order(Profile, Verdict), Verdicts),
    overall_citations(Citations),
    Verdicts == [dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_complied, Citations)].
test(every_subject_gets_exactly_one_verdict) :-
    findall(Subject - Count, (dsa_art_28_minors_order_subject(Subject), findall(Verdict, dsa_art_28_minors_order_assess(Subject, Verdict), Verdicts), length(Verdicts, Count)), Counts),
    findall(Subject - 1, dsa_art_28_minors_order_subject(Subject), Expected),
    Counts == Expected.
test(every_subject_is_resolvable_with_a_four_row_checklist) :-
    findall(Subject, (dsa_art_28_minors_order_subject(Subject), dsa_art_28_minors_order_profile_for(Subject, Profile), dsa_art_28_minors_order_decision_resolvable(Profile), dsa_art_28_minors_order_checklist(Profile, Items), length(Items, 4)), Resolved),
    findall(Subject, dsa_art_28_minors_order_subject(Subject), Subjects),
    Resolved == Subjects.
test(status_projection_agrees_with_the_verdict) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_designated, Profile),
    findall(Status, dsa_art_28_minors_order_status(Profile, Status), Statuses),
    Statuses == [dsa_art_28_minors_order_breached].
test(section_3_applies_to_a_medium_provider) :-
    section_citations(Citations),
    section_answers(medium_provider_accessible_platform_measures_adequate, Answers),
    Answers == [section_3_applies - [] - Citations].
test(section_3_applies_to_a_designated_provider_with_an_empty_basis) :-
    section_citations(Citations),
    section_answers(designated_provider_enterprise_facts_absent, Answers),
    Answers == [section_3_applies - [] - Citations].
test(section_3_does_not_apply_to_a_small_enterprise_stated_not_designated) :-
    section_citations(Citations),
    section_answers(small_enterprise_stated_not_designated, Answers),
    Answers == [section_3_not_applicable - [outside_fact(designated_as_very_large_online_platform, attested(false, attestation(host_user, recorded_moment, commission_list_checked, none)))] - Citations].
test(section_3_designation_not_shown_is_referred_on) :-
    section_answers(small_enterprise_designation_not_shown, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform - absent])]) - [] - []].
test(section_3_names_the_absent_run_off_fact) :-
    section_answers(enterprise_run_off_fact_absent, Answers),
    Answers == [indeterminate([provider_within_12_months_after_losing_micro_or_small_status]) - [] - []].
test(section_3_reports_input_problems) :-
    section_answers(profile_with_unknown_key, Answers),
    Answers == [input_problems([unknown_key(colour)]) - [] - []].
test(section_3_basis_copies_url_evidence_as_supplied) :-
    Attested = attested(false, attestation(host_user, recorded_moment, commission_list_checked, url(designation_list_address, retrieved_moment))),
    findall(Result - Basis, section_3_application_status([attribute(provider_qualifies_as_micro_or_small_enterprise, true), attribute(designated_as_very_large_online_platform, Attested)], Result, Basis, _), Answers),
    Answers == [section_3_not_applicable - [outside_fact(designated_as_very_large_online_platform, Attested)]].
test(section_3_basis_copies_document_evidence_as_supplied) :-
    Attested = attested(false, attestation(host_user, recorded_moment, commission_list_checked, document(upload_identifier, digest_value))),
    findall(Result - Basis, section_3_application_status([attribute(provider_within_12_months_after_losing_micro_or_small_status, true), attribute(designated_as_very_large_online_platform, Attested)], Result, Basis, _), Answers),
    Answers == [section_3_not_applicable - [outside_fact(designated_as_very_large_online_platform, Attested)]].
test(the_evidence_and_provenance_constructors_build_and_destructure) :-
    UrlEvidence = url(designation_list_address, retrieved_moment),
    UrlEvidence = url(Address, _),
    Address == designation_list_address,
    DocumentEvidence = document(upload_identifier, digest_value),
    DocumentEvidence = document(_, Digest),
    Digest == digest_value,
    Provenance = provenance(host_user, recorded_moment),
    Provenance = provenance(Source, _),
    Source == host_user.
test(obligation_applies_to_an_accessible_platform_in_section_3) :-
    obligation_citations(Citations),
    obligation_answers(medium_provider_accessible_platform_measures_adequate, Answers),
    Answers == [art_28_1_obligation_applies - [] - Citations].
test(obligation_does_not_apply_to_a_platform_not_accessible) :-
    obligation_citations(Citations),
    obligation_answers(medium_provider_platform_not_accessible_to_minors, Answers),
    Answers == [art_28_1_obligation_not_applicable - [] - Citations].
test(obligation_not_applicable_outside_section_3_does_not_copy_the_basis) :-
    obligation_citations(Citations),
    obligation_answers(small_enterprise_stated_not_designated, Answers),
    Answers == [art_28_1_obligation_not_applicable - [] - Citations].
test(obligation_names_accessibility_on_an_empty_profile) :-
    obligation_answers(empty_profile, Answers),
    Answers == [indeterminate([platform_accessible_to_minors]) - [] - []].
test(obligation_unsure_accessibility_goes_to_a_lawyer) :-
    obligation_answers(accessibility_judgement_unsure, Answers),
    Answers == [needs_legal_review(open_textured(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - unsure])]) - [] - []].
test(compliance_adequate_measures_are_compliant) :-
    obligation_citations(Citations),
    compliance_answers(medium_provider_accessible_platform_measures_adequate, Answers),
    Answers == [art_28_1_measures_compliant - [] - Citations].
test(compliance_inadequate_measures_are_not_compliant) :-
    obligation_citations(Citations),
    compliance_answers(medium_provider_accessible_platform_measures_inadequate, Answers),
    Answers == [art_28_1_measures_not_compliant - [] - Citations].
test(compliance_measures_not_required_without_the_obligation) :-
    obligation_citations(Citations),
    compliance_answers(medium_provider_platform_not_accessible_to_minors, Answers),
    Answers == [art_28_1_measures_not_required - [] - Citations].
test(compliance_names_the_absent_run_off_fact) :-
    compliance_answers(enterprise_run_off_fact_absent, Answers),
    Answers == [indeterminate([provider_within_12_months_after_losing_micro_or_small_status]) - [] - []].
test(compliance_unsure_measures_go_to_a_lawyer) :-
    compliance_answers(measures_judgement_unsure, Answers),
    Answers == [needs_legal_review(open_textured(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - true, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - unsure])]) - [] - []].
test(advertising_to_a_known_minor_is_prohibited) :-
    advertising_citations(Citations),
    advertising_answers(profiled_advertising_to_recipient_known_minor, Answers),
    Answers == [art_28_2_presentation_prohibited - [] - Citations].
test(advertising_recipient_not_known_minor_is_not_prohibited) :-
    advertising_citations(Citations),
    advertising_answers(profiled_advertising_recipient_not_known_minor, Answers),
    Answers == [art_28_2_presentation_not_prohibited - [] - Citations].
test(advertising_outside_section_3_is_not_prohibited_with_the_same_sets) :-
    advertising_citations(Citations),
    advertising_answers(small_enterprise_stated_not_designated, Answers),
    Answers == [art_28_2_presentation_not_prohibited - [] - Citations].
test(advertising_names_the_first_absent_element) :-
    advertising_answers(empty_profile, Answers),
    Answers == [indeterminate([advertisements_presented_to_recipient_on_interface]) - [] - []].
test(advertising_unsure_awareness_goes_to_a_lawyer) :-
    advertising_answers(awareness_judgement_unsure, Answers),
    Answers == [needs_legal_review(open_textured(aware_with_reasonable_certainty_recipient_is_minor, cite(eu_reg_2022_2065_art_28_2)), [inputs_relied_on([advertisements_based_on_profiling_of_recipient - true, aware_with_reasonable_certainty_recipient_is_minor - unsure])]) - [] - []].
test(adequate_measures_comply) :-
    status_once(medium_provider_accessible_platform_measures_adequate, dsa_art_28_minors_order_complied).
test(adequate_measures_checklist) :-
    results_once(medium_provider_accessible_platform_measures_adequate, [section_3_applies, art_28_1_obligation_applies, art_28_1_measures_compliant, art_28_2_presentation_not_prohibited]).
test(adequate_measures_cite_all_four_provisions) :-
    overall_citations(Expected),
    dsa_art_28_minors_order_assess(medium_provider_accessible_platform_measures_adequate, dsa_art_28_minors_order_verdict(_, Citations)),
    Citations == Expected.
test(inadequate_measures_breach) :-
    status_once(medium_provider_accessible_platform_measures_inadequate, dsa_art_28_minors_order_breached).
test(inadequate_measures_checklist) :-
    results_once(medium_provider_accessible_platform_measures_inadequate, [section_3_applies, art_28_1_obligation_applies, art_28_1_measures_not_compliant, art_28_2_presentation_not_prohibited]).
test(checklist_items_carry_their_fixed_citations) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_inadequate, Profile),
    dsa_art_28_minors_order_checklist(Profile, Items),
    Items == [item(section_3_application, section_3_applies, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]), item(art_28_1_obligation, art_28_1_obligation_applies, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]), item(art_28_1_compliance, art_28_1_measures_not_compliant, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]), item(art_28_2_advertising, art_28_2_presentation_not_prohibited, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)])].
test(platform_not_accessible_is_not_engaged) :-
    status_once(medium_provider_platform_not_accessible_to_minors, dsa_art_28_minors_order_not_engaged).
test(platform_not_accessible_checklist) :-
    results_once(medium_provider_platform_not_accessible_to_minors, [section_3_applies, art_28_1_obligation_not_applicable, art_28_1_measures_not_required, art_28_2_presentation_not_prohibited]).
test(profiled_advertising_to_a_known_minor_breaches) :-
    status_once(profiled_advertising_to_recipient_known_minor, dsa_art_28_minors_order_breached).
test(profiled_advertising_to_a_known_minor_checklist) :-
    results_once(profiled_advertising_to_recipient_known_minor, [section_3_applies, art_28_1_obligation_not_applicable, art_28_1_measures_not_required, art_28_2_presentation_prohibited]).
test(recipient_not_known_minor_is_not_engaged) :-
    status_once(profiled_advertising_recipient_not_known_minor, dsa_art_28_minors_order_not_engaged).
test(recipient_not_known_minor_checklist) :-
    results_once(profiled_advertising_recipient_not_known_minor, [section_3_applies, art_28_1_obligation_not_applicable, art_28_1_measures_not_required, art_28_2_presentation_not_prohibited]).
test(small_enterprise_not_designated_is_not_engaged) :-
    status_once(small_enterprise_stated_not_designated, dsa_art_28_minors_order_not_engaged).
test(small_enterprise_not_designated_checklist) :-
    results_once(small_enterprise_stated_not_designated, [section_3_not_applicable, art_28_1_obligation_not_applicable, art_28_1_measures_not_required, art_28_2_presentation_not_prohibited]).
test(small_enterprise_designated_breaches) :-
    status_once(small_enterprise_stated_designated, dsa_art_28_minors_order_breached).
test(small_enterprise_designated_checklist) :-
    results_once(small_enterprise_stated_designated, [section_3_applies, art_28_1_obligation_applies, art_28_1_measures_not_compliant, art_28_2_presentation_prohibited]).
test(within_twelve_months_not_designated_is_not_engaged) :-
    status_once(provider_within_twelve_months_stated_not_designated, dsa_art_28_minors_order_not_engaged).
test(within_twelve_months_not_designated_checklist) :-
    results_once(provider_within_twelve_months_stated_not_designated, [section_3_not_applicable, art_28_1_obligation_not_applicable, art_28_1_measures_not_required, art_28_2_presentation_not_prohibited]).
test(past_twelve_months_complies) :-
    status_once(provider_past_twelve_months_medium_enterprise, dsa_art_28_minors_order_complied).
test(past_twelve_months_checklist) :-
    results_once(provider_past_twelve_months_medium_enterprise, [section_3_applies, art_28_1_obligation_applies, art_28_1_measures_compliant, art_28_2_presentation_not_prohibited]).
test(designation_not_shown_is_referred_on) :-
    status_once(small_enterprise_designation_not_shown, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([platform_accessible_to_minors - true, designated_as_very_large_online_platform - absent, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - true])])).
test(designation_not_shown_has_no_citations) :-
    dsa_art_28_minors_order_assess(small_enterprise_designation_not_shown, dsa_art_28_minors_order_verdict(_, Citations)),
    Citations == [].
test(designation_not_shown_checklist) :-
    results_once(small_enterprise_designation_not_shown, [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform - absent])]), needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([platform_accessible_to_minors - true, designated_as_very_large_online_platform - absent])]), needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([platform_accessible_to_minors - true, designated_as_very_large_online_platform - absent, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - true])]), needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([advertisements_based_on_profiling_of_recipient - true, aware_with_reasonable_certainty_recipient_is_minor - true, designated_as_very_large_online_platform - absent])])]).
test(designated_with_enterprise_facts_absent_complies) :-
    status_once(designated_provider_enterprise_facts_absent, dsa_art_28_minors_order_complied).
test(designated_with_enterprise_facts_absent_checklist) :-
    results_once(designated_provider_enterprise_facts_absent, [section_3_applies, art_28_1_obligation_applies, art_28_1_measures_compliant, art_28_2_presentation_not_prohibited]).
test(empty_profile_names_accessibility_first) :-
    status_once(empty_profile, indeterminate([platform_accessible_to_minors])).
test(empty_profile_checklist) :-
    results_once(empty_profile, [indeterminate([provider_qualifies_as_micro_or_small_enterprise]), indeterminate([platform_accessible_to_minors]), indeterminate([platform_accessible_to_minors]), indeterminate([advertisements_presented_to_recipient_on_interface])]).
test(run_off_fact_absent_is_named) :-
    status_once(enterprise_run_off_fact_absent, indeterminate([provider_within_12_months_after_losing_micro_or_small_status])).
test(run_off_fact_absent_checklist) :-
    results_once(enterprise_run_off_fact_absent, [indeterminate([provider_within_12_months_after_losing_micro_or_small_status]), indeterminate([provider_within_12_months_after_losing_micro_or_small_status]), indeterminate([provider_within_12_months_after_losing_micro_or_small_status]), art_28_2_presentation_not_prohibited]).
test(unsure_accessibility_goes_to_a_lawyer) :-
    status_once(accessibility_judgement_unsure, needs_legal_review(open_textured(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - unsure, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - true])])).
test(unsure_accessibility_checklist) :-
    results_once(accessibility_judgement_unsure, [section_3_applies, needs_legal_review(open_textured(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - unsure])]), needs_legal_review(open_textured(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - unsure, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - true])]), art_28_2_presentation_not_prohibited]).
test(unsure_measures_go_to_a_lawyer) :-
    status_once(measures_judgement_unsure, needs_legal_review(open_textured(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - true, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - unsure])])).
test(unsure_profiling_goes_to_a_lawyer) :-
    status_once(profiling_judgement_unsure, needs_legal_review(open_textured(advertisements_based_on_profiling_of_recipient, cite(eu_reg_2022_2065_art_28_2)), [inputs_relied_on([advertisements_based_on_profiling_of_recipient - unsure, aware_with_reasonable_certainty_recipient_is_minor - true])])).
test(unsure_profiling_checklist) :-
    results_once(profiling_judgement_unsure, [section_3_applies, art_28_1_obligation_not_applicable, art_28_1_measures_not_required, needs_legal_review(open_textured(advertisements_based_on_profiling_of_recipient, cite(eu_reg_2022_2065_art_28_2)), [inputs_relied_on([advertisements_based_on_profiling_of_recipient - unsure, aware_with_reasonable_certainty_recipient_is_minor - true])])]).
test(unsure_awareness_goes_to_a_lawyer) :-
    status_once(awareness_judgement_unsure, needs_legal_review(open_textured(aware_with_reasonable_certainty_recipient_is_minor, cite(eu_reg_2022_2065_art_28_2)), [inputs_relied_on([advertisements_based_on_profiling_of_recipient - true, aware_with_reasonable_certainty_recipient_is_minor - unsure])])).
test(unknown_key_is_an_input_problem) :-
    status_once(profile_with_unknown_key, input_problems([unknown_key(colour)])).
test(unknown_key_checklist) :-
    results_once(profile_with_unknown_key, [input_problems([unknown_key(colour)]), input_problems([unknown_key(colour)]), input_problems([unknown_key(colour)]), input_problems([unknown_key(colour)])]).
test(wrong_type_is_an_input_problem) :-
    status_once(profile_with_wrong_type, input_problems([wrong_type(platform_accessible_to_minors)])).
test(duplicate_key_is_an_input_problem) :-
    status_once(profile_with_duplicate_key, input_problems([duplicate_key(provider_qualifies_as_micro_or_small_enterprise)])).
test(an_unbound_profile_gets_one_input_problem_verdict) :-
    findall(Verdict, decide_dsa_art_28_minors_order(_, Verdict), Verdicts),
    Verdicts == [dsa_art_28_minors_order_verdict(input_problems([wrong_type(profile)]), [])].

test(section_3_small_enterprise_not_designated_is_not_applies, fail) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_not_designated, Profile),
    section_3_application_status(Profile, section_3_applies, _, _).
test(obligation_outside_section_3_is_not_applies, fail) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_not_designated, Profile),
    art_28_1_obligation_status(Profile, art_28_1_obligation_applies, _, _).
test(compliance_inadequate_measures_are_not_compliant_atom, fail) :-
    dsa_art_28_minors_order_profile_for(medium_provider_accessible_platform_measures_inadequate, Profile),
    art_28_1_compliance_status(Profile, art_28_1_measures_compliant, _, _).
test(advertising_recipient_not_known_minor_is_not_prohibited_atom, fail) :-
    dsa_art_28_minors_order_profile_for(profiled_advertising_recipient_not_known_minor, Profile),
    art_28_2_advertising_status(Profile, art_28_2_presentation_prohibited, _, _).
test(inadequate_measures_do_not_comply, fail) :-
    dsa_art_28_minors_order_assess(medium_provider_accessible_platform_measures_inadequate, dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_complied, _)).
test(recipient_not_known_minor_is_not_breached, fail) :-
    dsa_art_28_minors_order_assess(profiled_advertising_recipient_not_known_minor, dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_breached, _)).
test(small_enterprise_designated_is_not_left_unengaged, fail) :-
    dsa_art_28_minors_order_assess(small_enterprise_stated_designated, dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_not_engaged, _)).
test(past_twelve_months_is_not_left_unengaged, fail) :-
    dsa_art_28_minors_order_assess(provider_past_twelve_months_medium_enterprise, dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_not_engaged, _)).
test(empty_profile_is_not_final, fail) :-
    dsa_art_28_minors_order_status_values(StatusValues),
    dsa_art_28_minors_order_assess(empty_profile, dsa_art_28_minors_order_verdict(Status, _)),
    member(Status, StatusValues).
test(unsure_measures_are_not_compliance, fail) :-
    dsa_art_28_minors_order_assess(measures_judgement_unsure, dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_complied, _)).
test(unsure_awareness_is_not_a_breach, fail) :-
    dsa_art_28_minors_order_assess(awareness_judgement_unsure, dsa_art_28_minors_order_verdict(dsa_art_28_minors_order_breached, _)).
test(duplicate_key_is_not_also_wrong_type, fail) :-
    dsa_art_28_minors_order_assess(profile_with_duplicate_key, dsa_art_28_minors_order_verdict(input_problems([wrong_type(provider_qualifies_as_micro_or_small_enterprise)]), _)).

cp_test_names([checklist_and_resolvable_hold_on_the_baseline_fixture, the_public_interface_resolves_on_the_baseline_fixture, every_subject_gets_exactly_one_verdict, every_subject_is_resolvable_with_a_four_row_checklist, status_projection_agrees_with_the_verdict, section_3_applies_to_a_medium_provider, section_3_applies_to_a_designated_provider_with_an_empty_basis, section_3_does_not_apply_to_a_small_enterprise_stated_not_designated, section_3_designation_not_shown_is_referred_on, section_3_names_the_absent_run_off_fact, section_3_reports_input_problems, section_3_basis_copies_url_evidence_as_supplied, section_3_basis_copies_document_evidence_as_supplied, the_evidence_and_provenance_constructors_build_and_destructure, obligation_applies_to_an_accessible_platform_in_section_3, obligation_does_not_apply_to_a_platform_not_accessible, obligation_not_applicable_outside_section_3_does_not_copy_the_basis, obligation_names_accessibility_on_an_empty_profile, obligation_unsure_accessibility_goes_to_a_lawyer, compliance_adequate_measures_are_compliant, compliance_inadequate_measures_are_not_compliant, compliance_measures_not_required_without_the_obligation, compliance_names_the_absent_run_off_fact, compliance_unsure_measures_go_to_a_lawyer, advertising_to_a_known_minor_is_prohibited, advertising_recipient_not_known_minor_is_not_prohibited, advertising_outside_section_3_is_not_prohibited_with_the_same_sets, advertising_names_the_first_absent_element, advertising_unsure_awareness_goes_to_a_lawyer, adequate_measures_comply, adequate_measures_checklist, adequate_measures_cite_all_four_provisions, inadequate_measures_breach, inadequate_measures_checklist, checklist_items_carry_their_fixed_citations, platform_not_accessible_is_not_engaged, platform_not_accessible_checklist, profiled_advertising_to_a_known_minor_breaches, profiled_advertising_to_a_known_minor_checklist, recipient_not_known_minor_is_not_engaged, recipient_not_known_minor_checklist, small_enterprise_not_designated_is_not_engaged, small_enterprise_not_designated_checklist, small_enterprise_designated_breaches, small_enterprise_designated_checklist, within_twelve_months_not_designated_is_not_engaged, within_twelve_months_not_designated_checklist, past_twelve_months_complies, past_twelve_months_checklist, designation_not_shown_is_referred_on, designation_not_shown_has_no_citations, designation_not_shown_checklist, designated_with_enterprise_facts_absent_complies, designated_with_enterprise_facts_absent_checklist, empty_profile_names_accessibility_first, empty_profile_checklist, run_off_fact_absent_is_named, run_off_fact_absent_checklist, unsure_accessibility_goes_to_a_lawyer, unsure_accessibility_checklist, unsure_measures_go_to_a_lawyer, unsure_profiling_goes_to_a_lawyer, unsure_profiling_checklist, unsure_awareness_goes_to_a_lawyer, unknown_key_is_an_input_problem, unknown_key_checklist, wrong_type_is_an_input_problem, duplicate_key_is_an_input_problem, an_unbound_profile_gets_one_input_problem_verdict]).
cp_test_fail_names([section_3_small_enterprise_not_designated_is_not_applies, obligation_outside_section_3_is_not_applies, compliance_inadequate_measures_are_not_compliant_atom, advertising_recipient_not_known_minor_is_not_prohibited_atom, inadequate_measures_do_not_comply, recipient_not_known_minor_is_not_breached, small_enterprise_designated_is_not_left_unengaged, past_twelve_months_is_not_left_unengaged, empty_profile_is_not_final, unsure_measures_are_not_compliance, unsure_awareness_is_not_a_breach, duplicate_key_is_not_also_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
