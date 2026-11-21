% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [decide_request_exception/2, request_exception_status/2, request_exception_checklist/2, request_exception_decision_resolvable/1, request_exception_status_values/1, request_exception_verdict/2, request_decision/2, request_exception/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [include/3]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems/2, contract_keys/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(library(reif), [memberd_t/3]).

request_exception_status_values([art20_3_public_task, art20_4_rights_of_others, art21_1_compelling_legitimate_grounds, art21_1_legal_claims, art21_6_public_interest_task, art22_2_a, art22_2_b, art22_2_c, art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction, none]).

engagement(portability, art20_1, cite(eu_reg_2016_679_art_20_1), conjunction([leaf(required, personal_data_provided_by_data_subject), leaf(required, processing_based_on_consent_or_contract), leaf(required, processing_carried_out_by_automated_means)])) :-
    implements(eu_reg_2016_679_art_20_1).
engagement(objection(art21_1), art21_1, cite(eu_reg_2016_679_art_21_1), conjunction([leaf(required, processing_based_on_art6_1_e_or_f), leaf(required, objection_grounds_relate_to_particular_situation)])) :-
    implements(eu_reg_2016_679_art_21_1).
engagement(objection(art21_2), art21_2, cite(eu_reg_2016_679_art_21_3), leaf(required, processing_for_direct_marketing)) :-
    implements(eu_reg_2016_679_art_21_2).
engagement(objection(art21_6), art21_6, cite(eu_reg_2016_679_art_21_6), conjunction([leaf(required, processing_for_research_or_statistics_pursuant_to_art89_1), leaf(required, objection_grounds_relate_to_particular_situation)])) :-
    implements(eu_reg_2016_679_art_21_6).
engagement(automated_decision, art22_1, cite(eu_reg_2016_679_art_22_1), conjunction([leaf(required, decision_based_solely_on_automated_processing), leaf(required, decision_produces_legal_or_similarly_significant_effects)])) :-
    implements(eu_reg_2016_679_art_22_1).

specific_exceptions(portability, [art20_3_public_task, art20_4_rights_of_others]).
specific_exceptions(objection(art21_1), [art21_1_compelling_legitimate_grounds, art21_1_legal_claims]).
specific_exceptions(objection(art21_2), []).
specific_exceptions(objection(art21_6), [art21_6_public_interest_task]).
specific_exceptions(automated_decision, [art22_2_a, art22_2_b, art22_2_c]).

common_exceptions([art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction]).

case_exceptions(RequestCase, ExceptionIdentifiers) :-
    specific_exceptions(RequestCase, SpecificIdentifiers),
    common_exceptions(CommonIdentifiers),
    append(SpecificIdentifiers, CommonIdentifiers, ExceptionIdentifiers).

exception_rule(art20_3_public_task, cite(eu_reg_2016_679_art_20_3), leaf(defeater, processing_necessary_for_public_task_or_official_authority)) :-
    implements(eu_reg_2016_679_art_20_3).
exception_rule(art20_4_rights_of_others, cite(eu_reg_2016_679_art_20_4), leaf(defeater, transmission_would_adversely_affect_rights_and_freedoms_of_others)) :-
    implements(eu_reg_2016_679_art_20_4).
exception_rule(art21_1_compelling_legitimate_grounds, cite(eu_reg_2016_679_art_21_1), leaf(defeater, controller_demonstrates_compelling_legitimate_grounds)) :-
    implements(eu_reg_2016_679_art_21_1).
exception_rule(art21_1_legal_claims, cite(eu_reg_2016_679_art_21_1), leaf(defeater, processing_necessary_for_legal_claims)) :-
    implements(eu_reg_2016_679_art_21_1).
exception_rule(art21_6_public_interest_task, cite(eu_reg_2016_679_art_21_6), leaf(defeater, processing_necessary_for_public_task_or_official_authority)) :-
    implements(eu_reg_2016_679_art_21_6).
exception_rule(art22_2_a, cite(eu_reg_2016_679_art_22_2_a), conjunction([leaf(defeater, decision_necessary_for_contract_with_data_subject), negation(SpecialCategoryBar)])) :-
    implements(eu_reg_2016_679_art_22_2_a),
    special_category_bar(SpecialCategoryBar).
exception_rule(art22_2_b, cite(eu_reg_2016_679_art_22_2_b), conjunction([leaf(blocking_fact, decision_authorised_by_union_or_member_state_law), negation(SpecialCategoryBar)])) :-
    implements(eu_reg_2016_679_art_22_2_b),
    special_category_bar(SpecialCategoryBar).
exception_rule(art22_2_c, cite(eu_reg_2016_679_art_22_2_c), conjunction([leaf(defeater, data_subject_gave_explicit_consent), negation(SpecialCategoryBar)])) :-
    implements(eu_reg_2016_679_art_22_2_c),
    special_category_bar(SpecialCategoryBar).
exception_rule(art12_5_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5), leaf(defeater, request_manifestly_unfounded_or_excessive)) :-
    implements(eu_reg_2016_679_art_12_5).
