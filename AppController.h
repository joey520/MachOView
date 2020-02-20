/*
 *  AppController.h
 *  MachOView
 *
 *  Created by psaghelyi on 15/06/2010.
 *
 */

#import <Cocoa/Cocoa.h>

@class MVPreferenceController;
@class ToolsController;
@class MVDocument;

@interface MVAppController : NSObject <NSApplicationDelegate,NSOpenSavePanelDelegate>
{
  MVPreferenceController * preferenceController;
    ToolsController *toolsController;
    MVDocument * myDocument;
}

- (IBAction)showPreferencePanel:(id)sender;
- (IBAction)attach:(id)sender;

@end




