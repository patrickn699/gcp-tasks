# Event driven workflow

### Scenario implemented

When an email is sent to support.example.com by client, at the backend
cloud workflows will start executing where, it calls pub/sub and publishes a message to the channel. As soon as the message is publishes a cloud function will be triggered which will then send an email to the devlopment, devops and management team respectively saying client has sent an email so look into it.

The workflow uses series of steps defined inside workflow.yaml, the workflow will start running the steps written in it.

### Scripts info:

1. infra.py:     
* Contains scripts to initiate and configure pub/sub, functions and workflow.

2. workflow.yaml:
* Contains steps defined for the workflow to execute.

3. send_mail.py:
* Contains script to send email to the backend team.


### services used:

1. Wrokflows
2. Pub/Sub
3. Cloud Functions
