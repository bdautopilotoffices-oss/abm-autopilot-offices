# Make scenarios

Team 3478981. Google Sheets connection `12450410`.

| # | Scenario | ID | Schedule | On? |
|---|---|---|---|---|
| 0 | ABM 0, intake leads from Claude | 7120707 | on demand | yes |
| 1 | ABM 1, send WhatsApp intro | 7108734 | every 3600s | no |
| 2 | ABM 2, day 8 WhatsApp follow-up | 7108740 | daily 11:00 | no |
| 3 | ABM 3, catch WhatsApp replies | 7108746 | immediately, webhook | no |

Edit links:

- https://us2.make.com/3478981/scenarios/7120707/edit
- https://us2.make.com/3478981/scenarios/7108734/edit
- https://us2.make.com/3478981/scenarios/7108740/edit
- https://us2.make.com/3478981/scenarios/7108746/edit

## What each one does

**0, intake.** On demand only, so it runs when Claude calls it and never on a
clock. Takes `campaign`, `target_office` and an array of `leads`, iterates with
a BasicFeeder and appends a row per lead.

**1, intro.** Watches the sheet hourly, 10 rows at a time. Filter passes a row
when score is HOT or WARM, column C has a phone, and column N is empty. Posts
to AiSensy campaign `andheri_intro` with first name and company as template
params, then stamps N as `Sent` and O with today's date.

**2, follow-up.** Daily at 11:00. Pulls up to 20 rows where N is `Sent`, P is
empty and Q is empty, then filters to rows where O is six or more days old.
Posts to `andheri_followup`, then stamps P.

**3, replies.** Webhook `3086812`, fires immediately on delivery. Matches the
caller's phone against column C and stamps Q with `Yes` and a timestamp. That
non empty Q is what stops scenario 2 from following up.

## Webhook

```
https://hook.us2.make.com/7dqe6i2mfn2kfk58pb59sbitcsr6bvsx
```

Anyone holding this URL can post fake replies into the sheet. It is not a
secret with teeth, but keep it in this private repo rather than anywhere public.

## Restoring a scenario

Open the scenario in Make, three dots, Import Blueprint, pick the JSON here.
The blueprints carry `PASTE_YOUR_AISENSY_API_KEY_HERE` rather than a real key,
so re-enter the key after importing scenario 1 or 2.
