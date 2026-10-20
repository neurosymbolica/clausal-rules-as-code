:- module(m__eu_state_aid_de_minimis_cumulation_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_state_aid_de_minimis_cumulation_queries, [de_minimis_qualifying_grants/3, de_minimis_compare_refs/4, de_minimis_headroom/3, de_minimis_gap_to_ineligible/3, de_minimis_what_if/4]).
:- use_module(m__eu_state_aid_de_minimis_cumulation_cumulation, [de_minimis_ceiling/1, de_minimis_aid_in_window/3, de_minimis_verdict/3]).
:- use_module(query_combinators, [flip_scan/4]).

q_ref(date(2025, 6, 1)).

q_mixed_grants([[date(2024, 1, 1), 15000000], [date(2022, 6, 2), 5000000], [date(2022, 6, 1), 4000000], [date(2020, 1, 1), 20000000]]).

q_at_ceiling_grants([[date(2024, 1, 1), 30000000]]).

q_over_grants([[date(2024, 1, 1), 20000000], [date(2023, 6, 1), 15000000]]).

q_small_headroom_grants([[date(2024, 1, 1), 29999950]]).

test('qualifying: keeps exactly the in-window grants, in order') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_qualifying_grants(Gs, Ref, Q),
    Q = [[date(2024, 1, 1), 15000000], [date(2022, 6, 2), 5000000]].
test('qualifying: grant ON the reference date is included (inclusive upper bound)') :-
    de_minimis_qualifying_grants([[date(2025, 6, 1), 100]], date(2025, 6, 1), Q),
    Q = [[date(2025, 6, 1), 100]].
test('qualifying: empty grants stay empty') :-
    q_ref(Ref),
    de_minimis_qualifying_grants([], Ref, Q),
    Q = [].
test('DET qualifying') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    findall(Q, de_minimis_qualifying_grants(Gs, Ref, Q), L),
    length(L, 1).
test('qualifying: sum over the returned grants equals the rulebase total') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_qualifying_grants(Gs, Ref, Q),
    de_minimis_aid_in_window(Q, Ref, TQ),
    de_minimis_aid_in_window(Gs, Ref, TAll),
    TQ #= TAll.
test('compare: postponing the grant date rolls old aid out and flips the verdict') :-
    Gs = [[date(2022, 3, 1), 20000000], [date(2024, 1, 1), 15000000]],
    de_minimis_compare_refs(Gs, date(2025, 1, 1), date(2025, 6, 1), R),
    R = ref_comparison(35000000, ineligible, 15000000, eligible).
test('compare: same date on both sides agrees with itself') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_compare_refs(Gs, Ref, Ref, R),
    R = ref_comparison(20000000, eligible, 20000000, eligible).
test('DET compare') :-
    Gs = [[date(2022, 3, 1), 20000000], [date(2024, 1, 1), 15000000]],
    findall(R, de_minimis_compare_refs(Gs, date(2025, 1, 1), date(2025, 6, 1), R), L),
    length(L, 1).
test('headroom: ceiling minus the in-window total (out-of-window aid ignored)') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_headroom(Gs, Ref, H),
    H #= 10000000.
test('headroom: empty history has the full EUR 300k ceiling free') :-
    q_ref(Ref),
    de_minimis_headroom([], Ref, H),
    de_minimis_ceiling(C),
    H #= C.
test('headroom: exactly at the ceiling -> 0 (inclusive boundary)') :-
    q_ref(Ref),
    q_at_ceiling_grants(Gs),
    de_minimis_headroom(Gs, Ref, H),
    H #= 0.
test('headroom: already over the ceiling -> 0') :-
    q_ref(Ref),
    q_over_grants(Gs),
    de_minimis_headroom(Gs, Ref, H),
    H #= 0.
test('DET headroom (at-ceiling boundary point)') :-
    q_ref(Ref),
    q_at_ceiling_grants(Gs),
    findall(H, de_minimis_headroom(Gs, Ref, H), L),
    length(L, 1).
test('gap: eligible undertaking flips at headroom + 1') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_gap_to_ineligible(Gs, Ref, Gap),
    Gap #= 10000001.
