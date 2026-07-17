---
title: "Purple Teaming That Actually Works: A Framework for Real Collaboration"
slug: "purple-teaming-that-actually-works"
date: 2026-04-10
tags:
  - "Purple Teaming"
  - post
author: Hugh McGauran
excerpt: "You've got a red team and a blue team. They hate each other"
layout: layouts/post.njk
permalink: /essays/purple-teaming-that-actually-works/
---
You've got a red team and a blue team. They hate each other.

Red team thinks blue team is incompetent because they don't understand adversary tradecraft. Blue team thinks red team is reckless because they don't understand operational risk. They don't talk unless it's a quarterly "engagement."

Then someone tells you about "purple teaming" and you think: "Problem solved."

It's not. Purple teaming is a methodology that requires real work. Most programmes fail because they're treated as a project (quarterly test) instead of a practice (continuous collaboration).

Here's how to actually do it.

## The Failure Mode

Most purple team attempts follow this pattern:

**Month 1:** Announce purple team programme. Red and blue teams meet. There's optimism.

**Month 2–3:** Red team runs a "collaborative exercise." Blue team watches. Debrief is awkward. Red team did things blue team thinks are wrong. Blue team didn't detect things they think they should have.

**Month 4:** Nothing changes. Red team goes back to thinking about attacks. Blue team goes back to reactive defense.

**Month 5:** "Why aren't we purple teaming anymore?" Meeting gets scheduled.

**Month 6–12:** Quarterly reports replace continuous collaboration. Programme becomes checkboxes.

Why does this happen? Because purple teaming requires fundamentally different thinking, and no one allocated time for that shift.

## What Purple Teaming Actually Is

Purple teaming isn't red team + blue team in the same room. It's:

**Continuous, aligned, threat-model-driven collaboration between attack and defense.**

That's different from:
- Red teaming (I attack; you detect what I did)
- Blue teaming (I defend; hope you don't break my things)
- Penetration testing (Contract engagement with findings)
- Security auditing (Compliance check)

Purple teaming means:

- Red team understands blue team's detection capabilities and constraints
- Blue team understands attack sequences and threat actor patterns
- Both teams align on what matters (threat model)
- Both teams iterate continuously to improve both attack and defense
- Collaboration is built into operations, not scheduled quarterly

## The Framework

Here's how to actually build it:

### 1. Establish Shared Threat Model (Week 1)

Red and blue teams sit together. No red team slides, no blue team slides. Just reality.

**Questions to answer together:**

- Who threatens us? (Be specific: APT groups, competitors, insiders, criminals)
- What do they want? (Data, disruption, espionage, financial gain)
- How do they typically access our environment? (Phishing, supply chain, stolen creds, physical access)
- What paths exist from initial access to objective? (Not "any path"—realistic paths given our segmentation and security controls)
- How much time do they have? (Minutes? Hours? Days?)
- What detection would burn them? (At what point does our environment go "we're under attack"?)

Document this. Literally write it down. "We believe APT28 targets financial services via spear-phishing for initial access. They move laterally within 2-4 hours. They exfil via HTTPS to infrastructure we can't block."

**This is not a consultant document. This is the shared foundation.**

### 2. Map Realistic Attack Paths (Week 2–3)

Now, given that threat model, what are the actual attack paths?

Not "everything MITRE ATT&CK says is possible." The paths your threat model actually uses.

Draw them:

```
Initial Access (phishing email)
    ↓
User clicks, code executes (PowerShell, Word macro, whatever)
    ↓
Reverse shell / beaconing established
    ↓
Lateral movement to: [SQL server? File server? DC? Not everywhere—only where they'd go]
    ↓
Objective: [Exfil financial data? Plant backdoor? Disrupt systems?]
```

Blue team adds detection points:

```
Initial Access → EDR monitors suspicious process execution
    ↓ (if they evade)
Reverse shell → Firewall monitors outbound HTTPS to unknown IPs
    ↓ (if they evade)
Lateral movement → Network monitoring for admin tool usage on [specific systems]
    ↓ (if they evade)
Objective → Data loss prevention monitors file access patterns
```

Now you have an attack sequence + detection sequence. This is what you test. Not everything. This.

### 3. Red Team Operates Within Constraints (Ongoing)

Red team's job changes. They don't try to breach the environment. They try to follow the realistic threat path while evading detection.

Rules:
- Start from your actual initial access vector (phishing, not "assume we're already in")
- Move only to systems your threat model would target
- Use tools/techniques your threat model would use
- Avoid detection, don't just run commands

When red team succeeds: "We successfully executed the threat model while avoiding detection."

When red team fails: "We were detected at the lateral movement phase."

Both are valuable. Both tell blue team something real.

### 4. Blue Team Hunts Actively (Ongoing)

Blue team doesn't passively watch. They actively hunt for the attack.

Weekly threat hunting sessions:

- "Given our threat model, what would the initial access look like?"
- "What can we detect in the first 30 minutes?"
- "Can we spot lateral movement before they reach the objective?"

Use Atomic Red Team playbooks, but scoped to your paths.

Update detection rules based on what red team teaches them about evasion.

### 5. Iterate (Monthly)

Once a month, red and blue teams sync:

- What did red team learn about evasion?
- What did blue team learn about detection?
- Did our threat model change? (New threat intel, new attacks in the wild?)
- How did we do against a realistic attack? Faster than last month? More detection?

Adjust next month's exercises based on findings.

## The Governance

For this to work, you need:

**Time allocation:**
- Red team: 20% of their week to collaborative exercises (not 100% red ops)
- Blue team: 5–10% of SOC time to active hunting (not just passive monitoring)
- Leadership: Time for monthly sync and iteration

**Metrics (not vanity metrics):**
- Mean time to detect (for the threat model you care about)
- Mean time to respond
- Techniques red team is using that blue team isn't catching
- Detection improvements month-over-month

**Escalation path:** If red team finds something critical (real vulnerability, not just "technique works"), what happens? (Shouldn't be stuck in a quarterly debrief.)

## The Uncomfortable Part

This takes time. It's not shiny. It doesn't fit neatly on a security audit checklist.

You can't outsource it to a quarterly consultant. You need your own people, aligned on threat model, collaborating continuously.

If you don't have budget for this, purple teaming won't work. You'll run the motions and get the theatre. You won't get the results.

But if you do this right, you get something real:

- Red team that understands why they're testing what they're testing
- Blue team that detects threats faster
- Security operations that improve month-over-month
- Collaborative culture instead of siloed teams

## Checklist: Do You Have a Real Purple Team Programme?

- [ ] Shared, documented threat model (written, agreed by red + blue + leadership)
- [ ] Realistic attack paths (not "test everything," but specific sequences)
- [ ] Red team constrained to threat model (not unlimited scope)
- [ ] Blue team actively hunting (not passively monitoring)
- [ ] Monthly sync between teams (with iteration, not just reporting)
- [ ] Detection improving month-over-month (measurable)
- [ ] Budget allocated (not "squeeze in around other work")

If you don't check most of these, you have a red team and a blue team. You don't have purple teaming.

---

**Further Reading:**
- Practical Purple Teaming (Alfie Champion): The operational playbook
- VECTR: Framework for adversary emulation and red teaming
- Active Defense: Threat modelling for defence

**Question:** Do you have a documented threat model that both red and blue teams agree on? Start there.

---

*Next week: Building a threat model with your team. Plus: How to measure purple team ROI without vanity metrics.*
