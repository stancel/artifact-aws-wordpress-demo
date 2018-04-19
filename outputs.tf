output "public_url" {
  value = "${aws_instance.web.public_dns}"
}
