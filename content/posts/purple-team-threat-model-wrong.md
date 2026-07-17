---
title: "Your Purple Team Test Failed Because Your Threat Model Is Wrong"
slug: "purple-team-threat-model-wrong"
date: 2026-03-20
tags:
  - "Purple Teaming"
author: Hugh McGauran
excerpt: "You ran a purple team exercise last week. Your red team executed a flawless attack chain: initial access via phishing, lateral movement via Kerberos relay, privilege escalation, and data exfiltration. Picture perfect"
layout: layouts/post.njk
---
You ran a purple team exercise last week. Your red team executed a flawless attack chain: initial access via phishing, lateral movement via Kerberos relay, privilege escalation, and data exfiltration. Picture perfect.

Then you got the debrief: your EDR caught nothing. Your SIEM was silent. Your firewalls didn't alert. Your detection engineers looked at you and said, "Our tools are misconfigured."

They're wrong. And you probably are too.

The problem isn't your tools. It's that your red team tested an adversary that doesn't exist in your environment.

## The Fundamental Mismatch

Here's what I see happen in most purple team programmes:

1. **Red team is given a playbook.** Usually MITRE ATT&CK or some vendor-blessed "attack pattern." Test everything: initial access, lateral movement, persistence, exfil. Be creative.

2. **Blue team sits and watches.** They monitor alerts. When nothing fires, they assume detection is broken. They tune. They add rules. They adjust thresholds.

3. **Repeat.** Next quarter, red team runs the same tests. Still nothing fires (or things fire randomly, drowning in false positives). Conclusion: "We need better tooling."

Here's what's actually happening: **You're testing threat capabilities your environment doesn't support.**

## An Example

Let's say you're a mid-sized financial services firm. Your threat model is: targeted APTs (FIN7, Lazarus), occasional script kiddies, insider threats.

Your environment:
- Windows 10/11 workstations, hardened build
- Modern domain controllers with Kerberos hardening
- Network segmentation: finance backend on isolated VLAN, can't reach from general corp network
- EDR deployed globally
- No plaintext credentials stored on endpoints
- Conditional Access enforces multi-factor authentication
- Sensitive data is encrypted at rest

Your red team shows up and runs Mimikatz, tries Kerberos relay attacks, attempts lateral movement across network segments, and exfiltrates via unencrypted channels.

**Result:** EDR blocks the binaries. Lateral movement fails (segmentation). Encrypted data stays encrypted. Nothing detectable because nothing succeeds.

Your blue team concludes: "EDR is misconfigured. We need better visibility into Kerberos traffic. We need better encryption key logging."

**Wrong.** Those attacks don't fit your threat model. An actual FIN7 intrusion into your environment would:
- Use living-off-the-land techniques (no Mimikatz)
- Move laterally via legitimate admin tools (RDP, WinRM) already allowed in your firewall rules
- Steal credentials from memory *over time*, not via flashy in-memory attacks
- Exfil via HTTP/HTTPS, not SMB or DNS tunneling (you'd flag those)

So your EDR *should* miss those attacks, because they're not your risk. Your tools are configured for your actual adversary, not the MITRE ATT&CK checklist.

## The Real Cost of Environment-Agnostic Testing

When you run tests that don't align with your threat model:

1. **You get false confidence.** Red team "successfully" executes techniques. You feel like you're being tested thoroughly. You're not—you're watching simulations that would never work in the real world.

2. **You waste blue team time.** Detection engineers spend weeks building rules for attacks that will never happen to you. That time could go to hunting for actual threats or hardening critical systems.

3. **You create alert fatigue.** All those detection rules for non-existent threats? They generate false positives. Your SOC tunes them down or disables them. Then an *actual* threat uses a legitimate technique you didn't adequately monitor.

4. **You fund vendor marketing.** Tool vendors love environment-agnostic testing. It justifies upgrading to the latest SIEM module, the newest EDR feature, the fancy threat hunting platform. None of which you needed if your testing was threat-model-driven.

## What Actually Works

Stop testing "everything." Start testing what you're actually at risk from.

**Step 1: Define your threat model.**
Ask yourself:
- Who targets companies like mine? (Organized crime, state-sponsored, activists, insiders?)
- What are they after? (Financial data, IP, customer PII, operational disruption?)
- What access do they typically start with? (Phishing, supply chain, credential stuffing, insider?)
- What's their environment awareness? (Will they know about my network segmentation? My EDR?)

Write this down. Three paragraphs, maximum. "Our primary threat is FIN7. They target financial services via spear-phishing to get initial access to non-critical systems. They spend weeks moving laterally to reach our payment processing tier."

**Step 2: Map your environment against that threat.**
- What attack paths does your threat model realistically have access to?
- Where can they move? (Based on segmentation, not assumption.)
- What techniques are *actually* possible? (Not "Mimikatz might work;" does it work *here*?)
- What detection gaps exist on those paths?

**Step 3: Test only the relevant paths.**
Your red team doesn't run the MITRE ATT&CK playbook. They run *your* threat playbook.

If FIN7 uses spear-phishing + living-off-the-land lateral movement, test that. 

If they exfil via HTTPS, test that — and tune your detection to spot anomalous HTTPS traffic from workstations.

If they're blocked by your segmentation, celebrate the segmentation and move to the next gap.

## The Honest Conversation

Here's what I'd tell your security team:

> "Your tools are configured correctly for the threats you actually face. When red team tests succeed using techniques that wouldn't work in a real intrusion, that's not a detection failure—that's a sign your test wasn't threat-driven. Let's refocus on the adversaries who can actually hurt us, and build detection for *those* attack paths."

This conversation is uncomfortable because it implies your purple team programme might be theater. But it's the one that matters.

## What's Next

**For your next purple team exercise:**
1. Spend time defining threat model, not technique selection
2. Have blue team validate which attack paths are realistic in *your* environment
3. Red team tests those paths, trying to evade detection on actual adversary techniques
4. Blue team tunes for *those specific* gaps

The tests will be less flashy. You won't check every MITRE ATT&CK technique. But when red team succeeds, it means something: you've found a real gap against a real threat.

That's worth a lot more than catching Mimikatz on a hardened system that would never run it in the first place.

---

**Further Reading:**
- MITRE ATT&CK: A framework, not a testing roadmap
- Threat modeling: Microsoft's threat modeling guide
- Practical Purple Teaming (Alfie Champion): Methodology for real collaboration

**Have a counter-argument?** Reply in the Discord community—let's debate threat modelling.

---

*Next week: How to actually scope a red team exercise to your threat model. Plus: Real detection gaps we found in a financial services engagement.*
