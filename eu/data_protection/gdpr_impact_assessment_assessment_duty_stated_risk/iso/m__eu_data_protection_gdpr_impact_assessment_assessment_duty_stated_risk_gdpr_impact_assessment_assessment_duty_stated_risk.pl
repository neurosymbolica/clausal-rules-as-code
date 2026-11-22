% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_gdpr_impact_assessment_assessment_duty_stated_risk, [decide_gdpr_impact_assessment_assessment_duty_stated_risk/2, gdpr_impact_assessment_assessment_duty_stated_risk_status/2, gdpr_impact_assessment_assessment_duty_stated_risk_checklist/2, gdpr_impact_assessment_assessment_duty_stated_risk_decision_resolvable/1, gdpr_impact_assessment_assessment_duty_stated_risk_status_values/1, decide_impact_assessment_duty/2, impact_assessment_officer_advice/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_kernel, [gdpr_impact_assessment_assessment_duty_stated_risk_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_citations, [implements/1]).

gdpr_impact_assessment_assessment_duty_stated_risk_status_values([required, not_required]).

basis_citations(art35_3_a_profiling_with_significant_decisions, [cite(eu_reg_2016_679_art_35_3_a)]).
basis_citations(art35_3_b_large_scale_sensitive_data, [cite(eu_reg_2016_679_art_35_3_b)]).
basis_citations(art35_3_c_public_area_monitoring, [cite(eu_reg_2016_679_art_35_3_c)]).
basis_citations(art35_4_national_list, [cite(eu_reg_2016_679_art_35_4)]).
basis_citations(art35_1_high_risk, [cite(eu_reg_2016_679_art_35_1)]).
basis_citations(art35_10_general_assessment_exemption, [cite(eu_reg_2016_679_art_35_10)]).
basis_citations(art35_5_national_list_exemption, [cite(eu_reg_2016_679_art_35_5)]).
basis_citations(no_requirement_triggered, [cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_35_3_a), cite(eu_reg_2016_679_art_35_3_b), cite(eu_reg_2016_679_art_35_3_c), cite(eu_reg_2016_679_art_35_4)]).

content_citation(description_and_purposes, cite(eu_reg_2016_679_art_35_7_a)).
content_citation(necessity_and_proportionality, cite(eu_reg_2016_679_art_35_7_b)).
content_citation(risk_assessment, cite(eu_reg_2016_679_art_35_7_c)).
content_citation(envisaged_measures, cite(eu_reg_2016_679_art_35_7_d)).

judgement_referral(systematic_and_extensive_evaluation, cite(eu_reg_2016_679_art_35_3_a)).
judgement_referral(decisions_similarly_significantly_affect, cite(eu_reg_2016_679_art_35_3_a)).
judgement_referral(processing_on_large_scale, cite(eu_reg_2016_679_art_35_3_b)).
judgement_referral(monitoring_is_systematic, cite(eu_reg_2016_679_art_35_3_c)).
judgement_referral(likely_high_risk_to_rights_and_freedoms, cite(eu_reg_2016_679_art_35_1)).

duty_slot_keys([automated_evaluation_including_profiling, criminal_offence_data_processed, decisions_based_on_evaluation, decisions_produce_legal_effects, decisions_similarly_significantly_affect, lawful_basis_is_legal_obligation_or_public_task, likely_high_risk_to_rights_and_freedoms, monitoring_is_systematic, processing_on_large_scale, publicly_accessible_area_monitored, special_category_data_processed, systematic_and_extensive_evaluation]).

judgement_keys([decisions_similarly_significantly_affect, likely_high_risk_to_rights_and_freedoms, monitoring_is_systematic, processing_on_large_scale, systematic_and_extensive_evaluation]).

checklist_keys([impact_assessment_carried_out, description_of_processing_and_purposes_present, legitimate_interest_pursued, legitimate_interest_described, necessity_and_proportionality_assessed, risks_to_data_subjects_assessed, envisaged_measures_described]).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

truth_exclusive(true, false, true).
truth_exclusive(false, true, true).
truth_exclusive(true, true, false).
truth_exclusive(false, false, false).

nonempty_truth([], false).
nonempty_truth([_|_], true).

single_truth([], false).
single_truth([_], true).
single_truth([_, _|_], false).

first_of([First|_], First).

polarized(positive, Value, Value).
polarized(negative, true, false).
polarized(negative, false, true).

crisp_leaf(Profile, Key, Polarity, slot(Key, Polarity, absence)) :-
    profile_lacks(Profile, Key).
crisp_leaf(Profile, Key, Polarity, settled(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Given),
    polarized(Polarity, Given, Value).

judgement_leaf(Profile, Key, slot(Key, positive, absence)) :-
    profile_lacks(Profile, Key).
judgement_leaf(Profile, Key, slot(Key, positive, judgement)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, unsure).
judgement_leaf(Profile, Key, settled(true)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, true).
judgement_leaf(Profile, Key, settled(false)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, false).

enabling_leaf(Profile, Key, Polarity, slot(Key, Polarity, cross_reference)) :-
    profile_lacks(Profile, Key).
enabling_leaf(Profile, Key, Polarity, settled(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(Given, _)),
    polarized(Polarity, Given, Value).

blocking_value(Profile, Key, false) :-
    profile_lacks(Profile, Key).
blocking_value(Profile, Key, true) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(true, _)).
blocking_value(Profile, Key, false) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(false, _)).

