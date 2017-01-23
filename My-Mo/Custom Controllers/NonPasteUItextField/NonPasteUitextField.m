//
//  NonPasteUitextField.m
//  My-Mo
//
//  Created by iQuinceSoft on 5/28/16.
//  Copyright © 2016 IquinceSoft. All rights reserved.
//

#import "NonPasteUitextField.h"

@implementation NonPasteUitextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    /*if (action == @selector(select:))
        return NO;
    if (action == @selector(selectAll:))
        return NO;*/
    return [super canPerformAction:action withSender:sender];
}

@end
