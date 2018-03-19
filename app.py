from flask import Flask, request, jsonify, make_response
import polyglot.tag

app = Flask(__name__)

from datetime import timedelta
from flask import make_response, request, current_app
from functools import update_wrapper

supportedLanguages = {"en", "de"}

def crossdomain(origin=None, methods=None, headers=None,
                max_age=21600, attach_to_all=True,
                automatic_options=True):
    """See: http://flask.pocoo.org/snippets/56/"""
    if methods is not None:
        methods = ', '.join(sorted(x.upper() for x in methods))
    if headers is not None and not isinstance(headers, basestring):
        headers = ', '.join(x.upper() for x in headers)
    if not isinstance(origin, basestring):
        origin = ', '.join(origin)
    if isinstance(max_age, timedelta):
        max_age = max_age.total_seconds()

    def get_methods():
        if methods is not None:
            return methods

        options_resp = current_app.make_default_options_response()
        return options_resp.headers['allow']

    def decorator(f):
        def wrapped_function(*args, **kwargs):
            if automatic_options and request.method == 'OPTIONS':
                resp = current_app.make_default_options_response()
            else:
                resp = make_response(f(*args, **kwargs))
            if not attach_to_all and request.method != 'OPTIONS':
                return resp

            h = resp.headers

            h['Access-Control-Allow-Origin'] = origin
            h['Access-Control-Allow-Methods'] = get_methods()
            h['Access-Control-Max-Age'] = str(max_age)
            if headers is not None:
                h['Access-Control-Allow-Headers'] = headers
            return resp

        f.provide_automatic_options = False
        return update_wrapper(wrapped_function, f)
    return decorator


@app.route('/', methods=['GET', 'POST', 'OPTIONS'])
@crossdomain(origin='*', headers=['Content-Type'])
def analyze():
    
    if request.method == 'OPTIONS':
        resp = make_response('')
        resp.headers['Access-Control-Allow-Origin'] = '*'
        resp.headers['Access-Control-Request-Method'] = 'POST'
        return resp
    
    if request.method == 'POST':

        try:
            docdata = request.get_json();
            lang = docdata["lang"]
            if lang not in supportedLanguages:
                print("Unknown language: " + lang + ". Switching to en as default.")
                lang = "en"
            chunker = polyglot.tag.NEChunker(lang = lang)

            result = []
            for sentence in docdata["sentences"]:
                result.append(chunker.annotate(sentence))
        except:
            result = "Error: invalid request format."

        return jsonify({'result': result})

if __name__ == "__main__":
    app.run()
