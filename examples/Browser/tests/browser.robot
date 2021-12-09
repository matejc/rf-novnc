*** Settings ***
Library   Browser

*** Variables ***
${SUT URL}      https://marketsquare.github.io/robotframework-browser/Browser.html
${BROWSER}      firefox

*** Test Cases ***
Example Test
    New Browser     ${BROWSER}  headless=${false}
    New Page        ${SUT URL}
    Get Title       ==    Browser
