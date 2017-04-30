//
//  ViewController.m
//  HaCareem-3
//
//  Created by Hyder@WhisperO on 29/04/2017.
//  Copyright © 2017 Hyder@WhisperO. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import "CHLocationManager.h"
#import "CHCache.h"
#import "SVGeocoder.h"
#import "DataManager.h"
#import "DropOffSuggestion.h"

@interface ViewController () <GMSMapViewDelegate>
@property (nonatomic, strong) NSMutableArray *suggestionsArray;
@property (nonatomic) BOOL isUp;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[[CHLocationManager sharedObject] setDelegate:self];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[CHLocationManager sharedObject] CurrentLocation] coordinate].latitude
                                                            longitude:[[[CHLocationManager sharedObject] CurrentLocation] coordinate].longitude
                                                                 zoom:18];
    
    //GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.viewForMap.frame.size.height) camera:camera];
    
    _mapView.camera = camera;
    
    _mapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = _mapView;
    
    //self.view = mapView;
    
    _mapView.settings.compassButton = YES;
    _mapView.settings.tiltGestures = NO;
    _mapView.settings.rotateGestures = NO;
    _mapView.settings.myLocationButton = YES;
    
    NSLog(@"User's current location: %@", _mapView.myLocation);
    
    _mapView.accessibilityElementsHidden = NO;
    
    //[mapView setMinZoom:0.0 maxZoom:21];
    
    _mapView.delegate = self;
    
    
    _suggestionsArray = [[NSMutableArray alloc] init];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    _myLocationMarker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin"]];
    
    _myLocationMarker.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [_myLocationMarker setFrame:CGRectMake(_mapView.frame.size.width/2 - 50, _mapView.frame.size.height/2 - 100, 50, 50)];
    
    _myLocationMarker.contentMode = UIViewContentModeScaleAspectFit;
    [_mapView addSubview:_myLocationMarker];
    
    
    NSArray *colors2 = [NSArray arrayWithObjects:[UIColor blackColor], [UIColor clearColor], nil];
    self.headerGradientView.colors = colors2;
    
    
    if ([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - Google Map Delegates
/**
 * Called before the camera on the map changes, either due to a gesture,
 * animation (e.g., by a user tapping on the "My Location" button) or by being
 * updated explicitly via the camera or a zero-length animation on layer.
 *
 * @param gesture If YES, this is occuring due to a user gesture.
 */
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    NSLog(@"Camera will move");
    
    _isUp = NO;
    
    [UIView animateWithDuration:.25
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.myLocationMarker.transform = CGAffineTransformMakeScale(0.55, 0.55);
                         
                         if (_footerView.frame.origin.y)
                         {
                             
                         }
                         
                         _footerView.translatesAutoresizingMaskIntoConstraints = YES;
                         
                         CGRect frame1 = _footerView.frame;
                         
                         frame1.origin.y = 569;
                         
                         _footerView.frame= frame1;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"done");
                     }
     ];
}