exception_rule(art12_2_unable_to_identify, cite(eu_reg_2016_679_art_12_2), leaf(defeater, controller_demonstrates_unable_to_identify_data_subject)) :-
    implements(eu_reg_2016_679_art_12_2).
exception_rule(art23_legislative_restriction, cite(eu_reg_2016_679_art_23_1), leaf(blocking_fact, legislative_restriction_applies_to_the_right)) :-
    implements(eu_reg_2016_679_art_23_1).

special_category_bar(conjunction([leaf(defeater, decision_based_on_special_categories), negation(leaf(required, special_category_condition_and_safeguards_met_for_decision))])) :-
    implements(eu_reg_2016_679_art_22_4).

suspension_rule(cite(eu_reg_2016_679_art_12_6), conjunction([leaf(defeater, reasonable_doubts_about_identity), negation(leaf(required, identity_confirmed))])) :-
    implements(eu_reg_2016_679_art_12_6).

exception_conditions(art20_3_public_task, []) :-
    implements(eu_reg_2016_679_art_20_3).
exception_conditions(art20_4_rights_of_others, []) :-
    implements(eu_reg_2016_679_art_20_4).
exception_conditions(art21_1_compelling_legitimate_grounds, []) :-
    implements(eu_reg_2016_679_art_21_1).
exception_conditions(art21_1_legal_claims, []) :-
    implements(eu_reg_2016_679_art_21_1).
exception_conditions(art21_6_public_interest_task, []) :-
    implements(eu_reg_2016_679_art_21_6).
exception_conditions(art22_2_a, [human_intervention, express_point_of_view, contest_decision]) :-
    implements(eu_reg_2016_679_art_22_3).
exception_conditions(art22_2_b, []) :-
    implements(eu_reg_2016_679_art_22_2_b).
exception_conditions(art22_2_c, [human_intervention, express_point_of_view, contest_decision]) :-
    implements(eu_reg_2016_679_art_22_3).
exception_conditions(art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged]) :-
    implements(eu_reg_2016_679_art_12_5).
exception_conditions(art12_2_unable_to_identify, []) :-
    implements(eu_reg_2016_679_art_12_2).
exception_conditions(art23_legislative_restriction, []) :-
    implements(eu_reg_2016_679_art_23_1).

referral(_, reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)) :-
    implements(eu_reg_2016_679_art_12_6).
referral(_, request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)) :-
    implements(eu_reg_2016_679_art_12_5).
referral(portability, processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_20_3)) :-
    implements(eu_reg_2016_679_art_20_3).
referral(portability, transmission_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_20_4)) :-
    implements(eu_reg_2016_679_art_20_4).
referral(objection(art21_1), objection_grounds_relate_to_particular_situation, cite(eu_reg_2016_679_art_21_1)) :-
    implements(eu_reg_2016_679_art_21_1).
