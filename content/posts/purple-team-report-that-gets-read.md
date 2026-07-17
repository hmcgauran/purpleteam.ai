---
title: "How to Write a Purple Team Report That Actually Gets Read"
slug: "purple-team-report-that-gets-read"
date: 2026-06-25
tags:
  - "Purple Teaming"
  - "Red Team"
  - "Blue Team"
author: Hugh McGauran
excerpt: "You ran a three-week purple team exercise. Your team worked hard. The red team executed a realistic adversary emulation. Your blue team detected some of it, missed most of it, and the gaps are clear. The debrief went…"
layout: layouts/post.njk
---
You ran a three-week purple team exercise. Your team worked hard. The red team executed a realistic adversary emulation. Your blue team detected some of it, missed most of it, and the gaps are clear. The debrief went well.

Then the report went out.

Two weeks later, you ask the CISO what they thought of the findings. They say "yes, I skimmed it, very comprehensive." They did not. You ask the engineering director if they have started work on the priority items. They say "we're reviewing it." They are not. You check the version of the report on the shared drive. Last modified date is the day it was sent.

The report did not fail because the engagement was bad. The engagement might have been excellent. The report failed because nobody who needed to act on it actually read it. And that is the only thing the report exists to do.

## The Audience Problem Nobody Wants to Solve

Every purple team report has at least three readers. They have different needs, different time budgets, and different levels of technical depth. If you do not consciously design for all three, you end up writing for the one who writes the report — which is the technical operator who already knows what happened.

Here is who actually opens the document.

### The Executive Reader

The CISO, the CIO, sometimes a CRO or COO if the report touches fraud or data. They will spend between three and seven minutes on the report. They will read the first page, glance at the table of contents, skip to any section that mentions their name or a number they recognise, and decide within those few minutes whether the report represents a problem they own or a problem someone else owns.

If the report does not give them what they need in those seven minutes, they will not come back to it later. They have other things to read. The decision they make in those seven minutes is the only decision that matters.

What they need: a one-paragraph answer to "are we exposed to a real, named risk, and is the gap getting fixed or not?" Everything else is detail they will never read.

### The Security Leader Reader

The head of detection engineering, the SOC director, the red team lead, sometimes the IT security manager. They will spend between twenty and forty-five minutes on the report. They will read the executive narrative, the findings in detail, and skim the methodology. They are looking for two things: which findings they will commit to fixing, and which findings they will defend in a meeting with their own leadership.

What they need: findings they can take to a budget meeting, a steering group, or a Monday morning stand-up and defend without having to re-read the report.

### The Engineer Reader

The detection engineer, the SOC analyst, the IT engineer who will actually build the detection rule or change the firewall config. They will spend one to three hours with the report. They will read the evidence chain, the technical narrative, and the detection content. They are looking for one thing: exactly what to build, where to put it, and how to know it works.

What they need: actionable detection content they can drop into Splunk, Elastic, Sentinel, or whatever their stack happens to be, and a test that proves the detection works.

### The Uncomfortable Truth

Most purple team reports are written for the engineer. Which means the executive gets nothing, the security leader skims, and the engineer — who needed it least — is the only person who reads it through.

That is the report's failure mode. It is also the easiest one to fix.

## Why the Default Format Fails

The standard purple team report structure looks like this:

1. Executive summary
2. Engagement overview and scope
3. Methodology
4. Threat model summary
5. Findings table
6. Findings (detailed, one per page)
7. Detection content (as appendix)
8. Recommendations
9. Appendices (logs, timeline, raw output)

This structure is sensible on paper. In practice, it produces a document nobody reads past page three.

### The Executive Summary Trap

The executive summary is supposed to be the answer for the CISO. In practice, it is a condensed version of the findings table: severity ratings, vulnerability counts, "critical," "high," "medium" distributions.

The CISO does not need severity counts. They need a decision. "We have a confirmed gap in how we detect credential theft from finance endpoints. We can close it with one detection rule and one conditional access policy change. Cost: two engineer days. Risk if not closed: high — a known adversary used this technique to reach our staging environment during the exercise."

That is one paragraph. The executive summary should be that paragraph. Not a table. Not a list of severity ratings.

### The Methodology Section Nobody Reads

The methodology section typically describes what the red team did, what tools they used, what the engagement rules of engagement were, and which adversary they emulated. The engineer who wrote the report finds this essential because it justifies their work. The executive finds it unreadable. The security leader skims it.

