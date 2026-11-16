% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_subject/1, gdpr_chapter_v_extras_profile_for/2, gdpr_chapter_v_extras_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [decide_gdpr_chapter_v_extras/2]).

gdpr_chapter_v_extras_subject(controller_all_duties_met).
gdpr_chapter_v_extras_subject(controller_data_subject_not_told_interests).
gdpr_chapter_v_extras_subject(controller_supervisory_authority_not_informed).
gdpr_chapter_v_extras_subject(controller_safeguards_not_documented).
gdpr_chapter_v_extras_subject(processor_documentation_met).
gdpr_chapter_v_extras_subject(processor_documentation_pending).
gdpr_chapter_v_extras_subject(no_second_subparagraph_transfer_stated).
gdpr_chapter_v_extras_subject(second_subparagraph_unstated).
gdpr_chapter_v_extras_subject(party_role_unstated).
gdpr_chapter_v_extras_subject(foreign_judgment_with_agreement).
gdpr_chapter_v_extras_subject(foreign_judgment_without_agreement).
gdpr_chapter_v_extras_subject(foreign_judgment_agreement_unstated).
gdpr_chapter_v_extras_subject(onward_transfer_with_basis).
gdpr_chapter_v_extras_subject(onward_transfer_without_basis).
gdpr_chapter_v_extras_subject(onward_transfer_basis_unstated).
gdpr_chapter_v_extras_subject(malformed_bare_boolean_outside_fact).

fixture_statement(Value, attested(Value, attestation(host_user, host_timestamp, fixture_statement, none))).

gdpr_chapter_v_extras_profile_for(controller_all_duties_met, Profile) :-
    fixture_statement(true, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true), attribute(data_subject_informed_of_transfer, true), attribute(data_subject_informed_of_compelling_legitimate_interests, true), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, true), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(controller_data_subject_not_told_interests, Profile) :-
    fixture_statement(true, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true), attribute(data_subject_informed_of_transfer, true), attribute(data_subject_informed_of_compelling_legitimate_interests, false), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, true), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(controller_supervisory_authority_not_informed, Profile) :-
    fixture_statement(true, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, false), attribute(data_subject_informed_of_transfer, true), attribute(data_subject_informed_of_compelling_legitimate_interests, true), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, true), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(controller_safeguards_not_documented, Profile) :-
    fixture_statement(true, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true), attribute(data_subject_informed_of_transfer, true), attribute(data_subject_informed_of_compelling_legitimate_interests, true), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, false), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(processor_documentation_met, Profile) :-
    fixture_statement(true, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, processor), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, true), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(processor_documentation_pending, Profile) :-
    fixture_statement(true, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, processor), attribute(assessment_documented_in_records, true), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(no_second_subparagraph_transfer_stated, Profile) :-
    fixture_statement(false, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(second_subparagraph_unstated, Profile) :-
    fixture_statement(false, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(party_role, controller), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(party_role_unstated, Profile) :-
    fixture_statement(true, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(supervisory_authority_informed_of_transfer, true), attribute(data_subject_informed_of_transfer, true), attribute(data_subject_informed_of_compelling_legitimate_interests, true), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, true), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(foreign_judgment_with_agreement, Profile) :-
    fixture_statement(false, TransferStatement),
    fixture_statement(true, JudgmentStatement),
    fixture_statement(true, AgreementStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(international_agreement_basis_for_judgment_or_decision, AgreementStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(foreign_judgment_without_agreement, Profile) :-
    fixture_statement(false, TransferStatement),
    fixture_statement(true, JudgmentStatement),
    fixture_statement(false, AgreementStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(international_agreement_basis_for_judgment_or_decision, AgreementStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(foreign_judgment_agreement_unstated, Profile) :-
    fixture_statement(false, TransferStatement),
    fixture_statement(true, JudgmentStatement),
    fixture_statement(false, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(onward_transfer_with_basis, Profile) :-
    fixture_statement(false, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(true, OnwardStatement),
    fixture_statement(true, OnwardBasisStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement), attribute(onward_transfer_has_chapter_v_basis, OnwardBasisStatement)].
gdpr_chapter_v_extras_profile_for(onward_transfer_without_basis, Profile) :-
    fixture_statement(false, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(true, OnwardStatement),
    fixture_statement(false, OnwardBasisStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement), attribute(onward_transfer_has_chapter_v_basis, OnwardBasisStatement)].
gdpr_chapter_v_extras_profile_for(onward_transfer_basis_unstated, Profile) :-
    fixture_statement(false, TransferStatement),
    fixture_statement(false, JudgmentStatement),
    fixture_statement(true, OnwardStatement),
    Profile = [attribute(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement), attribute(party_role, controller), attribute(third_country_judgment_or_decision_requires_transfer, JudgmentStatement), attribute(transfer_is_onward_transfer, OnwardStatement)].
gdpr_chapter_v_extras_profile_for(malformed_bare_boolean_outside_fact, Profile) :-
    Profile = [attribute(transfer_is_onward_transfer, true)].

gdpr_chapter_v_extras_assess(Subject, Result) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    decide_gdpr_chapter_v_extras(Profile, Result).
