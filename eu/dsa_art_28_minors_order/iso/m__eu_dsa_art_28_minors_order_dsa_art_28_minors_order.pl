% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_dsa_art_28_minors_order, [section_3_application_status/4, art_28_1_obligation_status/4, art_28_1_compliance_status/4, art_28_2_advertising_status/4, section_3_applies/0, section_3_not_applicable/0, art_28_1_obligation_applies/0, art_28_1_obligation_not_applicable/0, art_28_1_measures_compliant/0, art_28_1_measures_not_compliant/0, art_28_1_measures_not_required/0, art_28_2_presentation_prohibited/0, art_28_2_presentation_not_prohibited/0, decide_dsa_art_28_minors_order/2, dsa_art_28_minors_order_status/2, dsa_art_28_minors_order_checklist/2, dsa_art_28_minors_order_decision_resolvable/1, dsa_art_28_minors_order_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dsa_art_28_minors_order_kernel, [dsa_art_28_minors_order_input_problems/2]).
:- use_module(m__eu_dsa_art_28_minors_order_citations, [implements/1]).

section_3_applies.

section_3_not_applicable.

art_28_1_obligation_applies.

art_28_1_obligation_not_applicable.

art_28_1_measures_compliant.

art_28_1_measures_not_compliant.

art_28_1_measures_not_required.

art_28_2_presentation_prohibited.

art_28_2_presentation_not_prohibited.

result_citations(section_3_applies, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]).
result_citations(section_3_not_applicable, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]).
result_citations(art_28_1_obligation_applies, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
result_citations(art_28_1_obligation_not_applicable, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
result_citations(art_28_1_measures_compliant, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
result_citations(art_28_1_measures_not_compliant, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
result_citations(art_28_1_measures_not_required, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
result_citations(art_28_2_presentation_prohibited, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)]).
result_citations(art_28_2_presentation_not_prohibited, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)]).

open_textured_citation(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)).
open_textured_citation(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, cite(eu_reg_2022_2065_art_28_1)).
open_textured_citation(advertisements_based_on_profiling_of_recipient, cite(eu_reg_2022_2065_art_28_2)).
open_textured_citation(aware_with_reasonable_certainty_recipient_is_minor, cite(eu_reg_2022_2065_art_28_2)).

overall_citations([cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1), cite(eu_reg_2022_2065_art_28_2)]).

dsa_art_28_minors_order_status_values([dsa_art_28_minors_order_breached, dsa_art_28_minors_order_complied, dsa_art_28_minors_order_not_engaged]).

key_reading(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_reading(Profile, ProfileKey, Value) :-
    profile_get(Profile, ProfileKey, Value).

first_key_with(Wanted, [FoundKey|_], [Wanted|_], FoundKey).
first_key_with(Wanted, [_|ElementKeys], [ElementValue|ElementValues], FoundKey) :-
    dif(ElementValue, Wanted),
    first_key_with(Wanted, ElementKeys, ElementValues, FoundKey).

judgement_not_false(true).
judgement_not_false(unsure).
judgement_not_false(absent).

judgement_true_or_unsure(true).
judgement_true_or_unsure(unsure).

judgement_present(true).
judgement_present(false).
judgement_present(unsure).

section_state(section_3_applies, applies).
section_state(section_3_not_applicable, not_applicable).
section_state(indeterminate(MissingKeys), missing(MissingKeys)).
section_state(needs_legal_review(_, _), referral).

section_state_open(applies).
section_state_open(missing(_)).
section_state_open(referral).

designation_referral(Pairs, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2022_2065_art_19_2).

open_textured_referral(Input, Pairs, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)])) :-
    open_textured_citation(Input, Citation).

section_3_application_status(Profile, Result, Basis, Citations) :-
    dsa_art_28_minors_order_input_problems(Profile, Problems),
    section_3_answer(Problems, Profile, Result, Basis, Citations).

section_3_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
section_3_answer([], Profile, Result, Basis, Citations) :-
    section_3_decided(Profile, Result, Basis, Citations).

art_28_1_obligation_status(Profile, Result, Basis, Citations) :-
    dsa_art_28_minors_order_input_problems(Profile, Problems),
    obligation_answer(Problems, Profile, Result, Basis, Citations).

obligation_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
obligation_answer([], Profile, Result, Basis, Citations) :-
    obligation_decided(Profile, Result, Basis, Citations).

art_28_1_compliance_status(Profile, Result, Basis, Citations) :-
    dsa_art_28_minors_order_input_problems(Profile, Problems),
    compliance_answer(Problems, Profile, Result, Basis, Citations).

