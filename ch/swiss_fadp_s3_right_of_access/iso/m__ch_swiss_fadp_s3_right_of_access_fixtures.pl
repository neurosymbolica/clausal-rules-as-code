% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s3_right_of_access_fixtures, [swiss_fadp_s3_right_of_access_subject/1, swiss_fadp_s3_right_of_access_profile_for/2, swiss_fadp_s3_right_of_access_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_swiss_fadp_s3_right_of_access, [decide_swiss_fadp_s3_right_of_access/2]).

swiss_fadp_s3_right_of_access_subject(written_request_no_ground).
swiss_fadp_s3_right_of_access_subject(written_request_third_party_interests).
swiss_fadp_s3_right_of_access_subject(electronic_request_no_ground).
swiss_fadp_s3_right_of_access_subject(oral_request_without_agreement).
swiss_fadp_s3_right_of_access_subject(oral_request_without_agreement_with_ground).
swiss_fadp_s3_right_of_access_subject(oral_request_with_agreement).
swiss_fadp_s3_right_of_access_subject(private_controller_overriding_interests).
swiss_fadp_s3_right_of_access_subject(private_controller_discloses_to_third_parties).
swiss_fadp_s3_right_of_access_subject(federal_body_investigation_endangered).
swiss_fadp_s3_right_of_access_subject(federal_body_no_condition).
swiss_fadp_s3_right_of_access_subject(private_person_investigation_endangered).
swiss_fadp_s3_right_of_access_subject(category_absent_both_letters_met).
swiss_fadp_s3_right_of_access_subject(category_absent_private_letter_only).
swiss_fadp_s3_right_of_access_subject(editorial_media_sources_revealed).
swiss_fadp_s3_right_of_access_subject(sources_revealed_not_editorial_media).
swiss_fadp_s3_right_of_access_subject(media_professional_working_instrument).
swiss_fadp_s3_right_of_access_subject(empty_profile).
swiss_fadp_s3_right_of_access_subject(formal_law_unsure).
swiss_fadp_s3_right_of_access_subject(formal_law_unsure_third_party_interests).

subject_case(written_request_no_ground, full, []).
subject_case(written_request_third_party_interests, full, [set(restriction_required_by_overriding_third_party_interests, true)]).
subject_case(electronic_request_no_ground, full, [set(request_form, electronic)]).
subject_case(oral_request_without_agreement, full, [set(request_form, oral)]).
subject_case(oral_request_without_agreement_with_ground, full, [set(request_form, oral), set(restriction_required_by_overriding_third_party_interests, true)]).
subject_case(oral_request_with_agreement, full, [set(request_form, oral), set(controller_agreed_to_oral_request, true)]).
subject_case(private_controller_overriding_interests, full, [set(restriction_required_by_overriding_controller_interests, true)]).
subject_case(private_controller_discloses_to_third_parties, full, [set(restriction_required_by_overriding_controller_interests, true), set(controller_discloses_the_personal_data_to_third_parties, true)]).
subject_case(federal_body_investigation_endangered, full, [set(controller_category, federal_body), set(information_could_endanger_investigation_or_proceedings, true)]).
subject_case(federal_body_no_condition, full, [set(controller_category, federal_body)]).
subject_case(private_person_investigation_endangered, full, [set(information_could_endanger_investigation_or_proceedings, true)]).
subject_case(category_absent_both_letters_met, full, [drop(controller_category), set(restriction_required_by_overriding_controller_interests, true), set(restriction_required_by_overriding_public_interests, true)]).
subject_case(category_absent_private_letter_only, full, [drop(controller_category), set(restriction_required_by_overriding_controller_interests, true)]).
subject_case(editorial_media_sources_revealed, full, [set(processed_exclusively_for_publication_in_editorial_part_of_periodical_medium, true), set(data_reveal_information_sources, true)]).
subject_case(sources_revealed_not_editorial_media, full, [set(data_reveal_information_sources, true)]).
subject_case(media_professional_working_instrument, full, [set(data_serve_media_professional_exclusively_as_personal_working_instrument, true)]).
subject_case(empty_profile, empty, []).
subject_case(formal_law_unsure, full, [set(formal_law_provides_for_restriction, unsure)]).
subject_case(formal_law_unsure_third_party_interests, full, [set(formal_law_provides_for_restriction, unsure), set(restriction_required_by_overriding_third_party_interests, true)]).

swiss_fadp_s3_right_of_access_profile_for(Subject, Profile) :-
    subject_case(Subject, Start, Edits),
    start_profile(Start, StartProfile),
    foldl(apply_edit, Edits, StartProfile, Profile).

start_profile(full, [attribute(request_form, written), attribute(controller_agreed_to_oral_request, false), attribute(controller_category, private_person), attribute(formal_law_provides_for_restriction, false), attribute(restriction_required_by_overriding_third_party_interests, false), attribute(request_manifestly_unfounded_or_querulous, false), attribute(restriction_required_by_overriding_controller_interests, false), attribute(controller_discloses_the_personal_data_to_third_parties, false), attribute(restriction_required_by_overriding_public_interests, false), attribute(information_could_endanger_investigation_or_proceedings, false), attribute(processed_exclusively_for_publication_in_editorial_part_of_periodical_medium, false), attribute(data_reveal_information_sources, false), attribute(access_would_give_insight_into_drafts_for_publications, false), attribute(publication_would_endanger_free_formation_of_public_opinion, false), attribute(data_serve_media_professional_exclusively_as_personal_working_instrument, false)]).
start_profile(empty, []).

apply_edit(set(InputKey, Value), ProfileBefore, ProfileAfter) :-
    maplist(replace_attribute(InputKey, Value), ProfileBefore, ProfileAfter).
apply_edit(drop(InputKey), ProfileBefore, ProfileAfter) :-
    exclude(attribute_for_key(InputKey), ProfileBefore, ProfileAfter).

replace_attribute(InputKey, Value, attribute(InputKey, _), attribute(InputKey, Value)).
replace_attribute(InputKey, _, attribute(OtherKey, OtherValue), attribute(OtherKey, OtherValue)) :-
    dif(InputKey, OtherKey).

attribute_for_key(InputKey, attribute(ElementKey, _)) :-
    ElementKey == InputKey.

swiss_fadp_s3_right_of_access_assess(Subject, Result) :-
    swiss_fadp_s3_right_of_access_profile_for(Subject, Profile),
    decide_swiss_fadp_s3_right_of_access(Profile, Result).
