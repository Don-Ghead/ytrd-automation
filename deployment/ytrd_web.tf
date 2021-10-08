variable "web_port" {
  default     = 3000
  description = "The (development) port associated with the web service"
}

resource "aws_cloudwatch_log_group" "ytrd_main_logs" {
  name              = "ytrd_logs"
  retention_in_days = 1
}

resource "aws_ecs_cluster" "ytrd_cluster" {
  name = "ytrd_cluster"
}

resource "aws_ecs_task_definition" "ytrd_web_task" {
  family = "ytrd_web_task"

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  # When specifying fargate task, you need to have a valid
  # combination of memory/cpu
  memory = 512
  cpu    = 256

  execution_role_arn = aws_iam_role.ecs_role.arn

  container_definitions = jsonencode([
    {
      name : "ytrd_web_container"
      image : "public.ecr.aws/i3k0c8g9/ytrd-web-dev:latest"
      essential : true
      memory : 512
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-group : aws_cloudwatch_log_group.ytrd_main_logs.name,
          awslogs-region : var.aws_region,
          awslogs-stream-prefix : "ytrd-web"
        }
      },
      portMappings : [
        {
          "containerPort" : var.web_port,
          "hostPort" : var.web_port
        }
      ]
      environment : [
        {
          name : "REACT_APP_GQL_HOST"
          value : aws_lb.ytrd_alb.dns_name
        },
      ]
    },
  ])
}

resource "aws_ecs_service" "ytrd_web_service" {
  name = "ytrd_web_service"

  cluster         = aws_ecs_cluster.ytrd_cluster.id
  task_definition = aws_ecs_task_definition.ytrd_web_task.arn

  depends_on = [
    aws_internet_gateway.ytrd_default_igw
  ]

  launch_type   = "FARGATE"
  desired_count = 1

  network_configuration {
    subnets          = [aws_subnet.ytrd_public_a.id, aws_subnet.ytrd_public_b.id]
    security_groups  = [aws_security_group.ytrd_secgroup.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_web_tg.arn
    container_name   = "ytrd_web_container"
    container_port   = var.web_port
  }
}
