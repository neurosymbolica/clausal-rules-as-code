% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_queries, [gdpr_information_duties_items_and_further_processing_profile_keys/1, gdpr_information_duties_items_and_further_processing_what_if/4, gdpr_information_duties_items_and_further_processing_deadline/2, gdpr_information_duties_items_and_further_processing_compliance_check/3, gdpr_information_duties_items_and_further_processing_obligations/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_datetime, [timedelta/3, date_sub/3]).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_kernel, [gdpr_information_duties_items_and_further_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_information_route, [information_route_status/2, information_items_missing/2, information_route_for_flag/2, information_absent_keys/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_further_processing_information_verdict, [further_processing_information_verdict/3]).

gdpr_information_duties_items_and_further_processing_profile_keys([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, first_communication_date, disclosure_to_another_recipient_envisaged, first_disclosure_date, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law, further_processing_for_another_purpose_intended, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing, public_holidays]).

gdpr_information_duties_items_and_further_processing_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    information_route_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(Key, _)|Rest], Key, Value, [attribute(Key, Value)|Rest]).
override_attribute([attribute(OtherKey, OtherValue)|Rest], Key, Value, [attribute(OtherKey, OtherValue)|NewRest]) :-
    dif(OtherKey, Key),
    override_attribute(Rest, Key, Value, NewRest).

gdpr_information_duties_items_and_further_processing_compliance_check(Profile, start_further_processing, Verdict) :-
    further_processing_information_verdict(Profile, Status, Citations),
    compliance_verdict(Status, Citations, Verdict).

compliance_verdict(eligible, Citations, permitted(Citations)).
compliance_verdict(not_applicable, Citations, permitted(Citations)).
compliance_verdict(ineligible, Citations, prohibited(Citations)).
compliance_verdict(indeterminate(Keys), _, indeterminate(Keys)).
compliance_verdict(needs_legal_review(Reason, Context), _, needs_legal_review(Reason, Context)).
compliance_verdict(input_problems(Problems), _, input_problems(Problems)).

gdpr_information_duties_items_and_further_processing_obligations(Profile, Answer) :-
    information_items_missing(Profile, Answer).

gdpr_information_duties_items_and_further_processing_deadline(Profile, Answer) :-
    gdpr_information_duties_items_and_further_processing_input_problems(Profile, Problems),
    deadline_with_problems(Problems, Profile, Answer).

deadline_with_problems([Problem|Problems], _, input_problems([Problem|Problems])).
deadline_with_problems([], Profile, Answer) :-
    information_absent_keys(Profile, [personal_data_collected_from_data_subject, further_processing_for_another_purpose_intended], Absent),
    deadline_after_gate(Absent, Profile, Answer).

deadline_after_gate([Key|Keys], _, indeterminate([Key|Keys])).
deadline_after_gate([], Profile, Answer) :-
    profile_get(Profile, further_processing_for_another_purpose_intended, Intended),
    deadline_by_intention(Intended, Profile, Answer).

deadline_by_intention(false, _, not_applicable).
deadline_by_intention(true, Profile, Answer) :-
    information_absent_keys(Profile, [further_processing_start_date], Absent),
    deadline_after_start(Absent, Profile, Answer).

deadline_after_start([Key|Keys], _, indeterminate([Key|Keys])).
deadline_after_start([], Profile, deadline(LastDate, cite(CiteKey), consequence(ineligible))) :-
    profile_get(Profile, further_processing_start_date, StartDate),
    profile_get(Profile, personal_data_collected_from_data_subject, Collected),
    information_route_for_flag(Collected, Route),
    prior_citation_key(Route, CiteKey),
    timedelta(1, 0, OneDay),
    date_sub(StartDate, OneDay, LastDate).

prior_citation_key(art13, eu_reg_2016_679_art_13_3) :-
    implements(eu_reg_2016_679_art_13_3).
prior_citation_key(art14, eu_reg_2016_679_art_14_4) :-
    implements(eu_reg_2016_679_art_14_4).
