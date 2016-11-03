from random import choice
from string import ascii_letters

from flask import (
    Flask, jsonify, render_template, request, make_response)


words = [''.join(choice(ascii_letters) for i in range(10))
         for i in range(100000)]

app = Flask(__name__)


@app.route('/')
def home():
    return render_template('index.html')


@app.route('/search')
def search():
    term = request.args.get('term', '').lower().strip()
    results = [word for word in words if term in word.lower()]

    response = make_response(jsonify({
        'results': results,
        'total': len(results)
    }))
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response


if __name__ == '__main__':
    app.run(debug=True)
