//
//  SKRequest.m
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKRequest.h"
#import "SKData.h"
#import "GDataXMLNode.h"
#import "SKData+Private.h"

#define kSoapEnvelopeNamespace @"http://schemas.xmlsoap.org/soap/envelope/"

@interface SKRequest ()
@property (strong, nonatomic) GDataXMLElement *xml;
@property (strong, nonatomic) NSURL *url;
@end

@implementation SKRequest

- (instancetype)initWithURL:(NSURL *)url
                      operation:(NSString *)operation
                andNamespaceURL:(NSURL *)namespaceURL
{
    return [self initWithURL:url request:nil operation:operation andNamespaceURL:namespaceURL];
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                      operation:(NSString *)operation
                andNamespaceURL:(NSURL *)namespaceURL
{
    return [self initWithURL:nil request:request operation:operation andNamespaceURL:namespaceURL];
}

- (instancetype)initWithURL:(NSURL *)url
                    request:(NSURLRequest *)request
                      operation:(NSString *)operation
                andNamespaceURL:(NSURL *)namespaceURL
{
    self = [super init];
    if (self) {
        self.namespaceURL = namespaceURL;
        self.operation = operation;
        self.url = url;
        
        self.xml = [GDataXMLElement elementWithName:operation];
        [self.xml addNamespace:[GDataXMLElement namespaceWithName:nil stringValue:[namespaceURL absoluteString]]];
        
        self.request = (NSMutableURLRequest *)request ;//? (NSMutableURLRequest *)request:[self buildHTTPRequest:url];
    }
    return self;
}

- (void)addInput:(SKData *)arg
{
    [self.xml addChild:arg.xml];
}

- (void)addInputs:(NSArray *)args
{
    for(SKData *arg in args)
        [self addInput:arg];
}

- (NSString *)description
{
    return self.xml.XMLString;
}

- (NSString *)soapAction
{
    NSLog(@"SoapAction: %@",[[self.namespaceURL URLByAppendingPathComponent:self.operation] absoluteString]);
    return [[self.namespaceURL URLByAppendingPathComponent:self.operation] absoluteString];
}

- (NSData *)body
{
    GDataXMLElement *envelope = [GDataXMLElement elementWithName:@"Envelope"];
    [envelope addNamespace:[GDataXMLElement namespaceWithName:nil stringValue:kSoapEnvelopeNamespace]];
    
    GDataXMLElement *body = [GDataXMLElement elementWithName:@"Body"];
    [body addChild:self.xml];
    [envelope addChild:body];
    
    NSLog(@"body: %@",[[NSString alloc] initWithData:[[[GDataXMLDocument alloc] initWithRootElement:envelope] XMLData] encoding:NSUTF8StringEncoding]);
    return [[[GDataXMLDocument alloc] initWithRootElement:envelope] XMLData];
}

- (NSMutableURLRequest *)request
{
    if (!_request)
        _request = [self buildHTTPRequest:_url];
    else
        [_request setHTTPBody:self.body];
    return _request;
}

- (NSMutableURLRequest *)buildHTTPRequest:(NSURL *)url
{
    if (!url)
        return nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:self.body];
    [request setValue:self.soapAction forHTTPHeaderField:@"SOAPAction"];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

- (NSArray *)parseOutput:(NSData *)response
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:response options:0 error:nil];
    if(!doc)
        return nil;
    
    NSDictionary *namespaces = @{@"soap":kSoapEnvelopeNamespace,
                                 @"service":[self.namespaceURL absoluteString]};
    
    NSString *query = [NSString stringWithFormat:@"/soap:Envelope/soap:Body/service:%@Response/*", self.operation];
    NSArray *nodes = [doc nodesForXPath:query namespaces:namespaces error:nil];
    if(!nodes || nodes.count < 1)
        return nil;
    
    NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:nodes.count];
    for(GDataXMLElement *node in nodes)
        [output addObject:[SKData dataWithXMLElement:[node copy]]];
    
    return output;
}

@end
