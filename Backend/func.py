import boto3

dynamodb = boto3.resource('dynamodb')


def lambda_handler(event, context):
        table = dynamodb.Table('views_count')
        # Retrieve current views
        response = table.get_item(Key={'id':'1'})
        item = response.get('Item', {})
        views = item.get('views', 0)  # Default to 0 if 'views' attribute is not found

        # Increment views
        views += 1

        # Update DynamoDB item
        response = table.put_item(
            Item={
                'id': '1',
                'views': views
            }
        )

        return views