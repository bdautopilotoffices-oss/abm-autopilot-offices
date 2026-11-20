# Integrations needed

Who does what, on which platform, to get this live. Items marked **you** need
a human with an account login. Items marked **Claude** I can do from here.

---

## 1. Supabase, the system of record  — **you**, 10 minutes

Replaces the Google Sheet as the place truth lives. The sheet could not do
dedup, could not stop one channel when another got a reply, and could not hold
a pipeline stage. A database does all three.

**What to do**

1. Open your Supabase project, or create a new one for this.
2. Open the SQL editor.
3. Run `db/01_schema.sql`, then `db/02_views.sql`, then `db/03_functions.sql`,
   in that order. They are idempotent, so re-running is safe.
4. Go to Project Settings, API, and copy two things:
   - the Project URL
   - the `service_role` key

**What I need from you:** the Project URL only. Put the `service_role` key
straight into Make as described below. Do not paste it into chat.

**Why service_role and not anon:** these RPCs write data and must bypass row
level security. The key only ever lives inside Make.

---

## 2. AiSensy, WhatsApp  — **you**, 30 minutes plus Meta approval

**What to do**

1. Manage, then Template Messages, then New Template. Create all three from
   `templates/messages.md`: `abm_intro_v1`, `abm_followup_v1`, `abm_final_v1`.
   Copy the bodies exactly. Meta rejects templates where two variables touch,
   and these are written to avoid that.
2. Submit and wait for Meta. Usually minutes, sometimes hours.
3. Once approved, create one API campaign per template, named exactly the same
   as the template, and Set Live.
4. Manage, then API Key. Generate a key and keep it for step 4 below.
5. Find the webhook setting and paste in the Make webhook URL from
   `make/README.md`. Without this, replies never come back.
6. Top up the message wallet. At roughly Rs 0.80 to 1 per message and three
   messages per lead, 50 leads a week is about Rs 150 a week.

**Blocking:** nothing in the WhatsApp track works until the templates are
approved and the campaigns are Live.

---

## 3. Make, the orchestration  — **Claude builds, you paste two keys**

I rebuild the scenarios to read Supabase views instead of the sheet. Seven
scenarios replace the current four.

**What you do:** open each scenario once and paste in
- the Supabase `service_role` key
- the AiSensy API key

**What I do:** everything else.

---

## 4. Oppora, lead data  — **mostly done**

Already connected and working. 72 leads and 59 companies are sitting in
`Andheri ABM - Master`.

**One thing to decide:** phone enrichment. I tested three leads and got three
valid numbers back, so the data is there. Enriching all 72 costs 72 of your
112 remaining phone credits. Say go and I will run it.

**Note:** one of the three came back as a US number for a Mumbai-based
director. The schema rejects anything that is not a valid +91 mobile, so bad
numbers are dropped rather than messaged. Expect roughly 10 to 20 percent of
enriched numbers to be unusable.

---

## 5. LinkedIn  — **parked, your call**

Deferred until you have the Oppora LinkedIn plan. Nothing else is blocked by
it: the WhatsApp track, the call list and the tracker all run without it.

When you are ready it is one step: connect the LinkedIn account in Oppora, and
the sequence that is already built in campaign 15491 starts working.

---

## 6. Reply alerts  — **needs a decision from you**

Right now a hot reply would land in a database row and nobody would know.
That is the single biggest operational gap after the data itself.

Pick one and I will build it:

- a WhatsApp message to your own number the moment someone says yes
- an email to you and the BD associates
- a daily 9am digest instead of instant alerts

Instant is better for interested replies, digest is fine for the rest.

---

## 7. Google Sheets  — **demoted, not deleted**

The sheet stops being the brain and becomes a read-only mirror for anyone who
wants to look at a spreadsheet. Make writes to it from Supabase once a day. No
automation reads from it any more.

---

## Cost, monthly

| Item | Cost | Status |
|---|---|---|
| Oppora lead data | already bought | extra credits only if you scale |
| Oppora phone credits | 112 left, 72 needed for this batch | already bought |
| Oppora LinkedIn | about Rs 2,000 | not yet bought |
| AiSensy wallet | Rs 2,000 to 3,000 | top-up needed |
| Supabase | free tier is enough at this volume | may already have one |
| Make | depends on your plan, this uses roughly 400 operations per 50-lead batch | already bought |
| Claude | already bought | |

---

## Order of operations

1. Run the three SQL files in Supabase  (**you**, 10 min)
2. Create and submit the three WhatsApp templates  (**you**, 30 min, then wait for Meta)
3. Send me the Supabase project URL  (**you**, 1 min)
4. I rebuild the Make scenarios against Supabase  (**Claude**)
5. You paste the two keys into Make  (**you**, 5 min)
6. Create the AiSensy API campaigns and set them Live  (**you**, 10 min)
7. Paste the webhook into AiSensy  (**you**, 2 min)
8. I enrich phones and load the first batch  (**Claude**)
9. Test run on 10 leads  (**both**)
10. Full run

Steps 1, 2 and 3 are the only things blocking me. Everything else I can do or
is a two-minute paste.
