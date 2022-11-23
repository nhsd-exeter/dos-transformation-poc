from app import lambda_handler

def test_basic():
    """
    Testing an empty payload event to the Lambda
    """
    event = {}
    context = None

    assert payload['statusCode'] == 200