compliance_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
compliance_answer([], Profile, Result, Basis, Citations) :-
    compliance_decided(Profile, Result, Basis, Citations).

art_28_2_advertising_status(Profile, Result, Basis, Citations) :-
    dsa_art_28_minors_order_input_problems(Profile, Problems),
    advertising_answer(Problems, Profile, Result, Basis, Citations).

advertising_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
advertising_answer([], Profile, Result, Basis, Citations) :-
    advertising_decided(Profile, Result, Basis, Citations).

section_3_decided(Profile, Result, Basis, Citations) :-
    key_reading(Profile, provider_qualifies_as_micro_or_small_enterprise, QualifiesReading),
    key_reading(Profile, provider_within_12_months_after_losing_micro_or_small_status, WithinReading),
    key_reading(Profile, designated_as_very_large_online_platform, DesignationReading),
    exempt_state(QualifiesReading, WithinReading, ExemptState),
    designation_state(DesignationReading, DesignationState),
    section_3_route(ExemptState, DesignationState, Result, Basis, Citations).

exempt_state(QualifiesReading, WithinReading, ExemptState) :-
    implements(eu_reg_2022_2065_art_19_1),
    memberd_t(true, [QualifiesReading, WithinReading], HasTrue),
    exempt_after_true(HasTrue, [QualifiesReading, WithinReading], ExemptState).

exempt_after_true(true, _, exempt_qualified) :-
    implements(eu_reg_2022_2065_art_19_1).
exempt_after_true(false, Readings, ExemptState) :-
    implements(eu_reg_2022_2065_art_19_1),
    memberd_t(absent, Readings, HasAbsent),
    exempt_after_absent(HasAbsent, Readings, ExemptState).

exempt_after_absent(false, _, not_exempt) :-
    implements(eu_reg_2022_2065_art_19_1).
exempt_after_absent(true, Readings, missing(MissingKey)) :-
    implements(eu_reg_2022_2065_art_19_1),
    first_key_with(absent, [provider_qualifies_as_micro_or_small_enterprise, provider_within_12_months_after_losing_micro_or_small_status], Readings, MissingKey).

designation_state(absent, absent) :-
    implements(eu_reg_2022_2065_art_19_2).
designation_state(attested(true, _), designated) :-
    implements(eu_reg_2022_2065_art_19_2).
designation_state(attested(false, Attestation), not_designated(attested(false, Attestation))) :-
    implements(eu_reg_2022_2065_art_19_2).

section_3_route(not_exempt, _, section_3_applies, [], Citations) :-
    implements(eu_reg_2022_2065_art_19_1),
    result_citations(section_3_applies, Citations).
section_3_route(exempt_qualified, designated, section_3_applies, [], Citations) :-
    implements(eu_reg_2022_2065_art_19_2),
    result_citations(section_3_applies, Citations).
section_3_route(missing(_), designated, section_3_applies, [], Citations) :-
    implements(eu_reg_2022_2065_art_19_2),
    result_citations(section_3_applies, Citations).
section_3_route(exempt_qualified, not_designated(Attested), section_3_not_applicable, [outside_fact(designated_as_very_large_online_platform, Attested)], Citations) :-
    implements(eu_reg_2022_2065_art_19_1),
    result_citations(section_3_not_applicable, Citations).
section_3_route(exempt_qualified, absent, Result, [], []) :-
    implements(eu_reg_2022_2065_art_19_2),
    designation_referral([designated_as_very_large_online_platform - absent], Result).
section_3_route(missing(MissingKey), not_designated(_), indeterminate([MissingKey]), [], []) :-
    implements(eu_reg_2022_2065_art_19_1).
section_3_route(missing(MissingKey), absent, indeterminate([MissingKey]), [], []) :-
    implements(eu_reg_2022_2065_art_19_1).

obligation_decided(Profile, Result, Basis, Citations) :-
    key_reading(Profile, platform_accessible_to_minors, AccessibleReading),
    section_3_decided(Profile, SectionResult, _SectionBasis, _SectionCitations),
    section_state(SectionResult, SectionState),
    obligation_route(AccessibleReading, SectionState, Result, Basis, Citations).

obligation_route(false, _, art_28_1_obligation_not_applicable, [], Citations) :-
    implements(eu_reg_2022_2065_art_28_1),
    result_citations(art_28_1_obligation_not_applicable, Citations).
