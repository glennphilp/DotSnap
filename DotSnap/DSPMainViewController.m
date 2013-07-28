//
//  DSPMainViewController.m
//  DotSnap
//
//  Created by Robert Widmann on 7/24/13.
//
//

#import "DSPMainView.h"
#import "DSPMainWindow.h"
#import "DSPMainViewModel.h"
#import "DSPHistoryRowView.h"
#import "DSPHistoryTableView.h"
#import "DSPMainViewController.h"
#import "DSPDirectoryPickerButton.h"
#import "DSPSpinningSettingsButton.h"
#import "DSPPreferencesViewController.h"

@interface DSPMainViewController ()
@property (nonatomic, strong, readonly) DSPMainViewModel *viewModel;
@property (nonatomic, strong) DSPPreferencesViewController *preferencesViewController;
@property (nonatomic, strong) RACSubject *canFireSubject;
@property (nonatomic, strong) NSTextField *filenameField;
@property (nonatomic, copy) void (^carriageReturnBlock)();
@end

@implementation DSPMainViewController

- (id)initWithContentRect:(CGRect)rect {
	self = [super init];
	
	_contentFrame = rect;
	_viewModel = [DSPMainViewModel new];
	_canFireSubject = [RACSubject subject];
	_preferencesViewController = [[DSPPreferencesViewController alloc]initWithContentRect:(CGRect){ .size = { 400, 350 } } canFireSubject:_canFireSubject];
	[_canFireSubject sendNext:@YES];
	
	return self;
}

