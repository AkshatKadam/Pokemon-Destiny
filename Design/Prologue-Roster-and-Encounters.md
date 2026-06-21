# Pokémon Destiny — Prologue Roster & Eyjaf Encounters (FINAL)

Companion to `Prologue-Spec.md`. Resolves spec §5 (encounters) and §7 (partner roster).

> Status: encounters below are **implemented & compiled** on Essentials **v21.1**. Starters **Treecko /
> Litten / Froakie** are locked (Aspen's partner pick — event not yet wired).

---

## 1. Partner roster — LOCKED

Aspen offers a choice of three at the Ibitha Lab (spec beat §4.10):

| Slot | Partner | Type | Notes |
|---|---|---|---|
| Grass | **Treecko** | Grass | → Grovyle → Sceptile |
| Fire | **Litten** | Fire | → Torracat → Incineroar |
| Water | **Froakie** | Water | → Frogadier → Greninja |

- Standard Grass/Fire/Water triangle — early-gym choice tension preserved (Gym 1 Steel+Fighting, Gym 2 Grass+Water).
- All three have community Gen-4/5-style sprites available; **no Gen 9 Pack required**.
- None outshine Victini narratively — Victini stays the "heart" legendary; partner is the grounded companion.
- On choice: set `V:PartnerSpecies`, give the species (level 5), set `S:PartnerChosen`.

---

## 2. Eyjaf encounters — LOCKED

Design rules: remote sanctuary, humans don't train → peaceful pastoral 'mon only. Levels 2–6. Encounters in **tall grass only** (sand/beach gives nothing). Replaces all Kanto placeholders currently in `encounters.txt`.

### Area tables

**Route 301 / Eyjaf Pathway `[078]`** — first steps, tall grass only
- Starly 40% · Bidoof 35% · Hoppip 20% · **rare Cleffa 5%**

**Route P-01 / _2 `[033]` / `[083]`** — connective grassland (P-01_2 slightly higher levels)
- Caterpie 35% · Zigzagoon 30% · Pidove 30% · **rare Eevee 5%**
- (Zigzagoon = Hoenn/Normal form, not Galarian.)

**Dreidorf Coast `[077]`** — **NO land encounters** (sand). Water + fishing only; mostly reachable on later return trips (no Surf/rod in Prologue itself).
- Surf: Magikarp, Finneon · Fishing: Magikarp (Old), Magikarp/Finneon (Good/Super)

The two rares (Cleffa, Eevee) give the island a "something special lives here" payoff without power-creeping.

---

## 3. Paste-ready PBS — `encounters.txt`

Replace the existing `[033]`, `[083]` blocks; add `[078]` and `[077]`. Density numbers match the project's convention (Land = 21, Water = 2).

```
#-------------------------------
[078] # Route 301 (Eyjaf Pathway)
Land,21
    40,STARLY,2,4
    35,BIDOOF,2,4
    20,HOPPIP,3,4
    5,CLEFFA,4
#-------------------------------
[033] # Route P-01
Land,21
    35,CATERPIE,2,5
    30,ZIGZAGOON,3,5
    30,PIDOVE,3,5
    5,EEVEE,5
#-------------------------------
[083] # Route P-01_2
Land,21
    35,CATERPIE,3,6
    30,ZIGZAGOON,4,6
    30,PIDOVE,4,6
    5,EEVEE,6
#-------------------------------
[077] # Dreidorf Coast  (water/fishing only — no land/sand encounters)
Water,2
    70,MAGIKARP,5,15
    30,FINNEON,10,20
OldRod
    100,MAGIKARP,5,10
GoodRod
    60,MAGIKARP,10,20
    40,FINNEON,10,20
SuperRod
    60,FINNEON,15,25
    40,MAGIKARP,15,25
```

Notes:
- `[077]` water/fishing is defined for completeness but is **return-trip content** — the player has neither Surf nor a rod during the Prologue. Safe to ship as-is.
- If you later adopt the Gen 9 Pack, optional Norse swap: Starly → **Rookidee** (raven, Huginn/Muninn). Not applied here since the starters don't need the pack.
- Confirm each species exists in `pokemon.txt` for the region before testing (all are stock Essentials species, so they should).
```