article_35_3_a_tree(Profile, and([Automated, Based, Systematic, or([Legal, Similar])])) :-
    implements(eu_reg_2016_679_art_35_3_a),
    implements(eu_reg_2016_679_art_4_4),
    crisp_leaf(Profile, automated_evaluation_including_profiling, positive, Automated),
    crisp_leaf(Profile, decisions_based_on_evaluation, positive, Based),
    judgement_leaf(Profile, systematic_and_extensive_evaluation, Systematic),
    crisp_leaf(Profile, decisions_produce_legal_effects, positive, Legal),
    judgement_leaf(Profile, decisions_similarly_significantly_affect, Similar).

article_35_3_b_tree(Profile, and([LargeScale, or([Special, Criminal])])) :-
    implements(eu_reg_2016_679_art_35_3_b),
    implements(eu_reg_2016_679_art_9_1),
    implements(eu_reg_2016_679_art_10),
    judgement_leaf(Profile, processing_on_large_scale, LargeScale),
    crisp_leaf(Profile, special_category_data_processed, positive, Special),
    crisp_leaf(Profile, criminal_offence_data_processed, positive, Criminal).

article_35_3_c_tree(Profile, and([PublicArea, Monitoring, LargeScale])) :-
    implements(eu_reg_2016_679_art_35_3_c),
    crisp_leaf(Profile, publicly_accessible_area_monitored, positive, PublicArea),
    judgement_leaf(Profile, monitoring_is_systematic, Monitoring),
    judgement_leaf(Profile, processing_on_large_scale, LargeScale).

article_35_3_b_or_c_tree(Profile, and([LargeScale, or([or([Special, Criminal]), and([PublicArea, Monitoring])])])) :-
    implements(eu_reg_2016_679_art_35_3_b),
    implements(eu_reg_2016_679_art_35_3_c),
    judgement_leaf(Profile, processing_on_large_scale, LargeScale),
    crisp_leaf(Profile, special_category_data_processed, positive, Special),
    crisp_leaf(Profile, criminal_offence_data_processed, positive, Criminal),
    crisp_leaf(Profile, publicly_accessible_area_monitored, positive, PublicArea),
    judgement_leaf(Profile, monitoring_is_systematic, Monitoring).

article_35_4_node(Profile, settled(OnList)) :-
    implements(eu_reg_2016_679_art_35_4),
    blocking_value(Profile, national_list_requires_assessment, OnList).

article_35_5_node(Profile, settled(Exempt)) :-
    implements(eu_reg_2016_679_art_35_5),
    blocking_value(Profile, national_list_exempts_assessment, Exempt).

article_35_1_node(Profile, and([settled(NotExempt), HighRisk])) :-
    implements(eu_reg_2016_679_art_35_1),
    implements(eu_reg_2016_679_art_35_5),
    blocking_value(Profile, national_list_exempts_assessment, Exempt),
    polarized(negative, Exempt, NotExempt),
    judgement_leaf(Profile, likely_high_risk_to_rights_and_freedoms, HighRisk).

article_35_10_exemption_tree(Profile, and([Lawful, settled(General), NoMemberState])) :-
    implements(eu_reg_2016_679_art_35_10),
    implements(eu_reg_2016_679_art_6_1_c),
    implements(eu_reg_2016_679_art_6_1_e),
    crisp_leaf(Profile, lawful_basis_is_legal_obligation_or_public_task, positive, Lawful),
    blocking_value(Profile, legal_basis_with_general_impact_assessment, General),
    enabling_leaf(Profile, member_state_requires_assessment_despite_general_one, negative, NoMemberState).

article_35_10_inapplicable_tree(Profile, or([NotLawful, settled(NoGeneral), MemberState])) :-
    implements(eu_reg_2016_679_art_35_10),
    implements(eu_reg_2016_679_art_6_1_c),
    implements(eu_reg_2016_679_art_6_1_e),
    crisp_leaf(Profile, lawful_basis_is_legal_obligation_or_public_task, negative, NotLawful),
    blocking_value(Profile, legal_basis_with_general_impact_assessment, General),
    polarized(negative, General, NoGeneral),
    enabling_leaf(Profile, member_state_requires_assessment_despite_general_one, positive, MemberState).

required_tree(Profile, and([Inapplicable, or([National, HighRisk, Profiling, SensitiveOrMonitoring])])) :-
    implements(eu_reg_2016_679_art_35_1),
    implements(eu_reg_2016_679_art_35_10),
    article_35_10_inapplicable_tree(Profile, Inapplicable),
    article_35_4_node(Profile, National),
    article_35_1_node(Profile, HighRisk),
    article_35_3_a_tree(Profile, Profiling),
    article_35_3_b_or_c_tree(Profile, SensitiveOrMonitoring).

node_range(settled(true), _, true, false).
node_range(settled(false), _, false, true).
node_range(slot(Key, Polarity, _), Fixed, CanTrue, CanFalse) :-
    fixed_state(Fixed, Key, State),
    slot_range(State, Polarity, CanTrue, CanFalse).
node_range(and(Children), Fixed, CanTrue, CanFalse) :-
    and_range(Children, Fixed, CanTrue, CanFalse).
node_range(or(Children), Fixed, CanTrue, CanFalse) :-
    or_range(Children, Fixed, CanTrue, CanFalse).

slot_range(free, _, true, true).
slot_range(fixed(Value), Polarity, CanTrue, CanFalse) :-
    polarized(Polarity, Value, Effective),
    node_range(settled(Effective), [], CanTrue, CanFalse).

fixed_state([], _, free).
fixed_state([FixedKey - Value|_], Key, fixed(Value)) :-
    FixedKey == Key.
fixed_state([FixedKey - _|Rest], Key, State) :-
    FixedKey \== Key,
    fixed_state(Rest, Key, State).

and_range([], _, true, false).
and_range([Child|Children], Fixed, CanTrue, CanFalse) :-
    node_range(Child, Fixed, ChildTrue, ChildFalse),
    and_range(Children, Fixed, RestTrue, RestFalse),
    truth_and(ChildTrue, RestTrue, CanTrue),
    truth_or(ChildFalse, RestFalse, CanFalse).

