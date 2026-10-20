:- module(m__eu_procurement_utilities_negotiated_without_prior_call_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_keys/2, dict_pairs/2, get/3]).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_utilities_negotiated_without_prior_call, [decide_utilities_negotiated_without_prior_call/2, utilities_negotiated_without_prior_call_input_problem/2, utilities_negotiated_without_prior_call_status/2, utilities_negotiated_without_prior_call_checklist/2, utilities_negotiated_without_prior_call_unmet_count/2]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_queries, [utilities_negotiated_without_prior_call_what_if/4]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_fixtures, [utilities_negotiated_without_prior_call_subject/1, utilities_negotiated_without_prior_call_profile_for/2]).
:- use_module(query_combinators, [override_key/4]).
:- use_module(formalize_lib, [not_member/2, term_mismatch/2]).

decision_outcome(Profile, Outcome) :-
    catch((findall(Verdict, decide_utilities_negotiated_without_prior_call(Profile, Verdict), Verdicts), Outcome = answers(Verdicts)), Error, Outcome = raised(Error)).

gives_no_verdict(Profile) :-
    decision_outcome(Profile, Outcome),
    Outcome = answers([]).

gives_only_use_unlawful(Profile) :-
    decision_outcome(Profile, Outcome),
    Outcome = answers([utilities_negotiated_verdict(use_unlawful, n_a, _)]).

gives_only_use_lawful(Profile) :-
    decision_outcome(Profile, Outcome),
    Outcome = answers([utilities_negotiated_verdict(use_lawful, _, _)]).

fixture(Subject, Profile) :-
    utilities_negotiated_without_prior_call_profile_for(Subject, Profile).

lawful_subject(Subject) :-
    utilities_negotiated_without_prior_call_subject(Subject),
    fixture(Subject, Profile),
    decide_utilities_negotiated_without_prior_call(Profile, utilities_negotiated_verdict(use_lawful, _, _)).

ground_limited_by_contract_type(art_50_e_additional_deliveries).
ground_limited_by_contract_type(art_50_f_repetition).
ground_limited_by_contract_type(art_50_g_commodity_market).
ground_limited_by_contract_type(art_50_h_bargain_purchase).
ground_limited_by_contract_type(art_50_i_advantageous_winding_up).
ground_limited_by_contract_type(art_50_j_design_contest).

gives_some_verdict_or_raises(Profile) :-
    decision_outcome(Profile, Outcome),
    outcome_with_verdicts_or_raised(Outcome).

outcome_with_verdicts_or_raised(answers([_|_])).
outcome_with_verdicts_or_raised(raised(_)).

outcome_without_verdicts(answers([])).
outcome_without_verdicts(raised(_)).

gives_other_than_only_use_unlawful(Profile) :-
    decision_outcome(Profile, Outcome),
    outcome_other_than_only(utilities_negotiated_verdict(use_unlawful, n_a, _), Outcome).

gives_other_than_only_use_lawful(Profile) :-
    decision_outcome(Profile, Outcome),
    outcome_other_than_only(utilities_negotiated_verdict(use_lawful, _, _), Outcome).

outcome_other_than_only(_, raised(_)).
outcome_other_than_only(_, answers([])).
outcome_other_than_only(Pattern, answers([Verdict])) :-
    term_mismatch(Pattern, Verdict).
outcome_other_than_only(_, answers([_, _|_])).

not_exactly_one([]).
not_exactly_one([_, _|_]).

ground_not_limited_by_contract_type(Ground) :-
    not_member(Ground, [art_50_e_additional_deliveries, art_50_f_repetition, art_50_g_commodity_market, art_50_h_bargain_purchase, art_50_i_advantageous_winding_up, art_50_j_design_contest]).

profile_without_key(Key, Profile, Reduced) :-
    dict_pairs(Profile, Pairs),
    pairs_without_key(Pairs, Key, ReducedPairs),
    dict_pairs(Reduced, ReducedPairs).

pairs_without_key([Key - _|Tail], Key, Tail).
pairs_without_key([OtherKey - Value|Tail], Key, [OtherKey - Value|Rest]) :-
    dif(OtherKey, Key),
    pairs_without_key(Tail, Key, Rest).

test('there are twelve lawful fixtures to start from') :-
    findall(Subject, lawful_subject(Subject), Subjects),
    length(Subjects, 12).
