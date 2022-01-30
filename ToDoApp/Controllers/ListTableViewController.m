//
//  ListTableViewController.m
//  ToDoApp
//
//  Created by Akram Elhayani on 27/01/2022.
//

#import "ListTableViewController.h"
#import "ToDoObject.h"
#import "AddEditObjectViewController.h"
#import "CustomeTableViewCell.h"
#import "ViewOptionsViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ListTableViewController ()
{
    NSMutableArray<ToDoObject *> *dataSource;
    NSMutableArray<ToDoObject *> *filterdDataSource;
    NSMutableArray *groupedDataSource;
    bool IsFilterd;
 
    NSInteger  groupBy ;
    NSInteger  itemFiltring ;
    NSInteger  orderBy  ;
}
@property (weak, nonatomic) IBOutlet UIImageView *noDataImage;

@end

@implementation ListTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [NSMutableArray new ];
    groupedDataSource = [NSMutableArray new ];
    filterdDataSource = dataSource;
    IsFilterd = NO;
    [self loadSavedData];
    [self  addNotfications];
    _searchBar.delegate = self ;
    [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self LoadData];
}

// Loads Saved Data
-(void) loadSavedData{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *savedData =[def objectForKey:@"todoItems"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingFromData:savedData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    NSMutableArray<ToDoObject *> *arr  =[unarchiver decodeObject];
    if(arr != nil){
        dataSource = arr;
        filterdDataSource=dataSource;
    }
}

- (IBAction)addClicked:(id)sender {
    AddEditObjectViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditObjectView"];
    view.State = Adding;
    view.dataSource = dataSource;
    view.homeView = self ;
    [self presentViewController:view animated:YES completion:nil];
}

// Refresh data source and clear search after adding or filtering
- (void)RefreshDataSourc{
    filterdDataSource = dataSource;
    [self LoadData];
}

 
// add notfication For all items
-(void) addNotfications{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound+
                                             UNAuthorizationOptionBadge+UNAuthorizationOptionProvisional
                                             +UNAuthorizationOptionCriticalAlert)
       completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
    [center removeAllPendingNotificationRequests];
    for (int i = 0 ; i<[dataSource count]; i++) {
    
        ToDoObject *obj =[dataSource objectAtIndex:i];
        if(obj .State != Done){
            [self addNotficationForObject:obj fromNotficationCenter:center];
        }
    }
}
// add notfication From Item with notfication Center
-(void) addNotficationForObject:(ToDoObject*)obj fromNotficationCenter:(UNUserNotificationCenter*)center{
    
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:obj.Name arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:obj.Description
            arguments:nil];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute| NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:obj.CreationDate];
    NSDateComponents* date = [[NSDateComponents alloc] init];
    NSInteger hour = components .hour;
    NSInteger minute = components .minute;
    date.hour =hour;
    date.minute =minute;
    
    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger
        triggerWithDateMatchingComponents:date repeats:NO];
    // Create the request object.
    UNNotificationRequest* request = [UNNotificationRequest
           requestWithIdentifier:@"Alert" content:content trigger:trigger];
     
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
       if (error != nil) {
           NSLog(@"%@", error.localizedDescription);
       }
    }];
    printf("\n notfication add at %li  %li ",hour,minute);
  
}
-(void) addNotficationForObject:(ToDoObject*)obj {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound+
                                             UNAuthorizationOptionBadge+UNAuthorizationOptionProvisional
                                             +UNAuthorizationOptionCriticalAlert)
       completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
    [self addNotficationForObject:obj fromNotficationCenter:center];
}