referral(objection(art21_1), controller_demonstrates_compelling_legitimate_grounds, cite(eu_reg_2016_679_art_21_1)) :-
    implements(eu_reg_2016_679_art_21_1).
referral(objection(art21_1), processing_necessary_for_legal_claims, cite(eu_reg_2016_679_art_21_1)) :-
    implements(eu_reg_2016_679_art_21_1).
referral(objection(art21_6), objection_grounds_relate_to_particular_situation, cite(eu_reg_2016_679_art_21_6)) :-
    implements(eu_reg_2016_679_art_21_6).
referral(objection(art21_6), processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_21_6)) :-
    implements(eu_reg_2016_679_art_21_6).
referral(automated_decision, decision_based_solely_on_automated_processing, cite(eu_reg_2016_679_art_22_1)) :-
    implements(eu_reg_2016_679_art_22_1).
referral(automated_decision, decision_produces_legal_or_similarly_significant_effects, cite(eu_reg_2016_679_art_22_1)) :-
    implements(eu_reg_2016_679_art_22_1).
referral(automated_decision, decision_necessary_for_contract_with_data_subject, cite(eu_reg_2016_679_art_22_2_a)) :-
    implements(eu_reg_2016_679_art_22_2_a).

read_judgement(reasonable_doubts_about_identity).
read_judgement(request_manifestly_unfounded_or_excessive).
read_judgement(processing_necessary_for_public_task_or_official_authority).
read_judgement(processing_necessary_for_legal_claims).
read_judgement(transmission_would_adversely_affect_rights_and_freedoms_of_others).
read_judgement(objection_grounds_relate_to_particular_situation).
read_judgement(controller_demonstrates_compelling_legitimate_grounds).
read_judgement(decision_based_solely_on_automated_processing).
read_judgement(decision_produces_legal_or_similarly_significant_effects).
read_judgement(decision_necessary_for_contract_with_data_subject).

sibling_order_request_type(access).
sibling_order_request_type(rectification).
sibling_order_request_type(erasure).
sibling_order_request_type(restriction).

leaf_status(Profile, LeafKind, InputKey, Status) :-
    profile_lacks(Profile, InputKey),
    absent_status(LeafKind, InputKey, Status).
leaf_status(Profile, LeafKind, InputKey, Status) :-
    profile_get(Profile, InputKey, Value),
    present_status(LeafKind, InputKey, Value, Status).

absent_status(required, InputKey, open([InputKey], [])).
absent_status(defeater, _, unmet).
absent_status(blocking_fact, _, unmet).

present_status(required, InputKey, Value, Status) :-
    truth_status(Value, InputKey, Status).
present_status(defeater, InputKey, Value, Status) :-
    truth_status(Value, InputKey, Status).
present_status(blocking_fact, _, attested(AttestedValue, _), Status) :-
    attested_status(AttestedValue, Status).

truth_status(true, _, met).
truth_status(false, _, unmet).
truth_status(unsure, InputKey, open([], [InputKey])).

attested_status(true, met).
attested_status(false, unmet).

limb_status(Profile, leaf(LeafKind, InputKey), Status) :-
    leaf_status(Profile, LeafKind, InputKey, Status).
limb_status(Profile, conjunction(Formulas), Status) :-
    foldl(conjunct_status(Profile), Formulas, met, Status).
limb_status(Profile, negation(Formula), Status) :-
    limb_status(Profile, Formula, InnerStatus),
    negate_status(InnerStatus, Status).

conjunct_status(Profile, Formula, StatusSoFar, Status) :-
    limb_status(Profile, Formula, FormulaStatus),
    conjoin_status(StatusSoFar, FormulaStatus, Status).

conjoin_status(unmet, _, unmet).
conjoin_status(met, Status, Status).
conjoin_status(open(_, _), unmet, unmet).
conjoin_status(open(Absent, Unsure), met, open(Absent, Unsure)).
conjoin_status(open(AbsentFirst, UnsureFirst), open(AbsentSecond, UnsureSecond), open(Absent, Unsure)) :-
    append(AbsentFirst, AbsentSecond, Absent),
    append(UnsureFirst, UnsureSecond, Unsure).

