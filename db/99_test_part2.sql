\set ON_ERROR_STOP on
\pset pager off

select '=== REPLY CLASSIFICATION (the old bug: everything logged as Yes) ===' as step;

-- Pranesh taps "Yes, share options"
select (abm_record_reply('919820020906', null, 'whatsapp', 'Yes, share options'))->>'intent' as pranesh_intent,
       (abm_record_reply('919820020906', null, 'whatsapp', 'Yes, share options'))->>'alert'  as should_alert;

-- Viren taps "Not right now"  -> must NOT be interested
select (abm_record_reply('919821074005', null, 'whatsapp', 'Not right now'))->>'intent' as viren_intent,
       (abm_record_reply('919821074005', null, 'whatsapp', 'Not right now'))->>'alert'  as should_alert;

-- Cold guy says not interested -> must go to DNC permanently
select (abm_record_reply('919876543210', null, 'whatsapp', 'not interested, please remove me'))->>'intent' as cold_intent;

select '--- stages after replies ---' as step;
select first_name, stage, reply_intent, stopped_reason from abm_leads order by first_name;

select '--- CROSS-CHANNEL STOP: nobody who replied is in any send queue ---' as step;
select 'wa_followup' as queue, count(*) from v_abm_due_wa_followup
union all select 'li_followup', count(*) from v_abm_due_li_followup
union all select 'wa_final',    count(*) from v_abm_due_wa_final
union all select 'li_connect',  count(*) from v_abm_due_li_connect;

select '--- DNC list now contains the refuser ---' as step;
select phone, reason from abm_dnc order by added_at;

select '--- re-intake of a DNC person must be blocked ---' as step;
select abm_intake('Andheri_Nov26_B2','Andheri East','[
  {"first_name":"Cold","last_name":"Guy","linkedin_url":"https://linkedin.com/in/coldguy2",
   "phone":"9876543210","company":"ColdCo","score":"HOT"}]'::jsonb);

select '--- ALERT QUEUE: only interested/question, ranked ---' as step;
select first_name, reply_intent from v_abm_new_replies;

select '=== DAY 15 EXPIRY ===' as step;
-- Anand never replied. Push him to day 15.
update abm_leads set sequence_start = current_date - 14 where first_name='Anand';
select count(*) as to_expire from v_abm_to_expire;
select abm_expire_sequences();
select first_name, stopped_reason, retry_after from abm_leads where first_name='Anand';

select '=== FUNNEL / TRACKER ===' as step;
select * from v_abm_funnel;
select stage, leads from v_abm_pipeline order by stage;
