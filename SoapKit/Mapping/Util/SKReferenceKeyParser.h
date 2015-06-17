//
//  SKReferenceKeyParser.h
//  SoapKit
//
//  Created by Hannes Tribus on 15/10/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKReferenceKeyParser : NSObject

@property(nonatomic, readonly) NSString *splitToken;

+ (SKReferenceKeyParser *) parserForToken: (NSString *) splitToken;
- (NSString *) splitKeyAndMakeCamelcased: (NSString *) key;

@end
