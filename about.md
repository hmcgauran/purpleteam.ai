---
layout: layouts/base.njk
title: About
description: About Hugh McGauran and PurpleTeamAI — practitioner-led writing on purple teaming and detection engineering.
permalink: /about/
---

<section class="page">
  <header class="page__header">
    <p class="section-eyebrow">About</p>
    <h1 class="page__title">Practitioner-led writing on the operational work.</h1>
  </header>

  <div class="prose">
    <p><strong>{{ site.title }}</strong> is a publication by {{ author.name }}. It exists because most public security content is either vendor marketing, generic framework worship, or theatre dressed as strategy — and the practitioners running real programmes deserve sharper thinking than that.</p>

    <h2>What this publication is</h2>
    <ul>
      <li><strong>Threat-model driven analysis, not checklist security.</strong> Generic MITRE ATT&CK checklists don't tell you anything about your environment. Threat-driven analysis does.</li>
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
    <p>{{ author.longBio }}</p>

    <p>You can reach Hugh at <a href="mailto:{{ author.email }}">{{ author.email }}</a>. He's on <a href="{{ author.twitter }}">Twitter</a> and <a href="{{ author.linkedin }}">LinkedIn</a>.</p>
  </div>
</section>
