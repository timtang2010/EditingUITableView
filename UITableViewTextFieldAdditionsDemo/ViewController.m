#import "ViewController.h"
#import "EditableTableViewCell.h"
#import "UITableView+TextFieldAdditions.h"

enum { kAccountSection=0, kSectionCount };
enum { kAccountFirstNameRow=0, kAccountLastNameRow, kAccountPasswordRow, kUsernameRow, kAccountSectionRowCount };


@interface ViewController()
@property (nonatomic, strong) IBOutlet 	UITableView *tableView;
@property (strong, nonatomic) IBOutlet 	UIView 		*tableFooter;

@property (nonatomic, strong)			NSString	*username;
@property (nonatomic, strong)			NSString	*password;
@property (nonatomic, strong)			NSString	*firstName;
@property (nonatomic, strong)			NSString	*lastName;

-(void) setButtonStates;
@end

@implementation ViewController

@synthesize tableView = _tableView;
@synthesize tableFooter;
@synthesize username;
@synthesize password;
@synthesize firstName;
@synthesize lastName;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc 
{
	[[self tableView] endWatchingForKeyboardStateChanges];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.tableFooterView = self.tableFooter;
	[[self tableView] beginWatchingForKeyboardStateChanges];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
	[self setTableFooter:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark- UITableViewDataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return section == kAccountSection ? kAccountSectionRowCount : 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cellToReturn = nil;
	if( [indexPath section] == kAccountSection )
	{
		if( [indexPath row] == kUsernameRow )
		{
			NSString * const kCellID = @"emailCell";
			EditableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellID];
			if( !cell )
			{
				cell = [[EditableTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: kCellID];
			}
			
			cell.textLabel.text = NSLocalizedString( @"Email", @"Email" );
			
			cell.textField.placeholder = NSLocalizedString( @"john@me.com", @"john@me.com" );
			cell.textField.delegate = self;
			cell.textField.returnKeyType = UIReturnKeyNext;
			cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			cell.textField.text = [self username];
			
			cellToReturn = cell;
		}
		else if( [indexPath row] == kAccountFirstNameRow )
		{
			NSString * const kCellID = @"firstNameCell";
			EditableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellID];
			if( !cell )
			{
				cell = [[EditableTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: kCellID];
			}
			
			cell.textLabel.text = NSLocalizedString( @"First Name", @"First Name" );
			cell.textField.placeholder = NSLocalizedString( @"John", @"John" );
			
			cell.textField.delegate = self;
			cell.textField.returnKeyType = UIReturnKeyNext;
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
			cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			cell.textField.text = [self firstName];
			
			cellToReturn = cell;
		}
		else if( [indexPath row] == kAccountLastNameRow )
		{
			NSString * const kCellID = @"lastNameCell";
			EditableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellID];
			if( !cell )
			{
				cell = [[EditableTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: kCellID];
			}
			
			cell.textLabel.text = NSLocalizedString( @"Last Name", @"Last Name" );
			cell.textField.placeholder = NSLocalizedString( @"Appleseed", @"Appleseed" );
			
			cell.textField.delegate = self;
			cell.textField.returnKeyType = UIReturnKeyNext;
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
			cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			cell.textField.text = [self lastName];
			
			cellToReturn = cell;
		}
		else if( [indexPath row] == kAccountPasswordRow )
		{
			NSString * const kCellID = @"passwordCell";
			EditableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellID];
			if( !cell )
			{
				cell = [[EditableTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: kCellID];
			}
			cell.textField.placeholder = NSLocalizedString( @"secret", @"secret" );
			cell.textLabel.text = NSLocalizedString( @"Password", @"Password" );
			
			cell.textField.delegate = self;
			cell.textField.returnKeyType = UIReturnKeyNext;
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			cell.textField.secureTextEntry = YES;
			cell.textField.text = [self password];
			
			cellToReturn = cell;
		}
	}
	cellToReturn.selectionStyle = UITableViewCellSelectionStyleNone;
	return cellToReturn;
}

#pragma mark- UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	[[self tableView] makeFirstResponderForIndexPath: indexPath];
}


#pragma mark- UITextFieldDelegate

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *text = [[textField text] stringByReplacingCharactersInRange: range withString: string];
	NSIndexPath *indexPath = [[self tableView] indexPathForFirstResponder];
	
	if( [indexPath row] == kUsernameRow )
	{
		self.username = text;
	}
	else if( [indexPath row] == kAccountFirstNameRow )
	{
		self.firstName = text;
	}
	else if( [indexPath row] == kAccountLastNameRow )
	{
		self.lastName = text;
	}
	else if( [indexPath row] == kAccountPasswordRow )
	{
		self.password = text;
	}
	
	[self setButtonStates];
	return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[[self tableView] makeNextCellWithTextFieldFirstResponder];
	return YES;
}

#pragma mark- Internal

-(BOOL) canSignup
{
	return [[self firstName] length] && [[self lastName] length] && [[self username] length] && [[self password] length];
}

-(void) setButtonStates
{
}



@end
