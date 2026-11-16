% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_queries, [gdpr_information_duties_headline_verdict_profile_keys/1, gdpr_information_duties_headline_verdict_what_if/4, gdpr_information_duties_headline_verdict_compliance_check/3, gdpr_information_duties_headline_verdict_obligations/2, gdpr_information_duties_headline_verdict_deadline/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, outside_fact/2, attested/2, attestation/4, provenance/2, url/2, document/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3]).

input_problems(Problems) :-
    is_list(Problems).

unknown_key(Key) :-
    atom(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

indeterminate(Keys) :-
    is_list(Keys).

needs_legal_review(Reason, Context) :-
    nonvar(Reason),
    is_list(Context).

open_textured(Key, cite(Citation)) :-
    atom(Key),
    atom(Citation).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

outside_fact(Key, Value) :-
    atom(Key),
    nonvar(Value).

attested(Value, Attestation) :-
    nonvar(Value),
    nonvar(Attestation).

attestation(By, At, Reason, Evidence) :-
    nonvar(By),
    nonvar(At),
    nonvar(Reason),
    nonvar(Evidence).

provenance(Clause, Citations) :-
    atom(Clause),
    is_list(Citations).

url(Address, RetrievedAt) :-
    atom(Address),
    nonvar(RetrievedAt).

document(UploadIdentifier, Digest) :-
    nonvar(UploadIdentifier),
    nonvar(Digest).

information_already_has_cite(art13, cite(eu_reg_2016_679_art_13_4)).
information_already_has_cite(art14, cite(eu_reg_2016_679_art_14_5_a)).

information_exemption_chapeau_cite(cite(eu_reg_2016_679_art_14_5)).

provision_marker(eu_reg_2016_679_art_13_4) :-
    implements(eu_reg_2016_679_art_13_4).
provision_marker(eu_reg_2016_679_art_14_5) :-
    implements(eu_reg_2016_679_art_14_5).
provision_marker(eu_reg_2016_679_art_14_5_a) :-
    implements(eu_reg_2016_679_art_14_5_a).
provision_marker(eu_reg_1971_1182_art_3) :-
    implements(eu_reg_1971_1182_art_3).
provision_marker(eu_reg_2016_679_art_4_1) :-
    implements(eu_reg_2016_679_art_4_1).
provision_marker(eu_reg_2016_679_art_4_4) :-
    implements(eu_reg_2016_679_art_4_4).
provision_marker(eu_reg_2016_679_art_4_7) :-
    implements(eu_reg_2016_679_art_4_7).
provision_marker(eu_reg_2016_679_art_4_9) :-
    implements(eu_reg_2016_679_art_4_9).

gdpr_information_duties_headline_verdict_profile_keys([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, first_communication_date, disclosure_to_another_recipient_envisaged, first_disclosure_date, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law, further_processing_for_another_purpose_intended, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing, public_holidays]).

gdpr_information_duties_headline_verdict_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    information_duty_verdict(Hypothesis, NewStatus, _Citations).

override_attribute(Profile, Key, Value, [attribute(Key, Value)|Remaining]) :-
    remove_attribute(Profile, Key, Remaining).

remove_attribute([], _, []).
remove_attribute([attribute(Key, _)|Elements], Key, Remaining) :-
    remove_attribute(Elements, Key, Remaining).
remove_attribute([attribute(OtherKey, OtherValue)|Elements], Key, [attribute(OtherKey, OtherValue)|Remaining]) :-
    dif(OtherKey, Key),
    remove_attribute(Elements, Key, Remaining).

gdpr_information_duties_headline_verdict_compliance_check(Profile, proceed_with_processing, Result) :-
    information_duty_verdict(Profile, Verdict, Citations),
    compliance_result(Verdict, Citations, Result).

compliance_result(eligible, Citations, compliance(permitted, Citations)).
compliance_result(ineligible, Citations, compliance(prohibited, Citations)).
compliance_result(indeterminate(Keys), _, indeterminate(Keys)).
compliance_result(needs_legal_review(Reason, Context), _, needs_legal_review(Reason, Context)).
compliance_result(input_problems(Problems), _, input_problems(Problems)).

gdpr_information_duties_headline_verdict_obligations(Profile, Result) :-
    information_duty_verdict(Profile, Verdict, Citations),
    obligation_result(Verdict, Citations, Result).

obligation_result(eligible, _, obligations([])).
obligation_result(ineligible, Citations, obligations(Citations)).
obligation_result(indeterminate(Keys), _, indeterminate(Keys)).
obligation_result(needs_legal_review(Reason, Context), _, needs_legal_review(Reason, Context)).
obligation_result(input_problems(Problems), _, input_problems(Problems)).

gdpr_information_duties_headline_verdict_deadline(Profile, Result) :-
    information_duty_verdict(Profile, Verdict, Citations),
    timing_cites(Citations, Timing),
    deadline_result(Verdict, Timing, Result).

timing_cite(cite(eu_reg_2016_679_art_13_1)).
timing_cite(cite(eu_reg_2016_679_art_14_3_a)).
timing_cite(cite(eu_reg_2016_679_art_14_3_b)).
timing_cite(cite(eu_reg_2016_679_art_14_3_c)).

timing_cites(Citations, Timing) :-
    findall(Citation, (member(Citation, Citations), timing_cite(Citation)), Found),
    sort(Found, Timing).

deadline_result(eligible, _, deadline(satisfied, [])).
deadline_result(ineligible, [], deadline(not_missed, [])).
deadline_result(ineligible, [First|Others], deadline(missed, [First|Others])).
deadline_result(indeterminate(Keys), _, indeterminate(Keys)).
deadline_result(needs_legal_review(Reason, Context), _, needs_legal_review(Reason, Context)).
deadline_result(input_problems(Problems), _, input_problems(Problems)).
