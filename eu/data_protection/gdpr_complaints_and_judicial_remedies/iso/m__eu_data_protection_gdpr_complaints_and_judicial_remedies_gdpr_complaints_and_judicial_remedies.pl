% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [decide_gdpr_complaints_and_judicial_remedies/2, gdpr_complaints_and_judicial_remedies_status/2, gdpr_complaints_and_judicial_remedies_checklist/2, gdpr_complaints_and_judicial_remedies_decision_resolvable/1, gdpr_complaints_and_judicial_remedies_status_values/1, complaint_right/3, authority_decision_remedy_right/3, authority_inaction_remedy_right/4, controller_processor_remedy_right/3, controller_processor_forum/3, complaint_right_exists/0, no_complaint_right/0, decision_remedy_right_exists/0, no_decision_remedy_right/0, inaction_remedy_right_exists/0, no_inaction_remedy_right/0, judicial_remedy_right_exists/0, no_judicial_remedy_right/0, forum_establishment_state_only/0, forum_establishment_or_habitual_residence_state/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

complaint_right_exists.

no_complaint_right.

decision_remedy_right_exists.

no_decision_remedy_right.

inaction_remedy_right_exists.

no_inaction_remedy_right.

judicial_remedy_right_exists.

no_judicial_remedy_right.

forum_establishment_state_only.

forum_establishment_or_habitual_residence_state.

query_provision(complaint_right, cite(eu_reg_2016_679_art_77_1)).
query_provision(authority_decision_remedy_right, cite(eu_reg_2016_679_art_78_1)).
query_provision(authority_inaction_remedy_right, cite(eu_reg_2016_679_art_78_2)).
query_provision(controller_processor_remedy_right, cite(eu_reg_2016_679_art_79_1)).
query_provision(controller_processor_forum, cite(eu_reg_2016_679_art_79_2)).

gdpr_complaints_and_judicial_remedies_status_values([complaint_right_exists, no_complaint_right, decision_remedy_right_exists, no_decision_remedy_right, inaction_remedy_right_exists, no_inaction_remedy_right, judicial_remedy_right_exists, no_judicial_remedy_right, forum_establishment_state_only, forum_establishment_or_habitual_residence_state]).

key_state(Profile, Key, value(Value)) :-
    profile_get(Profile, Key, Value).
key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

complaint_right(Profile, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems),
    complaint_right_checked(Problems, Profile, Result, Citations).

complaint_right_checked([Problem|Problems], _, input_problems([Problem|Problems]), []).
complaint_right_checked([], Profile, Result, Citations) :-
    key_state(Profile, is_data_subject, Subject),
    key_state(Profile, data_subject_considers_processing_infringes_regulation, Considers),
    complaint_route(Subject, Considers, Result, Citations).

complaint_route(value(false), _, no_complaint_right, [cite(eu_reg_2016_679_art_77_1)]) :-
    implements(eu_reg_2016_679_art_77_1).
complaint_route(Subject, value(false), no_complaint_right, [cite(eu_reg_2016_679_art_77_1)]) :-
    implements(eu_reg_2016_679_art_77_1),
    dif(Subject, value(false)).
complaint_route(absent, Considers, indeterminate([is_data_subject]), []) :-
    implements(eu_reg_2016_679_art_77_1),
    dif(Considers, value(false)).
complaint_route(value(true), absent, indeterminate([data_subject_considers_processing_infringes_regulation]), []) :-
    implements(eu_reg_2016_679_art_77_1).
complaint_route(value(true), value(true), complaint_right_exists, [cite(eu_reg_2016_679_art_77_1)]) :-
    implements(eu_reg_2016_679_art_77_1).

authority_decision_remedy_right(Profile, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems),
    decision_remedy_checked(Problems, Profile, Result, Citations).

decision_remedy_checked([Problem|Problems], _, input_problems([Problem|Problems]), []).
decision_remedy_checked([], Profile, Result, Citations) :-
    key_state(Profile, decision_is_legally_binding, Binding),
    key_state(Profile, decision_concerns_the_caller, Concerns),
    decision_route(Binding, Concerns, Result, Citations).

decision_route(value(false), _, no_decision_remedy_right, [cite(eu_reg_2016_679_art_78_1)]) :-
    implements(eu_reg_2016_679_art_78_1).
decision_route(Binding, value(false), no_decision_remedy_right, [cite(eu_reg_2016_679_art_78_1)]) :-
    implements(eu_reg_2016_679_art_78_1),
    dif(Binding, value(false)).
decision_route(absent, Concerns, indeterminate([decision_is_legally_binding]), []) :-
    implements(eu_reg_2016_679_art_78_1),
    dif(Concerns, value(false)).
decision_route(value(true), absent, indeterminate([decision_concerns_the_caller]), []) :-
    implements(eu_reg_2016_679_art_78_1).
decision_route(value(unsure), absent, indeterminate([decision_concerns_the_caller]), []) :-
    implements(eu_reg_2016_679_art_78_1).
decision_route(value(unsure), value(true), needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])]), []) :-
    implements(eu_reg_2016_679_art_78_1).