test('gap: exactly at the ceiling, a single cent breaches') :-
    q_ref(Ref),
    q_at_ceiling_grants(Gs),
    de_minimis_gap_to_ineligible(Gs, Ref, Gap),
    Gap #= 1.
test('gap: already ineligible -> 0 (amlr pilot convention)') :-
    q_ref(Ref),
    q_over_grants(Gs),
    de_minimis_gap_to_ineligible(Gs, Ref, Gap),
    Gap #= 0.
test('gap MINIMALITY: gap flips the verdict, gap-1 does not') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_gap_to_ineligible(Gs, Ref, Gap),
    de_minimis_what_if(Gs, Ref, Gap, ineligible),
    Short #= Gap - 1,
    de_minimis_what_if(Gs, Ref, Short, eligible).
test('gap EMPIRICAL: kit flip_scan locates the rulebase flip exactly at gap (small range)') :-
    q_ref(Ref),
    q_small_headroom_grants(Gs),
    de_minimis_gap_to_ineligible(Gs, Ref, Gap),
    Gap #= 51,
    flip_scan(0, 80, de_minimis_what_if(Gs, Ref), Boundary),
    Boundary #= Gap.
test('gap EMPIRICAL: flip_scan window around a large analytic gap confirms the flip point') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_gap_to_ineligible(Gs, Ref, Gap),
    Lo #= Gap - 4,
    Hi #= Gap + 4,
    flip_scan(Lo, Hi, de_minimis_what_if(Gs, Ref), Boundary),
    Boundary #= Gap.
test('DET gap (eligible base)') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    findall(G, de_minimis_gap_to_ineligible(Gs, Ref, G), L),
    length(L, 1).
test('DET gap (ineligible base)') :-
    q_ref(Ref),
    q_over_grants(Gs),
    findall(G, de_minimis_gap_to_ineligible(Gs, Ref, G), L),
    length(L, 1).
test('what-if: a headroom-sized grant keeps eligibility (inclusive ceiling)') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_headroom(Gs, Ref, H),
    de_minimis_what_if(Gs, Ref, H, V),
    V = eligible.
test('what-if: one cent beyond headroom breaches') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_headroom(Gs, Ref, H),
    Over #= H + 1,
    de_minimis_what_if(Gs, Ref, Over, V),
    V = ineligible.
test('what-if: zero-amount grant never changes an eligible position') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    de_minimis_what_if(Gs, Ref, 0, V),
    V = eligible.
test('DET what-if') :-
    q_ref(Ref),
    q_mixed_grants(Gs),
    findall(V, de_minimis_what_if(Gs, Ref, 100, V), L),
    length(L, 1).

cp_test_names(['qualifying: keeps exactly the in-window grants, in order', 'qualifying: grant ON the reference date is included (inclusive upper bound)', 'qualifying: empty grants stay empty', 'DET qualifying', 'qualifying: sum over the returned grants equals the rulebase total', 'compare: postponing the grant date rolls old aid out and flips the verdict', 'compare: same date on both sides agrees with itself', 'DET compare', 'headroom: ceiling minus the in-window total (out-of-window aid ignored)', 'headroom: empty history has the full EUR 300k ceiling free', 'headroom: exactly at the ceiling -> 0 (inclusive boundary)', 'headroom: already over the ceiling -> 0', 'DET headroom (at-ceiling boundary point)', 'gap: eligible undertaking flips at headroom + 1', 'gap: exactly at the ceiling, a single cent breaches', 'gap: already ineligible -> 0 (amlr pilot convention)', 'gap MINIMALITY: gap flips the verdict, gap-1 does not', 'gap EMPIRICAL: kit flip_scan locates the rulebase flip exactly at gap (small range)', 'gap EMPIRICAL: flip_scan window around a large analytic gap confirms the flip point', 'DET gap (eligible base)', 'DET gap (ineligible base)', 'what-if: a headroom-sized grant keeps eligibility (inclusive ceiling)', 'what-if: one cent beyond headroom breaches', 'what-if: zero-amount grant never changes an eligible position', 'DET what-if']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
