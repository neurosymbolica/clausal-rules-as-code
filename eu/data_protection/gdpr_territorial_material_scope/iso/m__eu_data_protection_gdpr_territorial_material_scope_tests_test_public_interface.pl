% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_queries, [decide_gdpr_scope/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_applies, [gdpr_applies/2, scope_outside_facts/2, decide_gdpr_applies/2, gdpr_applies_status/2, gdpr_applies_checklist/2, gdpr_applies_decision_resolvable/1, gdpr_applies_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_scope_ground, [gdpr_scope_ground/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_representative_requirement, [representative_requirement/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_fixtures, [gdpr_territorial_material_scope_subject/1, gdpr_territorial_material_scope_profile_for/2, gdpr_territorial_material_scope_assess/2]).

test(eu_controller_in_context_applies_under_art_3_1) :-
    gdpr_territorial_material_scope_assess(eu_controller_in_context, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_1, not_applicable, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_1)]).
test(missing_establishment_context_does_not_apply) :-
    gdpr_territorial_material_scope_assess(eu_controller_context_lacking, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art3_not_met, not_applicable, [cite(eu_reg_2016_679_art_3_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_3_3)]).
test(non_eu_offering_applies_and_requires_a_representative) :-
    gdpr_territorial_material_scope_assess(non_eu_offering, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_2_a, required, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_27_1)]).
test(non_eu_without_targeting_does_not_apply) :-
    gdpr_territorial_material_scope_assess(non_eu_no_targeting, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art3_not_met, not_applicable, [cite(eu_reg_2016_679_art_3_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_3_3)]).
test(non_eu_monitoring_applies_under_art_3_2_b) :-
    gdpr_territorial_material_scope_assess(non_eu_monitoring, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_2_b, required, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_27_1)]).
test(occasional_processing_is_exempt_under_art_27_2_a) :-
    gdpr_territorial_material_scope_assess(non_eu_offering_occasional_exempt, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_2_a, exempt_art27_2_a, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_27_1), cite(eu_reg_2016_679_art_27_2_a)]).
test(large_scale_data_defeats_the_exemption) :-
    gdpr_territorial_material_scope_assess(non_eu_offering_large_scale, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_2_a, required, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_27_1)]).
test(a_public_authority_is_exempt_under_art_27_2_b) :-
    gdpr_territorial_material_scope_assess(non_eu_offering_public_authority, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_2_a, exempt_art27_2_b, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_27_1), cite(eu_reg_2016_679_art_27_2_b)]).
test(an_unsure_exemption_judgement_refers_the_representative_only) :-
    gdpr_territorial_material_scope_assess(non_eu_offering_occasional_unsure, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_2_a, needs_legal_review(open_textured(occasional_processing, cite(eu_reg_2016_679_art_27_2_a)), [inputs_relied_on([occasional_processing - unsure, special_or_criminal_data_on_large_scale - false, unlikely_to_result_in_risk - true])]), [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_27_2_a)]).
test(an_attested_public_international_law_place_applies_under_art_3_3) :-
    gdpr_territorial_material_scope_assess(public_international_law_place, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_3, not_applicable, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_3)]).
test(an_absent_outside_fact_refers_to_a_lawyer) :-
    gdpr_territorial_material_scope_assess(public_international_law_not_attested, Verdict),
    Verdict == gdpr_scope_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_3_3), cite(public_international_law_member_state_law_applies)), [resolution(cite(public_international_law_member_state_law_applies), not_attempted), inputs_relied_on([party_role - controller, established_in_union - false])]), none, not_reached, [cite(eu_reg_2016_679_art_3_3), cite(public_international_law_member_state_law_applies)]).
test(a_processor_does_not_meet_art_3_3) :-
    gdpr_territorial_material_scope_assess(processor_in_law_place, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art3_not_met, not_applicable, [cite(eu_reg_2016_679_art_3_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_3_3)]).
