//
//  SWPinFormatCheckerHelper.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/15/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWPinFormatCheckerHelper.h"

@implementation SWPinFormatCheckerHelper

+ (BOOL)validateFormatOfPinWithString:(NSString *)string {
    
    BOOL isValid;
    
    NSCharacterSet* noDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:noDigits].location == NSNotFound)
    {
        isValid = YES;
    }
    
    return isValid;
}

@end
