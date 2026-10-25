% tools/iso_export/companion/clausal_dicts.pl
% Clausal's dict predicate forms for the Clausal Prolog
% (.clausal) ISO export, under the ENGINE's names:
% the exported code calls get/3 exactly as the source does. A dict is an
% attribute(Key, Value) list -- the profile representation the vendored
% formalize_lib and query_combinators already use, so a dict built here flows
% into them unchanged -- except the EMPTY dict, which is the curly atom '{}'.
% An empty attribute list would be [], and the engine keeps the empty dict and
% [] apart: is_dict_t([], false), dict_pairs([], _) fails, get([], K, V, D)
% fails (measured on engine main 54c0ff57). With '{}' every predicate here
% answers as the engine does on both, and a kit walk over an attribute list
% treats '{}' as it treated []: no keys.
% Semantics follow clausal/logic/builtins/dict_set.py,
% with one KNOWN GAP: the engine orders keys by Python repr, this file by
% standard order. The two agree for atom keys (every profile key in the
% corpus); they differ for mixed or numeric keys ([10, 9] vs [9, 10]).
% Cut-free, ->-free.
:- module(clausal_dicts, [dict_pairs/2, get/3, get/4, dict_keys/2, is_dict_t/2]).
:- use_module(library(dif)).
:- use_module(library(lists)).

% dict_pairs(?Dict, ?Pairs): build from K-V pairs (Dict unbound, pair order
% kept), or decompose to KEYSORTED pairs (the engine sorts by key).
dict_pairs(D, Pairs) :- var(D), dicts_pairs_attrs(Pairs, A0), dicts_last_wins(A0, A), dicts_as_dict(A, D).
dict_pairs(D, Pairs) :- nonvar(D), dicts_view(D, A), dicts_attrs_pairs(A, P0), keysort(P0, Pairs).

% dicts_view(?Dict, ?Attrs): a dict's attribute list. The empty dict is '{}', a
% non-empty one is its own non-empty attribute list, and [] is not a dict.
dicts_view('{}', []).
dicts_view([A|T], [A|T]).

dicts_as_dict([], '{}').
dicts_as_dict([A|T], [A|T]).

dicts_pairs_attrs([], []).
dicts_pairs_attrs([K-V|T], [attribute(K, V)|T2]) :- dicts_pairs_attrs(T, T2).

% A repeated key keeps its LAST value, as a Python dict built from the pairs does.
dicts_last_wins([], []).
dicts_last_wins([attribute(K, _)|T], Out) :- dicts_has_key(T, K), dicts_last_wins(T, Out).
dicts_last_wins([attribute(K, V)|T], [attribute(K, V)|Out]) :-
    \+ dicts_has_key(T, K), dicts_last_wins(T, Out).

dicts_has_key(Attrs, K) :- dicts_attrs_pairs(Attrs, P), dicts_keys_of(P, Ks), memberchk(K, Ks).

dicts_attrs_pairs([], []).
dicts_attrs_pairs([attribute(K, V)|T], [K-V|T2]) :- dicts_attrs_pairs(T, T2).

% get(+Dict, ?Key, ?Value): the value at Key; fails when absent.
get(D, K, V) :- dicts_view(D, A), dicts_get(A, K, V).

dicts_get([attribute(K, V)|_], K, V).
dicts_get([attribute(K0, _)|T], K, V) :- dif(K0, K), dicts_get(T, K, V).

% get(+Dict, +Key, ?Value, +Default): Dict[Key] if present, else Default.
% Fails on an unbound Key, as the engine's get/4 does.
get(D, K, V, _) :- nonvar(K), dicts_view(D, A), dicts_get(A, K, V).
get(D, K, Def, Def) :- nonvar(K), dicts_view(D, A), dicts_attrs_pairs(A, P), dicts_keys_of(P, Ks),
    \+ memberchk(K, Ks).

% dict_keys(+Dict, -Keys): the SORTED keys.
dict_keys(D, Ks) :- dicts_view(D, A), dicts_attrs_pairs(A, P), dicts_keys_of(P, K0), sort(K0, Ks).

dicts_keys_of([], []).
dicts_keys_of([K-_|T], [K|T2]) :- dicts_keys_of(T, T2).

% is_dict_t(+Term, ?T): reified dict test (engine round 3, the dif_t/3 convention).
% T = true when Term is a dict, T = false when it is not; an unbound Term is an
% instantiation error, and a T other than true or false fails. [] answers false,
% as on the engine; '{}' (the empty dict) answers true. REMAINING GAP: a
% non-empty list of attribute/2 terms IS a dict here, and is a plain list on the
% engine; no corpus value is such a list.
is_dict_t(D, _) :- var(D), throw(error(instantiation_error, is_dict_t/2)).
is_dict_t(D, true) :- nonvar(D), dicts_is_dict(D).
is_dict_t(D, false) :- nonvar(D), \+ dicts_is_dict(D).

dicts_is_dict('{}').
dicts_is_dict([A|T]) :- dicts_is_attrs([A|T]).

dicts_is_attrs([]).
dicts_is_attrs([A|T]) :- nonvar(A), A = attribute(_, _), nonvar(T), dicts_is_attrs(T).
