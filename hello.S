/*
 * hello-1.1/Makefile
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
 * Copyright (C) 1995 by Ralf Baechle
 * Copyright (C) 2013 by Joël Porquet
 */

#include <linux/unistd.h>

#define AT_FDCWD 	-100
#define O_RDWR		00000002

	.set    noreorder
	.globl	_start
	.align	2
	.type	_start, @function
	.ent	_start, 0
_start:
	.frame	$29, 0, $31


#       fd = open("/dev/console", O_RDWR, 0);
	li	$4, AT_FDCWD
	la      $5, console_path
	li      $6, O_RDWR
	li      $7, 0
	li      $2, __NR_openat
	syscall

	bltz    $2, quit
	move    $16, $2                           # delay slot

#       write(fd, "Hello, world.\n", 14);
	#move    $4, $16
	li      $4, 1 // stdout
	la      $5, hello_str
	li      $6, 14
	li      $2, __NR_write
	syscall

	bltz    $2, quit
	nop

#       close(fd);
	move    $4, $16
	li      $2, __NR_close
	syscall

#	exit(0)
	quit:
#	j	quit
#	nop
	li      $4, 0
	li      $2, __NR_exit
	syscall

	j       quit
	nop

	.end	_start
	.size	_start, .-_start


	.data
console_path:	.asciz  "/dev/console"
hello_str:	.ascii  "Hello, world.\n"
