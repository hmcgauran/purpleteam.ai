---
title: "The Principals Nobody Watches: Detecting Machine Credentials When There Is Nobody to Impersonate"
slug: "the-principals-nobody-watches"
date: 2026-11-26
tags:
  - "Purple Teaming"
  - "Identity"
  - "Detection Engineering"
  - "Programme Operations"
  - post
author: Hugh McGauran
excerpt: "The last essay promised the detection side of the machine principal population. This is it: why a machine credential cannot be emulated the way a person is, the five moves that do work instead, and the null emulation that exposes the difference between a credential that is monitored and one that is merely present."
layout: layouts/post.njk
permalink: /essays/the-principals-nobody-watches/
---

The last essay in this thread ended by promising the next one would cover the detection side of the same population: what a purple team can actually emulate when there is nobody to impersonate, and the difference between a credential that is monitored and a credential that is merely present. This is that essay, and the answer to the second half of that question is doing most of the work.

Purple teaming a human credential has a shape. You take an identity that belongs to someone, authenticate as them, and do the things that person would not do — from a host they do not use, at an hour they do not work, against a resource they do not normally touch. Every detection you hope to fire is a comparison against a normal, and the normal comes from a person. A person's normal is observable because a person has a pattern: a device, a location, a working rhythm, a set of resources they touch to do their job. Break the pattern and there is something for a rule to catch.

A machine principal has no pattern in the sense that matters. An integration account authenticating from the same two hosts at two in the morning every night is not a deviation, because that is the whole of its existence. There is no person behind it to be unlike. There is no device that is its device, no location that is its location, no rhythm that is its rhythm, and no set of resources it uses for its job — only a set of resources somebody granted it once, in a window, for a reason that has since expired. The baseline that every identity detection leans on does not exist for this population, and no amount of log volume conjures it.

This is not a gap in coverage. It is the difference between a population you can exercise and a population you can only count.

## What emulating a machine principal actually means

The moves that work on a human credential are all variations on the same theme: be plausible in every dimension except the one you are testing. Move the source, or the time, or the resource. That approach does not transfer, because each of those dimensions is where the machine principal has no baseline to be implausible against.

So the emulation inverts. Instead of making the credential behave strangely, you make it behave exactly as it always behaves, and change one thing that is not about its behaviour at all. You are not looking for the anomalous session. You are looking for the credential doing something its job has never included.

Five moves do this work.

**Take the grant away.** Use the credential exactly as designed — right source, right protocol, right schedule — and point it at a resource it has never been granted. Nothing about the authentication looks wrong. The credential behaves perfectly. The grant is what is wrong, and the only way to see it is to join the credential to the resources it has ever touched and ask whether this one is on the list.

**Take the host away.** Same target, same protocol, same timing, different host. Here the source matters, but not as a baseline — as a record. Which hosts has this credential authenticated from, ever? A host that appears once is a finding whether or not there is a pattern behind it.

**Take the window away.** The integration runs at two in the morning. Run it at ten on a Saturday, or three times in an hour, or on a day the upstream system was down for maintenance. Nobody needs a behavioural model of this credential to notice that it authenticated outside its window. They need the window written down.

**Take the volume away.** Same source, same target, same hour, forty times the usual count of records. Volume is the one dimension where a machine principal has a reliable normal, because integrations are metronomic. They are also the easiest thing to miss, because volume anomalies are usually tuned against human traffic and a nightly feed produces enough volume to sit under every threshold.

**And then run the null emulation.** This is the one that matters and the one nobody does. Execute the legitimate integration, unchanged, and ask what fires. Not what *could* fire — what actually produces an alert, a case, or a dashboard entry on a normal night.

If the answer is nothing, then the monitoring is not monitoring, because the attacker does not need to be careful. An attacker using a machine credential has one job: look like the integration. Every hour the integration is invisible to the defender, the attacker is invisible with it. There is no way to detect the compromise if you cannot detect the legitimate thing.

## The case where the baseline existed and nobody built it

This draws on work with mid-sized enterprises and managed-service providers across regulated and unregulated environments — the specifics are composite, because the customers are not the lesson and the pattern is.

A claims and insurance brokerage, roughly 1,300 staff, administering claims for a network of third-party repairers and clinics. Their identity provider held 1,900 human principals and 21,400 machine principals — a little over eleven machines for every person, which is ordinary for an organisation whose workflow is integrations.

The inventory work from the earlier essays was done: identity joined to applications, to assets, to rotation records. What came out of it was a list of 21,400 machine principals, of which 27% had no owner, and a set of 640 holding standing privilege — a role that reached a whole data domain rather than one table, covering claims records, member data and settlement files.

Those 640 were the ones with a real blast radius, and they were also the ones with the least visibility. Of them, 11 had a recorded baseline that a defender could work from: the hosts they authenticated from, the resources they touched, the schedule they ran on, the protocol they used. The other 629 had a credential, a grant, and a name in a list.

The exercise ran the five moves above against that population. The findings were not the grants — the grants were expected, they were the standing privilege the previous essay described. The findings were about visibility.

