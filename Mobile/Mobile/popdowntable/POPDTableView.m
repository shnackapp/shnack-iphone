//
//  POPDTableView.m
//  Mobile
//
//  Created by Jake Staahl on 4/23/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "POPDTableView.h"


/*
 #define TABLECOLOR [UIColor colorWithRed:62.0/255.0 green:76.0/255.0 blue:87.0/255.0 alpha:1.0]
 #define SUBCELL [UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:1.0]
 #define CELLSELECTED [UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:1.0]
 #define SEPARATOR [UIColor colorWithRed:31.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:1.0]
 #define SEPSHADOW [UIColor colorWithRed:80.0/255.0 green:97.0/255.0 blue:110.0/255.0 alpha:1.0]
 #define SHADOW [UIColor colorWithRed:69.0/255.0 green:84.0/255.0 blue:95.0/255.0 alpha:1.0]
 #define TEXT [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:213.0/255.0 alpha:1.0]
 */

@interface POPDTableView () <UIGestureRecognizerDelegate>
@property NSArray *sections;
@property (strong, nonatomic) NSMutableArray *sectionsArray;
@property (strong, nonatomic) NSMutableArray *showingArray;
@property (nonatomic) BOOL isLoading;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) POPDCell *headerCell;
@property (strong, nonatomic) UIButton *headerButton;
@property (nonatomic) NSInteger currentHeaderSection;
@property (nonatomic) float headerHeight;
@property (nonatomic) BOOL startingScrollIsSet;
@property (nonatomic) float startingScrollY;
@property (nonatomic) BOOL sectionIsClosing;
@property (nonatomic) BOOL sectionIsOpening;
@property (strong, nonatomic) NSIndexPath *openingIndexPath;
@end


@implementation POPDTableView

-(void)initPopDownTable {
    self.delegate = self;
    self.dataSource = self;
    
    self.startingScrollIsSet = NO;
    self.currentHeaderSection = -100;
    self.sectionIsClosing = NO;
    self.sectionIsOpening = NO;
    
    static NSString *cellIdentifier = @"POPDOpenedCategoryCell";
    
    
    
    self.headerCell = [self dequeueReusableCellWithIdentifier:cellIdentifier];
    //self.headerHeight = self.headerCell.frame.size.height;
    //NSLog(@"header height: %f", self.headerHeight);
    self.headerCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headerButton.frame = self.headerCell.frame;
    [self.headerButton addTarget:self action:@selector(didSelectHeaderView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headerView = [[UIView alloc] initWithFrame:self.headerCell.frame];
    
    [self.headerView addSubview:self.headerCell];
    [self.headerView addSubview:self.headerButton];
    
    self.headerView.hidden = YES;
    
    /////////////////////////////////////////////////////////////
    
    [self addSubview:self.headerView];
    [self bringSubviewToFront:self.headerView];
    
    self.isLoading = NO;
    self.sectionsArray = [NSMutableArray new];
    self.showingArray = [NSMutableArray new];
    [self setMenuSections:self.sections];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.startingScrollY = 0;
    self.startingScrollIsSet = YES;

}

//- (void)swipeCell:(JZSwipeCell*)cell triggeredSwipeWithType:(JZSwipeType)swipeType
//
//{
//    if (swipeType != JZSwipeTypeNone)
//    {
//        NSIndexPath *indexPath = [self indexPathForCell:cell];
//        
//        //[self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
//        //[tableData removeObjectAtIndex:indexPath.row];
//        //[self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        // add conditional statement for swipeType
//    }
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPopDownTable];
    }
    return self;
}



-(id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initPopDownTable];
    }
    return self;
}

- (id)initWithMenuSections:(NSArray *) menuSections
{
    self = [super init];
    if (self) {
        self.sections = menuSections;
        [self initPopDownTable];
    }
    return self;
}

- (void)setLoading:(BOOL)loading {
    self.isLoading = loading;
    [self reloadData];
}

