# ABM Outbound System, Autopilot Offices

Source of truth for the account based marketing system that finds companies who
might want a managed office in Andheri East and reaches them on WhatsApp and
LinkedIn at the same time.

Everything here is configuration and copy. There is no application code.

## How it works

One Google Sheet is the brain. Two channels run off it in parallel.

```
Claude (Oppora search + scoring)
        |
        v
  Make scenario 0  ──────> ABM Leads Master sheet
   (on demand)                    |
                                  |
          ┌───────────────────────┴───────────────────────┐
          v                                               v
  Make scenarios 1 & 2                            Oppora campaign 15491
  WhatsApp via AiSensy                            LinkedIn sequence
  intro hourly, follow-up daily 11:00             day 0 / 1 / 3 / 7
          |                                               |
          v                                               v
  Make scenario 3                                 replies land in Oppora inbox
  catches replies, writes them back
  to the sheet and stops follow-ups
```

A lead gets a WhatsApp message within the hour and a LinkedIn touch the same
day, from two directions, and neither channel knows about the other.

## Moving parts

| Part | Identifier |
|---|---|
| Make team | 3478981 |
| Make org | 9687218 |
| Google Sheets connection in Make | 12450410 |
| Lead sheet | `1v_PegL5zdNzUNMQ8vLzqoQQiAk8oEy7VbKXtMiE_Qqo`, tab `Untitled` |
| Oppora sequence campaign | 15491, `ABM_Andheri` |
| AiSensy API endpoint | `https://backend.aisensy.com/campaign/t1/api/v2` |
| AiSensy API campaigns | `andheri_intro`, `andheri_followup` |
| Reply webhook | `https://hook.us2.make.com/7dqe6i2mfn2kfk58pb59sbitcsr6bvsx` |

## Status

| Component | State |
|---|---|
| Sheet, 20 columns A to T | built |
| Make scenario 0, intake | built, switched ON, on demand only |
| Make scenario 1, WhatsApp intro | built, switched OFF, needs AiSensy key |
| Make scenario 2, WhatsApp follow-up | built, switched OFF, needs AiSensy key |
| Make scenario 3, reply catcher | built, switched OFF, needs webhook registered in AiSensy |
| Oppora LinkedIn sequence, 4 steps | built, draft, needs a LinkedIn account connected |
| AiSensy templates | not created yet |
| AiSensy API campaigns | not created yet |

See `RUNBOOK.md` for what to do, and `KNOWN_ISSUES.md` before you trust it.