Move the methodology to the back of the document. Or fold it into the engagement overview. The methodology is reference material. The executive narrative is what gets read.

### The Findings Table: A Pretty Lie

The findings table is the most over-rated element of the report. It looks professional. It is easy to produce. It also flattens everything to noise.

Consider a findings table with twelve rows. Each row has an ID, a title, a severity, an affected system, and a one-line description. The CISO looks at the table. They see "Critical: 3, High: 5, Medium: 4." Their decision: this looks like a normal pentest report, the volume is reasonable, we are probably fine.

The three criticals are not equal. One is a confirmed path from a phished finance user to the payment processing tier, with no detection in place. Another is a misconfigured TLS certificate on a staging environment that nobody important uses. The third is a privilege escalation path that requires the attacker to already have admin on the domain controller — which they could not get because segmentation worked.

A table cannot communicate that. A paragraph can.

The findings table is a sales tool. It works for the security vendor who wants to show a customer "you got value." It does not work for the customer who has to act on the findings. If you have to keep a findings table, keep it. But do not let it be the substance of the report.

### The Detection Content in the Appendix

The detection content — the actual Splunk SPL, the Elastic EQL, the Sigma rule, the Sentinel KQL — lives in the appendix. This is the part of the report the engineer actually needs, and it is the part that gets the least editorial attention.

The detection content is not appendix material. It is a deliverable in its own right. If your detection engineer has to copy-paste from a PDF and clean up formatting before they can test the rule, you have failed the report. The detection content should be a set of versioned artefacts: Sigma rules in YAML files, SPL searches in text files, KQL queries in a query pack, detection-as-code repositories linked from the report.

The report should reference the artefacts. The artefacts should be tested, versioned, and reviewable. The detection content is not the appendix — it is the product.

## Writing for Three Audiences in One Document

You cannot produce three documents. The cost of writing, reviewing, and signing off three versions of the same report is not sustainable. But you can produce one document that reads three ways.

### The Layered Document

The structure that works is layered. Each layer serves one audience. The executive can stop after the first layer and still have what they need. The security leader reads two layers. The engineer reads all three.

1. **Executive narrative** (one page). What we tested, what we found, what the gap is, what we recommend, what it costs, who owns it. No jargon. No tables. No methodology. A short story.
2. **Decision-grade findings** (two to four pages). Each finding is a paragraph. Each paragraph answers five questions in order: what is the risk, what is the business impact, what is the detection gap, what is the recommendation, who owns the fix.
3. **Evidence chain and technical narrative** (as long as it needs to be). Per finding: how the test was run, what was observed, what data was collected, what the detection engineer needs to reproduce the work.
4. **Detection artefacts** (linked, not pasted). Versioned, tested, drop-in Sigma, SPL, EQL, KQL. Each artefact linked from the report, not embedded.

The executive stops at layer one. They have what they need to make a decision. The security leader reads layer one and the findings. They have what they need to take the findings into a budget conversation. The engineer reads everything and has the artefacts to build the detections.

### Why This Works

Each layer earns the next layer. The executive does not feel patronised because they have a one-page document that respects their time. The security leader does not feel condescended to because they get the findings in the form they need. The engineer does not feel like an afterthought because the detection content is a real deliverable, not a screenshot.

You are not producing three documents. You are producing one document that respects the role of each reader. That is the difference.

## The Executive Narrative, Written Properly

The executive narrative is the most important page of the report. It is also the page that gets the worst writing, because the engineer writing the report does not know how to write for an executive.

The mistakes are predictable:

- Burying the decision in methodology
- Using technical severity ratings instead of business risk
- Listing findings without prioritising
- Failing to name an owner
- Failing to name a cost

### A Template That Works

A reliable executive narrative structure:

1. **One sentence on the threat.** "We emulated a financially motivated threat actor targeting customer payment data, the same actor profile that has hit two of our peers this year."
2. **One sentence on what we found.** "We confirmed a path from a compromised finance user to the payment processing tier, with no detection in place at three of the four stages."
3. **One sentence on the business impact.** "If exploited, this path would allow unauthorised access to cardholder data within an estimated four to six hours of initial access."
4. **One sentence on the recommended action.** "Closing this gap requires three detection rules and one conditional access policy change, totalling an estimated ten engineer days."
5. **One sentence on ownership and timeline.** "We recommend the SOC director owns the detection work, completing it within four weeks; the IAM team owns the conditional access change, completing within two weeks."

