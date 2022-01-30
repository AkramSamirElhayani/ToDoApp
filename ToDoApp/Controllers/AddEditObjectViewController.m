//
//  AddEditObjectViewController.m
//  ToDoApp
//
//  Created by Akram Elhayani on 27/01/2022.
//

#import "AddEditObjectViewController.h"
@interface AddEditObjectViewController ()
{
    UIImagePickerController *imagePicker;
    UIImage *image;
    BOOL changesMade;
    

}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UISegmentedControl *priortySegmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteImageButton;

@end

@implementation AddEditObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _imageView.hidden = YES;
    _deleteImageButton.hidden =YES;
    
    if(_State == Editing){
         ToDoObject *obj = [_dataSource objectAtIndex:_currentObjectIndex];
         [self loadDataFromObject:obj];
    
     }
    
    
    _descriptionTextView.delegate =self;
    [self textViewDidEndEditing:_descriptionTextView];
    self.presentationController.delegate = self;
    changesMade = NO;
}
 
-(void)loadDataFromObject:(ToDoObject*)obj{
    _nameTextField.text =    obj.Name;
    if(![obj.description isEqual:@""])
        _descriptionTextView.text =  obj.Description ;
    _priortySegmentedControl.selectedSegmentIndex =   obj.Priorty ;
    _datePicker.date= obj.CreationDate;
    if(obj.Attachiment){
        _imageView.image =obj.Attachiment ;
        _imageView.hidden = NO;
        _deleteImageButton.hidden =NO;
        _addImageButton.hidden =YES;
    }
}
-(IBAction)editingChanged:(id)sender {
    _doneButton.enabled =![_nameTextField.text isEqual: @""];
    changesMade = YES;
}
-(bool)save{
    if([_nameTextField.text isEqual: @""])
        return NO;
    
    ToDoObject *obj ;
    if(_State == Adding){
    obj = [[ToDoObject alloc] initWithName:_nameTextField.text andDescription:_descriptionTextView.text];
        [_dataSource addObject:obj];
        [_homeView addNotficationForObject:obj];
    }
    else{
        obj = [_dataSource objectAtIndex:_currentObjectIndex];
    }
    [self loadDataIntoObject:obj];
    
    [self.homeView SaveDataIntoFile];
    return YES;
}

-(void)loadDataIntoObject:(ToDoObject*)obj{
    
    obj.Name = _nameTextField.text;
    obj.Description =(_descriptionTextView.textColor == UIColor.placeholderTextColor)?@"":
    _descriptionTextView.text;
    obj.Priorty =(enum Priorty)_priortySegmentedControl.selectedSegmentIndex;
    obj.CreationDate = _datePicker.date;
    obj.Attachiment = _imageView.image;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(textView .textColor == UIColor.placeholderTextColor&& [textView isFirstResponder]){
        textView .text = NULL;
        textView.textColor =_nameTextField.textColor;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if([textView .text isEqual:@""]){
        textView .text = @"Description";
        textView.textColor = UIColor.placeholderTextColor;
    }
    [self editingChanged:textView];
}
- (void)textViewDidChange:(UITextView *)textView{
    [self editingChanged:textView];
}
- (IBAction)priortySegmentChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            sender.backgroundColor = UIColor.systemGreenColor;
            break;
        case 1:
            sender.backgroundColor = UIColor.systemOrangeColor;
            break;
        case 2:
            sender.backgroundColor = UIColor.systemRedColor;
            break;
    }
}
- (IBAction)doneClicked:(id)sender {
    if( [self save]){
        [self dismissViewControllerAnimated:YES completion:NULL];
        [self.homeView RefreshDataSourc];
    }
 
}
- (IBAction)CancelClicked:(id)sender {
    if(changesMade == NO){
        [self Close];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm Closing Without Saving" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *discard =[UIAlertAction actionWithTitle:@"Discard Changes" style:UIAlertActionStyleDestructive handler:
                                 
                                 ^(UIAlertAction * _Nonnull action) {
        [self Close];
        
    } ];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:discard];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(void) Close{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (BOOL)presentationControllerShouldDismiss:(UIPresentationController *)presentationController{
    [self CancelClicked:nil];
    return NO;
}

- (IBAction)addImage:(id)sender {
    
      imagePicker =  [UIImagePickerController new];
      imagePicker.delegate = self;
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
      [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}

-(void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info {
    image = [info  objectForKey:UIImagePickerControllerOriginalImage];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
  
    if(image){
        self.imageView.image = image;
        _imageView.hidden = NO;
        _deleteImageButton.hidden =NO;
        _addImageButton.hidden =YES;
        [self editingChanged:picker];
    }
    
}

- (IBAction)deleteImage:(id)sender {
    
    self.imageView.image = nil;
     _imageView.hidden = YES;
    _deleteImageButton.hidden =YES;
    _addImageButton.hidden =NO;
    [self editingChanged:sender];
}

 

@end
