% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up, [objection_right_notice/4, erasure_follow_up_duty/4, decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up/2, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status/2, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_checklist/2, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_decision_resolvable/1, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_kernel, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems/2]).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status_values([notice_not_owed, notice_not_yet_due, notice_complies, notice_does_not_comply, follow_up_duty_does_not_apply, follow_up_duty_met, follow_up_duty_not_met]).

outside_fact_row(right_to_object_applies, cite(eu_reg_2016_679_art_21_4), cite(article_21_right_to_object_statement)).
outside_fact_row(controller_obliged_to_erase_under_article_17_1, cite(eu_reg_2016_679_art_17_2), cite(article_17_1_erasure_obligation_statement)).

judgement_row(right_presented_clearly, cite(eu_reg_2016_679_art_21_4)).
judgement_row(reasonable_steps_taken_to_inform_other_controllers, cite(eu_reg_2016_679_art_17_2)).

checklist_row(right_to_object_applies, right_to_object_applies, no_right_to_object, cite(article_21_right_to_object_statement)).
checklist_row(first_communication_with_data_subject_has_taken_place, first_communication_with_data_subject_has_taken_place, first_communication_not_yet_made, cite(eu_reg_2016_679_art_21_4)).
checklist_row(right_explicitly_brought_to_attention_by_first_communication, right_explicitly_brought_to_attention_by_first_communication, not_explicit_or_not_in_time, cite(eu_reg_2016_679_art_21_4)).
checklist_row(right_presented_separately_from_other_information, right_presented_separately_from_other_information, not_presented_separately, cite(eu_reg_2016_679_art_21_4)).
checklist_row(right_presented_clearly, right_presented_clearly, not_presented_clearly, cite(eu_reg_2016_679_art_21_4)).
checklist_row(controller_made_personal_data_public, controller_made_personal_data_public, data_not_made_public_by_controller, cite(eu_reg_2016_679_art_17_2)).
checklist_row(controller_obliged_to_erase_under_article_17_1, controller_obliged_to_erase_under_article_17_1, no_obligation_to_erase, cite(article_17_1_erasure_obligation_statement)).
checklist_row(reasonable_steps_taken_to_inform_other_controllers, reasonable_steps_taken_to_inform_other_controllers, no_reasonable_steps_taken, cite(eu_reg_2016_679_art_17_2)).

key_value(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_value(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

outside_state(absent, absent).
outside_state(attested(true, _), attested_true).
outside_state(attested(false, _), attested_false).

absent_referral(Key, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([Key - absent])])) :-
    outside_fact_row(Key, Citation, Target).

open_textured_referral(Key, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on([Key - unsure])])) :-
    judgement_row(Key, Citation).

objection_right_notice(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, [Problem|Problems]).
objection_right_notice(Profile, Result, Basis, Citations) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, []),
    notice_inputs(Profile, RightState, RightValue, First, Class),
    notice_route(RightState, RightValue, First, Class, Result, Basis, Citations).

notice_inputs(Profile, RightState, RightValue, First, Class) :-
    key_value(Profile, right_to_object_applies, RightValue),
    outside_state(RightValue, RightState),
    key_value(Profile, first_communication_with_data_subject_has_taken_place, First),
    key_value(Profile, right_explicitly_brought_to_attention_by_first_communication, Explicit),
    key_value(Profile, right_presented_separately_from_other_information, Separate),
    key_value(Profile, right_presented_clearly, Clear),
    requirement_class([right_explicitly_brought_to_attention_by_first_communication - Explicit, right_presented_separately_from_other_information - Separate, right_presented_clearly - Clear], Class).

requirement_class(Pairs, Class) :-
    implements(eu_reg_2016_679_art_21_4),
    pairs_values(Pairs, Values),
    memberd_t(false, Values, HasFalse),
    class_after_false(HasFalse, Pairs, Values, Class).

class_after_false(true, _, _, some_false).
class_after_false(false, Pairs, Values, Class) :-
    memberd_t(absent, Values, HasAbsent),
    class_after_absent(HasAbsent, Pairs, Class).

class_after_absent(true, Pairs, first_absent(Key)) :-
    first_absent_key(Pairs, Key).
class_after_absent(false, Pairs, all_clear(Clear)) :-
    last(Pairs, _ - Clear).

