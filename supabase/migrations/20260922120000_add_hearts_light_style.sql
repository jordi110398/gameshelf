-- Bombetes en forma de cor com a nou estil de llumets.

alter table public.profiles
  drop constraint profiles_shelf_light_style_check,
  add constraint profiles_shelf_light_style_check
    check (shelf_light_style in ('neon', 'bulbs', 'stars', 'christmas', 'hearts'));
