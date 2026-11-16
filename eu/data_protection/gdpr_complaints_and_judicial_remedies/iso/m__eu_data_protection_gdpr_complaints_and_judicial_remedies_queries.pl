% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_queries, [gdpr_complaints_and_judicial_remedies_profile_keys/1, gdpr_complaints_and_judicial_remedies_what_if/4, gdpr_complaints_and_judicial_remedies_eligibility/4, is_data_subject/0, data_subject_considers_processing_infringes_regulation/0, decision_is_legally_binding/0, decision_concerns_the_caller/0, complaint_lodged_under_article_77/0, authority_competent_under_articles_55_and_56/0, authority_handled_the_complaint/0, three_months_from_the_complaint_have_passed/0, authority_informed_on_progress_or_outcome/0, data_subject_considers_rights_infringed_by_processing/0, defendant_is_member_state_public_authority_acting_in_public_powers/0, unsure/0, indeterminate/1, needs_legal_review/2, provenance/2, outside_fact/2, attested/2, url/2, document/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [complaint_right/3, authority_decision_remedy_right/3, authority_inaction_remedy_right/4, controller_processor_remedy_right/3, gdpr_complaints_and_judicial_remedies_status/2]).
:- use_module(formalize_lib, [not_member/2]).

gdpr_complaints_and_judicial_remedies_profile_keys([is_data_subject, data_subject_considers_processing_infringes_regulation, decision_is_legally_binding, decision_concerns_the_caller, complaint_lodged_under_article_77, authority_competent_under_articles_55_and_56, authority_handled_the_complaint, three_months_from_the_complaint_have_passed, authority_informed_on_progress_or_outcome, data_subject_considers_rights_infringed_by_processing, defendant_is_member_state_public_authority_acting_in_public_powers]).

is_data_subject.

data_subject_considers_processing_infringes_regulation.

decision_is_legally_binding.

decision_concerns_the_caller.

complaint_lodged_under_article_77.

authority_competent_under_articles_55_and_56.

authority_handled_the_complaint.

three_months_from_the_complaint_have_passed.

authority_informed_on_progress_or_outcome.

data_subject_considers_rights_infringed_by_processing.

defendant_is_member_state_public_authority_acting_in_public_powers.

unsure.

indeterminate([MissingKey]) :-
    gdpr_complaints_and_judicial_remedies_profile_keys(ContractKeys),
    member(MissingKey, ContractKeys).

needs_legal_review(Reason, [ContextItem|ContextItems]) :-
    referral_reason(Reason),
    nonvar(ContextItem),
    is_list(ContextItems).

referral_reason(open_textured(Input, cite(Citation))) :-
    atom(Input),
    atom(Citation).
referral_reason(cross_reference_unresolved(cite(Citation), cite(Target))) :-
    atom(Citation),
    atom(Target).

provenance(Source, Detail) :-
    atom(Source),
    nonvar(Detail).

outside_fact(authority_competent_under_articles_55_and_56, Attested) :-
    nonvar(Attested),
    Attested = attested(Value, Attestation),
    attested(Value, Attestation).

attested(Value, Attestation) :-
    member(Value, [true, false]),
    nonvar(Attestation),
    functor(Attestation, attestation, 4).

url(Location, RetrievedAt) :-
    atom(Location),
    atom(RetrievedAt).

document(UploadIdentifier, Sha256Digest) :-
    atom(UploadIdentifier),
    atom(Sha256Digest).

input_problems([Problem|Problems]) :-
    maplist(input_problem, [Problem|Problems]).

input_problem(unknown_key(ProblemKey)) :-
    unknown_key(ProblemKey).
input_problem(wrong_type(ProblemKey)) :-
    wrong_type(ProblemKey).
input_problem(duplicate_key(ProblemKey)) :-
    duplicate_key(ProblemKey).

unknown_key(ProblemKey) :-
    gdpr_complaints_and_judicial_remedies_profile_keys(ContractKeys),
    not_member(ProblemKey, ContractKeys).

wrong_type(ProblemKey) :-
    gdpr_complaints_and_judicial_remedies_profile_keys(ContractKeys),
    member(ProblemKey, [profile|ContractKeys]).

duplicate_key(ProblemKey) :-
    gdpr_complaints_and_judicial_remedies_profile_keys(ContractKeys),
    member(ProblemKey, ContractKeys).

