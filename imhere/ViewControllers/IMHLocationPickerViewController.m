//
//  IMHLocationPickerViewController.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHLocationPickerViewController.h"

#import "IMHLocationTableViewCell.h"

#import "IMHLocationManager.h"
#import "IMHLocation.h"

@interface IMHLocationPickerViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *locationName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *locationArray;

@end

@implementation IMHLocationPickerViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupUI];
}

- (void)setupUI
{
    self.locationName.delegate = self;
}

#pragma mark - table view delegate

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locationArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMHLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationTableViewCellIdentifier];
    IMHLocation *location = [self.locationArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = location.locationName;
    return cell;
}

#pragma mark - uitextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __weak typeof(self) weakSelf = self;
    [[IMHLocationManager sharedManager] forwardGeocodeLocationWithName:textField.text withCompletionBlock:^(NSArray *locations) {
        NSLog(@"Location: %@",locations);
        
        if (locations == nil){
            [[[UIAlertView alloc] initWithTitle:@"Oops.." message:@"Location not found. Try another address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
        weakSelf.locationArray = locations;
        [weakSelf.tableView reloadData];
    }];
    return YES;
}


@end
