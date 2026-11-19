% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s1_international_transfers_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_swiss_fadp_s1_international_transfers, [decide_swiss_fadp_s1_international_transfers/2, swiss_fadp_s1_international_transfers_status/2, swiss_disclosure_under_article_16/3, swiss_disclosure_abroad/3, swiss_information_of_commissioner_on_request/3, eu_transfer_under_articles_45_and_46/3, compare_swiss_eu_transfer_routes/5, outside_facts_supplied/2]).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_fixtures, [swiss_fadp_s1_international_transfers_profile_for/2]).

abroad_answers(Subject, Answers) :-
    swiss_fadp_s1_international_transfers_profile_for(Subject, Profile),
    findall(Result - Citations, swiss_disclosure_abroad(Profile, Result, Citations), Answers).

test(a_finding_reads_out_adequacy_with_its_citations) :-
    abroad_answers(adequacy_finding_covers_disclosure, Answers),
    Answers == [permitted_by_adequacy_decision - [cite(ch_fadp_art_16_1), cite(ch_fadp_ord_art_8_1), cite(ch_fadp_ord_annex_1)]].
test(a_derogation_cites_every_letter_of_article_17_1) :-
    abroad_answers(life_or_physical_integrity, [permitted_by_derogation - Citations]),
    length(Citations, 11),
    member(cite(ch_fadp_art_17_1_f), Citations),
    member(cite(ch_fadp_art_17_1_b_2), Citations).
test(no_route_cites_both_articles) :-
    abroad_answers(nothing_permits_disclosure, [disclosure_abroad_not_permitted - Citations]),
    length(Citations, 24),
    member(cite(ch_fadp_ord_annex_1), Citations),
    member(cite(ch_fadp_art_17_1_e), Citations).
test(article_16_safeguards_read_out) :-
    swiss_fadp_s1_international_transfers_profile_for(binding_corporate_rules_approved, Profile),
    findall(Result, swiss_disclosure_under_article_16(Profile, Result, _), Results),
    Results == [permitted_by_safeguards].
test(the_eu_no_route_cites_both_articles) :-
    swiss_fadp_s1_international_transfers_profile_for(eu_safeguards_without_remedies, Profile),
    findall(Result - Citations, eu_transfer_under_articles_45_and_46(Profile, Result, Citations), Answers),
    Answers == [no_adequacy_decision_or_safeguards - [cite(eu_reg_2016_679_art_45_1), cite(eu_reg_2016_679_art_46_1)]].
test(an_empty_profile_names_the_treaty) :-
    abroad_answers(empty_profile, Answers),
    Answers == [indeterminate([international_treaty_ensures_suitable_protection]) - []].
test(a_single_open_key_is_named) :-
    abroad_answers(contract_clauses_notification_unknown, Answers),
    Answers == [indeterminate([contract_clauses_notified_to_commissioner_beforehand]) - []].
test(an_absent_approval_is_referred) :-
    abroad_answers(standard_clauses_approval_not_stated, [Result - []]),
    Result = needs_legal_review(cross_reference_unresolved(cite(ch_fadp_art_16_2_d), cite(commissioner_standard_clauses_statement)), [resolution(cite(commissioner_standard_clauses_statement), not_attempted), inputs_relied_on(Pairs)]),
    member(standard_clauses_approved_issued_or_recognised_by_commissioner - absent, Pairs),
    member(standard_clauses_ensure_suitable_protection - true, Pairs).
test(an_absent_finding_is_referred) :-
    abroad_answers(adequacy_finding_not_stated, [Result - []]),
    Result = needs_legal_review(cross_reference_unresolved(cite(ch_fadp_art_16_1), cite(federal_council_adequacy_listing_statement)), [resolution(cite(federal_council_adequacy_listing_statement), not_attempted), inputs_relied_on([federal_council_adequacy_listing_covers_disclosure - absent|_])]).
test(an_unsure_treaty_goes_to_a_lawyer) :-
    abroad_answers(treaty_suitability_unsure, [Result - []]),
    Result = needs_legal_review(open_textured(international_treaty_ensures_suitable_protection, cite(ch_fadp_art_16_2_a)), [inputs_relied_on([international_treaty_ensures_suitable_protection - unsure|_])]).