- (void)setMenuSections:(NSArray *)menuSections{
    
    for (NSDictionary *sec in menuSections) {
        
        NSString *header = [sec objectForKey:POPDCategoryTitleTV];
        NSArray *subSection = [sec objectForKey:POPDSubSectionTV];
        
        NSMutableArray *section;
        section = [NSMutableArray new];
        [section addObject:header];
        
        if (subSection != nil && (id)subSection != [NSNull null]) {
            for (NSString *sub in subSection) {
                [section addObject:sub];
            }
        } else {
            [section addObject:[NSNull null]];
        }
        
        [self.sectionsArray addObject:section];
        [self.showingArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self reloadData];
}

- (void)setMenuSections:(NSArray *)menuSections withAllSectionsOpen:(BOOL)open {
    for (NSDictionary *sec in menuSections) {
        
        NSString *header = [sec objectForKey:POPDCategoryTitleTV];
        NSArray *subSection = [sec objectForKey:POPDSubSectionTV];
        
        NSMutableArray *section;
        section = [NSMutableArray new];
        [section addObject:header];
        
        if (subSection != nil && (id)subSection != [NSNull null]) {
            for (NSString *sub in subSection) {
                [section addObject:sub];
            }
        } else {
            [section addObject:[NSNull null]];
        }
        
        [self.sectionsArray addObject:section];
        [self.showingArray addObject:[NSNumber numberWithBool:open]];
    }
    
    [self reloadData];
}

- (void)setMenuSection:(NSDictionary *)menuSection atSection:(NSInteger)sectionIndex {
    NSString *header = [menuSection objectForKey:POPDCategoryTitleTV];
    NSArray *subSection = [menuSection objectForKey:POPDSubSectionTV];
    
    NSMutableArray *section;
    section = [NSMutableArray new];
    [section addObject:header];
    
    if (subSection != nil && (id)subSection != [NSNull null]) {
        for (NSString *sub in subSection) {
            [section addObject:sub];
        }
    } else {
        [section addObject:[NSNull null]];
    }
    
    [self.sectionsArray replaceObjectAtIndex:sectionIndex withObject:section];
    [self reloadCategoryAtSection:sectionIndex];
}

- (void)setMenuSection:(NSDictionary *)menuSection atSection:(NSInteger)sectionIndex withSectionOpen:(BOOL)open {
    NSString *header = [menuSection objectForKey:POPDCategoryTitleTV];
    NSArray *subSection = [menuSection objectForKey:POPDSubSectionTV];
    
    NSMutableArray *section;
    section = [NSMutableArray new];
    [section addObject:header];
    
    if (subSection != nil && (id)subSection != [NSNull null]) {
        for (NSString *sub in subSection) {
            [section addObject:sub];
        }
    } else {
        [section addObject:[NSNull null]];
    }
    
    [self.sectionsArray replaceObjectAtIndex:sectionIndex withObject:section];
    [self.showingArray setObject:[NSNumber numberWithBool:open] atIndexedSubscript:sectionIndex];
    [self reloadCategoryAtSection:sectionIndex];
}

- (void)setMenuSectionChildren:(NSArray *)children atSection:(NSInteger)sectionIndex {
    NSString *header = [[self.sectionsArray objectAtIndex:sectionIndex] objectAtIndex:0];
    
    NSMutableArray *section;
    section = [NSMutableArray new];
    [section addObject:header];
    
    if (children != nil && (id)children != [NSNull null]) {
        for (NSString *sub in children) {
            [section addObject:sub];
        }
    } else {
        [section addObject:[NSNull null]];
    }
    
    [self.sectionsArray replaceObjectAtIndex:sectionIndex withObject:section];
    [self reloadCategoryAtSection:sectionIndex];
}

#pragma mark - Table view data source

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if ([self.sectionsArray count] > 0) {
        [self updateHeaderView];
    }
}

