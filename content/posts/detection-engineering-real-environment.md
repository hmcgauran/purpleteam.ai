---
title: "Detection Engineering in a Real Environment: Why Generic Rules Fail"
slug: "detection-engineering-real-environment"
date: 2026-03-26
tags:
  - "Purple Teaming"
  - post
author: Hugh McGauran
excerpt: "I walked into a SOC last month where they'd deployed 847 Sigma rules"
layout: layouts/post.njk
permalink: /essays/detection-engineering-real-environment/
---
I walked into a SOC last month where they'd deployed 847 Sigma rules.

Eight hundred and forty-seven.

The detection engineers were proud. They'd built a comprehensive ruleset covering the entire MITRE ATT&CK framework. Every technique had detection logic. Nothing would slip through, they said.

The SOC was drowning. Sixty percent of alerts were false positives. They'd stopped tuning months ago and just turned off entire rule categories. The analysts were burnt out, clicking "snooze" on everything.

Here's what nobody told them: **Generic detection rules fail in real environments because real environments aren't generic.**

## The Rule That Doesn't Work

Let's look at a real example. This is a common Sigma rule (simplified):

```yaml
title: Suspicious PowerShell Execution
detection:
  selection:
    EventID: 4688
    CommandLine|contains:
      - 'IEX'
      - 'Invoke-Expression'
      - 'DownloadString'
  condition: selection
```

This rule fires when PowerShell runs with suspicious keywords. Seems solid. Catches code injection, right?

Now let's deploy it in a real environment:

1. **Your software deployment tool (SCCM, Ansible, whatever) runs PowerShell scripts with DownloadString.** Alert every 30 seconds. Disable the rule.

2. **Your backup vendor runs scheduled PowerShell jobs that invoke expressions.** Thousands of alerts per day. Tune it out.

3. **Your developers have scripts with "IEX" in comments.** Execution fires on comment lines. Noise.

4. **Your EDR has whitelisting for Microsoft-signed PowerShell; your SIEM doesn't.** It alerts on things EDR already allowed.

By week two, detection engineers have disabled half the rule. By month one, it's gone. And when an attacker *actually* uses PowerShell injection, it's not being monitored because the rule was too noisy to keep.

**The rule didn't fail because it was poorly written. It failed because it was environment-agnostic.**

## Why Generic Rules Don't Survive Contact with Reality

Detection rules written in a vacuum assume:

- No legitimate tools use the same technique
- All environments have the same baseline behaviour
- Detection can be tuned to pure signal (no noise)
- Attackers use the same techniques in every environment

All false.

In a real environment:

**1. Legitimate tooling is weird.** Your backup software might use SMB in ways that look like lateral movement. Your monitoring agent might inject DLLs that look like persistence. Your deployment pipeline might run binaries with command-line obfuscation that looks like evasion.

**2. Baselines vary wildly.** A developer workstation runs PowerShell constantly. A kiosk never does. A bank branch server runs different software than your headquarters. A rule tuned for one environment is useless or too noisy in another.

**3. Tuning for signal means losing sensitivity.** You can build a rule that catches 100% of attacks. But it'll also alert on 10,000 false positives. The choice is: tune aggressively (miss attacks) or accept noise (burn out analysts). There's no free lunch.

**4. Attackers adapt to your environment.** An attacker who knows you monitor PowerShell won't use PowerShell. They'll use legitimate admin tools, scheduled tasks, or techniques that blend into your baseline.

## The Real Problem With Sigma (and YARA, and Generic Rules)

Don't get me wrong—Sigma is excellent. Open-source, community-driven, better than nothing.

But Sigma is a *language*, not a solution. It's like saying "I have a hammer" and expecting to build a house. You need a builder.

When people drop Sigma rules from the internet into their SIEM without context, they get either:

- **Blindly tuned rules** — so permissive they're useless
- **Overly aggressive rules** — so noisy they're turned off within a week
- **Rules that don't apply** — designed for environments completely different from yours

I've seen security teams import 1000 Sigma rules and then abandon 900 of them. That's not a detection programme; that's security theatre.

## What Actually Works

Effective detection is built bottom-up, not top-down.

**Start with your environment baseline.**

Run your legitimate tools and systems for a week. Capture:
- Normal PowerShell execution patterns (what commands, how often, from which systems)
- Normal network connections (which systems talk to which, ports, protocols)
- Normal process relationships (which processes spawn which children)
- Normal file writes (where legitimate software writes, when, how often)

Write this down. This is your signal floor. Anything below this is noise; anything above is suspicious.

**Then build detection for your actual threats.**

Not MITRE ATT&CK. Not Sigma. Your threats. FIN7 would use living-off-the-land techniques in *your* environment. Ransomware would move laterally using *your* admin tools. Insiders would access *your* sensitive data paths.

Build rules for those specific paths, in your specific environment, against your specific baseline.

**Example:** You know that administrative access to your financial database should only come from 3 specific systems, at 2 PM on Mondays (batch job), from 2 specific service accounts.

Anything else? Alert immediately. No false positives because you know your baseline.

**Tune for precision, not coverage.**

Don't try to detect every possible attack technique. Detect the ones that matter *to you*. Quality over quantity.

Ten precise, high-fidelity rules that catch real attacks beat 1000 rules that trigger on everything.

## The Role of Generic Rules

Sigma and community rules aren't useless. They're a starting point—a hypothesis library.

Use them like this:

1. **Review** — Which techniques are relevant to my threat model?
2. **Understand** — What is this rule trying to catch? How does it work?
3. **Evaluate** — Would this actually detect an attack in my environment, or would it be lost in noise?
4. **Adapt** — Rewrite it for my baseline. Add context (system type, user, time of day). Whitelist known legitimate use cases.
5. **Test** — Run it against historical data. Does it catch what you expect? How many false positives?
6. **Deploy** — Only if it's precise enough to keep tuned for more than a month.

This takes time. It's not as fast as importing 800 rules. But it works.

## The Uncomfortable Truth

If your detection programme consists of:
- Rules from the internet
- Sigma rules you didn't adapt
- Detection thresholds you didn't tune
- Coverage of every MITRE ATT&CK technique

...then you have a detection programme in name only. In practice, you're hoping someone else's rules work in your environment. They usually don't.

The uncomfortable part: **Detection engineering is environment-specific work.** It can't be outsourced to community rules or vendor defaults. It requires someone who understands:
- Your systems (what's normal)
- Your threats (what's dangerous)
- Your tools (what they can actually detect)

That person is on your team. Or you don't have effective detection.

## What's Next

**For your detection programme:**
1. Audit your rules. How many do you actually tune and maintain? Delete the rest.
2. Establish your baseline. Document normal behaviour for critical systems and techniques.
3. Build environment-specific rules for your threat model. Don't import; adapt.
4. Focus on precision. Ten good rules beat 1000 mediocre rules.
5. Invest in the people who know your environment. That's where effective detection lives.

---

**Further Reading:**
- Detection Engineering and Threat Hunting (Marcus Hutchins): Real-world detection work
- Security Data Science (Andrew Pendergast): Baselining and anomaly detection
- Florian Roth's Sigma rules: Study how they work; understand why you'll need to adapt them

**Question:** How many detection rules do you maintain? How many are turned off? We should talk about that.

---

*Next week: Building a detection baseline for your critical systems. Plus: A real case where generic rules missed an entire attack.*
