% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_penalties_dora_penalties, [administrative_penalty_rules_required/3, minimum_powers/2, penalty_decision_safeguards/2, circumstances_to_take_into_account/2, criminal_penalty_liaison_duties/2, decide_dora_penalties/2, dora_penalties_status/2, dora_penalties_checklist/2, dora_penalties_decision_resolvable/1, dora_penalties_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_penalties_kernel, [dora_penalties_input_problems/2]).
:- use_module(m__eu_dora_penalties_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

dora_penalties_status_values([required, not_required_criminal_penalties, indeterminate, input_problems]).

supervisory_powers([power(supervisory, access_to_documents_and_data, cite(eu_reg_2022_2554_art_50_2_a)), power(supervisory, on_site_inspections_and_investigations, cite(eu_reg_2022_2554_art_50_2_b)), power(supervisory, require_corrective_and_remedial_measures, cite(eu_reg_2022_2554_art_50_2_c))]).

penalty_powers(true, [power(penalty, cease_and_desist_order, cite(eu_reg_2022_2554_art_50_4_a)), power(penalty, cessation_of_practice_or_conduct, cite(eu_reg_2022_2554_art_50_4_b)), power(penalty, measures_to_ensure_continued_compliance, cite(eu_reg_2022_2554_art_50_4_c)), power(penalty, require_data_traffic_records, cite(eu_reg_2022_2554_art_50_4_d)), power(penalty, public_notice, cite(eu_reg_2022_2554_art_50_4_e))]).
penalty_powers(false, [power(penalty, cease_and_desist_order, cite(eu_reg_2022_2554_art_50_4_a)), power(penalty, cessation_of_practice_or_conduct, cite(eu_reg_2022_2554_art_50_4_b)), power(penalty, measures_to_ensure_continued_compliance, cite(eu_reg_2022_2554_art_50_4_c)), power(penalty, public_notice, cite(eu_reg_2022_2554_art_50_4_e))]).

extension_powers(true, [power(extension, management_body_and_responsible_individuals, cite(eu_reg_2022_2554_art_50_5))]).
extension_powers(false, []).

decision_safeguards(true, [properly_reasoned(cite(eu_reg_2022_2554_art_50_6)), right_of_appeal(cite(eu_reg_2022_2554_art_50_6))]).
decision_safeguards(false, []).

liaison_duties(true, [receive_criminal_proceedings_information(cite(eu_reg_2022_2554_art_52_2)), provide_information_to_authorities_and_esas(cite(eu_reg_2022_2554_art_52_2))]).
liaison_duties(false, []).

always_taken_circumstance(circumstance(intent_or_negligence, cite(eu_reg_2022_2554_art_51_2))).

judgement_keys([breach_materiality_gravity_duration_relevant, degree_of_responsibility_relevant, financial_strength_relevant, profits_gained_or_losses_avoided_relevant, third_party_losses_relevant, cooperation_with_authority_relevant, previous_breaches_relevant]).

circumstance_point(breach_materiality_gravity_duration_relevant, materiality_gravity_and_duration, cite(eu_reg_2022_2554_art_51_2_a)).
circumstance_point(degree_of_responsibility_relevant, degree_of_responsibility, cite(eu_reg_2022_2554_art_51_2_b)).
circumstance_point(financial_strength_relevant, financial_strength, cite(eu_reg_2022_2554_art_51_2_c)).
circumstance_point(profits_gained_or_losses_avoided_relevant, profits_gained_or_losses_avoided, cite(eu_reg_2022_2554_art_51_2_d)).
circumstance_point(third_party_losses_relevant, losses_for_third_parties, cite(eu_reg_2022_2554_art_51_2_e)).
circumstance_point(cooperation_with_authority_relevant, cooperation_with_competent_authority, cite(eu_reg_2022_2554_art_51_2_f)).
circumstance_point(previous_breaches_relevant, previous_breaches, cite(eu_reg_2022_2554_art_51_2_g)).

key_value(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_value(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

key_pair(Profile, Key, Key - Value) :-
    key_value(Profile, Key, Value).

administrative_penalty_rules_required(Profile, Result, Citations) :-
    dora_penalties_input_problems(Profile, Problems),
    rules_answer(Problems, Profile, Result, Citations).

rules_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
rules_answer([], Profile, Result, Citations) :-
    key_value(Profile, breach_subject_to_criminal_penalties_under_national_law, CriminalPenalties),
    rules_by_criminal_penalties(CriminalPenalties, Profile, Result, Citations).

rules_by_criminal_penalties(absent, _, indeterminate([breach_subject_to_criminal_penalties_under_national_law]), []).
rules_by_criminal_penalties(false, _, required, [cite(eu_reg_2022_2554_art_50_3)]) :-
    implements(eu_reg_2022_2554_art_50_3).
rules_by_criminal_penalties(true, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_52_1),
    key_value(Profile, member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, Choice),
    rules_by_choice(Choice, Result, Citations).

rules_by_choice(absent, indeterminate([member_state_chose_no_administrative_rules_for_criminally_penalised_breaches]), []).
rules_by_choice(true, not_required_criminal_penalties, [cite(eu_reg_2022_2554_art_52_1)]) :-
    implements(eu_reg_2022_2554_art_52_1).
rules_by_choice(false, required, [cite(eu_reg_2022_2554_art_50_3), cite(eu_reg_2022_2554_art_52_1)]) :-
    implements(eu_reg_2022_2554_art_50_3).

minimum_powers(Profile, Powers) :-
    dora_penalties_input_problems(Profile, Problems),
    powers_answer(Problems, Profile, Powers).

powers_answer([Problem|Problems], _, input_problems([Problem|Problems])).
powers_answer([], Profile, Powers) :-
    key_value(Profile, breach_subject_to_criminal_penalties_under_national_law, CriminalPenalties),
    key_value(Profile, member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, Choice),
    option_state(CriminalPenalties, Choice, OptionState),
    powers_by_option(OptionState, Profile, Powers).

option_state(false, _, does_not_apply) :-
    implements(eu_reg_2022_2554_art_52_1).
option_state(true, false, does_not_apply) :-
    implements(eu_reg_2022_2554_art_52_1).
option_state(absent, false, does_not_apply) :-
    implements(eu_reg_2022_2554_art_52_1).
option_state(absent, true, missing(breach_subject_to_criminal_penalties_under_national_law)).
option_state(absent, absent, missing(breach_subject_to_criminal_penalties_under_national_law)).
option_state(true, absent, missing(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches)).
option_state(true, true, applies) :-
    implements(eu_reg_2022_2554_art_52_1).

powers_by_option(missing(Key), _, indeterminate([Key])).
powers_by_option(applies, Profile, Powers) :-
    implements(eu_reg_2022_2554_art_52_1),
    key_value(Profile, measures_applied_to_legal_person, LegalPerson),
    powers_by_legal_person(LegalPerson, [], Powers).
powers_by_option(does_not_apply, Profile, Powers) :-
    implements(eu_reg_2022_2554_art_50_3),
    implements(eu_reg_2022_2554_art_51_1),
    key_value(Profile, national_law_permits_requiring_data_traffic_records, DataTrafficRecords),
    powers_by_data_traffic_records(DataTrafficRecords, Profile, Powers).

powers_by_data_traffic_records(absent, _, indeterminate([national_law_permits_requiring_data_traffic_records])).
powers_by_data_traffic_records(DataTrafficRecords, Profile, Powers) :-
    implements(eu_reg_2022_2554_art_50_4_d),
    penalty_powers(DataTrafficRecords, PenaltyPowers),
    key_value(Profile, measures_applied_to_legal_person, LegalPerson),
    powers_by_legal_person(LegalPerson, PenaltyPowers, Powers).

powers_by_legal_person(absent, _, indeterminate([measures_applied_to_legal_person])).
powers_by_legal_person(LegalPerson, PenaltyPowers, Powers) :-
    implements(eu_reg_2022_2554_art_50_1),
    implements(eu_reg_2022_2554_art_50_5),
    extension_powers(LegalPerson, ExtensionPowers),
    supervisory_powers(SupervisoryPowers),
    append([SupervisoryPowers, PenaltyPowers, ExtensionPowers], Powers).

penalty_decision_safeguards(Profile, Safeguards) :-
    dora_penalties_input_problems(Profile, Problems),
    safeguards_answer(Problems, Profile, Safeguards).

safeguards_answer([Problem|Problems], _, input_problems([Problem|Problems])).
safeguards_answer([], Profile, Safeguards) :-
    key_value(Profile, decision_imposes_art_50_2_c_measure, PointCMeasure),
    safeguards_by_measure(PointCMeasure, Safeguards).

safeguards_by_measure(absent, indeterminate([decision_imposes_art_50_2_c_measure])).
safeguards_by_measure(PointCMeasure, Safeguards) :-
    implements(eu_reg_2022_2554_art_50_6),
    decision_safeguards(PointCMeasure, Safeguards).

circumstances_to_take_into_account(Profile, Circumstances) :-
    dora_penalties_input_problems(Profile, Problems),
    circumstances_answer(Problems, Profile, Circumstances).

circumstances_answer([Problem|Problems], _, input_problems([Problem|Problems])).
circumstances_answer([], Profile, Circumstances) :-
    judgement_keys(Keys),
    maplist(key_pair(Profile), Keys, Pairs),
    first_with_state(Pairs, absent, AbsentKey),
    circumstances_by_absent(AbsentKey, Pairs, Circumstances).

first_with_state([], _, none).
first_with_state([Key - State|_], State, found(Key)).
first_with_state([_ - Value|Pairs], State, Found) :-
    dif(Value, State),
    first_with_state(Pairs, State, Found).

circumstances_by_absent(found(Key), _, indeterminate([Key])).
circumstances_by_absent(none, Pairs, Circumstances) :-
    first_with_state(Pairs, unsure, UnsureKey),
    circumstances_by_unsure(UnsureKey, Pairs, Circumstances).

circumstances_by_unsure(found(Key), Pairs, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    implements(eu_reg_2022_2554_art_51_2),
    circumstance_point(Key, _, Citation).
circumstances_by_unsure(none, Pairs, [AlwaysTaken|Listed]) :-
    implements(eu_reg_2022_2554_art_51_2),
    always_taken_circumstance(AlwaysTaken),
    listed_circumstances(Pairs, Listed).

listed_circumstances([], []).
listed_circumstances([Key - true|Pairs], [circumstance(Circumstance, Citation)|Listed]) :-
    implements(eu_reg_2022_2554_art_51_2),
    circumstance_point(Key, Circumstance, Citation),
    listed_circumstances(Pairs, Listed).
listed_circumstances([_ - false|Pairs], Listed) :-
    implements(eu_reg_2022_2554_art_51_2),
    listed_circumstances(Pairs, Listed).

criminal_penalty_liaison_duties(Profile, Duties) :-
    dora_penalties_input_problems(Profile, Problems),
    duties_answer(Problems, Profile, Duties).

duties_answer([Problem|Problems], _, input_problems([Problem|Problems])).
duties_answer([], Profile, Duties) :-
    key_value(Profile, member_state_laid_down_criminal_penalties_for_breaches, CriminalPenaltiesLaidDown),
    duties_by_choice(CriminalPenaltiesLaidDown, Duties).

duties_by_choice(absent, indeterminate([member_state_laid_down_criminal_penalties_for_breaches])).
duties_by_choice(CriminalPenaltiesLaidDown, Duties) :-
    implements(eu_reg_2022_2554_art_52_2),
    liaison_duties(CriminalPenaltiesLaidDown, Duties).

decide_dora_penalties(Profile, dora_penalties_verdict(required, Citations)) :-
    administrative_penalty_rules_required(Profile, required, Citations).
decide_dora_penalties(Profile, dora_penalties_verdict(not_required_criminal_penalties, Citations)) :-
    administrative_penalty_rules_required(Profile, not_required_criminal_penalties, Citations).
decide_dora_penalties(Profile, dora_penalties_verdict(indeterminate, [])) :-
    administrative_penalty_rules_required(Profile, indeterminate(_), _).
decide_dora_penalties(Profile, dora_penalties_verdict(input_problems, [])) :-
    administrative_penalty_rules_required(Profile, input_problems(_), _).

dora_penalties_status(Profile, Status) :-
    decide_dora_penalties(Profile, dora_penalties_verdict(Status, _Citations)).

dora_penalties_checklist(Profile, [item(administrative_penalty_rules_required, RulesResult, RulesCitations), item(minimum_powers, Powers, PowersCitations), item(penalty_decision_safeguards, Safeguards, SafeguardsCitations), item(circumstances_to_take_into_account, Circumstances, CircumstancesCitations), item(criminal_penalty_liaison_duties, Duties, DutiesCitations)]) :-
    administrative_penalty_rules_required(Profile, RulesResult, RulesCitations),
    minimum_powers(Profile, Powers),
    answer_citations(Powers, PowersCitations),
    penalty_decision_safeguards(Profile, Safeguards),
    answer_citations(Safeguards, SafeguardsCitations),
    circumstances_to_take_into_account(Profile, Circumstances),
    answer_citations(Circumstances, CircumstancesCitations),
    criminal_penalty_liaison_duties(Profile, Duties),
    answer_citations(Duties, DutiesCitations).

answer_citations(indeterminate(_), []).
answer_citations(input_problems(_), []).
answer_citations(needs_legal_review(open_textured(_, Citation), _), [Citation]).
answer_citations([], []).
answer_citations([AnswerTerm|AnswerTerms], [Citation|Citations]) :-
    functor(AnswerTerm, _, ArgumentCount),
    arg(ArgumentCount, AnswerTerm, Citation),
    answer_citations(AnswerTerms, Citations).

dora_penalties_decision_resolvable(Profile) :-
    decide_dora_penalties(Profile, _Verdict).

test(rules_required_when_breach_not_criminally_penalised) :-
    findall(Result - Citations, administrative_penalty_rules_required([attribute(breach_subject_to_criminal_penalties_under_national_law, false)], Result, Citations), Answers),
    Answers == [required - [cite(eu_reg_2022_2554_art_50_3)]].
test(rules_not_required_when_option_used) :-
    findall(Result - Citations, administrative_penalty_rules_required([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true)], Result, Citations), Answers),
    Answers == [not_required_criminal_penalties - [cite(eu_reg_2022_2554_art_52_1)]].
test(rules_required_when_option_not_used) :-
    administrative_penalty_rules_required([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, false)], required, [cite(eu_reg_2022_2554_art_50_3), cite(eu_reg_2022_2554_art_52_1)]).
test(rules_empty_profile_names_breach_key) :-
    findall(Result - Citations, administrative_penalty_rules_required([], Result, Citations), Answers),
    Answers == [indeterminate([breach_subject_to_criminal_penalties_under_national_law]) - []].
test(rules_choice_named_behind_breach) :-
    administrative_penalty_rules_required([attribute(breach_subject_to_criminal_penalties_under_national_law, true)], indeterminate([member_state_chose_no_administrative_rules_for_criminally_penalised_breaches]), []).
test(rules_unknown_key_is_input_problem) :-
    administrative_penalty_rules_required([attribute(colour, blue)], input_problems([unknown_key(colour)]), []).
test(powers_full_list) :-
    findall(Powers, minimum_powers([attribute(breach_subject_to_criminal_penalties_under_national_law, false), attribute(national_law_permits_requiring_data_traffic_records, true), attribute(measures_applied_to_legal_person, true)], Powers), Answers),
    Answers == [[power(supervisory, access_to_documents_and_data, cite(eu_reg_2022_2554_art_50_2_a)), power(supervisory, on_site_inspections_and_investigations, cite(eu_reg_2022_2554_art_50_2_b)), power(supervisory, require_corrective_and_remedial_measures, cite(eu_reg_2022_2554_art_50_2_c)), power(penalty, cease_and_desist_order, cite(eu_reg_2022_2554_art_50_4_a)), power(penalty, cessation_of_practice_or_conduct, cite(eu_reg_2022_2554_art_50_4_b)), power(penalty, measures_to_ensure_continued_compliance, cite(eu_reg_2022_2554_art_50_4_c)), power(penalty, require_data_traffic_records, cite(eu_reg_2022_2554_art_50_4_d)), power(penalty, public_notice, cite(eu_reg_2022_2554_art_50_4_e)), power(extension, management_body_and_responsible_individuals, cite(eu_reg_2022_2554_art_50_5))]].
test(powers_option_applies_drops_penalties) :-
    findall(Powers, minimum_powers([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true), attribute(measures_applied_to_legal_person, false)], Powers), Answers),
    Answers == [[power(supervisory, access_to_documents_and_data, cite(eu_reg_2022_2554_art_50_2_a)), power(supervisory, on_site_inspections_and_investigations, cite(eu_reg_2022_2554_art_50_2_b)), power(supervisory, require_corrective_and_remedial_measures, cite(eu_reg_2022_2554_art_50_2_c))]].
test(powers_choice_false_decides_alone) :-
    minimum_powers([attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, false)], indeterminate([national_law_permits_requiring_data_traffic_records])).
