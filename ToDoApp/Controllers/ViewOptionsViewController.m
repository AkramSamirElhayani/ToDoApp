//
//  ViewOptionsViewController.m
//  ToDoApp
//
//  Created by Akram Elhayani on 30/01/2022.
//

#import "ViewOptionsViewController.h"

@interface ViewOptionsViewController ()

@end

@implementation ViewOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.presentationController.delegate = self;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
     
    _showItems .selectedSegmentIndex = [ def integerForKey:@"showItems"];
    _orderBy.selectedSegmentIndex = [ def integerForKey:@"orderBy"];
    _groupBy.selectedSegmentIndex = [ def integerForKey:@"groupBy"];
    
    
}
- (IBAction)groupByChnged:(id)sender {
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setInteger:_groupBy.selectedSegmentIndex forKey:@"groupBy"];
//    [_homeView ApplyGroupBy];
}
- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController{
    
    _homeView .navigationItem.title =[_showItems titleForSegmentAtIndex:  _showItems.selectedSegmentIndex];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:_showItems.selectedSegmentIndex forKey:@"showItems"];
    [def setInteger:_orderBy.selectedSegmentIndex forKey:@"orderBy"];
    [def setInteger:_groupBy.selectedSegmentIndex forKey:@"groupBy"];
    
    [_homeView RefreshDataSourc];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
