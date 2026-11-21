% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, decide_gdpr_compensation_and_liability/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_kernel, [gdpr_compensation_and_liability_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_subject/1, gdpr_compensation_and_liability_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_compensation_and_liability_subject(Subject),
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    decide_gdpr_compensation_and_liability(Profile, _Verdict).

subject_has_one_answer(Subject) :-
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    profile_has_one_answer(Profile).

profile_has_one_answer(Profile) :-
    findall(Result - Basis - Citations, compensation_liability(Profile, Result, Basis, Citations), Answers),
    length(Answers, 1).

judgement_choice(true).
judgement_choice(false).
judgement_choice(unsure).
judgement_choice(absent).

statement_choice(absent).
statement_choice(attested(true, attestation(host, at, reason, none))).
statement_choice(attested(false, attestation(host, at, reason, none))).

caller_choice([]).
caller_choice([attribute(party_role, controller)]).
caller_choice([attribute(party_role, controller), attribute(involved_in_the_processing, true)]).
caller_choice([attribute(party_role, controller), attribute(involved_in_the_processing, false)]).
caller_choice([attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, true)]).
caller_choice([attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, false)]).
caller_choice([attribute(party_role, processor), attribute(processor_breached_obligations_directed_to_processors, false), attribute(processor_acted_outside_or_contrary_to_lawful_instructions, false)]).

optional_attribute(_, absent, []).
optional_attribute(ProfileKey, Value, [attribute(ProfileKey, Value)]) :-
    dif(Value, absent).

grid_case(case([DamageValue, InfringementValue, CausationValue], Profile)) :-
    caller_choice(CallerAttributes),
    judgement_choice(DamageValue),
    judgement_choice(InfringementValue),
    judgement_choice(CausationValue),
    statement_choice(StatementValue),
    optional_attribute(damage_suffered, DamageValue, DamageAttributes),
    optional_attribute(infringement_of_the_regulation_occurred, InfringementValue, InfringementAttributes),
    optional_attribute(damage_resulted_from_the_infringement, CausationValue, CausationAttributes),
    optional_attribute(not_in_any_way_responsible_for_the_event, StatementValue, StatementAttributes),
    append([CallerAttributes, DamageAttributes, InfringementAttributes, CausationAttributes, StatementAttributes], Profile).

grid_cases(Cases) :-
    findall(Case, grid_case(Case), Cases).

result_kind(right_not_established, final).
result_kind(not_liable_for_damage, final).
result_kind(exempt_from_liability, final).
result_kind(liable_for_damage, final).
result_kind(indeterminate(_), missing).
result_kind(needs_legal_review(_, _), referral).
result_kind(input_problems(_), refused).

pending_kind(missing).
pending_kind(referral).

allowed_citation(cite(eu_reg_2016_679_art_82_1)).
allowed_citation(cite(eu_reg_2016_679_art_82_2)).
allowed_citation(cite(eu_reg_2016_679_art_82_3)).

citations_fit_kind(final, [FirstCitation|OtherCitations]) :-
    maplist(allowed_citation, [FirstCitation|OtherCitations]).
citations_fit_kind(missing, []).
citations_fit_kind(referral, []).
citations_fit_kind(refused, []).

basis_fits_result(right_not_established, _, []).
basis_fits_result(not_liable_for_damage, _, []).
basis_fits_result(exempt_from_liability, Profile, [outside_fact(not_in_any_way_responsible_for_the_event, Attested)]) :-
    member(attribute(not_in_any_way_responsible_for_the_event, Attested), Profile),
    Attested = attested(true, _).
basis_fits_result(liable_for_damage, Profile, [outside_fact(not_in_any_way_responsible_for_the_event, Attested)]) :-
    member(attribute(not_in_any_way_responsible_for_the_event, Attested), Profile),
    Attested = attested(false, _).
basis_fits_result(indeterminate(_), _, []).
basis_fits_result(needs_legal_review(_, _), _, []).
basis_fits_result(input_problems(_), _, []).

named_key_fits(missing, indeterminate([MissingKey])) :-
    dif(MissingKey, not_in_any_way_responsible_for_the_event).
named_key_fits(final, _).
named_key_fits(referral, _).
named_key_fits(refused, _).

unsure_guard(true, _, right_not_established).
unsure_guard(false, true, Result) :-
    result_kind(Result, Kind),
    pending_kind(Kind).
unsure_guard(false, false, Result) :-
    result_kind(Result, Kind),
    dif(Kind, refused).

case_has_one_answer(case(_, Profile)) :-
    profile_has_one_answer(Profile).

case_is_well_formed(case(_, Profile)) :-
    gdpr_compensation_and_liability_input_problems(Profile, []).

case_respects_unsure(case(JudgementValues, Profile)) :-
    compensation_liability(Profile, Result, _Basis, _Citations),
    memberd_t(false, JudgementValues, HasFalse),
    memberd_t(unsure, JudgementValues, HasUnsure),
    unsure_guard(HasFalse, HasUnsure, Result).

case_cites_and_bases_correctly(case(_, Profile)) :-
    compensation_liability(Profile, Result, Basis, Citations),
    result_kind(Result, Kind),
    citations_fit_kind(Kind, Citations),
    basis_fits_result(Result, Profile, Basis),
    named_key_fits(Kind, Result).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_compensation_and_liability_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_answer) :-
    findall(Subject, gdpr_compensation_and_liability_subject(Subject), Subjects),
    maplist(subject_has_one_answer, Subjects).
test(the_grid_has_every_combination) :-
    grid_cases(Cases),
    length(Cases, 1344).
test(grid_every_profile_is_well_formed) :-
    grid_cases(Cases),
    maplist(case_is_well_formed, Cases).
test(grid_every_profile_has_exactly_one_answer) :-
    grid_cases(Cases),
    maplist(case_has_one_answer, Cases).
test(grid_a_final_answer_never_rests_on_an_unsure_judgement) :-
    grid_cases(Cases),
    maplist(case_respects_unsure, Cases).
test(grid_citations_and_basis_fit_the_result) :-
    grid_cases(Cases),
    maplist(case_cites_and_bases_correctly, Cases).

test(the_unsure_guard_rejects_a_final_answer, fail) :-
    unsure_guard(false, true, liable_for_damage).
test(the_citation_check_rejects_a_shortened_key, fail) :-
    citations_fit_kind(final, [cite(art_82_1)]).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_answer, the_grid_has_every_combination, grid_every_profile_is_well_formed, grid_every_profile_has_exactly_one_answer, grid_a_final_answer_never_rests_on_an_unsure_judgement, grid_citations_and_basis_fit_the_result]).
cp_test_fail_names([the_unsure_guard_rejects_a_final_answer, the_citation_check_rejects_a_shortened_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
