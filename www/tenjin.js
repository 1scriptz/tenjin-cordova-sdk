// Tenjin Cordova Plugin
// (c) 2017-2018 Tenjin

var exec = require('cordova/exec');

/**
 * Initialize Tenjin with the API key
 *
 * @param {string} apiKey
 * @returns {Promise}
 */
exports.init = function (apiKey) {
  return new Promise(function(resolve, reject) {
    cordova.exec(resolve, reject, 'Tenjin', 'init', [apiKey]);
  });
};

/**
 * Connect to Tenjin
 * 
 * @returns {Promise}
 */
exports.connect = function () {
  return new Promise(function(resolve, reject) {
    cordova.exec(resolve, reject, 'Tenjin', 'connect', []);
  });
};

/**
 * Opt-in to tracking
 * 
 * @returns {Promise}
 */
exports.optIn = function () {
  return new Promise(function(resolve, reject) {
    cordova.exec(resolve, reject, 'Tenjin', 'optIn', []);
  });
};

/**
 * Opt-out of tracking
 * 
 * @returns {Promise}
 */
exports.optOut = function () {
  return new Promise(function(resolve, reject) {
    cordova.exec(resolve, reject, 'Tenjin', 'optOut', []);
  });
};

/**
 * Opt-in specific devices related parameters
 *
 * @param {Array<string>} params
 * @returns {Promise}
 */
exports.optInParams = function (params) {
  return new Promise(function(resolve, reject) {
    cordova.exec(resolve, reject, 'Tenjin', 'optInParams', [params]);
  });
};

/**
 * Opt-in specific devices related parameters
 *
 * @param {Array<string>} params
 * @returns {Promise}
 */
exports.optOutParams = function (params) {
  return new Promise(function(resolve, reject) {
    cordova.exec(resolve, reject, 'Tenjin', 'optOutParams', [params]);
  });
};

/**
 * If you use other services to produce deferred deep links, you can pass Tenjin those deep links
 * to handle the attribution logic with your Tenjin enabled deep links.
 *
 * @param {string} url
 * @returns {Promise}
 */
exports.connectWithDeferredDeeplink = function (url) {
  return new Promise(function(resolve, reject) {
    cordova.exec(resolve, reject, 'Tenjin', 'connectWithDeferredDeeplink', [url]);
  });
};

/**
 * Tenjin supports the ability to direct users to a specific part of your app after a new attributed install
 * via Tenjin's campaign tracking URLs. You can utilize the registerDeepLinkHandler handler to access the deferred
 * deeplink through params[@"deferred_deeplink_url"] that is passed on the Tenjin campaign tracking URLs.
 *
 * The callback will receive a JSON object with keys and values.
 *
 * See https://github.com/tenjin/tenjin-ios-sdk#tenjin-deferred-deeplink-integration-instructions
 * https://help.tenjin.io/t/how-do-i-use-and-test-deferred-deeplinks-with-my-campaigns/547
 *
 * @param {function} callback
 * @param {function} failure
 */
exports.registerDeepLinkHandler = function (callback, failure) {
  cordova.exec(callback, failure, 'Tenjin', 'registerDeepLinkHandler', []);
};

/**
 * Manually track a transaction.
 *
 * @param {string} productId Name or ID of the product that you're selling
 * @param {string} currencyCode Currency code of the price, e.g. USD
 * @param {integer} quantity Number of transactions for this event
 * @param {double} unitPrice Unit price of a single transaction
 * @param {function} success Optional success callback
 * @param {function} failure Optional failure callback
 */
exports.transaction = function (productName, currency, quantity, unitPrice, success, failure) {

  if (typeof quantity !== 'number') {
    console.log('WARNING: expecting "quantity" to be an integer');
  }

  if (typeof unitPrice !== 'number') {
    console.log('WARNING: expecting "unitPrice" to be a floating point number');
  }

  exec(success, failure, 'Tenjin', 'transaction', [String(productName), String(currency), parseInt(quantity), parseFloat(unitPrice)]);
};

/**
 * Track an Android transaction and validate receipt data.
 *
 * @param {string} productId Name or ID of the product that you're selling
 * @param {string} currencyCode Currency code of the price, e.g. USD
 * @param {integer} quantity Number of transactions for this event
 * @param {double} unitPrice Unit price of a single transaction
 * @param {string} purchaseData JSON purchase data as a String
 * @param {string} dataSignature encoded signature
 * @param {function} success Optional success callback
 * @param {function} failure Optional failure callback
 */
exports.androidTransaction = function (productName, currency, quantity, unitPrice, purchaseData, dataSignature, success, failure) {

  if (typeof quantity !== 'number') {
    console.log('WARNING: expecting "quantity" to be an integer');
  }

  if (typeof unitPrice !== 'number') {
    console.log('WARNING: expecting "unitPrice" to be a floating point number');
  }

  exec(success, failure, 'Tenjin', 'androidTransaction',
    [String(productName), String(currency), parseInt(quantity), parseFloat(unitPrice), purchaseData, dataSignature]);
};

/**
 * Track an iOS transaction including the receipt data.
 *
 * @param {string} productId Name or ID of the product that you're selling
 * @param {string} currencyCode Currency code of the price, e.g. USD
 * @param {integer} quantity Number of transactions for this event
 * @param {double} unitPrice Unit price of a single transaction
 * @param {string} transactionId Transaction ID
 * @param {string} base64Receipt Receipt data as a base64 encoded string
 * @param {function} success Optional success callback
 * @param {function} failure Optional failure callback
 */
exports.iosTransaction = function (productName, currency, quantity, unitPrice, transactionId, base64Receipt, success, failure) {

  if (typeof quantity !== 'number') {
    console.log('WARNING: expecting "quantity" to be an integer');
  }

  if (typeof unitPrice !== 'number') {
    console.log('WARNING: expecting "unitPrice" to be a floating point number');
  }

  exec(success, failure, 'Tenjin', 'iosTransaction',
    [String(productName), String(currency), parseInt(quantity), parseFloat(unitPrice), transactionId, base64Receipt]);
};

/**
 * Send a custom event
 *
 * @param {string} eventName Custom event name
 * @param {function} success Optional success callback
 * @param {function} failure Optional failure callback
 */
exports.sendEvent = function (eventName, success, failure) {

  if (eventName === 'undefined') {
    console.log('WARNING: "eventName" is required');
    eventName = 'undefined';
  }

  exec(success, failure, 'Tenjin', 'sendEvent', [String(eventName)]);
};

/**
 * Send a custom event with an integer value
 *
 * @param {string} eventName Custom event name
 * @param {integer} integerValue Value to track with this metric
 * @param {function} success Optional success callback
 * @param {function} failure Optional failure callback
 */
exports.sendEventAndValue = function (eventName, integerValue, success, failure) {

  if (eventName === 'undefined') {
    console.log('WARNING: "eventName" is required');
    eventName = 'undefined';
  }

  if (typeof integerValue !== 'number') {
    console.log('WARNING: expecting "integerValue" to be an integer');
  }

  exec(success, failure, 'Tenjin', 'sendEventAndValue', [String(eventName), integerValue]);
};
