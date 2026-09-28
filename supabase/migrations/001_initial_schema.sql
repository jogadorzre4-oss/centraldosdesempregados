create extension if not exists pgcrypto;

create table if not exists companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  normalized_name text not null,
  website text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (normalized_name)
);

create table if not exists sources (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  base_url text not null,
  source_type text not null default 'website',
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (base_url)
);

create table if not exists locations (
  id uuid primary key default gen_random_uuid(),
  city text,
  state text,
  country text not null default 'Brasil',
  normalized text not null,
  unique (normalized)
);

create table if not exists jobs (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  normalized_title text not null,
  company_id uuid references companies(id) on delete set null,
  source_id uuid references sources(id) on delete set null,
  location_id uuid references locations(id) on delete set null,
  original_url text not null,
  external_id text,
  description text,
  employment_type text,
  salary_min numeric(12,2),
  salary_max numeric(12,2),
  salary_currency char(3) not null default 'BRL',
  salary_text text,
  benefits text[],
  requirements text[],
  published_at timestamptz,
  expires_at timestamptz,
  collected_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  status text not null default 'active' check (status in ('active','expired','removed')),
  fingerprint text not null,
  unique (fingerprint)
);

create index if not exists jobs_status_idx on jobs(status);
create index if not exists jobs_published_at_idx on jobs(published_at desc);
create index if not exists jobs_title_idx on jobs using gin(to_tsvector('simple', title));
create index if not exists jobs_original_url_idx on jobs(original_url);

create table if not exists ingestion_runs (
  id uuid primary key default gen_random_uuid(),
  source_id uuid references sources(id) on delete set null,
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  status text not null default 'running' check (status in ('running','success','error')),
  items_found integer not null default 0,
  items_created integer not null default 0,
  items_updated integer not null default 0,
  error_message text
);

create table if not exists job_categories (
  job_id uuid not null references jobs(id) on delete cascade,
  category text not null,
  primary key (job_id, category)
);

create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists companies_updated_at on companies;
create trigger companies_updated_at before update on companies
for each row execute function set_updated_at();

drop trigger if exists jobs_updated_at on jobs;
create trigger jobs_updated_at before update on jobs
for each row execute function set_updated_at();

create or replace view job_search as
select
  j.id, j.title, j.original_url, j.employment_type, j.salary_min, j.salary_max,
  j.salary_currency, j.salary_text, j.benefits, j.requirements, j.published_at,
  j.expires_at, j.status, c.name as company_name, s.name as source_name,
  l.city, l.state, l.country
from jobs j
left join companies c on c.id = j.company_id
left join sources s on s.id = j.source_id
left join locations l on l.id = j.location_id;