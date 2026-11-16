% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, decide_gdpr_art6_lawful_basis/2, gdpr_art6_lawful_basis_status/2, gdpr_art6_lawful_basis_checklist/2, gdpr_art6_lawful_basis_decision_resolvable/1, gdpr_art6_lawful_basis_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_citations, [implements/1]).

gdpr_art6_lawful_basis_status_values([eligible, ineligible]).

key_rank(basis_claimed, 1).
key_rank(consent_given_and_conditions_met, 2).
key_rank(contract_necessary, 3).
key_rank(legal_obligation_necessary, 4).
key_rank(legal_obligation_laid_down_by_law, 5).
key_rank(vital_interests_necessary, 6).
key_rank(public_interest_task_necessary, 7).
key_rank(public_interest_task_laid_down_by_law, 8).
key_rank(processing_by_public_authority_in_its_tasks, 9).
key_rank(legitimate_interests_pursued, 10).
key_rank(interests_overridden, 11).
key_rank(child_data_subject, 12).
key_rank(special_category, 13).
key_rank(new_purpose_processing, 14).
key_rank(compatible_purpose, 15).

way_row(point_a, cite(eu_reg_2016_679_art_6_1_a), [need(consent_given_and_conditions_met, outside_fact, true)]).
way_row(point_b, cite(eu_reg_2016_679_art_6_1_b), [need(contract_necessary, judgement, true)]).
way_row(point_c, cite(eu_reg_2016_679_art_6_1_c), [need(legal_obligation_necessary, judgement, true), need(legal_obligation_laid_down_by_law, outside_fact, true)]).
way_row(point_d, cite(eu_reg_2016_679_art_6_1_d), [need(vital_interests_necessary, judgement, true)]).
way_row(point_e, cite(eu_reg_2016_679_art_6_1_e), [need(public_interest_task_necessary, judgement, true), need(public_interest_task_laid_down_by_law, outside_fact, true)]).
way_row(point_f, cite(eu_reg_2016_679_art_6_1_f), [need(processing_by_public_authority_in_its_tasks, crisp, false), need(legitimate_interests_pursued, judgement, true), need(interests_overridden, judgement, false)]).

basis_way(consent, point_a).
basis_way(contract, point_b).
basis_way(legal_obligation, point_c).
basis_way(vital_interests, point_d).
basis_way(public_interest_task, point_e).
basis_way(legitimate_interests, point_f).

holds_citations(point_a, [cite(eu_reg_2016_679_art_6_1_a)]).
holds_citations(point_b, [cite(eu_reg_2016_679_art_6_1_b)]).
holds_citations(point_c, [cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_3)]).
holds_citations(point_d, [cite(eu_reg_2016_679_art_6_1_d)]).
holds_citations(point_e, [cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_3)]).
holds_citations(point_f, [cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).

outside_fact_row(consent_given_and_conditions_met, cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)).
outside_fact_row(legal_obligation_laid_down_by_law, cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)).
outside_fact_row(public_interest_task_laid_down_by_law, cite(eu_reg_2016_679_art_6_3), cite(public_interest_task_law_statement)).

judgement_citation(contract_necessary, cite(eu_reg_2016_679_art_6_1_b)).
judgement_citation(legal_obligation_necessary, cite(eu_reg_2016_679_art_6_1_c)).
judgement_citation(vital_interests_necessary, cite(eu_reg_2016_679_art_6_1_d)).
judgement_citation(public_interest_task_necessary, cite(eu_reg_2016_679_art_6_1_e)).
judgement_citation(legitimate_interests_pursued, cite(eu_reg_2016_679_art_6_1_f)).
judgement_citation(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)).

kind_class(judgement, question).
kind_class(crisp, question).
kind_class(outside_fact, statement).

unresolved_state(absent).
unresolved_state(unsure).

truth_state(true, true, held).
truth_state(false, false, held).
truth_state(true, false, opposed).
truth_state(false, true, opposed).

