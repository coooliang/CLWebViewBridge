
### 1. 在CLAppPlugin_JS.m中创建一个名为InfoPlugin的插件

```
function InfoPlugin() {};

InfoPlugin.prototype.hello = function (successCallback, failureCallback, jsonString) {
	js2native.exec(successCallback, failureCallback, "InfoPlugin", "hello", jsonString);
};//需要分号结尾
InfoPlugin.prototype.world = function (successCallback, failureCallback, jsonString) {
	js2native.exec(successCallback, failureCallback, "InfoPlugin", "world", jsonString);
};
InfoPlugin.prototype.keyboard = function (successCallback, failureCallback, jsonString) {
	js2native.exec(successCallback, failureCallback, "InfoPlugin", "keyboard", jsonString);
};
window.plugins.infoPlugin = new InfoPlugin();

//JS插件中的类名与方法名需要与OC中的类名方法名保持一致
function OtherPlugin(){}
OtherPlugin.prototype.methodName = function (successCallback, failureCallback, jsonString) {
	js2native.exec(successCallback, failureCallback, "ClassName", "methodName", jsonString);
};
...
window.plugins.otherPlugin = new OtherPlugin();

```
### 2. OC中添加对应的plugin类,需要继承CLBasePlugin

```
//JS插件中的类名与方法名需要与OC中的类名方法名保持一致
#import "CLBasePlugin.h"

@interface InfoPlugin : CLBasePlugin

//js2native.exec(successCallback, failureCallback, "InfoPlugin", "world", jsonString);
-(void)hello:(NSString *)argument;

-(void)world:(NSString *)argument;
    
-(void)keyboard:(NSString *)argument;
    
@end

```

### 3.拦截WebView的url

```
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    NSLog(@"url : %@",url);
    if([_interceptor isPluginUrl:url webView:webView]){
        [_interceptor filter:url webView:webView webViewController:self];
        return NO;
    }
    return YES;
}

```

### 4.html中如何调用插件

```

function hello(){
    var param = '{"name":"lion","value":"666"}';
    window.plugins.infoPlugin.hello(function(data){alert(data)},null,param);
}
    
function world(){
    var param = "{'name':'lion','value':'555'}";
    window.plugins.infoPlugin.world(function(data){alert(data)},null,param);
}
    
function keyboard(){
    var param = "{'nid':'test'}";
    window.plugins.infoPlugin.keyboard(function(data){alert(data)},null,param);
}

```

### 5. 设计缺陷

```

//因为业务多变，所以常常我们使用插件时不是必须使用成功和失败回调;
//此情况下需要手动释放内存，需要调用从CLBasePlugin继承的finish方法，例如：
-(void)world:(NSString *)argument{
    NSLog(@"argument = %@",argument);
    [self finish];//没有调用成功或者失败回调时，需要调用finish函数
}

```
