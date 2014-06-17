//
//  BoardViewController.m
//  DnM
//


#import "BoardViewController.h"
#import "PhysicsEngine.h"
#import "DnMDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import "AttributeSelectorViewController.h"



@interface BoardViewController ()

@property(nonatomic, strong)PhysicsEngine *physicsEngine;
@property(nonatomic, strong)NSMutableArray * allDust;
@end




@implementation BoardViewController

@synthesize magnetViewForParticle = _magnetViewForParticle, dustViewForParticle = _dustViewForParticle, particleSystem, physicsEngine, dustDataTable, allDust, radiusAttribute, controlsView;


#define kDustMaxRadius 15
#define kDustMinRadius 5
#define kDustMaxSize 30.0

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.allDust = [[NSMutableArray alloc] init];
    self.boardView.clipsToBounds = YES;
    
    [self initializeModel];
   
    self.physicsEngine = [[PhysicsEngine alloc] init ];
    self.physicsEngine.targetMins = self.particleSystem.dustMin;
    self.physicsEngine.targetMaxes = self.particleSystem.dustMax;
    self.physicsEngine.targetThresholds = self.particleSystem.dustThreshold;
   
    [self.particleSystem.magnetParticles enumerateObjectsUsingBlock:^(ParticleModel *magnet, NSUInteger magnetIndex, BOOL *stop) {
        MagnetView *magnetView = [[MagnetView alloc] initWithFrame:CGRectMake(100., 100., 50., 50.)];
        magnetView.particle = magnet;
        [magnetView setLabelText:magnet.name];
        [self.magnetViewForParticle setValue:magnetView forKey:magnet.name];
        [self.boardView addSubview:magnetView];
        [magnetView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMagnetPan:)] ];
        [magnetView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMagnetTap:)] ];
        UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMagnetDoubleTap:)];
        doubleTapGR.numberOfTapsRequired = 2;
        [magnetView addGestureRecognizer:doubleTapGR];
    }];
    
    
    
    [self.particleSystem.dustParticles enumerateObjectsUsingBlock:^(ParticleModel *dust, NSUInteger dustIndex, BOOL *stop) {
        DustView   *dustView = [[DustView alloc] initWithFrame:CGRectMake(50., 50., kDustMaxSize, kDustMaxSize)] ;
        dustView.particle = dust;
        [dustView setLabelText:dust.name];
        dustView.label.hidden = YES;
        [self.dustViewForParticle setValue:dustView forKey:dust.name];
        dustView.radius = kDustMaxRadius;
        [self.boardView addSubview:dustView];
       
       [dustView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_handleDustTap:)] ];
        dustView.baseColor = [self randomColor];
        
        
        
        [allDust addObject:dustView];
        
    }];
        
    [self initialPositioning];
    
    
    
    [self.boardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)]];
  
    
    self.dustDataTable.dataSource = self;
    [self.dustDataTable setDelegate:self];
    self.dustDataTable.hidden = YES;
    
    
    
    self.controlsView.layer.borderColor = [[UIColor blackColor]CGColor ];
    self.controlsView.layer.borderWidth = 2.0f;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



-(NSArray *)dustViews
{
    return [self.dustViewForParticle allValues];
}

-(void)handleMagnetPan:(UIPanGestureRecognizer *)panGR{
    if(panGR.state == UIGestureRecognizerStateBegan || panGR.state == UIGestureRecognizerStateChanged){
        ParticleView *view = (ParticleView*)panGR.view;
        CGPoint translation = [panGR translationInView:view.superview];
        CGPoint newCenter =  CGPointMake(view.center.x + translation.x, view.center.y +translation.y);
        [view setCenter:newCenter];
        [panGR setTranslation:CGPointZero inView:view.superview];
        
        
        if(view.enabled)
        {
            //Here, maybe sqrt
            float duration = abs(translation.x) + abs(translation.y);
            [self p_stepWithDuration: duration];
        }
        
       
    }
    
}