key_reading(Profile, Key, present(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).
key_reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

first_in_order(Keys, First) :-
    findall(Rank - Key, (member(Key, Keys), key_rank(Key, Rank)), RankedKeys),
    sort(RankedKeys, [_ - First|_]).

need_state(Profile, need(Key, Kind, Needed), State) :-
    implements(eu_reg_2016_679_art_6_1),
    key_reading(Profile, Key, Reading),
    reading_state(Kind, Needed, Reading, State).

reading_state(_, _, absent, absent).
reading_state(outside_fact, Needed, present(attested(Value, _)), State) :-
    truth_state(Value, Needed, State).
reading_state(crisp, Needed, present(Value), State) :-
    truth_state(Value, Needed, State).
reading_state(judgement, Needed, present(Value), State) :-
    judgement_state(Value, Needed, State).

judgement_state(unsure, _, unsure).
judgement_state(true, Needed, State) :-
    truth_state(true, Needed, State).
judgement_state(false, Needed, State) :-
    truth_state(false, Needed, State).

way_status(Profile, Way, Status) :-
    implements(eu_reg_2016_679_art_6_1),
    way_row(Way, _, Needs),
    findall(State, (member(Need, Needs), need_state(Profile, Need, State)), States),
    memberd_t(opposed, States, HasOpposed),
    unopposed_status(HasOpposed, States, Status).

unopposed_status(true, _, fails).
unopposed_status(false, States, Status) :-
    findall(State, (member(State, States), unresolved_state(State)), Unresolved),
    resolution_status(Unresolved, Status).

resolution_status([], holds).
resolution_status([_|_], open).

way_unresolved(Profile, Way, Entries) :-
    way_row(Way, _, Needs),
    findall(entry(Key, Kind, State), (member(need(Key, Kind, Needed), Needs), need_state(Profile, need(Key, Kind, Needed), State), unresolved_state(State)), Entries).

way_statement(Way, Key) :-
    way_row(Way, _, Needs),
    member(need(Key, outside_fact, _), Needs).

considered_ways(Profile, ConsideredWays) :-
    implements(eu_reg_2016_679_art_6_1),
    key_reading(Profile, basis_claimed, Reading),
    considered_from(Reading, ConsideredWays).

considered_from(absent, [point_a, point_b, point_c, point_d, point_e, point_f]).
considered_from(present(Choice), [Way]) :-
    basis_way(Choice, Way).

ways_with_status(Profile, Ways, Status, Matching) :-
    findall(Way, (member(Way, Ways), way_status(Profile, Way, Status)), Matching).

lawful_basis_route(Profile, Route) :-
    implements(eu_reg_2016_679_art_6_1),
    considered_ways(Profile, ConsideredWays),
    ways_with_status(Profile, ConsideredWays, holds, HoldingWays),
    ways_with_status(Profile, ConsideredWays, open, OpenWays),
    ways_with_status(Profile, ConsideredWays, fails, FailingWays),
    route_from(HoldingWays, OpenWays, FailingWays, Profile, ConsideredWays, Route).

route_from([FirstHolding|OtherHolding], _, _, _, _, holds([FirstHolding|OtherHolding])).
route_from([], [], FailingWays, _, _, fails(FailingWays)).
route_from([], [FirstOpen|OtherOpen], _, Profile, ConsideredWays, Route) :-
    open_route(Profile, [FirstOpen|OtherOpen], ConsideredWays, Route).

open_route(Profile, OpenWays, ConsideredWays, Route) :-
    implements(eu_reg_2016_679_art_6_1),
    findall(entry(Key, Kind), (member(Way, OpenWays), way_unresolved(Profile, Way, [entry(Key, Kind, absent)])), OneStepEntries),
    one_step_route(OneStepEntries, Profile, OpenWays, ConsideredWays, Route).

one_step_route([], Profile, OpenWays, ConsideredWays, Route) :-
    general_route(Profile, OpenWays, ConsideredWays, Route).
one_step_route([FirstEntry|OtherEntries], _, _, _, Route) :-
    findall(Key, (member(entry(Key, Kind), [FirstEntry|OtherEntries]), kind_class(Kind, question)), QuestionKeys),
    findall(Key, (member(entry(Key, Kind), [FirstEntry|OtherEntries]), kind_class(Kind, statement)), StatementKeys),
    one_step_answer(QuestionKeys, StatementKeys, Route).

one_step_answer([FirstQuestion|OtherQuestions], _, missing(Key)) :-
    first_in_order([FirstQuestion|OtherQuestions], Key).
one_step_answer([], [FirstStatement|OtherStatements], referral(Key)) :-
    first_in_order([FirstStatement|OtherStatements], Key).

general_route(Profile, OpenWays, ConsideredWays, Route) :-
    implements(eu_reg_2016_679_art_6_1),
    findall(Entry, (member(Way, OpenWays), way_unresolved(Profile, Way, Entries), member(Entry, Entries)), AllEntries),
    findall(Key, (member(entry(Key, Kind, absent), AllEntries), kind_class(Kind, question)), QuestionKeys),
    findall(Key, (member(entry(Key, Kind, absent), AllEntries), kind_class(Kind, statement)), StatementKeys),
    findall(Key, member(entry(Key, judgement, unsure), AllEntries), UnsureKeys),
    general_answer(QuestionKeys, StatementKeys, UnsureKeys, ConsideredWays, Route).

general_answer([FirstQuestion|OtherQuestions], _, _, _, missing(Key)) :-
    first_in_order([FirstQuestion|OtherQuestions], Key).
general_answer([], [FirstStatement|OtherStatements], _, _, referral(Key)) :-
    first_in_order([FirstStatement|OtherStatements], Key).
general_answer([], [], [FirstUnsure|OtherUnsure], ConsideredWays, unsure(Key, ConsideredWays)) :-
    first_in_order([FirstUnsure|OtherUnsure], Key).

holding_citations(HoldingWays, Citations) :-
    implements(eu_reg_2016_679_art_6_1),
    findall(Citation, (member(Way, HoldingWays), holds_citations(Way, WayCitations), member(Citation, WayCitations)), Found),
    sort([cite(eu_reg_2016_679_art_6_1)|Found], Citations).

failing_citations(Profile, FailingWays, Citations) :-
    implements(eu_reg_2016_679_art_6_1),
    findall(Citation, (member(Way, FailingWays), fails_citations(Profile, Way, WayCitations), member(Citation, WayCitations)), Found),
    sort([cite(eu_reg_2016_679_art_6_1)|Found], Citations).

fails_citations(_, point_a, [cite(eu_reg_2016_679_art_6_1_a)]) :-
    implements(eu_reg_2016_679_art_6_1_a).
fails_citations(_, point_b, [cite(eu_reg_2016_679_art_6_1_b)]) :-
    implements(eu_reg_2016_679_art_6_1_b).
fails_citations(Profile, point_c, Citations) :-
    implements(eu_reg_2016_679_art_6_3),
    key_reading(Profile, legal_obligation_laid_down_by_law, Reading),
    statement_false_citations(Reading, [cite(eu_reg_2016_679_art_6_1_c)], cite(eu_reg_2016_679_art_6_3), Citations).
fails_citations(_, point_d, [cite(eu_reg_2016_679_art_6_1_d)]) :-
    implements(eu_reg_2016_679_art_6_1_d).
fails_citations(Profile, point_e, Citations) :-
    implements(eu_reg_2016_679_art_6_3),
    key_reading(Profile, public_interest_task_laid_down_by_law, Reading),
    statement_false_citations(Reading, [cite(eu_reg_2016_679_art_6_1_e)], cite(eu_reg_2016_679_art_6_3), Citations).
fails_citations(Profile, point_f, Citations) :-
    implements(eu_reg_2016_679_art_6_1_second_subpara),
    key_reading(Profile, processing_by_public_authority_in_its_tasks, Reading),
    crisp_true_citations(Reading, [cite(eu_reg_2016_679_art_6_1_f)], cite(eu_reg_2016_679_art_6_1_second_subpara), Citations).

statement_false_citations(present(attested(false, _)), Base, Extra, Citations) :-
    append(Base, [Extra], Citations).
statement_false_citations(present(attested(true, _)), Base, _, Base).
statement_false_citations(absent, Base, _, Base).

crisp_true_citations(present(true), Base, Extra, Citations) :-
    append(Base, [Extra], Citations).
crisp_true_citations(present(false), Base, _, Base).
crisp_true_citations(absent, Base, _, Base).

holding_basis(Profile, HoldingWays, Basis) :-
    implements(eu_reg_2016_679_art_6_1),
    findall(outside_fact(Key, Value), (member(Way, HoldingWays), way_statement(Way, Key), key_reading(Profile, Key, present(Value))), Statements),
    memberd_t(point_f, HoldingWays, PointFHolds),
    child_flag(PointFHolds, Profile, ChildItems),
    key_reading(Profile, special_category, SpecialReading),
    special_category_flag(SpecialReading, SpecialItems),
    append([Statements, ChildItems, SpecialItems], Basis).

child_flag(false, _, []).
child_flag(true, Profile, Items) :-
    implements(eu_reg_2016_679_art_6_1_f),
    key_reading(Profile, child_data_subject, Reading),
    attested_true_flag(Reading, child_data_subject, Items).

special_category_flag(Reading, Items) :-
    implements(eu_reg_2016_679_art_9_1),
    attested_true_flag(Reading, special_category, Items).

attested_true_flag(absent, _, []).
attested_true_flag(present(attested(true, Attestation)), Key, [flagged(Key, attested(true, Attestation))]).
attested_true_flag(present(attested(false, _)), _, []).

failing_basis(Profile, FailingWays, Basis) :-
    implements(eu_reg_2016_679_art_6_1),
    findall(outside_fact(Key, attested(false, Attestation)), (member(Way, FailingWays), way_statement(Way, Key), key_reading(Profile, Key, present(attested(false, Attestation)))), Basis).

relied_on_pairs(Profile, ConsideredWays, Pairs) :-
    findall(Key, (member(Way, ConsideredWays), way_row(Way, _, Needs), member(need(Key, _, _), Needs)), WayKeys),
    memberd_t(point_f, ConsideredWays, PointFConsidered),
    child_candidate(PointFConsidered, ChildKeys),
    append([[basis_claimed], WayKeys, ChildKeys], CandidateKeys),
    findall(Key - Value, (member(Key, CandidateKeys), key_reading(Profile, Key, present(Value))), Pairs).

child_candidate(true, [child_data_subject]).
child_candidate(false, []).

lawful_basis_status(Profile, input_problems([FirstProblem|OtherProblems]), [], []) :-
    gdpr_art6_lawful_basis_input_problems(Profile, [FirstProblem|OtherProblems]).
lawful_basis_status(Profile, Result, Basis, Citations) :-
    gdpr_art6_lawful_basis_input_problems(Profile, []),
    lawful_basis_decision(Profile, Result, Basis, Citations).

lawful_basis_decision(Profile, eligible, Basis, Citations) :-
    implements(eu_reg_2016_679_art_6_1),
    lawful_basis_route(Profile, holds(HoldingWays)),
    holding_citations(HoldingWays, Citations),
    holding_basis(Profile, HoldingWays, Basis).
lawful_basis_decision(Profile, ineligible, Basis, Citations) :-
    implements(eu_reg_2016_679_art_6_1),
    lawful_basis_route(Profile, fails(FailingWays)),
    failing_citations(Profile, FailingWays, Citations),
    failing_basis(Profile, FailingWays, Basis).
lawful_basis_decision(Profile, indeterminate([Key]), [], []) :-
    implements(eu_reg_2016_679_art_6_1),
    lawful_basis_route(Profile, missing(Key)).
lawful_basis_decision(Profile, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([Key - absent])]), [], []) :-
    implements(eu_reg_2016_679_art_6_3),
    lawful_basis_route(Profile, referral(Key)),
    outside_fact_row(Key, Citation, Target).