negate_status(met, unmet).
negate_status(unmet, met).
negate_status(open(Absent, Unsure), open(Absent, Unsure)).

formula_keys(leaf(_, InputKey), [InputKey]).
formula_keys(conjunction(Formulas), InputKeys) :-
    maplist(formula_keys, Formulas, KeyLists),
    append(KeyLists, InputKeys).
formula_keys(negation(Formula), InputKeys) :-
    formula_keys(Formula, InputKeys).

root_order(Candidates, Ordered) :-
    contract_keys(ContractKeys),
    findall(InputKey, (member(InputKey, ContractKeys), memberd_t(InputKey, Candidates, true)), Ordered).

case_answer(Profile, RequestCase, Answer) :-
    engagement(RequestCase, Basis, _EngagementCitation, EngagementFormula),
    limb_status(Profile, EngagementFormula, EngagementStatus),
    case_exceptions(RequestCase, ExceptionIdentifiers),
    maplist(exception_outcome(Profile), ExceptionIdentifiers, Outcomes),
    first_met_exception(Outcomes, FirstMet),
    suspension_rule(_SuspensionCitation, SuspensionFormula),
    limb_status(Profile, SuspensionFormula, SuspensionStatus),
    maplist(outcome_limb, Outcomes, ExceptionLimbs),
    open_limbs([limb(EngagementFormula, EngagementStatus), limb(SuspensionFormula, SuspensionStatus)|ExceptionLimbs], OpenLimbs),
    route(EngagementStatus, FirstMet, SuspensionStatus, OpenLimbs, Basis, Profile, RequestCase, Answer).

exception_outcome(Profile, Identifier, exception_outcome(Identifier, Formula, Status)) :-
    exception_rule(Identifier, _, Formula),
    limb_status(Profile, Formula, Status).

outcome_limb(exception_outcome(_, Formula, Status), limb(Formula, Status)).

first_met_exception([], no_met_exception).
first_met_exception([exception_outcome(Identifier, _, met)|_], met_exception(Identifier)).
first_met_exception([exception_outcome(_, _, unmet)|Remaining], FirstMet) :-
    first_met_exception(Remaining, FirstMet).
first_met_exception([exception_outcome(_, _, open(_, _))|Remaining], FirstMet) :-
    first_met_exception(Remaining, FirstMet).

open_limbs([], []).
open_limbs([limb(Formula, Status)|Remaining], OpenLimbs) :-
    open_limbs(Remaining, LaterOpenLimbs),
    add_open_limb(Status, Formula, LaterOpenLimbs, OpenLimbs).

add_open_limb(met, _, OpenLimbs, OpenLimbs).
add_open_limb(unmet, _, OpenLimbs, OpenLimbs).
add_open_limb(open(Absent, Unsure), Formula, OpenLimbs, [limb(Formula, open(Absent, Unsure))|OpenLimbs]).

engaged_or_open(met).
engaged_or_open(open(_, _)).

suspension_not_met(unmet).
suspension_not_met(open(_, _)).

route(unmet, _, _, _, _, _, _, answer(need_not_comply, none, none, [])).
route(met, met_exception(Identifier), _, _, Basis, _, _, answer(need_not_comply, Basis, Identifier, Conditions)) :-
    exception_conditions(Identifier, Conditions).
route(open(_, _), met_exception(Identifier), _, _, _, _, _, answer(need_not_comply, none, Identifier, Conditions)) :-
    exception_conditions(Identifier, Conditions).
route(EngagementStatus, no_met_exception, met, _, _, _, _, answer(suspended(art12_6_identity_not_confirmed), none, none, [])) :-
    implements(eu_reg_2016_679_art_12_6),
    engaged_or_open(EngagementStatus).