Five sentences. One paragraph. That is the executive narrative. Everything else in the report exists to support these five sentences.

If the executive reads nothing else, they have: the threat, the finding, the impact, the action, the owner, the timeline. That is what they need to make a decision.

### Write Like a Journalist, Not a Vendor

Engineers writing for executives default to vendor voice. "Comprehensive," "robust," "industry-leading," "best-in-class" — these words signal that the report is a marketing artefact, not an honest assessment of risk. Executives have read enough vendor reports to spot the language. When they spot it, they discount the report.

Journalist voice is different. Journalists lead with the news, attribute claims to evidence, name sources, and avoid adjectives that do not add information. The executive narrative should read like the top of a news article: the threat, the finding, the impact, the response. No adjectives that the evidence does not earn.

Compare:

> "Our comprehensive purple team assessment uncovered critical security gaps requiring immediate remediation across multiple business units."

Versus:

> "We found a path from a phished finance user to cardholder data, with no detection at three of four stages. Ten engineer days to close. SOC director owns the work; four weeks to completion."

The first version sounds like a vendor. The second version sounds like an answer. Executives trust the second version, because the second version respects them enough to skip the padding.

### What Not To Do

Do not start the executive narrative with "This report summarises the findings of the recent purple team engagement…" The executive does not care that you are summarising a report. They care that there is a gap, an impact, a cost, and an owner. Get to it in the first sentence.

Do not use severity ratings. "Critical" means different things to different people. Use business impact in concrete terms. "Cardholder data exposure," "regulatory notification under GDPR," "loss of customer trust in a 30-day window." Those land. "Critical" does not.

Do not list the findings. Pick the top three. The executive does not need all twelve. They need to know which three matter and what is being done about them.

Do not end with "we recommend further assessment." That is the conclusion of a report with no conclusions. End with the named owner, the named deadline, and the named acceptance test. The executive should be able to put the report down knowing exactly who is doing what by when.

## Decision-Grade Findings, Written Properly

A finding is decision-grade when the security leader can take it into a budget meeting and defend it without re-reading the report. That means each finding has to do five things, in order, in one paragraph.

### The Five-Part Finding

**1. The risk.** Not the vulnerability. The risk. "An attacker with a phished finance user account can move to the payment processing tier without triggering any detection."

**2. The business impact.** Not "data could be exfiltrated." The actual business outcome. "Cardholder data exposure affecting approximately 220,000 customer records, with regulatory notification obligations under PCI DSS and GDPR within 72 hours of confirmed breach."

**3. The detection gap.** What specifically is not detected. "Three stages of the attack path — credential theft, lateral movement via WinRM, and access to the payment processing VLAN — generate no alert in our current Splunk and CrowdStrike deployment. The fourth stage (data staging) is detected, but detection occurs after the attacker has already reached the data."

**4. The recommendation.** Concrete, buildable, owned. "Deploy three Sigma rules targeting the missing stages. Estimated effort: five engineer days. Owning team: SOC detection engineering. Target completion: four weeks from sign-off."

**5. The acceptance test.** How you will know the fix works. "The recommendation will be validated by re-running the same test path used in this engagement. Pass criteria: all three Sigma rules fire within five minutes of the corresponding technique, with the alert containing the host, user, and technique stage."

One paragraph. Five sentences. Each sentence has a job. The security leader can read it once, take it to a meeting, and answer questions on it.

### Why Findings Tables Cannot Do This

A findings table can list twelve findings with severity ratings. It cannot answer "is this worth a budget conversation?" Because the answer to that question depends on the business impact, the detection gap, the recommendation cost, and the acceptance criteria — and the table cannot hold all of that in one row.

If you keep the table, keep it as an index. Each row links to the paragraph. The paragraph does the work.

### The Ownable Finding

One test for whether a finding is decision-grade: ask "who owns this, and what is their next action?" If you cannot answer both questions, the finding is not ready.

A finding without an owner is a complaint. A finding without a next action is an observation. Neither of those gets budget allocated, and neither of those gets closed in the tracking system.

Ownable findings have a named owner, a named deadline, a named effort estimate, and a named acceptance test. The owner can disagree with the finding, but they cannot ignore it. The deadline makes the disagreement a project decision, not an open question.

