# An assume role policy is a special policy associated with a role that controls which principals (users, other roles, AWS services, etc) can "assume" the role. 
# Assuming a role means generating temporary credentials to act with the privileges granted by the access policies associated with that role.
/**
Add IAM Role
**/

provider "aws" {
  region = "us-west-2"
  alias  = "env"
}

/**
Assume Role Policy === Trust policy 
**/
resource "aws_iam_role" "lambda_role" {
  name               = "Laraine_Test_Lambda_Function_Role"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Principal": {
        "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
    }
    ]
    }
    EOF
}

/**
Add IAM Policy
**/
resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "aws_iam_policy_for_terraform_aws_lambda_role"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

/**
Attach IAM Policy to IAM Role
**/

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

/**
Create a Zip of Python App
**/
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/hello-python.zip"
}
 

/**
AWS Lambda func resource

1. Runtime—
    You should mention correction runtime which AWS Lambda is going to use for running your Lambda function. 
    Currently, AWS Lambda supports Node.js, Python, JAVA, Ruby, Go, .NET.
2. IAM Role—
    Always mention the correct IAM role which you have created for the Lambda function.
3. Depends_on—
    Mention the correct IAM policy attachment block where you have attached the IAM role to IAM policy. It is a sanity check to make sure that IAM Policy and IAM roles are in place before lambda function is created.

**/
resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/python/hello-python.zip"
  function_name = "Laraine_Test_Lambda_Function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}