route(EngagementStatus, no_met_exception, SuspensionStatus, [OpenLimb|OpenLimbs], _, Profile, RequestCase, answer(Comply, none, none, [])) :-
    engaged_or_open(EngagementStatus),
    suspension_not_met(SuspensionStatus),
    open_comply(Profile, RequestCase, [OpenLimb|OpenLimbs], Comply).
route(met, no_met_exception, unmet, [], Basis, _, _, answer(must_comply, Basis, none, [])).

limb_absent_keys(limb(_, open(Absent, _)), Absent).

limb_unsure_keys(limb(_, open(_, Unsure)), Unsure).

limb_formula_keys(limb(Formula, _), InputKeys) :-
    formula_keys(Formula, InputKeys).

open_comply(Profile, RequestCase, OpenLimbs, Comply) :-
    maplist(limb_absent_keys, OpenLimbs, AbsentLists),
    append(AbsentLists, Absent),
    root_order(Absent, MissingKeys),
    open_comply_from(MissingKeys, Profile, RequestCase, OpenLimbs, Comply).

open_comply_from([MissingKey|MissingKeys], _, _, _, indeterminate([MissingKey|MissingKeys])).
open_comply_from([], Profile, RequestCase, OpenLimbs, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)])) :-
    maplist(limb_unsure_keys, OpenLimbs, UnsureLists),
    append(UnsureLists, Unsure),
    root_order(Unsure, [Input|_]),
    referral(RequestCase, Input, Citation),
    relied_on_pairs(Profile, RequestCase, OpenLimbs, Pairs).

case_pair_keys(portability, [request_type]).
case_pair_keys(objection(_), [request_type, objection_ground_claimed]).
case_pair_keys(automated_decision, [request_type]).

relied_on_pairs(Profile, RequestCase, OpenLimbs, Pairs) :-
    case_pair_keys(RequestCase, CaseKeys),
    maplist(limb_formula_keys, OpenLimbs, KeyLists),
    append(KeyLists, ReadKeys),
    include(read_judgement, ReadKeys, JudgementKeys),
    append(CaseKeys, JudgementKeys, Candidates),
    root_order(Candidates, Ordered),
    findall(InputKey - Value, (member(InputKey, Ordered), profile_get(Profile, InputKey, Value)), Pairs).

objection_cases(Profile, [objection(Ground)]) :-
    profile_get(Profile, objection_ground_claimed, Ground).
objection_cases(Profile, [objection(art21_1), objection(art21_2), objection(art21_6)]) :-
    profile_lacks(Profile, objection_ground_claimed).

objection_answer(Profile, Answer) :-
    objection_cases(Profile, Cases),
    maplist(case_answer(Profile), Cases, Answers),
    combine_answers(Answers, objection_ground_claimed, Answer).

combine_answers(Answers, NamedKey, Combined) :-
    findall(Comply - Exception, member(answer(Comply, _, Exception, _), Answers), Fields),
    sort(Fields, DistinctFields),
    agreement(DistinctFields, Answers, NamedKey, Combined).

agreement([Comply - Exception], Answers, _, answer(Comply, Basis, Exception, Conditions)) :-
    findall(AnswerBasis, member(answer(_, AnswerBasis, _, _), Answers), Bases),
    sort(Bases, DistinctBases),
    shared_basis(DistinctBases, Basis),
    Answers = [answer(_, _, _, Conditions)|_].
agreement([_, _|_], _, NamedKey, answer(indeterminate([NamedKey]), none, none, [])).

shared_basis([Basis], Basis).
shared_basis([_, _|_], none).

profile_answer(Profile, Answer) :-
    profile_lacks(Profile, request_type),
    case_answer(Profile, portability, PortabilityAnswer),
    objection_answer(Profile, ObjectionAnswer),
    case_answer(Profile, automated_decision, AutomatedAnswer),
    combine_answers([PortabilityAnswer, ObjectionAnswer, AutomatedAnswer], request_type, Answer).
