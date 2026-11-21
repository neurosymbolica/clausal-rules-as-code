% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [gdpr_complaints_and_judicial_remedies_status_values/1, complaint_right/3, authority_decision_remedy_right/3, authority_inaction_remedy_right/4, controller_processor_remedy_right/3, controller_processor_forum/3]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_profile_for/2]).

test(the_status_table_holds_every_near_miss_atom) :-
    gdpr_complaints_and_judicial_remedies_status_values(StatusValues),
    subtract([no_complaint_right, no_decision_remedy_right, no_inaction_remedy_right, no_judicial_remedy_right, forum_establishment_state_only], StatusValues, Unlisted),
    Unlisted == [].
test(complaint_positive) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    complaint_right(Profile, complaint_right_exists, _).
test(complaint_near_miss_not_a_data_subject_gets_no_right) :-
    gdpr_complaints_and_judicial_remedies_profile_for(not_a_data_subject, Profile),
    complaint_right(Profile, no_complaint_right, _).
test(complaint_near_miss_no_consideration_gets_no_right) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_no_consideration, Profile),
    complaint_right(Profile, no_complaint_right, _).
test(decision_positive) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    authority_decision_remedy_right(Profile, decision_remedy_right_exists, _).
test(decision_near_miss_not_binding_gets_no_right) :-
    gdpr_complaints_and_judicial_remedies_profile_for(decision_not_binding, Profile),
    authority_decision_remedy_right(Profile, no_decision_remedy_right, _).
test(decision_near_miss_not_concerning_gets_no_right) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, false)], no_decision_remedy_right, _).
test(decision_unsure_refers) :-
    gdpr_complaints_and_judicial_remedies_profile_for(decision_unsure_binding, Profile),
    authority_decision_remedy_right(Profile, needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), _), []).
test(decision_unsure_concerning_refers_on_that_judgement) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, unsure)], needs_legal_review(open_textured(decision_concerns_the_caller, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - true, decision_concerns_the_caller - unsure])]), []).
test(decision_unsure_with_missing_names_the_missing_key) :-
    gdpr_complaints_and_judicial_remedies_profile_for(decision_unsure_and_missing, Profile),
    authority_decision_remedy_right(Profile, indeterminate([decision_concerns_the_caller]), []).
test(inaction_positive) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    authority_inaction_remedy_right(Profile, inaction_remedy_right_exists, _, _).
test(inaction_near_miss_not_competent_gets_no_right) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_competence_false, Profile),
    authority_inaction_remedy_right(Profile, no_inaction_remedy_right, [outside_fact(authority_competent_under_articles_55_and_56, attested(false, _))], _).
test(inaction_near_miss_competence_absent_refers) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_competence_absent, Profile),
    authority_inaction_remedy_right(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), _), [], []).
test(inaction_near_miss_no_complaint_gets_no_right) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, false), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, reason, none))), attribute(authority_handled_the_complaint, false)], no_inaction_remedy_right, [], _).
test(inaction_three_months_uninformed_positive) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_three_months_uninformed_handled_absent, Profile),
    authority_inaction_remedy_right(Profile, inaction_remedy_right_exists, _, _).
test(inaction_near_miss_informed_needs_handled) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_three_months_informed_handled_absent, Profile),
    authority_inaction_remedy_right(Profile, indeterminate([authority_handled_the_complaint]), [], []).
test(inaction_near_miss_handled_and_informed_gets_no_right) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_handled_and_informed, Profile),
    authority_inaction_remedy_right(Profile, no_inaction_remedy_right, [], _).
test(remedy_positive) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    controller_processor_remedy_right(Profile, judicial_remedy_right_exists, _).
test(remedy_near_miss_no_consideration_gets_no_right) :-
    gdpr_complaints_and_judicial_remedies_profile_for(remedy_no_consideration, Profile),
    controller_processor_remedy_right(Profile, no_judicial_remedy_right, _).
test(remedy_near_miss_not_a_data_subject_gets_no_right) :-
    gdpr_complaints_and_judicial_remedies_profile_for(not_a_data_subject, Profile),
    controller_processor_remedy_right(Profile, no_judicial_remedy_right, _).
test(forum_positive_both_states) :-
    gdpr_complaints_and_judicial_remedies_profile_for(full_positive, Profile),
    controller_processor_forum(Profile, forum_establishment_or_habitual_residence_state, _).
