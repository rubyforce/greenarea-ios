//
//  FTCameraViewController.m
//  Green Area 1.0
//
//  Created by DmVolk on 20.10.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#define TABBARHEIGHT 50

#import "FTCameraViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FTTextField.h"
#import <SVProgressHUD.h>

@interface FTCameraViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign, getter = isKeyboardVisible) BOOL keyboardVisible;
@property (nonatomic, assign) CGPoint scrollViewContentOffset;
@property (nonatomic, strong) id activeField;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) FTTextField *nameTextField;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UILabel *backProjectLabel;
@property (nonatomic, strong) UISwitch *backProjectSwitch;
@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, assign, getter = isPicking) BOOL picking;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign, getter = isLocationAvaibale) BOOL locationAvaibale;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) UIButton *uploadButton;

@property(nonatomic, assign) CGFloat scrollViewContentHeight;

@end

@implementation FTCameraViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Create";
    }
    return self;
}

- (NSString *)tabImageName
{
	return @"add-pin.png";
}

- (NSString *)tabTitle
{
	return self.title;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 50.0f;
    [self.locationManager startUpdatingLocation];
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapView];
    
    //upload button
    UIImage *uploadImage = [UIImage imageNamed:@"cloud-upload.png"];
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadButton addTarget:self action:@selector(uploadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.uploadButton.frame = CGRectMake(0.0, 0.0, uploadImage.size.width, uploadImage.size.height);
    [self.uploadButton setImage:uploadImage forState:UIControlStateNormal];
    UIBarButtonItem *uploadBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.uploadButton];
    self.navigationItem.rightBarButtonItem = uploadBarButton;
    
    //scrollView
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (screenRect.size.height == 480.0f) {
        //for 3.5 inch
        self.scrollViewContentHeight = 366.0f;
    } else {
        //for 4 inch
        self.scrollViewContentHeight = 454.0f;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                     self.view.bounds.origin.y,
                                                                     self.view.bounds.size.width,
                                                                    self.scrollViewContentHeight)];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 552);
    [self.view addSubview:self.scrollView];
    
    //imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, 300.0)];
    self.imageView.image = [UIImage imageNamed:@"taptoshoot.png"];
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = [[UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.1] CGColor];
    self.imageView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
    UITapGestureRecognizer *tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tapImageView];
    [self.scrollView addSubview:self.imageView];
    
    //name lable
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x,
                                                               self.imageView.frame.origin.y + self.imageView.frame.size.height + 10.0,
                                                               self.imageView.frame.size.width,
                                                               25.0)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *attributedNameLabelText = [[NSMutableAttributedString alloc] initWithString:@"Name:"];
    UIColor *nameLableTextColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.5];
    NSDictionary *nameLabelTextAttributes = @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:18.0],
    NSForegroundColorAttributeName : nameLableTextColor};
    [attributedNameLabelText setAttributes:nameLabelTextAttributes range:NSMakeRange(0, [attributedNameLabelText length])];
    self.nameLabel.attributedText = attributedNameLabelText;
    [self.scrollView addSubview:self.nameLabel];
    
    //name textField
    self.nameTextField = [[FTTextField alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x,
                                                                       self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10.0,
                                                                       self.nameLabel.frame.size.width,
                                                                       25.0)];
    self.nameTextField.delegate = self;
    self.nameTextField.layer.borderWidth = 0.5;
    self.nameTextField.layer.borderColor = [[UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.1] CGColor];
    self.nameTextField.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
    [self.nameTextField setBorderStyle:UITextBorderStyleNone];
    self.nameTextField.horizontalPadding = 7.0;
    [self.nameTextField setFont:[UIFont fontWithName: @"Avenir-Book" size:18.0]];
    self.nameTextField.placeholder = @"Type a name...";
    [self.scrollView addSubview:self.nameTextField];
    
    //description label
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameTextField.frame.origin.x,
                                                                      self.nameTextField.frame.origin.y + self.nameTextField.frame.size.height + 10.0,
                                                                      self.nameTextField.frame.size.width,
                                                                      25.0)];
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *attributedDescriptionLabelText = [[NSMutableAttributedString alloc] initWithString:@"Description:"];
    UIColor *descriptionLabelTextColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.5];
    NSDictionary *descriptionLabelTextAttributes = @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:18.0],
    NSForegroundColorAttributeName : descriptionLabelTextColor};
    [attributedDescriptionLabelText setAttributes:descriptionLabelTextAttributes range:NSMakeRange(0, [attributedDescriptionLabelText length])];
    self.descriptionLabel.attributedText = attributedDescriptionLabelText;
    [self.scrollView addSubview:self.descriptionLabel];
    
    //description textView
    self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.descriptionLabel.frame.origin.x,
                                                                            self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + 10.0,
                                                                            self.descriptionLabel.frame.size.width,
                                                                            80.0)];
    self.descriptionTextView.delegate = self;
    self.descriptionTextView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
    self.descriptionTextView.layer.borderWidth = 0.5;
    self.descriptionTextView.layer.borderColor = [[UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.1] CGColor];
    [self.descriptionTextView setFont:[UIFont fontWithName: @"Avenir-Book" size:18.0]];
    [self.scrollView addSubview:self.descriptionTextView];
    
    //back project label
    self.backProjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.descriptionTextView.frame.origin.x,
                                                                      self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 10.0,
                                                                      self.descriptionTextView.frame.size.width / 2,
                                                                      27.0)];
    self.backProjectLabel.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *attributedBackProjectLabelText = [[NSMutableAttributedString alloc] initWithString:@"Back this project"];
    UIColor *backProjectLabelTextColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.5];
    NSDictionary *backProjectLabelTextAttributes = @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:18.0],
    NSForegroundColorAttributeName : backProjectLabelTextColor};
    [attributedBackProjectLabelText setAttributes:backProjectLabelTextAttributes range:NSMakeRange(0, [attributedBackProjectLabelText length])];
    self.backProjectLabel.attributedText = attributedBackProjectLabelText;
    [self.scrollView addSubview:self.backProjectLabel];
    
    //back project switch
    self.backProjectSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.descriptionTextView.frame.size.width - 79.0,
                                                                        self.backProjectLabel.frame.origin.y,
                                                                        79.0,
                                                                        27.0)];
    [self.scrollView addSubview:self.backProjectSwitch];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateDisplay];
    
    //Registering for the event
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(keyboardDidShow:)
                                                  name:UIKeyboardDidShowNotification
                                                object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(keyboardDidHide:)
                                                  name:UIKeyboardDidHideNotification
                                                object:nil];
    //Initially the keyboard is hidden
    self.keyboardVisible = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    //Unregistering for the event
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardDidShow:(NSNotification *)notification
{
    NSLog(@"Keyboard is visible");
    //If keyboard is visible, return
    if (self.keyboardVisible) {
        NSLog(@"Keyboard is already visible. Ignore notification.");
        return;
    }
    
    //Get the size of the keyboard
    NSDictionary *dictInfo = [notification userInfo];
    NSValue *rectValue = dictInfo[UIKeyboardFrameEndUserInfoKey];
    CGSize keyBoardSize = [rectValue CGRectValue].size;
    
    //Save the current location so we can restore when keyboard is dismissed
    self.scrollViewContentOffset = self.scrollView.contentOffset;
    
    //Resize the scroll view to make room for the keyboard
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height -= keyBoardSize.height - TABBARHEIGHT;
    self.scrollView.frame = viewFrame;
    
    CGRect textFieldRect = [self.activeField frame];
    textFieldRect.origin.y += 10;
#warning incrorrect rect to visible for UITextView *descriptionTextView
    [self.scrollView scrollRectToVisible:textFieldRect animated:YES];
    
    //Keyboard is visible
    self.keyboardVisible = YES;
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    //Is the keyboard already shown
    if (!self.keyboardVisible) {
        NSLog(@"Keyboard is already hidden. Ignore notification.");
        return;
    }
    
    //Reset the frame scroll view to its original value
    self.scrollView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.scrollViewContentHeight);
    
    //Reset the scroll view to previos location
    self.scrollView.contentOffset = self.scrollViewContentOffset;
    
    //Keyboard is no longer visible
    self.keyboardVisible = NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.activeField = textView;
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)imageViewTapped
{
    NSLog(@"Image View Tapped");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Media Source Type"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Photo Library", nil];
    [actionSheet showInView:[self.view window]];
}

