dseg segment
    start_addr dw ?
dseg ends

cseg segment
b__search proc far
    start:    
              assume cs:cseg,ds:dseg
              push   ds
              push   ax
              mov    ax,dseg
              mov    ds,ax
              pop    ax
              cmp    ax,es:[di+2]
              ja     chk_last
              lea    si,es:[di+2]
              je     exit
              stc
              jmp    exit
    chk_last: 
              mov    si, es:[di]
              shl    si,1
              add    si,di
              cmp    ax,es:[si]
              jb     search
              je     exit
              stc
              jmp    exit
    search:   
              mov    start_addr,di
              mov    si,es:[di]
    Even_idx: 
              test   si, 1
              jz     add_idx
              inc    si
    add_idx:  
              add    di, si
    compare:  
              cmp    ax,es:[ di]
              je     all_done
              ja     higher
              cmp    si, 2
              jne    idx_ok
    no_match: 
              stc
              je     all_done
    idx_ok:   
              shr    si, 1
              test   si, 1
              jz     sub_idx
              inc    si
    sub_idx:  
              sub    di, si
              jmp    short compare
    higher:   
              cmp    si, 2
              je     no_match
              shr    si, 1
              jmp    short even_idx
    all_done: 
              mov    si, di
              mov    di, start_addr
    exit:     
              pop    ds
              ret
b__search endp
cseg ends
  end start