## A Concrete Before and After

This is the part where theory gets tested. Here is a real finding, written the way most purple team reports write it.

### Before

> **Finding ID:** PT-2026-014
> **Severity:** Critical
> **Affected Systems:** FIN-WS-014, FIN-WS-022, FIN-WS-031 (finance workstations)
> **Title:** Lack of detection for lateral movement using WinRM
> **Description:** During the engagement, the red team was able to move laterally from a compromised finance workstation to a finance file server and then to the payment processing staging environment using Windows Remote Management (WinRM). No detection rules fired during this activity.
> **Recommendation:** Implement detection rules for WinRM usage and lateral movement.

That is a real finding. It is also useless. Here is why:

- The "severity" is asserted, not argued.
- The "affected systems" are listed but not explained.
- The "title" is a category, not a risk.
- The "description" describes what the red team did, not what the gap means.
- The "recommendation" is generic.

Now here is the same finding, written the way a decision-grade finding should be written.

### After

> **Risk:** A financially motivated attacker with a single phished finance user account can move laterally to the payment processing staging environment without triggering a single detection. The path was confirmed during this engagement. The same path was used in the 2025 attack on a peer organisation in the same sector.
>
> **Business impact:** Cardholder data exposure affecting approximately 220,000 customer records. PCI DSS requires breach notification within 72 hours of confirmed unauthorised access. GDPR imposes additional notification obligations and potential administrative fines up to 4% of annual global turnover. Estimated incident cost: GBP 2.4M to GBP 6.8M based on industry breach cost benchmarks.
>
> **Detection gap:** Three of the four stages in the path generate no alert in our current Splunk and CrowdStrike deployment. Credential theft from the finance workstation memory was undetected (no LSASS access telemetry rule). Lateral movement via WinRM from finance to the file server was undetected (no rule on WinRM session creation across finance subnets). File server to payment processing staging access was undetected (no rule on cross-VLAN SMB writes to the staging file share). The fourth stage — staging of cardholder data prior to exfiltration — was detected, but detection occurred after the attacker had reached the data.
>
> **Recommendation:** Deploy three Sigma rules targeting the missing stages. Estimated effort: five engineer days, plus two days for testing. Owning team: SOC detection engineering. Target completion: four weeks from sign-off. The three rules are versioned artefacts in the `purpleteam-2026-q2/detection-content/` repository under rule IDs `PT-2026-014-a`, `PT-2026-014-b`, and `PT-2026-014-c`. Each rule includes a unit test against the captured telemetry from this engagement.
>
> **Acceptance test:** Re-run the same lateral movement path used in this engagement, with blue team in active monitoring mode. Pass criteria: all three Sigma rules fire within five minutes of the corresponding technique, the alerts contain the host, user, technique stage, and the SOC responds to the first alert within 15 minutes. The test is scheduled for week five, after the detection engineering team has completed the build.

Same finding. Same evidence. Same gap. Completely different report. The first version tells you there is a problem. The second version tells you what to do about it, who is doing it, what it costs, and how you will know it works.

### Why the After Version Works

The after version is not longer for the sake of being longer. It is longer because it is doing work the before version is not doing. The before version says "lateral movement was undetected." The after version says what that means in pounds, days, and regulatory exposure.

A CISO reading the before version files it under "things the red team found." A CISO reading the after version signs off on the budget allocation.

Notice what the after version does not include. No adjectives. No hedging. No "comprehensive" or "robust." Every sentence carries information the security leader cannot get elsewhere. The verb density is high because the noun density is high; there are no filler phrases. That is the discipline.

## The Evidence Chain

The executive narrative answers "what." The decision-grade findings answer "what to do about it." The evidence chain answers "how do you know."

The evidence chain is what the engineer reader needs. It is also what protects you if anyone challenges the finding later.

### What Belongs in the Evidence Chain

For each finding, the evidence chain should contain:

- The exact commands, queries, or actions the red team executed, with timestamps
- The telemetry those actions generated in the environment, with timestamps
- The detection rules or alerts that did fire (and why they did not fire when they should have)
- The relevant log excerpts, query outputs, or screenshots that demonstrate the gap
- The detection content that should have fired but did not, with the rule that was tested and the reason it failed