obligation_route(AccessibleReading, not_applicable, art_28_1_obligation_not_applicable, [], Citations) :-
    implements(eu_reg_2022_2065_art_19_1),
    judgement_not_false(AccessibleReading),
    result_citations(art_28_1_obligation_not_applicable, Citations).
obligation_route(true, applies, art_28_1_obligation_applies, [], Citations) :-
    implements(eu_reg_2022_2065_art_28_1),
    result_citations(art_28_1_obligation_applies, Citations).
obligation_route(absent, SectionState, indeterminate([platform_accessible_to_minors]), [], []) :-
    implements(eu_reg_2022_2065_art_28_1),
    section_state_open(SectionState).
obligation_route(AccessibleReading, missing(MissingKeys), indeterminate(MissingKeys), [], []) :-
    implements(eu_reg_2022_2065_art_19_1),
    judgement_true_or_unsure(AccessibleReading).
obligation_route(AccessibleReading, referral, Result, [], []) :-
    implements(eu_reg_2022_2065_art_19_2),
    judgement_true_or_unsure(AccessibleReading),
    designation_referral([platform_accessible_to_minors - AccessibleReading, designated_as_very_large_online_platform - absent], Result).
obligation_route(unsure, applies, Result, [], []) :-
    implements(eu_reg_2022_2065_art_28_1),
    open_textured_referral(platform_accessible_to_minors, [platform_accessible_to_minors - unsure], Result).

compliance_decided(Profile, Result, Basis, Citations) :-
    key_reading(Profile, platform_accessible_to_minors, AccessibleReading),
    key_reading(Profile, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, MeasuresReading),
    obligation_decided(Profile, ObligationResult, _ObligationBasis, _ObligationCitations),
    obligation_state(ObligationResult, ObligationState),
    compliance_route(ObligationState, MeasuresReading, AccessibleReading, Result, Basis, Citations).

obligation_state(art_28_1_obligation_applies, applies).
obligation_state(art_28_1_obligation_not_applicable, not_applicable).
obligation_state(indeterminate(MissingKeys), missing(MissingKeys)).
obligation_state(needs_legal_review(cross_reference_unresolved(_, _), _), cross_referral).
obligation_state(needs_legal_review(open_textured(_, _), _), open_referral).

compliance_route(not_applicable, _, _, art_28_1_measures_not_required, [], Citations) :-
    implements(eu_reg_2022_2065_art_28_1),
    result_citations(art_28_1_measures_not_required, Citations).
compliance_route(applies, true, _, art_28_1_measures_compliant, [], Citations) :-
    implements(eu_reg_2022_2065_art_28_1),
    result_citations(art_28_1_measures_compliant, Citations).
compliance_route(applies, false, _, art_28_1_measures_not_compliant, [], Citations) :-
    implements(eu_reg_2022_2065_art_28_1),
    result_citations(art_28_1_measures_not_compliant, Citations).
compliance_route(missing(MissingKeys), _, _, indeterminate(MissingKeys), [], []) :-
    implements(eu_reg_2022_2065_art_28_1).
compliance_route(applies, absent, _, indeterminate([measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors]), [], []) :-
    implements(eu_reg_2022_2065_art_28_1).
compliance_route(cross_referral, absent, _, indeterminate([measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors]), [], []) :-
    implements(eu_reg_2022_2065_art_28_1).
compliance_route(open_referral, absent, _, indeterminate([measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors]), [], []) :-
    implements(eu_reg_2022_2065_art_28_1).
compliance_route(cross_referral, MeasuresReading, AccessibleReading, Result, [], []) :-
    implements(eu_reg_2022_2065_art_19_2),
    judgement_present(MeasuresReading),
    designation_referral([platform_accessible_to_minors - AccessibleReading, designated_as_very_large_online_platform - absent, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - MeasuresReading], Result).
compliance_route(open_referral, MeasuresReading, _, Result, [], []) :-
    implements(eu_reg_2022_2065_art_28_1),
    judgement_present(MeasuresReading),
    open_textured_referral(platform_accessible_to_minors, [platform_accessible_to_minors - unsure, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - MeasuresReading], Result).
compliance_route(applies, unsure, _, Result, [], []) :-
    implements(eu_reg_2022_2065_art_28_1),
    open_textured_referral(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, [platform_accessible_to_minors - true, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors - unsure], Result).