-(void)p_stepWithDuration:(double) duration
{
    double durationScale = 0.001;
    double scaledDuration = durationScale * duration;
    
    for(ParticleModel *dust in self.particleSystem.dustParticles)
    {
        
        DustView *dustView = [self.dustViewForParticle objectForKey:dust.name];
        CGPoint dustCenter = dustView.center;
        
        //Calculate net offset for next step
        CGPoint delta = CGPointZero;
        
        for(ParticleModel *magnet in self.particleSystem.magnetParticles){
            MagnetView *magnetView = [self.magnetViewForParticle objectForKey:magnet.name];
            CGPoint magnetCenter = magnetView.center;
            double attraction = [self.physicsEngine attractionBetweenSource:magnet andTarget:dust];
            delta = CGPointMake(delta.x + attraction * (magnetCenter.x - dustCenter.x),
                                delta.y + attraction * (magnetCenter.y - dustCenter.y));
        }
        //Move the dust
        dustCenter = CGPointMake(dustCenter.x + scaledDuration * delta.x, dustCenter.y + scaledDuration*delta.y);
        //Here, chek that the vie stay inside the view
        
        
        
       dustView.center = dustCenter;
        
    }
    
}


-(BOOL)checkBounds:(CGPoint)newCenter
{
    return CGRectContainsPoint(self.boardView.frame, newCenter);
}


-(void)handleBackgroundTap:(id)sender
{
  
    [self p_selectDust:nil];
    self.selectedMagnet = nil;
    self.magnetLabel.text = @"?";
}



-(void)handleMagnetTap:(UITapGestureRecognizer *)tapGR
{
    
     NSLog(@"Single tap on magnet");
    self.selectedMagnet = (MagnetView *)tapGR.view;
    [self reloadMagnetDislay];
   
}

-(void)handleMagnetDoubleTap:(UITapGestureRecognizer *)tapGR
{
    NSLog(@"Two taps on magnet");
    MagnetView *magnetView = (MagnetView *)tapGR.view;
    magnetView.enabled = !magnetView.enabled;
    [magnetView updateRendering];
}

#define kMagentLayoutCenterX 600.0
#define kMagentLayoutCenterY 400.0
#define kMagentLayoutRadius 100.0


#define kDustLayoutCenterX 300.0
#define kDustLayoutCenterY 300.0
#define kDustLayoutRadius 150.0

-(void)initialPositioning
{
    CGPoint magnetsCenter = CGPointMake(kMagentLayoutCenterX, kMagentLayoutCenterY);
    NSUInteger magnetCount = self.particleSystem.magnetParticles.count;
   
    
    
    
    [self.particleSystem.magnetParticles enumerateObjectsUsingBlock:^(ParticleModel * magnet, NSUInteger magnetIndex, BOOL *stop) {
        UIView *view = [self.magnetViewForParticle objectForKey:magnet.name];
        view.center = [self p_pointOnCircleAtCenter:magnetsCenter radius: kMagentLayoutRadius theta: (2 * M_PI * magnetIndex / magnetCount)];
    }];
    
    
    
    
    
    CGPoint dustCenter =  CGPointMake(kDustLayoutCenterX, kDustLayoutCenterY);
    NSUInteger dustCount    = self.particleSystem.dustParticles.count;
    
    [self.particleSystem.dustParticles enumerateObjectsUsingBlock:^(ParticleModel *dust, NSUInteger dustIndex, BOOL *stop) {
        UIView *view = [self.dustViewForParticle objectForKey:dust.name];
        view.center = [self p_pointOnCircleAtCenter:dustCenter radius: kDustLayoutRadius theta: (2 * M_PI * dustIndex / dustCount)];
    }];
        
}

-(CGPoint) p_pointOnCircleAtCenter:(CGPoint) circleCenter radius:(CGFloat) radius theta:(float) theta
{
        
    CGFloat x =  circleCenter.x + radius * cos(theta);
    CGFloat y =  circleCenter.y + radius * sin(theta);
    CGPoint point = CGPointMake(x, y);
    return point;
}


