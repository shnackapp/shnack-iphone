//
//  POPDViewController.h
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef MB_STRONG
#if __has_feature(objc_arc)
#define MB_STRONG strong
#else
#define MB_STRONG retain
#endif
#endif

#ifndef MB_WEAK
#if __has_feature(objc_arc_weak)
#define MB_WEAK weak
#elif __has_feature(objc_arc)
#define MB_WEAK unsafe_unretained
#else
#define MB_WEAK assign
#endif
#endif

static NSString *POPDHeader = @"menuSectionHeader";
static NSString *POPDSubSection = @"menuSubSection";


@protocol POPDDelegate <NSObject>

@optional
//gets called the row clicked is a leaf (no children)
//note: a category with an empty sub-section category is not a leaf. a category with nil or [NSNull null] sub-section is.
-(void) didSelectLeafRowAtIndexPath:(NSIndexPath *)indexPath;

//gets called the row clicked is a category
-(void) didSelectCategoryRowAtIndexPath:(NSIndexPath *)indexPath;

//gets called for selection of any row
-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface POPDTable : UITableViewController
- (id)initWithMenuSections:(NSArray *) menuSections;
- (void)reloadCategoryAtSection:(NSInteger)sectionIndex;
- (void)setMenuSections:(NSArray *)menuSections;
- (void)setMenuSection:(NSDictionary *)menuSection atSection:(NSInteger)sectionIndex;
- (void)setMenuSectionChildren:(NSArray *)children atSection:(NSInteger)sectionIndex;
- (BOOL)sectionIsLeaf:(NSUInteger) section;
- (NSInteger)numberOfChildrenInSection:(NSUInteger) section;
@property (MB_WEAK) id<POPDDelegate> delegate;

@end
