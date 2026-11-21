% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_scope_and_entity_types_dora_scope_and_entity_types, [dora_scope_decision/3, dora_entity_category/3, decide_dora_scope_and_entity_types/2, dora_scope_and_entity_types_status/2, dora_scope_and_entity_types_checklist/2, dora_scope_and_entity_types_decision_resolvable/1, dora_scope_and_entity_types_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_dora_scope_and_entity_types_kernel, [dora_scope_and_entity_types_input_problems/2]).
:- use_module(m__eu_dora_scope_and_entity_types_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

dora_scope_and_entity_types_status_values([in_scope(_), out_of_scope, indeterminate(_), input_problems(_)]).

listed_type(credit_institution, [cite(eu_reg_2022_2554_art_2_1_a)], post_office_giro_institution, financial_entity).
listed_type(institution_exempted_pursuant_to_directive_2013_36, [cite(eu_reg_2022_2554_art_2_1_a), cite(eu_reg_2022_2554_art_3_32)], member_state_option, financial_entity).
listed_type(payment_institution, [cite(eu_reg_2022_2554_art_2_1_b)], no_exclusion, financial_entity).
listed_type(exempted_payment_institution, [cite(eu_reg_2022_2554_art_2_1_b), cite(eu_reg_2022_2554_art_3_36)], no_exclusion, financial_entity).
listed_type(account_information_service_provider, [cite(eu_reg_2022_2554_art_2_1_c)], no_exclusion, financial_entity).
listed_type(electronic_money_institution, [cite(eu_reg_2022_2554_art_2_1_d)], no_exclusion, financial_entity).
listed_type(exempted_electronic_money_institution, [cite(eu_reg_2022_2554_art_2_1_d), cite(eu_reg_2022_2554_art_3_39)], no_exclusion, financial_entity).
listed_type(investment_firm, [cite(eu_reg_2022_2554_art_2_1_e)], exempted_investment_person, financial_entity).
listed_type(crypto_asset_service_provider, [cite(eu_reg_2022_2554_art_2_1_f)], no_exclusion, financial_entity).
listed_type(issuer_of_asset_referenced_tokens, [cite(eu_reg_2022_2554_art_2_1_f)], no_exclusion, financial_entity).
listed_type(central_securities_depository, [cite(eu_reg_2022_2554_art_2_1_g)], no_exclusion, financial_entity).
listed_type(central_counterparty, [cite(eu_reg_2022_2554_art_2_1_h)], no_exclusion, financial_entity).
listed_type(trading_venue, [cite(eu_reg_2022_2554_art_2_1_i)], no_exclusion, financial_entity).
listed_type(trade_repository, [cite(eu_reg_2022_2554_art_2_1_j)], no_exclusion, financial_entity).
listed_type(manager_of_alternative_investment_funds, [cite(eu_reg_2022_2554_art_2_1_k)], alternative_investment_fund_manager, financial_entity).
listed_type(management_company, [cite(eu_reg_2022_2554_art_2_1_l)], no_exclusion, financial_entity).
listed_type(data_reporting_service_provider, [cite(eu_reg_2022_2554_art_2_1_m)], no_exclusion, financial_entity).
listed_type(insurance_undertaking, [cite(eu_reg_2022_2554_art_2_1_n)], insurance_undertaking_under_article_4, financial_entity).
listed_type(reinsurance_undertaking, [cite(eu_reg_2022_2554_art_2_1_n)], insurance_undertaking_under_article_4, financial_entity).
listed_type(insurance_intermediary, [cite(eu_reg_2022_2554_art_2_1_o)], intermediary_size, financial_entity).
listed_type(reinsurance_intermediary, [cite(eu_reg_2022_2554_art_2_1_o)], intermediary_size, financial_entity).
listed_type(ancillary_insurance_intermediary, [cite(eu_reg_2022_2554_art_2_1_o)], intermediary_size, financial_entity).
listed_type(institution_for_occupational_retirement_provision, [cite(eu_reg_2022_2554_art_2_1_p)], occupational_retirement_members, financial_entity).
listed_type(credit_rating_agency, [cite(eu_reg_2022_2554_art_2_1_q)], no_exclusion, financial_entity).
listed_type(administrator_of_critical_benchmarks, [cite(eu_reg_2022_2554_art_2_1_r)], no_exclusion, financial_entity).
listed_type(crowdfunding_service_provider, [cite(eu_reg_2022_2554_art_2_1_s)], no_exclusion, financial_entity).
listed_type(securitisation_repository, [cite(eu_reg_2022_2554_art_2_1_t)], no_exclusion, financial_entity).
listed_type(ict_third_party_service_provider, [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)], no_exclusion, ict_third_party_service_provider).

