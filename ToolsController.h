//
//  ToolsController.h
//  MachOView
//
//  Created by Joey Cao on 2020/2/10.
//

#import <Cocoa/Cocoa.h>
@class MVDataController;
NS_ASSUME_NONNULL_BEGIN

@interface ToolsController : NSWindowController

- (instancetype)initWithDataController:(MVDataController *)dataController;

@end

NS_ASSUME_NONNULL_END
