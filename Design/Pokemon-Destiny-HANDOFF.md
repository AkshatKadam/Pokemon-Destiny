# Pokémon Destiny — Home Machine Handoff

> ⚠️ **HISTORICAL DOCUMENT (original planning, work-machine).** Much here is now superseded.
> **For current state, read `Design/dev/DEVLOG.md` (source of truth) and `Design/Prologue-Spec.md`.**
> Key updates since this was written: project found on the home machine and reconciled (it was the
> stock Essentials demo + a thin Destiny layer); **upgraded v20.1 → v21.1**; **Following Pokémon EX**
> installed; Eyjaf encounters curated & compiled; demo content quarantined; starters locked
> **Treecko/Litten/Froakie**; boat captain disambiguated to **Branson**. Current scope = **foundations +
> a polished Prologue to ship**; the Act V / Stein ending is OUT of scope (user handles separately).
> The full-game analysis below remains a useful design reference.

---

## 0. How to use this file

You (Claude, on the home machine) are picking up an in-progress fangame project. The project files live on THIS (home) machine. The planning so far happened on a separate work machine with no access to the project files. This document is the bridge.

**First actions when this session starts:**
1. Ask the user for the project folder path, then read its structure (`Data`, `PBS`, `Plugins`, `Graphics`, `Audio`).
2. Confirm the Essentials version on disk matches what's recorded below (v20.1).
3. Then pick up at the agreed next step (Section 6).

---

## 1. Project snapshot

- **Title:** Pokémon Destiny (working title)
- **Engine:** Pokémon Essentials **v20.1** + RPG Maker XP
- **Style target:** Gen 4/5-style graphics, fully original story / world / characters / fakemon-and-roster
- **Region:** Volua (plus connected regions: Sylia, Sifrier, Torria)
- **Machine policy:** Build ONLY on the home machine, never during work hours. Planning/writing can happen anywhere.
- **Current build state:** Plot + character bios written (master doc), world map drawn (third-party tool), Essentials v20.1 installed, first 2 towns built in-engine. Everything else is design, not yet built.
- **Source documents:** "Pokemon Destiny Master Document.docx" (full plot/screenplay + character bios + gym themes + legendary plan) and the hand-drawn world map image.

---

## 2. Division of labor (agreed)

- **User does (RPG Maker XP GUI work):** maps, tile placement, visual event editing, art direction, original art/sprites/tilesets.
- **Claude does (everything scriptable/text):** all Ruby scripting (RGSS / Essentials plugins), all PBS data generation and validation, design writing, balance/level-curve work, crash-log debugging (paste error + backtrace).

Claude **cannot**: operate the RPG Maker XP GUI, draw pixel art. Claude **can** help with art specs, palettes, asset naming/organization, and batch image processing.

---

## 3. Development roadmap

**Phase 0 — Project hygiene (do once, early)**
- Put the whole project under git (local repo is fine). Commit regularly. This is the safety net against corrupt saves / bad plugins.
- Lock the Essentials version; keep a separate clean-install backup.
- Decide and install the full plugin list now (e.g. Following Pokémon, modern battle UI) before scripting custom systems on top.

**Phase 1 — Design Bible (~80% done; finish it)**
- Region structure, gym/town themes, evil-team plot beats, rival arc, fakemon/roster dex plan, type chart.
- The plot, character bios, gym themes, and legendary plan already exist in the master doc. Remaining gaps are listed in Section 5.

**Phase 2 — Systems & data foundation**
- Lock the dex as PBS data: every species' types, base stats, abilities, movesets, evolutions.
- Trainer rosters + level curve across the critical path.
- Encounter tables per route. Custom mechanics decided now, not bolted on later.

**Phase 3 — Vertical slice**
- Build ONE complete, polished loop: starter pick → beat Gym 1. Validates systems, pacing, and fun before mass production.

**Phase 4 — Content production**
- Repeat the proven loop town by town. This is where Claude's PBS/data generation saves the most time.

**Phase 5 — Polish & playtest**
- Balance passes, crash-log fixing, cutscenes (intro/ending), music, credits.

**Sequencing rule:** Do not start Phase 2+ until the Design Bible (Phase 1) is locked, because dex and trainer data flow from it.

---

## 4. Story analysis (done on work machine)

Overall: well above typical fangame quality. Real thematic spine, coherent political world, an antagonist with an actual ideology. Score as-is: ~8/10 ambition & worldbuilding, ~6.5/10 execution discipline. Weaknesses are fixable polish, not structural.

### Strengths (preserve these)
- **Premise:** fallen, amnesiac former Champion recovering his past while climbing back against the man who deposed him. "Memories of a Past Life" framing + the Celebi "do it all over again" hook give a strong emotional engine.
- **Stein** (Bismarck + Katakuri): a pragmatic authoritarian who respects the player and whose final monologue is half-reasonable and genuinely unsettling. The story's biggest asset.
- **Badge-as-HM-key mechanic:** HM distribution outlawed to keep the populace dependent; badges decrypt HMs. Turns the most tired Pokémon convention into diegetic worldbuilding + political metaphor. Best original idea in the doc — keep it.
- **Finale structure:** three towers, each unpacking one commander's backstory/motivation before the Nova tower. Fire Emblem / Persona-tier payoff architecture.
- **Norse/Germanic mythos:** Asyrium, three realms (Alfheim/Jotunheim/Midgard) mapped to the three kingdoms, Valhalla, Sacred Trees. A genuine identity, reinforced by the map.
- **Curated legendary core:** Victini (victory) at the heart, Kalos aura trio (Xerneas/Yveltal/Zygarde balance) as central myth, Unova Tao dragons (Reshiram/Zekrom) for Stein and rivals.