dora_scope_decision(Profile, Result, Citations) :-
    dora_scope_and_entity_types_input_problems(Profile, Problems),
    scope_from_problems(Problems, Profile, Result, Citations).

scope_from_problems([Problem|Problems], _, input_problems([Problem|Problems]), []).
scope_from_problems([], Profile, Result, Citations) :-
    scope_outcome(Profile, Result, Citations).

scope_outcome(Profile, indeterminate([dora_entity_type]), []) :-
    implements(eu_reg_2022_2554_art_2_1),
    profile_lacks(Profile, dora_entity_type).
scope_outcome(Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_2_1),
    profile_get(Profile, dora_entity_type, EntityType),
    type_outcome(EntityType, Profile, Result, Citations).

type_outcome(none_of_the_listed_types, _, out_of_scope, [cite(eu_reg_2022_2554_art_2_1)]) :-
    implements(eu_reg_2022_2554_art_2_1).
type_outcome(EntityType, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_2_1),
    listed_type(EntityType, InScopeCitations, ExclusionRow, _),
    exclusion_state(ExclusionRow, Profile, ExclusionState),
    state_outcome(ExclusionState, EntityType, InScopeCitations, Result, Citations).

state_outcome(missing(MissingKey), _, _, indeterminate([MissingKey]), []).
state_outcome(excluded(ExclusionCitations), _, _, out_of_scope, ExclusionCitations) :-
    implements(eu_reg_2022_2554_art_2_3).
state_outcome(not_excluded, EntityType, InScopeCitations, in_scope(EntityType), InScopeCitations).

exclusion_state(no_exclusion, _, not_excluded) :-
    implements(eu_reg_2022_2554_art_2_1).
exclusion_state(post_office_giro_institution, Profile, ExclusionState) :-
    implements(eu_reg_2022_2554_art_2_3_f),
    crisp_exclusion(Profile, post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, [cite(eu_reg_2022_2554_art_2_3_f)], ExclusionState).
exclusion_state(member_state_option, Profile, ExclusionState) :-
    implements(eu_reg_2022_2554_art_2_4),
    crisp_exclusion(Profile, exempted_from_dora_scope_by_member_state, [cite(eu_reg_2022_2554_art_2_4)], ExclusionState).
exclusion_state(exempted_investment_person, Profile, ExclusionState) :-
    implements(eu_reg_2022_2554_art_2_3_d),
    crisp_exclusion(Profile, exempted_under_articles_2_and_3_of_directive_2014_65, [cite(eu_reg_2022_2554_art_2_3_d)], ExclusionState).
exclusion_state(alternative_investment_fund_manager, Profile, ExclusionState) :-
    implements(eu_reg_2022_2554_art_2_3_a),
    crisp_exclusion(Profile, aifm_under_article_3_2_of_directive_2011_61, [cite(eu_reg_2022_2554_art_2_3_a)], ExclusionState).
exclusion_state(insurance_undertaking_under_article_4, Profile, ExclusionState) :-
    implements(eu_reg_2022_2554_art_2_3_b),
    crisp_exclusion(Profile, undertaking_under_article_4_of_directive_2009_138, [cite(eu_reg_2022_2554_art_2_3_b)], ExclusionState).
exclusion_state(intermediary_size, Profile, ExclusionState) :-
    implements(eu_reg_2022_2554_art_2_3_e),
    present_value(Profile, financial_entity_is_microenterprise, MicroenterpriseValue),
    present_value(Profile, financial_entity_is_small_or_medium_sized_enterprise, SmallOrMediumValue),
    size_exclusion(MicroenterpriseValue, SmallOrMediumValue, ExclusionState).
