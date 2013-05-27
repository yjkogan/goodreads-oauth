//
//  GROAuth.h
//  goodreads-oauth-example
//
//  Created by Romotive on 5/26/13.
//  Copyright (c) 2013 YonatanKogan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GROAuth : NSObject

+ (NSString *)consumerKey;

+ (NSString *)consumerSecret;

+ (void)setGoodreadsOAuthWithConsumerKey:(NSString *)consumerKey secret:(NSString *)consumerSecret;

+ (void)loginWithGoodreadsWithCompletion:(void( ^ )(NSDictionary *authParams, NSError *error))completion;

+ (void)loginWithGoodreadsWithCallbackURL:(NSString *)callbackURL
                           completion:(void( ^ )(NSDictionary *authParams, NSError *error))completion;

+ (NSURLRequest *)goodreadsRequestForOAuthPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               HTTPmethod:(NSString *)method;

+ (NSURLRequest *)goodreadsRequestForOAuthPath:(NSString *)path
                               parameters:(NSDictionary *)parameters
                               HTTPmethod:(NSString *)method
                               oauthToken:(NSString *)oauth_token
                              oauthSecret:(NSString *)oauth_token_secret;

+ (NSString *)XMLResponseForOAuthPath:(NSString *)path
                      parameters:(NSDictionary *)parameters
                      HTTPmethod:(NSString *)method;

+ (NSString *)XMLResponseForOAuthPath:(NSString *)path
                      parameters:(NSDictionary *)parameters
                      HTTPmethod:(NSString *)method
                      oauthToken:(NSString *)oauth_token
                     oauthSecret:(NSString *)oauth_token_secret;

+ (NSDictionary *)dictionaryResponseForOAuthPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                 HTTPmethod:(NSString *)method;

+ (NSDictionary *)dictionaryResponseForOAuthPath:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                 HTTPmethod:(NSString *)method
                                 oauthToken:(NSString *)oauth_token
                                oauthSecret:(NSString *)oauth_token_secret;

+ (NSString *)XMLResponseForNonOAuthPath:(NSString *)path parameters:(NSDictionary *)parameters;

+ (NSDictionary *)dictionaryResponseForNonOAuthPath:(NSString *)path parameters:(NSDictionary *)parameters;
@end
