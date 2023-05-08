+++
title = "g. Connect to PCluster UI"
date = 2019-09-18T10:46:30-04:00
weight = 70
tags = ["tutorial", "initialize", "ParallelCluster"]
+++

ParallelCluster UI was deployed as a CloudFormation Stack prior to the event. To access it you'll need to create a user.

#### Create User

1. Open the [Cognito Console](https://console.aws.amazon.com/cognito/v2/idp/user-pools)

2. Choose **parallelcluster-ui-Cognito-**...

3. Choose **Create user**:
![Create user](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-a-create-user.png)

4. Enter the following details for the new user:

- Invitation: **Send an email invitation**
- Email Address: **An email address you can access during the event**
- Password: **generate password**

Leave everything else set with the default values.

![New Cognito user](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-b-cognito-new-user.png)

5. You should now have an email titled **[AWS ParallelCluster UI] Welcome to ParallelCluster UI, please verify your account.** Copy the temporary password from that email.

> From: “no-reply@verificationemail.com” no-reply@verificationemail.com Date: Sunday, May 21, 2023 at 10:00 AM To: you@email.com Subject: [AWS ParallelCluster UI] Welcome to AWS ParallelCluster UI, please verify your account.

> You are invited to manage clusters with ParallelCluster UI. Your administrator will contact you with the link to access. Your username is you@email.com and your temporary password is XXXXXX (you will need to change it in your first access).

6. Next we'll need to grant our newly created user their permissions. To do so we first need to click on the username (the long hash like **bd719805-047a-4cc7-a056-ccd0e012519a**):

![New Cognito username](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-c-click-username.png)

7. Scroll down in the user details section to **Groups > Add user to Group**:

![Add user to group](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-d-add-user-group.png)

8. Select **Admin >** and click **Add**


#### Connect to the cluster

1. Navigate to [AWS CloudFormation Console](https://us-east-2.console.aws.amazon.com/cloudformation/home?region=us-east-2#/stacks) and on the left select the stack **parallelcluster-ui**

2. Click on **Outputs** and look for the row showing the key **ParallelClusterUIUrl**

![PClusterUIURL](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-e-pcluster-deployed.png)

3. **Enter the credentials** using the _email address_ you used when creating the user, and the _temporary password_ from the email you received.

![PCluster Login](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-f-pcmanager-creds.png)

4. You will be required to provide a new password; please enter this new password to complete signup.

![Password update](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-g-signup.png)

You will now be logged in to the AWS ParallelCluster UI, with your cluster build either still in-progress or complete.

![Pcluster UI Log in](/images/hpc-aws-parallelcluster-workshop/lab1-pcluster-workshop-07-h-cluster-creation-in-progress.png)

Next you will do a dry run cluster creation using the ParallelCluster UI to familiarise yourself with the steps taken earlier.