or_range([], _, false, true).
or_range([Child|Children], Fixed, CanTrue, CanFalse) :-
    node_range(Child, Fixed, ChildTrue, ChildFalse),
    or_range(Children, Fixed, RestTrue, RestFalse),
    truth_or(ChildTrue, RestTrue, CanTrue),
    truth_and(ChildFalse, RestFalse, CanFalse).

range_value(true, false, met).
range_value(false, true, unmet).
range_value(true, true, open).

met_truth(met, true).
met_truth(unmet, false).
met_truth(open, false).

pivotal(settled(_), _, _, false).
pivotal(slot(SlotKey, _, _), Key, _, true) :-
    SlotKey == Key.
pivotal(slot(SlotKey, _, _), Key, _, false) :-
    SlotKey \== Key.
pivotal(and(Children), Key, Fixed, Truth) :-
    child_summaries(Children, Key, Fixed, Summaries),
    gate_pivotal(Summaries, and, AnyPivotal, OthersAllow),
    truth_and(AnyPivotal, OthersAllow, Truth).
pivotal(or(Children), Key, Fixed, Truth) :-
    child_summaries(Children, Key, Fixed, Summaries),
    gate_pivotal(Summaries, or, AnyPivotal, OthersAllow),
    truth_and(AnyPivotal, OthersAllow, Truth).

child_summaries([], _, _, []).
child_summaries([Child|Children], Key, Fixed, [child_summary(Pivotal, CanTrue, CanFalse)|Summaries]) :-
    pivotal(Child, Key, Fixed, Pivotal),
    node_range(Child, Fixed, CanTrue, CanFalse),
    child_summaries(Children, Key, Fixed, Summaries).

gate_pivotal([], _, false, true).
gate_pivotal([child_summary(Pivotal, CanTrue, CanFalse)|Summaries], Gate, AnyPivotal, OthersAllow) :-
    gate_pivotal(Summaries, Gate, RestPivotal, RestAllow),
    truth_or(Pivotal, RestPivotal, AnyPivotal),
    noncontrolling(Gate, CanTrue, CanFalse, Allows),
    sibling_allows(Pivotal, Allows, ThisAllows),
    truth_and(ThisAllows, RestAllow, OthersAllow).

noncontrolling(and, CanTrue, _, CanTrue).
noncontrolling(or, _, CanFalse, CanFalse).

sibling_allows(true, _, true).
sibling_allows(false, Allows, Allows).

missing_contents(false, _, _, _, _, _, _, [description_and_purposes, necessity_and_proportionality, risk_assessment, envisaged_measures]) :-
    implements(eu_reg_2016_679_art_35_7_a),
    implements(eu_reg_2016_679_art_35_7_b),
    implements(eu_reg_2016_679_art_35_7_c),
    implements(eu_reg_2016_679_art_35_7_d).
missing_contents(true, Description, InterestPursued, InterestDescribed, Necessity, Risks, Measures, Contents) :-
    implements(eu_reg_2016_679_art_35_7_b),
    implements(eu_reg_2016_679_art_35_7_c),
    implements(eu_reg_2016_679_art_35_7_d),
    description_missing(Description, InterestPursued, InterestDescribed, DescriptionMissing),
    element_missing(Necessity, NecessityMissing),
    element_missing(Risks, RisksMissing),
    element_missing(Measures, MeasuresMissing),
    content_entry(DescriptionMissing, description_and_purposes, First),
    content_entry(NecessityMissing, necessity_and_proportionality, Second),
    content_entry(RisksMissing, risk_assessment, Third),
    content_entry(MeasuresMissing, envisaged_measures, Fourth),
    append([First, Second, Third, Fourth], Contents).

description_missing(false, _, _, true) :-
    implements(eu_reg_2016_679_art_35_7_a).
description_missing(true, true, false, true) :-
    implements(eu_reg_2016_679_art_35_7_a).
description_missing(true, true, true, false) :-
    implements(eu_reg_2016_679_art_35_7_a).
description_missing(true, false, _, false) :-
    implements(eu_reg_2016_679_art_35_7_a).

element_missing(true, false).
element_missing(false, true).

content_entry(true, Content, [Content]).
content_entry(false, _, []).

checklist_base(Profile, Base) :-
    checklist_keys(Keys),
    base_entries(Keys, Profile, Base).

base_entries([], _, []).
base_entries([Key|Keys], Profile, [Key - Choices|Rest]) :-
    key_choices(Profile, Key, Choices),
    base_entries(Keys, Profile, Rest).

key_choices(Profile, Key, [true, false]) :-
    profile_lacks(Profile, Key).
key_choices(Profile, Key, [Value]) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

checklist_completion([], []).
checklist_completion([Key - Choices|Rest], [Key - Value|Values]) :-
    member(Value, Choices),
    checklist_completion(Rest, Values).

checklist_value([_ - Carried, _ - Description, _ - InterestPursued, _ - InterestDescribed, _ - Necessity, _ - Risks, _ - Measures], Contents) :-
    missing_contents(Carried, Description, InterestPursued, InterestDescribed, Necessity, Risks, Measures, Contents).

checklist_outcomes(Base, Outcomes) :-
    findall(Contents, (checklist_completion(Base, Completion), checklist_value(Completion, Contents)), AllContents),
    sort(AllContents, Outcomes).

replace_value([], _, _, []).
replace_value([EntryKey - _|Rest], Key, New, [EntryKey - New|Replaced]) :-
    EntryKey == Key,
    replace_value(Rest, Key, New, Replaced).