exclusion_state(occupational_retirement_members, Profile, ExclusionState) :-
    implements(eu_reg_2022_2554_art_2_3_c),
    present_value(Profile, iorp_pension_scheme_members_total, MemberValue),
    member_count_exclusion(MemberValue, ExclusionState).

crisp_exclusion(Profile, ExclusionKey, _, missing(ExclusionKey)) :-
    profile_lacks(Profile, ExclusionKey).
crisp_exclusion(Profile, ExclusionKey, ExclusionCitations, excluded(ExclusionCitations)) :-
    profile_get(Profile, ExclusionKey, true).
crisp_exclusion(Profile, ExclusionKey, _, not_excluded) :-
    profile_get(Profile, ExclusionKey, false).

present_value(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
present_value(Profile, ProfileKey, given(Value)) :-
    profile_get(Profile, ProfileKey, Value).

size_exclusion(given(true), _, excluded([cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)])) :-
    implements(eu_reg_2022_2554_art_3_60).
size_exclusion(given(false), given(true), excluded([cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)])) :-
    implements(eu_reg_2022_2554_art_3_63).
size_exclusion(absent, given(true), excluded([cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)])) :-
    implements(eu_reg_2022_2554_art_3_64).
size_exclusion(given(false), given(false), not_excluded) :-
    implements(eu_reg_2022_2554_art_2_3_e).
size_exclusion(absent, given(false), missing(financial_entity_is_microenterprise)) :-
    implements(eu_reg_2022_2554_art_3_60).
size_exclusion(absent, absent, missing(financial_entity_is_microenterprise)) :-
    implements(eu_reg_2022_2554_art_3_60).
size_exclusion(given(false), absent, missing(financial_entity_is_small_or_medium_sized_enterprise)) :-
    implements(eu_reg_2022_2554_art_3_63).

member_count_exclusion(absent, missing(iorp_pension_scheme_members_total)) :-
    implements(eu_reg_2022_2554_art_2_3_c).
member_count_exclusion(given(MemberCount), excluded([cite(eu_reg_2022_2554_art_2_3_c)])) :-
    implements(eu_reg_2022_2554_art_2_3_c),
    MemberCount #< 16.
member_count_exclusion(given(MemberCount), not_excluded) :-
    implements(eu_reg_2022_2554_art_2_3_c),
    MemberCount #> 15.

dora_entity_category(Profile, Result, Citations) :-
    dora_scope_decision(Profile, ScopeResult, ScopeCitations),
    category_from_scope(ScopeResult, ScopeCitations, Result, Citations).

category_from_scope(input_problems(Problems), ScopeCitations, input_problems(Problems), ScopeCitations).
category_from_scope(indeterminate(MissingKeys), ScopeCitations, indeterminate(MissingKeys), ScopeCitations).
category_from_scope(out_of_scope, ScopeCitations, out_of_scope, ScopeCitations).
category_from_scope(in_scope(EntityType), ScopeCitations, Category, Citations) :-
    implements(eu_reg_2022_2554_art_2_2),
    listed_type(EntityType, _, _, Category),
    category_citations(Category, ScopeCitations, Citations).

category_citations(ict_third_party_service_provider, ScopeCitations, ScopeCitations) :-
    implements(eu_reg_2022_2554_art_3_19).
category_citations(financial_entity, ScopeCitations, Citations) :-
    implements(eu_reg_2022_2554_art_2_2),
    append(ScopeCitations, [cite(eu_reg_2022_2554_art_2_2)], Citations).

decide_dora_scope_and_entity_types(Profile, dora_scope_and_entity_types_verdict(Status, Citations)) :-
    dora_scope_decision(Profile, Status, Citations).

dora_scope_and_entity_types_status(Profile, Status) :-
    decide_dora_scope_and_entity_types(Profile, dora_scope_and_entity_types_verdict(Status, _Citations)).

dora_scope_and_entity_types_checklist(Profile, Items) :-
    dora_scope_decision(Profile, Result, Citations),
    result_checklist(Result, Citations, Items).

