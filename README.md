# Tenjin Cordova Plugin

This plugin provides APIs to integrate [Tenjin](https://tenjin.io) into your Cordova application.

## Installation

Use the cordova command-line interface to install the Tenjin plugin into your Cordova project.

    cordova plugin add cordova-plugin-tenjin

## Supported Platforms

 * iOS
 * Android

## Demo App

See [cordova-demo](https://github.com/tenjin/cordova-demo) for a test application that uses this plugin.

## Callbacks

Functions from version one of the plugin use the standard Cordova success and failure callbacks, but you can probably ignore them. The Tenjin APIs are designed to work (and fail) silently so telemetry doesn't break your app if things go bad. 

Functions `iosTransaction`, `androidTransaction`, `transaction`, `sendEvent`, and `sendEventAndValue` always call the success callbacks. The failure callbacks are never called. The Tenjin SDK will log info the the console when there is a problem or it can't send data. For iOS, view the logs in Xcode. For Android, use Android studio, or tail the log with `adb logcat`. During development, add a [test device in Tenjin](https://www.tenjin.io/dashboard/debug_app_users) and use the [Tenjin Diagnostics Page](https://www.tenjin.io/dashboard/sdk_diagnostics) to ensure that your code is sending data.

## Changes for Version Two

Version two of the plugin adds new functions for GDPR compliance. These changes require you, as the application developer, to initialize the Tenjin in your app when the app starts or resumes. (See [connecting](#connecting) for more details.) The new APIs such as `init`, `connect`, `optIn`, `optOut`, `optInParams`, `optOutParams` return Promises instead of callbacks. Note that the new Tenjin APIs are also designed to work (and fail) silently so telemetry doesn't break your app if things go bad. Since multiple APIs calls are required initialize and connect, the newer async await style of programming is recommended. 

## Features

* [Connecting](#connecting)
* [GDPR](#gdpr)
* [Deep Link Handler](#register-deep-link-handler)
* [Purchase Event Integration](#purchase-event-integration)
* [Custom Events](#custom-events)

## API

* [tenjin.init](#init)
* [tenjin.connect](#connect)
* [tenjin.connectWithDeferredDeeplink](#connect-with-deferred-deeplink)
* [tenjin.optIn](#opt-in)
* [tenjin.optOut](#opt-out)
* [tenjin.optInParams](#opt-in-params)
* [tenjin.optOutParams](#opt-out-params)
* [tenjin.registerDeepLinkHandler](#register-deep-link-handler)
* [tenjin.iosTransaction](#ios-transaction)
* [tenjin.androidTransaction](#android-transaction)
* [tenjin.transaction](#manual-tracking)
* [tenjin.sendEvent](#send-event)
* [tenjin.sendEventAndValue](#send-event-and-value)

### Connecting

#### Device Ready

For iOS and Android, Tenjin must be initialized when Cordova's `deviceready` event fires. Register a function than handle `deviceready` events.

    document.addEventListener('deviceready', onDeviceReady, false);

Initialize Tenjin with your API key and then call connect. Get your API_KEY from your [Tenjin Organization tab](https://www.tenjin.io/dashboard/organizations).

These plugin API calls are asynchronous and return Promises. We recommened using async await for these calls.

    async function onDeviceReady(event) {
        try {
            await tenjin.init(apiKey);
            await tenjin.connect();
        } catch (error) {
            console.log(error);
        }
    }

#### On Resume

On Android, you also need to initialize Tenjin in onResume. Register an function than handle `resume` events.

    document.addEventListener('resume', onResume, false);

Initialize Tenjin with your API key and then call connect.

    async function onResume(event) {

        if (cordova.platformId === 'ios') { return; }

        try {
            await tenjin.init(apiKey);
            await tenjin.connect();
        } catch (error) {
            console.log(error);
        }
    }

#### Init

Initialize Tenjin with the API key. Init should be called when the Cordova device ready event fires. Additionally call init when resume fires on Android. See [connecting](#connecting) for more details.

    tenjin.init(apiKey)

    @param {string} apiKey
    @returns {Promise}

example:

    await tenjin.init(apiKey);

#### Connect

Connect to Tenjin. Call connect after init. See [connecting](#connecting) for more details.

    tenjin.connect();

    @returns {Promise}

Example:

    await tenjin.init(apiKey);
    await tenjin.connect();


#### Connect with Deferred Deeplink

If you have a deep link that's generated from a third party service then pass it to tenjin to handle the attribution of deep links holistically

    tenjin.connectWithDeferredDeeplink(url);

    @param {string} url
    @returns {Promise}

Example:

    let url = // string url from 3rd party
    
    await tenjin.init(apiKey);
    await tenjin.connectWithDeferredDeeplink(url);

### GDPR

As part of GDPR compliance, with Tenjin's SDK you can opt-in, opt-out devices/users, or select which specific device-related params to opt-in or opt-out. If optOut is called, no API requests are sent to Tenjin and we will not process any events.

#### Opt In

Opt-in to tracking.
  
    tenjin.optIn();

    @returns {Promise}

#### Opt Out

Opt-out of tracking. No events will be sent to Tenjin.
  
    tenjin.optOut();

    @returns {Promise}

#### Opt In / Opt Out

Call `tenjin.optIn` or `tenjin.optOut` after `tenjin.init` and before `tenjin.connect`. Your app needs to determine if the user opted in or opted out. These API calls are asynchronus but must be called in order, using async await or by chaining promises.

    let optIn = checkOptInValue();

    await tenjin.init(apiKey);
    if (optIn) {
        await tenjin.optIn();
    } else {
        await tenjin.optOut();
    }
    await tenjin.connect();

#### Opt In Params

If you want to only get specific device-related parameters, use OptInParams(). In example below, we will only these device-related parameters: ip_address, advertising_id, developer_device_id, limit_ad_tracking, referrer, and iad.
    
    tenjin.optInParams(params);

    @param {Array<string>} params
    @returns {Promise}

Example:

    let params = ['ip_address', 'advertising_id', 'developer_device_id', 'limit_ad_tracking', 'referrer', 'iad'];

    await tenjin.init(apiKey);
    await tenjin.optInParams(params);
    await tenjin.connect();

See the [Unity SDK](https://github.com/tenjin/tenjin-unity-sdk#device-related-parameters) for a list of available paramters.

#### Opt Out Params

If you want to send ALL parameters except specfic device-related parameters, use OptOutParams(). In example below, we will send ALL device-related parameters except: locale, timezone, and build_id parameters.

    tenjin.optOutParams(params);

    @param {Array<string>} params
    @returns {Promise}

Example:

    let params = ['country', 'timezone', 'language'];

    await tenjin.init(apiKey);
    await tenjin.optOutParams(params);
    await tenjin.connect();

See the [Unity SDK](https://github.com/tenjin/tenjin-unity-sdk#device-related-parameters) for a list of available paramters. 


### Register Deep Link Handler

Tenjin supports the ability to direct users to a specific part of your app after a new attributed install via Tenjin's campaign tracking URLs. You can utilize the registerDeepLinkHandler handler to access the deferred deeplink through params['deferred_deeplink_url'] that is passed on the Tenjin campaign tracking URLs. To test you can follow the instructions found here.

    registerDeepLinkHandler(callback);

    @param {function} callback
 
Example:

    await tenjin.init(apiKey);
    await tenjin.connect();
    
    // params is a JSON object with key and values
    tenjin.registerDeepLinkHandler(params -> {
        if (params.clicked_tenjin_link && params.is_first_session) {
            //use the params to retrieve deferred_deeplink_url through params."deferred_deeplink_url"
            //use the deferred_deeplink_url to direct the user to a specific part of your app
        } else {
            // ...
        }
    });

Example 2:

You can also use the params for handling post-install logic. For example, if you have a paid app, you can register your paid app install in the following way:

    await tenjin.init(apiKey);
    await tenjin.connect();
    
    // params is
    tenjin.registerDeepLinkHandler(params -> {
        if (params.is_first_session) {
            // send paid app price and revenue to Tenjin
        } else {
            // ...
        }
    });

### Purchase Event Integration

Tenjin can track and verify transcations with platform specific functions for iOS and Android.

#### iOS Transaction

After a purchase you can pass Tenjin the transaction and receipt data.

    tenjin.iosTransaction(productId, currencyCode, quantity, unitPrice, transactionId, base64Receipt, success, failure);

    @param {string} productId Name or ID of the product that you're selling
    @param {string} currencyCode Currency code of the price, e.g. USD
    @param {integer} quantity Number of transactions for this event
    @param {double} unitPrice Unit price of a single transaction
    @param {string} transactionId Transaction ID
    @param {string} base64Receipt Receipt data as a base64 encoded string
    @param {function} success Optional success callback
    @param {function} failure Optional failure callback
   
Example:

    tenjin.iosTransaction('sku_123', 'USD', 1, 0.99, transactionId, base64Receipt);

#### Android Transaction

Tenjin can validate transaction receipts for you. Visit your app on the dashboard (Apps -> Your Android App -> Edit) and enter your Public Key that can be found in your Google Play dashboard under "Services & APIs".

![Dashboard](https://s3.amazonaws.com/tenjin-instructions/android_pk.png "dashboard")

After entering your Public Key into the Tenjin dashboard for your app, you can use the Tenjin SDK method below:

    tenjin.androidTransaction(productId, currencyCode, quantity, unitPrice, purchaseData, dataSignature, success, failure);

    @param {string} productId Name or ID of the product that you're selling
    @param {string} currencyCode Currency code of the price, e.g. USD
    @param {integer} quantity Number of transactions for this event
    @param {double} unitPrice Unit price of a single transaction
    @param {string} purchaseData JSON purchase data as a String
    @param {string} dataSignature encoded signature
    @param {function} success Optional success callback
    @param {function} failure Optional failure callback

For Android, purchaseData and dataSignature should be the equivalent to the following intent data. See the Android [In-app Billing docs](https://developer.android.com/google/play/billing/billing_integrate.html#Purchase) and [Tenjin Android SDK docs](https://github.com/tenjin/tenjin-android-sdk#1-validate-receipts) for more details.

    String purchaseData = data.getStringExtra("INAPP_PURCHASE_DATA");
    String dataSignature = data.getStringExtra("INAPP_DATA_SIGNATURE");

Example

    tenjin.androidTransaction('sku_123', 'USD', 1, 0.99, purchaseData, dataSignature);

#### Manual Tracking

You have the option to manually track transactions.

To send transaction events, you must provide the productId, currencyCode, quantity, and unitPrice of the user's transaction.

    tenjin.transaction(productId, currencyCode, quantity, unitPrice, success, failure);

    @param {string} productId Name or ID of the product that you're selling
    @param {string} currencyCode Currency code of the price, e.g. USD
    @param {integer} quantity Number of transactions for this event
    @param {double} unitPrice Unit price of a single transaction
    @param {function} success Optional success callback
    @param {function} failure Optional failure callback

    tenjin.transaction('sku_123', 'USD', 1, 0.99);

### Custom Events

#### Send Event

You can also use the Tenjin SDK to pass a custom events.

    tenjin.sendEvent(eventName, success, failure);

    @param {string} eventName Name of custom event
    @param {function} success Optional success callback
    @param {function} failure Optional failure callback


The custom interactions with your app can be tied to level cost from each acquisition source that you use through Tenjin's service.

    tenjin.sendEvent('swipeRight');

#### Send Event and Value

You can also use the Tenjin SDK to pass a custom event with an integer value.

    tenjin.sendEventAndValue(eventName, eventValue, success, failure);

    @param {string} eventName Name of custom event
    @param {integer} integerValue Value to track with this metric 
    @param {function} success Optional success callback
    @param {function} failure Optional failure callback

Passing an integer value with an event's name allows marketers to sum up and track averages of the values passed for that metric in the Tenjin dashboard. If you plan to use DataVault, these values can be used to derive additional metrics that can be useful.

    tenjin.sendEventAndValue('item', 100);

Note: Don't send any events before `deviceready` fires.    

## Links

* [Tenjin](https://tenjin.io)
* [Tenjin Cordova Plugin](https://github.com/tenjin/cordova-sdk)
* [Tenjin Cordova Demo](https://github.com/tenjin/cordova-demo)
* [Tenjin SDK for iOS](https://github.com/tenjin/tenjin-ios-sdk)
* [Tenjin SDK for Android](https://github.com/tenjin/tenjin-android-sdk)
