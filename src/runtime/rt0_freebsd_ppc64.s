#include "textflag.h"

// actually a function descriptor for _main<>(SB)
TEXT _rt0_ppc64_freebsd(SB),NOSPLIT,$0
	DWORD $_main<>(SB)
	DWORD $0
	DWORD $0

TEXT main(SB),NOSPLIT,$0
	DWORD $_main<>(SB)
	DWORD $0
	DWORD $0

TEXT _main<>(SB),NOSPLIT,$-8
	// In a statically linked binary, the stack contains argc,
	// argv as argc string pointers followed by a NULL, envv as a
	// sequence of string pointers followed by a NULL, and auxv.
	// There is no TLS base pointer.
	//
	// TODO(austin): Support ABI v1 dynamic linking entry point
	XOR	R0, R0 // following functions assume R0 is zero
	MOVD	$runtime·rt0_go(SB), R12
	MOVD	R12, CTR
	MOVBZ	runtime·iscgo(SB), R5
	CMP	R5, $0
	BEQ	nocgo
	BR	(CTR)
nocgo:
	BR	(CTR)