decision_route(value(unsure), value(unsure), needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - unsure])]), []) :-
    implements(eu_reg_2016_679_art_78_1).
decision_route(value(true), value(unsure), needs_legal_review(open_textured(decision_concerns_the_caller, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - true, decision_concerns_the_caller - unsure])]), []) :-
    implements(eu_reg_2016_679_art_78_1).
decision_route(value(true), value(true), decision_remedy_right_exists, [cite(eu_reg_2016_679_art_78_1)]) :-
    implements(eu_reg_2016_679_art_78_1).

authority_inaction_remedy_right(Profile, Result, Basis, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems),
    inaction_remedy_checked(Problems, Profile, Result, Basis, Citations).

inaction_remedy_checked([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
inaction_remedy_checked([], Profile, Result, Basis, Citations) :-
    key_state(Profile, is_data_subject, Subject),
    key_state(Profile, complaint_lodged_under_article_77, Lodged),
    competence_state(Profile, Competence, Attested),
    key_state(Profile, authority_handled_the_complaint, Handled),
    key_state(Profile, three_months_from_the_complaint_have_passed, MonthsPassed),
    key_state(Profile, authority_informed_on_progress_or_outcome, Informed),
    failure_state(Handled, MonthsPassed, Informed, Failure),
    inaction_route(Subject, Lodged, Competence, Attested, Failure, Result, Basis, Citations).

competence_state(Profile, absent, none) :-
    profile_lacks(Profile, authority_competent_under_articles_55_and_56).
competence_state(Profile, competent, Attested) :-
    implements(eu_reg_2016_679_art_78_2),
    profile_get(Profile, authority_competent_under_articles_55_and_56, Attested),
    Attested = attested(true, _).
competence_state(Profile, not_competent, Attested) :-
    implements(eu_reg_2016_679_art_78_2),
    profile_get(Profile, authority_competent_under_articles_55_and_56, Attested),
    Attested = attested(false, _).

failure_state(value(true), value(false), _, settled_absent) :-
    implements(eu_reg_2016_679_art_78_2).
failure_state(value(true), MonthsPassed, value(true), settled_absent) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(MonthsPassed, value(false)).
failure_state(value(false), _, _, holds) :-
    implements(eu_reg_2016_679_art_78_2).
failure_state(value(true), value(true), value(false), holds) :-
    implements(eu_reg_2016_679_art_78_2).
failure_state(absent, value(true), value(false), holds) :-
    implements(eu_reg_2016_679_art_78_2).
failure_state(absent, MonthsPassed, _, missing(authority_handled_the_complaint)) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(MonthsPassed, value(true)).
failure_state(absent, value(true), Informed, missing(authority_handled_the_complaint)) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(Informed, value(false)).
failure_state(value(true), absent, Informed, missing(three_months_from_the_complaint_have_passed)) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(Informed, value(true)).
failure_state(value(true), value(true), absent, missing(authority_informed_on_progress_or_outcome)) :-
    implements(eu_reg_2016_679_art_78_2).

inaction_route(value(false), _, _, _, _, no_inaction_remedy_right, [], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2).
inaction_route(Subject, value(false), _, _, _, no_inaction_remedy_right, [], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(Subject, value(false)).
inaction_route(Subject, Lodged, not_competent, Attested, _, no_inaction_remedy_right, [outside_fact(authority_competent_under_articles_55_and_56, Attested)], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(Subject, value(false)),
    dif(Lodged, value(false)).
inaction_route(Subject, Lodged, Competence, _, settled_absent, no_inaction_remedy_right, [], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(Subject, value(false)),
    dif(Lodged, value(false)),
    dif(Competence, not_competent).
inaction_route(absent, Lodged, Competence, _, Failure, indeterminate([is_data_subject]), [], []) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(Lodged, value(false)),
    dif(Competence, not_competent),
    dif(Failure, settled_absent).
inaction_route(value(true), absent, Competence, _, Failure, indeterminate([complaint_lodged_under_article_77]), [], []) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(Competence, not_competent),
    dif(Failure, settled_absent).
inaction_route(value(true), value(true), Competence, _, missing(Key), indeterminate([Key]), [], []) :-
    implements(eu_reg_2016_679_art_78_2),
    dif(Competence, not_competent).
inaction_route(value(true), value(true), absent, _, holds, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]), [], []) :-
    implements(eu_reg_2016_679_art_78_2).
inaction_route(value(true), value(true), competent, Attested, holds, inaction_remedy_right_exists, [outside_fact(authority_competent_under_articles_55_and_56, Attested)], [cite(eu_reg_2016_679_art_78_2)]) :-
    implements(eu_reg_2016_679_art_78_2).

controller_processor_remedy_right(Profile, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems),
    controller_processor_remedy_checked(Problems, Profile, Result, Citations).

controller_processor_remedy_checked([Problem|Problems], _, input_problems([Problem|Problems]), []).
controller_processor_remedy_checked([], Profile, Result, Citations) :-
    key_state(Profile, is_data_subject, Subject),
    key_state(Profile, data_subject_considers_rights_infringed_by_processing, Considers),
    controller_processor_remedy_route(Subject, Considers, Result, Citations).

controller_processor_remedy_route(value(false), _, no_judicial_remedy_right, [cite(eu_reg_2016_679_art_79_1)]) :-
    implements(eu_reg_2016_679_art_79_1).
controller_processor_remedy_route(Subject, value(false), no_judicial_remedy_right, [cite(eu_reg_2016_679_art_79_1)]) :-
    implements(eu_reg_2016_679_art_79_1),
    dif(Subject, value(false)).
controller_processor_remedy_route(absent, Considers, indeterminate([is_data_subject]), []) :-
    implements(eu_reg_2016_679_art_79_1),
    dif(Considers, value(false)).
controller_processor_remedy_route(value(true), absent, indeterminate([data_subject_considers_rights_infringed_by_processing]), []) :-
    implements(eu_reg_2016_679_art_79_1).
controller_processor_remedy_route(value(true), value(true), judicial_remedy_right_exists, [cite(eu_reg_2016_679_art_79_1)]) :-
    implements(eu_reg_2016_679_art_79_1).

controller_processor_forum(Profile, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems),
    controller_processor_forum_checked(Problems, Profile, Result, Citations).

controller_processor_forum_checked([Problem|Problems], _, input_problems([Problem|Problems]), []).
controller_processor_forum_checked([], Profile, Result, Citations) :-
    key_state(Profile, defendant_is_member_state_public_authority_acting_in_public_powers, PublicAuthority),
    forum_route(PublicAuthority, Result, Citations).

forum_route(absent, indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers]), []) :-
    implements(eu_reg_2016_679_art_79_2).
forum_route(value(true), forum_establishment_state_only, [cite(eu_reg_2016_679_art_79_2)]) :-
    implements(eu_reg_2016_679_art_79_2).
forum_route(value(false), forum_establishment_or_habitual_residence_state, [cite(eu_reg_2016_679_art_79_2)]) :-
    implements(eu_reg_2016_679_art_79_2).

decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(answer(complaint_right, Result), Citations)) :-
    complaint_right(Profile, Result, Citations).
decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(answer(authority_decision_remedy_right, Result), Citations)) :-
    authority_decision_remedy_right(Profile, Result, Citations).
decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(answer(authority_inaction_remedy_right, Result), Citations)) :-
    authority_inaction_remedy_right(Profile, Result, _Basis, Citations).
decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(answer(controller_processor_remedy_right, Result), Citations)) :-
    controller_processor_remedy_right(Profile, Result, Citations).
decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(answer(controller_processor_forum, Result), Citations)) :-
    controller_processor_forum(Profile, Result, Citations).

gdpr_complaints_and_judicial_remedies_status(Profile, Status) :-
    decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(Status, _Citations)).

gdpr_complaints_and_judicial_remedies_checklist(Profile, [item(complaint_right, ComplaintResult, ComplaintCitation), item(authority_decision_remedy_right, DecisionResult, DecisionCitation), item(authority_inaction_remedy_right, InactionResult, InactionCitation), item(controller_processor_remedy_right, RemedyResult, RemedyCitation), item(controller_processor_forum, ForumResult, ForumCitation)]) :-
    complaint_right(Profile, ComplaintResult, _),
    query_provision(complaint_right, ComplaintCitation),
    authority_decision_remedy_right(Profile, DecisionResult, _),
    query_provision(authority_decision_remedy_right, DecisionCitation),
    authority_inaction_remedy_right(Profile, InactionResult, _, _),
    query_provision(authority_inaction_remedy_right, InactionCitation),
    controller_processor_remedy_right(Profile, RemedyResult, _),
    query_provision(controller_processor_remedy_right, RemedyCitation),
    controller_processor_forum(Profile, ForumResult, _),
    query_provision(controller_processor_forum, ForumCitation).

