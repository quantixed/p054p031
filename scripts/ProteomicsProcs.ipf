#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3				// Use modern global access method and strict wave access
#pragma DefaultTab={3,20,4}		// Set default tab width in Igor Pro 9 and later

// example BuildBubblePlot("TPD52*;RAB*;ITG*;")

Function BuildBubblePlot(STRING prefixList)
	FindMatches(prefixList)
	LookUpProteinValues(1)
	FinalBubblePrep()
End

Function FindMatches(prefixList)
	String prefixList
	
	Variable nPrefix = ItemsInList(prefixList)
	WAVE/Z/T SHORTNAME
	String prefix, wName
	
	Variable i
	
	for(i = 0; i < nPrefix; i += 1)
		prefix = StringFromList(i,prefixList)
		wName = "temporary_" + num2str(i)
		Extract SHORTNAME, $wName, stringmatch(SHORTNAME, prefix)
		Sort $wName, $wName
	endfor
	
	Concatenate/O/T/KILL/NP=0 WaveList("temporary_*",";",""), sel_SHORTNAME
End

// to change order of proteins or add/remove, edit sel_SHORTNAME and run this
Function LookUpProteinValues(normOpt, [normTo])
	Variable normOpt // 0 is no norm, 1 is norm to max value per column
	String normTo // specify full SHORTNAME of protein to norm to
	
	WAVE/Z/T SHORTNAME, sel_SHORTNAME
	// use original data (no imputation)
	WAVE/Z/T volcanoPrefixWave
	Concatenate/O/FREE/NP=1 WaveList(volcanoPrefixWave[0],";",""), selTemp1
	Concatenate/O/FREE/NP=1 WaveList(volcanoPrefixWave[1],";",""), selTemp2
	if(ParamIsDefault(normTo) && normOpt == 1)
		// normalise to max value
		MatrixOp/O/FREE maxW1 = maxCols(selTemp1)
		MatrixOp/O/FREE maxW2 = maxCols(selTemp2)
		selTemp1[][] /= maxW1[0][q]
		selTemp2[][] /= maxW2[0][q]
	else
		FindValue/TEXT=normTo/TXOP=2 SHORTNAME
		Duplicate/O/FREE/RMD=[V_Value,V_Value][] selTemp1,maxW1
		Duplicate/O/FREE/RMD=[V_Value,V_Value][] selTemp2,maxW2
		selTemp1[][] /= maxW1[0][q]
		selTemp2[][] /= maxW2[0][q]
	endif
	
	Variable nProteins = numpnts(sel_SHORTNAME)
	Make/O/N=(nProteins, DimSize(selTemp1,1)) sel_cond1
	Make/O/N=(nProteins, DimSize(selTemp2,1)) sel_cond2
	String proteinName
	
	Variable i
	
	for(i = 0; i < nProteins; i += 1)
		proteinName = sel_SHORTNAME[i]
		FindValue/TEXT=proteinName/TXOP=2 SHORTNAME
		sel_cond1[i][] = selTemp1[V_Value][q]
		sel_cond2[i][] = selTemp2[V_Value][q]
	endfor
End

