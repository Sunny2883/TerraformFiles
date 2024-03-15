variable "image_url" {
  description = "URL of the Docker image for the ECS task"
  type = string
}

variable "cpu" {
  description = "CPU units for the ECS task"
  type = string
}

variable "memory" {
  description = "Memory for the ECS task (in MiB)"
 type = string
}

variable "task_name" {
  description = "Name of the ECS task"
  type = string
}






variable "min_capacity" {
  description = "Minimum capacity for Auto Scaling Group"
}

variable "max_capacity" {
  description = "Maximum capacity for Auto Scaling Group"
}


variable "backend_image_url" {
  type = string
}

variable "backend_task_name" {
  type = string
}