The evidence chain is not storytelling. It is reconstruction. The engineer should be able to read the evidence chain and answer "if I had this exact telemetry at this exact time, would I have detected this technique? If yes, why did my detection not fire? If no, what rule would I need?"

### What Does Not Belong

The evidence chain is not the place for narrative storytelling about the engagement. "The red team then proceeded to the finance subnet, where they encountered little resistance…" is not evidence. It is prose.

The evidence chain is also not the place for apologies, hedging, or throat-clearing. "It is worth noting that the detection engineering team is currently working on improving coverage in this area" is not evidence. It is deflection.

The evidence chain is the chain. It goes from action, to telemetry, to detection gap, to rule. Nothing else.

### Format

The evidence chain should be structured, not narrative. Use a consistent template per finding:

- Test ID
- Date and time
- Operator (or "automated test")
- Target system
- Action taken
- Telemetry observed
- Detection rule(s) that should fire
- Detection rule(s) that did fire
- Gap analysis

That template, repeated for each test case, is the evidence chain. It is reviewable, reproducible, and audit-friendly. It is also what the detection engineer will use to write the new rules — they take the action, the telemetry, and the gap analysis, and they have the inputs they need.

### Tools for Capturing Evidence

A few tools that make the evidence chain easier to produce and harder to fake:

- **Sliver, Mythic, or Cobalt Strike** for adversary emulation with built-in logging of every action
- **Atomic Red Team** for repeatable, documented test cases mapped to MITRE ATT&CK
- **Stratus Red Team** for cloud-focused adversary emulation with captured cloud telemetry
- **Velociraptor** for endpoint telemetry queries during the engagement
- **Sentinel One, CrowdStrike, or Defender for Endpoint** forensic timelines for post-engagement reconstruction
- **Splunk, Elastic, or Chronicle** for the detection-rule validation queries

If your evidence chain can be reproduced from these tools, it stands up to scrutiny. If it is reconstructed from memory, it does not.

## Detection Content as Artefacts, Not Appendix

I have said it before. I will say it again, because this is where most reports fail the engineer: the detection content is a deliverable, not a page in a PDF.

### What "Detection Content as Artefacts" Means

It means the detection rules live in a repository. They are versioned. They are reviewable. They have unit tests. They are drop-in ready.

For Sigma rules: a YAML file per rule, with metadata, log source specification, detection logic, false positive notes, and a unit test reference. The unit test runs the rule against a sample of telemetry — captured during the engagement — and asserts the expected outcome.

For Splunk SPL: a savedsearch file with the search, the threshold, the alert action, and a reference to the captured test data.

For Elastic EQL or KQL: a query file with the query, the expected hits, and a test harness.

For network detection: a Zeek or Suricata rule with the same structure.

For endpoint detection: a Velociraptor hunt artefact or a custom EDR query, with the same test structure.

The point: the engineer does not have to copy from a PDF, clean up formatting, and rebuild the rule from a screenshot. The rule is a file they can pull, review, test, and deploy.

### The Repository Structure That Works

A simple structure:

```
purpleteam-2026-q2/
  detection-content/
    sigma/
      PT-2026-014-a.yml
      PT-2026-014-b.yml
      PT-2026-014-c.yml
    splunk/
      pt_2026_014_a.spl
      pt_2026_014_b.spl
    elastic/
      pt_2026_014_a.eql
      pt_2026_014_b.eql
    sentinel/
      pt_2026_014_a.kql
    test-data/
      PT-2026-014-capture.json
      PT-2026-014-expected-alerts.json
  evidence/
    PT-2026-014.md
    PT-2026-014-timeline.csv
  README.md
  CHANGELOG.md
```

The README explains the engagement, links to the report, and lists every detection rule with its finding ID. The CHANGELOG tracks version history. The test data is the captured telemetry from the engagement. The engineer can clone, test, review, and deploy.

### Why This Matters

A detection rule in a PDF appendix is documentation. A detection rule in a versioned repository with unit tests is a deliverable. The difference is the difference between a report and a product.

Reports sit on shared drives. Products get used. If your detection content is a product, your report drives action. If it is documentation, your report drives PowerPoint.

The downstream effect on the engagement is significant. A report that produces a working detection rule gets revisited. A report that produces a screenshot of a rule gets archived. The same engineering work went into both. The packaging determined which one mattered.

## What to Leave Out

