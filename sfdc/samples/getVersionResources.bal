import ballerina/config;
import ballerina/log;
import ballerinax/sfdc;

public function main(){

    // Create Salesforce client configuration by reading from config file.
    sfdc:SalesforceConfiguration sfConfig = {
        baseUrl: config:getAsString("EP_URL"),
        clientConfig: {
            accessToken: config:getAsString("ACCESS_TOKEN"),
            refreshConfig: {
                clientId: config:getAsString("CLIENT_ID"),
                clientSecret: config:getAsString("CLIENT_SECRET"),
                refreshToken: config:getAsString("REFRESH_TOKEN"),
                refreshUrl: config:getAsString("REFRESH_URL")
            }
        }
    };

    // Create Salesforce client.
    sfdc:BaseClient baseClient = new(sfConfig);

    map<string>|sfdc:Error apiVersionResources = baseClient->getResourcesByApiVersion("v48.0");

    if (apiVersionResources is map<string>) {
        log:print("Versions retrieved successfully : " + apiVersionResources.toString());
    } else {
        log:printError(msg = apiVersionResources.message());
    }
}