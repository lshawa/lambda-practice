## Project Details

This is my attempt at practicing using infra as code (terraform) to create a lambda to deploy my python function and to create a role and policy. 

## Assume Role Policy 

An assume role policy is a special policy associated with a role that controls which principals (users, other roles, AWS services, etc) can "assume" the role. Assuming a role means generating temporary credentials to act with the privileges granted by the access policies associated with that role.

An assume role policy differs from a normal policy in the following ways:

1. It is a property of the role itself, rather than a separate object associated with the role. There is only one assume role policy per role.
2. The only `Action` values that have any meaning in an assume role policy are `sts:AssumeRole` and some other variants on it (at the time of writing, `sts:AssumeRoleWithSAML` and `sts:AssumeRoleWithWebIdentity`). Those are the API operations used to obtain the temporary credentials for the role.

An AWS IAM role has two key parts:

1. The assume role policy, that controls which services and/or users may assume the role.
2. The policies controlling what the role grants access to. This decides what a service or user can do once it has assumed the role.

## Steps

1. Let’s start by creating a main.tf file and inside the main.tf file create a role `Laraine_Test_Lambda_Function_Role`. 

2. Add IAM Policy 
After creating the IAM Role, let’s create an IAM Policy to manage the permissions associated with the role. Since this is a small application, we will be assigning the following permissions: 

1. logs:CreateLogGroup
2. logs:CreateLogStream
3. logs:PutLogEvents

3. Add the following IAM Policy resource block to main.tf:

4. Setup your credentials 
```bash
aws configure 
```


Practice Project: Assume Role 
