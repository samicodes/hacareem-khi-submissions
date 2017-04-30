//
//  ViewController.h
//  HaCareem-3
//
//  Created by Hyder@WhisperO on 29/04/2017.
//  Copyright © 2017 Hyder@WhisperO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "OBGradientView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewForMap;
@property (weak, nonatomic) IBOutlet UIButton *rideButton;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) UIImageView *myLocationMarker;
@property (weak, nonatomic) IBOutlet UILabel *currentAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestedDropOffAddress;
@property (weak, nonatomic) IBOutlet OBGradientView *headerGradientView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

