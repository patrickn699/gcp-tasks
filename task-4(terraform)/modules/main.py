from google.cloud import storage
from PIL import Image


def main(event, context):

    """Triggers when a file is created in GCS.
    Args:
        event: Event payload.
        context: Metadata for the event.
    """
    # Get the file name from the trigger event.
    file_name = event['name']

    if file_name[-3] == 'jpg' or file_name[-3] == 'png':

        # Get the files from GCS and setup upload bucket name.
        gcs_file = storage.Client().bucket(event['bucket']).get_blob(file_name)
        upload_buk = storage.Client().bucket('resize-bucket')

        # Get the file content.
        file_content = gcs_file.download_as_string()

        # Open the file content as a PIL image.
        image = Image.open(file_content)

        # Resize the image.
        image = image.resize((100, 100))

        # Save the image to the orginal file
        image.save(file_content)

        # convert the image into blob and uplod the file to the destination bucket.
        upload_buk.blob(file_name+"_resized")
        upload_buk.upload_from_string(file_content)
        
        return {"message":" file uploaded successfully"}

    else:

        return {"message":" incorrect file type"}