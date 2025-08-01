
- The death timer acts as a limiter for the amount of time an Official can be in play.
- Each time ==Card Play== occurs, the timer is reduced by 1.
- When the timer is reduced to zero, the next card play will kill the Official.


#### States
- Inactive
	- This state occurs while the card still remains in the player pool and does not occupy an Office.  In this state the Death Timer is present to be informational to the player.
	- In this state the timer does not listen or trigger from anything.  Once the Official is occupies an Office, the timer moves to an 'Active' state.
- Active
	- This state occurs while the Official occupies an Office.
	- In this state, the timer reduces by 1 each time there is a 'Card Play'.
	- Once timer reaches 