The hardest part of writing a good report is not what to include. It is what to leave out.

A few categories that almost always belong in the bin:

### Vendor Marketing

"The CrowdStrike Falcon platform was deployed across all endpoints, providing industry-leading EDR coverage." This is a vendor talking point, not a finding. Cut it. If the EDR was deployed, that fact belongs in the environment context section. If the EDR failed to detect something, that fact belongs in the finding. The middle is filler.

### Methodology Theatre

"The red team utilised a multi-stage adversary emulation framework combining commercial and open-source tooling, executed by senior operators with OSCP and CRTO certifications, against a realistic threat model based on industry intelligence sources." Replace with: "We emulated FIN7 using the techniques documented in their public reporting, against the environment described in section 2." Same meaning. Five lines shorter.

### Apologies and Hedging

"The detection engineering team was not given sufficient notice of the engagement window." This is a process complaint, not a finding. If the engagement window affected detection coverage, that fact belongs in the engagement overview. If it did not, cut it.

### Severity Inflation

"Critical (CVSS 9.8)." The CVSS score is meaningless in a purple team report. CVSS scores vulnerabilities; purple team findings describe detection gaps. Replace with the business impact in concrete terms. The executive trusts the concrete terms. They discount the CVSS.

### Generic Recommendations

"Improve detection coverage across the MITRE ATT&CK matrix." This is a recommendation to do more work. It is not a recommendation to do specific work. Cut it. Replace with: "Deploy the three Sigma rules referenced in PT-2026-014-a/b/c, validated by the acceptance test in PT-2026-014."

A useful rule: if the recommendation could appear in any report for any organisation in any sector, it is generic. Cut it. Replace with the specific action for the specific environment.

## The Reporting Cadence Question

The structure I have described so far assumes a single report, produced at the end of an engagement. That is one valid cadence. It is not the only one, and for most mature purple team programmes it is not the best one.

### The Annual Report Trap

Some organisations run one purple team engagement per year and produce one big report at the end. This is the worst cadence for action.

The reasons are structural:

- The annual report covers twelve months of work. By the time it is written, reviewed, signed off, and distributed, the gap landscape has shifted.
- The annual report is too long to read in one sitting. The CISO will not read it. The security leader will skim it. The engineer will read the findings for their area.
- The annual report ages immediately. Three months after publication, half the findings are out of date.
- The annual report rewards thoroughness, not action. The writer who produces forty findings is rewarded more than the writer who produces four critical ones and three weeks later has them fixed.

### The Quarterly Report Trap

Quarterly reports are slightly better. They are still too long, still too late, and still written for the wrong audience.

A quarterly report arrives once every thirteen weeks. The CISO sees it as one of many quarterly artefacts (board update, risk committee, vendor reviews) and treats it accordingly. The findings get added to a backlog that already has items older than the report.

### The Rolling Weekly Briefing

The cadence that works for mature programmes is the rolling weekly briefing. Short, focused, and tied directly to action.

Each week during an active purple team engagement:

- Two to four findings produced that week
- Each finding written in the five-part format
- Each finding sent to the security leader with an explicit owner and a two-week action window
- Each finding added to the rolling repository with versioned detection content
- Each finding tracked in a simple status table: open, in progress, validated, closed

The briefing itself is one to two pages. Not a 30-page document. One to two pages, with the findings for the week, the owners, the deadlines, and the test plan.

This cadence has three advantages:

1. **Findings are fresh.** The gap is current. The environment has not changed. The recommendation is actionable.
2. **Owners are accountable.** A two-week window is short enough that the owner cannot defer. A six-month roadmap is long enough that nobody owns it.
3. **Progress is visible.** The CISO sees findings being closed, not findings being accumulated.

### When the Big Report Still Makes Sense

The big report is not useless. It has a place: at the end of the engagement, when you want to consolidate the rolling briefings into a single document for the audit committee, the board, or the regulator.

But the big report is the summary of the rolling briefings, not the primary deliverable. The primary deliverable is the weekly briefing. The big report is the artefact.

If you are currently producing one big report per year, the move to rolling weekly briefings will feel like more work. It is not. The total amount of writing is roughly the same. The distribution is different, and the action rate is higher.

## Tools and Platforms That Help

A few tools and platforms that materially improve report quality and reading.

### Reporting Platforms