test(a_missing_key_comes_before_an_unsure_judgement) :-
    abroad_answers(treaty_unsure_and_notification_unknown, Answers),
    Answers == [indeterminate([contract_clauses_notified_to_commissioner_beforehand]) - []].
test(the_eu_limb_refers_on_the_absent_decision) :-
    swiss_fadp_s1_international_transfers_profile_for(eu_decision_not_stated, Profile),
    findall(Result - Citations, eu_transfer_under_articles_45_and_46(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_45_1), cite(commission_adequacy_decision_statement)), [resolution(cite(commission_adequacy_decision_statement), not_attempted), inputs_relied_on([commission_adequacy_decision_covers_transfer - absent, appropriate_safeguards_provided - true, enforceable_rights_and_effective_remedies_available - true])]) - []].
test(an_unstated_request_is_named) :-
    swiss_fadp_s1_international_transfers_profile_for(information_request_not_stated, Profile),
    findall(Result - Citations, swiss_information_of_commissioner_on_request(Profile, Result, Citations), Answers),
    Answers == [indeterminate([commissioner_requested_information_on_disclosure]) - []].
test(the_routes_differ_while_the_swiss_side_is_open) :-
    Profile = [attribute(federal_council_adequacy_listing_covers_disclosure, attested(false, attestation(by, at, reason, none))), attribute(commission_adequacy_decision_covers_transfer, attested(true, attestation(by, at, reason, none)))],
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_transfer_routes(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(indeterminate([international_treaty_ensures_suitable_protection]), permitted_by_adequacy_decision, differs, [cite(ch_fadp_art_16_1), cite(ch_fadp_art_16_2), cite(eu_reg_2016_679_art_45_1), cite(eu_reg_2016_679_art_46_1)])].
test(outside_facts_come_back_in_contract_order_exactly) :-
    Profile = [attribute(commission_adequacy_decision_covers_transfer, attested(false, attestation(host, at, stated, url('https://example.org/decision', '2026-11-16')))), attribute(federal_council_adequacy_listing_covers_disclosure, attested(true, attestation(host, at, listed, document(upload_one, digest))))],
    findall(Facts, outside_facts_supplied(Profile, Facts), Answers),
    Answers == [[outside_fact(federal_council_adequacy_listing_covers_disclosure, attested(true, attestation(host, at, listed, document(upload_one, digest)))), outside_fact(commission_adequacy_decision_covers_transfer, attested(false, attestation(host, at, stated, url('https://example.org/decision', '2026-11-16'))))]].
test(the_facade_verdict_is_the_abroad_answer) :-
    swiss_fadp_s1_international_transfers_profile_for(certification_backed, Profile),
    findall(Verdict, decide_swiss_fadp_s1_international_transfers(Profile, Verdict), Verdicts),
    swiss_disclosure_abroad(Profile, Status, Citations),
    Verdicts == [swiss_fadp_s1_international_transfers_verdict(Status, Citations)],
    Status == permitted_by_safeguards.
test(the_baseline_profile_yields_exactly_one_status) :-
    swiss_fadp_s1_international_transfers_profile_for(nothing_permits_disclosure, Profile),
    findall(Status, swiss_fadp_s1_international_transfers_status(Profile, Status), Statuses),
    Statuses == [disclosure_abroad_not_permitted].

cp_test_names([a_finding_reads_out_adequacy_with_its_citations, a_derogation_cites_every_letter_of_article_17_1, no_route_cites_both_articles, article_16_safeguards_read_out, the_eu_no_route_cites_both_articles, an_empty_profile_names_the_treaty, a_single_open_key_is_named, an_absent_approval_is_referred, an_absent_finding_is_referred, an_unsure_treaty_goes_to_a_lawyer, a_missing_key_comes_before_an_unsure_judgement, the_eu_limb_refers_on_the_absent_decision, an_unstated_request_is_named, the_routes_differ_while_the_swiss_side_is_open, outside_facts_come_back_in_contract_order_exactly, the_facade_verdict_is_the_abroad_answer, the_baseline_profile_yields_exactly_one_status]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
