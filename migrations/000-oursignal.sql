create table links(
  id                bigserial,
  url               text,
  title             text,
  content_type      text,
  score_delicious   float default '0',
  score_digg        float default '0',
  score_facebook    float default '0',
  score_frequency   float default '0',
  score_freshness   float default '0',
  score_googlebuzz  float default '0',
  score_reddit      float default '0',
  score_twitter     float default '0',
  score_ycombinator float default '0',
  updated_at        timestamp with time zone default now(),
  created_at        timestamp with time zone default now(),
  referred_at       timestamp with time zone default now(),
  unique(url),
  primary key(id)
);
create index links_updated_at_idx on links(updated_at);

create table timesteps(
  id          serial,
  created_at  timestamp with time zone default now(),
  primary key(id)
);
create index timesteps_created_at_idx on timesteps(created_at);

create table scores(
  timestep_id       integer not null,
  link_id           bigint not null,
  score_delicious   float,
  score_digg        float,
  score_facebook    float,
  score_frequency   float,
  score_freshness   float,
  score_googlebuzz  float,
  score_reddit      float,
  score_twitter     float,
  score_ycombinator float,
  kmeans            float,
  ema               float,
  velocity          float,
  score             float,
  primary key(timestep_id, link_id),
  foreign key(timestep_id) references timesteps(id) on delete cascade,
  foreign key(link_id)     references links(id)     on delete cascade
);
create index scores_score_idx on scores(score);

create table feeds(
  id            bigserial,
  title         varchar(255),
  url           text not null,
  total_links   integer default '0',
  daily_links   float default '0',
  updated_at    timestamp with time zone default now(),
  created_at    timestamp with time zone default now(),
  unique(url),
  primary key(id)
);
create index feeds_url_idx        on feeds(url);
create index feeds_updated_at_idx on feeds(updated_at);

create table entries(
  feed_id bigint not null,
  link_id bigint not null,
  url     text,
  unique(feed_id, url),
  primary key(feed_id, link_id),
  foreign key(feed_id) references feeds(id) on delete cascade,
  foreign key(link_id) references links(id) on delete cascade
);
create index entries_url_idx on entries(url);