- (void)loadView {
	DSPMainView *view = [[DSPMainView alloc]initWithFrame:_contentFrame];
	view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	view.backgroundColor = [NSColor colorWithCalibratedRed:0.260 green:0.663 blue:0.455 alpha:1.000];
	
	NSBox *windowShadow = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = NSHeight(_contentFrame) - 2, .size = { (NSWidth(_contentFrame)/2) - 10, 2 } }];
	windowShadow.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	windowShadow.borderType = NSLineBorder;
	windowShadow.borderColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	windowShadow.fillColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	windowShadow.borderWidth = 2.f;
	windowShadow.boxType = NSBoxCustom;
	[view addSubview:windowShadow];
	
	NSBox *windowShadow2 = [[NSBox alloc]initWithFrame:(NSRect){ .origin.x = (NSWidth(_contentFrame)/2) + 10, .origin.y = NSHeight(_contentFrame) - 2, .size = { (NSWidth(_contentFrame)/2) - 10, 2 } }];
	windowShadow2.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	windowShadow2.borderType = NSLineBorder;
	windowShadow2.borderColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	windowShadow2.fillColor = [NSColor colorWithCalibratedRed:0.361 green:0.787 blue:0.568 alpha:1.000];
	windowShadow2.borderWidth = 2.f;
	windowShadow2.boxType = NSBoxCustom;
	[view addSubview:windowShadow2];
	
	NSBox *separatorShadow = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = NSHeight(_contentFrame) - 146, .size = { NSWidth(_contentFrame), 2 } }];
	separatorShadow.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	separatorShadow.borderType = NSLineBorder;
	separatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	separatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	separatorShadow.borderWidth = 2.f;
	separatorShadow.boxType = NSBoxCustom;
	[view addSubview:separatorShadow];
	
	NSBox *underSeparatorShadow = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = 2, .size = { NSWidth(_contentFrame), 2 } }];
	underSeparatorShadow.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	underSeparatorShadow.borderType = NSLineBorder;
	underSeparatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	underSeparatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.159 green:0.468 blue:0.307 alpha:1.000];
	underSeparatorShadow.borderWidth = 2.f;
	underSeparatorShadow.boxType = NSBoxCustom;
	[view addSubview:underSeparatorShadow];
	
	DSPMainView *fieldBackground = [[DSPMainView alloc]initWithFrame:(NSRect){ .origin.y = 4, .size = { NSWidth(_contentFrame), 60 } }];
	fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];
	fieldBackground.autoresizingMask = NSViewMinYMargin;
	[view addSubview:fieldBackground];
	
	NSTextField *changeFolderLabel = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 96, .origin.y = NSHeight(_contentFrame) - 80, .size = { NSWidth(_contentFrame), 36 } }];
	changeFolderLabel.bezeled = NO;
	changeFolderLabel.editable = NO;
	changeFolderLabel.drawsBackground = NO;
	changeFolderLabel.font = [NSFont fontWithName:@"HelveticaNeue" size:30.f];
	changeFolderLabel.textColor = [NSColor whiteColor];
	changeFolderLabel.focusRingType = NSFocusRingTypeNone;
	changeFolderLabel.stringValue = @"Change Folder";
	changeFolderLabel.autoresizingMask = NSViewMinYMargin;
	[view addSubview:changeFolderLabel];
		
	NSTextField *saveToLabel = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 96, .origin.y = NSHeight(_contentFrame) - 115, .size = { NSWidth(_contentFrame), 34 } }];
	saveToLabel.bezeled = NO;
	saveToLabel.editable = NO;
	saveToLabel.drawsBackground = NO;
	saveToLabel.font = [NSFont fontWithName:@"HelveticaNeue-Bold" size:10.f];
	saveToLabel.textColor = [NSColor colorWithCalibratedRed:0.171 green:0.489 blue:0.326 alpha:1.000];
	saveToLabel.focusRingType = NSFocusRingTypeNone;
	NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	self.viewModel.filepath = desktopPath;
	saveToLabel.stringValue = [NSString stringWithFormat:@"SAVE TO: %@", desktopPath];
	saveToLabel.autoresizingMask = NSViewMinYMargin;
	[view addSubview:saveToLabel];
	
	NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:(NSRect){ }];
	scrollView.layer = CALayer.layer;
	scrollView.wantsLayer = YES;
	scrollView.verticalScrollElasticity = NSScrollElasticityNone;
	DSPHistoryTableView *tableView = [[DSPHistoryTableView alloc] initWithFrame: scrollView.bounds];
	[tableView setHeaderView:nil];
	tableView.focusRingType = NSFocusRingTypeNone;
	tableView.gridStyleMask = NSTableViewSolidHorizontalGridLineMask;
	NSTableColumn *firstColumn  = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
	firstColumn.editable = NO;
	firstColumn.width = CGRectGetWidth(view.bounds);
	[tableView addTableColumn:firstColumn];
	tableView.delegate = self;
	tableView.dataSource = self.viewModel;
	scrollView.documentView = tableView;
	[view addSubview:scrollView];
	
	_filenameField = [[NSTextField alloc]initWithFrame:(NSRect){ .origin.x = 30, .origin.y = 12, .size = { NSWidth(_contentFrame), 34 } }];
	_filenameField.delegate = self;
	_filenameField.bezeled = NO;
	_filenameField.drawsBackground = NO;
	_filenameField.font = [NSFont fontWithName:@"HelveticaNeue" size:16.f];
	_filenameField.textColor = [NSColor colorWithCalibratedRed:0.437 green:0.517 blue:0.559 alpha:1.000];
	_filenameField.focusRingType = NSFocusRingTypeNone;
	_filenameField.autoresizingMask = NSViewMinYMargin;
	[view addSubview:_filenameField];
	
	DSPDirectoryPickerButton *directoryButton = [[DSPDirectoryPickerButton alloc]initWithFrame:(NSRect){ .origin.x = 36, .origin.y = NSHeight(_contentFrame) - 96, .size = { 48, 48 } }];
	directoryButton.rac_command = [RACCommand commandWithCanExecuteSignal:self.canFireSubject];
	[directoryButton.rac_command subscribeNext:^(NSButton *_) {
		((DSPMainWindow *)view.window).isInOpenPanel = YES;
		[self.openPanel beginSheetModalForWindow:view.window completionHandler:^(NSInteger result){
			((DSPMainWindow *)view.window).isInOpenPanel = NO;
			if (result == NSFileHandlingPanelOKButton) {
				NSArray *urls = [self.openPanel URLs];
				NSString *urlString = [[urls objectAtIndex:0] path];
				BOOL isDir;
				[NSFileManager.defaultManager fileExistsAtPath:urlString isDirectory:&isDir];
				if (isDir) {
					self.viewModel.filepath = urlString;
					saveToLabel.stringValue = [NSString stringWithFormat:@"SAVE TO: %@", urlString.stringByStandardizingPath.stringByAbbreviatingWithTildeInPath];
				} else {
					self.viewModel.filepath = urlString.stringByDeletingLastPathComponent;
					saveToLabel.stringValue = [NSString stringWithFormat:@"SAVE TO: %@", urlString.stringByDeletingLastPathComponent.stringByStandardizingPath.stringByAbbreviatingWithTildeInPath];
				}
			}
		}];
	}];
	[view addSubview:directoryButton];

	DSPSpinningSettingsButton *optionsButton = [[DSPSpinningSettingsButton alloc]initWithFrame:(NSRect){ .origin.x = NSWidth(_contentFrame) - 45, .origin.y = 24, .size = { 17, 17 } }];
	optionsButton.rac_command = [RACCommand commandWithCanExecuteSignal:self.canFireSubject];
	[optionsButton.rac_command subscribeNext:^(NSButton *_) {
		[_filenameField resignFirstResponder];
		_preferencesViewController.view.alphaValue = 0.0f;
	
		[NSAnimationContext beginGrouping];
		[_preferencesViewController.view.animator setAlphaValue:1.f];
		[(DSPMainWindow *)view.window setFrame:(NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = NSMaxY(view.window.screen.frame) - 374, .size = { 400, 350 } } display:YES animate:YES];

		[NSAnimationContext endGrouping];
		[self.canFireSubject sendNext:@NO];
	}];
	[view addSubview:optionsButton];
	
	NSBox *historySeparatorShadow = [[NSBox alloc]initWithFrame:(NSRect){ .origin.y = 2, .size = { NSWidth(_contentFrame), 2 } }];
	historySeparatorShadow.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	historySeparatorShadow.borderType = NSLineBorder;
	historySeparatorShadow.borderColor = [NSColor colorWithCalibratedRed:0.794 green:0.840 blue:0.864 alpha:1.000];
	historySeparatorShadow.fillColor = [NSColor colorWithCalibratedRed:0.794 green:0.840 blue:0.864 alpha:1.000];
	historySeparatorShadow.borderWidth = 2.f;
	historySeparatorShadow.boxType = NSBoxCustom;
	historySeparatorShadow.alphaValue = 0.f;
	[view addSubview:historySeparatorShadow];
	
	_preferencesViewController.view.alphaValue = 0.f;
	[view addSubview:_preferencesViewController.view];
	
	self.view = view;

	@weakify(self);
	[NSNotificationCenter.defaultCenter addObserverForName:NSControlTextDidChangeNotification object:_filenameField queue:nil usingBlock:^(NSNotification *note) {
		@strongify(self);
		NSRect rect = (NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = NSMaxY(view.window.screen.frame) - 474, .size = { 400, 469 } };
		if (!CGRectEqualToRect(rect, view.window.frame)) {
			[view setNeedsDisplay:YES];
			historySeparatorShadow.alphaValue = 1.f;
			[scrollView.animator setFrame:(NSRect){ .origin.y = 4, .size = { 400, 246 } }];
			[(DSPMainWindow *)view.window setFrame:rect display:YES animate:YES];
			fieldBackground.backgroundColor = [NSColor whiteColor];
		}
		if (_filenameField.stringValue.length == 0) {
			self.viewModel.filename = @"Screen Shot";
		}
		self.viewModel.filename = _filenameField.stringValue;
	}];
	
	self.viewModel.filename = [NSUserDefaults.standardUserDefaults stringForKey:DSPDefaultFilenameTemplateKey];

	self.carriageReturnBlock = ^{
		@strongify(self);
		[tableView reloadData];
		
		historySeparatorShadow.alphaValue = 0.f;

		[self.filenameField resignFirstResponder];
		
		fieldBackground.backgroundColor = [NSColor colorWithCalibratedRed:0.850 green:0.888 blue:0.907 alpha:1.000];
		
		optionsButton.image = [NSImage imageNamed:@"FilenameCheckmark.png"];
		
		[scrollView.animator setFrame:(NSRect){ .origin.y = 4, .size = { 400, 0 } }];
		[(DSPMainWindow *)view.window setFrame:(NSRect){ .origin.x = view.window.frame.origin.x, .origin.y = NSMaxY(view.window.screen.frame) - 244, .size = { 400, 224 } } display:YES animate:YES];
		
		double delayInSeconds = 0.5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext]setCompletionHandler:^{
				optionsButton.image = [NSImage imageNamed:@"OptionsGear"];
				[optionsButton.animator setAlphaValue:1.f];
			}];
			
			[optionsButton.animator setAlphaValue:0.f];
			
			[NSAnimationContext endGrouping];
		});
	};
	
	_filenameField.stringValue = [NSUserDefaults.standardUserDefaults stringForKey:DSPDefaultFilenameTemplateKey];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
	if (commandSelector == @selector(insertNewline:)) {
		[self.viewModel addFilenameToHistory:self.filenameField.stringValue];
		self.carriageReturnBlock();
		return YES;
	}
	return NO;
}

- (NSOpenPanel *)openPanel {
	static NSOpenPanel *panel;
	if (panel == nil) {
		panel = [NSOpenPanel openPanel];
		[panel setCanChooseDirectories:YES];
		[panel setAllowsMultipleSelection:NO];
		[panel setBecomesKeyOnlyIfNeeded:YES];
		[panel setCanCreateDirectories:YES];
		[panel setMessage:@"Import one or more files or directories."];
	}
	return panel;
}

#pragma mark - NSTableViewDelegate

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 60.f;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	DSPHistoryRowView *tableCellView = (DSPHistoryRowView*)[tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
	return tableCellView;
}

- (void)tableView:(NSTableView *)tableView didAddRowView:(DSPHistoryRowView *)rowView forRow:(NSInteger)row {
	rowView.title = self.viewModel.filenameHistory[row];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
	DSPHistoryRowView *rowView = [[DSPHistoryRowView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(_contentFrame), 110)];
    return rowView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSTableView *table = notification.object;
	self.filenameField.stringValue = self.viewModel.filenameHistory[table.selectedRow];
	self.carriageReturnBlock();
}

@end