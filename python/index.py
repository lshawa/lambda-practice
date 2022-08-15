# /**
#  let’s call on the Python application which we will be running on AWS Lambda.
#  *//
def lambda_handler(event, context):
   message = 'Hello {} !'.format(event['key1'])
   return {
       'message' : message
   }