replace_value([EntryKey - Value|Rest], Key, New, [EntryKey - Value|Replaced]) :-
    EntryKey \== Key,
    replace_value(Rest, Key, New, Replaced).

completion_holds([], _).
completion_holds([Key - Value|Rest], Completion) :-
    member(Key - Value, Completion),
    completion_holds(Rest, Completion).

checklist_pivotal_completion(Base, Key, Fixed, Completion) :-
    checklist_completion(Base, Completion),
    completion_holds(Fixed, Completion),
    member(Key - true, Completion),
    replace_value(Completion, Key, false, Flipped),
    checklist_value(Completion, Contents),
    checklist_value(Flipped, FlippedContents),
    dif(Contents, FlippedContents).

checklist_pivotal(Base, Key, Fixed, Truth) :-
    findall(witness, checklist_pivotal_completion(Base, Key, Fixed, _), Witnesses),
    nonempty_truth(Witnesses, Truth).

duty_key_behind(Tree, Key, Other, Truth) :-
    pivotal(Tree, Key, [Other - true], WithOtherTrue),
    pivotal(Tree, Key, [Other - false], WithOtherFalse),
    truth_exclusive(WithOtherTrue, WithOtherFalse, OtherFixedValue),
    pivotal(Tree, Other, [Key - true], OtherWithKeyTrue),
    pivotal(Tree, Other, [Key - false], OtherWithKeyFalse),
    truth_and(OtherWithKeyTrue, OtherWithKeyFalse, OtherAlways),
    truth_and(OtherFixedValue, OtherAlways, Truth).

checklist_key_behind(Base, Key, Other, Truth) :-
    findall(Value, (checklist_pivotal_completion(Base, Key, [], Completion), member(Other - Value, Completion)), Values),
    sort(Values, Distinct),
    single_truth(Distinct, OtherFixedValue),
    checklist_pivotal(Base, Other, [Key - true], OtherWithKeyTrue),
    checklist_pivotal(Base, Other, [Key - false], OtherWithKeyFalse),
    truth_and(OtherWithKeyTrue, OtherWithKeyFalse, OtherAlways),
    truth_and(OtherFixedValue, OtherAlways, Truth).

first_free([Key|Keys], All, Behind, Named) :-
    behind_any(Key, All, Behind, Truth),
    free_choice(Truth, Key, Keys, All, Behind, Named).

free_choice(false, Key, _, _, _, Key).
free_choice(true, _, Keys, All, Behind, Named) :-
    first_free(Keys, All, Behind, Named).

behind_any(_, [], _, false).
behind_any(Key, [Other|Others], Behind, Truth) :-
    Other == Key,
    behind_any(Key, Others, Behind, Truth).
behind_any(Key, [Other|Others], Behind, Truth) :-
    Other \== Key,
    call(Behind, Key, Other, OtherTruth),
    behind_rest(OtherTruth, Key, Others, Behind, Truth).

behind_rest(true, _, _, _, true).
behind_rest(false, Key, Others, Behind, Truth) :-
    behind_any(Key, Others, Behind, Truth).

decide_impact_assessment_duty(Profile, Verdict) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems(Profile, Problems),
    duty_after_input_check(Problems, Profile, Verdict).

duty_after_input_check([Problem|Problems], _, impact_assessment_verdict(input_problems([Problem|Problems]), [], [], [], [], [])).
duty_after_input_check([], Profile, Verdict) :-
    required_tree(Profile, Tree),
    node_range(Tree, [], CanTrue, CanFalse),
    checklist_base(Profile, Base),
    checklist_outcomes(Base, Outcomes),
    duty_case(CanTrue, CanFalse, Outcomes, Profile, Tree, Base, Verdict).

duty_case(false, true, _, Profile, _, _, Verdict) :-
    not_required_verdict(Profile, Verdict).
duty_case(true, false, [MissingContents], Profile, _, _, Verdict) :-
    required_verdict(Profile, MissingContents, Verdict).
duty_case(true, false, [_, _|_], Profile, Tree, Base, impact_assessment_verdict(Status, [], [], [], [], [])) :-
    open_status(Profile, Tree, Base, Status).
duty_case(true, true, _, Profile, Tree, Base, impact_assessment_verdict(Status, [], [], [], [], [])) :-
    open_status(Profile, Tree, Base, Status).

not_required_verdict(Profile, impact_assessment_verdict(not_required, [Basis], [], Context, Citations, [])) :-
    implements(eu_reg_2016_679_art_35_1),
    not_required_basis(Profile, Basis),
    basis_citations(Basis, BasisCitations),
    exemption_item_citations(Basis, Profile, ItemCitations),
    append(BasisCitations, ItemCitations, Citations),
    final_context(Profile, Context).

required_verdict(Profile, MissingContents, impact_assessment_verdict(required, [Basis], MissingContents, Context, Citations, [])) :-
    implements(eu_reg_2016_679_art_35_1),
    required_basis(Profile, Basis),
    basis_citations(Basis, BasisCitations),
    requirement_item_citations(Basis, Profile, ItemCitations),
    content_citations(MissingContents, ContentCitations),
    append([BasisCitations, ItemCitations, ContentCitations], Citations),
    final_context(Profile, Context).

content_citations([], []).
content_citations([Content|Contents], [Citation|Citations]) :-
    content_citation(Content, Citation),
    content_citations(Contents, Citations).

required_basis(Profile, Basis) :-
    article_35_3_a_tree(Profile, Profiling),
    article_35_3_b_tree(Profile, Sensitive),
    article_35_3_c_tree(Profile, Monitoring),
    article_35_4_node(Profile, National),
    article_35_1_node(Profile, HighRisk),
    first_met_basis([art35_3_a_profiling_with_significant_decisions - Profiling, art35_3_b_large_scale_sensitive_data - Sensitive, art35_3_c_public_area_monitoring - Monitoring, art35_4_national_list - National, art35_1_high_risk - HighRisk], Basis).

