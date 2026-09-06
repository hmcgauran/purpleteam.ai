---
title: "Building a Detection Baseline: The Work Nobody Wants to Do"
slug: "building-a-detection-baseline"
date: 2026-06-11
tags:
  - "Detection Engineering"
  - "Blue Team"
  - post
author: Hugh McGauran
excerpt: "Every detection engineer has been told to build a baseline. Almost nobody has been given a clear answer about what a baseline actually is, what data it needs, or how it connects to the rules the SOC actually runs. Here is the honest version of the work"
layout: layouts/post.njk
permalink: /essays/building-a-detection-baseline/
---

Every detection engineer has, at some point, been told to build a baseline for the environment. Almost nobody has been given a clear answer about what a baseline actually is, what data it needs, or how it connects to the rules the SOC actually runs on a Tuesday afternoon.

The honest version of the work is this.

## A baseline is not a list

A baseline is not a list of "normal things." A list of normal things is what you get when you point a SIEM at a noisy environment and filter for the most common events. That gives you a list that includes the noise as if it were signal. It is not a baseline. It is a frequency distribution.

A baseline is a model of what the environment looks like when nothing interesting is happening. It is a model that you can run a detection against and say "this is not the baseline" with confidence. The model needs to be specific enough that the answer is meaningful and simple enough that the SOC analyst can read it.

The model does not need to be sophisticated. It needs to be honest. A simple model that says "this user has never logged in from this country before" is more useful than a sophisticated model that says "this user's behaviour has shifted by 12 percent across these seven features." The first is actionable. The second is a research project.

## What the baseline is actually built from

The baseline is built from three things. The first is the network traffic. The second is the endpoint telemetry. The third is the identity logs. The fourth, which most people forget, is the change log. If you do not know what changed in the environment in the last 24 hours, your baseline is missing a feature.

Network traffic is the easy one. NetFlow, DNS logs, proxy logs, TLS fingerprints. You have most of this already. The work is the data engineering, not the data collection.

Endpoint telemetry is the hard one. Most environments have a third of the endpoint telemetry they think they have. The collection agent is installed but not running, or running but not shipping, or shipping but the schema changed and nobody updated the parser. You will spend a meaningful amount of time on the basic plumbing. This is not glamorous work. It is necessary.

Identity logs are the under-rated one. Authentication logs, especially for service accounts, are where the modern attacks live. Lateral movement, privilege escalation, persistence, exfiltration. Almost all of it shows up in identity logs first. If you are not collecting every authentication event on every system, with the source address, the destination, the protocol, and the outcome, your baseline is missing the most important feature.

Change log is the feature you did not know you needed. Every meaningful change in the environment should be in a change log that the detection system can read. New service account created. New server provisioned. New firewall rule. New scheduled task on a critical host. If the SOC analyst can see the change, they can correlate the anomaly with the change and decide whether the change explains the anomaly. If they cannot, they are working blind.

## The work, in order

The work is, roughly, in this order.

First, get the data into a queryable form. A SIEM is fine, a data lake is fine, a Postgres table is fine. The point is that you can run a query and get an answer in seconds, not minutes.

Second, profile the data. What does the environment actually look like? For each identity, what is the pattern of authentication? For each host, what is the pattern of process execution? For each network flow, what is the pattern of communication? The profile is the baseline.

Third, build a small set of detections that test the baseline. The detections are not the SOC's first-line detections. The detections are the alarm that says "this is not the baseline, and the analyst should look at it." The SOC's first-line detections are the next layer, built on top of the baseline.

Fourth, document. What is in the baseline. What is not. What does the model not know. The documentation is the thing that makes the programme durable.

Fifth, maintain. The baseline drifts. The environment changes. The detections need to be retested. The documentation needs to be updated. None of this is exciting. All of it is the work.

## What the baseline is not

The baseline is not a one-time project. It is a living system that the detection engineering team maintains as part of their day job. A baseline built and then ignored for six months is a baseline that is lying to you.

The baseline is not a vendor product. Every vendor in the detection space sells a "baseline" or a "user and entity behaviour analytics" module. Some of them are good. None of them are the baseline. The baseline is the model of your specific environment, and the work of building it is the work of understanding your specific environment. There is no shortcut.

The baseline is not a substitute for the SOC analyst. The baseline is a model the SOC analyst uses to do their job faster. The model is not the job. The job is investigating the alert, making the call, taking the action.

## The honest scope of the work

A real baseline for a mid-sized environment is a six to twelve month build. The first three months are data engineering. The next three are profiling and detection. The last three are documentation and operationalisation. After that, the baseline is a living system that the detection engineering team maintains.

That is the honest scope. Most programmes skip steps. The ones that skip the data engineering end up with a baseline that is wrong. The ones that skip the profiling end up with detections that fire on the wrong things. The ones that skip the documentation end up with a baseline that nobody on the team understands, which is a baseline that gets ignored.

The work is unglamorous. The work is what makes the rest of the work possible. There is no version of the detection engineering function that works without a baseline, and there is no version of building a baseline that is faster than the work itself.

If you are a detection engineer who has been told to build a baseline, that is the work. Take the year. Do the data engineering first. Do the profiling second. Do the detections third. Do the documentation last. Then maintain it forever.
