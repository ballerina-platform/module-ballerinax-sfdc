//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

package tests;

import ballerina/io;
import ballerina/net.http;
import salesforce;

string url = "https://wso2--wsbox.cs8.my.salesforce.com";
string accessToken = "00DL0000002ASPS!ASAAQE8Fjy_aMAjn4G28QIZ7Qjm9c4D5PygH_dCS4CGUVo_zalVOzwZwYAcBUnCNwwFnolNjqEXntHEuZyZ3fmVPC8ZsVFoa";
string clientId = "3MVG9MHOv_bskkhSA6dmoQao1M5bAQdCQ1ePbHYQKaoldqFSas7uechL0yHewu1QvISJZi2deUh5FvwMseYoF";
string clientSecret = "1164810542004702763";
string refreshToken = "5Aep86161DM2BuiV6zOy.J2C.tQMhSDLfkeFVGqMEInbvqLfxwoof9fCkXwO4xihKfjTXkhSLyZRpv0yhBCJ69B";
string refreshTokenEndpoint = "https://test.salesforce.com";
string refreshTokenPath = "/services/oauth2/token";

public function main (string[] args) {
    error Error = {};
    json jsonResponse;
    string nextUrl;

    json account = {Name:"ABC Inc", BillingCity:"New York", Global_POD__c:"UK"};
    string accountId = "";

    salesforce:SalesforceConnector salesforceConnector = {};
    salesforceConnector.init(url, accessToken, refreshToken, clientId, clientSecret, refreshTokenEndpoint, refreshTokenPath);

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    io:println("\n------------------------MAIN METHOD: getAvailableApiVersions()----------------------");
    try {
        jsonResponse = salesforceConnector.getAvailableApiVersions();
        io:println("Success!");
        //io:println(jsonResponse);
    } catch (error e) {
        io:println(e);
    }

    io:println("\n------------------------MAIN METHOD: getResourcesByApiVersion()----------------------");
    try {
        jsonResponse = salesforceConnector.getResourcesByApiVersion("v37.0");
        io:println("Success!");
        //io:println(jsonResponse);
    } catch (error e) {
        io:println(e);
    }

    io:println("\n------------------------MAIN METHOD: getOrganizationLimits ()----------------------");
    try {
        jsonResponse = salesforceConnector.getOrganizationLimits();
        io:println("Success!");
        //io:println(jsonResponse);
    } catch (error e) {
        io:println(e);
    }

    io:println("\n------------------------MAIN METHOD: getQueryResult ()----------------------");
    try {
        jsonResponse = salesforceConnector.getQueryResult("SELECT name FROM Account");
        io:println("Success!");
        //io:println(jsonResponse);
        while (jsonResponse.nextRecordsUrl != null) {
            nextUrl = jsonResponse.nextRecordsUrl.toString();
            jsonResponse = salesforceConnector.getNextQueryResult(nextUrl);
            io:println("\n------------------------MAIN METHOD: getNextQueryResult ()----------------------");
            io:println("Successfully received next query results set!");
        }
    } catch (error e) {
        io:println(e);
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // ============================ ACCOUNT SObject: get, create, update, delete ===================== //

    io:println("\n------------------------ACCOUNT SObjecct Information----------------");
    try {
        string response = salesforceConnector.createAccount(account);
        accountId = response;
        io:println("\nAccount created with: " + response);
    } catch (error e) {
        io:println(e);
    }

    try {
        json j1 = salesforceConnector.getAccountById(accountId);
        io:println("\nAccount details received successfully for: " + accountId);
    } catch (error e) {
        io:println(e);
    }

    try {
        boolean response = salesforceConnector.updateAccount(accountId, account);
        if (response) {
            io:println("\nAccount successfully updated! ");
        }
    } catch (error e) {
        io:println(e);
    }

    try {
        boolean response = salesforceConnector.deleteAccount(accountId);
        if (response) {
            io:println("\nAccount successfully deleted! ");
        }
    } catch (error e) {
        io:println(e);
    }

}