test('dropping the pleaded ground gives no verdict, for every lawful fixture') :-
    findall(Subject, (lawful_subject(Subject), fixture(Subject, Profile), profile_without_key(pleaded_ground_key, Profile, Reduced), gives_some_verdict_or_raises(Reduced)), Offenders),
    Offenders = [].
test('default: dropping any condition flag from a lawful fixture gives use_unlawful') :-
    findall(Subject - Key, (lawful_subject(Subject), fixture(Subject, Profile), dict_keys(Profile, Keys), member(Key, Keys), not_member(Key, [pleaded_ground_key, contract_type_key, sole_operator_reason_key])), Examined),
    length(Examined, ExaminedCount),
    ExaminedCount #> 20,
    findall(Subject - Key, (lawful_subject(Subject), fixture(Subject, Profile), dict_keys(Profile, Keys), member(Key, Keys), not_member(Key, [pleaded_ground_key, contract_type_key, sole_operator_reason_key]), profile_without_key(Key, Profile, Reduced), gives_other_than_only_use_unlawful(Reduced)), Offenders),
    Offenders = [].
test('default: dropping the contract type gives use_unlawful where the ground is limited by type') :-
    findall(Subject, (lawful_subject(Subject), fixture(Subject, Profile), get(Profile, pleaded_ground_key, Ground), ground_limited_by_contract_type(Ground), profile_without_key(contract_type_key, Profile, Reduced), gives_other_than_only_use_unlawful(Reduced)), Offenders),
    Offenders = [].
test('dropping the contract type leaves grounds (a) to (d) lawful') :-
    findall(Subject, (lawful_subject(Subject), fixture(Subject, Profile), get(Profile, pleaded_ground_key, Ground), ground_not_limited_by_contract_type(Ground), profile_without_key(contract_type_key, Profile, Reduced), gives_other_than_only_use_lawful(Reduced)), Offenders),
    Offenders = [].
test('default: dropping the sole operator reason gives use_unlawful') :-
    findall(Subject, (lawful_subject(Subject), fixture(Subject, Profile), get(Profile, pleaded_ground_key, art_50_c_sole_operator), profile_without_key(sole_operator_reason_key, Profile, Reduced), gives_other_than_only_use_unlawful(Reduced)), Offenders),
    Offenders = [].
test('pleaded ground spelled as a character list gives no verdict') :-
    fixture("a_lawful", Profile),
    override_key(Profile, pleaded_ground_key, "art_50_a_no_suitable_tenders", Changed),
    gives_no_verdict(Changed).
test('pleaded ground given as a number gives no verdict') :-
    fixture("a_lawful", Profile),
    override_key(Profile, pleaded_ground_key, 50, Changed),
    gives_no_verdict(Changed).
test('pleaded ground given as a list gives no verdict') :-
    fixture("a_lawful", Profile),
    override_key(Profile, pleaded_ground_key, [art_50_a_no_suitable_tenders], Changed),
    gives_no_verdict(Changed).
test('pleaded ground outside the ten gives use_unlawful') :-
    fixture("a_lawful", Profile),
    override_key(Profile, pleaded_ground_key, not_a_ground, Changed),
    gives_only_use_unlawful(Changed).
test('unbound pleaded ground gives no verdict instead of being solved to a lawful ground') :-
    fixture("a_lawful", Profile),
    override_key(Profile, pleaded_ground_key, _, Changed),
    gives_no_verdict(Changed).
test('contract type spelled as a character list gives no verdict for ground (e)') :-
    fixture("e_lawful", Profile),
    override_key(Profile, contract_type_key, "supplies", Changed),
    gives_no_verdict(Changed).
test('contract type given as a number gives no verdict for ground (e)') :-
    fixture("e_lawful", Profile),
    override_key(Profile, contract_type_key, 1, Changed),
    gives_no_verdict(Changed).
test('contract type given as a list gives no verdict for ground (e)') :-
    fixture("e_lawful", Profile),
    override_key(Profile, contract_type_key, [supplies], Changed),
    gives_no_verdict(Changed).
test('unbound contract type gives no verdict instead of satisfying the supplies-only gate of ground (e)') :-
    fixture("e_lawful", Profile),
    override_key(Profile, contract_type_key, _, Changed),
    gives_no_verdict(Changed).
test('unbound contract type gives no verdict instead of satisfying the works-or-services gate of ground (f)') :-
    fixture("f_lawful", Profile),
    override_key(Profile, contract_type_key, _, Changed),
    gives_no_verdict(Changed).
