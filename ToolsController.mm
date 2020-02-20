//
//  ToolsController.m
//  MachOView
//
//  Created by Joey Cao on 2020/2/10.
//

#import "ToolsController.h"
#import "DataController.h"
#import "MachOLayout.h"
#import "ObjC.h"

@interface ToolsController ()

@property (nonatomic) MVDataController *dataController;

@property (weak) IBOutlet NSScrollView *textView;
@property (nonatomic) NSTextView *textContent;

@property (nonatomic, strong) MachOLayout *macho;

@property (nonatomic) NSArray *currentLines;
@property (nonatomic) NSString *fliterLines;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ToolsController

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    }
    return _dateFormatter;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (instancetype)initWithDataController:(MVDataController *)dataController {
    self = [super initWithWindowNibName:@"ToolsController"];
    if (self) {
        _dataController = dataController;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMVThreadStateChange:) name:MVThreadStateChangedNotification object:nil];
    }
    return self;
}
- (IBAction)onFliterFeildChange:(NSSearchField *)sender {
    NSString *fliter = sender.stringValue;
    if (fliter.length <= 0) {
        [self showTexts:_currentLines];
        return;
    }
    NSMutableArray *fliterdLines = [NSMutableArray array];
    for (NSString *line in self.currentLines) {
        if ([line containsString:fliter]) {
            [fliterdLines addObject:line];
        }
    }
    [self showTexts:fliterdLines];
}

- (IBAction)onAllClassesClicked:(id)sender {
    if (![self findMachOLayout]) {
        NSLog(@"No mach-O");
    } else {
        NSArray *allClasses = _macho.allClassLists;
        self.currentLines = allClasses;
        [self showTexts:allClasses];
    }
}

- (IBAction)onUnusedClassesClicked:(id)sender {
   
    
    if (![self findMachOLayout]) {
        NSLog(@"No mach-O");
    } else {
        NSArray *unusedClasses = _macho.unusedClassLists;
        self.currentLines = unusedClasses;
        [self showTexts:unusedClasses];
    }
}

- (MachOLayout *)findMachOLayout {
    if (_macho) {
        return _macho;
    }
    for (NSUInteger i = 0; i < _dataController.layouts.count; i ++) {
           if ([_dataController.layouts[i] isKindOfClass:[MachOLayout class]]) {
               _macho = _dataController.layouts[i];
               return _macho;
           }
    }
    return nil;
}

- (void)showTexts:(NSArray *)array {
    if (!_textContent) {
        self.textContent = [[NSTextView alloc] initWithFrame:CGRectMake(20, 20, self.window.frame.size.width - 40, self.window.frame.size.height - 80)];
        [self.window.contentView addSubview:self.textContent];
        self.textContent.backgroundColor = [NSColor whiteColor];
        self.textContent.editable = NO;
        self.textContent.textColor = [NSColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0];
        [self.textContent setMinSize:NSMakeSize(0.0, self.window.frame.size.height - 80)];
        [self.textContent setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
        [self.textContent setVerticallyResizable:YES];
        [self.textContent setHorizontallyResizable:NO];
        [self.textContent setAutoresizingMask:NSViewWidthSizable];
        [[self.textContent textContainer]setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
        [[self.textContent textContainer]setWidthTracksTextView:YES];
        [self.textContent setFont:[NSFont fontWithName:@"PingFang-SC-Regular" size:12.0]];
        [self.textContent setEditable:NO];
    }
    
    NSMutableString *log = [NSMutableString string];
    if (array.count <= 0) {
        _textContent.string = @"No Unused Classes";
    } else {
        int index = 0;
        for (NSString *clsName in array) {
            [log appendFormat:@"%d: %@\n", index, clsName];
            index ++;
        }
        _textContent.string = log;
        _fliterLines = log;
    }
    
    self.textView.documentView = _textContent;
}

- (IBAction)onExportClicked:(id)sender {

    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:[NSString stringWithFormat:@"UnusedClasses_%@.txt" ,[self.dateFormatter stringFromDate:[NSDate date]]]];
    [panel setMessage:@"Choose the path to save"];
    [panel setAllowsOtherFileTypes:YES];
    [panel setAllowedFileTypes:@[@".txt"]];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            NSString *path = [[panel URL] path];
                        [self.fliterLines writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

@end
