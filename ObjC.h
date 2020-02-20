/*
 *  ObjC.h
 *  MachOView
 *
 *  Created by Peter Saghelyi on 17/10/2011.
 *
 */

#import "MachOLayout.h"

struct class64_t
{
  uint64_t isa;               // class_t * (64-bit pointer)
  uint64_t superclass;        // class_t * (64-bit pointer)
  uint64_t cache;             // Cache (64-bit pointer)
  uint64_t vtable;            // IMP * (64-bit pointer)
  uint64_t data;              // class_ro_t * (64-bit pointer)
};

struct class64_ro_t
{
  uint32_t flags;
  uint32_t instanceStart;
  uint32_t instanceSize;
  uint32_t reserved;
  uint64_t ivarLayout;        // const uint8_t * (64-bit pointer)
  uint64_t name;              // const char * (64-bit pointer)
  uint64_t baseMethods;       // const method_list_t * (64-bit pointer)
  uint64_t baseProtocols;     // const protocol_list_t * (64-bit pointer)
  uint64_t ivars;             // const ivar_list_t * (64-bit pointer)
  uint64_t weakIvarLayout;    // const uint8_t * (64-bit pointer)
  uint64_t baseProperties;    // const struct objc_property_list * (64-bit pointer)
};


typedef std::vector<uint32_t> PointerVector;
typedef std::vector<uint64_t> Pointer64Vector;

@interface MachOLayout (ObjC)


- (MVNode *)createObjCCFStringsNode:(MVNode *)parent
                            caption:(NSString *)caption
                           location:(uint32_t)location
                             length:(uint32_t)length;

- (MVNode *)createObjCCFStrings64Node:(MVNode *)parent
                              caption:(NSString *)caption
                             location:(uint32_t)location
                               length:(uint32_t)length;

- (MVNode *)createObjCImageInfoNode:(MVNode *)parent
                            caption:(NSString *)caption
                           location:(uint32_t)location
                             length:(uint32_t)length;

- (MVNode *)createObjCModulesNode:(MVNode *)parent
                          caption:(NSString *)caption
                         location:(uint32_t)location
                           length:(uint32_t)length;

- (MVNode *)createObjCClassExtNode:(MVNode *)parent
                           caption:(NSString *)caption
                          location:(uint32_t)location
                            length:(uint32_t)length;

- (MVNode *)createObjCProtocolExtNode:(MVNode *)parent
                              caption:(NSString *)caption
                             location:(uint32_t)location
                               length:(uint32_t)length;

- (MVNode *)createObjC2PointerListNode:(MVNode *)parent
                               caption:(NSString *)caption
                              location:(uint32_t)location
                                length:(uint32_t)length
                              pointers:(PointerVector &)pointers;

- (MVNode *)createObjC2Pointer64ListNode:(MVNode *)parent
                                 caption:(NSString *)caption
                                location:(uint32_t)location
                                  length:(uint32_t)length
                                pointers:(Pointer64Vector &)pointers;

- (MVNode *)createObjC2MsgRefsNode:(MVNode *)parent
                           caption:(NSString *)caption
                          location:(uint32_t)location
                            length:(uint32_t)length;

- (MVNode *)createObjC2MsgRefs64Node:(MVNode *)parent
                             caption:(NSString *)caption
                            location:(uint32_t)location
                              length:(uint32_t)length;

-(void)parseObjC2ClassPointers:(PointerVector const *)classes
              CategoryPointers:(PointerVector const *)categories
              ProtocolPointers:(PointerVector const *)protocols;

-(void)parseObjC2Class64Pointers:(Pointer64Vector const *)classes
                       classNode:(MVNode *)classNode
              Category64Pointers:(Pointer64Vector const *)categories
                    categoryNode:(MVNode *)categoryNode
              Protocol64Pointers:(Pointer64Vector const *)protocols
                    protocolNode:(MVNode *)protocolNode;

@end
