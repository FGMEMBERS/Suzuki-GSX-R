###############################################################################################
#		Idea from DetlefF. and LesterB.
#		written by Lake of Constance Hangar :: M.Kraus
#		Suzuki GSX-R for Flightgear August 2014
#		This file is licenced under the terms of the GNU General Public Licence V2 or later
############################################################################################### 

var fuel = props.globals.getNode("consumables/fuel/tank/level-m3");
var fuel_lev = 0;
var fuel_weight = props.globals.getNode("consumables/fuel/total-fuel-lbs"); # max 14.9lbs
var running = props.globals.getNode("/engines/engine/running");
var gear = props.globals.getNode("/engines/engine/gear");
var gearsound = props.globals.getNode("/engines/engine/gear-sound");
var fastcircuit = props.globals.getNode("/controls/flight/flaps");
var clutch = props.globals.getNode("/engines/engine/clutch");
var secclutchcontrol = props.globals.getNode("/devices/status/keyboard/ctrl");
var killed = props.globals.getNode("/engines/engine/killed");
var rpm = props.globals.getNode("/engines/engine/rpm");
var propulsion = props.globals.getNode("/engines/engine/propulsion");
var throttle = props.globals.getNode("/controls/flight/throttle-on-elev-axis");
var lastthrottle = 0;
var lastgear = 0;
var lastrpm = 0;
var lastfastcircuit = 0;
var engine_brake = props.globals.getNode("/engines/engine[0]/brake-engine");
var engine_rpm_regulation = props.globals.getNode("/engines/engine[0]/rpm_regulation");
var weight = props.globals.getNode("/sim/weight/weight-lb"); # max. 230 lbs
var inertia = 0;
var vmax = 0;
var looptime = 0.1;
var minrpm = 2200;
var maxrpm = 18500;
var clutchrpm = 0;
var maxhealth = 60; # for the engine killing, higher is longer live while overspeed rpm
var speedlimiter = props.globals.getNode("/instrumentation/Suzuki-GSX-R/speed-indicator/speed-limiter");
var speedlimstate = props.globals.getNode("/instrumentation/Suzuki-GSX-R/speed-indicator/speed-limiter-switch");
var speed = 0;
var gspeed = 0;

###########################################################################

