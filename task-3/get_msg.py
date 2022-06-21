from google.cloud import pubsub_v1
from google.api_core import retry


def read_messages(project_id, subscription_id):

    '''
    This method reads messages from pub/sub
    args:
        project_id: project id of the current project.
        subscription_id: subscription id of the pub/sub.
    '''

    subs = pubsub_v1.SubscriberClient()
    subs_path = 'projects/{project_id}/subscriptions/{subscription_id}'

    response = subs.pull(
                request={
                    "subscription": subs_path,
                    "max_messages": 1
                },
                retry=retry.Retry(deadline=300))

    ack_id = []

    for messages in response.received_messages:
        ack_id.append(messages.ack_id)

        print("message received is:-", messages.message.data)

    subs.acknowledge(request= {"subscription": subs_path,
    "ack_ids": ack_id} )

read_messages('demo-id', 'dev_subs_001')




