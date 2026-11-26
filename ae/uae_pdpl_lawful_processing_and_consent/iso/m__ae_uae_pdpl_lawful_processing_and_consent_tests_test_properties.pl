% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_lawful_processing_and_consent_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_uae_pdpl_lawful_processing_and_consent, [decide_uae_pdpl_lawful_processing_and_consent/2, pdpl_processing_lawful_basis/3, pdpl_consent_valid/3, pdpl_processing_controls/3]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_kernel, [uae_pdpl_lawful_processing_and_consent_input_problems/2]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_fixtures, [uae_pdpl_lawful_processing_and_consent_subject/1, uae_pdpl_lawful_processing_and_consent_profile_for/2]).

query_name(pdpl_processing_lawful_basis).
query_name(pdpl_consent_valid).
query_name(pdpl_processing_controls).

run_query(pdpl_processing_lawful_basis, Profile, Result, Citations) :-
    pdpl_processing_lawful_basis(Profile, Result, Citations).
run_query(pdpl_consent_valid, Profile, Result, Citations) :-
    pdpl_consent_valid(Profile, Result, Citations).
run_query(pdpl_processing_controls, Profile, Result, Citations) :-
    pdpl_processing_controls(Profile, Result, Citations).

subject_query_pairs(Pairs) :-
    findall(Subject - Query, (uae_pdpl_lawful_processing_and_consent_subject(Subject), query_name(Query)), Pairs).

subject_classifies(Subject) :-
    uae_pdpl_lawful_processing_and_consent_subject(Subject),
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    decide_uae_pdpl_lawful_processing_and_consent(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, uae_pdpl_lawful_processing_and_consent_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_each_subject_once) :-
    subject_query_pairs(Pairs),
    Pairs = [_|_],
    maplist(one_answer, Pairs).
test(determinism_the_input_check_answers_once) :-
    findall(Subject, uae_pdpl_lawful_processing_and_consent_subject(Subject), Subjects),
    maplist(one_problem_list, Subjects).
test(citation_form_final_results_cite_and_statuses_do_not) :-
    subject_query_pairs(Pairs),
    maplist(citation_form_holds, Pairs).
test(agreement_lawful_basis_and_consent_validity) :-
    findall(Subject, uae_pdpl_lawful_processing_and_consent_subject(Subject), Subjects),
    maplist(queries_agree, Subjects).
test(independence_controls_ignore_consent_and_case_keys) :-
    maplist(controls_ignore_consent, [valid_consent_no_case, consent_fails_given, consent_refused_case_contract, control_fails_fairness, control_fails_security, unsure_fairness_before_failing_purpose, unsure_fairness_next_control_unstated]).

one_answer(Subject - Query) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    findall(Result - Citations, run_query(Query, Profile, Result, Citations), [_]).

one_problem_list(Subject) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    findall(Problems, uae_pdpl_lawful_processing_and_consent_input_problems(Profile, Problems), [_]).

result_kind(indeterminate(_), pending).
result_kind(needs_legal_review(_, _), pending).
result_kind(input_problems(_), pending).
result_kind(allowed_with_consent, final).
result_kind(allowed_without_consent(_), final).
result_kind(not_allowed, final).
result_kind(not_in_force, final).
result_kind(valid, final).
result_kind(not_valid(_), final).
result_kind(meets_listed_controls, final).
result_kind(fails_control(_), final).

citations_fit(pending, []).
citations_fit(final, [Citation|Citations]) :-
    maplist(cite_term, [Citation|Citations]),
    sort([Citation|Citations], CitationSet),
    length([Citation|Citations], Count),
    length(CitationSet, Count).

cite_term(cite(Key)) :-
    atom(Key).

citation_form_holds(Subject - Query) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    run_query(Query, Profile, Result, Citations),
    result_kind(Result, Kind),
    citations_fit(Kind, Citations).

consent_lawful_agree(valid, allowed_with_consent).
consent_lawful_agree(ConsentResult, LawfulResult) :-
    dif(ConsentResult, valid),
    dif(LawfulResult, allowed_with_consent).

queries_agree(Subject) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    pdpl_consent_valid(Profile, ConsentResult, _),
    pdpl_processing_lawful_basis(Profile, LawfulResult, _),
    consent_lawful_agree(ConsentResult, LawfulResult).

consent_or_case_attribute(attribute(Key, _)) :-
    member(Key, [consent_given, consent_specific_clear_and_unambiguous, controller_able_to_prove_consent, consent_clear_simple_unambiguous_and_easily_accessible, consent_includes_right_to_withdraw_easily, consent_withdrawn_before_processing, necessary_to_protect_public_interest, personal_data_made_available_and_known_to_all_by_data_subject, necessary_for_legal_claims_defence_of_rights_or_judicial_or_security_procedures, necessary_for_occupational_or_preventive_medicine_or_health_or_social_care, necessary_to_protect_public_health, necessary_for_archival_purposes_or_scientific_historical_or_statistical_studies, necessary_to_protect_interests_of_data_subject, necessary_for_employment_social_security_or_social_protection_obligations_and_rights, necessary_for_contract_with_data_subject, necessary_for_specific_obligations_of_controller_under_other_laws]).

controls_ignore_consent(Subject) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    exclude(consent_or_case_attribute, Profile, ControlProfile),
    pdpl_processing_controls(Profile, Result, Citations),
    pdpl_processing_controls(ControlProfile, Result, Citations).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_each_subject_once, determinism_the_input_check_answers_once, citation_form_final_results_cite_and_statuses_do_not, agreement_lawful_basis_and_consent_validity, independence_controls_ignore_consent_and_case_keys]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