lawful_basis_decision(Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), [], []) :-
    implements(eu_reg_2016_679_art_6_1),
    lawful_basis_route(Profile, unsure(Key, ConsideredWays)),
    judgement_citation(Key, Citation),
    relied_on_pairs(Profile, ConsideredWays, Pairs).

purpose_compatibility(Profile, input_problems([FirstProblem|OtherProblems]), [], []) :-
    gdpr_art6_lawful_basis_input_problems(Profile, [FirstProblem|OtherProblems]).
purpose_compatibility(Profile, Result, [], Citations) :-
    gdpr_art6_lawful_basis_input_problems(Profile, []),
    key_reading(Profile, new_purpose_processing, Reading),
    compatibility_decision(Reading, Profile, Result, Citations).

compatibility_decision(absent, _, indeterminate([new_purpose_processing]), []) :-
    implements(eu_reg_2016_679_art_6_4).
compatibility_decision(present(false), _, compatibility_test_not_engaged, [cite(eu_reg_2016_679_art_6_4)]) :-
    implements(eu_reg_2016_679_art_6_4).
compatibility_decision(present(true), Profile, Result, Citations) :-
    implements(eu_reg_2016_679_art_6_4),
    key_reading(Profile, compatible_purpose, Reading),
    compatible_judgement(Reading, Result, Citations).