-(NSMutableDictionary *) magnetViewForParticle
{
    if(!_magnetViewForParticle)
    {
        _magnetViewForParticle = [NSMutableDictionary dictionary];
    }
    return _magnetViewForParticle;
}

-(NSMutableDictionary *) dustViewForParticle
{
    if(!_dustViewForParticle)
    {
        _dustViewForParticle = [NSMutableDictionary dictionary];
    }
    return _dustViewForParticle;
}


-(void) initializeModel
{
    self.particleSystem = [[ParticleSystem alloc] initWithLocalDB];
}
- (IBAction)resetPosition:(id)sender {
    
    [UIView animateWithDuration:1.0 animations:^{
        [self initialPositioning];
    }];
    
}



-(void)p_handleDustTap:(UIGestureRecognizer *) tapGR
{
    NSLog(@"Tap en el dust");
    [self p_selectDust:(DustView *)tapGR.view];
}

-(void)p_resizeDustTable
{
    
}

-(void)p_selectDust:(DustView *)dustView
{
        
    
    BOOL tappedSelected = self.selectedDust !=nil && dustView == self.selectedDust;
    if (tappedSelected || dustView == nil) {
        //Deselect.
        [self.selectedDust highlight:NO];
        self.selectedDust = nil;
        self.dustDisplay.hidden = YES;
        
    }else{
        //Select
        [self.selectedDust highlight:NO];
        self.selectedDust = dustView;
        [self.selectedDust highlight:YES];
        [self.dustDataTable reloadData];
        //[self p_resizeDustTable];
        [self performSelector:@selector(p_resizeDustTable) withObject:self afterDelay:0.];
        self.dustDisplay.hidden = NO;
        self.dustDataTable.hidden = NO;
        self.dustLabelName.text = self.selectedDust.particle.name;
        NSLog(@"Se dio tap en: %@", self.selectedDust.particle.name);
        [self showDustDetails:dustView];
       
    }
}



-(void)showDustDetails:(DustView *)sender
{
    if([dustDetailpopover isPopoverVisible])
    {
        [dustDetailpopover dismissPopoverAnimated:YES];
        dustDetailpopover = nil;
        return;
    }
    DustDetailViewController *dustDetailViewController = [[DustDetailViewController alloc] init];
    dustDetailViewController.contentSizeForViewInPopover = CGSizeMake(320, 350);
    dustDetailViewController.delegate = self;
    
    //dustDetailViewController.delegate = self;
    
    dustDetailpopover = [[UIPopoverController alloc] initWithContentViewController:dustDetailViewController ];
    dustDetailpopover.delegate = self;
    
    [dustDetailpopover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}



-(void)shakeView:(UIView *)firstView awayFromView:(UIView * )secondView withinFrame:(CGRect)clampFrame
{
    CGRect firstFrame = firstView.frame;
    CGRect secondFrame = secondView.frame;
    CGPoint firstCenter = CGPointMake(CGRectGetMidX(firstFrame), CGRectGetMidY(firstFrame));
    CGPoint secondCenter = CGPointMake(CGRectGetMidX(secondFrame), CGRectGetMidY(secondFrame));
    
    CGPoint direction  = CGPointMake(firstCenter.x - secondCenter.x, firstCenter.y - secondCenter.y);
    CGFloat norm = sqrt(direction.x * direction.x + direction.y * direction.y);
    
    CGPoint normalizedDirection = CGPointMake(1.0,0.0);
    
    if(norm >  0.01)
    {
        normalizedDirection = CGPointMake(direction.x / norm, direction.y / norm);
    }
    CGPoint shake = CGPointMake(normalizedDirection.x * 2., normalizedDirection.y * 2.);
    CGPoint newFirstCenter = CGPointMake(firstCenter.x + shake.x, firstCenter.y + shake.y);
    firstView.center = newFirstCenter;
}


-(BOOL)shakeViews:(NSArray *)views withinFrame:(CGRect) clampFrame
{
    BOOL foundOverlappingViews = NO;
    if(views)
    {
        for(UIView *firstView in views)
        {
            CGRect firstFrame  = firstView.frame;
            for(UIView * secondView in views)
            {
                CGRect secondFrame  = secondView.frame;
                if(firstView != secondView)
                {
                    //Do they overlap?
                    BOOL framesOverlap = NO;
                    if(YES)
                    {
                        framesOverlap = CGRectIntersectsRect(firstFrame, secondFrame);
                    }else{
                        //OMITTED Calculation of wether circles overlap
                    }
                    //If they overlap, shake the first one away, and quit processing the first one for now
                    if(framesOverlap)
                    {
                        foundOverlappingViews = YES;
                        [self shakeView:firstView awayFromView:secondView withinFrame:clampFrame];
                        break;
                    }
                    
                }
                
            }
        }
    }
    return foundOverlappingViews;
}


-(void) shakeDustUntilDoneWithMaxIterationCount:(NSUInteger)maxIterationCount
{
    BOOL done = NO;
    NSMutableArray *dustViews = allDust;
    for(NSUInteger iteration = 0; !done && iteration < maxIterationCount; iteration ++)
    {
        BOOL changed = [self shakeViews:dustViews withinFrame:self.boardView.frame];
        done = !changed;
    }
}

-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"Shaking!!!");
    if(event.type == UIEventSubtypeMotionShake)
    {
        [self shakeDustUntilDoneWithMaxIterationCount:100];
    }
    }


