//
//  SKService.m
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKService.h"
#import "SKRequest.h"
#import "SKData.h"
#import "GDataXMLNode.h"
#import "SKData+Private.h"

#define kSoapEnvelopeNamespace @"http://schemas.xmlsoap.org/soap/envelope/"

@interface SKService ()
@property (strong, nonatomic, readwrite) NSURLSession *session;
@end

@implementation SKService

- (NSURLSession *)session {
    if(!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return _session;
}

- (void)performRequest:(SKRequest *)soapRequest onSuccess:(void (^)(SKService *soapService, SKData *data))success onFailure:(void (^)(SKService *soapService, NSError *error))failure {
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:soapRequest.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            failure(self, error);
            return;
        }
        NSArray *result = [self parseOutput:data SoapReaquest:soapRequest];
        if(!result) {
            failure(self, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotParseResponse userInfo:nil]);
        } else {
            if (result.count > 1) {
                success(self, [SKData dataWithName:[NSString stringWithFormat:@"%@Response", soapRequest.operation] andChildren:result]);
            }
            success(self, result.firstObject );
        }
    }];
    [task resume];
}

- (NSArray *)parseOutput:(NSData *)response SoapReaquest:(SKRequest *)soapRequest {
    DLog(@"response: %@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:response options:0 error:nil];
    if(!doc)
        return nil;
    
    NSDictionary *namespaces = @{@"soap":kSoapEnvelopeNamespace,
                                 @"service":[soapRequest.namespaceURL absoluteString]};
    
    NSString *query = [NSString stringWithFormat:@"/soap:Envelope/soap:Body/service:%@Response/*", soapRequest.operation];
    NSArray *nodes = [doc nodesForXPath:query namespaces:namespaces error:nil];
    if(!nodes || nodes.count < 1)
        return nil;
    
    NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:nodes.count];
    for(GDataXMLElement *node in nodes)
        [output addObject:[SKData dataWithXMLElement:[node copy]]];
    
    return output;
}

@end
