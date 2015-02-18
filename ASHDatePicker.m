//
//  ASHDatePicker.m
//  ASHDatePicker
//
//  Created by Adam Hartford on 10/3/12.
//  Copyright (c) 2012 Adam Hartford. All rights reserved.
//

#import "ASHDatePicker.h"

@implementation ASHDatePicker

- (void)popoverDateAction
{
    self.dateValue = controller.datePicker.dateValue;
    // Update bound value...
    NSDictionary *bindingInfo = [self infoForBinding:NSValueBinding];
    [[bindingInfo valueForKey:NSObservedObjectKey] setValue:self.dateValue
                                                 forKeyPath:[bindingInfo valueForKey:NSObservedKeyPathKey]];
}

-(void)dateAction
{
    controller.datePicker.dateValue = self.dateValue;
}

- (void)awakeFromNib
{
    controller = [[ASHDatePickerController alloc] init];
    self.action = @selector(dateAction);
    controller.datePicker.action = @selector(popoverDateAction);
    [controller.datePicker bind:NSValueBinding toObject:self withKeyPath:@"dateValue" options:nil];
    
    self.popover = [[NSPopover alloc] init];
    self.popover.contentViewController = controller;
    self.popover.behavior = NSPopoverBehaviorSemitransient;
    
    self.preferredPopoverEdge = NSMaxXEdge;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.   
    }
    
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self becomeFirstResponder];
    [super mouseDown:theEvent];
}

- (BOOL)becomeFirstResponder
{
    showingPopover = YES;
    controller.datePicker.dateValue = self.dateValue;
    
    if (![self.datePickerDelegate respondsToSelector:@selector(datePickerShouldShowPopover:)]
        || [self.datePickerDelegate datePickerShouldShowPopover:self]) {
        
        [self.popover showRelativeToRect:self.bounds ofView:self preferredEdge:self.preferredPopoverEdge];
    }
    
    showingPopover = NO;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if (showingPopover) return NO;
    [self.popover close];
    return [super resignFirstResponder];
}

@end

@implementation ASHDatePickerController

- (id)init
{
    self = [super init];
    if (self) {
        NSRect viewFrame = NSMakeRect(0.0f, 0.0f, 180.0f, 180.0f);
        NSView *popoverView = [[NSView alloc] initWithFrame:viewFrame];
        
        NSRect pickerFrame = NSMakeRect(22.0f, 17.0f, 139.0f, 148.0f);
        self.datePicker = [[NSDatePicker alloc] initWithFrame:pickerFrame];
        self.datePicker.datePickerStyle = NSClockAndCalendarDatePickerStyle;
        self.datePicker.drawsBackground = NO;
        [self.datePicker.cell setBezeled:NO];
        [popoverView addSubview:self.datePicker];
        self.view = popoverView;
    }
    
    return self;
}

@end
