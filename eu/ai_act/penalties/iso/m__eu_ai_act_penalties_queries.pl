% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_penalties_queries, [penalties_profile_keys/1, penalties_what_if/4, no_union_maximum/0, set_by_member_state_rules/0, not_applicable_on_date/0, earlier_version_applies/0, no_commission_fine/0, fixed_amount/0, turnover_percentage/0, fine_maximum/2, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_ai_act_penalties_kernel, [penalties_input_problems/2]).
:- use_module(m__eu_ai_act_penalties_penalties, [decide_penalties/2]).

penalties_profile_keys([offender_category, infringement, offender_is_general_purpose_ai_model_provider, general_purpose_ai_model_infringement, provider_acted_intentionally_or_negligently, worldwide_annual_turnover_eur]).

no_union_maximum.

set_by_member_state_rules.

not_applicable_on_date.

earlier_version_applies.

no_commission_fine.

fixed_amount.

turnover_percentage.

fine_maximum(AmountEurCents, fixed_amount) :-
    integer(AmountEurCents),
    AmountEurCents >= 0.
fine_maximum(AmountEurCents, Basis) :-
    nonvar(Basis),
    Basis == turnover_percentage,
    integer(AmountEurCents),
    AmountEurCents >= 0.

indeterminate([MissingKey]) :-
    atom(MissingKey).

needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(Pairs)|_Provenance]) :-
    atom(InputKey),
    atom(CitationKey),
    is_list(Pairs).

open_textured(InputKey, cite(CitationKey)) :-
    atom(InputKey),
    atom(CitationKey).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(_Clause, Citations) :-
    is_list(Citations).

input_problems([_FirstProblem|_OtherProblems]).

unknown_key(Key) :-
    atomic(Key).
unknown_key(Key) :-
    compound(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

penalties_what_if(maximum_fine(Profile, InfringementDate), OverriddenKey, NewValue, Verdict) :-
    hypothesis_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_penalties(maximum_fine(Hypothesis, InfringementDate), Verdict).
penalties_what_if(general_purpose_ai_model_maximum_fine(Profile, InfringementDate), OverriddenKey, NewValue, Verdict) :-
    hypothesis_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_penalties(general_purpose_ai_model_maximum_fine(Hypothesis, InfringementDate), Verdict).

hypothesis_profile(Profile, Key, Value, Hypothesis) :-
    penalties_input_problems(Profile, Problems),
    hypothesis_for_problems(Problems, Profile, Key, Value, Hypothesis).

hypothesis_for_problems([wrong_type(profile)], Profile, _, _, Profile).
hypothesis_for_problems(Problems, Profile, Key, Value, Hypothesis) :-
    dif(Problems, [wrong_type(profile)]),
    override_attribute(Profile, Key, Value, Hypothesis).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ElementKey, _)|Elements], Key, Value, [attribute(Key, Value)|KeptElements]) :-
    ElementKey == Key,
    without_key(Elements, Key, KeptElements).
override_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|OverriddenElements]) :-
    ElementKey \== Key,
    override_attribute(Elements, Key, Value, OverriddenElements).

without_key([], _, []).
without_key([attribute(ElementKey, _)|Elements], Key, KeptElements) :-
    ElementKey == Key,
    without_key(Elements, Key, KeptElements).
without_key([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|KeptElements]) :-
    ElementKey \== Key,
    without_key(Elements, Key, KeptElements).

test(the_profile_keys_are_the_six_contract_keys) :-
    penalties_profile_keys(Keys),
    length(Keys, 6).
test(the_final_atoms_are_served) :-
    no_union_maximum,
    set_by_member_state_rules,
    not_applicable_on_date,
    earlier_version_applies,
    no_commission_fine,
    fixed_amount,
    turnover_percentage.
test(a_fine_maximum_has_its_shape) :-
    fine_maximum(3500000000, fixed_amount).
test(a_turnover_fine_maximum_has_its_shape) :-
    fine_maximum(7000000000, turnover_percentage).
test(a_status_compound_has_its_shape) :-
    indeterminate([offender_category]),
    needs_legal_review(open_textured(provider_acted_intentionally_or_negligently, cite(eu_reg_2024_1689_art_101_1)), [inputs_relied_on([provider_acted_intentionally_or_negligently - unsure])]),
    input_problems([wrong_type(profile)]),
    wrong_type(infringement_date),
    duplicate_key(infringement),
    unknown_key(colour).
test(a_number_key_is_an_unknown_key_shape) :-
    unknown_key(42).
test(adding_the_turnover_settles_the_maximum) :-
    findall(Verdict, penalties_what_if(maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice)], date(2026, 9, 1)), worldwide_annual_turnover_eur, 1000000000, Verdict), Verdicts),
    Verdicts == [penalties_verdict(union_maximum_determined, fine_maximum(7000000000, turnover_percentage), [cite(eu_reg_2024_1689_art_99_3)])].
test(replacing_the_category_gives_the_fixed_amount) :-
    findall(Verdict, penalties_what_if(maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice), attribute(worldwide_annual_turnover_eur, 1000000000)], date(2026, 9, 1)), offender_category, not_an_undertaking, Verdict), Verdicts),
    Verdicts == [penalties_verdict(union_maximum_determined, fine_maximum(3500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_3)])].
test(overriding_a_duplicate_key_leaves_one_occurrence) :-
    findall(Verdict, penalties_what_if(maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice), attribute(infringement, other_infringement)], date(2026, 9, 1)), infringement, prohibited_practice, Verdict), Verdicts),
    Verdicts == [penalties_verdict(information_missing, indeterminate([worldwide_annual_turnover_eur]), [])].
test(a_profile_that_is_not_a_list_stays_rejected) :-
    findall(Verdict, penalties_what_if(maximum_fine(not_a_profile, date(2026, 9, 1)), offender_category, other_undertaking, Verdict), Verdicts),
    Verdicts == [penalties_verdict(input_rejected, input_problems([wrong_type(profile)]), [])].
test(settling_an_unsure_judgement_settles_the_model_fine) :-
    findall(Verdict, penalties_what_if(general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true), attribute(general_purpose_ai_model_infringement, infringed_relevant_provisions), attribute(provider_acted_intentionally_or_negligently, unsure), attribute(worldwide_annual_turnover_eur, 1000000000)], date(2026, 9, 1)), provider_acted_intentionally_or_negligently, true, Verdict), Verdicts),
    Verdicts == [penalties_verdict(union_maximum_determined, fine_maximum(3000000000, turnover_percentage), [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_a)])].
test(a_false_judgement_gives_no_commission_fine) :-
    penalties_what_if(general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true), attribute(provider_acted_intentionally_or_negligently, unsure)], date(2026, 9, 1)), provider_acted_intentionally_or_negligently, false, penalties_verdict(no_union_maximum_determined, no_commission_fine, [cite(eu_reg_2024_1689_art_101_1)])).

test(a_fine_maximum_with_another_basis_is_not_one, fail) :-
    fine_maximum(3500000000, percentage).
test(an_unbound_term_is_not_an_unknown_key_shape, fail) :-
    unknown_key(_).
test(replacing_the_category_does_not_keep_the_turnover_amount, fail) :-
    penalties_what_if(maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice), attribute(worldwide_annual_turnover_eur, 1000000000)], date(2026, 9, 1)), offender_category, not_an_undertaking, penalties_verdict(_, fine_maximum(7000000000, _), _)).
