# SIGNATURE — AMLR beneficial-ownership chain

`effective_ownership(HOLDINGS, PERSON, ENTITY, EFF_BPS)` and `ubo_status(HOLDINGS, PERSON, ENTITY, VERDICT)`. HOLDINGS = list of `[HOLDER, HELD, PCT_BPS]`. EFF_BPS in basis points; VERDICT in {eligible, ineligible} (the shared terminal triple — eligible = a beneficial owner, ineligible = not a beneficial owner via the Art 52(1) ownership limb); threshold 2500 bps (25%), inclusive `>=`.