- **Plextrac**: built for purple team and breach-and-attack simulation reporting. Findings, recommendations, and remediation tracking in one place.
- **Bishop Fox Cosmos**: continuous purple teaming platform with per-finding reports and stakeholder views.
- **AttackIQ**: built around adversary emulation but includes a reporting layer for findings and detection coverage.
- **SafeBreach**: similar to AttackIQ, breach simulation with reporting tied to MITRE ATT&CK coverage.
- **SCYTHE**: adversary emulation platform with customisable reporting templates.

These platforms do not fix a bad report. But they make the good structure easier to produce: per-finding views, executive summaries, detection content linking, and remediation tracking.

### Detection Content Repositories

- **Sigma rules**: the de facto standard for vendor-neutral detection rules. Public repository at github.com/SigmaHQ/sigma.
- **Elastic Detection Rules**: Elastic's official detection content, EQL-based, in a public repository.
- **Splunk Security Content**: Splunk's detection content, SPL-based, in a public repository.
- **Microsoft Sentinel KQL queries**: Microsoft's hunting and detection queries for Sentinel, in the official Microsoft repository.
- **Chronicle Detection Rules**: Google Cloud's detection content for Chronicle SIEM.

If your detection content lives in a similar structure — vendor-neutral where possible, vendor-specific where required, versioned, tested — your report becomes a product, not a document.

### Internal Tools

The tools above are useful. The real leverage, though, comes from building internal tooling around the report:

- A simple markdown-to-PDF pipeline that produces the executive narrative, findings, and evidence chain in a consistent template
- A detection content repository with CI that runs unit tests on every commit
- A status dashboard that shows open findings, owners, and deadlines
- A briefing template that takes the rolling findings and produces the weekly one-pager

None of this requires a vendor platform. It requires treating the report as a product, not a document.

## Common Objections

Three objections to this approach come up regularly. None of them holds up.

### "The CISO Will Not Read Even One Page."

Then the report failed before it was written. If the CISO will not read one page, the engagement did not have executive sponsorship to begin with. The report is the visible artefact of the sponsorship, not the cause of the engagement.

The answer is not to write a 60-page report hoping they will read page four. The answer is to escalate the engagement sponsorship problem before the report is written, and to ensure the CISO has agreed to read the executive narrative before the engagement starts.

### "Our Stakeholders Want Severity Counts."

Then give them severity counts. In a table. At the back of the report. As an index. The CISO gets the executive narrative, the security leader gets the findings, and the stakeholder who wants severity counts gets the table.

You do not have to choose between the executive and the compliance team. You write for each of them in the part of the report they actually read.

### "We Do Not Have Time to Write Per-Finding Paragraphs."

Then write fewer findings. Five decision-grade findings delivered and acted on is worth more than fifteen generic findings ignored.

The report is not a count of what you tested. It is a record of what needs to change. If you do not have time to write the change clearly, you do not have time to test it properly either.

## Monday Morning Takeaways

Five things you can do this week to make the next report actually get read.

1. **Write the executive narrative first.** Before you write anything else, write five sentences: the threat, the finding, the impact, the recommendation, the owner. If you cannot write those five sentences, the engagement is not ready to report.
2. **Stop writing findings tables as the substance.** A table is an index, not a finding. Each row links to a paragraph that does the actual work.
3. **Treat detection content as a deliverable.** Versioned, tested, in a repository, with unit tests against captured telemetry. Not in a PDF appendix.
4. **Switch to rolling weekly briefings.** A one- to two-page briefing per week during the engagement is more actionable than a single 60-page report at the end.
5. **Decide who reads what.** Before the report goes out, name the executive reader, the security leader reader, and the engineer reader. Write to each of them in their section. Do not write to the report's author.

If you do these five things, the next purple team report will be the one your CISO actually reads. And the one your detection engineer actually uses. And the one your security leader actually defends in the budget meeting.

That is what a report is for.

---

**Further Reading:**
- Plextrac reporting templates for purple team engagements
- SigmaHQ rule structure and unit testing guidance
- Detection-as-code patterns in Elastic and Splunk content repositories
- Practical Purple Teaming (Alfie Champion) on stakeholder communication

**Have a counter-argument?** Reply in the Discord community — let's discuss what works in your reporting pipeline.

---

*Next week: How to write a detection rule that survives first contact with production telemetry. Plus: the three false-positive traps that kill most new rules in their first month.*