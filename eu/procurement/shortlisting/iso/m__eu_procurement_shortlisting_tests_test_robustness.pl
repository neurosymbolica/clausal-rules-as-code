:- module(m__eu_procurement_shortlisting_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__eu_procurement_shortlisting_shortlisting, [decide_shortlisting/2, shortlisting_status/2, shortlisting_checklist/2, shortlisting_decision_resolvable/1, shortlisting_what_if/4, shortlisting_invitation_floor/4, shortlisting_limitation_modality/4, shortlisting_input_problem/2]).
:- use_module(m__eu_procurement_shortlisting_queries, [shortlisting_threshold_flip/5]).
:- use_module(m__eu_procurement_shortlisting_fixtures, [shortlisting_subject/1, shortlisting_profile_for/2]).
:- use_module(query_combinators, [override_key/4]).

shortlisting_outcome(Profile, Outcome) :-
    catch((findall(Verdict, decide_shortlisting(Profile, Verdict), Verdicts), Outcome = answers(Verdicts)), Caught, Outcome = raised(Caught)).

profile_without(Key, Profile) :-
    shortlisting_profile_for("restricted_all_clear", Base),
    dict_pairs(Base, Pairs),
    findall(OtherKey - Value, (member(OtherKey - Value, Pairs), dif(OtherKey, Key)), Remaining),
    dict_pairs(Profile, Remaining).

profile_with(Key, Value, Profile) :-
    shortlisting_profile_for("restricted_all_clear", Base),
    override_key(Base, Key, Value, Profile).

profile_with_two(KeyOne, ValueOne, KeyTwo, ValueTwo, Profile) :-
    profile_with(KeyOne, ValueOne, Middle),
    override_key(Middle, KeyTwo, ValueTwo, Profile).

test('control: restricted_all_clear is limitation_permitted with 5 to invite, exactly one answer') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_permitted, [], 5, [])])).
test('missing procedure_type_key (Art 65(1)): decide_shortlisting must refuse, not answer') :-
    profile_without(procedure_type_key, Profile),
    shortlisting_outcome(Profile, answers([])).
test('missing objective_and_non_discriminatory_criteria_indicated (Art 65(2) first sub-paragraph): decide_shortlisting must refuse, not answer') :-
    profile_without(objective_and_non_discriminatory_criteria_indicated, Profile),
    shortlisting_outcome(Profile, answers([])).
test('missing minimum_number_indicated (Art 65(2) first sub-paragraph): decide_shortlisting must refuse, not answer') :-
    profile_without(minimum_number_indicated, Profile),
    shortlisting_outcome(Profile, answers([])).
test('missing declared_minimum_candidates (Art 65(2) first sub-paragraph): decide_shortlisting must refuse, not answer') :-
    profile_without(declared_minimum_candidates, Profile),
    shortlisting_outcome(Profile, answers([])).
test('missing declared_maximum_candidates (Art 65(2) first sub-paragraph): decide_shortlisting must refuse, not answer') :-
    profile_without(declared_maximum_candidates, Profile),
    shortlisting_outcome(Profile, answers([])).
test('missing qualified_candidates (Art 65(1) and 65(2) third sub-paragraph): decide_shortlisting must refuse, not answer') :-
    profile_without(qualified_candidates, Profile),
    shortlisting_outcome(Profile, answers([])).
test('missing invited_candidates (Art 65(2) third sub-paragraph): decide_shortlisting must refuse, not answer') :-
    profile_without(invited_candidates, Profile),
    shortlisting_outcome(Profile, answers([])).
test('missing number_invited_sufficient_for_genuine_competition (Art 65(2) second sub-paragraph final sentence): decide_shortlisting must refuse, not answer') :-
    profile_without(number_invited_sufficient_for_genuine_competition, Profile),
    shortlisting_outcome(Profile, answers([])).
test('missing invited_include_non_requesting_economic_operators (Art 65(2) third sub-paragraph final sentence): decide_shortlisting must refuse, not answer') :-
    profile_without(invited_include_non_requesting_economic_operators, Profile),
    shortlisting_outcome(Profile, answers([])).
test('missing invited_include_candidates_without_required_capabilities (Art 65(2) third sub-paragraph final sentence): decide_shortlisting must refuse, not answer') :-
    profile_without(invited_include_candidates_without_required_capabilities, Profile),
    shortlisting_outcome(Profile, answers([])).
