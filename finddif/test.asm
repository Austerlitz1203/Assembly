seg1 segment
    buf  dw 100 dup(?)
seg1 ends

code segment
          assume cs:code, ds:seg1
    start:
          mov    bx,0
          MOV    AX,3000H
          MOV    DS,AX               ;条件1
          MOV    AX,4000H
          MOV    ES,AX               ;条件2
          MOV    SI,1500H            ;条件3
          MOV    DI,2000H            ;条件4
          MOV    CX,100              ;条件5
    camp: 
          CLD                        ;条件6
          REPE   CMPSB               ;si，di自动后移
          JNZ    carry               ;不匹配的话，存偏移位置
    ;执行到这里就是匹配的情况，此时要判断cx
          cmp    cx,0
          jz     done                ;执行这一句，说明cx已经为0，跳到done
    carry:
          mov    ax,DI
          dec    ax
          mov    buf[bx],ax
          add    bx,2
          jmp    camp                ;loop会使cx-1
    done: 
          mov    ax,4c00h
          int    21h

code ends
  end start
