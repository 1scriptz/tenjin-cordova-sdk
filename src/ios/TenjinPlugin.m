// Tenjin Cordova Plugin
// (c) 2017-2018 Tenjin

#import "TenjinPlugin.h"
#import <Cordova/CDVPlugin.h>
#import "TenjinSDK.h"

#import <AdSupport/ASIdentifierManager.h>

@implementation TenjinPlugin

- (void)pluginInitialize {

    NSLog(@"Cordova Tenjin Plugin");
    NSLog(@"(c)2017-2018 Tenjin");

    [super pluginInitialize];
    NSLog(@"Advertising ID: %@", [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]);
    NSLog(@"AdvertisingTrackingEnabled: %@", [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] ? @"YES" : @"NO");
    
}

- (void)init:(CDVInvokedUrlCommand*)command
{
    NSString *apiKey = [command.arguments objectAtIndex:0];
    [TenjinSDK init:apiKey];
    
    // TODO will I get any indication if the API key is bad?
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)optIn:(CDVInvokedUrlCommand*)command
{
    [TenjinSDK optIn];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)optInParams:(CDVInvokedUrlCommand*)command
{
    NSArray *params = [command.arguments objectAtIndex:0];
    [TenjinSDK optInParams:params];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)optOut:(CDVInvokedUrlCommand*)command{
    [TenjinSDK optOut];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)optOutParams:(CDVInvokedUrlCommand*)command
{
    NSArray *params = [command.arguments objectAtIndex:0];
    [TenjinSDK optOutParams:params];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)connect:(CDVInvokedUrlCommand*)command
{
    [TenjinSDK connect];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)connectWithDeferredDeeplink:(CDVInvokedUrlCommand*)command
{
    NSURL *deepLinkUrl = [NSURL URLWithString:[command.arguments objectAtIndex:0]];
    [TenjinSDK connectWithDeferredDeeplink:deepLinkUrl];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)registerDeepLinkHandler:(CDVInvokedUrlCommand*)command
{
    
    [[TenjinSDK sharedInstance] registerDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        CDVPluginResult* pluginResult;
        
        if (error) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
        }
        
        [pluginResult setKeepCallbackAsBool:TRUE];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}

- (void)transaction:(CDVInvokedUrlCommand*)command
{
    
    NSString* productName = [command.arguments objectAtIndex:0];
    NSString* currencyCode = [command.arguments objectAtIndex:1];
    NSInteger quantity = [[command.arguments objectAtIndex:2] integerValue];
    NSDecimalNumber *price = [command.arguments objectAtIndex:3];

    // never fails, need to check the console output for details
    [TenjinSDK  transactionWithProductName: productName
        andCurrencyCode: currencyCode
        andQuantity: quantity
        andUnitPrice: price];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)iosTransaction:(CDVInvokedUrlCommand*)command
{
    NSString* productName = [command.arguments objectAtIndex:0];
    NSString* currencyCode = [command.arguments objectAtIndex:1];
    NSInteger quantity = [[command.arguments objectAtIndex:2] integerValue];
    NSDecimalNumber *price = [command.arguments objectAtIndex:3];
    NSString* transactionId = [command.arguments objectAtIndex:4];
    NSString* base64Receipt = [command.arguments objectAtIndex:5];
    
    NSLog(@"iosTransaction");
    NSLog(@"productName %@", productName);
    NSLog(@"currencyCode %@", currencyCode);
    NSLog(@"quantity %ld", (long)quantity);
    NSLog(@"price %@", price);
    NSLog(@"transactionId %@", transactionId);
    NSLog(@"base64Receipt %@", base64Receipt);

    [TenjinSDK  transactionWithProductName: productName
                       andCurrencyCode: currencyCode
                           andQuantity: quantity
                          andUnitPrice: price
                      andTransactionId:transactionId
                      andBase64Receipt:base64Receipt];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)sendEvent:(CDVInvokedUrlCommand*)command
{
    NSString* eventName = [command.arguments objectAtIndex:0];
    [TenjinSDK sendEventWithName:eventName];
        
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)sendEventAndValue:(CDVInvokedUrlCommand*)command
{
    NSString* eventName = [command.arguments objectAtIndex:0];
    // eventValue should be an integer, but sendEventWithName:andEventValue
    // takes a NSString and coerces it into an integer
    // if there's a problem, details are printed to the log file
    NSString *eventValueAsString = [NSString stringWithFormat:@"%@", [command.arguments objectAtIndex:1]];

    [TenjinSDK sendEventWithName:eventName andEventValue:eventValueAsString];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
