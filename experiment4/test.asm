SEG1 SEGMENT
    BUF    DB 'As398*#fh!Hb$9M'
    NUM    DW $-BUF                ;BUF 含有的数字个数
    COUNT1 DB 00H                  ;大写字母  65 - 90   十六进制 41-5a
    COUNT2 DB 00H                  ;小写字母  97 - 122          61-7a
    COUNT3 DB 00H                  ;数字      48 - 57           30-39
    COUNT4 DB 00H                  ;其他
    TEMP   DW 00H                  ;
SEG1 ENDS

CODE SEGMENT
          ASSUME CS:CODE ,DS:SEG1
    START:
          MOV    AX,SEG1
          MOV    DS,AX
          MOV    CX,NUM               ;CX来计数
          MOV    BX,0
    INIT: 
          MOV    AX,0
          MOV    AL,BUF[BX]
          MOV    TEMP,AX
          INC    BX                   ;先放进去，再+1

    ;大写字母 65-90
    LOOP1:
          MOV    DX,41H
          CMP    TEMP,DX
          JB     LOOP3                ;TEMP < 65 ,则是在数字里面比较
          MOV    AX,5aH
          CMP    TEMP,AX
          JA     LOOP2                ;TEMP > 90 ,则是在小写字母里比较
          INC    BYTE PTR [COUNT1]
          LOOP   INIT
          JMP    EXIT                 ; CX=0跳转

    ;小写字母 97 - 122
    LOOP2:
          MOV    DX,61H
          CMP    TEMP,DX
          JB     LOOP4
          MOV    AX,7aH
          CMP    TEMP,AX
          JA     LOOP4
          INC    BYTE PTR [COUNT2]
          LOOP   INIT
          JMP    EXIT

    ;数字  48 - 57
    LOOP3:
          MOV    DX,30H
          CMP    TEMP,DX
          JB     LOOP4
          MOV    AX,39H
          CMP    TEMP,AX
          JA     LOOP4
          INC    BYTE PTR [COUNT3]
          LOOP   INIT
          JMP    EXIT

    ;其他
    LOOP4:
          INC    BYTE PTR [COUNT4]
          LOOP   INIT

    EXIT: 
          MOV    AX,4C00H
          INT    21H
CODE ENDS
  END START