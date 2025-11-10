# Bantas Workbook: Making Choices!

Hello again, Coder!

You've learned how to make the computer repeat things with loops. Now, let's teach it how to **make choices**!

In life, you make choices all the time. **IF** it's raining, you take an umbrella. **IF** you're hungry, you eat a snack.

Computers can make choices too! This is called **Selection**.

### The Magic Crossroads

Imagine you're on an adventure and you reach a crossroads.
*   A sign on the left path says: "**IF** you have a magic key, go this way."
*   A sign on the right path says: "**OTHERWISE**, you must go this way."

In Bantas, we create a magic crossroads using three special commands: `#`, `!`, and `;`.

*   `#` is the **IF** command. It checks if something is true.
*   `!` is the **ELSE** (or OTHERWISE) command.
*   `;` is the **END IF** command. It tells the computer where the crossroads ends.

Here is how you'd write it:
```bantas
' Let's put the number 10 in a memory box
@,1
<,10

' Now, let's make a choice!
@,1 ' Look at the value in box #1
#,=10 ' IF the value IS EQUAL TO 10...
  ?, "You found the treasure!"
! ' OTHERWISE...
  ?, "Sorry, wrong number!"
; ' END of the choice.
```
You can check for different things:
*   `#,=10` (is it equal to 10?)
*   `#,<10` (is it less than 10?)
*   `#,>10` (is it greater than 10?)

Ready to teach your computer how to make smart choices? Let's go!

---
### General Exercises

1.  **Even or Odd?:** Ask for a number. Use the modulo (`///`) command to check if the remainder when divided by 2 is 0. Print whether the number is "Even" or "Odd".
2.  **Secret Password:** Store a secret password (like "magic"). Ask the user to guess it. If they are correct, print "Welcome!", otherwise print "Wrong password!".
3.  **Are You Old Enough?:** The age to ride a rollercoaster is 10. Ask for an age. If the age is 10 or greater, print "You can ride!". Otherwise, print "Sorry, you are not old enough."
4.  **The Magic Number:** Tell the user you're thinking of a number between 1 and 5. If their guess is correct (e.g., 3), print "You guessed it!". Otherwise, print "Nope, that's not it!".
5.  **It's Snack Time!:** Ask the user if they are hungry (they can type "yes"). If they say "yes", print "Time for a snack!". Otherwise, print "Okay, no snack right now."
6.  **Weekend Fun:** Ask for a day of the week. If the day is "Saturday", print "It's the weekend! Hooray!". Otherwise, print "It's a weekday, time to work."
7.  **Coin Flip:** Use the random command (`$`) to get a number that is either 1 or 2. If the number is 1, print "Heads!". Otherwise, print "Tails!".
8.  **Positive or Negative?:** Ask for a number. If it's greater than 0, print "It's positive!". If it's not, print "It's zero or negative!".
9.  **Too Long a Word?:** Ask the user for a word. Use the `_` command to find its length. If the length is greater than 10, print "That's a long word!".
10. **Thermostat Check:** Ask for the temperature. If it's greater than 25, print "It's hot!". If it's less than 15, print "It's cold!". Otherwise, print "It feels just right." (This will require more than one `#` check).

---
### Math Exercises

11. **Greater Than 100?:** Ask for a number. If it's greater than 100, print "That's a big number!".
12. **Is it a Triangle?:** Ask for the lengths of three sides of a triangle. Check if the first two sides added together are greater than the third side. If so, print "This could be a valid triangle!". Otherwise, print "This cannot be a triangle."
13. **Divisible by 5?:** Ask for a number. Use the modulo (`///`) command to see if it's perfectly divisible by 5. If the remainder is 0, print "This number is divisible by 5."
14. **Right Angle Check:** Ask for the measurement of an angle. If it is exactly 90 degrees, print "That's a right angle!".
15. **Square or Rectangle?:** Ask for the length and width of a shape. If the length and width are equal, print "This shape is a square!". Otherwise, print "This shape is a rectangle!".
16. **Fraction Check:** Ask for the top number (numerator) and bottom number (denominator) of a fraction. If the top number is smaller than the bottom number, print "This is a proper fraction."
17. **Negative Number Alert:** Ask for a number. If it's less than 0, print "That's a negative number!".
18. **Is it a Dozen?:** Ask for a number. If it's exactly 12, print "That's a dozen!".
19. **Comparing Numbers:** Ask for two numbers. If the first number is greater than the second, print "The first number is bigger!".
20. **Zero Hero:** Ask for a number. If it is 0, print "You entered Zero!".

