#!/usr/bin/env python3
from flask import Flask, url_for
from flask_restful import Api
from resources.user import *
from resources.product import *
from resources.family import *
from resources.list import *
from resources.homepage import *
from resources.favicon import *
from flask_jwt_extended import JWTManager
from flasgger import Swagger

app = Flask(__name__)
api = Api(app)

app.config["JWT_SECRET_KEY"] = "ijpdhnmUb2iArs9x9pLn93EsZgmshLYrbzGpv$f4xQgP@eEWbH$h$N9AfwH3DN@5yX@nBm^3MBGEu$MZ#3Ur4ehh&*66mjJi6CxhXM2Ws6%G*AmGRFD%NEr7BezD2qrg"
app.config['SWAGGER'] = {
    'title': 'Koopy',
    'specs_route': '/api/docs/',
    'termsOfService': '',
    'description': 'API for Koopy application'
}

swagger_config = Swagger.DEFAULT_CONFIG
swagger_config['swagger_ui_bundle_js'] = '//unpkg.com/swagger-ui-dist@3/swagger-ui-bundle.js'
swagger_config['swagger_ui_standalone_preset_js'] = '//unpkg.com/swagger-ui-dist@3/swagger-ui-standalone-preset.js'
swagger_config['jquery_js'] = '//unpkg.com/jquery@2.2.4/dist/jquery.min.js'
swagger_config['swagger_ui_css'] = '//unpkg.com/swagger-ui-dist@3/swagger-ui.css'
swag = Swagger(app, config=swagger_config)

jwt = JWTManager(app)

# FIRST PAGE
api.add_resource(Homepage, '/api/')
api.add_resource(Favicon, '/api/favicon')

#  USER API
api.add_resource(UserInfo, '/api/user/<string:user_id>')
api.add_resource(User, '/api/user')

#  PRODUCT API
api.add_resource(Product, '/api/product')

# FAMILY API
api.add_resource(Family, '/api/family')

# LIST API
api.add_resource(List, '/api/list')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
