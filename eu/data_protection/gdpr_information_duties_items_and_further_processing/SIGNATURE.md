# SIGNATURE: eu/data_protection/gdpr_information_duties_items_and_further_processing

Public surface. PROFILE is an attribute list [attribute(Key, Value), ...] with the twenty-six keys of the order, read only with profile_get/3 from formalize_lib. Crisp flags are the atoms true or false, judgements true, false or unsure, lists hold item atoms, dates are date(Year, Month, Day) terms.

## Verdict status atoms

- information_route/2: art13 | art14
- further_processing_information_verdict/3: eligible | ineligible | not_applicable
- non-final compound statuses: indeterminate(MissingKeys), needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]), input_problems(Problems)
- list constructors: owed_item(Item, cite(Key)), missing_item(Item, cite(Key)), no_item_missing

## Profile keys (in contract order)

personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, first_communication_date, disclosure_to_another_recipient_envisaged, first_disclosure_date, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law, further_processing_for_another_purpose_intended, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing, public_holidays.

## Citation keys

eu_reg_2016_679_art_13_1, _13_1_a to _13_1_f, _13_2_a to _13_2_f, _13_3, _13_4, eu_reg_2016_679_art_14_1, _14_1_a to _14_1_f, _14_2_a to _14_2_g, _14_4, _14_5_a (all prefixed eu_reg_2016_679_art_).

## Public predicates

- information_route(Profile, Route): art13 or art14 from the crisp collection flag; Art 13(1), 14(1).
- information_items_owed(Profile, Owed): list of owed_item(Item, cite(Key)) in checklist order; Art 13(1)-(2), 14(1)-(2).
- information_items_missing(Profile, Missing): owed items neither provided nor already held, or [no_item_missing]; Art 13(4), 14(5)(a).
- further_processing_information_verdict(Profile, Verdict, Cites): eligible, ineligible or not_applicable with [cite(Key)]; Art 13(3), 14(4).
- gdpr_information_duties_items_and_further_processing_input_problems(Profile, Problems): the input check (kernel).
- decide_information_route(Profile, Verdict), information_route_status(Profile, Status), information_route_checklist(Profile, Checklist): facade of slice 1.
- decide_further_processing_information_verdict(Profile, Verdict), further_processing_information_verdict_status(Profile, Status), further_processing_information_verdict_checklist(Profile, Checklist): facade of slice 2.
- gdpr_information_duties_items_and_further_processing_what_if(Profile, Key, Value, Status): override one key and re-read the route.
- gdpr_information_duties_items_and_further_processing_deadline(Profile, Answer): last day to give the further-processing information (the day before the start), consequence ineligible; Art 13(3), 14(4).
- fixtures: gdpr_information_duties_items_and_further_processing_subject/1, _profile_for/2, _assess/2.
- Query types: #2 eligibility = further_processing_information_verdict/3; #13 compliance_check = further_processing_information_verdict/3 and information_items_missing/2; #14 obligation_surfacing = information_items_owed/2; #15 deadline = the deadline predicate above.
- Result constructors (data terms, never queried): owed_item/2, missing_item/2, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, attested/2, attestation/4, url/2, document/2.

## Slice 1: information_route

Owns: the item table information_item_row(Item, Route, Paragraph, cite(Key), Condition), 25 rows (12 Art 13, 13 Art 14), in checklist order; the route flag mapping; the automated decision-making citation per route; the already-has citation per route. Rules: route, owed list, missing list, input check first. Shared with slice 2 (exported): information_item_row/5, information_route_for_flag/2, information_absent_keys/3.

## Slice 2: further_processing_information_verdict

Owns: the three-valued outcome algebra (true, false, unknown(Absent, Unsure)), the strict prior-to date test, the coverage test (further_processing_items_provided or items_data_subject_already_has), the key order for reporting open keys, the citation per route (13_3, 14_4). Verdicts: not_applicable when key 21 is false; ineligible when the information date is not earlier than the start date or an owed item is uncovered; eligible otherwise; unsure relevance or automated decision-making judgement gives needs_legal_review.

## Planned reuse

formalize_lib: profile_get/3, profile_has/2, profile_lacks/2, not_member/2. library(reif): memberd_t/3. library(datetime): timedelta/3, date_sub/3 (deadline). No kit query combinators are needed.
