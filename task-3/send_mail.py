import sendgrid
from sendgrid.helpers.mail import Email, Content, Mail, To


def send_mail(event, context):

    '''
    This method sends email to backend teams.
    args:
        event: tells what event occured.
        context: gives metadata about event occured.
    '''

    # instantiate the email client
    mailg = sendgrid.SendGridAPIClient(api_key='api223344')

    # send email from
    from_mail = Email("gcp-pubsub@example.com")

    # send email to all the 3 teams
    to_mail = To(["devops_support@example.com","dev_support@example.com", "management_support@example.com"])

    # subject of the email
    subject = "Alert!, mail from client"

    # body of email
    content = Content("text/plain", "Hello team!, client has sent an email please look into it.")

    # create and send email request to the destination addresses
    mail = Mail(from_mail, to_mail, subject, content)
    response = mailg.client.mail.send.post(request_body=mail.get())

    return response
   