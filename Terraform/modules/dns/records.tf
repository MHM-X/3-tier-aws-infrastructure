
# GitHub Pages - Apex domain
resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300

  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]
}

# GitHub Pages - WWW
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 300

  records = ["mhm-x.github.io"]
}

# White API - Application Load Balancer
resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "api"
  type    = "CNAME"
  ttl     = 300

  records = [var.alb_dns_name]
}

# ACM certificate validation
resource "aws_route53_record" "acm_validation" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "_aa03a66d7a5fd19f5d35687c0717e91c.api"
  type    = "CNAME"
  ttl     = 300

  records = [
    "_60367fdb0c47b6cc01657500b864c3b9.wzccmgtwzk.acm-validations.aws"
  ]
}

# Brevo DKIM
resource "aws_route53_record" "brevo1_dkim" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "brevo1._domainkey"
  type    = "CNAME"
  ttl     = 3600

  records = ["b1.white-ps.dkim.brevo.com"]
}

resource "aws_route53_record" "brevo2_dkim" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "brevo2._domainkey"
  type    = "CNAME"
  ttl     = 3600

  records = ["b2.white-ps.dkim.brevo.com"]
}

# DMARC
resource "aws_route53_record" "dmarc" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "_dmarc"
  type    = "TXT"
  ttl     = 3600

  records = [
    "v=DMARC1; p=none; rua=mailto:rua@dmarc.brevo.com"
  ]
}

# Apex TXT records
resource "aws_route53_record" "apex_txt" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 3600

  records = [
    "v=spf1 include:_spf.mx.cloudflare.net ~all",
    "google-site-verification=qJidYUXcsPY2jDm4KqYRtkgggE_LwbUsz_-iAgKJC3k",
    "brevo-code:7ac12c96881d81d65750c4b5eeb4da72"
  ]
}


resource "aws_route53_record" "cf_dkim" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "cf2024-1._domainkey"
  type    = "TXT"
  ttl     = 300

  records = [
    "v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k\" \"m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB"
  ]
}
