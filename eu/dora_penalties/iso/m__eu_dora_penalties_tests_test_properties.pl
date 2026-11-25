% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_penalties_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_dora_penalties_kernel, [dora_penalties_input_problems/2]).
:- use_module(m__eu_dora_penalties_dora_penalties, [administrative_penalty_rules_required/3, minimum_powers/2, penalty_decision_safeguards/2, circumstances_to_take_into_account/2, criminal_penalty_liaison_duties/2, decide_dora_penalties/2]).
:- use_module(m__eu_dora_penalties_fixtures, [dora_penalties_subject/1, dora_penalties_profile_for/2]).

subject_classifies(Subject) :-
    dora_penalties_subject(Subject),
    dora_penalties_profile_for(Subject, Profile),
    decide_dora_penalties(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_penalties_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_one_answer_per_subject) :-
    findall(Subject, dora_penalties_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(one_answer_per_query, Subjects).
test(every_answer_has_an_allowed_shape) :-
    findall(Subject, dora_penalties_subject(Subject), Subjects),
    maplist(shapes_hold, Subjects).
test(input_problems_agree_across_queries) :-
    findall(Subject, dora_penalties_subject(Subject), Subjects),
    maplist(problems_agree, Subjects).
test(choice_not_read_when_breach_not_criminally_penalised) :-
    administrative_penalty_rules_required([attribute(breach_subject_to_criminal_penalties_under_national_law, false), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true)], FirstResult, FirstCitations),
    administrative_penalty_rules_required([attribute(breach_subject_to_criminal_penalties_under_national_law, false), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, false)], SecondResult, SecondCitations),
    FirstResult - FirstCitations == SecondResult - SecondCitations.
test(data_traffic_not_read_when_option_applies) :-
    minimum_powers([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true), attribute(national_law_permits_requiring_data_traffic_records, true), attribute(measures_applied_to_legal_person, false)], FirstPowers),
    minimum_powers([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true), attribute(national_law_permits_requiring_data_traffic_records, false), attribute(measures_applied_to_legal_person, false)], SecondPowers),
    FirstPowers == SecondPowers.
test(profile_order_does_not_change_the_answer) :-
    minimum_powers([attribute(measures_applied_to_legal_person, true), attribute(national_law_permits_requiring_data_traffic_records, true), attribute(breach_subject_to_criminal_penalties_under_national_law, false)], FirstPowers),
    minimum_powers([attribute(breach_subject_to_criminal_penalties_under_national_law, false), attribute(national_law_permits_requiring_data_traffic_records, true), attribute(measures_applied_to_legal_person, true)], SecondPowers),
    FirstPowers == SecondPowers.
test(an_absent_key_gives_a_status) :-
    minimum_powers([], indeterminate([breach_subject_to_criminal_penalties_under_national_law])).

one_answer_per_query(Subject) :-
    dora_penalties_profile_for(Subject, Profile),
    findall(Result - Citations, administrative_penalty_rules_required(Profile, Result, Citations), [_]),
    findall(Powers, minimum_powers(Profile, Powers), [_]),
    findall(Safeguards, penalty_decision_safeguards(Profile, Safeguards), [_]),
    findall(Circumstances, circumstances_to_take_into_account(Profile, Circumstances), [_]),
    findall(Duties, criminal_penalty_liaison_duties(Profile, Duties), [_]),
    findall(Verdict, decide_dora_penalties(Profile, Verdict), [_]),
    findall(Problems, dora_penalties_input_problems(Profile, Problems), [_]).

rules_shape(required, [_|_]).
rules_shape(not_required_criminal_penalties, [cite(eu_reg_2022_2554_art_52_1)]).
rules_shape(indeterminate([_]), []).
rules_shape(input_problems([_|_]), []).

supervisory_prefix([power(supervisory, access_to_documents_and_data, cite(eu_reg_2022_2554_art_50_2_a)), power(supervisory, on_site_inspections_and_investigations, cite(eu_reg_2022_2554_art_50_2_b)), power(supervisory, require_corrective_and_remedial_measures, cite(eu_reg_2022_2554_art_50_2_c))]).

powers_shape(indeterminate([_])).
powers_shape(input_problems([_|_])).
powers_shape(Powers) :-
    clausal_is_list(Powers),
    supervisory_prefix(Prefix),
    append(Prefix, _LaterPowers, Powers).

paired_shape(indeterminate([_])).
paired_shape(input_problems([_|_])).
paired_shape([]).
paired_shape([_FirstTerm, _SecondTerm]).

circumstances_shape(indeterminate([_])).
circumstances_shape(input_problems([_|_])).
circumstances_shape(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)])).
circumstances_shape([circumstance(intent_or_negligence, cite(eu_reg_2022_2554_art_51_2))|_]).

shapes_hold(Subject) :-
    dora_penalties_profile_for(Subject, Profile),
    administrative_penalty_rules_required(Profile, Result, Citations),
    rules_shape(Result, Citations),
    minimum_powers(Profile, Powers),
    powers_shape(Powers),
    penalty_decision_safeguards(Profile, Safeguards),
    paired_shape(Safeguards),
    criminal_penalty_liaison_duties(Profile, Duties),
    paired_shape(Duties),
    circumstances_to_take_into_account(Profile, Circumstances),
    circumstances_shape(Circumstances).

problems_agree(Subject) :-
    dora_penalties_profile_for(Subject, Profile),
    dora_penalties_input_problems(Profile, Problems),
    answers_agree(Problems, Profile).

answers_agree([], _).
answers_agree([Problem|Problems], Profile) :-
    administrative_penalty_rules_required(Profile, input_problems([Problem|Problems]), []),
    minimum_powers(Profile, input_problems([Problem|Problems])),
    penalty_decision_safeguards(Profile, input_problems([Problem|Problems])),
    circumstances_to_take_into_account(Profile, input_problems([Problem|Problems])),
    criminal_penalty_liaison_duties(Profile, input_problems([Problem|Problems])).

test(an_absent_key_is_not_a_final_powers_list, fail) :-
    minimum_powers([], Powers),
    clausal_is_list(Powers).

cp_test_names([totality_every_subject_classifies, determinism_every_query_one_answer_per_subject, every_answer_has_an_allowed_shape, input_problems_agree_across_queries, choice_not_read_when_breach_not_criminally_penalised, data_traffic_not_read_when_option_applies, profile_order_does_not_change_the_answer, an_absent_key_gives_a_status]).
cp_test_fail_names([an_absent_key_is_not_a_final_powers_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
