//
//  SCView.m
//  SC
//
//  Created by Simon Fransson on 2010-05-03.
//  Copyright (c) 2010, Hobo Code. All rights reserved.
//

#import "BSODSaverView.h"

@interface BSODSaverView (Private)
- (void)loadFontWithName:(NSString *)fontName inBundle:(NSBundle *)bundle;
@end


@implementation BSODSaverView

NSString *const kExternalURL = @"http://www.github.com/dessibelle/Blue-Screen-Saver";

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        
        ScreenSaverDefaults *defaults;
        defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"BlueScreenSaver"];
        
        // Register our default values
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                    @0.5, @"CrashType",
                                    @0.5, @"Fatality",
                                    nil]];
        
        
		self.backgroundColor = [NSColor colorWithCalibratedRed:(1.0/255.0) green:(2.0/255.0) blue:(172.0/255.0) alpha:1.0];
		self.captionBackgroundColor = [NSColor colorWithCalibratedRed:(169.0/255.0) green:(170.0/255.0) blue:(174.0/255.0) alpha:1.0];
		self.hasUnderscoreSuffix = NO;
		
		[self setAnimationTimeInterval:1/1.5];
		
		/* FixedsysTTF / LucidaConsole: File names must match post script names */
		NSString *bundleIdentifier = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleIdentifier"];
		self.defaults = [ScreenSaverDefaults defaultsForModuleWithName:bundleIdentifier];
				
        NSBundle *screenSaverBundle = [NSBundle bundleWithIdentifier:bundleIdentifier];
        [self loadFontWithName:@"FixedsysTTF" inBundle:screenSaverBundle];
        [self loadFontWithName:@"LucidaConsole" inBundle:screenSaverBundle];
		
		float fontSize = isPreview ? 6.0 : 15.0;
		
		srand48(arc4random());
        
        double fatal_rand = drand48() -0.5 + [defaults doubleForKey:@"Fatality"];
        double xp_rand = drand48() -0.5 + [defaults doubleForKey:@"CrashType"];
    
        self.fatal = fatal_rand >= 0.5;
        self.xp = xp_rand >= 0.5;
		
		if (self.xp) {
			self.font = [NSFont fontWithName:@"LucidaConsole" size:fontSize];
		} else {
			self.font = [NSFont fontWithName:@"FixedsysTTF" size:fontSize];
		}
		
		/* 9.X : VMM / DiskTSD / voltrack  */
		
		if (self.xp) {
		
			NSInteger	addr1 = rand(),
			addr2 = rand(),
			addr3 = rand(),
			addr4 = rand(),
			addr5 = rand(),
			addr6 = rand(),
			addr7 = rand(),
			addr8 = rand();
			
			self.contentString = [NSString stringWithFormat:@"A problem has been detected and windows has been shut down to prevent damage\nto you computer.\n\nThe problem seems to be caused by the following file: SPCMDCON.SYS\n\nPAGE_FAULT_IN_NONPAGED_AREAD\n\nIf this is the first time you've seen this stop error screen,\nrestart you computer. If this screen appears again, follow\nthese steps:\n\nCheck to make sure any new hardware or software is properly installed.\nIf this is a new installation, ask you hardware or software manufacturer\nfor any windows updates you might need.\n\nIf problems continue, disable or remove any newly installed hardware\nor software. Disable BIOS memory options such as caching or shadowing.\nIf you need to use Safe Mode to remove or disable components, restart\nyour computer, press F8 to select Advanced Startup Options, and then\nselect Safe Mode.\n\nTechnical information:\n\n*** STOP: 0x%08lX (0x%08lX, 0x%08lX, 0x%08lX, 0x%08lX)\n\n\n*** SPCMDCON.SES - Address %08lX base at %08lX, DateStamp %08lx ", addr1, addr2, addr3, addr4, addr5, addr6, addr7, addr8];
			
		} else if (self.fatal) {
			
			NSInteger	addr1 = rand() % (0xFFFF - 0x1000) + 0x1000,
			addr2 = rand(),
			addr3 = rand(),
			exception = rand() % (0x0F - 0x01) + 0x01;
			
			self.contentString = [NSString stringWithFormat:@"A fatal exception %02lX has occured at %04lX:%08lX in VxD VMM(01) + \n%08lX. The current application will be terminated.\n\n* Press any key to terminate the current application.\n* Press CTRL+ALT+RESET to restart you computer. You will\n  lose any unsaved information in all applications.\n\n\n		             Press any key to continue ", exception, addr1, addr2, addr3];
			
		} else {
			
			NSInteger	addr1 = rand() % (0xFFFF - 0x1000) + 0x1000,
			addr2 = rand(),
			addr3 = rand(),
			addr4 = rand() % (0xFFFF - 0x1000) + 0x1000,
			addr5 = rand(),
			addr6 = rand(),
			exception = rand() % (0x0F - 0x01) + 0x01;
			
			self.contentString = [NSString stringWithFormat:@"An exception %02lX has occured at %04lX:%08lX in VxD VMM(01) + \n%08lX. This was called from %04lX:%08lX in VxD VMM(01) + \n%08lX. It may be possible to continue normally.\n\n* Press any key to terminate the current application.\n* Press CTRL+ALT+RESET to restart you computer. You will\n  lose any unsaved information in all applications.\n\n\n		             Press any key to continue ", exception, addr1, addr2, addr3, addr4, addr5, addr6];
		}
		
		self.captionString = @" Windows ";
		
		self.drawingAttributes = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,
								   [NSColor whiteColor], NSForegroundColorAttributeName,
								   nil];
		
		self.captionDrawingAttributes = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,
										 self.backgroundColor, NSForegroundColorAttributeName,
										 self.captionBackgroundColor, NSBackgroundColorAttributeName,
										 nil];
    }
	
    return self;
}

