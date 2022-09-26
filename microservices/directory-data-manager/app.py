from flask import Flask

app = Flask(__name__)

#var = 'updated'

@app.route('/')
def hello():
    return 'Hello, World! I am the Directory-Data-Manager'

if __name__ == '__main__':
    app.run(debug=True)