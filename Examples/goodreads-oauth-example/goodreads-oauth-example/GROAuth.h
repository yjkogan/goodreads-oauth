//
//  GROAuth.h
//  goodreads-oauth-example
//
//  Created by Romotive on 5/26/13.
//  Copyright (c) 2013 YonatanKogan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GROAuth : NSObject

+ (void)loginWithGoodreadsWithCompletion:(void( ^ )(NSDictionary *authParams, NSError *error))completion;

+ (void)loginWithGoodreadsWithCallbackURL:(NSString *)callbackURL
                           completion:(void( ^ )(NSDictionary *authParams, NSError *error))completion;

+ (void)setGoodreadsOAuthWithConsumerKey:(NSString *)consumerKey secret:(NSString *)consumerSecret;

+ (NSURLRequest *)goodreadsRequestForPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               HTTPmethod:(NSString *)method;

+ (NSURLRequest *)goodreadsRequestForPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               HTTPmethod:(NSString *)method
                               oauthToken:(NSString *)oauth_token
                              oauthSecret:(NSString *)oauth_token_secret;

+ (NSString *)XMLResponseForPath:(NSString *)path
                      parameters:(NSDictionary *)parameters
                      HTTPmethod:(NSString *)method;

+ (NSString *)XMLResponseForPath:(NSString *)path
                      parameters:(NSDictionary *)parameters
                      HTTPmethod:(NSString *)method
                      oauthToken:(NSString *)oauth_token
                     oauthSecret:(NSString *)oauth_token_secret;

+ (NSDictionary *)dictionaryResponseForPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                 HTTPmethod:(NSString *)method;

+ (NSDictionary *)dictionaryResponseForPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                 HTTPmethod:(NSString *)method
                                 oauthToken:(NSString *)oauth_token
                                oauthSecret:(NSString *)oauth_token_secret;
@end
