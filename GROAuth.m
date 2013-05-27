//
//  GROAuth.m
//  goodreads-oauth-example
//
//  Created by Romotive on 5/26/13.
//  Copyright (c) 2013 YonatanKogan. All rights reserved.
//

#import "GROAuth.h"
#import "OAuth1Controller.h"

#define kGROAuthDefaults @"GROAuthDefaults"
#define kGROAuthConsumerKey @"consumerKey"
#define kGROAuthConsumerSecret @"consumerSecret"
#define kGROAuthAccessToken @"accessToken"

@implementation GROAuth

+ (void)setGoodreadsOAuthWithConsumerKey:(NSString *)consumerKey secret:(NSString *)consumerSecret {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *goodreadsOAuthDefaults = [NSDictionary dictionaryWithObjectsAndKeys:consumerKey, kGROAuthConsumerKey,consumerSecret, kGROAuthConsumerSecret, nil];
    
    [defaults setObject:goodreadsOAuthDefaults forKey:kGROAuthDefaults];
    
    [defaults synchronize];
}

+ (void)loginWithGoodreadsWithCompletion:(void( ^ )(NSDictionary *authParams, NSError *error))completion {
    [GROAuth loginWithGoodreadsWithCallbackURL:nil completion:completion];
}

+ (void)loginWithGoodreadsWithCallbackURL:(NSString *)callbackURL completion:(void( ^ )(NSDictionary *authParams, NSError *error))completion {
    
    static NSString *defaultCallbackURL = @"http://www.example.com";
    
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
    
    UIWebView *loginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0,
                                                                          window.bounds.size.height,
                                                                          window.bounds.size.width,
                                                                          window.bounds.size.height)];
    
    [window addSubview:loginWebView];
    
    loginWebView.scalesPageToFit = YES;
    
    [UIView animateWithDuration:1.0
                    animations:^{
                        loginWebView.frame = window.bounds;
                  } completion:^(BOOL finished) {
                      
                      oauth1Controller = [[OAuth1Controller alloc] init];
                      
                      // Set consumerKey and consumerSecret to the values set earlier
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      NSDictionary *GROAuthDefaults = [defaults objectForKey:kGROAuthDefaults];
                      oauth1Controller.consumerKey = [GROAuthDefaults objectForKey:kGROAuthConsumerKey];
                      oauth1Controller.consumerSecret = [GROAuthDefaults objectForKey:kGROAuthConsumerSecret];
                      oauth1Controller.oauthCallback = callbackURL;
                      
                      // Now use the webView to log the user in
                      [oauth1Controller loginWithWebView:loginWebView
                                              completion:^(NSDictionary *oauthTokens, NSError *error) {
                                                  
                                                  // Save the access token so we can use it as a default later if we wish to
                                                  // We need to make a mutable copy because all objects returned from
                                                  // NSUserDefaults are immutable
                                                  NSMutableDictionary *mutableGROAuthDefaults = [GROAuthDefaults mutableCopy];
                                                  [mutableGROAuthDefaults setObject:[oauthTokens objectForKey:@"oauth_token"] forKey:kGROAuthAccessToken];
                                                  [defaults setObject:mutableGROAuthDefaults forKey:kGROAuthDefaults];
                                                  
                                                  // Check that the block isn't nil since calling something on a nil C-like
                                                  // object causes a crash
                                                  if (completion != nil) {
                                                      return completion(oauthTokens,error);
                                                  }
                                                  return;
                                              }];
                  }];
}

@end
