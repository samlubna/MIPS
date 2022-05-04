# resources https://minnie.tuhs.org/CompArch/Resources/mips_quick_tutorial.html
.data # The data segment
# ensure the number of elements in the array is a product of the row and column size
# remember to change the row and column sizes accordingly
array: .word 1,2,3,4,5,6,7,8
row: .word 1
column: .word 8
dataSize: .word 4
# A next line character
newLine: .asciiz "\n"
space: .asciiz " "

.text # The text segment
main:
    # Range of outer loop is between registers $t0 and $t1
    li $t0, 0
    lw $t1, row
    # Range of inner loop is between registers $t2 and $t3
    li $t2, 0
    lw $t3, column
    # The datasize to calculate the array offset
    lw $t4, dataSize
    # The offset is = (row_index * column_size + column_index) * data_size
    # the row index is the index of the outer loop
    # the column index is the index of the inner loop
    # column * datasize 
    mult $t3, $t4
    # store result in t5
    mflo $t5
for_1:
    beq $t0, $t1, exit_1
    # t5 * row_index 
    mult $t5, $t0
    # store result in t6
    mflo $t6
    # set t2 to 0 for the inner loop
    li $t2, 0
    for_2:
        beq $t2, $t3, exit_2
        li $v0, 1
        # access the 2d array
        lw $a0, array($t6)
        # call to print value
        syscall
        li $v0, 4
        # call to print space
        la $a0, space
        syscall
        # increment inner loop
        addi $t2,$t2,1
        # incrment t6 with the data size = column_index * datasize
        add $t6, $t6, $t4 
        j for_2
    exit_2:
    	# increment outer loop
        addi $t0, $t0, 1
        #call to print next line
        la, $a0, newLine
        syscall
        j for_1
exit_1:
    # a call for program termination
    li $v0, 10
    syscall