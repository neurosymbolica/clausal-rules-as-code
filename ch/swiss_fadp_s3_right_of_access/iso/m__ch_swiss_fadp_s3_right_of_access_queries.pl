% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s3_right_of_access_queries, [swiss_fadp_s3_right_of_access_profile_keys/1, swiss_fadp_s3_right_of_access_what_if/4, swiss_fadp_s3_right_of_access_controller_obligations/2, request_form/0, controller_agreed_to_oral_request/0, controller_category/0, formal_law_provides_for_restriction/0, restriction_required_by_overriding_third_party_interests/0, request_manifestly_unfounded_or_querulous/0, restriction_required_by_overriding_controller_interests/0, controller_discloses_the_personal_data_to_third_parties/0, restriction_required_by_overriding_public_interests/0, information_could_endanger_investigation_or_proceedings/0, processed_exclusively_for_publication_in_editorial_part_of_periodical_medium/0, data_reveal_information_sources/0, access_would_give_insight_into_drafts_for_publications/0, publication_would_endanger_free_formation_of_public_opinion/0, data_serve_media_professional_exclusively_as_personal_working_instrument/0, access_involves_disproportionate_effort/0, written/0, electronic/0, oral/0, private_person/0, federal_body/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_kernel, [swiss_fadp_s3_right_of_access_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_citations, [implements/1]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_swiss_fadp_s3_right_of_access, [swiss_access_request_answer/3]).

request_form.

controller_agreed_to_oral_request.

controller_category.

formal_law_provides_for_restriction.

restriction_required_by_overriding_third_party_interests.

request_manifestly_unfounded_or_querulous.

restriction_required_by_overriding_controller_interests.

controller_discloses_the_personal_data_to_third_parties.

restriction_required_by_overriding_public_interests.

information_could_endanger_investigation_or_proceedings.

processed_exclusively_for_publication_in_editorial_part_of_periodical_medium.

data_reveal_information_sources.

access_would_give_insight_into_drafts_for_publications.

publication_would_endanger_free_formation_of_public_opinion.

data_serve_media_professional_exclusively_as_personal_working_instrument.

access_involves_disproportionate_effort.

written.

electronic.

oral.

private_person.

federal_body.

unsure.

swiss_fadp_s3_right_of_access_profile_keys([request_form, controller_agreed_to_oral_request, controller_category, formal_law_provides_for_restriction, restriction_required_by_overriding_third_party_interests, request_manifestly_unfounded_or_querulous, restriction_required_by_overriding_controller_interests, controller_discloses_the_personal_data_to_third_parties, restriction_required_by_overriding_public_interests, information_could_endanger_investigation_or_proceedings, processed_exclusively_for_publication_in_editorial_part_of_periodical_medium, data_reveal_information_sources, access_would_give_insight_into_drafts_for_publications, publication_would_endanger_free_formation_of_public_opinion, data_serve_media_professional_exclusively_as_personal_working_instrument, access_involves_disproportionate_effort]).

swiss_fadp_s3_right_of_access_what_if(Profile, OverriddenKey, NewValue, NewResult) :-
    hypothetical_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    swiss_access_request_answer(Hypothesis, NewResult, _Citations).

hypothetical_profile(Profile, OverriddenKey, NewValue, Hypothesis) :-
    exclude(attribute_for_key(OverriddenKey), Profile, OtherAttributes),
    append(OtherAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis).

attribute_for_key(OverriddenKey, attribute(ElementKey, _)) :-
    ElementKey == OverriddenKey.

swiss_fadp_s3_right_of_access_controller_obligations(Profile, Obligations) :-
    swiss_access_request_answer(Profile, Result, _Citations),
    obligations_for_answer(Result, Obligations).

obligations_for_answer(access_must_be_given, [obligation(give_access, cite(ch_fadp_art_25_1)), obligation(give_access_within_time_limit, cite(ch_fadp_ord_art_18_1))]) :-
    implements(ch_fadp_art_25_1),
    implements(ch_fadp_ord_art_18_1).
obligations_for_answer(access_may_be_refused_restricted_or_deferred, [obligation(state_reasons_for_measure, cite(ch_fadp_art_26_4)), obligation(communicate_measure_within_time_limit, cite(ch_fadp_ord_art_18_3))]) :-
    implements(ch_fadp_art_26_4),
    implements(ch_fadp_ord_art_18_3).
obligations_for_answer(access_request_not_in_required_form, []) :-
    implements(ch_fadp_ord_art_16_1).
obligations_for_answer(indeterminate(MissingKeys), indeterminate(MissingKeys)).
obligations_for_answer(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
obligations_for_answer(input_problems(Problems), input_problems(Problems)).
