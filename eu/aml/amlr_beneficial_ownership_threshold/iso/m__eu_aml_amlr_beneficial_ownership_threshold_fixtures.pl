:- module(m__eu_aml_amlr_beneficial_ownership_threshold_fixtures, [amlr_bo_subject/1, amlr_bo_profile_for/2, amlr_bo_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [assess_amlr_bo/3]).

amlr_bo_subject("person_direct_30pct").
amlr_bo_subject("person_chain_50x49pct_below").
amlr_bo_subject("person_missing_chains").

amlr_bo_profile_for("person_direct_30pct", Profile) :-
    dict_pairs(Profile, [ownership_chains - [[3000]]]).
amlr_bo_profile_for("person_chain_50x49pct_below", Profile) :-
    dict_pairs(Profile, [ownership_chains - [[5000, 4999]]]).
amlr_bo_profile_for("person_missing_chains", Profile) :-
    dict_pairs(Profile, []).

amlr_bo_assess(Subject, Result) :-
    amlr_bo_profile_for(Subject, Profile),
    assess_amlr_bo(Subject, Profile, Result).