test(activity_outside_union_law_is_excluded) :-
    gdpr_territorial_material_scope_assess(outside_union_law, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art2_2_a, not_applicable, [cite(eu_reg_2016_679_art_2_2_a)]).
test(member_state_security_activity_is_excluded) :-
    gdpr_territorial_material_scope_assess(member_state_security_activity, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art2_2_b, not_applicable, [cite(eu_reg_2016_679_art_2_2_b)]).
test(household_processing_by_a_natural_person_is_excluded) :-
    gdpr_territorial_material_scope_assess(household_processing, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art2_2_c, not_applicable, [cite(eu_reg_2016_679_art_2_2_c)]).
test(an_unsure_household_judgement_refers_to_a_lawyer) :-
    gdpr_territorial_material_scope_assess(household_processing_unsure, Verdict),
    Verdict == gdpr_scope_verdict(needs_legal_review(open_textured(purely_personal_or_household_activity, cite(eu_reg_2016_679_art_2_2_c)), [inputs_relied_on([purely_personal_or_household_activity - unsure])]), none, not_reached, [cite(eu_reg_2016_679_art_2_2_c)]).
test(a_legal_person_is_never_within_the_household_exclusion) :-
    gdpr_territorial_material_scope_assess(legal_person_household_claim, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_1, not_applicable, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_1)]).
test(law_enforcement_by_a_competent_authority_is_excluded) :-
    gdpr_territorial_material_scope_assess(law_enforcement_authority, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art2_2_d, not_applicable, [cite(eu_reg_2016_679_art_2_2_d)]).
test(an_authority_with_another_purpose_is_not_excluded) :-
    gdpr_territorial_material_scope_assess(authority_other_purpose, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_1, not_applicable, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_1)]).
test(a_union_institution_is_taken_out_by_art_2_3) :-
    gdpr_territorial_material_scope_assess(union_institution, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art2_3, not_applicable, [cite(eu_reg_2016_679_art_2_3)]).
test(no_personal_data_fails_art_2_1) :-
    gdpr_territorial_material_scope_assess(no_personal_data, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art2_1_not_met, not_applicable, [cite(eu_reg_2016_679_art_2_1)]).
test(manual_processing_outside_a_filing_system_fails_art_2_1) :-
    gdpr_territorial_material_scope_assess(manual_without_filing_system, Verdict),
    Verdict == gdpr_scope_verdict(does_not_apply, art2_1_not_met, not_applicable, [cite(eu_reg_2016_679_art_2_1)]).
test(manual_processing_in_a_filing_system_applies) :-
    gdpr_territorial_material_scope_assess(manual_in_filing_system, Verdict),
    Verdict == gdpr_scope_verdict(applies, art3_1, not_applicable, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_1)]).
test(a_missing_exclusion_flag_is_indeterminate) :-
    gdpr_territorial_material_scope_assess(exclusion_flag_missing, Verdict),
    Verdict == gdpr_scope_verdict(indeterminate([activity_outside_union_law]), none, not_reached, [cite(eu_reg_2016_679_art_2_2_a), cite(eu_reg_2016_679_art_2_2_b), cite(eu_reg_2016_679_art_2_2_c), cite(eu_reg_2016_679_art_2_2_d), cite(eu_reg_2016_679_art_2_3)]).
test(an_unknown_key_is_an_input_problem) :-
    gdpr_territorial_material_scope_assess(unknown_key_given, Verdict),
    Verdict == gdpr_scope_verdict(input_problems([unknown_key(place_of_processing)]), none, not_reached, []).
test(a_wrongly_typed_value_is_an_input_problem) :-
    gdpr_territorial_material_scope_assess(wrong_type_given, Verdict),
    Verdict == gdpr_scope_verdict(input_problems([wrong_type(established_in_union)]), none, not_reached, []).
test(every_fixture_subject_has_exactly_one_verdict) :-
    gdpr_territorial_material_scope_subject(Subject),
    gdpr_territorial_material_scope_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_scope(Profile, Verdict), Verdicts),
    length(Verdicts, 1).
