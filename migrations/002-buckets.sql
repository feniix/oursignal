create table score_buckets(
  source  text,
  buckets float[100],
  primary key(source)
);

alter table scores
  add column bucket float
;

alter table links
  drop column score_freshness
;
