---
name: feedback-khong-chay-buoc-soat-dai
description: "Mam_Studio: user doesn't want long multi-agent review steps after image generation; quick self-check, then show the result"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 78068ed1-d5a0-4324-a72f-388ff9d471aa
  modified: 2026-11-23T04:22:48.447Z
---

On 2026-11-22, after I generated the avatar with the characters replaced, I ran a workflow of 5 agents to review each character. The user cut in: "Soát cái gì, tao nói là con mèo không có nail, con gà cười".

**Why:** the user only wants the result to match exactly what they asked for. A long independent review adds waiting time and token cost for no benefit they can see.

**How to apply:**
- After generating, look at it yourself: open it full size and zoom into the spots the user named. If it's right, show the result right away.
- Don't spawn agents or workflows to review images unless the user asks for one, even when ultracode is on.
- Only report a defect when it touches what the user asked for or a character's lock; skip minor color or detail nitpicks.

Related: [[feedback-anh-nhom-giu-nguyen-nhan-vat]], [[feedback-google-flow-trinh-duyet-app]].
