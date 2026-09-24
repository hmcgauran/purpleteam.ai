---
title: "Purple Teaming Your Identity Environment: Where the Real Attacks Live Now"
slug: "purple-teaming-your-identity-environment"
date: 2026-09-24
tags:
  - "Purple Teaming"
  - "Identity"
  - "Detection Engineering"
  - "Red Team"
  - post
author: Hugh McGauran
excerpt: "Most purple team exercises still treat identity as the perimeter you walk through on the way to the real objective. It is not. It is the objective. Here is how to run a purple team exercise that is actually about identity"
layout: layouts/post.njk
permalink: /essays/purple-teaming-your-identity-environment/
---

Most purple team exercises still treat identity as the perimeter you walk through on the way to the real objective. The real objective is the file server. The real objective is the domain controller. The real objective is the production database. The real objective is the SaaS tenant where the customer data lives. Identity is the front door you walk through on the way to the real objective.

That view was correct in 2014. It is wrong now.

The identity layer is the objective. The identity layer is the place where the attacker wins. The identity layer is the place where the defender has to be able to detect. The identity layer is the place where the purple team exercise has to live.

If your purple team exercise is not spending most of its time in the identity layer, your purple team exercise is not testing the layer where the attacks live.

## Why identity is now the objective

The reason identity is now the objective is that the rest of the environment has got harder to attack. The reason the rest of the environment has got harder to attack is that endpoint detection has matured, network segmentation has improved, and the cloud providers have done most of the infrastructure security work for the average enterprise.

Identity has not got harder to attack for the same reason. The attacker needs to find one valid credential; the defender needs to detect one anomalous use of that valid credential. The asymmetry is brutal. The attacker needs to win once. The defender needs to win every time. The attacker can use a credential that is technically legitimate. The defender has to decide whether the use of the credential is legitimate.

The attacker also does not need to exploit a vulnerability. The attacker needs to log in. The attacker logs in with a valid credential. The attacker logs in from a valid device. The attacker logs in during business hours. The attacker logs in and does the things the user normally does. The defender has to find the one thing the attacker is doing that is not normal. The defender is looking for a needle in a stack of needles.

A purple team that does not replicate that asymmetry is not testing the layer where the attacks live.

## The inputs the exercise needs

A purple team exercise that is actually about identity needs the data sources the SOC analyst can query, join, and pivot through during an investigation. It does not need the theoretical identity analytics the vendor sells. It needs the sources the analyst will be expected to use at 02:00 when the alert fires.

Authentication logs and MFA challenge logs are the obvious ones. Conditional access decision logs and session logs sit alongside them — the logs that record what was allowed, what was blocked, and what token was issued. OAuth consent logs and service principal logs matter as much, because the attacker is no longer logging in as a person. Workload identity logs are now part of the same picture.

Beyond the identity provider itself, the joins are what make the exercise meaningful. Directory, access management, privileged access management, secrets manager, DLP, email, and endpoint all sit alongside identity. A join on identity, session, device, resource, and time is what lets the analyst answer the questions that matter: who, what, when, where, why, and how do we contain this.

A purple team exercise that is not testing the joins is not testing the analyst's ability to investigate. It is testing whether a single log line fires.

## The TTPs that actually look like the attack

The TTPs the attacker is going to run against your environment are not the TTPs that demonstrate a vulnerability. They are the TTPs that demonstrate the attacker's ability to use a valid credential to do the thing the user would normally do.

They start with the credential, obtained through a realistic means. Phishing. A session cookie stolen from a local device. A leaked token from a third-party breach. A personal device compromise. The credential is valid. The user is real. The session is real.

Then the credential is used. Log in. Access the resources the user has access to. Enumerate the access. Establish persistence. Move laterally to the resources the user has access to. The pattern is not loud. It does not trip the legacy detections. It looks like a user working. It uses a valid credential, on a valid device, during business hours, doing the things the user would normally do.

The purple team that emulates that pattern — and only that pattern — is testing the layer where the attacks live. The purple team that emulates Kerberoasting, Pass-the-Hash, and NTLM relay in isolation is testing a layer that the attacker is no longer trying to attack first.

## The detections that matter

The detections that matter are the detections that fire on the TTPs above. They are not the detections that fire on the legacy authentication anomalies. They are the detections that fire on the specific actions the attacker is taking against the specific resources the attacker is targeting.

Impossible travel. MFA fatigue. Session anomaly. Token replay. OAuth consent. Workload identity. Conditional access bypass. Data access anomaly. Data egress anomaly. The list is well known. The list is rarely tested against the specific environment with the specific joins wired up.

A detection that fires on a single log line is not a detection. A detection is a signal that survives the SOC analyst joining it to identity, session, device, and resource — and that survives that analyst making a decision. A purple team exercise that produces a report full of single-line detections is producing a report full of things the analyst will close in the queue.

## The outcome the exercise is for

The outcome of a purple team exercise on the identity layer is not the time to detect. The outcome is not the number of detections that fired. The outcome is not the number of TTPs that were blocked.

The outcome is the SOC analyst's ability to investigate — to pivot from the detection to the identity, from the identity to the session, from the session to the device, from the device to the resource, from the resource to the data, from the data to the action. The outcome is the SOC analyst's ability to answer the questions that matter and act on them before the attacker does the thing the attacker is trying to do.

The outcome is the response. Revoke the session. Invalidate the token. Disable the credential. Isolate the device. The detections are the input. The response is the output. A purple team exercise that does not measure whether the response is possible has not finished its work — it has only finished its demo.

## What an identity-focused exercise actually looks like

Small. Focused. Well-resourced.

Three to five realistic credential scenarios, each sourced from a plausible leak path. Each scenario tested against the joins the SOC analyst will actually have at 02:00. Each scenario measured on whether the analyst can answer who, what, when, where, why, and contain — not on whether the legacy detection fired.

If the exercise cannot be run that small, the identity layer is not yet ready to be purple teamed — and the work that needs to happen first is the data work, not the TTP work. Most programmes learn this the hard way: the exercise was scheduled, the joins were not wired up, the report said the SOC missed the detection, and the SOC missed the detection because the SOC did not have the data to see it.

The honest scope of an identity-focused purple team exercise is the data work that makes the investigation possible. Everything else is decoration.

---

This essay is part of an ongoing series on purple teaming in environments where identity is the perimeter. If you are running identity-layer exercises and want to compare notes on joins, TTPs, or measurement, I would rather hear from you than guess.
