	.file	"fib.c"
	.option nopic
	.text
	.align	2
	.globl	fib
	.type	fib, @function
# arg n in a0
# return in a1
fib:
  li t0, 2
  bge a0, t0, recursion
  mv a1, a0
  ret
recursion:
  addi sp, sp, -12 # move stack pointer
  sw   ra, 0(sp)   # push ra
  sw   s1, 4(sp)   # push s1
  sw   a0, 8(sp)   # push a0

  addi a0, a0, -1  # a0 = n - 1
  jal  ra, fib     # call fib(n-1)
  mv   s1, a1      # store fib(n-1)
  addi a0, a0, -1  # a0 = n - 2
  jal  ra, fib    # call fib(n-2)
  add  a1, a1, s1  # a1 = fib(n-1) + fib(n-2)

  lw   ra, 0(sp)   # load ra
  lw   s1, 4(sp)   # load s1
  lw   a0, 8(sp)   # load a0
  addi sp, sp, 12  # back stack pointer
  ret              # return a1
	.size	fib, .-fib
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32 # allocate stack pointer
	sw	ra,28(sp)   # push ra
	sw	s0,24(sp)   # push s0

  li  a0, 10
	call	fib

	lw	ra,28(sp) # load ra
	lw	s0,24(sp) # load s0
	addi	sp,sp,32 # back sp

	jr	ra # return
	.size	main, .-main
	.ident	"Fibo Exp2"

