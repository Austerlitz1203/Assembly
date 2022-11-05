SEG1 SEGMENT 
    X    DW 22c7H   ;8903
    Y    DW 0fd1H   ;4049
    M    DW 001eH
    N    DW 0064H   ;M*N=30*100=3000
    D    DW 0004H
    G    DW 0000H   ;结果应该是995，十六进制是3e3
    R    DW 0000H   ;结果应该是2，十六进制是2
    DN1  DW 0000H    ; 12952
    DN2  DW 0000H    ; 3000
    TDN2 DW 0000H
    DN3  DW 0000H    ; 10
SEG1 ENDS

CODE SEGMENT 
          ASSUME CS:CODE ,DS:SEG1
    START:
          MOV    AX,SEG1
          MOV    DS,AX
          MOV    AX,0
          MOV    BX,0
    ;计算加法
          MOV    AX,Y
          ADD    AX,X
          MOV    DN1,AX              ;低位放进去
    ;计算乘法
          MOV    AX,M
          MUL    N                   ;结果在dx，ax
          MOV    DN2,AX          ;低位放低位
          MOV    TDN2,DX         ;高位放高位
    ;计算除数
          MOV    AX,6
          ADD    AX,D
          MOV    DN3,AX              ;除数
    ;把被除数放到dx,ax里面
          MOV    AX,DN1
          CWD                        ;扩展ax，结果存在dx:ax里面，dx存高位，ax存低位
          SUB    DX,TDN2
          SUB    AX,DN2              ;现在ax里存的是被除数
    ;最终结果
          DIV    DN3                 ;现在AX存的商，DX存的余数
          MOV    G,AX
          MOV    R,DX

    ;退出
          MOV    AX,4C00H
          INT    21H
CODE ENDS
    END START