first_met_basis([Candidate - Tree|Rest], Basis) :-
    node_range(Tree, [], CanTrue, CanFalse),
    range_value(CanTrue, CanFalse, Value),
    met_truth(Value, Met),
    take_basis(Met, Candidate, Rest, Basis).

take_basis(true, Candidate, _, Candidate).
take_basis(false, _, Rest, Basis) :-
    first_met_basis(Rest, Basis).

not_required_basis(Profile, Basis) :-
    article_35_10_exemption_tree(Profile, Exemption),
    node_range(Exemption, [], CanTrue, CanFalse),
    range_value(CanTrue, CanFalse, Value),
    met_truth(Value, GeneralMet),
    blocking_value(Profile, national_list_exempts_assessment, ListExempts),
    not_required_basis_choice(GeneralMet, ListExempts, Basis).

not_required_basis_choice(true, _, art35_10_general_assessment_exemption) :-
    implements(eu_reg_2016_679_art_35_10).
not_required_basis_choice(false, true, art35_5_national_list_exemption) :-
    implements(eu_reg_2016_679_art_35_5).
not_required_basis_choice(false, false, no_requirement_triggered) :-
    implements(eu_reg_2016_679_art_35_1).

outside_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
outside_state(Profile, Key, attested(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(Value, _)).

read_item(Profile, BooleanKey, ItemKey, Read) :-
    outside_state(Profile, BooleanKey, State),
    item_when(State, Profile, ItemKey, Read).

item_when(absent, _, _, none).
item_when(attested(false), _, _, none).
item_when(attested(true), Profile, ItemKey, Read) :-
    item_presence(Profile, ItemKey, Read).

item_presence(Profile, ItemKey, none) :-
    profile_lacks(Profile, ItemKey).
item_presence(Profile, ItemKey, item(Value)) :-
    profile_has(Profile, ItemKey),
    profile_get(Profile, ItemKey, Value).

item_citations(none, []).
item_citations(item(attested(national_list_item(_, Identifier), _)), [cite(Identifier)]).

requirement_item_citations(art35_4_national_list, Profile, Citations) :-
    implements(eu_reg_2016_679_art_35_4),
    read_item(Profile, national_list_requires_assessment, national_list_requires_item, Read),
    item_citations(Read, Citations).
requirement_item_citations(Basis, _, []) :-
    dif(Basis, art35_4_national_list).

exemption_item_citations(art35_5_national_list_exemption, Profile, Citations) :-
    implements(eu_reg_2016_679_art_35_5),
    read_item(Profile, national_list_exempts_assessment, national_list_exempts_item, Read),
    item_citations(Read, Citations).
exemption_item_citations(Basis, _, []) :-
    dif(Basis, art35_5_national_list_exemption).

final_context(Profile, Context) :-
    blocking_context(Profile, legal_basis_with_general_impact_assessment, General),
    enabling_context(Profile, member_state_requires_assessment_despite_general_one, MemberState),
    blocking_context(Profile, national_list_exempts_assessment, Exempts),
    item_context(Profile, national_list_exempts_assessment, national_list_exempts_item, ExemptItem),
    blocking_context(Profile, national_list_requires_assessment, Requires),
    item_context(Profile, national_list_requires_assessment, national_list_requires_item, RequireItem),
    judgement_pairs(Profile, Pairs),
    append([General, MemberState, Exempts, ExemptItem, Requires, RequireItem, [inputs_relied_on(Pairs)]], Context).

blocking_context(Profile, Key, [outside_fact(Key, absent)]) :-
    profile_lacks(Profile, Key).
blocking_context(Profile, Key, [outside_fact(Key, Value)]) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

enabling_context(Profile, Key, []) :-
    profile_lacks(Profile, Key).
enabling_context(Profile, Key, [outside_fact(Key, Value)]) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

item_context(Profile, BooleanKey, ItemKey, Items) :-
    read_item(Profile, BooleanKey, ItemKey, Read),
    item_context_items(Read, ItemKey, Items).

item_context_items(none, _, []).
item_context_items(item(Value), ItemKey, [outside_fact(ItemKey, Value)]).

judgement_pairs(Profile, Pairs) :-
    judgement_keys(Keys),
    present_pairs(Keys, Profile, Pairs).

present_pairs([], _, []).
present_pairs([Key|Keys], Profile, Pairs) :-
    key_pairs(Profile, Key, Entry),
    present_pairs(Keys, Profile, Rest),
    append(Entry, Rest, Pairs).

key_pairs(Profile, Key, []) :-
    profile_lacks(Profile, Key).
key_pairs(Profile, Key, [Key - Value]) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

cross_reference_pairs(Profile, Pairs) :-
    present_pairs([decisions_similarly_significantly_affect, likely_high_risk_to_rights_and_freedoms], Profile, Before),
    present_pairs([monitoring_is_systematic, processing_on_large_scale, systematic_and_extensive_evaluation], Profile, After),
    append(Before, [member_state_requires_assessment_despite_general_one - absent|After], Pairs).

open_status(Profile, Tree, Base, Status) :-
    duty_slot_keys(Keys),
    findall(Key, (member(Key, Keys), profile_lacks(Profile, Key), pivotal(Tree, Key, [], true)), Mattering),
    open_status_from_duty_keys(Mattering, Profile, Tree, Base, Status).

open_status_from_duty_keys([Key|Keys], _, Tree, _, indeterminate([Named])) :-
    first_free([Key|Keys], [Key|Keys], duty_key_behind(Tree), Named).
open_status_from_duty_keys([], Profile, Tree, Base, Status) :-
    findall(Key, (member(Key - [true, false], Base), checklist_pivotal(Base, Key, [], true)), Mattering),
    open_status_from_checklist_keys(Mattering, Profile, Tree, Base, Status).

open_status_from_checklist_keys([Key|Keys], _, _, Base, indeterminate([Named])) :-
    first_free([Key|Keys], [Key|Keys], checklist_key_behind(Base), Named).
open_status_from_checklist_keys([], Profile, Tree, _, Status) :-
    member_state_matters(Profile, Tree, Matters),
    referral_status(Matters, Profile, Tree, Status).

member_state_matters(Profile, Tree, Matters) :-
    profile_lacks(Profile, member_state_requires_assessment_despite_general_one),
    pivotal(Tree, member_state_requires_assessment_despite_general_one, [], Matters).
member_state_matters(Profile, _, false) :-
    profile_has(Profile, member_state_requires_assessment_despite_general_one).

referral_status(true, Profile, _, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_35_10), cite(member_state_decision_requiring_impact_assessment_before_processing)), [resolution(cite(member_state_decision_requiring_impact_assessment_before_processing), not_attempted), inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2016_679_art_35_10),
    cross_reference_pairs(Profile, Pairs).
