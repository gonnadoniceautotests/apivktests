import vk_api
import json
import os


def get_token(login, password):
    auth = vk_api.VkApi(login, password)
    auth.auth()
    with open('vk_config.v2.json', 'r') as data_file:
        data = json.load(data_file)
    for app in data[login]['token'].keys():
        for scope in data[login]['token'][app].keys():
            access_token = data[login]['token'][app][scope]['access_token']
    return access_token


def get_id():
    get_number = 0
    with open('vk_config.v2.json', 'r') as data_file:
        data = json.load(data_file)
    for item in data.keys():
        get_number = item
    for app in data[get_number]['token'].keys():
        for scope in data[get_number]['token'][app].keys():
            userid = data[get_number]['token'][app][scope]['user_id']
    return userid


def remove_vk_json():
    os.remove('vk_config.v2.json')