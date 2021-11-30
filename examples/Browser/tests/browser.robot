*** Settings ***
Library   Browser

*** Variables ***
${SUT URL}      https://marketsquare.github.io/robotframework-browser/Browser.html
${BROWSER}      firefox

*** Test Cases ***
Example Test
    New Browser     ${BROWSER}
    New Page        ${SUT URL}
    Get Title       ==    Browser