profile_answer(Profile, Answer) :-
    profile_get(Profile, request_type, RequestType),
    typed_answer(RequestType, Profile, Answer).

typed_answer(portability, Profile, Answer) :-
    case_answer(Profile, portability, Answer).
typed_answer(objection, Profile, Answer) :-
    objection_answer(Profile, Answer).
typed_answer(automated_decision, Profile, Answer) :-
    case_answer(Profile, automated_decision, Answer).
typed_answer(RequestType, _, answer(need_not_comply, none, none, [])) :-
    sibling_order_request_type(RequestType).

request_exception_verdict(Profile, Verdict) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, Problems),
    verdict_for_problems(Problems, Profile, Verdict).

verdict_for_problems([Problem|Problems], _, gdpr_data_subject_request_verdict(input_problems([Problem|Problems]), none, none, [], [])).
verdict_for_problems([], Profile, gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, [])) :-
    profile_answer(Profile, answer(Comply, Basis, Exception, Conditions)).

request_decision(Profile, Comply) :-
    request_exception_verdict(Profile, gdpr_data_subject_request_verdict(Comply, _, _, _, _)).

request_exception(Profile, Exception) :-
    request_exception_verdict(Profile, gdpr_data_subject_request_verdict(_, _, Exception, _, _)).

decide_request_exception(Profile, request_exception_verdict(Exception, Citations)) :-
    request_exception(Profile, Exception),
    exception_citations(Exception, Citations).

exception_citations(none, []).
exception_citations(Identifier, [Citation]) :-
    exception_rule(Identifier, Citation, _).

request_exception_status(Profile, Status) :-
    decide_request_exception(Profile, request_exception_verdict(Status, _Citations)).

request_exception_checklist(Profile, Items) :-
    decision_cases(Profile, Cases),
    maplist(case_items(Profile), Cases, ItemLists),
    append(ItemLists, Items).

decision_cases(Profile, Cases) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, Problems),
    cases_for_problems(Problems, Profile, Cases).

cases_for_problems([_|_], _, []).
cases_for_problems([], Profile, Cases) :-
    profile_lacks(Profile, request_type),
    objection_cases(Profile, ObjectionCases),
    append([[portability], ObjectionCases, [automated_decision]], Cases).
cases_for_problems([], Profile, Cases) :-
    profile_get(Profile, request_type, RequestType),
    type_cases(RequestType, Profile, Cases).

type_cases(portability, _, [portability]).
type_cases(automated_decision, _, [automated_decision]).
type_cases(objection, Profile, Cases) :-
    objection_cases(Profile, Cases).
type_cases(RequestType, _, []) :-
    sibling_order_request_type(RequestType).

case_items(Profile, RequestCase, [item(engagement(RequestCase), EngagementItemStatus, EngagementCitation), item(suspension(RequestCase), SuspensionItemStatus, SuspensionCitation)|ExceptionItems]) :-
    engagement(RequestCase, _, EngagementCitation, EngagementFormula),
    limb_status(Profile, EngagementFormula, EngagementStatus),
    item_status(EngagementStatus, engagement, EngagementItemStatus),
    suspension_rule(SuspensionCitation, SuspensionFormula),
    limb_status(Profile, SuspensionFormula, SuspensionStatus),
    item_status(SuspensionStatus, suspension, SuspensionItemStatus),
    case_exceptions(RequestCase, ExceptionIdentifiers),
    maplist(exception_item(Profile, RequestCase), ExceptionIdentifiers, ExceptionItems).

exception_item(Profile, RequestCase, Identifier, item(exception(RequestCase, Identifier), ItemStatus, Citation)) :-
    exception_rule(Identifier, Citation, Formula),
    limb_status(Profile, Formula, Status),
    item_status(Status, Identifier, ItemStatus).

item_status(met, _, met).
item_status(unmet, Identifier, unmet(Identifier)).
item_status(open(Absent, Unsure), _, unknown(InputKeys)) :-
    append(Absent, Unsure, InputKeys).

