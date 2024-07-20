variable "lambda_source_code_hash" {
  description = "Base64-encoded SHA-256 hash of the Lambda deployment package"
  type        = string
  default     = ""
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "MyLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "AWSLambdaProject"
  runtime       = "dotnet8"

  filename         = "../publish/lambda-deployment-package.zip"
  source_code_hash = var.lambda_source_code_hash != "" ? var.lambda_source_code_hash : null
  }

  tags = {
    Name = "MyLambdaFunction"
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_attach]
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })

  tags = {
    Name = "lambda_exec_role"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.my_lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.my_rest_api.execution_arn}/*/*"
}