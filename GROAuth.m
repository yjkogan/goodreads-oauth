//
//  GROAuth.m
//  goodreads-oauth-example
//
//  Created by Romotive on 5/26/13.
//  Copyright (c) 2013 YonatanKogan. All rights reserved.
//

#import "GROAuth.h"
#import "OAuth1Controller.h"
#import "XMLDictionary.h"

#define kGROAuthDefaults @"GROAuthDefaults"
#define kGROAuthConsumerKey @"consumerKey"
#define kGROAuthConsumerSecret @"consumerSecret"
#define kGROAuthAccessToken @"accessToken"
#define kGROAuthAccessTokenSecret @"accessTokenSecret"

#define API_URL @"http://www.goodreads.com/"

@implementation GROAuth

+ (NSString *)consumerKey {
    // Convenience method for getting the stored consumer key
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *GROAuthDefaults = [defaults objectForKey:kGROAuthDefaults];
    return [GROAuthDefaults objectForKey:kGROAuthConsumerKey];
}

+ (NSString *)consumerSecret {
    // Convenience method for getting the stored consumer secret
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *GROAuthDefaults = [defaults objectForKey:kGROAuthDefaults];
    return [GROAuthDefaults objectForKey:kGROAuthConsumerSecret];
}

+ (void)setGoodreadsOAuthWithConsumerKey:(NSString *)consumerKey secret:(NSString *)consumerSecret {

    // Store the consumer key and consumer secret
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // If the dictionary already exists, use it
    NSDictionary *goodreadsOAuthDefaults = [defaults objectForKey:kGROAuthDefaults];
    // Otherwise alloc a new one
    if (!goodreadsOAuthDefaults) {
        goodreadsOAuthDefaults = [[NSDictionary alloc] init];
    }
    
    // Set the consumer key info
    NSMutableDictionary *mutableGoodreadsOAuthDefaults = [goodreadsOAuthDefaults mutableCopy];
    [mutableGoodreadsOAuthDefaults setObject:consumerKey forKey:kGROAuthConsumerKey];
    [mutableGoodreadsOAuthDefaults setObject:consumerSecret forKey:kGROAuthConsumerSecret];
    
    [defaults setObject:mutableGoodreadsOAuthDefaults forKey:kGROAuthDefaults];
    
    // For good measure
    [defaults synchronize];
}

+ (void)loginWithGoodreadsWithCompletion:(void( ^ )(NSDictionary *authParams, NSError *error))completion {
    // Just pass this on with no callback
    [GROAuth loginWithGoodreadsWithCallbackURL:nil completion:completion];
}

+ (void)loginWithGoodreadsWithCallbackURL:(NSString *)callbackURL completion:(void( ^ )(NSDictionary *authParams, NSError *error))completion {
    
    static NSString *defaultCallbackURL = @"http://www.goodreads.com";
    
    // This varibale needs to be static and out here because otherwise it will go out of scope when the function returns
    // If that happens, then the compeltion blocks that need to be execute, which are related to this instance, will
    // attempt to access this instance, which may have been collected, and cause a crash (EXEC_BAD_ACCESS)
    static OAuth1Controller *oauth1Controller;
    
    // If the user doesn't submit a callback URL, just use the default one
    // The way OAuth1Controller works, it really doesn't matter what the URL is since
    // We're just going to pull the token out of the URL
    if (!callbackURL) {
        callbackURL = defaultCallbackURL;
    }
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    
    // We want this to be able to show itself so that the user can just call this class method and have all the login
    // done for them. Therefore, let's get the appDelegate's window and just animate our webView into it
    UIWindow *window = [appDelegate window];
    
    UIWebView *loginWebView = [[UIWebView alloc] initWithFrame:window.bounds];
    [window addSubview:loginWebView];
    
    loginWebView.scalesPageToFit = YES;
    
    oauth1Controller = [[OAuth1Controller alloc] init];
                      
    // Set consumerKey and consumerSecret to the values set earlier
    oauth1Controller.consumerKey = [GROAuth consumerKey];
    oauth1Controller.consumerSecret = [GROAuth consumerSecret];
    oauth1Controller.oauthCallback = callbackURL;
    
    // Now use the webView to log the user in
    [oauth1Controller loginWithWebView:loginWebView
                            completion:^(NSDictionary *oauthTokens, NSError *error) {
                                
                                if (error) {
                                    [loginWebView removeFromSuperview];
                                    if (completion != nil) {
                                        return completion(nil,error);
                                    }
                                    return;
                                }
                                
                                // Save the access tokens so we can use it as a default later if we wish to
                                // We need to make a mutable copy because all objects returned from
                                // NSUserDefaults are immutable
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                NSDictionary *GROAuthDefaults = [defaults objectForKey:kGROAuthDefaults];
                                NSMutableDictionary *mutableGROAuthDefaults = [GROAuthDefaults mutableCopy];
                                [mutableGROAuthDefaults setObject:[oauthTokens objectForKey:@"oauth_token"] forKey:kGROAuthAccessToken];
                                [mutableGROAuthDefaults setObject:[oauthTokens objectForKey:@"oauth_token_secret"] forKey:kGROAuthAccessTokenSecret];
                                [defaults setObject:mutableGROAuthDefaults forKey:kGROAuthDefaults];
                                
                                [loginWebView removeFromSuperview];
                                // Check that the block isn't nil since calling
                                // something on a nil C-like
                                // object causes a crash
                                if (completion != nil) {
                                    return completion(oauthTokens,nil);
                                }
                                return;
                            }];
}