referral_status(false, Profile, Tree, needs_legal_review(open_textured(Judgement, Citation), [inputs_relied_on(Pairs)])) :-
    judgement_keys(Keys),
    findall(Key, (member(Key, Keys), profile_has(Profile, Key), profile_get(Profile, Key, unsure), pivotal(Tree, Key, [], true)), Unsure),
    first_of(Unsure, Judgement),
    judgement_referral(Judgement, Citation),
    judgement_pairs(Profile, Pairs).

impact_assessment_officer_advice(Profile, Verdict) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems(Profile, Problems),
    officer_after_input_check(Problems, Profile, Verdict).

officer_after_input_check([Problem|Problems], _, officer_advice_verdict(input_problems([Problem|Problems]), [])).
officer_after_input_check([], Profile, Verdict) :-
    crisp_state(Profile, impact_assessment_carried_out, Carried),
    crisp_state(Profile, data_protection_officer_designated, Designated),
    crisp_state(Profile, data_protection_officer_advice_sought, Sought),
    officer_ladder(Carried, Designated, Sought, Verdict).

crisp_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
crisp_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

officer_ladder(false, _, _, officer_advice_verdict(not_applicable, [cite(eu_reg_2016_679_art_35_2)])) :-
    implements(eu_reg_2016_679_art_35_2).
officer_ladder(true, false, _, officer_advice_verdict(not_applicable, [cite(eu_reg_2016_679_art_35_2)])) :-
    implements(eu_reg_2016_679_art_35_2).
officer_ladder(absent, false, _, officer_advice_verdict(not_applicable, [cite(eu_reg_2016_679_art_35_2)])) :-
    implements(eu_reg_2016_679_art_35_2).
officer_ladder(absent, true, _, officer_advice_verdict(indeterminate([impact_assessment_carried_out]), [])).
officer_ladder(absent, absent, _, officer_advice_verdict(indeterminate([impact_assessment_carried_out]), [])).
officer_ladder(true, absent, _, officer_advice_verdict(indeterminate([data_protection_officer_designated]), [])).
officer_ladder(true, true, true, officer_advice_verdict(met, [cite(eu_reg_2016_679_art_35_2)])) :-
    implements(eu_reg_2016_679_art_35_2).
officer_ladder(true, true, false, officer_advice_verdict(not_met, [cite(eu_reg_2016_679_art_35_2)])) :-
    implements(eu_reg_2016_679_art_35_2).
officer_ladder(true, true, absent, officer_advice_verdict(indeterminate([data_protection_officer_advice_sought]), [])).

decide_gdpr_impact_assessment_assessment_duty_stated_risk(Profile, gdpr_impact_assessment_assessment_duty_stated_risk_verdict(Status, Citations)) :-
    decide_impact_assessment_duty(Profile, impact_assessment_verdict(Status, _, _, _, Citations, _)).

gdpr_impact_assessment_assessment_duty_stated_risk_status(Profile, Status) :-
    decide_gdpr_impact_assessment_assessment_duty_stated_risk(Profile, gdpr_impact_assessment_assessment_duty_stated_risk_verdict(Status, _Citations)).

gdpr_impact_assessment_assessment_duty_stated_risk_checklist(Profile, Items) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems(Profile, Problems),
    checklist_after_input_check(Problems, Profile, Items).

checklist_after_input_check([_|_], _, []).
checklist_after_input_check([], Profile, [ProfilingItem, SensitiveItem, MonitoringItem, NationalItem, ExemptItem, HighRiskItem, GeneralItem]) :-
    article_35_3_a_tree(Profile, Profiling),
    article_35_3_b_tree(Profile, Sensitive),
    article_35_3_c_tree(Profile, Monitoring),
    article_35_4_node(Profile, National),
    article_35_5_node(Profile, Exempt),
    article_35_1_node(Profile, HighRisk),
    article_35_10_exemption_tree(Profile, General),
    limb_item(article_35_3_a, Profiling, cite(eu_reg_2016_679_art_35_3_a), ProfilingItem),
    limb_item(article_35_3_b, Sensitive, cite(eu_reg_2016_679_art_35_3_b), SensitiveItem),
    limb_item(article_35_3_c, Monitoring, cite(eu_reg_2016_679_art_35_3_c), MonitoringItem),
    limb_item(article_35_4, National, cite(eu_reg_2016_679_art_35_4), NationalItem),
    limb_item(article_35_5, Exempt, cite(eu_reg_2016_679_art_35_5), ExemptItem),
    limb_item(article_35_1, HighRisk, cite(eu_reg_2016_679_art_35_1), HighRiskItem),
    limb_item(article_35_10, General, cite(eu_reg_2016_679_art_35_10), GeneralItem).

