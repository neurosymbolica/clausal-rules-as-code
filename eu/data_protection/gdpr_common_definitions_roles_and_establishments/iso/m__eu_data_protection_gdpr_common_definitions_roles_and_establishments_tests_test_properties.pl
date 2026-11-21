% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [decide_gdpr_common_definitions_roles_and_establishments/2, party_is_controller/2, party_is_processor/2, genetic_data/2, biometric_data/2, data_concerning_health/2, main_establishment/2, enterprise/2, group_of_undertakings/2, supervisory_authority_concerned/2, cross_border_processing/2, relevant_and_reasoned_objection/2, roles_and_establishments_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_fixtures, [gdpr_common_definitions_roles_and_establishments_subject/1, gdpr_common_definitions_roles_and_establishments_profile_for/2]).

relation_name(party_is_controller).
relation_name(party_is_processor).
relation_name(genetic_data).
relation_name(biometric_data).
relation_name(data_concerning_health).
relation_name(main_establishment).
relation_name(enterprise).
relation_name(group_of_undertakings).
relation_name(supervisory_authority_concerned).
relation_name(cross_border_processing).
relation_name(relevant_and_reasoned_objection).

relation_answer(party_is_controller, Profile, Answer) :-
    party_is_controller(Profile, Answer).
relation_answer(party_is_processor, Profile, Answer) :-
    party_is_processor(Profile, Answer).
relation_answer(genetic_data, Profile, Answer) :-
    genetic_data(Profile, Answer).
relation_answer(biometric_data, Profile, Answer) :-
    biometric_data(Profile, Answer).
relation_answer(data_concerning_health, Profile, Answer) :-
    data_concerning_health(Profile, Answer).
relation_answer(main_establishment, Profile, Answer) :-
    main_establishment(Profile, Answer).
relation_answer(enterprise, Profile, Answer) :-
    enterprise(Profile, Answer).
relation_answer(group_of_undertakings, Profile, Answer) :-
    group_of_undertakings(Profile, Answer).
relation_answer(supervisory_authority_concerned, Profile, Answer) :-
    supervisory_authority_concerned(Profile, Answer).
relation_answer(cross_border_processing, Profile, Answer) :-
    cross_border_processing(Profile, Answer).
relation_answer(relevant_and_reasoned_objection, Profile, Answer) :-
    relevant_and_reasoned_objection(Profile, Answer).

subject_relation(Subject - RelationName) :-
    gdpr_common_definitions_roles_and_establishments_subject(Subject),
    relation_name(RelationName).

relation_answer_count(Subject, RelationName, AnswerCount) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    findall(Answer, relation_answer(RelationName, Profile, Answer), Answers),
    length(Answers, AnswerCount).

answered(Subject - RelationName) :-
    subject_relation(Subject - RelationName),
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    relation_answer(RelationName, Profile, _).

ground_atom(party_is_controller, determines_purposes_and_means).
ground_atom(party_is_controller, provided_for_by_law).
ground_atom(main_establishment, central_administration).
ground_atom(main_establishment, establishment_taking_decisions).
ground_atom(main_establishment, establishment_of_main_processing_activities).
ground_atom(main_establishment, not_established_in_more_than_one_member_state).
ground_atom(main_establishment, no_main_establishment_identified).
ground_atom(supervisory_authority_concerned, point_a).
ground_atom(supervisory_authority_concerned, point_b).
ground_atom(supervisory_authority_concerned, point_c).
ground_atom(cross_border_processing, point_a).
ground_atom(cross_border_processing, point_b).
ground_atom(RelationName, none) :-
    relation_name(RelationName).

citation_key(eu_reg_2016_679_art_4_1).
citation_key(eu_reg_2016_679_art_4_7).
citation_key(eu_reg_2016_679_art_4_8).
citation_key(eu_reg_2016_679_art_4_13).
citation_key(eu_reg_2016_679_art_4_14).
citation_key(eu_reg_2016_679_art_4_15).
citation_key(eu_reg_2016_679_art_4_16).
citation_key(eu_reg_2016_679_art_4_16_a).
citation_key(eu_reg_2016_679_art_4_16_b).
citation_key(eu_reg_2016_679_art_4_18).
citation_key(eu_reg_2016_679_art_4_19).
citation_key(eu_reg_2016_679_art_4_22).
citation_key(eu_reg_2016_679_art_4_22_a).
citation_key(eu_reg_2016_679_art_4_22_b).
citation_key(eu_reg_2016_679_art_4_22_c).
citation_key(eu_reg_2016_679_art_4_23).
citation_key(eu_reg_2016_679_art_4_23_a).
citation_key(eu_reg_2016_679_art_4_23_b).
citation_key(eu_reg_2016_679_art_4_24).
citation_key(union_or_member_state_law_providing_for_controller).

vocabulary_cite(cite(CitationKey)) :-
    citation_key(CitationKey).

cites_in_vocabulary(Citations) :-
    maplist(vocabulary_cite, Citations).

well_formed_answer(_, definition_answer(input_problems([_|_]), none, [])).
well_formed_answer(RelationName, definition_answer(met, Ground, [Citation|Citations])) :-
    ground_atom(RelationName, Ground),
    cites_in_vocabulary([Citation|Citations]).
