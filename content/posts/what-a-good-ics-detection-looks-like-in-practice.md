---
title: "What a Good ICS Detection Looks Like in Practice"
slug: "what-a-good-ics-detection-looks-like-in-practice"
date: 2026-09-06
tags:
  - "ICS"
  - "OT Security"
  - "Detection Engineering"
  - post
author: Hugh McGauran
excerpt: "There is a lot of advice about ICS detection that talks about MODBUS, DNP3, and the protocol layers. This is the part that comes after the protocol talk: what a good detection actually looks like in the SIEM, and what the SOC analyst does with it"
layout: layouts/post.njk
permalink: /essays/what-a-good-ics-detection-looks-like-in-practice/
---

There is a lot of advice about ICS detection that talks about MODBUS, DNP3, and the protocol layers. The protocol talk is necessary. The protocol talk is not sufficient. The protocol talk does not tell the SOC analyst what to do when the alert fires. The protocol talk does not tell the SOC analyst how to investigate the alert. The protocol talk does not tell the SOC analyst how to respond to the alert.

This is the part that comes after the protocol talk.

## The detection that fires

A good ICS detection is a detection that fires on the right things. A good ICS detection is a detection that fires on the actions that an attacker would take against an ICS environment. A good ICS detection is a detection that fires on the actions that a misconfiguration would cause. A good ICS detection is a detection that fires on the actions that a failure mode would cause.

A good ICS detection is not a detection that fires on the protocol. A good ICS detection is not a detection that fires on the packet. A good ICS detection is not a detection that fires on the bytes. A good ICS detection is a detection that fires on the meaning of the protocol, the meaning of the packet, the meaning of the bytes.

A good ICS detection is the detection that the SOC analyst can act on. A good ICS detection is the detection that the SOC analyst can investigate. A good ICS detection is the detection that the SOC analyst can respond to.

## The detection that does not fire

A good ICS detection is also a detection that does not fire on the wrong things. A good ICS detection is also a detection that does not fire on the noise. A good ICS detection is also a detection that does not fire on the legitimate activity that the operator is going to be doing.

A good ICS detection does not fire on the routine engineering activity. A good ICS detection does not fire on the routine configuration change. A good ICS detection does not fire on the routine firmware update. A good ICS detection does not fire on the routine commissioning activity.

A good ICS detection is the detection that the SOC analyst trusts. A good ICS detection is the detection that the SOC analyst does not suppress. A good ICS detection is the detection that the SOC analyst investigates when the detection fires.

## The alert the SOC analyst sees

The alert the SOC analyst sees is the alert that has the right context. The alert the SOC analyst sees is the alert that has the system name, the protocol, the source, the destination, the action, the timestamp, the operator, the asset. The alert the SOC analyst sees is the alert that the SOC analyst can use to start the investigation.

The alert the SOC analyst sees is not the alert that has the protocol packet dump. The alert the SOC analyst sees is not the alert that has the raw bytes. The alert the SOC analyst sees is not the alert that has the wireshark capture. The alert the SOC analyst sees is the alert that the SOC analyst can use to start the investigation.

The alert the SOC analyst sees is the alert that the detection engineering function has written. The alert the SOC analyst sees is the alert that the detection engineering function has tested. The alert the SOC analyst sees is the alert that the detection engineering function has tuned. The alert the SOC analyst sees is the alert that the detection engineering function has documented.

## The investigation the SOC analyst does

The investigation the SOC analyst does is the work of answering four questions. The first question is what the action was. The second question is who initiated the action. The third question is whether the action was authorised. The fourth question is what the action is going to do.

The first question is what the action was. The first question is the question of what the protocol, the source, the destination, the timestamp, the action, the asset, the operator was. The first question is the question of what the alert told the SOC analyst.

The second question is who initiated the action. The second question is the question of whether the action was initiated by an operator, by an engineering workstation, by an attacker, by a system. The second question is the question of whether the action was initiated by the system that the protocol is supposed to be initiated by.

The third question is whether the action was authorised. The third question is the question of whether the action is in the change-control system, the work-order system, the operations log. The third question is the question of whether the action is the action that was supposed to happen.

The fourth question is what the action is going to do. The fourth question is the question of whether the action is going to change a setpoint, trip a breaker, open a valve, change a controller mode. The fourth question is the question of whether the action is going to do harm to the process.

## The response the SOC analyst takes

The response the SOC analyst takes is the work of deciding what to do. The response the SOC analyst takes is the work of deciding whether to escalate, whether to investigate further, whether to contain, whether to recover.

The response the SOC analyst takes is not the work of following a runbook blindly. The response the SOC analyst takes is not the work of executing a script. The response the SOC analyst takes is the work of making a judgement call with the four answers in hand.

The response the SOC analyst takes is the work that the SOC analyst is the most experienced to do. The response the SOC analyst takes is the work that the SOC analyst is the most expensive resource to do. The response the SOC analyst takes is the work that is the most important to do well.

## The honest answer

The honest answer is that a good ICS detection is a detection that the SOC analyst can use. The honest answer is that a good ICS detection is a detection that the SOC analyst can act on. The honest answer is that a good ICS detection is a detection that the SOC analyst can trust.

The honest answer is that the SOC analyst is the most expensive resource in the ICS detection function. The honest answer is that the SOC analyst is the most under-resourced resource in the ICS detection function. The honest answer is that the SOC analyst is the most under-appreciated resource in the ICS detection function.

The honest answer is that the ICS detection function is worth the money when the SOC analyst is doing the work. The honest answer is that the ICS detection function is not worth the money when the SOC analyst is not doing the work.

If you are building an ICS detection function, build the function that the SOC analyst can use. If you are building an ICS detection function, build the function that the SOC analyst can act on. If you are building an ICS detection function, build the function that the SOC analyst can trust.
