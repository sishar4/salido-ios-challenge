# SALIDO iOS Challenge
This challenge is intended to get a better idea of a SALIDO candidate's coding style and development process. There is no hard time limit, but we ask that you send in your solution promptly.

Please feel free to use the developer reviewing your work as a resource. If any points seem vague or need clarifying, they will be there to help.

## Submission Instructions
1. Fork this project. If you don't already have a github account, you will need one.
2. Complete the project according to the provided requirements
3. Push all changes to your fork and submit a pull request to this project. Email the SALIDO employee that interviewed you to let them know the challenge was submitted.
4. In your README, give us a brief explanation of how you approached the problem and assumptions you made. If there are any setup steps we need before running your code, list them here.

## Expectations
1. You can model data supplied by the API in a way that is simple and makes sense.
2. You can take modeled information and create an easily digestible UI around it.
3. You can utilize appropriate frameworks to make your code fast, simple, and DRY.
4. You can take a set of business requirements from end-to-end, keeping in mind how the user will interact with the final product.

## Context
Imagine SALIDO has expanded its reach into the wine industry with the new "SALIDO Wine Club". We need to source product data from the wine.com API (http://api.wine.com) and load it into our own database of wine products.

## Requirements
1. Upon app start, the user should be prompted to sign in using a pin or to create a new employee
	- A user should have (at minimum) the following attributes:
		1. a pin code
		2. a first name
		3. a last name
		4. a valid email address (optional)
	- An error prompt must appear if an invalid pin is entered (not the right format or isn't assigned to anyone)
2. Upon logging in, the user should be presented with a list of wines sourced from the wine.com API
	- The user should be able to filter items by name, location, etc.
	- The items in the list presented should display an image of the item and the item name.
	- If the API is unreachable (no internet) an error should be displayed. The user should be given an option to retry the API call.
	- If the user returns to this screen after traveling to a different screen, the search query, results, and filters should be in the same state that they were left in.
3. Upon selecting an item from the list, the user should be taken to an item detail screen.
	- The item detail screen should display an image of the item and the item's name
	- The item detail screen should display the item's description as returned from the API.
	- The item detail screen should allow the user to add the item to their shopping cart and set the quantity.

4. Upon moving to the shopping cart screen, the user should be shown a list of items that were selected.
	- Items in the list should display the item image, item name, and quantity bought
	- Items should be displayed in the order they were added to the cart.
	- The total of all item quantities should be present somewhere on the screen.
	- The screen should allow the user to return to the main catalogue of items.
	- The user should be allowed to remove items from the cart.
	- The item detail screen should also be accessible from the shopping cart screen.
5. Upon checking out, the user should be presented with a confirmation or "Thank You" screen as well as the option to start a new order.
6. The user should be able to log out at any point in time.
7. Objective-C is preferred, but you can write the app in Swift if you want to.

## Extra credit
- add a "Forgot Your Pin" feature using the email address as lookup. If no email was given respond with an appropriate error message.
- enforce unique employees
- implementing a live updating shopping cart interface
- allow access to a list of all employees and the amount of time they've been employed at the SALIDO Wine Club.
- If multiple instances of the same item are added, but at different points, the item should appear in the position that the first instance was added, but the quantity should be grouped. For example:
	- Item A was added with quantity 1.
	- Item B was added with quantity 2.
	- Another instance of item A was added, but with a quantity of 4.
	- The expected outcome is:
		- Item A, Qty 5
		- Item B, Qty 2
- implement a "quick add" feature from the catalogue screen. It should allow the user to quickly add an item from the catalogue and set a quantity without ever hitting its detail page.
- surprise us! implement a feature of the API in a way we haven't mentioned or suggested

## Other Notes
- You do not need to:
	- Save an order or session if the app enters the background. If the user presses the home button, you can just log them out and present the login screen when the app is launched again.
	- Handle payment. Assume all items are free.
	- Have fancy UI. You can make the interface as barebones as you'd like.
	- Account for screen rotation.

- You can:
	- Use (free) 3rd party frameworks, if needed.

- Evaluation
	Evaluation is based on the following criteria:
	- Did you complete all of the base requirements?
	- Did you follow standard coding practices and use an appropriate programming paradigm for iOS development?
	- Did you properly submit the project?
	- Did you use iOS and 3rd party frameworks in an appropriate way?
	- Is your code "self-documenting"? 
