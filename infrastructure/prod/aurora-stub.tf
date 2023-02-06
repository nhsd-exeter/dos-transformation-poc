
module "cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"
    version = "6.2.0"

  name           = "uec-core-dos-prod-aurora-stub"
  engine         = "postgres"
  engine_version = "14.5"
  instance_class = "db.t3.medium"
  instances = {
    one = {
      preferred_maintenance_window = "Mon:01:00-Mon:03:00"
    },
    two = {
      preferred_maintenance_window = "Tue:01:00-Tue:03:00"
    }
  }

  iam_role_name                = "core-dos-prod-monitoring"
  iam_role_use_name_prefix     = true
  preferred_backup_window      = "00:00-01:00"
  preferred_maintenance_window = "Wed:01:00-Wed:03:00"
  auto_minor_version_upgrade   = false

  # Autoscaling policies
  autoscaling_enabled             = true
  autoscaling_min_capacity        = 1
  autoscaling_max_capacity        = 3
  autoscaling_target_cpu          = 40
  autoscaling_scale_in_cooldown   = 300
  autoscaling_scale_out_cooldown  = 120

  # vpc_id  = "default"
  # subnets = data.terraform_remote_state.vpc.outputs.private_subnets  (CREATE)

  create_security_group  = false
  vpc_security_group_ids = [aws_security_group.aurora_stub_sg.id]

  deletion_protection = false
  master_username     = "postgres"

  # if specifying a value here, 'create_random_password' should be set to `false`
  master_password                  = "test123"
  create_random_password           = false
  storage_encrypted                = true
  apply_immediately                = true
  monitoring_interval              = 10
  copy_tags_to_snapshot            = false
  skip_final_snapshot              = true
  final_snapshot_identifier_prefix = "final-snapshot"

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group.name
  db_parameter_group_name         = aws_db_parameter_group.aurora_instance_parameter_group.name

  create_db_subnet_group          = true
  # db_subnet_group_name            = "subnet-1c3e8c50"
  performance_insights_enabled    = false
  enabled_cloudwatch_logs_exports = ["postgresql"]
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group" {
  name        = "uec-core-dos-prod-aurora-cluster-pg-14"
  family      = "aurora-postgresql14"
  description = "Aurora instance stub parameter group"

  parameter {
    name         = "max_connections"
    value        = "100"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }


  parameter {
    name         = "timezone"
    value        = "GB"
  }

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "wal_sender_timeout"
    value = "0"
  }

  parameter {
    name  = "log_lock_waits"
    value = "0"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "-1"
  }

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements,pg_hint_plan"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "default_statistics_target"
    value = "256"
  }

  parameter {
    name = "random_page_cost"
    value = "1"
  }

  parameter {
    name = "apg_enable_remove_redundant_inner_joins"
    value = "1"
  }

}

resource "aws_db_parameter_group" "aurora_instance_parameter_group" {
  name = "uec-core-dos-prod-aurora-instance-pg-14"
  family      = "aurora-postgresql14"
  description = "Aurora instance stub parameter group"
}

resource "aws_security_group" "aurora_stub_sg" {
  name        = "uec-core-dos-prod-aurora-stub-sg"
  description = "uec core dos prod aurora stub sg"
  # vpc_id      = "default"
}