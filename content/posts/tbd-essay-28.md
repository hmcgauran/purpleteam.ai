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

The reason identity has not got harder to attack is that identity is still the layer where the attacker needs to find one valid credential and the defender needs to detect one anomalous use of that valid credential. The asymmetry is brutal. The attacker needs to win once. The defender needs to win every time. The attacker can use a credential that is technically legitimate. The defender has to decide whether the use of the credential is legitimate.

The reason identity has not got harder to attack is also that the attacker does not need to exploit a vulnerability. The attacker needs to log in. The attacker logs in with a valid credential. The attacker logs in from a valid device. The attacker logs in during business hours. The attacker logs in and does the things the user normally does. The defender has to find the one thing the attacker is doing that is not normal. The defender is looking for a needle in a stack of needles.

## The wrong purple team

The wrong purple team exercise is the exercise that runs a few credential dumping TTPs, exfiltrates the NTLM hashes, cracks a password, and documents the time to detection. The wrong purple team exercise is the exercise that demonstrates a Kerberoasting attack against a service account and documents the detection that fires on the encryption downgrade. The wrong purple team exercise is the exercise that shows the blue team can detect a Pass-the-Hash attack and concludes the identity layer is covered.

The wrong purple team exercise misses the point because the wrong purple team exercise is testing the technique, not the outcome. The wrong purple team exercise is testing the detection engineering. The wrong purple team exercise is not testing the defender's ability to detect the attack that the attacker is actually going to run.

The attack the attacker is actually going to run is the attack that uses a valid credential that the attacker has obtained through phishing, through session theft, through a leaked token, through a personal device compromise, or through a third-party breach. The attack the attacker is actually going to run does not exploit a vulnerability. The attack the attacker is actually going to run logs in.

## The right inputs

The right inputs are the data sources that actually exist in your environment and that you actually have access to. The right inputs are not the theoretical identity analytics that the vendor sells. The right inputs are the data sources the SOC analyst can query, join, and pivot through during an investigation.

The right inputs include the identity provider logs. The right inputs include the authentication logs. The right inputs include the conditional access decision logs. The right inputs include the MFA challenge logs. The right inputs include the session logs. The right inputs include the device compliance logs. The right inputs include the OAuth consent logs. The right inputs include the service principal logs. The right inputs include the workload identity logs.

The right inputs also include the directory. The right inputs include the access management system. The right inputs include the privileged access management system. The right inputs include the secrets manager. The right inputs include the data loss prevention system. The right inputs include the email system. The right inputs include the endpoint detection system.

The right inputs are joined. The right inputs are joined on the identity. The right inputs are joined on the session. The right inputs are joined on the device. The right inputs are joined on the resource. The right inputs are joined so the SOC analyst can see the full picture of what the identity did, on what device, from what location, against what resource, at what time.

If your purple team exercise is not testing the joins, your purple team exercise is not testing the layer where the attacks live.

## The right TTPs

The right TTPs are the TTPs that an attacker is actually going to run against your environment. The right TTPs are not the TTPs that demonstrate a vulnerability. The right TTPs are the TTPs that demonstrate the attacker's ability to use a valid credential to do the thing the user would normally do.

The right TTPs start with the credential. The right TTPs start with a credential the attacker has obtained through a realistic means. The credential comes from phishing. The credential comes from a session cookie stolen from a local device. The credential comes from a leaked token from a third-party breach. The credential comes from a personal device compromise.

The right TTPs then use the credential. The right TTPs use the credential to log in. The right TTPs use the credential to access the resources the user has access to. The right TTPs use the credential to enumerate the access the user has. The right TTPs use the credential to establish persistence. The right TTPs use the credential to move laterally to the resources the user has access to.

The right TTPs are not noisy. The right TTPs do not trip the legacy detections. The right TTPs look like a user working. The right TTPs do not exploit a vulnerability. The right TTPs use a valid credential, on a valid device, during business hours, doing the things the user would normally do.

## The right detections

The right detections are the detections that fire on the right TTPs. The right detections are not the detections that fire on the legacy authentication anomalies. The right detections are the detections that fire on the specific actions the attacker is taking against the specific resources the attacker is targeting.

The right detections include the impossible travel detection. The right detections include the MFA fatigue detection. The right detections include the session anomaly detection. The right detections include the token replay detection. The right detections include the OAuth consent detection. The right detections include the workload identity detection. The right detections include the conditional access bypass detection. The right detections include the data access anomaly detection. The right detections include the data egress anomaly detection.

The right detections are written for the specific environment. The right detections are tuned for the specific environment. The right detections are tested for the specific environment. The right detections are documented for the specific environment. The right detections are maintained for the specific environment.

The right detections are not the detections the vendor sells. The right detections are the detections the detection engineering function has written, the detection engineering function has tested, the detection engineering function has tuned, the detection engineering function has documented, the detection engineering function has maintained.

## The right outcome

The right outcome of a purple team exercise on the identity layer is not the time to detect. The right outcome is not the number of detections that fired. The right outcome is not the number of TTPs that were blocked.

The right outcome is the SOC analyst's ability to investigate. The right outcome is the SOC analyst's ability to pivot from the detection to the identity, from the identity to the session, from the session to the device, from the device to the resource, from the resource to the data, from the data to the action. The right outcome is the SOC analyst's ability to answer the questions that matter: who, what, when, where, why, and how do we contain this.

The right outcome is the SOC analyst's ability to contain. The right outcome is the SOC analyst's ability to revoke the session, invalidate the token, disable the credential, isolate the device, and prevent the attacker from doing the thing the attacker is trying to do. The right outcome is not the detection. The right outcome is the response.

If your purple team exercise is not testing the response, your purple team exercise is not testing the layer where the attacks live.

## The honest scope

The honest scope of a purple team exercise that is actually about identity is an exercise that has the right inputs, the right TTPs, the right detections, and the right outcome. The honest scope is an exercise that is small, focused, and well-resourced.

The honest scope is not an exercise that runs the legacy credential dumping TTPs and documents the time to detect. The honest scope is not an exercise that demonstrates the technique. The honest scope is not an exercise that produces a report that the SOC analyst already knows how to respond to.

The honest scope is the work. The honest scope is the work the purple team has to do to test the layer where the attacks live. The honest scope is the work the purple team has to do to produce an exercise that the SOC analyst learns something from.

If you are running a purple team exercise, run the right exercise. If you are running a purple team exercise, run the exercise that tests the identity layer. If you are running a purple team exercise, run the exercise that is worth the money.
