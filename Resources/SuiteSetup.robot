*** Settings ***
Library  Authtry.py  WITH NAME  Authtry
Library  RequestsLibrary
Library  Collections
Library  JsonValidator

*** Variables ***
${login}   +79817042088
${password}  PasswordForTest
${api_version}  &v=5.131
${main_url}  https://api.vk.com/method/
${method}  users.get?
${ac_string}  access_token=
${setup_url}  ${main_url}${method}access_token=
${OK}   200

*** Keywords ***
Suite Setup
    ${token}=  Authtry.Get Token   ${login}   ${password}
    ${owner_id}=  Authtry.Get Id
    Set Global Variable   ${owner_id}
    ${urlending}=  evaluate  $ac_string+$token+$api_version
    Set Global Variable   ${urlending}
    ${auth_url_assert}=  evaluate   $setup_url+$token+$apiversion
    Create session   connection   url=${auth_url_assert}
    ${getbody}=  GET On Session  connection  url=${auth_url_assert}
    Should Be Equal As Numbers    ${getbody.status_code}    ${OK}
    # Запрос с ошибочным токеном все равно отдаст 200, поэтому ищем error в теле ответа
    dictionary should not contain key  ${getbody.json()}  error
    # Метод users.get без параметров возвращает данные залогиненного пользователя
    ${id_from_resp}=  Get Elements    ${getbody.json()}   $.response[*].id
    Should Be Equal As Numbers   ${owner_id}   ${id_from_resp}[0]
    Authtry.Remove Vk Json
