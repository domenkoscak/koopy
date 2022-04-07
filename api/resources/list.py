from flask import request
from flask_restful import Resource
from datetime import datetime
from database.tables import List
from playhouse.shortcuts import model_to_dict
from json import dumps, loads
from .functions import check_for_data
from flask_jwt_extended import jwt_required

class ListInfo(Resource):
    @jwt_required()
    def get(__self__, list_id):
        list = List.select().where(List.id == list_id)
        if list.exists():
            return loads(dumps(model_to_dict(list.get()), sort_keys=True, default=str))
        else:
            return {'message': 'List with that id does not exist.'}, 400

class NewList(Resource):
    @jwt_required()
    def post(__self__):
        data = check_for_data()

        list = List.select().where(List.name == data["name"] and List.id_f == data["family_id"])

        if list.exists():
            return {"message": "List with that name in family already exists."}, 400
        
        list = List.create(name=data["name"], id_f=data["family_id"], admin=data["admin"], created=datetime.now())

        return model_to_dict(list), 201

class DeleteList(Resource):
    @jwt_required()
    def post(__self__):
        data = check_for_data()

        list = List.select().where(List.id == data['id'])

        if not list.exist():
            return {"message": "List does not exist"}, 400

        products = List.get().products

        for product in products:
            product.delete().execute()

        list.delete().execute()

        return {"message": "List successfully deleted"}, 204