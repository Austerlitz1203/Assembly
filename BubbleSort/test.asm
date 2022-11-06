; n equ 10   ;有10个数据

; seg1 segment
;     a    dw 0012H,6H,9H,10H,55H,43H,69H,20H,33H,89H
; seg1 ends

; code segment
;             assume cs:code,ds:seg1
;     start:  
;             mov    ax,seg1
;             mov    ds,ax
;             mov    cx,n
;             dec    cx                 ;实际循环N-1次就行
;     loopl:  
;     ;相当于初始化一下
;             mov    di,cx
;             mov    bx,0
;     loop2:  
;     ;相当于C语言中的判断，交换语句，即循环内部的程序
;             mov    ax,a[bx]
;             cmp    ax,a[bx+2]
;             jge    cotinue
;             xchg   ax,a[bx+2]
;             mov    a[bx],ax
;     cotinue:
;     ;相当于C语言中的i++，循环控制条件
;             add    bx,2
;             loop   loop2              ;注意这里，loop指令会把cx-1，cx=0则不跳转
;             mov    cx,di              ;这里是因为上面loop指令导致cx=0，然后执行此条指令
;             loop   loopl              ;loop指令又把cx-1，所以比上一次要少执行一次
            
;             mov    ax,4c00h
;             int    21h
; code ends
;   end start

; ;但是这种方法不推荐，因为要比较熟悉LOOP和cx，然后固定死的循环次数，在 良序 的情况下浪费资源





data segment
    buf        dw 5,56H,33H,78H,90H,1H
    save_cnt   dw ?
    start_addr dw ?
data ends

code segment
           assume cs:code, ds:data
    start: 
    ;    push   ds
    ;    push   cx
    ;    push   ax
    ;    push   bx
           mov    ax, data
           mov    ds, ax
           mov    start_addr, di
           mov    cx, buf[di]         ;第一个元素是存的数组内数据个数
           mov    save_cnt ,cx
    init:  
           mov    bx,1                ;相当于标记，如果bx为0，那么做了交换步骤，否则就已经排好序，直接跳出循环
           dec    save_cnt            ;每次-1
           jz     sorted              ;最多做save_cnt-1次循环，然后跳出
           mov    cx, save_cnt
           mov    di, start_addr
    next:  
           add    di, 2
           mov    ax, buf[di]
           cmp    buf[di+2], ax
           jae    cont                ;后一个比前一个大的话，不需要交换，直接跳转
           xchg   buf[di+2], ax
           mov    buf[di],ax
           sub    bx, bx              ;执行交换操作之后，bx置为0，这样子代表交换过
    cont:  
           loop   next                ; 后一个大之后跳到这里
           cmp    bx,0                ;一轮循环比较完之后再看bx是否为0
           je     init                ;为0代表交换过了，直接跳转到init开始下一轮循环
    sorted:
           mov    di, start_addr
    ;    pop    bx
    ;    pop    ax
    ;    pop    cx
    ;    pop    ds
           mov    ax,4c00h
           int    21h

code ends
  end start