first_absent_key([Key - absent|_], Key).
first_absent_key([_ - Value|Pairs], Key) :-
    dif(Value, absent),
    first_absent_key(Pairs, Key).

notice_route(attested_false, RightValue, _, _, notice_not_owed, [outside_fact(right_to_object_applies, RightValue)], [cite(eu_reg_2016_679_art_21_4)]) :-
    implements(eu_reg_2016_679_art_21_4).
notice_route(RightState, _, absent, _, indeterminate([first_communication_with_data_subject_has_taken_place]), [], []) :-
    implements(eu_reg_2016_679_art_21_4),
    dif(RightState, attested_false).
notice_route(attested_true, RightValue, false, _, notice_not_yet_due, [outside_fact(right_to_object_applies, RightValue)], [cite(eu_reg_2016_679_art_21_4)]) :-
    implements(eu_reg_2016_679_art_21_4).
notice_route(absent, _, false, _, Result, [], []) :-
    implements(eu_reg_2016_679_art_21_4),
    absent_referral(right_to_object_applies, Result).
notice_route(attested_true, RightValue, true, some_false, notice_does_not_comply, [outside_fact(right_to_object_applies, RightValue)], [cite(eu_reg_2016_679_art_21_4)]) :-
    implements(eu_reg_2016_679_art_21_4).
notice_route(absent, _, true, some_false, Result, [], []) :-
    implements(eu_reg_2016_679_art_21_4),
    absent_referral(right_to_object_applies, Result).
notice_route(RightState, _, true, first_absent(Key), indeterminate([Key]), [], []) :-
    implements(eu_reg_2016_679_art_21_4),
    dif(RightState, attested_false).
notice_route(absent, _, true, all_clear(_), Result, [], []) :-
    implements(eu_reg_2016_679_art_21_4),
    absent_referral(right_to_object_applies, Result).
notice_route(attested_true, _, true, all_clear(unsure), Result, [], []) :-
    implements(eu_reg_2016_679_art_21_4),
    open_textured_referral(right_presented_clearly, Result).
notice_route(attested_true, RightValue, true, all_clear(true), notice_complies, [outside_fact(right_to_object_applies, RightValue)], [cite(eu_reg_2016_679_art_21_4)]) :-
    implements(eu_reg_2016_679_art_21_4).

erasure_follow_up_duty(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, [Problem|Problems]).
erasure_follow_up_duty(Profile, Result, Basis, Citations) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, []),
    key_value(Profile, controller_made_personal_data_public, Public),
    key_value(Profile, controller_obliged_to_erase_under_article_17_1, ObligedValue),
    outside_state(ObligedValue, ObligedState),
    key_value(Profile, reasonable_steps_taken_to_inform_other_controllers, Steps),
    follow_up_route(Public, ObligedState, ObligedValue, Steps, Result, Basis, Citations).

follow_up_basis(absent, _, []).
follow_up_basis(attested_true, ObligedValue, [outside_fact(controller_obliged_to_erase_under_article_17_1, ObligedValue)]).
follow_up_basis(attested_false, ObligedValue, [outside_fact(controller_obliged_to_erase_under_article_17_1, ObligedValue)]).

follow_up_route(false, ObligedState, ObligedValue, _, follow_up_duty_does_not_apply, Basis, [cite(eu_reg_2016_679_art_17_2)]) :-
    implements(eu_reg_2016_679_art_17_2),
    follow_up_basis(ObligedState, ObligedValue, Basis).
follow_up_route(Public, attested_false, ObligedValue, _, follow_up_duty_does_not_apply, [outside_fact(controller_obliged_to_erase_under_article_17_1, ObligedValue)], [cite(eu_reg_2016_679_art_17_2)]) :-
    implements(eu_reg_2016_679_art_17_2),
    dif(Public, false).
follow_up_route(absent, ObligedState, _, _, indeterminate([controller_made_personal_data_public]), [], []) :-
    implements(eu_reg_2016_679_art_17_2),
    dif(ObligedState, attested_false).
follow_up_route(true, ObligedState, _, absent, indeterminate([reasonable_steps_taken_to_inform_other_controllers]), [], []) :-
    implements(eu_reg_2016_679_art_17_2),
    dif(ObligedState, attested_false).
