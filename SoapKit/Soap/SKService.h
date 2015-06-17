//
//  SKService.h
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKRequest;
@class SKData;

@interface SKService : NSObject

@property (strong, nonatomic, readonly) NSURLSession *session;
@property (strong, nonatomic, readonly) NSURL *url;
@property (strong, nonatomic, readonly) NSURL *namespaceURL;

- (void)performRequest:(SKRequest *)soapRequest onSuccess:(void (^)(SKService *soapService, SKData *data))success onFailure:(void (^)(SKService *soapService, NSError *error))failure;

@end
