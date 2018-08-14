COMMENT
**********By vetri 22nd June2018*************
In addition to GABAa and GABAb, extra-synaptic GABA receptors are added 
The added one is from exp2syn synapse
Two state kinetic scheme synapse described by rise time tau1,
and decay time constant tau2. The normalized peak condunductance is 1.
Decay time MUST be greater than rise time.

The solution of A->G->bath with rate constants 1/tau1 and 1/tau2 is
 A = a*exp(-t/tau1) and
 G = a*tau2/(tau2-tau1)*(-exp(-t/tau1) + exp(-t/tau2))
	where tau1 < tau2

If tau2-tau1 is very small compared to tau1, this is an alphasynapse with time constant tau2.
If tau1/tau2 is very small, this is single exponential decay with time constant tau2.

The factor is evaluated in the initial block 
such that an event of weight 1 generates a
peak conductance of 1.

Because the solution is a sum of exponentials, the
coupled equations can be solved as a pair of independent equations
by the more efficient cnexp method.

ENDCOMMENT
: inhibitory synapses with both GABAa and GABAb
NEURON {
	POINT_PROCESS inter2pyr
	NONSPECIFIC_CURRENT i_gabab, i_gabaa, i_xtra  
	:i_xtra added by vetri
	RANGE tau1_xtra, tau2_xtra, e_xtra, i_xtra  
	RANGE g_xtra, gbar_gabaa_xtra
	: above two lines added by vetri
	RANGE initW
	RANGE Cdur_gabab, AlphaTmax_gabab, Beta_gabab, Erev_gabab, gbar_gabab, W_gabab, on_gabab, g_gabab, K3_gabab, K4_gabab, n_gabab, Kd_gabab, rr_gabab
	RANGE Cdur_gabaa, AlphaTmax_gabaa, Beta_gabaa, Erev_gabaa, gbar_gabaa, W_gabaa, on_gabaa, g_gabaa
	RANGE ECa, ICa, P0a, P0b, fCa, tauCa, iCatotal
	RANGE Cainf, pooldiam, z
	RANGE lambda1, lambda2, threshold1, threshold2
	RANGE fmax, fmin, Wmax, Wmin, maxChange, normW, scaleW
	RANGE pregid,postgid
	:Added by Ali
	RANGE F, f, tauF, D1, d1, tauD1, D2, d2, tauD2, facfactor
	RANGE aACH, bACH, aDA, bDA, wACH, wDA
   :Added by verti on 13thJuly2018
   
}

UNITS {
	(mV) = (millivolt)
        (nA) = (nanoamp)
	(uS) = (microsiemens)
	FARADAY = 96485 (coul)
	pi = 3.141592 (1)
}

PARAMETER {
	initW = 5

	
	Cdur_gabaa = 5.31 (ms)
	AlphaTmax_gabaa = 5000 (/ms)
	Beta_gabaa = 0.18(/ms) :0.072 
	Erev_gabaa = -75 (mV)
	gbar_gabaa = 1.7e-3 (uS)
	
	Cdur_gabab = 6 (ms)
	AlphaTmax_gabab =  0.09 (/ms mM) :.08
	Beta_gabab = 0.008 (/ms) :0.008 
	Erev_gabab = -75 (mV)
	gbar_gabab = 1e-3 (uS)
	K3_gabab = .18 (/ms) 
	K4_gabab = .034 (/ms) 
	n_gabab = 4
	Kd_gabab = 100

	ECa = 120
	gbar_Ca = 18e-3 (uS)
	
	Cainf = 50e-6 (mM)
	pooldiam =  1.8172 (micrometer)
	z = 2


	tauCa = 50 (ms)
	P0a = .0035  : Had to lower 10 fold becaues for some reason inh synapses generated 10 folds more calcium than exitatory despite simlar levels of NMDA and GABAb.
	P0b = .0015
	fCa = .024

	lambda1 = 2.5
	lambda2 = .01
	threshold1 = 0.2 (uM)
	threshold2 = 0.4 (uM)

	:fmax = 3
	:fmin = .8

	:Added by Ali
		ACH = 1
		
LearningShutDown = 1

		facfactor = 1
	: the (1) is needed for the range limits to be effective
        f = 1 (1) < 0, 1e9 >    : facilitation
        tauF = 1 (ms) < 1e-9, 1e9 >
        d1 = 1 (1) < 0, 1 >     : fast depression
        tauD1 = 1 (ms) < 1e-9, 1e9 >
        d2 = 1 (1) < 0, 1 >     : slow depression
        tauD2 = 1 (ms) < 1e-9, 1e9 >
	
	aACH = 1
	bACH = 0
	wACH = 0
	aDA = 1
	bDA = 0
	wDA = 0
	
:Added by Vetri
  
	tau1_xtra = 0.1 (ms) <1e-9,1e9>
	tau2_xtra = 10 (ms) <1e-9,1e9>
	e_xtra=0	(mV)	
  gbar_gabaa_xtra = 0.0(uS)   
  :13thJuly2018 remeber to recompile mod files!! vetri
}