request_exception_decision_resolvable(Profile) :-
    decide_request_exception(Profile, _Verdict).

engaged_portability([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)]).

engaged_automated_decision([attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true)]).

with_attributes(Base, Extra, Profile) :-
    engaged_base(Base, BaseProfile),
    append(BaseProfile, Extra, Profile).

engaged_base(portability, Profile) :-
    engaged_portability(Profile).
engaged_base(automated_decision, Profile) :-
    engaged_automated_decision(Profile).

test(portability_engaged_must_comply_once) :-
    engaged_portability(Profile),
    findall(Comply, request_decision(Profile, Comply), Answers),
    Answers == [must_comply].
test(portability_engaged_exception_none_once) :-
    engaged_portability(Profile),
    findall(Exception, request_exception(Profile, Exception), Answers),
    Answers == [none].
test(portability_engaged_full_verdict) :-
    engaged_portability(Profile),
    request_exception_verdict(Profile, gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [])).
test(portability_public_task_relieves) :-
    with_attributes(portability, [attribute(processing_necessary_for_public_task_or_official_authority, true)], Profile),
    request_exception_verdict(Profile, gdpr_data_subject_request_verdict(need_not_comply, art20_1, art20_3_public_task, [], [])).
test(manifestly_unfounded_carries_the_fee_condition) :-
    with_attributes(portability, [attribute(request_manifestly_unfounded_or_excessive, true)], Profile),
    request_exception_verdict(Profile, gdpr_data_subject_request_verdict(need_not_comply, art20_1, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [])).
test(rights_of_others_unsure_refers) :-
    with_attributes(portability, [attribute(transmission_would_adversely_affect_rights_and_freedoms_of_others, unsure)], Profile),
    request_decision(Profile, needs_legal_review(open_textured(transmission_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_20_4)), [inputs_relied_on([request_type - portability, transmission_would_adversely_affect_rights_and_freedoms_of_others - unsure])])).
test(portability_missing_keys_listed_all) :-
    request_decision([attribute(request_type, portability)], indeterminate([personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means])).
test(portability_not_engaged) :-
    request_exception_verdict([attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, false)], gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).
test(sibling_order_request_type_is_not_engaged_once) :-
    findall(Comply, request_decision([attribute(request_type, access)], Comply), Answers),
    Answers == [need_not_comply].
test(identity_doubts_suspend) :-
    with_attributes(portability, [attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)], Profile),
    request_decision(Profile, suspended(art12_6_identity_not_confirmed)).
test(identity_doubts_suspend_exception_none) :-
    with_attributes(portability, [attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)], Profile),
    request_exception(Profile, none).
test(identity_doubts_with_identity_absent_is_indeterminate) :-
    with_attributes(portability, [attribute(reasonable_doubts_about_identity, true)], Profile),
    request_decision(Profile, indeterminate([identity_confirmed])).
test(legislative_restriction_attested_true_relieves) :-
    with_attributes(portability, [attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(host, now, reason, none)))], Profile),
    request_exception(Profile, art23_legislative_restriction).
test(legislative_restriction_attested_false_must_comply) :-
    with_attributes(portability, [attribute(legislative_restriction_applies_to_the_right, attested(false, attestation(host, now, reason, none)))], Profile),
    request_decision(Profile, must_comply).
test(direct_marketing_objection_is_absolute) :-
    request_exception_verdict([attribute(request_type, objection), attribute(objection_ground_claimed, art21_2), attribute(processing_for_direct_marketing, true), attribute(controller_demonstrates_compelling_legitimate_grounds, true)], gdpr_data_subject_request_verdict(must_comply, art21_2, none, [], [])).
test(particular_situation_unsure_refers) :-
    request_decision([attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, unsure)], needs_legal_review(open_textured(objection_grounds_relate_to_particular_situation, cite(eu_reg_2016_679_art_21_1)), [inputs_relied_on([request_type - objection, objection_ground_claimed - art21_1, objection_grounds_relate_to_particular_situation - unsure])])).