- (void)updateHeaderView {
    if (!self.startingScrollIsSet) {
        self.startingScrollY = self.contentOffset.y;
        self.startingScrollIsSet = YES;
    }
    
    NSIndexPath *indexPath1 = [self indexPathForRowAtPoint:CGPointMake(0, self.contentOffset.y - self.startingScrollY)];
    //NSIndexPath *indexPath2 = [self.tableView indexPathForRowAtPoint:CGPointMake(0, self.tableView.contentOffset.y - self.startingScrollY + self.headerHeight)];
    NSIndexPath *indexPath2 = [self indexPathForRowAtPoint:CGPointMake(0, self.contentOffset.y - self.startingScrollY + self.headerCell.frame.size.height)];
    
    if(indexPath2.row > 0) {
        NSLog(@"1");
        if (self.currentHeaderSection != indexPath2.section) {
            NSLog(@"2");
            self.currentHeaderSection = indexPath2.section;
            if ([self.popDownDelegate respondsToSelector:@selector(willDisplayOpenedCategoryCell:atIndexPath:)]) {
                [self.popDownDelegate willDisplayOpenedCategoryCell:self.headerCell atIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentHeaderSection]];
            } else {
                self.headerCell.labelText.text = [self.sectionsArray[self.currentHeaderSection] objectAtIndex:0];
            }
        }
        self.headerView.hidden = NO;
        CGRect frame = CGRectMake(0, self.contentOffset.y - self.startingScrollY, [[UIScreen mainScreen] bounds].size.width, self.headerView.frame.size.height);
        self.headerView.frame = frame;
    } else if (indexPath1.row > 0) {
        if (self.currentHeaderSection != indexPath1.section) {
            NSLog(@"3");
            self.currentHeaderSection = indexPath1.section;
            if ([self.popDownDelegate respondsToSelector:@selector(willDisplayOpenedCategoryCell:atIndexPath:)]) {
                [self.popDownDelegate willDisplayOpenedCategoryCell:self.headerCell atIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentHeaderSection]];
            } else {
                self.headerCell.labelText.text = [[self.sectionsArray objectAtIndex:self.currentHeaderSection] objectAtIndex:0];
            }
        }
        CGRect frame;
        if (indexPath2.row == 0 && indexPath2.section == 0) {
            frame = CGRectMake(0, self.contentOffset.y - self.startingScrollY, [[UIScreen mainScreen] bounds].size.width, self.headerView.frame.size.height);
        } else {
            CGRect nextRect = [self rectForRowAtIndexPath:indexPath2];
            //frame = CGRectMake(0, nextRect.origin.y - self.headerHeight, [[UIScreen mainScreen] bounds].size.width, self.headerView.frame.size.height);
            frame = CGRectMake(0, nextRect.origin.y - self.headerCell.frame.size.height, [[UIScreen mainScreen] bounds].size.width, self.headerView.frame.size.height);
        }
        NSLog(@"4    :%ld, %ld", (long)indexPath2.section, (long)indexPath2.row);
        self.headerView.frame = frame;
        self.headerView.hidden = NO;
    } else {
        NSLog(@"5");
        self.headerView.hidden = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numSections = [self.sectionsArray count];
    if ([self.sectionsArray count] == 0 || self.isLoading) {
        return 1;
    }
    
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentHeaderSection == section) {
        if ([self.popDownDelegate respondsToSelector:@selector(willDisplayOpenedCategoryCell:atIndexPath:)]) {
            [self.popDownDelegate willDisplayOpenedCategoryCell:self.headerCell atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        } else {
            self.headerCell.labelText.text = [[self.sectionsArray objectAtIndex:section] objectAtIndex:0];
        }
    }
    
    //if there are is no data at all to show (should display the POPDEmpty cell), or this section is not expanded
    if ([self.sectionsArray count] == 0 || self.isLoading || ![[self.showingArray objectAtIndex:section]boolValue]) {
        return 1;
    }
    else {
        return 1 + [self numberOfChildrenInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POPDCell *cell = nil;
    
    if (self.isLoading) {
        static NSString *cellIdentifier = @"POPDLoading";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    }
    else if ([self.sectionsArray count] == 0) {
        static NSString *cellIdentifier = @"POPDEmpty";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.row == 0) {
        if ([self sectionIsLeaf:indexPath.section]) {
            static NSString *cellIdentifier = @"POPDLeafCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if ([self.popDownDelegate respondsToSelector:@selector(willDisplayLeafCell:atIndexPath:)]) {
                [self.popDownDelegate willDisplayLeafCell:cell atIndexPath:indexPath];
            } else {
                cell.labelText.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            }
        }
        else if ([[self.showingArray objectAtIndex:indexPath.section] boolValue]) {
            static NSString *cellIdentifier = @"POPDOpenedCategoryCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            //cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            if ([self.popDownDelegate respondsToSelector:@selector(willDisplayOpenedCategoryCell:atIndexPath:)]) {
                [self.popDownDelegate willDisplayOpenedCategoryCell:cell atIndexPath:indexPath];
            } else {
                cell.labelText.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            }
        } else {
            static NSString *cellIdentifier = @"POPDClosedCategoryCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if ([self.popDownDelegate respondsToSelector:@selector(willDisplayClosedCategoryCell:atIndexPath:)]) {
                [self.popDownDelegate willDisplayClosedCategoryCell:cell atIndexPath:indexPath];
            } else {
                cell.labelText.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            }
        }
    } else {
        static NSString *cellIdentifier = @"POPDLeafSubCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if ([self.popDownDelegate respondsToSelector:@selector(willDisplayLeafSubCell:atIndexPath:)]) {
            [self.popDownDelegate willDisplayLeafSubCell:cell atIndexPath:indexPath];
        } else {
            cell.labelText.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
    }
    
    cell.indexPath = indexPath;
    return cell;
}

