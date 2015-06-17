//
//  SKNSDateConverter.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKValueConverter.h"
@interface SKNSDateConverter : NSObject <SKValueConverter>

+ (SKNSDateConverter *) dateConverterForPattern: (NSString *) pattern;

@end
