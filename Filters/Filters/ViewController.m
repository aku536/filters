//
//  ViewController.m
//  Filters
//
//  Created by Кирилл Афонин on 12/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

#import "ViewController.h"
#import "ISSSelectSourcePickerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    ISSSelectSourcePickerView *pickerView = [ISSSelectSourcePickerView selectSourceView];
    [self.view addSubview:pickerView];
}

@end
