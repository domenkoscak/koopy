from flask import request
from flask_restful import Resource
from datetime import datetime
from database.tables import Family, Family_has_User
from playhouse.shortcuts import model_to_dict
from json import dumps, loads
from .functions import check_for_data
from uuid import uuid5, NAMESPACE_URL

class FamilyInfo(Resource):
    def get(__self__, family_id):
        family = Family.select().where(Family.id == family_id)
        if family.exists():
            return loads(dumps(model_to_dict(family.get()), sort_keys=True, default=str))
        else:
            return {'message': 'Family with that id does not exist.'}

class NewFamily(Resource):
    def post(__self__):
        data = check_for_data()

        family = Family.select().where(Family.name == data['name'] and Family.address == data['address'])

        if family.exists():
            return {"message": "Family with that name and address already exists."}

        family = Family.create(name=data['name'], address=data['address'], admin=data['admin'], qrcode=uuid5(NAMESPACE_URL, data['name']+data['address']))
        Family_has_User.create(id_f = family.id, id_u = data['admin'])

        return  loads(dumps(model_to_dict(Family.get(Family.id == family.id)), sort_keys=True, default=str))

class DeleteFamily(Resource):
    def post(__self__):
        data = check_for_data()

        try:
            family = Family.get(Family.id == data['id'])
        except:
            return {"message": "Family does not exist."}, 400

        users = family.members
        
        for user in users:
            user.delete().execute()

        family.delete().execute()

        return {"message": "ok"}

class JoinFamily(Resource):
    def post(__self__):
        data = check_for_data()

        family = Family.select(Family.id).where(Family.qrcode == data["join_key"])

        if not family.exists():
            return {"message": "Family does not exist."}
        
        Family_has_User.create(id_u = data["user"], id_f = family)

        return {"message": "Joined the family."}