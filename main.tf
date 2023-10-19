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

resource "google_sql_user" "users" {
  project = var.project_id

  name     = "test-user"
  instance = google_sql_database_instance.instance.name
  password = "password_1234"
}

resource "google_service_account" "new_account" {
  project      = var.project_id
  account_id   = "test1234"
  display_name = "Test Service Account"
}

resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.new_account.email}"
}

resource "google_cloud_run_service" "default" {
  project  = var.project_id
  name     = "test-sql"
  location = "asia-northeast1"
  template {
    spec {
      service_account_name = google_service_account.new_account.email

      containers {
        image = "gcr.io/${var.project_id}/test"
      }
    }
    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = "${var.project_id}:asia-northeast1:instance-1"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public" {
  project  = var.project_id
  service  = google_cloud_run_service.default.name
  location = "asia-northeast1"
  role     = "roles/run.invoker"
  member   = "allUsers"
}
