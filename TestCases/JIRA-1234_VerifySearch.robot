*** Settings ***
Resource    ../PageObjects/Homepage.robot
Resource    ../PageObjects/ListingPage.robot
Resource    ../Libraries/Utilities.robot
Resource    ../PageObjects/Itempage.robot

*** Variables ***
${page_title}       Electronics, Cars, Fashion, Collectibles, Coupons and More | eBay
${cd_title}         Queen - Made In Heaven - CD, VG
${regex_pattern}    [0-9]+
${regex_price}      [0-9]+.[0-9]+
${listedSearchPrice}   #US $11.13  #Local variable - Value to be fetched and stored here

*** Test Cases ***
Navigate to web site and verify title
    open browser    http://www.ebay.com    firefox
    Utilities.Maximise browser
    title should be  ${page_title}

Verify search results
    Homepage.Search for specific item    ${cd_title}
    ${actualValue} =    ListingPage.Get result count
    should match regexp  ${actualValue}    ${regex_pattern}

Store listed item price
    ${aa}=      ListingPage.Get item price
    set global variable      ${listedSearchPrice}   ${aa}

Click on the first search listing
    ListingPage.Click search result

Verify item title
    ${displayedTitle}=   Itempage.Get item title
#    log to console     ${displayedTitle}
    should be equal as strings  ${displayedTitle}  ${cd_title}

Verify item price
    ${displayedPrice}=   Itempage.Get item price   #get text  xpath://*[@id="convbinPrice"]
    should be equal as strings    US ${listedSearchPrice}  ${displayedPrice}

Close the browser
    Utilities.Close browser