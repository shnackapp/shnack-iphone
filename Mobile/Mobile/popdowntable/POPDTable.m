//
//  POPDViewController.m
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import "POPDTable.h"
#import "POPDCell.h"

/*
#define TABLECOLOR [UIColor colorWithRed:62.0/255.0 green:76.0/255.0 blue:87.0/255.0 alpha:1.0]
#define SUBCELL [UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:1.0]
#define CELLSELECTED [UIColor colorWithRed:52.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:1.0]
#define SEPARATOR [UIColor colorWithRed:31.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:1.0]
#define SEPSHADOW [UIColor colorWithRed:80.0/255.0 green:97.0/255.0 blue:110.0/255.0 alpha:1.0]
#define SHADOW [UIColor colorWithRed:69.0/255.0 green:84.0/255.0 blue:95.0/255.0 alpha:1.0]
#define TEXT [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:213.0/255.0 alpha:1.0]
*/

@interface POPDTable ()
@property NSArray *sections;
@property (strong, nonatomic) NSMutableArray *sectionsArray;
@property (strong, nonatomic) NSMutableArray *showingArray;
@end


@implementation POPDTable
@synthesize delegate;

- (id)initWithMenuSections:(NSArray *) menuSections
{
    self = [super init];
    if (self) {
        self.sections = menuSections;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sectionsArray = [NSMutableArray new];
    self.showingArray = [NSMutableArray new];
    [self setMenuSections:self.sections];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setMenuSections:(NSArray *)menuSections{
    
    for (NSDictionary *sec in menuSections) {
        
        NSString *header = [sec objectForKey:POPDHeader];
        NSArray *subSection = [sec objectForKey:POPDSubSection];

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
    
    [self.tableView reloadData];
}

- (void)setMenuSection:(NSDictionary *)menuSection atSection:(NSInteger)sectionIndex {
    NSString *header = [menuSection objectForKey:POPDHeader];
    NSArray *subSection = [menuSection objectForKey:POPDSubSection];
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numSections = [self.sectionsArray count];
    if (numSections == 0) {
        return 1;
    }
    
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if there are is no data at all to show (should display the POPDEmpty cell), or this section is not expanded
    if ([self.sectionsArray count] == 0 || ![[self.showingArray objectAtIndex:section]boolValue]) {
        return 1;
    }
    else {
        return 1 + [self numberOfChildrenInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    POPDCell *cell = nil;
    if ([self.sectionsArray count] == 0) {
        static NSString *cellIdentifier = @"POPDEmpty";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.row == 0) {
        if ([self sectionIsLeaf:indexPath.section]) {
            static NSString *cellIdentifier = @"POPDLeafCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        }
        else if ([[self.showingArray objectAtIndex:indexPath.section] boolValue]) {
            static NSString *cellIdentifier = @"POPDOpenedCategoryCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        } else {
            static NSString *cellIdentifier = @"POPDClosedCategoryCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        }
    } else {
        static NSString *cellIdentifier = @"POPDLeafSubCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
    cell.labelText.text = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)reloadCategoryAtSection:(NSInteger)sectionIndex {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && ![self sectionIsLeaf:indexPath.section]) {
        if ([self.delegate respondsToSelector:@selector(didSelectCategoryRowAtIndexPath:)]) {
            [self.delegate didSelectCategoryRowAtIndexPath:indexPath];
        }
        if([[self.showingArray objectAtIndex:indexPath.section] boolValue]){
            [self.showingArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:indexPath.section];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.showingArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:indexPath.section];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(didSelectLeafRowAtIndexPath:)]) {
            [self.delegate didSelectLeafRowAtIndexPath:indexPath];
        }
    }
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.delegate didSelectRowAtIndexPath:indexPath];
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
