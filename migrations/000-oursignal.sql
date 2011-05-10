create table links(
  id                bigserial,
  url               text,
  title             varchar(255),
  score_delicious   float default '0',
  score_digg        float default '0',
  score_frequency   float default '0',
  score_freshness   float default '0',
  score_reddit      float default '0',
  score_twitter     float default '0',
  score_ycombinator float default '0',
  updated_at        timestamp default now(),
  created_at        timestamp default now(),
  unique(url),
  primary key(id)
);
create index links_updated_at_idx on links(updated_at);
create index links_score_at_idx on links(score_at);

create table score_kmeans_centroids(
  score_delicious   float,
  score_digg        float,
  score_frequency   float,
  score_reddit      float,
  score_swarm       float,
  score_twitter     float,
  score_ycombinator float,
  score             float not null
);

create table score_timeseries(
  link_id bigint not null,
  score_delicious   float,
  score_digg        float,
  score_frequency   float,
  score_reddit      float,
  score_swarm       float,
  score_twitter     float,
  score_ycombinator float,
  score             float,
  velocity          float,
  created_at        timestamp default not null,
  foreign key(link_id) references links(id) on delete cascade
);
create index score_samples_created_at_idx on score_timeseries(created_at);

create table feeds(
  id            bigserial,
  title         varchar(255),
  site          text,
  url           text not null,
  etag          text default null,
  last_modified timestamp default null,
  total_links   integer default '0',
  daily_links   float default '0',
  updated_at    timestamp default now(),
  created_at    timestamp default now(),
  unique(url),
  primary key(id)
);
create index feeds_updated_at_idx on feeds(updated_at);

create table feed_links(
  feed_id bigint not null,
  link_id bigint not null,
  url     text,
  unique(feed_id, url),
  primary key(feed_id, link_id),
  foreign key(feed_id) references feeds(id) on delete cascade,
  foreign key(link_id) references links(id) on delete cascade
);
create index feed_links_url_idx on feed_links(url);

