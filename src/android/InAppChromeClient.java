/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
*/
package org.apache.cordova.inappbrowser;

import org.apache.cordova.CordovaWebView;
import org.apache.cordova.LOG;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PermissionHelper;
import org.json.JSONArray;
import org.json.JSONException;

import android.Manifest;
import android.util.Log;
import android.webkit.JsPromptResult;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import android.webkit.WebStorage;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.GeolocationPermissions.Callback;

import java.util.ArrayList;
import java.util.List;

public class InAppChromeClient extends WebChromeClient {

    private CordovaWebView webView;
    private CordovaPlugin plugin;
    private static String LOG_TAG = "InAppChromeClient";
    public static int PERMISSION_REQUEST_CODE = 11223344;
    private long MAX_QUOTA = 100 * 1024 * 1024;
    private PermissionRequest lastPermissionRequest;

    public InAppChromeClient(CordovaPlugin plugin, CordovaWebView webView) {
        super();
        this.webView = webView;
        this.plugin = plugin;
    }
    /**
     * Handle database quota exceeded notification.
     *
     * @param url
     * @param databaseIdentifier
     * @param currentQuota
     * @param estimatedSize
     * @param totalUsedQuota
     * @param quotaUpdater
     */
    @Override
    public void onExceededDatabaseQuota(String url,
                                        String databaseIdentifier,
                                        long currentQuota,
                                        long estimatedSize,
                                        long totalUsedQuota,
                                        WebStorage.QuotaUpdater quotaUpdater) {
        LOG.d(LOG_TAG, "onExceededDatabaseQuota estimatedSize: %d  currentQuota: %d  totalUsedQuota: %d", estimatedSize, currentQuota, totalUsedQuota);
        quotaUpdater.updateQuota(MAX_QUOTA);
    }

    /**
     * Instructs the client to show a prompt to ask the user to set the Geolocation permission state for the specified origin.
     *
     * @param origin
     * @param callback
     */
    @Override
    public void onGeolocationPermissionsShowPrompt(String origin, Callback callback) {
        super.onGeolocationPermissionsShowPrompt(origin, callback);
        callback.invoke(origin, true, false);
    }

    /**
     * Tell the client to display a prompt dialog to the user.
     * If the client returns true, WebView will assume that the client will
     * handle the prompt dialog and call the appropriate JsPromptResult method.
     *
     * The prompt bridge provided for the InAppBrowser is capable of executing any
     * oustanding callback belonging to the InAppBrowser plugin. Care has been
     * taken that other callbacks cannot be triggered, and that no other code
     * execution is possible.
     *
     * To trigger the bridge, the prompt default value should be of the form:
     *
     * gap-iab://<callbackId>
     *
     * where <callbackId> is the string id of the callback to trigger (something
     * like "InAppBrowser0123456789")
     *
     * If present, the prompt message is expected to be a JSON-encoded value to
     * pass to the callback. A JSON_EXCEPTION is returned if the JSON is invalid.
     *
     * @param view
     * @param url
     * @param message
     * @param defaultValue
     * @param result
     */
    @Override
    public boolean onJsPrompt(WebView view, String url, String message, String defaultValue, JsPromptResult result) {
        // See if the prompt string uses the 'gap-iab' protocol. If so, the remainder should be the id of a callback to execute.
        if (defaultValue != null && defaultValue.startsWith("gap")) {
            if(defaultValue.startsWith("gap-iab://")) {
                PluginResult scriptResult;
                String scriptCallbackId = defaultValue.substring(10);
                if (scriptCallbackId.matches("^InAppBrowser[0-9]{1,10}$")) {
                    if(message == null || message.length() == 0) {
                        scriptResult = new PluginResult(PluginResult.Status.OK, new JSONArray());
                    } else {
                        try {
                            scriptResult = new PluginResult(PluginResult.Status.OK, new JSONArray(message));
                        } catch(JSONException e) {
                            scriptResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.getMessage());
                        }
                    }
                    this.webView.sendPluginResult(scriptResult, scriptCallbackId);
                    result.confirm("");
                    return true;
                }
                else {
                    // Anything else that doesn't look like InAppBrowser0123456789 should end up here
                    LOG.w(LOG_TAG, "InAppBrowser callback called with invalid callbackId : "+ scriptCallbackId);
                    result.cancel();
                    return true;
                }
            }
            else {
                // Anything else with a gap: prefix should get this message
                LOG.w(LOG_TAG, "InAppBrowser does not support Cordova API calls: " + url + " " + defaultValue); 
                result.cancel();
                return true;
            }
        }
        return false;
    }

    @Override
    public void onPermissionRequest(PermissionRequest request) {

        List<String> permissions = new ArrayList<String>();
        for (String r: request.getResources()) {
            switch (r){
                case "android.webkit.resource.AUDIO_CAPTURE": {
                    if(!PermissionHelper.hasPermission(plugin, Manifest.permission.MODIFY_AUDIO_SETTINGS)){
                        permissions.add(Manifest.permission.MODIFY_AUDIO_SETTINGS);
                    }
                    if(!PermissionHelper.hasPermission(plugin, Manifest.permission.RECORD_AUDIO)){
                        permissions.add(Manifest.permission.RECORD_AUDIO);
                    }
                    break;
                }
                case "android.webkit.resource.VIDEO_CAPTURE": {
                    if(!PermissionHelper.hasPermission(plugin, Manifest.permission.CAMERA)){
                        permissions.add(Manifest.permission.CAMERA);
                    }
                    break;
                }
                default: {
                    Log.d(LOG_TAG, "Permission not found for: " + r);
                    break;
                }
            }
        }

        if(permissions.size() > 0) {
            String[] permissionArray = new String[permissions.size()];
            permissionArray = permissions.toArray(permissionArray);
            lastPermissionRequest = request;
            PermissionHelper.requestPermissions(plugin, PERMISSION_REQUEST_CODE, permissionArray);
            Log.d(LOG_TAG, "Requesting permissions :" + permissions);
        }
        else {
            request.grant(request.getResources());
        }
    }

    @Override
    public void onPermissionRequestCanceled(PermissionRequest request) {
        super.onPermissionRequestCanceled(request);
        Log.d(LOG_TAG, "Permission request canceled");
    }

    public void handleOnPermissionResult(String[] permissions, int[] grantResults) {
        lastPermissionRequest.grant(lastPermissionRequest.getResources());
    }

}