result_checklist(input_problems(Problems), _, [item(input_check, unmet(input_problems(Problems)), [cite(eu_reg_2022_2554_art_2_1)])]).
result_checklist(indeterminate([dora_entity_type]), _, [item(listed_type, unknown([dora_entity_type]), [cite(eu_reg_2022_2554_art_2_1)]), item(no_exclusion, unknown([dora_entity_type]), [cite(eu_reg_2022_2554_art_2_1)])]).
result_checklist(indeterminate([MissingKey]), _, [item(listed_type, met, [cite(eu_reg_2022_2554_art_2_1)]), item(no_exclusion, unknown([MissingKey]), [cite(eu_reg_2022_2554_art_2_1)])]) :-
    dif(MissingKey, dora_entity_type).
result_checklist(out_of_scope, [cite(eu_reg_2022_2554_art_2_1)], [item(listed_type, unmet(none_of_the_listed_types), [cite(eu_reg_2022_2554_art_2_1)]), item(no_exclusion, unknown([dora_entity_type]), [cite(eu_reg_2022_2554_art_2_1)])]).
result_checklist(out_of_scope, [ExclusionCitation|ExclusionCitations], [item(listed_type, met, [cite(eu_reg_2022_2554_art_2_1)]), item(no_exclusion, unmet(excluded), [ExclusionCitation|ExclusionCitations])]) :-
    dif([ExclusionCitation|ExclusionCitations], [cite(eu_reg_2022_2554_art_2_1)]).
result_checklist(in_scope(_), Citations, [item(listed_type, met, Citations), item(no_exclusion, met, [cite(eu_reg_2022_2554_art_2_1)])]).

dora_scope_and_entity_types_decision_resolvable(Profile) :-
    dora_scope_decision(Profile, Result, _Citations),
    final_result(Result).

final_result(in_scope(_)).
final_result(out_of_scope).

test(credit_institution_not_giro_is_in_scope) :-
    findall(Result - Citations, dora_scope_decision([attribute(dora_entity_type, credit_institution), attribute(post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, false)], Result, Citations), Answers),
    Answers == [in_scope(credit_institution) - [cite(eu_reg_2022_2554_art_2_1_a)]].
test(credit_institution_giro_is_out_of_scope) :-
    dora_scope_decision([attribute(dora_entity_type, credit_institution), attribute(post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, true)], out_of_scope, [cite(eu_reg_2022_2554_art_2_3_f)]).
test(credit_institution_without_giro_key_is_indeterminate) :-
    dora_scope_decision([attribute(dora_entity_type, credit_institution)], indeterminate([post_office_giro_institution_under_article_2_5_3_of_directive_2013_36]), []).
test(absent_type_is_indeterminate) :-
    findall(Result - Citations, dora_scope_decision([], Result, Citations), Answers),
    Answers == [indeterminate([dora_entity_type]) - []].
test(none_of_the_listed_types_is_out_of_scope) :-
    dora_scope_decision([attribute(dora_entity_type, none_of_the_listed_types)], out_of_scope, [cite(eu_reg_2022_2554_art_2_1)]).
test(unknown_key_is_an_input_problem) :-
    findall(Result - Citations, dora_scope_decision([attribute(dora_entity_type, trading_venue), attribute(colour, blue)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(float_member_count_is_wrong_type) :-
    FractionalCount is float(15),
    dora_scope_decision([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, FractionalCount)], input_problems([wrong_type(iorp_pension_scheme_members_total)]), []).
test(fifteen_members_is_out_of_scope) :-
    dora_scope_decision([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 15)], out_of_scope, [cite(eu_reg_2022_2554_art_2_3_c)]).
test(sixteen_members_is_in_scope) :-
    dora_scope_decision([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 16)], in_scope(institution_for_occupational_retirement_provision), [cite(eu_reg_2022_2554_art_2_1_p)]).
test(small_intermediary_decides_alone) :-
    findall(Result - Citations, dora_scope_decision([attribute(dora_entity_type, insurance_intermediary), attribute(financial_entity_is_small_or_medium_sized_enterprise, true)], Result, Citations), Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)]].