advertising_decided(Profile, Result, Basis, Citations) :-
    key_reading(Profile, advertisements_presented_to_recipient_on_interface, PresentedReading),
    key_reading(Profile, advertisements_based_on_profiling_of_recipient, ProfilingReading),
    key_reading(Profile, aware_with_reasonable_certainty_recipient_is_minor, AwarenessReading),
    elements_state([advertisements_presented_to_recipient_on_interface, advertisements_based_on_profiling_of_recipient, aware_with_reasonable_certainty_recipient_is_minor], [PresentedReading, ProfilingReading, AwarenessReading], ElementState),
    section_3_decided(Profile, SectionResult, _SectionBasis, _SectionCitations),
    section_state(SectionResult, SectionState),
    advertising_route(ElementState, SectionState, ProfilingReading, AwarenessReading, Result, Basis, Citations).

elements_state(ElementKeys, ElementValues, ElementState) :-
    implements(eu_reg_2022_2065_art_28_2),
    memberd_t(false, ElementValues, HasFalse),
    elements_after_false(HasFalse, ElementKeys, ElementValues, ElementState).

elements_after_false(true, _, _, some_false) :-
    implements(eu_reg_2022_2065_art_28_2).
elements_after_false(false, ElementKeys, ElementValues, ElementState) :-
    implements(eu_reg_2022_2065_art_28_2),
    memberd_t(absent, ElementValues, HasAbsent),
    elements_after_absent(HasAbsent, ElementKeys, ElementValues, ElementState).

elements_after_absent(true, ElementKeys, ElementValues, first_absent(MissingKey)) :-
    implements(eu_reg_2022_2065_art_28_2),
    first_key_with(absent, ElementKeys, ElementValues, MissingKey).
elements_after_absent(false, ElementKeys, ElementValues, ElementState) :-
    implements(eu_reg_2022_2065_art_28_2),
    memberd_t(unsure, ElementValues, HasUnsure),
    elements_after_unsure(HasUnsure, ElementKeys, ElementValues, ElementState).

elements_after_unsure(false, _, _, all_true) :-
    implements(eu_reg_2022_2065_art_28_2).
elements_after_unsure(true, ElementKeys, ElementValues, first_unsure(UnsureKey)) :-
    implements(eu_reg_2022_2065_art_28_2),
    first_key_with(unsure, ElementKeys, ElementValues, UnsureKey).

elements_not_false(first_absent(_)).
elements_not_false(all_true).
elements_not_false(first_unsure(_)).

elements_present(all_true).
elements_present(first_unsure(_)).

advertising_route(some_false, _, _, _, art_28_2_presentation_not_prohibited, [], Citations) :-
    implements(eu_reg_2022_2065_art_28_2),
    result_citations(art_28_2_presentation_not_prohibited, Citations).
advertising_route(ElementState, not_applicable, _, _, art_28_2_presentation_not_prohibited, [], Citations) :-
    implements(eu_reg_2022_2065_art_19_1),
    elements_not_false(ElementState),
    result_citations(art_28_2_presentation_not_prohibited, Citations).
advertising_route(all_true, applies, _, _, art_28_2_presentation_prohibited, [], Citations) :-
    implements(eu_reg_2022_2065_art_28_2),
    result_citations(art_28_2_presentation_prohibited, Citations).
advertising_route(first_absent(MissingKey), SectionState, _, _, indeterminate([MissingKey]), [], []) :-
    implements(eu_reg_2022_2065_art_28_2),
    section_state_open(SectionState).
advertising_route(ElementState, missing(MissingKeys), _, _, indeterminate(MissingKeys), [], []) :-
    implements(eu_reg_2022_2065_art_19_1),
    elements_present(ElementState).
advertising_route(ElementState, referral, ProfilingReading, AwarenessReading, Result, [], []) :-
    implements(eu_reg_2022_2065_art_19_2),
    elements_present(ElementState),
    designation_referral([advertisements_based_on_profiling_of_recipient - ProfilingReading, aware_with_reasonable_certainty_recipient_is_minor - AwarenessReading, designated_as_very_large_online_platform - absent], Result).
advertising_route(first_unsure(UnsureKey), applies, ProfilingReading, AwarenessReading, Result, [], []) :-
    implements(eu_reg_2022_2065_art_28_2),
    open_textured_referral(UnsureKey, [advertisements_based_on_profiling_of_recipient - ProfilingReading, aware_with_reasonable_certainty_recipient_is_minor - AwarenessReading], Result).

