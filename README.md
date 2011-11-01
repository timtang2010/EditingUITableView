# EditingUITableView 

## Making UITableView based view controllers that need multiple UITextFields for editing a breeze. 

There are a number of problems working with UITableViews whenever UITextField elements are involved:

- Moving data from the text fields
- Jumping from current responder to the next
- Handling the keyboard properly to resize the table and move content to a visible area

This set of classes are designed to make these tasks easy.  Here's an example of how to do this.

## Example Usage


0) Copy all the files from UITableViewTextFieldAdditions into your project.

In your UIViewController which contains your UITableView:

1) Include headers

``` objective-c
#import "UITableView+TextFieldAdditions.h"
#import "EditableTableViewCell.h"
end
```

2) Enable auto-keyboard handling for our UITableView

``` objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self tableView] beginWatchingForKeyboardStateChanges];
}

- (void)dealloc 
{
		[[self tableView] endWatchingForKeyboardStateChanges];
}
```

3) Return editable cells (snippet)

``` objective-c
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
```

4) Update our data from the UITextFields as the user types and handle our "Next" logic

``` objective-c
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *text = [[textField text] stringByReplacingCharactersInRange: range withString: string];
	NSIndexPath *indexPath = [[self tableView] indexPathForFirstResponder];
	if( [indexPath row] == kUsernameRow )
	{
		self.username = text;
	}
	return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[[self tableView] makeNextCellWithTextFieldFirstResponder];
	return YES;
}

```

That's it! 
Checkout the sample code for further details.

## Dependencies

* [iOS 4.0+]
* ARC
* No other external dependencies.

### ARC Support Comments

The code library ASSUMES ARC SUPPORT.
If you want to use this with pre-ARC code, please run through and add the needed -retain calls to the mapping dictionary ivar.

## Contact

Steve Breen - breeno@me.com

## License

This library is licensed under the BSD license.