follow_up_route(true, absent, _, Steps, Result, [], []) :-
    implements(eu_reg_2016_679_art_17_2),
    dif(Steps, absent),
    absent_referral(controller_obliged_to_erase_under_article_17_1, Result).
follow_up_route(true, attested_true, _, unsure, Result, [], []) :-
    implements(eu_reg_2016_679_art_17_2),
    open_textured_referral(reasonable_steps_taken_to_inform_other_controllers, Result).
follow_up_route(true, attested_true, ObligedValue, true, follow_up_duty_met, [outside_fact(controller_obliged_to_erase_under_article_17_1, ObligedValue)], [cite(eu_reg_2016_679_art_17_2)]) :-
    implements(eu_reg_2016_679_art_17_2).
follow_up_route(true, attested_true, ObligedValue, false, follow_up_duty_not_met, [outside_fact(controller_obliged_to_erase_under_article_17_1, ObligedValue)], [cite(eu_reg_2016_679_art_17_2)]) :-
    implements(eu_reg_2016_679_art_17_2).

decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up(Profile, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_verdict(determination(NoticeResult, FollowUpResult), Citations)) :-
    objection_right_notice(Profile, NoticeResult, _NoticeBasis, NoticeCitations),
    erasure_follow_up_duty(Profile, FollowUpResult, _FollowUpBasis, FollowUpCitations),
    append(NoticeCitations, FollowUpCitations, AllCitations),
    sort(AllCitations, Citations).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status(Profile, Status) :-
    decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up(Profile, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_verdict(Status, _Citations)).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_checklist(Profile, [item(input, input_problems([Problem|Problems]), [])]) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, [Problem|Problems]).
gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_checklist(Profile, Items) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, []),
    findall(Identifier - Key - Reason - Citation, checklist_row(Identifier, Key, Reason, Citation), Rows),
    maplist(checklist_item(Profile), Rows, Items).

checklist_item(Profile, Identifier - Key - Reason - Citation, item(Identifier, Status, Citation)) :-
    key_value(Profile, Key, Value),
    plain_value(Value, Plain),
    value_status(Plain, Key, Reason, Status).

plain_value(attested(Value, _), Value).
plain_value(Value, Value) :-
    atom(Value).

value_status(true, _, _, met).
value_status(false, _, Reason, unmet(Reason)).
value_status(absent, Key, _, unknown([Key])).
value_status(unsure, Key, _, unknown([Key])).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_decision_resolvable(Profile) :-
    decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up(Profile, _Verdict).

test_attested(Value, attested(Value, attestation(host_user, host_time, stated_reason, none))).

test(notice_complies_once) :-
    test_attested(true, Attested),
    Profile = [attribute(right_to_object_applies, Attested), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, true)],
    findall(Result - Basis - Citations, objection_right_notice(Profile, Result, Basis, Citations), Answers),
    Answers == [notice_complies - [outside_fact(right_to_object_applies, Attested)] - [cite(eu_reg_2016_679_art_21_4)]].
test(notice_not_owed_when_no_right) :-
    test_attested(false, Attested),
    objection_right_notice([attribute(right_to_object_applies, Attested)], notice_not_owed, [outside_fact(right_to_object_applies, Attested)], [cite(eu_reg_2016_679_art_21_4)]).
test(first_communication_named_first) :-
    objection_right_notice([], indeterminate([first_communication_with_data_subject_has_taken_place]), [], []).
test(not_yet_due_with_right_absent_is_referred) :-
    objection_right_notice([attribute(first_communication_with_data_subject_has_taken_place, false)], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_21_4), cite(article_21_right_to_object_statement)), [resolution(cite(article_21_right_to_object_statement), not_attempted), inputs_relied_on([right_to_object_applies - absent])]), [], []).
test(not_yet_due) :-
    test_attested(true, Attested),
    objection_right_notice([attribute(right_to_object_applies, Attested), attribute(first_communication_with_data_subject_has_taken_place, false)], notice_not_yet_due, _, _).
test(one_failed_requirement_is_enough) :-
    test_attested(true, Attested),
    objection_right_notice([attribute(right_to_object_applies, Attested), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_presented_separately_from_other_information, false), attribute(right_presented_clearly, unsure)], notice_does_not_comply, _, _).