decide_dsa_art_28_minors_order(Profile, dsa_art_28_minors_order_verdict(Status, Citations)) :-
    art_28_1_compliance_status(Profile, ComplianceResult, _ComplianceBasis, _ComplianceCitations),
    art_28_2_advertising_status(Profile, AdvertisingResult, _AdvertisingBasis, _AdvertisingCitations),
    compliance_class(ComplianceResult, ComplianceClass),
    advertising_class(AdvertisingResult, AdvertisingClass),
    overall_verdict(ComplianceClass, AdvertisingClass, Status, Citations).

compliance_class(art_28_1_measures_not_compliant, breach).
compliance_class(art_28_1_measures_compliant, compliant).
compliance_class(art_28_1_measures_not_required, not_required).
compliance_class(indeterminate(MissingKeys), pending(indeterminate(MissingKeys))).
compliance_class(needs_legal_review(Reason, Context), pending(needs_legal_review(Reason, Context))).
compliance_class(input_problems(Problems), pending(input_problems(Problems))).

advertising_class(art_28_2_presentation_prohibited, breach).
advertising_class(art_28_2_presentation_not_prohibited, clear).
advertising_class(indeterminate(MissingKeys), pending(indeterminate(MissingKeys))).
advertising_class(needs_legal_review(Reason, Context), pending(needs_legal_review(Reason, Context))).
advertising_class(input_problems(Problems), pending(input_problems(Problems))).

compliance_not_breach(compliant).
compliance_not_breach(not_required).
compliance_not_breach(pending(_)).

overall_verdict(breach, _, dsa_art_28_minors_order_breached, Citations) :-
    implements(eu_reg_2022_2065_art_28_1),
    overall_citations(Citations).
overall_verdict(ComplianceClass, breach, dsa_art_28_minors_order_breached, Citations) :-
    implements(eu_reg_2022_2065_art_28_2),
    compliance_not_breach(ComplianceClass),
    overall_citations(Citations).
overall_verdict(compliant, clear, dsa_art_28_minors_order_complied, Citations) :-
    implements(eu_reg_2022_2065_art_28_1),
    overall_citations(Citations).
overall_verdict(not_required, clear, dsa_art_28_minors_order_not_engaged, Citations) :-
    implements(eu_reg_2022_2065_art_28_1),
    overall_citations(Citations).
overall_verdict(pending(Result), clear, Result, []).
overall_verdict(pending(Result), pending(_), Result, []).
overall_verdict(compliant, pending(Result), Result, []).
overall_verdict(not_required, pending(Result), Result, []).

dsa_art_28_minors_order_status(Profile, Status) :-
    decide_dsa_art_28_minors_order(Profile, dsa_art_28_minors_order_verdict(Status, _Citations)).

dsa_art_28_minors_order_checklist(Profile, [item(section_3_application, SectionResult, SectionCitations), item(art_28_1_obligation, ObligationResult, ObligationCitations), item(art_28_1_compliance, ComplianceResult, ComplianceCitations), item(art_28_2_advertising, AdvertisingResult, AdvertisingCitations)]) :-
    section_3_application_status(Profile, SectionResult, _SectionBasis, SectionCitations),
    art_28_1_obligation_status(Profile, ObligationResult, _ObligationBasis, ObligationCitations),
    art_28_1_compliance_status(Profile, ComplianceResult, _ComplianceBasis, ComplianceCitations),
    art_28_2_advertising_status(Profile, AdvertisingResult, _AdvertisingBasis, AdvertisingCitations).

dsa_art_28_minors_order_decision_resolvable(Profile) :-
    decide_dsa_art_28_minors_order(Profile, _Verdict).

test(a_medium_enterprise_is_in_section_3) :-
    findall(Result - Basis - Citations, section_3_application_status([attribute(provider_qualifies_as_micro_or_small_enterprise, false), attribute(provider_within_12_months_after_losing_micro_or_small_status, false)], Result, Basis, Citations), Answers),
    Answers == [section_3_applies - [] - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]].
test(a_small_enterprise_stated_not_designated_is_outside_section_3) :-
    findall(Result - Basis, section_3_application_status([attribute(provider_qualifies_as_micro_or_small_enterprise, true), attribute(designated_as_very_large_online_platform, attested(false, attestation(host, moment, stated, none)))], Result, Basis, _), Answers),
    Answers == [section_3_not_applicable - [outside_fact(designated_as_very_large_online_platform, attested(false, attestation(host, moment, stated, none)))]].
test(a_designated_platform_is_in_section_3_with_an_empty_basis) :-
    findall(Result - Basis, section_3_application_status([attribute(designated_as_very_large_online_platform, attested(true, attestation(host, moment, stated, none)))], Result, Basis, _), Answers),
    Answers == [section_3_applies - []].