/**
 * Called repeatedly during any animations or gestures on the map (or once, if
 * the camera is explicitly set). This may not be called for all intermediate
 * camera positions. It is always called for the final position of an animation
 * or gesture.
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    
}

/**
 * Called when the map becomes idle, after any outstanding gestures or
 * animations have completed (or after the camera has been explicitly set).
 */
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    
    double latitude = mapView.camera.target.latitude;
    double longitude = mapView.camera.target.longitude;
    
    NSLog(@"Camera stopped moving at %f --- %f",latitude,longitude);
    
    NSNumber *longi = [NSNumber numberWithDouble:longitude];
    NSNumber *lati = [NSNumber numberWithDouble:latitude];
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@"cfecdb276f" forKey:@"userid"];
    [parameter setObject:longi forKey:@"longitude"];
    [parameter setObject:lati forKey:@"latitude"];
    
    
    
    [DataManager getSuggestionsBy:@"suggestionsforuser" andData:parameter withCallback:^(NSMutableArray *suggestionsArray, NSString *error) {
        
        if (suggestionsArray.count)
        {
             [UIView animateWithDuration:.25 animations:^{
                 
                    _footerView.translatesAutoresizingMaskIntoConstraints = YES;
            
                    CGRect frame1 = _footerView.frame;
            
                    frame1.origin.y = 445;
                    
                    _footerView.frame= frame1;
                 
                 if (_suggestionsArray.count) {
                     [_suggestionsArray removeAllObjects];
                 }
                 _suggestionsArray = suggestionsArray;
                 
                 [_tableView reloadData];
                 
              }];
        }
        else
            NSLog(@"Error : %@",error);
    }];
    
    
    CLLocation * coord = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    
    [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(coord.coordinate.latitude, coord.coordinate.longitude) completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error == nil)
        {
            
            SVPlacemark * placemark = [placemarks firstObject];
            
            NSString *formattedAddress = placemark.formattedAddress;
            
            NSLog(@"Address : %@",formattedAddress);
            
            if (formattedAddress.length)
                _currentAddressLabel.text = formattedAddress;
            
            else
                _currentAddressLabel.text = @"My pin location";
            
        }
        else
        {
            NSLog(@"%@",error);
            
        }
    }];
    
    
    
    [UIView animateWithDuration:.25 animations:^{
        
        self.myLocationMarker.transform = CGAffineTransformMakeScale(1, 1);

    }];

    
   
}

#pragma mark - CHLocation Delegates
-(void)CHLocationManager:(CHLocationManager *) locationManager LocationChanged:(CLLocation *) location
{
    
}

-(void)CHLocationManager:(CHLocationManager *) locationManager AddressChanged:(NSString *) Address
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 40.0f; //60 was before.change below too.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = _suggestionsArray.count;
    
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    
    UILabel *address = [cell viewWithTag:990];

    address.text = ((DropOffSuggestion*)(_suggestionsArray[indexPath.row])).address;
    
    UIButton *button = [cell viewWithTag:991];
    button.layer.cornerRadius = 7.0;
    
    //[button addTarget:self action:@selector(moveToTop:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DropOffSuggestion *temp = _suggestionsArray[indexPath.row];
    
    [_suggestionsArray removeObjectAtIndex:indexPath.row];
    
    [_suggestionsArray insertObject:temp atIndex:0];
    
    [UIView animateWithDuration:.25 animations:^{
        
        _footerView.translatesAutoresizingMaskIntoConstraints = YES;
        
        CGRect frame1 = _footerView.frame;
        
        frame1.origin.y = 445;
        
        _footerView.frame= frame1;
        
        [_tableView reloadData];
        
    }];
}

- (IBAction)dragFooter:(id)sender
{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [recognizer translationInView:_footerView];
    
    
    if (_suggestionsArray.count > 1)
    {
        
        //if (recognizer.view.center.y >= 468)
        CGPoint point = [recognizer locationInView:self.view];
        
        
        if (recognizer.view.center.y >= 468)
        {
            _isUp = YES;
            
            recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                                 recognizer.view.center.y + translation.y);
            
            if (recognizer.state == UIGestureRecognizerStateEnded) {
                
                // Check here for the position of the view when the user stops touching the screen
                
                // Set "CGFloat finalX" and "CGFloat finalY", depending on the last position of the touch
                
                // Use this to animate the position of your view to where you want
                
                if (_isUp)
                {
                    [UIView animateWithDuration:.25 animations:^{
                        
                        _footerView.translatesAutoresizingMaskIntoConstraints = YES;
                        
                        CGRect frame1 = _footerView.frame;
                        
                        frame1.origin.y = 400;
                        
                        _footerView.frame= frame1;
                        
                    }];
                }
                
            }
            
        
            
            [recognizer setTranslation:CGPointMake(0, 0) inView:_footerView];
        }
    }
    
}


@end
