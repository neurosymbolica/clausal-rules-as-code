% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [complaint_right/3, authority_decision_remedy_right/3, authority_inaction_remedy_right/4, controller_processor_remedy_right/3, controller_processor_forum/3, gdpr_complaints_and_judicial_remedies_status/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_profile_for/2]).

test(complaint_right_bound_exists) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    complaint_right(Profile, complaint_right_exists, [cite(eu_reg_2016_679_art_77_1)]).
test(complaint_right_bound_no_right) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_no_consideration, Profile),
    complaint_right(Profile, no_complaint_right, [cite(eu_reg_2016_679_art_77_1)]).
test(decision_remedy_bound_exists) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    authority_decision_remedy_right(Profile, decision_remedy_right_exists, [cite(eu_reg_2016_679_art_78_1)]).
test(decision_remedy_bound_referral) :-
    gdpr_complaints_and_judicial_remedies_profile_for(decision_unsure_binding, Profile),
    authority_decision_remedy_right(Profile, needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])]), []).
test(inaction_remedy_bound_exists_with_basis) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    authority_inaction_remedy_right(Profile, inaction_remedy_right_exists, [outside_fact(authority_competent_under_articles_55_and_56, attested(true, _))], [cite(eu_reg_2016_679_art_78_2)]).
test(inaction_remedy_bound_referral) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_competence_absent, Profile),
    authority_inaction_remedy_right(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]), [], []).
test(controller_processor_remedy_bound_exists) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    controller_processor_remedy_right(Profile, judicial_remedy_right_exists, [cite(eu_reg_2016_679_art_79_1)]).
test(forum_bound_both_states) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    controller_processor_forum(Profile, forum_establishment_or_habitual_residence_state, [cite(eu_reg_2016_679_art_79_2)]).
test(forum_bound_establishment_only) :-
    gdpr_complaints_and_judicial_remedies_profile_for(forum_public_authority, Profile),
    controller_processor_forum(Profile, forum_establishment_state_only, [cite(eu_reg_2016_679_art_79_2)]).
test(status_bound_answer) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    gdpr_complaints_and_judicial_remedies_status(Profile, answer(controller_processor_forum, forum_establishment_or_habitual_residence_state)).
test(key_order_does_not_change_any_answer) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    reverse(Profile, ReversedProfile),
    findall(Status, gdpr_complaints_and_judicial_remedies_status(Profile, Status), Statuses),
    findall(Status, gdpr_complaints_and_judicial_remedies_status(ReversedProfile, Status), ReversedStatuses),
    ReversedStatuses == Statuses.
test(a_quoted_string_value_is_wrong_type) :-
    complaint_right([attribute(is_data_subject, "true")], Result, Citations),
    Result == input_problems([wrong_type(is_data_subject)]),
    Citations == [].
test(a_judgement_outside_the_three_values_is_wrong_type) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, maybe)], Result, _),
    Result == input_problems([wrong_type(decision_is_legally_binding)]).
test(a_bare_outside_fact_is_wrong_type) :-
    authority_inaction_remedy_right([attribute(authority_competent_under_articles_55_and_56, true)], Result, Basis, Citations),
    Result == input_problems([wrong_type(authority_competent_under_articles_55_and_56)]),
    Basis == [],
    Citations == [].
test(a_number_key_is_an_unknown_key) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(an_unbound_value_is_wrong_type) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(defendant_is_member_state_public_authority_acting_in_public_powers, attested(true, attestation(host, at, reason, none)))], Problems),
    Problems == [wrong_type(defendant_is_member_state_public_authority_acting_in_public_powers)].
test(an_unbound_profile_is_refused_by_the_input_check) :-
    gdpr_complaints_and_judicial_remedies_input_problems(42, Problems),
    Problems == [wrong_type(profile)].
test(a_non_list_profile_is_refused_by_every_query) :-
    complaint_right(not_a_profile, ComplaintResult, _),
    ComplaintResult == input_problems([wrong_type(profile)]),
    controller_processor_forum(not_a_profile, ForumResult, _),
    ForumResult == input_problems([wrong_type(profile)]).
test(a_pair_list_is_not_a_profile) :-
    controller_processor_remedy_right([is_data_subject - true], Result, _),
    Result == input_problems([wrong_type(profile)]).
test(a_present_unread_key_is_still_checked) :-
    complaint_right([attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, true), attribute(three_months_from_the_complaint_have_passed, unsure)], Result, _),
    Result == input_problems([wrong_type(three_months_from_the_complaint_have_passed)]).

test(complaint_right_bound_wrong_verdict_rejected, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    complaint_right(Profile, no_complaint_right, _).
test(decision_remedy_bound_exists_rejected_when_unsure, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(decision_unsure_binding, Profile),
    authority_decision_remedy_right(Profile, decision_remedy_right_exists, _).
test(inaction_remedy_bound_exists_rejected_without_competence, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_competence_absent, Profile),
    authority_inaction_remedy_right(Profile, inaction_remedy_right_exists, _, _).
test(controller_processor_remedy_bound_wrong_verdict_rejected, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(remedy_no_consideration, Profile),
    controller_processor_remedy_right(Profile, judicial_remedy_right_exists, _).
test(forum_bound_wrong_verdict_rejected, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(forum_public_authority, Profile),
    controller_processor_forum(Profile, forum_establishment_or_habitual_residence_state, _).

cp_test_names([complaint_right_bound_exists, complaint_right_bound_no_right, decision_remedy_bound_exists, decision_remedy_bound_referral, inaction_remedy_bound_exists_with_basis, inaction_remedy_bound_referral, controller_processor_remedy_bound_exists, forum_bound_both_states, forum_bound_establishment_only, status_bound_answer, key_order_does_not_change_any_answer, a_quoted_string_value_is_wrong_type, a_judgement_outside_the_three_values_is_wrong_type, a_bare_outside_fact_is_wrong_type, a_number_key_is_an_unknown_key, an_unbound_value_is_wrong_type, an_unbound_profile_is_refused_by_the_input_check, a_non_list_profile_is_refused_by_every_query, a_pair_list_is_not_a_profile, a_present_unread_key_is_still_checked]).
cp_test_fail_names([complaint_right_bound_wrong_verdict_rejected, decision_remedy_bound_exists_rejected_when_unsure, inaction_remedy_bound_exists_rejected_without_competence, controller_processor_remedy_bound_wrong_verdict_rejected, forum_bound_wrong_verdict_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
