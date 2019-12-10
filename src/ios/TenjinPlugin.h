// Tenjin Cordova Plugin
// (c) 2017-2018 Tenjin

#import <Cordova/CDVPlugin.h>

@interface TenjinPlugin : CDVPlugin

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)optIn:(CDVInvokedUrlCommand*)command;
- (void)optInParams:(CDVInvokedUrlCommand*)command;
- (void)optOut:(CDVInvokedUrlCommand*)command;
- (void)optOutParams:(CDVInvokedUrlCommand*)command;
- (void)connect:(CDVInvokedUrlCommand*)command;
- (void)connectWithDeferredDeeplink:(CDVInvokedUrlCommand*)command;
- (void)registerDeepLinkHandler:(CDVInvokedUrlCommand*)command;
- (void)transaction:(CDVInvokedUrlCommand*)command;
- (void)iosTransaction:(CDVInvokedUrlCommand*)command;
- (void)sendEvent:(CDVInvokedUrlCommand*)command;
- (void)sendEventAndValue:(CDVInvokedUrlCommand*)command;

@end
