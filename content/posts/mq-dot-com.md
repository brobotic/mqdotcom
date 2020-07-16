---
title: "Behind the scenes of michaelquinonez.com"
date: 2020-07-14T23:19:04-07:00
draft: false
---

Here's what technology is used to build, deploy, and run this site.

* [Hugo](https://gohugo.io/): this fantastic static site generator is what I use to build the site. Posts are written in markdown, and build times are insanely fast: ~60ms average for this blog. There is even deployment support built-in, so I can push the content to S3 by running `hugo deploy`.
* [AWS](https://aws.amazon.com)
    * [S3](https://aws.amazon.com/s3/): the static files are being served from an s3 bucket. Not having to maintain a web server is a plus.
    * [Route53](https://aws.amazon.com/route53/): AWS' DNS services are required to serve the S3 bucket at this domain name.
* [Terraform](https://www.terraform.io/): all of the S3 and Route53 configuration is defined in Terraform files. Being able to store the configuration as infrastructure-as-code was a requirement for me, and Terraform supports managing AWS resources out of the box. I can nuke everything with the `terraform destroy` command, and bring it back up with `terraform apply`. You can view the Terraform configuration [here](https://github.com/brobotic/mqdotcom/blob/master/terraform/terraform.tf).

In the near future, the site's content will be versioned in GitHub so I can create an automated deployment process whenever new code is committed to the master branch.