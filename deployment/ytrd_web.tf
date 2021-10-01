
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
      name: "ytrd_web_container"
      image: "public.ecr.aws/i3k0c8g9/ytrd-web-dev:latest"
      memory: 512
      essential: true
      portMappings: [
        {
          "containerPort" : 3000,
          "hostPort" : 3000
        }
      ]
    },
  ])
}

resource "aws_ecs_service" "ytrd_web_service" {
  name = "ytrd_web_service"

  cluster         = aws_ecs_cluster.ytrd_cluster.id
  task_definition = aws_ecs_task_definition.ytrd_web_task.arn

  launch_type   = "FARGATE"
  desired_count = 1

  network_configuration {
    subnets          = [aws_subnet.ytrd_public_a.id]
    security_groups  = [aws_security_group.ytrd_secgroup.id]
    assign_public_ip = true
  }
}