test('condition flag given as the number 1 gives no verdict') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, 1, Changed),
    gives_no_verdict(Changed).
test('condition flag given as an atom other than true gives no verdict') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, yes, Changed),
    gives_no_verdict(Changed).
test('condition flag spelled as a character list gives no verdict') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, "true", Changed),
    gives_no_verdict(Changed).
test('condition flag given as a list gives no verdict') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, [true], Changed),
    gives_no_verdict(Changed).
test('unbound condition flag gives no verdict instead of reading as established') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, _, Changed),
    gives_no_verdict(Changed).
test('all condition flags unbound give no verdict instead of a lawful use') :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_f_repetition, contract_type_key - services, repetition_conforms_to_basic_project - _, original_contract_followed_article_44_1_procedure - _, basic_project_indicated_extent_and_conditions - _, possible_use_of_this_procedure_disclosed_at_first_tender - _]),
    gives_no_verdict(Profile).
test('sole operator reason spelled as a character list gives no verdict') :-
    fixture("c_art_lawful", Profile),
    override_key(Profile, sole_operator_reason_key, "unique_artistic_work_or_performance", Changed),
    gives_no_verdict(Changed).
test('sole operator reason given as a number gives no verdict') :-
    fixture("c_art_lawful", Profile),
    override_key(Profile, sole_operator_reason_key, 3, Changed),
    gives_no_verdict(Changed).
test('unbound sole operator reason gives no verdict instead of being solved to a reason') :-
    fixture("c_art_lawful", Profile),
    override_key(Profile, sole_operator_reason_key, _, Changed),
    gives_no_verdict(Changed).
test('a profile that is not a dict gives no definite verdict') :-
    decision_outcome(not_a_profile, Outcome),
    outcome_without_verdicts(Outcome).
test('empty profile gives no verdict and raises nothing') :-
    dict_pairs(Empty, []),
    gives_no_verdict(Empty).
test('every fixture profile yields exactly one verdict') :-
    findall(Subject, utilities_negotiated_without_prior_call_subject(Subject), Subjects),
    length(Subjects, 24),
    findall(Subject, (utilities_negotiated_without_prior_call_subject(Subject), fixture(Subject, Profile), findall(Verdict, decide_utilities_negotiated_without_prior_call(Profile, Verdict), Verdicts), not_exactly_one(Verdicts)), Offenders),
    Offenders = [].
test('input check finds no problem on any registered fixture') :-
    findall(Subject, (utilities_negotiated_without_prior_call_subject(Subject), fixture(Subject, Profile), utilities_negotiated_without_prior_call_input_problem(Profile, _)), Offenders),
    Offenders = [].
test('refused: an unbound value is reported as not_ground') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, _, Changed),
    problem_is(Changed, not_ground).
test('refused: a profile that is not a dict') :-
    problem_is(not_a_profile, not_a_dict).
test('refused: the empty profile is reported as missing the pleaded ground') :-
    dict_pairs(Empty, []),
    problem_is(Empty, missing_key(pleaded_ground_key)).
test('refused: a pleaded ground given as a number') :-
    fixture("a_lawful", Profile),
    override_key(Profile, pleaded_ground_key, 50, Changed),
    problem_is(Changed, wrong_type(pleaded_ground_key, expected_atom)).
test('refused: a pleaded ground spelled as a character list') :-
    fixture("a_lawful", Profile),
    override_key(Profile, pleaded_ground_key, "art_50_a_no_suitable_tenders", Changed),
    problem_is(Changed, wrong_type(pleaded_ground_key, expected_atom)).
test('refused: a contract type given as a list') :-
    fixture("e_lawful", Profile),
    override_key(Profile, contract_type_key, [supplies], Changed),
    problem_is(Changed, wrong_type(contract_type_key, expected_atom)).
test('refused: a contract type that is not works, supplies or services') :-
    fixture("e_lawful", Profile),
    override_key(Profile, contract_type_key, not_a_contract_type, Changed),
    problem_is(Changed, wrong_value(contract_type_key, expected_contract_type)).
test('refused: a sole operator reason given as a number') :-
    fixture("c_art_lawful", Profile),
    override_key(Profile, sole_operator_reason_key, 3, Changed),
    problem_is(Changed, wrong_type(sole_operator_reason_key, expected_atom)).
