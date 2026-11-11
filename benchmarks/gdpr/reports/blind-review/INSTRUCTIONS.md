# Independent blind legal review

Two independent qualified GDPR reviewers must each rate a separate copy of the same
items.jsonl before seeing the other's ratings. A third independent qualified GDPR
adjudicator resolves disagreements; an independent analyst performs the analysis.
All roles start UNASSIGNED in roles.json. Record actual identity, qualifications,
acceptance date, independence from authorship and conflicts before final analysis.
An imported reviewer identifier alone does not certify qualifications or independence.

The legislation directory contains the exact pinned English GDPR article text and
its source manifest. Source-file hashes were verified before copying. Use the
item's relevant_articles and the complete article text when assessing its legal
bases and exceptions; the provisional reference is not authoritative gold. Copy
verification does not itself certify that a source run supplied those same law
bytes: run-law provenance is separately checked by the release CLI. Null article
metadata in a synthetic/development fixture is not a verified article selection.

To assign reviewer_1, reviewer_2 or third_adjudicator in roles.json, replace that
role's null with an object containing id, qualifications, independent_of_authorship
(true only if actually declared), conflicts (including an explicit no-conflict
declaration when applicable), and accepted_at (ISO date/time). The third_adjudicator
must also declare independent_of_reviewers: true and have a different id from both
reviewers. Keep independent_analyst null until a real person accepts that role.
Declarations are recorded; this tool does not independently verify credentials.

After independent imports, adjudication_export creates a pending checklist. For
each dispute, an actual third reviewer chooses resolution {"choice":"first"},
{"choice":"second"}, or {"choice":"custom","ratings":[complete original rating
objects with scores, legally_correct, severe_error, required_points, errors,
comment and question_id]}. Every dispute needs rationale and resolved_at. Preserve
the original ratings, blind IDs and source hashes. Complete adjudicator,
qualifications (matching roles.json), independent_of_reviewers_and_authorship and
signed_at, and only after actual sign-off change status to completed. Agreements
also require that sign-off. finalize_adjudication validates these files, recomputes
the primary/severity/rubric outcomes from actual ratings and retains both original
reviews as hashed evidence. Blank assignments or resolutions never become results.

Edit only ratings. Preserve the case, response and provisional reference exactly.
For every question explicitly set legally_correct and severe_error to true or false.
A severe error is a material legal error that could lead to unlawful processing,
loss of a right, a missed mandatory duty or materially unsafe legal advice. Explain
it in comment, identify the error category and provide supporting point evidence.
Any severe error vetoes correctness. A task is correct only if ALL subquestions are
legally correct with no severe error. Do not infer correctness from rubric points.

Five secondary dimensions each use integer 0/1/2 (wrong or absent / partial / sound):
legal_decision: correct legally qualified conclusion;
conditions: application of the relevant legal conditions to the supplied facts;
exceptions: identifying and applying relevant exceptions, or justifying none;
legal_basis: correct applicable legal bases and accurate supporting references;
uncertainty: acknowledging material missing facts and avoiding invented certainty.
Appropriate definiteness can earn full uncertainty credit when facts are sufficient.
The secondary question rubric score is the sum of these five dimensions / 10.
Mark every required point met true/false with a short evidence explanation. Point
coverage is a separate checklist, never a sixth dimension or primary correctness.
References are provisional; explain a reasoned disagreement rather than copying them.
An unknown/conditional answer can be legally correct; unreviewed is never zero.

Raw product responses are supplied verbatim. Score each case question against that
response; do not invent a structured answer or use an automated judge. System,
model and operational metadata are removed, but style or self-identification in the
answer can reveal a condition. Do not seek identity. Record suspected unblinding.
Pending templates are not results. Adjudication exports are checklists, not approvals.

Error categories: formalization_error, incomplete_answer, inconsistent_reasoning, invalid_citation, missed_exception, missed_missing_fact, missing_action, other, overconfident_conclusion, tool_misuse, unsupported_fact, wrong_deadline, wrong_legal_basis, wrong_role, wrong_scope, wrong_threshold