test('by design: open procedure with only procedure_type_key is limitation_not_available (Art 65(1))') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure]),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_not_available, [], 0, [])])).
test('wrong value: procedure_type_key outside the six-atom vocabulary: decide_shortlisting must refuse') :-
    profile_with(procedure_type_key, procedure_not_in_vocabulary, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: procedure_type_key as a string: decide_shortlisting must refuse') :-
    profile_with(procedure_type_key, "restricted_procedure", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: procedure_type_key as a number: decide_shortlisting must refuse') :-
    profile_with(procedure_type_key, 1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: procedure_type_key as a list: decide_shortlisting must refuse') :-
    profile_with(procedure_type_key, [restricted_procedure], Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: objective_and_non_discriminatory_criteria_indicated as atom yes: decide_shortlisting must refuse, not answer') :-
    profile_with(objective_and_non_discriminatory_criteria_indicated, yes, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: objective_and_non_discriminatory_criteria_indicated as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer') :-
    profile_with(objective_and_non_discriminatory_criteria_indicated, "true", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: objective_and_non_discriminatory_criteria_indicated as integer 1: decide_shortlisting must refuse, not answer') :-
    profile_with(objective_and_non_discriminatory_criteria_indicated, 1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: objective_and_non_discriminatory_criteria_indicated as integer 0: decide_shortlisting must refuse, not answer') :-
    profile_with(objective_and_non_discriminatory_criteria_indicated, 0, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: minimum_number_indicated as atom yes: decide_shortlisting must refuse, not answer') :-
    profile_with(minimum_number_indicated, yes, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: minimum_number_indicated as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer') :-
    profile_with(minimum_number_indicated, "true", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: minimum_number_indicated as integer 1: decide_shortlisting must refuse, not answer') :-
    profile_with(minimum_number_indicated, 1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: minimum_number_indicated as integer 0: decide_shortlisting must refuse, not answer') :-
    profile_with(minimum_number_indicated, 0, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: number_invited_sufficient_for_genuine_competition as atom yes: decide_shortlisting must refuse, not answer') :-
    profile_with(number_invited_sufficient_for_genuine_competition, yes, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: number_invited_sufficient_for_genuine_competition as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer') :-
    profile_with(number_invited_sufficient_for_genuine_competition, "true", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: number_invited_sufficient_for_genuine_competition as integer 1: decide_shortlisting must refuse, not answer') :-
    profile_with(number_invited_sufficient_for_genuine_competition, 1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: number_invited_sufficient_for_genuine_competition as integer 0: decide_shortlisting must refuse, not answer') :-
    profile_with(number_invited_sufficient_for_genuine_competition, 0, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_include_non_requesting_economic_operators as atom yes: decide_shortlisting must refuse, not answer') :-
    profile_with(invited_include_non_requesting_economic_operators, yes, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_include_non_requesting_economic_operators as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer') :-
    profile_with(invited_include_non_requesting_economic_operators, "true", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_include_non_requesting_economic_operators as integer 1: decide_shortlisting must refuse, not answer') :-
    profile_with(invited_include_non_requesting_economic_operators, 1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_include_non_requesting_economic_operators as integer 0: decide_shortlisting must refuse, not answer') :-
    profile_with(invited_include_non_requesting_economic_operators, 0, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_include_candidates_without_required_capabilities as atom yes: decide_shortlisting must refuse, not answer') :-
    profile_with(invited_include_candidates_without_required_capabilities, yes, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_include_candidates_without_required_capabilities as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer') :-
    profile_with(invited_include_candidates_without_required_capabilities, "true", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_include_candidates_without_required_capabilities as integer 1: decide_shortlisting must refuse, not answer') :-
    profile_with(invited_include_candidates_without_required_capabilities, 1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_include_candidates_without_required_capabilities as integer 0: decide_shortlisting must refuse, not answer') :-
    profile_with(invited_include_candidates_without_required_capabilities, 0, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_minimum_candidates as an atom: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_minimum_candidates, five, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_minimum_candidates as a string (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_minimum_candidates, "5", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_minimum_candidates as a list: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_minimum_candidates, [5], Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_minimum_candidates as a non-integer 5.5: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_minimum_candidates, 5.5, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_minimum_candidates as a negative count -1: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_minimum_candidates, -1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_minimum_candidates as boolean True: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_minimum_candidates, true, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_maximum_candidates as an atom: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_maximum_candidates, five, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_maximum_candidates as a string (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_maximum_candidates, "5", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_maximum_candidates as a list: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_maximum_candidates, [5], Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_maximum_candidates as a non-integer 5.5: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_maximum_candidates, 5.5, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_maximum_candidates as a negative count -1: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_maximum_candidates, -1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: declared_maximum_candidates as boolean True: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(declared_maximum_candidates, true, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: qualified_candidates as an atom: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(qualified_candidates, five, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: qualified_candidates as a string (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer or crash') :-
    profile_with(qualified_candidates, "5", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: qualified_candidates as a list: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(qualified_candidates, [5], Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: qualified_candidates as a non-integer 5.5: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(qualified_candidates, 5.5, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: qualified_candidates as a negative count -1: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(qualified_candidates, -1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: qualified_candidates as boolean True: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(qualified_candidates, true, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_candidates as an atom: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(invited_candidates, five, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_candidates as a string (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer or crash') :-
    profile_with(invited_candidates, "5", Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_candidates as a list: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(invited_candidates, [5], Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_candidates as a non-integer 5.5: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(invited_candidates, 5.5, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_candidates as a negative count -1: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(invited_candidates, -1, Profile),
    shortlisting_outcome(Profile, answers([])).
test('wrong type: invited_candidates as boolean True: decide_shortlisting must refuse, not answer or crash') :-
    profile_with(invited_candidates, true, Profile),
    shortlisting_outcome(Profile, answers([])).
test('empty profile: decide_shortlisting must refuse, not answer') :-
    dict_pairs(Profile, []),
    shortlisting_outcome(Profile, answers([])).
test('exactly one answer: decide_shortlisting, every fixture profile') :-
    findall(Subject, shortlisting_subject(Subject), Subjects),
    length(Subjects, 10),
    findall(Subject, (shortlisting_subject(Subject), not_one_shortlisting_answer(Subject)), Offenders),
    Offenders = [].
test('boundary: restricted, declared minimum 4 (one below statutory 5) is limitation_prohibited') :-
    profile_with(declared_minimum_candidates, 4, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_prohibited, [declared_minimum_below_statutory_minimum, fewer_invited_than_minimum_number], 10, [cite(eu_dir_2014_24_art_65_2_minima), cite(eu_dir_2014_24_art_65_2_invitation_floor)])])).
test('boundary: restricted, declared minimum 5 (at statutory 5) is limitation_permitted') :-
    profile_with(declared_minimum_candidates, 5, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_permitted, [], 5, [])])).
test('boundary: restricted, declared minimum 6 (one above statutory 5), 6 invited, is limitation_permitted with 6 to invite') :-
    profile_with_two(declared_minimum_candidates, 6, invited_candidates, 6, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_permitted, [], 6, [])])).
test('boundary: competitive procedure with negotiation, declared minimum 2 (one below statutory 3) is limitation_prohibited') :-
    shortlisting_profile_for("cpwn_all_clear", Base),
    override_key(Base, declared_minimum_candidates, 2, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_prohibited, [declared_minimum_below_statutory_minimum, fewer_invited_than_minimum_number], 8, [cite(eu_dir_2014_24_art_65_2_minima), cite(eu_dir_2014_24_art_65_2_invitation_floor)])])).
test('boundary: competitive procedure with negotiation, declared minimum 3 (at statutory 3) is limitation_permitted') :-
    shortlisting_profile_for("cpwn_all_clear", Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_permitted, [], 3, [])])).
test('boundary: invited 4 (one below the floor of 5) is limitation_prohibited for fewer_invited_than_minimum_number') :-
    profile_with(invited_candidates, 4, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_prohibited, [fewer_invited_than_minimum_number], 5, [cite(eu_dir_2014_24_art_65_2_invitation_floor)])])).
test('boundary: invited 6 (one above the floor of 5) is limitation_permitted') :-
    profile_with(invited_candidates, 6, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_permitted, [], 5, [])])).
test('boundary: qualified 4 (one below declared minimum 5) is continuation_permitted with 4 to invite') :-
    profile_with(qualified_candidates, 4, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(continuation_permitted, [], 4, [])])).
test('boundary: qualified 5 (at declared minimum 5) is limitation_permitted') :-
    profile_with(qualified_candidates, 5, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_permitted, [], 5, [])])).
test('boundary: qualified 6 (one above declared minimum 5) is limitation_permitted') :-
    profile_with(qualified_candidates, 6, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_permitted, [], 5, [])])).
test('boundary: declared maximum 0 (no maximum declared, profile_keys.yaml) is limitation_permitted') :-
    profile_with(declared_maximum_candidates, 0, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_permitted, [], 5, [])])).
test('boundary: declared maximum 4 (one below declared minimum 5) is limitation_prohibited') :-
    profile_with(declared_maximum_candidates, 4, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_prohibited, [declared_maximum_below_declared_minimum], 5, [cite(eu_dir_2014_24_art_65_2_indication)])])).
test('boundary: declared maximum 5 (at declared minimum 5) is limitation_permitted') :-
    profile_with(declared_maximum_candidates, 5, Profile),
    shortlisting_outcome(Profile, answers([shortlisting_verdict(limitation_permitted, [], 5, [])])).
test('input check: no fixture profile has a problem') :-
    findall(Subject, (shortlisting_subject(Subject), shortlisting_profile_for(Subject, Profile), shortlisting_input_problem(Profile, _)), Offenders),
    Offenders = [].
test('input check reports exactly one problem (the first)') :-
    dict_pairs(Profile, []),
    findall(Problem, shortlisting_input_problem(Profile, Problem), Problems),
    Problems = [missing_key(procedure_type_key)].
test('input check reports not_ground for a profile holding an unbound variable') :-
    profile_with(qualified_candidates, _, Profile),
    shortlisting_input_problem(Profile, not_ground).
test('input check reports wrong_type(profile, expected_dict) for a profile that is not a dict') :-
    shortlisting_input_problem([procedure_type_key], wrong_type(profile, expected_dict)).
test('input check reports missing_key for an Art 65(2) key of a restricted procedure') :-
    profile_without(invited_candidates, Profile),
    shortlisting_input_problem(Profile, missing_key(invited_candidates)).
test('input check reports wrong_value for a procedure type outside the vocabulary') :-
    first_problem(procedure_type_key, procedure_not_in_vocabulary, wrong_value(procedure_type_key, expected_procedure_type_atom)).
test('input check reports wrong_type expected_boolean for an integer flag') :-
    first_problem(minimum_number_indicated, 0, wrong_type(minimum_number_indicated, expected_boolean)).
test('input check reports wrong_type expected_integer_count for a non-integer count') :-
    first_problem(qualified_candidates, 5.5, wrong_type(qualified_candidates, expected_integer_count)).
test('input check reports negative_count for a negative count') :-
    first_problem(invited_candidates, -1, negative_count(invited_candidates)).
test('input check: an open procedure with a wrongly typed key present is still refused') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, qualified_candidates - five]),
    shortlisting_input_problem(Profile, wrong_type(qualified_candidates, expected_integer_count)),
    dict_pairs(Profile2, [procedure_type_key - open_procedure, qualified_candidates - five]),
    shortlisting_outcome(Profile2, answers([])).
test('not ground: decide_shortlisting refuses a profile with an unbound flag') :-
    profile_with(minimum_number_indicated, _, Profile),
    shortlisting_outcome(Profile, answers([])).
test('not ground: decide_shortlisting refuses an unbound profile') :-
    shortlisting_outcome(_, answers([])).
test('entry point: shortlisting_status, shortlisting_checklist and shortlisting_decision_resolvable refuse a bad profile') :-
    profile_with(invited_candidates, five, Profile),
    findall(Status, shortlisting_status(Profile, Status), Statuses),
    Statuses = [],
    findall(Checklist, shortlisting_checklist(Profile, Checklist), Checklists),
    Checklists = [],
    findall(Profile, shortlisting_decision_resolvable(Profile), []).
test('entry point: shortlisting_what_if refuses a wrongly typed override value') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    findall(Status, shortlisting_what_if(Profile, qualified_candidates, five, Status), Statuses),
    Statuses = [].
test('entry point: shortlisting_what_if refuses an unbound profile') :-
    findall(Status, shortlisting_what_if(_, qualified_candidates, 5, Status), Statuses),
    Statuses = [].
test('entry point: shortlisting_threshold_flip refuses a bad profile') :-
    profile_with(minimum_number_indicated, yes, Profile),
    findall(Boundary, shortlisting_threshold_flip(Profile, qualified_candidates, 0, 20, Boundary), Boundaries),
    Boundaries = [].
test('entry point: shortlisting_invitation_floor refuses an atom count without crashing') :-
    catch((findall(Floor, shortlisting_invitation_floor(restricted_procedure, five, 10, Floor), Floors), Outcome = answers(Floors)), Caught, Outcome = raised(Caught)),
    Outcome = answers([]).
test('entry point: shortlisting_limitation_modality refuses unbound counts without crashing') :-
    catch((findall(Modality, shortlisting_limitation_modality(restricted_procedure, _, _, Modality), Modalities), Outcome = answers(Modalities)), Caught, Outcome = raised(Caught)),
    Outcome = answers([]).

one_shortlisting_answer(Subject) :-
    shortlisting_profile_for(Subject, Profile),
    shortlisting_outcome(Profile, answers([_])).

not_one_shortlisting_answer(Subject) :-
    shortlisting_profile_for(Subject, Profile),
    shortlisting_outcome(Profile, Outcome),
    not_exactly_one_answer(Outcome).

not_exactly_one_answer(answers([])).
not_exactly_one_answer(answers([_, _|_])).
not_exactly_one_answer(raised(_)).

first_problem(Key, Value, Problem) :-
    profile_with(Key, Value, Profile),
    shortlisting_input_problem(Profile, Problem).

cp_test_names(['control: restricted_all_clear is limitation_permitted with 5 to invite, exactly one answer', 'missing procedure_type_key (Art 65(1)): decide_shortlisting must refuse, not answer', 'missing objective_and_non_discriminatory_criteria_indicated (Art 65(2) first sub-paragraph): decide_shortlisting must refuse, not answer', 'missing minimum_number_indicated (Art 65(2) first sub-paragraph): decide_shortlisting must refuse, not answer', 'missing declared_minimum_candidates (Art 65(2) first sub-paragraph): decide_shortlisting must refuse, not answer', 'missing declared_maximum_candidates (Art 65(2) first sub-paragraph): decide_shortlisting must refuse, not answer', 'missing qualified_candidates (Art 65(1) and 65(2) third sub-paragraph): decide_shortlisting must refuse, not answer', 'missing invited_candidates (Art 65(2) third sub-paragraph): decide_shortlisting must refuse, not answer', 'missing number_invited_sufficient_for_genuine_competition (Art 65(2) second sub-paragraph final sentence): decide_shortlisting must refuse, not answer', 'missing invited_include_non_requesting_economic_operators (Art 65(2) third sub-paragraph final sentence): decide_shortlisting must refuse, not answer', 'missing invited_include_candidates_without_required_capabilities (Art 65(2) third sub-paragraph final sentence): decide_shortlisting must refuse, not answer', 'by design: open procedure with only procedure_type_key is limitation_not_available (Art 65(1))', 'wrong value: procedure_type_key outside the six-atom vocabulary: decide_shortlisting must refuse', 'wrong type: procedure_type_key as a string: decide_shortlisting must refuse', 'wrong type: procedure_type_key as a number: decide_shortlisting must refuse', 'wrong type: procedure_type_key as a list: decide_shortlisting must refuse', 'wrong type: objective_and_non_discriminatory_criteria_indicated as atom yes: decide_shortlisting must refuse, not answer', 'wrong type: objective_and_non_discriminatory_criteria_indicated as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer', 'wrong type: objective_and_non_discriminatory_criteria_indicated as integer 1: decide_shortlisting must refuse, not answer', 'wrong type: objective_and_non_discriminatory_criteria_indicated as integer 0: decide_shortlisting must refuse, not answer', 'wrong type: minimum_number_indicated as atom yes: decide_shortlisting must refuse, not answer', 'wrong type: minimum_number_indicated as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer', 'wrong type: minimum_number_indicated as integer 1: decide_shortlisting must refuse, not answer', 'wrong type: minimum_number_indicated as integer 0: decide_shortlisting must refuse, not answer', 'wrong type: number_invited_sufficient_for_genuine_competition as atom yes: decide_shortlisting must refuse, not answer', 'wrong type: number_invited_sufficient_for_genuine_competition as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer', 'wrong type: number_invited_sufficient_for_genuine_competition as integer 1: decide_shortlisting must refuse, not answer', 'wrong type: number_invited_sufficient_for_genuine_competition as integer 0: decide_shortlisting must refuse, not answer', 'wrong type: invited_include_non_requesting_economic_operators as atom yes: decide_shortlisting must refuse, not answer', 'wrong type: invited_include_non_requesting_economic_operators as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer', 'wrong type: invited_include_non_requesting_economic_operators as integer 1: decide_shortlisting must refuse, not answer', 'wrong type: invited_include_non_requesting_economic_operators as integer 0: decide_shortlisting must refuse, not answer', 'wrong type: invited_include_candidates_without_required_capabilities as atom yes: decide_shortlisting must refuse, not answer', 'wrong type: invited_include_candidates_without_required_capabilities as string true (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer', 'wrong type: invited_include_candidates_without_required_capabilities as integer 1: decide_shortlisting must refuse, not answer', 'wrong type: invited_include_candidates_without_required_capabilities as integer 0: decide_shortlisting must refuse, not answer', 'wrong type: declared_minimum_candidates as an atom: decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_minimum_candidates as a string (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_minimum_candidates as a list: decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_minimum_candidates as a non-integer 5.5: decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_minimum_candidates as a negative count -1: decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_minimum_candidates as boolean True: decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_maximum_candidates as an atom: decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_maximum_candidates as a string (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_maximum_candidates as a list: decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_maximum_candidates as a non-integer 5.5: decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_maximum_candidates as a negative count -1: decide_shortlisting must refuse, not answer or crash', 'wrong type: declared_maximum_candidates as boolean True: decide_shortlisting must refuse, not answer or crash', 'wrong type: qualified_candidates as an atom: decide_shortlisting must refuse, not answer or crash', 'wrong type: qualified_candidates as a string (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer or crash', 'wrong type: qualified_candidates as a list: decide_shortlisting must refuse, not answer or crash', 'wrong type: qualified_candidates as a non-integer 5.5: decide_shortlisting must refuse, not answer or crash', 'wrong type: qualified_candidates as a negative count -1: decide_shortlisting must refuse, not answer or crash', 'wrong type: qualified_candidates as boolean True: decide_shortlisting must refuse, not answer or crash', 'wrong type: invited_candidates as an atom: decide_shortlisting must refuse, not answer or crash', 'wrong type: invited_candidates as a string (a char list under double_quotes(chars)): decide_shortlisting must refuse, not answer or crash', 'wrong type: invited_candidates as a list: decide_shortlisting must refuse, not answer or crash', 'wrong type: invited_candidates as a non-integer 5.5: decide_shortlisting must refuse, not answer or crash', 'wrong type: invited_candidates as a negative count -1: decide_shortlisting must refuse, not answer or crash', 'wrong type: invited_candidates as boolean True: decide_shortlisting must refuse, not answer or crash', 'empty profile: decide_shortlisting must refuse, not answer', 'exactly one answer: decide_shortlisting, every fixture profile', 'boundary: restricted, declared minimum 4 (one below statutory 5) is limitation_prohibited', 'boundary: restricted, declared minimum 5 (at statutory 5) is limitation_permitted', 'boundary: restricted, declared minimum 6 (one above statutory 5), 6 invited, is limitation_permitted with 6 to invite', 'boundary: competitive procedure with negotiation, declared minimum 2 (one below statutory 3) is limitation_prohibited', 'boundary: competitive procedure with negotiation, declared minimum 3 (at statutory 3) is limitation_permitted', 'boundary: invited 4 (one below the floor of 5) is limitation_prohibited for fewer_invited_than_minimum_number', 'boundary: invited 6 (one above the floor of 5) is limitation_permitted', 'boundary: qualified 4 (one below declared minimum 5) is continuation_permitted with 4 to invite', 'boundary: qualified 5 (at declared minimum 5) is limitation_permitted', 'boundary: qualified 6 (one above declared minimum 5) is limitation_permitted', 'boundary: declared maximum 0 (no maximum declared, profile_keys.yaml) is limitation_permitted', 'boundary: declared maximum 4 (one below declared minimum 5) is limitation_prohibited', 'boundary: declared maximum 5 (at declared minimum 5) is limitation_permitted', 'input check: no fixture profile has a problem', 'input check reports exactly one problem (the first)', 'input check reports not_ground for a profile holding an unbound variable', 'input check reports wrong_type(profile, expected_dict) for a profile that is not a dict', 'input check reports missing_key for an Art 65(2) key of a restricted procedure', 'input check reports wrong_value for a procedure type outside the vocabulary', 'input check reports wrong_type expected_boolean for an integer flag', 'input check reports wrong_type expected_integer_count for a non-integer count', 'input check reports negative_count for a negative count', 'input check: an open procedure with a wrongly typed key present is still refused', 'not ground: decide_shortlisting refuses a profile with an unbound flag', 'not ground: decide_shortlisting refuses an unbound profile', 'entry point: shortlisting_status, shortlisting_checklist and shortlisting_decision_resolvable refuse a bad profile', 'entry point: shortlisting_what_if refuses a wrongly typed override value', 'entry point: shortlisting_what_if refuses an unbound profile', 'entry point: shortlisting_threshold_flip refuses a bad profile', 'entry point: shortlisting_invitation_floor refuses an atom count without crashing', 'entry point: shortlisting_limitation_modality refuses unbound counts without crashing']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
