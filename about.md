---
layout: layouts/base.njk
title: About
description: About PurpleTeamAI — practitioner-led writing on purple teaming and detection engineering.
permalink: /about/
---

<section class="page shell">
  <header class="page__header">
    <p class="page__eyebrow">About</p>
    <h1 class="page__title">Practitioner-led writing on the operational work.</h1>
  </header>

  <div class="prose">
    <p><strong>PurpleTeamAI</strong> is a publication by {{ authorProfile.name }}. It exists because most public security content is either vendor marketing, generic framework worship, or theatre dressed as strategy — and the practitioners running real programmes deserve sharper thinking than that.</p>

    <h2>What this publication is</h2>
    <ul>
      <li><strong>Threat-model driven analysis, not checklist security.</strong> Generic MITRE ATT&amp;CK checklists don't tell you anything about your environment. Threat-driven analysis does.</li>
      <li><strong>Detection engineering grounded in baseline and environment.</strong> What's normal here, before what's anomalous here.</li>
      <li><strong>Practical writing for teams that run real programmes.</strong> Operational detail, not strategy-deck bullet points.</li>
    </ul>

    <h2>What this publication isn't</h2>
    <ul>
      <li>No vendor fluff. No sponsored content without disclosure.</li>
      <li>No generic frameworks presented as if they were new methodology.</li>
      <li>No theatre dressed up as strategy.</li>
    </ul>

    <h2>About the author</h2>
    <p>{{ authorProfile.longBio }}</p>

    <p>You can reach {{ authorProfile.name }} at <a href="mailto:{{ authorProfile.email }}">{{ authorProfile.email }}</a>. They're on <a href="{{ authorProfile.twitter }}">Twitter</a> and <a href="{{ authorProfile.linkedin }}">LinkedIn</a>.</p>
  </div>
</section>
