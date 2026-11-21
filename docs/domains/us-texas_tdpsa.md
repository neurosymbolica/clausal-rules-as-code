# Tex. Bus. & Com. Code ch. 541 (Texas Data Privacy and Security Act): for one person or controller the caller describes, whether the chapter applies (Sec. 541.002(a), ...

`us/texas_tdpsa`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 235/235 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Tex. Bus. & Com. Code ch. 541 (Texas Data Privacy and Security Act): for one person or controller the caller describes, whether the chapter applies (Sec. 541.002(a), (b); the SBA small-business determination is an attested outside fact, never computed); the last day to respond to a consumer request or to tell the consumer the controller declines to act (Sec. 541.052(b), (c)); the last day of the once-extended response period or that no extension is available (Sec. 541.052(b)); the last day to answer an appeal in writing (Sec. 541.053(c)); the last day of the 30-day cure period after the attorney general's written notice (Sec. 541.154); on a reference day, whether the cure period is running, the attorney general may bring an action, or no action may be brought for a cured violation (Secs. 541.154, 541.155(a)); and the maximum civil penalty in whole US dollars (Sec. 541.155(a)). Periods are calendar days from the event, the event day not counted, never moved for weekends or holidays (Tex. Gov't Code 311.014 not pinned). Out of scope (handed to the caller or a lawyer): whether conducting business in Texas or the necessity of an extension holds (open-textured judgements), the SBA size ...

## Sources

The statute text is not reproduced here. Read it at Texas Statutes (Texas Legislature Online):

| Instrument | Link | Last read |
|---|---|---|
| Texas Business and Commerce Code, chapter 541 | <https://statutes.capitol.texas.gov> | 2026-11-16 |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/us/texas_tdpsa){ .md-button }

## Provisions deferred, and what follows

??? info "definitions_the_keys_use"

    **Why:** Sec. 541.001 defines 'business associate', 'consumer', 'controller', 'covered entity', 'institution of higher education', 'nonprofit organization', 'personal data', 'process', 'sale of personal data' and 'state agency'. They give the meaning of processes_or_sells_personal_data, of atoms of entity_category and of the premise that the caller is a controller; the caller applies them when it states the keys (reading (11), Q13).

    **Consequence for a user:** The caller classifies the person and its processing under these definitions; the answers do not check that it did.

??? info "other_definitions"

    **Why:** The lead-in of Sec. 541.001 and its other definitions (affiliate, authenticate, biometric data, child, consent, dark pattern, deidentified data, sensitive data, targeted advertising, third party, trade secret and the rest) are used by duties this order does not formalise.

    **Consequence for a user:** No answer reads these definitions.

??? info "quoted_units_formalised_in_part"

    **Why:** Sec. 541.002(b)(2) also excludes 'data subject to Title V' of the Gramm-Leach-Bliley Act, a data exclusion not formalised (Q12); Sec. 541.052(b) and (c) also require a response 'without undue delay' and give the content of a notice declining to act, of which only the latest day is formalised (Q18); Sec. 541.155(a) also makes the penalty follow a breach of the written statement, read by attorney_general_action_status and civil_penalty_maximum through their keys, while a violation of Sec. 541.107 is not formalised.

    **Consequence for a user:** The answers never say which data are excluded, whether a response was given without undue delay or what a declining notice must say (reading (5), reading (11)).

??? info "exempt_information_inapplicability_and_coppa"

    **Why:** Sec. 541.003 lists information exempt from the chapter; Sec. 541.004 makes the chapter inapplicable to certain processing; Sec. 541.005 treats compliance with the parental consent requirements of the federal children's online privacy law as compliance with the chapter's parental consent duties.

    **Consequence for a user:** in_scope does not say that the chapter reaches every piece of data or processing of the person (reading (11)).

??? info "rights_request_conditions_fees_authentication_and_appeal_process"

    **Why:** Sec. 541.051 grants the consumer rights and says how they are invoked; Sec. 541.052(a), (d), (e) and (f) set the duty to comply 'except as otherwise provided', the free responses twice a year, fees and refusals for manifestly unfounded, excessive or repetitive requests, authentication, and deletion of data obtained from others; Sec. 541.053(a), (b) and (d) set the appeal process, its period 'within a reasonable period of time', and the complaint mechanism after a denied appeal; Sec. 541.054 voids waivers; Sec. 541.055 sets the methods for submitting requests.

    **Consequence for a user:** The deadline answers never say whether the right exists, whether a fee may be charged or the request refused, whether authentication failed, or whether an appeal was brought in time (reading (7), reading (11)).

??? info "controller_processor_assessment_and_deidentified_data_duties"

    **Why:** Secs. 541.101 to 541.106 (controller duties and transparency, privacy notice, sale of data and targeted advertising, duties of a processor as amended by H.B. 149 eff. January 1, 2026, data protection assessments, deidentified and pseudonymous data) set duties without a dated period this order reads.

    **Consequence for a user:** The answers never say whether a controller or processor met these duties (reading (11)).

??? info "small_business_sensitive_data_rule"

    **Why:** Sec. 541.107 forbids a small business under Sec. 541.002(a)(3) to sell sensitive personal data without the consumer's prior consent and subjects a violation to the penalty of Sec. 541.155 (Q20).

    **Consequence for a user:** applicability_status answers out_of_scope for a small business although Sec. 541.107 binds it; no answer speaks of that rule (reading (3)).

??? info "enforcement_authority_website_investigation_injunction_fees_and_no_private_action"

    **Why:** Sec. 541.151 gives the attorney general exclusive authority to enforce; Sec. 541.152 sets its website and complaint mechanism; Sec. 541.153 its civil investigative demands; Sec. 541.155(b) to (d) the action to recover the penalty or an injunction, the recovery of fees and expenses and the deposit of the penalty; Sec. 541.156 excludes a private right of action.

    **Consequence for a user:** The answers speak only of the cure period, whether the action may be brought, and the maximum penalty; never of injunctions, fees, investigations or a private action (reading (9), reading (10)).

??? info "construction_permitted_purposes_and_preemption"

    **Why:** Secs. 541.201 to 541.205 say how the chapter is construed, the purposes for which data may still be collected, used or retained, disclosures to third parties, certain processing, and preemption of local rules.

    **Consequence for a user:** The answers never say whether a permitted purpose excuses a duty (reading (11)).

??? info "computing_periods_rule_not_pinned"

    **Why:** The general Texas rule on computing periods is not pinned. This order counts calendar days from the event, the day of the event not counted, and moves no last day for a Saturday, Sunday or legal holiday (reading (4); Q1). If that rule applies to the periods of Secs. 541.052, 541.053 and 541.154, a last day may move to a later day.

    **Consequence for a user:** A date this order gives that falls on a Saturday, Sunday or legal holiday is given unmoved; the caller or a lawyer checks whether a later day applies.

??? info "small_business_size_standards_not_pinned"

    **Why:** Sec. 541.002(a)(3) refers to the Administration's definition, which this order does not pin or formalise; the determination is the attested outside fact small_business_as_defined_by_sba (Q10).

    **Consequence for a user:** The caller attests whether the person is a small business; absent, the answer is referred.

