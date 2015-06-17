//
//  SKCustomParser.m
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKCustomParser.h"

@implementation SKCustomParser
@synthesize blockParser = _blockParser;
@synthesize attributeName = _attributeName;
@synthesize destinationClass = _destinationClass;
- (id) initWithBlockParser: (SKCustomParserBlock) blockParser
          forAttributeName: (NSString *) attributeName
        onDestinationClass: (Class) classe {
    self = [super init];
    if(self){
        _attributeName = attributeName;
        _destinationClass = classe;
        _blockParser = [blockParser copy];
    }
    return self;
}

- (BOOL) isValidToPerformBlockOnAttributeName: (NSString *) attributeName
                                     forClass: (Class) classe {
    return [_attributeName isEqualToString:attributeName] && classe == _destinationClass;
}

@end