well_formed_answer(RelationName, definition_answer(not_met, Ground, [Citation|Citations])) :-
    ground_atom(RelationName, Ground),
    cites_in_vocabulary([Citation|Citations]).
well_formed_answer(_, definition_answer(indeterminate([_|_]), none, [Citation|Citations])) :-
    cites_in_vocabulary([Citation|Citations]).
well_formed_answer(_, definition_answer(needs_legal_review(_, [_|_]), none, [Citation|Citations])) :-
    cites_in_vocabulary([Citation|Citations]).

well_formed_pair(Subject - RelationName) :-
    subject_relation(Subject - RelationName),
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    relation_answer(RelationName, Profile, Answer),
    well_formed_answer(RelationName, Answer).

outside_facts_well_formed([outside_fact(party_provided_for_as_controller_by_law, absent)]).
outside_facts_well_formed([outside_fact(party_provided_for_as_controller_by_law, attested(_, attestation(_, _, _, _)))]).
outside_facts_well_formed(input_problems([_|_])).

subject_outside_facts_count(Subject, AnswerCount) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    findall(OutsideFacts, roles_and_establishments_outside_facts(Profile, OutsideFacts), Results),
    length(Results, AnswerCount).

subject_outside_facts_well_formed(Subject) :-
    gdpr_common_definitions_roles_and_establishments_subject(Subject),
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    roles_and_establishments_outside_facts(Profile, OutsideFacts),
    outside_facts_well_formed(OutsideFacts).

subject_classifies(Subject) :-
    gdpr_common_definitions_roles_and_establishments_subject(Subject),
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    decide_gdpr_common_definitions_roles_and_establishments(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_common_definitions_roles_and_establishments_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(totality_every_relation_answers_every_subject) :-
    findall(Pair, subject_relation(Pair), Pairs),
    sort(Pairs, PairSet),
    findall(Pair, answered(Pair), AnsweredPairs),
    sort(AnsweredPairs, PairSet).
test(determinism_every_relation_answers_exactly_once) :-
    findall(AnswerCount, (subject_relation(Subject - RelationName), relation_answer_count(Subject, RelationName, AnswerCount)), AnswerCounts),
    sort(AnswerCounts, [1]).
test(determinism_the_verdict_is_given_once_per_subject) :-
    findall(VerdictCount, (gdpr_common_definitions_roles_and_establishments_subject(Subject), gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile), findall(Verdict, decide_gdpr_common_definitions_roles_and_establishments(Profile, Verdict), Verdicts), length(Verdicts, VerdictCount)), VerdictCounts),
    sort(VerdictCounts, [1]).
test(every_answer_is_well_formed) :-
    findall(Pair, subject_relation(Pair), Pairs),
    sort(Pairs, PairSet),
    findall(Pair, well_formed_pair(Pair), WellFormedPairs),
    sort(WellFormedPairs, PairSet).
test(determinism_outside_facts_answer_exactly_once) :-
    findall(AnswerCount, (gdpr_common_definitions_roles_and_establishments_subject(Subject), subject_outside_facts_count(Subject, AnswerCount)), AnswerCounts),
    sort(AnswerCounts, [1]).
test(outside_facts_are_well_formed_for_every_subject) :-
    findall(Subject, gdpr_common_definitions_roles_and_establishments_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_outside_facts_well_formed(Subject), WellFormedSubjects),
    sort(WellFormedSubjects, SubjectSet).
test(an_unread_key_does_not_change_the_processor) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(cloud_processor, Profile),
    party_is_processor(Profile, Answer),
    party_is_processor([attribute(objection_to_draft_decision, true), attribute(party_role, controller)|Profile], Answer).
test(an_unread_key_does_not_change_genetic_data) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(genetic_test_laboratory, Profile),
    genetic_data(Profile, Answer),
    genetic_data([attribute(data_relate_to_health_and_reveal_health_status, unsure)|Profile], Answer).
test(the_controller_path_never_reads_processor_obligations) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(controller_without_main_establishment, Profile),
    main_establishment(Profile, Answer),
    main_establishment([attribute(processor_subject_to_specific_obligations, true)|Profile], Answer).
test(the_processor_path_never_reads_the_decision_keys) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(processor_without_specific_obligations, Profile),
    main_establishment(Profile, Answer),
    main_establishment([attribute(decisions_taken_in_other_union_establishment, true), attribute(other_establishment_can_have_decisions_implemented, true)|Profile], Answer).
test(step_one_ignores_the_role) :-
    main_establishment([attribute(established_in_more_than_one_member_state, false), attribute(party_role, processor)], definition_answer(not_met, not_established_in_more_than_one_member_state, [cite(eu_reg_2016_679_art_4_16), cite(eu_reg_2016_679_art_4_16_b)])).

cp_test_names([totality_every_subject_classifies, totality_every_relation_answers_every_subject, determinism_every_relation_answers_exactly_once, determinism_the_verdict_is_given_once_per_subject, every_answer_is_well_formed, determinism_outside_facts_answer_exactly_once, outside_facts_are_well_formed_for_every_subject, an_unread_key_does_not_change_the_processor, an_unread_key_does_not_change_genetic_data, the_controller_path_never_reads_processor_obligations, the_processor_path_never_reads_the_decision_keys, step_one_ignores_the_role]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
