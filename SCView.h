//
//  SCView.h
//  SC
//
//  Created by Simon Fransson on 2010-05-03.
//  Copyright (c) 2010, Hobo Code. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>


@interface SCView : ScreenSaverView 
{
	NSColor					*_backgroundColor;
	NSColor					*_captionBackgroundColor;
	NSFont					*_font;
	NSString				*_captionString;
	NSString				*_contentString;
	NSDictionary			*_drawingAttributes;
	NSDictionary			*_captionDrawingAttributes;
	ScreenSaverDefaults		*_defaults;
	
	BOOL					_hasUnderscoreSuffix;
	BOOL					_xp;
	BOOL					_fatal;
}

@property (retain)	NSColor					*backgroundColor;
@property (retain)	NSColor					*captionBackgroundColor;
@property (retain)	NSFont					*font;
@property (retain)	NSDictionary			*drawingAttributes;
@property (retain)	NSDictionary			*captionDrawingAttributes;
@property (copy)	NSString				*captionString;
@property (copy)	NSString				*contentString;
@property (retain)	ScreenSaverDefaults		*defaults;
@property (assign)	BOOL					hasUnderscoreSuffix;
@property (assign)	BOOL					xp;
@property (assign)	BOOL					fatal;

@end