ASSIGNED {
	v (mV)


	i_gabab (nA)
	g_gabab (uS)
	on_gabab
	W_gabab
	rr_gabab

	i_gabaa (nA)
	g_gabaa (uS)
	on_gabaa
	W_gabaa
	
	t0 (ms)

	ICa (mA)
	Afactor	(mM/ms/nA)
	iCatotal (mA)

	dW_gabaa
	Wmax
	Wmin
	maxChange
	normW
	scaleW
	
	pregid
	postgid
	
		tsyn
	
		fa
		F
		D1
		D2
:Added by vetri
	i_xtra (nA)
	g_xtra (uS)
	factor_xtra		
		
}

STATE { 
	r_gabab 
	s_gabab 
	r_gabaa 
	Capoolcon 
	A (uS) 
	B (uS)}

INITIAL {
  LOCAL tp
	on_gabab = 0
	r_gabab = 0
	s_gabab = 0
	W_gabab = initW

	on_gabaa = 0
	r_gabaa = 0
	W_gabaa = initW

	t0 = -1

	:Wmax = fmax*initW
	:Wmin = fmin*initW
	maxChange = (Wmax-Wmin)/10
	dW_gabaa = 0

	Capoolcon = Cainf
	Afactor	= 1/(z*FARADAY*4/3*pi*(pooldiam/2)^3)*(1e6)
	
	:Added by Ali		printf("Afactor : %g", Afactor)

		tsyn = -1e30

	fa =0
	F = 1
	D1 = 1
	D2 = 1
 
  :Added by vetri
	if (tau1_xtra/tau2_xtra > 0.9999) {
		tau1_xtra = 0.9999*tau2_xtra
	}
	if (tau1_xtra/tau2_xtra < 1e-9) {
		tau1_xtra = tau2_xtra*1e-9
	}
	A = 0
	B = 0
	tp = (tau1_xtra*tau2_xtra)/(tau2_xtra - tau1_xtra) * log(tau2_xtra/tau1_xtra)
	factor_xtra = -exp(-tp/tau1_xtra) + exp(-tp/tau2_xtra)
	factor_xtra = 1/factor_xtra
	
}

BREAKPOINT {
	SOLVE release METHOD cnexp
}

