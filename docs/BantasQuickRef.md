# Bantas Command Quick Reference Sheet

## **Core Commands**

| Symbol | Name | What it does | Example |
| :--- | :--- | :--- | :--- |
| `?` | Print | Prints something on a **new line**. | `?,Hello` |
| `??` | Print (Same Line) | Prints something and **stays on the same line**. | `??,Hello` |
| `<` | Store | **Puts** a value into the active memory box. | `<,10` |
| `@` | Use Box / Get Value | `@,1` **chooses** box #1. `?,@1` **gets** the value from it. | `@,1` or `?,@1`|
| `@@` | Secret Pointer | Gets a value by looking in two boxes (a treasure hunt!). | `?,@@2`|
| `>` | Ask User | Asks the user a question and stores their answer. | `>,"Your name?"`|

## **Looping (Repeating)**

| Symbol | Name | What it does | Example |
| :--- | :--- | :--- | :--- |
| `[` | Loop Start | Starts a repeating block of code. | `[,1` |
| `]` | Loop End | Ends a repeating block. | `],5` or `],<5` |
| `@0` | Loop Counter | The magic variable that holds the loop's current number. | `?,@0` |
| `@,0` | Use Loop Counter | Lets you manually change the loop's counter. | `@,0` |

## **Choices (If/Else)**

| Symbol | Name | What it does | Example |
| :--- | :--- | :--- | :--- |
| `#` | If | Checks if a condition is true. | `#,=10` |
| `!` | Else | Runs if the `#` (if) condition was false. | `!` |
| `;` | End If | Marks the end of the choice block. | `;` |

## **Math Commands**

| Symbol | Name | What it does | Example |
| :--- | :--- | :--- | :--- |
| `+` | Add | Adds a number to the value in the active box. | `+,5` |
| `-` | Subtract | Subtracts a number from the value in the active box. | `-,3` |
| `*` | Multiply | Multiplies the value in the active box. | `*,2` |
| `/` | Divide | Divides the value in the active box. | `/,4` |
| `//` | Integer Divide | Divides and keeps the **whole number**. | `//,3` |
| `///`| Modulo | Gets the **remainder** of a division. | `///,2` |
| `^` | Power Up | Puts a value to the power of another value. | `^,3` |
| `$` | Random | Gets a random number from 1 up to the value given. | `$,10` |

## **Working with Words (Strings)**

| Symbol | Name | What it does | Example |
| :--- | :--- | :--- | :--- |
| `&` | Join | Joins two words together. | `&, World` |
| `><` | Tidy Up (Trim) | Removes extra spaces from the start and end of a word. | `><,"  Hi  "` |
| `_` | Length | **Measures** the length of a word. | `_,Hello` |
| `(` | Left | Gets a piece of a word from the **left**. | `(,3` |
| `)` | Right | Gets a piece of a word from the **right**. | `),2` |

## **Trigonometry**

| Symbol | Name | What it does | Example |
| :--- | :--- | :--- | :--- |
| `{` | Sine | Calculates the sine of an angle in degrees. | `{,90` |
| `}` | Cosine | Calculates the cosine of an angle in degrees. | `},0` |
| `\` | Tangent | Calculates the tangent of an angle in degrees. | `\,45` |

## **Type and Format**

| Symbol | Name | What it does | Example |
| :--- | :--- | :--- | :--- |
| `.` | Letter to Number | Converts a letter to its secret computer number. | `.,A` |
| `:` | Number to Letter | Converts a secret computer number back to a letter. | `:,65` |
| `%` | Format | Changes how a word or number looks (e.g., UPPERCASE). | `%,U` |

**Bantas Web (based on Bantas 1.4.7 Beta)**

Copyright (c) 2025 Jon Velasco a.k.a. muthym
