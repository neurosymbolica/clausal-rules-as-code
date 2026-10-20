:- module(m__eu_procurement_life_cycle_costing_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [decide_lcc_method_validity/2, decide_lcc_mandatory_method/2, decide_lcc_computation/2, life_cycle_costing_input_problem/3, lcc_total/2, lcc_externality_assessment/2, lcc_method_validity_limb_status/4]).
:- use_module(m__eu_procurement_life_cycle_costing_queries, [life_cycle_costing_calculation/2]).
:- use_module(m__eu_procurement_life_cycle_costing_fixtures, [life_cycle_costing_subject/1, life_cycle_costing_profile_for/2]).
:- use_module(query_combinators, [override_key/4]).

method_validity_outcome(Profile, Outcome) :-
    catch((findall(Verdict, decide_lcc_method_validity(Profile, Verdict), Verdicts), Outcome = answers(Verdicts)), Caught, Outcome = raised(Caught)).

mandatory_method_outcome(Profile, Outcome) :-
    catch((findall(Verdict, decide_lcc_mandatory_method(Profile, Verdict), Verdicts), Outcome = answers(Verdicts)), Caught, Outcome = raised(Caught)).

computation_outcome(Profile, Outcome) :-
    catch((findall(Verdict, decide_lcc_computation(Profile, Verdict), Verdicts), Outcome = answers(Verdicts)), Caught, Outcome = raised(Caught)).

computation_not_definite(answers([])).
computation_not_definite(answers([lcc_computation_verdict(lcc_indeterminate, _, _)])).

profile_without(Subject, Key, Profile) :-
    life_cycle_costing_profile_for(Subject, Base),
    dict_without_key(Base, Key, Profile).

profile_with(Subject, Key, Value, Profile) :-
    life_cycle_costing_profile_for(Subject, Base),
    override_key(Base, Key, Value, Profile).

dict_without_key(Dict, Key, NewDict) :-
    dict_pairs(Dict, Pairs),
    findall(OtherKey - Value, (member(OtherKey - Value, Pairs), dif(OtherKey, Key)), KeptPairs),
    dict_pairs(NewDict, KeptPairs).

not_established_base(Profile) :-
    profile_with("externality_compliant", externality_method_established_for_repeated_or_continuous_application, false, Profile).

test('control: externality_compliant is valid_lcc_method, exactly one answer') :-
    life_cycle_costing_profile_for("externality_compliant", Profile),
    method_validity_outcome(Profile, answers([lcc_method_validity_verdict(valid_lcc_method, [], [])])).
test('control: externality_compliant with method not established and no undue favour is valid_lcc_method') :-
    not_established_base(Profile),
    method_validity_outcome(Profile, answers([lcc_method_validity_verdict(valid_lcc_method, [], [])])).
test('control: mandatory_applied is union_common_method_mandatory_and_applied, exactly one answer') :-
    life_cycle_costing_profile_for("mandatory_applied", Profile),
    mandatory_method_outcome(Profile, answers([lcc_mandatory_method_verdict(union_common_method_mandatory_and_applied, [], [])])).
test('control: basic_compliant computes 10000 euro-cents, exactly one answer') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    computation_outcome(Profile, answers([lcc_computation_verdict(lcc_computed, 10000, [])])).
test('missing cost_components: method validity must refuse, not answer valid or invalid') :-
    profile_without("externality_compliant", cost_components, Profile),
    method_validity_outcome(Profile, answers([])).
test('missing tenderer_data_indicated_in_procurement_documents (Art 68(2) first alinea): method validity must refuse, not answer valid or invalid') :-
    profile_without("externality_compliant", tenderer_data_indicated_in_procurement_documents, Profile),
    method_validity_outcome(Profile, answers([])).
test('missing costing_method_indicated_in_procurement_documents (Art 68(2) first alinea): method validity must refuse, not answer valid or invalid') :-
    profile_without("externality_compliant", costing_method_indicated_in_procurement_documents, Profile),
    method_validity_outcome(Profile, answers([])).
test('missing externality_method_criteria_objectively_verifiable (Art 68(2)(a) first sentence): method validity must refuse, not answer valid or invalid') :-
    profile_without("externality_compliant", externality_method_criteria_objectively_verifiable, Profile),
    method_validity_outcome(Profile, answers([])).
test('missing externality_method_criteria_non_discriminatory (Art 68(2)(a) first sentence): method validity must refuse, not answer valid or invalid') :-
    profile_without("externality_compliant", externality_method_criteria_non_discriminatory, Profile),
    method_validity_outcome(Profile, answers([])).
test('missing externality_method_established_for_repeated_or_continuous_application (Art 68(2)(a) second sentence): method validity must refuse, not answer valid or invalid') :-
    profile_without("externality_compliant", externality_method_established_for_repeated_or_continuous_application, Profile),
    method_validity_outcome(Profile, answers([])).