DERIVATIVE release {
	if (t0>0) {
		if (t-t0 < Cdur_gabab) {
			on_gabab = 1
		} else {
			on_gabab = 0
		}
		if (t-t0 < Cdur_gabaa) {
			on_gabaa = 1
		} else {
			on_gabaa = 0
		}
	}
	r_gabab' = AlphaTmax_gabab*on_gabab*(1-r_gabab)-Beta_gabab*r_gabab
	s_gabab' = K3_gabab*r_gabab-K4_gabab*s_gabab
	r_gabaa' = AlphaTmax_gabaa*on_gabaa*(1-r_gabaa)-Beta_gabaa*r_gabaa

	dW_gabaa = eta(Capoolcon)*(lambda1*omega(Capoolcon, threshold1, threshold2)-lambda2*W_gabaa)*dt

	: Limit for extreme large weight changes
	if (fabs(dW_gabaa) > maxChange) {
		if (dW_gabaa < 0) {
			dW_gabaa = -1*maxChange
		} else {
			dW_gabaa = maxChange
		}
	}

	:Normalize the weight change
	normW = (W_gabaa-Wmin)/(Wmax-Wmin)
	if (dW_gabaa < 0) {
		scaleW = sqrt(fabs(normW))
	} else {
		scaleW = sqrt(fabs(1.0-normW))
	}

	W_gabaa = W_gabaa + dW_gabaa*scaleW *(1+ (wACH * (ACH - 1))) * LearningShutDown
	
	:Weight value limits
	if (W_gabaa > Wmax) { 
		W_gabaa = Wmax
	} else if (W_gabaa < Wmin) {
 		W_gabaa = Wmin
	}

	rr_gabab = s_gabab^n_gabab/(s_gabab^n_gabab+Kd_gabab)
	g_gabab = gbar_gabab*rr_gabab * facfactor
	i_gabab = W_gabab*g_gabab*(v - Erev_gabab) 

	g_gabaa = gbar_gabaa*r_gabaa * facfactor
	i_gabaa = W_gabaa*g_gabaa*(v - Erev_gabaa) * (1 + (bACH * (ACH-1)))

	ICa = P0b*g_gabab*(v - ECa) + P0a * gbar_Ca*VDCCm(v) * ( v - ECa) :P0b
 	Capoolcon'= -fCa*Afactor*ICa + (Cainf-Capoolcon)/tauCa 
:Added by vetri	
	A' = -A/tau1_xtra
	B' = -B/tau2_xtra
	g_xtra = gbar_gabaa_xtra*(B - A)
	i_xtra = g_xtra*(v - e_xtra)
	
}

:dummy_weight changed to weight (uS) below -vetri
NET_RECEIVE(weight (uS)) {
	:Added by Ali, Synaptic facilitation
	F  = 1 + (F-1)* exp(-(t - tsyn)/tauF)
	D1 = 1 - (1-D1)*exp(-(t - tsyn)/tauD1)
	D2 = 1 - (1-D2)*exp(-(t - tsyn)/tauD2)
 :printf("%g\t%g\t%g\t%g\t%g\t%g\n", t, t-tsyn, F, D1, D2, facfactor)
	tsyn = t
	
	facfactor = F * D1 * D2

	F = F * f
	D1 = D1 * d1
	D2 = D2 * d2
:printf("\t%g\t%g\t%g\n", F, D1, D2)

	t0 = t :Spike time for conductance openining.
:Added by vetri
	A = A + weight*factor_xtra
	B = B + weight*factor_xtra	
}

:::::::::::: FUNCTIONs and PROCEDUREs ::::::::::::

FUNCTION eta(Cani (mM)) {
	LOCAL taulearn, P1, P2, P4, Cacon
	P1 = 0.1
	P2 = P1*1e-4
	P4 = 1
	Cacon = Cani*1e3
	taulearn = P1/(P2+Cacon*Cacon*Cacon)+P4
	eta = 1/taulearn*0.001
}
FUNCTION VDCCm (v (mV)) {
	UNITSOFF
	VDCCm = 1 / (1 + exp( (-4 - v)/6.3)) : Values taken from Fisher et al. 1990 from the 14pS channel group "Properties and distribution of single voltage..."
	UNITSON
}

FUNCTION omega(Cani (mM), threshold1 (uM), threshold2 (uM)) {
	LOCAL r, mid, Cacon
	Cacon = Cani*1e3
	r = (threshold2-threshold1)/2
	mid = (threshold1+threshold2)/2
	if (Cacon <= threshold1) { omega = 0}
	else if (Cacon >= threshold2) {	omega = 1/(1+50*exp(-50*(Cacon-threshold2)))}
	else {omega = -sqrt(r*r-(Cacon-mid)*(Cacon-mid))}
}
