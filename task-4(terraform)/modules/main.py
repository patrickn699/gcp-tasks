from google.cloud import storage
from PIL import Image


def main(event, context):

    """Triggers when a file is created in GCS.
    Args:
        event (dict): Event payload.
        context (google.cloud.functions.Context): Metadata for the event.
    """
    # Get the file name from the event.
    file_name = event['name']
    # Get the file from GCS.
    gcs_file = storage.Client().bucket(event['bucket']).get_blob(file_name)
    upload_buk = storage.Client().bucket('upload-bucket')
    # Get the file content.
    file_content = gcs_file.download_as_string()
    # Create a PIL image.
    image = Image.open(file_content)
    # Resize the image.
    image = image.resize((300, 300))
    # Save the image.
    image.save(file_content)
    # Upload the image to GCS.
    upload_buk.upload_from_string(file_content)
    # Send a message to Pub/Sub.
    #publish_message(file_name)
    return {"message":" file uploaded successfully"}