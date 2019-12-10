// Cordova Tenjin Plugin
// (c) 2017-2018 Tenjin

package io.tenjin.cordova;

import android.app.Activity;

import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.tenjin.android.Callback;
import com.tenjin.android.TenjinSDK;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.LOG;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class TenjinPlugin extends CordovaPlugin {

    // actions
    private static final String INIT = "init";
    private static final String OPT_IN = "optIn";
    private static final String OPT_IN_PARAMS = "optInParams";
    private static final String OPT_OUT = "outOut";
    private static final String OPT_OUT_PARAMS = "optOutParams";
    private static final String CONNECT = "connect";
    private static final String CONNECT_WITH_DEFERRED_DEEPLINK = "connectWithDeferredDeeplink";
    private static final String REGISTER_DEEP_LINK_HANLDER = "registerDeepLinkHandler";

    private static final String TRANSACTION = "transaction";
    private static final String ANDROID_TRANSACTION = "androidTransaction";
    private static final String SEND_EVENT = "sendEvent";
    private static final String SEND_EVENT_AND_VALUE = "sendEventAndValue";
    
    private static final String TAG = "TenjinCordovaPlugin";

    private TenjinSDK tenjinSDK;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        logAdvertisingId();
    }

    @Override
    public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext) throws JSONException {
        LOG.d(TAG, "action = " + action);

        boolean validAction = true;

        if (action.equals(INIT)) {
            String apiKey = args.getString(0);
            tenjinSDK = TenjinSDK.getInstance(cordova.getActivity(), apiKey);
            callbackContext.success();
            return true;
        }

        // The Tenjin Cordova APIs are designed to work (and fail) silently so taht problems with telemetry
        // don't break applications. If the user didn't call INIT, we'll log a message and return success
        if (tenjinSDK == null) {
            // Log the error
            LOG.w(TAG, "TenjinSDK is null. The app must call tenjin.init(apiKey)");
            // Return success, so the app doesn't break
            callbackContext.success();
            return true; 
        }

        if (action.equals(OPT_IN)) {

            tenjinSDK.optIn();
            callbackContext.success();

        } else if (action.equals(OPT_IN_PARAMS)) {

            JSONArray array = args.getJSONArray(0);

            List<String> params = new ArrayList<String>();
            for (int i = 0; i < array.length(); i++){
                params.add(array.getString(i));
            }
            tenjinSDK.optInParams(params.toArray(new String[0]));
            callbackContext.success();

        } else if (action.equals(OPT_OUT)) {

            tenjinSDK.optOut();
            callbackContext.success();

        } else if (action.equals(OPT_OUT_PARAMS)) {

            JSONArray array = args.getJSONArray(0);

            List<String> params = new ArrayList<String>();
            for (int i = 0; i < array.length(); i++){
                params.add(array.getString(i));
            }
            tenjinSDK.optOutParams(params.toArray(new String[0]));
            callbackContext.success();

        } else if (action.equals(CONNECT)) {

            tenjinSDK.connect();
            callbackContext.success();

        } else if (action.equals(CONNECT_WITH_DEFERRED_DEEPLINK)) {

            String deferredDeeplinkUri = args.getString(0);
            tenjinSDK.connect(deferredDeeplinkUri, null);
            callbackContext.success();

        } else if (action.equals(REGISTER_DEEP_LINK_HANLDER)) {

            final CallbackContext cordovaCallback = callbackContext;

            tenjinSDK.getDeeplink(new Callback() {
                @Override
                public void onSuccess(boolean clickedTenjinLink, boolean isFirstSession, Map<String, String> data) {

                    JSONObject object = new JSONObject(data);
                    cordovaCallback.success(object);

                }
            });

        } else if (action.equals(TRANSACTION)) {

            String productId = args.getString(0);
            String currencyCode = args.getString(1);
            int quantity = args.getInt(2);
            double unitPrice = args.getDouble(3);

            tenjinSDK.transaction(productId, currencyCode, quantity, unitPrice);

            callbackContext.success();

        } else if (action.equals(ANDROID_TRANSACTION)) {

            String productId = args.getString(0);
            String currencyCode = args.getString(1);
            int quantity = args.getInt(2);
            double unitPrice = args.getDouble(3);
            String purchaseData = args.getString(4);
            String dataSignature = args.getString(5);

            tenjinSDK.transaction(productId, currencyCode, quantity, unitPrice, purchaseData, dataSignature);

            callbackContext.success();

        } else if (action.equals(SEND_EVENT)) {

            String eventName = args.getString(0);
            LOG.d(TAG, "eventName " + eventName);

            tenjinSDK.eventWithName(eventName);

            callbackContext.success();

        } else if (action.equals(SEND_EVENT_AND_VALUE)) {

            String eventName = args.getString(0);
            String eventValue = args.getString(1);

            LOG.d(TAG, "eventName " + eventName);
            LOG.d(TAG, "eventValue " + eventValue);

            tenjinSDK.eventWithNameAndValue(eventName, eventValue);

            callbackContext.success();

        } else {

            validAction = false;

        }

        return validAction;
    }

    private void logAdvertisingId() {
        try {
            Activity activity = cordova.getActivity();
            if (activity != null) {
                AdvertisingIdClient.Info idInfo = AdvertisingIdClient.getAdvertisingIdInfo(activity);
                if (idInfo != null) {
                    LOG.d(TAG, "Advertising ID: " + idInfo.getId());
                    LOG.d(TAG, "AdvertisingTrackingEnabled: " + (idInfo.isLimitAdTrackingEnabled() ? "NO" : "YES"));           
                }     
            }
        } catch (IOException e) {
            LOG.e(TAG, "Error loading Advertising ID", e);
            e.printStackTrace();
        } catch (GooglePlayServicesNotAvailableException e) {
            LOG.e(TAG, "Error loading Advertising ID", e);
        } catch (GooglePlayServicesRepairableException e) {
            LOG.e(TAG, "Error loading Advertising ID", e);
        }

    }

}