*** Settings ***
Resource  ../Resources/SuiteSetup.robot
Resource  ../Resources/Keywords.robot
Suite Setup  Suite Setup
Suite Teardown  Suite Teardown Status
Test Setup  Test Setup

*** Variables ***
${status_text}   New Shiny Status
${status_empty}

*** Test Cases ***
# По условиям теста задано что статус изначально пуст
Get Status and Check its Content
    ${resp_status_get}=  Get Status and Assert 200
    ${resp_status_body}=   Get Elements    ${resp_status_get.json()}     $.response.text
    Should Be Equal As Strings   ${resp_status_body}    ['']
    [Tags]  Status

Change Status
    ${resp_status_change}=  POST On Session   testing_session   /status.set?text\=${status_text}&${urlending}
    Should Be Equal As Numbers   ${resp_status_change.status_code}    ${OK}
    Dictionary Should Contain Item   ${resp_status_change.json()}  response  1
    [Tags]  Status

Check if Changed
    ${resp_status_get}=  Get Status and Assert 200
    ${if_changed}  Get Elements    ${resp_status_get.json()}      $.response.text
    Should Be Equal As Strings   ${status_text}   ${if_changed}[0]
    [Tags]  Status