The null emulation produced the result. Of the 640 standing-privilege machine principals, 412 produced no alert of any kind when their own legitimate integration was executed. No case, no ticket, no dashboard entry. They authenticated, they pulled their data, and the SOC saw an authenticated service doing exactly what an authenticated service does. The remaining 228 produced something, but for 217 of those the something was a log line in a search index — the kind of record that exists to be found, not to be read.

The target-swap move was the one that produced a finding. A claims-feed credential, used from its usual host on its usual schedule with its usual protocol, was pointed at a member records endpoint it had never been granted. The authentication was clean. The grant was not. It was caught by a rule that compared the credential's access history with its current access — a join, not a detection, and one that took four days to build because the resource access history was not in a place anyone queried.

The source-swap move was the one that produced nothing, because the credentials had no recorded hosts. Thirty-one of them authenticated from a source that had never been seen before, and not one of those sources was a surprise to anyone, because nobody had a list.

## The three numbers

Three numbers describe whether a machine principal population is monitored or merely present.

The first is the share of machine principals with a usable baseline — for how many of them can you say what the credential normally does: which hosts, which resources, which schedule, which protocol. Not "how many have a log line" but how many have a normal you could compare an anomaly against. At the brokerage it was 34%, and it was 11 of the 640 that held standing privilege.

The second is the age of the oldest standing-privilege credential with no baseline. Not the oldest credential — old credentials with function privilege are untidy. The number that matters is the oldest one that can reach a whole domain and about which nobody can say what it is supposed to do. At the brokerage it was four years and seven months.

The third is time-to-detect for a machine principal, measured the same way as for a human one: from the first anomalous use to the point where an analyst has identity, source, target and time joined. It was nine days. The comparable number for a human principal in the same environment, from a credential reused off a personal laptop, was sixty-one minutes.

Nine days is not a detection failure in the usual sense. Nothing fired slowly. Nothing fired.

A fourth measurement completes the set, and it is the house measure rather than a new one: paths to Tier Zero. Machine principals that could reach a Tier Zero resource, measured against the actual joins. It was 1,240 before the remediation work and 190 after, and the 190 that remained were the 11 with baselines plus the 179 that had been granted a domain-wide role for a reason nobody could reconstruct.

## What a monitored machine principal looks like

A monitored machine principal is not one with more logs. It is one with four things written down, and the four things are exactly the ones the emulation needed.

It has a recorded source set: the hosts it authenticates from, held as a list that is consulted rather than collected. It has a recorded target set: the resources it has touched, held the same way. It has a schedule and a protocol, held as an expectation rather than a description.

And it has a detection that does not need any of them. The target-swap detection works off a single question — has this credential ever touched this resource — and it works on a credential with no behavioural profile at all, because it never had one. That is the detection that generalises, and it is the one that catches an attacker who has studied the integration and is behaving exactly as it should.

The baseline detections still matter. They are what catches a credential being used from a new host, or at a new hour, or forty times over. But they only exist if somebody has written the baseline down, and writing it down is unglamorous work that no one does until an exercise shows them the gap.

The numbers moved like this. Baseline coverage across the machine principal population went from 34% to 81%. The oldest standing-privilege credential with no baseline went from four years and seven months to fourteen months. Time-to-detect for a machine principal went from nine days to twenty-six minutes, which is faster than the human principal figure in the same environment, because the join that did the work needed no model of what the credential normally did.

## The discipline that makes the population countable

The exercise that emulates a credential-driven intrusion with human principals will never tell you whether your machine principals are watched. It cannot, because watching a human requires a pattern and a machine has none, and because the exercise was scoped from the people in the model while the population that actually holds the privilege was never in it.

So the machine principal population has to be brought into scope on purpose, which means it has to be joined on purpose, and joining it on purpose means joining it to resource access history — which most organisations hold in a log pipeline nobody queries — and to a host inventory, which for a machine principal is a set of addresses nobody owns.

The five moves are cheap. They take an afternoon once the joins exist, and they find the gap between what is logged and what is watched faster than any assessment will. The null emulation is the one to run first, because it is the one that tells you the truth: a credential whose legitimate use produces no signal cannot be defended, and no amount of credential hygiene changes that.

A credential that is present is not a credential that is monitored. The difference between them is four lists, and the purple team's job is to find out which of your machine principals have them.

---

This essay continues the identity thread — [Purple Teaming Your Identity Environment](/essays/purple-teaming-your-identity-environment/), [Containing a Credential-Driven Intrusion](/essays/containing-a-credential-driven-intrusion/), [Purple Teaming a PCI Environment](/essays/purple-teaming-a-pci-environment/), [Quarterly Cadence](/essays/quarterly-identity-purple-team-cadence/), [The Joins Nobody Owns](/essays/the-joins-nobody-owns/), [The Principals That Never Log In](/essays/the-principals-that-never-log-in/) — and delivers the detection side of the machine principal population that the last one promised. The next essay in this thread will move from the credentials that are counted to the place where they are minted: the CI/CD pipeline, which no essay in this corpus has covered, and which is where build systems issue, rotate and grant credentials on their own schedule.
