# Pokémon Destiny — Prologue Implementation Spec

> **Engine:** Pokémon Essentials **v21.1** / RPG Maker XP. **Repo:** `D:\Claude\Pokemon Destiny` (branch `master`, GitHub `AkshatKadam/Pokemon-Destiny`, PUBLIC).
> **Scope:** the shippable vertical slice — game boot → Eyjaf island events → board the boat → reach Ibitha → meet Prof. Aspen → pick partner → "Your journey begins."
> **Source of truth for *current build state*:** `Design/dev/DEVLOG.md` (updated every session). This spec is the *design target*; DEVLOG tracks what's actually built.
> **Division of labor:** this doc is the spec. User builds maps/events in RPG Maker XP; Claude writes recipes (exact editor steps + dialogue), PBS, Ruby. Maps are binary (`Map###.rxdata`) — Claude reads them via `dev_map_dump.txt` (Destiny Dev Tools plugin auto-dumps on debug boot) + map screenshots in `Design/dev/maps/`.

---

## 0. Status & how this Prologue is being built (read first)

**This is a RECONCILIATION, not a from-scratch build.** The early game already exists in-engine, but it implements the *deprecated* prologue flow (letter-to-Hannah delivery, fishing chatter, a Victini placeholder using a DEOXYS battle). **Decision (locked): KEEP & ADAPT** that existing content as the calm "Day 1," then **layer the cold-open before it** and the **fire → Victini → kidnapping beats after it.**

What already works (do not rebuild): Dreidorf village + house doors/transfers, PN's House interior with Mom/Dad NPCs, Hannah's House, the Storehouse, Route 301 (south transfers), Reise Town + Port (Branson sailboat + ferry), Henry's Shop, the Lab skeleton (starter table with 3 balls), Ibitha + indoor maps, curated Eyjaf encounters (compiled), and **Following Pokémon EX** (installed & verified).

What must be BUILT (the story thread): cold-open, the fire scene, Victini joining party + following, the landslide + Victini clearing it, the officers, the kidnapping + Gallaghar, the chase, Branson's boat → Ibitha, Aspen alley rescue, partner pick.

---

## 1. Naming & identity decisions (locked)

