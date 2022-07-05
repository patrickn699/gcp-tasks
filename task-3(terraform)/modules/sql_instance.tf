resource "google_compute_network" "private-vpc" {

    name = "private-my_sql-vpc"
  
}


resource "google_sql_database_instance" "my-sql-server" {

    name = "cloud sql instance"
    region = "asia-east1"
    database_version = "mysql_5_7"
    project = "demo-project"

    settings {

      tier = "db-f1-micro"
      availability_type = "REGIONAL"
      disk_size = 20
      disk_type = "PD_SSD"

      backup_configuration {
        
        binary_log_enabled = true
        enabled = true
        point_in_time_recovery_enabled = true
        start_time = "00:00"
        }

      ip_configuration {
        
        ipv4_enabled = true
        private_network = google_compute_network.private-vpc.self_link
        
        }
    
    }
    
    replica_configuration {

        user = "root_user"
        password = "root_pass@123"
        failover_target = true
        location = "us-east1"
        database_version = "mysql_5_7"
    }

    root_password = "root_user@123"
    deletion_protection = true
    

}