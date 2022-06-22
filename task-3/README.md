# Event driven workflow

### Scenario implemented

When an email is sent to support.example.com by client, at the backend
cloud workflows will start executing where, it calls pub/sub and publishes a message to the channel. As soon as the message is publishes a cloud function will be triggered which will then send an email to the devlopment, devops and management team respectively saying client has sent an email so look into it.