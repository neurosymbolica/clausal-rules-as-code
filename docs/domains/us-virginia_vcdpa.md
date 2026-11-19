# Consumer Data Protection Act, Code of Virginia Title 59.1 chapter 53, as pinned from the Virginia LIS web copy fetched 2026-11-16. Decided here: whether the chapter ...

`us/virginia_vcdpa`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 210/210 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Consumer Data Protection Act, Code of Virginia Title 59.1 chapter 53, as pinned from the Virginia LIS web copy fetched 2026-11-16. Decided here: whether the chapter applies to a person (Va. Code 59.1-576(A), (B)); the last day for a controller's response to a consumer request and for its notice of a decline (59.1-577(B)(1), (B)(2)); the last day of the once-only 45-day extension (59.1-577(B)(1)); the last day for the controller's written answer to an appeal (59.1-577(C)); the last day of the Attorney General's 30-day cure period (59.1-584(B)); whether, on a day the caller names, the Attorney General may initiate an action on the noticed violation (59.1-584(B), (C)); and the most that may be sought in civil penalties, 7,500 US dollars per violation (59.1-584(C)). Days are calendar days, the day of the event not counted, and no last day is moved for a weekend or holiday. Open-textured terms (business link to Virginia; reasonable necessity of an extension) are handed to a lawyer as needs_legal_review. Out of scope (the deferred set): the definitions of 59.1-575 the caller applies, the data exemptions and COPPA deeming of 59.1-576(C), (D), the consumer rights, fees, authentication and ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| va-code-59-1-ch53-2026-11-16-lis-copy | as pinned | 2026-11-16T13:43:52+00:00 | `62c62e78b55d4eb6...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/us/virginia_vcdpa){ .md-button }

## Provisions deferred, and what follows

??? info "definitions_the_keys_use"

    **Why:** The definitions of 'consumer', 'personal data', 'sale of personal data' (with its five exclusions), 'nonprofit organization' and 'institution of higher education' in 59.1-575 give the meaning of consumer_count, over_half_of_gross_revenue_from_sale and two atoms of entity_category. The caller applies them when it states those facts (reading (3)); the order does not test them.

    **Consequence for a user:** The caller counts consumers, classifies revenue as from a sale and states the entity category under these definitions; the answers do not check that it did.

??? info "other_definitions"

    **Why:** The lead-in of 59.1-575 and its other definitions (affiliate, authenticate, biometric data, child, consent, controller, processor, sensitive data, targeted advertising, social media platform and the rest) are used by duties this order does not formalise, or by the caller's premises (that the recipient of a request is a controller, that a request is authenticated).

    **Consequence for a user:** No answer reads these definitions; the caller's premises rest on them.

??? info "quoted_units_formalised_in_part"

    **Why:** 59.1-576(B) clause (ii) also exempts 'data subject to Title V' of the Gramm-Leach-Bliley Act, a data exemption this order does not formalise (the person-level exemptions are formalised); 59.1-577(C) also requires the controller to establish an appeal process available within a reasonable period of time, conspicuously available and similar to the request process, and, after a denied appeal, to provide a means to contact the Attorney General: only its 60-day period is formalised; 59.1-584(C) also allows an injunction and directs where penalties, expenses and fees are paid: only the action's condition and the $7,500 figure are formalised.

    **Consequence for a user:** The answers never say which data are exempt under the Gramm-Leach-Bliley clause, whether the appeal process is adequate, or anything about an injunction or the fund (reading (3), (7), (9), (10)).

??? info "data_exemptions_and_coppa_deeming"

    **Why:** 59.1-576(C) lists fourteen kinds of information and data exempt from the chapter (health, credit reporting, education records, employment data and others); 59.1-576(D) deems controllers and processors that comply with COPPA's verifiable parental consent requirements compliant with the chapter's parental consent duty. Both are about data or a consent duty, not about whether the chapter applies to a person or a date.

    **Consequence for a user:** in_scope does not say that the chapter reaches every piece of data the person holds (reading (3), (11)).

??? info "rights_request_conditions_fees_and_authentication"

    **Why:** 59.1-577(A) and (A)(1) to (A)(5) grant the consumer rights (confirm and access, correct, delete, portable copy, opt out) and who may invoke them; the lead-in of 59.1-577(B) says the duties apply 'except as otherwise provided in this chapter'; 59.1-577(B)(3) sets the free responses up to twice annually and the fee or refusal for manifestly unfounded, excessive or repetitive requests; (B)(4) relieves a controller that cannot authenticate a request; (B)(5) deems a controller compliant with a deletion request for data obtained from a third party. This order takes the request as given and formalises its deadlines only.

    **Consequence for a user:** The deadline answers never say whether the right exists, whether a fee may be charged or the request refused, or whether authentication failed (reading (5), (11)).

??? info "social_media_platforms_and_minors"

    **Why:** 59.1-577.1 (added by 2025, c. 703) sets duties for controllers and processors operating a social media platform toward minors under 16: age determination, a default limit of one hour per day per service or application with verifiable parental consent to change it, and limits on use of age information and on degrading service. It is a section of its own and outside the dated duties this order formalises (response, extension, appeal, cure, penalty, applicability).

    **Consequence for a user:** No answer speaks of social media platforms or the daily time limit (reading (1), (11)).

??? info "controller_processor_assessment_deidentified_limitations_and_investigation"

    **Why:** 59.1-578 (controller duties and privacy notice), 59.1-579 (controller and processor roles and contracts), 59.1-580 (data protection assessments; subsection G applies them to processing activities created or generated after January 1, 2023), 59.1-581 (de-identified and pseudonymous data), 59.1-582 (limitations and exemptions for processing) and 59.1-583 (civil investigative demand) set duties and limits that are not part of this order's dated-duties slice.

    **Consequence for a user:** The answers never say whether a controller or processor met these duties, or whether a limitation of 59.1-582 or 59.1-581 excuses a response (reading (5), (11)).

??? info "computing_time_rules_not_pinned"

    **Why:** The general Virginia rules on computing time are not pinned. This order counts calendar days from the event, the day of the event not counted, and moves no last day for a Saturday, Sunday or public holiday (reading (4); open question Q2). If those rules apply to the periods of 59.1-577 and 59.1-584, a last day may move.

    **Consequence for a user:** A date this order gives that falls on a Saturday, Sunday or public holiday is given unmoved; the caller or a lawyer checks whether a later day applies.

??? info "enforcement_authority_expenses_and_no_private_action"

    **Why:** 59.1-584(A) gives the Attorney General exclusive authority to enforce; (D) lets the Attorney General recover reasonable expenses including attorney fees; (E) excludes a private right of action. attorney_general_action_status speaks of the Attorney General's action only and civil_penalty_maximum of civil penalties only; these three subsections change no answer this order gives.

    **Consequence for a user:** The answers never say what expenses may be recovered and never speak of an action by anyone but the Attorney General (reading (9), (10)).

