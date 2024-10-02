output "cluster_id" {
  value = aws_eks_cluster.MultiTierPipeline.id
}

output "node_group_id" {
  value = aws_eks_node_group.MultiTierPipeline.id
}

output "vpc_id" {
  value = aws_vpc.MultiTierPipeline_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.MultiTierPipeline_subnet[*].id
}