gdpr_complaints_and_judicial_remedies_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_with_value(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_complaints_and_judicial_remedies_status(Hypothesis, NewStatus).

profile_with_value([], Key, Value, [attribute(Key, Value)]).
profile_with_value([attribute(ElementKey, _)|Elements], Key, Value, Hypothesis) :-
    ElementKey == Key,
    profile_with_value(Elements, Key, Value, Hypothesis).
profile_with_value([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== Key,
    profile_with_value(Elements, Key, Value, Hypothesis).

gdpr_complaints_and_judicial_remedies_eligibility(complaint_right, Profile, Label, Citations) :-
    complaint_right(Profile, Result, Citations),
    result_label(Result, complaint_right_exists, no_complaint_right, Label).
gdpr_complaints_and_judicial_remedies_eligibility(authority_decision_remedy_right, Profile, Label, Citations) :-
    authority_decision_remedy_right(Profile, Result, Citations),
    result_label(Result, decision_remedy_right_exists, no_decision_remedy_right, Label).
gdpr_complaints_and_judicial_remedies_eligibility(authority_inaction_remedy_right, Profile, Label, Citations) :-
    authority_inaction_remedy_right(Profile, Result, _Basis, Citations),
    result_label(Result, inaction_remedy_right_exists, no_inaction_remedy_right, Label).
gdpr_complaints_and_judicial_remedies_eligibility(controller_processor_remedy_right, Profile, Label, Citations) :-
    controller_processor_remedy_right(Profile, Result, Citations),
    result_label(Result, judicial_remedy_right_exists, no_judicial_remedy_right, Label).

result_label(Positive, Positive, _, eligible).
result_label(Negative, _, Negative, ineligible).
result_label(indeterminate(_), _, _, indeterminate_eligibility).
result_label(needs_legal_review(_, _), _, _, indeterminate_eligibility).
result_label(input_problems(_), _, _, indeterminate_eligibility).

test(the_profile_keys_are_the_eleven_contract_keys) :-
    gdpr_complaints_and_judicial_remedies_profile_keys(Keys),
    length(Keys, 11).
test(the_root_atoms_are_defined) :-
    is_data_subject,
    defendant_is_member_state_public_authority_acting_in_public_powers,
    unsure.
test(supplying_the_consideration_makes_a_remedy_available) :-
    gdpr_complaints_and_judicial_remedies_what_if([attribute(is_data_subject, true)], data_subject_considers_processing_infringes_regulation, true, remedy_available).
test(an_override_replaces_the_earlier_value) :-
    gdpr_complaints_and_judicial_remedies_what_if([attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, false)], data_subject_considers_processing_infringes_regulation, true, remedy_available).
test(a_complaint_right_is_eligible) :-
    gdpr_complaints_and_judicial_remedies_eligibility(complaint_right, [attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, true)], eligible, [cite(eu_reg_2016_679_art_77_1)]).
test(a_non_data_subject_is_ineligible_for_the_judicial_remedy) :-
    gdpr_complaints_and_judicial_remedies_eligibility(controller_processor_remedy_right, [attribute(is_data_subject, false)], ineligible, [cite(eu_reg_2016_679_art_79_1)]).
test(an_unsure_judgement_is_indeterminate_eligibility) :-
    gdpr_complaints_and_judicial_remedies_eligibility(authority_decision_remedy_right, [attribute(decision_is_legally_binding, unsure), attribute(decision_concerns_the_caller, true)], indeterminate_eligibility, []).
test(an_absent_competence_statement_is_indeterminate_eligibility) :-
    gdpr_complaints_and_judicial_remedies_eligibility(authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, false)], indeterminate_eligibility, []).
test(the_eligibility_has_one_answer) :-
    findall(Label, gdpr_complaints_and_judicial_remedies_eligibility(complaint_right, [attribute(is_data_subject, false), attribute(data_subject_considers_processing_infringes_regulation, false)], Label, _), Labels),
    Labels == [ineligible].
test(the_indeterminate_term_names_one_contract_key) :-
    indeterminate([is_data_subject]).
test(the_open_textured_referral_is_well_formed) :-
    needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])]).
test(the_cross_reference_referral_is_well_formed) :-
    needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]).
test(a_provenance_term_is_well_formed) :-
    provenance(host_attestation_service, register_lookup).
test(the_outside_fact_term_is_well_formed) :-
    outside_fact(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, reason, none))).
test(an_attested_false_is_well_formed) :-
    attested(false, attestation(host, at, reason, none)).
test(a_url_evidence_is_well_formed) :-
    url('https://example.org/competence', '2026-11-12').
test(a_document_evidence_is_well_formed) :-
    document(upload_0001, sha256_digest).
test(an_input_problems_term_is_well_formed) :-
    input_problems([duplicate_key(is_data_subject), wrong_type(decision_is_legally_binding), unknown_key(colour)]).
test(an_unknown_key_is_outside_the_contract) :-
    unknown_key(colour).
test(the_whole_profile_can_be_wrong_type) :-
    wrong_type(profile).
test(a_contract_key_can_be_wrong_type) :-
    wrong_type(authority_competent_under_articles_55_and_56).
test(a_contract_key_can_be_duplicate) :-
    duplicate_key(is_data_subject).

test(an_override_never_makes_a_duplicate, fail) :-
    gdpr_complaints_and_judicial_remedies_what_if([attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, false)], data_subject_considers_processing_infringes_regulation, true, input_problems(_)).
test(an_unsure_judgement_is_not_eligible, fail) :-
    gdpr_complaints_and_judicial_remedies_eligibility(authority_decision_remedy_right, [attribute(decision_is_legally_binding, unsure), attribute(decision_concerns_the_caller, true)], eligible, _).
test(an_empty_indeterminate_term_is_not_well_formed, fail) :-
    indeterminate([]).
test(a_referral_without_context_is_not_well_formed, fail) :-
    needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), []).
test(another_key_is_not_an_outside_fact, fail) :-
    outside_fact(is_data_subject, attested(true, attestation(host, at, reason, none))).
test(an_attested_unsure_is_not_well_formed, fail) :-
    attested(unsure, attestation(host, at, reason, none)).
test(an_empty_input_problems_term_is_not_well_formed, fail) :-
    input_problems([]).
test(a_contract_key_is_not_unknown, fail) :-
    unknown_key(is_data_subject).
test(an_unknown_key_is_never_a_duplicate_key, fail) :-
    duplicate_key(colour).
