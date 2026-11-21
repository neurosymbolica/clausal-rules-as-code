% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_subject/1, gdpr_chapter_v_extras_profile_for/2, gdpr_chapter_v_extras_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [decide_gdpr_chapter_v_extras/2]).

gdpr_chapter_v_extras_subject(supervisory_authority_informed).
gdpr_chapter_v_extras_subject(supervisory_authority_not_informed).
gdpr_chapter_v_extras_subject(supervisory_authority_information_unstated).
gdpr_chapter_v_extras_subject(processor_asks_about_informing).
gdpr_chapter_v_extras_subject(processor_asks_with_transfer_fact_absent).
gdpr_chapter_v_extras_subject(controller_asks_with_transfer_fact_absent).
gdpr_chapter_v_extras_subject(party_role_unstated).
gdpr_chapter_v_extras_subject(transfer_not_under_second_subparagraph).
gdpr_chapter_v_extras_subject(transfer_not_under_second_subparagraph_role_unstated).
gdpr_chapter_v_extras_subject(data_subject_fully_informed).
gdpr_chapter_v_extras_subject(data_subject_not_told_of_interests).
gdpr_chapter_v_extras_subject(data_subject_interests_refused_transfer_unstated).
gdpr_chapter_v_extras_subject(data_subject_transfer_information_unstated).
gdpr_chapter_v_extras_subject(records_complete_for_processor).
gdpr_chapter_v_extras_subject(records_lack_safeguards).
gdpr_chapter_v_extras_subject(records_lack_assessment_safeguards_unstated).
gdpr_chapter_v_extras_subject(records_safeguards_unstated).
gdpr_chapter_v_extras_subject(judgment_not_requiring_transfer).
gdpr_chapter_v_extras_subject(judgment_with_international_agreement).
gdpr_chapter_v_extras_subject(judgment_without_international_agreement).
gdpr_chapter_v_extras_subject(judgment_agreement_unstated).
gdpr_chapter_v_extras_subject(judgment_unstated_agreement_stated).
gdpr_chapter_v_extras_subject(onward_transfer_with_chapter_v_basis).
gdpr_chapter_v_extras_subject(onward_transfer_without_chapter_v_basis).
gdpr_chapter_v_extras_subject(onward_transfer_basis_unstated).
gdpr_chapter_v_extras_subject(transfer_not_onward).
gdpr_chapter_v_extras_subject(transfer_not_onward_with_link_evidence).
gdpr_chapter_v_extras_subject(onward_status_unstated_basis_stated).
gdpr_chapter_v_extras_subject(duplicated_party_role).
gdpr_chapter_v_extras_subject(bare_boolean_outside_fact).
gdpr_chapter_v_extras_subject(unknown_key_supplied).
gdpr_chapter_v_extras_subject(empty_profile).
gdpr_chapter_v_extras_subject(complete_transfer_file).