- (void)animateOneFrame
{
	self.hasUnderscoreSuffix = !self.hasUnderscoreSuffix;
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect
{
	if (![self isPreview])
		[[NSGraphicsContext currentContext] setShouldAntialias:NO];
	
	[self.backgroundColor set];
	[self.font set];
	
	/*
	 *  ▋ █ ▊
	 */
	
	NSString *message = [self.contentString stringByAppendingString:(self.hasUnderscoreSuffix ? @"_" : @"▋")];
	
	NSRectFill(rect);
	
	NSSize captionSize = [self.captionString sizeWithAttributes:self.captionDrawingAttributes];
	NSSize contentSize = [message sizeWithAttributes:self.drawingAttributes];
	
	NSRect captionRect = NSMakeRect((rect.size.width - captionSize.width) / 2.0,
									((rect.size.height + contentSize.height) / 2.0) + (self.xp ? 0 : captionSize.height), 
									captionSize.width,
									captionSize.height);

	NSRect contentRect = NSMakeRect((rect.size.width - contentSize.width) / 2.0,
									((rect.size.height - contentSize.height) / 2.0) - (self.xp ? 0 : captionSize.height), 
									contentSize.width,
									contentSize.height);
	
	if (!self.xp)
		[self.captionString drawInRect:captionRect withAttributes:self.captionDrawingAttributes];
	
	[message drawInRect:contentRect withAttributes:self.drawingAttributes];
}

+ (BOOL)performGammaFade
{
    return NO;
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow *)configureSheet
{
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"BlueScreenSaver"];
    
    if (!self.configSheet)
    {
        NSArray *topLevelObjects;
        
        if (![[NSBundle bundleForClass:[self class]] loadNibNamed:@"ConfigureSheet" owner:self topLevelObjects:&topLevelObjects])
        {
            NSLog( @"Failed to load configure sheet." );
            NSBeep();
        }
    }
    
    
    [self.fatalitySlider setFloatValue:[defaults floatForKey:@"Fatality"]];
    [self.typeSlider setFloatValue:[defaults floatForKey:@"CrashType"]];
    
    return self.configSheet;

}

# pragma mark Private

- (void)loadFontWithName:(NSString *)fontName inBundle:(NSBundle *)bundle {
    NSArray *availableFonts = [[NSFontManager sharedFontManager] availableFonts];

    if (![availableFonts containsObject:fontName]) {
        NSURL *fontURL = [bundle URLForResource:fontName withExtension:@"ttf" subdirectory:@"Fonts"];
        assert(fontURL);
        CFErrorRef error = NULL;
        if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontURL, kCTFontManagerScopeProcess, &error))
        {
            CFShow(error);
        }
    }
}

#pragma mark IBACtions

- (IBAction)configSheetCancelAction:(id)sender
{
    if ([NSWindow respondsToSelector:@selector(endSheet:)])
    {
        [[self.configSheet sheetParent] endSheet:self.configSheet returnCode:NSModalResponseCancel];
    } else {
        [[NSApplication sharedApplication] endSheet:self.configSheet];
    }
}

- (IBAction)configSheetOKAction:(id)sender
{
    ScreenSaverDefaults *defaults;
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"BlueScreenSaver"];

    [defaults setFloat:self.fatalitySlider.floatValue forKey:@"Fatality"];
    [defaults setFloat:self.typeSlider.floatValue forKey:@"CrashType"];
    
    [defaults synchronize];
    
    [self configSheetCancelAction:sender];
}

- (IBAction)URLTextFieldClicked:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:kExternalURL]];
}


@end
