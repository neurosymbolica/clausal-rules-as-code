% =====================================================================
% formalize_lib.pl -- reusable formalization PRIMITIVES (domain-independent)
% Clausify kit. ISO Prolog, cut-free, ->-free, ASCII-only.
% De-domain-1'd from the pilot domain's genesis formalize_lib.pl
% (CSA R5 / Traffic 1.1): primitives + a LABEL-NEUTRAL checklist engine.
% A domain supplies: requirement(?Id,+Profile,-Status,-Citation), its
% rule_set/checklist lists, and its facts. Status = met | unmet(R) | unknown(Keys).
% =====================================================================

% --- Profile access --------------------------------------------------
profile_get([attribute(K, V)|_], K, V).
profile_get([attribute(K1, _)|T], K, V) :- K1 \== K, profile_get(T, K, V).
profile_has(P, K) :- profile_get(P, K, _).

% --- Atomic checks (each yields exactly one Status) ------------------
% Well-typed-facts assumption: each check_* has exactly THREE clauses (met /
% unmet / unknown-key). A profile key that IS present but carries a wrong-typed
% value (e.g. an atom where a number is expected) matches NONE of the three
% clauses, so the check -- and therefore eval_requirements/assess -- fails
% outright. This means "totality" (every subject yields >=1 assessment) assumes
% well-typed profile facts; a malformed-type fact makes the subject
% un-assessable rather than returning unknown.
check_gte(P, K, T, _, met)          :- profile_get(P, K, V), number(V), V >= T.
check_gte(P, K, T, R, unmet(R))     :- profile_get(P, K, V), number(V), V < T.
check_gte(P, K, _, _, unknown([K])) :- \+ profile_has(P, K).

check_lte(P, K, T, _, met)          :- profile_get(P, K, V), number(V), V =< T.
check_lte(P, K, T, R, unmet(R))     :- profile_get(P, K, V), number(V), V > T.
check_lte(P, K, _, _, unknown([K])) :- \+ profile_has(P, K).

check_true(P, K, _, met)          :- profile_get(P, K, true).
check_true(P, K, R, unmet(R))     :- profile_get(P, K, false).
check_true(P, K, _, unknown([K])) :- \+ profile_has(P, K).

check_false(P, K, _, met)          :- profile_get(P, K, false).
check_false(P, K, R, unmet(R))     :- profile_get(P, K, true).
check_false(P, K, _, unknown([K])) :- \+ profile_has(P, K).

check_eq(P, K, W, _, met)          :- profile_get(P, K, W).
check_eq(P, K, W, R, unmet(R))     :- profile_get(P, K, V), V \== W.
check_eq(P, K, _, _, unknown([K])) :- \+ profile_has(P, K).

check_holds(P, K, Pred, _, met) :-
    profile_get(P, K, V), G =.. [Pred, V], call(G).
check_holds(P, K, Pred, R, unmet(R)) :-
    profile_get(P, K, V), G =.. [Pred, V], \+ call(G).
check_holds(P, K, _, _, unknown([K])) :- \+ profile_has(P, K).

% --- Status combinators (carry the SET of missing keys; delta #2) ----
or_status(L, met)           :- member(met, L).
or_status(L, unknown(Keys)) :- \+ member(met, L), collect_unknown(L, Keys), Keys \== [].
or_status(L, unmet(all))    :- \+ member(met, L), collect_unknown(L, []).

and_status(L, unmet(some))   :- member_unmet(L).
and_status(L, met)           :- \+ member_unmet(L), collect_unknown(L, []).
and_status(L, unknown(Keys)) :- \+ member_unmet(L), collect_unknown(L, Keys), Keys \== [].

member_unmet([unmet(_)|_]).
member_unmet([H|T]) :- H \= unmet(_), member_unmet(T).

collect_unknown([], []).
collect_unknown([unknown(Ks)|T], All) :-
    collect_unknown(T, Rest), append(Ks, Rest, M), sort(M, All).
collect_unknown([H|T], All) :- H \= unknown(_), collect_unknown(T, All).

% --- Generic checklist engine (LABEL-NEUTRAL) ------------------------
% assess/5 is the reusable engine for checklist-shaped domains. Non-checklist
% shapes (classification, deontic) write their own engine -- see KIT-README.
eval_requirements([], _, []).
eval_requirements([R|Rs], P, [item(R, S, C)|Items]) :-
    requirement(R, P, S, C),
    eval_requirements(Rs, P, Items).

% decide_labeled/3 -- DETERMINISTIC single fold (no member/2, no cut, no ->).
% labels(Pos, Indet, Neg): the domain's terminal vocabulary (CSA R5).
decide_labeled(CL, labels(Pos, Indet, Neg), Decision) :-
    summarize(CL, HasUnmet, HasUnknown),
    classify_labeled(HasUnmet, HasUnknown, labels(Pos, Indet, Neg), Decision).

summarize([], no, no).
summarize([item(_, S, _)|T], HU, HK) :-
    summarize(T, HU0, HK0),
    mark_unmet(S, HU0, HU),
    mark_unknown(S, HK0, HK).
mark_unmet(unmet(_), _, yes).
mark_unmet(S, A, A) :- S \= unmet(_).
mark_unknown(unknown(_), _, yes).
mark_unknown(S, A, A) :- S \= unknown(_).

classify_labeled(yes, _,   labels(_, _, Neg),   Neg).
classify_labeled(no,  yes, labels(_, Indet, _), Indet).
classify_labeled(no,  no,  labels(Pos, _, _),   Pos).

assess(Subject, ReqIds, Profile, Labels, assessment(Subject, Decision, Checklist)) :-
    eval_requirements(ReqIds, Profile, Checklist),
    decide_labeled(Checklist, Labels, Decision).

has_unmet(CL)   :- member(item(_, unmet(_), _), CL).
has_unknown(CL) :- member(item(_, unknown(_), _), CL).
