# Who [quotation omitted] to 6-1-1315) covers and when certain of its duties fall due. Decided here: whether part 13, other than the minors' sections, applies to a ...

`us/colorado_cpa`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 245/245 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Who [quotation omitted] to 6-1-1315) covers and when certain of its duties fall due. Decided here: whether part 13, other than the minors' sections, applies to a controller ([quotation omitted]) and the exempt persons of 6-1-1304(2)(l), (m), (q)); whether the minors' [quotation omitted] [quotation omitted] (6-1-1304(1)(b), (2)); the last day to inform a consumer of action on a request, with the extension (6-1-1306(2)(a), (b)); the last day to answer an appeal, with the extension (6-1-1306(3)(b)); the last day of the sixty-day cure period for the minors' sections and how that provision bears on an action on a given day (6-1-1311(1)(d)(II), read as in force from 1 October 2025 to 30 December 2026); and the first day a controller must recognise a universal opt-out mechanism on the public list (6-1-1306(1)(a)(IV)(B); 4 CCR 904-3, Rules 5.07(F), 5.08(A), 5.08(A)(3)). Out of scope: whether a duty was broken or met, the consumer rights and their exceptions, the data exemptions of 6-1-1304(2), penalties (C.R.S. 6-1-112, not pinned), the computation-of-time statute (C.R.S. 2-4-108, not pinned) and every other rule of 4 CCR 904-3 (see deferred_set). The open-textured business links and the ...

## Sources

The statute text is not reproduced here. Read it at Colorado Secretary of State (Colorado Revised Statutes):

| Instrument | Link | Last read |
|---|---|---|
| GenerateRulePdf.do | <https://www.coloradosos.gov/CCR/GenerateRulePdf.do?ruleVersionId=12259&fileName=4%20CCR%20904-3> | 2026-11-16T13:47:57+00:00 |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/us/colorado_cpa){ .md-button }

## Provisions deferred, and what follows

