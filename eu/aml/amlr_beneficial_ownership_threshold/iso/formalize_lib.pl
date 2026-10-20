:- module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2, profile_set/3, profile_keys/2, check_gte/5, check_lte/5, status_gte/4, status_gt/4, status_lte/4, status_lt/4, check_ratio_gte/6, check_ratio_lte/6, ratio_bps/4, required_numerator_gte/3, max_denom_gte/3, max_numerator_lte/3, min_denom_lte/3, check_tri/4, check_tri_neg/4, sum_list/2, first_applicable/2, not_member/2, member_matching/2, memberd/2, term_mismatch/2, usable_positive/3, missing_keys/3, all_present/2, check_eq/5, check_true/4, check_false/4, check_holds/5, or_status/2, and_status/2, collect_unknown/2, member_unmet/1, mark_unmet/3, mark_unknown/3, assess/6, eval_requirements/4, decide_labeled/3, summarize/3, classify_labeled/4, has_unmet/1, has_unknown/1, not_defeated/3, int_min/3, int_max/3, int_abs/2]).

:- use_module(library(lists), [append/3]).
:- use_module(library(lists), [member/2]).
:- use_module(library(dif), [dif/2]).
:- use_module('clausal_profiles', [tri_get/3]).
:- use_module('clausal_profiles', [is_dict/1]).
:- use_module('clausal_profiles', [dict_keys/2]).
:- use_module('clausal_hof', [call_goal/2]).
:- use_module('clausal_hof', [call_goal/3]).
:- use_module('clausal_hof', [call_goal/5]).

:- meta_predicate(check_holds(?, ?, 1, ?, ?)).

:- meta_predicate(eval_requirements(?, ?, 4, ?)).

:- meta_predicate(assess(?, ?, ?, 4, ?, ?)).

:- meta_predicate(not_defeated(?, ?, 2)).

