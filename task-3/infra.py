import subprocess


def create_topic(topic_name):

    '''
    This method creates a pub/sub topic
    args:
        topic_name: name of the topic to be created.
    '''
    
    subprocess.run(['gcloud', 'pubsub', 'topics', 'create', topic_name], shell=True)


def subscribe_to_topic(topic_name, subscription_name):

    '''
    This mehtod crates subscription to the specified pub/sub topic
    args:
        topic_name: name of the topic to subscribe.
        subscription_name: name of the subscribers.
    '''

    subprocess.run(['gcloud','pubsub','subscriptions', 'create', subscription_name, '--topic', topic_name], shell=True)


def create_workflow(workflow_name, region, service_account):

    '''
    this method creates a workflow of services
    args:
        workflow_name: name of the workflow to create.
        region: region where the workflow should be deployed.
        service_aacount: specified service account.
    '''

    subprocess.run(['gcloud','workflows', 'deploy', workflow_name, '--location', region,
    '--service-account', service_account, '--source', 'workflow.yaml'], shell=True)


def get_details(workflow_name, region):

    '''
    This methods return details about the current workflow
    args:
        workflow_name: name of the workflow.
        region: region where the workflow is deployed.
    '''

    subprocess.run(['gcloud', 'workflows', 'describe', workflow_name, '--location', region], shell=True)


def execute_workflow(workflow_name, region):

    '''
    This method executes the specfied workflow.
    args:
        workflow_name: name of the workflow.
        region: region where the workflow is deployed.

    '''

    subprocess.run(['gcloud', 'workflows', 'execute', workflow_name, '--location', region], shell=True)


create_topic('email-by-customer')
subscribe_to_topic('email-by-customer', 'devlopment-team')
subscribe_to_topic('email-by-customer', 'devops-team')
subscribe_to_topic('email-by-customer', 'management-team')
create_workflow('email-event', 'us-west1', "demo-service-account")
get_details('email-event', 'us-west1')
execute_workflow('email-event', 'us-west1')

