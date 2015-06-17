//
//  SKDictionaryRearranger.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKParserConfiguration.h"

@interface SKDictionaryRearranger : NSObject

+ (NSDictionary *)rearrangeDictionary:(NSDictionary *)dictionary forConfiguration:(SKParserConfiguration *)configuration;

@end
