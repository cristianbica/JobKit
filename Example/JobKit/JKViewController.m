//
//  JKViewController.m
//  JobKit
//
//  Created by Cristian Bica on 04/02/2015.
//  Copyright (c) 2014 Cristian Bica. All rights reserved.
//

#import "JKViewController.h"
#import <JobKit/JobKit.h>
#import <JobKit/JKCoreDataAdapter.h>
#import <JobKit/JKRealmAdapter.h>
#import <JobKit/JKMemoryAdapter.h>
@interface JKViewController ()

@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  [JobKit setupDefaultManagerWithStorageProvider:[JKCoreDataAdapter class]];
  [JobKit setupDefaultManagerWithStorageProvider:[JKRealmAdapter class]];
  [JobKit setupDefaultManagerWithStorageProvider:[JKMemoryAdapter class]];
	// Do any additional setup after loading the view, typically from a nib.
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
