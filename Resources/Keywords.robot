*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  JsonValidator

*** Keywords ***
Get Status and Assert 200
    ${status_get}=  GET On Session    testing_session   /status.get?   ${urlending}
    Should Be Equal As Numbers  ${status_get.status_code}      ${OK}
    [Return]   ${status_get}

Make Session
    Create Session   testing_session    ${main_url}
    Session Exists   testing_session

Test Setup
    # Создается сессия к https://api.vk.com/method/, здесь пусто, но задача принять нужный алиас
    # Более оптимального решения не нашел :(
    Make Session

Get Albums and Assert 200
    ${photos_get}=  GET On Session    testing_session   /photos.getAlbums?${owner_id}&${urlending}
    Should Be Equal As Numbers   ${photos_get.status_code}   ${OK}
    [Return]   ${photos_get}

Suite Teardown Status
    ${resp_set_back}=  POST On Session   testing_session   /status.set?text\=${status_empty}&${urlending}
    Should Be Equal As Numbers   ${resp_set_back.status_code}    ${OK}
    Run Keyword If All Tests Passed  log  Тестирование получения/создания/удаления статуса на уровне API завершено успешно
    Delete All Sessions

Suite Teardown Albums
    Run Keyword If All Tests Passed   log  Тестирование получения/создания/удаления статуса на уровне API завершено успешно
    Delete All Sessions
    Sleep  10s  #ВК жалуется на большое количество RPS => тесты падают

