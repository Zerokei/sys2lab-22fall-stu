# 常见问题及解答

## 1 仿真和上板结果对不上怎么办

往往是一些 Verilog 代码的细节不当，导致了综合器无法综合出与你预期的代码。

首先可以尽可能地消除你的工程中的 Warnings。此外，可以参考这份 [slides](http://www.ee.ncu.edu.tw/~jfli/vlsidi/lecture/Verilog-2012.pdf) 的 17-31 页检查你的工程。

## 2 Linux 源码放在共享文件夹下编译失败

这种情况请使用 `wget` 等工具将 Linux 源码下载至容器内目录**而非共享目录**，然后执行编译。

## 3 运行时出现 `localhost:1234: Connection timed out.`

检查 qemu 启动时是否开启了 `-s` 选项。

## 4 QEMU+GDB 使用 `si` 单指令调试遇到模式切换失效

在遇到诸如 `mret`, `sret` 等指令造成的模式切换时，`si` 指令会失效，可能表现为程序开始不停跑，影响对程序运行行为的判断。

一个解决方法是在程序**预期跳转**的位置打上断点，断点不会受到模式切换的影响，比如：

```bash
(gdb) i r sepc    
sepc        0x8000babe
(gdb) b * 0x8000babe
Breakpoint 1 at 0x8000babe
(gdb) si    # 或者使用 c
Breakpoint 1, 0x000000008000babe in _never_gonna_give_you_up ()
...
```

这样就可以看到断点被触发，可以继续调试了。

## 5. Function Prologue and Epilogue in C

在实验中C语言编译出的函数会多出一部分非程序的代码，集中在函数的开头与结尾，这被称作`Prologue`和`Epilogue`，他们起到了分配栈空间等作用，具体的信息可以查看这个[回答](https://stackoverflow.com/questions/14765406/function-prologue-and-epilogue-in-c)。

## 6. mtime & mtimecmp

在QEMU中也可以方便地查看`mtime`和`mtimecmp`的值，`mtime`和`mtimecmp`的实现是通过MMIO(Memory-mapped I/O)的方式实现的，在QEMU的默认设置中`mtime`的地址位于`0x200bff8`，读这个地址的值就是`mtime`的值(实验中是一个64bit的量)，`mtimecmp`的地址在`0x2004000`。

## 7. 杂项

* 设置sp寄存器是为了给C语言提供运行环境，需要在执行任何C语言编写的函数前准备好栈
* C语言默认的整数常数类型为整形，如果需要使用长整形使用`1L << 63`
* gdb卡住时可以通过`ctrl+C`查看程序当前运行状态，遇到非预期的异常时可以通过`scause, sepc`的值进行跟踪和调试，注意并不是所有地址都是可供读写的，请尽量确保读写的地址落在栈空间和给每个进程分配的空间上
* 在Makefile的编译选项`CFLAG`中加入`-g`选项可以在调试时通过`layout src`查看源码，但是在过程中可能会出现部分变量显示为`<error reading variable: dwarf2_find_location_expression: Corrupted DWARF expression.>`的情况，这是`gcc`的一个bug，在新版本已经修复，在本次实验中可以通过关闭`-O3`优化选项来解决