### Weaknesses (fix, in priority order)
1. **Ending is TBD.** The Stein choice is the thesis of the entire game and is undefined. Highest priority — design it FIRST; it retroactively defines the meaning of everything before it.
2. **Naming collision.** Nearly every antagonist starts with G (Gale, Gallaghar, Gryffin, Goliath, Gunter) plus the city Galafrei. **Gunter is used twice** (Gym 1 weaponsmith AND the boat captain, who is elsewhere called Branson). Disambiguate. If the shared initial is a Team Might motif, make it deliberate and tighten it.
3. **"You look familiar" overused** (Gallaghar, Van Njord, Amira). Good motif once or twice; vary how recognition surfaces.
4. **Act IV sags.** Strong forward momentum in Acts I–III collapses into a lore-delivery detour (Stormstead → Spiralshire → Dunkelgard). The Zigmond/Darkrai reveal is excellent, but the act needs a stronger personal stake between the castle defeat and the finale.
5. **HM load is heavy** (Cut, Flash, Rock Smash, Surf, Strength, Fly, Dive/Waterfall, Rock Climb = 8). Even with the clever badge framing, that's a lot of party-slot tax. Consider a shared field-move item or trimming mandatory-path HMs.
6. **Legendary bloat in post-game.** The catch list is essentially every legendary ever; it dilutes the curated Kalos/Unova core and clashes with the Norse identity. Curate to the handful that fit Volua's mythology.
7. **Celebi de-aging underexplained** on the main thread (only clear in the deprecated detailed prologue). It's load-bearing for the premise; make it unambiguous.

### Map-to-story check
Geography supports the route logically: Eyjaf island start → Ibitha → Steinsburg → Riverlands/Caspia → Torria desert/Dengron → Sylia & Sifrier arcs across the seas → Starlands/Valask. Sea crossings are motivated. TODO: audit for orphans (named gym/plot cities that aren't on the map, and vice versa).

---

## 5. Known design gaps to fill (Phase 1 remainder)

- **Act V ending / the Stein choice** and its consequences (the central decision). TOP PRIORITY.
- Protagonist (PN) name still pending; gender-selectable adult, age 29.
- Several "[Events]" / "[some events here…]" placeholders throughout Acts I–V need fleshing out.
- Michelle's home delta is named "???" — needs a name.
- Some post-game legendary triggers marked "(?)" / "???" (Terrakion, Giratina, Rayquaza, Latios/Latias locations).
- Type chart decision: vanilla or custom? (Gyms use 16 of 18 types; Normal and Poison are unused for gyms.)
- Fakemon vs. canon roster decision: the doc currently uses canon species for all gym leader / commander / Elite 4 teams. Decide how much is original 'mon vs. canon.

### Reference: gym themes & badges (from master doc)
- Gym 1 — Workshop, Steel+Fighting — Stark badge — leader Gunter (HM Cut)
- Gym 2 — Riverlands, Grass+Water — Lotus badge — leader Frieda (HM Flash)
- Gym 3 — Furnace, Rock+Fire — Paladin badge — Dengron colosseum / Gryffin clash (HM Rock Smash)
- Gym 4 — Cloudburst, Electric+Flying — Tempest badge — leader Himmel (HM Surf comes Act II/III)
- Gym 5 — Glacier, Ice+Ground — Norse badge — leader Diana
- Gym 6 — Sleeping Beauty, Ghost+Fairy — Jinx badge — leader Amira (HM Fly)
- Gym 7 — Reptilian, Bug+Dragon — Erudite badge — leader Royce
- Gym 8 — Manipulation, Dark+Psychic — Subvert badge — leader Zigmond
- Unused types: Normal, Poison

### Reference: act structure
- Prologue (Eyjaf island): tutorial, obtain Victini, lose Victini to Team Might, reach Ibitha, meet Prof. Aspen, pick partner.
- Act I "Memories of a Past Life": Gyms 1–3; HMs Cut, Flash, Rock Smash.
- Act II "A Chance for Redemption": Gyms 4–5; HMs Strength, Surf.
- Act III "Showdown in Dreiker Castle": Gym 6; obtain Victini (powerless); HM Fly. Midpoint low: Stein extracts Victini's power.
- Act IV "The Man & the Legend": Gyms 7–8; HMs Dive/Waterfall, Rock Climb. Zigmond/Darkrai reveal at Dunkelgard.
- Act V "What you hold dearest": Attack on the Asyrium; recruit allies; Final Campaign through Victory Road to Valask palace; three-tower commander finale; Stein confrontation (ending TBD).
- Post-game: recruit Elite 4 (Himmel, Byorn, Ulrich, Michelle), re-establish the League, legendary quests.

---

## 6. Recommended next step for the home session

Two tracks, run in this order:

1. **Design (no engine needed):** Resolve the **Act V ending / Stein choice** first. Then a **naming pass** (fix the G-cluster and the duplicate Gunter), then an **Act IV restructure** to add personal stake.
2. **Build (engine):** Phase 0 hygiene — get the project under git and lock the plugin list — then start the **Phase 3 vertical slice** (starter → Gym 1) once the dex/trainer data for that slice is generated as PBS.

Suggested first home-session task: **Phase 0 git setup + read the existing 2 towns' maps/events**, so Claude has full context on the in-engine state before generating any PBS data.

---

## 7. Quick-start prompt (if you want a short version)

> I'm continuing my Pokémon Essentials v20.1 fangame "Pokémon Destiny" on this home machine where the project files live. Read `Pokemon-Destiny-HANDOFF.md` for full context (roadmap, division of labor, story analysis, open gaps). Current state: plot/bios written, world map drawn, Essentials installed, 2 towns built. First, ask me for the project folder path and read its structure. Then let's start with: [Phase 0 git setup / resolve the Act V ending / generate PBS for the starter slice].
