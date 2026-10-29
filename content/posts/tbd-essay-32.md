---
title: "The Joins Nobody Owns: How Identity, Asset, and Rotation Registries Get Wired Together"
slug: "the-joins-nobody-owns"
date: 2026-11-05
tags:
  - "Purple Teaming"
  - "Identity"
  - "Detection Engineering"
  - "Programme Operations"
  - post
author: Hugh McGauran
excerpt: "The last essay in the identity series ended with a promise: the next thread would cover the joins. This is that essay — why the join between your identity provider and your asset inventory is a maintained artefact with an owner, what happens to an exercise when the join is stale, and why the join work is where a quarterly cadence quietly dies."
layout: layouts/post.njk
permalink: /essays/the-joins-nobody-owns/
---

The last essay in the identity series ended by promising the next thread would move from the perimeter to the joins. This is that essay. It is about the least interesting part of purple teaming and the part that decides whether any of it is worth doing twice.

The claim is simple. A purple team exercise can only find what its model can represent. The model is not the exercise. The model is the set of joins between the registries you already own — identity, assets, applications, credentials, rotations — and a join is a maintained relationship between two things that both change while nobody is looking. Where the joins are current, the exercise finds things. Where the joins are stale or missing, the exercise is not blind in an interesting way. It is blind in the way that produces a clean report.

## What a join actually is

A join is a relationship between two registries, kept current on a schedule, with a named owner and a known failure mode. Identity provider to asset inventory. Identity provider to application. Credential to rotation policy. Application to data store.

The distinction that matters is between an integration and a join. An integration moves data once, usually at build time, usually because someone needed the data on a specific date. A join keeps a relationship true over time, and takes responsibility for it when it stops being true.

Most organisations have the first. Very few have the second. The integration exists in a data engine, written by a team that has since moved on, running on a schedule nobody reads the output of. When the asset inventory adds a laptop, the join between that laptop and the human who holds it does not update. The join continues to assert, with total confidence, that the laptop belongs to whoever belonged to it in 2023.

That is what a stale join looks like from the inside. Not an outage. An assertion that has quietly stopped being true, still being made, still being believed.

## The four registries that have to join

An identity-focused exercise needs four things to be able to represent the world, and each one has to be joined to the others.

The identity provider tells you who holds a credential. On its own it tells you very little about risk, because a credential is only interesting in relation to what it reaches.

The asset inventory tells you what exists — servers, laptops, network appliances, the things with a network location and a name. It rarely tells you who owns them or what they are allowed to reach.

The application registry tells you what systems exist and who administers them. In a mid-sized organisation this is usually the least-governed of the four, because it is the one nobody bought a tool for.

The credential and rotation record tells you when each credential was last rotated, by what policy, and whether the rotation ever happened. This is the registry that makes a cadence possible, because it is the only one that records a history rather than a state.

Now put the joins between them. Identity to asset: this person's credential is on this machine, in this location. Asset to application: this machine is in the estate of this application, with this access. Credential to rotation: this credential rotates on this policy, and was last rotated on this date. Application to data: this application can reach this data store.

Each of those joins answers a question the exercise needs. Each is maintained by someone. Each has a freshness window. If the identity-to-asset join is ninety-six hours stale, then an exercise that emulates a credential theft cannot say with confidence where the credential might be used, so it emulates it everywhere, or it emulates it somewhere convenient and gets a finding about a scenario nobody has.

## What a stale join does to an exercise

This draws on work with mid-to-large enterprises and managed-service providers across regulated and unregulated environments — the specifics anonymised because the customers are not the lesson. The pattern is the lesson.

A health and social care provider, roughly 5,600 staff, six hospital sites and around forty community clinics, most of the clinics acquired rather than built. They had run an identity-focused purple team exercise for two years. The exercise was well-run. The scope was good. The emulation was thorough. The findings were real.

In the second year, the exercise ran against a scope assembled from the identity provider, and the identity provider was clean — one tenant for the four hospital sites, consolidated after an integration project the previous year. The clinics were in a second tenant, still on the platform the group acquired them on, and no one had joined the two tenants because no one had asked for the join; each tenant was internally fine.

The consequence was not a missed finding. It was a mis-scoped finding. The exercise found a set of dormant privileged accounts in the hospital tenant and measured the response to them, and the response was good, and the exercise reported that the programme's privileged account hygiene had a specific, bounded, addressable problem.

The clinic tenant held privileged accounts with wider reach. The exercise could not find them because the clinic tenant was not in the scope, and the scope could not include it because the join between the two tenants did not exist — the platform would emit both, but the account naming convention differed between the acquired estate and the legacy estate, so nothing reconciled them into a single principal list.

Three joins were missing in that environment. The identity join: two tenants, two naming conventions, no reconciliation. The asset join: the hospital sites ran a service management system with a working inventory; the clinics used spreadsheets maintained by practice managers, updated when a clinic changed hands, not when a device did — about 340 devices in no inventory at all. The rotation join: the hospital estate recorded rotations through the privileged access tool; the clinics' service accounts rotated when a contractor remembered to, and nothing recorded it either way.

The exercise reported a bounded problem because the model was bounded. The programme's remediation plan was built against that bounded model, and the bounded model was the truth for the exercise. It was not the truth for the estate. Somewhere behind that boundary, a privileged account in a clinic tenant had been holding access to a shared drive of patient discharge summaries for fourteen months, because no join had ever made it visible and no exercise had ever been able to represent it.

The gap that matters was not in the detection stack. It was in the joins. That is why the programme's quarter-two plan, which added more detection coverage, changed very little: the exercise kept finding the same bounded set of findings because the model it ran against had the same boundaries.

