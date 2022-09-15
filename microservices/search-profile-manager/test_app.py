import json


def test_index(app, client):
    del app
    res = client.get('/')
    assert res.status_code == 200
    expected = 'Hello, World! I am the Search-Profile-Manager!'
    assert expected == res.get_data(as_text=True)