??? info "statute_source_lines_and_editors_notes"

    **Why:** The eighteen Source lines list the acts that enacted and amended each section (the publisher's history notes); the four Editor's notes explain renumbering, harmonisation and repeal dates. They are notes of the publisher, not text of the law. They were all read for reading (1) (the only 2026 act named is HB 26-1426, which added 6-1-1315) and the notes of 6-1-1311 give the dates of reading (9) (open questions Q4 and Q17); the order cites none of them.

    **Consequence for a user:** No answer cites a note; the start date of the cure provision and the version of the text rest on them (reading (1), (9)).

??? info "statute_repealed_clauses"

    **Why:** These units hold only a label and the word 'Repealed.': 6-1-1303(17.5), [quotation omitted] 6-1-1311(1)(d)(I). The last was the general sixty-day cure period; reading (9) states that it is not in force and that no other cure period is in the pinned statute. No rule is left in these units.

    **Consequence for a user:** No answer gives the general cure period: it is repealed (reading (9)).

??? info "definitions_the_keys_use"

    **Why:** The definitions of 'consumer' (6-1-1303(6)), 'sale' with its exclusions (6-1-1303(23)), 'biometric data' (6-1-1303(2.4)), 'biometric identifier' (6-1-1303(2.5)) and 'controller' (6-1-1303(7)) give the meaning of consumer_count, revenue_or_discount_from_sale, processes_biometric_data and of the person the applicability queries speak of. The caller applies them when it states those facts (reading (3)); the order does not test them.

    **Consequence for a user:** The caller counts consumers, classifies revenue as from a sale and states whether it handles biometric data under these definitions; the answers do not check that it did.

??? info "other_definitions"

    **Why:** The lead-in of 6-1-1303 and its other definitions (adult, affiliate, authenticate, biological data, child, consent, dark pattern, minor, personal data, processing, processor, sensitive data, targeted advertising and the rest) are used by duties this order does not formalise, or by the caller's premises (that the recipient of a request is a controller, that a request is authenticated, that the processing is for targeted advertising).

    **Consequence for a user:** No answer reads these definitions; the caller's premises rest on them.

??? info "short_title_and_legislative_declaration"

    **Why:** 6-1-1301 gives the short title and 6-1-1302 the general assembly's findings, determinations and declarations, including that part 13 addresses minors' data. They state purposes, not a rule with a date or a figure.

    **Consequence for a user:** No answer rests on the declaration.

??? info "applicability_lead_in_and_data_exemptions"

    **Why:** 6-1-1304(1) opens with '[quotation omitted]', which reading (3) applies by putting the person exemptions first; the lead-in of 6-1-1304(2) says 'This part 13 does not apply to:'. Clauses (a) to (k), (n), (o) and (p) of 6-1-1304(2) exempt kinds of information and data (protected health information, research data, credit reporting activity, data under GLBA, DPPA, COPPA and FERPA, employment records, public utility customer data, data of public bodies and state institutions of higher education used for noncommercial purposes, and others), not a person; only the person clauses (l), (m) and (q) are formalised.

    **Consequence for a user:** in_scope does not say that part 13 reaches every piece of data the controller holds; the data exemptions are the caller's to apply (reading (3), (12)).

??? info "applicability_limits_and_burden"

    **Why:** 6-1-1304(3) says what the obligations do not restrict (compliance with law, legal claims, security, internal operations and the rest, age verification, free speech); (4) limits processing under an exception; (5) puts the burden of showing an exemption on the controller. They limit duties, not coverage or a date.

    **Consequence for a user:** No answer says whether a limit of 6-1-1304(3) excuses a response or other duty (reading (12)).

??? info "consumer_rights_request_methods_fees_and_authentication"

    **Why:** 6-1-1306(1) grants the consumer rights (opt out of targeted advertising, sale and profiling; access; correction; deletion; portability, at most twice per calendar year) and sets the request methods, authorised agents, the opt-out method and the consent after a universal opt-out (6-1-1306(1)(a)(IV)(C)); only the date and the controllers of 6-1-1306(1)(a)(IV)(B) are formalised (reading (10)). 6-1-1306(2) is a heading unit; (2)(c) makes the information free of charge except [quotation omitted] [quotation omitted], for which a charge calculated under C.R.S. 24-72-205(5)(a) (not pinned) may be made; (2)(d) relieves a controller that cannot authenticate the request. This order takes the request as given and formalises its deadlines only.

    **Consequence for a user:** The deadline answers never say whether the right exists, whether a charge may be made, or whether authentication failed (reading (5), (12)).

??? info "appeal_process_and_attorney_general_contact"

    **Why:** 6-1-1306(3)(a) requires an internal appeal process available within a reasonable period after the consumer receives the notice of no action, [quotation omitted] [quotation omitted] request process; (3)(c) requires the controller to tell the consumer of the ability to contact the Attorney General. Only the periods of (3)(b) are formalised (reading (7)).

    **Consequence for a user:** No answer says whether an appeal was in time or whether the appeal process is adequate (reading (7)).

??? info "enforcement_authority_deceptive_practice_and_receipts"

    **Why:** 6-1-1311(1)(a) gives the Attorney General and district attorneys exclusive authority to enforce part 13; (1)(b) and 6-1-1310(1) exclude a private right of action; (1)(c) makes a violation a deceptive trade practice for their enforcement; 6-1-1311(2) sends civil penalty receipts to the state treasurer; 6-1-1310(2) allocates liability by comparative fault. None states a date or a figure; the penalty figures are in the unpinned C.R.S. 6-1-112 (see the row on it).

    **Consequence for a user:** attorney_general_action_status speaks of the cure provision only; no answer names a penalty amount or speaks of an action by anyone but the Attorney General or a district attorney (reading (9), (11)).

??? info "controller_processor_minors_assessment_and_other_duties"

    **Why:** 6-1-1305 (controller and processor duties and contracts), 6-1-1305.5 (duties toward minors), 6-1-1307 (processing de-identified or pseudonymous data; exceptions to the rights), 6-1-1308 (controller duties, privacy notice, purpose specification, minimisation, care, sensitive data), 6-1-1308.5 (minors' consent duties), 6-1-1309 and 6-1-1309.5 (data protection assessments, including for minors) and 6-1-1312 (preemption of local law) set duties and limits outside this order's dated-duties slice. Their own dates are not formalised.

    **Consequence for a user:** The answers never say whether a controller or processor met these duties (reading (8), (12)).

??? info "rulemaking_opinion_letters_and_advisory_council"

    **Why:** 6-1-1313 lets the Attorney General make rules, required universal opt-out rules by July 1, 2023 and allowed opinion-letter rules by January 1, 2025, effective by July 1, 2025: dates for the Attorney General, not for a controller. 6-1-1314 (added by HB 24-1130) governs opinion letters on biometric data. 6-1-1315 (added by HB 26-1426, effective August 12, 2026: the only 2026 change in the pinned Source lines) creates the Colorado privacy act advisory council of three members, with terms, meetings at least twice a year and a repeal on September 1, 2032. None sets a dated duty of a controller.

    **Consequence for a user:** No answer speaks of the Attorney General's rulemaking dates, opinion letters or the advisory council (reading (1), (12)).

??? info "rules_history_and_effective_date"

    **Why:** The History note of 4 CCR 904-3 lists the effective dates of the rules (new rules effective 07/01/2023; amendments effective 01/30/2025 and 12/01/2025); Rule 1.03 makes the rules effective on the date the Secretary of State publishes, save for delayed effective dates. They fix the version of the rules, read for reading (1) (open question Q17); Rules 5.07 and 5.08 carry their own dates.

    **Consequence for a user:** No answer gives the effective date of a rule; the version question stays open (reading (1)).

??? info "rules_universal_opt_out_other"

    **Why:** Rule 5 sets the rights exercised through a universal opt-out mechanism, notice and choice, default settings, personal data use limits, the technical specification (5.06), the public list and its criteria (5.07(A) to (E): the initial list to [quotation omitted]), recognition of unlisted mechanisms (5.08(B)), the choice to honour a mechanism before July 1, 2024 (5.08(C)), authentication and display (5.08(D) to (F)) and consent after an opt-out (5.09). Only the six-month period of 5.07(F) and the duty and date of 5.08(A) and 5.08(A)(3) are formalised (reading (10)).

    **Consequence for a user:** No answer says which mechanisms are listed or whether a mechanism meets the specification (reading (10)).

??? info "rules_consumer_rights_and_responses"

    **Why:** Rule 4 sets how requests are submitted and how each right is honoured (opt-out as soon as feasibly possible, access, correction, deletion, portability), authentication (4.08) and responses (4.09); Rule 4.09(A) points back to the timing [quotation omitted] [quotation omitted] (b) and adds no period; Rule 4.09(C) lists what a denial must state. This order formalises the statute's periods only (reading (5)).

    **Consequence for a user:** No answer says whether a response met Rule 4; the deadlines are the statute's (reading (5), (12)).

??? info "rules_other_parts"

    **Why:** Rules 1 (basis, severability, exemptions), 2 (definitions), 3 (disclosures), 6 (privacy notices and duties of controllers, including the minors' duties of 6.13 and 6.14), 7 (consent), 8 (data protection assessments), 9 (profiling), 10 (opinion letters and interpretive guidance), 11 (enforcement considerations) and 12 (the incorporated accessibility guidelines) set duties and procedures outside this order's dated-duties slice.

    **Consequence for a user:** No answer reads these rules (reading (12)).

??? info "computing_time_statute_not_pinned"

    **Why:** The general Colorado statute on computing time is not pinned. This order counts calendar days from the event, the day of the event not counted, and moves no last day for a Saturday, Sunday or legal holiday (reading (4); open question Q2). If that statute applies to the periods of 6-1-1306 and 6-1-1311, a last day may move.

    **Consequence for a user:** A date this order gives that falls on a Saturday, Sunday or legal holiday is given unmoved; the caller or a lawyer checks whether a later day applies.

??? info "deceptive_trade_practice_penalties_not_pinned"

    **Why:** 6-1-1311(1)(c) makes a violation of part 13 a deceptive trade practice; the civil penalty amounts for deceptive trade practices are in C.R.S. 6-1-112, which is not pinned. The pinned text of part 13 states no penalty figure, so this order gives none (reading (11)).

    **Consequence for a user:** No answer gives a penalty amount; a caller needs the penalty section itself.