---
### Real-World Exercises

21. **Allowance Day:** Ask the user if they did their chores ("yes" or "no"). If they answer "yes", print "You get your allowance!".
22. **Bedtime Check:** Ask for the current hour. If the hour is 8 or later, print "It's past your bedtime!".
23. **Raining Outside?:** Ask if it is raining ("yes" or "no"). If "yes", print "Remember to take an umbrella!".
24. **Library Book Overdue?:** Ask how many days the user has had a library book. If it's more than 14, print "Your book is overdue!".
25. **Video Game Level Up:** You level up at 1000 points. Ask for a score. If the score is 1000 or more, print "Congratulations, you leveled up!".
26. **Party Invitation:** Ask how many friends are coming to a party. If the number is more than 10, print "Wow, that's a big party!".
27. **Washing Dishes:** Ask the user if they have eaten dinner ("yes" or "no"). If "yes", print "Time to wash the dishes!".
28. **Correct Change?:** An item costs $8 and you pay with $10. Ask the user how much change they got. If they enter 2, print "That's correct!".
29. **Team Sign-up:** A team needs at least 7 players. Ask how many players have signed up. If the number is less than 7, print "We need more players!".
30. **Is the Bus Late?:** The bus arrives at 8. Ask for the current time. If it's later than 8, print "The bus is late!".

---
## Bonus Section: Choices Inside Choices! (Nested Selection)

You've mastered making one choice at a time. But what if you need to make a choice, and then *another* choice right after that?

You can do this by putting one `if` block (`#`...`;`) **inside** another one. This is called **nested selection**.

Think about a game menu. First, you choose "Options". THEN, inside the options menu, you might choose "Difficulty". That's a choice inside a choice!

**Example: A Simple Game Menu**

Let's say the user can type "Start" or "Options". If they choose "Options", we'll then ask them to choose a difficulty: "Easy" or "Hard".

```bantas
' Ask the user for their menu choice
@,1
>,"Type Start or Options"

' --- First (Outer) Choice ---
@,1
#,"Start" ' IF the choice is "Start"...
  ?, "Starting the game... Go!"

! ' OTHERWISE...

  ' --- Second (Nested) Choice ---
  @,1
  #,"Options" ' Check IF the choice was "Options"...
    
    ' Ask another question!
    @,2
    >,"Choose difficulty: Easy or Hard"
    
    @,2
    #,"Easy" ' IF difficulty is "Easy"...
      ?, "Game set to Easy mode."
    ! ' OTHERWISE...
      ?, "Game set to Hard mode."
    ; ' End of the INNER choice

  ! ' OTHERWISE (if it wasn't Start or Options)...
    ?, "That's not a valid choice."
  ; ' End of the nested check
; ' End of the OUTER choice
```
See how the second choice (for difficulty) is completely nested inside the first one? This is a very powerful way to handle complex decisions.

### Bonus Exercises:

31. **Simple Text Adventure:** Your game starts. Ask the user if they want to go "left" or "right".
    *   If they go "left", then ask them if they want to open a "chest" or walk down a "path". Print a message confirming their final choice.
    *   If they go "right", then ask them if they want to cross a "bridge" or follow a "river". Print a message confirming their final choice.

32. **Vending Machine:** A vending machine has two rows, 'A' and 'B'.
    *   First, ask the user to choose a row ('A' or 'B').
    *   If they chose 'A', ask if they want "A1" for chips or "A2" for cookies.
    *   If they chose 'B', ask if they want "B1" for a candy bar or "B2" for pretzels.
    *   Print out what snack they get!
