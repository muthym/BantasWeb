# The Bantas Loop Workbook: Your Guide to Repeating Magic!

### The Three Pillars of Programming

All computer programs, from the simplest games to the most complex applications, are built using three basic ideas:

1.  **Sequence:** Doing things in order, from top to bottom. This is the default!
2.  **Repetition (Loops):** Repeating a set of instructions.
3.  **Selection (Choices):** Choosing which instructions to run.

You have already mastered sequence by writing your first programs. Now, let's learn about **Repetition**!

---

Hello, future coding master!

Welcome to the world of loops. Loops are one of the most powerful tools a programmer has. Think of them as a way to teach the computer how to do something over and over again, so you don't have to!

## Meet Your Looping Robot!

Imagine you have a robot. You can give it a list of instructions, and it will follow them. But what if you want it to do the same thing 10 times? You could write the instruction 10 times... or you could use a **loop**!

A loop is like telling your robot: "**Repeat these steps until I tell you to stop.**"

In Bantas, our robot's instructions look like this:

```bantas
[  ... instructions go here ... ]
```

The `[` is like saying "Robot, start looping!"
The `]` is like saying "Robot, this is the end of the loop instructions."

### The Basic Counting Loop (Automatic)

The most common loop is an automatic counting loop. It's like telling your robot: "Count from 1 to 5, and I trust you to handle the counting."

```bantas
' This loop will run 5 times
[,1   ' Start counting at 1
  ?,@0  ' @0 is the robot's current number
],5   ' Stop when you get to 5
```
This will print:
```
1
2
3
4
5
```
The robot automatically adds 1 to its counter after each pass.

### Taking Control: Manual Counting

What if you want to count by 2s, or 10s, or even backwards? You can take control of the counting yourself!

If you change the loop counter (`@0`) inside the loop using `+` or `-`, the Bantas interpreter sees that you want to be in charge of the counting, and it will **turn off its automatic +1 counting**.

**Example: Counting from 2 to 10 by 2s**
```bantas
[,2      ' Start at 2
  ?,@0    ' Print the current number
  
  @,0     ' Tell the robot you want to change its counter
  +,2     ' Manually add 2 to the counter
],10     ' The loop will stop when the counter goes past 10
```
This will print:
```
2
4
6
8
10
```
You are now in full control of how the loop progresses!

## The "Smarter" While Loop

Sometimes, you don't want to loop a specific number of times. Instead, you want to loop **while** something is true.

It's like telling your robot: "**Keep going while the treasure chest is not full.**"

In Bantas, we can do this by adding a condition to the end of our loop.

```bantas
[,1
  ?,@0
],<5  ' The condition is: Keep looping WHILE the Tally Counter is LESS THAN 5
```
This loop will run for numbers 1, 2, 3, and 4. When the Tally Counter becomes 5, the condition `],<5` is no longer true, so the robot stops!

You can use different conditions:
*   `],<10` (while less than 10)
*   `],>0` (while greater than 0)
*   `],=7` (while equal to 7)

## Loops Inside Loops (Nested Loops)

Now for the really cool part! You can put a loop inside another loop. This is called a **nested loop**.

Imagine you have a "Boss Robot" and a "Helper Robot".
The Boss Robot can tell the Helper Robot to run its own loop. This is perfect for making patterns and drawing shapes!

**Note:** The original example for nested loops had a bug that caused an error in the interpreter. The example below is a workaround that produces the correct output.

```bantas
' Boss Robot's Loop (runs 3 times)
[,1  
  ' Helper Robot's Loop
  @,1
  <,@0
  [,1
    ??,"*"  ' Print a star without a new line
  ],@1      ' Helper robot stops at the Boss robot's current number
  ?,""      ' Print a new line to move down
],3 
```