test(compelling_grounds_relieve_art21_1) :-
    request_exception([attribute(request_type, objection), attribute(objection_ground_claimed, art21_1), attribute(processing_based_on_art6_1_e_or_f, true), attribute(objection_grounds_relate_to_particular_situation, true), attribute(controller_demonstrates_compelling_legitimate_grounds, true)], art21_1_compelling_legitimate_grounds).
test(explicit_consent_carries_the_safeguards) :-
    with_attributes(automated_decision, [attribute(data_subject_gave_explicit_consent, true)], Profile),
    request_exception_verdict(Profile, gdpr_data_subject_request_verdict(need_not_comply, art22_1, art22_2_c, [human_intervention, express_point_of_view, contest_decision], [])).
test(special_categories_bar_the_consent_exception) :-
    with_attributes(automated_decision, [attribute(data_subject_gave_explicit_consent, true), attribute(decision_based_on_special_categories, true), attribute(special_category_condition_and_safeguards_met_for_decision, false)], Profile),
    request_decision(Profile, must_comply).
test(special_categories_with_safeguards_absent_is_indeterminate) :-
    with_attributes(automated_decision, [attribute(data_subject_gave_explicit_consent, true), attribute(decision_based_on_special_categories, true)], Profile),
    request_decision(Profile, indeterminate([special_category_condition_and_safeguards_met_for_decision])).
test(authorising_law_attested_relieves_without_conditions) :-
    with_attributes(automated_decision, [attribute(decision_authorised_by_union_or_member_state_law, attested(true, attestation(host, now, reason, none)))], Profile),
    request_exception_verdict(Profile, gdpr_data_subject_request_verdict(need_not_comply, art22_1, art22_2_b, [], [])).
test(unknown_key_is_an_input_problem) :-
    request_decision([attribute(colour, red)], input_problems([unknown_key(colour)])).
test(unknown_key_gives_exception_none) :-
    request_exception([attribute(colour, red)], none).
test(duplicate_key_is_an_input_problem) :-
    request_decision([attribute(request_type, portability), attribute(request_type, objection)], input_problems([duplicate_key(request_type)])).
test(non_list_profile_is_an_input_problem) :-
    request_decision(profile, input_problems([wrong_type(profile)])).
test(absent_request_type_settled_relief_decides) :-
    request_exception_verdict([attribute(request_manifestly_unfounded_or_excessive, true)], gdpr_data_subject_request_verdict(need_not_comply, none, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [])).
test(absent_request_type_different_answers_name_it) :-
    findall(Comply, request_decision([attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true)], Comply), Answers),
    Answers == [indeterminate([request_type])].
test(absent_ground_all_unmet_decides) :-
    request_decision([attribute(request_type, objection), attribute(processing_based_on_art6_1_e_or_f, false), attribute(processing_for_direct_marketing, false), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, false)], need_not_comply).
test(absent_ground_different_answers_name_it) :-
    request_decision([attribute(request_type, objection), attribute(processing_based_on_art6_1_e_or_f, false), attribute(processing_for_direct_marketing, true), attribute(processing_for_research_or_statistics_pursuant_to_art89_1, false)], indeterminate([objection_ground_claimed])).
test(checklist_items_carry_citations) :-
    engaged_portability(Profile),
    request_exception_checklist(Profile, Items),
    member(item(engagement(portability), met, cite(eu_reg_2016_679_art_20_1)), Items).
test(status_projection_names_the_exception) :-
    with_attributes(portability, [attribute(processing_necessary_for_public_task_or_official_authority, true)], Profile),
    request_exception_status(Profile, art20_3_public_task).

test(portability_public_task_is_not_must_comply, fail) :-
    with_attributes(portability, [attribute(processing_necessary_for_public_task_or_official_authority, true)], Profile),
    request_decision(Profile, must_comply).
test(sibling_order_request_type_is_not_indeterminate, fail) :-
    request_decision([attribute(request_type, erasure)], indeterminate(_)).