limb_item(Identifier, Tree, Citation, item(Identifier, Status, Citation)) :-
    node_range(Tree, [], CanTrue, CanFalse),
    range_value(CanTrue, CanFalse, Status).

gdpr_impact_assessment_assessment_duty_stated_risk_decision_resolvable(Profile) :-
    decide_impact_assessment_duty(Profile, _Verdict).

test(profiling_case_is_required_with_all_contents_missing) :-
    decide_impact_assessment_duty([attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)], Verdict),
    Verdict = impact_assessment_verdict(required, [art35_3_a_profiling_with_significant_decisions], [description_and_purposes, necessity_and_proportionality, risk_assessment, envisaged_measures], [outside_fact(legal_basis_with_general_impact_assessment, absent), outside_fact(national_list_exempts_assessment, absent), outside_fact(national_list_requires_assessment, absent), inputs_relied_on([likely_high_risk_to_rights_and_freedoms - false, systematic_and_extensive_evaluation - true])], Citations, []),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(eu_reg_2016_679_art_35_3_a), cite(eu_reg_2016_679_art_35_7_a), cite(eu_reg_2016_679_art_35_7_b), cite(eu_reg_2016_679_art_35_7_c), cite(eu_reg_2016_679_art_35_7_d)], Expected),
    Sorted == Expected.
test(no_trigger_is_not_required) :-
    decide_impact_assessment_duty([attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false)], Verdict),
    Verdict = impact_assessment_verdict(not_required, [no_requirement_triggered], [], [outside_fact(legal_basis_with_general_impact_assessment, absent), outside_fact(national_list_exempts_assessment, absent), outside_fact(national_list_requires_assessment, absent), inputs_relied_on([likely_high_risk_to_rights_and_freedoms - false, processing_on_large_scale - false])], Citations, []),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_35_3_a), cite(eu_reg_2016_679_art_35_3_b), cite(eu_reg_2016_679_art_35_3_c), cite(eu_reg_2016_679_art_35_4)], Expected),
    Sorted == Expected.
test(a_silent_profile_names_the_first_duty_key) :-
    decide_impact_assessment_duty([attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)], impact_assessment_verdict(indeterminate([automated_evaluation_including_profiling]), [], [], [], [], [])).
test(the_general_assessment_exemption_outranks_profiling) :-
    decide_impact_assessment_duty([attribute(lawful_basis_is_legal_obligation_or_public_task, true), attribute(legal_basis_with_general_impact_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(member_state_requires_assessment_despite_general_one, attested(false, attestation(host, at_time, reason, none))), attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(likely_high_risk_to_rights_and_freedoms, false)], impact_assessment_verdict(not_required, [art35_10_general_assessment_exemption], [], [outside_fact(legal_basis_with_general_impact_assessment, attested(true, attestation(host, at_time, reason, none))), outside_fact(member_state_requires_assessment_despite_general_one, attested(false, attestation(host, at_time, reason, none))), outside_fact(national_list_exempts_assessment, absent), outside_fact(national_list_requires_assessment, absent), inputs_relied_on([likely_high_risk_to_rights_and_freedoms - false, systematic_and_extensive_evaluation - true])], [cite(eu_reg_2016_679_art_35_10)], [])).
test(an_absent_member_state_decision_is_referred) :-
    decide_impact_assessment_duty([attribute(lawful_basis_is_legal_obligation_or_public_task, true), attribute(legal_basis_with_general_impact_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)], impact_assessment_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_35_10), cite(member_state_decision_requiring_impact_assessment_before_processing)), [resolution(cite(member_state_decision_requiring_impact_assessment_before_processing), not_attempted), inputs_relied_on([likely_high_risk_to_rights_and_freedoms - false, member_state_requires_assessment_despite_general_one - absent, systematic_and_extensive_evaluation - true])]), [], [], [], [], [])).
test(an_unsure_large_scale_is_referred) :-
    decide_impact_assessment_duty([attribute(processing_on_large_scale, unsure), attribute(special_category_data_processed, true), attribute(automated_evaluation_including_profiling, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)], impact_assessment_verdict(needs_legal_review(open_textured(processing_on_large_scale, cite(eu_reg_2016_679_art_35_3_b)), [inputs_relied_on([likely_high_risk_to_rights_and_freedoms - false, processing_on_large_scale - unsure])]), [], [], [], [], [])).
test(a_national_list_item_is_cited) :-
    decide_impact_assessment_duty([attribute(national_list_requires_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(national_list_requires_item, attested(national_list_item(ie_dpc, ie_dpc_35_4_nr_3), attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false), attribute(impact_assessment_carried_out, true), attribute(description_of_processing_and_purposes_present, true), attribute(legitimate_interest_pursued, false), attribute(necessity_and_proportionality_assessed, true), attribute(risks_to_data_subjects_assessed, true), attribute(envisaged_measures_described, true)], Verdict),
    Verdict = impact_assessment_verdict(required, [art35_4_national_list], [], [outside_fact(legal_basis_with_general_impact_assessment, absent), outside_fact(national_list_exempts_assessment, absent), outside_fact(national_list_requires_assessment, attested(true, attestation(host, at_time, reason, none))), outside_fact(national_list_requires_item, attested(national_list_item(ie_dpc, ie_dpc_35_4_nr_3), attestation(host, at_time, reason, none))), inputs_relied_on([likely_high_risk_to_rights_and_freedoms - false, processing_on_large_scale - false])], Citations, []),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(eu_reg_2016_679_art_35_4), cite(ie_dpc_35_4_nr_3)], Expected),
    Sorted == Expected.
