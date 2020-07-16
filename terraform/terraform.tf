variable "sitename" {
    type    = string
    default = "michaelquinonez.com"
}

provider "aws" {
}

resource "aws_s3_bucket" "root" {
    bucket  = var.sitename
    policy  = file("policy.json")

    website {
        index_document = "index.html"
    }
}

resource "aws_s3_bucket" "rootwww" {
    bucket  = format("www.%s", var.sitename)

    website {
        redirect_all_requests_to = var.sitename
    }
}

resource "aws_s3_bucket_public_access_block" "block" {
    bucket = aws_s3_bucket.rootwww.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_route53_zone" "main" {
    name = var.sitename
}

resource "aws_route53_record" "base" {
    name    = var.sitename
    zone_id = aws_route53_zone.main.zone_id
    type    = "A"

    alias {
        name                    = aws_s3_bucket.root.website_endpoint
        zone_id                 = aws_s3_bucket.root.hosted_zone_id
        evaluate_target_health  = false
    }
}

resource "aws_route53_record" "basewww" {
    name    = format("www.%s", var.sitename)
    zone_id = aws_route53_zone.main.zone_id
    type    = "A"

    alias {
        name                    = aws_s3_bucket.rootwww.website_endpoint
        zone_id                 = aws_s3_bucket.rootwww.hosted_zone_id
        evaluate_target_health  = false
    }
}
