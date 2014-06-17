//
//  BoardViewController.h
//  DnM
//


#import <UIKit/UIKit.h>
#import "ParticleSystem.h"
#import "DustView.h"
#import "MagnetView.h"
#import "DustDetailViewController.h"

@interface BoardViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverControllerDelegate>
{
    ParticleSystem *mParticleSystem;
    
    //View
    UIView *mBoardView;
    NSMutableDictionary *mMagnetViewForParticle;
    NSMutableDictionary *mDustViewForParticle;
    
    UIPopoverController *attributeSelectorPopover;
    UIPopoverController *dustDetailpopover;
    

}

@property(nonatomic, strong)NSString *radiusAttribute;


@property (weak, nonatomic) IBOutlet UIView *controlsView;

@property (retain, nonatomic) IBOutlet UIView *boardView;
@property (retain, nonatomic)  NSMutableDictionary *magnetViewForParticle;
@property (retain, nonatomic)  NSMutableDictionary *dustViewForParticle;

@property (retain, nonatomic) ParticleSystem *particleSystem;

@property (weak, nonatomic) IBOutlet UIView *dustDisplay;

@property (weak, nonatomic) IBOutlet UITableView *dustDataTable;

@property(nonatomic, retain) DustView *selectedDust;
@property(nonatomic, retain) MagnetView *selectedMagnet;
@property(nonatomic, assign)CGRect dustDataTableDesiresdFrame;

@property (weak, nonatomic) IBOutlet UILabel *dustLabelName;
@property (weak, nonatomic) IBOutlet UIView *magnetDisplay;

@property (weak, nonatomic) IBOutlet UILabel *magnetLabel;

@property (weak, nonatomic) IBOutlet UISlider *magnitudeSlider;

@property (weak, nonatomic) IBOutlet UISlider *repulsionSlider;

@property (weak, nonatomic) IBOutlet UILabel *repulsionMinLabel;

@property (weak, nonatomic) IBOutlet UILabel *repulsionMaxLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *radiusPicker;

@property(nonatomic, readonly)NSArray *dustViews;





@end