**Wait, what happened?**
1.  The Boss Robot starts its loop at `1`.
2.  It tells the Helper Robot to loop from `1` to the Boss's current number (`@0`, which is `1`). The helper prints `*`.
3.  The Boss Robot then prints a new line.
4.  The Boss Robot moves to its next number, `2`.
5.  It tells the Helper Robot to loop from `1` to `2`. The helper prints `*` `*`.
6.  And so on!

The output is a triangle!
```
*
**
***
```

**Super Important Tip:** When you have a loop inside another, `@0` **always** belongs to the **inner loop** (the Helper Robot). If you need the Boss Robot's number, you should save it somewhere else first!

---
## Your Bantas Toolbox: Essential Commands

Before you start the exercises, let's look at the essential tools you'll need. Think of these as the extra gadgets for your Looping Robot!

### A Quick Note on Quotes (`"`)

You will see some words (strings) in Bantas code with double quotes (`"`) and some without. What's the difference?

The rule is simple: **You only NEED quotes when your word could be confused for something else, like a number or a command.**

*   **Simple words are fine without quotes:**
    *   `?,Hello` is okay. Bantas knows `Hello` is a word.

*   **When you MUST use quotes:**
    1.  **When your "word" is made of only numbers:** If you want to treat the number `123` as a word, you must use quotes.
        *   `<,123` stores a **number**.
        *   `<,"123"` stores the **word** "123".
    2.  **When your word looks like a command or reference:** If you wanted to print the literal text `@1`, you must use quotes.
        *   `?,@1` gets the value from **memory box #1**.
        *   `?,"@1"` prints the literal **word** "@1".

When in doubt, using quotes for your words is always a safe bet!

### Printing: `?` vs. `??`

*   `?` **(Print with Newline):** This command prints your message and then moves the cursor down to the **next line**. It's like hitting the "Enter" key after typing.
    *   **Example:** `?,Hello` followed by `?,World` will print:
        ```
        Hello
        World
        ```

*   `??` **(Print on Same Line):** This command prints your message but keeps the cursor on the **same line**. This is perfect for building a line piece by piece, like when drawing shapes.
    *   **Example:** `??,Hello ` followed by `??,World` will print:
        ```
        Hello World
        ```

### Memory Boxes: Stacks (`@` and `<`)

Imagine you have a wall of numbered boxes where you can store things. In Bantas, these are called **stacks**.

*   `<` **(Store a Value):** Puts a value (a number or a word) into the currently active box.
*   `@` **(Choose a Box or Get a Value):**
    1.  **Choose a box:** `@,1` tells the computer, "Get ready to work with box #1."
    2.  **Get a value:** `?,@1` means "Get the value from box #1 and print it."

### Advanced Memory: The Double `@` Trick (`@@`)

This is a super cool trick! `@@` is like having a secret note inside one box that tells you the number of *another* box to open.

Imagine:
*   Box #2 has a secret note inside that says "11".
*   Box #11 has the word "Treasure!" inside.

If you tell the robot `?,@@2`, it will:
1.  Go to box #2.
2.  Read the secret note, which says "11".
3.  Then go to box #11 and get the value from there.
4.  It will print "Treasure!".

It's a two-step treasure hunt for your values!

### Talking to the User: `>`
The `>` command lets your program ask the user a question and stores their answer in the active memory box.

### Working with Words (Strings)

These commands help you play with words!

*   `&` **(Join Words Together):** Joins words (we call them "strings") together.
    *   **Example:** If box #1 has "Hello", `&, World` will change it to "Hello World".
*   `_` **(Measure Word Length):** Measures how many characters are in a word and stores that number.
    *   **Example:** `_,Bantas` would store the number `6`.
*   `(` **(Get a Piece from the Left):** Grabs a certain number of characters from the beginning of a word.
    *   **Example:** If a box has "Bantas", `(,3` will change it to "Ban".
*   `)` **(Get a Piece from the Right):** Grabs a certain number of characters from the end of a word.
    *   **Example:** If a box has "Bantas", `),3` will change it to "tas".

---