compatible_judgement(present(true), purpose_compatible, [cite(eu_reg_2016_679_art_6_4)]) :-
    implements(eu_reg_2016_679_art_6_4).
compatible_judgement(present(false), purpose_not_compatible, [cite(eu_reg_2016_679_art_6_4)]) :-
    implements(eu_reg_2016_679_art_6_4).
compatible_judgement(absent, indeterminate([compatible_purpose]), []) :-
    implements(eu_reg_2016_679_art_6_4).
compatible_judgement(present(unsure), needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing - true, compatible_purpose - unsure])]), []) :-
    implements(eu_reg_2016_679_art_6_4).

decide_gdpr_art6_lawful_basis(Profile, gdpr_art6_lawful_basis_verdict(Status, Citations)) :-
    lawful_basis_status(Profile, Status, _Basis, Citations).

gdpr_art6_lawful_basis_status(Profile, Status) :-
    decide_gdpr_art6_lawful_basis(Profile, gdpr_art6_lawful_basis_verdict(Status, _Citations)).

gdpr_art6_lawful_basis_checklist(Profile, [item(input_check, unmet(input_problems([FirstProblem|OtherProblems])), cite(eu_reg_2016_679_art_6_1))]) :-
    gdpr_art6_lawful_basis_input_problems(Profile, [FirstProblem|OtherProblems]).
