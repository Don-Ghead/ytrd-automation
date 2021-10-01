# resource "aws_ecs_task_definition" "ytrd_gql_api_task" {
#   family = "ytrd_gql_task"

#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"

#   memory = 512
#   cpu    = 256

#   execution_role_arn = aws_iam_role.ecs_role.arn

#   container_definitions = jsonencode([
#     {
#       name: "ytrd_gql_container"
#       image: "public.ecr.aws/i3k0c8g9/ytrd-gql-dev:latest"
#       memory: 512
#       essential: true
#       portMappings: [
#         {
#           "containerPort" : 4000
#           "hostPort" : 4000
#         }
#       ]
#       environment: [
#         {
#           name: "GCP_API_KEY"
#           value: var.gcp_api_key
#         }
#       ]
#     }
#   ])
# }

# resource "aws_ecs_service" "ytrd_gql_service" {
#   name = "ytrd_gql_service"

#   cluster         = aws_ecs_cluster.ytrd_cluster.id
#   task_definition = aws_ecs_task_definition.ytrd_gql_api_task.arn

#   launch_type   = "FARGATE"
#   desired_count = 1

#   network_configuration {
#     subnets          = [aws_subnet.ytrd_public_a.id]
#     security_groups  = [aws_security_group.ytrd_secgroup.id]
#     assign_public_ip = true
#   }
# }