:- use_module(library(clpz), [(#=)/2]).

:- set_prolog_flag(double_quotes, chars).

profile_get(PROFILE, KEY, VALUE) :-
    is_dict(PROFILE),
    profile_get(PROFILE, KEY, VALUE).

profile_get([HEAD|_], KEY, VALUE) :-
    HEAD = attribute(KEY, VALUE).

profile_get([HEAD|TAIL], KEY, VALUE) :-
    HEAD = attribute(HEAD_KEY, _),
    dif(HEAD_KEY, KEY),
    profile_get(TAIL, KEY, VALUE).

profile_has(PROFILE, KEY) :-
    profile_get(PROFILE, KEY, _).

profile_lacks(PROFILE, KEY) :-
    profile_keys(PROFILE, KEYS),
    key_absent_from(KEY, KEYS).

profile_set([], NEW_ENTRY, [NEW_ENTRY]).

profile_set([ENTRY|REST], NEW_ENTRY, [NEW_ENTRY|REST]) :-
    functor(ENTRY, FUNCTOR_NAME, _),
    functor(NEW_ENTRY, FUNCTOR_NAME, _).

profile_set([ENTRY|REST], NEW_ENTRY, [ENTRY|NEW_REST]) :-
    functor(ENTRY, FUNCTOR_OLD, _),
    functor(NEW_ENTRY, FUNCTOR_NEW, _),
    dif(FUNCTOR_OLD, FUNCTOR_NEW),
    profile_set(REST, NEW_ENTRY, NEW_REST).

profile_keys(PROFILE, KEYS) :-
    is_dict(PROFILE),
    dict_keys(PROFILE, KEYS).

profile_keys([], KEYS) :-
    profile_keys_list([], KEYS).

profile_keys([HEAD|TAIL], KEYS) :-
    profile_keys_list([HEAD|TAIL], KEYS).

profile_keys_list([], []).

profile_keys_list([HEAD|TAIL], [KEY|REST]) :-
    HEAD = attribute(KEY, _),
    profile_keys_list(TAIL, REST).

check_eff(PROFILE, KEY, value(VALUE)) :-
    profile_get(PROFILE, KEY, VALUE),
    number(VALUE).

check_eff(PROFILE, KEY, absent([KEY])) :-
    profile_lacks(PROFILE, KEY).

check_gte(PROFILE, KEY, THRESHOLD, REASON, STATUS) :-
    check_eff(PROFILE, KEY, EFF),
    status_gte(EFF, THRESHOLD, REASON, STATUS).

check_lte(PROFILE, KEY, THRESHOLD, REASON, STATUS) :-
    check_eff(PROFILE, KEY, EFF),
    status_lte(EFF, THRESHOLD, REASON, STATUS).

status_gte(value(N), T, _, STATUS) :-
    N >= T,
    STATUS = met.

status_gte(value(N), T, REASON, STATUS) :-
    N < T,
    STATUS = unmet(REASON).

status_gte(absent(KEYS), _, _, STATUS) :-
    STATUS = unknown(KEYS).

status_gt(value(N), T, _, STATUS) :-
    N > T,
    STATUS = met.

status_gt(value(N), T, REASON, STATUS) :-
    N =< T,
    STATUS = unmet(REASON).

status_gt(absent(KEYS), _, _, STATUS) :-
    STATUS = unknown(KEYS).

status_lte(value(N), T, _, STATUS) :-
    N =< T,
    STATUS = met.

status_lte(value(N), T, REASON, STATUS) :-
    N > T,
    STATUS = unmet(REASON).

status_lte(absent(KEYS), _, _, STATUS) :-
    STATUS = unknown(KEYS).

status_lt(value(N), T, _, STATUS) :-
    N < T,
    STATUS = met.

status_lt(value(N), T, REASON, STATUS) :-
    N >= T,
    STATUS = unmet(REASON).

status_lt(absent(KEYS), _, _, STATUS) :-
    STATUS = unknown(KEYS).

check_true(PROFILE, KEY, _, STATUS) :-
    profile_get(PROFILE, KEY, true),
    STATUS = met.

check_true(PROFILE, KEY, REASON, STATUS) :-
    profile_get(PROFILE, KEY, false),
    STATUS = unmet(REASON).

check_true(PROFILE, KEY, _, STATUS) :-
    profile_lacks(PROFILE, KEY),
    STATUS = unknown([KEY]).

check_false(PROFILE, KEY, _, STATUS) :-
    profile_get(PROFILE, KEY, false),
    STATUS = met.

check_false(PROFILE, KEY, REASON, STATUS) :-
    profile_get(PROFILE, KEY, true),
    STATUS = unmet(REASON).

check_false(PROFILE, KEY, _, STATUS) :-
    profile_lacks(PROFILE, KEY),
    STATUS = unknown([KEY]).

check_eq(PROFILE, KEY, WANT, _, STATUS) :-
    profile_get(PROFILE, KEY, WANT),
    STATUS = met.

check_eq(PROFILE, KEY, WANT, REASON, STATUS) :-
    profile_get(PROFILE, KEY, VALUE),
    dif(VALUE, WANT),
    STATUS = unmet(REASON).

check_eq(PROFILE, KEY, _, _, STATUS) :-
    profile_lacks(PROFILE, KEY),
    STATUS = unknown([KEY]).

check_holds(PROFILE, KEY, PRED, _, STATUS) :-
    profile_get(PROFILE, KEY, VALUE),
    call_goal(PRED, VALUE),
    STATUS = met.

check_holds(PROFILE, KEY, PRED, REASON, STATUS) :-
    profile_get(PROFILE, KEY, VALUE),
    \+ call_goal(PRED, VALUE),
    STATUS = unmet(REASON).

check_holds(PROFILE, KEY, _, _, STATUS) :-
    profile_lacks(PROFILE, KEY),
    STATUS = unknown([KEY]).

bps_full_scale(10000).

usable_positive(PROFILE, KEY, VALUE) :-
    profile_get(PROFILE, KEY, VALUE),
    VALUE > 0.

usable_nonpositive(PROFILE, KEY) :-
    is_dict(PROFILE),
    profile_lacks(PROFILE, KEY).

usable_nonpositive(PROFILE, KEY) :-
    is_dict(PROFILE),
    profile_get(PROFILE, KEY, VALUE),
    VALUE =< 0.

usable_nonpositive([], _).

usable_nonpositive([_|_], _).

check_ratio_gte(PROFILE, NUM_KEY, DENOM_KEY, MIN_BPS, _, STATUS) :-
    profile_get(PROFILE, NUM_KEY, NUMERATOR),
    usable_positive(PROFILE, DENOM_KEY, DENOMINATOR),
    bps_full_scale(SCALE),
    #=(SCALED_NUMERATOR, NUMERATOR * SCALE),
    #=(REQUIRED_SCALED, MIN_BPS * DENOMINATOR),
    SCALED_NUMERATOR >= REQUIRED_SCALED,
    STATUS = met.

check_ratio_gte(PROFILE, NUM_KEY, DENOM_KEY, MIN_BPS, REASON, STATUS) :-
    profile_get(PROFILE, NUM_KEY, NUMERATOR),
    usable_positive(PROFILE, DENOM_KEY, DENOMINATOR),
    bps_full_scale(SCALE),
    #=(SCALED_NUMERATOR, NUMERATOR * SCALE),
    #=(REQUIRED_SCALED, MIN_BPS * DENOMINATOR),
    SCALED_NUMERATOR < REQUIRED_SCALED,
    STATUS = unmet(REASON).

check_ratio_gte(PROFILE, NUM_KEY, _, _, _, STATUS) :-
    profile_lacks(PROFILE, NUM_KEY),
    STATUS = unknown([NUM_KEY]).

check_ratio_gte(PROFILE, NUM_KEY, DENOM_KEY, _, _, STATUS) :-
    profile_has(PROFILE, NUM_KEY),
    usable_nonpositive(PROFILE, DENOM_KEY),
    STATUS = unknown([DENOM_KEY]).

check_ratio_lte(PROFILE, NUM_KEY, DENOM_KEY, MAX_BPS, _, STATUS) :-
    profile_get(PROFILE, NUM_KEY, NUMERATOR),
    usable_positive(PROFILE, DENOM_KEY, DENOMINATOR),
    bps_full_scale(SCALE),
    #=(SCALED_NUMERATOR, NUMERATOR * SCALE),
    #=(LIMIT_SCALED, MAX_BPS * DENOMINATOR),
    SCALED_NUMERATOR =< LIMIT_SCALED,
    STATUS = met.

check_ratio_lte(PROFILE, NUM_KEY, DENOM_KEY, MAX_BPS, REASON, STATUS) :-
    profile_get(PROFILE, NUM_KEY, NUMERATOR),
    usable_positive(PROFILE, DENOM_KEY, DENOMINATOR),
    bps_full_scale(SCALE),
    #=(SCALED_NUMERATOR, NUMERATOR * SCALE),
    #=(LIMIT_SCALED, MAX_BPS * DENOMINATOR),
    SCALED_NUMERATOR > LIMIT_SCALED,
    STATUS = unmet(REASON).

check_ratio_lte(PROFILE, NUM_KEY, _, _, _, STATUS) :-
    profile_lacks(PROFILE, NUM_KEY),
    STATUS = unknown([NUM_KEY]).

check_ratio_lte(PROFILE, NUM_KEY, DENOM_KEY, _, _, STATUS) :-
    profile_has(PROFILE, NUM_KEY),
    usable_nonpositive(PROFILE, DENOM_KEY),
    STATUS = unknown([DENOM_KEY]).

ratio_bps(PROFILE, NUM_KEY, DENOM_KEY, RATIO_BPS) :-
    profile_get(PROFILE, NUM_KEY, NUMERATOR),
    usable_positive(PROFILE, DENOM_KEY, DENOMINATOR),
    bps_full_scale(SCALE),
    #=(RATIO_BPS, div(NUMERATOR * SCALE, DENOMINATOR)).

required_numerator_gte(DENOM, MIN_BPS, REQ_NUM) :-
    bps_full_scale(SCALE),
    #=(REQ_NUM, div(MIN_BPS * DENOM + SCALE - 1, SCALE)).

max_denom_gte(NUM, MIN_BPS, MAX_DENOM) :-
    MIN_BPS > 0,
    bps_full_scale(SCALE),
    #=(MAX_DENOM, div(NUM * SCALE, MIN_BPS)).

max_numerator_lte(DENOM, MAX_BPS, MAX_NUM) :-
    bps_full_scale(SCALE),
    #=(MAX_NUM, div(MAX_BPS * DENOM, SCALE)).

min_denom_lte(NUM, MAX_BPS, MIN_DENOM) :-
    MAX_BPS > 0,
    bps_full_scale(SCALE),
    #=(MIN_DENOM, div(NUM * SCALE + MAX_BPS - 1, MAX_BPS)).

check_tri(PROFILE, KEY, _, STATUS) :-
    tri_get(PROFILE, KEY, VALUE),
    VALUE = true,
    STATUS = met.

check_tri(PROFILE, KEY, REASON, STATUS) :-
    tri_get(PROFILE, KEY, VALUE),
    VALUE = false,
    STATUS = unmet(REASON).

check_tri(PROFILE, KEY, _, STATUS) :-
    tri_get(PROFILE, KEY, VALUE),
    dif(VALUE, true),
    dif(VALUE, false),
    STATUS = unknown([KEY]).

check_tri_neg(PROFILE, KEY, _, STATUS) :-
    tri_get(PROFILE, KEY, VALUE),
    VALUE = false,
    STATUS = met.

check_tri_neg(PROFILE, KEY, REASON, STATUS) :-
    tri_get(PROFILE, KEY, VALUE),
    VALUE = true,
    STATUS = unmet(REASON).

check_tri_neg(PROFILE, KEY, _, STATUS) :-
    tri_get(PROFILE, KEY, VALUE),
    dif(VALUE, true),
    dif(VALUE, false),
    STATUS = unknown([KEY]).

sum_list([], 0).

sum_list([HEAD|TAIL], SUM) :-
    sum_list(TAIL, SUBTOTAL),
    #=(SUM, HEAD + SUBTOTAL).

first_applicable([item(RESULT, applicable, _)|_], RESULT).

first_applicable([item(_, inapplicable, _)|REST], RESULT) :-
    first_applicable(REST, RESULT).

not_member(_, []).

not_member(X, [HEAD|TAIL]) :-
    term_variables(X, []),
    dif(X, HEAD),
    not_member(X, TAIL).

not_member(X, [HEAD|TAIL]) :-
    term_variables(X, [_|_]),
    term_mismatch(X, HEAD),
    not_member(X, TAIL).

term_mismatch(P, E) :-
    nonvar(P),
    functor(P, F, N),
    functor(E, G, M),
    dif([F, N], [G, M]).

term_mismatch(P, E) :-
    nonvar(P),
    functor(P, F, N),
    functor(E, F, N),
    N > 0,
    P =.. [_|P_ARGS],
    E =.. [_|E_ARGS],
    args_mismatch(P_ARGS, E_ARGS).

args_mismatch([P|_], [E|_]) :-
    term_mismatch(P, E).

args_mismatch([P|P_REST], [E|E_REST]) :-
    term_matches(P, E),
    args_mismatch(P_REST, E_REST).

term_matches(P, _) :-
    var(P).

term_matches(P, E) :-
    nonvar(P),
    functor(P, F, N),
    functor(E, F, N),
    P =.. [_|P_ARGS],
    E =.. [_|E_ARGS],
    args_match(P_ARGS, E_ARGS).

member_matching(PATTERN, [E|_]) :-
    term_matches(PATTERN, E).

member_matching(PATTERN, [E|TAIL]) :-
    term_mismatch(PATTERN, E),
    member_matching(PATTERN, TAIL).

args_match([], []).

args_match([P|P_REST], [E|E_REST]) :-
    term_matches(P, E),
    args_match(P_REST, E_REST).

missing_keys(PROFILE, REQUIRED_KEYS, MISSING) :-
    profile_keys(PROFILE, PRESENT),
    missing_keys_from(REQUIRED_KEYS, PRESENT, MISSING).

missing_keys_from([], _, []).

missing_keys_from([K|KS], PRESENT, [K|REST]) :-
    key_absent_from(K, PRESENT),
    missing_keys_from(KS, PRESENT, REST).

missing_keys_from([K|KS], PRESENT, REST) :-
    memberd(K, PRESENT),
    missing_keys_from(KS, PRESENT, REST).

key_absent_from(_, []).

key_absent_from(K, [HEAD|TAIL]) :-
    dif(K, HEAD),
    key_absent_from(K, TAIL).

memberd(X, [HEAD|_]) :-
    X = HEAD.

memberd(X, [HEAD|TAIL]) :-
    dif(X, HEAD),
    memberd(X, TAIL).

all_present(PROFILE, KEYS) :-
    missing_keys(PROFILE, KEYS, []).

or_status(LIST, STATUS) :-
    memberd(met, LIST),
    STATUS = met.

or_status(LIST, STATUS) :-
    not_member(met, LIST),
    collect_unknown(LIST, KEYS),
    dif(KEYS, []),
    STATUS = unknown(KEYS).

or_status(LIST, STATUS) :-
    not_member(met, LIST),
    collect_unknown(LIST, []),
    STATUS = unmet(no_disjunct_met).

and_status(LIST, STATUS) :-
    member_unmet(LIST),
    STATUS = unmet(some_conjunct_unmet).

and_status(LIST, STATUS) :-
    not_member(unmet(_), LIST),
    collect_unknown(LIST, []),
    STATUS = met.

and_status(LIST, STATUS) :-
    not_member(unmet(_), LIST),
    collect_unknown(LIST, KEYS),
    dif(KEYS, []),
    STATUS = unknown(KEYS).

member_unmet([HEAD|_]) :-
    HEAD = unmet(_).

member_unmet([HEAD|TAIL]) :-
    term_mismatch(unmet(_), HEAD),
    member_unmet(TAIL).

collect_unknown([], []).

collect_unknown([HEAD|TAIL], ALL) :-
    HEAD = unknown(KS),
    collect_unknown(TAIL, REST),
    append(KS, REST, MERGED),
    sort(MERGED, ALL).

collect_unknown([HEAD|TAIL], ALL) :-
    term_mismatch(unknown(_), HEAD),
    collect_unknown(TAIL, ALL).

eval_requirements([], _, _, []).

eval_requirements([REQ|REQS], PROFILE, REQ_PRED, [ITEM|ITEMS]) :-
    call_goal(REQ_PRED, REQ, PROFILE, STATUS, CITATION),
    ITEM = item(REQ, STATUS, CITATION),
    eval_requirements(REQS, PROFILE, REQ_PRED, ITEMS).

decide_labeled(CHECKLIST, labels(POS, INDET, NEG), DECISION) :-
    summarize(CHECKLIST, HAS_UNMET, HAS_UNKNOWN),
    classify_labeled(HAS_UNMET, HAS_UNKNOWN, labels(POS, INDET, NEG), DECISION).

summarize([], false, false).

summarize([HEAD|TAIL], HAS_UNMET, HAS_UNKNOWN) :-
    HEAD = item(_, STATUS, _),
    summarize(TAIL, HAS_UNMET0, HAS_UNKNOWN0),
    mark_unmet(STATUS, HAS_UNMET0, HAS_UNMET),
    mark_unknown(STATUS, HAS_UNKNOWN0, HAS_UNKNOWN).

mark_unmet(unmet(_), _, true).

mark_unmet(STATUS, ACC, ACC) :-
    term_mismatch(unmet(_), STATUS).

mark_unknown(unknown(_), _, true).

mark_unknown(STATUS, ACC, ACC) :-
    term_mismatch(unknown(_), STATUS).

classify_labeled(true, _, labels(_, _, NEG), NEG).

classify_labeled(false, true, labels(_, INDET, _), INDET).

classify_labeled(false, false, labels(POS, _, _), POS).

assess(SUBJECT, REQ_IDS, PROFILE, REQ_PRED, LABELS, assessment(SUBJECT, DECISION, CHECKLIST)) :-
    eval_requirements(REQ_IDS, PROFILE, REQ_PRED, CHECKLIST),
    decide_labeled(CHECKLIST, LABELS, DECISION).

has_unmet(CHECKLIST) :-
    member(item(_, unmet(_), _), CHECKLIST).

has_unknown(CHECKLIST) :-
    member(item(_, unknown(_), _), CHECKLIST).

not_defeated(RULE_ID, PROFILE, DEFEAT_PRED) :-
    \+ once(call_goal(DEFEAT_PRED, RULE_ID, PROFILE)).

int_min(A, B, A) :-
    A =< B.

int_min(A, B, B) :-
    A > B.

int_max(A, B, A) :-
    A >= B.

int_max(A, B, B) :-
    A < B.

int_abs(A, A) :-
    A >= 0.

int_abs(A, ABS) :-
    A < 0,
    #=(ABS, 0 - A).