test(powers_empty_profile_names_breach_key) :-
    minimum_powers([], indeterminate([breach_subject_to_criminal_penalties_under_national_law])).
test(powers_legal_person_named_last) :-
    minimum_powers([attribute(breach_subject_to_criminal_penalties_under_national_law, false), attribute(national_law_permits_requiring_data_traffic_records, false)], indeterminate([measures_applied_to_legal_person])).
test(powers_without_data_traffic_records) :-
    minimum_powers([attribute(breach_subject_to_criminal_penalties_under_national_law, false), attribute(national_law_permits_requiring_data_traffic_records, false), attribute(measures_applied_to_legal_person, false)], Powers),
    length(Powers, 7).
test(safeguards_for_point_c_decision) :-
    findall(Safeguards, penalty_decision_safeguards([attribute(decision_imposes_art_50_2_c_measure, true)], Safeguards), Answers),
    Answers == [[properly_reasoned(cite(eu_reg_2022_2554_art_50_6)), right_of_appeal(cite(eu_reg_2022_2554_art_50_6))]].
test(safeguards_none_otherwise) :-
    penalty_decision_safeguards([attribute(decision_imposes_art_50_2_c_measure, false)], []).
test(safeguards_absent_key) :-
    penalty_decision_safeguards([], indeterminate([decision_imposes_art_50_2_c_measure])).