test(both_size_facts_true_give_one_answer) :-
    findall(Result, dora_scope_decision([attribute(dora_entity_type, reinsurance_intermediary), attribute(financial_entity_is_microenterprise, true), attribute(financial_entity_is_small_or_medium_sized_enterprise, true)], Result, _), Results),
    Results == [out_of_scope].
test(intermediary_with_no_size_names_microenterprise) :-
    dora_scope_decision([attribute(dora_entity_type, ancillary_insurance_intermediary)], indeterminate([financial_entity_is_microenterprise]), []).
test(intermediary_not_micro_names_small_or_medium) :-
    dora_scope_decision([attribute(dora_entity_type, ancillary_insurance_intermediary), attribute(financial_entity_is_microenterprise, false)], indeterminate([financial_entity_is_small_or_medium_sized_enterprise]), []).
test(large_intermediary_is_a_financial_entity) :-
    dora_entity_category([attribute(dora_entity_type, insurance_intermediary), attribute(financial_entity_is_microenterprise, false), attribute(financial_entity_is_small_or_medium_sized_enterprise, false)], financial_entity, [cite(eu_reg_2022_2554_art_2_1_o), cite(eu_reg_2022_2554_art_2_2)]).
test(member_state_exclusion_is_out_of_scope) :-
    dora_scope_decision([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36), attribute(exempted_from_dora_scope_by_member_state, true)], out_of_scope, [cite(eu_reg_2022_2554_art_2_4)]).
test(exempted_institution_not_excluded_cites_point_32) :-
    dora_entity_category([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36), attribute(exempted_from_dora_scope_by_member_state, false)], financial_entity, [cite(eu_reg_2022_2554_art_2_1_a), cite(eu_reg_2022_2554_art_3_32), cite(eu_reg_2022_2554_art_2_2)]).
test(ict_provider_category) :-
    findall(Result - Citations, dora_entity_category([attribute(dora_entity_type, ict_third_party_service_provider)], Result, Citations), Answers),
    Answers == [ict_third_party_service_provider - [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)]].
test(other_type_key_is_not_read) :-
    dora_scope_decision([attribute(dora_entity_type, trading_venue), attribute(aifm_under_article_3_2_of_directive_2011_61, true)], in_scope(trading_venue), [cite(eu_reg_2022_2554_art_2_1_i)]).
test(exempted_investment_firm_is_out_of_scope) :-
    dora_entity_category([attribute(dora_entity_type, investment_firm), attribute(exempted_under_articles_2_and_3_of_directive_2014_65, true)], out_of_scope, [cite(eu_reg_2022_2554_art_2_3_d)]).
test(small_insurer_is_out_of_scope) :-
    dora_scope_decision([attribute(dora_entity_type, reinsurance_undertaking), attribute(undertaking_under_article_4_of_directive_2009_138, true)], out_of_scope, [cite(eu_reg_2022_2554_art_2_3_b)]).
test(checklist_of_an_in_scope_entity) :-
    dora_scope_and_entity_types_checklist([attribute(dora_entity_type, trade_repository)], [item(listed_type, met, [cite(eu_reg_2022_2554_art_2_1_j)]), item(no_exclusion, met, [cite(eu_reg_2022_2554_art_2_1)])]).
test(status_projection) :-
    dora_scope_and_entity_types_status([attribute(dora_entity_type, management_company)], in_scope(management_company)).
test(final_answer_is_resolvable) :-
    dora_scope_and_entity_types_decision_resolvable([attribute(dora_entity_type, none_of_the_listed_types)]).

test(credit_institution_giro_is_not_in_scope, fail) :-
    dora_scope_decision([attribute(dora_entity_type, credit_institution), attribute(post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, true)], in_scope(_), _).
test(sixteen_members_is_not_out_of_scope, fail) :-
    dora_scope_decision([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 16)], out_of_scope, _).
test(ict_provider_is_not_a_financial_entity, fail) :-
    dora_entity_category([attribute(dora_entity_type, ict_third_party_service_provider)], financial_entity, _).
test(indeterminate_is_not_resolvable, fail) :-
    dora_scope_and_entity_types_decision_resolvable([]).
