variable "gql_port" {
  default     = 4000
  description = "The (development) port associated with the graphql API service"
}

resource "aws_ecs_task_definition" "ytrd_gql_api_task" {
  family = "ytrd_gql_task"

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  memory = 512
  cpu    = 256

  execution_role_arn = aws_iam_role.ecs_role.arn

  container_definitions = jsonencode([
    {
      name : "ytrd_gql_container"
      image : "public.ecr.aws/i3k0c8g9/ytrd-gql-dev:latest"
      essential : true
      memory : 512
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-group : aws_cloudwatch_log_group.ytrd_main_logs.name,
          awslogs-region : var.aws_region,
          awslogs-stream-prefix : "ytrd-gql"
        }
      },
      portMappings : [
        {
          "containerPort" : var.gql_port
          "hostPort" : var.gql_port
        }
      ]
      environment : [
        {
          name : "GCP_API_KEY"
          value : var.gcp_api_key
        },
      ]
    }
  ])
}

resource "aws_ecs_service" "ytrd_gql_service" {
  name = "ytrd_gql_service"

  cluster         = aws_ecs_cluster.ytrd_cluster.id
  task_definition = aws_ecs_task_definition.ytrd_gql_api_task.arn

  depends_on = [
    aws_internet_gateway.ytrd_default_igw
  ]

  launch_type   = "FARGATE"
  desired_count = 1

  network_configuration {
    # maybe create a variable to hold the list of subnet id's
    subnets          = [aws_subnet.ytrd_public_a.id, aws_subnet.ytrd_public_b.id]
    security_groups  = [aws_security_group.ytrd_secgroup.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_gql_tg.arn
    container_name   = "ytrd_gql_container"
    container_port   = var.gql_port
  }
}