test('refused: a condition flag given as the number 1') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, 1, Changed),
    problem_is(Changed, wrong_type(initial_conditions_not_substantially_altered, expected_boolean)).
test('refused: a condition flag given as an atom other than true or false') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, yes, Changed),
    problem_is(Changed, wrong_type(initial_conditions_not_substantially_altered, expected_boolean)).
test('refused: a condition flag spelled as a character list') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, "true", Changed),
    problem_is(Changed, wrong_type(initial_conditions_not_substantially_altered, expected_boolean)).
test('documented: a sole operator reason that is an atom outside the three is not refused and the use is unlawful') :-
    fixture("c_art_lawful", Profile),
    override_key(Profile, sole_operator_reason_key, not_a_ground, Referred),
    findall(Problem, utilities_negotiated_without_prior_call_input_problem(Referred, Problem), []),
    gives_only_use_unlawful(Referred).
test('status, checklist, unmet count and what-if give no answer on a refused profile') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, 1, Refused),
    findall(Status, utilities_negotiated_without_prior_call_status(Refused, Status), []),
    findall(Checklist, utilities_negotiated_without_prior_call_checklist(Refused, Checklist), []),
    findall(Count, utilities_negotiated_without_prior_call_unmet_count(Refused, Count), []),
    findall(NewStatus, utilities_negotiated_without_prior_call_what_if(Refused, no_suitable_tenders_or_requests_received, true, NewStatus), []).
test('what-if can still correct the refused key it overrides') :-
    fixture("a_lawful", Profile),
    override_key(Profile, initial_conditions_not_substantially_altered, 1, Refused),
    utilities_negotiated_without_prior_call_what_if(Refused, initial_conditions_not_substantially_altered, true, use_lawful).

problem_is(Profile, ExpectedProblem) :-
    findall(Problem, utilities_negotiated_without_prior_call_input_problem(Profile, Problem), [ExpectedProblem]),
    gives_no_verdict(Profile).

cp_test_names(['there are twelve lawful fixtures to start from', 'dropping the pleaded ground gives no verdict, for every lawful fixture', 'default: dropping any condition flag from a lawful fixture gives use_unlawful', 'default: dropping the contract type gives use_unlawful where the ground is limited by type', 'dropping the contract type leaves grounds (a) to (d) lawful', 'default: dropping the sole operator reason gives use_unlawful', 'pleaded ground spelled as a character list gives no verdict', 'pleaded ground given as a number gives no verdict', 'pleaded ground given as a list gives no verdict', 'pleaded ground outside the ten gives use_unlawful', 'unbound pleaded ground gives no verdict instead of being solved to a lawful ground', 'contract type spelled as a character list gives no verdict for ground (e)', 'contract type given as a number gives no verdict for ground (e)', 'contract type given as a list gives no verdict for ground (e)', 'unbound contract type gives no verdict instead of satisfying the supplies-only gate of ground (e)', 'unbound contract type gives no verdict instead of satisfying the works-or-services gate of ground (f)', 'condition flag given as the number 1 gives no verdict', 'condition flag given as an atom other than true gives no verdict', 'condition flag spelled as a character list gives no verdict', 'condition flag given as a list gives no verdict', 'unbound condition flag gives no verdict instead of reading as established', 'all condition flags unbound give no verdict instead of a lawful use', 'sole operator reason spelled as a character list gives no verdict', 'sole operator reason given as a number gives no verdict', 'unbound sole operator reason gives no verdict instead of being solved to a reason', 'a profile that is not a dict gives no definite verdict', 'empty profile gives no verdict and raises nothing', 'every fixture profile yields exactly one verdict', 'input check finds no problem on any registered fixture', 'refused: an unbound value is reported as not_ground', 'refused: a profile that is not a dict', 'refused: the empty profile is reported as missing the pleaded ground', 'refused: a pleaded ground given as a number', 'refused: a pleaded ground spelled as a character list', 'refused: a contract type given as a list', 'refused: a contract type that is not works, supplies or services', 'refused: a sole operator reason given as a number', 'refused: a condition flag given as the number 1', 'refused: a condition flag given as an atom other than true or false', 'refused: a condition flag spelled as a character list', 'documented: a sole operator reason that is an atom outside the three is not refused and the use is unlawful', 'status, checklist, unmet count and what-if give no answer on a refused profile', 'what-if can still correct the refused key it overrides']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
