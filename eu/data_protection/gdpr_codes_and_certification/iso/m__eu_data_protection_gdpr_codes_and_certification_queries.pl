% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_queries, [gdpr_codes_and_certification_profile_keys/1, gdpr_codes_and_certification_what_if/4, gdpr_codes_and_certification_provision/3, gdpr_codes_and_certification_ground_provision/3, gdpr_codes_and_certification_key_read/2, not_yet_issued/0, maximum_period_ended/0, not_issued_by_competent_issuer/0, criteria_not_approved/0, issued_without_informing_supervisory_authority/0, withdrawn/0, withdrawal_required/0, within_maximum_period/0, not_relied_on_for_transfers/0, transfer_conditions_not_met/0, transfer_conditions_met/0, article_41_not_applicable/0, not_a_code_under_article_40_2/0, code_not_approved/0, monitoring_mechanisms_missing/0, no_accredited_monitoring_body/0, not_yet_accredited/0, accreditation_revoked/0, not_accredited_by_entity_named_in_article_43_1/0, accreditation_conditions_not_met/0, revocation_required/0, accreditation_conditions_met/0, take_appropriate_action_on_infringement/0, inform_supervisory_authority_of_actions_and_reasons/0, certification_result/2, code_result/2, monitoring_by_accredited_body/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, input_problems/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_kernel, [gdpr_codes_and_certification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_citations, [citation/2]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_gdpr_codes_and_certification, [gdpr_codes_and_certification_status/2]).

gdpr_codes_and_certification_profile_keys([certification_issuer, certification_body_accredited, certification_criteria_approved, supervisory_authority_informed_before_issue_or_renewal, certification_withdrawn, certification_requirements_not_met, certification_holder_not_subject_to_regulation, certification_holder_binding_commitments_made, processing_by_public_authority_or_body, code_prepared_by_body_representing_controllers_or_processors, code_approved_by_competent_supervisory_authority, code_contains_monitoring_mechanisms, monitoring_body_accredited, code_adhered_to_by_party_not_subject_to_regulation, code_has_general_validity, code_adherent_binding_commitments_made, monitoring_body_accreditation_revoked, monitoring_body_independence_and_expertise_demonstrated, monitoring_body_eligibility_monitoring_and_review_procedures_established, monitoring_body_complaint_procedures_and_structures_established, monitoring_body_no_conflict_of_interests_demonstrated, monitoring_body_actions_infringe_regulation, certification_body_accreditation_revoked, certification_body_accrediting_entity, certification_body_independence_and_expertise_demonstrated, certification_body_undertook_to_respect_approved_criteria, certification_body_issuing_review_and_withdrawal_procedures_established, certification_body_complaint_procedures_and_structures_established, certification_body_no_conflict_of_interests_demonstrated, certification_body_actions_infringe_regulation]).

gdpr_codes_and_certification_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_with_value(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_codes_and_certification_status(Hypothesis, NewStatus).

profile_with_value(Profile, Key, Value, NewProfile) :-
    profile_without_key(Profile, Key, Rest),
    append(Rest, [attribute(Key, Value)], NewProfile).

profile_without_key([], _, []).
profile_without_key([attribute(ElementKey, _)|Elements], Key, Rest) :-
    ElementKey == Key,
    profile_without_key(Elements, Key, Rest).
profile_without_key([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Rest]) :-
    ElementKey \== Key,
    profile_without_key(Elements, Key, Rest).

gdpr_codes_and_certification_provision(CitationKey, Label, Verbatim) :-
    citation(CitationKey, Record),
    member(label - Label, Record),
    member(verbatim - Verbatim, Record).

gdpr_codes_and_certification_ground_provision(Query, Ground, Citation) :-
    ground_provision_row(Query, Ground, Citation).

ground_provision_row(certification_status, not_yet_issued, cite(eu_reg_2016_679_art_42_7)).
ground_provision_row(certification_status, maximum_period_ended, cite(eu_reg_2016_679_art_42_7)).
ground_provision_row(certification_status, not_issued_by_competent_issuer, cite(eu_reg_2016_679_art_42_5)).
ground_provision_row(certification_status, criteria_not_approved, cite(eu_reg_2016_679_art_42_5)).
ground_provision_row(certification_status, issued_without_informing_supervisory_authority, cite(eu_reg_2016_679_art_43_1)).
ground_provision_row(certification_status, withdrawn, cite(eu_reg_2016_679_art_42_7)).
ground_provision_row(certification_status, withdrawal_required, cite(eu_reg_2016_679_art_42_7)).
ground_provision_row(certification_status, within_maximum_period, cite(eu_reg_2016_679_art_42_7)).
ground_provision_row(certification_status, not_relied_on_for_transfers, cite(eu_reg_2016_679_art_42_2)).
ground_provision_row(certification_status, transfer_conditions_not_met, cite(eu_reg_2016_679_art_42_2)).
ground_provision_row(certification_status, transfer_conditions_met, cite(eu_reg_2016_679_art_42_2)).
ground_provision_row(code_monitoring_status, article_41_not_applicable, cite(eu_reg_2016_679_art_41_6)).
ground_provision_row(code_monitoring_status, not_a_code_under_article_40_2, cite(eu_reg_2016_679_art_40_2)).
ground_provision_row(code_monitoring_status, code_not_approved, cite(eu_reg_2016_679_art_40_5)).
ground_provision_row(code_monitoring_status, monitoring_mechanisms_missing, cite(eu_reg_2016_679_art_40_4)).
ground_provision_row(code_monitoring_status, no_accredited_monitoring_body, cite(eu_reg_2016_679_art_41_1)).
ground_provision_row(code_monitoring_status, monitoring_by_accredited_body, cite(eu_reg_2016_679_art_41_4)).
ground_provision_row(code_monitoring_status, not_relied_on_for_transfers, cite(eu_reg_2016_679_art_40_3)).
ground_provision_row(code_monitoring_status, transfer_conditions_not_met, cite(eu_reg_2016_679_art_40_3)).
ground_provision_row(code_monitoring_status, transfer_conditions_met, cite(eu_reg_2016_679_art_40_3)).
ground_provision_row(monitoring_body, not_yet_accredited, cite(eu_reg_2016_679_art_41_2)).
ground_provision_row(monitoring_body, accreditation_revoked, cite(eu_reg_2016_679_art_41_5)).
ground_provision_row(monitoring_body, accreditation_conditions_not_met, cite(eu_reg_2016_679_art_41_2)).
ground_provision_row(monitoring_body, revocation_required, cite(eu_reg_2016_679_art_41_5)).
ground_provision_row(monitoring_body, accreditation_conditions_met, cite(eu_reg_2016_679_art_41_2)).
ground_provision_row(certification_body, not_yet_accredited, cite(eu_reg_2016_679_art_43_4)).
ground_provision_row(certification_body, maximum_period_ended, cite(eu_reg_2016_679_art_43_4)).
ground_provision_row(certification_body, accreditation_revoked, cite(eu_reg_2016_679_art_43_7)).
ground_provision_row(certification_body, not_accredited_by_entity_named_in_article_43_1, cite(eu_reg_2016_679_art_43_1)).
ground_provision_row(certification_body, accreditation_conditions_not_met, cite(eu_reg_2016_679_art_43_2)).
ground_provision_row(certification_body, revocation_required, cite(eu_reg_2016_679_art_43_7)).
ground_provision_row(certification_body, accreditation_conditions_met, cite(eu_reg_2016_679_art_43_2)).

gdpr_codes_and_certification_key_read(Query, Key) :-
    query_keys(Query, Keys),
    member(Key, Keys).

query_keys(certification_status, [certification_issuer, certification_body_accredited, certification_criteria_approved, supervisory_authority_informed_before_issue_or_renewal, certification_withdrawn, certification_requirements_not_met, certification_holder_not_subject_to_regulation, certification_holder_binding_commitments_made]).
query_keys(code_monitoring_status, [processing_by_public_authority_or_body, code_prepared_by_body_representing_controllers_or_processors, code_approved_by_competent_supervisory_authority, code_contains_monitoring_mechanisms, monitoring_body_accredited, code_adhered_to_by_party_not_subject_to_regulation, code_has_general_validity, code_adherent_binding_commitments_made]).
query_keys(monitoring_body, [monitoring_body_accreditation_revoked, monitoring_body_independence_and_expertise_demonstrated, monitoring_body_eligibility_monitoring_and_review_procedures_established, monitoring_body_complaint_procedures_and_structures_established, monitoring_body_no_conflict_of_interests_demonstrated, monitoring_body_actions_infringe_regulation]).
query_keys(certification_body, [certification_body_accreditation_revoked, certification_body_accrediting_entity, certification_body_independence_and_expertise_demonstrated, certification_body_undertook_to_respect_approved_criteria, certification_body_issuing_review_and_withdrawal_procedures_established, certification_body_complaint_procedures_and_structures_established, certification_body_no_conflict_of_interests_demonstrated, certification_body_actions_infringe_regulation]).

not_yet_issued.

maximum_period_ended.

not_issued_by_competent_issuer.

criteria_not_approved.

issued_without_informing_supervisory_authority.

withdrawn.

withdrawal_required.

within_maximum_period.

not_relied_on_for_transfers.

transfer_conditions_not_met.

transfer_conditions_met.

article_41_not_applicable.

not_a_code_under_article_40_2.

code_not_approved.

monitoring_mechanisms_missing.

no_accredited_monitoring_body.

not_yet_accredited.

accreditation_revoked.

not_accredited_by_entity_named_in_article_43_1.

accreditation_conditions_not_met.

revocation_required.

accreditation_conditions_met.

take_appropriate_action_on_infringement.

inform_supervisory_authority_of_actions_and_reasons.

validity_answer(not_yet_issued).
validity_answer(maximum_period_ended).
validity_answer(not_issued_by_competent_issuer).
validity_answer(criteria_not_approved).
validity_answer(issued_without_informing_supervisory_authority).
validity_answer(withdrawn).
validity_answer(withdrawal_required).
validity_answer(within_maximum_period).

transfer_answer(not_relied_on_for_transfers).
transfer_answer(transfer_conditions_not_met).
transfer_answer(transfer_conditions_met).

monitoring_answer(article_41_not_applicable).
monitoring_answer(not_a_code_under_article_40_2).
monitoring_answer(code_not_approved).
monitoring_answer(monitoring_mechanisms_missing).
monitoring_answer(no_accredited_monitoring_body).
monitoring_answer(monitoring_by_accredited_body(Duties)) :-
    monitoring_by_accredited_body(Duties).

referral_row(certification_requirements_not_met, cite(eu_reg_2016_679_art_42_7)).
referral_row(code_prepared_by_body_representing_controllers_or_processors, cite(eu_reg_2016_679_art_40_2)).
referral_row(monitoring_body_independence_and_expertise_demonstrated, cite(eu_reg_2016_679_art_41_2_a)).
referral_row(monitoring_body_no_conflict_of_interests_demonstrated, cite(eu_reg_2016_679_art_41_2_d)).
referral_row(monitoring_body_actions_infringe_regulation, cite(eu_reg_2016_679_art_41_5)).
referral_row(certification_body_independence_and_expertise_demonstrated, cite(eu_reg_2016_679_art_43_2_a)).
referral_row(certification_body_no_conflict_of_interests_demonstrated, cite(eu_reg_2016_679_art_43_2_e)).
referral_row(certification_body_actions_infringe_regulation, cite(eu_reg_2016_679_art_43_7)).

argument_name(profile).
argument_name(body).
argument_name(issued_on).
argument_name(accredited_on).
argument_name(check_date).

certification_result(Validity, Transfer) :-
    validity_answer(Validity),
    transfer_answer(Transfer).

code_result(Monitoring, Transfer) :-
    monitoring_answer(Monitoring),
    transfer_answer(Transfer).

monitoring_by_accredited_body([take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons]).

indeterminate([Key]) :-
    gdpr_codes_and_certification_profile_keys(Keys),
    member(Key, Keys).

needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]) :-
    open_textured(Key, Citation),
    inputs_relied_on(Pairs).