- (IBAction)shake:(id)sender {
    [self shakeDustUntilDoneWithMaxIterationCount:100];
}




-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 0;
    if(self.selectedDust)
    {
        ParticleModel *dustModel = self.selectedDust.particle;
        numberOfRowsInSection = dustModel.strengthByAttribute.count;
    }
    return numberOfRowsInSection;
}



-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 static NSString *sCellIndentifier = @"Cell";
    
    
  UITableViewCell *cell = [dustDataTable dequeueReusableCellWithIdentifier:sCellIndentifier];
  
  if(self.selectedDust)
  {
      if(!cell)
      {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2  reuseIdentifier:sCellIndentifier];
      }
      ParticleModel *dustModel = self.selectedDust.particle;
      NSArray *attributes = dustModel.attributes;
      NSString *attribute = [attributes objectAtIndex:indexPath.row];
      NSString *strength = @"";
      
      if(attribute)
      {
          NSNumber *valueNum = [dustModel.strengthByAttribute objectForKey:attribute];
          strength = [NSString stringWithFormat:@"%0.2f", valueNum.doubleValue];
          cell.textLabel.text = [attribute uppercaseString];
          cell.detailTextLabel.text = strength;
      }
  }else
  {
      NSLog(@"Attempted to  create data display for row %d when no dust was selected", indexPath.row);
      cell.textLabel.text = @"";
      cell.detailTextLabel.text = @"?";
  }   
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     if(self.selectedDust)
     {
         return [self.selectedDust.particle.name capitalizedString];
     }
    return @"";
}


- (IBAction)handleMagnetRepulsionChanged:(id)sender {
    NSLog(@"El valor es: %f", self.repulsionSlider.value);
    if(self.selectedMagnet)
    {
        ParticleModel *magnetParticle = self.selectedMagnet.particle;
        NSString *attribute = [magnetParticle.attributes objectAtIndex:0];
        NSNumber * newValue = [ NSNumber  numberWithDouble:  self.repulsionSlider.value];
        [self.particleSystem.dustThreshold.strengthByAttribute setValue:newValue forKey:attribute];
        self.physicsEngine.targetThresholds = self.particleSystem.dustThreshold;
    }
}

- (IBAction)handleMagnetScaleFactorChanged:(id)sender {
    
    if(self.selectedMagnet)
    {
        self.selectedMagnet.particle.scaleFactor = self.magnitudeSlider.value;
    }
    
    
}