gdpr_complaints_and_judicial_remedies_decision_resolvable(Profile) :-
    complaint_right(Profile, _, _).

test(complaint_right_exists_when_both_true) :-
    complaint_right([attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, true)], Result, Citations),
    Result == complaint_right_exists,
    Citations == [cite(eu_reg_2016_679_art_77_1)].
test(complaint_right_not_a_data_subject) :-
    complaint_right([attribute(is_data_subject, false)], Result, Citations),
    Result == no_complaint_right,
    Citations == [cite(eu_reg_2016_679_art_77_1)].
test(complaint_right_false_consideration_before_missing_subject) :-
    complaint_right([attribute(data_subject_considers_processing_infringes_regulation, false)], Result, _),
    Result == no_complaint_right.
test(complaint_right_first_missing_key) :-
    complaint_right([], Result, Citations),
    Result == indeterminate([is_data_subject]),
    Citations == [].
test(complaint_right_second_missing_key) :-
    complaint_right([attribute(is_data_subject, true)], Result, _),
    Result == indeterminate([data_subject_considers_processing_infringes_regulation]).
test(complaint_right_input_problems) :-
    complaint_right([attribute(is_data_subject, unsure)], Result, Citations),
    Result == input_problems([wrong_type(is_data_subject)]),
    Citations == [].
test(complaint_right_one_answer) :-
    findall(Result, complaint_right([attribute(is_data_subject, false), attribute(data_subject_considers_processing_infringes_regulation, false)], Result, _), Results),
    Results == [no_complaint_right].
test(decision_remedy_exists) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, true)], Result, Citations),
    Result == decision_remedy_right_exists,
    Citations == [cite(eu_reg_2016_679_art_78_1)].
test(decision_remedy_false_beats_unsure) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, unsure), attribute(decision_concerns_the_caller, false)], Result, _),
    Result == no_decision_remedy_right.
test(decision_remedy_missing_before_unsure) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, unsure)], Result, Citations),
    Result == indeterminate([decision_concerns_the_caller]),
    Citations == [].
test(decision_remedy_unsure_binding_refers) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, unsure), attribute(decision_concerns_the_caller, unsure)], Result, Citations),
    Result == needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - unsure])]),
    Citations == [].
test(decision_remedy_unsure_concerns_refers) :-
    authority_decision_remedy_right([attribute(decision_concerns_the_caller, unsure), attribute(decision_is_legally_binding, true)], Result, _),
    Result == needs_legal_review(open_textured(decision_concerns_the_caller, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - true, decision_concerns_the_caller - unsure])]).
test(inaction_remedy_exists_not_handled) :-
    Attested = attested(true, attestation(host, '2026-11-12', reason, none)),
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, Attested), attribute(authority_handled_the_complaint, false)], Result, Basis, Citations),
    Result == inaction_remedy_right_exists,
    Basis == [outside_fact(authority_competent_under_articles_55_and_56, Attested)],
    Citations == [cite(eu_reg_2016_679_art_78_2)].
test(inaction_remedy_exists_months_passed_no_information_handled_absent) :-
    Attested = attested(true, attestation(host, '2026-11-12', reason, none)),
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, Attested), attribute(three_months_from_the_complaint_have_passed, true), attribute(authority_informed_on_progress_or_outcome, false)], Result, _, _),
    Result == inaction_remedy_right_exists.
test(inaction_remedy_competence_absent_refers) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, false)], Result, Basis, Citations),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]),
    Basis == [],
    Citations == [].