test(duties_when_criminal_penalties_laid_down) :-
    findall(Duties, criminal_penalty_liaison_duties([attribute(member_state_laid_down_criminal_penalties_for_breaches, true)], Duties), Answers),
    Answers == [[receive_criminal_proceedings_information(cite(eu_reg_2022_2554_art_52_2)), provide_information_to_authorities_and_esas(cite(eu_reg_2022_2554_art_52_2))]].
test(duties_none_otherwise) :-
    criminal_penalty_liaison_duties([attribute(member_state_laid_down_criminal_penalties_for_breaches, false)], []).
test(duties_wrong_type) :-
    criminal_penalty_liaison_duties([attribute(member_state_laid_down_criminal_penalties_for_breaches, unsure)], input_problems([wrong_type(member_state_laid_down_criminal_penalties_for_breaches)])).
test(circumstances_absent_named_before_unsure) :-
    circumstances_to_take_into_account([attribute(breach_materiality_gravity_duration_relevant, unsure)], indeterminate([degree_of_responsibility_relevant])).
test(circumstances_unsure_referred) :-
    Profile = [attribute(breach_materiality_gravity_duration_relevant, true), attribute(degree_of_responsibility_relevant, unsure), attribute(financial_strength_relevant, false), attribute(profits_gained_or_losses_avoided_relevant, unsure), attribute(third_party_losses_relevant, true), attribute(cooperation_with_authority_relevant, false), attribute(previous_breaches_relevant, true)],
    findall(Answer, circumstances_to_take_into_account(Profile, Answer), Answers),
    Answers == [needs_legal_review(open_textured(degree_of_responsibility_relevant, cite(eu_reg_2022_2554_art_51_2_b)), [inputs_relied_on([breach_materiality_gravity_duration_relevant - true, degree_of_responsibility_relevant - unsure, financial_strength_relevant - false, profits_gained_or_losses_avoided_relevant - unsure, third_party_losses_relevant - true, cooperation_with_authority_relevant - false, previous_breaches_relevant - true])])].
