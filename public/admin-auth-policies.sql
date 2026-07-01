-- Admin access: any logged-in (authenticated) user gets full control.
-- SECURITY: this is safe ONLY because public sign-ups are DISABLED in Supabase Auth,
-- so the ONLY authenticated user is the owner account you create manually.
-- NEVER enable public sign-ups while these policies exist.

create policy "authed read all" on public.transmissions
  for select to authenticated using ( true );

create policy "authed insert any" on public.transmissions
  for insert to authenticated with check ( true );

create policy "authed update any" on public.transmissions
  for update to authenticated using ( true ) with check ( true );

create policy "authed delete any" on public.transmissions
  for delete to authenticated using ( true );