-(void)viewTapped
{
    NSLog(@"View Tapped");
    [self.nameTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

#pragma mark Action Sheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.nameTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
    
    if (buttonIndex == 0) {
        [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == 1){
        [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark -

-(void)updateDisplay
{
    if ([self isPicking]) {
        self.imageView.image = self.pickedImage;
    }
}

-(void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && mediaTypes > 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error accessing media"
                                                     message:@"Device doesn't support that media source"
                                                    delegate:nil
                                           cancelButtonTitle:@"Drat!"
                                           otherButtonTitles:nil];
        [av show];
    }
}

-(UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [original drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final;
}

#pragma mark Picker Controller Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *shrunkenImage = [self shrinkImage:chosenImage toSize:self.imageView.bounds.size];
    self.pickedImage = shrunkenImage;
    self.picking = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark -

#pragma mark CLLocationManager Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    if (newLocation.horizontalAccuracy < 0 /*|| newLocation.verticalAccuracy < 0*/) {
        NSLog(@"Incorrect results of newLocation: horizontal accuracy = %f, vertical accuracy = %f", newLocation.horizontalAccuracy, newLocation.verticalAccuracy);
        return;
    }
    
    if (newLocation.horizontalAccuracy > 50 /*|| newLocation.verticalAccuracy > 50*/) {
        NSLog(@"Incorrect results of newLocation: horizontal accuracy = %f, vertical accuracy = %f", newLocation.horizontalAccuracy, newLocation.verticalAccuracy);
        return;
    }
    
    self.locationAvaibale = YES;
    self.currentLocation = newLocation;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Location error happened" message:[NSString stringWithFormat:@"Error: %@", error]
                                                delegate:nil
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil];
    [av show];
}
#pragma mark -

-(void)uploadButtonPressed
{
    NSLog(@"Upload button pressed!");
    
    [self.nameTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
    //form validation
    if (!self.picking || !self.nameTextField.text || [self.nameTextField.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@""]) {
        NSLog(@"Drat!");
        
        NSMutableString *alertString = [NSMutableString string];
        
        if (!self.picking) {
            [alertString appendString:@"photo"];
        }
        if (!self.nameTextField.text || [self.nameTextField.text isEqualToString:@""]) {
            if ([alertString isEqualToString:@""]) {
                [alertString appendString:@"name"];
            } else {
                [alertString appendString:@", name"];
            }
        }
        if ([self.descriptionTextView.text isEqualToString:@""]) {
            if ([alertString isEqualToString:@""]) {
                [alertString appendString:@"description"];
            } else {
                [alertString appendString:@", description"];
            }
        }
        
        NSLog(@"%@", alertString);
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Drat! :("
                                                     message:[NSString stringWithFormat:@"Please, complete the following: %@", alertString]
                                                    delegate:nil
                                           cancelButtonTitle:@"Ok, bro"
                                           otherButtonTitles:nil];
        [av show];
        
        return;
    }
    
    //location validation
    if (!self.locationAvaibale) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Drat! :("
                                                     message:@"Your current location is not avaible. Try again later."
                                                    delegate:nil
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
        [av show];
    }
    
    NSLog(@"Hmm, sending data... :)");
    
    //disable upload button
    self.uploadButton.enabled = NO;
    
    NSMutableString *switchState = [NSMutableString string];
    if (self.backProjectSwitch.isOn) {
        [switchState appendString:@"Y"];
    } else {
        [switchState appendString:@"N"];
    }
    //client
    FTGreenAreaHTTPClient *client = [FTGreenAreaHTTPClient sharedFTGreenAreaHTTPClient];
    client.delegate = self;
    
    NSDictionary *uploadData =
    @{@"image" : self.pickedImage,
    @"title" : self.nameTextField.text,
    @"description" : self.descriptionTextView.text,
    @"latitude" : [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude],
    @"longitude" : [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude],
    @"donate" : switchState};
    
    [client uploadData:uploadData];
}

#pragma mark FTGreenAreaHTTPClient Delegate Methods
-(void)greenAreaHTTPClient:(FTGreenAreaHTTPClient *)client responseObject:(id)responseObject
{
    NSLog(@"Data uploaded :)");
    [SVProgressHUD showSuccessWithStatus:@"Great Success!"];
    
    //enable upload button
    self.uploadButton.enabled = YES;
}

-(void)greenAreaHTTPClient:(FTGreenAreaHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"Data didn't upload :(, Error: %@", error);
    [SVProgressHUD showErrorWithStatus:@"Failed with Error"];
    
    //enable upload button
    self.uploadButton.enabled = YES;
}

-(void)greenAreaHTTPClient:(FTGreenAreaHTTPClient *)client bytesWritten:(NSInteger)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    
    //progress
    [SVProgressHUD showProgress:progress status:@"Loading"];
}

@end
