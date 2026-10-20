# For lawyers and policy makers

Questions a legal or policy reader is likely to ask first, answered as plainly as we can.
Where the answer is "not yet", it says so.

## Is this legal advice? Who is responsible for an answer?

No. A domain computes what its rules say for the facts it is given, and shows the provisions
it relied on. It does not establish facts, weigh evidence or exercise discretion, and it is not a
substitute for a lawyer or for the competent authority. Responsibility for any decision stays
with whoever makes it. The domains are best read as an executable, checkable statement of one
reading of the law, which a lawyer can confirm, correct or reject.

## Has a lawyer reviewed these formalizations?

Not yet, independently. Each domain records its interpretive choices, the provisions it leaves
out and the reason for each, precisely so that a qualified reviewer can examine them one by one
(see [Lawyers in the loop](lawyers.md)). Independent legal review is the natural next step for
anyone building on this work, and the repository is organized to make that review efficient.

## How were the formalizations made?

They are written to a fixed method: a commissioning specification for each domain fixes its
legal question, the provisions in scope and the expected kind of answer; the rulebase is then
drafted with machine assistance and must pass every check described in
[How it is checked](validation.md) before it is accepted. Nothing in a domain is accepted on
the strength of how it reads: each claim is backed by a check that can be re-run.

## Which version of the law does a domain implement?

The one it pins. Each domain carries, under `sources/`, the extract of the official text it was
written against, fetched from the Publications Office (EUR-Lex), with its CELEX number, the
consolidated version date, the date it was fetched and a SHA-256 fingerprint of the bytes. A
domain is therefore exact about *which* text it implements, and a change in the law shows up as
a new pinned version whose differences can be reviewed.

## What happens when the law changes?

The pinned text is replaced with the new consolidated version, and the checks tell you what
moved: quotations that no longer match the new text fail, and the provision-tracking ledger
shows every unit of the new extract that is not yet formalized or deferred. Nothing is silently
carried over.

## How are discretion and vague terms handled?

They are not resolved by the program. Where the law leaves room ("duly substantiated", "reasonable
effort"), the domain either takes that judgement as an input supplied by the person using it, or
defers the provision with a stated reason. Where a provision admits more than one reading, the
domain's manifest records the readings considered, the one chosen and whether the choice is the
more conservative one (four of the eight domains in this release record such readings, eighteen
in all), so that the choice is visible rather than buried in code.

## What does a domain do with incomplete or wrong input?

It refuses or answers "indeterminate"; it never guesses. Every domain in this release has
robustness tests that drop each required input in turn, feed values of the wrong type, give an
empty profile and leave values blank, and check that no definite answer comes back and nothing
crashes.

## Can an answer be explained?

Yes. Results carry the citations of the provisions that produced them, and the checklist form of
each decision shows which conditions were met, which were not and which could not be decided.
The same facts always give the same answer: the programs are deterministic, with no statistical
model involved at run time.

## Does this make it an AI system under the AI Act?

The programs themselves are deterministic rules executed by a logic engine; no machine-learning
model runs when a domain answers a question. Whether a particular deployment falls within the AI
Act depends on how and for what it is used, which is for the deployer to assess. Machine
assistance was used to draft the rules, which is one more reason the method relies on checks a
reader can re-run rather than on trust.

## What about the other official languages?

The current release quotes the English text. The method supports parallel quotations in other
official languages, checked against the same pinned source in that language; one domain already
carries French records in its working version, held back from this release until it is complete.
Because the rules cite provisions, not words, the logic is shared across languages.

## Does it cover national law, such as the transposition of a directive?

No. The procurement domains implement the Directive's own provisions. Member States transpose
directives with their own choices, which a national layer would add on top, citing the national
measure in the same way.

## Is any personal data processed?

The programs run locally on the facts a user supplies and keep nothing. They store no data, call
no external service and need no network access once installed.

## Can it be reused and extended?

Yes. Everything is published under the European Union Public Licence (EUPL-1.2), the engine is
open source, and every check runs on an ordinary computer with two commands (see
[Run it yourself](run.md)). A new domain follows the same method and is held to the same checks.

## Is this tied to one vendor's engine?

No, and that is by design. The rules are written in Clausal Prolog, a restricted subset of ISO
Prolog, the international standard for Prolog. A Clausal Prolog program is therefore also an ISO
Prolog program, meant to run on any ISO-conforming engine, several of which are independent and
open source. See [Standards and openness](standards.md).

## Why logic programs rather than a general-purpose language or a language model?

A logic program states each condition of a provision as a rule that can be read next to the
text it implements, and the same program can be asked different questions: is this lawful,
what is missing, what would change the answer, where is the threshold. The answers are exact,
repeatable and come with their reasons, which is what review and accountability require.
