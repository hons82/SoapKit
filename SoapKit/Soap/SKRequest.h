//
//  SKRequest.h
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKData;

//Build requests for Microsoft's "Document/literal wrapped" Soap style.

@interface SKRequest : NSObject

@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSURL *namespaceURL;
@property (strong, nonatomic) NSString *operation;

- (instancetype)initWithURL:(NSURL *)url
                  operation:(NSString *)operation
            andNamespaceURL:(NSURL *)namespaceURL;

- (instancetype)initWithRequest:(NSURLRequest *)request
                      operation:(NSString *)operation
                andNamespaceURL:(NSURL *)namespaceURL;

- (void)addInput:(SKData *)arg;

- (void)addInputs:(NSArray *)args;

- (NSString *)description;

@end
