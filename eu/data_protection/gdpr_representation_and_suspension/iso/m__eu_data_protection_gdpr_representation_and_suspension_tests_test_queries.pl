% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_queries, [gdpr_representation_and_suspension_profile_keys/1, gdpr_representation_and_suspension_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_kernel, [gdpr_representation_and_suspension_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_gdpr_representation_and_suspension, [gdpr_representation_and_suspension_status/2, gdpr_representation_and_suspension_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_fixtures, [gdpr_representation_and_suspension_profile_for/2]).

attested_true_term(attested(true, attestation(host_service, attestation_moment, caller_statement, none))).

item_cited(Citation, item(_Requirement, _Status, Citation)).

test(profile_keys_are_the_contract_keys) :-
    gdpr_representation_and_suspension_profile_keys(ProfileKeys),
    ProfileKeys == [body_is_not_for_profit, body_properly_constituted_under_member_state_law, body_statutory_objectives_in_public_interest, body_active_in_protection_of_data_subjects_rights_and_freedoms, data_subject_mandated_the_body, member_state_law_provides_for_mandated_compensation_claims, member_state_law_provides_for_the_action_without_mandate, body_considers_data_subject_rights_infringed_by_processing, court_is_competent_court, court_has_information_on_proceedings_pending_in_another_member_state, other_proceedings_pending_in_court_of_another_member_state, other_proceedings_concern_same_controller_or_processor, other_proceedings_concern_same_subject_matter, court_is_court_first_seized, other_proceedings_pending_at_first_instance, party_applied_for_court_to_decline_jurisdiction, court_first_seized_has_jurisdiction_over_the_actions, law_of_court_first_seized_permits_consolidation].
test(the_input_check_answers_once) :-
    findall(Problems, gdpr_representation_and_suspension_input_problems([attribute(court_is_competent_court, true)], Problems), Answers),
    Answers == [[]].
test(status_gives_the_positive_verdict) :-
    gdpr_representation_and_suspension_profile_for(mandated_complaint_qualified, Profile),
    findall(Status, gdpr_representation_and_suspension_status(mandated_representation(Profile, lodge_complaint_under_article_77), Status), Statuses),
    Statuses == [may_act_on_mandate].
test(status_gives_the_negative_verdict) :-
    gdpr_representation_and_suspension_profile_for(court_suspension_court_first_seized, Profile),
    gdpr_representation_and_suspension_status(court_suspension_option(Profile), suspension_not_available).
test(status_gives_the_indeterminate_verdict) :-
    gdpr_representation_and_suspension_profile_for(court_contact_information_missing, Profile),
    gdpr_representation_and_suspension_status(court_contact_duty(Profile), indeterminate([court_has_information_on_proceedings_pending_in_another_member_state])).
test(checklist_cites_every_mandate_item) :-
    gdpr_representation_and_suspension_profile_for(mandated_complaint_qualified, Profile),
    gdpr_representation_and_suspension_checklist(mandated_representation(Profile, lodge_complaint_under_article_77), Items),
    length(Items, 5),
    maplist(item_cited(cite(eu_reg_2016_679_art_80_1)), Items).
test(checklist_marks_the_absent_compensation_law_unknown) :-
    gdpr_representation_and_suspension_profile_for(mandated_compensation_law_absent, Profile),
    gdpr_representation_and_suspension_checklist(mandated_representation(Profile, receive_compensation_under_article_82), Items),
    length(Items, 6),
    member(item(member_state_law_provides_for_mandated_compensation_claims, unknown([member_state_law_provides_for_mandated_compensation_claims]), cite(eu_reg_2016_679_art_80_1)), Items).
test(checklist_for_compensation_without_mandate) :-
    gdpr_representation_and_suspension_profile_for(without_mandate_compensation_refused, Profile),
    gdpr_representation_and_suspension_checklist(representation_without_mandate(Profile, receive_compensation_under_article_82), Items),
    Items == [item(action_named_in_article_80_2, unmet(receive_compensation_under_article_82), cite(eu_reg_2016_679_art_80_2))].
test(checklist_cites_every_declining_item) :-
    gdpr_representation_and_suspension_profile_for(court_declining_consolidation_refused, Profile),
    gdpr_representation_and_suspension_checklist(court_declining_jurisdiction_option(Profile), Items),
    length(Items, 8),
    maplist(item_cited(cite(eu_reg_2016_679_art_81_3)), Items),
    member(item(law_of_court_first_seized_permits_consolidation, unmet(law_of_court_first_seized_permits_consolidation), _), Items).
test(checklist_reports_an_input_problem) :-
    gdpr_representation_and_suspension_checklist(court_contact_duty(not_a_profile), Items),
    Items == [item(input_check, unmet(input_problems([wrong_type(profile)])), cite(eu_reg_2016_679_art_81_1))].
test(what_if_attests_the_compensation_law) :-
    gdpr_representation_and_suspension_profile_for(mandated_compensation_law_absent, Profile),
    attested_true_term(AttestedTrue),
    findall(Status, gdpr_representation_and_suspension_what_if(mandated_representation(Profile, receive_compensation_under_article_82), member_state_law_provides_for_mandated_compensation_claims, AttestedTrue, Status), Statuses),
    Statuses == [may_act_on_mandate].
test(what_if_the_mandate_still_refers_on_compensation) :-
    gdpr_representation_and_suspension_profile_for(mandated_compensation_law_and_mandate_absent, Profile),
    gdpr_representation_and_suspension_what_if(mandated_representation(Profile, receive_compensation_under_article_82), data_subject_mandated_the_body, true, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_80_1), _), _)).
test(what_if_overrides_a_present_key_without_duplicating) :-
    gdpr_representation_and_suspension_profile_for(court_declining_consolidation_refused, Profile),
    attested_true_term(AttestedTrue),
    findall(Status, gdpr_representation_and_suspension_what_if(court_declining_jurisdiction_option(Profile), law_of_court_first_seized_permits_consolidation, AttestedTrue, Status), Statuses),
    Statuses == [may_decline_jurisdiction].
test(what_if_an_unsure_judgement_goes_to_a_lawyer) :-
    gdpr_representation_and_suspension_profile_for(court_contact_related, Profile),
    gdpr_representation_and_suspension_what_if(court_contact_duty(Profile), other_proceedings_concern_same_subject_matter, unsure, needs_legal_review(open_textured(other_proceedings_concern_same_subject_matter, cite(eu_reg_2016_679_art_81_1)), [inputs_relied_on([other_proceedings_concern_same_subject_matter - unsure])])).

test(what_if_the_overridden_key_is_not_refused_twice, fail) :-
    gdpr_representation_and_suspension_profile_for(court_suspension_court_first_seized, Profile),
    gdpr_representation_and_suspension_what_if(court_suspension_option(Profile), court_is_court_first_seized, false, input_problems(_)).

cp_test_names([profile_keys_are_the_contract_keys, the_input_check_answers_once, status_gives_the_positive_verdict, status_gives_the_negative_verdict, status_gives_the_indeterminate_verdict, checklist_cites_every_mandate_item, checklist_marks_the_absent_compensation_law_unknown, checklist_for_compensation_without_mandate, checklist_cites_every_declining_item, checklist_reports_an_input_problem, what_if_attests_the_compensation_law, what_if_the_mandate_still_refers_on_compensation, what_if_overrides_a_present_key_without_duplicating, what_if_an_unsure_judgement_goes_to_a_lawyer]).
cp_test_fail_names([what_if_the_overridden_key_is_not_refused_twice]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
