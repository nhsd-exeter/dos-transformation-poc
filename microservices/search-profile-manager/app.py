from chalice import Chalice
#deploy
app = Chalice(app_name="helloworld")

@app.route("/")
def index():
    return {"hello": "world"}

@app.route('/{id}', methods=['GET'])
def get_search_profile(id):
    return {'search-profile': id}

