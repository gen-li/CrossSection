* --------------
// Prep IBES data
use "$pathDataIntermediate/IBES_EPS_Unadj", replace
keep if fpi == "1" 
keep tickerIBES time_avail_m meanest
save "$pathtemp/temp", replace


// DATA LOAD
use permno tickerIBES time_avail_m using "$pathDataIntermediate/SignalMasterTable", clear
merge m:1 tickerIBES time_avail_m using "$pathtemp/temp", keep(master match) nogenerate 

// SIGNAL CONSTRUCTION
xtset permno time_avail_m
gen DownForecast = (meanest < l.meanest)
replace DownForecast = . if mi(meanest) | mi(l.meanest)
label var DownForecast "Down Forecast EPS"

// SAVE
do "$pathCode/savepredictor" DownForecast
