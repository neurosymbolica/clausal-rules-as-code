% tools/iso_export/companion/clausal_dicts.pl
% Clausal's dict predicate forms for the Clausal Prolog
% (.clausal) ISO export, under the ENGINE's names:
% the exported code calls get/3 exactly as the source does. A dict is an
% attribute(Key, Value) list -- the profile representation the vendored
% formalize_lib and query_combinators already use, so a dict built here flows
% into them unchanged. Semantics follow clausal/logic/builtins/dict_set.py,
% with one KNOWN GAP: the engine orders keys by Python repr, this file by
% standard order. The two agree for atom keys (every profile key in the
% corpus); they differ for mixed or numeric keys ([10, 9] vs [9, 10]).
% Cut-free, ->-free.
:- module(clausal_dicts, [dict_pairs/2, get/3, get/4, dict_keys/2]).
:- use_module(library(dif)).
:- use_module(library(lists)).

% dict_pairs(?Dict, ?Pairs): build from K-V pairs (Dict unbound, pair order
% kept), or decompose to KEYSORTED pairs (the engine sorts by key).
dict_pairs(D, Pairs) :- var(D), dicts_pairs_attrs(Pairs, A0), dicts_last_wins(A0, D).
dict_pairs(D, Pairs) :- nonvar(D), dicts_attrs_pairs(D, P0), keysort(P0, Pairs).

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
get(D, K, V) :- dicts_get(D, K, V).

dicts_get([attribute(K, V)|_], K, V).
dicts_get([attribute(K0, _)|T], K, V) :- dif(K0, K), dicts_get(T, K, V).

% get(+Dict, +Key, ?Value, +Default): Dict[Key] if present, else Default.
% Fails on an unbound Key, as the engine's get/4 does.
get(D, K, V, _) :- nonvar(K), dicts_get(D, K, V).
get(D, K, Def, Def) :- nonvar(K), dicts_attrs_pairs(D, P), dicts_keys_of(P, Ks), \+ memberchk(K, Ks).

% dict_keys(+Dict, -Keys): the SORTED keys.
dict_keys(D, Ks) :- dicts_attrs_pairs(D, P), dicts_keys_of(P, K0), sort(K0, Ks).

dicts_keys_of([], []).
dicts_keys_of([K-_|T], [K|T2]) :- dicts_keys_of(T, T2).