- (IBAction)optionsClicked:(id)sender {
    
    ViewOptionsViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewOptionsView"];
    view.homeView = self ;
    [self presentViewController:view animated:YES completion:nil];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if([searchText isEqual:@""]){
        filterdDataSource =dataSource;
        [self LoadData];
        return;
    }
  
    //NSString *qurey = [[@"Name LIKE[sd]  '"stringByAppendingString:[searchText lowercaseString]]stringByAppendingString:@"'"];
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"self.Name LIKE[cd] %@",searchText];
    //NSPredicate *predicte = [NSPredicate predicateWithFormat:qurey];
    filterdDataSource = [dataSource filteredArrayUsingPredicate:predicte];
    [self LoadData];
    
}
//Load Data and apply filtring and grouping
-(void)LoadData{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    groupBy = [ def integerForKey:@"groupBy"];
    itemFiltring = [ def integerForKey:@"showItems"];
    orderBy = [ def integerForKey:@"orderBy"];
    
    [self ApplyItemFiltring];
    [self ApplyOrderBy];
    [self ApplyGroupBy];
    [_tableView reloadData];
    if([filterdDataSource count ]== 0 ){
        _noDataImage.hidden = NO;
        _tableView.hidden=YES;
        printf("\nNoData");
    }else{
        _noDataImage.hidden = YES;
        _tableView.hidden=NO;
        printf("\nHas Data");
    }
    
}
-(void) ApplyItemFiltring{
    NSString *qurey ;
    switch (itemFiltring) {
        case 0:
          //  filterdDataSource = filterdDataSource;
            return;
            break;
          
        case 1:
            qurey = @"State = 0";
            break;
        case 2:
            qurey = @"State = 1";
            break;
        case 3:
            qurey = @"State = 2";
            break;
    }
 
    NSPredicate *predicte = [NSPredicate predicateWithFormat:qurey];
    filterdDataSource = [filterdDataSource filteredArrayUsingPredicate:predicte];
    
}

-(void) ApplyOrderBy{
    
    NSString *qurey ;
    switch (orderBy) {
        case 0:
            qurey = @"Priorty";
            break;
        case 1:
            qurey = @"State";
            break;
        case 2:
            qurey = @"CreationDate";
            break;
    }
    filterdDataSource = [filterdDataSource sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:qurey ascending:NO]]];
}
-(void)ApplyGroupBy{
 
    NSString *   qurey =(groupBy==0)? @"Priorty = 0": @"State = 0";
    NSPredicate *predicte = [NSPredicate predicateWithFormat:qurey];
    NSArray *arr0 = [filterdDataSource filteredArrayUsingPredicate:predicte];
    
    
    qurey =(groupBy==0)? @"Priorty = 1": @"State = 1";
    predicte = [NSPredicate predicateWithFormat:qurey];
    NSArray *arr1 = [filterdDataSource filteredArrayUsingPredicate:predicte];
    
    qurey =(groupBy==0)? @"Priorty = 2": @"State = 2";
    predicte = [NSPredicate predicateWithFormat:qurey];
    NSArray *arr2 = [filterdDataSource filteredArrayUsingPredicate:predicte];
    
    [groupedDataSource removeAllObjects];
    [groupedDataSource addObject:arr0];
    [groupedDataSource addObject:arr1];
    [groupedDataSource addObject:arr2];
  
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar endEditing:YES];
}