gdpr_art6_lawful_basis_checklist(Profile, Items) :-
    gdpr_art6_lawful_basis_input_problems(Profile, []),
    considered_ways(Profile, ConsideredWays),
    findall(Item, (way_row(Way, Citation, _), checklist_item(Profile, ConsideredWays, Way, Citation, Item)), Items).

checklist_item(Profile, ConsideredWays, Way, Citation, item(Way, Status, Citation)) :-
    memberd_t(Way, ConsideredWays, Considered),
    way_checklist_status(Considered, Profile, Way, Status).

way_checklist_status(false, _, _, inapplicable).
way_checklist_status(true, Profile, Way, Status) :-
    way_status(Profile, Way, WayStatus),
    item_status(WayStatus, Profile, Way, Status).

item_status(holds, _, _, met).
item_status(fails, _, _, unmet(way_fails)).
item_status(open, Profile, Way, unknown(Keys)) :-
    way_unresolved(Profile, Way, Entries),
    findall(Key, member(entry(Key, _, _), Entries), Keys).

gdpr_art6_lawful_basis_decision_resolvable(Profile) :-
    decide_gdpr_art6_lawful_basis(Profile, _Verdict).

statement(Value, attested(Value, attestation(host_system, recorded_moment, stated_by_host, none))).

test(contract_alone_is_eligible) :-
    findall(Result - Basis - Citations, lawful_basis_status([attribute(contract_necessary, true)], Result, Basis, Citations), Answers),
    Answers = [eligible - [] - Cited],
    sort(Cited, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
test(empty_profile_asks_for_contract_first) :-
    findall(Result - Basis - Citations, lawful_basis_status([], Result, Basis, Citations), Answers),
    Answers == [indeterminate([contract_necessary]) - [] - []].
test(claimed_consent_absent_is_referred) :-
    findall(Result, lawful_basis_status([attribute(basis_claimed, consent)], Result, [], []), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])])].
test(claimed_legal_obligation_without_law_statement_is_referred) :-
    lawful_basis_status([attribute(basis_claimed, legal_obligation), attribute(legal_obligation_necessary, true)], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), _), [], []).
test(consent_statement_attested_true_is_copied) :-
    statement(true, Consent),
    lawful_basis_status([attribute(consent_given_and_conditions_met, Consent)], eligible, Basis, _),
    Basis == [outside_fact(consent_given_and_conditions_met, Consent)].
