
### 1.继承CLBasePlugin

```

#import "CLBasePlugin.h"

@interface InfoPlugin : CLBasePlugin
 
//必须有argument参数
-(void)hello:(NSString *)argument;
    
@end

```

### 2.拦截url

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

//WKWebView
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    NSLog(@"url: %@",url);
    
    if([_interceptor isPluginUrl:url webView:webView]){
        [_interceptor filter:url webView:webView webViewController:self];
        //不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}
```

### 3.HTML中调用插件

```
//json string param
function hello(){
	var obj = {name:"lion",value:"666"};
	var param = JSON.stringify(obj);
	
	//var param = '{"name":"lion","value":"666"}';

    window.plugins.infoPlugin.hello(function(data){
    	alert(data);
    },null,param);
}
  

```


### 4. 设计缺陷

```
//1.所有页面自动注入插件，即使您不需要。

//2.因为业务多变，所以常常我们使用插件时不是必须使用成功和失败回调;
//此情况下需要手动释放内存，需要调用从CLBasePlugin继承的finish方法。例如：
-(void)world:(NSString *)argument{
    NSLog(@"argument = %@",argument);
    [self finish];//没有调用成功或者失败回调时，需要调用finish函数
}

```
