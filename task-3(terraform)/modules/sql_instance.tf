resource "google_sql_database_instance" "my-sql-server" {

    name = "cloud sql instance"
    region = "asia-east1"
    database_version = "mysql_5_7"
    project = "demo-project"
    master_instance_name = google_sql_database_instance.my-sql-server.name

    settings {

      tier = "db-f1-micro"
      availability_type = "REGIONAL"
      disk_size = 20
      disk_type = "PD_SSD"

      backup_configuration {
        
        enabled = true
        binary_log_enabled = true
        point_in_time_recovery_enabled = true
        start_time = "00:00"
        location = "asia-west1"

        backup_retention_settings {
          
          retained_backups = 3
          retention_unit = "COUNT"

            }

        }

        maintenance_window {
          
          day = 7
          hour = 0
          update_track = "stable"

        }

      ip_configuration {
        
        ipv4_enabled = true
        
        }
    
    }
    
    replica_configuration {

        user = "root_user"
        password = "root_pass@123"
        failover_target = true

    }

    root_password = "root_user@123"
    deletion_protection = true

}


resource "google_sql_user" "my-sql-user" {

    name = "root_user"
    password = "root_pass@123"
    instance = google_sql_database_instance.my-sql-server.name
    project = "demo-project"
  
}

output "sql_instance_ip" {

    value = google_sql_database_instance.my-sql-server.ip_address
}
  

