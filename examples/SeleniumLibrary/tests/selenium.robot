*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${SUT URL}      https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html
${BROWSER}      firefox

*** Test Cases ***
Example Test
    Open Browser        ${SUT URL}    ${BROWSER}
    Title Should Be     SeleniumLibrary
    [Teardown]    Close Browser
