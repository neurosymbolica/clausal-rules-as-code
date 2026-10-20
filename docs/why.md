# Why this matters

## The cost of knowing what the rules require

Every business and public body has to work out what the law requires of it, case by case, and
the cost of doing so falls hardest on the smallest. Small and medium-sized enterprises make up
99 % of businesses in the EU, and much of the cost of compliance is fixed: reading the rules,
working out which apply, checking each case. A European Commission expert group put the
pattern in one ratio: where a large company spends one euro per employee to meet a regulatory
duty, a medium-sized enterprise may spend around four, and a small business up to ten.

The Commission's Competitiveness Compass (January 2025) sets the aim of cutting administrative
burden by at least 25 %, and by at least 35 % for SMEs. Cutting the burden need not mean weakening
the protections the rules exist for. Much of the cost lies not in what a rule requires but in
finding out, case by case, what it requires: a rule stated once, precisely, in a form that
software can execute and a lawyer can check, costs less to apply correctly, and the rule itself
stays exactly as strong as before.

## The same law, applied many times over

An EU regulation is applied by thousands of firms, advisers, banks, contracting authorities and
supervisors, each building its own interpretation into its own spreadsheet, checklist or
software. The work is repeated, the readings drift apart, and when the law changes each copy has
to be found and fixed. A shared, open, executable formalization, tied provision by provision to
the official text, can be checked once and reused by all, and its reading can be discussed in
the open.

## A direction already set in policy

- The **Interoperable Europe Act** (Regulation (EU) 2024/903, in force since April 2024) builds
  a framework for interoperable public services across borders and sectors, and the Commission's
  Better Regulation agenda calls for **digital-ready policymaking**: legislation designed from
  the start to be implemented digitally.
- The OECD's Observatory of Public Sector Innovation set out the case for **Rules as Code** in
  *Cracking the Code* (2020), and administrations in several countries have built executable
  versions of benefit and tax rules.
- New EU legislation is increasingly data-driven in its own design: thresholds, deadlines,
  ownership percentages and reporting duties that are naturally computed rather than read.

## Public infrastructure that the public controls

If the reading of a law is built into software, whoever controls the software controls the
reading. Executable law that public bodies and businesses depend on should therefore be open,
inspectable and runnable without depending on any single vendor or foreign service. This
project is built that way:

- the formalizations, the tools and the documentation are published under the EUPL-1.2, the
  European Commission's own open-source licence;
- the engine is open source, and everything runs on an ordinary computer, offline, on
  infrastructure the user controls;
- no personal data is collected or sent anywhere, and no cloud service or AI model is needed to
  run a domain or check its answers;
- public procurement, the area of law that decides how administrations buy software, is itself
  among the domains formalized.

## Why open, verifiable formalizations, and why now

Machine assistance now makes it practical to draft formalizations at scale. That makes the
question of trust more pressing, not less: a formalization is only useful if anyone can see
which text it implements, which reading it took, what it left out, and whether it gives the
right answers. That is what this repository is built to show, for every domain it contains.

The problem is not only European. Every jurisdiction that publishes law faces the same gap
between the text and its application, and an open method, licence and toolchain can travel.