test('missing externality_method_accessible_to_all_interested_parties (Art 68(2)(b)): method validity must refuse, not answer valid or invalid') :-
    profile_without("externality_compliant", externality_method_accessible_to_all_interested_parties, Profile),
    method_validity_outcome(Profile, answers([])).
test('missing externality_data_obtainable_with_reasonable_effort (Art 68(2)(c)): method validity must refuse, not answer valid or invalid') :-
    profile_without("externality_compliant", externality_data_obtainable_with_reasonable_effort, Profile),
    method_validity_outcome(Profile, answers([])).
test('missing externality_data_obtainable_by_third_country_gpa_operators (Art 68(2)(c)): method validity must refuse, not answer valid or invalid') :-
    profile_without("externality_compliant", externality_data_obtainable_by_third_country_gpa_operators, Profile),
    method_validity_outcome(Profile, answers([])).
test('missing externality_method_unduly_favours_or_disadvantages_operators with method not established (Art 68(2)(a) second sentence): method validity must refuse') :-
    not_established_base(Base),
    dict_without_key(Base, externality_method_unduly_favours_or_disadvantages_operators, Profile),
    method_validity_outcome(Profile, answers([])).
test('by design: empty cost_components with every flag missing is valid_lcc_method (Art 68(2) outer gate)') :-
    dict_pairs(Profile, [cost_components - []]),
    method_validity_outcome(Profile, answers([lcc_method_validity_verdict(valid_lcc_method, [], [])])).
test('by design: no externality component, externality flags missing, is valid_lcc_method (Art 68(2) second alinea inner gate)') :-
    dict_pairs(Profile, [cost_components - [[acquisition_cost, 10000, 1]], tenderer_data_indicated_in_procurement_documents - true, costing_method_indicated_in_procurement_documents - true]),
    method_validity_outcome(Profile, answers([lcc_method_validity_verdict(valid_lcc_method, [], [])])).
test('by design: established method with undue-favour flag missing is valid_lcc_method (Art 68(2)(a) second sentence condition)') :-
    profile_without("externality_compliant", externality_method_unduly_favours_or_disadvantages_operators, Profile),
    method_validity_outcome(Profile, answers([lcc_method_validity_verdict(valid_lcc_method, [], [])])).
