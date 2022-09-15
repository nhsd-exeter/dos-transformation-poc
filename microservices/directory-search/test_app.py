import json


def test_index(app, client):
    del app
    res = client.get('/')
    assert res.status_code == 200
    expected = 'Hello, World! I am the Directory-Search Service!'
    assert expected == res.get_data(as_text=True)