var loop = func {

	# shoulder view helper
	var cv = getprop("/sim/current-view/view-number") or 0;
	var apos = getprop("/devices/status/keyboard/event/key") or 0;
	var press = getprop("/devices/status/keyboard/event/pressed") or 0;
	var du = getprop("/controls/Suzuki-GSX-R/driver-up") or 0;
	#helper turn shoulder to look back
	if(cv == 0 and !du){
		if(apos == 49 and press){
			setprop("/sim/current-view/heading-offset-deg", 160);
			setprop("/controls/Suzuki-GSX-R/driver-looks-back",1);
		}else{
			setprop("/sim/current-view/heading-offset-deg", 0);
			setprop("/controls/Suzuki-GSX-R/driver-looks-back",0);
		}
	}
	
	var comp_m_f = getprop("/gear/gear[0]/compression-m") or 0;
	var comp_m_r = getprop("/gear/gear[1]/compression-m") or 0;
	var brake_ctrl_left = getprop("/controls/gear/brake-left") or 0;
	var brake_ctrl_right = getprop("/controls/gear/brake-right") or 0;
	var brake_park = getprop("/controls/gear/brake-parking") or 0;

	# second possibility for clutch control backspace key is setting in the Suzuki-GSX-R1000-gears-set.xml
	if(secclutchcontrol.getBoolValue()){
		clutch.setValue(1);
	}else{
		clutch.setValue(0);
	}
	
	#gspeed = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") or 0;
	gspeed = getprop("/velocities/groundspeed-kt") or 0;
	
	# drive with gears
	# clutch control
	gearsound.setValue(0);
	if (lastfastcircuit != fastcircuit.getValue()){
			###### fastcircuit without clutch
			if(fastcircuit.getValue() == 0){
				gear.setValue(0);
				gearsound.setValue(1);
			}else if(fastcircuit.getValue() > 0 and fastcircuit.getValue() < 0.11 ){
				gear.setValue(1);
				gearsound.setValue(1);
			}else if(fastcircuit.getValue() > 0.11 and fastcircuit.getValue() < 0.21){
				gear.setValue(2);
				gearsound.setValue(1);
			}else if(fastcircuit.getValue() > 0.21 and fastcircuit.getValue() < 0.31){
				gear.setValue(3);
				gearsound.setValue(1);
			}else if(fastcircuit.getValue() > 0.31 and fastcircuit.getValue() < 0.41){
				gear.setValue(4);
				gearsound.setValue(1);
			}else if(fastcircuit.getValue() > 0.41 and fastcircuit.getValue() < 0.51){
				gear.setValue(5);
				gearsound.setValue(1);
			}else if(fastcircuit.getValue() > 0.51 and fastcircuit.getValue() < 0.61){
				gear.setValue(6);
				gearsound.setValue(1);
			}
	} else if(gear.getValue() != lastgear and clutch.getValue() == 1){
		###### switch up and down with clutch
		gearsound.setValue(1);
	} else { 
		gear.setValue(lastgear);
	}

	lastgear = gear.getValue();

	# ----------- ENGINE IS RUNNING --------------
	if(running.getValue() == 1){

		# calculate the inertia
		#inertia = (fuel_weight.getValue() + weight.getValue())/245; # 245 max. weight and fuel

 		# overgspeed the engine
 		if(rpm.getValue() > (maxrpm - 500)){
 			killed.setValue(killed.getValue() + 1/maxhealth);
 			if(killed.getValue() >= 1)rpm.setValue(40000);
 		}
 		if(killed.getValue() >= 1){
 			running.setValue(0);
 			killed.setValue(1);
 			propulsion.setValue(0);
 			engine_brake.setValue(0.7);
 		}

		# max speed per gear in kts
		if (gear.getValue() == 0) {
			vmax = 0;
			fastcircuit.setValue(0);
		} else if (gear.getValue() == 1) {
			vmax = 50;
			fastcircuit.setValue(0.1);
		} else if (gear.getValue() == 2) {
			vmax =  70;
			fastcircuit.setValue(0.2);
		} else if (gear.getValue() == 3) {
			vmax = 100;
			fastcircuit.setValue(0.3);
		} else if (gear.getValue() == 4) {
			vmax = 130;
			fastcircuit.setValue(0.4);
		} else if (gear.getValue() == 5) {
			vmax = 160;
			fastcircuit.setValue(0.5);
		} else if (gear.getValue() == 6) {
			vmax = 186;
			fastcircuit.setValue(0.6);
		}

		# everthing is ok - let him go
		if (gear.getValue() > 0 and clutch.getValue() == 0) {
			if(fastcircuit.getValue() == 0.1){
			  transmissionpower = throttle.getValue()*2;
			  setprop("/sim/weight[1]/weight-lb", throttle.getValue()*300);
			}else if(fastcircuit.getValue() == 0.2){
			  transmissionpower = 0.9*throttle.getValue()-propulsion.getValue()/maxrpm;
			  setprop("/sim/weight[1]/weight-lb", throttle.getValue()*60);
			}else{
			  transmissionpower = 0.65*throttle.getValue()-propulsion.getValue()/maxrpm;
			  setprop("/sim/weight[1]/weight-lb", 0);
			}
			propulsion.setValue(transmissionpower);
			
			newrpm = (gspeed < 20 and throttle.getValue() > 0.1) ? throttle.getValue()*(maxrpm+2700) : (maxrpm+1500)/vmax*gspeed;
			rpm.setValue(newrpm);
			
			# killing engine with the wrong gear
			if (gear.getValue() > 2 and gspeed < 4) {
						running.setValue(0);
						propulsion.setValue(0);
			}

		} else {
			rpm.setValue(throttle.getValue()*(maxrpm+2000));
			propulsion.setValue(0);
		}
		
		# brake engine feeling at decrease throttle
		speed = getprop("/instrumentation/Suzuki-GSX-R/speed-indicator/speed-meter");
		
		if(rpm.getValue() > 2000 and clutch.getValue() == 1){
			clutchrpm = lastrpm + 1000;
			rpm.setValue(clutchrpm);
		}
		
		if(speed > 5 and lastthrottle > throttle.getValue() and clutch.getValue() == 0 and gear.getValue() > 0){ 
			propulsion.setValue(0);
			engine_brake.setValue(0.6);
		}else if(gspeed > vmax or (speedlimiter.getValue() < speed and speedlimstate.getBoolValue() == 1)){
			propulsion.setValue(0);
			engine_brake.setValue(1);
		}else{
			engine_brake.setValue(0);
		}
		
		# Automatic RPM overspeed regulation
		if(engine_rpm_regulation.getValue() == 1 and rpm.getValue() > maxrpm-500){
			propulsion.setValue(0);
			if (speed > 20) engine_brake.setValue(0.8);
			rpm.setValue(maxrpm-800);
		}
		
		# Anti - slip regulation ASR
		if(comp_m_f < 0.06 or comp_m_r < 0.06 and brake_ctrl_right <= 0.5 and brake_ctrl_left <= 0.5){
			propulsion.setValue(propulsion.getValue() + 0.06);
			setprop("/controls/Suzuki-GSX-R/ASR/ctrl-light", 1);
		}else{
			setprop("/controls/Suzuki-GSX-R/ASR/ctrl-light", 0);
		}

		#help_win.write(sprintf("Propulsion: %.2f", propulsion.getValue()));

	   	 if(rpm.getValue() < minrpm) rpm.setValue(minrpm);  # place after the rpm calculation
	 
	   	 if (fuel.getValue() < 0.0000015) {
	   	  running.setValue(0);
	   	  }
	   	 else {
	   	  fuel_lev = fuel.getValue();
	   	  fuel.setValue(fuel_lev - (0.5*throttle.getValue()+0.3)*0.0000015);  # +0.1 consumption on idle rpm
	   	 }
		 
		 #-------------- ENGINE RUNNING END --------------------
	}else{
	  	if(rpm.getValue() > 2000){
	  		interpolate("/engines/engine/rpm" , 0, 3);
	  	}

		propulsion.setValue(0);

	}#-------------- ENGINE NOT RUNNING END --------------------

	#print(engine_brake.getValue());

	lastthrottle = throttle.getValue();
	lastrpm = rpm.getValue();
	lastfastcircuit = fastcircuit.getValue();
	settimer (loop, 0.125);
}


loop();


