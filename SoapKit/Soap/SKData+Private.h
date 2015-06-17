//
//  SKData+Private.h
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKData.h"

@class GDataXMLNode;

@interface SKData (Private)

+ (instancetype)dataWithXMLElement:(GDataXMLElement *)element;

@property (strong, nonatomic) GDataXMLElement *xml;

@end