test(forum_near_miss_public_authority_establishment_only) :-
    gdpr_complaints_and_judicial_remedies_profile_for(forum_public_authority, Profile),
    controller_processor_forum(Profile, forum_establishment_state_only, _).

test(complaint_near_miss_not_a_data_subject_is_not_exists, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(not_a_data_subject, Profile),
    complaint_right(Profile, complaint_right_exists, _).
test(complaint_near_miss_no_consideration_is_not_exists, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_no_consideration, Profile),
    complaint_right(Profile, complaint_right_exists, _).
test(decision_near_miss_not_binding_is_not_exists, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(decision_not_binding, Profile),
    authority_decision_remedy_right(Profile, decision_remedy_right_exists, _).
test(decision_near_miss_not_concerning_is_not_exists, fail) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, false)], decision_remedy_right_exists, _).
test(decision_unsure_is_not_exists, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(decision_unsure_binding, Profile),
    authority_decision_remedy_right(Profile, decision_remedy_right_exists, _).
test(decision_unsure_with_missing_does_not_refer, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(decision_unsure_and_missing, Profile),
    authority_decision_remedy_right(Profile, needs_legal_review(_, _), _).
test(inaction_near_miss_not_competent_is_not_exists, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_competence_false, Profile),
    authority_inaction_remedy_right(Profile, inaction_remedy_right_exists, _, _).
test(inaction_near_miss_competence_absent_is_not_exists, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_competence_absent, Profile),
    authority_inaction_remedy_right(Profile, inaction_remedy_right_exists, _, _).
test(inaction_near_miss_no_complaint_is_not_exists, fail) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, false), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, reason, none))), attribute(authority_handled_the_complaint, false)], inaction_remedy_right_exists, _, _).
test(inaction_near_miss_informed_is_not_exists, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_three_months_informed_handled_absent, Profile),
    authority_inaction_remedy_right(Profile, inaction_remedy_right_exists, _, _).
test(inaction_near_miss_handled_and_informed_does_not_refer, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_handled_and_informed, Profile),
    authority_inaction_remedy_right(Profile, needs_legal_review(_, _), _, _).
test(remedy_near_miss_no_consideration_is_not_exists, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(remedy_no_consideration, Profile),
    controller_processor_remedy_right(Profile, judicial_remedy_right_exists, _).
test(forum_near_miss_public_authority_is_not_both, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(forum_public_authority, Profile),
    controller_processor_forum(Profile, forum_establishment_or_habitual_residence_state, _).
test(forum_missing_is_neither, fail) :-
    controller_processor_forum([], forum_establishment_or_habitual_residence_state, _).

cp_test_names([the_status_table_holds_every_near_miss_atom, complaint_positive, complaint_near_miss_not_a_data_subject_gets_no_right, complaint_near_miss_no_consideration_gets_no_right, decision_positive, decision_near_miss_not_binding_gets_no_right, decision_near_miss_not_concerning_gets_no_right, decision_unsure_refers, decision_unsure_concerning_refers_on_that_judgement, decision_unsure_with_missing_names_the_missing_key, inaction_positive, inaction_near_miss_not_competent_gets_no_right, inaction_near_miss_competence_absent_refers, inaction_near_miss_no_complaint_gets_no_right, inaction_three_months_uninformed_positive, inaction_near_miss_informed_needs_handled, inaction_near_miss_handled_and_informed_gets_no_right, remedy_positive, remedy_near_miss_no_consideration_gets_no_right, remedy_near_miss_not_a_data_subject_gets_no_right, forum_positive_both_states, forum_near_miss_public_authority_establishment_only]).
cp_test_fail_names([complaint_near_miss_not_a_data_subject_is_not_exists, complaint_near_miss_no_consideration_is_not_exists, decision_near_miss_not_binding_is_not_exists, decision_near_miss_not_concerning_is_not_exists, decision_unsure_is_not_exists, decision_unsure_with_missing_does_not_refer, inaction_near_miss_not_competent_is_not_exists, inaction_near_miss_competence_absent_is_not_exists, inaction_near_miss_no_complaint_is_not_exists, inaction_near_miss_informed_is_not_exists, inaction_near_miss_handled_and_informed_does_not_refer, remedy_near_miss_no_consideration_is_not_exists, forum_near_miss_public_authority_is_not_both, forum_missing_is_neither]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