gdpr_chapter_v_extras_profile_for(supervisory_authority_informed, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true)]).
gdpr_chapter_v_extras_profile_for(supervisory_authority_not_informed, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, false)]).
gdpr_chapter_v_extras_profile_for(supervisory_authority_information_unstated, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller)]).
gdpr_chapter_v_extras_profile_for(processor_asks_about_informing, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, processor), attribute(supervisory_authority_informed_of_transfer, true)]).
gdpr_chapter_v_extras_profile_for(processor_asks_with_transfer_fact_absent, [attribute(party_role, processor)]).
gdpr_chapter_v_extras_profile_for(controller_asks_with_transfer_fact_absent, [attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true)]).
gdpr_chapter_v_extras_profile_for(party_role_unstated, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(supervisory_authority_informed_of_transfer, true)]).
gdpr_chapter_v_extras_profile_for(transfer_not_under_second_subparagraph, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(false, attestation(by, at, reason, none))), attribute(party_role, controller)]).
gdpr_chapter_v_extras_profile_for(transfer_not_under_second_subparagraph_role_unstated, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(false, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(data_subject_fully_informed, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(data_subject_informed_of_transfer, true), attribute(data_subject_informed_of_compelling_legitimate_interests, true)]).
gdpr_chapter_v_extras_profile_for(data_subject_not_told_of_interests, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(data_subject_informed_of_transfer, true), attribute(data_subject_informed_of_compelling_legitimate_interests, false)]).
gdpr_chapter_v_extras_profile_for(data_subject_interests_refused_transfer_unstated, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(data_subject_informed_of_compelling_legitimate_interests, false)]).
gdpr_chapter_v_extras_profile_for(data_subject_transfer_information_unstated, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(data_subject_informed_of_compelling_legitimate_interests, true)]).
gdpr_chapter_v_extras_profile_for(records_complete_for_processor, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, processor), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, true)]).
gdpr_chapter_v_extras_profile_for(records_lack_safeguards, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, processor), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, false)]).
gdpr_chapter_v_extras_profile_for(records_lack_assessment_safeguards_unstated, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(assessment_documented_in_records, false)]).
gdpr_chapter_v_extras_profile_for(records_safeguards_unstated, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(assessment_documented_in_records, true)]).
gdpr_chapter_v_extras_profile_for(judgment_not_requiring_transfer, [attribute(third_country_judgment_or_decision_requires_transfer, attested(false, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(judgment_with_international_agreement, [attribute(third_country_judgment_or_decision_requires_transfer, attested(true, attestation(by, at, reason, none))), attribute(international_agreement_basis_for_judgment_or_decision, attested(true, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(judgment_without_international_agreement, [attribute(third_country_judgment_or_decision_requires_transfer, attested(true, attestation(by, at, reason, none))), attribute(international_agreement_basis_for_judgment_or_decision, attested(false, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(judgment_agreement_unstated, [attribute(third_country_judgment_or_decision_requires_transfer, attested(true, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(judgment_unstated_agreement_stated, [attribute(international_agreement_basis_for_judgment_or_decision, attested(true, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(onward_transfer_with_chapter_v_basis, [attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none))), attribute(onward_transfer_has_chapter_v_basis, attested(true, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(onward_transfer_without_chapter_v_basis, [attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none))), attribute(onward_transfer_has_chapter_v_basis, attested(false, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(onward_transfer_basis_unstated, [attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(transfer_not_onward, [attribute(transfer_is_onward_transfer, attested(false, attestation(by, at, reason, none))), attribute(onward_transfer_has_chapter_v_basis, attested(true, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(transfer_not_onward_with_link_evidence, [attribute(transfer_is_onward_transfer, attested(false, attestation(by, at, reason, url(source_location, retrieved_at))))]).
gdpr_chapter_v_extras_profile_for(onward_status_unstated_basis_stated, [attribute(onward_transfer_has_chapter_v_basis, attested(true, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(duplicated_party_role, [attribute(party_role, controller), attribute(party_role, controller)]).
gdpr_chapter_v_extras_profile_for(bare_boolean_outside_fact, [attribute(transfer_is_onward_transfer, true)]).
gdpr_chapter_v_extras_profile_for(unknown_key_supplied, [attribute(transfer_is_onward_transfer, attested(false, attestation(by, at, reason, none))), attribute(transfer_date, today)]).
gdpr_chapter_v_extras_profile_for(empty_profile, []).
gdpr_chapter_v_extras_profile_for(complete_transfer_file, [attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true), attribute(data_subject_informed_of_transfer, true), attribute(data_subject_informed_of_compelling_legitimate_interests, true), attribute(assessment_documented_in_records, true), attribute(suitable_safeguards_documented_in_records, true), attribute(third_country_judgment_or_decision_requires_transfer, attested(true, attestation(by, at, reason, none))), attribute(international_agreement_basis_for_judgment_or_decision, attested(true, attestation(by, at, reason, none))), attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none))), attribute(onward_transfer_has_chapter_v_basis, attested(true, attestation(by, at, reason, none)))]).
gdpr_chapter_v_extras_profile_for(todo_baseline_subject, [attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none))), attribute(onward_transfer_has_chapter_v_basis, attested(true, attestation(by, at, reason, none)))]).

gdpr_chapter_v_extras_assess(Subject, Result) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    decide_gdpr_chapter_v_extras(Profile, Result).
