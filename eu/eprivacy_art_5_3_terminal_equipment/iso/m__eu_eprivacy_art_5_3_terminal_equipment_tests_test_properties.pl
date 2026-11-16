% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(clausal_hof, [include/3]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_eprivacy_art_5_3_terminal_equipment, [terminal_equipment_storage_or_access_permitted/3, decide_eprivacy_art_5_3_terminal_equipment/2]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_queries, [eprivacy_art_5_3_terminal_equipment_profile_keys/1]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_fixtures, [eprivacy_art_5_3_terminal_equipment_subject/1, eprivacy_art_5_3_terminal_equipment_profile_for/2]).

subject_classifies(Subject) :-
    eprivacy_art_5_3_terminal_equipment_subject(Subject),
    eprivacy_art_5_3_terminal_equipment_profile_for(Subject, Profile),
    decide_eprivacy_art_5_3_terminal_equipment(Profile, _Verdict).

all_subjects(Subjects) :-
    findall(Subject, eprivacy_art_5_3_terminal_equipment_subject(Subject), Subjects).

profile_answers(Profile, Answers) :-
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted(Profile, Result, Citations), Answers).

profile_has_exactly_one_answer(Profile) :-
    profile_answers(Profile, Answers),
    length(Answers, 1).

subject_has_exactly_one_answer(Subject) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(Subject, Profile),
    profile_has_exactly_one_answer(Profile).

citations_fit(permitted, [cite(eu_dir_2002_58_art_5_3)]).
citations_fit(not_permitted, [cite(eu_dir_2002_58_art_5_3)]).
citations_fit(not_applicable, [cite(eu_dir_2002_58_art_5_3)]).
citations_fit(indeterminate([_MissingKey]), []).
citations_fit(needs_legal_review(open_textured(_Key, cite(_CitationKey)), [inputs_relied_on(_Pairs)]), []).
citations_fit(input_problems([_FirstProblem|_LaterProblems]), []).

subject_citations_fit(Subject) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(Subject, Profile),
    terminal_equipment_storage_or_access_permitted(Profile, Result, Citations),
    citations_fit(Result, Citations).

referral_citation_key(eu_dir_2002_58_art_5_3_s1).
referral_citation_key(eu_dir_2002_58_art_5_3_s2).
referral_citation_key(eu_dir_2002_58_art_2_f).

ordered_sublist([], _).
ordered_sublist([Key|Keys], [Key|ContractKeys]) :-
    ordered_sublist(Keys, ContractKeys).
ordered_sublist([Key|Keys], [ContractKey|ContractKeys]) :-
    dif(Key, ContractKey),
    ordered_sublist([Key|Keys], ContractKeys).

referral_is_well_formed(needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])) :-
    eprivacy_art_5_3_terminal_equipment_profile_keys(ContractKeys),
    member(Key, ContractKeys),
    referral_citation_key(CitationKey),
    pairs_keys(Pairs, PairKeys),
    ordered_sublist(PairKeys, ContractKeys).

subject_referral_well_formed(Subject) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(Subject, Profile),
    terminal_equipment_storage_or_access_permitted(Profile, Result, _Citations),
    result_well_formed(Result).

result_well_formed(permitted).
result_well_formed(not_permitted).
result_well_formed(not_applicable).
result_well_formed(indeterminate([Key])) :-
    eprivacy_art_5_3_terminal_equipment_profile_keys(ContractKeys),
    member(Key, ContractKeys).
result_well_formed(needs_legal_review(Reason, Context)) :-
    referral_is_well_formed(needs_legal_review(Reason, Context)).
result_well_formed(input_problems([_FirstProblem|_LaterProblems])).

judgement_value(true).
judgement_value(false).
judgement_value(unsure).

complete_profile(Scope, Profile) :-
    judgement_value(Transmission),
    judgement_value(Requested),
    judgement_value(Necessary),
    judgement_value(Consent),
    judgement_value(Information),
    Profile = [attribute(storage_or_access_in_terminal_equipment, Scope), attribute(storage_or_access_solely_for_transmission, Transmission), attribute(service_explicitly_requested_by_user, Requested), attribute(strictly_necessary_to_provide_requested_service, Necessary), attribute(user_consent_given, Consent), attribute(clear_and_comprehensive_information_provided, Information)].

complete_profiles(Scope, Profiles) :-
    findall(Profile, complete_profile(Scope, Profile), Profiles).

has_attribute(Key, Value, Profile) :-
    member(attribute(Key, Value), Profile).

complete_in_scope_result(permitted).
complete_in_scope_result(not_permitted).
complete_in_scope_result(needs_legal_review(open_textured(_Key, cite(_CitationKey)), [inputs_relied_on([_, _, _, _, _, _])])).

complete_in_scope_answer_fits(Profile) :-
    profile_answers(Profile, [Result - _Citations]),
    complete_in_scope_result(Result).

complete_out_of_scope_is_not_applicable(Profile) :-
    profile_answers(Profile, [not_applicable - [cite(eu_dir_2002_58_art_5_3)]]).

complete_scope_unsure_refers_on_the_scope(Profile) :-
    profile_answers(Profile, [needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([_, _, _, _, _, _])]) - []]).

complete_transmission_true_is_permitted(Profile) :-
    profile_answers(Profile, [permitted - [cite(eu_dir_2002_58_art_5_3)]]).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_answer) :-
    all_subjects(Subjects),
    maplist(subject_has_exactly_one_answer, Subjects).
test(citation_completeness_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_citations_fit, Subjects).
test(every_subject_result_is_well_formed) :-
    all_subjects(Subjects),
    maplist(subject_referral_well_formed, Subjects).
test(determinism_every_complete_profile_in_scope) :-
    complete_profiles(true, Profiles),
    length(Profiles, 243),
    maplist(profile_has_exactly_one_answer, Profiles).
test(complete_profiles_in_scope_never_ask_for_a_key) :-
    complete_profiles(true, Profiles),
    maplist(complete_in_scope_answer_fits, Profiles).
test(scope_false_is_not_applicable_whatever_else) :-
    complete_profiles(false, Profiles),
    maplist(complete_out_of_scope_is_not_applicable, Profiles).
test(scope_unsure_with_nothing_absent_always_refers_on_the_scope) :-
    complete_profiles(unsure, Profiles),
    maplist(complete_scope_unsure_refers_on_the_scope, Profiles).
test(transmission_met_permits_whatever_else) :-
    complete_profiles(true, Profiles),
    include(has_attribute(storage_or_access_solely_for_transmission, true), Profiles, TransmissionProfiles),
    length(TransmissionProfiles, 81),
    maplist(complete_transmission_true_is_permitted, TransmissionProfiles).

test(a_wrong_citation_set_does_not_fit, fail) :-
    citations_fit(indeterminate([storage_or_access_in_terminal_equipment]), [cite(eu_dir_2002_58_art_5_3)]).
test(pairs_out_of_contract_order_are_rejected, fail) :-
    referral_is_well_formed(needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_2_f)), [inputs_relied_on([user_consent_given - unsure, storage_or_access_in_terminal_equipment - true])])).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_answer, citation_completeness_every_subject, every_subject_result_is_well_formed, determinism_every_complete_profile_in_scope, complete_profiles_in_scope_never_ask_for_a_key, scope_false_is_not_applicable_whatever_else, scope_unsure_with_nothing_absent_always_refers_on_the_scope, transmission_met_permits_whatever_else]).
cp_test_fail_names([a_wrong_citation_set_does_not_fit, pairs_out_of_contract_order_are_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
