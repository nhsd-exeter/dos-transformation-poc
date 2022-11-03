from chalice import Chalice
#deploy
app = Chalice(app_name="helloworld")

@app.route("/searchprofiles/{id}", methods=['GET'])
def index():
    return {"hello": id}

@app.route('/{id}', methods=['GET'])
def get_search_profile(id):
    return {'search-profile': id}