#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[UIView new];
  //  headerView.backgroundColor = UIColor.lightGrayColor;
    headerView.layer.cornerRadius = 5;
    headerView.layer.masksToBounds = true;
    CGRect rect = CGRectMake(10, 20,tableView.bounds.size.width, tableView.bounds.size.height);
    UILabel *sectionLabel =[[UILabel alloc]initWithFrame: rect];
    UIFont *font = [UIFont  fontWithName: @"Helvetica" size: 16];
    
    UIFont *boldFont = [UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:font.pointSize];
    sectionLabel.font = boldFont;
    sectionLabel.textColor = UIColor.darkTextColor;
     
    [sectionLabel sizeToFit];
    [headerView addSubview:sectionLabel];

    NSArray<ToDoObject*> *data = [groupedDataSource objectAtIndex:section];
    NSString *title = nil ;
    if([data count] > 0 ){

        switch (section) {
            case 0:
                title=(groupBy==0)? @"Low": @"Todo";
                break;
            case 1:
                title=(groupBy==0)? @"Mediam": @"Inprogress";
                break;
            case 2:
                title=(groupBy==0)? @"High": @"Done";
                break;
            default:
                break;
        }
    }
    
    sectionLabel.text = title;
    [sectionLabel sizeToFit];
    return headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [groupedDataSource count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray<ToDoObject*> *data = [groupedDataSource objectAtIndex:section];
    return [data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
   // NSArray<ToDoObject*> *data = [groupedDataSource objectAtIndex:indexPath.section];
    ToDoObject  *obj = [dataSource objectAtIndex:[self getObjectIndex:indexPath]];
    cell.NameLable.text = obj.Name;
    cell.descriptionLable.text = obj.Description;
    switch (obj.Priorty) {
        case High:
            cell.imgPriorty.image = [UIImage imageNamed:@"2"];
            break;
        case Mediam:
            cell.imgPriorty.image = [UIImage imageNamed:@"1"];
            break;
        case Low:
            cell.imgPriorty.image = [UIImage imageNamed:@"0"];
            break;
    }
    cell .imgFile.image = obj.Attachiment;
    switch (obj.State) {
        case Done:
            cell.NameLable.textColor = UIColor.systemGrayColor;
            cell.imgPriorty.image = [UIImage imageNamed:@"done"];
            cell.progressLable.text = @"Done";
            cell.progressLable.backgroundColor = UIColor.systemGray5Color;
            break;
        case InProgress:
            cell.NameLable.textColor = UIColor.blackColor;
            cell.progressLable.text = @"Inprogress";
            cell.progressLable.backgroundColor = UIColor.systemYellowColor;
            break;
        case ToDO:
            cell.NameLable.textColor = UIColor.blackColor;
            cell.progressLable.text = @"Todo";
            cell.progressLable.backgroundColor = UIColor.systemGreenColor;
            break;
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete this item ?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *discard =[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:
                                 
                                 ^(UIAlertAction * _Nonnull action) {
            //TODO Handle Delete While Search
       
            
            [self->dataSource removeObjectAtIndex:[self getObjectIndex:indexPath]];
            groupedDataSource = [NSMutableArray new ];
            filterdDataSource = dataSource;
            [self LoadData];
            [self SaveDataIntoFile];
        } ];
        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:discard];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
-(int)getObjectIndex:(NSIndexPath *)indexPath{
    
    NSArray<ToDoObject*> *data = [groupedDataSource objectAtIndex:indexPath.section];
    ToDoObject  *obj = [data objectAtIndex:indexPath.row];
    int index =[dataSource indexOfObject:obj];
    return index;
    
    
}
-(void) SaveDataIntoFile{
    NSKeyedArchiver *archiver  = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    [archiver encodeObject:dataSource];
    NSData *data =  [ archiver encodedData];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:data forKey:@"todoItems"];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO Get selected Object
    [self viewObject:[self getObjectIndex:indexPath]];
}
-(void) viewObject:(int)index{
 
 
    AddEditObjectViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEditObjectView"];
    view.currentObjectIndex = index;
    view.State = Editing;
    view.dataSource = dataSource;
    view.homeView = self ;
    [self presentViewController:view animated:YES completion:nil];
}
 
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ToDoObject *obj = [dataSource objectAtIndex:[self getObjectIndex:indexPath]];
    if(obj.State== Done)
        return nil;
    
    UIContextualAction *modifyAction =
    [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Update" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        if(obj.State== ToDO){
            
            obj.State = InProgress;
        } else{
            
            obj.State = Done;
        }
        completionHandler (true);
        [self  SaveDataIntoFile];
        [self LoadData];
    }];
    if(obj.State== ToDO){
        [ modifyAction setTitle: @"Mark As Inprogress"];
        modifyAction.backgroundColor = UIColor.systemOrangeColor;
         
    }
    
    else{
        [ modifyAction setTitle: @"Mark As Done"];
        modifyAction.backgroundColor = UIColor.systemGreenColor;
    }
       
    
    UISwipeActionsConfiguration *con =[UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithObject: modifyAction] ] ;


    return con;
}
@end