test(circumstances_listed_in_order) :-
    Profile = [attribute(previous_breaches_relevant, true), attribute(breach_materiality_gravity_duration_relevant, true), attribute(degree_of_responsibility_relevant, false), attribute(financial_strength_relevant, false), attribute(profits_gained_or_losses_avoided_relevant, false), attribute(third_party_losses_relevant, false), attribute(cooperation_with_authority_relevant, false)],
    findall(Answer, circumstances_to_take_into_account(Profile, Answer), Answers),
    Answers == [[circumstance(intent_or_negligence, cite(eu_reg_2022_2554_art_51_2)), circumstance(materiality_gravity_and_duration, cite(eu_reg_2022_2554_art_51_2_a)), circumstance(previous_breaches, cite(eu_reg_2022_2554_art_51_2_g))]].
test(circumstances_empty_profile) :-
    circumstances_to_take_into_account([], indeterminate([breach_materiality_gravity_duration_relevant])).
test(verdict_required) :-
    decide_dora_penalties([attribute(breach_subject_to_criminal_penalties_under_national_law, false)], dora_penalties_verdict(required, [cite(eu_reg_2022_2554_art_50_3)])).
test(checklist_one_solution) :-
    findall(Items, dora_penalties_checklist([], Items), Answers),
    length(Answers, 1).
test(not_a_profile) :-
    minimum_powers(not_a_list, input_problems([wrong_type(profile)])).

test(rules_option_used_is_not_required, fail) :-
    administrative_penalty_rules_required([attribute(breach_subject_to_criminal_penalties_under_national_law, true), attribute(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches, true)], required, _).
test(verdict_required_is_not_indeterminate, fail) :-
    decide_dora_penalties([attribute(breach_subject_to_criminal_penalties_under_national_law, false)], dora_penalties_verdict(indeterminate, _)).
