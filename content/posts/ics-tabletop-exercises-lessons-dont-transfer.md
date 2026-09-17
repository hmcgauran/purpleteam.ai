---
title: "ICS Tabletop Exercises: Why the Lessons Never Transfer to the Plant Floor"
slug: "ics-tabletop-exercises-lessons-dont-transfer"
date: 2026-09-17
tags:
  - "ICS"
  - "OT Security"
  - "Purple Teaming"
  - "Tabletop"
  - post
author: Hugh McGauran
excerpt: "An IT tabletop finds a process gap and the team rewrites the runbook. An ICS tabletop finds the same gap and the team can do nothing with it, because the person who would have to act on the gap is two floors down, on a different shift, under a different chain of command."
layout: layouts/post.njk
permalink: /essays/ics-tabletop-exercises-lessons-dont-transfer/
---

A few months ago I wrote that most IT tabletops are theatre. The piece landed. People sent it to their detection leads, argued with it in their team channels, and ran better exercises because of it. The exercises they ran were IT exercises. The lessons in that piece do not transfer to the plant floor. The reasons are not the ones most programmes think.

The thesis of the IT piece was that a tabletop is a stress test of the incident response process. The point of the exercise is to find the places where the process breaks under realistic conditions, fix those places, and document the fixes. For an IT environment, this works. The process is one process. The team is one team. The chain of command is a single chain of command. The postmortem is signed and the fixes get made.

In an ICS environment, none of those sentences are true in the same way.

## Two floors, two chains of command

In an IT environment, the person who discovers the incident, the person who triages it, the person who contains it, and the person who signs off on the recovery all sit under the same CISO. The CISO has the authority to make the call. The call gets made. The runbook gets updated.

In an OT environment, the people who would have to act on the tabletop lessons do not sit under the CISO. The control room operator sits under the plant manager. The process safety engineer sits under a separate HSE organisation. The shift supervisor sits under a third organisation, and the third organisation has its own chain of command that runs to a different senior than the CISO. The CISO can author the runbook. The CISO cannot author the action.

This is the first reason the lessons do not transfer. The lesson is identified in the war-room, by the cyber team, against a process owned by a different organisation. The lesson is owned by the cyber team. The action lives somewhere else.

## The runbook the operator will not read

The tabletop identifies a gap. The gap is something an operator would have to do under stress, in the first ten minutes of a real incident, with the HMI showing partial loss of view and the phones ringing. The cyber team writes a new runbook page. The runbook page is reviewed by the control room supervisor. The supervisor files it in the binder.

The operator will not read the binder. The binder was already too long before the cyber team added a page. The operator's first action in a real incident is to call the shift supervisor, not to read the cyber team's binder. The supervisor is on the phone with the plant manager. The plant manager is on the phone with the HSE lead. The HSE lead is the one who actually has the authority to stop the line.

The lesson is in the binder. The lesson is not in the muscle memory.

## What changes when the environment is the environment

There is a deeper structural reason the lessons do not transfer, and the structural reason is what the IT programmes miss. In an IT environment, the response is to a process. The process can be rehearsed. The process can be measured. The process can be fixed. In an OT environment, the response is to a process that is welded into the plant. The response is also to the physical consequence of the process. The process cannot be rehearsed against the real plant. The plant is producing. The plant cannot be stopped to test the playbook.

This means the tabletop is testing the response against a process the team is not allowed to touch. The lessons the tabletop identifies are lessons about a process the team cannot practise on. The lessons are durable. The lessons are also unactionable, because the only place to action them is the plant, and the plant is off-limits.

## The lesson the July piece did not teach

I argued in July that the postmortem is signed by senior leadership and the signature is the commitment. For an ICS exercise, the senior leadership is the wrong senior leadership. The CISO signing the postmortem does not commit the plant manager. The plant manager signing the postmortem does not commit the control room operator. The control room operator is the person who would have to act on the lesson, and the control room operator was not in the room when the lesson was identified.

The fix is not a better postmortem. The fix is a different audience for the tabletop. The exercise has to include the operators, on shift, with their kit, in their chair. The exercise has to include the shift supervisor, in their control room, with their phone. The exercise has to include the process safety engineer, in their office, with their own authority. Without those people, the exercise is the cyber team testing the cyber team's plan against the cyber team's plant. The lessons will transfer to the cyber team's binder. The lessons will not transfer to the floor.

## What actually transfers

A tabletop transfers a lesson only when the lesson is given to the person who has to act on it, in the form that person acts on it, in the moment that person acts on it.

For an IT team, that form is the runbook. For an OT team, that form is the muscle memory of the operator, the authority of the HSE lead, and the call the shift supervisor makes in the first five minutes. None of those are writable in a binder.

A tabletop that pulls the operator, the shift supervisor, and the HSE lead into the room, on the operator's shift, against the operator's kit, finds a different set of lessons. The lessons are smaller. The lessons are specific. The lessons are the things the operator can actually do. The lessons transfer, because they were generated by the person who will act on them, in the chair where they will act, with the kit they will use.

A tabletop that pulls the cyber team into a war-room and writes a binder the operator will not read finds lessons the cyber team can publish. The lessons do not transfer. The postmortem is signed. The binder is filed. The plant floor is unchanged.

## The honest answer for ICS

The honest answer is that an ICS tabletop run the IT way is worse than no exercise. The exercise generates artefacts that look like preparation. The artefacts are written by a team that does not have the authority to act on the lessons. The artefacts are filed in a binder the operator will not read. The artefacts make the programme look mature. The artefacts do not change the response.

The honest answer is that an ICS tabletop is only worth running if the operators, the shift supervisors, and the HSE lead are in the room, on shift, with their kit. The exercise will be slower. The exercise will be harder to schedule. The exercise will produce fewer lessons per hour. The lessons that are produced will transfer, because they will be in the muscle memory of the person who has to act.

Run fewer. Run them on the floor. The plant will be better prepared, and you will not have another binder to maintain.
