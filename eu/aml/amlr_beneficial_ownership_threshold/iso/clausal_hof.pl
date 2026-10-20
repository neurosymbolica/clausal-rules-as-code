% tools/iso_export/companion/clausal_hof.pl
% Generated-companion supplying the closure-taking Clausal builtins that no
% ISO engine has: call_goal/1..8 and the list higher-order predicates
% include/3, max_by/3 and min_by/3. Source of truth for the semantics is
% clausal/clausal/logic/builtins/higher_order.py -- call_goal/N at
% :22-50 (call/N is registered there as an ALIAS of the same trampoline),
% include/3 at :116, max_by/3 at :387, min_by/3 at :432. Pure, cut-free,
% ->-free, same house style as clausal_kleene.pl and clausal_profiles.pl.
%
% WHY THIS FILE EXISTS. Scryer's library(lists) has none of these, and
% call_goal/N is not a list predicate at all -- it is the engine's own
% meta-call trampoline, the protocol every kit higher-order library speaks
% (kit/formalize_lib.clausal's eval_requirements/4, query_combinators'
% flip_scan/bisect_flip/what_if, planner_lib's plan_for/thread_plan, ...).
% Measured, Scryer cargo:0.10.0: `existence_error(procedure, call_goal/5)`.
% The design note (clausal/implementation_plans/
% prolog-lambda-lowering.md) §5 records the same for include/3 and widens it:
% include/3, exclude/3, partition/4, msort/2, last/2, max_by/3, min_by/3,
% take_while/3, drop_while/3, span/4, group_by/3, sort_by/3, filter_map/3,
% tfilter/3, tpartition/4 are all absent, and adding include/3 to
% LIBRARY_INJECTIONS moves the error rather than removing it (the use_module
% directive is silently satisfied; the CALL raises).
%
% WHAT IS HERE AND WHAT IS NOT -- censused, not speculated. Over the kit's
% 43 parseable .clausal files (2026-09-05):
%
%     call_goal/1  1 site     include/3   2 sites    max_by/3  1 site
%     call_goal/2  7 sites    exclude/3   0 sites    min_by/3  2 sites
%     call_goal/3 24 sites    partition/4 0 sites
%     call_goal/4  6 sites
%     call_goal/5  6 sites
%     call_goal/6  4 sites
%     call_goal/7  1 site
%
% exclude/3 and partition/4 are therefore NOT here: nothing in the kit
% consumes them, and a companion predicate no program reaches is a dead
% instrument that reads as a passing test. include/3, max_by/3 and min_by/3
% ARE here because the class-(c) hand-lift (step B-3) leaves those five sites
% passing a BARE PREDICATE NAME to them -- kit/query_combinators.clausal:165
% and :224 (include/3), :393 (max_by/3), kit/optimization_lib.clausal:110 and
% :143 (min_by/3) -- so each has a real consumer in the staged tree.
%
% call_goal/8 is defined although the kit stops at /7. The engine registers
% call_goal/1..8 (higher_order.py:44, `for _n in range(0, 8)`) and ISO
% guarantees call/1..8 and no more, so 1..8 is exactly the family that is both
% engine-faithful and implementable; stopping at /7 would leave a hole whose
% only symptom is an existence_error in some later domain. Every arity has its
% own test, so none of the eight is unexercised.
%
% THE meta_predicate DIRECTIVES ARE THE POINT, NOT DECORATION. ISO call/N
% resolves its goal in the module where the call/N textually sits -- here,
% clausal_hof -- so without a directive every one of these predicates raises
% existence_error on a bare reference from a caller module. Measured on the
% real layout, Scryer cargo:0.10.0, this file with the directives commented
% out and nothing else changed:
%
%     include(big, [1,2,3,4], R)  -> error(existence_error(procedure, big/1))
%     max_by(cost, [...], R)      -> error(existence_error(procedure, cost/2))
%     call_goal(req, r1, R)       -> error(existence_error(procedure, req/2))
%
% and with them, R = [3,4] / p(b,7) / met. That pairing is pinned in
% tools/iso_export/tests/test_companion_hof.py, not left to this comment.
% See design note §3.2/§3.3 and §10 for the mechanism and the mode vocabulary
% (integer N = "call/N appends N arguments"; it also pins the resolved
% predicate's ARITY in the caller's module, which is why each call_goal/K
% carries K-1 and not a blanket `:').
%
% The private helpers max_by_/5, min_by_/5, max_pick/6 and min_pick/6 carry NO
% directive and need none: max_by/3 and min_by/3 have already qualified the
% goal at their own call site, so what the helper receives and re-applies is
% an already-qualified `Module:Name' term. Measured -- t2/t3 above resolve
% through two helper hops with the helpers undeclared.
%
% DIVERGENCES FROM THE ENGINE, stated rather than assumed. All three are
% consequences of being cut-free, and all three are unreachable for the kit's
% own five consuming sites (every one passes a semidet, deterministic
% predicate over a ground list):
%
%  1. NONDETERMINISM. The engine runs each element's test/projection through
%     one StepGenerator and takes the FIRST solution. These clauses do not:
%     a test with two solutions makes include/3 yield two results, and a
%     projection with two keys makes max_by/3 yield two maxima. Closing it
%     needs a cut, `->', or a reified-truth if_/3 -- the note calls that a
%     companion-STYLE decision for the operator, not a correctness question,
%     and this file keeps the house style.
%  2. RESIDUAL CHOICE POINT. include/3 and max_pick/6 leave one behind (the
%     price of disjoint guards instead of a cut). An unwrapped top-level
%     include/3 prompts for more solutions; under findall/3, once/1 or a
%     failure-driven loop -- which is every use the exporter stages -- exactly
%     one answer comes back. Pinned by the *_det tests, which assert the
%     findall/3 result list has LENGTH ONE rather than merely containing the
%     right answer.
%  3. KEY COMPARISON is the ISO STANDARD ORDER (@>/@=<), where the engine uses
%     Python's own `>' with a standard-order key as its documented fallback
%     (higher_order.py:414 "A09-F012"). For keys of one numeric type -- what
%     every kit site projects -- the two agree exactly. They can disagree for
%     mixed int/float keys of equal value (the standard order puts Float
%     before Int) and for cross-type keys generally, where Python raises
%     TypeError and falls back while the standard order simply orders by type.
%
% TIE-BREAKING IS NOT a divergence and is deliberate: Python's max()/min()
% return the FIRST extremal element, so max_pick/6 and min_pick/6 keep the
% incumbent on an equal key (`K @=< K0' / `K @>= K0' select the incumbent).
% Pinned by max_by_tie_keeps_first / min_by_tie_keeps_first.
%
% EMPTY LIST FAILS for max_by/3 and min_by/3 -- there is no clause for `[]' --
% matching the engine's `not items -> yield (_fail, DONE)'. include/3 on `[]'
% succeeds with `[]', matching its own base case.
:- module(clausal_hof, [call_goal/1, call_goal/2, call_goal/3, call_goal/4,
                        call_goal/5, call_goal/6, call_goal/7, call_goal/8,
                        include/3, max_by/3, min_by/3]).

:- meta_predicate(call_goal(0)).
:- meta_predicate(call_goal(1, ?)).
:- meta_predicate(call_goal(2, ?, ?)).
:- meta_predicate(call_goal(3, ?, ?, ?)).
:- meta_predicate(call_goal(4, ?, ?, ?, ?)).
:- meta_predicate(call_goal(5, ?, ?, ?, ?, ?)).
:- meta_predicate(call_goal(6, ?, ?, ?, ?, ?, ?)).
:- meta_predicate(call_goal(7, ?, ?, ?, ?, ?, ?, ?)).
:- meta_predicate(include(1, ?, ?)).
:- meta_predicate(max_by(2, ?, ?)).
:- meta_predicate(min_by(2, ?, ?)).

call_goal(G) :- call(G).
call_goal(G, A) :- call(G, A).
call_goal(G, A, B) :- call(G, A, B).
call_goal(G, A, B, C) :- call(G, A, B, C).
call_goal(G, A, B, C, D) :- call(G, A, B, C, D).
call_goal(G, A, B, C, D, E) :- call(G, A, B, C, D, E).
call_goal(G, A, B, C, D, E, F) :- call(G, A, B, C, D, E, F).
call_goal(G, A, B, C, D, E, F, H) :- call(G, A, B, C, D, E, F, H).

include(_, [], []).
include(G, [X|Xs], [X|Ys]) :- call(G, X), include(G, Xs, Ys).
include(G, [X|Xs], Ys) :- \+ call(G, X), include(G, Xs, Ys).

max_by(G, [X|Xs], Max) :- call(G, X, K), max_by_(Xs, G, X, K, Max).

max_by_([], _, Best, _, Best).
max_by_([X|Xs], G, Best0, K0, Max) :-
    call(G, X, K),
    max_pick(K, K0, X, Best0, Best, K1),
    max_by_(Xs, G, Best, K1, Max).

max_pick(K, K0, X, _, X, K) :- K @> K0.
max_pick(K, K0, _, Best0, Best0, K0) :- K @=< K0.

min_by(G, [X|Xs], Min) :- call(G, X, K), min_by_(Xs, G, X, K, Min).

min_by_([], _, Best, _, Best).
min_by_([X|Xs], G, Best0, K0, Min) :-
    call(G, X, K),
    min_pick(K, K0, X, Best0, Best, K1),
    min_by_(Xs, G, Best, K1, Min).

min_pick(K, K0, X, _, X, K) :- K @< K0.
min_pick(K, K0, _, Best0, Best0, K0) :- K @>= K0.