test(one_step_statement_is_referred_before_open_ways) :-
    statement(false, Refused),
    Profile = [attribute(consent_given_and_conditions_met, Refused), attribute(contract_necessary, false), attribute(legal_obligation_necessary, true), attribute(vital_interests_necessary, false)],
    lawful_basis_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), _), [], []).
test(missing_question_before_unsure) :-
    statement(false, Refused),
    statement(true, LawStated),
    Profile = [attribute(consent_given_and_conditions_met, Refused), attribute(contract_necessary, false), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, unsure), attribute(public_interest_task_laid_down_by_law, LawStated)],
    lawful_basis_status(Profile, indeterminate([processing_by_public_authority_in_its_tasks]), [], []).
test(unsure_balance_goes_to_a_lawyer_with_the_child) :-
    statement(true, Child),
    Profile = [attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, unsure), attribute(child_data_subject, Child)],
    findall(Result, lawful_basis_status(Profile, Result, [], []), Answers),
    Answers == [needs_legal_review(open_textured(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)), [inputs_relied_on([basis_claimed - legitimate_interests, processing_by_public_authority_in_its_tasks - false, legitimate_interests_pursued - true, interests_overridden - unsure, child_data_subject - Child])])].
test(public_authority_cannot_rely_on_point_f) :-
    findall(Result - Cited, lawful_basis_status([attribute(basis_claimed, legitimate_interests), attribute(processing_by_public_authority_in_its_tasks, true)], Result, [], Cited), Answers),
    Answers = [ineligible - Citations],
    sort(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)]).
test(every_way_failing_is_ineligible) :-
    statement(false, Refused),
    Profile = [attribute(consent_given_and_conditions_met, Refused), attribute(contract_necessary, false), attribute(legal_obligation_necessary, false), attribute(vital_interests_necessary, false), attribute(public_interest_task_necessary, false), attribute(processing_by_public_authority_in_its_tasks, true)],
    lawful_basis_status(Profile, ineligible, Basis, Cited),
    Basis == [outside_fact(consent_given_and_conditions_met, Refused)],
    sort(Cited, Sorted),
    sort([cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a), cite(eu_reg_2016_679_art_6_1_b), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_1_d), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara)], Sorted).
test(point_f_holding_flags_child_and_special_category) :-
    statement(true, Child),
    statement(true, Special),
    Profile = [attribute(processing_by_public_authority_in_its_tasks, false), attribute(legitimate_interests_pursued, true), attribute(interests_overridden, false), attribute(child_data_subject, Child), attribute(special_category, Special)],
    lawful_basis_status(Profile, eligible, Basis, _),
    Basis == [flagged(child_data_subject, Child), flagged(special_category, Special)].
test(wrong_type_is_an_input_problem) :-
    lawful_basis_status([attribute(contract_necessary, maybe)], input_problems([wrong_type(contract_necessary)]), [], []).
test(compatibility_not_engaged) :-
    findall(Result - Basis - Citations, purpose_compatibility([attribute(new_purpose_processing, false)], Result, Basis, Citations), Answers),
    Answers == [compatibility_test_not_engaged - [] - [cite(eu_reg_2016_679_art_6_4)]].
test(compatibility_absent_new_purpose_is_asked) :-
    purpose_compatibility([attribute(compatible_purpose, true)], indeterminate([new_purpose_processing]), [], []).
test(compatible_purpose_true) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(compatible_purpose, true)], purpose_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
test(compatible_purpose_false) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(compatible_purpose, false)], purpose_not_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
test(compatible_purpose_unsure_is_referred) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(compatible_purpose, unsure)], needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing - true, compatible_purpose - unsure])]), [], []).
test(checklist_has_six_rows) :-
    gdpr_art6_lawful_basis_checklist([attribute(contract_necessary, true)], Items),
    length(Items, 6),
    member(item(point_b, met, cite(eu_reg_2016_679_art_6_1_b)), Items).

test(contract_alone_is_not_ineligible, fail) :-
    lawful_basis_status([attribute(contract_necessary, true)], ineligible, _, _).
test(wrong_type_is_not_eligible, fail) :-
    lawful_basis_status([attribute(contract_necessary, maybe)], eligible, _, _).
test(compatible_purpose_false_is_not_compatible_answer, fail) :-
    purpose_compatibility([attribute(new_purpose_processing, true), attribute(compatible_purpose, false)], purpose_compatible, _, _).
