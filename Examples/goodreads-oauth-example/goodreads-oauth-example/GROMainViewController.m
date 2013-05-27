//
//  GROMainViewController.m
//  goodreads-oauth-example
//
//  Created by Romotive on 5/26/13.
//  Copyright (c) 2013 YonatanKogan. All rights reserved.
//

#import "GROMainViewController.h"
#import "GROAuth.h"

@interface GROMainViewController ()

@property (strong,nonatomic) GROAuth *groAuth;

@end

@implementation GROMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnTapped:(id)sender {

    [GROAuth loginWithGoodreadsWithCallbackURL:nil completion:nil];
    
}
@end
