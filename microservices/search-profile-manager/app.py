from flask_lambda import FlaskLambda
#deploy
app = FlaskLambda(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'
    
@app.route('/say-my-name')
def hello_world():
    return 'Hello, ' + request.args.get('name')
