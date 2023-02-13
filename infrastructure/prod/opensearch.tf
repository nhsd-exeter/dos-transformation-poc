# ##########################
# # Opensearch
# ##########################

variable "domain" {
  default = "directory-search"
}

variable "index_name" {
  default = "directory-index"
}

resource "aws_elasticsearch_domain" "directory_search" {
  domain_name           = var.domain
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
    iops        = "3000" 
    volume_type = "gp3"
  }


  access_policies = jsonencode({
      Version: "2012-10-17",
      Statement: [
          {
            Effect: "Allow",
            Principal: {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github"
            },
            Action: "es:*",
            Resource: "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
          },
          {
            Effect: "Allow",
            Principal: {
              "AWS": "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/elastic-search/elastic-search"
            },
            Action: [
                "es:ESHttpGet",
                "es:ESHttpPost"
              ]
            Resource: "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
          },
          {
            Effect: "Allow",
            Principal: {
              "AWS": "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/directory-data-relay/directory-data-relay"
            },
            Action: [
                "es:ESHttpDelete",
                "es:ESHttpGet",
                "es:ESHttpPost",
                "es:ESHttpPut"
              ],
            Resource: "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
          },
                    {
            Effect: "Allow",
            Principal: {
              "AWS": "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/geo-data-relay/geo-data-relay"
            },
            Action: [
                "es:ESHttpDelete",
                "es:ESHttpGet",
                "es:ESHttpPost",
                "es:ESHttpPut"
              ],
            Resource: "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
          }
        ]
      }
    )
  }



  resource "null_resource" "elastic_provisioner_script" {
    provisioner "local-exec" {
      command = <<EOT
        cd ./elastic
        pip install -r requirements.txt --target .
        python3 configure_elastic.py ${var.aws_region} ${aws_elasticsearch_domain.directory_search.endpoint} 
      EOT
      }
      
      triggers = {
          always_run = timestamp()
      }
  }

