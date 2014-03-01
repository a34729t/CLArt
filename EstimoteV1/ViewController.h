//
//  ViewController.h
//  EstimoteV1
//
//  Created by Nicolas Flacco on 2/27/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController 

@property (weak,nonatomic)IBOutlet UIButton *scanButton;
@property (weak,nonatomic)IBOutlet UILabel *rssiLabel;

- (IBAction)scanButtonPressed:(UIButton *)sender;

@end
