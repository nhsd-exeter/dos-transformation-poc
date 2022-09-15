from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello():
    return 'Hello, World! I am the Directory-Data-Manager'

    #change me

if __name__ == '__main__':
    app.run(debug=True)