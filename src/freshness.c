#include "score.h"

int main (int arc, char* argv[]) {
  // TODO: Move all the basic looping stuff into score.h && score.c

  // TODO: Read from the config/database.yml
  MYSQL *db = mysql_init(NULL);
  if (!mysql_real_connect(db, "localhost", "root", "", "oursignal", 0, NULL, 0)) {
    fprintf(stderr, "%s\n", mysql_error(db));
    return 1;
  }

  if (mysql_query(db, "select url, ((now() - referred_at) / (60 * 60)) as hours from links")) {
    fprintf(stderr, "%s\n", mysql_error(db));
    return 1;
  }

  printf("select all links ... ");
  MYSQL_RES *links;
  if (!(links = mysql_store_result(db))) {
    fprintf(stderr, "nok\nerror: %s\n", mysql_error(db));
    return 1;
  }
  printf("ok, %lu rows\n", (unsigned long int)mysql_num_rows(links));

  // TODO: Move all the query preperation stuff in score.h && score.c and share it with frequency.
  MYSQL_BIND binds[5];
  memset(binds, 0, sizeof(binds));

  MYSQL_STMT *score = mysql_stmt_init(db); // TODO: Check for out of memory?
  char *insert      = "insert into scores (id, source, url, score, created_at, updated_at) values (sha1(?), ?, ?, ?, now(), now()) on duplicate key update score = ?, updated_at = now()";
  if (mysql_stmt_prepare(score, insert, strlen(insert))) {
    fprintf(stderr, "error: %s", mysql_stmt_error(score));
    return(1);
  }

  char* id     = malloc(300);
  char* source = "freshness";
  unsigned long source_length = strlen(source);

  binds[0].buffer_type   = MYSQL_TYPE_STRING;
  binds[0].buffer_length = 300;
  binds[1].buffer_type   = MYSQL_TYPE_STRING;
  binds[1].buffer_length = 50;
  binds[1].buffer        = source;
  binds[1].length        = &source_length;
  binds[2].buffer_type   = MYSQL_TYPE_STRING;
  binds[2].buffer_length = 255;
  binds[3].buffer_type   = MYSQL_TYPE_FLOAT;
  binds[4].buffer_type   = MYSQL_TYPE_FLOAT;

  printf("updating scores  ... ");

  MYSQL_ROW link;
  unsigned long int updates = 0;
  while ((link = mysql_fetch_row(links))) {
    float hours = atof(link[1]);
    hours = hours < 24 ? ((24.0f - hours) / 24) : 0.0f;

    strcpy(id, source);
    strcat(id, link[0]);

    unsigned long id_length = strlen(id);
    binds[0].buffer = id;
    binds[0].length = &id_length;

    unsigned long url_length = strlen(link[0]);
    binds[2].buffer = link[0];
    binds[2].length = &url_length;

    binds[3].buffer = (char*)& hours;
    binds[3].length = 0;
    binds[3].is_null = 0;

    binds[4].buffer = (char*)& hours;
    binds[4].length = 0;
    binds[4].is_null = 0;

    if (mysql_stmt_bind_param(score, binds)) {
      fprintf(stderr, "%s\n", mysql_stmt_error(score));
      continue;
    }

    if (mysql_stmt_execute(score)) {
      fprintf(stderr, "%s\n", mysql_stmt_error(score));
      continue;
    }

    // Silly MySQL returns 2 on duplicate keys. It's 'rows' affected dickheads, not successful statments.
    if (mysql_stmt_affected_rows(score) > 0) {
      updates += 1;
    }
  }

  if (mysql_stmt_close(score)) {
    fprintf(stderr, " %s\n", mysql_stmt_error(score));
    return(1);
  }

  free(id);
  mysql_free_result(links);
  mysql_close(db);

  printf("ok, %lu rows\n", updates);
  return(0);
}
