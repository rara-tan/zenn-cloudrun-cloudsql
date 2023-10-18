resource "google_sql_database" "database" {
  project = var.project_id

  name     = "database"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "instance" {
  project = var.project_id

  name             = "instance-1"
  region           = "asia-northeast1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = "true"
}