test(a_small_enterprise_without_designation_is_referred) :-
    findall(Result, section_3_application_status([attribute(provider_within_12_months_after_losing_micro_or_small_status, true)], Result, _, _), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform - absent])])].
test(an_empty_profile_names_the_first_enterprise_key) :-
    findall(Result, section_3_application_status([], Result, _, _), Answers),
    Answers == [indeterminate([provider_qualifies_as_micro_or_small_enterprise])].
test(a_platform_not_accessible_to_minors_has_no_obligation) :-
    findall(Result - Citations, art_28_1_obligation_status([attribute(platform_accessible_to_minors, false)], Result, _, Citations), Answers),
    Answers == [art_28_1_obligation_not_applicable - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]].
test(unsure_accessibility_goes_to_a_lawyer) :-
    findall(Result, art_28_1_obligation_status([attribute(platform_accessible_to_minors, unsure), attribute(provider_qualifies_as_micro_or_small_enterprise, false), attribute(provider_within_12_months_after_losing_micro_or_small_status, false)], Result, _, _), Answers),
    Answers == [needs_legal_review(open_textured(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - unsure])])].
test(inadequate_measures_are_not_compliant) :-
    findall(Result, art_28_1_compliance_status([attribute(platform_accessible_to_minors, true), attribute(provider_qualifies_as_micro_or_small_enterprise, false), attribute(provider_within_12_months_after_losing_micro_or_small_status, false), attribute(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, false)], Result, _, _), Answers),
    Answers == [art_28_1_measures_not_compliant].
test(the_measures_key_is_named_before_a_referral) :-
    findall(Result, art_28_1_compliance_status([attribute(platform_accessible_to_minors, true), attribute(provider_qualifies_as_micro_or_small_enterprise, true)], Result, _, _), Answers),
    Answers == [indeterminate([measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors])].
test(profiled_advertising_to_a_known_minor_is_prohibited) :-
    findall(Result - Citations, art_28_2_advertising_status([attribute(advertisements_presented_to_recipient_on_interface, true), attribute(advertisements_based_on_profiling_of_recipient, true), attribute(aware_with_reasonable_certainty_recipient_is_minor, true), attribute(provider_qualifies_as_micro_or_small_enterprise, false), attribute(provider_within_12_months_after_losing_micro_or_small_status, false)], Result, _, Citations), Answers),
    Answers == [art_28_2_presentation_prohibited - [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)]].
test(the_first_absent_element_is_named) :-
    findall(Result, art_28_2_advertising_status([attribute(advertisements_based_on_profiling_of_recipient, unsure)], Result, _, _), Answers),
    Answers == [indeterminate([advertisements_presented_to_recipient_on_interface])].
test(outside_section_3_presentation_is_not_prohibited) :-
    findall(Result - Basis, art_28_2_advertising_status([attribute(advertisements_presented_to_recipient_on_interface, true), attribute(advertisements_based_on_profiling_of_recipient, true), attribute(aware_with_reasonable_certainty_recipient_is_minor, true), attribute(provider_qualifies_as_micro_or_small_enterprise, true), attribute(designated_as_very_large_online_platform, attested(false, attestation(host, moment, stated, none)))], Result, Basis, _), Answers),
    Answers == [art_28_2_presentation_not_prohibited - []].
test(an_unknown_key_is_an_input_problem_for_every_query) :-
    findall(Result, art_28_2_advertising_status([attribute(colour, true)], Result, _, _), Answers),
    Answers == [input_problems([unknown_key(colour)])].
test(prohibited_presentation_is_a_breach) :-
    findall(Status, dsa_art_28_minors_order_status([attribute(platform_accessible_to_minors, false), attribute(advertisements_presented_to_recipient_on_interface, true), attribute(advertisements_based_on_profiling_of_recipient, true), attribute(aware_with_reasonable_certainty_recipient_is_minor, true), attribute(provider_qualifies_as_micro_or_small_enterprise, false), attribute(provider_within_12_months_after_losing_micro_or_small_status, false)], Status), Statuses),
    Statuses == [dsa_art_28_minors_order_breached].

test(a_small_enterprise_stated_not_designated_is_not_in_section_3, fail) :-
    section_3_application_status([attribute(provider_qualifies_as_micro_or_small_enterprise, true), attribute(designated_as_very_large_online_platform, attested(false, attestation(host, moment, stated, none)))], section_3_applies, _, _).
