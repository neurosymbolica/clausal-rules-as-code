% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [decide_dora_proportionality_and_simplified_framework/2, simplified_framework_qualification/3, simplified_framework_duties_required/3, simplified_framework_duties_complete/3, simplified_framework_duties_outstanding/3]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_fixtures, [dora_proportionality_and_simplified_framework_subject/1, dora_proportionality_and_simplified_framework_profile_for/2]).

query_name(simplified_framework_qualification).
query_name(simplified_framework_duties_required).
query_name(simplified_framework_duties_complete).
query_name(simplified_framework_duties_outstanding).

final_result(article_16_1_entity).
final_result(not_article_16_1_entity).
final_result(out_of_scope).
final_result(not_a_financial_entity).
final_result(complete).
final_result(incomplete).
final_result(none_outstanding).
final_result(required(_Duties)).
final_result(outstanding(_Duties)).

result_citations_shape(indeterminate([_MissingKey]), []).
result_citations_shape(needs_legal_review(open_textured(_Key, cite(_Citation)), [inputs_relied_on(_Pairs)|_]), []).
result_citations_shape(input_problems([_Problem|_Problems]), []).
result_citations_shape(Result, [Citation|Citations]) :-
    final_result(Result),
    maplist(vocabulary_citation, [Citation|Citations]).

vocabulary_citation(cite(Key)) :-
    citation_key(Key).

citation_key(eu_reg_2022_2554_art_2_1).
citation_key(eu_reg_2022_2554_art_2_1_u).
citation_key(eu_reg_2022_2554_art_2_2).
citation_key(eu_reg_2022_2554_art_2_3_c).
citation_key(eu_reg_2022_2554_art_2_4).
citation_key(eu_reg_2022_2554_art_3_32).
citation_key(eu_reg_2022_2554_art_3_34).
citation_key(eu_reg_2022_2554_art_3_36).
citation_key(eu_reg_2022_2554_art_3_39).
citation_key(eu_reg_2022_2554_art_3_53).
citation_key(eu_reg_2022_2554_art_16_1).
citation_key(eu_reg_2022_2554_art_4_1).
citation_key(eu_reg_2022_2554_art_16_1_a).
citation_key(eu_reg_2022_2554_art_16_1_b).
citation_key(eu_reg_2022_2554_art_16_1_c).
citation_key(eu_reg_2022_2554_art_16_1_d).
citation_key(eu_reg_2022_2554_art_16_1_e).
citation_key(eu_reg_2022_2554_art_16_1_f).
citation_key(eu_reg_2022_2554_art_16_1_g).
citation_key(eu_reg_2022_2554_art_16_1_h).
citation_key(eu_reg_2022_2554_art_16_2).

entity_types([credit_institution, institution_exempted_pursuant_to_directive_2013_36, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty, trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider, insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary, institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types]).

settled_type_profile(EntityType, [attribute(dora_entity_type, EntityType), attribute(investment_firm_is_small_and_non_interconnected, true), attribute(iorp_pension_scheme_members_total, 50), attribute(exempted_from_dora_scope_by_member_state, false)]).

subject_classifies(Subject) :-
    dora_proportionality_and_simplified_framework_subject(Subject),
    dora_proportionality_and_simplified_framework_profile_for(Subject, Profile),
    decide_dora_proportionality_and_simplified_framework(Profile, _Verdict).

exactly_one_verdict(Subject) :-
    dora_proportionality_and_simplified_framework_profile_for(Subject, Profile),
    findall(Verdict, decide_dora_proportionality_and_simplified_framework(Profile, Verdict), [_]).

query_has_one_answer(Profile, Query) :-
    findall(Result - Citations, call(Query, Profile, Result, Citations), [_]).

every_query_has_one_answer(Subject) :-
    dora_proportionality_and_simplified_framework_profile_for(Subject, Profile),
    findall(Query, query_name(Query), Queries),
    maplist(query_has_one_answer(Profile), Queries).

answer_well_shaped(Profile, Query) :-
    call(Query, Profile, Result, Citations),
    result_citations_shape(Result, Citations),
    sort(Citations, CitationSet),
    length(Citations, CitationCount),
    length(CitationSet, CitationCount).

every_answer_well_shaped(Subject) :-
    dora_proportionality_and_simplified_framework_profile_for(Subject, Profile),
    findall(Query, query_name(Query), Queries),
    maplist(answer_well_shaped(Profile), Queries).

type_settles_once(EntityType) :-
    settled_type_profile(EntityType, Profile),
    findall(Result, simplified_framework_qualification(Profile, Result, _), [Result]),
    final_result(Result).

qualifying_type(EntityType) :-
    entity_types(EntityTypes),
    member(EntityType, EntityTypes),
    settled_type_profile(EntityType, Profile),
    simplified_framework_qualification(Profile, article_16_1_entity, _).

members_profile(Members, [attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, Members)]).

members_band(Members, out_of_scope) :-
    Members =< 15.
members_band(Members, article_16_1_entity) :-
    Members >= 16,
    Members =< 99.
members_band(Members, not_article_16_1_entity) :-
    Members >= 100.

members_answer_matches_band(Members) :-
    members_profile(Members, Profile),
    findall(Result, simplified_framework_qualification(Profile, Result, _), [Result]),
    members_band(Members, Result).

completion_consistent(complete, none_outstanding).
completion_consistent(incomplete, outstanding([_Duty|_Duties])).
completion_consistent(Result, Result) :-
    dif(Result, complete),
    dif(Result, incomplete).

subject_consistent(Subject) :-
    dora_proportionality_and_simplified_framework_profile_for(Subject, Profile),
    simplified_framework_duties_complete(Profile, CompleteResult, _),
    simplified_framework_duties_outstanding(Profile, OutstandingResult, _),
    completion_consistent(CompleteResult, OutstandingResult).

all_subjects(Subjects) :-
    findall(Subject, dora_proportionality_and_simplified_framework_subject(Subject), Subjects),
    Subjects = [_|_].

test(totality_every_subject_classifies) :-
    findall(Subject, dora_proportionality_and_simplified_framework_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    all_subjects(Subjects),
    maplist(exactly_one_verdict, Subjects).
test(determinism_every_query_has_exactly_one_answer) :-
    all_subjects(Subjects),
    maplist(every_query_has_one_answer, Subjects).
test(every_answer_has_its_citation_shape) :-
    all_subjects(Subjects),
    maplist(every_answer_well_shaped, Subjects).
test(every_entity_type_settles_once) :-
    entity_types(EntityTypes),
    length(EntityTypes, 29),
    maplist(type_settles_once, EntityTypes).
test(exactly_the_five_kinds_of_article_16_1_qualify) :-
    findall(EntityType, qualifying_type(EntityType), Found),
    sort(Found, FoundSet),
    sort([exempted_payment_institution, exempted_electronic_money_institution, investment_firm, institution_for_occupational_retirement_provision, institution_exempted_pursuant_to_directive_2013_36], ExpectedSet),
    FoundSet == ExpectedSet.
test(the_member_count_bands_hold_from_zero_to_one_hundred_and_fifty) :-
    numlist(0, 150, MemberCounts),
    maplist(members_answer_matches_band, MemberCounts).
test(completeness_and_outstanding_agree_on_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_consistent, Subjects).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_query_has_exactly_one_answer, every_answer_has_its_citation_shape, every_entity_type_settles_once, exactly_the_five_kinds_of_article_16_1_qualify, the_member_count_bands_hold_from_zero_to_one_hundred_and_fifty, completeness_and_outstanding_agree_on_every_subject]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