open_textured(Key, Citation) :-
    referral_row(Key, Citation).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

input_problems([Problem|Problems]) :-
    maplist(problem_term, [Problem|Problems]).

problem_term(duplicate_key(Key)) :-
    duplicate_key(Key).
problem_term(wrong_type(Name)) :-
    wrong_type(Name).
problem_term(unknown_key(_Key)).

wrong_type(Name) :-
    argument_name(Name).
wrong_type(Key) :-
    gdpr_codes_and_certification_profile_keys(Keys),
    member(Key, Keys).

duplicate_key(Key) :-
    gdpr_codes_and_certification_profile_keys(Keys),
    member(Key, Keys).

test(what_if_settles_the_public_authority_step) :-
    gdpr_codes_and_certification_what_if([attribute(code_adhered_to_by_party_not_subject_to_regulation, false)], processing_by_public_authority_or_body, true, code_result).
test(without_the_what_if_the_key_is_missing) :-
    gdpr_codes_and_certification_status([attribute(code_adhered_to_by_party_not_subject_to_regulation, false)], indeterminate).
test(what_if_replaces_an_earlier_value) :-
    profile_with_value([attribute(certification_withdrawn, true)], certification_withdrawn, false, [attribute(certification_withdrawn, false)]).
test(provision_lookup_reads_the_pinned_words) :-
    gdpr_codes_and_certification_provision(eu_reg_2016_679_art_41_6, _, 'This Article shall not apply to processing carried out by public authorities and bodies.').
test(ground_lookup_names_the_withdrawal_provision) :-
    gdpr_codes_and_certification_ground_provision(certification_status, withdrawal_required, cite(eu_reg_2016_679_art_42_7)).
test(certification_body_ladder_reads_eight_keys) :-
    findall(Key, gdpr_codes_and_certification_key_read(certification_body, Key), Keys),
    length(Keys, 8).
test(the_constructor_takes_the_pinned_atoms) :-
    certification_result(withdrawn, transfer_conditions_met).
test(the_duties_are_in_text_order) :-
    monitoring_by_accredited_body(Duties),
    Duties == [take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons].

test(the_constructor_refuses_a_synonym, fail) :-
    certification_result(expired, transfer_conditions_met).