## The join that decides what an exercise can find

There is a specific relationship here that is worth naming precisely, because it is the difference between an exercise that finds things and an exercise that confirms what it already knows.

A model can only represent a gap if the joins can express the gap's shape. The gap in that environment was not a detection gap. Detection worked. The gap was that nobody knew which clinics had devices in the inventory, and nobody knew which tenant held which accounts, and nobody knew when any of it had been joined. To represent that gap, the exercise would have needed a join between the clinic asset spreadsheets and the hospital asset system — a join that would have produced the answer "no", for a quarter of the clinics' devices.

When an exercise finds a gap it can represent, it is doing its job. When it does not find one, the first question worth asking is not whether the detection coverage is good enough. The first question is whether the model could have expressed the gap if the gap had been there. Most of the time the answer is no, and the exercise's clean report is a statement about the model rather than about the estate.

This is also why the same exercise tends to find the same findings every year. A finding that is bounded by the model's boundaries will be found every time, because the boundary keeps the finding in the same place. The programme reads the repeat findings as evidence the estate is not changing. The estate may well be changing. The model is not.

## Who owns a join

A join needs an owner. Not a team that touches it, and not a ticket queue it eventually reaches — a named role with the job of keeping the relationship true and reporting when it stops being true.

In the health provider, once the joins were built, the work belonged to one role, and the role was small. It was not a data engineering job. The engineering was the easy part: two exports, a match on normalised account naming, a scheduled load, a mapping table for the exceptions. The hard part was the standing job.

The job had three parts, and all three are unglamorous.

Knowing the freshness of each join, per registry, with a number attached. The identity-to-asset join was refreshed every fifteen minutes; the asset-to-application join was refreshed nightly; the clinic spreadsheet join was refreshed monthly, by hand, by a person who read the spreadsheets. That last one was the weak link and everybody knew it was the weak link, which is the most useful thing that can be true about a join. The programme's quarterly report carried the freshness numbers for all four joins, and the clinic join's number was the one the steering group asked about every time. That is what the numbers are for.

Owning the exceptions. Every join produces a set of records that cannot be reconciled — a device in a spreadsheet with no matching account, an account with no matching device, an application with no registered owner. A join with an exception queue nobody works is a join that has silently stopped asserting. The provider's steward cleared roughly 60 exceptions a month. Most of them were the same two causes: people who changed role and kept their device, and service accounts whose owner had left. Both were cheap to fix once they were named, and invisible before.

Saying when a join is not good enough to model against. This is the part that gets skipped, because it requires the join's owner to be able to say "the exercise's scope is unreliable this quarter" without being overridden. If the owner of a weak join cannot stop an exercise from running against it, then the join's freshness number is decorative. The provider's rule was that any join with freshness worse than its window blocks the exercise scope, and the first exercise after that rule went in was smaller than the previous one. It found fewer findings and more of them mattered.

## The metric that matters

Coverage percentages are the wrong metric here, and they are the wrong metric in a way that flatters.

An organisation can report 94% asset coverage because 94% of assets appear in an inventory. That inventory is joined to the identity provider at 61% freshness. Both numbers are true and neither is useful, because they describe different joins, and the number being quoted is the one that is easy to produce.

The number that matters is the one that describes whether the model can represent the estate. Two forms of it work.

The first is scope representability: for the exercise's target scenario, can the model say where the credential could be used, what it could reach, and who owns it? If the answer is no for any of the three, the scope is not sound, and the exercise's findings inherit that limitation. This is a precondition of the exercise, not a finding of it, and it should be stated in the report as a precondition.

The second is the findability of the last finding. For each of the previous four quarters' findings, can the current model still represent it? If a finding from Q1 can no longer be represented in the current model, something was removed from the model, and the removal is as important as the finding. A programme that can answer that question has a cadence, because the answer is the delta. A programme that cannot is running four exercises.

There is a third number, less often reported and more useful than either: the time between the join being wrong and anyone noticing. For the clinic join, that was fourteen months. Not because anyone was hiding anything — because nothing was checking. The number is the cost of a join without an owner, expressed in months of exposure, and it is the number that moves when you put someone in the job.

## The discipline that earns the next exercise

The joins are built between exercises. The exercises measure the joins. The findings are the model's blind spots, and the model's blind spots are the joins.

The work that makes the joins survivable is the work that nobody is measuring. Building the join is a project. Keeping the join true is a job. The project ends and the report is written; the job continues, quietly, at the refresh cadence, clearing exceptions and reporting freshness, with no dashboard and no incident to point at. That job is what a quarterly cadence is actually paying for, and it is the first thing to be cut when the budget gets tight, because a join that stops being refreshed does not raise an alert. It just becomes the reason the next exercise finds less than the last one.

The exercise is where you find out whether the joins are good enough. It is not where the joins get fixed.

That is what the join work is for.

---

This essay opens a new thread, following the identity series — [Purple Teaming Your Identity Environment](/essays/purple-teaming-your-identity-environment/), [Containing a Credential-Driven Intrusion](/essays/containing-a-credential-driven-intrusion/), [Purple Teaming a PCI Environment](/essays/purple-teaming-a-pci-environment/), [Quarterly Cadence](/essays/quarterly-identity-purple-team-cadence/) — and it picks up the promise made at the end of the last one: the joins are where a cadence lives or dies. The next essay in this thread will cover the principals in that model that never authenticate like a person: service accounts, API keys, and the standing machine credentials that fill a join inventory once you build one, and what it means to revoke one of them when the thing it unlocks has no owner.
