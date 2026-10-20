% clausal: no-collect
% (a Prolog module/fixture, not a test file: clausal.testing collects .pl since engine 076d7b41)
% =====================================================================
% validate_props.pl -- reusable property PATTERNS (Clausify kit).
% Each property is a viol-collector (succeeds with a violation term when
% broken). A clean run is only meaningful with negative controls
% (harness.pl) and the vacuous_property/1 flag (Traffic 1.3). The check
% bodies (findall collectors) are pure/->-free; report_prop / prop_no_trivial
% use -> for result dispatch -- validate_props plays the same TOOLING role
% as harness.pl, so -> is permitted here.
%
% SHAPE-NEUTRALITY (HIPAA domain-5 delta S1/N3). Only TWO of these are
% shape-neutral; the rest assume the CHECKLIST result term:
%   * SHAPE-NEUTRAL (any result shape): run_prop/3, prop_totality/3,
%     prop_determinism/3. A non-checklist shape (deontic verdict, numeric
%     result, classification term, ...) reuses these and writes its OWN
%     violation collectors, running them via run_prop/3.
%   * CHECKLIST-SHAPED (only for assessment(_,_,[item(Id,Status,Cit)])
%     domains): prop_provenance/2, prop_integrity/2, prop_no_trivial/3.
%     They hard-reference requirement/4 and item/3. Do NOT call them on a
%     non-checklist shape -- they error or pass vacuously. Re-derive their
%     intent against your own result term instead (see KIT-README).
%
% VACUOUS PROPERTIES. A property the engine makes architecture-guaranteed
% (e.g. determinism under a single-solution engine) carries no evidence;
% flag it with declare_vacuous/1 so it is reported but NOT counted. Call it
% from a directive: `:- initialization(declare_vacuous(determinism)).`
% Never write a bare `vacuous_property(Name).` fact in the domain file --
% that redefines the kit's dynamic predicate (a zero-warnings violation, S2).
% =====================================================================
:- dynamic(vacuous_property/1).

% declare_vacuous(+Name): the supported way for a domain to flag a vacuous
% property (S2). Use via `:- initialization(declare_vacuous(Name)).`
declare_vacuous(Name) :- assertz(vacuous_property(Name)).

% ---------------------------------------------------------------------
% SHAPE-NEUTRAL -- reusable on ANY result shape.
% ---------------------------------------------------------------------

% run_prop(+Label, +Name, +Collector): the generic property runner. Collector
% is an arity-1 predicate yielding one violation term per solution (no
% solutions => the property holds). This is how a non-checklist shape plugs
% its own collectors into the same PASS/FAIL/vacuous accounting (S1/N3).
run_prop(Label, Name, Collector) :-
    findall(V, call(Collector, V), Raw),
    report_prop(Label, Name, Raw).

% Totality: every subject yields >=1 assessment.
prop_totality(SubjGen, AssessGen, totality) :-
    findall(Sub, ( call(SubjGen, Sub), \+ has_assessment(AssessGen, Sub) ), Viols),
    report_prop('totality: every subject assessable', totality, Viols).

% Determinism: exactly one assessment per subject.
prop_determinism(SubjGen, AssessGen, determinism) :-
    findall(Sub-N, ( call(SubjGen, Sub),
                     findall(t, call(AssessGen, Sub, _), L), length(L, N), N =\= 1 ), Viols),
    report_prop('determinism: exactly one assessment per subject', determinism, Viols).

% Projection (shape-neutral). A query family's projection decide_<family>(+Input,
% -Comparable) must be TOTAL (every input yields a comparable -- a partial projection
% that fails instead of yielding unknown([Keys]) is a violation) and DETERMINISTIC
% (exactly one comparable). Reuses the totality/determinism collectors with
% family-labelled, separately-counted property names.
:- dynamic(projection/2).
declare_projection(Family, ProjPred) :- assertz(projection(Family, ProjPred)).

% Label is a COMPOUND term (projection_total(Family)) rendered by report_prop's ~w --
% NOT format(atom(X),...), which is an SWI extension gprolog's format/3 does not support.
prop_projection(Family, InputGen, ProjPred) :-
    findall(I, ( call(InputGen, I), \+ has_assessment(ProjPred, I) ), TViols),
    report_prop(projection_total(Family), projection_total, TViols),
    findall(I-N, ( call(InputGen, I),
                   findall(t, call(ProjPred, I, _), L), length(L, N), N =\= 1 ), DViols),
    report_prop(projection_det(Family), projection_det, DViols).

