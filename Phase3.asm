.data
prompt:                 .asciiz "Enter the amount of money: "
select:                 .asciiz "Select an item (1 for Water, 2 for Snacks, 3 for Sandwiches, 4 for Meals, -1 to exit): "
insufficient_balance:   .asciiz "Insufficient balance. Please enter another option."
remaining_balance:      .asciiz "Remaining balance: $"

.text
.globl main

main:
    li $v0, 4                   # Print prompt
    la $a0, prompt
    syscall

    li $v0, 5                   # Read amount of money
    syscall
    add $t0, $zero, $v0         # $t0 = amount of money entered

    li $t1, 0                   # Initialize balance

loop:
    li $v0, 4                   # Print selection prompt
    la $a0, select
    syscall

    li $v0, 5                   # Read user selection
    syscall
    add $t2, $zero, $v0         # $t2 = user selection

    beq $t2, -1, end            # If user selects -1, exit loop

    # Calculate price based on selection
    beq $t2, 1, water
    beq $t2, 2, snacks
    beq $t2, 3, sandwiches
    beq $t2, 4, meals
    j invalid_selection

water:
    li $t3, 1                   # Water price
    j check_balance

snacks:
    li $t3, 2                   # Snacks price
    j check_balance

sandwiches:
    li $t3, 3                   # Sandwiches price
    j check_balance

meals:
    li $t3, 4                   # Meals price
    j check_balance

check_balance:
    sub $t4, $t0, $t1           # Calculate remaining balance
    blt $t4, $t3, insufficient_balance  # If balance < price, print error message
    add $t1, $t1, $t3           # Update balance
    j loop

invalid_selection:
    # Print error message for invalid selection
    li $v0, 4
    la $a0, insufficient_balance
    syscall
    j loop

end:
    # Print remaining balance
    li $v0, 4
    la $a0, remaining_balance
    syscall

    li $v0, 1
    move $a0, $t0               # Load remaining balance into $a0
    syscall

    li $v0, 10                  # Exit program
    syscall
