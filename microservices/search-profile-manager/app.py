from chalice import Chalice
#deploy
app = Chalice(app_name="helloworld")

@app.route("/")
def index():
    return {"hello": "world"}
