create or replace view "public"."tasker_service_details" as
select
  sd.*,
  sd.tasker_user_id as user_id
from "public"."service_details" sd;
grant select on table "public"."tasker_service_details" to "anon";
grant select on table "public"."tasker_service_details" to "authenticated";
grant select on table "public"."tasker_service_details" to "service_role";
