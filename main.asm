.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO,   dwExitCode:DWORD 
ReadFile proto, a1: dword, a2: ptr byte, a3: dword, a4:ptr dword, a5: ptr dword
CreateFileA PROTO,  pFilename:PTR BYTE, accessMode:DWORD, shareMode:DWORD, lpSecurity:DWORD, howToCreate:DWORD, attributes:DWORD, htemplate:DWORD 
WriteConsoleA PROTO, handle:DWORD, lpBuffer:PTR BYTE, nNumberOfCharsToWrite:DWORD, lpNumberOfCharsWritten:PTR DWORD, lpReserved:PTR DWORD 
GetStdHandle proto, a1:dword
WriteFile PROTO, fileHandle:DWORD, pBuffer:PTR BYTE, nBufsize:DWORD, pBytesWritten:PTR DWORD,  pOverlapped:PTR DWORD  
ReadConsoleA PROTO,  handle:DWORD, lpBuffer:PTR BYTE, nNumberOfCharsToRead:DWORD, lpNumberOfCharsRead:PTR DWORD, lpReserved:PTR DWORD

.data
filepath byte 20 dup(?), 0
filepath1 byte 20 dup(?), 0
buff byte 1320000 dup(?)
line0 byte "Wrong Input. Try Again !", 1010b, 0
line1 byte "What would you like to do?",  1010b, 0
line2 byte "1.) Hide 2.) Recover",1010b, 0 
line3 byte "Enter your selection: ", 0
one1 byte "Please specify the source PPM filename: ", 0
one2 byte "Please specify the output PPM filename: ", 0
one3 byte "Please enter a phrase to hide: ", 0
one4 byte "Your message ", 0
one5 byte "has been hidden in file", 0
two1 byte "Please specify the source PPM filename: ", 0
two2 byte "The following message has been recovered from file: ", 0
message byte 50 dup(?), 0  
x dword ?
input byte 10 dup(?)
result byte 50 dup(?), 0

.code
main proc

first:
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset line1, lengthof line1, offset x, 0
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset line2, lengthof line2, offset x, 0
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset line3, lengthof line3, offset x, 0
invoke GetstdHandle, -10
invoke ReadConsoleA, eax, offset input, lengthof input, offset x, 0
movzx eax, input
sub eax, 48
mov esi, 1
cmp esi, eax
jz hide
mov esi, 2
cmp esi, eax
jz recover
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset line0, lengthof line0, offset x, 0
jmp first

hide: 
mov x, 0
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset one1, lengthof one1, offset x, 0
invoke GetstdHandle, -10
invoke ReadConsoleA, eax, offset filepath, lengthof filepath, offset x, 0
mov ecx, lengthof filepath
mov edx, 0
myloop:
mov al, filepath[edx]
cmp al, 0dh
jz outer
inc edx
loop myloop
outer: 
mov filepath[edx], 0
inc edx
mov filepath[edx], 0

invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset one2, lengthof one2, offset x, 0
invoke GetstdHandle, -10
invoke ReadConsoleA, eax, offset filepath1, lengthof filepath1, offset x, 0
mov ecx, lengthof filepath1
mov edx, 0
myloop1:
mov al, filepath1[edx]
cmp al, 0dh
jz outer1
inc edx
loop myloop1
outer1: 
mov filepath1[edx], 0
inc edx
mov filepath1[edx], 0

invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset one3, lengthof one3, offset x, 0
invoke GetstdHandle, -10
invoke ReadConsoleA, eax, offset message, lengthof message, offset x, 0
mov ecx, lengthof message
mov edx, 0
myloop2:
mov al, message[edx]
cmp al, 0dh
jz outer2
inc edx
loop myloop2
outer2: 
mov message[edx], 0
inc edx
mov message[edx], 0
jmp encrypt

recover:
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset two1, lengthof two1, offset x, 0
invoke GetstdHandle, -10
invoke ReadConsoleA, eax, offset filepath, lengthof filepath, offset x, 0
mov ecx, lengthof filepath
mov edx, 0
myloop3:
mov al, filepath[edx]
cmp al, 0dh
jz outer3
inc edx
loop myloop3
outer3: 
mov filepath[edx], 0
inc edx
mov filepath[edx], 0
jmp decrypt

encrypt:

invoke CreateFileA, offset filepath, 1 ,1,0,3, 128, 0
invoke ReadFile, eax, offset buff, lengthof buff, offset x, 0
mov eax, 0
mov edx, 0
mov ebx, 0
mov edi, 0 
mov esi, 0

checki:
mov cl, buff[edx]
cmp cl, 0ah
jnz ee
	iner: 
	inc bl
	cmp bl, 3
	jnz ee
	inc edx
	jmp mainencrypt
ee:
inc edx
jmp checki

mainencrypt:
mov al, message[esi]
cmp al, 0
jz endencrypt

	l1:
	cmp edi, 8
	jnl eel1
	mov bl, buff[edx]
	shl al, 1
	jc cl1
	jnc cnl1
		cl1: 
		shr bl, 1
		jc el1
		or buff[edx], 00000001b
		jmp el1
			
			cnl1:
			shr bl, 1
			jnc el1
			and buff[edx], 11111110b
			jmp el1

	el1:
	inc edx
	inc edi
	jmp l1

eel1:
mov edi, 0
inc esi
jmp mainencrypt

endencrypt:
mov buff[edx], 00000000b
mov eax, offset buff
invoke CreateFileA, offset filepath1, 2 ,1,0,2, 128, 0
invoke WriteFile, eax, offset buff, lengthof buff, offset x, 0
jmp encryptend

decrypt:

invoke CreateFileA, offset filepath, 1 ,1,0,3, 128, 0
invoke ReadFile, eax, offset buff, lengthof buff, offset x, 0
mov eax, 0
mov edx, 0
mov ebx, 0
mov edi, 0 
mov ecx, 0 
mov esi, 0

checki1:
mov cl, buff[edx]
cmp cl, 0ah
jnz eee
	inner: 
	inc bl
	cmp bl, 3
	jnz eee
	inc edx
	mov ecx, 0
	jmp maindencrypt
eee:
inc edx
jmp checki1

maindencrypt:
mov bl, 00000000b
mov al, 00000000b
mov al, buff[edx]
cmp al, 000000000b
jz enddencrypt
	
	innerdencrypt:
	cmp edi, 8
	jnl endinnerdencrypt
	mov al, buff[edx]
	shr al, 1
	jnc inner1
	jc inner2
		
		inner1:
		shl bl, 1
		jmp eend
			
		inner2:
		shl bl, 1
		or bl, 00000001b
		jmp eend

	eend:
	inc edx
	inc edi
	jmp innerdencrypt

	endinnerdencrypt:
	mov edi, 0
	mov result[ecx], bl
	inc ecx
	jmp maindencrypt

enddencrypt:
jmp eeend

encryptend:
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset one4, lengthof one4, offset x, 0
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset message, lengthof message, offset x, 0
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset one5, lengthof one5, offset x, 0
jmp eeeend

eeend:
invoke GetStdHandle, -11
invoke WriteConsoleA, eax, offset two2, lengthof two2, offset x, 0
invoke GetstdHandle, -11
invoke WriteConsoleA, eax, offset result, lengthof result, offset x, 0

eeeend:

invoke ExitProcess,0
main endp
end main