// if rows need combining do that and then run this
Function FinalBubblePrep()
	WAVE/Z sel_cond1, sel_cond2
	MakeCircleLoc(sel_cond1)
	Duplicate/O sel_cond1,sel_1dcond1
	Duplicate/O sel_cond2,sel_1dcond2
	Redimension/N=(numpnts(sel_cond1)) sel_1dcond1,sel_1dcond2
	// log conversion because f(z) mrkr size doesn't autolog
	sel_1dcond1[] = log(sel_1dcond1[p])
	sel_1dcond2[] = log(sel_1dcond2[p])
	// get rid of -inf/+inf
	sel_1dcond1[] = (numtype(sel_1dcond1[p]) == 1) ? NaN : sel_1dcond1[p]
	sel_1dcond2[] = (numtype(sel_1dcond2[p]) == 1) ? NaN : sel_1dcond2[p]
	Make/O/N=(DimSize(sel_cond1,1) * 2)/T yLabels = num2str(1 + mod(p,DimSize(sel_cond1,1)))
	Make/O/N=(DimSize(sel_cond1,1) * 2) yPos = p
	Make/O/N=(DimSize(sel_cond1,0)) xPos = p
	
	WAVE/Z xyW1,xyW2
	WAVE/Z/T sel_SHORTNAME
	KillWindow/Z bubble_plot
	Display/N=bubble_plot
	// proteins on y, repeats on x
	AppendToGraph/T/W=bubble_plot xyW1[][0] vs xyW1[][1]
	AppendToGraph/T/W=bubble_plot xyW2[][0] vs xyW2[][1]
	ModifyGraph/W=bubble_plot mode=3,marker=19
	ModifyGraph/W=bubble_plot zmrkSize(xyW1)={sel_1dcond1,-3,0,2,5},zmrkSize(xyW2)={sel_1dcond2,-3,0,2,5}
	ModifyGraph/W=bubble_plot userticks(top)={yPos,yLabels}
	ModifyGraph/W=bubble_plot userticks(left)={xPos,sel_SHORTNAME}
	SetAxis/W=bubble_plot top -0.5, DimSize(sel_cond1,1) * 2 - 0.5
	SetAxis/W=bubble_plot left DimSize(sel_cond1,0),-1
	ModifyGraph/W=bubble_plot standoff=0, mirror=1
	ModifyGraph/W=bubble_plot gfSize=8
	ModifyGraph/W=bubble_plot rgb=(17476,17476,17476)
	
	// make 1-column bubble plot
	MatrixOp/O sel_sumCond1 = sumrows(sel_cond1)
	MatrixOp/O sel_sumCond2 = sumrows(sel_cond2)
	sel_sumCond1[] = (sel_sumCond1[p] == 0) ? NaN : sel_sumCond1[p]
	sel_sumCond2[] = (sel_sumCond2[p] == 0) ? NaN : sel_sumCond2[p]
	sel_sumCond1[] = log(sel_sumCond1[p])
	sel_sumCond2[] = log(sel_sumCond2[p])
	// we need xy waves, called xySW1 and xySW2
	Make/O/N=(DimSize(sel_cond1,0),2) xySw1 = p, xySW2 = p
	xySw1[][1] = 0
	xySw2[][1] = 1
	// top labels need doing
	Make/O/N=(2) ySumPos = p
	WAVE/Z/T VolcanoLabelWave
	
	KillWindow/Z bubble_summary
	Display/N=bubble_summary
	// proteins on y, repeats on x
	AppendToGraph/T/W=bubble_summary xySW1[][0] vs xySW1[][1]
	AppendToGraph/T/W=bubble_summary xySW2[][0] vs xySW2[][1]
	ModifyGraph/W=bubble_summary mode=3,marker=19
	ModifyGraph/W=bubble_summary zmrkSize(xySW1)={sel_sumCond1,-3,0,2,5},zmrkSize(xySW2)={sel_sumCond2,-3,0,2,5}
	ModifyGraph/W=bubble_summary userticks(top)={ySumPos,VolcanoLabelWave}
	ModifyGraph/W=bubble_summary userticks(left)={xPos,sel_SHORTNAME}
	SetAxis/W=bubble_summary top -0.5, 1.5
	SetAxis/W=bubble_summary left DimSize(sel_cond1,0),-1
	ModifyGraph/W=bubble_summary standoff=0, mirror=1
	ModifyGraph/W=bubble_summary gfSize=8
	ModifyGraph/W=bubble_summary rgb=(17476,17476,17476)
End

STATIC Function MakeCircleLoc(w)
	Wave w
	Duplicate/O w, xW, yW
	xW[][] = p
	yW[][] = q
	Redimension/N=(numpnts(w)) xW,yW
	Concatenate/O/NP=1 {xW,yW}, xyW1
	yW += DimSize(w,1)
	Concatenate/O/NP=1/KILL {xW,yW}, xyW2
End