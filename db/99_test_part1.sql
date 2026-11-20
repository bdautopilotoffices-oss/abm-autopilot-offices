\set ON_ERROR_STOP on
\pset pager off

-- ============ 1. INTAKE with dedup, DNC and bad phones ============
select abm_add_dnc('9820000001', null, null, null, 'pre-existing DNC');

select '--- intake ---' as step;
select abm_intake('Andheri_Nov26_B1', 'Andheri East', '[
 {"first_name":"Pranesh","last_name":"Misra","linkedin_url":"https://linkedin.com/in/pranesh123",
  "phone":"+919820020906","company":"Brandscapes","persona":"founder","score":"HOT",
  "why_now":"hiring across several roles right now","designation":"Managing Director"},
 {"first_name":"Viren","last_name":"Reshamwala","linkedin_url":"https://linkedin.com/in/virenreshamwala",
  "phone":"9821074005","company":"MBM Newtech","persona":"finance","score":"WARM",
  "why_now":"carrying a large security deposit","designation":"CFO"},
 {"first_name":"Anand","last_name":"Naik","linkedin_url":"https://linkedin.com/in/anand-naik",
  "phone":"+18486672570","company":"Sequretek","persona":"founder","score":"HOT",
  "why_now":"recently raised funding","designation":"CEO"},
 {"first_name":"Cold","last_name":"Guy","linkedin_url":"https://linkedin.com/in/coldguy",
  "phone":"9876543210","company":"ColdCo","persona":"hr","score":"COLD","why_now":"maybe"},
 {"first_name":"Dup","last_name":"Again","linkedin_url":"https://LINKEDIN.com/in/PRANESH123",
  "phone":"9999999999","company":"Dupe","score":"HOT"},
 {"first_name":"Blocked","last_name":"Person","linkedin_url":"https://linkedin.com/in/blocked",
  "phone":"9820000001","company":"BlockedCo","score":"HOT"}
]'::jsonb);

select '--- phone normalisation (US number must be null) ---' as step;
select first_name, phone, abm_is_sendable_phone(phone) as sendable from abm_leads order by first_name;

-- ============ 2. DAY-BY-DAY QUEUE CHECK ============
create or replace function t_day(n int) returns void language sql as $$
  update abm_leads set sequence_start = current_date - (n-1);
$$;

select '--- Day 1: who gets a LinkedIn connect? ---' as step;
select t_day(1); select first_name, day_n from v_abm_due_li_connect order by 1;

select '--- Day 1: WhatsApp should be EMPTY (intro is day 2) ---' as step;
select count(*) as wa_due_day1 from v_abm_due_wa_intro;

select '--- Day 2: WhatsApp intro. COLD excluded, US-number excluded ---' as step;
select t_day(2); select first_name, score, phone from v_abm_due_wa_intro order by 1;

select '--- Day 3: LinkedIn message needs an ACCEPTED invite, so empty ---' as step;
select t_day(3); select count(*) as li_msg_due from v_abm_due_li_message;

select '--- mark Pranesh accepted, now he is due ---' as step;
select abm_mark_sent(id,'li_accepted') is not null from abm_leads where first_name='Pranesh';
select first_name from v_abm_due_li_message;

select '--- Day 4-6: call list = HOT only ---' as step;
select t_day(5); select first_name, score, priority from v_abm_call_list order by priority, 1;

select '--- Day 8: follow-up needs intro already sent ---' as step;
select t_day(8);
select count(*) as before_intro_sent from v_abm_due_wa_followup;
select abm_mark_sent(id,'wa_intro') is not null from abm_leads where first_name in ('Pranesh','Viren');
select first_name from v_abm_due_wa_followup order by 1;
