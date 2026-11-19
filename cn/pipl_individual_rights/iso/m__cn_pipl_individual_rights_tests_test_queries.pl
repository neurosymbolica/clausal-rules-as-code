% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_individual_rights_queries, [pipl_individual_rights_profile_keys/1, pipl_individual_rights_what_if/4]).
:- use_module(m__cn_pipl_individual_rights_kernel, [pipl_individual_rights_input_problems/2]).
:- use_module(m__cn_pipl_individual_rights_pipl_individual_rights, [decide_pipl_individual_rights/2, pipl_individual_rights_checklist/2]).
:- use_module(m__cn_pipl_individual_rights_fixtures, [pipl_individual_rights_profile_for/2, pipl_individual_rights_assess/2]).

cited_item(item(_, _, cite(_))).

test(profile_keys_are_the_contract_keys) :-
    pipl_individual_rights_profile_keys(ProfileKeys),
    ProfileKeys == [pinned_text_in_force_on_reference_day, laws_or_regulations_provide_otherwise, article_18_1_case, article_35_case, cyberspace_department_transfer_conditions_met, verification_confirms_inaccurate_or_incomplete, purpose_achieved_impossible_or_unnecessary, service_stopped_or_retention_period_expired, consent_withdrawn, processing_violates_law_or_agreement, other_deletion_case_prescribed_by_law, legal_retention_period_unexpired, deletion_technically_difficult, person_deceased, requester_is_near_relative, for_requester_own_lawful_and_legitimate_interests, deceased_arranged_otherwise, convenient_mechanism_established, request_refused, refusal_reasons_given].
test(the_reexported_input_check_answers_once) :-
    findall(Problems, pipl_individual_rights_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(eligibility_verdict_on_the_baseline) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    findall(Status, decide_pipl_individual_rights(Profile, pipl_individual_rights_verdict(Status, _)), Statuses),
    Statuses == [eligible].
test(eligibility_verdict_through_the_fixture_wrapper) :-
    findall(Status, pipl_individual_rights_assess(mechanism_not_convenient, pipl_individual_rights_verdict(Status, _)), Statuses),
    Statuses == [ineligible].
test(justification_every_item_carries_a_citation) :-
    pipl_individual_rights_profile_for(deletion_purpose_unsure, Profile),
    pipl_individual_rights_checklist(Profile, Items),
    length(Items, 9),
    maplist(cited_item, Items).
test(justification_referred_row_names_the_open_texture) :-
    pipl_individual_rights_profile_for(deletion_purpose_unsure, Profile),
    pipl_individual_rights_checklist(Profile, Items),
    member(item(article_47_deletion, referred(open_textured(purpose_achieved_impossible_or_unnecessary, cite(cn_pipl_art_47_p1_i1))), cite(cn_pipl_art_47_p1)), Items).
test(what_if_breaks_the_mechanism) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, convenient_mechanism_established, false, Status), Statuses),
    Statuses == [ineligible].
test(what_if_repairs_the_mechanism) :-
    pipl_individual_rights_profile_for(mechanism_not_convenient, Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, convenient_mechanism_established, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_resolves_a_duplicated_key) :-
    pipl_individual_rights_profile_for(input_duplicate_key, Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, consent_withdrawn, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_supplies_a_missing_key) :-
    pipl_individual_rights_profile_for(refusal_reasons_unstated, Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, refusal_reasons_given, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_refers_an_unsure_judgement) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, for_requester_own_lawful_and_legitimate_interests, unsure, Status), Statuses),
    Statuses == [referred_for_legal_review].
test(what_if_text_not_in_force) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, pinned_text_in_force_on_reference_day, false, Status), Statuses),
    Statuses == [text_not_in_force].

test(what_if_repaired_mechanism_is_not_ineligible, fail) :-
    pipl_individual_rights_profile_for(mechanism_not_convenient, Profile),
    pipl_individual_rights_what_if(Profile, convenient_mechanism_established, true, ineligible).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_answers_once, eligibility_verdict_on_the_baseline, eligibility_verdict_through_the_fixture_wrapper, justification_every_item_carries_a_citation, justification_referred_row_names_the_open_texture, what_if_breaks_the_mechanism, what_if_repairs_the_mechanism, what_if_resolves_a_duplicated_key, what_if_supplies_a_missing_key, what_if_refers_an_unsure_judgement, what_if_text_not_in_force]).
cp_test_fail_names([what_if_repaired_mechanism_is_not_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
