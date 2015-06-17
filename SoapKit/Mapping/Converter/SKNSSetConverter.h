//
//  SKNSSetConverter.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKValueConverter.h"

@class SKParserConfiguration;
@interface SKNSSetConverter : NSObject <SKValueConverter>

+ (SKNSSetConverter *) setConverterForConfiguration: (SKParserConfiguration *) configuration;

@end
