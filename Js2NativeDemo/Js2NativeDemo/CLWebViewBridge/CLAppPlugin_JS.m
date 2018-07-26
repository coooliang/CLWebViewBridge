//
//  CLAppPlugin_JS.m
//  Js2NativeDemo
//
//  Created by chenliang on 2018/7/23.
//  Copyright © 2018年 chenl. All rights reserved.
//

#import "CLAppPlugin_JS.h"

NSString * CLWebViewJavascriptBridge_js() {
    #define __wvjb_js_func__(x) #x
    static NSString * preprocessorJSCode = @__wvjb_js_func__(
        ;
        (function () {
            var app_plugin_uuid_count = 1;
        
            function app_plugin_uuid() {
                var result = 'cid' + (app_plugin_uuid_count++) + '_' + new Date().getTime();
                return result;
            }
            var app_plugin_callback_map = new Map();
        
            function app_plugin_execute_callback(key, data) {
                var func = app_plugin_callback_map.get(key);
                if (func) {
                    if (data) {
                        func(data);
                    } else {
                        func();
                    }
                }
            }
        
            function app_plugin_page_name() {
                var strUrl = location.href;
                var arrUrl = strUrl.split("/");
                var strPage = arrUrl[arrUrl.length - 1];
                return strPage;
            }
        
            function app_plugin_create_frame(url) {
                var iframe = document.createElement('iframe');
                iframe.style.display = 'none';
                iframe.src = url;
                document.body.appendChild(iframe);
                
                setTimeout(function () {
                    iframe.parentNode.removeChild(iframe);
                    iframe = null;
                }, 0);
            }
            if (!window.plugins) {
                window.plugins = {};
            }
            if (!window.js2native) {
                window.js2native = {
                exec: function (successCallback, failureCallback, className, methodName, jsonString) {
                    var callbackId = app_plugin_uuid();
                    var successKey = callbackId + "SuccessEvent";
                    var failKey = callbackId + "FailEvent";
                    app_plugin_callback_map.set(successKey, successCallback);
                    app_plugin_callback_map.set(failKey, failureCallback);
                    var url = "https://callfunction//callbackId=" + callbackId + "&className=" + className + "&method=" + methodName + "&params=" + encodeURIComponent(jsonString);
                    url += ("&currentPage=" + app_plugin_page_name());
                    url += ("&tt=" + new Date().getTime());
                    app_plugin_create_frame(url);
                }
                };
            }
        
            function InfoPlugin() {};
            InfoPlugin.prototype.hello = function (successCallback, failureCallback, jsonString) {
                js2native.exec(successCallback, failureCallback, "InfoPlugin", "hello", jsonString);
            }
            InfoPlugin.prototype.keyboard = function (successCallback, failureCallback, jsonString) {
                js2native.exec(successCallback, failureCallback, "InfoPlugin", "keyboard", jsonString);
            }
            window.plugins.infoPlugin = new InfoPlugin();
        
            function PasswordPlugin() {};
            PasswordPlugin.prototype.keyboard = function (successCallback, failureCallback, jsonString) {
                js2native.exec(successCallback, failureCallback, "PasswordPlugin", "password", jsonString);
            }
            window.plugins.passwordPlugin = new PasswordPlugin();
        
        })();
    ); // END preprocessorJSCode
    
    #undef __wvjb_js_func__
    return preprocessorJSCode;
};