### Bantas Programming Exercises for Loops (Number Series)

**Instructions:** For each exercise, write a Bantas program that uses loops to generate or calculate the requested number series.

1.  **Count Up to 10:**
    *   Write a program that prints numbers from 1 to 10, each on a new line.
    *   *(Hint: You won't need user input for 'n' here, just loop from 1 to 10.)*

2.  **Count Down from 5:**
    *   Write a program that prints numbers from 5 down to 1, each on a new line.
    *   *(Hint: You'll need to start your loop at 5 and make sure it counts downwards.)*

3.  **Even Numbers Up to 20:**
    *   Write a program that prints all even numbers from 2 up to 20.
    *   *(Hint: Start your loop at 2 and add 2 in each step, or use the modulo operator to check if a number is even.)*

4.  **Odd Numbers Up to 15:**
    *   Write a program that prints all odd numbers from 1 up to 15.
    *   *(Hint: Start your loop at 1 and add 2 in each step, or use the modulo operator to check if a number is odd.)*

5.  **Multiples of 3 (up to 30):**
    *   Write a program that prints the first few multiples of 3, starting from 3, up to 30.
    *   *(Hint: Start your loop at 3 and add 3 in each step.)*

6.  **Sum of First 5 Numbers:**
    *   Write a program that calculates and prints the sum of the numbers from 1 to 5 (i.e., 1 + 2 + 3 + 4 + 5).
    *   *(Hint: Use a loop to add each number to a running total in a separate stack.)*

7.  **Print a Simple Sequence:**
    *   Ask the user for a starting number. Then, print that number and the next 4 numbers after it.
    *   *(Example: If user enters 7, output should be 7, 8, 9, 10, 11.)*

8.  **Square Numbers (First 5):**
    *   Write a program that prints the first 5 square numbers (1, 4, 9, 16, 25).
    *   *(Hint: In your loop, multiply the current loop counter by itself.)*

9.  **Repeat a Message:**
    *   Ask the user for a number `N`. Then, print the message "Bantas is Fun!" `N` times.
    *   *(Hint: The loop counter doesn't have to be printed, just used to control how many times the message appears.)*

10. **Countdown with a Message:**
    *   Ask the user for a starting number `N`. Then, count down from `N` to 1, printing each number. After 1, print "Blast Off!".
    *   *(Example: If user enters 3, output should be 3, 2, 1, Blast Off!)*


### More Fun Loop Adventures!

11. **The Growing Flower:**
    *   A flower starts as a seed (size 1) and doubles in size every day. Print the flower's size for 7 days.
    *   *(Hint: Start with a variable for size at 1, and in a loop from 1 to 7, print the size and then multiply it by 2.)*

12. **Building a Wall:**
    *   You are building a wall with bricks. The wall is 10 bricks high. Print the height of the wall as you add each brick, from 1 to 10.
    *   *(Example: "Height: 1", "Height: 2", ... "Height: 10")*

13. **A Bouncing Ball:**
    *   A ball is dropped from a height of 100 meters. Each time it bounces, it reaches half of its previous height. Print the height of the ball after each of the first 5 bounces.
    *   *(Hint: Start with height = 100. In a loop that runs 5 times, calculate the new height and print it.)*

14. **Marching Ants:**
    *   A line of 8 ants is marching. Print a message for each ant, like "Ant #1 is marching.", "Ant #2 is marching.", and so on.
    *   *(Hint: Use a loop from 1 to 8 and include the loop counter in your print message.)*

15. **Triangle of Stars:**
    *   Create a right-angled triangle of stars that is 5 stars tall.
    *   *(Hint: You might need a loop inside a loop! The outer loop can control the rows, and the inner loop can print the stars for each row.)*
    *   **Example Output:**
        ```
        *
        **
        ***
        ****
        *****
        ```

16. **The Echo Cave:**
    *   Ask the user for a word. Then, using a loop, print the word 5 times, each time with one more "echo" (a dot at the end).
    *   *(Example: If the user enters "Hello", print: "Hello.", "Hello..", "Hello...", "Hello....", "Hello.....")*

17. **The Frog's Journey:**
    *   A frog wants to cross a pond by jumping on 12 lily pads, numbered 1 to 12. Print a message for each jump, like "Frog is on lily pad #1".
    *   *(Hint: This is similar to the marching ants exercise. Use a loop to go from 1 to 12.)*

18. **Countdown to Bedtime:**
    *   It's almost bedtime! Count down from 10 to 1. After 1, print "Time for bed! Zzzz..."
    *   *(Hint: This is a variation of the "Blast Off!" exercise. Just change the final message.)*

19. **The Wise Old Owl:**
    *   An owl hoots a number of times equal to its age. If the owl is 8 years old, make it hoot 8 times.
    *   *(Hint: Ask the user for the owl's age, then use a loop to print "Hoot!" that many times.)*

20. **Stepping Stones:**
    *   You are crossing a river on 10 stepping stones, numbered 1 to 10. You can only step on the even-numbered stones. Print the numbers of the stones you step on.
    *   *(Hint: Use a loop from 1 to 10 and check if the number is even before printing it.)*

### Learning with Loops: School Subjects Edition!

21. **Math Whiz - Multiplication Tables:**
    *   **Subject: Math**
    *   Ask the user for a number from 1 to 10. Then, use a loop to print its multiplication table up to 10.
    *   *(Example: If the user enters 7, it prints "7 x 1 = 7", "7 x 2 = 14", ... "7 x 10 = 70".)*

22. **Science Class - Rocket to the Moon!**
    *   **Subject: Science**
    *   A rocket is 384,400 km away from the moon. Let's pretend it travels 50,000 km every hour. Print the remaining distance to the moon for 7 hours.
    *   *(Hint: Start with a distance of 384,400. In a loop that runs 7 times, subtract 50,000 from the distance and print the new distance.)*

23. **Art Class - Let's Draw a Square!**
    *   **Subject: Art/Math**
    *   Ask the user for a number between 1 and 5. Then, draw a square of that size using the '#' symbol.
    *   *(Hint: You'll need a loop inside a loop. The outer loop handles the rows, and the inner loop prints the '#' for each row.)*
    *   **Example for size 3:**
        ```
        ###
        ###
        ###
        ```

24. **History Class - Ancient Pyramids:**
    *   **Subject: History**
    *   The ancient Egyptians built pyramids with steps. Let's build a small one! Create a pyramid of blocks that is 4 levels high.
    *   *(Hint: This is similar to the triangle of stars, but you can use a block character like '[]' or just '#'.)*
    *   **Example Output:**
        ```
        #
        ##
        ###
        ####
        ```

25. **English Class - Spelling Bee:**
    *   **Subject: English**
    *   Ask the user for a 5-letter word. Then, use a loop to print each letter of the word on a new line to practice spelling.
    *   *(Hint: Depending on how Bantas works with words, you might need to ask the user to enter each letter one by one.)*

26. **Music Class - A Simple Beat:**
    *   **Subject: Music**
    *   Create a simple drum beat that repeats. Use a loop to print "Boom! Clap! Boom! Clap!" four times.
    *   *(Hint: The loop will run 4 times, and inside you will print the beat.)*

27. **P.E. Class - Jumping Jacks!**
    *   **Subject: Physical Education**
    *   Let's do 10 jumping jacks! Use a loop to count from 1 to 10, printing "Jumping Jack #1!", "Jumping Jack #2!", and so on.
    *   *(Hint: This is very similar to the Marching Ants exercise.)*

28. **Geography Class - Exploring Caves:**
    *   **Subject: Geography**
    *   You are an explorer going deeper into a cave. You are walking 100 meters at a time. Print your total distance as you explore for 500 meters.
    *   *(Hint: Use a loop that adds 100 to a total distance variable, and print the total distance in each step, up to 500.)*
    *   **Example Output:** "Distance explored: 100m", "Distance explored: 200m", ...

29. **Biology Class - Butterfly Life Cycle:**
    *   **Subject: Science**
    *   Let's show the 4 stages of a butterfly's life. Use a loop to print the stages in order: 1. Egg, 2. Larva (Caterpillar), 3. Pupa (Chrysalis), 4. Adult (Butterfly).
    *   *(Hint: You can use a loop that runs 4 times. Inside the loop, you'll need to print a different stage for each number from 1 to 4.)*

30. **Computer Science - Binary Code:**
    *   **Subject: Computer Science**
    *   Computers use binary code (0s and 1s). Let's create a simple binary pattern. Use a loop to print "0 1 " five times in a row.
    *   *(Example Output: "0 1 0 1 0 1 0 1 0 1 ")*

### Math Mania: Loop Challenges!

31. **Factorial Fun!**
    *   **Subject: Math**
    *   Calculate the factorial of a number. Ask the user for a number (like 5), and then calculate 5! (which is 5 x 4 x 3 x 2 x 1).
    *   *(Hint: Use a loop that counts down from the user's number and multiplies each number into a total.)*

32. **Powers of Two:**
    *   **Subject: Math**
    *   Print the first 8 powers of two (2¹, 2², 2³, etc.).
    *   *(Hint: Start with a variable at 1. In a loop that runs 8 times, print the variable and then multiply it by 2.)*
    *   **Example Output:** 2, 4, 8, 16, 32, 64, 128, 256

33. **Sum of the Evens:**
    *   **Subject: Math**
    *   Find the sum of all the even numbers from 1 to 20.
    *   *(Hint: Loop from 1 to 20. Inside the loop, check if the number is even. If it is, add it to a running total.)*

34. **What's the Average?**
    *   **Subject: Math**
    *   Ask the user to enter 5 numbers. After the 5th number, calculate and print their average.
    *   *(Hint: Use a loop that runs 5 times to get the numbers from the user and add them to a sum. After the loop, divide the sum by 5.)*

35. **Drawing a Rectangle:**
    *   **Subject: Math/Geometry**
    *   Ask the user for a width and a height (e.g., width 6, height 3). Then, draw a rectangle of that size using the '*' symbol.
    *   *(Hint: You'll need a loop inside a loop. The outer loop for the height, and the inner loop for the width.)*
    *   **Example for width 6, height 3:**
        ```
        ******
        ******
        ******
        ```

36. **Number Pyramid:**
    *   **Subject: Math**
    *   Print a pyramid of numbers where each row contains that row's number repeated.
    *   *(Hint: Use a loop inside a loop. The outer loop will go from 1 to 5. The inner loop will print the number from the outer loop that many times.)*
    *   **Example Output:**
        ```
        1
        22
        333
        4444
        55555
        ```

37. **Countdown by Tens:**
    *   **Subject: Math**
    *   Count down from 100 to 0, but only in steps of 10.
    *   *(Hint: Start your loop at 100 and subtract 10 in each step until you get to 0.)*
    *   **Example Output:** 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0

38. **Fibonacci Challenge:**
    *   **Subject: Math**
    *   The Fibonacci sequence is a famous pattern where each number is the sum of the two before it. Print the first 12 numbers in the sequence, starting with 0 and 1.
    *   *(Hint: You'll need two variables to keep track of the last two numbers. In a loop, you'll calculate the next number, print it, and then update your two variables.)*

39. **The Gauss Sum:**
    *   **Subject: Math**
    *   A famous mathematician named Gauss quickly found the sum of all numbers from 1 to 100. Can you write a program to do the same?
    *   *(Hint: Use a loop to go from 1 to 100, adding each number to a total. After the loop, print the final total.)*

40. **Triangle Numbers:**
    *   **Subject: Math**
    *   Triangle numbers are the sums of consecutive numbers (1, 1+2, 1+2+3, etc.). Print the first 7 triangle numbers.
    *   *(Hint: Use a loop inside a loop. The outer loop decides how many numbers to add (from 1 to 7), and the inner loop does the adding.)*
    *   **Example Output:** 1, 3, 6, 10, 15, 21, 28

### Loops in the Real World!

41. **Saving for a New Toy:**
    *   **Real-World Tie-in:** Saving Money
    *   You want to buy a new toy that costs $30. You save $5 each week. Write a program that shows your savings growing each week until you have enough money.
    *   *(Hint: Start with $0 savings. In a loop, add $5 to your savings and print the new total. The loop should stop when your savings reach $30.)*

42. **Daily Chore Chart:**
    *   **Real-World Tie-in:** Household Chores
    *   You have 3 chores to do every day: 1. Make your bed, 2. Feed the dog, 3. Tidy your room. Write a loop that prints out your list of chores for the day.
    *   *(Hint: This is similar to the butterfly life cycle exercise. Use a loop that runs 3 times and print a different chore for each number.)*

43. **Baking Cookies:**
    *   **Real-World Tie-in:** Cooking/Baking
    *   You are baking a batch of 12 cookies. Write a loop that simulates placing each cookie on a baking sheet, from "Placing cookie #1" to "Placing cookie #12".
    *   *(Hint: This is a simple counting loop from 1 to 12.)*

44. **Reading a Chapter Book:**
    *   **Real-World Tie-in:** Reading
    *   You are reading a book that has 100 pages. You read 10 pages every night. Write a loop that shows how many pages are left to read after each night for 5 nights.
    *   *(Hint: Start with 100 pages. In a loop that runs 5 times, subtract 10 from the total and print the number of pages left.)*

45. **Watering the Plants:**
    *   **Real-World Tie-in:** Gardening/Caring for Plants
    *   You have 6 plants in your house. Write a loop that prints a message for watering each plant, from "Watering plant 1" to "Watering plant 6".
    *   *(Hint: This is another counting loop, similar to the marching ants or jumping jacks.)*

46. **Packing for Vacation:**
    *   **Real-World Tie-in:** Travel
    *   You are packing for a 5-day vacation and you need to pack one pair of socks for each day. Write a loop that counts the socks as you pack them.
    *   *(Hint: Use a loop that goes from 1 to 5 and prints "Packing socks for day 1", "Packing socks for day 2", etc.)*

47. **Simple Workout Circuit:**
    *   **Real-World Tie-in:** Exercise/Health
    *   You are doing a workout circuit 3 times. The circuit is: 10 jumping jacks and 5 push-ups. Write a program that announces each round of the circuit.
    *   *(Hint: Use a loop that runs 3 times for the rounds. Inside, you can just print "Round 1: 10 jumping jacks, 5 push-ups", etc.)*

48. **Sharing Pizza Slices:**
    *   **Real-World Tie-in:** Sharing
    *   You have a pizza with 8 slices to share with your friend. You both take turns taking a slice. Show the number of slices left after each person takes one until the pizza is gone.
    *   *(Hint: Start with 8 slices. Use a loop that counts down by 1 and prints the number of slices remaining.)*

49. **Collecting Stickers:**
    *   **Real-World Tie-in:** Hobbies/Collecting
    *   You have a sticker book with 20 stickers in it. You get 2 new stickers every day for a week (7 days). Show how your sticker collection grows each day.
    *   *(Hint: Start with 20 stickers. Use a loop that runs 7 times. In each loop, add 2 to your total and print the new total.)*

50. **Screen Time Countdown:**
    *   **Real-World Tie-in:** Daily Routines
    *   Your parents give you 15 minutes of screen time. Write a program that counts down every minute from 15 to 0. When it reaches 0, it should print "Screen time is over!".
    *   *(Hint: This is a countdown loop, similar to the "Blast Off!" exercise.)*
