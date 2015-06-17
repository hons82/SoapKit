//
//  SKCustomParser.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SKData.h"

typedef id(^SKCustomParserBlock)(__weak SKData *data, __weak NSString *attributeName, __weak Class destinationClass, __weak id value);

@interface SKCustomParser : NSObject

@property(nonatomic, readonly) NSString *attributeName;
@property(nonatomic, readonly) Class destinationClass;
@property(nonatomic, readonly) SKCustomParserBlock blockParser;

- (id) initWithBlockParser: (SKCustomParserBlock) blockParser
          forAttributeName: (NSString *) attributeName
        onDestinationClass: (Class) classe;

- (BOOL) isValidToPerformBlockOnAttributeName: (NSString *) attributeName
                                     forClass: (Class) classe;
@end
