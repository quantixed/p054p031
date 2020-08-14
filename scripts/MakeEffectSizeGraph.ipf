#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function MakeEffectSizeGraph()
	WAVE mybcahi, mybcalo, mymeans
	WAVE/T myheaders
	// mybcahi and mybcalo are the absolute positions, need them relative to mean
	MatrixOp/O mybcaErrUp = mybcahi - mymeans
	MatrixOp/O mybcaErrDown = mymeans - mybcalo
	// we will sort the effects - work on a copy
	Duplicate/O mybcahi, mybcahi_s
	Duplicate/O mybcalo, mybcalo_s
	Duplicate/O mymeans, mymeans_s
	Duplicate/O/T myheaders, myheaders_s
	Duplicate/O mybcaErrdown,mybcaErrDown_s
	Duplicate/O mybcaErrUp,mybcaErrUp_s
	Sort/R mymeans_s, mymeans_s, mybcahi_s, mybcalo_s, myheaders_s, mybcaErrDown_s, mybcaErrUp_s
	// the plot just needs the Rab number, so delete string "Rab"
	myheaders_s[] = ReplaceString("Rab",myheaders_s[p],"")
	
	// make plot
	Make/O/N=(numpnts(myheaders)) labelpos=p
	String plotName = "p_effect"
	KillWindow/Z $plotName
	Display/N=$plotName mymeans_s
	ModifyGraph/W=$plotName userticks(bottom)={labelpos,myheaders_s}
	ModifyGraph/W=$plotName tkLblRot(bottom)=90
	SetAxis/A/N=1/W=$plotName left
	ModifyGraph/W=$plotName zero(left)=4
	ModifyGraph/W=$plotName margin(left)=45,margin(right)=21
	ErrorBars/W=$plotName mymeans_s Y,wave=(mybcaErrUp_s,mybcaErrDown_s)
	ModifyGraph/W=$plotName mirror=1
	ModifyGraph/W=$plotName mode=3,marker=19,msize=1.5,mrkThick=0
	SetAxis/W=$plotName bottom -0.5,numpnts(myheaders_s) - 0.5
	Label/W=$plotName left "Difference"
	
	// add to layout
	KillWindow/Z summaryLayout
	NewLayout/N=summaryLayout
	LayoutPageAction/W=summaryLayout size(-1)=(842, 595), margins(-1)=(18, 18, 18, 18)
	ModifyLayout/W=summaryLayout units=0
	AppendLayoutObject/W=summaryLayout graph p_effect
	ModifyLayout/W=summaryLayout left(p_effect)=21,top(p_effect)=21,width(p_effect)=556,height(p_effect)=115
	ModifyLayout/W=summaryLayout frame=0,trans=1
End