- (void)reloadCategoryAtSection:(NSInteger)sectionIndex {
    [self reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didSelectHeaderView:(id)obj {
    self.headerView.hidden =  YES;
    [self tableView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentHeaderSection]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && ![self sectionIsLeaf:indexPath.section]) {
        if ([self.popDownDelegate respondsToSelector:@selector(didSelectCategoryRowAtIndexPath:)]) {
            [self.popDownDelegate didSelectCategoryRowAtIndexPath:indexPath];
        }
        if([[self.showingArray objectAtIndex:indexPath.section] boolValue]){ //close the section
            [self.showingArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:indexPath.section];
            self.sectionIsClosing = YES;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else { //open the section
            [self.showingArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPath.section];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            self.sectionIsOpening = YES;
            self.openingIndexPath = indexPath;
        }
    } else {
        if ([self.popDownDelegate respondsToSelector:@selector(didSelectLeafRowAtIndexPath:)]) {
            [self.popDownDelegate didSelectLeafRowAtIndexPath:indexPath];
        }
    }
    if ([self.popDownDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.popDownDelegate didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionIsClosing) {
        [self updateHeaderView];
        self.sectionIsClosing = NO;
    }
    if (self.sectionIsOpening) {
        [self scrollToRowAtIndexPath:self.openingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.sectionIsOpening = NO;
    }
}

- (BOOL)sectionIsLeaf:(NSUInteger) section {
    if ([[self.sectionsArray objectAtIndex:section] count] == 1) {
        return NO;
    } else if ([[self.sectionsArray objectAtIndex:section] objectAtIndex:1] != [NSNull null]) {
        return NO;
    }
    
    return YES;
}


- (NSInteger)numberOfChildrenInSection:(NSUInteger) section {
    if ([self sectionIsLeaf:section]) {
        return 0;
    }
    return [[self.sectionsArray objectAtIndex:section] count] - 1;
}


/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (indexPath.row != 0){
 if ([[self.showingArray objectAtIndex:indexPath.section] boolValue]){
 //[cell setBackgroundColor:SUBCELL];
 } else {
 //[cell setBackgroundColor:[UIColor clearColor]];
 }
 }
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
