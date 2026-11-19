% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_queries, [gdpr_procedural_regulation_profile_keys/1, gdpr_procedural_regulation_what_if/4, admissible/0, inadmissible/0, prior_request_not_required/0, prior_request_made/0, prior_request_not_made/0, early_resolution_not_available/0, complaint_not_devoid_of_purpose/0, early_resolution_objected/0, resolution_established_by_receiving_authority/0, draft_decision_establishing_resolution/0, chapter_iii_not_applicable/0, simple_procedure_not_available/0, simple_procedure_excluded_by_objection/0, simple_procedure_available/0, legality_and_validity_not_affected/0, not_governed_by_article_14/0, part_applies/0, part_does_not_apply/0, suspended_until_board_binding_decision/0, extension_not_permitted/0, no_extension/0, up_to/0, exactly/0, weeks/0, months/0, within/0, at_least_before/0, receipt_of_complaint/0, complainant_receiving_early_resolution_information/0, expiry_of_objection_time_limit/0, confirmation_of_competence_or_board_binding_decision/0, notification_of_simple_cooperation_procedure/0, receipt_of_summary_of_key_issues/0, expiry_of_comment_period/0, expiry_of_draft_decision_time_limit/0, being_informed_of_extension/0, expiry_of_simple_procedure_time_limit/0, indeterminate/1, input_problems/1, wrong_type/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(clausal_hof, [include/3, exclude/3]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [gdpr_procedural_regulation_status/2]).

gdpr_procedural_regulation_profile_keys([complaint_lodged_by, lodging_person_name_and_contact_details_included, proof_of_proper_constitution_included, proof_of_data_subject_mandate_included, controller_or_processor_identification_information_included, alleged_infringement_description_included, complaint_concerns_right_exercised_by_request, request_made_to_controller_before_complaint, complaint_concerns_chapter_iii_rights, end_of_infringement_established_on_supporting_evidence, complainant_objected_to_early_resolution_in_time, early_resolution_procedure_before, case_handled_under_article_56_2, lead_authority_considers_no_reasonable_doubt_as_to_scope, issues_addressable_without_additional_cooperation, concerned_authority_objected_to_simple_procedure_in_time, simple_cooperation_procedure_applied, draft_decision_time_limit_extended, board_request_under_article_11_6_made, extension_justified_by_exceptional_complexity, national_law_requires_domestic_proceedings_after_time_limit, time_limit_set_by_this_regulation_or_article_65_6]).

gdpr_procedural_regulation_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    hypothesis_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_procedural_regulation_status(Hypothesis, NewStatus).

hypothesis_profile(Profile, Key, Value, Hypothesis) :-
    include(clausal_is_list, [Profile], KeptProfiles),
    hypothesis_for(KeptProfiles, Profile, Key, Value, Hypothesis).

hypothesis_for([_], Profile, Key, Value, Hypothesis) :-
    exclude(attribute_with_key(Key), Profile, KeptAttributes),
    append(KeptAttributes, [attribute(Key, Value)], Hypothesis).
hypothesis_for([], Profile, _, _, Profile).

attribute_with_key(Key, Element) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key.

admissible.

inadmissible.

prior_request_not_required.

prior_request_made.

prior_request_not_made.

early_resolution_not_available.

complaint_not_devoid_of_purpose.

early_resolution_objected.

resolution_established_by_receiving_authority.

draft_decision_establishing_resolution.

chapter_iii_not_applicable.

simple_procedure_not_available.

simple_procedure_excluded_by_objection.

simple_procedure_available.

legality_and_validity_not_affected.

not_governed_by_article_14.

part_applies.

part_does_not_apply.

suspended_until_board_binding_decision.

extension_not_permitted.

no_extension.

up_to.

exactly.

weeks.

months.

within.

at_least_before.

receipt_of_complaint.

complainant_receiving_early_resolution_information.

expiry_of_objection_time_limit.

confirmation_of_competence_or_board_binding_decision.

notification_of_simple_cooperation_procedure.

receipt_of_summary_of_key_issues.

expiry_of_comment_period.

expiry_of_draft_decision_time_limit.

being_informed_of_extension.

expiry_of_simple_procedure_time_limit.

indeterminate([MissingKey]) :-
    atom(MissingKey).

input_problems([Problem|Problems]) :-
    compound(Problem),
    clausal_is_list(Problems).

wrong_type(Name) :-
    atom(Name).

test(what_if_a_missing_description_makes_the_complaint_inadmissible) :-
    Profile = [attribute(complaint_lodged_by, data_subject), attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true)],
    findall(Status, gdpr_procedural_regulation_what_if(Profile, alleged_infringement_description_included, false, Status), Statuses),
    Statuses == [inadmissible].
test(what_if_the_unchanged_complaint_stays_admissible) :-
    Profile = [attribute(complaint_lodged_by, data_subject), attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true)],
    gdpr_procedural_regulation_what_if(Profile, alleged_infringement_description_included, true, admissible).
test(what_if_adds_an_absent_key) :-
    Profile = [attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true)],
    gdpr_procedural_regulation_what_if(Profile, complaint_lodged_by, article_80_2_body, indeterminate([proof_of_proper_constitution_included])).
test(what_if_a_wrong_value_is_an_input_problem) :-
    gdpr_procedural_regulation_what_if([], complaint_lodged_by, nobody, input_problems([wrong_type(complaint_lodged_by)])).
test(what_if_a_non_list_profile_is_named_by_the_input_check) :-
    gdpr_procedural_regulation_what_if(nonsense, complaint_lodged_by, data_subject, input_problems([wrong_type(profile)])).
test(profile_keys_are_twenty_two) :-
    gdpr_procedural_regulation_profile_keys(Keys),
    length(Keys, 22).
test(result_vocabulary_is_declared) :-
    admissible,
    months.
test(status_constructors_recognize_their_shape) :-
    indeterminate([complaint_lodged_by]),
    input_problems([wrong_type(profile)]),
    wrong_type(event_date).

test(what_if_the_override_is_not_inadmissible, fail) :-
    Profile = [attribute(complaint_lodged_by, data_subject), attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, false)],
    gdpr_procedural_regulation_what_if(Profile, alleged_infringement_description_included, true, inadmissible).
test(indeterminate_names_only_one_key, fail) :-
    indeterminate([complaint_lodged_by, data_subject]).
