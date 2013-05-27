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
    static OAuth1Controller *oauth1Controller;
    
    if (!callbackURL) {
        callbackURL = defaultCallbackURL;
    }
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
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
                      NSDictionary *GROAuthDefaults = [GROAuth getGoodreadsOAuthDefaults];
                      oauth1Controller.consumerKey = [GROAuthDefaults objectForKey:kGROAuthConsumerKey];
                      oauth1Controller.consumerSecret = [GROAuthDefaults objectForKey:kGROAuthConsumerSecret];
                      oauth1Controller.oauthCallback = callbackURL;
                      
                      [oauth1Controller loginWithWebView:loginWebView
                                              completion:^(NSDictionary *oauthTokens, NSError *error) {
                                                  NSLog(@"oauthTokens: %@",oauthTokens);
                                                  if (completion != nil) {
                                                      NSLog(@"got here");
                                                      return completion(oauthTokens,error);
                                                  }
                                                  return;
                                              }];
                  }];
}

#pragma mark --Private Methods--

+ (NSDictionary *)getGoodreadsOAuthDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kGROAuthDefaults];
}

@end
