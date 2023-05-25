/* output "vpc_id" {
  description = "ID of project VPC"
  value       = module.vpc.vpc_id
}
*/

output "iam_user" {
  value       = aws_iam_user.user.name
  description = "IAM user name"
}


output "iam_ssh_key" {
  value       = aws_iam_user_ssh_key.user.id
  description = "ssh key id"

}


output "aws_key_pait_name" {
  value       = aws_key_pair.k_deployer.key_name
  description = "key pair name"

}