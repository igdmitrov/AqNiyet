-- function for triggering push notifications
create or replace function private.send_push_notification(receiver_user_id uuid, title text, message text, roomid uuid)
returns bigint
language plpgsql security definer
as
$$
  declare
    payload text;
    receiver_fcm_token text;
    request_id bigint;
  begin
    select firebase_key
    from public.firebase_messaging_key
    where user_id = $1
    order by updated_at desc
    limit 1
    into receiver_fcm_token;

    if receiver_fcm_token is null
    then return null;
    end if;

    payload := '{
      "token": "'||receiver_fcm_token||'",
      "title": "'||$2||'",
      "message": "'||$3||'",
      "roomid": "'||$4||'"
    }';
H
    select
      net.http_post(
        url := 'https://us-central1-aqniyet-web-f4338.cloudfunctions.net/sendPushNotify',
        body := payload::jsonb
      )
    into request_id;

    return request_id;
  end;
$$;