| Item | Decision |
|---|---|
| **Starters (Aspen's pick)** | **Treecko / Litten / Froakie** (locked). |
| **Boat captain** | **Branson** (NOT Gunter — Gunter is the Gym 1 weaponsmith). Kills the doc's duplicate. |
| **PN name** | Player-named at start (gender-selectable adult, 29). Norse-flavored default suggestions ok. Player is currently **POKEMONTRAINER_Ash** charset (male) / Leaf (female). |
| **Rescued 'mon** | Victini. Path-clearing special move = **Boulder Blast**. |
| **Mom / Dad** | Exist in-engine in PN's House (currently unnamed NPCs). Optional names: Greta / Aldric. |
| **Hannah** | Raises a Water Pokémon (douses the fire). Suggest Marill/Azumarill. |
| **Celebi de-aging** | OMITTED from playable v1 Prologue (revisit as a cinematic later). |

---

## 2. Switches & Variables

**ALREADY USED by existing build — DO NOT reuse:** `22` (door-exit system), `32` (Victini-battle temp), `53/54/55` (demo roaming debug — remove with demo), `60` (progression / "intro/normal-day" gate, used widely in PN-House/Coast NPC pages), `67` (letter delivered to Hannah).

**Allocate NEW Destiny switches at `#100+`** to stay clear. Suggested mapping (assign real IDs in editor, record back here + in DEVLOG):

| Name | Purpose |
|---|---|
| `S:PrologueStarted` | after cold-open wake |
| `S:VictiniRescued` | after the warehouse fire (Victini joins party) |
| `S:LandslideCleared` | after Victini clears Route 301 |
| `S:RationsDelivered` | after Henry gives supplies |
| `S:OfficersSeenR301` | after passing the questioning officers |
| `S:VictiniComfortable` | morning Victini bonds (gates kidnap) |
| `S:VictiniKidnapped` | Gallaghar takes Victini |
| `S:HannahBriefed` | after Hannah exposition + running shoes |
| `S:ReachedReisePort_Chase` | reached port during chase |
| `S:BoardedBoat` | Branson ferries to Ibitha |
| `S:MetAspen` | after alley rescue |
| `S:PartnerChosen` | after partner pick |
| `S:PrologueComplete` | "Your journey begins" |

Variables: `V:PartnerSpecies`. Self-switches A–D for per-event one-shots.

---

## 3. Real map inventory (from dev_map_dump.txt)

| ID | Map | Size | Prologue role / state |
|---|---|---|---|
| `076` | **PN's House** | 39x15 | Downstairs(left)+upstairs bedroom(right), stairs (17,2)↔(36,2). Mom EV6 (heals, Switch#60, gives letter→#67), Dad EV7. **Demo "Roaming Pokemon" debug EV3 → REMOVE.** New-game start = bed upstairs (coord from user). |
| `022` | **Dreidorf Village** | 38x42 | Home door(16,21)→076; Hannah door(17,11)→048; storehouse door(31,27)→082; north harbour exits(10–13,6)→Route301. Board, mailboxes, placeholder NPCs, FollowerPkmn test events (clean up). |
| `082` | **Dreidorf Storehouse** | 30x15 | THE FIRE scene. Victini placeholder events (DEOXYS cry/battle, Switch#32) + `FollowingPkmn.start_following(3)`. Build real fire + Hannah-douses + Victini-to-party. |
| `048` | **Hannah's House** | 34x15 | Built; placeholder NPC. |
| `077` | **Dreidorf Coast** | 40x36 | Hannah + letter-delivery (sets #67). No land encounters (sand). |
| `078` | **Route 301 "Eyjaf Pathway"** | 43x45 | Only south transfers→Dreidorf. **BUILD: landslide block + Victini Boulder Blast clear + officers questioning.** Tall grass (encounters set). |
| `033`/`083` | **Route P-01 / P-01_2** | 40x56 / 42x40 | Connective grass; encounters set. P-01_2 has no events. |
| `080` | **Reise Town** | 42x33 | Market town; built. |
| `081` | **Reise Port** | 60x40 | Branson **sailboat** (left dock) + **ferry** (right dock). Chase/boarding scene. |
| `085` | **Henry's Shop** | 20x15 | Placeholder "still setting up" NPC → build rations scene. |
| `084` | **Reise Indoors** | 20x60 | Generic interiors (door exits). |
| `043` | **Pokémon Lab (Ibitha)** | 20x15 | Starter table (3 balls) + NPC. Wire Aspen + partner pick. |
| `079` | **Ibitha City** | 110x100 | Arrival; Lab locked; Aspen alley rescue. |
| `032` | **Ibitha Route 302 Gate** | 22x15 | Repurposed Destiny map (keep). |
| `086`/`087` | **Ibitha Bay / Suburb Indoors** | — | Worldbuilding interiors (some remain to build). |

Everything else (Lappet/Cedolan/Battle Frontier/Safari/etc.) is **quarantined demo** — unreachable, connections severed, delete at pre-ship (keep/delete list in DEVLOG).

---

## 4. Following Pokémon EX — how to use (verified)

Plugin: **Following Pokemon EX v2.5.1** (`FollowingPkmn` module). Verified working.
- The **lead party Pokémon auto-follows** when following is toggled on (toggle key = **A** / `Input::JUMPUP`).
- `FollowingPkmn.start_following(event_id = nil, anim = true)` — converts a placed map event into the follower / (re)starts following. **Returns false unless the player has a follower Pokémon** (`get_pokemon`).
- **Therefore the fire scene must: (1) add Victini to the party, then (2) call `FollowingPkmn.start_following`.** At kidnapping: remove Victini from party / `FollowingPkmn.stop_following`.
- Victini follower sprite present: `Graphics/Characters/Followers/VICTINI.png`. (Separate from the `Pokemon_Victini` event charset used for the standing Victini in the Storehouse.)

---

## 5. Beat sheet (the spine)

1. **Cold open** — lullaby in dark → nightmare screech → silence → PN wakes in bed (Map076 upstairs). → `S:PrologueStarted`.
2. **Establish Dreidorf (Day 1)** — KEEP existing: meet Mom/Dad, village NPCs, Hannah; the blocked Route 301 (landslide); the letter-to-Hannah errand (existing). Texture before the storm.
3. **The fire (Night 1)** — Storehouse ablaze, Hannah missing; rush in, find scared **Victini**, Hannah arrives and douses with her Water 'mon; take Victini. **Add Victini to party + start following.** → `S:VictiniRescued`.
4. **Errand to Reise (Day 2)** — Mom sends for supplies; Victini clears the **landslide** (Boulder Blast) on Route 301 → `S:LandslideCleared`; meet **Henry**, free rations → `S:RationsDelivered`; pass **officers** questioning, who eye Victini → `S:OfficersSeenR301`.
5. **Bonding** — Victini comfortable; parents glad PN is "warming to Pokémon again." → `S:VictiniComfortable`.
6. **The kidnapping** — Victini gone; outside, **Hannah beats grunts then loses to Gallaghar**, who takes Victini (remove from party). → `S:VictiniKidnapped`.
7. **Briefing** — Hannah explains Team Might, Gallaghar, brother **Hans** (missing). Mom gives **Running Shoes**. → `S:HannahBriefed`.
8. **The chase** — rush to **Reise Port**; officers board a ship; **Gallaghar** stops PN ("you look familiar"), leaves. → `S:ReachedReisePort_Chase`.
9. **The passage out** — Henry takes PN to **Branson**, who ferries to **Ibitha**; "see the Professor." → `S:BoardedBoat`.
10. **Ibitha** — explore; **Lab locked**; at the exit **Team Might shove Prof. Aspen**; help him up. → `S:MetAspen`.
11. **Call to adventure + partner** — Aspen explains the fallen region, compels PN to rescue Victini, **partner pick (Treecko/Litten/Froakie)** → `S:PartnerChosen`; points to **Steinsburg**. → `S:PrologueComplete` → "Your journey begins…"

---

## 6. Map-by-map event spec

> Build recipes (exact editor steps) are produced per-beat as we go, against live coordinates. Below is the design intent + dialogue beats. Existing events to reuse/adapt are flagged.

### 6.1 PN's House [076] — Cold open + Day-1 morning
- **Cold open (Autorun, new game, before `S:PrologueStarted`):** black screen + soft lullaby BGM → screech SE → beat of silence → fade in on bed → wake. Set `S:PrologueStarted`, self-switch off so it never repeats.
- **REMOVE** the demo "Roaming Pokemon" debug event (EV3).
- **Reuse** Mom (EV6) / Dad (EV7) — they already gate on `Switch#60`. The cold-open should leave state so their Day-1 pages read correctly. (Audit `Switch#60`'s exact role before wiring.)
- Mom (warmth + hook): family farm, village respects PN; Route 301 blocked by landslide.

### 6.2 Dreidorf Village [022] + Coast [077] — Day 1 (KEEP existing)
- Existing letter-to-Hannah errand (Coast, sets `Switch#67`) stays as Day-1 texture. Hannah established as a trainer (rare here).
- Place/confirm the **Storehouse** prominence (door at (31,27)→082) for the night fire.
- Clean up the stray `FollowingPkmn` **test events** (Dreidorf EV10/EV11) once the real follow is wired.

### 6.3 Dreidorf Storehouse [082] — Night 1: The Fire
- Adapt existing Victini events. Replace DEOXYS placeholder with real flow:
  1. Enter at night (Storehouse on fire, Hannah missing) → flames block path → find scared **Victini** (charset `Pokemon_Victini`).
  2. **Hannah arrives**, Water 'mon douses fire.
  3. **Add Victini to party** (`pbAddPokemon(:VICTINI, <lvl>)` or give-event), then `FollowingPkmn.start_following`. → `S:VictiniRescued`.
- Mom: *"There's no time — do something! Stop the fire!"*

### 6.4 Route 301 [078] — Landslide + Officers (BUILD)
- **Landslide** (cond `S:VictiniRescued` ON, `S:LandslideCleared` OFF): rubble blocks path; Victini steps up, **Boulder Blast** animation, rubble clears → `S:LandslideCleared`. First taste of the power Stein later steals.
- **Officers** (return trip, cond `S:RationsDelivered` ON): two Team Might officers question a townsperson; one eyes Victini, acts oddly, lets PN pass → `S:OfficersSeenR301`.

### 6.5 Reise Town [080] + Henry's Shop [085]
- Henry (shocked re: fire) gives **free rations**, will restock storehouse → `S:RationsDelivered`. (Replace the placeholder "still setting up" line.)

### 6.6 Dreidorf — The Kidnapping (BUILD)
- Outside (cond `S:VictiniComfortable`): Victini gone; **Hannah beats grunts, loses to Gallaghar**; Gallaghar takes Victini (remove from party + stop following) → `S:VictiniKidnapped`. Then Hannah briefing + Mom gives **Running Shoes** → `S:HannahBriefed`.

### 6.7 Reise Port [081] — The Chase (BUILD)
- Officers boarding ship; **Gallaghar** stops PN, "you look familiar," departs → `S:ReachedReisePort_Chase`. Henry → **Branson** ferries to Ibitha ("see the Professor") → `S:BoardedBoat`. Departure cutscene (ferry on right dock).

### 6.8 Ibitha City [079] + Lab [043] — Aspen + Partner (BUILD)
- Branson notes he'll ferry back and forth. **Lab locked.** At the city exit, **Team Might shove Aspen**; help him up → `S:MetAspen`.
- At the Lab: Aspen explains the fallen region, compels rescue of Victini, **partner pick** (reuse demo Lab starter-select event as a template; 3 balls already on the table → Treecko/Litten/Froakie). Set `V:PartnerSpecies`, `S:PartnerChosen`. Points to **Steinsburg** → `S:PrologueComplete` → "Your journey begins…"

---

## 7. Encounters (DONE)

Curated Eyjaf set compiled & verified (see `Prologue-Roster-and-Encounters.md`): Route 301 (Starly/Bidoof/Hoppip/rare Cleffa), P-01/_2 (Caterpie/Zigzagoon/Pidove/rare Eevee), Coast (water/fishing only). Tall-grass only.

---

## 8. Remaining foundation (not Prologue-event blockers)

- **PN trainer identity:** currently Ash charset/trainer-type placeholder. Decide final PN sprite/name later.
- **Region/town map:** still v21 "Essen" (Kanto). Rebuild as **Volua/Eyjaf** (v21 moved region-map images to a new Graphics folder — fix then).
- **Demo deletion:** quarantined now; delete map files via RMXP map tree at pre-ship (list in DEVLOG). Copy reusable demo events first (starter-select → Aspen; PC/Mart setups).
- **Title screen / intro:** replace demo with "Pokémon Destiny".

---

## 9. Build order (recommended)

1. **Cold open** (§6.1) — first thing the player sees; self-contained. *(Needs: bed/start tile in Map076.)*
2. Reconcile **Day-1** so existing Mom/Dad/letter content flows from the cold open (audit `Switch#60`).
3. **Fire → Victini party + follow** (§6.3) — the emotional core; uses Following EX.
4. **Landslide + officers** (§6.4).
5. **Henry rations** (§6.5).
6. **Kidnapping + briefing** (§6.6).
7. **Chase + Branson boat** (§6.7).
8. **Aspen + partner pick** (§6.8).
9. Polish: encounters check, title, then full slice playtest + crash-log pass.
