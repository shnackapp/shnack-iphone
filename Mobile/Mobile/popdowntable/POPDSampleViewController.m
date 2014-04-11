//
//  POPDSampleViewController.m
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import "POPDSampleViewController.h"
#import "POPDTable.h"

@interface POPDSampleViewController()<POPDDelegate> 

@end

@implementation POPDSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *sucSectionsA = [NSArray arrayWithObjects:@"7th Inning Stretch",@"Dippin' Dots", nil];
    NSArray *sucSectionsB = [NSArray arrayWithObjects:@"Subway",@"In 'N Out",@"Beer Garden", nil];

    NSDictionary *sectionA = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Dodger Stadium", POPDHeader,
                                    sucSectionsA, POPDSubSection,
                                    nil];
    
    NSDictionary *sectionB = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"Madison Square Garden", POPDHeader,
                        sucSectionsB, POPDSubSection,
                        nil];
    
    NSDictionary *sectionC = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Coffee Collab", POPDHeader,
                              nil, POPDSubSection,
                              nil];
    
    NSDictionary *sectionD = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"South Coast Deli", POPDHeader,
                              nil, POPDSubSection,
                              nil];
    
    NSArray *menu = [NSArray arrayWithObjects:sectionA,sectionC,sectionB,sectionD,nil];
    [self setMenuSections:menu];
    self.delegate = self;
}

#pragma mark POPDViewController delegate

/*
-(void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"didSelectRowAtIndexPath: %d,%d",indexPath.section,indexPath.row);

}
 */


-(void) didSelectLeafRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"didSelecLeaftRowAtIndexPath: %d,%d",indexPath.section,indexPath.row);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
