//
//  IMHHomeViewController.m
//  imhere
//
//  Created by Aci Cartagena on 5/2/15.
//  Copyright (c) 2015 imhere. All rights reserved.
//

#import "IMHHomeViewController.h"
#import "IMHConnectionManager.h"

#import "IMHNoteFeedTableViewCell.h"



@interface IMHHomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IMHNoteFeedTableViewCell *prototypeCell;

@property (strong, nonatomic) NSArray *notes;

@end

@implementation IMHHomeViewController

#pragma mark - lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    [self.tableView registerClass:[IMHNoteFeedTableViewCell class] forCellReuseIdentifier:noteFeedTableViewCellIdentifier];
}

#pragma mark - propeties
- (IMHNoteFeedTableViewCell *)prototypeCell
{
    if (!_prototypeCell){
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:noteFeedTableViewCellIdentifier];
    }
    return _prototypeCell;
}

#pragma mark - uitableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMHNote *note = [self.notes objectAtIndex:indexPath.row];
    self.prototypeCell.note = note;
    
    return [self.prototypeCell getHeightForNote:note];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning to code later
}

#pragma mark - uitableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMHNoteFeedTableViewCell *noteCell = [tableView dequeueReusableCellWithIdentifier:noteFeedTableViewCellIdentifier];
    
    IMHNote *note = [self.notes objectAtIndex:indexPath.row];
    noteCell.note = note;
    
    return noteCell;
}


#pragma mark - ib action
- (IBAction)heya:(id)sender
{
    [[IMHConnectionManager sharedManager] heya];
}

- (IBAction)newMessage:(id)sender
{
    [self performSegueWithIdentifier:homeToNewNoteSegueId sender:nil];
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:homeToMessageSegueId]){
        
    }
}

@end