-(void)reloadMagnetDislay
{
    if (self.selectedMagnet) {
        MagnetView *magnetView = self.selectedMagnet;
        ParticleModel *magnetModel  = magnetView.particle;
        
        //Magnitude slider
        
        self.magnetLabel.text = magnetModel.name;
        self.magnitudeSlider.value = magnetModel.scaleFactor;
        
        //Repulsion slider
        
        NSArray *magnetAttributes = [magnetModel attributes];
        if(magnetAttributes.count > 0)//should be 1
        {
            NSString *attribute = (NSString *)[magnetAttributes objectAtIndex:0];
            double minStrength = [self.particleSystem.dustMin strengthForAttribute:attribute];
            double maxStrength = [self.particleSystem.dustMax strengthForAttribute:attribute];
            double tresholdStrength = [self.particleSystem.dustThreshold strengthForAttribute:attribute];
            
            self.repulsionSlider.minimumValue = minStrength;
            self.repulsionSlider.maximumValue = maxStrength;
            self.repulsionSlider.value = tresholdStrength;
            
            self.repulsionMinLabel.text = [NSString stringWithFormat:@"%3.1f", minStrength];
            self.repulsionMaxLabel.text = [NSString stringWithFormat:@"%3.1f", maxStrength];
            
        }
    }
}


-(UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}


-(void)updateDustRadii
{
  
       NSString *attribute = self.radiusAttribute;            
       double minStrength = 0.;
       double maxStrength = 0.;
       
       if(attribute){
           minStrength = [self.particleSystem.dustMin strengthForAttribute:attribute];
           maxStrength = [self.particleSystem.dustMax strengthForAttribute:attribute];
       }
       
       if(maxStrength > minStrength)
       {
           [self.dustViews enumerateObjectsUsingBlock:^(DustView *dustView, NSUInteger dustIdx, BOOL *stop) {
               double strength = [dustView.particle strengthForAttribute:attribute];
               double fraction = (strength - minStrength) / (maxStrength - minStrength);
               double diameter = kDustMinRadius + fraction * (kDustMaxRadius - kDustMinRadius);
               double r = diameter / 2.;
               
               dustView.radius = r;
           }];
       }
       else{
           [self.dustViews enumerateObjectsUsingBlock:^(DustView *dustView, NSUInteger dustIdx, BOOL *stop) {
               
               [UIView animateWithDuration:0.5 animations:^{
                    dustView.radius = kDustMaxRadius;
               }];
               
               //dustView.radius = kDustMaxRadius;
           }];
       }
       
  }

- (IBAction)showPicker:(id)sender {
    self.radiusPicker.hidden = NO;
}




-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
        attributeSelectorPopover = nil;
        dustDetailpopover = nil;
}

#pragma mark -UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1 + self.particleSystem.attributes.count;
}

#pragma mark -UIPickerViewDelegate



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(row == 0)
    {
        self.radiusAttribute = nil;
    }
    else{
        self.radiusAttribute = [self.particleSystem.attributes objectAtIndex:row - 1];
    }
    
    
    [self updateDustRadii];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0)
    {
        return @"(same)";
    }
    else{
        return [[self.particleSystem.attributes objectAtIndex:row -1] capitalizedString];
    }
}
- (IBAction)selectAttribute:(id)sender {
    if([attributeSelectorPopover isPopoverVisible])
    {
        [attributeSelectorPopover dismissPopoverAnimated:YES];
        attributeSelectorPopover = nil;
        return;
    }
    AttributeSelectorViewController *attrController = [[AttributeSelectorViewController alloc] init];
    attrController.contentSizeForViewInPopover = CGSizeMake(320, 216);
    
    attrController.delegate = self;
    
    if(self.radiusAttribute){
        NSUInteger a = (int)[self.particleSystem.attributes indexOfObject:self.radiusAttribute];
        
        attrController.defaultSelection = a + 1;
    }
    
    
    attributeSelectorPopover = [[UIPopoverController alloc] initWithContentViewController:attrController ];
    attributeSelectorPopover.delegate = self;
    UIButton *btn = (UIButton*)sender;     
    [attributeSelectorPopover presentPopoverFromRect:btn.bounds inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
}

- (IBAction)loadJSON:(id)sender {
    
    DnMDataSource *ds = [[DnMDataSource alloc] init];
    [ds test];
}



@end