% Result-term conformance (shape-neutral). Every Result a family's projection produces
% must conform to result_vocab(Family, Template): same functor/arity, and each arg
% conforms to its spec -- enum(L) => member; term(Schema) => unifies (shape match).
% result_vocab/2 facts are generated from result_shape.yaml by vocab_prolog.py, which
% emits the `:- dynamic(result_vocab/2).` declaration in that generated file (the sole
% definer -- declaring it here too would trigger a "redefining procedure" warning).
prop_result_conformance(Family, InputGen, ProjPred) :-
    findall(viol(I, Why),
            ( call(InputGen, I),
              ( catch(call(ProjPred, I, R), _, fail) -> true ; R = '<failed>' ),
              nonconformance(Family, R, Why) ),
            Viols),
    report_prop(result_conformance(Family), result_conformance, Viols).

nonconformance(Family, Result, Why) :-
    result_vocab(Family, Template), !,
    Result =.. [F|Args], Template =.. [TF|Specs],
    ( F \== TF -> Why = wrong_functor(F)
    ; length(Args, NA), length(Specs, NS), NA =\= NS -> Why = wrong_arity(NA)
    ; bad_arg(Args, Specs, Why) ).
nonconformance(Family, _, no_vocab(Family)).

bad_arg([A|_], [S|_], arg(A, violates, S)) :- \+ vocab_arg_ok(A, S).
bad_arg([_|As], [_|Ss], Why) :- bad_arg(As, Ss, Why).

vocab_arg_ok(_, skip) :- !.
vocab_arg_ok(A, enum(L)) :- !, member(A, L).
vocab_arg_ok(A, set_of(L)) :- !, is_list(A), \+ ( member(E, A), \+ member(E, L) ).
vocab_arg_ok(A, term(Schema)) :- \+ \+ (A = Schema).

% ---------------------------------------------------------------------
% CHECKLIST-SHAPED -- ONLY for assessment(_,_,[item(Id,Status,Cit)]) domains.
% Non-checklist shapes: re-derive these via run_prop/3 + your own collectors.
% ---------------------------------------------------------------------

% Integrity: every referenced id has a defining requirement clause.
prop_integrity(SetGen, integrity) :-
    findall(Id, ( call(SetGen, Id), \+ catch(requirement(Id, [], _, _), _, fail) ), Viols),
    report_prop('integrity: every referenced requirement id defined', integrity, Viols).

% Provenance: every checklist item carries a non-empty citation.
prop_provenance(AssessGen, provenance) :-
    findall(Id, ( call(AssessGen, _, assessment(_, _, CL)),
                  member(item(Id, _, C), CL), bad_citation(C) ), Viols),
    report_prop('provenance: every checklist item cited', provenance, Viols).

% No trivial positive: the empty profile must not be the positive decision.
prop_no_trivial(AssessGen, PosLabel, no_trivial) :-
    ( call(AssessGen, _, assessment(_, PosLabel, _))   % expects empty-profile generator
    -> report_prop('no trivial positive', no_trivial, [empty_is_positive])
    ;  report_prop('no trivial positive', no_trivial, []) ).

% ---------------------------------------------------------------------
% Shared helpers + reporting.
% ---------------------------------------------------------------------
has_assessment(AssessGen, Sub) :- catch(call(AssessGen, Sub, _), _, fail).
bad_citation(C) :- var(C).
bad_citation('').
bad_citation(none).

report_prop(Label, Name, Viols) :-
    sort(Viols, Vs),
    ( Vs == []
    -> ( vacuous_property(Name)
       -> format("  ----  ~w  [VACUOUS by architecture -- not counted]~n", [Label])
       ;  note_assertion, format("  PASS  ~w~n", [Label]) )
    ;  note_assertion, bump(h_fail), format("  FAIL  ~w -- ~q~n", [Label, Vs]) ).

run_props([]).
run_props([P|Ps]) :- ( catch(call(P), E, (format("  FAIL  prop error ~q~n",[E]), bump(h_fail))) -> true ; true ),
                     run_props(Ps).