test(an_exemption_list_item_is_cited) :-
    decide_impact_assessment_duty([attribute(national_list_exempts_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(national_list_exempts_item, attested(national_list_item(fr_cnil, fr_cnil_35_5_list), attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, true), attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false)], Verdict),
    Verdict = impact_assessment_verdict(not_required, [art35_5_national_list_exemption], [], [outside_fact(legal_basis_with_general_impact_assessment, absent), outside_fact(national_list_exempts_assessment, attested(true, attestation(host, at_time, reason, none))), outside_fact(national_list_exempts_item, attested(national_list_item(fr_cnil, fr_cnil_35_5_list), attestation(host, at_time, reason, none))), outside_fact(national_list_requires_assessment, absent), inputs_relied_on([likely_high_risk_to_rights_and_freedoms - true, processing_on_large_scale - false])], Citations, []),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(eu_reg_2016_679_art_35_5), cite(fr_cnil_35_5_list)], Expected),
    Sorted == Expected.
test(legitimate_interest_pursued_is_named_before_its_description) :-
    decide_impact_assessment_duty([attribute(national_list_requires_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, true), attribute(description_of_processing_and_purposes_present, true), attribute(necessity_and_proportionality_assessed, true), attribute(risks_to_data_subjects_assessed, true), attribute(envisaged_measures_described, true)], impact_assessment_verdict(indeterminate([legitimate_interest_pursued]), [], [], [], [], [])).
test(an_absent_carried_out_key_is_named) :-
    decide_impact_assessment_duty([attribute(national_list_requires_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, false)], impact_assessment_verdict(indeterminate([impact_assessment_carried_out]), [], [], [], [], [])).
test(an_input_problem_comes_first) :-
    decide_impact_assessment_duty([attribute(colour, red)], impact_assessment_verdict(input_problems([unknown_key(colour)]), [], [], [], [], [])).
test(entry_a_gives_one_solution) :-
    findall(Verdict, decide_impact_assessment_duty([attribute(likely_high_risk_to_rights_and_freedoms, false)], Verdict), Verdicts),
    length(Verdicts, 1).
test(an_unread_key_changes_no_answer) :-
    decide_impact_assessment_duty([attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false)], Verdict),
    decide_impact_assessment_duty([attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(uses_new_technologies, true), attribute(vulnerable_data_subjects, unsure), attribute(member_state_requires_prior_authorisation, attested(true, attestation(host, at_time, reason, none)))], Verdict).
test(officer_advice_sought_is_met) :-
    impact_assessment_officer_advice([attribute(impact_assessment_carried_out, true), attribute(data_protection_officer_designated, true), attribute(data_protection_officer_advice_sought, true)], officer_advice_verdict(met, [cite(eu_reg_2016_679_art_35_2)])).
test(officer_advice_not_sought_is_not_met) :-
    impact_assessment_officer_advice([attribute(impact_assessment_carried_out, true), attribute(data_protection_officer_designated, true), attribute(data_protection_officer_advice_sought, false)], officer_advice_verdict(not_met, [cite(eu_reg_2016_679_art_35_2)])).
test(no_officer_is_not_applicable) :-
    impact_assessment_officer_advice([attribute(data_protection_officer_designated, false)], officer_advice_verdict(not_applicable, [cite(eu_reg_2016_679_art_35_2)])).
test(a_silent_officer_profile_names_the_carried_out_key) :-
    impact_assessment_officer_advice([], officer_advice_verdict(indeterminate([impact_assessment_carried_out]), [])).
test(the_designation_is_named_next) :-
    impact_assessment_officer_advice([attribute(impact_assessment_carried_out, true)], officer_advice_verdict(indeterminate([data_protection_officer_designated]), [])).
test(the_advice_is_named_last) :-
    impact_assessment_officer_advice([attribute(impact_assessment_carried_out, true), attribute(data_protection_officer_designated, true)], officer_advice_verdict(indeterminate([data_protection_officer_advice_sought]), [])).
test(officer_input_problem_comes_first) :-
    impact_assessment_officer_advice([attribute(data_protection_officer_designated, unsure)], officer_advice_verdict(input_problems([wrong_type(data_protection_officer_designated)]), [])).
test(entry_o_gives_one_solution) :-
    findall(Verdict, impact_assessment_officer_advice([attribute(impact_assessment_carried_out, false)], Verdict), Verdicts),
    length(Verdicts, 1).
test(the_status_projection_reads_entry_a) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_status([attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false)], not_required).
test(the_checklist_carries_a_cite_per_limb) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_checklist([attribute(automated_evaluation_including_profiling, false)], Items),
    member(item(article_35_3_a, unmet, cite(eu_reg_2016_679_art_35_3_a)), Items),
    length(Items, 7).

test(profiling_case_is_not_not_required, fail) :-
    decide_impact_assessment_duty([attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)], impact_assessment_verdict(not_required, _, _, _, _, _)).
test(a_silent_profile_is_not_final, fail) :-
    decide_impact_assessment_duty([attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)], impact_assessment_verdict(not_required, _, _, _, _, _)).
test(an_absent_member_state_decision_is_not_required, fail) :-
    decide_impact_assessment_duty([attribute(lawful_basis_is_legal_obligation_or_public_task, true), attribute(legal_basis_with_general_impact_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)], impact_assessment_verdict(required, _, _, _, _, _)).
test(officer_advice_not_sought_is_not_met_only, fail) :-
    impact_assessment_officer_advice([attribute(impact_assessment_carried_out, true), attribute(data_protection_officer_designated, true), attribute(data_protection_officer_advice_sought, false)], officer_advice_verdict(met, _)).
