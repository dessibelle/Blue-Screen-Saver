//
//  SCView.h
//  SC
//
//  Created by Simon Fransson on 2010-05-03.
//  Copyright (c) 2010, Hobo Code. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>


@interface SCView : ScreenSaverView 
{}

@property (strong)	NSColor					*backgroundColor;
@property (strong)	NSColor					*captionBackgroundColor;
@property (strong)	NSFont					*font;
@property (strong)	NSDictionary			*drawingAttributes;
@property (strong)	NSDictionary			*captionDrawingAttributes;
@property (copy)	NSString				*captionString;
@property (copy)	NSString				*contentString;
@property (strong)	ScreenSaverDefaults		*defaults;
@property (assign)	BOOL					hasUnderscoreSuffix;
@property (assign)	BOOL					xp;
@property (assign)	BOOL					fatal;

@property (strong)  IBOutlet NSWindow       *configSheet;
@property (strong)  IBOutlet NSSlider       *typeSlider;
@property (strong)  IBOutlet NSSlider       *fatalitySlider;

@end