test('wrong type: tenderer_data_indicated_in_procurement_documents as atom yes: method validity must refuse, not answer') :-
    profile_with("externality_compliant", tenderer_data_indicated_in_procurement_documents, yes, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: tenderer_data_indicated_in_procurement_documents as string true (a char list under double_quotes(chars)): method validity must refuse, not answer') :-
    profile_with("externality_compliant", tenderer_data_indicated_in_procurement_documents, "true", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: tenderer_data_indicated_in_procurement_documents as integer 1: method validity must refuse, not answer') :-
    profile_with("externality_compliant", tenderer_data_indicated_in_procurement_documents, 1, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: tenderer_data_indicated_in_procurement_documents as integer 0: method validity must refuse, not answer') :-
    profile_with("externality_compliant", tenderer_data_indicated_in_procurement_documents, 0, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: costing_method_indicated_in_procurement_documents as atom yes: method validity must refuse, not answer') :-
    profile_with("externality_compliant", costing_method_indicated_in_procurement_documents, yes, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: costing_method_indicated_in_procurement_documents as string true (a char list under double_quotes(chars)): method validity must refuse, not answer') :-
    profile_with("externality_compliant", costing_method_indicated_in_procurement_documents, "true", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: costing_method_indicated_in_procurement_documents as integer 1: method validity must refuse, not answer') :-
    profile_with("externality_compliant", costing_method_indicated_in_procurement_documents, 1, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: costing_method_indicated_in_procurement_documents as integer 0: method validity must refuse, not answer') :-
    profile_with("externality_compliant", costing_method_indicated_in_procurement_documents, 0, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_criteria_objectively_verifiable as atom yes: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_criteria_objectively_verifiable, yes, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_criteria_objectively_verifiable as string true (a char list under double_quotes(chars)): method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_criteria_objectively_verifiable, "true", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_criteria_objectively_verifiable as integer 1: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_criteria_objectively_verifiable, 1, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_criteria_objectively_verifiable as integer 0: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_criteria_objectively_verifiable, 0, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_criteria_non_discriminatory as atom yes: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_criteria_non_discriminatory, yes, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_criteria_non_discriminatory as string true (a char list under double_quotes(chars)): method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_criteria_non_discriminatory, "true", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_criteria_non_discriminatory as integer 1: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_criteria_non_discriminatory, 1, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_criteria_non_discriminatory as integer 0: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_criteria_non_discriminatory, 0, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_established_for_repeated_or_continuous_application as atom yes: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_established_for_repeated_or_continuous_application, yes, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_established_for_repeated_or_continuous_application as string true (a char list under double_quotes(chars)): method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_established_for_repeated_or_continuous_application, "true", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_established_for_repeated_or_continuous_application as integer 1: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_established_for_repeated_or_continuous_application, 1, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_established_for_repeated_or_continuous_application as integer 0: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_established_for_repeated_or_continuous_application, 0, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_accessible_to_all_interested_parties as atom yes: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_accessible_to_all_interested_parties, yes, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_accessible_to_all_interested_parties as string true (a char list under double_quotes(chars)): method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_accessible_to_all_interested_parties, "true", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_accessible_to_all_interested_parties as integer 1: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_accessible_to_all_interested_parties, 1, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_accessible_to_all_interested_parties as integer 0: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_method_accessible_to_all_interested_parties, 0, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_data_obtainable_with_reasonable_effort as atom yes: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_data_obtainable_with_reasonable_effort, yes, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_data_obtainable_with_reasonable_effort as string true (a char list under double_quotes(chars)): method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_data_obtainable_with_reasonable_effort, "true", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_data_obtainable_with_reasonable_effort as integer 1: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_data_obtainable_with_reasonable_effort, 1, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_data_obtainable_with_reasonable_effort as integer 0: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_data_obtainable_with_reasonable_effort, 0, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_data_obtainable_by_third_country_gpa_operators as atom yes: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_data_obtainable_by_third_country_gpa_operators, yes, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_data_obtainable_by_third_country_gpa_operators as string true (a char list under double_quotes(chars)): method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_data_obtainable_by_third_country_gpa_operators, "true", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_data_obtainable_by_third_country_gpa_operators as integer 1: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_data_obtainable_by_third_country_gpa_operators, 1, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_data_obtainable_by_third_country_gpa_operators as integer 0: method validity must refuse, not answer') :-
    profile_with("externality_compliant", externality_data_obtainable_by_third_country_gpa_operators, 0, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_unduly_favours_or_disadvantages_operators as atom yes with method not established: method validity must refuse, not answer') :-
    not_established_base(Base),
    override_key(Base, externality_method_unduly_favours_or_disadvantages_operators, yes, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_unduly_favours_or_disadvantages_operators as string true (a char list under double_quotes(chars)) with method not established: method validity must refuse, not answer') :-
    not_established_base(Base),
    override_key(Base, externality_method_unduly_favours_or_disadvantages_operators, "true", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_unduly_favours_or_disadvantages_operators as integer 1 with method not established: method validity must refuse, not answer') :-
    not_established_base(Base),
    override_key(Base, externality_method_unduly_favours_or_disadvantages_operators, 1, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality_method_unduly_favours_or_disadvantages_operators as integer 0 with method not established: method validity must refuse, not answer') :-
    not_established_base(Base),
    override_key(Base, externality_method_unduly_favours_or_disadvantages_operators, 0, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: cost_components as an atom: method validity must refuse, not answer') :-
    profile_with("externality_compliant", cost_components, no_cost_components_given, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: cost_components as a number: method validity must refuse, not answer') :-
    profile_with("externality_compliant", cost_components, 15000, Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: cost_components as a string: method validity must refuse, not answer') :-
    profile_with("externality_compliant", cost_components, "acquisition_cost", Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong shape: cost component with two elements instead of three: method validity must refuse, not answer') :-
    profile_with("externality_compliant", cost_components, [[acquisition_cost, 10000]], Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality determinability as boolean True instead of integer 1: method validity must refuse, not answer') :-
    profile_with("externality_compliant", cost_components, [[acquisition_cost, 10000, 1], [environmental_externality_cost, 5000, true]], Profile),
    method_validity_outcome(Profile, answers([])).
test('wrong type: externality determinability as atom yes: method validity must refuse, not answer') :-
    profile_with("externality_compliant", cost_components, [[acquisition_cost, 10000, 1], [environmental_externality_cost, 5000, yes]], Profile),
    method_validity_outcome(Profile, answers([])).
test('missing union_common_method_act_key: mandatory method must refuse, not answer') :-
    profile_without("mandatory_applied", union_common_method_act_key, Profile),
    mandatory_method_outcome(Profile, answers([])).
test('missing union_common_method_applied with directive_2009_33_ec: mandatory method must refuse, not answer') :-
    profile_without("mandatory_applied", union_common_method_applied, Profile),
    mandatory_method_outcome(Profile, answers([])).
test('by design: no_union_common_method with union_common_method_applied missing is no_union_common_method_mandatory') :-
    profile_without("basic_compliant", union_common_method_applied, Profile),
    mandatory_method_outcome(Profile, answers([lcc_mandatory_method_verdict(no_union_common_method_mandatory, [], [])])).
test('incoherent: no_union_common_method with union_common_method_applied True must fail closed (profile_keys.yaml)') :-
    profile_with("basic_compliant", union_common_method_applied, true, Profile),
    mandatory_method_outcome(Profile, answers([])).
test('wrong type: union_common_method_act_key as a string: mandatory method must refuse, not answer') :-
    profile_with("mandatory_applied", union_common_method_act_key, "directive_2009_33_ec", Profile),
    mandatory_method_outcome(Profile, answers([])).
test('wrong value: union_common_method_act_key outside its vocabulary: mandatory method must refuse, not answer') :-
    profile_with("mandatory_applied", union_common_method_act_key, regulation_not_in_vocabulary, Profile),
    mandatory_method_outcome(Profile, answers([])).
test('wrong type: union_common_method_act_key as a number: mandatory method must refuse, not answer') :-
    profile_with("mandatory_applied", union_common_method_act_key, 1, Profile),
    mandatory_method_outcome(Profile, answers([])).
test('wrong type: union_common_method_act_key as a list: mandatory method must refuse, not answer') :-
    profile_with("mandatory_applied", union_common_method_act_key, [directive_2009_33_ec], Profile),
    mandatory_method_outcome(Profile, answers([])).
test('wrong type: union_common_method_applied as atom yes: mandatory method must refuse, not answer') :-
    profile_with("mandatory_applied", union_common_method_applied, yes, Profile),
    mandatory_method_outcome(Profile, answers([])).
test('wrong type: union_common_method_applied as string true (a char list under double_quotes(chars)): mandatory method must refuse, not answer') :-
    profile_with("mandatory_applied", union_common_method_applied, "true", Profile),
    mandatory_method_outcome(Profile, answers([])).
test('wrong type: union_common_method_applied as integer 1: mandatory method must refuse, not answer') :-
    profile_with("mandatory_applied", union_common_method_applied, 1, Profile),
    mandatory_method_outcome(Profile, answers([])).
test('wrong type: union_common_method_applied as integer 0: mandatory method must refuse, not answer') :-
    profile_with("mandatory_applied", union_common_method_applied, 0, Profile),
    mandatory_method_outcome(Profile, answers([])).
test('missing cost_components: computation must refuse or be lcc_indeterminate, not compute') :-
    profile_without("basic_compliant", cost_components, Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong type: cost_components as an atom: computation must refuse or be lcc_indeterminate') :-
    profile_with("basic_compliant", cost_components, no_cost_components_given, Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong type: cost_components as a number: computation must refuse or be lcc_indeterminate') :-
    profile_with("basic_compliant", cost_components, 10000, Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong type: cost_components as a string: computation must refuse or be lcc_indeterminate') :-
    profile_with("basic_compliant", cost_components, "acquisition_cost", Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong shape: cost component with two elements: computation must refuse or be lcc_indeterminate') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, 10000]], Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong type: amount as an atom: computation must refuse or be lcc_indeterminate, not crash') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, ten_thousand, 1]], Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong type: amount as a string: computation must refuse or be lcc_indeterminate, not crash') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, "10000", 1]], Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong type: amount as a list: computation must refuse or be lcc_indeterminate, not crash') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, [10000], 1]], Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong type: amount as a non-integer 100.5 euro-cents: computation must refuse or be lcc_indeterminate') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, 100.5, 1]], Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong value: cost category outside the six-atom vocabulary: computation must refuse or be lcc_indeterminate') :-
    profile_with("basic_compliant", cost_components, [[fuel_cost_not_in_vocabulary, 10000, 1]], Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong type: externality determinability as boolean True instead of integer 1: computation must refuse or be lcc_indeterminate') :-
    profile_with("basic_compliant", cost_components, [[environmental_externality_cost, 5000, true]], Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('wrong type: externality determinability as atom yes: computation must refuse or be lcc_indeterminate') :-
    profile_with("basic_compliant", cost_components, [[environmental_externality_cost, 5000, yes]], Profile),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('empty profile: method validity must refuse, not answer valid or invalid') :-
    dict_pairs(Profile, []),
    method_validity_outcome(Profile, answers([])).
test('empty profile: mandatory method must refuse, not answer') :-
    dict_pairs(Profile, []),
    mandatory_method_outcome(Profile, answers([])).
test('empty profile: computation must refuse or be lcc_indeterminate') :-
    dict_pairs(Profile, []),
    computation_outcome(Profile, Outcome),
    computation_not_definite(Outcome).
test('exactly one answer: method validity, every fixture profile') :-
    findall(Subject, life_cycle_costing_subject(Subject), Subjects),
    findall(Subject, (life_cycle_costing_subject(Subject), not_one_method_validity_answer(Subject)), Offenders),
    Offenders = [],
    length(Subjects, 13).
test('exactly one answer: mandatory method, every fixture profile') :-
    findall(Subject, (life_cycle_costing_subject(Subject), not_one_mandatory_method_answer(Subject)), Offenders),
    Offenders = [].
test('exactly one answer: computation, every fixture profile') :-
    findall(Subject, (life_cycle_costing_subject(Subject), not_one_computation_answer(Subject)), Offenders),
    Offenders = [].
test('boundary: amount 0 euro-cents computes total 0') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, 0, 1]], Profile),
    computation_outcome(Profile, answers([lcc_computation_verdict(lcc_computed, 0, [])])).
test('boundary: amount 1 euro-cent computes total 1') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, 1, 1]], Profile),
    computation_outcome(Profile, answers([lcc_computation_verdict(lcc_computed, 1, [])])).
test('boundary: amount minus 1 euro-cent is lcc_indeterminate with total 0') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, -1, 1]], Profile),
    computation_outcome(Profile, answers([lcc_computation_verdict(lcc_indeterminate, 0, [])])).
test('input check: a valid fixture has no problem for any determination') :-
    life_cycle_costing_profile_for("externality_compliant", Profile),
    findall(Problem, life_cycle_costing_input_problem(method_validity, Profile, Problem), []),
    findall(Problem, life_cycle_costing_input_problem(mandatory_method, Profile, Problem), []),
    findall(Problem, life_cycle_costing_input_problem(computation, Profile, Problem), []).
test('input check: every fixture has no problem for method validity and mandatory method') :-
    findall(Subject, (life_cycle_costing_subject(Subject), life_cycle_costing_profile_for(Subject, Profile), life_cycle_costing_input_problem(method_validity, Profile, _)), OffendersValidity),
    OffendersValidity = [],
    findall(Subject, (life_cycle_costing_subject(Subject), life_cycle_costing_profile_for(Subject, Profile), life_cycle_costing_input_problem(mandatory_method, Profile, _)), OffendersMandatory),
    OffendersMandatory = [].
test('input check reports exactly one problem (the first)') :-
    dict_pairs(Profile, []),
    findall(Problem, life_cycle_costing_input_problem(method_validity, Profile, Problem), Problems),
    Problems = [missing_key(cost_components)].
test('input check reports not_ground for a profile holding an unbound variable') :-
    dict_pairs(Profile, [cost_components - _]),
    life_cycle_costing_input_problem(method_validity, Profile, not_ground).
test('input check reports wrong_type(profile, expected_dict) for a profile that is not a dict') :-
    life_cycle_costing_input_problem(computation, [cost_components], wrong_type(profile, expected_dict)).
test('input check reports missing_key for a missing first-alinea flag') :-
    profile_without("externality_compliant", tenderer_data_indicated_in_procurement_documents, Profile),
    life_cycle_costing_input_problem(method_validity, Profile, missing_key(tenderer_data_indicated_in_procurement_documents)).
test('input check reports not_a_list for cost_components that is not a list') :-
    first_problem(computation, "basic_compliant", cost_components, 10000, not_a_list(cost_components)).
test('input check reports malformed_cost_component for a two-element record') :-
    first_problem(computation, "basic_compliant", cost_components, [[acquisition_cost, 10000]], malformed_cost_component([acquisition_cost, 10000])).
test('input check reports unknown_cost_category for a category outside the vocabulary') :-
    first_problem(computation, "basic_compliant", cost_components, [[fuel_cost_not_in_vocabulary, 10000, 1]], unknown_cost_category(fuel_cost_not_in_vocabulary)).
test('input check reports wrong_type expected_integer_euro_cents for a non-integer amount') :-
    first_problem(computation, "basic_compliant", cost_components, [[acquisition_cost, 100.5, 1]], wrong_type(cost_component([acquisition_cost, 100.5, 1]), expected_integer_euro_cents)).
test('input check reports wrong_type expected_zero_or_one for a boolean determinability') :-
    first_problem(method_validity, "externality_compliant", cost_components, [[environmental_externality_cost, 5000, true]], wrong_type(cost_component([environmental_externality_cost, 5000, true]), expected_zero_or_one)).
test('input check reports negative_amount for the computation only') :-
    first_problem(computation, "basic_compliant", cost_components, [[acquisition_cost, -1, 1]], negative_amount([acquisition_cost, -1, 1])),
    profile_with("basic_compliant", cost_components, [[acquisition_cost, -1, 1]], Profile),
    findall(Problem, life_cycle_costing_input_problem(method_validity, Profile, Problem), []).
test('input check reports wrong_type expected_boolean for an integer flag') :-
    first_problem(method_validity, "externality_compliant", externality_method_criteria_non_discriminatory, 1, wrong_type(externality_method_criteria_non_discriminatory, expected_boolean)).
test('input check reports wrong_value for an act key outside the vocabulary') :-
    first_problem(mandatory_method, "mandatory_applied", union_common_method_act_key, regulation_not_in_vocabulary, wrong_value(union_common_method_act_key, expected_union_act_atom)).
test('input check reports incoherent_input for no_union_common_method with applied True') :-
    first_problem(mandatory_method, "basic_compliant", union_common_method_applied, true, incoherent_input(union_common_method_applied_without_union_act)).
test('input check reports missing_key(union_common_method_applied) when an act is named') :-
    profile_without("mandatory_applied", union_common_method_applied, Profile),
    life_cycle_costing_input_problem(mandatory_method, Profile, missing_key(union_common_method_applied)).
test('not ground: method validity refuses a profile with an unbound flag') :-
    profile_with("externality_compliant", tenderer_data_indicated_in_procurement_documents, _, Profile),
    method_validity_outcome(Profile, answers([])).
test('not ground: mandatory method refuses a profile with an unbound act key') :-
    profile_with("mandatory_applied", union_common_method_act_key, _, Profile),
    mandatory_method_outcome(Profile, answers([])).
test('not ground: computation is lcc_indeterminate for an unbound amount') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, _, 1]], Profile),
    computation_outcome(Profile, answers([lcc_computation_verdict(lcc_indeterminate, 0, [])])).
test('not ground: computation is lcc_indeterminate for an unbound profile') :-
    computation_outcome(_, answers([lcc_computation_verdict(lcc_indeterminate, 0, [])])).
test('entry point: lcc_method_validity_limb_status refuses a profile missing a flag') :-
    profile_without("basic_compliant", tenderer_data_indicated_in_procurement_documents, Profile),
    findall(Status, lcc_method_validity_limb_status(tenderer_data_not_indicated, Profile, Status, _), Statuses),
    Statuses = [].
test('entry point: life_cycle_costing_calculation refuses a non-integer amount') :-
    profile_with("basic_compliant", cost_components, [[acquisition_cost, 100.5, 1]], Profile),
    findall(Total, life_cycle_costing_calculation(Profile, Total), Totals),
    Totals = [].
test('entry point: lcc_total refuses an atom amount without crashing') :-
    catch((findall(Total, lcc_total([[acquisition_cost, ten_thousand, 1]], Total), Totals), Outcome = answers(Totals)), Caught, Outcome = raised(Caught)),
    Outcome = answers([]).
test('entry point: lcc_total refuses an unbound list') :-
    findall(Total, lcc_total(_, Total), Totals),
    Totals = [].
test('entry point: lcc_externality_assessment refuses an unbound list') :-
    findall(Assessment, lcc_externality_assessment(_, Assessment), Assessments),
    Assessments = [].

one_method_validity_answer(Subject) :-
    life_cycle_costing_profile_for(Subject, Profile),
    method_validity_outcome(Profile, answers([_])).

one_mandatory_method_answer(Subject) :-
    life_cycle_costing_profile_for(Subject, Profile),
    mandatory_method_outcome(Profile, answers([_])).

one_computation_answer(Subject) :-
    life_cycle_costing_profile_for(Subject, Profile),
    computation_outcome(Profile, answers([_])).

not_one_method_validity_answer(Subject) :-
    findall(Profile, life_cycle_costing_profile_for(Subject, Profile), []).
not_one_method_validity_answer(Subject) :-
    life_cycle_costing_profile_for(Subject, Profile),
    method_validity_outcome(Profile, Outcome),
    outcome_not_one_answer(Outcome).

not_one_mandatory_method_answer(Subject) :-
    findall(Profile, life_cycle_costing_profile_for(Subject, Profile), []).
not_one_mandatory_method_answer(Subject) :-
    life_cycle_costing_profile_for(Subject, Profile),
    mandatory_method_outcome(Profile, Outcome),
    outcome_not_one_answer(Outcome).

not_one_computation_answer(Subject) :-
    findall(Profile, life_cycle_costing_profile_for(Subject, Profile), []).
not_one_computation_answer(Subject) :-
    life_cycle_costing_profile_for(Subject, Profile),
    computation_outcome(Profile, Outcome),
    outcome_not_one_answer(Outcome).

outcome_not_one_answer(answers([])).
outcome_not_one_answer(answers([_, _|_])).
outcome_not_one_answer(raised(_)).

first_problem(Determination, Subject, Key, Value, Problem) :-
    profile_with(Subject, Key, Value, Profile),
    life_cycle_costing_input_problem(Determination, Profile, Problem).

cp_test_names(['control: externality_compliant is valid_lcc_method, exactly one answer', 'control: externality_compliant with method not established and no undue favour is valid_lcc_method', 'control: mandatory_applied is union_common_method_mandatory_and_applied, exactly one answer', 'control: basic_compliant computes 10000 euro-cents, exactly one answer', 'missing cost_components: method validity must refuse, not answer valid or invalid', 'missing tenderer_data_indicated_in_procurement_documents (Art 68(2) first alinea): method validity must refuse, not answer valid or invalid', 'missing costing_method_indicated_in_procurement_documents (Art 68(2) first alinea): method validity must refuse, not answer valid or invalid', 'missing externality_method_criteria_objectively_verifiable (Art 68(2)(a) first sentence): method validity must refuse, not answer valid or invalid', 'missing externality_method_criteria_non_discriminatory (Art 68(2)(a) first sentence): method validity must refuse, not answer valid or invalid', 'missing externality_method_established_for_repeated_or_continuous_application (Art 68(2)(a) second sentence): method validity must refuse, not answer valid or invalid', 'missing externality_method_accessible_to_all_interested_parties (Art 68(2)(b)): method validity must refuse, not answer valid or invalid', 'missing externality_data_obtainable_with_reasonable_effort (Art 68(2)(c)): method validity must refuse, not answer valid or invalid', 'missing externality_data_obtainable_by_third_country_gpa_operators (Art 68(2)(c)): method validity must refuse, not answer valid or invalid', 'missing externality_method_unduly_favours_or_disadvantages_operators with method not established (Art 68(2)(a) second sentence): method validity must refuse', 'by design: empty cost_components with every flag missing is valid_lcc_method (Art 68(2) outer gate)', 'by design: no externality component, externality flags missing, is valid_lcc_method (Art 68(2) second alinea inner gate)', 'by design: established method with undue-favour flag missing is valid_lcc_method (Art 68(2)(a) second sentence condition)', 'wrong type: tenderer_data_indicated_in_procurement_documents as atom yes: method validity must refuse, not answer', 'wrong type: tenderer_data_indicated_in_procurement_documents as string true (a char list under double_quotes(chars)): method validity must refuse, not answer', 'wrong type: tenderer_data_indicated_in_procurement_documents as integer 1: method validity must refuse, not answer', 'wrong type: tenderer_data_indicated_in_procurement_documents as integer 0: method validity must refuse, not answer', 'wrong type: costing_method_indicated_in_procurement_documents as atom yes: method validity must refuse, not answer', 'wrong type: costing_method_indicated_in_procurement_documents as string true (a char list under double_quotes(chars)): method validity must refuse, not answer', 'wrong type: costing_method_indicated_in_procurement_documents as integer 1: method validity must refuse, not answer', 'wrong type: costing_method_indicated_in_procurement_documents as integer 0: method validity must refuse, not answer', 'wrong type: externality_method_criteria_objectively_verifiable as atom yes: method validity must refuse, not answer', 'wrong type: externality_method_criteria_objectively_verifiable as string true (a char list under double_quotes(chars)): method validity must refuse, not answer', 'wrong type: externality_method_criteria_objectively_verifiable as integer 1: method validity must refuse, not answer', 'wrong type: externality_method_criteria_objectively_verifiable as integer 0: method validity must refuse, not answer', 'wrong type: externality_method_criteria_non_discriminatory as atom yes: method validity must refuse, not answer', 'wrong type: externality_method_criteria_non_discriminatory as string true (a char list under double_quotes(chars)): method validity must refuse, not answer', 'wrong type: externality_method_criteria_non_discriminatory as integer 1: method validity must refuse, not answer', 'wrong type: externality_method_criteria_non_discriminatory as integer 0: method validity must refuse, not answer', 'wrong type: externality_method_established_for_repeated_or_continuous_application as atom yes: method validity must refuse, not answer', 'wrong type: externality_method_established_for_repeated_or_continuous_application as string true (a char list under double_quotes(chars)): method validity must refuse, not answer', 'wrong type: externality_method_established_for_repeated_or_continuous_application as integer 1: method validity must refuse, not answer', 'wrong type: externality_method_established_for_repeated_or_continuous_application as integer 0: method validity must refuse, not answer', 'wrong type: externality_method_accessible_to_all_interested_parties as atom yes: method validity must refuse, not answer', 'wrong type: externality_method_accessible_to_all_interested_parties as string true (a char list under double_quotes(chars)): method validity must refuse, not answer', 'wrong type: externality_method_accessible_to_all_interested_parties as integer 1: method validity must refuse, not answer', 'wrong type: externality_method_accessible_to_all_interested_parties as integer 0: method validity must refuse, not answer', 'wrong type: externality_data_obtainable_with_reasonable_effort as atom yes: method validity must refuse, not answer', 'wrong type: externality_data_obtainable_with_reasonable_effort as string true (a char list under double_quotes(chars)): method validity must refuse, not answer', 'wrong type: externality_data_obtainable_with_reasonable_effort as integer 1: method validity must refuse, not answer', 'wrong type: externality_data_obtainable_with_reasonable_effort as integer 0: method validity must refuse, not answer', 'wrong type: externality_data_obtainable_by_third_country_gpa_operators as atom yes: method validity must refuse, not answer', 'wrong type: externality_data_obtainable_by_third_country_gpa_operators as string true (a char list under double_quotes(chars)): method validity must refuse, not answer', 'wrong type: externality_data_obtainable_by_third_country_gpa_operators as integer 1: method validity must refuse, not answer', 'wrong type: externality_data_obtainable_by_third_country_gpa_operators as integer 0: method validity must refuse, not answer', 'wrong type: externality_method_unduly_favours_or_disadvantages_operators as atom yes with method not established: method validity must refuse, not answer', 'wrong type: externality_method_unduly_favours_or_disadvantages_operators as string true (a char list under double_quotes(chars)) with method not established: method validity must refuse, not answer', 'wrong type: externality_method_unduly_favours_or_disadvantages_operators as integer 1 with method not established: method validity must refuse, not answer', 'wrong type: externality_method_unduly_favours_or_disadvantages_operators as integer 0 with method not established: method validity must refuse, not answer', 'wrong type: cost_components as an atom: method validity must refuse, not answer', 'wrong type: cost_components as a number: method validity must refuse, not answer', 'wrong type: cost_components as a string: method validity must refuse, not answer', 'wrong shape: cost component with two elements instead of three: method validity must refuse, not answer', 'wrong type: externality determinability as boolean True instead of integer 1: method validity must refuse, not answer', 'wrong type: externality determinability as atom yes: method validity must refuse, not answer', 'missing union_common_method_act_key: mandatory method must refuse, not answer', 'missing union_common_method_applied with directive_2009_33_ec: mandatory method must refuse, not answer', 'by design: no_union_common_method with union_common_method_applied missing is no_union_common_method_mandatory', 'incoherent: no_union_common_method with union_common_method_applied True must fail closed (profile_keys.yaml)', 'wrong type: union_common_method_act_key as a string: mandatory method must refuse, not answer', 'wrong value: union_common_method_act_key outside its vocabulary: mandatory method must refuse, not answer', 'wrong type: union_common_method_act_key as a number: mandatory method must refuse, not answer', 'wrong type: union_common_method_act_key as a list: mandatory method must refuse, not answer', 'wrong type: union_common_method_applied as atom yes: mandatory method must refuse, not answer', 'wrong type: union_common_method_applied as string true (a char list under double_quotes(chars)): mandatory method must refuse, not answer', 'wrong type: union_common_method_applied as integer 1: mandatory method must refuse, not answer', 'wrong type: union_common_method_applied as integer 0: mandatory method must refuse, not answer', 'missing cost_components: computation must refuse or be lcc_indeterminate, not compute', 'wrong type: cost_components as an atom: computation must refuse or be lcc_indeterminate', 'wrong type: cost_components as a number: computation must refuse or be lcc_indeterminate', 'wrong type: cost_components as a string: computation must refuse or be lcc_indeterminate', 'wrong shape: cost component with two elements: computation must refuse or be lcc_indeterminate', 'wrong type: amount as an atom: computation must refuse or be lcc_indeterminate, not crash', 'wrong type: amount as a string: computation must refuse or be lcc_indeterminate, not crash', 'wrong type: amount as a list: computation must refuse or be lcc_indeterminate, not crash', 'wrong type: amount as a non-integer 100.5 euro-cents: computation must refuse or be lcc_indeterminate', 'wrong value: cost category outside the six-atom vocabulary: computation must refuse or be lcc_indeterminate', 'wrong type: externality determinability as boolean True instead of integer 1: computation must refuse or be lcc_indeterminate', 'wrong type: externality determinability as atom yes: computation must refuse or be lcc_indeterminate', 'empty profile: method validity must refuse, not answer valid or invalid', 'empty profile: mandatory method must refuse, not answer', 'empty profile: computation must refuse or be lcc_indeterminate', 'exactly one answer: method validity, every fixture profile', 'exactly one answer: mandatory method, every fixture profile', 'exactly one answer: computation, every fixture profile', 'boundary: amount 0 euro-cents computes total 0', 'boundary: amount 1 euro-cent computes total 1', 'boundary: amount minus 1 euro-cent is lcc_indeterminate with total 0', 'input check: a valid fixture has no problem for any determination', 'input check: every fixture has no problem for method validity and mandatory method', 'input check reports exactly one problem (the first)', 'input check reports not_ground for a profile holding an unbound variable', 'input check reports wrong_type(profile, expected_dict) for a profile that is not a dict', 'input check reports missing_key for a missing first-alinea flag', 'input check reports not_a_list for cost_components that is not a list', 'input check reports malformed_cost_component for a two-element record', 'input check reports unknown_cost_category for a category outside the vocabulary', 'input check reports wrong_type expected_integer_euro_cents for a non-integer amount', 'input check reports wrong_type expected_zero_or_one for a boolean determinability', 'input check reports negative_amount for the computation only', 'input check reports wrong_type expected_boolean for an integer flag', 'input check reports wrong_value for an act key outside the vocabulary', 'input check reports incoherent_input for no_union_common_method with applied True', 'input check reports missing_key(union_common_method_applied) when an act is named', 'not ground: method validity refuses a profile with an unbound flag', 'not ground: mandatory method refuses a profile with an unbound act key', 'not ground: computation is lcc_indeterminate for an unbound amount', 'not ground: computation is lcc_indeterminate for an unbound profile', 'entry point: lcc_method_validity_limb_status refuses a profile missing a flag', 'entry point: life_cycle_costing_calculation refuses a non-integer amount', 'entry point: lcc_total refuses an atom amount without crashing', 'entry point: lcc_total refuses an unbound list', 'entry point: lcc_externality_assessment refuses an unbound list']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
