SoapKit
===

[![Pod Version](http://img.shields.io/cocoapods/v/SoapKit.svg?style=flat)](http://cocoadocs.org/docsets/SoapKit/)
[![Pod Platform](http://img.shields.io/cocoapods/p/SoapKit.svg?style=flat)](http://cocoadocs.org/docsets/SoapKit/)
[![Pod License](http://img.shields.io/cocoapods/l/SoapKit.svg?style=flat)](http://opensource.org/licenses/MIT)

This framework aims to simplify the construction of a SOAP request as well as the parsing/mapping of the response into domain objects.

The parsing is based on the GDataXMLNode class that was initially developed by Google. A handy XML parsing class that will come up with nice and strucured results. Actually you'll see that because the result is already parsed you can use the result directly without mapping it into objects.

The mapping features is based on the [KeyValueObjectMapping](https://github.com/dchohfi/KeyValueObjectMapping) done by [dchohfi](https://github.com/dchohfi). Basically an adaption to deal with the result classes of SoapKit.

# Installation

### CocoaPods

Install with [CocoaPods](http://cocoapods.org) by adding the following to your Podfile:

``` ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.1'

pod 'SoapKit', '~> 0.0.1'
```

**Note**: We follow http://semver.org for versioning the public API.

### Manually

- copy the Files under ./SoapKit/
- If you'll need the mapping to Objects feature add ./Soapkit/Mapping/

# Usage

These examples are mainly taken from the example projects which should make it easy to follow

## Construct and send a Request

For this example we take a freely available webservice ([WSDL](http://www.foxcentral.net/foxcentral.asmx?op=GetNewsItems)) construct the ```SKRequest``` and send it.

```Objective-C
- (void)loadItemsofType:(NSString *)type withinLast:(NSUInteger)days
                onCompletion:(void (^)(NSArray *lectures, NSError *error))completion {
    SKRequest *request = [[SKRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.foxcentral.net/foxcentral.asmx"] operation:@"GetNewsItems" andNamespaceURL:[NSURL URLWithString:@"http://www.west-wind.com/foxcentral"]];
    [request addInputs:@[[SKData dataWithName:@"Days" andIntValue:days],
                         [SKData dataWithName:@"Provider" andIntValue:0],
                         [SKData dataWithName:@"Type" andStringValue:type]]
                        ];
    
    SKService *soapService = [[SKService alloc] init];
    [soapService performRequest:request onSuccess:^(SKService *soapService, SKData *data) {
        NSLog(@"Name:  %@",data.name);
        NSLog(@"Value: %@",data.stringValue);
    } onFailure:^(SKService *soapService, NSError *error) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }];
}
```
When you run it by yourself you'll see that the ```SKData *data``` in the result contains just a long string which itself is in XML format and could be parsed.

## Perform a request and map the result to a Doman Object

Again we'll use a freely available webservice ([WSDL](http://www.webservicex.net/GenericNAICS.asmx?op=GetNAICSByIndustry)) which is returning a simple but structured XML that we can use directly.
```Objective-C
- (void)loadItemsofIndustryType:(NSString *)type
           onCompletion:(void (^)(NSArray *lectures, NSError *error))completion {
    SKRequest *request = [[SKRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.webservicex.net/GenericNAICS.asmx"] operation:@"GetNAICSByIndustry" andNamespaceURL:[NSURL URLWithString:@"http://www.webservicex.net/"]];
    [request addInput:[SKData dataWithName:@"IndustryName" andStringValue:type]];
    SKService *soapService = [[SKService alloc] init];
    [soapService performRequest:request onSuccess:^(SKService *soapService, SKData *data) {
        SKDataObjectMapping *mapping = [SKDataObjectMapping mapperForClass:[NAICSItem class]];
        NSArray *result = [mapping parseArray:[[data childByName:@"NAICSData"] childByName:@"NAICSData"].children];
        NSLog(@"Got %lu results",(unsigned long)[result count]);
    } onFailure:^(SKService *soapService, NSError *error) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }];
}
```
Now the ```NSArray *result``` contains the results as an array of ```NAICSItem```s. That's in this case a simple domain object class defined as

```Objective-C
@interface NAICSItem : NSObject

@property (nonatomic,strong)NSString *NAICSCode;
@property (nonatomic,strong)NSString *Title;
@property (nonatomic,strong)NSString *Country;
@property (nonatomic,strong)NSString *IndustryDescription;

@end
```

### ...add a slightly more complex mapping to it

It might be that for some reasons you'll not be able to use the field names from the XML in the domain objects. Well fortunately this problem was already solved in the [original mapping project](https://github.com/dchohfi/KeyValueObjectMapping) and so it can be used here too

```Objective-C
- (void)loadItemsofIndustryType:(NSString *)type
           onCompletion:(void (^)(NSArray *lectures, NSError *error))completion {
    SKRequest *request = [[SKRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.webservicex.net/GenericNAICS.asmx"] operation:@"GetNAICSByIndustry" andNamespaceURL:[NSURL URLWithString:@"http://www.webservicex.net/"]];
    [request addInput:[SKData dataWithName:@"IndustryName" andStringValue:type]];
    SKService *soapService = [[SKService alloc] init];
    [soapService performRequest:request onSuccess:^(SKService *soapService, SKData *data) {
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
```
This means of course that the field in the domain class needs to be changed from ```Title``` to ```NAICSTitle```
#Contributions

...are really welcome. The featureset that is implemented right now is the minimum that I need for my projects and will grow with my personal needs. That's why I decided open source it, to be able to cover more use cases in a shorter amount of time.

###Planned Features

- Mapping to CoreData Objects
- Advanced Logging to Console

# License

Source code of this project is available under the standard MIT license. Please see [the license file](LICENSE.md).


