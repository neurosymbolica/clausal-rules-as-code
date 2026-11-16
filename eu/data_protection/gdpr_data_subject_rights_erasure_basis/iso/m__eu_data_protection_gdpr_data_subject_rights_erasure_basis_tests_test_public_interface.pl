% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [request_basis/2, decide_request_basis/2, request_basis_status/2, request_basis_checklist/2, request_basis_decision_resolvable/1, request_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_fixtures, [gdpr_data_subject_rights_erasure_basis_subject/1, gdpr_data_subject_rights_erasure_basis_profile_for/2, gdpr_data_subject_rights_erasure_basis_assess/2]).

status_of(Subject, Status) :-
    gdpr_data_subject_rights_erasure_basis_assess(Subject, request_basis_verdict(Status, _Citations)).

test(every_subject_is_registered) :-
    findall(Subject, gdpr_data_subject_rights_erasure_basis_subject(Subject), Subjects),
    length(Subjects, 22).
test(every_status_is_in_the_vocabulary) :-
    status_of(necessity_no_longer, Status),
    request_basis_status_values(Values),
    member(Status, Values).
test(no_ground_engaged_gives_none) :-
    status_of(no_ground_engaged, none).
test(necessity_no_longer_gives_a) :-
    status_of(necessity_no_longer, art17_1_a).
test(necessity_unsure_is_referred_and_gives_none) :-
    status_of(necessity_unsure, none).
test(consent_withdrawn_gives_b) :-
    status_of(consent_withdrawn_no_other_ground, art17_1_b).
test(another_ground_for_processing_blocks_b) :-
    status_of(consent_withdrawn_other_ground_exists, none).
test(objection_without_overriding_grounds_gives_c) :-
    status_of(objection_21_1_without_overriding, art17_1_c).
test(overriding_grounds_block_c) :-
    status_of(objection_21_1_with_overriding, none).
test(art21_2_objection_gives_c) :-
    status_of(objection_21_2, art17_1_c).
test(unlawful_processing_gives_d) :-
    status_of(unlawfully_processed, art17_1_d).
test(attested_law_gives_e) :-
    status_of(law_requires_erasure, art17_1_e).
test(unattested_law_is_referred_and_gives_none) :-
    status_of(law_requires_erasure_unattested, none).
test(information_society_offer_gives_f) :-
    status_of(information_society_offer, art17_1_f).
test(freedom_of_expression_relieves_but_keeps_the_basis) :-
    gdpr_data_subject_rights_erasure_basis_assess(freedom_of_expression_exception, request_basis_verdict(art17_1_a, Citations)),
    Citations == [cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_17_3_a)].
test(no_freedom_of_expression_necessity_leaves_only_the_basis) :-
    gdpr_data_subject_rights_erasure_basis_assess(freedom_of_expression_not_necessary, request_basis_verdict(art17_1_a, Citations)),
    Citations == [cite(eu_reg_2016_679_art_17_1_a)].
test(manifestly_excessive_request_is_cited) :-
    gdpr_data_subject_rights_erasure_basis_assess(manifestly_excessive_request, request_basis_verdict(art17_1_a, Citations)),
    Citations == [cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_12_5)].
test(a_request_not_excessive_leaves_only_the_basis) :-
    gdpr_data_subject_rights_erasure_basis_assess(request_not_excessive, request_basis_verdict(art17_1_a, Citations)),
    Citations == [cite(eu_reg_2016_679_art_17_1_a)].
test(unable_to_identify_is_cited) :-
    gdpr_data_subject_rights_erasure_basis_assess(unable_to_identify, request_basis_verdict(art17_1_a, Citations)),
    Citations == [cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_12_2)].
test(legislative_restriction_is_cited) :-
    gdpr_data_subject_rights_erasure_basis_assess(legislative_restriction, request_basis_verdict(art17_1_a, Citations)),
    Citations == [cite(eu_reg_2016_679_art_17_1_a), cite(eu_reg_2016_679_art_23_1)].
test(unconfirmed_identity_suspends_and_gives_none) :-
    status_of(identity_doubts_unconfirmed, none).
test(confirmed_identity_gives_a) :-
    status_of(identity_doubts_confirmed, art17_1_a).
test(missing_keys_give_none) :-
    status_of(request_type_only, none).
test(an_input_problem_gives_none) :-
    status_of(unknown_key_present, none).
test(the_same_profile_without_the_unknown_key_gives_a) :-
    status_of(necessity_no_longer, art17_1_a).
test(request_basis_gives_a_on_a_profile) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    request_basis(Profile, art17_1_a).
test(request_basis_gives_none_on_the_control_profile) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(no_ground_engaged, Profile),
    request_basis(Profile, none).
test(status_projection_agrees) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(objection_21_2, Profile),
    request_basis_status(Profile, art17_1_c).
test(the_decision_is_resolvable) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(unlawfully_processed, Profile),
    request_basis_decision_resolvable(Profile).
test(checklist_marks_the_met_ground_with_its_citation) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    request_basis_checklist(Profile, [_FirstItem|_OtherItems]),
    request_basis_checklist(Profile, Items),
    member(item(art17_1_a, met, cite(eu_reg_2016_679_art_17_1_a)), Items).
test(checklist_marks_the_control_ground_unmet) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(no_ground_engaged, Profile),
    request_basis_checklist(Profile, Items),
    member(item(art17_1_a, unmet, cite(eu_reg_2016_679_art_17_1_a)), Items).
test(checklist_is_not_empty_for_an_input_problem) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(unknown_key_present, Profile),
    request_basis_checklist(Profile, [_FirstItem|_OtherItems]).

cp_test_names([every_subject_is_registered, every_status_is_in_the_vocabulary, no_ground_engaged_gives_none, necessity_no_longer_gives_a, necessity_unsure_is_referred_and_gives_none, consent_withdrawn_gives_b, another_ground_for_processing_blocks_b, objection_without_overriding_grounds_gives_c, overriding_grounds_block_c, art21_2_objection_gives_c, unlawful_processing_gives_d, attested_law_gives_e, unattested_law_is_referred_and_gives_none, information_society_offer_gives_f, freedom_of_expression_relieves_but_keeps_the_basis, no_freedom_of_expression_necessity_leaves_only_the_basis, manifestly_excessive_request_is_cited, a_request_not_excessive_leaves_only_the_basis, unable_to_identify_is_cited, legislative_restriction_is_cited, unconfirmed_identity_suspends_and_gives_none, confirmed_identity_gives_a, missing_keys_give_none, an_input_problem_gives_none, the_same_profile_without_the_unknown_key_gives_a, request_basis_gives_a_on_a_profile, request_basis_gives_none_on_the_control_profile, status_projection_agrees, the_decision_is_resolvable, checklist_marks_the_met_ground_with_its_citation, checklist_marks_the_control_ground_unmet, checklist_is_not_empty_for_an_input_problem]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