+ (NSURLRequest *)goodreadsRequestForOAuthPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               HTTPmethod:(NSString *)method {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *GROAuthDefaults = [defaults objectForKey:kGROAuthDefaults];
    
    // Pass this on with the stored access token and secret
    return [GROAuth goodreadsRequestForOAuthPath:path parameters:parameters HTTPmethod:method oauthToken:[GROAuthDefaults objectForKey:kGROAuthAccessToken] oauthSecret:[GROAuthDefaults objectForKey:kGROAuthAccessTokenSecret]];
}

+ (NSURLRequest *)goodreadsRequestForOAuthPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               HTTPmethod:(NSString *)method
                               oauthToken:(NSString *)oauth_token
                              oauthSecret:(NSString *)oauth_token_secret {
    
    OAuth1Controller *oauth1Controller = [[OAuth1Controller alloc] init];
    
    // Set consumerKey and consumerSecret to the values set earlier
    oauth1Controller.consumerKey = [GROAuth consumerKey];
    oauth1Controller.consumerSecret = [GROAuth consumerSecret];
    
    NSURLRequest *request = [oauth1Controller preparedRequestForPath:path parameters:parameters HTTPmethod:method oauthToken:oauth_token oauthSecret:oauth_token_secret];
    return request;
}

+ (NSString *)XMLResponseForOAuthPath:(NSString *)path
                           parameters:(NSDictionary *)parameters
                           HTTPmethod:(NSString *)method {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *GROAuthDefaults = [defaults objectForKey:kGROAuthDefaults];
    
    // Pass this on with the stored access token and secret
    return [GROAuth XMLResponseForOAuthPath:path parameters:parameters HTTPmethod:method oauthToken:[GROAuthDefaults objectForKey:kGROAuthAccessToken] oauthSecret:[GROAuthDefaults objectForKey:kGROAuthAccessTokenSecret]];
}

+ (NSString *)XMLResponseForOAuthPath:(NSString *)path
                           parameters:(NSDictionary *)parameters
                           HTTPmethod:(NSString *)method
                           oauthToken:(NSString *)oauth_token
                          oauthSecret:(NSString *)oauth_token_secret {
    
    // Get the request from our other method and then use the helper method to get the XML
    NSURLRequest *request = [GROAuth goodreadsRequestForOAuthPath:path parameters:parameters HTTPmethod:method oauthToken:oauth_token oauthSecret:oauth_token_secret];
    return [GROAuth getDataFromRequest:request];
}

+ (NSDictionary *)dictionaryResponseForOAuthPath:(NSString *)path
                                      parameters:(NSDictionary *)parameters
                                      HTTPmethod:(NSString *)method {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *GROAuthDefaults = [defaults objectForKey:kGROAuthDefaults];
    
    // Pass this on with the stored access token and secret
    return [GROAuth dictionaryResponseForOAuthPath:path parameters:parameters HTTPmethod:method oauthToken:[GROAuthDefaults objectForKey:kGROAuthAccessToken] oauthSecret:[GROAuthDefaults objectForKey:kGROAuthAccessTokenSecret]];
}

+ (NSDictionary *)dictionaryResponseForOAuthPath:(NSString *)path
                                      parameters:(NSDictionary *)parameters
                                      HTTPmethod:(NSString *)method
                                      oauthToken:(NSString *)oauth_token
                                     oauthSecret:(NSString *)oauth_token_secret {
    // Just use XMLDictionary to convert the XMLString into a dictionary
    return [NSDictionary dictionaryWithXMLString:[GROAuth XMLResponseForOAuthPath:path parameters:parameters HTTPmethod:method oauthToken:oauth_token oauthSecret:oauth_token_secret]];
}

#pragma mark --Non OAuth methods--
+ (NSString *)XMLResponseForNonOAuthPath:(NSString *)path parameters:(NSDictionary *)parameters {
    
    // If the path doesn't require OAuth, just request the path with the appropriate parameters and return
    // the XML that's returned
    // Note: assumes all non-oauth requests are GET requests
    path = [NSString stringWithFormat:@"%@%@?", API_URL,path];
    NSMutableString *url = [path mutableCopy];
    for (NSString *key in [parameters allKeys]) {
        NSString *param = [NSString stringWithFormat:@"&%@=%@",key,[parameters objectForKey:key]];
        [url appendString:param];
    }
    return [GROAuth getDataFromURL:url];
}

+ (NSDictionary *)dictionaryResponseForNonOAuthPath:(NSString *)path parameters:(NSDictionary *)parameters {
    return [NSDictionary dictionaryWithXMLString:[GROAuth XMLResponseForNonOAuthPath:path parameters:parameters]];
}
            
#pragma mark --Private Helper Methods--
+ (NSString *)getDataFromURL:(NSString *)url {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    
    [request setURL:[NSURL URLWithString:url]];
    return [GROAuth getDataFromRequest:request];
}

// Helper function for drawing data out of a 
+ (NSString *)getDataFromRequest:(NSURLRequest *)request {
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", [[request URL] absoluteString], [responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}
@end
