//
//  ViewController.m
//  SoapKitNAICS
//
//  Created by Hannes Tribus on 16/06/15.
//  Copyright (c) 2015 3Bus. All rights reserved.
//

#import "ViewController.h"
#import <SoapKit/SoapKit.h>
#import <SoapKit/Mapping/SoapKitMapping.h>
#import "NAICSItem.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadItemsofIndustryType:@"Construction" onCompletion:^(NSArray *lectures, NSError *error) {
        NSLog(@"Done");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadItemsofIndustryType:(NSString *)type
           onCompletion:(void (^)(NSArray *lectures, NSError *error))completion {
    SKRequest *request = [[SKRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.webservicex.net/GenericNAICS.asmx"] operation:@"GetNAICSByIndustry" andNamespaceURL:[NSURL URLWithString:@"http://www.webservicex.net/"]];
    [request addInput:[SKData dataWithName:@"IndustryName" andStringValue:type]];
    
    SKService *soapService = [[SKService alloc] init];
    [soapService performRequest:request onSuccess:^(SKService *soapService, SKData *data) {
        NSArray * tmp = data.children;
        NSLog(@"Name: %@",data.name);
    
        SKParserConfiguration *configuration = [SKParserConfiguration configuration];
        [configuration addObjectMapping:[SKObjectMapping mapKeyPath:@"Title" toAttribute:@"NAICSTitle" onClass:[NAICSItem class]]];
        SKDataObjectMapping *mapping = [SKDataObjectMapping mapperForClass:[NAICSItem class]andConfiguration:configuration];
        NSArray *result = [mapping parseArray:[[data childByName:@"NAICSData"] childByName:@"NAICSData"].children];
        NSLog(@"Got %lu results",(unsigned long)[result count]);
        
        for (id ritem in result) {
            if ([ritem isKindOfClass:[NAICSItem class]]) {
                [self.textView setText:[NSString stringWithFormat:@"%@ TITLE:%@\n DESCRIPTION:%@\n",self.textView.text, ((NAICSItem *)ritem).NAICSTitle, ((NAICSItem *)ritem).IndustryDescription]];
            }
        }
        
    } onFailure:^(SKService *soapService, NSError *error) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }];
}

@end
