% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art15_access_copy_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_gdpr_art15_access_copy, [decide_gdpr_art15_access_copy/2, access_answer_items/4, access_answer_items_missing/4, copy_scope/3, copy_fee/3, information_form/3]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_fixtures, [gdpr_art15_access_copy_subject/1, gdpr_art15_access_copy_profile_for/2]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_citations, [citation/2]).

query_name(decide).
query_name(items).
query_name(missing).
query_name(scope).
query_name(fee).
query_name(form).

query_answer(decide, Profile, Verdict) :-
    decide_gdpr_art15_access_copy(Profile, Verdict).
query_answer(items, Profile, answer(Result, Basis, Citations)) :-
    access_answer_items(Profile, Result, Basis, Citations).
query_answer(missing, Profile, answer(Result, Basis, Citations)) :-
    access_answer_items_missing(Profile, Result, Basis, Citations).
query_answer(scope, Profile, answer(Result, Citations)) :-
    copy_scope(Profile, Result, Citations).
query_answer(fee, Profile, answer(Result, Citations)) :-
    copy_fee(Profile, Result, Citations).
query_answer(form, Profile, answer(Result, Citations)) :-
    information_form(Profile, Result, Citations).

answer_count(Query, Subject, Count) :-
    query_name(Query),
    gdpr_art15_access_copy_subject(Subject),
    gdpr_art15_access_copy_profile_for(Subject, Profile),
    findall(Answer, query_answer(Query, Profile, Answer), Answers),
    length(Answers, Count).

subject_classifies(Subject) :-
    gdpr_art15_access_copy_subject(Subject),
    gdpr_art15_access_copy_profile_for(Subject, Profile),
    decide_gdpr_art15_access_copy(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_art15_access_copy_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_each_subject_exactly_once) :-
    findall(Count, answer_count(_Query, _Subject, Count), Counts),
    sort(Counts, [1]).
test(every_returned_citation_is_recorded) :-
    findall(Key, returned_citation(Key), Keys),
    sort(Keys, Distinct),
    Distinct = [_|_],
    maplist(recorded_citation, Distinct).
test(every_item_list_is_in_item_order_each_item_once) :-
    findall(Subject - Result, list_result(Subject, Result), Results),
    Results = [_|_],
    findall(Subject - Result, ordered_list_result(Subject, Result), OrderedResults),
    OrderedResults == Results.
test(every_owed_list_opens_with_the_confirmation) :-
    findall(First, (gdpr_art15_access_copy_subject(Subject), gdpr_art15_access_copy_profile_for(Subject, Profile), access_answer_items(Profile, [First|_], _, _)), Firsts),
    sort(Firsts, [confirmation_of_processing]).
test(the_items_query_never_reads_the_article_15_4_judgement) :-
    settled_items_profile(Base),
    findall(answer(Result, Basis, Citations), (member(Judgement, [true, false, unsure]), access_answer_items([attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, Judgement)|Base], Result, Basis, Citations)), Answers),
    length(Answers, 3),
    sort(Answers, [_]).
test(the_missing_query_never_reads_the_copy_fee_or_form_keys) :-
    settled_items_profile(Base),
    findall(answer(Result, Basis, Citations), (member(Flag, [true, false]), access_answer_items_missing([attribute(further_copy_requested, Flag), attribute(request_made_by_electronic_means, Flag), attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, Flag)|Base], Result, Basis, Citations)), Answers),
    length(Answers, 2),
    sort(Answers, [_]).
test(the_copy_scope_never_reads_the_fee_key) :-
    findall(Result, (member(Flag, [true, false]), copy_scope([attribute(personal_data_concerning_data_subject_processed, true), attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, true), attribute(further_copy_requested, Flag)], Result, _)), Results),
    Results == [copy_limited_by_rights_and_freedoms_of_others, copy_limited_by_rights_and_freedoms_of_others].
test(the_form_never_reads_the_other_form_key_without_an_electronic_request) :-
    findall(Result, (member(Flag, [true, false]), information_form([attribute(request_made_by_electronic_means, false), attribute(other_form_requested_by_data_subject, Flag)], Result, _)), Results),
    Results == [no_electronic_request, no_electronic_request].

answer_citations(answer(_, _, Citations), Citations).
answer_citations(answer(_, Citations), Citations).
answer_citations(gdpr_art15_access_copy_verdict(_, Citations), Citations).

returned_citation(Key) :-
    query_name(Query),
    gdpr_art15_access_copy_subject(Subject),
    gdpr_art15_access_copy_profile_for(Subject, Profile),
    query_answer(Query, Profile, Answer),
    answer_citations(Answer, Citations),
    member(cite(Key), Citations).

recorded_citation(Key) :-
    citation(Key, _Record).

item_order([confirmation_of_processing, access_to_personal_data, purposes_of_processing, categories_of_personal_data, recipients_or_categories_of_recipients, storage_period_or_criteria, rights_to_rectification_erasure_restriction_and_objection, right_to_lodge_complaint, source_of_personal_data, automated_decision_making_information, transfer_safeguards_information, copy_of_personal_data]).

ordered_within([], _).
ordered_within([Item|Items], [Item|Order]) :-
    ordered_within(Items, Order).
ordered_within([Item|Items], [Other|Order]) :-
    dif(Item, Other),
    ordered_within([Item|Items], Order).

list_result(Subject, [Item|Items]) :-
    gdpr_art15_access_copy_subject(Subject),
    gdpr_art15_access_copy_profile_for(Subject, Profile),
    access_answer_items(Profile, [Item|Items], _, _).
list_result(Subject, [Item|Items]) :-
    gdpr_art15_access_copy_subject(Subject),
    gdpr_art15_access_copy_profile_for(Subject, Profile),
    access_answer_items_missing(Profile, [Item|Items], _, _).

ordered_list_result(Subject, Result) :-
    list_result(Subject, Result),
    item_order(Order),
    ordered_within(Result, Order).

settled_items_profile([attribute(items_provided, []), attribute(personal_data_concerning_data_subject_processed, true), attribute(disclosure_to_recipients_made_or_envisaged, false), attribute(some_personal_data_not_collected_from_data_subject, false), attribute(source_information_available, false), attribute(automated_decision_making_referred_to_in_article_22, attested(false, attestation(host, recorded_at, attested_by_caller, none))), attribute(transfer_to_third_country_or_international_organisation, false)]).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_each_subject_exactly_once, every_returned_citation_is_recorded, every_item_list_is_in_item_order_each_item_once, every_owed_list_opens_with_the_confirmation, the_items_query_never_reads_the_article_15_4_judgement, the_missing_query_never_reads_the_copy_fee_or_form_keys, the_copy_scope_never_reads_the_fee_key, the_form_never_reads_the_other_form_key_without_an_electronic_request]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