test(the_three_fields_agree_with_the_package_verdict) :-
    gdpr_territorial_material_scope_profile_for(non_eu_offering, Profile),
    gdpr_applies(Profile, applies),
    gdpr_scope_ground(Profile, art3_2_a),
    representative_requirement(Profile, required).
test(the_status_projection_and_vocabulary) :-
    gdpr_territorial_material_scope_profile_for(eu_controller_in_context, Profile),
    gdpr_applies_status(Profile, Status),
    gdpr_applies_status_values(StatusValues),
    member(Status, StatusValues),
    Status == applies.
test(the_checklist_is_not_empty_and_carries_citations) :-
    gdpr_territorial_material_scope_profile_for(eu_controller_in_context, Profile),
    gdpr_applies_decision_resolvable(Profile),
    gdpr_applies_checklist(Profile, [item(_Id, _Status, cite(_Key))|_Items]).
test(the_applies_verdict_carries_its_citations) :-
    gdpr_territorial_material_scope_profile_for(eu_controller_in_context, Profile),
    decide_gdpr_applies(Profile, gdpr_applies_verdict(applies, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_1)])).
test(the_attested_outside_fact_is_copied_as_given) :-
    gdpr_territorial_material_scope_profile_for(public_international_law_place, Profile),
    scope_outside_facts(Profile, [outside_fact(member_state_law_applies_by_public_international_law, attested(true, attestation(decision_layer, fixture_time, fixture_reason, none)))]).
test(an_absent_outside_fact_is_reported_absent) :-
    gdpr_territorial_material_scope_profile_for(public_international_law_not_attested, Profile),
    scope_outside_facts(Profile, [outside_fact(member_state_law_applies_by_public_international_law, absent)]).
test(outside_facts_give_the_input_problems_for_a_bad_profile) :-
    gdpr_territorial_material_scope_profile_for(unknown_key_given, Profile),
    scope_outside_facts(Profile, input_problems([unknown_key(place_of_processing)])).

test(the_near_miss_does_not_get_the_positive_verdict, fail) :-
    gdpr_territorial_material_scope_profile_for(non_eu_no_targeting, Profile),
    gdpr_applies(Profile, applies).

cp_test_names([eu_controller_in_context_applies_under_art_3_1, missing_establishment_context_does_not_apply, non_eu_offering_applies_and_requires_a_representative, non_eu_without_targeting_does_not_apply, non_eu_monitoring_applies_under_art_3_2_b, occasional_processing_is_exempt_under_art_27_2_a, large_scale_data_defeats_the_exemption, a_public_authority_is_exempt_under_art_27_2_b, an_unsure_exemption_judgement_refers_the_representative_only, an_attested_public_international_law_place_applies_under_art_3_3, an_absent_outside_fact_refers_to_a_lawyer, a_processor_does_not_meet_art_3_3, activity_outside_union_law_is_excluded, member_state_security_activity_is_excluded, household_processing_by_a_natural_person_is_excluded, an_unsure_household_judgement_refers_to_a_lawyer, a_legal_person_is_never_within_the_household_exclusion, law_enforcement_by_a_competent_authority_is_excluded, an_authority_with_another_purpose_is_not_excluded, a_union_institution_is_taken_out_by_art_2_3, no_personal_data_fails_art_2_1, manual_processing_outside_a_filing_system_fails_art_2_1, manual_processing_in_a_filing_system_applies, a_missing_exclusion_flag_is_indeterminate, an_unknown_key_is_an_input_problem, a_wrongly_typed_value_is_an_input_problem, every_fixture_subject_has_exactly_one_verdict, the_three_fields_agree_with_the_package_verdict, the_status_projection_and_vocabulary, the_checklist_is_not_empty_and_carries_citations, the_applies_verdict_carries_its_citations, the_attested_outside_fact_is_copied_as_given, an_absent_outside_fact_is_reported_absent, outside_facts_give_the_input_problems_for_a_bad_profile]).
cp_test_fail_names([the_near_miss_does_not_get_the_positive_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
