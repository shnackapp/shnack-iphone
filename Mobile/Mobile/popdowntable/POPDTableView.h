#import <UIKit/UIKit.h>
<<<<<<< HEAD
#import "POPDCell.h"

=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
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

<<<<<<< HEAD

static NSString *POPDCategoryTitleTV = @"menuSectionHeader";
static NSString *POPDSubSectionTV = @"menuSubSection";
=======
#import "POPDCell.h"

static NSString *POPDCategoryTitle = @"menuSectionHeader";
static NSString *POPDSubSection = @"menuSubSection";
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a


@protocol POPDDelegate <NSObject>

@optional
//gets called when the row clicked is a leaf (no children)
//note: a category with an empty sub-section category is not a leaf. a category with nil or [NSNull null] sub-section is.
-(void) didSelectLeafRowAtIndexPath:(NSIndexPath *)indexPath;

//gets called the row clicked is a category
-(void) didSelectCategoryRowAtIndexPath:(NSIndexPath *)indexPath;

//gets called for selection of any row
-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void) willDisplayLeafCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void) willDisplayClosedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void) willDisplayOpenedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void) willDisplayLeafSubCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath;
<<<<<<< HEAD
//-(void)swipeCell:(JZSwipeCell*)cell triggeredSwipeWithType:(JZSwipeType)swipeType;

=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
@end


@interface POPDTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
- (id)initWithMenuSections:(NSArray *) menuSections;
- (void)reloadCategoryAtSection:(NSInteger)sectionIndex;
- (void)setLoading:(BOOL)loading;
- (void)setMenuSections:(NSArray *)menuSections;

- (void)setMenuSections:(NSArray *)menuSections withAllSectionsOpen:(BOOL)open;
- (void)setMenuSection:(NSDictionary *)menuSection atSection:(NSInteger)sectionIndex;
- (void)setMenuSection:(NSDictionary *)menuSection atSection:(NSInteger)sectionIndex withSectionOpen:(BOOL)open;
- (void)setMenuSectionChildren:(NSArray *)children atSection:(NSInteger)sectionIndex;
- (BOOL)sectionIsLeaf:(NSUInteger) section;
- (NSInteger)numberOfChildrenInSection:(NSUInteger) section;
@property (MB_WEAK) id<POPDDelegate> popDownDelegate;

@end
