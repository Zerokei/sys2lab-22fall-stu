BASE_ADDR = 0;
SECTIONS
{
	. = BASE_ADDR;
	.text : {
		*(.text.init)
		*(.text.entry)
		*(.text)
		*(.text.*)
	 }
	.rodata : { 
		*(.rodata) 
		*(.rodata.*) 
	}
	.data : { 
		*(.data) 
		*(.data.*)
	}
	.bss : {
		PROVIDE(bss_start = .);
		. = ALIGN(8);
		*(.sbss)
		*(.sbss.*)
		*(.bss)
		*(.bss.*)
		. = ALIGN(8);
		PROVIDE(bss_end = .);
	}
	. = ALIGN(0x500);
	stack_top = .;
	_end = .;
}