test(explicit_named_before_unsure_clarity) :-
    test_attested(true, Attested),
    objection_right_notice([attribute(right_to_object_applies, Attested), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, unsure)], indeterminate([right_explicitly_brought_to_attention_by_first_communication]), [], []).
test(unsure_clarity_goes_to_a_lawyer) :-
    test_attested(true, Attested),
    objection_right_notice([attribute(right_to_object_applies, Attested), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, unsure)], needs_legal_review(open_textured(right_presented_clearly, cite(eu_reg_2016_679_art_21_4)), [inputs_relied_on([right_presented_clearly - unsure])]), [], []).
test(follow_up_does_not_apply_without_publication) :-
    findall(Result - Basis - Citations, erasure_follow_up_duty([attribute(controller_made_personal_data_public, false)], Result, Basis, Citations), Answers),
    Answers == [follow_up_duty_does_not_apply - [] - [cite(eu_reg_2016_679_art_17_2)]].
test(follow_up_met) :-
    test_attested(true, Attested),
    erasure_follow_up_duty([attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, Attested), attribute(reasonable_steps_taken_to_inform_other_controllers, true)], follow_up_duty_met, [outside_fact(controller_obliged_to_erase_under_article_17_1, Attested)], [cite(eu_reg_2016_679_art_17_2)]).
test(follow_up_not_met) :-
    test_attested(true, Attested),
    erasure_follow_up_duty([attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, Attested), attribute(reasonable_steps_taken_to_inform_other_controllers, false)], follow_up_duty_not_met, _, _).
test(steps_named_before_obligation_referred) :-
    erasure_follow_up_duty([attribute(controller_made_personal_data_public, true)], indeterminate([reasonable_steps_taken_to_inform_other_controllers]), [], []).
test(obligation_referred_before_unsure_steps) :-
    erasure_follow_up_duty([attribute(controller_made_personal_data_public, true), attribute(reasonable_steps_taken_to_inform_other_controllers, unsure)], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_2), cite(article_17_1_erasure_obligation_statement)), [resolution(cite(article_17_1_erasure_obligation_statement), not_attempted), inputs_relied_on([controller_obliged_to_erase_under_article_17_1 - absent])]), [], []).
test(unsure_steps_go_to_a_lawyer) :-
    test_attested(true, Attested),
    erasure_follow_up_duty([attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, Attested), attribute(reasonable_steps_taken_to_inform_other_controllers, unsure)], needs_legal_review(open_textured(reasonable_steps_taken_to_inform_other_controllers, cite(eu_reg_2016_679_art_17_2)), [inputs_relied_on([reasonable_steps_taken_to_inform_other_controllers - unsure])]), [], []).
test(no_obligation_settles_without_publication) :-
    test_attested(false, Attested),
    erasure_follow_up_duty([attribute(controller_obliged_to_erase_under_article_17_1, Attested)], follow_up_duty_does_not_apply, [outside_fact(controller_obliged_to_erase_under_article_17_1, Attested)], _).
test(bare_outside_fact_is_an_input_problem) :-
    findall(Result - Basis - Citations, objection_right_notice([attribute(right_to_object_applies, true)], Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(right_to_object_applies)]) - [] - []].
test(facade_verdict) :-
    decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up([attribute(controller_made_personal_data_public, false)], gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_verdict(determination(indeterminate([first_communication_with_data_subject_has_taken_place]), follow_up_duty_does_not_apply), [cite(eu_reg_2016_679_art_17_2)])).
test(checklist_rows) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_checklist([attribute(controller_made_personal_data_public, false)], Items),
    length(Items, 8),
    member(item(controller_made_personal_data_public, unmet(data_not_made_public_by_controller), cite(eu_reg_2016_679_art_17_2)), Items).

test(notice_complies_is_not_does_not_comply, fail) :-
    test_attested(true, Attested),
    Profile = [attribute(right_to_object_applies, Attested), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, true)],
    objection_right_notice(Profile, notice_does_not_comply, _, _).
test(follow_up_not_met_is_not_met, fail) :-
    test_attested(true, Attested),
    erasure_follow_up_duty([attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, Attested), attribute(reasonable_steps_taken_to_inform_other_controllers, false)], follow_up_duty_met, _, _).
