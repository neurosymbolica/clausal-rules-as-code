:- module(m__eu_procurement_shortlisting_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_shortlisting_kernel).
:- use_module(m__eu_procurement_shortlisting_citations, [citation/2]).

test('verdict status atoms are pairwise distinct') :-
    dif(limitation_not_available, limitation_prohibited),
    dif(limitation_not_available, continuation_permitted),
    dif(limitation_not_available, limitation_permitted),
    dif(limitation_prohibited, continuation_permitted),
    dif(limitation_prohibited, limitation_permitted),
    dif(continuation_permitted, limitation_permitted).
test('verdict constructor builds and destructures') :-
    Verdict = shortlisting_verdict(limitation_permitted, [objective_and_non_discriminatory_criteria_not_indicated, minimum_number_not_indicated], 5, [cite(eu_dir_2014_24_art_65_2_indication), cite(eu_dir_2014_24_art_65_2_indication)]),
    Verdict = shortlisting_verdict(Status, DefectIds, NumberToInvite, Citations),
    Status = limitation_permitted,
    DefectIds = [objective_and_non_discriminatory_criteria_not_indicated, minimum_number_not_indicated],
    NumberToInvite #= 5,
    Citations = [cite(eu_dir_2014_24_art_65_2_indication), cite(eu_dir_2014_24_art_65_2_indication)].
test('verdict constructor with empty defects and citations') :-
    Verdict = shortlisting_verdict(limitation_not_available, [], 0, []),
    Verdict = shortlisting_verdict(Status, DefectIds, NumberToInvite, Citations),
    Status = limitation_not_available,
    DefectIds = [],
    NumberToInvite #= 0,
    Citations = [].
test('citation record resolves for art 65(1)') :-
    citation(eu_dir_2014_24_art_65_1, Record),
    member(label - Label, Record),
    Label = 'Directive 2014/24/EU, Article 65(1) (the power to limit the number of candidates, and the four procedures in which it exists)'.
test('citation record resolves for the Art 65(2) minima sentence') :-
    citation(eu_dir_2014_24_art_65_2_minima, Record),
    member(label - Label, Record),
    Label = 'Directive 2014/24/EU, Article 65(2) second sub-paragraph, first two sentences (the minimum is five in the restricted procedure and three in the other three)'.
test('all eight defect limb atoms are pairwise distinct') :-
    dif(objective_and_non_discriminatory_criteria_not_indicated, minimum_number_not_indicated),
    dif(objective_and_non_discriminatory_criteria_not_indicated, declared_minimum_below_statutory_minimum),
    dif(objective_and_non_discriminatory_criteria_not_indicated, declared_maximum_below_declared_minimum),
    dif(objective_and_non_discriminatory_criteria_not_indicated, genuine_competition_not_ensured),
    dif(objective_and_non_discriminatory_criteria_not_indicated, fewer_invited_than_minimum_number),
    dif(objective_and_non_discriminatory_criteria_not_indicated, non_requesting_economic_operator_included),
    dif(objective_and_non_discriminatory_criteria_not_indicated, candidate_without_required_capabilities_included),
    dif(minimum_number_not_indicated, declared_minimum_below_statutory_minimum),
    dif(minimum_number_not_indicated, declared_maximum_below_declared_minimum),
    dif(minimum_number_not_indicated, genuine_competition_not_ensured),
    dif(minimum_number_not_indicated, fewer_invited_than_minimum_number),
    dif(minimum_number_not_indicated, non_requesting_economic_operator_included),
    dif(minimum_number_not_indicated, candidate_without_required_capabilities_included),
    dif(declared_minimum_below_statutory_minimum, declared_maximum_below_declared_minimum),
    dif(declared_minimum_below_statutory_minimum, genuine_competition_not_ensured),
    dif(declared_minimum_below_statutory_minimum, fewer_invited_than_minimum_number),
    dif(declared_minimum_below_statutory_minimum, non_requesting_economic_operator_included),
    dif(declared_minimum_below_statutory_minimum, candidate_without_required_capabilities_included),
    dif(declared_maximum_below_declared_minimum, genuine_competition_not_ensured),
    dif(declared_maximum_below_declared_minimum, fewer_invited_than_minimum_number),
    dif(declared_maximum_below_declared_minimum, non_requesting_economic_operator_included),
    dif(declared_maximum_below_declared_minimum, candidate_without_required_capabilities_included),
    dif(genuine_competition_not_ensured, fewer_invited_than_minimum_number),
    dif(genuine_competition_not_ensured, non_requesting_economic_operator_included),
    dif(genuine_competition_not_ensured, candidate_without_required_capabilities_included),
    dif(fewer_invited_than_minimum_number, non_requesting_economic_operator_included),
    dif(fewer_invited_than_minimum_number, candidate_without_required_capabilities_included),
    dif(non_requesting_economic_operator_included, candidate_without_required_capabilities_included).

cp_test_names(['verdict status atoms are pairwise distinct', 'verdict constructor builds and destructures', 'verdict constructor with empty defects and citations', 'citation record resolves for art 65(1)', 'citation record resolves for the Art 65(2) minima sentence', 'all eight defect limb atoms are pairwise distinct']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