test(inaction_remedy_not_competent_whatever_else) :-
    Attested = attested(false, attestation(host, '2026-11-12', reason, none)),
    authority_inaction_remedy_right([attribute(authority_competent_under_articles_55_and_56, Attested)], Result, Basis, _),
    Result == no_inaction_remedy_right,
    Basis == [outside_fact(authority_competent_under_articles_55_and_56, Attested)].
test(inaction_remedy_settled_absent_before_missing) :-
    authority_inaction_remedy_right([attribute(authority_handled_the_complaint, true), attribute(three_months_from_the_complaint_have_passed, false)], Result, Basis, _),
    Result == no_inaction_remedy_right,
    Basis == [].
test(inaction_remedy_informed_settles_absent) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, true), attribute(authority_informed_on_progress_or_outcome, true)], Result, _, _),
    Result == no_inaction_remedy_right.
test(inaction_remedy_missing_subject_first) :-
    authority_inaction_remedy_right([attribute(authority_handled_the_complaint, false)], Result, _, _),
    Result == indeterminate([is_data_subject]).
test(inaction_remedy_missing_handled) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true)], Result, _, _),
    Result == indeterminate([authority_handled_the_complaint]).
test(inaction_remedy_missing_months) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, true)], Result, _, _),
    Result == indeterminate([three_months_from_the_complaint_have_passed]).
test(inaction_remedy_missing_informed) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, true), attribute(three_months_from_the_complaint_have_passed, true)], Result, _, _),
    Result == indeterminate([authority_informed_on_progress_or_outcome]).
test(inaction_remedy_no_lodging) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, false)], Result, Basis, Citations),
    Result == no_inaction_remedy_right,
    Basis == [],
    Citations == [cite(eu_reg_2016_679_art_78_2)].
test(inaction_remedy_input_problems) :-
    authority_inaction_remedy_right([attribute(colour, red)], Result, Basis, Citations),
    Result == input_problems([unknown_key(colour)]),
    Basis == [],
    Citations == [].
test(controller_processor_remedy_exists) :-
    controller_processor_remedy_right([attribute(is_data_subject, true), attribute(data_subject_considers_rights_infringed_by_processing, true)], Result, Citations),
    Result == judicial_remedy_right_exists,
    Citations == [cite(eu_reg_2016_679_art_79_1)].
test(controller_processor_remedy_no_consideration) :-
    controller_processor_remedy_right([attribute(data_subject_considers_rights_infringed_by_processing, false)], Result, _),
    Result == no_judicial_remedy_right.
test(controller_processor_remedy_missing) :-
    controller_processor_remedy_right([attribute(is_data_subject, true)], Result, Citations),
    Result == indeterminate([data_subject_considers_rights_infringed_by_processing]),
    Citations == [].
test(forum_public_authority) :-
    controller_processor_forum([attribute(defendant_is_member_state_public_authority_acting_in_public_powers, true)], Result, Citations),
    Result == forum_establishment_state_only,
    Citations == [cite(eu_reg_2016_679_art_79_2)].
test(forum_private_defendant) :-
    controller_processor_forum([attribute(defendant_is_member_state_public_authority_acting_in_public_powers, false)], Result, _),
    Result == forum_establishment_or_habitual_residence_state.
test(forum_missing) :-
    controller_processor_forum([], Result, Citations),
    Result == indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers]),
    Citations == [].
test(checklist_has_one_cited_row_per_query) :-
    gdpr_complaints_and_judicial_remedies_checklist([attribute(is_data_subject, true)], Items),
    length(Items, 5),
    member(item(controller_processor_forum, _, cite(eu_reg_2016_679_art_79_2)), Items).
test(facade_gives_five_verdicts) :-
    findall(Verdict, decide_gdpr_complaints_and_judicial_remedies([], Verdict), Verdicts),
    length(Verdicts, 5).

test(complaint_right_missing_is_not_exists, fail) :-
    complaint_right([attribute(is_data_subject, true)], complaint_right_exists, _).
test(decision_remedy_unsure_is_not_exists, fail) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, unsure)], decision_remedy_right_exists, _).
test(inaction_remedy_referral_is_not_exists, fail) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, false)], inaction_remedy_right_exists, _, _).
test(forum_missing_is_not_only, fail) :-
    controller_processor_forum([], forum_establishment_state_only, _).
